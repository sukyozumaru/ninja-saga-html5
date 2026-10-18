import lock from '../asset-lock.json';
const files=new Map(lock.files.map(record=>[record.path,record]));
export async function serveOriginal(request:Request){
 const name=decodeURIComponent(new URL(request.url).pathname).slice(1);
 const record=files.get(name);
 if(!record)return new Response('Missing historical resource: '+name,{status:404});
 const cache=(caches as unknown as {default:Cache}).default;
 const cacheKey=new Request(new URL('/__preserved/'+lock.commit+'/'+name,request.url));
 const existing=cache?await cache.match(cacheKey).catch(()=>undefined):undefined;if(existing)return existing;
 const source='https://raw.githubusercontent.com/sukyozumaru/ninja-saga-html5/'+lock.commit+'/'+record.source.split('/').map(encodeURIComponent).join('/');
 try{
  const upstream=await fetch(source);if(!upstream.ok)return new Response('Original resource temporarily unavailable',{status:503});
  const bytes=await upstream.arrayBuffer();
  if(bytes.byteLength!==record.bytes)return new Response('Historical resource size mismatch',{status:502});
  const hash=Array.from(new Uint8Array(await crypto.subtle.digest('SHA-256',bytes)),b=>b.toString(16).padStart(2,'0')).join('');
  if(hash!==record.sha256)return new Response('Historical resource hash mismatch',{status:502});
  const response=new Response(bytes,{headers:{'Content-Type':name.endsWith('.swf')?'application/x-shockwave-flash':'application/octet-stream','Cache-Control':'public, max-age=31536000, immutable','ETag':'"'+record.sha256+'"','X-Content-Type-Options':'nosniff'}});
  if(cache)await cache.put(cacheKey,response.clone()).catch(()=>{});return response;
 }catch{return new Response('Original resource temporarily unavailable',{status:503});}
}
