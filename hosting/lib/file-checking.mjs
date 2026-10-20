import records from './resource-integrity.json' with {type:'json'};
import {historicalHash} from './characters.mjs';
export async function checkFiles(args){
 const [session,entries,hash]=args;
 if(!Array.isArray(entries)||entries.length<1||entries.length>200){console.warn('Resource check invalid list',typeof entries,Array.isArray(entries),entries?.length);return false;}
 for(const entry of entries){
  if(!Array.isArray(entry)||entry.length<3||typeof entry[0]!=='string'){console.warn('Resource check invalid entry',typeof entry,Array.isArray(entry),entry?.length,typeof entry?.[0]);return false;}
  let name;try{name=new URL(entry[0]).pathname.slice(1)}catch{console.warn('Resource check invalid URL',String(entry[0]).slice(0,180));return false}
  if(!records[name]?.includes(entry[1])||entry[2]!==entry[1]){console.warn('Resource integrity rejected',name,'total',entry[1],'loaded',entry[2],'expected',records[name]);return false;}
 }
 // Preserve Main.fileCheck's exact string construction, including its repeated second entry.
 const message=Array.from({length:entries.length},()=>String(entries[1])).join('');
 const valid=hash===await historicalHash(session,message);if(!valid)console.warn('Resource check signature rejected','entries',entries.length,'secondEntry',Array.isArray(entries[1])?'array':typeof entries[1],'messageLength',message.length);return valid;
}
