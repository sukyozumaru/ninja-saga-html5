'use strict';
const fs=require('fs'),path=require('path'),http=require('http'),cp=require('child_process');
const root=path.resolve(__dirname,'..');
const source=path.join(root,'sources/shenjai47/NinjaSaga-master');
const runtime=path.join(__dirname,'server');
fs.mkdirSync(runtime,{recursive:true});
for(const name of fs.readdirSync(path.join(source,'server'))){
 if(name.endsWith('.js')) fs.copyFileSync(path.join(source,'server',name),path.join(runtime,name));
}
let code=fs.readFileSync(path.join(runtime,'index.js'),'utf8');
code=code.replace('const PORT = 8080;','const PORT = 8081;');
code=code.replace("const WEB_ROOT = path.resolve(__dirname, '..', 'web');",'const WEB_ROOT = '+JSON.stringify(path.join(source,'web'))+';');
fs.writeFileSync(path.join(runtime,'index.js'),code);
const log=fs.openSync(path.join(__dirname,'gateway.log'),'a');
const child=cp.spawn(process.execPath,[path.join(runtime,'index.js')],{cwd:runtime,stdio:['ignore',log,log],windowsHide:true});
const publicRoot=path.join(__dirname,'public');
const types={'.html':'text/html; charset=utf-8','.js':'application/javascript','.wasm':'application/wasm','.json':'application/json','.swf':'application/x-shockwave-flash'};
const frontend=http.createServer((req,res)=>{
 const url=new URL(req.url,'http://localhost');
 if(url.pathname==='/client-log'&&req.method==='POST'){
  let b=''; req.on('data',c=>{if(b.length<200000)b+=c});req.on('end',()=>{fs.appendFileSync(path.join(__dirname,'client.log'),b+'\n');res.end('ok')});return;
 }
 if(url.pathname==='/health'){res.setHeader('Content-Type','application/json');res.end(JSON.stringify({gateway:!child.killed,pid:child.pid}));return;}
 let file=path.resolve(publicRoot,'.'+(url.pathname==='/'?'/index.html':url.pathname));
 if(file.startsWith(publicRoot+path.sep)&&fs.existsSync(file)&&fs.statSync(file).isFile()){
  res.setHeader('Content-Type',types[path.extname(file)]||'application/octet-stream');res.setHeader('Cache-Control','no-store');fs.createReadStream(file).pipe(res);return;
 }
 const upstream=http.request({host:'127.0.0.1',port:8081,path:req.url,method:req.method,headers:{...req.headers,host:'cdn.ninjasaga.cc'}},r=>{res.writeHead(r.statusCode,r.headers);r.pipe(res)});
 upstream.on('error',()=>{res.statusCode=502;res.end('Gateway iniciando o detenido');});req.pipe(upstream);
});
frontend.on('error',e=>{child.kill();console.error(e.code==='EADDRINUSE'?'El puerto 8080 ya está ocupado. Si Ninja Saga está abierto, visita http://localhost:8080':e.message);process.exit(1)});
frontend.listen(8080,'127.0.0.1',()=>console.log('Ninja Saga local: http://localhost:8080'));
function stop(){child.kill();process.exit()};process.on('SIGINT',stop);process.on('SIGTERM',stop);
