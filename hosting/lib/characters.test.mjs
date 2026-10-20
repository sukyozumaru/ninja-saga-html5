import test from 'node:test';
import assert from 'node:assert/strict';
import {DatabaseSync} from 'node:sqlite';
import {readFileSync,readdirSync,mkdtempSync,unlinkSync,rmdirSync} from 'node:fs';
import {tmpdir} from 'node:os';
import {join} from 'node:path';
import {register,dispatch} from './auth.mjs';
import {historicalHash,validCreation} from './characters.mjs';
import {checkFiles} from './file-checking.mjs';
import integrity from './resource-integrity.json' with {type:'json'};
function facade(sqlite){return {prepare(sql){const s=sqlite.prepare(sql);let a=[];return {bind(...v){a=v;return this},first(){return s.get(...a)||null},run(){return s.run(...a)}}},batch(a){return a.map(s=>s.run())}}}
function migrate(db){for(const f of readdirSync(new URL('../drizzle/',import.meta.url)).filter(f=>f.endsWith('.sql')).sort())db.exec(readFileSync(new URL('../drizzle/'+f,import.meta.url),'utf8'))}
test('persists original post-tutorial character, isolates owners and avoids duplicate grants',async t=>{
 const dir=mkdtempSync(join(tmpdir(),'ninja-persistence-')),file=join(dir,'test.sqlite');let sql=new DatabaseSync(file);migrate(sql);let db=facade(sql);
 t.after(()=>{sql.close();unlinkSync(file);rmdirSync(dir)});
 await register(db,'FirstNinja','test-password-123');await register(db,'OtherNinja','test-password-456');
 const login=async(name,password)=>(await dispatch(db,'SystemService.login',[name,password,'3.3.00810'])).result[3];
 const session=await login('FirstNinja','test-password-123'),other=await login('OtherNinja','test-password-456');
 const createArgs=[session,'OriginalNinja',1,17,11,'10_1','01_1'];
 assert.equal((await dispatch(db,'CharacterService.selectFreeSkill',[session,'skill999'])).status,'0');
 const created=await dispatch(db,'CharacterDAO.createCharacter',createArgs);assert.equal(created.status,'1');assert.ok(created.character_id);
 assert.equal((await dispatch(db,'CharacterDAO.createCharacter',createArgs)).character_id,created.character_id);
 assert.deepEqual((await dispatch(db,'CharacterDAO.getCharactersList',[session])).result,[]);
 assert.equal((await dispatch(db,'CharacterDAO.getCharacterById',[other,created.character_id])).status,'0');
 const system=await dispatch(db,'SystemData.getCreateCharacter',[session,false]);assert.equal(typeof system.server_time,'number');assert.equal(system.result,undefined);
 const calendar=await dispatch(db,'NewDailyRewardStamp2017.getStatus',[session,'en']);assert.equal(calendar.restoration_state,'calendar-unavailable');assert.ok(calendar.claimReward.every(x=>x==='0'));
 assert.equal((await dispatch(db,'NewDailyRewardStamp2017.claimReward',[session,0])).status,'0');
 const extra=await dispatch(db,'CharacterDAO.getExtraData',[session,await historicalHash(session,'0'),'']);assert.equal(extra.status,'1');assert.equal(extra.result.extra_data_hash,await historicalHash(session,',,,1,0,0'));
 const statistics=[session,'0123456789ab',await historicalHash(session,'Achievement.flushCharStat250,1'),{12:250,20:1}];
 assert.equal((await dispatch(db,'Achievement.flushCharStat',statistics)).status,'1');
 assert.equal((await dispatch(db,'Achievement.flushCharStat',statistics)).status,'1');
 const counters=await dispatch(db,'CharacterDAO.getExtraData',[session,await historicalHash(session,'0'),'']);assert.equal(counters.result.char_statistic.GOLD_OBTAINED,250);assert.equal(counters.result.char_statistic.MISSION_COMPLETED,1);
 assert.equal((await dispatch(db,'CharacterService.selectFreeSkill',[session,'skill10'])).status,'1');
 assert.equal((await dispatch(db,'CharacterDAO.createCharacter',[session,'AnotherNinja',1,17,11,'10_1','01_1'])).status,'0');
 assert.equal((await dispatch(db,'CharacterService.selectFreeSkill',[session,'skill9'])).status,'0');
 // Close the database and reopen it: no reliance on process memory.
 sql.close();sql=new DatabaseSync(file);db=facade(sql);
 const next=await login('FirstNinja','test-password-123');
 const list=await dispatch(db,'CharacterDAO.getCharactersList',[next]);assert.deepEqual(list.result,[[created.character_id,'OriginalNinja',1,1]]);
 const loaded=await dispatch(db,'CharacterDAO.getCharacterById',[next,created.character_id]);assert.equal(loaded.status,'1');
 const persistedStats=await dispatch(db,'CharacterDAO.getExtraData',[next,await historicalHash(next,'130'),'']);assert.equal(persistedStats.result.char_statistic.GOLD_OBTAINED,250);
 assert.equal(loaded.result.character_xp,130);assert.equal(loaded.result.character_gold,550);assert.equal(loaded.result.character_item,'1,2,3');assert.equal(loaded.result.character_equipped_skills,'10');assert.equal(loaded.result.character_hair,'10_1');
 assert.notEqual(loaded.result.character_hash,'');assert.equal(loaded.result.expiry_data.expiry_hash,await historicalHash(next,''));
 assert.equal((await dispatch(db,'CharacterDAO.getExtraData',[next,await historicalHash(next,'0'),''])).status,'0');
 assert.equal((await dispatch(db,'CharacterDAO.getExtraData',[next,await historicalHash(next,'130'),''])).status,'1');
 assert.equal((await dispatch(db,'CharacterService.updateCharacter',[next])).status,'0');
});
test('original file checks accept preserved sizes and reject altered resources',async()=>{
 const session='0123456789abcdef',name=Object.keys(integrity)[0],size=integrity[name][0];
 const entries=[['http://static.ninjasaga.com/'+name,size,size,true,10,3,{}]];
 const hash=await historicalHash(session,'undefined');
 assert.equal(await checkFiles([session,entries,hash]),true);
 assert.equal(await checkFiles([session,[[entries[0][0],size+1,size+1]],hash]),false);
 assert.equal(await checkFiles([session,entries,'invalid']),false);
 assert.equal(await checkFiles([session,[['http://static.ninjasaga.com/unrecovered.swf',size,size]],hash]),false);
});
test('creation accepts only original starting appearances and palette indices',()=>{
 assert.equal(validCreation(['s','Ninja',0,17,11,'01_0','01_0']),true);
 for(const a of [['s','',0,17,11,'01_0','01_0'],['s','Ninja',0,16777113,11,'01_0','01_0'],['s','Ninja',1,17,11,'01_0','01_1'],['s','Ninja',1,17,11,'999_1','01_1']])assert.equal(validCreation(a),false);
});
