import fs from 'node:fs';
import path from 'node:path';
import crypto from 'node:crypto';
import {spawnSync} from 'node:child_process';
import {Readable} from 'node:stream';
import {pipeline} from 'node:stream/promises';
const root=path.resolve(import.meta.dirname,'..');
const lock=JSON.parse(fs.readFileSync(path.join(root,'asset-lock.json')));
let source=process.env.NS_CORPUS_ROOT||(fs.existsSync(path.resolve(root,'../restoration/historical-assets'))?path.resolve(root,'..'):path.resolve(root,'../NinjaSaga'));
function valid(file,record){return fs.existsSync(file)&&fs.statSync(file).size===record.bytes&&crypto.createHash('sha256').update(fs.readFileSync(file)).digest('hex')===record.sha256;}
async function getSource(){
 if(fs.existsSync(path.join(source,'restoration/historical-assets')))return;
 const cache=path.join(root,'.sites-runtime/asset-source');fs.mkdirSync(cache,{recursive:true});
 source=path.join(cache,'ninja-saga-html5-'+lock.commit);
 if(fs.existsSync(path.join(source,'restoration/historical-assets')))return;
 const archive=path.join(cache,'corpus.tar.gz');
 const response=await fetch('https://codeload.github.com/sukyozumaru/ninja-saga-html5/tar.gz/'+lock.commit);if(!response.ok||!response.body)throw new Error('Could not download pinned corpus');
 await pipeline(Readable.fromWeb(response.body),fs.createWriteStream(archive));
 const extraction=spawnSync('tar',['-xzf',archive,'-C',cache],{stdio:'inherit'});if(extraction.status!==0)throw new Error('Corpus extraction failed');
}
for(const record of lock.files){
 const target=path.join(root,'public',record.path);if(valid(target,record))continue;
 await getSource();const original=path.join(source,record.source);if(!valid(original,record))throw new Error('Source hash mismatch: '+record.path);
 fs.mkdirSync(path.dirname(target),{recursive:true});fs.copyFileSync(original,target);
}
console.log(`Verified ${lock.files.length} original assets from ${lock.commit}.`);
