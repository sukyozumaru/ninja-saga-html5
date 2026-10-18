'use strict';
const fs = require('node:fs');
const path = require('node:path');
const crypto = require('node:crypto');

// Local replacement authentication. Never store the original client's cleartext password.
class Accounts {
  constructor(directory) {
    this.file = path.join(directory, 'accounts.json');
    fs.mkdirSync(directory, {recursive: true});
    this.data = fs.existsSync(this.file) ? JSON.parse(fs.readFileSync(this.file)) : {nextId: 1, accounts: []};
    this.sessions = new Map();
  }
  create(username, password) {
    if (typeof username !== 'string' || !/^[A-Za-z0-9_.]{3,32}$/.test(username) || typeof password !== 'string' || password.length < 8 || password.length > 128) throw new Error('Usuario de 3–32 caracteres y contraseña de 8–128 caracteres.');
    if (this.data.accounts.some(a => a.username.toLowerCase() === username.toLowerCase())) throw new Error('El usuario ya existe.');
    const salt = crypto.randomBytes(16).toString('hex');
    const account = {id: this.data.nextId, username, salt, passwordHash: crypto.scryptSync(password, salt, 64).toString('hex'), characters: []};
    const next = {nextId: this.data.nextId + 1, accounts: [...this.data.accounts, account]};
    fs.writeFileSync(this.file + '.tmp', JSON.stringify(next, null, 2), {mode: 0o600});
    fs.renameSync(this.file + '.tmp', this.file);
    this.data = next;
    return account;
  }
  login(username, password) {
    if (typeof username !== 'string' || typeof password !== 'string' || password.length > 128) return null;
    const account = this.data.accounts.find(a => a.username.toLowerCase() === username.toLowerCase());
    const salt = account?.salt || 'invalid-account';
    const actual = crypto.scryptSync(password, salt, 64);
    if (!account || !crypto.timingSafeEqual(actual, Buffer.from(account.passwordHash, 'hex'))) return null;
    const session = crypto.randomBytes(24).toString('hex');
    this.sessions.set(session, {account, expires: Date.now() + 12 * 60 * 60 * 1000});
    return {account, session};
  }
  get(session) {
    const entry = this.sessions.get(session);
    if (!entry || entry.expires < Date.now()) {this.sessions.delete(session); return null;}
    return entry.account;
  }
}
module.exports = {Accounts};
