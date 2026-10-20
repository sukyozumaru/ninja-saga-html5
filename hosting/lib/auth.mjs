import {characterService} from './characters.mjs';
import {checkFiles} from './file-checking.mjs';
const encoder=new TextEncoder();
export function randomHex(bytes=24){return Array.from(crypto.getRandomValues(new Uint8Array(bytes)),b=>b.toString(16).padStart(2,'0')).join('');}
export async function digest(text,algorithm='SHA-256'){return Array.from(new Uint8Array(await crypto.subtle.digest(algorithm,encoder.encode(text))),b=>b.toString(16).padStart(2,'0')).join('');}
export async function passwordHash(password,salt){
 const key=await crypto.subtle.importKey('raw',encoder.encode(password),'PBKDF2',false,['deriveBits']);
 const bits=await crypto.subtle.deriveBits({name:'PBKDF2',hash:'SHA-256',salt:encoder.encode(salt),iterations:100000},key,256);
 return Array.from(new Uint8Array(bits),b=>b.toString(16).padStart(2,'0')).join('');
}
export function equal(a,b){if(typeof a!=='string'||typeof b!=='string'||a.length!==b.length)return false;let difference=0;for(let i=0;i<a.length;i++)difference|=a.charCodeAt(i)^b.charCodeAt(i);return difference===0;}
export function validCredentials(username,password){return typeof username==='string'&&/^[A-Za-z0-9_.]{3,32}$/.test(username)&&typeof password==='string'&&password.length>=8&&password.length<=128;}
export async function signature(session,id,type=1,balance=0){return (await digest(`${id}|${type}|${balance}Vmn34aAciYK00Hen26nT01${session}`,'SHA-1')).slice(parseInt(session[1],16),parseInt(session[1],16)+12);}
export async function rateLimit(db,key,maximum=20){
 const now=Date.now();
 const result=await db.prepare('INSERT INTO attempts (key,hits,expires) VALUES (?,1,?) ON CONFLICT(key) DO UPDATE SET hits=CASE WHEN expires<=? THEN 1 ELSE hits+1 END, expires=CASE WHEN expires<=? THEN ? ELSE expires END RETURNING hits').bind(await digest(key),now+60000,now,now,now+60000).first();
 return result.hits>maximum;
}
export async function register(db,username,password){
 if(!validCredentials(username,password))throw new Error('Usa un usuario de 3–32 caracteres y una contraseña de 8–128 caracteres.');
 const salt=randomHex(16), hash=await passwordHash(password,salt);
 try{await db.prepare('INSERT INTO accounts (username,normalized,salt,password_hash,created) VALUES (?,?,?,?,?)').bind(username,username.toLowerCase(),salt,hash,Date.now()).run();}
 catch(e){if(String(e).includes('UNIQUE'))throw new Error('Este usuario ya existe.');throw e;}
}
export async function dispatch(db,service,args){
 const fail=error=>({status:'0',error});
 if(service==='SystemService.login'){
  const [username,password,build]=args;
  if(!['3.3.00810','3.3.00809'].includes(build))return fail('PUBLIC_BUILD_MISMATCH');
  if(!validCredentials(username,password))return fail('PUBLIC_INVALID_CREDENTIALS');
  const account=await db.prepare('SELECT id,salt,password_hash FROM accounts WHERE normalized=?').bind(username.toLowerCase()).first();
  const actual=await passwordHash(password,account?.salt||'invalid-account');
  if(!account||!equal(actual,account.password_hash))return fail('PUBLIC_INVALID_CREDENTIALS');
  const session=randomHex(),tokenHash=await digest(session);
  await db.batch([
   db.prepare('DELETE FROM sessions WHERE account_id=? AND expires<?').bind(account.id,Date.now()),
   db.prepare('INSERT INTO sessions (token_hash,account_id,expires) VALUES (?,?,?)').bind(tokenHash,account.id,Date.now()+12*3600000)
  ]);
  return {status:'1',result:[account.id,1,0,session],signature:await signature(session,account.id),swf_versions:[{type:'data',version:'3.3.00810'}],account_registered_tutored:0,account_registered_password:1};
 }
 const session=args[0];
 if(typeof session!=='string'||!/^[a-f0-9]{48}$/.test(session))return fail('PUBLIC_INVALID_SESSION');
 const sessionHash=await digest(session);
 const account=await db.prepare('SELECT account_id,selected_character_id,pending_skill,fresh_character FROM sessions WHERE token_hash=? AND expires>?').bind(sessionHash,Date.now()).first();
 if(!account)return fail('PUBLIC_INVALID_SESSION');
 if(service==='FileChecking.checkHackActivity')return await checkFiles(args)?{status:'1'}:fail('PUBLIC_RESOURCE_INTEGRITY_MISMATCH');
 const characterResult=await characterService(db,service,args,account,sessionHash);
 if(characterResult){if(characterResult.status==='0')console.warn('Rejected historical service',service,characterResult.error);return characterResult;}
 console.warn('Unrestored historical AMF service',String(service).replace(/[^A-Za-z0-9_.]/g,'').slice(0,100));
 return fail('PUBLIC_NOT_RESTORED:'+service);
}
