'use strict';
const crypto = require('node:crypto');
// Compatibility only: ClientLibrary.getHash/generateHash. This public SWF constant
// is NOT the password hash or an authentication secret of the replacement server.
const COMPAT_SALT = 'Vmn34aAciYK00Hen26nT01';
function accountSignature(session, id, type, balance) {
  const full = crypto.createHash('sha1').update(`${id}|${type}|${balance}${COMPAT_SALT}${session}`).digest('hex');
  return full.substr(parseInt(session[1], 16), 12);
}
function dispatch(accounts, service, args) {
  const fail = error => ({status: '0', error});
  if (service === 'SystemService.login') {
    if (!['3.3.00810', '3.3.00809'].includes(args[2])) return fail('LOCAL_BUILD_MISMATCH');
    const login = accounts.login(args[0], args[1]);
    if (!login) return fail('LOCAL_INVALID_CREDENTIALS');
    const {account, session} = login;
    // Account.setupAccount expects [id, type, tokens, session] and its hash.
    return {status: '1', result: [account.id, 1, 0, session], signature: accountSignature(session, account.id, 1, 0), swf_versions: [{type: 'data', version: '3.3.00810'}], account_registered_tutored: 0, account_registered_password: 1};
  }
  const account = accounts.get(args[0]);
  if (!account) return fail('LOCAL_INVALID_SESSION');
  if (service === 'CharacterDAO.getCharactersList') return {status: '1', result: account.characters, login_per_day: 1};
  // Unreconstructed game contracts must fail explicitly, never return fake success.
  return fail('LOCAL_NOT_RESTORED:' + service);
}
module.exports = {dispatch, accountSignature};
