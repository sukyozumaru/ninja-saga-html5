import {env} from 'cloudflare:workers';
import * as codec from '../../../lib/amf.mjs';
import {Buffer} from 'node:buffer';
import {dispatch,rateLimit} from '../../../lib/auth.mjs';
export async function POST(request:Request){
 const origin=new URL(request.url).origin;
 if(request.headers.get('Origin')&&request.headers.get('Origin')!==origin)return new Response('Forbidden',{status:403});
 if(!env.DB)return new Response('Database unavailable',{status:503});
 try{
  const reader=request.body?.getReader();if(!reader)return new Response('Empty request',{status:400});
  let size=0;const chunks:Uint8Array[]=[];
  while(true){const {done,value}=await reader.read();if(done)break;size+=value.length;if(size>1024*1024){await reader.cancel();return new Response('Request too large',{status:413});}chunks.push(value);}
  const packet=codec.decodePacket(Buffer.concat(chunks));
  if(packet.bodies.length>8)return new Response('Too many calls',{status:400});
  const responses=[];
  for(const b of packet.bodies){
   console.info('Historical AMF',String(b.target).replace(/[^A-Za-z0-9_.]/g,'').slice(0,100));
   const args=Array.isArray(b.data)?b.data:[];
   let data;
   if(b.target==='SystemService.login'&&await rateLimit(env.DB,'login:'+request.headers.get('CF-Connecting-IP')))data={status:'0',error:'PUBLIC_RATE_LIMIT'};
   else data=await dispatch(env.DB,b.target,args);
   responses.push({target:b.response+'/onResult',data});
  }
  return new Response(new Uint8Array(codec.encodePacket(responses,packet.version===3)),{headers:{'Content-Type':'application/x-amf','Cache-Control':'no-store'}});
 }catch{return new Response('Invalid AMF request',{status:400});}
}
