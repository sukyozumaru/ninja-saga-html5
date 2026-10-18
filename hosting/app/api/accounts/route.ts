import {env} from 'cloudflare:workers';
import {register,rateLimit} from '../../../lib/auth.mjs';
import {readBody} from '../../../lib/read-body';
function result(message:string,status:number){return new Response(`<!doctype html><html lang="es"><meta charset="utf-8"><title>Cuenta de pruebas · Ninja Saga</title><style>body{max-width:600px;margin:12vh auto;background:#171717;color:#eee;font:18px system-ui;padding:24px}a{color:#deb776}</style><h1>Cuenta de pruebas</h1><p>${message}</p><a href="/">Volver al juego</a></html>`,{status,headers:{'Content-Type':'text/html; charset=utf-8','Cache-Control':'no-store'}});}
export async function POST(request:Request){
 if(request.headers.get('Origin')!==new URL(request.url).origin)return result('Solicitud no permitida.',403);
 if(!env.DB)return result('Servicio en preparación.',503);
 if(Number(request.headers.get('Content-Length')||0)>4096)return result('Solicitud demasiado grande.',413);
 let text;try{text=new TextDecoder().decode(await readBody(request,4096));}catch{return result('Solicitud demasiado grande.',413);}
 if(await rateLimit(env.DB,'signup:'+request.headers.get('CF-Connecting-IP'),5))return result('Espera un minuto antes de intentarlo de nuevo.',429);
 const form=new URLSearchParams(text);
 try{await register(env.DB,form.get('username'),form.get('password'));return result('Cuenta creada. Vuelve al juego e inicia sesión en su pantalla original.',201);}
 catch(e){const known=['Este usuario ya existe.','Usa un usuario de 3–32 caracteres y una contraseña de 8–128 caracteres.'];const message=e instanceof Error&&known.includes(e.message)?e.message:'No se pudo crear la cuenta. Inténtalo más tarde.';return result(message,400);}
}
