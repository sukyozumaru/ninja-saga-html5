// Protocol reconstructed from the preserved AS3; see restoration/CONTRATO-PERSISTENCIA.md.
const secret='Vmn34aAciYK00Hen26nT01';
export async function historicalHash(session,text){
 const bytes=await crypto.subtle.digest('SHA-1',new TextEncoder().encode(String(text)+secret+session));
 return Array.from(new Uint8Array(bytes),b=>b.toString(16).padStart(2,'0')).join('').slice(parseInt(session[1],16),parseInt(session[1],16)+12);
}
export const starterSkills=['skill1','skill9','skill10','skill12','skill13']; // Mission_01.selectSkill
const hairChoices=[['01','03','04','05','11','12','13','14','17','19'],['01','02','03','04','05','10','12','13','14','17']];
const hairColors=[17,5,19,4,14,1,9,0],skinColors=[11,13,15,16,14,17,18,19];
export function validCreation(args){
 const [,name,gender,hairColor,skinColor,hair,face]=args;
 return args.length===7&&typeof name==='string'&&name.trim().length>0&&name.length<=100&&!/[\u0000-\u001f<>]/.test(name)&&
  [0,1].includes(gender)&&hairColors.includes(hairColor)&&skinColors.includes(skinColor)&&
  typeof hair==='string'&&hairChoices[gender].some(n=>hair===n+'_'+gender)&&face==='01_'+gender;
}
export function initialProfile(args,skill,now=Date.now()){
 const [,name,gender,hairColor,skinColor,hair,face]=args;
 // DBCharacter defaults + MissionDetail.msn0 reward, once, at post-battle creation.
 return {character_name:name,character_level:1,character_xp:skill?130:0,character_rank:0,character_gold:skill?550:300,character_armor:0,
  character_equipped_skills:skill.replace('skill',''),character_equipped_weapon:'1',character_equipped_body_set:'1',
  character_body_set:'1',character_item:skill?'1,2,3':'',character_weapon:'1',character_skill:skill.replace('skill',''),
  character_magatama:'',character_npc:'',character_equipped_back_item:'',character_back_item:'',character_equipped_accessory:'',character_accessory:'',
  character_hair_color:hairColor,character_gender:gender,character_skin_color:skinColor,character_face:face,character_hair:hair,
  character_fire:0,character_water:0,character_wind:0,character_earth:0,character_lightning:0,character_taijutsu:0,character_genjutsu:0,character_summon:0,character_control:0,
  character_bloodline:'',character_mission:skill?'0:1:0:'+Math.floor(now/1000):'',character_ninja_essence:'',character_material:'',character_inv_hair:hair,
  character_trade_item:'',character_equipped_trade_weapon:'',character_equipped_trade_back_item:'',character_equipped_trade_body_set:'',character_common_currency:'',
  character_inv_slots:{weapon:0,body_set:0,item:0,essence:0,material:0,back:0,pet:0},bloodline:[],senjutsu:[],senjutsu_spirit:0};
}
const hashFields=['character_id','character_level','character_xp','character_rank','character_gold','character_armor','character_equipped_skills','character_equipped_weapon','character_equipped_body_set','character_body_set','character_item','character_weapon','character_skill','character_magatama','character_npc','character_equipped_back_item','character_back_item','character_equipped_accessory','character_accessory','character_hair_color','character_gender','character_skin_color','character_face','character_hair','character_fire','character_water','character_wind','character_earth','character_lightning','character_taijutsu','character_genjutsu','character_summon','character_control','character_bloodline','character_mission','character_ninja_essence','character_material','character_inv_hair'];
export async function rawCharacter(row,session){
 const p={...JSON.parse(row.profile),character_id:row.id};
 p.character_hash=await historicalHash(session,hashFields.map(k=>String(p[k])).join(''));
 p.character_pre_hash=await historicalHash(session,['character_level','character_xp','character_rank','character_equipped_skills','character_fire','character_water','character_earth','character_lightning'].map(k=>String(p[k])).join(','));
 p.expiry_data={remove_inv_arr:[],add_inv_arr:[],equip_arr:[],current_expiry_arr:[],remove_equip_arr:[],expiry_pet_data:[],expiry_hash:await historicalHash(session,'')};
 return p;
}
export function systemData(){const now=new Date();return {server_time:Math.floor(now.getTime()/1000),current_date:Number(now.toISOString().slice(0,10).replaceAll('-','')),news:''};}
export async function extraData(row,session){
 const created=new Date(row.created).toISOString().slice(0,19).replace('T',' ');
 const profile=JSON.parse(row.profile);
 return {player_pet:[],bloodline:[],senjutsu:[],consecutive_days:1,is_fan:false,roulette_allowed:false,
  char_login_per_day:1,character_create_date:created,date:new Date().toISOString().slice(0,19).replace('T',' '),
  achievement:[],recent_achievement:[],achievement_point:0,bp_mission_id:[],invite_accepted:0,veteran_return_fk_accepted:0,totalToken:0,MCoin:0,totalMCoin:0,
  map_key:'11',file_1:[],file_2:[],file_3:[],sum_1:[],sum_2:[],sum_3:[],
  statistic_battle:profile.statistic_battle||{},char_statistic:profile.char_statistic||{},
  extra_data_hash:await historicalHash(session,',,,1,0,0')};
}
const statNames=['','BATTLE','USE_WEAPON','USE_SKILL','DODGE','CRITICAL','HIGHEST_DAMAGE','ENEMY_KILLED','DEATH','RUN','LIVE_BATTLE','LIVE_BATTLE_WIN','GOLD_OBTAINED','FRIEND_VISITED','CHALLENGE_DONE','FRIEND_RECRUITED','GIFT_SHARED','WEAPON_BOUGHT','CLOTHING_BOUGHT','WEAPON_FORGED','MISSION_COMPLETED','SPECIAL_MISSION_COMPLETED','DAILY_MISSION_COMPLETED','MISSION_FAILED','SKILL_TRAINED','NINJA_EMBLEM','KINJUTSU_TRAINED','WALLFEED_POSTED','WALLFEED_CLAIMED','FRIEND_INVITED','DAYS_PLAYED','SPECIFIC_MISSION_COMPLETED'];
async function saveStatistics(db,service,args,context){
 const fail=error=>({status:'0',error}),[session,sequence,hash,stats]=args;
 if(!context.selected_character_id)return fail('PUBLIC_CHARACTER_NOT_SELECTED');
 if(!/^[0-9a-f]{12}$/.test(sequence)||!stats||typeof stats!=='object')return fail('PUBLIC_INVALID_STATISTICS');
 const keys=stats[Symbol.for('amf.propertyOrder')]||Object.keys(stats);
 if(keys.length>31||keys.some(k=>!/^\d+$/.test(k)||!statNames[Number(k)]||!Number.isInteger(stats[k])||stats[k]<0||stats[k]>1000000))return fail('PUBLIC_INVALID_STATISTICS');
 if(hash!==await historicalHash(session,service+keys.map(k=>stats[k]).join(',')))return fail('PUBLIC_STATISTICS_HASH_MISMATCH');
 const column=service==='Achievement.flushBattleStat'?'statistic_battle':'char_statistic';
 const changes=keys.filter(k=>stats[k]!==0);const binds=[];
 const sets=changes.map(k=>{const p='$."'+column+'"."'+statNames[Number(k)]+'"';binds.push(p,p,stats[k]);return '?,coalesce(json_extract(profile,?),0)+?'}).join(',');
 const payload=JSON.stringify(stats),key=[context.selected_character_id,service,sequence];
 const existing=await db.prepare('SELECT payload FROM character_statistics WHERE character_id=? AND service=? AND sequence=?').bind(...key).first();
 if(existing&&existing.payload!==payload)return fail('PUBLIC_STATISTICS_REPLAY_MISMATCH');
 const statements=[db.prepare('INSERT INTO character_statistics(character_id,service,sequence,payload) VALUES(?,?,?,?) ON CONFLICT DO NOTHING').bind(...key,payload)];
 if(sets)statements.push(db.prepare('UPDATE characters SET profile=json_set(profile,'+sets+') WHERE id=? AND account_id=? AND EXISTS(SELECT 1 FROM character_statistics WHERE character_id=? AND service=? AND sequence=? AND processed=0)').bind(...binds,context.selected_character_id,context.account_id,...key));
 statements.push(db.prepare('UPDATE character_statistics SET processed=1 WHERE character_id=? AND service=? AND sequence=?').bind(...key));
 await db.batch(statements);return {status:'1'};
}
export async function characterService(db,service,args,context,sessionHash){
 const fail=error=>({status:'0',error}),session=args[0];
 if(['Achievement.flushBattleStat','Achievement.flushCharStat'].includes(service))return saveStatistics(db,service,args,context);
 if(service==='NewDailyRewardStamp2017.claimReward')return fail('PUBLIC_DAILY_CALENDAR_UNAVAILABLE');
 if(service==='NewDailyRewardStamp2017.getStatus'){
  if(!context.selected_character_id)return fail('PUBLIC_CHARACTER_NOT_SELECTED');
  // Real inactive-campaign state. No historical calendar has been recovered; no rewards can be claimed.
  return {status:'1',restoration_state:'calendar-unavailable',loginDay:Array(31).fill('-'),rewardDay:Array(6).fill('—'),item_list:Array.from({length:6},()=>['gold_0']),claimReward:Array(6).fill('0'),txt:{desc1:'Daily rewards pending',desc2:'No active reward calendar is configured.',desc3:'No rewards are available to claim.'},now_time:Math.floor(Date.now()/1000),part2:false};
 }
 if(service==='CharacterDAO.getCharactersList'){
  const row=await db.prepare('SELECT id,profile FROM characters WHERE account_id=?').bind(context.account_id).first();
  const p=row?JSON.parse(row.profile):null;
  return {status:'1',result:row&&p.character_equipped_skills?[[row.id,p.character_name,p.character_level,p.character_gender]]:[],login_per_day:1};
 }
 if(service==='CharacterService.selectFreeSkill'){
  if(!starterSkills.includes(args[1]))return fail('PUBLIC_INVALID_STARTER_SKILL');
  const row=await db.prepare('SELECT * FROM characters WHERE account_id=?').bind(context.account_id).first();
  if(row){
   const p=JSON.parse(row.profile),chosen=args[1].replace('skill','');
   if(p.character_equipped_skills&&p.character_equipped_skills!==chosen)return fail('PUBLIC_STARTER_ALREADY_SELECTED');
   if(!p.character_equipped_skills&&context.selected_character_id===row.id){
    const completed={...p,...initialProfile([session,...JSON.parse(row.fingerprint)],args[1],row.created)};
    await db.prepare("UPDATE characters SET profile=? WHERE id=? AND json_extract(profile,'$.character_equipped_skills')='' ").bind(JSON.stringify(completed),row.id).run();
    const saved=await db.prepare('SELECT profile FROM characters WHERE id=?').bind(row.id).first();
    if(JSON.parse(saved.profile).character_equipped_skills!==chosen)return fail('PUBLIC_STARTER_ALREADY_SELECTED');
   }
  }
  await db.prepare('UPDATE sessions SET pending_skill=?,fresh_character=0 WHERE token_hash=?').bind(args[1],sessionHash).run();
  return {status:'1'};
 }
 if(service==='CharacterDAO.createCharacter'){
  if(!validCreation(args))return fail('PUBLIC_INVALID_CHARACTER');
  const fingerprint=JSON.stringify(args.slice(1));
  await db.prepare('INSERT INTO characters(account_id,fingerprint,profile,created) VALUES(?,?,?,?) ON CONFLICT(account_id) DO NOTHING').bind(context.account_id,fingerprint,JSON.stringify(initialProfile(args,'')),Date.now()).run();
  // An interrupted callback has no confirmed skill/reward yet; retry through the original editor.
  await db.prepare("UPDATE characters SET fingerprint=?,profile=? WHERE account_id=? AND json_extract(profile,'$.character_equipped_skills')='' AND fingerprint<>?").bind(fingerprint,JSON.stringify(initialProfile(args,'')),context.account_id,fingerprint).run();
  const row=await db.prepare('SELECT id,fingerprint,profile FROM characters WHERE account_id=?').bind(context.account_id).first();
  if(row.fingerprint!==fingerprint)return fail('PUBLIC_FREE_CHARACTER_SLOT_FULL');
  await db.prepare('UPDATE sessions SET selected_character_id=?,fresh_character=? WHERE token_hash=?').bind(row.id,JSON.parse(row.profile).character_xp===0?1:0,sessionHash).run();
  return {status:'1',character_id:row.id};
 }
 if(service==='CharacterDAO.getCharacterById'){
  if(!Number.isSafeInteger(Number(args[1]))||Number(args[1])<1)return fail('PUBLIC_INVALID_CHARACTER');
  const row=await db.prepare('SELECT * FROM characters WHERE id=? AND account_id=?').bind(Number(args[1]),context.account_id).first();
  if(!row)return fail('PUBLIC_CHARACTER_NOT_FOUND');
  if(!JSON.parse(row.profile).character_equipped_skills)return fail('PUBLIC_CHARACTER_INITIALIZING');
  await db.prepare('UPDATE sessions SET selected_character_id=?,fresh_character=0 WHERE token_hash=?').bind(row.id,sessionHash).run();
  return {status:'1',result:await rawCharacter(row,session)};
 }
 if(['SystemData.get','SystemData.getCreateCharacter','CharacterDAO.getExtraData'].includes(service)){
  const row=await db.prepare('SELECT * FROM characters WHERE id=? AND account_id=?').bind(context.selected_character_id,context.account_id).first();
  if(!row)return fail('PUBLIC_CHARACTER_NOT_SELECTED');
  if(service==='SystemData.getCreateCharacter')return {status:'1',...systemData()};
  if(service==='SystemData.get')return {status:'1',result:systemData()};
  const expected=await historicalHash(session,String(JSON.parse(row.profile).character_xp));
  // During the creation callback the unchanged client has not yet applied msn0's XP.
  const initial=!!context.fresh_character&&args[1]===await historicalHash(session,'0');
  if(args[1]!==expected&&!initial)return fail('PUBLIC_XP_HASH_MISMATCH');
  return {status:'1',result:await extraData(row,session)};
 }
 return null;
}
