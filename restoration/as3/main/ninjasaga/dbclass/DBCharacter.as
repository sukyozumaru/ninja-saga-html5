package ninjasaga.dbclass
{
   import flash.net.registerClassAlias;
   import ninjasaga.data.DBCharacterData;
   import ninjasaga.data.Data;
   
   public class DBCharacter
   {
      
      public var character_id:* = 0;
      
      public var account_id:uint = 0;
      
      public var character_name:String = "";
      
      public var character_level:uint = 1;
      
      public var character_xp:uint = 0;
      
      public var character_armor:uint = 0;
      
      public var character_hp:uint = 100;
      
      public var character_max_hp:uint = 100;
      
      public var character_cp:uint = 100;
      
      public var character_max_cp:uint = 100;
      
      public var character_gold:uint = 300;
      
      public var character_rank:uint = 0;
      
      public var character_max_sp:uint = 0;
      
      public var character_sp:uint = 0;
      
      public var character_pet_cp:uint = 0;
      
      public var character_pet_max_cp:uint = 1000;
      
      public var character_pet_ep:uint = 0;
      
      public var character_pet_max_ep:uint = 0;
      
      public var damage_hp:int = 0;
      
      public var damage_cp:int = 0;
      
      public var damage_sp:int = 0;
      
      public var restore_hp:int = 0;
      
      public var restore_cp:int = 0;
      
      public var restore_sp:int = 0;
      
      public var character_skills:Array = new Array();
      
      public var character_skill_talent:Array = new Array();
      
      public var character_skill_unallocated:uint = 0;
      
      public var character_skill_resistance:Array = new Array();
      
      public var character_skill_resistance_unallocated:uint = 0;
      
      public var character_strength:uint = 0;
      
      public var character_speed:uint = 10;
      
      public var character_intelligence:uint = 0;
      
      public var character_stamina:uint = 0;
      
      public var character_chakra:uint = 0;
      
      public var character_body_parts:Object = {};
      
      public var character_hair_color:Array = Data.DEFAULT_HAIR_COLOR;
      
      public var character_gender:uint = 0;
      
      public var character_eye_color:Number = Data.DEFAULT_EYE_COLOR;
      
      public var character_skin_color:Number = Data.DEFAULT_SKIN_COLOR;
      
      public var character_face:String = Data.DEFAULT_FACE + "_" + this.character_gender;
      
      public var character_hair:String = Data.DEFAULT_HAIR + "_" + this.character_gender;
      
      public var character_body_set:String = Data.DEFAULT_BODY_SET;
      
      public var character_equipped_back_item:String = "";
      
      public var character_equipped_weapon:String = Data.DEFAULT_WEAPON;
      
      public var character_trade_item:String = null;
      
      public var character_equipped_trade_body_set:String = null;
      
      public var character_equipped_trade_weapon:String = null;
      
      public var character_equipped_trade_back_item:String = null;
      
      public var session_playtime:int = 100;
      
      public var character_inventory:Object = new Object();
      
      public var character_fire:uint = 0;
      
      public var character_water:uint = 0;
      
      public var character_wind:uint = 0;
      
      public var character_earth:uint = 0;
      
      public var character_lightning:uint = 0;
      
      public var character_taijutsu:uint = 0;
      
      public var character_genjutsu:uint = 0;
      
      public var character_summon:uint = 0;
      
      public var character_control:uint = 0;
      
      public var character_bloodline:String = "";
      
      public var character_hash:* = "";
      
      public var bloodline:Array = [];
      
      public var senjutsu:Array = [];
      
      public var character_senjutsu:Array = [];
      
      public var character_senjutsu_ss:String = "";
      
      public var remove_inv_arr:Array = [];
      
      public var add_inv_arr:Array = [];
      
      public var equip_arr:Array = [];
      
      public var remove_equip_arr:Array = [];
      
      public var current_expiry_arr:Array = [];
      
      public var expired_pet_arr:Array = [];
      
      public var inv_slots_obj:Object = {};
      
      public function DBCharacter()
      {
         super();
      }
      
      public static function register() : void
      {
         registerClassAlias("ninja.Character",DBCharacter);
      }
      
      public static function parseDBCharacter(param1:DBCharacter) : Object
      {
         var _loc2_:Object = new Object();
         _loc2_.character_id = param1.character_id;
         _loc2_.account_id = param1.account_id;
         _loc2_.character_name = param1.character_name;
         _loc2_.character_level = param1.character_level;
         _loc2_.character_xp = param1.character_xp;
         _loc2_.character_armor = param1.character_armor;
         _loc2_.character_hp = param1.character_hp;
         _loc2_.character_max_hp = param1.character_max_hp;
         _loc2_.character_cp = param1.character_cp;
         _loc2_.character_max_cp = param1.character_max_cp;
         _loc2_.character_gold = param1.character_gold;
         _loc2_.character_rank = param1.character_rank;
         _loc2_.character_skills = param1.character_skills;
         _loc2_.character_skill_talent = param1.character_skill_talent;
         _loc2_.character_skill_unallocated = param1.character_skill_unallocated;
         _loc2_.character_skill_resistance = param1.character_skill_resistance;
         _loc2_.character_skill_resistance_unallocated = param1.character_skill_resistance_unallocated;
         _loc2_.character_strength = param1.character_strength;
         _loc2_.character_speed = param1.character_speed;
         _loc2_.character_intelligence = param1.character_intelligence;
         _loc2_.character_stamina = param1.character_stamina;
         _loc2_.character_chakra = param1.character_chakra;
         _loc2_.character_body_parts = param1.character_body_parts;
         _loc2_.character_hair_color = param1.character_hair_color;
         _loc2_.character_gender = param1.character_gender;
         _loc2_.character_eye_color = param1.character_eye_color;
         _loc2_.character_skin_color = param1.character_skin_color;
         _loc2_.character_face = param1.character_face;
         _loc2_.character_hair = param1.character_hair;
         _loc2_.character_equipped_weapon = param1.character_equipped_weapon;
         _loc2_.character_equipped_back_item = param1.character_equipped_back_item;
         _loc2_.character_body_set = param1.character_body_set;
         _loc2_.character_trade_item = param1.character_trade_item;
         _loc2_.character_equipped_trade_body_set = param1.character_equipped_trade_body_set;
         _loc2_.character_equipped_trade_weapon = param1.character_equipped_trade_weapon;
         _loc2_.character_equipped_trade_back_item = param1.character_equipped_trade_back_item;
         _loc2_.character_pet_cp = param1.character_pet_cp;
         _loc2_.character_pet_max_cp = param1.character_pet_max_cp;
         _loc2_.character_pet_ep = param1.character_pet_ep;
         _loc2_.character_pet_max_ep = param1.character_pet_max_ep;
         _loc2_[DBCharacterData.SP] = 0;
         _loc2_[DBCharacterData.MAX_SP] = 1;
         _loc2_[DBCharacterData.DAMAGE_HP] = 0;
         _loc2_[DBCharacterData.DAMAGE_CP] = 0;
         _loc2_[DBCharacterData.DAMAGE_SP] = 0;
         _loc2_[DBCharacterData.RESTORE_HP] = 0;
         _loc2_[DBCharacterData.RESTORE_CP] = 0;
         _loc2_[DBCharacterData.RESTORE_SP] = 0;
         _loc2_[DBCharacterData.FIRE] = param1[DBCharacterData.FIRE];
         _loc2_[DBCharacterData.WATER] = param1[DBCharacterData.WATER];
         _loc2_[DBCharacterData.WIND] = param1[DBCharacterData.WIND];
         _loc2_[DBCharacterData.EARTH] = param1[DBCharacterData.EARTH];
         _loc2_[DBCharacterData.LIGHTNING] = param1[DBCharacterData.LIGHTNING];
         _loc2_[DBCharacterData.TAIJUTSU] = param1[DBCharacterData.TAIJUTSU];
         _loc2_[DBCharacterData.GENJUTSU] = param1[DBCharacterData.GENJUTSU];
         _loc2_[DBCharacterData.SUMMON] = param1[DBCharacterData.SUMMON];
         _loc2_[DBCharacterData.CONTROL] = param1[DBCharacterData.CONTROL];
         _loc2_[DBCharacterData.BLOODLINE] = param1[DBCharacterData.BLOODLINE];
         _loc2_[DBCharacterData.BLOODLINE_SKILL] = param1[DBCharacterData.BLOODLINE_SKILL];
         _loc2_[DBCharacterData.EXPIRY_ITEM_REMOVE_INV_ARR] = param1[DBCharacterData.EXPIRY_ITEM_REMOVE_INV_ARR];
         _loc2_[DBCharacterData.EXPIRY_ITEM_ADD_INV_ARR] = param1[DBCharacterData.EXPIRY_ITEM_ADD_INV_ARR];
         _loc2_[DBCharacterData.EXPIRY_ITEM_EQUIP_ARR] = param1[DBCharacterData.EXPIRY_ITEM_EQUIP_ARR];
         _loc2_[DBCharacterData.EXPIRY_ITEM_REMOVE_EQUIP_ARR] = param1[DBCharacterData.EXPIRY_ITEM_REMOVE_EQUIP_ARR];
         _loc2_[DBCharacterData.EXPIRY_ITEM_CURRENT_EXPIRY_ARR] = param1[DBCharacterData.EXPIRY_ITEM_CURRENT_EXPIRY_ARR];
         _loc2_[DBCharacterData.EXPIRY_ITEM_EXPIRED_PET_ARR] = param1[DBCharacterData.EXPIRY_ITEM_EXPIRED_PET_ARR];
         return _loc2_;
      }
      
      public static function parseObject(param1:Object) : DBCharacter
      {
         var _loc2_:DBCharacter = new DBCharacter();
         _loc2_.character_id = param1.character_id;
         _loc2_.account_id = param1.account_id;
         _loc2_.character_name = param1.character_name;
         _loc2_.character_level = param1.character_level;
         _loc2_.character_xp = param1.character_xp;
         _loc2_.character_armor = param1.character_armor;
         _loc2_.character_hp = param1.character_hp;
         _loc2_.character_max_hp = param1.character_max_hp;
         _loc2_.character_cp = param1.character_cp;
         _loc2_.character_max_cp = param1.character_max_cp;
         _loc2_.character_gold = param1.character_gold;
         _loc2_.character_rank = param1.character_rank;
         _loc2_.character_skills = param1.character_skills;
         _loc2_.character_skill_talent = param1.character_skill_talent;
         _loc2_.character_skill_unallocated = param1.character_skill_unallocated;
         _loc2_.character_skill_resistance = param1.character_skill_resistance;
         _loc2_.character_skill_resistance_unallocated = param1.character_skill_resistance_unallocated;
         _loc2_.character_strength = param1.character_strength;
         _loc2_.character_speed = param1.character_speed;
         _loc2_.character_intelligence = param1.character_intelligence;
         _loc2_.character_stamina = param1.character_stamina;
         _loc2_.character_chakra = param1.character_chakra;
         _loc2_.character_body_parts = param1.character_body_parts;
         _loc2_.character_hair_color = param1.character_hair_color;
         _loc2_.character_gender = param1.character_gender;
         _loc2_.character_eye_color = param1.character_eye_color;
         _loc2_.character_skin_color = param1.character_skin_color;
         _loc2_.character_face = param1.character_face;
         _loc2_.character_hair = param1.character_hair;
         _loc2_.character_equipped_back_item = param1.character_equipped_back_item;
         _loc2_.character_equipped_weapon = param1.character_equipped_weapon;
         _loc2_.character_body_set = param1.character_body_set;
         _loc2_.character_trade_item = param1.character_trade_item;
         _loc2_.character_equipped_trade_body_set = param1.character_equipped_trade_body_set;
         _loc2_.character_equipped_trade_weapon = param1.character_equipped_trade_weapon;
         _loc2_.character_equipped_trade_back_item = param1.character_equipped_trade_back_item;
         _loc2_.character_pet_cp = param1.character_pet_cp;
         _loc2_.character_pet_max_cp = param1.character_pet_max_cp;
         _loc2_.character_pet_ep = param1.character_pet_ep;
         _loc2_.character_pet_max_ep = param1.character_pet_max_ep;
         _loc2_[DBCharacterData.SP] = 0;
         _loc2_[DBCharacterData.MAX_SP] = 1;
         _loc2_[DBCharacterData.DAMAGE_HP] = 0;
         _loc2_[DBCharacterData.DAMAGE_CP] = 0;
         _loc2_[DBCharacterData.DAMAGE_SP] = 0;
         _loc2_[DBCharacterData.RESTORE_HP] = 0;
         _loc2_[DBCharacterData.RESTORE_CP] = 0;
         _loc2_[DBCharacterData.RESTORE_SP] = 0;
         _loc2_[DBCharacterData.FIRE] = param1[DBCharacterData.FIRE];
         _loc2_[DBCharacterData.WATER] = param1[DBCharacterData.WATER];
         _loc2_[DBCharacterData.WIND] = param1[DBCharacterData.WIND];
         _loc2_[DBCharacterData.EARTH] = param1[DBCharacterData.EARTH];
         _loc2_[DBCharacterData.LIGHTNING] = param1[DBCharacterData.LIGHTNING];
         _loc2_[DBCharacterData.TAIJUTSU] = param1[DBCharacterData.TAIJUTSU];
         _loc2_[DBCharacterData.GENJUTSU] = param1[DBCharacterData.GENJUTSU];
         _loc2_[DBCharacterData.SUMMON] = param1[DBCharacterData.SUMMON];
         _loc2_[DBCharacterData.CONTROL] = param1[DBCharacterData.CONTROL];
         _loc2_[DBCharacterData.BLOODLINE] = param1[DBCharacterData.BLOODLINE];
         _loc2_[DBCharacterData.BLOODLINE_SKILL] = param1[DBCharacterData.BLOODLINE_SKILL];
         _loc2_[DBCharacterData.EXPIRY_ITEM_REMOVE_INV_ARR] = param1[DBCharacterData.EXPIRY_ITEM_REMOVE_INV_ARR];
         _loc2_[DBCharacterData.EXPIRY_ITEM_ADD_INV_ARR] = param1[DBCharacterData.EXPIRY_ITEM_ADD_INV_ARR];
         _loc2_[DBCharacterData.EXPIRY_ITEM_EQUIP_ARR] = param1[DBCharacterData.EXPIRY_ITEM_EQUIP_ARR];
         _loc2_[DBCharacterData.EXPIRY_ITEM_REMOVE_EQUIP_ARR] = param1[DBCharacterData.EXPIRY_ITEM_REMOVE_EQUIP_ARR];
         _loc2_[DBCharacterData.EXPIRY_ITEM_CURRENT_EXPIRY_ARR] = param1[DBCharacterData.EXPIRY_ITEM_CURRENT_EXPIRY_ARR];
         _loc2_[DBCharacterData.EXPIRY_ITEM_EXPIRED_PET_ARR] = param1[DBCharacterData.EXPIRY_ITEM_EXPIRED_PET_ARR];
         return _loc2_;
      }
   }
}

