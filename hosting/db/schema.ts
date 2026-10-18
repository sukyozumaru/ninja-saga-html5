// Intentionally empty by default.
// Add Drizzle tables here when the site actually needs a database.
// See examples/d1/db/schema.ts for an opt-in example.
import {sqliteTable, integer, text, index} from 'drizzle-orm/sqlite-core';
export const accounts=sqliteTable('accounts',{
  id:integer('id').primaryKey({autoIncrement:true}),
  username:text('username').notNull(),
  normalized:text('normalized').notNull().unique(),
  salt:text('salt').notNull(),
  passwordHash:text('password_hash').notNull(),
  created:integer('created').notNull(),
});
export const sessions=sqliteTable('sessions',{
  tokenHash:text('token_hash').primaryKey(),
  accountId:integer('account_id').notNull().references(()=>accounts.id),
  expires:integer('expires').notNull(),
},t=>[index('session_expiry').on(t.expires)]);
export const attempts=sqliteTable('attempts',{
  key:text('key').primaryKey(),
  hits:integer('hits').notNull(),
  expires:integer('expires').notNull(),
});
