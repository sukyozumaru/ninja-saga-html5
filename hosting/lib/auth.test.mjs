import test from 'node:test';
import assert from 'node:assert/strict';
import {DatabaseSync} from 'node:sqlite';
import {readFileSync,readdirSync} from 'node:fs';
import {dispatch,register,signature,rateLimit,digest} from './auth.mjs';
function database(t){
 const sqlite=new DatabaseSync(':memory:');for(const f of readdirSync(new URL('../drizzle/',import.meta.url)).filter(f=>f.endsWith('.sql')).sort())sqlite.exec(readFileSync(new URL('../drizzle/'+f,import.meta.url),'utf8'));t.after(()=>sqlite.close());
 return {prepare(sql){const statement=sqlite.prepare(sql);let values=[];return {bind(...args){values=args;return this;},first(){return statement.get(...values)||null;},run(){return statement.run(...values);}};},batch(statements){return statements.map(s=>s.run());}};
}
test('historical account signature matches original ClientLibrary fixture',async()=>assert.equal(await signature('0123456789abcdef',7),'9cd5151c51f0'));
test('public account persists a hash, rejects wrong passwords and authenticates AMF',async t=>{
 const db=database(t);await register(db,'TestNinja','test-public-password');
 await assert.rejects(()=>register(db,'testninja','another-password'),/existe/);
 const stored=db.prepare('SELECT * FROM accounts').first();assert.notEqual(stored.password_hash,'test-public-password');
 assert.equal((await dispatch(db,'SystemService.login',['TestNinja','wrong-password','3.3.00810'])).status,'0');
 const response=await dispatch(db,'SystemService.login',['TestNinja','test-public-password','3.3.00810']);
 assert.equal(response.status,'1');assert.deepEqual(response.result.slice(0,3),[1,1,0]);
 const token=response.result[3];assert.equal(db.prepare('SELECT token_hash FROM sessions').first().token_hash,await digest(token));
 assert.deepEqual((await dispatch(db,'CharacterDAO.getCharactersList',[token])).result,[]);
 assert.equal((await dispatch(db,'CharacterService.startMission',[token,'mission_1'])).error,'PUBLIC_NOT_RESTORED:CharacterService.startMission');
 db.prepare('UPDATE sessions SET expires=0').run();assert.equal((await dispatch(db,'CharacterDAO.getCharactersList',[token])).status,'0');
});
test('registration and rate limits reject invalid input and share durable counters',async t=>{
 const db=database(t);await assert.rejects(()=>register(db,'<script>','test-public-password'));
 assert.equal(await rateLimit(db,'test-ip',2),false);assert.equal(await rateLimit(db,'test-ip',2),false);assert.equal(await rateLimit(db,'test-ip',2),true);
 db.prepare('UPDATE attempts SET expires=0').run();assert.equal(await rateLimit(db,'test-ip',2),false);
});
