'use strict';
const fs=require('node:fs'), path=require('node:path'), crypto=require('node:crypto');
const root=path.resolve(__dirname,'../restoration/historical-assets');
const manifestFile=path.resolve(__dirname,'../restoration/historical-assets.json');
function walk(directory) {
  return fs.readdirSync(directory,{withFileTypes:true}).flatMap(e=>e.isDirectory()?walk(path.join(directory,e.name)):[path.join(directory,e.name)]);
}
function inventory() {
  return walk(root).sort().map(file=>({path:path.relative(root,file).replaceAll('\\','/'),bytes:fs.statSync(file).size,sha256:crypto.createHash('sha256').update(fs.readFileSync(file)).digest('hex')}));
}
if (process.argv.includes('--write')) {
  const files=inventory();
  fs.writeFileSync(manifestFile,JSON.stringify({source:'https://archive.org/download/ninja_saga/ns-static-bwhcb6a5289.netdna-ssl.com.7z',archivePathVersion:'3.3.00810',embeddedBuild:'3.3.00809',note:'Unmodified archive extraction. Uses original client_version parameter; no binary patch. Not a completeness guarantee.',files},null,2)+'\n');
  console.log(`${files.length} archivos; ${files.filter(f=>f.path.endsWith('.swf')).length} SWF; ${files.reduce((n,f)=>n+f.bytes,0)} bytes`);
} else {
  const expected=JSON.parse(fs.readFileSync(manifestFile));
  const actual=inventory();
  if(JSON.stringify(actual)!==JSON.stringify(expected.files)) throw new Error('Historical archive differs from pinned manifest');
  const flat=path.resolve(__dirname,'../restoration/corpus/3.3.00810');
  for(const name of ['ninja_saga','code_library','network_library','client_library','menu']) {
    const relative=name==='ninja_saga'?'ninja_saga.swf':`swf/library/${name}.swf`;
    if(!fs.readFileSync(path.join(flat,name+'.swf')).equals(fs.readFileSync(path.join(root,'swf/3.3.00810',relative)))) throw new Error(`Corpus mismatch: ${name}`);
  }
  console.log(`Verificados ${actual.length} archivos y los cinco módulos del corpus analizado.`);
}
