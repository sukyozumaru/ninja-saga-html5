import fs from 'node:fs';
import path from 'node:path';
import crypto from 'node:crypto';
import {fileURLToPath} from 'node:url';
const root=path.dirname(fileURLToPath(import.meta.url));
function walk(p){return fs.readdirSync(p,{withFileTypes:true}).flatMap(e=>e.isDirectory()?walk(path.join(p,e.name)):[path.join(p,e.name)]);}
const hash=p=>crypto.createHash('sha256').update(fs.readFileSync(p)).digest('hex');
const classes=[],services=[],incomplete=[],imports=new Map(),symbols=[];
for(const file of walk(path.join(root,'as3')).filter(f=>f.endsWith('.as'))){
 const text=fs.readFileSync(file,'utf8'),rel=path.relative(root,file).replaceAll('\\','/');
 const packageName=text.match(/package\s+([\w.]+)/)?.[1]||'';
 const name=text.match(/(?:class|interface)\s+([^\s{]+)/)?.[1]||path.basename(file,'.as');
 const methods=[...text.matchAll(/\bfunction\s+(?:(get|set)\s+)?([^\s(]+)\s*\(/g)].map(m=>({name:m[2],line:text.slice(0,m.index).split('\n').length}));
 classes.push({file:rel,class:packageName?packageName+'.'+name:name,bytes:Buffer.byteLength(text),sha256:hash(file),methods});
 for(const m of text.matchAll(/\.service\(\s*"([^"\n]+)"/g))services.push({service:m[1],file:rel,line:text.slice(0,m.index).split('\n').length});
 for(const m of text.matchAll(/import\s+(flash\.[\w.*]+)\s*;/g))imports.set(m[1],(imports.get(m[1])||0)+1);
 if(/Not decompiled|Decompilation error/.test(text))incomplete.push(rel);
 if(name.includes('§'))symbols.push({file:rel,class:name});
}
const corpus=walk(path.join(root,'corpus')).filter(f=>f.endsWith('.swf')).map(file=>({file:path.relative(root,file).replaceAll('\\','/'),bytes:fs.statSync(file).size,sha256:hash(file)}));
const byLibrary={};for(const c of classes){const key=c.file.split('/')[1];byLibrary[key]=(byLibrary[key]||0)+1;}
const uniqueServices=[...new Set(services.map(s=>s.service))].sort();
const result={generated:'2026-10-18',scope:'historical corpus, decompiled AS3; not a complete native port',tool:'JPEXS FFDec 26.3.0',sourceArchive:'https://archive.org/download/ninja_saga/ns-static-bwhcb6a5289.netdna-ssl.com.7z',folderVersion:'3.3.00810',embeddedBuild:fs.readFileSync(path.join(root,'as3/main/ninjasaga/data/Data.as'),'utf8').match(/BUILD_NO:String\s*=\s*"([^"]+)"/)?.[1],byLibrary,scriptFiles:classes.length,uniqueServices:uniqueServices.length,incompleteExports:incomplete,nonStandardClassNames:symbols,flashImports:[...imports].map(([name,count])=>({name,count})).sort((a,b)=>b.count-a.count),corpus};
fs.writeFileSync(path.join(root,'manifest.json'),JSON.stringify(result,null,2));
fs.writeFileSync(path.join(root,'classes.json'),JSON.stringify(classes,null,2));
fs.writeFileSync(path.join(root,'services.json'),JSON.stringify({limitations:'Only literal .service("...") calls. Dynamic service names and runtime-only calls require further analysis.',unique:uniqueServices,occurrences:services},null,2));
console.log(JSON.stringify({scripts:classes.length,byLibrary,uniqueServices:uniqueServices.length,incompleteExports:incomplete,nonStandardClassNames:symbols.length,embeddedBuild:result.embeddedBuild},null,2));
