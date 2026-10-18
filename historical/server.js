'use strict';
const fs = require('node:fs');
const path = require('node:path');
const http = require('node:http');
const {Accounts} = require('./accounts');
const {dispatch} = require('./contracts');
// Only the transport codec is reused. No community gameplay handlers are loaded.
const {decodePacket, encodePacket} = require('../sources/shenjai47/NinjaSaga-master/server/amf');
const root = path.resolve(__dirname, '..');
const archive = path.join(root, 'restoration/historical-assets');
const fallbackArchive = path.join(root, 'sources/internet-archive/ns-static-bwhcb6a5289.netdna-ssl.com');
const assets = fs.existsSync(archive) ? archive : fallbackArchive;
const runtime = path.join(__dirname, 'runtime');
const accounts = new Accounts(runtime);
const types = {'.html':'text/html; charset=utf-8','.js':'text/javascript','.wasm':'application/wasm','.swf':'application/x-shockwave-flash','.png':'image/png','.jpg':'image/jpeg'};
const port = Number(process.env.NS_HISTORICAL_PORT || 8082);
function record(event) {fs.appendFileSync(path.join(runtime, 'requests.jsonl'), JSON.stringify({time:new Date().toISOString(), ...event}) + '\n');}
function reply(res, status, body, type='text/plain; charset=utf-8') {res.writeHead(status, {'Content-Type':type, 'Cache-Control':'no-store'}); res.end(body);}
async function body(req, limit) {
  const chunks = []; let size = 0;
  for await (const chunk of req) {size += chunk.length; if (size > limit) throw new Error('Payload too large'); chunks.push(chunk);}
  return Buffer.concat(chunks);
}
const attempts = new Map();
function rateLimit(req) {
  const key = req.socket.remoteAddress; const now = Date.now();
  const recent = (attempts.get(key) || []).filter(t => now-t < 60000);
  recent.push(now); attempts.set(key,recent); return recent.length > 20;
}
const server = http.createServer(async (req,res) => {
  try {
    // Loopback only; reject DNS rebinding and cross-origin form submissions.
    const origin = `http://${req.headers.host}`;
    if (![ `localhost:${port}`, `127.0.0.1:${port}` ].includes(req.headers.host)) return reply(res,403,'Local host required');
    if (req.headers.origin && req.headers.origin !== origin) return reply(res,403,'Local origin required');
    const url = new URL(req.url,origin);
    if (url.pathname === '/health') return reply(res,200,JSON.stringify({profile:'historical',version:'3.3.00810',assets:fs.existsSync(path.join(assets,'swf/3.3.00810/ninja_saga.swf'))}), 'application/json');
    if (req.method === 'POST' && url.pathname === '/accounts') {
      if (rateLimit(req)) return reply(res,429,'Espera un minuto.');
      const form = new URLSearchParams((await body(req,4096)).toString());
      try {accounts.create(form.get('username'),form.get('password')); reply(res,201,'Cuenta local creada. Vuelve al juego e inicia sesión en su pantalla original.');}
      catch(e) {reply(res,400,e.message);} return;
    }
    if (req.method === 'POST' && url.pathname === '/amf_live1/') {
      const packet = decodePacket(await body(req,1024*1024));
      const responses = packet.bodies.map(b => {
        const args = Array.isArray(b.data) ? b.data : [];
        let data;
        if (b.target === 'SystemService.login' && rateLimit(req)) data = {status:'0',error:'LOCAL_RATE_LIMIT'};
        else data = dispatch(accounts,b.target,args);
        record({service:b.target,status:data.status,error:data.error}); // No password, session, or arguments in logs.
        return {target:b.response + '/onResult',data};
      });
      return reply(res,200,encodePacket(responses,packet.version===3),'application/x-amf');
    }
    if (req.method === 'POST' && url.pathname === '/client-log') {
      const log = (await body(req,65536)).toString();
      // Deliberately omit client traces containing login requests/passwords.
      if (!/password|SystemService\.login|account_session|sessionKey/i.test(log)) fs.appendFileSync(path.join(runtime,'client.log'),log+'\n');
      return reply(res,200,'ok');
    }
    if (req.method !== 'GET' && req.method !== 'HEAD') return reply(res,405,'Method not allowed');
    let pathname = decodeURIComponent(url.pathname);
    // Preserve the original host check without editing the SWF: the archive host
    // appears in loaderURL's local path. All requests still go to loopback.
    const prefix = '/mirror/http://static.ninjasaga.com';
    if (pathname.startsWith(prefix + '/')) pathname = pathname.slice(prefix.length);
    let base, relative;
    if (pathname === '/') {base=path.join(__dirname,'public'); relative='index.html';}
    else if (['/registration.html','/html/forgot_password.html','/swf/3.3.00810/registration.html','/swf/3.3.00810/html/forgot_password.html'].includes(pathname)) {base=path.join(__dirname,'public'); relative='registration.html';}
    else if (pathname.startsWith('/ruffle/')) {base=path.join(root,'local/public/ruffle'); relative=pathname.slice(8);}
    else {base=assets; relative=pathname.slice(1);}
    const file = path.resolve(base,relative);
    if (!file.startsWith(base + path.sep) || !fs.existsSync(file) || !fs.statSync(file).isFile()) {record({missing:pathname}); return reply(res,404,'Missing historical resource: ' + pathname);}
    res.writeHead(200,{'Content-Type':types[path.extname(file)]||'application/octet-stream','Cache-Control':'no-cache'});
    if (req.method==='HEAD') return res.end();
    fs.createReadStream(file).pipe(res);
  } catch(e) {record({error:e.message}); if (!res.headersSent) reply(res,400,'Invalid local request'); else res.end();}
});
server.listen(port,'127.0.0.1',()=>console.log(`Cliente histórico: http://localhost:${port} — cuentas: http://localhost:${port}/registration.html`));
