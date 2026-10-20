// Intentionally empty by default.
// Add Drizzle tables here when the site actually needs a database.
// See examples/d1/db/schema.ts for an opt-in example.
import {sqliteTable, integer, text, index, primaryKey} from 'drizzle-orm/sqlite-core';
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
  selectedCharacterId:integer('selected_character_id'),
  pendingSkill:text('pending_skill'),
  freshCharacter:integer('fresh_character').notNull().default(0),
},t=>[index('session_expiry').on(t.expires)]);
export const characters=sqliteTable('characters',{
  id:integer('id').primaryKey({autoIncrement:true}),
  accountId:integer('account_id').notNull().references(()=>accounts.id).unique(),
  fingerprint:text('fingerprint').notNull(),
  profile:text('profile').notNull(),
  created:integer('created').notNull(),
});
export const characterStatistics=sqliteTable('character_statistics',{
 characterId:integer('character_id').notNull().references(()=>characters.id),
 service:text('service').notNull(),sequence:text('sequence').notNull(),payload:text('payload').notNull(),processed:integer('processed').notNull().default(0),
},t=>[primaryKey({columns:[t.characterId,t.service,t.sequence]})]);
export const attempts=sqliteTable('attempts',{
  key:text('key').primaryKey(),
  hits:integer('hits').notNull(),
  expires:integer('expires').notNull(),
});
