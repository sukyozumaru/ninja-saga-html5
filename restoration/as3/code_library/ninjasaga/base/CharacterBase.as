package ninjasaga.base
{
   import br.com.stimuli.loading.BulkLoader;
   import br.com.stimuli.loading.loadingtypes.*;
   import com.adobe.utils.IntUtil;
   import com.utils.CreateFilter;
   import com.utils.GF;
   import com.utils.NumberUtil;
   import com.utils.Out;
   import flash.display.*;
   import flash.events.*;
   import flash.net.*;
   import flash.utils.*;
   import gs.*;
   import gs.plugins.*;
   import gs.utils.tween.*;
   import ninjasaga.*;
   import ninjasaga.battle.BattleProcessor;
   import ninjasaga.data.BattleData;
   import ninjasaga.data.BloodlineData;
   import ninjasaga.data.DBCharacterData;
   import ninjasaga.data.Formula;
   import ninjasaga.data.RankData;
   import ninjasaga.data.SenjutsuData;
   import ninjasaga.data.SkillData;
   
   public class CharacterBase
   {
      
      protected var dbChar:*;
      
      public var battleSkillCooldown:Object = {};
      
      protected var battleAction:Object = null;
      
      protected var battleBuff:Object = {};
      
      protected var battleDebuff:Object = {};
      
      public var isDead:Boolean = false;
      
      public var hpBonus:int = 0;
      
      public var cpBonus:int = 0;
      
      public var spBonus:int = 0;
      
      public var side:uint = BattleData.SIDE_FRIENDLY;
      
      public var type:int;
      
      public var dodgeBonus:Number = 0;
      
      public var effectResistance:Array = [];
      
      public var isStunResistBoo:Boolean = false;
      
      public var limb:int = 1;
      
      public const TYPE_CHARACTER:int = 1;
      
      public const TYPE_AICHARACTER:int = 2;
      
      public const TYPE_PVPCHARACTER:int = 3;
      
      public const TYPE_ENEMY:int = 4;
      
      public const TYPE_PET:int = 5;
      
      public const TYPE_NPC:int = 6;
      
      protected var isClassSkillAvailable:Array = new Array();
      
      protected var classSkillList:Array = [];
      
      public var salfLifeSkill:Array = [BattleData.EFFECT_ALL_CP_DODGE_BONUS,BattleData.EFFECT_ALL_CP_DRAIN_HP,BattleData.EFFECT_ALL_CP_BLIND,BattleData.EFFECT_ALL_CP_GUARD_RESIST,BattleData.EFFECT_ALL_CP_HEAL,SenjutsuData.EFFECT_SS_DIVIDE_CHAOS];
      
      public var senjustuSkillFirstUseArr:Array = [];
      
      public var damageShield:int = 0;
      
      public var divideChaosSingleClearRound:int = 0;
      
      public var divideChaosRound:int = 0;
      
      public function CharacterBase()
      {
         super();
      }
      
      public function getData(param1:String) : *
      {
         return this.dbChar[param1];
      }
      
      public function updateData(param1:String, param2:*) : void
      {
         this.dbChar[param1] = param2;
      }
      
      public function getCharacterId() : int
      {
         return this.getData(DBCharacterData.ID);
      }
      
      private function isLevelHack() : Boolean
      {
         if(Formula.getLvByXp(Central.main.getMainChar().getData(DBCharacterData.XP)) != Central.main.getMainChar().getData(DBCharacterData.LEVEL))
         {
            return true;
         }
         switch(Central.main.getMainChar().getData(DBCharacterData.RANK))
         {
            case RankData.GENIN:
               if(Central.main.getMainChar().getData(DBCharacterData.LEVEL) > RankData.GENIN_LEVEL_CAP)
               {
                  return true;
               }
               break;
            case RankData.CHUNIN:
            case RankData.CHUNIN_TALENTED:
               if(Central.main.getMainChar().getData(DBCharacterData.LEVEL) > RankData.CHUNIN_LEVEL_CAP)
               {
                  return true;
               }
               break;
            case RankData.JOUNIN:
            case RankData.JOUNIN_TALENTED:
               if(Central.main.getMainChar().getData(DBCharacterData.LEVEL) > RankData.JOUNIN_LEVEL_CAP)
               {
                  return true;
               }
               break;
            case RankData.SPECIAL_JOUNIN:
            case RankData.SPECIAL_JOUNIN_TALENTED:
               if(Central.main.getMainChar().getData(DBCharacterData.LEVEL) > RankData.SPECIAL_JOUNIN_LEVEL_CAP)
               {
                  return true;
               }
               break;
            case RankData.TUTOR:
            case RankData.TUTOR_SENIOR:
               if(Central.main.getMainChar().getData(DBCharacterData.LEVEL) > RankData.TUTOR_LEVEL_CAP)
               {
                  return true;
               }
         }
         return false;
      }
      
      public function getLevel() : uint
      {
         if(this.isLevelHack())
         {
            Central.main.onError("2977","");
            return 0;
         }
         return this.dbChar.character_level;
      }
      
      public function get hp() : uint
      {
         return this.getData(DBCharacterData.HP);
      }
      
      public function get cp() : uint
      {
         return this.getData(DBCharacterData.CP);
      }
      
      public function get sp() : uint
      {
         return this.getData(DBCharacterData.SP);
      }
      
      public function get petCP() : uint
      {
         return this.getData(DBCharacterData.PET_CP);
      }
      
      public function get petMaxCP() : uint
      {
         return this.getData(DBCharacterData.PET_MAX_CP);
      }
      
      public function get petMaxEp() : uint
      {
         return this.getData(DBCharacterData.PET_MAX_EP);
      }
      
      public function updatePetCP(param1:int) : uint
      {
         var _loc2_:* = this.getData(DBCharacterData.PET_CP);
         _loc2_ += param1;
         if(_loc2_ < 0)
         {
            _loc2_ = 0;
         }
         if(_loc2_ > this.petMaxCP)
         {
            _loc2_ = this.petMaxCP;
         }
         this.updateData(DBCharacterData.PET_CP,_loc2_);
         return _loc2_;
      }
      
      public function updatePetEP(param1:int) : uint
      {
         var _loc2_:* = this.getData(DBCharacterData.PET_EP);
         _loc2_ += param1;
         if(_loc2_ < 0)
         {
            _loc2_ = 0;
         }
         if(_loc2_ > this.petMaxEp)
         {
            _loc2_ = this.petMaxEp;
         }
         this.updateData(DBCharacterData.PET_EP,_loc2_);
         return _loc2_;
      }
      
      public function get maxHP() : uint
      {
         return Formula.calcHP(this,Central.main.BLOODLINE_SKILL_DATA_ARR,Central.main.SENJUTSU_SKILL_DATA_ARR) + this.hpBonus;
      }
      
      public function get maxCP() : uint
      {
         return Formula.calcCP(this,Central.main.BLOODLINE_SKILL_DATA_ARR,Central.main.SENJUTSU_SKILL_DATA_ARR) + this.cpBonus;
      }
      
      public function get maxSP() : uint
      {
         return Formula.calcSP(this) + this.spBonus;
      }
      
      public function get DamageHp() : int
      {
         return this.getData(DBCharacterData.DAMAGE_HP);
      }
      
      public function get DamageCp() : int
      {
         return this.getData(DBCharacterData.DAMAGE_CP);
      }
      
      public function get DamageSp() : int
      {
         return this.getData(DBCharacterData.DAMAGE_SP);
      }
      
      public function get RestoreHp() : int
      {
         return this.getData(DBCharacterData.RESTORE_HP);
      }
      
      public function get RestoreCp() : int
      {
         return this.getData(DBCharacterData.RESTORE_CP);
      }
      
      public function get RestoreSp() : int
      {
         return this.getData(DBCharacterData.RESTORE_SP);
      }
      
      public function set DamageHp(param1:int) : void
      {
         this.updateData(DBCharacterData.DAMAGE_HP,param1);
      }
      
      public function set DamageCp(param1:int) : void
      {
         this.updateData(DBCharacterData.DAMAGE_CP,param1);
      }
      
      public function set DamageSp(param1:int) : void
      {
         this.updateData(DBCharacterData.DAMAGE_SP,param1);
      }
      
      public function set RestoreHp(param1:int) : void
      {
         this.updateData(DBCharacterData.RESTORE_HP,param1);
      }
      
      public function set RestoreCp(param1:int) : void
      {
         this.updateData(DBCharacterData.RESTORE_CP,param1);
      }
      
      public function set RestoreSp(param1:int) : void
      {
         this.updateData(DBCharacterData.RESTORE_SP,param1);
      }
      
      public function updateHP(param1:int) : uint
      {
         var _loc2_:int = this.getData(DBCharacterData.HP);
         if(Central.battle.type == Central.battle.TYPE_LOCAL)
         {
            if(this.getCharacterId() != Central.main.getMainChar().getCharacterId())
            {
               if(this.isDead == true)
               {
                  return _loc2_;
               }
            }
         }
         _loc2_ += param1;
         if(_loc2_ < 0)
         {
            _loc2_ = 0;
         }
         if(_loc2_ > this.maxHP)
         {
            _loc2_ = int(this.maxHP);
         }
         this.updateData(DBCharacterData.HP,_loc2_);
         return _loc2_;
      }
      
      public function updateSP(param1:int) : uint
      {
         var _loc2_:int = this.getData(DBCharacterData.SP);
         if(Central.battle.type == Central.battle.TYPE_LOCAL)
         {
            if(this.getCharacterId() != Central.main.getMainChar().getCharacterId())
            {
               if(this.isDead == true)
               {
                  return _loc2_;
               }
            }
         }
         _loc2_ += param1;
         if(_loc2_ < 0)
         {
            _loc2_ = 0;
         }
         if(_loc2_ > this.maxSP)
         {
            _loc2_ = int(this.maxSP);
         }
         this.updateData(DBCharacterData.SP,_loc2_);
         return _loc2_;
      }
      
      public function updateSPstatus(param1:String, param2:int = 0) : void
      {
         switch(param1)
         {
            case SenjutsuData.SP_UPDATE_ROUND:
               updateSP(int(this.maxSP * SenjutsuData.SP_UPDATE_ROUND_PERCENTAGE * 0.01));
               break;
            case SenjutsuData.SP_UPDATE_EXTRA:
               updateSP(param2);
         }
      }
      
      public function getTradingWeapon() : String
      {
         return "";
      }
      
      public function getTradingBackItem() : String
      {
         return "";
      }
      
      public function getWeapon() : String
      {
         return "";
      }
      
      public function getWeaponEffectObj(param1:String) : Object
      {
         return {};
      }
      
      public function getBackItem() : String
      {
         return "";
      }
      
      public function getAccessory() : String
      {
         return "";
      }
      
      public function getTradingItem() : String
      {
         return "";
      }
      
      public function getBloodlineEffect() : Array
      {
         return null;
      }
      
      public function getBloodline() : Array
      {
         return null;
      }
      
      public function getGearset() : Object
      {
         return null;
      }
      
      public function getSkillListArr() : Array
      {
         var _loc3_:int = 0;
         if(this.dbChar.character_skills == null)
         {
            return [];
         }
         var _loc1_:Array = this.dbChar.character_skills;
         var _loc2_:Boolean = false;
         _loc3_ = 0;
         while(_loc3_ < _loc1_.length)
         {
            if(_loc1_[_loc3_] == null)
            {
               _loc2_ = true;
               break;
            }
            _loc3_++;
         }
         if(!_loc2_)
         {
            switch(this.type)
            {
               case TYPE_PET:
                  _loc3_ = 0;
                  while(_loc3_ < _loc1_.length)
                  {
                     if(!(_loc1_[_loc3_] >= 0 && _loc1_[_loc3_] <= 5))
                     {
                        _loc2_ = true;
                        break;
                     }
                     _loc3_++;
                  }
                  break;
               default:
                  _loc3_ = 0;
                  while(_loc3_ < _loc1_.length)
                  {
                     if(_loc1_[_loc3_] == 0)
                     {
                        _loc2_ = true;
                        break;
                     }
                     _loc3_++;
                  }
                  if(_loc2_)
                  {
                     break;
                  }
                  _loc3_ = 0;
                  while(_loc3_ < _loc1_.length)
                  {
                     if(Central.main.SKILL_DATA != null)
                     {
                        if(Central.main.SKILL_DATA[_loc1_[_loc3_]] == null)
                        {
                           _loc2_ = true;
                           break;
                        }
                     }
                     _loc3_++;
                  }
            }
         }
         if(_loc2_)
         {
            this.dbChar.character_skills = [];
            return [];
         }
         return _loc1_;
      }
      
      public function getWeaponDamage() : int
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:String = this.getWeapon();
         var _loc4_:Object = Central.main.WEAPON_DATA.find(_loc3_);
         if(_loc4_ == null)
         {
            Out.debug(this,"getWeaponDamage :: weapon not found");
            return 0;
         }
         return Formula.calcDamage(_loc4_,{"character":this});
      }
      
      public function isBattleSkillCooldown(param1:String) : Boolean
      {
         if(this.battleSkillCooldown[param1])
         {
            if(this.battleSkillCooldown[param1] > 0)
            {
               return true;
            }
         }
         return false;
      }
      
      public function getBattleSkillCooldown(param1:String) : int
      {
         if(this.battleSkillCooldown[param1])
         {
            return this.battleSkillCooldown[param1];
         }
         return 0;
      }
      
      public function setSkillCooldown(param1:Object) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:Array = null;
         var _loc7_:int = 0;
         var _loc8_:Object = null;
         Out.debug(this,"rex1706 : outputSkill id : " + param1.id);
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         if(this.isBattleBuffActive(SenjutsuData.EFFECT_SS_SKILL_FIRST_USE_CD_REDUCE))
         {
            if(this.senjustuSkillFirstUseArr.indexOf(param1.id) < 0)
            {
               Out.debug(this,"setSkillCooldown :: need reduce");
               _loc2_ = int(this.getBattleBuff()[SenjutsuData.EFFECT_SS_SKILL_FIRST_USE_CD_REDUCE].amount);
               this.senjustuSkillFirstUseArr.push(param1.id);
            }
         }
         _loc5_ = 0;
         if(Boolean(param1.effect) && param1.effect.type == BattleData.EFFECT_CLEARBUFF_REDUCE_CP_THANOS)
         {
            if(this.getWeapon() == "wpn1596")
            {
               _loc4_ = int(Central.main.stateInventory.getStateOnCount(this.getCharacterId(),"wpn","wpn1596"));
               if(_loc4_ >= 0)
               {
                  _loc5_ = _loc4_;
               }
            }
         }
         if(param1.skill_cooldown_group != 0 && param1.skill_cooldown_group != null)
         {
            _loc6_ = this.getSkillListArr();
            _loc7_ = 0;
            while(_loc7_ < _loc6_.length)
            {
               _loc8_ = Central.main.SKILL_DATA[_loc6_[_loc7_]];
               if(_loc8_.skill_cooldown_group == param1.skill_cooldown_group)
               {
                  _loc3_ = param1.cooldown - _loc2_ - _loc5_;
                  if(_loc3_ > 0)
                  {
                     Out.debug(this,"group setSkillCooldown :: cd_reduce >> " + _loc2_);
                     Out.debug(this,"group setSkillCooldown :: cd >> " + _loc3_);
                     this.battleSkillCooldown[_loc8_.id] = _loc3_;
                  }
               }
               _loc7_++;
            }
         }
         else
         {
            _loc3_ = param1.cooldown - _loc2_ - _loc5_;
            if(_loc3_ > 0)
            {
               Out.debug(this,"setSkillCooldown :: cd_reduce >> " + _loc2_);
               Out.debug(this,"setSkillCooldown :: cd >> " + _loc3_);
               this.battleSkillCooldown[param1.id] = _loc3_;
            }
         }
      }
      
      public function setBattleSkillCooldown(param1:String, param2:int) : void
      {
         if(param1.indexOf("skill") == -1)
         {
            param1 = "skill" + param1;
         }
         this.battleSkillCooldown[param1] = Math.round(param2 + 0);
      }
      
      public function reduceSkillCooldown(param1:int, param2:int = 0, param3:String = null) : void
      {
         var _loc5_:String = null;
         var _loc7_:int = 0;
         var _loc4_:Boolean = false;
         var _loc6_:Object = {};
         for(_loc5_ in this.battleSkillCooldown)
         {
            switch(param2)
            {
               case BattleData.REDUCETYPE_ALL:
                  _loc4_ = true;
                  break;
               case BattleData.REDUCETYPE_SKILL:
                  if(Central.main.SKILL_DATA[_loc5_])
                  {
                     if(param3 != null)
                     {
                        if(Central.main.SKILL_DATA[_loc5_].type == param3)
                        {
                           _loc4_ = true;
                        }
                     }
                     else
                     {
                        _loc4_ = true;
                     }
                  }
                  break;
               case BattleData.REDUCETYPE_TALENT:
                  if(Central.main.BLOODLINE_SKILL_DATA["bloodline_" + _loc5_])
                  {
                     _loc4_ = true;
                  }
            }
            _loc7_ = int(this.battleSkillCooldown[_loc5_]);
            if(_loc4_)
            {
               _loc7_ -= param1;
               _loc4_ = false;
            }
            if(_loc7_ > 0)
            {
               _loc6_[_loc5_] = _loc7_;
            }
         }
         this.battleSkillCooldown = _loc6_;
      }
      
      public function addSkillCooldown(param1:int, param2:String = null) : void
      {
         var _loc4_:int = 0;
         var _loc6_:int = 0;
         var _loc3_:Boolean = false;
         var _loc5_:Array = this.getSkillListArr();
         _loc4_ = 0;
         while(_loc4_ < _loc5_.length)
         {
            if(param2 != null)
            {
               if(Central.main.SKILL_DATA[_loc5_[_loc4_]])
               {
                  if(Central.main.SKILL_DATA[_loc5_[_loc4_]].type == param2)
                  {
                     _loc3_ = true;
                  }
               }
            }
            else
            {
               _loc3_ = true;
            }
            if(_loc3_)
            {
               _loc6_ = this.getBattleSkillCooldown(_loc5_[_loc4_]);
               _loc6_ = _loc6_ + param1;
               this.setBattleSkillCooldown(_loc5_[_loc4_],_loc6_);
               _loc3_ = false;
            }
            _loc4_++;
         }
      }
      
      public function addAllSkillCooldown(param1:int) : void
      {
         var _loc2_:int = 0;
         var _loc4_:int = 0;
         var _loc3_:Array = this.getSkillListArr();
         _loc2_ = 0;
         while(_loc2_ < _loc3_.length)
         {
            _loc4_ = this.getBattleSkillCooldown(_loc3_[_loc2_]);
            _loc4_ = _loc4_ + param1;
            this.setBattleSkillCooldown(_loc3_[_loc2_],_loc4_);
            _loc2_++;
         }
      }
      
      public function addRandomSkillCooldown(param1:int) : void
      {
         var _loc2_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc3_:Array = this.getSkillListArr();
         if(_loc3_.length > 0)
         {
            _loc4_ = NumberUtil.randomInt(0,_loc3_.length - 1);
            _loc5_ = this.getBattleSkillCooldown(_loc3_[_loc4_]);
            _loc5_ = _loc5_ + param1;
            this.setBattleSkillCooldown(_loc3_[_loc4_],_loc5_);
         }
      }
      
      public function reduceRandomSkillCooldown(param1:int) : void
      {
         var _loc2_:int = 0;
         var _loc6_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:Array = new Array();
         var _loc5_:Array = this.getSkillListArr();
         _loc2_ = 0;
         while(_loc2_ < _loc5_.length)
         {
            _loc6_ = this.getBattleSkillCooldown(_loc5_[_loc2_]);
            if(_loc6_ > 0)
            {
               _loc4_[_loc3_] = _loc2_;
               _loc3_++;
            }
            _loc2_++;
         }
         var _loc7_:int = NumberUtil.randomInt(0,_loc4_.length - 1);
         _loc6_ = this.getBattleSkillCooldown(_loc5_[_loc4_[_loc7_]]);
         _loc6_ = _loc6_ - param1;
         if(_loc6_ < 0)
         {
            _loc6_ = 0;
         }
         this.setBattleSkillCooldown(_loc5_[_loc4_[_loc7_]],_loc6_);
      }
      
      public function reducenetRandomSkillCooldown(param1:String, param2:int) : void
      {
         var _loc3_:int = 0;
         var _loc7_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:Array = new Array();
         var _loc6_:Array = this.getSkillListArr();
         param1 = "skill" + param1;
         _loc3_ = 0;
         while(_loc3_ < _loc6_.length)
         {
            if(_loc6_[_loc3_] == param1)
            {
               _loc5_[0] = _loc3_;
            }
            _loc3_++;
         }
         _loc7_ = this.getBattleSkillCooldown(_loc6_[_loc5_[0]]);
         _loc7_ = _loc7_ - param2;
         if(_loc7_ < 0)
         {
            _loc7_ = 0;
         }
         this.setBattleSkillCooldown(_loc6_[_loc5_[0]],_loc7_);
      }
      
      public function syncCoolDown() : void
      {
         var _loc4_:String = null;
         var _loc1_:Array = this.getSkillListArr();
         var _loc2_:Object = Central.battle.syncCoolDownObj;
         var _loc3_:int = 0;
         while(_loc3_ < _loc1_.length)
         {
            _loc4_ = _loc1_[_loc3_];
            trace("Central.battle.syncCoolDownObj.skillList[i] >> " + _loc2_[_loc4_]);
            if(_loc2_[_loc4_])
            {
               this.setBattleSkillCooldown(_loc1_[_loc3_],_loc2_[_loc4_]);
            }
            _loc3_++;
         }
      }
      
      public function setCommand(param1:String) : void
      {
         Out.debug(this,"setCommand :: action >> " + param1);
         switch(param1)
         {
            case "pass":
               this.battleAction = {"action":param1};
               break;
            case "dodge":
               this.battleAction = {"action":param1};
         }
      }
      
      public function setBattleAction(param1:Object = null) : void
      {
         this.battleAction = param1;
      }
      
      public function getBattleAction() : Object
      {
         return this.battleAction;
      }
      
      public function updateBattleAction(param1:String, param2:*) : void
      {
         if(this.battleAction)
         {
            this.battleAction[param1] = param2;
         }
      }
      
      public function resetBuff() : void
      {
         this.battleBuff = {};
         this.battleDebuff = {};
      }
      
      public function isBattleBuffActive(param1:String) : Boolean
      {
         if(this.battleBuff[param1] != null)
         {
            if(this.battleBuff[param1].duration > 0)
            {
               return true;
            }
         }
         return false;
      }
      
      public function isBattleDeBuffActive(param1:String) : Boolean
      {
         if(this.battleDebuff[param1] != null)
         {
            if(this.battleDebuff[param1].duration > 0)
            {
               return true;
            }
         }
         return false;
      }
      
      public function getBattleBuff() : Object
      {
         return this.battleBuff;
      }
      
      public function getBattleDeBuff() : Object
      {
         return this.battleDebuff;
      }
      
      public function setBattleBuff(param1:Object) : Boolean
      {
         var _loc3_:int = 0;
         var _loc4_:Number = NaN;
         var _loc2_:Object = {};
         _loc2_.type = param1.type;
         _loc2_.duration = Math.round(int(param1.duration) + 0);
         _loc2_.amount = param1.amount + 0;
         if(Central.battle.type == Central.battle.TYPE_LOCAL)
         {
            if(this.isBattleDeBuffActive(BattleData.EFFECT_BUFF_NEGATE))
            {
               _loc3_ = NumberUtil.getRandom();
               _loc4_ = int(this.getBattleDeBuff()[BattleData.EFFECT_BUFF_NEGATE].amount) / 100;
               if(_loc3_ < _loc4_)
               {
                  return false;
               }
            }
         }
         if(param1.chance != null)
         {
            _loc2_.chance = param1.chance;
         }
         if(param1.target != null)
         {
            _loc2_.target = param1.target;
         }
         if(param1.chancetohit != null)
         {
            _loc2_.chancetohit = Math.round(int(param1.chancetohit) + 0);
         }
         if(param1.chancetoeffect != null)
         {
            _loc2_.chancetoeffect = Math.round(int(param1.chancetoeffect) + 0);
         }
         if(param1.requirement != null)
         {
            _loc2_.requirement = param1.requirement;
         }
         if(param1.intmem1 != null)
         {
            _loc2_.intmem1 = param1.intmem1;
         }
         if(param1.intmem2 != null)
         {
            _loc2_.intmem2 = param1.intmem2;
         }
         if(param1.remainClones != null)
         {
            _loc2_.remainClones = param1.remainClones;
         }
         if(Boolean(this.battleAction) && Boolean(this.battleAction.clones) && this.battleAction.clones != null)
         {
            if(this.battleAction.clones[this.getCharacterId()])
            {
               return false;
            }
         }
         this.battleBuff[_loc2_.type] = _loc2_;
         return true;
      }
      
      public function setActiveBuff(param1:Object) : void
      {
         this.battleBuff = param1;
      }
      
      public function clearBuff() : void
      {
         var _loc1_:String = null;
         for(_loc1_ in this.battleBuff)
         {
            if(this.battleBuff[_loc1_])
            {
               if(salfLifeSkill.indexOf(_loc1_) >= 0)
               {
                  return;
               }
               if(_loc1_.indexOf(BattleData.EFFECT_DAMAGE_DELAY) < 0)
               {
                  if(_loc1_.indexOf(BattleData.EFFECT_SUSANOOB) < 0)
                  {
                     if(_loc1_.indexOf(BattleData.EFFECT_DAMAGE_BONUSA) < 0)
                     {
                        if(_loc1_.indexOf(BattleData.EFFECT_DAMAGE_REDUCTIONA) < 0)
                        {
                           if(_loc1_.indexOf(BattleData.EFFECT_BERSERKER_BUFF) < 0)
                           {
                              if(_loc1_.indexOf(BattleData.EFFECT_BURN_HP_CP_FIX_NUM_N_IMMUNITY_BLEEDING) < 0)
                              {
                                 if(_loc1_.indexOf(BattleData.EFFECT_DAMAGE_DELAY_INJURY) < 0)
                                 {
                                    if(_loc1_.indexOf(SenjutsuData.EFFECT_SENNIN_MODE) < 0)
                                    {
                                       if(_loc1_.indexOf(BattleData.EFFECT_DEBUFF_RESIST_EX) < 0)
                                       {
                                          if(this.battleBuff[_loc1_].duration <= BloodlineData.PASSIVE_BUFF_IDENTIFIER)
                                          {
                                             if(_loc1_.indexOf(BloodlineData.EFFECT_SKIP_DEAD_CLEAR_DEBUFF) < 0)
                                             {
                                                if(_loc1_.indexOf(BattleData.EFFECT_CLEAR_BLESS_N_REDUCE_HP) < 0)
                                                {
                                                   this.battleBuff[_loc1_] = null;
                                                }
                                             }
                                          }
                                       }
                                    }
                                 }
                              }
                           }
                        }
                     }
                  }
               }
            }
         }
      }
      
      public function isBattleDebuffActive(param1:String) : Boolean
      {
         if(this.battleDebuff[param1])
         {
            if(this.battleDebuff[param1].duration > 0)
            {
               return true;
            }
         }
         return false;
      }
      
      public function getBattleDebuff() : Object
      {
         return this.battleDebuff;
      }
      
      public function setBattleDebuff(param1:Object) : Boolean
      {
         var _loc2_:int = 0;
         var _loc3_:Number = NaN;
         if(Boolean(param1.resisted) && param1.resisted == true)
         {
            return false;
         }
         if(Central.battle.type == Central.battle.TYPE_LOCAL)
         {
            if(this.isBattleBuffActive(BattleData.EFFECT_PET_DEBUFF_RESIST) && this.checkDebuffCanResist(param1.type))
            {
               _loc2_ = NumberUtil.getRandom();
               _loc3_ = int(this.getBattleBuff()[BattleData.EFFECT_PET_DEBUFF_RESIST].amount) / 100;
               if(_loc2_ < _loc3_)
               {
                  return false;
               }
            }
            if(this.isBattleBuffActive(BattleData.EFFECT_VIGOR) && this.checkDebuffCanResist(param1.type))
            {
               _loc2_ = NumberUtil.getRandom();
               _loc3_ = int(this.getBattleBuff()[BattleData.EFFECT_VIGOR].amount) / 100;
               if(_loc2_ < _loc3_)
               {
                  return false;
               }
            }
         }
         if(this.isBattleBuffActive(BloodlineData.EFFECT_SKIP_DEAD_CLEAR_DEBUFF))
         {
            return false;
         }
         if(this.isBattleBuffActive(BattleData.EFFECT_DEBUFF_RESIST_EX))
         {
            return false;
         }
         Out.debug("setBattleDebuff","_effect >> " + GF.printObject(param1));
         var _loc4_:Object = {};
         _loc4_.type = param1.type;
         _loc4_.duration = Math.round(int(param1.duration) + 0);
         _loc4_.amount = param1.amount + 0;
         if(param1.target != null)
         {
            _loc4_.target = param1.target;
         }
         if(param1.chancetohit != null)
         {
            _loc4_.chancetohit = Math.round(int(param1.chancetohit) + 0);
         }
         if(param1.chancetoeffect != null)
         {
            _loc4_.chancetoeffect = Math.round(int(param1.chancetoeffect) + 0);
         }
         if(param1.requirement != null)
         {
            _loc4_.requirement = param1.requirement;
         }
         if(param1.intmem1 != null)
         {
            _loc4_.intmem1 = param1.intmem1;
         }
         if(param1.intmem2 != null)
         {
            _loc4_.intmem2 = param1.intmem2;
         }
         this.battleDebuff[_loc4_.type] = _loc4_;
         return true;
      }
      
      private function checkDebuffCanResist(param1:String) : Boolean
      {
         switch(param1)
         {
            case BattleData.EFFECT_DAMAGE_DELAY:
            case BattleData.EFFECT_DAMAGE_REDUCTIONA:
            case BattleData.EFFECT_SUSANOOB:
            case BattleData.EFFECT_DAMAGE_BONUSA:
            case BattleData.EFFECT_DAMAGE_DELAY_INJURY:
               return false;
            default:
               return true;
         }
      }
      
      public function removeDebuff(param1:String) : void
      {
         if(this.battleDebuff[param1])
         {
            this.battleDebuff[param1] = null;
         }
      }
      
      public function setActiveDebuff(param1:Object) : void
      {
         this.battleDebuff = param1;
      }
      
      public function clearAllDebuff() : void
      {
         var _loc1_:String = null;
         for(_loc1_ in this.battleDebuff)
         {
            if(this.battleDebuff[_loc1_])
            {
               if(salfLifeSkill.indexOf(_loc1_) >= 0)
               {
                  return;
               }
               if(this.battleDebuff[_loc1_].duration <= BloodlineData.PASSIVE_DEBUFF_IDENTIFIER && _loc1_ != "burn_cnnt_purify" && _loc1_ != "venom")
               {
                  this.battleDebuff[_loc1_] = null;
               }
            }
         }
      }
      
      public function getBloodlineListArr() : Array
      {
         var _loc2_:int = 0;
         var _loc3_:Object = null;
         var _loc4_:Object = null;
         var _loc5_:Object = null;
         var _loc1_:Array = [];
         if(this.dbChar.bloodline == null)
         {
            return [];
         }
         for each(_loc3_ in this.dbChar.bloodline)
         {
            if(Boolean(Central.main.BLOODLINE_SKILL_DATA["bloodline_skill" + _loc3_.skill_id]) && Boolean(Central.main.BLOODLINE_DATA["bloodline" + _loc3_.bloodline_id]))
            {
               _loc4_ = Central.main.BLOODLINE_SKILL_DATA["bloodline_skill" + _loc3_.skill_id];
               _loc5_ = Central.main.BLOODLINE_DATA["bloodline" + _loc3_.bloodline_id];
               if(_loc4_.bloodline_type == BloodlineData.SKILL_TYPE_ACTIVE && _loc5_.type == BloodlineData.SKILL_TYPE_BLOODLINE)
               {
                  _loc1_.push(_loc3_);
               }
               if(_loc4_.bloodline_type == BloodlineData.SKILL_TYPE_PASSIVE && (_loc4_.skill_id == "skill1022" || _loc4_.skill_id == "skill1046"))
               {
                  _loc1_.push(_loc3_);
               }
            }
         }
         return _loc1_;
      }
      
      public function getSenjutsuListArr() : Array
      {
         var _loc2_:int = 0;
         var _loc3_:Object = null;
         var _loc4_:Object = null;
         var _loc1_:Array = [];
         if(this.dbChar.senjutsu == null)
         {
            return [];
         }
         for each(_loc3_ in this.dbChar.senjutsu)
         {
            if(Boolean(Central.main.SENJUTSU_SKILL_DATA["senjutsu_skill" + _loc3_.skill_id]) && Boolean(Central.main.SENJUTSU_DATA["senjutsu" + _loc3_.senjutsu_id]))
            {
               _loc4_ = Central.main.SENJUTSU_SKILL_DATA["senjutsu_skill" + _loc3_.skill_id];
               if(_loc4_.senjutsu_type == SenjutsuData.SKILL_TYPE_ACTIVE)
               {
                  _loc1_.push(_loc3_);
               }
            }
         }
         return _loc1_;
      }
      
      public function reseteffectResistance() : void
      {
         this.effectResistance = [];
      }
      
      public function initResistance() : void
      {
         var _loc1_:String = null;
         var _loc5_:Number = NaN;
         var _loc11_:uint = 0;
         var _loc2_:String = "";
         var _loc3_:String = "";
         var _loc4_:Array = [];
         var _loc6_:Object = {};
         var _loc7_:Array = [];
         var _loc8_:String = "";
         var _loc9_:String = "";
         var _loc10_:Array = [];
         var _loc12_:String = "";
         var _loc13_:Number = 0;
         var _loc14_:Object = {};
         var _loc15_:Array = this.effectResistance;
         var _loc16_:Boolean = false;
         var _loc17_:Number = 0;
         var _loc18_:Boolean = true;
         isStunResistBoo = false;
         if(this.type == TYPE_AICHARACTER)
         {
            _loc17_ = 30;
         }
         for(_loc1_ in this.battleBuff)
         {
            _loc4_ = [];
            _loc2_ = "";
            _loc3_ = "";
            _loc7_ = [];
            _loc8_ = "";
            _loc10_ = [];
            _loc9_ = "";
            _loc12_ = "";
            _loc13_ = 0;
            _loc14_ = {};
            _loc16_ = false;
            if(!this.battleBuff[_loc1_])
            {
               continue;
            }
            if(this.battleBuff[_loc1_].duration <= 0)
            {
               continue;
            }
            _loc4_ = _loc1_.split(".");
            if(_loc4_)
            {
               _loc2_ = _loc4_[0];
               _loc3_ = _loc4_[1];
            }
            if(!(Boolean(_loc2_) && Boolean(this.battleBuff[_loc1_].chancetoeffect) && this.battleBuff[_loc1_].chancetoeffect > 0))
            {
               continue;
            }
            switch(_loc2_)
            {
               case BloodlineData.EFFECT_RESIST_DEBUFF:
                  _loc12_ = this.battleBuff[_loc1_].requirement;
                  _loc13_ = this.battleBuff[_loc1_].amount + _loc17_;
                  _loc14_ = {
                     "type":_loc12_,
                     "change":_loc13_
                  };
                  if(_loc15_)
                  {
                     _loc11_ = 0;
                     while(_loc11_ < _loc15_.length)
                     {
                        if(_loc15_[_loc11_].type == _loc12_)
                        {
                           _loc15_[_loc11_].change = _loc13_;
                           _loc16_ = true;
                        }
                        _loc11_++;
                     }
                  }
                  if(_loc16_ == false)
                  {
                     this.effectResistance.push(_loc14_);
                  }
                  _loc18_ = false;
            }
         }
         for(_loc1_ in this.battleDebuff)
         {
            _loc4_ = [];
            _loc2_ = "";
            _loc3_ = "";
            _loc7_ = [];
            _loc8_ = "";
            _loc10_ = [];
            _loc9_ = "";
            _loc12_ = "";
            _loc13_ = 0;
            _loc14_ = {};
            _loc16_ = false;
            if(!this.battleDebuff[_loc1_])
            {
               continue;
            }
            if(this.battleDebuff[_loc1_].duration <= 0)
            {
               continue;
            }
            _loc4_ = _loc1_.split(".");
            if(_loc4_)
            {
               _loc2_ = _loc4_[0];
               _loc3_ = _loc4_[1];
            }
            if(!(Boolean(_loc2_) && Boolean(this.battleDebuff[_loc1_].chancetoeffect) && this.battleDebuff[_loc1_].chancetoeffect > 0))
            {
               continue;
            }
            switch(_loc2_)
            {
               case BloodlineData.EFFECT_RESIST_DEBUFF:
                  _loc12_ = this.battleDebuff[_loc1_].requirement;
                  _loc13_ = this.battleDebuff[_loc1_].amount + _loc17_;
                  _loc14_ = {
                     "type":_loc12_,
                     "change":_loc13_
                  };
                  if(_loc15_)
                  {
                     _loc11_ = 0;
                     while(_loc11_ < _loc15_.length)
                     {
                        if(_loc15_[_loc11_].type == _loc12_)
                        {
                           _loc15_[_loc11_].change = _loc13_;
                           _loc16_ = true;
                        }
                        _loc11_++;
                     }
                  }
                  if(_loc16_ == false)
                  {
                     this.effectResistance.push(_loc14_);
                  }
                  _loc18_ = false;
            }
         }
         if(_loc18_)
         {
            _loc12_ = BattleData.EFFECT_STUN;
            _loc13_ = _loc17_;
            _loc14_ = {
               "type":_loc12_,
               "change":_loc13_
            };
            this.effectResistance.push(_loc14_);
         }
         _loc5_ = NumberUtil.getRandom();
         _loc11_ = 0;
         while(_loc11_ < effectResistance.length)
         {
            if(_loc5_ < effectResistance[_loc11_].change / 100 && effectResistance[_loc11_].type == BattleData.EFFECT_STUN)
            {
               Out.debug("initResistance :: ","initResistance >> " + _loc5_);
               Out.debug("initResistance :: ","effectResistance[i].change / 100 >> " + effectResistance[_loc11_].change / 100);
               isStunResistBoo = true;
            }
            _loc11_++;
         }
      }
      
      public function isStunResist() : Boolean
      {
         return isStunResistBoo;
      }
      
      public function checkBloodlineresurrection() : Object
      {
         var _loc1_:String = null;
         var _loc5_:Number = NaN;
         var _loc11_:int = 0;
         var _loc2_:String = "";
         var _loc3_:String = "";
         var _loc4_:Array = [];
         var _loc6_:Object = {};
         var _loc7_:Array = [];
         var _loc8_:String = "";
         var _loc9_:String = "";
         var _loc10_:Array = [];
         var _loc12_:Object = {};
         var _loc13_:Number = 0;
         var _loc14_:Number = 0;
         for(_loc1_ in this.battleBuff)
         {
            _loc4_ = [];
            _loc2_ = "";
            _loc3_ = "";
            _loc7_ = [];
            _loc8_ = "";
            _loc10_ = [];
            _loc9_ = "";
            if(!this.battleBuff[_loc1_])
            {
               continue;
            }
            if(this.battleBuff[_loc1_].duration <= 0)
            {
               continue;
            }
            _loc4_ = _loc1_.split(".");
            if(_loc4_)
            {
               _loc2_ = _loc4_[0];
               _loc3_ = _loc4_[1];
            }
            if(!(Boolean(_loc2_) && Boolean(this.battleBuff[_loc1_].chancetoeffect) && this.battleBuff[_loc1_].chancetoeffect > 0))
            {
               continue;
            }
            switch(_loc2_)
            {
               case BloodlineData.EFFECT_RESURRECTION:
                  _loc13_ += int(this.battleBuff[_loc1_].amount / 100 * this.maxHP - this.hp);
                  _loc14_ += int(this.battleBuff[_loc1_].amount / 100 * this.maxCP - this.cp);
                  this.resetBuff();
                  this.battleBuff[_loc1_] = null;
                  this.battleBuff[BloodlineData.EFFECT_COPY_JUTSU + ".skill1023"] = null;
                  this.battleBuff[BloodlineData.EFFECT_REFLECT_GENJUTSU + ".skill1024"] = null;
                  _loc12_["type"] = _loc2_;
                  break;
               case BloodlineData.EFFECT_REBORN:
                  this.battleBuff[_loc1_] = null;
                  _loc13_ += 1;
                  _loc12_["type"] = _loc2_;
            }
         }
         _loc12_["HPRec"] = _loc13_;
         _loc12_["CPRec"] = _loc14_;
         return _loc12_;
      }
      
      public function isClassSkillActive(param1:String) : Boolean
      {
         var _loc2_:int = classSkillList.indexOf(param1);
         return isClassSkillAvailable[_loc2_];
      }
   }
}

