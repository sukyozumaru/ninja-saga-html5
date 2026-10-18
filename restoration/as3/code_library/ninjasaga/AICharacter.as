package ninjasaga
{
   import com.utils.NumberUtil;
   import com.utils.Out;
   import ninjasaga.data.BattleData;
   import ninjasaga.data.BloodlineData;
   import ninjasaga.data.DBCharacterData;
   import ninjasaga.data.Data;
   import ninjasaga.data.InventoryData;
   import ninjasaga.data.SenjutsuData;
   import ninjasaga.data.SkillData;
   import ninjasaga.dbclass.DBCharacter;
   
   public class AICharacter extends Character
   {
      
      public var friendly:Boolean = false;
      
      public function AICharacter(param1:DBCharacter)
      {
         super(param1);
         this.type = 2;
      }
      
      override public function skillCheck() : void
      {
         var _loc2_:int = 0;
         var _loc3_:Object = null;
         while(this.hasItem(InventoryData.TYPE_SKILL,"skill91"))
         {
            this.removeInventory(InventoryData.TYPE_SKILL,"skill91");
         }
         var _loc1_:Array = this.getSkillListArr();
         if(_loc1_.indexOf("skill91") >= 0)
         {
            this.dbChar.character_skills = [];
         }
         else
         {
            _loc2_ = 0;
            while(_loc2_ < _loc1_.length)
            {
               _loc3_ = Main.SKILL_DATA[_loc1_[_loc2_]];
               if(!_loc3_)
               {
                  this.dbChar.character_skills = [];
                  break;
               }
               _loc2_++;
            }
         }
      }
      
      public function aiAction() : void
      {
         var _loc1_:Number = NaN;
         var _loc7_:String = null;
         var _loc14_:uint = 0;
         var _loc15_:Array = null;
         var _loc16_:Object = null;
         var _loc17_:Object = null;
         var _loc18_:uint = 0;
         var _loc19_:Object = null;
         var _loc20_:Object = null;
         var _loc21_:int = 0;
         var _loc22_:Boolean = false;
         var _loc23_:Boolean = false;
         var _loc24_:Boolean = false;
         var _loc25_:Object = null;
         var _loc26_:Object = null;
         var _loc27_:uint = 0;
         var _loc28_:Object = null;
         var _loc29_:Object = null;
         var _loc30_:int = 0;
         var _loc31_:Object = null;
         var _loc32_:int = 0;
         var _loc33_:Object = null;
         var _loc34_:uint = 0;
         var _loc35_:Object = null;
         var _loc36_:Object = null;
         var _loc37_:int = 0;
         var _loc38_:Object = null;
         var _loc39_:int = 0;
         var _loc40_:Object = null;
         var _loc2_:uint = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         trace("rockman>trace senjutsu> AI character>DBCharacterData.SENJUTSU = " + getData(DBCharacterData.SENJUTSU));
         trace("rockman>trace senjutsu> AI character>SenjutsuListArr = " + this.getSenjutsuListArr());
         trace("rockman>trace senjutsu> AI character>bloodline_skill_arr = " + this.getBloodlineListArr());
         trace("rockman>trace senjutsu> AI character>Secret_skill_arr = " + this.getSecretListArr());
         trace("rockman>trace senjutsu> AI character>skills = " + this.getSkillListArr());
         if(this.battleDebuff[BattleData.EFFECT_BUNDLE])
         {
            if(this.battleDebuff[BattleData.EFFECT_BUNDLE].duration > 0)
            {
               this.setPlayerCommand("weapon_attack");
               return;
            }
         }
         if(this.battleDebuff[BattleData.SKILL_377])
         {
            if(this.battleDebuff[BattleData.SKILL_377].duration > 0)
            {
               this.setPlayerCommand("weapon_attack");
               return;
            }
         }
         if(this.battleDebuff[BattleData.EFFECT_MERIDIANS_SEAL])
         {
            if(this.battleDebuff[BattleData.EFFECT_MERIDIANS_SEAL].duration > 0)
            {
               this.setPlayerCommand("weapon_attack");
               return;
            }
         }
         if(this.battleDebuff[BattleData.EFFECT_PARALYZE])
         {
            if(this.battleDebuff[BattleData.EFFECT_PARALYZE].duration > 0)
            {
               this.setPlayerCommand("weapon_attack");
               return;
            }
         }
         if(this.battleDebuff[BattleData.EFFECT_ECSTATIC_SOUND])
         {
            if(this.battleDebuff[BattleData.EFFECT_ECSTATIC_SOUND].duration > 0)
            {
               this.setPlayerCommand("weapon_attack");
               return;
            }
         }
         if(this.battleDebuff[BattleData.EFFECT_PARALYZE])
         {
            if(this.battleDebuff[BattleData.EFFECT_PARALYZE].duration > 0)
            {
               this.setPlayerCommand("pass");
               return;
            }
         }
         if(this.battleDebuff[BattleData.EFFECT_BUBBLE_PRISON])
         {
            if(this.battleDebuff[BattleData.EFFECT_PARALYZE].duration > 0)
            {
               this.setPlayerCommand("pass");
               return;
            }
         }
         if(this.battleDebuff[BloodlineData.EFFECT_MERIDIAN_BLOCK])
         {
            if(this.battleDebuff[BloodlineData.EFFECT_MERIDIAN_BLOCK].duration > 0)
            {
               this.setPlayerCommand("pass");
               return;
            }
         }
         if(this.battleBuff[BloodlineData.EFFECT_SKIP_DEAD_CLEAR_DEBUFF])
         {
            if(this.battleBuff[BloodlineData.EFFECT_SKIP_DEAD_CLEAR_DEBUFF].duration > 0)
            {
               this.setPlayerCommand("pass");
               return;
            }
         }
         var _loc8_:Array = this.getSkillListArr();
         _loc2_ = 0;
         while(_loc2_ < _loc8_.length)
         {
            if(this.getBattleSkillCooldown(_loc8_[_loc14_]) > 0)
            {
               _loc5_++;
            }
            _loc2_++;
         }
         var _loc9_:int = -1;
         if(_loc5_ == 0)
         {
            _loc2_ = 0;
            while(_loc2_ < _loc8_.length)
            {
               _loc1_ = NumberUtil.getRandom();
               _loc7_ = Main.SKILL_DATA[_loc8_[_loc2_]].effect.type;
               if(_loc7_ == BattleData.EFFECT_STUN || _loc7_ == BattleData.EFFECT_STUN_RANDOM || _loc7_ == BattleData.EFFECT_BLEEDING_STUN || _loc7_ == BattleData.EFFECT_DRAIN_HP_STUN || _loc7_ == BattleData.EFFECT_FEAR_WEAKEN_N_STUN || _loc7_ == BattleData.EFFECT_REDUCE_AGI_STUN)
               {
                  if(_loc1_ > 0.5 && this.getBattleSkillCooldown(_loc8_[_loc2_]) <= 0 && this.cp >= Main.SKILL_DATA[_loc8_[_loc2_]].cp)
                  {
                     this.setPlayerCommand("skill",_loc2_);
                     return;
                  }
                  if(this.getBattleSkillCooldown(_loc8_[_loc2_]) <= 0 && this.cp >= Main.SKILL_DATA[_loc8_[_loc2_]].cp)
                  {
                     _loc9_ = int(_loc2_);
                  }
               }
               else if(_loc7_ == BattleData.EFFECT_DAMAGE_BONUS || _loc7_ == BattleData.EFFECT_DODGE_BONUS || _loc7_ == BattleData.EFFECT_THUNDER_MODE_N_DEBUFF_RESIST || _loc7_ == BattleData.EFFECT_DMG_BONUS_N_REDUCTION || _loc7_ == BattleData.EFFECT_PROTECT_BY_DUMMY_RECEIVED_STUN || _loc7_ == BattleData.EFFECT_CP_LOCK_AND_DEBUFF_RESIST || _loc7_ == BattleData.EFFECT_HEAL_HP_N_DMG_BONUS_UPGRADE || _loc7_ == BattleData.SKILL_501 || _loc7_ == BattleData.EFFECT_HEAL_OVER_TIME_FIX_NUM)
               {
                  if(this.getBattleSkillCooldown(_loc8_[_loc2_]) <= 0 && this.cp >= Main.SKILL_DATA[_loc8_[_loc2_]].cp)
                  {
                     this.setPlayerCommand("skill",_loc2_);
                     return;
                  }
               }
               _loc2_++;
            }
            if(_loc9_ != -1)
            {
               this.setPlayerCommand("skill",_loc9_);
               return;
            }
         }
         else if(_loc5_ == 1)
         {
            _loc2_ = 0;
            while(_loc2_ < _loc8_.length)
            {
               _loc1_ = NumberUtil.getRandom();
               _loc7_ = Main.SKILL_DATA[_loc8_[_loc2_]].effect.type;
               if(_loc7_ == BattleData.EFFECT_STUN || _loc7_ == BattleData.EFFECT_STUN_RANDOM || _loc7_ == BattleData.EFFECT_BLEEDING_STUN || _loc7_ == BattleData.EFFECT_DRAIN_HP_STUN || _loc7_ == BattleData.EFFECT_FEAR_WEAKEN_N_STUN || _loc7_ == BattleData.EFFECT_REDUCE_AGI_STUN)
               {
                  if(_loc1_ > 0.5 && this.getBattleSkillCooldown(_loc8_[_loc2_]) <= 0 && this.cp >= Main.SKILL_DATA[_loc8_[_loc2_]].cp)
                  {
                     this.setPlayerCommand("skill",_loc2_);
                     return;
                  }
                  if(this.getBattleSkillCooldown(_loc8_[_loc2_]) <= 0 && this.cp >= Main.SKILL_DATA[_loc8_[_loc2_]].cp)
                  {
                     _loc9_ = int(_loc2_);
                  }
               }
               else if(_loc7_ == BattleData.EFFECT_DAMAGE_BONUS || _loc7_ == BattleData.EFFECT_DODGE_BONUS || _loc7_ == BattleData.EFFECT_THUNDER_MODE_N_DEBUFF_RESIST || _loc7_ == BattleData.EFFECT_DMG_BONUS_N_REDUCTION || _loc7_ == BattleData.EFFECT_PROTECT_BY_DUMMY_RECEIVED_STUN || _loc7_ == BattleData.EFFECT_CP_LOCK_AND_DEBUFF_RESIST || _loc7_ == BattleData.EFFECT_HEAL_HP_N_DMG_BONUS_UPGRADE || _loc7_ == BattleData.SKILL_501 || _loc7_ == BattleData.EFFECT_HEAL_OVER_TIME_FIX_NUM)
               {
                  if(this.getBattleSkillCooldown(_loc8_[_loc2_]) <= 0 && this.cp >= Main.SKILL_DATA[_loc8_[_loc2_]].cp)
                  {
                     this.setPlayerCommand("skill",_loc2_);
                     return;
                  }
               }
               _loc2_++;
            }
            if(_loc9_ != -1)
            {
               this.setPlayerCommand("skill",_loc9_);
               return;
            }
         }
         else if(_loc5_ == 2)
         {
            _loc2_ = 0;
            while(_loc2_ < _loc8_.length)
            {
               _loc1_ = NumberUtil.getRandom();
               _loc7_ = Main.SKILL_DATA[_loc8_[_loc2_]].effect.type;
               if(_loc7_ == BattleData.EFFECT_DAMAGE_BONUS || _loc7_ == BattleData.EFFECT_DODGE_BONUS || _loc7_ == BattleData.EFFECT_THUNDER_MODE_N_DEBUFF_RESIST || _loc7_ == BattleData.EFFECT_DMG_BONUS_N_REDUCTION || _loc7_ == BattleData.EFFECT_PROTECT_BY_DUMMY_RECEIVED_STUN || _loc7_ == BattleData.EFFECT_CP_LOCK_AND_DEBUFF_RESIST || _loc7_ == BattleData.EFFECT_HEAL_HP_N_DMG_BONUS_UPGRADE || _loc7_ == BattleData.SKILL_501 || _loc7_ == BattleData.EFFECT_HEAL_OVER_TIME_FIX_NUM)
               {
                  if(_loc1_ > 0.5 && this.getBattleSkillCooldown(_loc8_[_loc2_]) <= 0 && this.cp >= Main.SKILL_DATA[_loc8_[_loc2_]].cp)
                  {
                     this.setPlayerCommand("skill",_loc2_);
                     return;
                  }
                  if(this.getBattleSkillCooldown(_loc8_[_loc2_]) <= 0 && this.cp >= Main.SKILL_DATA[_loc8_[_loc2_]].cp)
                  {
                     _loc9_ = int(_loc2_);
                  }
               }
               else if(Main.SKILL_DATA[_loc8_[_loc2_]].damage >= 500)
               {
                  if(this.getBattleSkillCooldown(_loc8_[_loc2_]) <= 0 && this.cp >= Main.SKILL_DATA[_loc8_[_loc2_]].cp)
                  {
                     this.setPlayerCommand("skill",_loc2_);
                     return;
                  }
               }
               _loc2_++;
            }
            if(_loc9_ != -1)
            {
               this.setPlayerCommand("skill",_loc9_);
               return;
            }
         }
         else if(_loc5_ == 3)
         {
            _loc2_ = 0;
            while(_loc2_ < _loc8_.length)
            {
               _loc1_ = NumberUtil.getRandom();
               _loc7_ = Main.SKILL_DATA[_loc8_[_loc2_]].effect.type;
               if(_loc7_ == BattleData.EFFECT_STUN || _loc7_ == BattleData.EFFECT_STUN_RANDOM || _loc7_ == BattleData.EFFECT_BLEEDING_STUN || _loc7_ == BattleData.EFFECT_DRAIN_HP_STUN || _loc7_ == BattleData.EFFECT_FEAR_WEAKEN_N_STUN || _loc7_ == BattleData.EFFECT_REDUCE_AGI_STUN)
               {
                  if(_loc1_ > 0.5 && this.getBattleSkillCooldown(_loc8_[_loc2_]) <= 0 && this.cp >= Main.SKILL_DATA[_loc8_[_loc2_]].cp)
                  {
                     this.setPlayerCommand("skill",_loc2_);
                     return;
                  }
                  if(this.getBattleSkillCooldown(_loc8_[_loc2_]) <= 0 && this.cp >= Main.SKILL_DATA[_loc8_[_loc2_]].cp)
                  {
                     _loc9_ = int(_loc2_);
                  }
               }
               else if(Main.SKILL_DATA[_loc8_[_loc2_]].damage >= 500)
               {
                  if(this.getBattleSkillCooldown(_loc8_[_loc2_]) <= 0 && this.cp >= Main.SKILL_DATA[_loc8_[_loc2_]].cp)
                  {
                     this.setPlayerCommand("skill",_loc2_);
                     return;
                  }
               }
               _loc2_++;
            }
            if(_loc9_ != -1)
            {
               this.setPlayerCommand("skill",_loc9_);
               return;
            }
         }
         else if(_loc5_ == 4)
         {
            _loc2_ = 0;
            while(_loc2_ < _loc8_.length)
            {
               if(Main.SKILL_DATA[_loc8_[_loc2_]].damage >= 10)
               {
                  if(this.getBattleSkillCooldown(_loc8_[_loc2_]) <= 0 && this.cp >= Main.SKILL_DATA[_loc8_[_loc2_]].cp)
                  {
                     this.setPlayerCommand("skill",_loc2_);
                     return;
                  }
               }
               _loc2_++;
            }
         }
         _loc2_ = 0;
         while(_loc2_ < _loc8_.length)
         {
            _loc14_ = Math.floor(NumberUtil.randomNumber(0,_loc8_.length));
            _loc1_ = NumberUtil.getRandom();
            if(_loc1_ > 0.5 && this.getBattleSkillCooldown(_loc8_[_loc14_]) <= 0 && this.cp >= Main.SKILL_DATA[_loc8_[_loc14_]].cp)
            {
               if(!(this.hp > this.maxHP * 0.8 && Main.SKILL_DATA[_loc8_[_loc14_]].effect.type == SkillData.EFFECT_TYPE_HEAL))
               {
                  if(Main.SKILL_DATA[_loc8_[_loc14_]].effect.type != BattleData.EFFECT_HEAL_MEMBER)
                  {
                     _loc15_ = ["fire","water","wind","earth","lightning"];
                     _loc16_ = {
                        "fire":"wind",
                        "wind":"lightning",
                        "lightning":"earth",
                        "earth":"water",
                        "water":"fire"
                     };
                     _loc17_ = {
                        "noTaijutsu":"taijutsu",
                        "noGenjutsu":"genjutsu"
                     };
                     if(String(Main.SKILL_DATA[_loc8_[_loc14_]].type).indexOf(_loc17_[String(Central.battle.getBattleBackground().name)]) >= 0)
                     {
                        break;
                     }
                     if(Central.battle.getBattleBackground().name == "noNinjutsu" && _loc15_.indexOf(String(Main.SKILL_DATA[_loc8_[_loc14_]].type)) >= 0)
                     {
                        break;
                     }
                     if(String(Main.SKILL_DATA[_loc8_[_loc14_]].type).indexOf(_loc16_[String(Central.battle.getBattleBackground().name)]) >= 0)
                     {
                        break;
                     }
                     this.setPlayerCommand("skill",_loc14_);
                     return;
                  }
                  if(this.friendly == true)
                  {
                     if(Central.main.getMainChar().hp < Central.main.getMainChar().maxHP * 0.8)
                     {
                        Battle.setDefender(Central.main.getMainChar());
                        this.setPlayerCommand("skill",_loc14_);
                        return;
                     }
                     _loc4_ = 0;
                     while(_loc4_ < Battle.partyArr.length)
                     {
                        if(!Battle.partyArr[_loc4_].isDead && Battle.partyArr[_loc4_] != this && Battle.partyArr[_loc4_].hp < Battle.partyArr[_loc4_].maxHP * 0.8)
                        {
                           Battle.setDefender(Battle.partyArr[_loc4_]);
                           this.setPlayerCommand("skill",_loc14_);
                           return;
                        }
                        _loc4_++;
                     }
                  }
                  else
                  {
                     _loc4_ = 0;
                     while(_loc4_ < Battle.enemyArr.length)
                     {
                        if(!Battle.enemyArr[_loc4_].isDead && Battle.enemyArr[_loc4_] != this && Battle.enemyArr[_loc4_].hp < Battle.enemyArr[_loc4_].maxHP * 0.8)
                        {
                           Battle.setDefender(Battle.enemyArr[_loc4_]);
                           this.setPlayerCommand("skill",_loc14_);
                           return;
                        }
                        _loc4_++;
                     }
                  }
               }
            }
            _loc2_++;
         }
         var _loc10_:Array = this.getBloodlineListArr();
         if(this.fuckNoBloodline == true)
         {
            _loc10_ = [];
         }
         _loc2_ = 0;
         while(_loc2_ < _loc10_.length)
         {
            _loc18_ = Math.floor(NumberUtil.randomNumber(0,_loc10_.length));
            _loc19_ = Central.main.BLOODLINE_SKILL_DATA["bloodline_skill" + _loc10_[_loc18_].skill_id];
            _loc20_ = {};
            _loc3_ = 0;
            while(_loc3_ < 10)
            {
               if(_loc19_.effect[_loc3_].skill_level == _loc10_[_loc18_].level)
               {
                  _loc20_ = _loc19_.effect[_loc3_];
               }
               _loc3_++;
            }
            _loc21_ = int(this.getLevel() * (_loc20_.skill_cp / 100));
            trace("AI Character :: bloodline_skill_arr[randomBloodlineSkillId].skill_id :: " + _loc10_[_loc18_].skill_id);
            _loc1_ = NumberUtil.getRandom();
            _loc22_ = true;
            if(_loc10_[_loc18_].skill_id == "1010")
            {
               if(this.isBattleBuffActive(BloodlineData.EFFECT_EXTREME + ".skill1009"))
               {
                  _loc22_ = true;
               }
               else
               {
                  _loc22_ = false;
               }
            }
            _loc23_ = true;
            if(_loc10_[_loc18_].skill_id == "1022")
            {
               _loc23_ = false;
            }
            _loc24_ = true;
            if(_loc10_[_loc18_].skill_id == "1046")
            {
               _loc24_ = false;
            }
            if(_loc1_ > 0.5 && this.getBattleSkillCooldown(_loc19_.skill_id) <= 0 && this.cp >= _loc21_ && _loc22_ == true && _loc23_ == true && _loc24_ == true)
            {
               _loc25_ = {};
               _loc25_.id = _loc19_.skill_id;
               _loc25_.dbid = String(_loc19_.skill_id).replace("skill","");
               _loc25_.name = _loc19_.name;
               _loc25_.gold = 0;
               _loc25_.crystal = 0;
               _loc25_.damage = int(this.getLevel() * (_loc20_.skill_damage / 100));
               _loc25_.rarity = _loc19_.rarity;
               _loc25_.swfName = _loc19_.swf_name;
               _loc25_.description = _loc19_.description;
               _loc25_.cp = int(this.getLevel() * (_loc20_.skill_cp / 100));
               _loc25_.cooldown = _loc19_.cooldown;
               _loc25_.posType = _loc19_.postype;
               _loc25_.tooltip = _loc19_.tooltip;
               _loc25_.type = _loc19_.type;
               _loc25_.effect = _loc20_;
               _loc25_.level = _loc20_.skill_level;
               _loc25_.premium = _loc19_.premium;
               _loc25_.vendor = _loc19_.vendor;
               _loc25_.train_time = 0;
               _loc25_.bloodline_id = _loc19_.bloodline_id;
               _loc25_.bloodline_type = Central.main.BLOODLINE_DATA["bloodline" + _loc19_.bloodline_id].type;
               _loc26_ = {};
               _loc26_.skillData = _loc25_;
               this.setPlayerCommand("bloodline",_loc18_,_loc26_);
               return;
            }
            _loc2_++;
         }
         var _loc11_:Array = this.getSecretListArr();
         _loc2_ = 0;
         while(_loc2_ < _loc11_.length)
         {
            _loc27_ = Math.floor(NumberUtil.randomNumber(0,_loc11_.length - 0.001));
            Out.debug(this,"randomSecretSkillId >> " + _loc27_);
            Out.debug(this,"bl_skill >> " + _loc11_[_loc27_]);
            Out.debug(this,"bl_skill_id >> " + _loc11_[_loc27_].skill_id);
            _loc28_ = Central.main.BLOODLINE_SKILL_DATA["bloodline_skill" + _loc11_[_loc27_].skill_id];
            _loc29_ = {};
            _loc3_ = 0;
            while(_loc3_ < 10)
            {
               if(_loc28_.effect[_loc3_].skill_level == _loc11_[_loc27_].level)
               {
                  _loc29_ = _loc28_.effect[_loc3_];
               }
               _loc3_++;
            }
            _loc30_ = int(this.getLevel() * (_loc29_.skill_cp / 100));
            _loc1_ = NumberUtil.getRandom();
            if(_loc1_ > 0.5 && this.getBattleSkillCooldown(_loc28_.skill_id) <= 0 && this.cp >= _loc30_)
            {
               _loc31_ = {};
               _loc32_ = 0;
               _loc32_ = int(this.getLevel() * (_loc29_.skill_damage / 100));
               _loc31_.id = _loc28_.skill_id;
               _loc31_.dbid = String(_loc28_.skill_id).replace("skill","");
               _loc31_.name = _loc28_.name;
               _loc31_.gold = 0;
               _loc31_.crystal = 0;
               _loc31_.damage = _loc32_;
               _loc31_.rarity = _loc28_.rarity;
               _loc31_.swfName = _loc28_.swf_name;
               _loc31_.description = _loc28_.description;
               _loc31_.cp = _loc30_;
               _loc31_.cooldown = _loc28_.cooldown;
               _loc31_.posType = _loc28_.postype;
               _loc31_.tooltip = _loc28_.tooltip;
               _loc31_.type = _loc28_.type;
               _loc31_.effect = _loc29_;
               _loc31_.level = _loc29_.skill_level;
               _loc31_.premium = _loc28_.premium;
               _loc31_.vendor = _loc28_.vendor;
               _loc31_.train_time = 0;
               _loc31_.bloodline_id = _loc28_.bloodline_id;
               _loc31_.bloodline_type = Central.main.BLOODLINE_DATA["bloodline" + _loc28_.bloodline_id].type;
               _loc33_ = {};
               _loc33_.skillData = _loc31_;
               this.setPlayerCommand("bloodline",_loc27_,_loc33_);
               return;
            }
            _loc2_++;
         }
         var _loc12_:Array = this.getSenjutsuListArr();
         var _loc13_:Array = [];
         _loc2_ = 0;
         while(_loc2_ < _loc12_.length)
         {
            if(dbChar[DBCharacterData.SENJUTSU].indexOf("senjutsu_skill" + _loc12_[_loc2_].skill_id) >= 0)
            {
               _loc13_.push(_loc12_[_loc2_]);
            }
            _loc2_++;
         }
         _loc2_ = 0;
         while(_loc2_ < _loc13_.length)
         {
            _loc34_ = Math.floor(NumberUtil.randomNumber(0,_loc13_.length - 0.001));
            _loc35_ = Central.main.SENJUTSU_SKILL_DATA["senjutsu_skill" + _loc13_[_loc34_].skill_id];
            Out.debug(this,"sen_skill_id >> " + _loc13_[_loc34_].skill_id);
            _loc36_ = {};
            _loc3_ = 0;
            while(_loc3_ < 10)
            {
               if(_loc35_.effect[_loc3_].skill_level == _loc13_[_loc34_].level)
               {
                  _loc36_ = _loc35_.effect[_loc3_];
                  break;
               }
               _loc3_++;
            }
            _loc37_ = 0;
            if(_loc13_[_loc34_].skill_id == "3000")
            {
               _loc37_ = int(this.maxSP);
            }
            else if(isBattleBuffActive(SenjutsuData.EFFECT_SENNIN_MODE))
            {
               _loc37_ = 0;
            }
            else
            {
               _loc37_ = int(_loc36_.skill_sp);
            }
            _loc1_ = NumberUtil.getRandom();
            if(_loc1_ > 0.5 && this.getBattleSkillCooldown(_loc35_.skill_id) <= 0 && this.sp >= _loc37_)
            {
               _loc38_ = {};
               _loc39_ = 0;
               _loc39_ = int(this.getLevel() * (_loc36_.skill_damage / 100));
               _loc38_.id = _loc35_.skill_id;
               _loc38_.dbid = String(_loc35_.skill_id).replace("skill","");
               _loc38_.name = _loc35_.name;
               _loc38_.gold = 0;
               _loc38_.crystal = 0;
               _loc38_.damage = _loc39_;
               _loc38_.rarity = _loc35_.rarity;
               _loc38_.swfName = _loc35_.swf_name;
               _loc38_.description = _loc35_.description;
               _loc38_.sp = _loc37_;
               _loc38_.cooldown = _loc35_.cooldown;
               _loc38_.posType = _loc35_.postype;
               _loc38_.tooltip = _loc35_.tooltip;
               _loc38_.type = _loc35_.type;
               _loc38_.effect = _loc36_;
               _loc38_.level = _loc36_.skill_level;
               _loc38_.premium = _loc35_.premium;
               _loc38_.vendor = _loc35_.vendor;
               _loc38_.train_time = 0;
               _loc38_.senjutsu_id = _loc35_.senjutsu_id;
               _loc40_ = {};
               _loc40_.skillData = _loc38_;
               this.setPlayerCommand("senjutsu",_loc34_,_loc40_);
               return;
            }
            _loc2_++;
         }
         _loc1_ = NumberUtil.getRandom();
         if(_loc1_ > 0.5 && this.cp < this.maxCP / 2)
         {
            this.setPlayerCommand("charge");
            return;
         }
         if(_loc1_ > 0.3 && this.cp < this.maxCP / 3)
         {
            this.setPlayerCommand("charge");
            return;
         }
         this.setPlayerCommand("weapon_attack");
      }
      
      public function get rewardGold() : uint
      {
         if(this.getLevel() < 3)
         {
            return 25;
         }
         return this.getLevel() * 10;
      }
      
      public function get rewardXP() : uint
      {
         if(this.getLevel() == 1)
         {
            return 10;
         }
         return this.getLevel() * 5;
      }
      
      public function get rewardConsumable() : Object
      {
         var _loc1_:uint = 0;
         var _loc2_:Array = null;
         var _loc3_:Array = null;
         if(this.getLevel() >= Main.getMainChar().getLevel() - 1)
         {
            _loc2_ = Central.main.ITEM_DATA.toArray();
            _loc3_ = [];
            _loc1_ = 0;
            while(_loc1_ < _loc2_.length)
            {
               if(_loc2_[_loc1_].level >= this.getLevel() - Data.BATTLE_REWARDS_CONSUMABLE_LEVEL_RESTRICTION && _loc2_[_loc1_].level <= this.getLevel() && _loc2_[_loc1_].rarity == 1)
               {
                  _loc3_.push(_loc2_[_loc1_]);
               }
               _loc1_++;
            }
            return _loc3_[Math.floor(NumberUtil.randomNumber(0,_loc3_.length - 1.0001))];
         }
         return null;
      }
      
      public function get rewardItem() : Object
      {
         return null;
      }
   }
}

