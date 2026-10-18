'use strict';
const test = require('node:test');
const assert = require('node:assert/strict');
const fs = require('node:fs');
const os = require('node:os');
const path = require('node:path');
const {Accounts} = require('./accounts');
const {dispatch, accountSignature} = require('./contracts');
function fixture(t) {
  const directory = fs.mkdtempSync(path.join(os.tmpdir(),'ns-auth-test-'));
  t.after(()=>fs.rmSync(directory,{recursive:true,force:true}));
  const accounts = new Accounts(directory);
  accounts.create('TestNinja','test-only-password');
  return {accounts,directory};
}
test('original Account.setupAccount / ClientLibrary hash fixture',()=> {
  assert.equal(accountSignature('0123456789abcdef',7,1,0),'9cd5151c51f0');
});
test('password survives restart as a salted hash; wrong password cannot get a session',t=> {
  const {accounts,directory}=fixture(t);
  assert.equal(accounts.login('TestNinja','wrong'),null);
  assert.equal(accounts.login('Nobody','test-only-password'),null);
  assert.ok(!fs.readFileSync(path.join(directory,'accounts.json'),'utf8').includes('test-only-password'));
  assert.ok(new Accounts(directory).login('testninja','test-only-password'));
  accounts.create('SecondNinja','second-test-password');
  const restored = new Accounts(directory);
  assert.ok(restored.login('SecondNinja','second-test-password'));
  assert.ok(restored.login('TestNinja','test-only-password'));
  assert.throws(()=>accounts.create('testninja','another-password'));
  assert.throws(()=>accounts.create(null,'another-password'));
});
test('historical login signs a free account and only its own character list',t=> {
  const {accounts}=fixture(t);
  const response=dispatch(accounts,'SystemService.login',['TestNinja','test-only-password','3.3.00810']);
  assert.equal(response.status,'1');
  assert.deepEqual(response.result.slice(0,3),[1,1,0]);
  const session=response.result[3];
  assert.deepEqual(dispatch(accounts,'CharacterDAO.getCharactersList',[session]).result,[]);
  assert.equal(dispatch(accounts,'CharacterDAO.getCharactersList',['invalid']).status,'0');
  assert.equal(response.signature,accountSignature(session,1,1,0));
});
test('expired sessions and mismatched builds cannot authenticate',t=> {
  const {accounts}=fixture(t);
  assert.equal(dispatch(accounts,'SystemService.login',['TestNinja','test-only-password','latest']).status,'0');
  const {session}=accounts.login('TestNinja','test-only-password');
  accounts.sessions.get(session).expires=Date.now()-1;
  assert.equal(accounts.get(session),null);
});
test('unreconstructed gameplay never returns a success stub',t=> {
  const {accounts}=fixture(t);
  const {session}=accounts.login('TestNinja','test-only-password');
  assert.deepEqual(dispatch(accounts,'CharacterService.startMission',[session,'mission_1']),{status:'0',error:'LOCAL_NOT_RESTORED:CharacterService.startMission'});
});
