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
// Keep the initial client and Ruffle local to the deployment. Other historical
// resources are fetched by the immutable, hash-verifying asset routes.
const initial=new Set(['ninja_saga.swf','code_library.swf','network_library.swf','client_library.swf','popup.swf','menu.swf','en.swf','data_library_en.swf']);
const bundled=lock.files.filter(record=>record.path.startsWith('ruffle/')||initial.has(path.basename(record.path)));
for(const record of bundled){
 const target=path.join(root,'public',record.path);if(valid(target,record))continue;
 await getSource();const original=path.join(source,record.source);if(!valid(original,record))throw new Error('Source hash mismatch: '+record.path);
 fs.mkdirSync(path.dirname(target),{recursive:true});fs.copyFileSync(original,target);
}
console.log(`Verified ${bundled.length} bundled assets; ${lock.files.length} pinned assets available through verified routes.`);
// Explicitly reconstructed exception, authorized by the user; never part of the original lock.
const reconstructed='swf/3.3.00810/swf/items/hair_10_1.swf';
const target=path.join(root,'public',reconstructed);
fs.mkdirSync(path.dirname(target),{recursive:true});
fs.copyFileSync(path.join(root,'restoration-assets/hair_10_1.swf'),target);
fs.copyFileSync(path.join(root,'restoration-assets/library.swf'),path.join(root,'public/swf/3.3.00810/swf/library/library.swf'));
