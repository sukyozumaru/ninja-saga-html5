package ninjasaga.battle
{
   import com.utils.GF;
   import com.utils.NumberUtil;
   import com.utils.Out;
   import flash.events.Event;
   import ninjasaga.Account;
   import ninjasaga.Central;
   import ninjasaga.data.*;
   import ninjasaga.loader.AssetLoader;
   
   public final class BattleProcessor
   {
      
      private static var instance:BattleProcessor;
      
      public static var HHPP:int = 0;
      
      public static var showOHN_chaos:Boolean = false;
      
      private var characterArr:Array = [];
      
      private var petArr:Array = [];
      
      private var attacker:*;
      
      private var defender:*;
      
      private var attackerWeapon:*;
      
      private var attackerBackItem:*;
      
      private var attackerAccessory:*;
      
      private var initialized:Boolean = false;
      
      private var roundObj:Object;
      
      private var actionLimited:int = 0;
      
      public var backItemMaxEffectNum:int = 3;
      
      private var deductCP:Boolean = false;
      
      private var cancntpurlfyburn:Boolean = false;
      
      private var canburn:Boolean = false;
      
      private var candoburn:Boolean = false;
      
      private var canburnnum:Boolean = false;
      
      private var canburning:Boolean = false;
      
      private var canpetburn:Boolean = false;
      
      public var thisbattleround:int;
      
      public var attackerplayer:Boolean = false;
      
      public var battleandaction:String;
      
      private var freezeskill:Boolean = false;
      
      private var HpCondition:Boolean = false;
      
      private var CpCondition:Boolean = false;
      
      public var skipBattleTurn:Boolean = false;
      
      private var battleMemVariables:Object;
      
      internal var adminArr:Array = [30714278,30714554,47864495,44490146,62299565,62543662,64183147,66966519];
      
      public function BattleProcessor(param1:InstanceBlocker)
      {
         super();
         if(param1 == null)
         {
            throw new Error("Error: [BattleProcessor] Instantiation failed: Use Client.getInstance() instead of new.");
         }
      }
      
      public static function getInstance() : BattleProcessor
      {
         if(instance == null)
         {
            instance = new BattleProcessor(new InstanceBlocker());
         }
         return instance;
      }
      
      public static function destroyInstance() : void
      {
         instance = null;
      }
      
      public static function findEffectObjectInList(param1:Object, param2:String) : *
      {
         var _loc3_:Object = null;
         var _loc5_:String = null;
         if(param2 == null || param2 == "")
         {
            return null;
         }
         var _loc4_:Object = null;
         for(_loc5_ in param1)
         {
            _loc3_ = param1[_loc5_];
            if(Boolean(_loc3_) && Boolean(_loc3_ is Object) && _loc3_.type == param2)
            {
               _loc4_ = _loc3_;
               break;
            }
         }
         return _loc4_;
      }
      
      public function init() : void
      {
         if(this.initialized == true)
         {
            return;
         }
         var _loc1_:int = 0;
         this.characterArr.push(Central.main.getMainChar());
         var _loc2_:Array = Central.battle.enemyArr;
         _loc1_ = 0;
         while(_loc1_ < _loc2_.length)
         {
            this.characterArr.push(_loc2_[_loc1_]);
            _loc1_++;
         }
         var _loc3_:Array = Central.battle.partyArr;
         if(_loc3_ != null)
         {
            _loc1_ = 0;
            while(_loc1_ < _loc3_.length)
            {
               this.characterArr.push(_loc3_[_loc1_]);
               _loc1_++;
            }
         }
         var _loc4_:Array = Central.battle.petArr;
         if(_loc4_ != null)
         {
            _loc1_ = 0;
            while(_loc1_ < _loc4_.length)
            {
               this.petArr.push(_loc4_[_loc1_]);
               _loc1_++;
            }
         }
         thisbattleround = -1;
         Central.main.battleFlowLog.battles[Central.main.battleround] = {
            "start_log":String,
            "step_log":Array,
            "step":int,
            "enemyid":Array
         };
         Central.main.battleFlowLog.battles[Central.main.battleround].start_log = Central.main.getMainChar().getWeapon() + "," + Central.main.getMainChar().getBackItem() + "," + Central.main.getMainChar().getAccessory();
         Central.main.battleFlowLog.battles[Central.main.battleround].step_log = [];
         Central.main.battleFlowLog.battles[Central.main.battleround].enemyid = [];
         _loc1_ = 0;
         while(_loc1_ < Central.main.battleFlowLogenemy.length)
         {
            Central.main.battleFlowLog.battles[Central.main.battleround].enemyid.push(Central.main.battleFlowLogenemy[_loc1_].swfName);
            _loc1_++;
         }
         this.initialized = true;
      }
      
      public function getAttacker() : *
      {
         return this.attacker;
      }
      
      public function setDefenderById(param1:int) : void
      {
         var _loc2_:uint = 0;
         _loc2_ = 0;
         while(_loc2_ < this.characterArr.length)
         {
            if(this.characterArr[_loc2_].getCharacterId() == param1)
            {
               this.defender = this.characterArr[_loc2_];
               return;
            }
            _loc2_++;
         }
         if(petArr)
         {
            _loc2_ = 0;
            while(_loc2_ < petArr.length)
            {
               if(petArr[_loc2_].getCharacterId() == param1)
               {
                  this.defender = petArr[_loc2_];
                  return;
               }
               _loc2_++;
            }
         }
      }
      
      public function getDefender() : *
      {
         return this.defender;
      }
      
      public function characterTurn(param1:String, param2:uint) : Boolean
      {
         var _loc3_:uint = 0;
         Out.debug(this,"characterTurn :: _type " + param1 + " :: _id " + param2);
         this.attacker = null;
         this.defender = null;
         switch(param1)
         {
            case "player":
               _loc3_ = 0;
               while(_loc3_ < characterArr.length)
               {
                  if(param2 == characterArr[_loc3_].getCharacterId())
                  {
                     attacker = characterArr[_loc3_];
                     ++thisbattleround;
                     attackerplayer = true;
                     break;
                  }
                  _loc3_++;
               }
               break;
            case "enemy":
               _loc3_ = 0;
               while(_loc3_ < characterArr.length)
               {
                  if(param2 == characterArr[_loc3_].getCharacterId())
                  {
                     attacker = characterArr[_loc3_];
                     attackerplayer = false;
                     break;
                  }
                  _loc3_++;
               }
               break;
            case "party":
               _loc3_ = 0;
               while(_loc3_ < characterArr.length)
               {
                  if(param2 == characterArr[_loc3_].getCharacterId())
                  {
                     attacker = characterArr[_loc3_];
                     attackerplayer = false;
                     break;
                  }
                  _loc3_++;
               }
               break;
            case "pet":
               _loc3_ = 0;
               while(_loc3_ < petArr.length)
               {
                  if(param2 == petArr[_loc3_].getData(DBCharacterData.ID))
                  {
                     attacker = petArr[_loc3_];
                     attackerplayer = false;
                     break;
                  }
                  _loc3_++;
               }
         }
         this.attackerWeapon = null;
         this.attackerBackItem = null;
         this.attackerAccessory = null;
         if(attacker)
         {
            if(this.attacker.getWeapon())
            {
               this.attackerWeapon = Central.main.WEAPON_DATA.find(this.attacker.getWeapon());
            }
            if(this.attacker.getBackItem())
            {
               this.attackerBackItem = Central.main.BACK_ITEM_DATA.find(this.attacker.getBackItem());
            }
            if(this.attacker.getAccessory())
            {
               this.attackerAccessory = Central.main.BACK_ITEM_DATA.find(this.attacker.getAccessory());
            }
         }
         this.defender = this.attacker;
         this.checkSkipBattleTurn();
         if(this.attacker.isDead == true)
         {
            return false;
         }
         return true;
      }
      
      private function checkSkipBattleTurn() : void
      {
         Out.debug(this,"checkSkipBattleTurn");
         if(this.attacker.isBattleDebuffActive(SenjutsuData.EFFECT_SS_SKIP_BATTLE_TURN))
         {
            this.skipBattleTurn = true;
            Out.debug(this,"need SkipBattleTurn");
            this.attacker.getBattleDebuff()[SenjutsuData.EFFECT_SS_SKIP_BATTLE_TURN] = null;
         }
      }
      
      public function nextRound() : Object
      {
         var _loc1_:int = 0;
         Out.debug(this,"nextRound");
         this.roundObj = {};
         this.roundObj.restore = {
            "hp":0,
            "cp":0,
            "arr":[]
         };
         this.roundObj.buff = [];
         this.roundObj.debuff = [];
         this.roundObj.buff = this.checkBuff(this.attacker);
         this.checkBuffEffect(this.attacker,this.roundObj.buff);
         this.attacker.reduceSkillCooldown(1);
         this.updateRoundBuff(this.attacker);
         this.updateRoundDebuff(this.attacker);
         this.roundObj.purify = this.checkPurify(this.attacker);
         this.checkAgility(this.attacker);
         this.checkRestore(this.attacker);
         if(int(this.attacker.getData(DBCharacterData.RANK)) >= 8 && !this.attacker.isBattleBuffActive(SenjutsuData.EFFECT_SENNIN_MODE))
         {
            this.attacker.updateSPstatus(SenjutsuData.SP_UPDATE_ROUND);
            this.attacker.updateSPstatus(SenjutsuData.SP_UPDATE_EXTRA,calcSenjutsuRecoverSPBonus(0,this.attacker.getBattleBuff(),this.attacker.getBattleDebuff(),this.defender.getBattleBuff(),this.defender.getBattleDebuff(),SenjutsuData.STATUS_ROUND_START));
         }
         Out.debug("","nextRound=" + GF.printObject(this.roundObj));
         return this.roundObj;
      }
      
      private function updateRoundBuff(param1:*) : void
      {
         var _loc2_:Object = null;
         var _loc4_:Object = null;
         var _loc5_:String = null;
         var _loc6_:int = 0;
         _loc2_ = param1.getBattleBuff();
         var _loc3_:Object = {};
         for(_loc5_ in _loc2_)
         {
            if(!_loc2_[_loc5_])
            {
               continue;
            }
            _loc4_ = _loc2_[_loc5_];
            if(_loc4_.duration <= BloodlineData.PASSIVE_BUFF_IDENTIFIER)
            {
               --_loc4_.duration;
            }
            if(int(_loc4_.duration) > 0)
            {
               _loc3_[_loc5_] = _loc4_;
               continue;
            }
            switch(_loc5_)
            {
               case BattleData.EFFECT_GATE_OPENING:
                  _loc4_ = {
                     "type":BattleData.EFFECT_STUN,
                     "duration":2
                  };
                  this.roundObj.debuff.push(_loc4_);
                  break;
               case BattleData.EFFECT_DAMAGE_DELAY:
                  _loc6_ = int(_loc2_[_loc5_].intmem1);
                  _loc6_ = this.updateHP(param1,_loc6_);
                  this.roundObj.restore.arr.push({
                     "type":_loc5_,
                     "hp":_loc6_
                  });
                  _loc4_ = {
                     "type":BattleData.EFFECT_DAMAGE_DELAY_INJURY,
                     "duration":3,
                     "amount":100
                  };
                  this.roundObj.debuff.push(this.setDebuff(this.attacker,_loc4_));
            }
         }
         param1.setActiveBuff(_loc3_);
      }
      
      private function updateRoundDebuff(param1:*) : void
      {
         var _loc4_:Object = null;
         var _loc5_:int = 0;
         var _loc6_:String = null;
         var _loc2_:Object = param1.getBattleDebuff();
         var _loc3_:Object = {};
         for(_loc6_ in _loc2_)
         {
            _loc4_ = _loc2_[_loc6_];
            if(_loc2_[_loc6_])
            {
               if(_loc4_.type == BattleData.EFFECT_ACCUM_BLEEDING)
               {
                  _loc4_.amount += _loc4_.duration;
                  _loc3_[_loc6_] = _loc4_;
               }
               else
               {
                  if(_loc4_.duration <= BloodlineData.PASSIVE_DEBUFF_IDENTIFIER)
                  {
                     --_loc4_.duration;
                  }
                  if(int(_loc4_.duration) > 0)
                  {
                     _loc3_[_loc6_] = _loc4_;
                  }
               }
            }
         }
         if(_loc2_[SenjutsuData.EFFECT_SS_DIVIDE_CHAOS])
         {
            if(_loc2_[SenjutsuData.EFFECT_SS_DIVIDE_CHAOS].duration % 2 == 1)
            {
               _loc4_ = {
                  "type":BattleData.EFFECT_CHAOS,
                  "duration":1
               };
               _loc3_[BattleData.EFFECT_CHAOS] = _loc4_;
            }
         }
         param1.setActiveDebuff(_loc3_);
      }
      
      private function checkPurify(param1:*) : Object
      {
         var _loc5_:Object = null;
         var _loc6_:Object = null;
         var _loc7_:Object = null;
         var _loc8_:Object = null;
         var _loc9_:Object = null;
         var _loc10_:String = null;
         var _loc11_:Object = null;
         var _loc12_:int = 0;
         var _loc13_:Object = null;
         var _loc2_:Number = int(param1.getData(DBCharacterData.WATER)) * 4 / 1000;
         var _loc3_:Number = NumberUtil.getRandom();
         var _loc4_:Object = {};
         _loc4_.restoreHp = 0;
         if(param1.getWeapon())
         {
            _loc6_ = Central.main.WEAPON_DATA.find(param1.getWeapon());
            if(_loc6_)
            {
               for each(_loc5_ in _loc6_.effect)
               {
                  switch(_loc5_.type)
                  {
                     case BattleData.EFFECT_ADD_PURIFY_CHANCE:
                        _loc2_ += _loc5_.amount / 100;
                  }
               }
            }
         }
         if(param1.getBackItem())
         {
            _loc7_ = Central.main.BACK_ITEM_DATA.find(param1.getBackItem());
            if(_loc7_)
            {
               for each(_loc5_ in _loc7_.effect)
               {
                  switch(_loc5_.type)
                  {
                     case BattleData.EFFECT_ADD_PURIFY_CHANCE:
                        _loc2_ += _loc5_.amount / 100;
                  }
               }
            }
         }
         if(param1.getAccessory())
         {
            _loc8_ = Central.main.ACCESSORY_DATA.find(param1.getAccessory());
            if(_loc8_)
            {
               for each(_loc5_ in _loc8_.effect)
               {
                  switch(_loc5_.type)
                  {
                     case BattleData.EFFECT_ADD_PURIFY_CHANCE:
                        _loc2_ += _loc5_.amount / 100;
                  }
               }
            }
         }
         if(param1.getBloodlineEffect())
         {
            for each(_loc5_ in param1.getBloodlineEffect())
            {
               switch(_loc5_.type)
               {
                  case BloodlineData.EFFECT_ADD_PURIFY_CHANCE_OVER_CP:
                     if(param1.cp >= _loc5_.amount)
                     {
                        _loc2_ += int(param1.maxCP / _loc5_.amount) * _loc5_.chancetoeffect * 0.01;
                     }
               }
            }
         }
         if(param1.getGearset())
         {
            _loc9_ = param1.getGearset();
            for(_loc10_ in _loc9_)
            {
               _loc11_ = Central.main.GEAR_SET_DATA.find(_loc10_);
               _loc12_ = 0;
               while(_loc12_ < _loc9_[_loc10_] - 1)
               {
                  _loc13_ = _loc11_.effect[_loc12_];
                  switch(_loc13_.type)
                  {
                     case BattleData.EFFECT_ADD_PURIFY_CHANCE:
                        _loc2_ += _loc13_.amount * 0.01;
                  }
                  _loc12_++;
               }
            }
         }
         if(param1.isBattleBuffActive(BattleData.EFFECT_ADD_PURIFY_CHANCE))
         {
            _loc2_ += int(param1.getBattleBuff()[BattleData.EFFECT_ADD_PURIFY_CHANCE].amount) / 100;
         }
         if(param1.isBattleBuffActive(BattleData.EFFECT_PET_ENERGIZE))
         {
            _loc2_ += int(param1.getBattleBuff()[BattleData.EFFECT_PET_ENERGIZE].amount) / 100;
         }
         if(param1.isBattleDebuffActive(BattleData.EFFECT_PET_DISORIENTED))
         {
            _loc2_ -= int(param1.getBattleDebuff()[BattleData.EFFECT_PET_DISORIENTED].amount) / 100;
         }
         if(param1.isBattleDebuffActive(BattleData.SKILL_342))
         {
            _loc2_ -= int(param1.getBattleDebuff()[BattleData.SKILL_342].amount) / 100;
         }
         if(param1.isBattleDebuffActive(BattleData.SKILL_253))
         {
            _loc2_ -= int(param1.getBattleDebuff()[BattleData.SKILL_253].amount) / 100;
         }
         if(param1.isBattleDebuffActive(BattleData.EFFECT_REDUCE_PURIFY_CHANCE))
         {
            _loc2_ -= int(param1.getBattleDebuff()[BattleData.EFFECT_REDUCE_PURIFY_CHANCE].amount) / 100;
         }
         if(param1.isBattleBuffActive(BattleData.EFFECT_PURIFY_BELOW_CP))
         {
            if(param1.cp <= param1.getBattleBuff()[BattleData.EFFECT_PURIFY_BELOW_CP].amount * 0.01 * param1.maxCP)
            {
               _loc2_ = 1;
               _loc3_ = 0;
            }
         }
         if(_loc2_ >= _loc3_)
         {
            param1.clearAllDebuff();
            if(_loc6_)
            {
               for each(_loc5_ in _loc6_.effect)
               {
                  switch(_loc5_.type)
                  {
                     case BattleData.EFFECT_PURIFY_RESTORE_HP:
                        _loc4_.restoreHp = Math.round(int(param1.maxHP) * (_loc5_.amount / 100));
                  }
               }
            }
            if(_loc7_)
            {
               for each(_loc5_ in _loc7_.effect)
               {
                  switch(_loc5_.type)
                  {
                     case BattleData.EFFECT_PURIFY_RESTORE_HP:
                        _loc4_.restoreHp = Math.round(int(param1.maxHP) * (_loc5_.amount / 100));
                  }
               }
            }
            if(_loc8_)
            {
               for each(_loc5_ in _loc8_.effect)
               {
                  switch(_loc5_.type)
                  {
                     case BattleData.EFFECT_PURIFY_RESTORE_HP:
                        _loc4_.restoreHp = Math.round(int(param1.maxHP) * (_loc5_.amount / 100));
                  }
               }
            }
            if(_loc4_.restoreHp > 0)
            {
               _loc4_.restoreHp = this.updateHP(param1,_loc4_.restoreHp);
            }
            _loc4_.purify = true;
            return _loc4_;
         }
         return null;
      }
      
      private function checkRestore(param1:*) : void
      {
         var _loc4_:Number = NaN;
         var _loc5_:String = null;
         var _loc6_:Object = null;
         var _loc11_:Array = null;
         var _loc12_:String = null;
         var _loc14_:Object = null;
         var _loc15_:Object = null;
         var _loc16_:Object = null;
         var _loc17_:Object = null;
         var _loc18_:Object = null;
         var _loc19_:Object = null;
         var _loc20_:Object = null;
         var _loc21_:int = 0;
         var _loc22_:Object = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:Object = null;
         var _loc10_:Boolean = true;
         if(param1.isBattleBuffActive(BloodlineData.EFFECT_SKIP_DEAD_CLEAR_DEBUFF))
         {
            param1.clearAllDebuff();
            return;
         }
         if(param1.getWeapon())
         {
            _loc16_ = Central.main.WEAPON_DATA.find(param1.getWeapon());
            if(_loc16_)
            {
               for each(_loc15_ in _loc16_.effect)
               {
                  switch(_loc15_.type)
                  {
                     case BattleData.EFFECT_ADD_HP_AMOUNT:
                        _loc2_ += _loc15_.amount;
                        break;
                     case BattleData.EFFECT_ADD_HP_AMOUNT_PRESENT:
                        if(NumberUtil.getRandom() <= _loc15_.chance / 100)
                        {
                           _loc2_ += Math.round(param1.maxHP * (_loc15_.amount / 100));
                        }
                        break;
                     case BattleData.EFFECT_ADD_CP_AMOUNT_PRESENT:
                        if(NumberUtil.getRandom() <= _loc15_.chance / 100)
                        {
                           _loc3_ += Math.round(param1.maxCP * (_loc15_.amount / 100));
                        }
                        break;
                     case BattleData.EFFECT_ADD_CP_BELOW_CP:
                        if(param1.cp < Math.round(param1.maxCP * (_loc15_.chance / 100)))
                        {
                           _loc3_ += Math.round(param1.maxCP * (_loc15_.amount / 100));
                        }
                        break;
                     case BattleData.EFFECT_ADD_HP_BELOW_CP:
                        if(param1.cp < Math.round(param1.maxCP * (_loc15_.chance / 100)))
                        {
                           _loc2_ += Math.round(param1.maxHP * (_loc15_.amount / 100));
                        }
                  }
               }
            }
         }
         if(param1.getBackItem())
         {
            _loc17_ = Central.main.BACK_ITEM_DATA.find(param1.getBackItem());
            if(_loc17_)
            {
               for each(_loc15_ in _loc17_.effect)
               {
                  switch(_loc15_.type)
                  {
                     case BattleData.EFFECT_ADD_HP_AMOUNT:
                        _loc2_ += _loc15_.amount;
                        break;
                     case BattleData.EFFECT_ADD_CP_AMOUNT:
                        _loc3_ += _loc15_.amount;
                        break;
                     case BattleData.EFFECT_ADD_HP_AMOUNT_PRESENT:
                        if(NumberUtil.getRandom() <= _loc15_.chance / 100)
                        {
                           _loc2_ += Math.round(param1.maxHP * (_loc15_.amount / 100));
                        }
                        break;
                     case BattleData.EFFECT_ADD_CP_AMOUNT_PRESENT:
                        if(NumberUtil.getRandom() <= _loc15_.chance / 100)
                        {
                           _loc3_ += Math.round(param1.maxCP * (_loc15_.amount / 100));
                        }
                        break;
                     case BattleData.EFFECT_REWIND:
                        if(NumberUtil.getRandom() <= _loc15_.chance / 100)
                        {
                           param1.reduceSkillCooldown(_loc15_.amount,BattleData.REDUCETYPE_ALL);
                        }
                        break;
                     case BattleData.EFFECT_ADD_CP_BELOW_CP:
                        if(param1.cp < Math.round(param1.maxCP * (_loc15_.chance / 100)))
                        {
                           _loc3_ += Math.round(param1.maxCP * (_loc15_.amount / 100));
                        }
                  }
               }
            }
         }
         if(param1.getAccessory())
         {
            _loc18_ = Central.main.ACCESSORY_DATA.find(param1.getAccessory());
            if(_loc18_)
            {
               for each(_loc15_ in _loc18_.effect)
               {
                  switch(_loc15_.type)
                  {
                     case BattleData.EFFECT_ADD_HP_AMOUNT:
                        _loc2_ += _loc15_.amount;
                        break;
                     case BattleData.EFFECT_ADD_CP_AMOUNT:
                        _loc3_ += _loc15_.amount;
                        break;
                     case BattleData.EFFECT_ADD_HP_AMOUNT_PRESENT:
                        if(NumberUtil.getRandom() <= _loc15_.chance / 100)
                        {
                           _loc2_ += Math.round(param1.maxHP * (_loc15_.amount / 100));
                        }
                        break;
                     case BattleData.EFFECT_ADD_CP_AMOUNT_PRESENT:
                        if(NumberUtil.getRandom() <= _loc15_.chance / 100)
                        {
                           _loc3_ += Math.round(param1.maxCP * (_loc15_.amount / 100));
                        }
                        break;
                     case BattleData.EFFECT_REWIND:
                        if(NumberUtil.getRandom() <= _loc15_.chance / 100)
                        {
                           param1.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(800));
                           param1.reduceSkillCooldown(_loc15_.amount,BattleData.REDUCETYPE_SKILL);
                        }
                  }
               }
            }
         }
         if(param1.getBloodlineEffect())
         {
            for each(_loc15_ in param1.getBloodlineEffect())
            {
               switch(_loc15_.type)
               {
                  case BloodlineData.EFFECT_ADD_HP_PASSIVE:
                     _loc2_ += _loc15_.amount;
                     break;
                  case BloodlineData.EFFECT_HP_BELOW_CP:
                     if(param1.hp < Math.round(param1.maxHP * _loc15_.chancetohit * 0.01))
                     {
                        _loc2_ += _loc15_.amount;
                     }
                     break;
                  case BloodlineData.EFFECT_RESTORE_CP_LT_CPP:
                     if(param1.cp < Math.round(param1.maxCP * _loc15_.chancetoeffect * 0.01))
                     {
                        _loc3_ += param1.maxCP * _loc15_.amount * 0.01;
                     }
               }
            }
         }
         if(param1.getGearset())
         {
            _loc19_ = param1.getGearset();
            for(_loc5_ in _loc19_)
            {
               _loc20_ = Central.main.GEAR_SET_DATA.find(_loc5_);
               _loc21_ = 0;
               while(_loc21_ < _loc19_[_loc5_] - 1)
               {
                  _loc22_ = _loc20_.effect[_loc21_];
                  switch(_loc22_.type)
                  {
                     case BattleData.EFFECT_ADD_CP_AMOUNT:
                        _loc3_ += Math.round(_loc22_.amount);
                        break;
                     case BattleData.EFFECT_ADD_CP_AMOUNT_PRESENT:
                        _loc3_ += Math.round(param1.maxCP * _loc22_.amount * 0.01);
                        break;
                     case BattleData.EFFECT_ADD_HP_AMOUNT_PRESENT:
                        _loc2_ += Math.round(param1.maxHP * _loc22_.amount * 0.01);
                        break;
                     case BattleData.EFFECT_ADD_HP_AMOUNT:
                        _loc2_ += _loc22_.amount;
                  }
                  _loc21_++;
               }
            }
         }
         _loc2_ = this.updateHP(param1,_loc2_);
         _loc3_ = this.updateCP(param1,_loc3_);
         this.roundObj.restore.hp += _loc2_;
         this.roundObj.restore.cp += _loc3_;
         var _loc13_:Object = param1.getBattleBuff();
         for(_loc5_ in _loc13_)
         {
            if(_loc13_[_loc5_])
            {
               _loc6_ = _loc13_[_loc5_];
               _loc7_ = 0;
               _loc8_ = 0;
               _loc9_ = null;
               _loc10_ = true;
               switch(_loc5_)
               {
                  case BattleData.EFFECT_REGENERATE_CHAKRA:
                     _loc8_ += Math.round(param1.maxCP * (int(_loc6_.amount) / 100));
                     break;
                  case BattleData.EFFECT_TURKEY_FEAST:
                     _loc7_ += Math.round(param1.maxHP * (13 / 100));
                     break;
                  case BattleData.EFFECT_REGENERATE_HP:
                     _loc7_ += Math.round(param1.maxHP * (int(_loc6_.amount) / 100));
                     break;
                  case BattleData.EFFECT_SKILL_899:
                     _loc8_ -= Math.round(param1.maxCP * (int(_loc6_.amount) * 5 / 100));
                     this.attacker.showOverheadNumber(Timeline.WORD,_loc8_ + "CP");
                     break;
                  case BattleData.EFFECT_WIND_PEACE_SINGLE:
                  case BattleData.EFFECT_WIND_PEACE:
                  case BattleData.EFFECT_WIND_PEACE_2:
                     _loc8_ += Math.round(param1.maxCP * (8 / 100));
                     break;
                  case BattleData.EFFECT_WIND_PEACE_3:
                  case BattleData.EFFECT_WIND_PEACE_4:
                     _loc8_ += Math.round(param1.maxCP * (9 / 100));
                     break;
                  case BattleData.EFFECT_REWIND:
                     this.attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(800));
                     param1.reduceSkillCooldown(_loc6_.amount,BattleData.REDUCETYPE_SKILL);
                     break;
                  case BattleData.EFFECT_SKILL_899:
                     this.attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(800));
                     param1.reduceRandomSkillCooldown(_loc6_.amount);
                     break;
                  case BattleData.SKILL_335:
                     _loc7_ += Math.round(param1.maxHP * 0.08);
                     break;
                  case BattleData.EFFECT_DAMAGE_REDUCE_N_HEAL:
                     _loc7_ += Math.round(param1.maxHP * 0.06);
                     break;
                  case BattleData.EFFECT_CATALYTIC_MATTER:
                     _loc7_ -= Math.round(param1.maxHP * (2 / 100));
                     break;
                  case BattleData.EFFECT_DODGE_BONUS_N_HEAL:
                     _loc7_ += Math.round(param1.maxHP * 0.05);
                     break;
                  case BattleData.EFFECT_PET_HEAL:
                     _loc10_ = false;
                     _loc7_ = Math.round(param1.maxHP * (int(_loc6_.amount) / 100));
                     _loc7_ = this.updateHP(param1,_loc7_);
                     this.roundObj.restore.arr.push({
                        "type":_loc5_,
                        "hp":_loc7_,
                        "cp":_loc8_
                     });
                     break;
                  case BattleData.EFFECT_GATE_OPENING:
                     _loc7_ -= Math.round(param1.maxHP * 0.02);
                     break;
                  case BattleData.EFFECT_HEAL_OVER_TIME:
                  case BattleData.EFFECT_HEAL_OVER_TIME_NPC:
                     _loc7_ += Math.round(param1.maxHP * (int(_loc6_.amount) / 100));
                     param1.clearAllDebuff();
                     break;
                  case BattleData.EFFECT_HEAL_OVER_TIME_FIX_NUM:
                     _loc7_ += int(_loc6_.amount);
                     param1.clearAllDebuff();
                     break;
                  case BattleData.SKILL_234:
                  case BattleData.EFFECT_DAMAGE_DELAY:
                     param1.clearAllDebuff();
                     break;
                  case BattleData.EFFECT_HEAL_OVER_TIME_FIX_NUM_DARKNESS:
                     _loc7_ += int(_loc6_.amount);
                     break;
                  case BattleData.EFFECT_HEAL_HP_N_DMG_BONUS:
                  case BattleData.EFFECT_HEAL_HP_N_DMG_BONUS_GASHADOKURO:
                     _loc7_ += 250;
                     break;
                  case BattleData.EFFECT_HEAL_HP_N_DMG_BONUS_UPGRADE:
                     _loc7_ += 550;
               }
               _loc9_ = {
                  "type":_loc5_,
                  "hp":_loc7_,
                  "cp":_loc8_
               };
               _loc11_ = _loc5_.split(".");
               _loc12_ = null;
               if(_loc11_ != null)
               {
                  _loc12_ = _loc11_[0];
               }
               if(_loc12_ != null && _loc6_.chancetoeffect != null && int(_loc6_.chancetoeffect) > 0)
               {
                  _loc4_ = NumberUtil.getRandom();
                  if(_loc4_ <= int(_loc6_.chancetoeffect) / 100)
                  {
                     switch(_loc12_)
                     {
                        case BloodlineData.EFFECT_BL_UPDATE_HP_FIX_NUM:
                           _loc7_ += int(_loc6_.amount);
                     }
                  }
                  _loc5_ = _loc12_;
                  _loc9_ = {
                     "type":_loc5_,
                     "hp":_loc7_,
                     "cp":_loc8_
                  };
               }
               if(_loc10_)
               {
                  _loc9_.hp = this.updateHP(param1,_loc9_.hp) + 0;
                  _loc9_.cp = this.updateCP(param1,_loc9_.cp) + 0;
                  this.roundObj.restore.arr.push(_loc9_);
               }
            }
         }
         _loc14_ = param1.getBattleDebuff();
         for(_loc5_ in _loc14_)
         {
            if(_loc14_[_loc5_])
            {
               _loc6_ = _loc14_[_loc5_];
               _loc7_ = 0;
               _loc8_ = 0;
               _loc9_ = null;
               _loc10_ = true;
               Out.debug("[rockman","battle processor -> check restore -> key in battleDebuff >> key = " + _loc5_);
               switch(_loc5_)
               {
                  case BattleData.EFFECT_BURN_CNNT_PURIFY:
                  case BattleData.EFFECT_BURN:
                     _loc7_ = 0 - Math.round(param1.maxHP * (int(_loc6_.amount) / 100));
                     break;
                  case BattleData.EFFECT_TEARING:
                     _loc7_ = 0 - Math.round(param1.maxHP * (int(_loc6_.amount) / 100));
                     break;
                  case BattleData.EFFECT_BURN_FIX_NUM:
                     _loc7_ = 0 - Math.round(int(_loc6_.amount));
                     break;
                  case BattleData.EFFECT_DAMAGE_HP_FIX_NUM:
                     _loc7_ = 0 - Math.round(int(_loc6_.amount));
                     break;
                  case BattleData.EFFECT_DOUBLE_BURN:
                     _loc7_ = 0 - Math.round(param1.maxHP * (int(_loc6_.amount) / 200));
                     break;
                  case BattleData.EFFECT_POISON:
                  case BattleData.EFFECT_PARASITE:
                  case BattleData.EFFECT_BURNING:
                  case BattleData.EFFECT_JUTSU_POISON:
                  case BattleData.EFFECT_PET_BURN:
                  case BattleData.SKILL_377:
                  case BattleData.EFFECT_DOT_HP:
                  case BattleData.EFFECT_CLEARBUFF_REDUCE_HP:
                  case BattleData.EFFECT_ULTRA_BURNING:
                  case BattleData.EFFECT_VENOM:
                  case BattleData.EFFECT_BLOODY_MIST:
                     _loc7_ = 0 - Math.round(param1.maxHP * (int(_loc6_.amount) / 100));
                     break;
                  case BattleData.EFFECT_BLAZING:
                     _loc7_ = 0 - Math.round(param1.maxHP * (int(_loc6_.amount) / 100));
                     param1.getBattleDebuff()[BattleData.EFFECT_BLAZING].amount = param1.getBattleDebuff()[BattleData.EFFECT_BLAZING].amount + 1;
                     break;
                  case BattleData.EFFECT_CLEARBUFF_REDUCE_CP:
                     _loc8_ = 0 - Math.round(param1.maxCP * (int(_loc6_.amount) / 100));
                     break;
                  case BattleData.EFFECT_FLAME:
                     _loc7_ = 0 - Math.round(param1.maxHP * (int(_loc6_.amount) / 100));
                     _loc8_ = 0 - Math.round(param1.maxCP * (int(_loc6_.amount) / 100));
                     break;
                  case BattleData.EFFECT_SOUL_CHAINS_BUNDLE:
                     _loc7_ = 0 - int(_loc6_.amount);
                     break;
                  case BattleData.EFFECT_COLLIDING_WAVE:
                  case BattleData.EFFECT_REDUCE_HP_CP:
                  case BattleData.EFFECT_CLEARBUFF_REDUCE_HP_CP:
                     _loc7_ = 0 - Math.round(param1.maxHP * (_loc6_.amount / 100));
                     _loc8_ = 0 - Math.round(param1.maxCP * (_loc6_.amount / 100));
               }
               _loc9_ = {
                  "type":_loc5_,
                  "hp":_loc7_,
                  "cp":_loc8_
               };
               _loc11_ = _loc5_.split(".");
               _loc12_ = null;
               if(_loc11_ != null)
               {
                  _loc12_ = _loc11_[0];
               }
               if(_loc12_ != null && _loc6_.chancetoeffect != null && int(_loc6_.chancetoeffect) > 0)
               {
                  _loc4_ = NumberUtil.getRandom();
                  if(_loc4_ <= int(_loc6_.chancetoeffect) / 100)
                  {
                     switch(_loc12_)
                     {
                        case BloodlineData.EFFECT_UPDATE_HP:
                           _loc7_ = Math.round(param1.maxHP * (int(_loc6_.amount) / 100));
                           break;
                        case BloodlineData.EFFECT_UPDATE_CP:
                           _loc8_ = Math.round(param1.maxCP * (int(_loc6_.amount) / 100));
                     }
                  }
                  _loc5_ = _loc12_;
                  _loc9_ = {
                     "type":_loc5_,
                     "hp":_loc7_,
                     "cp":_loc8_,
                     "skill":_loc11_[1]
                  };
               }
               if(_loc10_)
               {
                  _loc9_.hp = this.updateHP(param1,_loc9_.hp) + 0;
                  _loc9_.cp = this.updateCP(param1,_loc9_.cp) + 0;
                  this.roundObj.restore.arr.push(_loc9_);
               }
            }
         }
      }
      
      private function checkAgility(param1:*) : void
      {
         Out.debug(this,"checkAgility :: agility >> " + param1.agility);
         Out.debug(this,"checkAgility :: character_id >> " + param1.getData("character_id"));
         var _loc2_:int = int(param1.agility);
         if(param1.isBattleDebuffActive(BattleData.EFFECT_REDUCE_AGILITY))
         {
            _loc2_ -= Math.round(_loc2_ * int(param1.getBattleDebuff()[BattleData.EFFECT_REDUCE_AGILITY].amount) * 0.01);
            if(_loc2_ < 10)
            {
               _loc2_ = 10;
            }
         }
         if(param1.isBattleBuffActive(BattleData.EFFECT_AGILITY_BONUS_FIX))
         {
            _loc2_ += param1.getBattleBuff()[BattleData.EFFECT_AGILITY_BONUS_FIX].amount;
         }
         if(param1.isBattleBuffActive(BattleData.EFFECT_SKILL_899))
         {
            _loc2_ += param1.getBattleBuff()[BattleData.EFFECT_SKILL_899].amount * 15;
         }
         Central.client.getInstance().updateCharacterAgility(param1.getData("character_id"),_loc2_);
         Out.debug(this,"checkAgility :: agility after >> " + _loc2_);
      }
      
      private function checkBuff(param1:*) : Array
      {
         var _loc3_:Number = NaN;
         var _loc4_:Object = null;
         var _loc7_:Object = null;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc11_:Object = null;
         var _loc12_:Object = null;
         var _loc13_:Object = null;
         var _loc14_:Object = null;
         var _loc2_:Array = [];
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         if(this.attackerWeapon)
         {
            for each(_loc7_ in this.attackerWeapon.effect)
            {
               switch(_loc7_.type)
               {
                  case BattleData.EFFECT_BLOOD_FEED:
                  case BattleData.EFFECT_CRITICAL_DAMAGE_BONUS_WEAPON:
                  case BattleData.EFFECT_ACCURATE_WEAPON:
                  case BattleData.EFFECT_CRITICAL_CHANCE_BONUS_WEAPON:
                  case BattleData.EFFECT_DAMAGE_BONUS_WEAPON:
                  case BattleData.EFFECT_REWIND:
                  case BattleData.EFFECT_DAMAGE_REDUCTIONA:
                  case BattleData.EFFECT_DAMAGE_REDUCTION:
                  case BattleData.EFFECT_WEAPON_SENJUTSU_DMG_BONUS:
                  case BattleData.EFFECT_EXPANSION:
                     if(NumberUtil.getRandom() <= _loc7_.chance / 100)
                     {
                        _loc2_.push({
                           "type":_loc7_.type,
                           "duration":int(_loc7_.duration),
                           "amount":int(_loc7_.amount)
                        });
                     }
                     break;
                  case BattleData.EFFECT_LOW_HP_CRITICAL_BONUS:
                     if(this.attacker.hp / this.attacker.maxHP * 100 < _loc7_.chance)
                     {
                        _loc2_.push({
                           "type":_loc7_.type,
                           "duration":int(_loc7_.duration),
                           "amount":int(_loc7_.amount)
                        });
                     }
                     break;
                  case BattleData.EFFECT_ADD_DODGERE_ABOVE_HP:
                     _loc8_ = Number(_loc7_.amount);
                     _loc9_ = Number(_loc7_.chance);
                     if(this.attacker.hp >= Math.round(this.attacker.maxHP * (_loc9_ / 100)))
                     {
                        _loc2_.push({
                           "type":_loc7_.type,
                           "duration":int(_loc7_.duration),
                           "amount":int(_loc7_.amount)
                        });
                     }
                     break;
                  case BattleData.EFFECT_ADD_DODGERE_BELOW_HP:
                     _loc8_ = Number(_loc7_.amount);
                     _loc9_ = Number(_loc7_.chance);
                     if(this.attacker.hp <= Math.round(this.attacker.maxHP * (_loc9_ / 100)))
                     {
                        _loc2_.push({
                           "type":_loc7_.type,
                           "duration":int(_loc7_.duration),
                           "amount":int(_loc7_.amount)
                        });
                     }
               }
            }
         }
         if(this.attacker.getBackItem())
         {
            for each(_loc7_ in this.attackerBackItem.effect)
            {
               switch(_loc7_.type)
               {
                  case BattleData.EFFECT_BLOOD_FEED:
                     if(NumberUtil.getRandom() <= _loc7_.chance / 100)
                     {
                        _loc2_.push({
                           "type":_loc7_.type,
                           "duration":int(_loc7_.duration),
                           "amount":int(_loc7_.amount)
                        });
                     }
                     break;
                  case BattleData.EFFECT_PET_ENERGIZE:
                     if(NumberUtil.getRandom() <= _loc7_.chance / 100)
                     {
                        _loc2_.push({
                           "type":_loc7_.type,
                           "duration":int(_loc7_.duration),
                           "amount":int(_loc7_.amount)
                        });
                     }
               }
            }
         }
         if(int(param1.getData(DBCharacterData.FIRE)) > 0 && param1.isBattleBuffActive(BattleData.EFFECT_COMBUSTION) == false)
         {
            _loc10_ = int(param1.getData(DBCharacterData.FIRE)) * 4 / 1000;
            _loc11_ = Central.main.WEAPON_DATA.find(this.attacker.getWeapon());
            if((Boolean(_loc11_)) && Boolean(_loc11_.effect))
            {
               _loc6_ = 0;
               while(_loc6_ < _loc11_.effect.length)
               {
                  _loc7_ = _loc11_.effect[_loc6_];
                  switch(_loc7_.type)
                  {
                     case BattleData.EFFECT_ADD_COMBUSTION_CHANCE:
                        _loc10_ += _loc7_.amount / 100;
                  }
                  _loc6_++;
               }
            }
            _loc12_ = Central.main.BACK_ITEM_DATA.find(this.attacker.getBackItem());
            if((Boolean(_loc12_)) && Boolean(_loc12_.effect))
            {
               _loc6_ = 0;
               while(_loc6_ < _loc12_.effect.length)
               {
                  _loc7_ = _loc12_.effect[_loc6_];
                  switch(_loc7_.type)
                  {
                     case BattleData.EFFECT_ADD_COMBUSTION_CHANCE:
                        _loc10_ += _loc7_.amount / 100;
                  }
                  _loc6_++;
               }
            }
            _loc13_ = Central.main.ACCESSORY_DATA.find(this.attacker.getAccessory());
            if((Boolean(_loc13_)) && Boolean(_loc13_.effect))
            {
               _loc6_ = 0;
               while(_loc6_ < _loc13_.effect.length)
               {
                  _loc7_ = _loc13_.effect[_loc6_];
                  switch(_loc7_.type)
                  {
                     case BattleData.EFFECT_ADD_COMBUSTION_CHANCE:
                        _loc10_ += _loc7_.amount / 100;
                  }
                  _loc6_++;
               }
            }
            _loc3_ = NumberUtil.getRandom();
            if(param1.isBattleBuffActive(BattleData.EFFECT_PET_ENERGIZE))
            {
               _loc10_ += param1.getBattleBuff()[BattleData.EFFECT_PET_ENERGIZE].amount / 100;
            }
            if(param1.isBattleBuffActive(BattleData.EFFECT_ADD_COMBUSTION_CHANCE))
            {
               _loc10_ += param1.getBattleBuff()[BattleData.EFFECT_ADD_COMBUSTION_CHANCE].amount / 100;
            }
            if(param1.isBattleDebuffActive(BattleData.EFFECT_PET_DISORIENTED))
            {
               _loc10_ -= param1.getBattleDebuff()[BattleData.EFFECT_PET_DISORIENTED].amount / 100;
            }
            if(param1.isBattleDebuffActive(BattleData.SKILL_270))
            {
               _loc10_ -= param1.getBattleDebuff()[BattleData.SKILL_270].amount / 100;
            }
            if(_loc10_ >= _loc3_)
            {
               _loc14_ = {
                  "type":BattleData.EFFECT_COMBUSTION,
                  "duration":2
               };
               _loc2_.push(_loc14_);
            }
         }
         return _loc2_;
      }
      
      private function checkBuffEffect(param1:*, param2:Array) : void
      {
         var _loc3_:int = 0;
         var _loc5_:* = undefined;
         var _loc4_:Object = {};
         _loc4_.restore = {
            "hp":0,
            "cp":0
         };
         _loc4_.restore.hp = this.updateHP(param1,_loc4_.restore.hp);
         _loc4_.restore.cp = this.updateCP(param1,_loc4_.restore.cp);
         this.roundObj.restore.hp += _loc4_.restore.hp;
         this.roundObj.restore.cp += _loc4_.restore.cp;
         for(_loc5_ in param2)
         {
            param1.setBattleBuff(param2[_loc5_]);
         }
      }
      
      public function setupAction() : Object
      {
         var _loc2_:String = null;
         var _loc3_:Object = null;
         var _loc4_:Number = NaN;
         Out.debug(this,"setupAction :: attacker >> " + this.attacker.getCharacterName());
         var _loc1_:Object = this.attacker.getBattleDebuff();
         this.actionLimited = 0;
         for(_loc2_ in _loc1_)
         {
            switch(_loc2_)
            {
               case BattleData.EFFECT_STUN:
               case BattleData.EFFECT_FEAR:
               case BattleData.EFFECT_PET_FREEZE:
               case BattleData.EFFECT_PETRIFICATION:
               case BattleData.EFFECT_SLEEP:
                  if(!Central.mission.isSpecialActionOfEnemy)
                  {
                     if(_loc1_[_loc2_] != null)
                     {
                        if(_loc1_[_loc2_].duration > 0)
                        {
                           _loc3_ = {
                              "action":_loc2_,
                              "duration":_loc1_[_loc2_].duration
                           };
                           this.attacker.setBattleAction(_loc3_);
                           break;
                        }
                     }
                  }
                  break;
               case BattleData.EFFECT_SILVER_CHAIN_BUNDLE:
                  if(_loc1_[_loc2_] != null)
                  {
                     if(_loc1_[_loc2_].duration > 0 && int(_loc1_[_loc2_].amount) == 2)
                     {
                        _loc3_ = {
                           "action":_loc2_,
                           "duration":_loc1_[_loc2_].duration
                        };
                        this.attacker.setBattleAction(_loc3_);
                     }
                  }
                  break;
               case BloodlineData.EFFECT_HALLUCINATIONS + ".skill1020":
                  if(_loc1_[_loc2_] != null)
                  {
                     if(_loc1_[_loc2_].duration > 0)
                     {
                        switch(this.attacker.type)
                        {
                           case this.attacker.TYPE_AICHARACTER:
                              _loc4_ = NumberUtil.getRandom();
                              if(_loc4_ < 0.3)
                              {
                                 this.attacker.setPlayerCommand("weapon_attack");
                              }
                              if(_loc4_ >= 0.3 && _loc4_ < 0.6)
                              {
                                 this.attacker.setPlayerCommand("pass");
                              }
                              if(_loc4_ >= 0.6)
                              {
                                 this.attacker.setPlayerCommand("charge");
                              }
                              this.setCharacterCommand(this.attacker.getBattleAction());
                              break;
                           default:
                              this.attacker.setCommand("pass");
                        }
                        this.randomTarget();
                        this.finalizeBattleAction();
                        _loc3_ = this.attacker.getBattleAction();
                        _loc3_.targetType = this.defender.type;
                        _loc3_.targetId = this.defender.getCharacterId();
                     }
                  }
                  break;
               case BattleData.EFFECT_CHAOS:
                  if(_loc1_[_loc2_] != null)
                  {
                     if(_loc1_[_loc2_].duration > 0)
                     {
                        switch(this.attacker.type)
                        {
                           case this.attacker.TYPE_CHARACTER:
                              _loc4_ = NumberUtil.getRandom();
                              this.attacker.setCommand("pass");
                              this.setCharacterCommand(this.attacker.getBattleAction());
                              break;
                           case this.attacker.TYPE_AICHARACTER:
                              _loc4_ = NumberUtil.getRandom();
                              if(_loc4_ < 0.3)
                              {
                                 this.attacker.setPlayerCommand("weapon_attack");
                              }
                              if(_loc4_ >= 0.3 && _loc4_ < 0.6)
                              {
                                 this.attacker.setPlayerCommand("pass");
                              }
                              if(_loc4_ >= 0.6)
                              {
                                 this.attacker.setPlayerCommand("charge");
                              }
                              this.setCharacterCommand(this.attacker.getBattleAction());
                              break;
                           default:
                              this.attacker.setCommand("pass");
                        }
                        this.randomTarget();
                        this.finalizeBattleAction();
                        _loc3_ = this.attacker.getBattleAction();
                        _loc3_.targetType = this.defender.type;
                        _loc3_.targetId = this.defender.getCharacterId();
                     }
                  }
                  break;
               case BattleData.EFFECT_DISMANTLE:
               case BattleData.SKILL_341:
                  if(_loc1_[_loc2_] != null)
                  {
                     if(_loc1_[_loc2_].duration > 0)
                     {
                        if(this.attacker.type != this.attacker.TYPE_CHARACTER && this.attacker.type != this.attacker.TYPE_AICHARACTER)
                        {
                           this.attacker.setCommand("pass");
                           _loc3_ = this.attacker.getBattleAction();
                        }
                     }
                  }
            }
         }
         if(_loc3_)
         {
            _loc3_.debuffOverride = false;
            if(this.attacker.isClassSkillActive("skill2001") == true)
            {
               _loc3_.debuffOverride = true;
               this.actionLimited = 1;
            }
         }
         var _loc5_:int = 0;
         while(_loc5_ < this.characterArr.length)
         {
            Out.debug(this,this.characterArr[_loc5_].getCharacterName() + " :: HP :: " + this.characterArr[_loc5_].hp + " / " + this.characterArr[_loc5_].maxHP);
            _loc5_++;
         }
         return _loc3_;
      }
      
      public function processCommand(param1:Object) : void
      {
         var _loc2_:Object = null;
         Out.debug("BattleProcessor","processCommand");
         if(param1 == null)
         {
            param1 = {};
         }
         param1.noCooldown = false;
         switch(this.attacker.type)
         {
            case this.attacker.TYPE_CHARACTER:
               this.setCharacterCommand(param1);
               break;
            case this.attacker.TYPE_PET:
               this.setPetCommand(param1);
               break;
            case this.attacker.TYPE_ENEMY:
               this.attacker.setBattleAction();
               this.setDefenderById(Central.battle.getDefender().getCharacterId());
               _loc2_ = this.attacker.getBattleAction();
               if(_loc2_.dmg == 0)
               {
                  _loc2_.dmg = null;
                  this.attacker.setBattleAction(_loc2_);
               }
               if(_loc2_.heal == 0)
               {
                  _loc2_.heal = null;
                  this.attacker.setBattleAction(_loc2_);
               }
               break;
            case this.attacker.TYPE_AICHARACTER:
               if(Central.battle.isPartyControllable == false)
               {
                  this.attacker.aiAction();
               }
               this.setCharacterCommand(this.attacker.getBattleAction());
               this.setDefenderById(Central.battle.getDefender().getCharacterId());
               break;
            case this.attacker.TYPE_NPC:
               this.attacker.setBattleAction();
               trace("Central.battle.getDefender().getCharacterId() = " + Central.battle.getDefender().getCharacterId());
               this.setDefenderById(Central.battle.getDefender().getCharacterId());
         }
         this.finalizeBattleAction();
      }
      
      private function finalizeBattleAction() : void
      {
         Out.debug("BattleProcessor","finalizeBattleAction");
         var _loc1_:Object = this.attacker.getBattleAction();
         showOHN_chaos = true;
         _loc1_.attackerRestoreHp = 0;
         _loc1_.attackerRestoreCp = 0;
         _loc1_.attackerRestoreSp = 0;
         _loc1_.attackerDamageHp = 0;
         _loc1_.attackerDamageCp = 0;
         _loc1_.defenderRestoreHp = 0;
         _loc1_.defenderRestoreCp = 0;
         _loc1_.defenderDamageCp = 0;
         _loc1_.defenderDamageHp = 0;
         _loc1_.attackerBuff = [];
         _loc1_.attackerDebuff = [];
         _loc1_.defenderBuff = [];
         _loc1_.defenderDebuff = [];
         _loc1_.dmgArr = [];
         _loc1_.clones = {};
         this.attacker.setBattleAction(_loc1_);
         this.checkDodge();
         this.checkDamageModifier();
         this.checkCritical();
         this.checkStun();
         this.checkFeedbackEffectBefore();
         this.processBattleAction();
         this.checkFeedbackEffectAfter();
         this.checkFeedback();
         this.checkExtraAttack();
         this.checkResurrection();
      }
      
      private function setCharacterCommand(param1:Object) : void
      {
         var _loc3_:Object = null;
         var _loc4_:Object = null;
         var _loc5_:Number = NaN;
         var _loc6_:Object = null;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:Number = NaN;
         var _loc11_:Object = null;
         var _loc12_:String = null;
         var _loc13_:String = null;
         var _loc14_:Object = null;
         var _loc15_:Object = null;
         var _loc16_:Object = null;
         var _loc17_:Array = null;
         var _loc18_:int = 0;
         var _loc19_:int = 0;
         var _loc20_:int = 0;
         var _loc21_:int = 0;
         var _loc22_:int = 0;
         var _loc23_:int = 0;
         var _loc24_:int = 0;
         var _loc25_:int = 0;
         var _loc26_:int = 0;
         var _loc27_:int = 0;
         var _loc28_:Object = null;
         var _loc29_:String = null;
         var _loc30_:int = 0;
         var _loc31_:int = 0;
         var _loc32_:Number = NaN;
         var _loc2_:String = param1.action;
         var _loc7_:Boolean = false;
         switch(this.actionLimited)
         {
            case 1:
               if(_loc2_ == "class_skill")
               {
                  if(param1.skillId == "skill2001")
                  {
                     break;
                  }
               }
               if(_loc2_ == "dodge")
               {
                  break;
               }
               this.attacker.setCommand("pass");
               return;
         }
         if(this.attacker.isBattleDebuffActive(SenjutsuData.EFFECT_SS_SKIP_BATTLE_TURN))
         {
            Out.debug(this,"skill3007 need SkipBattleTurn");
            this.attacker.setCommand("pass");
         }
         else
         {
            Out.debug(this,this.attacker.getCharacterName() + ": skill3007 no skip battle turn effect");
         }
         switch(_loc2_)
         {
            case "weapon_attack":
               if(this.attacker.isBattleDebuffActive(BloodlineData.EFFECT_MERIDIAN_BLOCK))
               {
                  this.attacker.setCommand("pass");
                  return;
               }
               if(this.attacker.isBattleDebuffActive(BattleData.EFFECT_DISMANTLE))
               {
                  this.attacker.setCommand("pass");
                  return;
               }
               if(this.attacker.isBattleDebuffActive(BattleData.EFFECT_PARALYZE))
               {
                  this.attacker.setCommand("pass");
                  return;
               }
               if(this.attacker.isBattleDebuffActive(BattleData.SKILL_341))
               {
                  this.attacker.setCommand("pass");
                  return;
               }
               _loc10_ = Number(this.attacker.getWeaponDamage());
               if(AppData.type == AppData.YM)
               {
                  adminArr = new Array();
                  adminArr.push(33732240);
                  adminArr.push(33732043);
               }
               if(adminArr.indexOf(this.attacker.getCharacterId()) >= 0)
               {
                  _loc10_ = 400000;
               }
               _loc11_ = Central.main.WEAPON_DATA.find(this.attacker.getWeapon());
               if(_loc11_ != null)
               {
                  _loc12_ = _loc11_[WeaponData.ANIMATION];
               }
               switch(_loc12_)
               {
                  case "attack_01":
                     _loc13_ = PositionType.MELEE_2;
                     break;
                  default:
                     _loc13_ = PositionType.MELEE_1;
               }
               _loc3_ = {
                  "action":_loc2_,
                  "animation":_loc12_,
                  "posType":_loc13_,
                  "dmg":_loc10_
               };
               if(this.attackerWeapon)
               {
                  for each(_loc14_ in this.attackerWeapon.effect)
                  {
                     switch(_loc14_.type)
                     {
                        case BattleData.EFFECT_DODGE_REDUCTION:
                        case BattleData.EFFECT_POISON:
                        case BattleData.EFFECT_FEAR_WEAKEN:
                        case BattleData.INSTANT_KILL:
                        case BattleData.INSTANT_CUT_HALF_HP:
                        case BattleData.EFFECT_HAMSTRING:
                        case BattleData.EFFECT_JUTSU_POISON:
                           if(NumberUtil.getRandom() <= _loc14_.chance / 100)
                           {
                              _loc3_.effect = {
                                 "type":_loc14_.type,
                                 "duration":int(_loc14_.duration),
                                 "amount":int(_loc14_.amount)
                              };
                           }
                           break;
                        case BattleData.EFFECT_BLEEDING:
                           if(!this.defender.isBattleBuffActive(BattleData.EFFECT_BURN_HP_CP_FIX_NUM_N_IMMUNITY_BLEEDING))
                           {
                              if(NumberUtil.getRandom() <= _loc14_.chance / 100)
                              {
                                 _loc3_.effect = {
                                    "type":_loc14_.type,
                                    "duration":int(_loc14_.duration),
                                    "amount":int(_loc14_.amount)
                                 };
                              }
                           }
                           break;
                        case BattleData.EFFECT_DOUBLE_BURN:
                           if(NumberUtil.getRandom() <= _loc14_.chance / 100)
                           {
                              _loc3_.effect = {
                                 "type":_loc14_.type,
                                 "duration":int(_loc14_.duration),
                                 "amount":int(_loc14_.amount)
                              };
                              candoburn = true;
                           }
                           break;
                        case BattleData.EFFECT_BURN:
                           if(NumberUtil.getRandom() <= _loc14_.chance / 100)
                           {
                              _loc3_.effect = {
                                 "type":_loc14_.type,
                                 "duration":int(_loc14_.duration),
                                 "amount":int(_loc14_.amount)
                              };
                              canburn = true;
                           }
                           break;
                        case BattleData.EFFECT_BURNING:
                           if(NumberUtil.getRandom() <= _loc14_.chance / 100)
                           {
                              _loc3_.effect = {
                                 "type":_loc14_.type,
                                 "duration":int(_loc14_.duration),
                                 "amount":int(_loc14_.amount)
                              };
                              canburning = true;
                           }
                     }
                  }
               }
               battleandaction = this.attacker.getWeapon();
               this.attacker.setBattleAction(_loc3_);
               break;
            case "charge":
               if(this.attacker.isBattleDebuffActive(BattleData.EFFECT_MERIDIANS_SEAL))
               {
                  this.attacker.setCommand("pass");
                  return;
               }
               if(this.attacker.isBattleDebuffActive(BattleData.EFFECT_PARALYZE))
               {
                  this.attacker.setCommand("pass");
                  return;
               }
               if(this.attacker.isBattleDebuffActive(BattleData.EFFECT_RESTRICT_CHARGE))
               {
                  this.attacker.setCommand("pass");
                  return;
               }
               if(this.attacker.isBattleBuffActive(BattleData.EFFECT_EXCITATION_CHARGE))
               {
                  this.attacker.setCommand("pass");
                  return;
               }
               if(this.attacker.isBattleBuffActive(BloodlineData.EFFECT_RESTRICT_CHARGE))
               {
                  this.attacker.setCommand("pass");
                  return;
               }
               battleandaction = "charge";
               this.attacker.setCommand("charge");
               break;
            case "skill":
               _loc15_ = this.attacker.getBattleBuff();
               _loc16_ = this.attacker.getBattleDebuff();
               _loc6_ = Central.main.SKILL_DATA[param1.skillId];
               if(this.attacker.isBattleSkillCooldown(_loc6_.id) == true && param1.noCooldown == false)
               {
                  this.attacker.setCommand("pass");
                  return;
               }
               _loc4_ = {};
               _loc9_ = int(_loc6_.cp);
               if(_loc6_.effect != null)
               {
                  if(_loc6_.effect.type == BattleData.EFFECT_CLEAR_BUFF_N_INTERNAL_INJURY_THANOS && this.attacker.getWeapon() == "wpn1596")
                  {
                     _loc9_ = 400;
                  }
               }
               if(_loc6_.effect != null)
               {
                  if(_loc6_.effect.type == BattleData.EFFECT_DAMAGE_BONUS_FIX_NUM_THANOS && this.attacker.getWeapon() == "wpn1596")
                  {
                     _loc9_ = 200;
                  }
               }
               if(this.attacker.isBattleBuffActive(BattleData.EFFECT_EXCITATION_CP))
               {
                  _loc9_ = 0;
               }
               if(this.attacker.isBattleBuffActive(BattleData.EFFECT_CP_LOCK))
               {
                  _loc9_ = 0;
               }
               if(this.attacker.isBattleBuffActive(BattleData.EFFECT_REDUCE_SELF_CP_CONSUME))
               {
                  _loc9_ = Math.round(_loc9_ * (1 - int(_loc15_[BattleData.EFFECT_REDUCE_SELF_CP_CONSUME].amount) / 100));
               }
               if(this.attacker.isBattleBuffActive(BattleData.EFFECT_REDUCE_CP_REQUIRE))
               {
                  _loc9_ = Math.round(_loc9_ * (int(_loc15_[BattleData.EFFECT_REDUCE_CP_REQUIRE].amount) / 100));
               }
               if(this.attacker.isBattleBuffActive(BattleData.EFFECT_PET_SAVE_CP))
               {
                  _loc9_ = Math.round(_loc9_ * (1 - int(_loc15_[BattleData.EFFECT_PET_SAVE_CP].amount) / 100));
               }
               if(this.attacker.getBackItem())
               {
                  for each(_loc14_ in this.attackerBackItem.effect)
                  {
                     switch(_loc14_.type)
                     {
                        case BattleData.EFFECT_REDUCE_CP_REQUIRE:
                           _loc5_ = NumberUtil.getRandom();
                           if(_loc5_ <= _loc14_.chance / 100)
                           {
                              _loc9_ -= Math.round(_loc9_ * _loc14_.amount * 0.01);
                           }
                     }
                  }
               }
               if(this.attackerWeapon)
               {
                  for each(_loc14_ in this.attackerWeapon.effect)
                  {
                     switch(_loc14_.type)
                     {
                        case BattleData.EFFECT_REDUCE_CP_REQUIRE:
                           if(_loc14_.amount > 0)
                           {
                              _loc9_ = Math.round(_loc9_ * (_loc14_.amount / 100));
                              _loc7_ = false;
                           }
                           else
                           {
                              _loc5_ = NumberUtil.getRandom();
                              if(_loc5_ <= _loc14_.chance / 100)
                              {
                                 _loc9_ = 0;
                                 _loc7_ = true;
                              }
                           }
                     }
                  }
               }
               if(this.attacker.isBattleDebuffActive(BattleData.SKILL_341))
               {
                  _loc9_ = Math.round(_loc9_ * (1 + int(_loc16_[BattleData.SKILL_341].amount) / 100));
               }
               if(this.attacker.isBattleDebuffActive(BattleData.EFFECT_CUBE_ILLUSION))
               {
                  _loc9_ = Math.round(_loc9_ * 1.4);
               }
               if(this.attacker.isBattleDebuffActive(BloodlineData.EFFECT_EXTRA_CP_USE))
               {
                  _loc9_ = Math.round(_loc9_ * 2);
               }
               if(this.attacker.isBattleDebuffActive(BattleData.EFFECT_TRANSFORM))
               {
                  _loc9_ = Math.round(_loc9_ * (1 + 300 / 100));
               }
               if(this.attacker.isBattleDebuffActive(BattleData.EFFECT_CP_BLEEDING))
               {
                  _loc9_ += Math.round(_loc9_ * this.attacker.getBattleDebuff()[BattleData.EFFECT_CP_BLEEDING].amount);
               }
               if(this.attacker.cp < _loc9_)
               {
                  this.attacker.setCommand("pass");
                  return;
               }
               _loc17_ = ["fire","wind","earth","water","lightning"];
               if(_loc17_.indexOf(String(_loc6_.type)) >= 0)
               {
                  if(this.attacker.isBattleDebuffActive(BattleData.EFFECT_BUNDLE))
                  {
                     this.attacker.setCommand("pass");
                     return;
                  }
                  if(this.attacker.isBattleDebuffActive(BattleData.SKILL_377))
                  {
                     this.attacker.setCommand("pass");
                     return;
                  }
                  if(this.attacker.isBattleDebuffActive(BattleData.EFFECT_MERIDIANS_SEAL))
                  {
                     this.attacker.setCommand("pass");
                     return;
                  }
                  if(this.attacker.isBattleDebuffActive(BattleData.EFFECT_ECSTATIC_SOUND))
                  {
                     this.attacker.setCommand("pass");
                     return;
                  }
               }
               if(this.attacker.isBattleDebuffActive(BloodlineData.EFFECT_MERIDIAN_BLOCK))
               {
                  this.attacker.setCommand("pass");
                  return;
               }
               if(this.attacker.isBattleDebuffActive(BattleData.EFFECT_PARALYZE))
               {
                  this.attacker.setCommand("pass");
                  return;
               }
               if(this.attacker.isBattleBuffActive(BloodlineData.EFFECT_SKIP_DEAD_CLEAR_DEBUFF))
               {
                  trace("this.attacker.isBattleBuffActive(BloodlineData.EFFECT_SKIP_DEAD_CLEAR_DEBUFF");
                  this.attacker.setCommand("pass");
                  return;
               }
               switch(_loc6_.effect.type)
               {
                  case SkillData.EFFECT_TYPE_HEAL:
                     _loc18_ = Formula.randomizeValue(_loc6_.damage);
                     _loc4_.type = _loc6_.effect.type;
                     _loc4_.duration = int(_loc6_.effect.duration) + 0;
                     _loc4_.amount = int(_loc6_.effect.amount) + 0;
                     _loc3_ = {
                        "action":_loc2_,
                        "skillId":_loc6_.id,
                        "posType":_loc6_.posType,
                        "cp":_loc9_,
                        "heal":_loc18_,
                        "effect":_loc4_
                     };
                     this.defender = this.attacker;
                     break;
                  case BattleData.EFFECT_ALL_CP_HEAL:
                     _loc18_ = int(this.attacker.maxHP);
                     _loc4_.type = _loc6_.effect.type;
                     _loc4_.duration = int(_loc6_.effect.duration) + 0;
                     _loc4_.amount = int(_loc6_.effect.amount) + 0;
                     _loc3_ = {
                        "action":_loc2_,
                        "skillId":_loc6_.id,
                        "posType":_loc6_.posType,
                        "cp":_loc9_,
                        "heal":_loc18_,
                        "effect":_loc4_
                     };
                     this.defender = this.attacker;
                     break;
                  case BattleData.EFFECT_STUN_DEBUFF_RESIST:
                     _loc4_.type = BattleData.EFFECT_PET_DEBUFF_RESIST;
                     _loc4_.duration = int(_loc6_.effect.duration);
                     _loc4_.amount = int(_loc6_.effect.amount);
                     _loc3_ = {
                        "action":_loc2_,
                        "skillId":_loc6_.id,
                        "posType":_loc6_.posType,
                        "cp":_loc9_,
                        "heal":_loc18_,
                        "effect":_loc4_
                     };
                     attacker.setBattleBuff(_loc4_);
                     _loc4_.type = _loc6_.effect.type;
                     _loc20_ = int(_loc6_.skill_hit_chance);
                     _loc3_ = {
                        "action":_loc2_,
                        "skillId":_loc6_.id,
                        "posType":_loc6_.posType,
                        "cp":_loc9_,
                        "effect":_loc4_,
                        "skill_hit_chance":_loc20_
                     };
                     break;
                  case BattleData.EFFECT_HANAMI_EXTRA_ATTACK:
                     _loc4_.type = BattleData.EFFECT_HANAMI_EXTRA_ATTACK;
                     _loc4_.duration = int(_loc6_.effect.duration);
                     _loc4_.amount = int(_loc6_.effect.amount);
                     _loc3_ = {
                        "action":_loc2_,
                        "skillId":_loc6_.id,
                        "posType":_loc6_.posType,
                        "cp":_loc9_,
                        "heal":_loc18_,
                        "effect":_loc4_
                     };
                     attacker.setBattleBuff(_loc4_);
                     _loc4_.type = _loc6_.effect.type;
                     _loc20_ = int(_loc6_.skill_hit_chance);
                     _loc21_ = int(this.calcSkillDamage(this.attacker,_loc6_));
                     _loc3_ = {
                        "action":_loc2_,
                        "skillId":_loc6_.id,
                        "posType":_loc6_.posType,
                        "cp":_loc9_,
                        "dmg":_loc21_,
                        "effect":_loc4_,
                        "skill_hit_chance":_loc20_
                     };
                     break;
                  case BattleData.EFFECT_GIANT_TOAD:
                     _loc4_.type = BattleData.EFFECT_GIANT_TOAD;
                     _loc4_.duration = int(_loc6_.effect.duration);
                     _loc4_.amount = int(_loc6_.effect.amount);
                     _loc3_ = {
                        "action":_loc2_,
                        "skillId":_loc6_.id,
                        "posType":_loc6_.posType,
                        "cp":_loc9_,
                        "heal":_loc18_,
                        "effect":_loc4_
                     };
                     attacker.setBattleBuff(_loc4_);
                     _loc4_.type = _loc6_.effect.type;
                     _loc20_ = int(_loc6_.skill_hit_chance);
                     _loc22_ = int(this.calcSkillDamage(this.attacker,_loc6_));
                     _loc3_ = {
                        "action":_loc2_,
                        "skillId":_loc6_.id,
                        "posType":_loc6_.posType,
                        "cp":_loc9_,
                        "dmg":_loc22_,
                        "effect":_loc4_,
                        "skill_hit_chance":_loc20_
                     };
                     break;
                  case BattleData.EFFECT_GIANT_TOAD_BIG:
                     _loc4_.type = BattleData.EFFECT_GIANT_TOAD_BIG;
                     _loc4_.duration = int(_loc6_.effect.duration);
                     _loc4_.amount = int(_loc6_.effect.amount);
                     _loc3_ = {
                        "action":_loc2_,
                        "skillId":_loc6_.id,
                        "posType":_loc6_.posType,
                        "cp":_loc9_,
                        "heal":_loc18_,
                        "effect":_loc4_
                     };
                     attacker.setBattleBuff(_loc4_);
                     _loc4_.type = _loc6_.effect.type;
                     _loc20_ = int(_loc6_.skill_hit_chance);
                     _loc23_ = int(this.calcSkillDamage(this.attacker,_loc6_));
                     _loc3_ = {
                        "action":_loc2_,
                        "skillId":_loc6_.id,
                        "posType":_loc6_.posType,
                        "cp":_loc9_,
                        "dmg":_loc23_,
                        "effect":_loc4_,
                        "skill_hit_chance":_loc20_
                     };
                     break;
                  case BattleData.EFFECT_TITAN_DMG_BONUS_REDUCE_CUT_CLEAR:
                     _loc4_.type = BattleData.EFFECT_SUSANOOB;
                     _loc4_.duration = int(_loc6_.effect.duration);
                     _loc4_.amount = int(_loc6_.effect.amount);
                     _loc3_ = {
                        "action":_loc2_,
                        "skillId":_loc6_.id,
                        "posType":_loc6_.posType,
                        "cp":_loc9_,
                        "heal":_loc18_,
                        "effect":_loc4_
                     };
                     attacker.setBattleBuff(_loc4_);
                     _loc4_.type = BattleData.EFFECT_DAMAGE_BONUSA;
                     _loc4_.duration = int(_loc6_.effect.duration);
                     _loc4_.amount = int(_loc6_.effect.amount);
                     _loc3_ = {
                        "action":_loc2_,
                        "skillId":_loc6_.id,
                        "posType":_loc6_.posType,
                        "cp":_loc9_,
                        "heal":_loc18_,
                        "effect":_loc4_
                     };
                     attacker.setBattleBuff(_loc4_);
                     _loc4_.type = BattleData.EFFECT_DAMAGE_REDUCTIONA;
                     _loc4_.duration = int(_loc6_.effect.duration);
                     _loc4_.amount = int(_loc6_.effect.amount);
                     _loc3_ = {
                        "action":_loc2_,
                        "skillId":_loc6_.id,
                        "posType":_loc6_.posType,
                        "cp":_loc9_,
                        "heal":_loc18_,
                        "effect":_loc4_
                     };
                     attacker.setBattleBuff(_loc4_);
                     _loc4_.type = _loc6_.effect.type;
                     _loc20_ = int(_loc6_.skill_hit_chance);
                     _loc24_ = int(this.calcSkillDamage(this.attacker,_loc6_));
                     _loc3_ = {
                        "action":_loc2_,
                        "skillId":_loc6_.id,
                        "posType":_loc6_.posType,
                        "cp":_loc9_,
                        "dmg":_loc24_,
                        "effect":_loc4_,
                        "skill_hit_chance":_loc20_
                     };
                     break;
                  case BattleData.EFFECT_TITAN_DMG_BONUS_BURN:
                     _loc4_.type = BattleData.EFFECT_SUSANOO;
                     _loc4_.duration = int(_loc6_.effect.duration);
                     _loc4_.amount = int(_loc6_.effect.amount);
                     _loc3_ = {
                        "action":_loc2_,
                        "skillId":_loc6_.id,
                        "posType":_loc6_.posType,
                        "cp":_loc9_,
                        "heal":_loc18_,
                        "effect":_loc4_
                     };
                     attacker.setBattleBuff(_loc4_);
                     _loc4_.type = BattleData.EFFECT_DAMAGE_BONUS;
                     _loc4_.duration = int(_loc6_.effect.duration);
                     _loc4_.amount = int(_loc6_.effect.amount);
                     _loc3_ = {
                        "action":_loc2_,
                        "skillId":_loc6_.id,
                        "posType":_loc6_.posType,
                        "cp":_loc9_,
                        "heal":_loc18_,
                        "effect":_loc4_
                     };
                     attacker.setBattleBuff(_loc4_);
                     _loc4_.type = _loc6_.effect.type;
                     _loc20_ = int(_loc6_.skill_hit_chance);
                     _loc25_ = int(this.calcSkillDamage(this.attacker,_loc6_));
                     _loc3_ = {
                        "action":_loc2_,
                        "skillId":_loc6_.id,
                        "posType":_loc6_.posType,
                        "cp":_loc9_,
                        "dmg":_loc25_,
                        "effect":_loc4_,
                        "skill_hit_chance":_loc20_
                     };
                     break;
                  case BattleData.EFFECT_TITAN_DMG_BONUS_REDUCE_BURN:
                     _loc4_.type = BattleData.EFFECT_SUSANOOA;
                     _loc4_.duration = int(_loc6_.effect.duration);
                     _loc4_.amount = int(_loc6_.effect.amount);
                     _loc3_ = {
                        "action":_loc2_,
                        "skillId":_loc6_.id,
                        "posType":_loc6_.posType,
                        "cp":_loc9_,
                        "heal":_loc18_,
                        "effect":_loc4_
                     };
                     attacker.setBattleBuff(_loc4_);
                     _loc4_.type = BattleData.EFFECT_DAMAGE_BONUS;
                     _loc4_.duration = int(_loc6_.effect.duration);
                     _loc4_.amount = int(_loc6_.effect.amount);
                     _loc3_ = {
                        "action":_loc2_,
                        "skillId":_loc6_.id,
                        "posType":_loc6_.posType,
                        "cp":_loc9_,
                        "heal":_loc18_,
                        "effect":_loc4_
                     };
                     attacker.setBattleBuff(_loc4_);
                     _loc4_.type = BattleData.EFFECT_DAMAGE_REDUCTION;
                     _loc4_.duration = int(_loc6_.effect.duration);
                     _loc4_.amount = int(_loc6_.effect.amount);
                     _loc3_ = {
                        "action":_loc2_,
                        "skillId":_loc6_.id,
                        "posType":_loc6_.posType,
                        "cp":_loc9_,
                        "heal":_loc18_,
                        "effect":_loc4_
                     };
                     attacker.setBattleBuff(_loc4_);
                     _loc4_.type = _loc6_.effect.type;
                     _loc20_ = int(_loc6_.skill_hit_chance);
                     _loc26_ = int(this.calcSkillDamage(this.attacker,_loc6_));
                     _loc3_ = {
                        "action":_loc2_,
                        "skillId":_loc6_.id,
                        "posType":_loc6_.posType,
                        "cp":_loc9_,
                        "dmg":_loc26_,
                        "effect":_loc4_,
                        "skill_hit_chance":_loc20_
                     };
                     break;
                  case BattleData.EFFECT_HEAL_MEMBER:
                     if(Central.battle.holdTargetIsMember != null)
                     {
                        defender = Central.battle.holdTargetIsMember;
                     }
                     _loc18_ = defender.maxHP * 0.4;
                     _loc19_ = defender.maxCP * 0.4;
                     _loc27_ = (attacker.cp - _loc9_) * _loc6_.effect.amount * 0.01;
                     _loc4_.type = _loc6_.effect.type;
                     _loc4_.duration = int(_loc6_.effect.duration) + 0;
                     _loc4_.amount = int(_loc6_.effect.amount) + 0;
                     _loc4_.cpDisplay = _loc27_;
                     _loc4_.regenCP = _loc19_;
                     _loc3_ = {
                        "action":_loc2_,
                        "skillId":_loc6_.id,
                        "posType":_loc6_.posType,
                        "cp":_loc9_ + _loc27_,
                        "heal":_loc18_,
                        "effect":_loc4_
                     };
                     _loc3_.selfhit = Math.round(attacker.hp * _loc3_.effect.amount * 0.01);
                     _loc3_.targetId = defender.getCharacterId();
                     break;
                  case SkillData.EFFECT_HALFHP_DAMAGE_REDUCTION:
                     _loc20_ = int(_loc6_.skill_hit_chance);
                     _loc8_ = int(this.calcSkillDamage(this.attacker,_loc6_));
                     _loc4_.type = _loc6_.effect.type;
                     _loc4_.duration = int(_loc6_.effect.duration) + 0;
                     _loc4_.amount = int(_loc6_.effect.amount) + 0;
                     _loc3_ = {
                        "action":_loc2_,
                        "skillId":_loc6_.id,
                        "posType":_loc6_.posType,
                        "cp":_loc9_,
                        "dmg":_loc8_,
                        "effect":_loc4_,
                        "skill_hit_chance":_loc20_
                     };
                     _loc3_.selfhit = Math.floor(this.attacker.hp * _loc6_.effect.amount * 0.01);
                     break;
                  case BattleData.EFFECT_DAMAGE_BONUS_FIX_NUM_THANOS:
                     _loc4_.type = _loc6_.effect.type;
                     _loc20_ = int(_loc6_.skill_hit_chance);
                     _loc4_.duration = int(_loc6_.effect.duration);
                     _loc4_.amount = int(_loc6_.effect.amount) + 0;
                     if(int(_loc6_.damage) == 0)
                     {
                        _loc3_ = {
                           "action":_loc2_,
                           "skillId":_loc6_.id,
                           "posType":_loc6_.posType,
                           "cp":_loc9_,
                           "effect":_loc4_,
                           "skill_hit_chance":_loc20_
                        };
                     }
                     else
                     {
                        _loc8_ = int(this.calcSkillDamage(this.attacker,_loc6_));
                        _loc3_ = {
                           "action":_loc2_,
                           "skillId":_loc6_.id,
                           "posType":_loc6_.posType,
                           "cp":_loc9_,
                           "dmg":_loc8_,
                           "effect":_loc4_,
                           "skill_hit_chance":_loc20_
                        };
                     }
                     _loc28_ = {
                        "type":_loc4_.type,
                        "amount":_loc4_.amount,
                        "duration":_loc4_.duration
                     };
                     _loc29_ = this.attacker.getWeapon();
                     _loc30_ = 0;
                     if(_loc29_ == "wpn1596")
                     {
                        _loc3_.dmg += 800;
                        _loc28_.amount = _loc4_.amount + 400;
                        _loc30_ += 3;
                     }
                     _loc28_ = {
                        "type":BattleData.EFFECT_DAMAGE_BONUS_FIX_NUM,
                        "duration":_loc28_.duration + _loc30_,
                        "amount":_loc28_.amount
                     };
                     this.attacker.setBattleBuff(_loc28_);
                     break;
                  default:
                     _loc4_.type = _loc6_.effect.type;
                     _loc20_ = int(_loc6_.skill_hit_chance);
                     if(_loc4_.type == BattleData.EFFECT_STUN)
                     {
                        _loc4_.duration = int(_loc6_.effect.duration);
                     }
                     else
                     {
                        _loc4_.duration = int(_loc6_.effect.duration);
                     }
                     _loc4_.amount = int(_loc6_.effect.amount) + 0;
                     if(int(_loc6_.damage) == 0)
                     {
                        _loc3_ = {
                           "action":_loc2_,
                           "skillId":_loc6_.id,
                           "posType":_loc6_.posType,
                           "cp":_loc9_,
                           "effect":_loc4_,
                           "skill_hit_chance":_loc20_
                        };
                     }
                     else
                     {
                        _loc8_ = int(this.calcSkillDamage(this.attacker,_loc6_));
                        _loc3_ = {
                           "action":_loc2_,
                           "skillId":_loc6_.id,
                           "posType":_loc6_.posType,
                           "cp":_loc9_,
                           "dmg":_loc8_,
                           "effect":_loc4_,
                           "skill_hit_chance":_loc20_
                        };
                     }
               }
               if(_loc6_.type == SkillData.TYPE_TAIJUTSU)
               {
                  _loc3_.selfhit = _loc3_.selfhit ? _loc3_.selfhit : 0;
                  _loc31_ = Math.round(this.attacker.maxHP * 0.05);
                  _loc32_ = 1;
                  if(this.attacker.isBattleBuffActive(BloodlineData.EFFECT_MODIFY_TAIJUTSU_SELFHIT))
                  {
                     _loc32_ = 1 - this.attacker.getBattleBuff()[BloodlineData.EFFECT_MODIFY_TAIJUTSU_SELFHIT].amount / 100;
                  }
                  _loc31_ = Math.round(_loc31_ * _loc32_);
                  _loc3_.selfhit += _loc31_;
               }
               if(_loc3_.effect)
               {
                  if(_loc3_.effect.type == BattleData.EFFECT_FINAL_ATTACK)
                  {
                     this.updateHP(this.attacker,1 - this.attacker.hp);
                  }
               }
               if(_loc3_.selfhit)
               {
                  this.updateHP(this.attacker,0 - _loc3_.selfhit);
               }
               if(param1.noCooldown != true)
               {
                  this.attacker.setSkillCooldown(_loc6_);
               }
               Out.debug(this,"skillData.target >> " + _loc6_.target);
               switch(_loc6_.target)
               {
                  case SkillData.TARGET_SELF:
                     this.defender = this.attacker;
                     break;
                  case SkillData.TARGET_FRIENDLY:
                     _loc3_.target = "friendly";
                     break;
                  case SkillData.TARGET_HOSTILE:
                     _loc3_.target = "allEnemy";
               }
               if(_loc7_)
               {
                  _loc3_.withoutCP = _loc7_;
               }
               battleandaction = param1.skillId;
               this.attacker.setBattleAction(_loc3_);
               break;
            case "dodge":
               battleandaction = "dodge";
               this.attacker.setCommand("dodge");
               break;
            case "item":
               _loc3_ = {
                  "action":_loc2_,
                  "item":param1.item
               };
               battleandaction = param1.item;
               this.attacker.setBattleAction(_loc3_);
               break;
            case "bloodline":
               if(this.attacker.isBattleDebuffActive(BloodlineData.EFFECT_MERIDIAN_BLOCK))
               {
                  this.attacker.setCommand("pass");
                  return;
               }
               battleandaction = "bloodline";
               this.attacker.setBattleAction(param1);
               break;
            case "senjutsu":
               battleandaction = "senjutsu";
               this.attacker.setBattleAction(param1);
               break;
            case "class_skill":
               _loc6_ = Central.main.SKILL_DATA[param1.skillId];
               _loc4_ = {};
               _loc4_.type = _loc6_.effect.type;
               _loc4_.duration = int(_loc6_.effect.duration) + 0;
               _loc4_.amount = int(_loc6_.effect.amount) + 0;
               if(_loc4_.type == BattleData.SKILL_2004)
               {
                  _loc3_ = {
                     "action":_loc2_,
                     "skillId":param1.skillId,
                     "posType":_loc6_.posType,
                     "dmg":0,
                     "effect":_loc4_
                  };
               }
               else
               {
                  _loc3_ = {
                     "action":_loc2_,
                     "skillId":param1.skillId,
                     "posType":_loc6_.posType,
                     "effect":_loc4_
                  };
               }
               battleandaction = param1.skillId;
               this.attacker.setBattleAction(_loc3_);
               break;
            default:
               this.attacker.setCommand("pass");
         }
      }
      
      private function setPetCommand(param1:Object) : void
      {
         var _loc2_:Object = this.defender.getBattleDebuff();
         if(_loc2_[BattleData.EFFECT_SLEEP] != null)
         {
            if(int(_loc2_[BattleData.EFFECT_SLEEP].duration) > 0)
            {
               this.attacker.setCommand("pass");
               return;
            }
         }
         this.attacker.setBattleAction();
         this.setDefenderById(Central.battle.getDefender().getCharacterId());
      }
      
      private function checkDodge() : void
      {
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc12_:String = null;
         var _loc15_:Object = null;
         var _loc16_:Number = NaN;
         var _loc17_:Number = NaN;
         var _loc18_:Object = null;
         var _loc19_:Object = null;
         var _loc20_:Object = null;
         var _loc21_:Object = null;
         var _loc22_:int = 0;
         var _loc23_:int = 0;
         var _loc24_:* = undefined;
         var _loc25_:Object = null;
         var _loc1_:Object = this.attacker.getBattleAction();
         var _loc2_:int = 0;
         _loc1_.dodge = false;
         this.attacker.setBattleAction(_loc1_);
         if(this.attacker.side == this.defender.side)
         {
            return;
         }
         if(_loc1_.action == BattleData.ACTION_SKILL)
         {
            _loc18_ = Central.main.SKILL_DATA[_loc1_.skillId];
            switch(_loc18_.effect_nature)
            {
               case SkillData.NATURE_BUFF:
                  return;
            }
         }
         var _loc5_:Object = this.attacker.getBattleBuff();
         var _loc6_:Object = this.attacker.getBattleDebuff();
         var _loc7_:Object = defender.getBattleBuff();
         var _loc8_:Object = defender.getBattleDebuff();
         var _loc9_:Number = NumberUtil.getRandom();
         var _loc10_:Number = 0;
         var _loc11_:Number = 0;
         _loc11_ = _loc11_ + this.defender.dodgeBonus;
         var _loc13_:int = this.CalculateBloodlineDodgebonus();
         _loc11_ += _loc13_;
         var _loc14_:Number = this.CalculateSenjutsuDodgebonus();
         _loc11_ += _loc14_;
         for(_loc12_ in _loc5_)
         {
            if(!_loc5_[_loc12_])
            {
               continue;
            }
            if(int(_loc5_[_loc12_].duration) <= 0)
            {
               continue;
            }
            switch(_loc12_)
            {
               case BattleData.EFFECT_THUNDERSTORM_MODE:
                  _loc10_ += Number(_loc5_[_loc12_].amount) / 100;
                  break;
               case BattleData.SKILL_234:
                  _loc10_ += Number(_loc5_[_loc12_].amount) / 100;
                  if(_loc5_[_loc12_].amount == 100)
                  {
                     _loc10_ += 99999;
                  }
                  break;
               case BattleData.EFFECT_PET_ATTENTION:
                  _loc10_ += int(_loc5_[_loc12_].amount) / 100;
                  break;
               case BattleData.EFFECT_PET_LIGHTNING:
                  _loc10_ += int(_loc5_[_loc12_].amount) / 100;
                  break;
               case BattleData.EFFECT_TURKEY_FEAST:
               case BattleData.EFFECT_ACCURATE:
                  _loc10_ += int(_loc5_[_loc12_].amount) / 100;
                  break;
               case BloodlineData.EFFECT_DMG_BONUS_AND_DODGE_REDUCTION:
                  _loc10_ += int(_loc5_[_loc12_].amount) / 100;
                  break;
               case SenjutsuData.EFFECT_SS_CRITICAL_N_DODGE_REDUCTION:
                  trace("2~~~~~in EFFECT_SS_CRITICAL_N_DODGE_REDUCTION");
                  if(this.attacker.hp / this.attacker.maxHP <= _loc5_[SenjutsuData.EFFECT_SS_SPIRIT_MODE].amount * 0.01)
                  {
                     trace("~~~~~this.attacker.hp / this.attacker.maxHP = " + this.attacker.hp / this.attacker.maxHP);
                     trace("~~~~~attackerBuff[SenjutsuData.EFFECT_SS_SPIRIT_MODE].amount = " + _loc5_[SenjutsuData.EFFECT_SS_SPIRIT_MODE].amount);
                     trace("~~~~~dodgeReduction = " + _loc10_);
                     _loc10_ += Number(_loc5_[_loc12_].chancetoeffect) / 100;
                     trace("~~~~~attackerBuff[key].chancetoeffect = " + _loc5_[_loc12_].chancetoeffect);
                     trace("~~~~~dodgeReduction = " + _loc10_);
                  }
                  break;
               case BattleData.EFFECT_ADD_DODGERE_ABOVE_HP:
                  _loc16_ = Number(_loc5_[_loc12_].amount);
                  _loc10_ += _loc16_ / 100;
                  break;
               case BattleData.EFFECT_ADD_DODGERE_BELOW_HP:
                  _loc16_ = Number(_loc5_[_loc12_].amount);
                  _loc10_ += _loc16_ / 100;
            }
         }
         for(_loc12_ in _loc6_)
         {
            if(!_loc6_[_loc12_])
            {
               continue;
            }
            if(int(_loc6_[_loc12_].duration) <= 0)
            {
               continue;
            }
            switch(_loc12_)
            {
               case BattleData.EFFECT_BLIND:
               case BattleData.EFFECT_ALL_CP_BLIND:
                  _loc11_ += Number(_loc6_[_loc12_].amount) / 100;
                  break;
               case BattleData.EFFECT_PET_BLIND:
                  _loc11_ += Number(_loc6_[_loc12_].amount) / 100;
                  break;
               case BattleData.EFFECT_HIDDEN_MIST:
               case BattleData.EFFECT_DARKNESS:
               case BattleData.EFFECT_BLOODY_MIST:
                  _loc11_ += int(_loc6_[_loc12_].amount) / 100;
                  break;
               case BattleData.EFFECT_ACCURATE_WEAPON:
                  _loc11_ += int(_loc6_[_loc12_].amount) / 100;
            }
         }
         for(_loc12_ in _loc7_)
         {
            if(!_loc7_[_loc12_])
            {
               continue;
            }
            if(int(_loc7_[_loc12_].duration) <= 0)
            {
               continue;
            }
            switch(_loc12_)
            {
               case BattleData.EFFECT_ALL_CP_DODGE_BONUS:
               case BattleData.EFFECT_DODGE_BONUS:
               case BattleData.EFFECT_PET_DODGE_BONUS:
               case BattleData.EFFECT_TURKEY_FEAST:
                  _loc11_ += int(_loc7_[_loc12_].amount) / 100;
            }
         }
         for(_loc12_ in _loc8_)
         {
            if(!_loc8_[_loc12_])
            {
               continue;
            }
            if(int(_loc8_[_loc12_].duration) <= 0)
            {
               continue;
            }
            switch(_loc12_)
            {
               case BattleData.EFFECT_DODGE_REDUCTION:
                  _loc10_ += Number(_loc8_[_loc12_].amount) / 100;
                  break;
               case BattleData.EFFECT_LIGHTING_BUNDLE:
               case BattleData.EFFECT_LIGHTING_BUNDLE_2:
               case BattleData.EFFECT_LIGHTING_BUNDLE_3:
               case BattleData.EFFECT_LIGHTING_BUNDLE_4:
                  _loc10_ += Number(_loc8_[_loc12_].amount) / 100;
                  break;
               case BattleData.EFFECT_CLEARBUFF_DODGEREDUCTION:
                  _loc10_ += Number(_loc8_[_loc12_].amount) / 100;
                  break;
               case BattleData.EFFECT_HIDDEN_MIST:
               case BattleData.EFFECT_DARKNESS:
               case BattleData.EFFECT_BLOODY_MIST:
                  _loc10_ += int(_loc8_[_loc12_].amount) / 100;
                  break;
               case BattleData.SKILL_342:
                  _loc10_ += int(_loc8_[_loc12_].amount) / 100;
            }
         }
         if(this.attackerWeapon)
         {
            for each(_loc15_ in this.attackerWeapon.effect)
            {
               switch(_loc15_.type)
               {
                  case BattleData.EFFECT_ADD_DODGE_BONUS:
                     _loc11_ += _loc15_.amount / 100;
                     break;
                  case BattleData.EFFECT_ADD_DODGE_RANDOM:
                     _loc9_ += _loc15_.amount / 100;
                     break;
                  case BattleData.EFFECT_ADD_DODGE_REDUCTION:
                     _loc10_ += _loc15_.amount / 100;
                     if(this.attackerWeapon.id == "wpn1596" && Boolean(this.attacker))
                     {
                        _loc4_ = Central.main.stateInventory.getStateOnCount(this.attacker.getCharacterId(),"wpn","wpn1596");
                        if(_loc4_ >= 0)
                        {
                           _loc3_ = _loc4_;
                        }
                        _loc10_ += 8 * _loc3_ / 100;
                     }
               }
            }
         }
         if(this.attackerBackItem)
         {
            for each(_loc15_ in this.attackerBackItem.effect)
            {
               switch(_loc15_.type)
               {
                  case BattleData.EFFECT_ADD_DODGE_RANDOM:
                     _loc9_ += _loc15_.amount / 100;
                     break;
                  case BattleData.EFFECT_REDUCE_DODGE_RANDOM:
                     _loc9_ -= _loc15_.amount / 100;
                     break;
                  case BattleData.EFFECT_ADD_DODGE_REDUCTION:
                     _loc10_ += _loc15_.amount / 100;
               }
            }
         }
         if(this.attackerAccessory)
         {
            for each(_loc15_ in this.attackerAccessory.effect)
            {
               switch(_loc15_.type)
               {
                  case BattleData.EFFECT_ADD_DODGE_RANDOM:
                     _loc9_ += _loc15_.amount / 100;
                     break;
                  case BattleData.EFFECT_REDUCE_DODGE_RANDOM:
                     _loc9_ -= _loc15_.amount / 100;
                     break;
                  case BattleData.EFFECT_ADD_DODGE_REDUCTION:
                     _loc10_ += _loc15_.amount / 100;
               }
            }
         }
         if(this.attacker.getGearset())
         {
            _loc19_ = this.attacker.getGearset();
            for(_loc12_ in _loc19_)
            {
               _loc20_ = Central.main.GEAR_SET_DATA.find(_loc12_);
               _loc2_ = 0;
               while(_loc2_ < _loc19_[_loc12_] - 1)
               {
                  _loc21_ = _loc20_.effect[_loc2_];
                  switch(_loc21_.type)
                  {
                     case BattleData.EFFECT_ADD_DODGE_REDUCTION:
                        _loc10_ += _loc15_.amount / 100;
                        break;
                     case BattleData.EFFECT_ADD_DODGE_RANDOM:
                        _loc9_ += _loc15_.amount / 100;
                  }
                  _loc2_++;
               }
            }
         }
         if(_loc1_.action == BattleData.ACTION_CLASS_SKILL)
         {
            if(_loc1_.effect.type == BattleData.SKILL_2004)
            {
               _loc10_ += 1;
            }
         }
         if(_loc1_.action == BattleData.ACTION_SKILL)
         {
            if(_loc1_.effect.type == BattleData.EFFECT_HUNDRED_PERCENT_ATTACK || _loc1_.effect.type == BattleData.EFFECT_BURN_CP_CLEAR_BUFF || _loc1_.effect.type == BattleData.EFFECT_BURN_CP_CLEAR_BUFF_WEAK || _loc1_.skillId == "skill709")
            {
               _loc10_ += 999;
            }
            else if(_loc1_.skillId == "skill669" || _loc1_.skillId == "skill719")
            {
               _loc10_ += 999;
            }
            else if(_loc1_.effect.type == BattleData.EFFECT_BURN_CP_HP)
            {
               _loc10_ += int(_loc1_.effect.duration) * 0.01;
            }
            else if(_loc1_.effect.type == BattleData.EFFECT_HIDDEN_MIST)
            {
               _loc10_ += 999;
            }
            else if(_loc1_.effect.type == BattleData.EFFECT_BURN_CP)
            {
               _loc10_ += int(_loc1_.effect.duration) * 0.01;
            }
            else if(_loc1_.effect.type == BattleData.EFFECT_CLEARBUFF_INTERNAL_INJURY_CHAOS)
            {
               _loc10_ += int(_loc1_.effect.amount) * 0.01;
            }
         }
         if(_loc1_.effect)
         {
            if(_loc1_.effect.type == BattleData.EFFECT_HUNDRED_PERCENT_ATTACK)
            {
               _loc10_ += 999;
            }
         }
         if(_loc1_.actoin == BattleData.ACTION_SKILL)
         {
            if(_loc1_.effect)
            {
               if(_loc1_.effect.type == BattleData.EFFECT_CRITICAL_DMG_N_DODGE_REDUCTION)
               {
                  _loc22_ = 0;
                  switch(_loc1_.target)
                  {
                     case "allEnemy":
                        _loc2_ = 0;
                        while(_loc2_ < this.characterArr.length)
                        {
                           if(this.characterArr[_loc2_].isDead == false && this.characterArr[_loc2_].side == this.defender.side)
                           {
                              _loc23_ = 0;
                              for(_loc24_ in this.characterArr[_loc2_].getBattleBuff())
                              {
                                 if(this.characterArr[_loc2_].getBattleBuff()[_loc24_].druration < 999)
                                 {
                                    _loc23_++;
                                 }
                              }
                              if(_loc23_ > _loc22_)
                              {
                                 _loc22_ = _loc23_;
                              }
                           }
                           _loc2_++;
                        }
                  }
                  _loc10_ += _loc1_.effect.amount * _loc22_ * 0.01;
               }
            }
         }
         if(defender.dodge - _loc10_ >= _loc9_ - _loc11_ && defender.getData(DBCharacterData.AGILITY) > 0)
         {
            Out.debug(this,"seal enemy dogde");
            _loc1_.dodge = true;
         }
         else
         {
            Out.debug(this,"seal enemy hasn\'t dogde");
            _loc1_.dodge = false;
         }
         if(this.defender.getWeapon())
         {
            _loc25_ = Central.main.WEAPON_DATA.find(this.defender.getWeapon());
            if(_loc25_)
            {
               for each(_loc15_ in _loc25_.effect)
               {
                  switch(_loc15_.type)
                  {
                     case BattleData.EFFECT_DODGE_SUCCESS_DAMAGE_BONUS:
                        if(_loc1_.dodge)
                        {
                           _loc1_.defenderBuff.push({
                              "type":BattleData.EFFECT_DAMAGE_BONUS,
                              "duration":_loc15_.duration,
                              "amount":_loc15_.amount
                           });
                        }
                  }
               }
            }
         }
         if(Central.mission.curMissionID == "msn0")
         {
            _loc1_.dodge = false;
         }
         this.attacker.setBattleAction(_loc1_);
      }
      
      public function checkCritical() : void
      {
         var _loc1_:String = null;
         var _loc8_:Object = null;
         var _loc9_:Object = null;
         var _loc10_:Object = null;
         var _loc11_:int = 0;
         var _loc12_:Object = null;
         var _loc2_:Number = NumberUtil.getRandom();
         var _loc3_:Number = Formula.calcCritical(this.attacker,Central.main.BLOODLINE_SKILL_DATA_ARR,Central.main.SENJUTSU_SKILL_DATA_ARR);
         var _loc4_:Object = this.attacker.getBattleDebuff();
         var _loc5_:Object = this.attacker.getBattleBuff();
         var _loc6_:Object = this.defender.getBattleDebuff();
         var _loc7_:Object = this.attacker.getBattleAction();
         _loc7_.critical = false;
         if(_loc7_.dodge == true || _loc7_.dmg == null)
         {
            _loc7_.critical = false;
            this.attacker.setBattleAction(_loc7_);
            return;
         }
         for(_loc1_ in _loc4_)
         {
            if(!_loc4_[_loc1_])
            {
               continue;
            }
            if(_loc4_[_loc1_].duration <= 0)
            {
               continue;
            }
            switch(_loc1_)
            {
               case BattleData.EFFECT_DISTRACT:
                  _loc2_ += _loc4_[_loc1_].amount;
            }
         }
         for(_loc1_ in _loc5_)
         {
            if(!_loc5_[_loc1_])
            {
               continue;
            }
            if(_loc5_[_loc1_].duration <= 0)
            {
               continue;
            }
            trace("check crit!!!!!!!!!attackerBuff[key].duration = " + _loc5_[_loc1_].duration);
            switch(_loc1_)
            {
               case BattleData.EFFECT_CRIT_CHANCE_DMG:
                  _loc2_ -= 0.15;
                  break;
               case BattleData.EFFECT_TURKEY_FEAST:
               case BattleData.EFFECT_ADD_CRITICAL_CHANCE:
               case BattleData.EFFECT_LOW_HP_CRITICAL_BONUS:
                  _loc2_ -= _loc5_[_loc1_].amount / 100;
                  break;
               case SenjutsuData.EFFECT_SS_CRITICAL_CHANCE_BONUS:
                  if(attacker.hp * 100 / attacker.maxHP < _loc5_[_loc1_].amount)
                  {
                     _loc2_ -= _loc5_[_loc1_].chancetoeffect / 100;
                  }
                  Out.debug(this,"EFFECT_SS_CRITICAL_CHANCE_BONUS rNum >> " + _loc2_);
                  break;
               case SenjutsuData.EFFECT_SS_CRITICAL_N_DODGE_REDUCTION:
                  trace("1!!!!!!!!!!!!!in EFFECT_SS_CRITICAL_N_DODGE_REDUCTION");
                  trace("!!!!!!!!!!!!!attackerBuff[key].amount = " + _loc5_[_loc1_].amount);
                  trace("!!!!!!!!!!!!!rNum = " + _loc2_);
                  if(this.attacker.hp / this.attacker.maxHP <= _loc5_[SenjutsuData.EFFECT_SS_SPIRIT_MODE].amount * 0.01)
                  {
                     trace("!!!!!!!!!!!!!this.attacker.hp / this.attacker.maxHP = " + this.attacker.hp / this.attacker.maxHP);
                     trace("!!!!!!!!!!!!!attackerBuff[SenjutsuData.EFFECT_SS_SPIRIT_MODE].amount = " + _loc5_[SenjutsuData.EFFECT_SS_SPIRIT_MODE].amount);
                     _loc2_ -= _loc5_[_loc1_].chancetoeffect / 100;
                     trace("!!!!!!!!!!!!!attackerBuff[key].chancetoeffect / 100 = " + _loc5_[_loc1_].chancetoeffect / 100);
                  }
            }
         }
         if(this.attacker.getGearset())
         {
            _loc9_ = this.attacker.getGearset();
            for(_loc1_ in _loc9_)
            {
               _loc10_ = Central.main.GEAR_SET_DATA.find(_loc1_);
               _loc11_ = 0;
               while(_loc11_ < _loc9_[_loc1_] - 1)
               {
                  _loc12_ = _loc10_.effect[_loc11_];
                  switch(_loc12_.type)
                  {
                     case BattleData.EFFECT_ADD_CRITICAL_CHANCE:
                        _loc2_ -= _loc12_.amount * 0.01;
                  }
                  _loc11_++;
               }
            }
         }
         if(this.attackerWeapon)
         {
            for each(_loc8_ in this.attackerWeapon.effect)
            {
               switch(_loc8_.type)
               {
                  case BattleData.EFFECT_ADD_CRITICAL_CHANCE:
                     _loc2_ -= _loc8_.amount / 100;
               }
            }
         }
         if(this.attackerBackItem)
         {
            for each(_loc8_ in this.attackerBackItem.effect)
            {
               switch(_loc8_.type)
               {
                  case BattleData.EFFECT_ADD_CRITICAL_CHANCE:
                     _loc2_ -= _loc8_.amount / 100;
               }
            }
         }
         if(this.attackerAccessory)
         {
            for each(_loc8_ in this.attackerAccessory.effect)
            {
               switch(_loc8_.type)
               {
                  case BattleData.EFFECT_ADD_CRITICAL_CHANCE:
                     _loc2_ -= _loc8_.amount / 100;
               }
            }
         }
         if(_loc7_.effect)
         {
            if(_loc7_.effect.type == BattleData.SKILL_304)
            {
               if(this.attacker.isBattleBuffActive(BattleData.SKILL_302))
               {
                  _loc2_ = 0;
               }
            }
         }
         if(_loc2_ <= _loc3_)
         {
            _loc7_.critical = true;
         }
         if(_loc7_.effect)
         {
            if(_loc7_.effect.type == BattleData.EFFECT_PARALYZE)
            {
               if(_loc2_ <= _loc7_.effect.amount * 0.01)
               {
                  _loc7_.critical = true;
               }
               else
               {
                  _loc7_.critical = false;
               }
            }
         }
         if(Central.mission.curMissionID == "msn0")
         {
            _loc7_.critical = false;
         }
         this.attacker.setBattleAction(_loc7_);
      }
      
      public function checkStun() : void
      {
         var _loc4_:uint = 0;
         var _loc5_:Number = NaN;
         var _loc6_:Array = null;
         var _loc7_:String = null;
         var _loc8_:Boolean = false;
         var _loc1_:Object = this.attacker.getBattleAction();
         if(_loc1_.dodge == true)
         {
            _loc1_.stun = false;
            this.attacker.setBattleAction(_loc1_);
            return;
         }
         var _loc2_:Number = NumberUtil.getRandom();
         var _loc3_:int = 0;
         this.defender.reseteffectResistance();
         this.attacker.reseteffectResistance();
         this.defender.initResistance();
         this.attacker.initResistance();
         if(_loc1_.effect)
         {
            if(this.defender.effectResistance)
            {
               _loc6_ = this.defender.effectResistance;
               _loc4_ = 0;
               while(_loc4_ < _loc6_.length)
               {
                  _loc8_ = false;
                  _loc5_ = NumberUtil.getRandom();
                  if(_loc1_.action == "skill")
                  {
                     if(_loc6_[_loc4_].type == _loc1_.effect.type && _loc5_ <= _loc6_[_loc4_].change / 100)
                     {
                        _loc3_ = 1;
                     }
                  }
                  if(_loc1_.action == "bloodline")
                  {
                     if(Boolean(_loc1_.effect.effect_type_1) && _loc1_.effect.effect_type_1 != "")
                     {
                        if(_loc6_[_loc4_].type == _loc1_.effect.effect_type_1 && _loc5_ <= _loc6_[_loc4_].change / 100)
                        {
                           _loc1_.effect["effect_resisted_1"] = true;
                           _loc3_ = 1;
                        }
                        else if(_loc6_[_loc4_].type == _loc1_.effect.effect_type_1)
                        {
                           _loc1_.effect["effect_resisted_1"] = false;
                        }
                     }
                     if(Boolean(_loc1_.effect.effect_type_2) && _loc1_.effect.effect_type_2 != "")
                     {
                        if(_loc6_[_loc4_].type == _loc1_.effect.effect_type_2 && _loc5_ <= _loc6_[_loc4_].change / 100)
                        {
                           _loc1_.effect["effect_resisted_2"] = true;
                           _loc3_ = 1;
                        }
                        else if(_loc6_[_loc4_].type == _loc1_.effect.effect_type_2)
                        {
                           _loc1_.effect["effect_resisted_2"] = false;
                        }
                     }
                     if(Boolean(_loc1_.effect.effect_type_3) && _loc1_.effect.effect_type_3 != "")
                     {
                        if(_loc6_[_loc4_].type == _loc1_.effect.effect_type_3 && _loc5_ <= _loc6_[_loc4_].change / 100)
                        {
                           _loc1_.effect["effect_resisted_3"] = true;
                           _loc3_ = 1;
                        }
                        else if(_loc6_[_loc4_].type == _loc1_.effect.effect_type_3)
                        {
                           _loc1_.effect["effect_resisted_3"] = false;
                        }
                     }
                  }
                  if(_loc1_.action == "senjutsu")
                  {
                     if(Boolean(_loc1_.effect.effect_type_1) && _loc1_.effect.effect_type_1 != "")
                     {
                        if(_loc6_[_loc4_].type == _loc1_.effect.effect_type_1 && _loc5_ <= _loc6_[_loc4_].change / 100)
                        {
                           _loc1_.effect["effect_resisted_1"] = true;
                           _loc3_ = 1;
                        }
                        else if(_loc6_[_loc4_].type == _loc1_.effect.effect_type_1)
                        {
                           _loc1_.effect["effect_resisted_1"] = false;
                        }
                     }
                     if(Boolean(_loc1_.effect.effect_type_2) && _loc1_.effect.effect_type_2 != "")
                     {
                        if(_loc6_[_loc4_].type == _loc1_.effect.effect_type_2 && _loc5_ <= _loc6_[_loc4_].change / 100)
                        {
                           _loc1_.effect["effect_resisted_2"] = true;
                           _loc3_ = 1;
                        }
                        else if(_loc6_[_loc4_].type == _loc1_.effect.effect_type_2)
                        {
                           _loc1_.effect["effect_resisted_2"] = false;
                        }
                     }
                     if(Boolean(_loc1_.effect.effect_type_3) && _loc1_.effect.effect_type_3 != "")
                     {
                        if(_loc6_[_loc4_].type == _loc1_.effect.effect_type_3 && _loc5_ <= _loc6_[_loc4_].change / 100)
                        {
                           _loc1_.effect["effect_resisted_3"] = true;
                           _loc3_ = 1;
                        }
                        else if(_loc6_[_loc4_].type == _loc1_.effect.effect_type_3)
                        {
                           _loc1_.effect["effect_resisted_3"] = false;
                        }
                     }
                  }
                  _loc4_++;
               }
            }
         }
         _loc1_.stun = true;
         this.attacker.setBattleAction(_loc1_);
      }
      
      public function checkDamageModifier() : void
      {
         var _loc1_:Object = this.attacker.getBattleAction();
         if(_loc1_.dodge == true || _loc1_.dmg == null)
         {
            return;
         }
         this.attacker.setBattleAction(_loc1_);
      }
      
      public function checkFeedback() : void
      {
         var _loc1_:Number = NaN;
         var _loc3_:Object = null;
         var _loc4_:Object = null;
         var _loc5_:Object = null;
         var _loc6_:Object = null;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:Object = null;
         var _loc10_:int = 0;
         var _loc11_:Object = null;
         var _loc12_:int = 0;
         var _loc13_:Object = null;
         var _loc14_:Object = null;
         var _loc15_:Object = null;
         var _loc16_:* = undefined;
         var _loc17_:int = 0;
         var _loc18_:Object = null;
         var _loc19_:Object = null;
         var _loc20_:Object = null;
         var _loc21_:Object = null;
         var _loc2_:Object = this.attacker.getBattleAction();
         if(_loc2_.dodge == true)
         {
            _loc2_.feedback = null;
            _loc2_.AttackerRandomSkillSlot = 999;
            _loc2_.DefenderRandomSkillSlot = 999;
            this.attacker.setBattleAction(_loc2_);
            return;
         }
         if(this.attacker.isBattleBuffActive(BloodlineData.EFFECT_SKIP_DEAD_CLEAR_DEBUFF))
         {
            trace("checkFeedback 111111111111111111111111111111111111111111111111");
            return;
         }
         if(this.attacker != this.defender)
         {
            _loc6_ = this.defender.getBattleBuff();
            if(Boolean(this.defender.isBattleBuffActive(BattleData.EFFECT_REACTIVE_DEBUFF)) && this.attacker.type != this.attacker.TYPE_PET)
            {
               _loc10_ = NumberUtil.randomInt(1,4);
               _loc11_ = {};
               switch(_loc10_)
               {
                  case 1:
                     _loc11_.type = BattleData.EFFECT_STUN;
                     break;
                  case 2:
                     _loc11_.type = BattleData.EFFECT_SLEEP;
                     break;
                  case 3:
                     _loc11_.type = BattleData.EFFECT_BUNDLE;
                     break;
                  default:
                     _loc11_.type = BattleData.EFFECT_MERIDIANS_SEAL;
               }
               _loc11_.duration = _loc6_[BattleData.EFFECT_REACTIVE_DEBUFF].amount;
               _loc11_.amount = 0;
               _loc2_.reactiveEffect = this.setDebuff(this.attacker,_loc11_);
               defender.removeBuff(BattleData.EFFECT_REACTIVE_DEBUFF);
            }
            _loc7_ = 0;
            _loc8_ = 0;
            if(int(this.defender.getData(DBCharacterData.EARTH)) >= 0)
            {
               _loc7_ += int(this.defender.getData(DBCharacterData.EARTH)) * (4 / 1000);
            }
            if(this.defender.getWeapon())
            {
               _loc3_ = Central.main.WEAPON_DATA.find(this.defender.getWeapon());
               if(_loc3_)
               {
                  for each(_loc9_ in _loc3_.effect)
                  {
                     switch(_loc9_.type)
                     {
                        case BattleData.EFFECT_ADD_FEEDBACK_CHANCE:
                           _loc7_ += _loc9_.amount / 100;
                     }
                  }
               }
            }
            if(this.defender.getBackItem())
            {
               _loc4_ = Central.main.BACK_ITEM_DATA.find(this.defender.getBackItem());
               if(_loc4_)
               {
                  for each(_loc9_ in _loc4_.effect)
                  {
                     switch(_loc9_.type)
                     {
                        case BattleData.EFFECT_ADD_FEEDBACK_CHANCE:
                           _loc7_ += _loc9_.amount / 100;
                     }
                  }
               }
            }
            if(this.defender.getAccessory())
            {
               _loc5_ = Central.main.ACCESSORY_DATA.find(this.defender.getAccessory());
               if(_loc5_)
               {
                  for each(_loc9_ in _loc5_.effect)
                  {
                     switch(_loc9_.type)
                     {
                        case BattleData.EFFECT_ADD_FEEDBACK_CHANCE:
                           _loc7_ += _loc9_.amount * 0.01;
                     }
                  }
               }
            }
            if(this.defender.isBattleBuffActive(BattleData.EFFECT_REACTIVE_FORCE))
            {
               _loc7_ += int(_loc6_[BattleData.EFFECT_REACTIVE_FORCE].chance) / 100;
            }
            if(this.defender.isBattleBuffActive(BattleData.EFFECT_SAND_GUARD))
            {
               _loc7_ += (int(_loc6_[BattleData.EFFECT_SAND_GUARD].amount) + 10) / 100;
            }
            if(this.defender.isBattleBuffActive(BattleData.EFFECT_ATTACKER_BURNING))
            {
               _loc9_ = {
                  "type":BattleData.EFFECT_BURNING,
                  "duration":3,
                  "amount":5
               };
               canburning = true;
               _loc2_.attackerDebuff.push(_loc9_);
            }
            if(this.defender.isBattleBuffActive(BattleData.EFFECT_PET_ENERGIZE))
            {
               _loc7_ += int(this.defender.getBattleBuff()[BattleData.EFFECT_PET_ENERGIZE].amount) / 100;
            }
            if(this.defender.isBattleDebuffActive(BattleData.EFFECT_PET_DISORIENTED))
            {
               _loc7_ -= int(this.defender.getBattleDebuff()[BattleData.EFFECT_PET_DISORIENTED].amount) / 100;
            }
            if(this.defender.isBattleDebuffActive(BattleData.SKILL_304))
            {
               _loc7_ -= int(this.defender.getBattleDebuff()[BattleData.SKILL_304].amount) / 100;
            }
            _loc1_ = NumberUtil.getRandom();
            if(_loc7_ >= _loc1_)
            {
               _loc12_ = 0;
               _loc13_ = {};
               _loc13_.damage = Math.round(Math.abs(_loc2_.dmg) * (0.3 + _loc8_));
               _loc13_.type = BattleData.EFFECT_REACTIVE_FORCE;
               this.setBattleActionFeedback(_loc2_,_loc13_);
               if(this.defender.getBackItem())
               {
                  _loc4_ = Central.main.BACK_ITEM_DATA.find(this.defender.getBackItem());
                  if(_loc4_)
                  {
                     for each(_loc14_ in _loc4_.effect)
                     {
                        switch(_loc14_.type)
                        {
                           case BattleData.EFFECT_FEEDBACK_RESTORE_HP:
                              if(NumberUtil.getRandom() <= _loc14_.chance / 100)
                              {
                                 _loc2_.defenderRestoreHp += Math.round(this.defender.maxHP * (_loc14_.amount / 100));
                                 _loc12_ = Math.round(this.defender.maxHP * (_loc14_.amount / 100));
                                 _loc12_ = this.updateHP(this.defender,_loc12_);
                              }
                        }
                     }
                  }
               }
            }
            if(this.defender.isBattleBuffActive(BattleData.EFFECT_BERSERKER_MODE))
            {
               if(_loc2_.action != "class_skill" || _loc2_.action == "class_skill" && _loc2_.effect.type != BattleData.SKILL_2004)
               {
                  _loc15_ = {};
                  _loc15_.damage = Math.round(Math.abs(_loc2_.dmg));
                  _loc15_.type = BattleData.EFFECT_BERSERKER_MODE;
                  this.setBattleActionFeedback(_loc2_,_loc15_);
               }
            }
            if(this.defender.isBattleBuffActive(BloodlineData.EFFECT_PASSIVE_STUN + ".skill1039"))
            {
               _loc16_ = int(_loc6_[BloodlineData.EFFECT_PASSIVE_STUN + ".skill1039"].chancetohit);
               _loc17_ = Math.random() * 100;
               if(_loc17_ < _loc16_)
               {
                  _loc18_ = {};
                  _loc18_.type = BattleData.EFFECT_STUN;
                  _loc18_.duration = 2;
                  this.setDebuff(this.attacker,_loc18_);
                  _loc19_ = {};
                  _loc19_.type = BloodlineData.EFFECT_PASSIVE_STUN;
                  this.setBattleActionFeedback(_loc2_,_loc19_);
               }
            }
            if(_loc2_.feedback_skipcheck)
            {
               for each(_loc20_ in _loc2_.feedback_skipcheck)
               {
                  if(!_loc2_.feedback)
                  {
                     _loc2_.feedback = new Array();
                  }
                  _loc2_.feedback.push(_loc20_);
               }
               delete _loc2_.feedback_skipcheck;
            }
            if(_loc2_.feedback != null)
            {
               for each(_loc21_ in _loc2_.feedback)
               {
                  if(this.defender.hp > 0)
                  {
                     if(_loc21_.damage)
                     {
                        this.updateHP(this.attacker,0 - _loc21_.damage);
                     }
                  }
               }
            }
         }
         this.attacker.setBattleAction(_loc2_);
      }
      
      private function checkFeedbackEffectBefore() : void
      {
         var _loc1_:Number = NaN;
         var _loc4_:String = null;
         var _loc5_:Object = null;
         var _loc6_:Array = null;
         var _loc7_:String = null;
         var _loc8_:String = null;
         var _loc9_:Boolean = false;
         var _loc2_:Object = this.attacker.getBattleAction();
         var _loc3_:Object = this.defender.getBattleBuff();
         for(_loc4_ in _loc3_)
         {
            _loc6_ = [];
            if(!_loc3_[_loc4_])
            {
               continue;
            }
            if(int(_loc3_[_loc4_].duration) <= 0)
            {
               continue;
            }
            _loc6_ = _loc4_.split(".");
            if(_loc6_)
            {
               _loc7_ = _loc6_[0];
               _loc8_ = _loc6_[1];
            }
            if(_loc3_[_loc4_].chancetoeffect == null)
            {
               if(int(_loc3_[_loc4_].chancetoeffect) <= 0)
               {
                  _loc7_ = null;
               }
            }
            if(_loc7_ == null)
            {
               continue;
            }
            switch(_loc7_)
            {
               case BloodlineData.EFFECT_REFLECT_DAMAGE:
                  _loc1_ = NumberUtil.getRandom();
                  if(_loc1_ <= int(_loc3_[_loc4_].chancetoeffect) / 100)
                  {
                     _loc2_.rebound = true;
                     _loc2_.reboundDamage = int(_loc3_[_loc4_].amount);
                  }
                  break;
               case BloodlineData.EFFECT_REFLECT_GENJUTSU:
                  _loc1_ = NumberUtil.getRandom();
                  if(_loc1_ <= int(_loc3_[_loc4_].chancetoeffect) / 100)
                  {
                     if(_loc2_.action == BattleData.ACTION_SKILL && this.attacker.getCharacterId() != this.defender.getCharacterId())
                     {
                        _loc5_ = Central.main.SKILL_DATA[_loc2_.skillId];
                        if(_loc5_)
                        {
                           if(_loc5_.type == SkillData.TYPE_GENJUTSU)
                           {
                              _loc9_ = true;
                              if(Boolean(this.defender.isBattleDebuffActive(BattleData.EFFECT_BUNDLE)) || Boolean(this.defender.isBattleDebuffActive(BattleData.EFFECT_MERIDIANS_SEAL)) || Boolean(this.defender.isBattleDebuffActive(BattleData.EFFECT_ECSTATIC_SOUND)) || Boolean(this.defender.isBattleDebuffActive(BattleData.EFFECT_STUN)) || Boolean(this.defender.isBattleDebuffActive(BattleData.EFFECT_SLEEP)) || Boolean(this.defender.isBattleDebuffActive(BloodlineData.EFFECT_MERIDIAN_BLOCK)) || Boolean(this.defender.isBattleDebuffActive(BattleData.SKILL_377)))
                              {
                                 _loc9_ = false;
                              }
                              if(_loc5_.target == SkillData.TARGET_SINGLE_FRIENDLY)
                              {
                                 _loc9_ = false;
                              }
                              if(_loc9_)
                              {
                                 _loc2_.reflectEffect = _loc2_.effect;
                                 _loc2_.reflectEffect.resisted = false;
                                 _loc2_.effect = null;
                              }
                           }
                        }
                     }
                  }
            }
         }
         this.attacker.setBattleAction(_loc2_);
      }
      
      public function checkFeedbackEffectAfter() : void
      {
         var _loc1_:Number = NaN;
         var _loc4_:String = null;
         var _loc5_:Object = null;
         var _loc6_:Array = null;
         var _loc7_:String = null;
         var _loc8_:String = null;
         var _loc9_:Array = null;
         var _loc2_:Object = this.attacker.getBattleAction();
         var _loc3_:Object = this.defender.getBattleBuff();
         _loc2_ = this.reactiveBufforDebuffTarget(_loc2_);
         for(_loc4_ in _loc3_)
         {
            _loc6_ = [];
            if(!_loc3_[_loc4_])
            {
               continue;
            }
            if(int(_loc3_[_loc4_].duration) <= 0)
            {
               continue;
            }
            _loc6_ = _loc4_.split(".");
            if(_loc6_)
            {
               _loc7_ = _loc6_[0];
               _loc8_ = _loc6_[1];
            }
            if(_loc3_[_loc4_].chancetoeffect == null)
            {
               if(int(_loc3_[_loc4_].chancetoeffect) <= 0)
               {
                  _loc7_ = null;
               }
            }
            if(_loc7_ == null)
            {
               continue;
            }
            switch(_loc7_)
            {
               case BloodlineData.EFFECT_COPY_JUTSU:
                  _loc1_ = NumberUtil.getRandom();
                  if(_loc1_ <= int(_loc3_[_loc4_].chancetoeffect) / 100)
                  {
                     if(_loc2_.action == BattleData.ACTION_SKILL && this.attacker.getCharacterId() != this.defender.getCharacterId())
                     {
                        _loc9_ = [];
                        _loc9_.push(SkillData.TYPE_GENJUTSU);
                        _loc9_.push(SkillData.TYPE_TAIJUTSU);
                        _loc9_.push(SkillData.TYPE_EARTH);
                        _loc9_.push(SkillData.TYPE_FIRE);
                        _loc9_.push(SkillData.TYPE_LIGHTNING);
                        _loc9_.push(SkillData.TYPE_WATER);
                        _loc9_.push(SkillData.TYPE_WIND);
                        _loc5_ = Central.main.SKILL_DATA[_loc2_.skillId];
                        if(_loc5_)
                        {
                           if(_loc9_.indexOf(_loc5_.type) >= 0 && this.defender.cp >= _loc2_.cp && !this.defender.isBattleDebuffActive(BattleData.EFFECT_BUNDLE) && !this.defender.isBattleDebuffActive(BattleData.EFFECT_MERIDIANS_SEAL) && !this.defender.isBattleDebuffActive(BattleData.EFFECT_ECSTATIC_SOUND) && !this.defender.isBattleDebuffActive(BattleData.EFFECT_STUN) && !this.defender.isBattleDebuffActive(BattleData.EFFECT_SLEEP) && !this.defender.isBattleDebuffActive(BloodlineData.EFFECT_MERIDIAN_BLOCK) && !this.defender.isBattleDebuffActive(BattleData.SKILL_377))
                           {
                              _loc2_.copyJutsu = true;
                           }
                           if(_loc2_.effect)
                           {
                              if(_loc2_.effect.type == BattleData.EFFECT_STUN && _loc2_.stun == true)
                              {
                                 _loc2_.copyJutsu = false;
                              }
                              if(_loc2_.effect.target == SkillData.TARGET_SINGLE_FRIENDLY)
                              {
                                 _loc2_.copyJutsu = false;
                              }
                           }
                        }
                     }
                  }
            }
         }
         this.attacker.setBattleAction(_loc2_);
      }
      
      private function checkExtraAttack() : void
      {
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc13_:Object = null;
         var _loc14_:int = 0;
         var _loc15_:int = 0;
         var _loc16_:Array = null;
         var _loc17_:int = 0;
         var _loc18_:int = 0;
         var _loc19_:Object = null;
         var _loc20_:Object = null;
         var _loc21_:Object = null;
         var _loc22_:Number = NaN;
         var _loc23_:Array = null;
         var _loc24_:String = null;
         var _loc25_:int = 0;
         var _loc26_:int = 0;
         var _loc27_:int = 0;
         var _loc28_:Object = null;
         var _loc29_:Object = null;
         var _loc30_:Object = null;
         var _loc31_:int = 0;
         var _loc32_:Object = null;
         var _loc33_:int = 0;
         var _loc34_:Object = null;
         var _loc35_:int = 0;
         var _loc1_:Object = this.attacker.getBattleAction();
         var _loc2_:Boolean = false;
         var _loc3_:Boolean = false;
         var _loc4_:Boolean = false;
         var _loc5_:Boolean = false;
         var _loc6_:Boolean = false;
         var _loc7_:Boolean = false;
         var _loc8_:Boolean = false;
         var _loc9_:Boolean = false;
         if(_loc1_.action == "skill")
         {
            _loc13_ = Central.main.SKILL_DATA[_loc1_.skillId];
         }
         _loc1_.exat = false;
         _loc1_.toad = false;
         _loc1_.toadbig = false;
         _loc1_.titana = false;
         _loc1_.titanc = false;
         _loc1_.titanb = false;
         _loc1_.titan = false;
         _loc1_.toadef = false;
         if(_loc1_.action == "bloodline")
         {
            if(_loc1_.effect != null)
            {
               if(_loc1_.effect.effect_type_1 == BloodlineData.EFFECT_TITAN || _loc1_.effect.effect_type_2 == BloodlineData.EFFECT_TITAN || _loc1_.effect.effect_type_3 == BloodlineData.EFFECT_TITAN)
               {
                  _loc2_ = true;
               }
            }
         }
         if(_loc1_.action == "skill" && (_loc1_.skillId == "skill813" || _loc1_.skillId == "skill814" || _loc1_.skillId == "skill815"))
         {
            if(_loc1_.effect.type == BattleData.EFFECT_TITAN_DMG_BONUS_BURN)
            {
               _loc3_ = true;
            }
            if(_loc1_.effect.type == BattleData.EFFECT_TITAN_DMG_BONUS_REDUCE_BURN)
            {
               _loc4_ = true;
            }
            if(_loc1_.effect.type == BattleData.EFFECT_TITAN_DMG_BONUS_REDUCE_CUT_CLEAR)
            {
               _loc5_ = true;
            }
         }
         if(_loc1_.action == "skill" && _loc1_.skillId == "skill900")
         {
            _loc6_ = true;
         }
         if(_loc1_.action == "skill" && _loc1_.skillId == "skill901")
         {
            _loc7_ = true;
         }
         if(_loc1_.action == "skill" && _loc1_.skillId == "skill5016")
         {
            _loc8_ = true;
         }
         var _loc12_:Array = _loc1_.dmgArr;
         if(_loc12_)
         {
            _loc14_ = 0;
            while(_loc14_ < _loc12_.length)
            {
               if(_loc12_[_loc14_].dmg != 0)
               {
                  _loc9_ = true;
               }
               _loc14_++;
            }
         }
         if(Boolean(this.attacker.isBattleBuffActive(BloodlineData.EFFECT_TITAN)) && _loc2_ == false)
         {
            if(this.attacker.hp > 0 && this.defender.hp > 0 && this.attacker.getCharacterId() != this.defender.getCharacterId() && this.attacker.side != this.defender.side && _loc1_.dmg != null && _loc9_ == true)
            {
               _loc14_ = 0;
               _loc15_ = 0;
               _loc16_ = this.attacker.getBloodlineListArr();
               _loc17_ = 0;
               _loc18_ = 0;
               while(_loc18_ < _loc16_.length)
               {
                  if(_loc16_[_loc18_].skill_id == "1021")
                  {
                     _loc17_ = int(_loc16_[_loc18_].level);
                  }
                  _loc18_++;
               }
               _loc10_ = NumberUtil.getRandom();
               if(_loc10_ <= _loc17_ / 100)
               {
                  _loc1_.titanstun = true;
               }
               else
               {
                  _loc1_.titanstun = false;
               }
               _loc19_ = Central.main.BLOODLINE_SKILL_DATA["bloodline_skill1021"];
               _loc20_ = {};
               _loc14_ = 0;
               while(_loc14_ < 10)
               {
                  if(_loc19_.effect[_loc14_].skill_level == _loc17_)
                  {
                     _loc20_ = _loc19_.effect[_loc14_];
                  }
                  _loc14_++;
               }
               _loc15_ = Math.round(_loc20_.skill_damage / 100 * this.attacker.getLevel());
               if(_loc1_.critical)
               {
                  _loc15_ *= attacker.criticalBonus;
               }
               _loc1_.titan = true;
               _loc1_.titanDamage = _loc15_;
               if(_loc1_.titanstun == true)
               {
                  _loc21_ = {
                     "type":BloodlineData.EFFECT_STUN,
                     "duration":2,
                     "amount":0
                  };
                  this.defender.initResistance();
                  if(this.defender.effectResistance)
                  {
                     _loc23_ = this.defender.effectResistance;
                     _loc14_ = 0;
                     while(_loc14_ < _loc23_.length)
                     {
                        _loc22_ = NumberUtil.getRandom();
                        if(_loc23_[_loc14_].type == _loc21_.type && _loc22_ <= _loc23_[_loc14_].change / 100)
                        {
                           _loc21_["resisted"] = true;
                        }
                        _loc14_++;
                     }
                  }
                  _loc1_.titanEffect = this.setDebuff(this.defender,_loc21_);
               }
            }
         }
         if(Boolean(this.attacker.isBattleBuffActive(BattleData.EFFECT_HANAMI_EXTRA_ATTACK)) && _loc8_ == false)
         {
            if(this.attacker.hp > 0 && this.defender.hp > 0 && this.attacker.getCharacterId() != this.defender.getCharacterId() && this.attacker.side != this.defender.side && _loc1_.dmg != null && _loc9_ == true && (_loc1_.action == "skill" || _loc1_.action == "weapon_attack" || _loc1_.action == "attack"))
            {
               if(_loc1_.action == "skill")
               {
                  if(_loc13_.type != SkillData.TYPE_GENJUTSU)
                  {
                     _loc25_ = NumberUtil.randomInt(350,880);
                     if(_loc1_.critical)
                     {
                        _loc25_ *= attacker.criticalBonus;
                     }
                     _loc1_.exat = true;
                     _loc1_.exatDamagea = _loc25_;
                  }
               }
               else
               {
                  _loc25_ = NumberUtil.randomInt(350,880);
                  if(_loc1_.critical)
                  {
                     _loc25_ *= attacker.criticalBonus;
                  }
                  _loc1_.exat = true;
                  _loc1_.exatDamagea = _loc25_;
               }
            }
         }
         if(Boolean(this.attacker.isBattleBuffActive(BattleData.EFFECT_GIANT_TOAD)) && _loc6_ == false)
         {
            if(this.attacker.hp > 0 && this.defender.hp > 0 && this.attacker.getCharacterId() != this.defender.getCharacterId() && this.attacker.side != this.defender.side && _loc1_.dmg != null && _loc9_ == true)
            {
               _loc10_ = NumberUtil.getRandom();
               _loc26_ = 0;
               _loc26_ = 200;
               if(_loc1_.critical)
               {
                  _loc26_ *= attacker.criticalBonus;
               }
               _loc1_.toad = true;
               _loc1_.toadDamagea = _loc26_;
            }
         }
         if(Boolean(this.attacker.isBattleBuffActive(BattleData.EFFECT_GIANT_TOAD_BIG)) && _loc7_ == false)
         {
            if(this.attacker.hp > 0 && this.defender.hp > 0 && this.attacker.getCharacterId() != this.defender.getCharacterId() && this.attacker.side != this.defender.side && _loc1_.dmg != null && _loc9_ == true)
            {
               _loc27_ = 0;
               _loc27_ = 500;
               if(_loc1_.critical)
               {
                  _loc27_ *= attacker.criticalBonus;
               }
               _loc1_.toadbig = true;
               _loc1_.toadbigDamagea = _loc27_;
               if(_loc1_.dodge != true)
               {
                  _loc10_ = NumberUtil.getRandom();
                  _loc11_ = NumberUtil.getRandom();
                  if(_loc10_ <= 0.1)
                  {
                     _loc1_.toadef = true;
                     _loc28_ = {
                        "type":BattleData.EFFECT_STUN,
                        "duration":3,
                        "amount":0
                     };
                  }
                  if(_loc11_ <= 0.5)
                  {
                     _loc1_.toadef = true;
                     _loc29_ = {
                        "type":BattleData.EFFECT_BLEEDING,
                        "duration":3,
                        "amount":20
                     };
                  }
                  if(_loc10_ <= 0.1 && _loc11_ <= 0.5)
                  {
                     _loc30_ = {
                        "type":BattleData.EFFECT_BLEEDING_STUN,
                        "duration":3,
                        "amount":20
                     };
                     _loc1_.toadef = true;
                     this.setDebuff(this.defender,_loc28_);
                     this.setDebuff(this.defender,_loc29_);
                     _loc1_.toadbigEffect = this.setDebuff(this.defender,_loc30_);
                     _loc1_.showa = false;
                     _loc1_.showb = false;
                     _loc1_.showall = true;
                  }
                  else if(_loc10_ > 0.1 && _loc11_ > 0.5)
                  {
                     _loc1_.showa = false;
                     _loc1_.showb = false;
                     _loc1_.showall = false;
                  }
                  else if(_loc10_ <= 0.1 && _loc11_ > 0.5)
                  {
                     _loc1_.toadbigEffect = this.setDebuff(this.defender,_loc28_);
                     _loc1_.showa = true;
                     _loc1_.showb = false;
                     _loc1_.showall = false;
                  }
                  else if(_loc10_ > 0.1 && _loc11_ <= 0.5)
                  {
                     _loc1_.toadbigEffect = this.setDebuff(this.defender,_loc29_);
                     _loc1_.showa = false;
                     _loc1_.showb = true;
                     _loc1_.showall = false;
                  }
               }
            }
         }
         if(Boolean(this.attacker.isBattleBuffActive(BattleData.EFFECT_SUSANOO)) && _loc3_ == false)
         {
            if(this.attacker.hp > 0 && this.defender.hp > 0 && this.attacker.getCharacterId() != this.defender.getCharacterId() && this.attacker.side != this.defender.side && _loc1_.dmg != null && _loc9_ == true)
            {
               _loc31_ = 0;
               _loc31_ = 300;
               if(_loc1_.critical)
               {
                  _loc31_ *= attacker.criticalBonus;
               }
               _loc1_.titanc = true;
               _loc1_.titanDamagec = _loc31_;
               if(_loc1_.dodge != true)
               {
                  _loc32_ = {
                     "type":BattleData.EFFECT_PET_BURN,
                     "duration":3,
                     "amount":5
                  };
                  canpetburn = true;
                  _loc1_.titanEffectc = this.setDebuff(this.defender,_loc32_);
               }
            }
         }
         if(Boolean(this.attacker.isBattleBuffActive(BattleData.EFFECT_SUSANOOA)) && _loc4_ == false)
         {
            if(this.attacker.hp > 0 && this.defender.hp > 0 && this.attacker.getCharacterId() != this.defender.getCharacterId() && this.attacker.side != this.defender.side && _loc1_.dmg != null && _loc9_ == true)
            {
               _loc33_ = 0;
               _loc33_ = 400;
               if(_loc1_.critical)
               {
                  _loc33_ *= attacker.criticalBonus;
               }
               _loc1_.titana = true;
               _loc1_.titanDamagea = _loc33_;
               if(_loc1_.dodge != true)
               {
                  _loc34_ = {
                     "type":BattleData.EFFECT_PET_BURN,
                     "duration":3,
                     "amount":5
                  };
                  canpetburn = true;
                  _loc1_.titanEffecta = this.setDebuff(this.defender,_loc34_);
               }
            }
         }
         if(Boolean(this.attacker.isBattleBuffActive(BattleData.EFFECT_SUSANOOB)) && _loc5_ == false)
         {
            if(this.attacker.hp > 0 && this.defender.hp > 0 && this.attacker.getCharacterId() != this.defender.getCharacterId() && this.attacker.side != this.defender.side && _loc1_.dmg != null && _loc9_ == true)
            {
               _loc35_ = 0;
               _loc35_ = 500;
               if(_loc1_.critical)
               {
                  _loc35_ *= attacker.criticalBonus;
               }
               _loc1_.titanb = true;
               _loc1_.titanDamageb = _loc35_;
               if(_loc1_.dodge != true)
               {
                  _loc1_.titanDefenderDamageHp = Math.round(this.defender.maxHP * 0.05);
                  var _temp_61:* = NumberUtil.getRandom();
                  _loc10_ = NumberUtil.getRandom();
                  if(_loc10_ <= 0.3)
                  {
                     this.defender.clearBuff();
                     _loc1_.showclearbuff = true;
                  }
                  else
                  {
                     _loc1_.showclearbuff = false;
                  }
               }
            }
         }
         this.attacker.setBattleAction(_loc1_);
      }
      
      public function checkExtraTurn() : Boolean
      {
         var _loc1_:Object = this.attacker.getBattleAction();
         var _loc2_:* = this.attacker;
         var _loc3_:* = this.defender;
         if(_loc1_)
         {
            if(_loc1_.copyJutsu == true)
            {
               this.attacker = _loc3_;
               this.defender = _loc2_;
               this.setCharacterCommand({
                  "action":"skill",
                  "skillId":_loc1_.skillId,
                  "noCooldown":true
               });
               this.finalizeBattleAction();
               return true;
            }
            if(_loc1_.stealSkillId)
            {
               Out.debug(this,"stealSkillId is not null");
               this.setCharacterCommand({
                  "action":"skill",
                  "skillId":_loc1_.stealSkillId,
                  "noCooldown":true
               });
               this.finalizeBattleAction();
               return true;
            }
            Out.debug(this,"stealSkillId is null");
         }
         return false;
      }
      
      private function processBattleAction() : void
      {
         var _loc1_:Object = null;
         var _loc6_:Object = null;
         var _loc7_:* = undefined;
         var _loc8_:int = 0;
         var _loc9_:String = null;
         var _loc10_:Number = NaN;
         var _loc11_:int = 0;
         var _loc12_:Number = NaN;
         var _loc13_:int = 0;
         var _loc14_:int = 0;
         var _loc15_:Object = null;
         var _loc16_:int = 0;
         var _loc17_:Object = null;
         var _loc18_:int = 0;
         var _loc19_:Object = null;
         var _loc20_:int = 0;
         var _loc21_:int = 0;
         var _loc22_:int = 0;
         var _loc23_:int = 0;
         var _loc24_:Array = null;
         var _loc25_:int = 0;
         var _loc26_:int = 0;
         var _loc27_:Object = null;
         var _loc28_:int = 0;
         var _loc29_:int = 0;
         var _loc30_:* = undefined;
         var _loc31_:Array = null;
         var _loc32_:int = 0;
         Out.debug("[rockman]","\n-----------------------------------------------------------------------------------------------------\n");
         Out.debug("[rockman]","battleProcessor  processbattleAction start");
         _loc1_ = this.attacker.getBattleAction();
         var _loc2_:Object = this.attacker.getBattleBuff();
         var _loc3_:Object = this.attacker.getBattleDebuff();
         var _loc4_:Object = this.defender.getBattleBuff();
         var _loc5_:Object = this.defender.getBattleDebuff();
         this.HpCondition = true;
         this.CpCondition = true;
         _loc8_ = 0;
         while(_loc8_ < Central.main.battleRuleArr.length)
         {
            switch(Central.main.battleRuleArr[_loc8_].attribute)
            {
               case EnemyAttributeData.HP:
                  if(Central.main.battleRuleArr[_loc8_].type == EnemyAttributeData.OVER)
                  {
                     this.HpCondition = this.attacker.hp / this.attacker.maxHP * 100 >= Central.main.battleRuleArr[_loc8_].amount ? true : false;
                  }
                  else
                  {
                     this.HpCondition = this.attacker.hp / this.attacker.maxHP * 100 <= Central.main.battleRuleArr[_loc8_].amount ? true : false;
                  }
                  break;
               case EnemyAttributeData.CP:
                  if(Central.main.battleRuleArr[_loc8_].type == EnemyAttributeData.OVER)
                  {
                     this.CpCondition = this.attacker.cp / this.attacker.maxCP * 100 >= Central.main.battleRuleArr[_loc8_].amount ? true : false;
                  }
                  else
                  {
                     this.CpCondition = this.attacker.cp / this.attacker.maxCP * 100 <= Central.main.battleRuleArr[_loc8_].amount ? true : false;
                  }
            }
            _loc8_++;
         }
         if(Boolean(this.defender.isBattleBuffActive(SenjutsuData.EFFECT_SS_IGNORE_DMG)) && Boolean(this.attacker.type != this.attacker.TYPE_PET) && this.attacker.type != this.attacker.TYPE_CHARACTER)
         {
            _loc10_ = NumberUtil.getRandom();
            if((Boolean(this.defender.sp / this.defender.maxSP >= _loc4_[SenjutsuData.EFFECT_SS_IGNORE_DMG].amount * 0.01) || Boolean(this.defender.isBattleBuffActive(SenjutsuData.EFFECT_SENNIN_MODE))) && _loc10_ < _loc4_[SenjutsuData.EFFECT_SS_IGNORE_DMG].chancetoeffect * 0.01)
            {
               if(_loc1_.action != "class_skill" || _loc1_.action == "class_skill" && _loc1_.effect.type != BattleData.SKILL_2004)
               {
                  _loc1_.dmg = 0;
                  _loc1_.effect = null;
                  _loc1_.ignoredmg = true;
                  this.attacker.setBattleAction(_loc1_);
               }
            }
            else
            {
               _loc1_.ignoredmg = false;
            }
         }
         else
         {
            _loc1_.ignoredmg = false;
         }
         switch(_loc1_.action)
         {
            case "attack":
               this.hitTarget();
               break;
            case "weapon_attack":
               this.hitTarget();
               break;
            case "charge":
               _loc12_ = 0;
               _loc13_ = 0;
               _loc14_ = 0;
               if(this.attacker.isBattleBuffActive(BloodlineData.EFFECT_EXTRA_CHARGE_RECOVER))
               {
                  _loc12_ = Number(this.attacker.getBattleBuff()[BloodlineData.EFFECT_EXTRA_CHARGE_RECOVER].amount);
                  _loc13_ += Math.round(this.attacker.maxCP * (_loc12_ / 100));
               }
               if(this.attacker.isBattleBuffActive(BattleData.EFFECT_EXTRA_CP_RECOVER))
               {
                  _loc12_ = Number(this.attacker.getBattleBuff()[BattleData.EFFECT_EXTRA_CP_RECOVER].amount);
                  _loc13_ += Math.round(this.attacker.maxCP * (_loc12_ / 100));
               }
               if(this.attacker.isBattleDebuffActive(BattleData.EFFECT_PET_REDUCE_CHARGE))
               {
                  _loc12_ = Number(this.attacker.getBattleBuff()[BattleData.EFFECT_PET_REDUCE_CHARGE].amount);
                  _loc13_ -= Math.round(this.attacker.maxCP * BattleData.CHAKRA_RECOVER_CHARGE * _loc12_ / 100);
               }
               if(this.attackerBackItem)
               {
                  for each(_loc15_ in this.attackerBackItem.effect)
                  {
                     switch(_loc15_.type)
                     {
                        case BattleData.EFFECT_CHARGE_CP_BONUS:
                           _loc13_ += Math.round(this.attacker.maxCP * (_loc15_.amount / 100));
                           break;
                        case BattleData.EFFECT_CHARGE_RECOVER_HP:
                           _loc14_ += Math.round(this.attacker.maxHP * (_loc15_.amount / 100));
                     }
                  }
               }
               _loc15_ = null;
               if(this.attackerAccessory)
               {
                  for each(_loc15_ in this.attackerAccessory.effect)
                  {
                     switch(_loc15_.type)
                     {
                        case BattleData.EFFECT_CHARGE_CP_BONUS:
                           _loc13_ += Math.round(this.attacker.maxCP * (_loc15_.amount / 100));
                           break;
                        case BattleData.EFFECT_CHARGE_RECOVER_HP:
                           _loc14_ += Math.round(this.attacker.maxHP * (_loc15_.amount / 100));
                     }
                  }
               }
               if(_loc14_ > 0)
               {
                  _loc1_.restoreHp = this.updateHP(this.attacker,_loc14_);
               }
               _loc16_ = Math.round(this.attacker.maxCP * BattleData.CHAKRA_RECOVER_CHARGE + _loc13_);
               _loc1_.cpRestore = this.updateCP(this.attacker,_loc16_);
               break;
            case "skill":
               if(Central.mission.curMissionID == "msn0")
               {
                  ++Central.main.tutorialMsnStep;
               }
               if(this.attackerWeapon)
               {
                  for each(_loc15_ in this.attackerWeapon.effect)
                  {
                     switch(_loc15_.type)
                     {
                        case BattleData.EFFECT_CP_CONSUME_TO_HP:
                           _loc1_.attackerRestoreHp += Math.round(_loc1_.cp * (_loc15_.amount / 100));
                     }
                  }
               }
               _loc17_ = Central.main.SKILL_DATA[_loc1_.skillId];
               if(this.attacker.isBattleBuffActive(BattleData.SKILL_251))
               {
                  if(_loc17_.type == SkillData.TYPE_EARTH && _loc17_.id != "skill251")
                  {
                     _loc1_.attackerBuff.push({
                        "type":BattleData.EFFECT_COMPLETE_GUARD,
                        "duration":2,
                        "amount":0
                     });
                  }
               }
               if(this.attacker.isBattleBuffActive(BattleData.SKILL_302))
               {
                  if(_loc17_.type == SkillData.TYPE_LIGHTNING)
                  {
                     if(this.attacker != this.defender)
                     {
                        this.defender.setBattleDebuff({
                           "type":BattleData.EFFECT_STUN,
                           "duration":2,
                           "amount":0
                        });
                     }
                  }
               }
               switch(String(_loc17_.effect.type))
               {
                  case BattleData.EFFECT_ALL_CP_DODGE_BONUS:
                  case BattleData.EFFECT_ALL_CP_DRAIN_HP:
                  case BattleData.EFFECT_ALL_CP_BLIND:
                  case BattleData.EFFECT_ALL_CP_GUARD_RESIST:
                  case BattleData.EFFECT_ALL_CP_HEAL:
                     _loc1_.cp = this.attacker.cp;
               }
               this.updateCP(this.attacker,0 - _loc1_.cp);
               this.hitTarget();
               break;
            case "class_skill":
               switch(_loc1_.effect.type)
               {
                  case BattleData.SKILL_2001:
                     _loc6_ = _loc1_.effect;
                     this.attacker.clearAllDebuff();
                     _loc1_.attackerBuff.push(_loc6_);
                     break;
                  case BattleData.SKILL_2003:
                     _loc6_ = _loc1_.effect;
                     _loc1_.attackerBuff.push(_loc6_);
               }
               break;
            case "item":
               _loc19_ = Central.main.ITEM_DATA.find(_loc1_.item);
               _loc20_ = 0;
               _loc21_ = 0;
               _loc22_ = 0;
               if(Boolean(_loc19_.extra_effect) && _loc19_.extra_effect != null)
               {
                  _loc27_ = _loc19_.extra_effect;
                  _loc24_ = [];
                  _loc7_ = 0;
                  while(_loc7_ < _loc27_.enemy.length)
                  {
                     _loc24_.push(Central.main.ENEMY_DATA.find(_loc27_.enemy[_loc7_]).name);
                     _loc7_++;
                  }
                  if(defender.type == 4 && _loc24_.indexOf(this.defender.getCharacterName()) >= 0)
                  {
                     switch(_loc27_.type)
                     {
                        case BattleData.ITEM_REDUCE_TARGET_HP:
                           _loc23_ = Math.round(this.defender.maxHP * (_loc27_.amount * 0.01));
                           _loc1_.defenderDamageHp += _loc23_;
                           this.defender.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(482) + String(_loc1_.defenderDamageHp));
                           this.hitTarget();
                           break;
                        case BattleData.EFFECT_REDUCE_PURIFY_N_DODGE:
                           _loc6_ = {
                              "type":BattleData.EFFECT_REDUCE_PURIFY_CHANCE,
                              "duration":_loc27_.duration,
                              "amount":_loc27_.amount
                           };
                           this.defender.setBattleDebuff(_loc6_);
                           _loc6_ = {
                              "type":BattleData.EFFECT_DODGE_REDUCTION,
                              "duration":_loc27_.duration,
                              "amount":_loc27_.amount
                           };
                           this.defender.setBattleDebuff(_loc6_);
                           this.defender.showOverheadNumber(Timeline.WORD,String(Central.main.langLib.get(1361)));
                           this.defender.showOverheadNumber(Timeline.WORD,String(Central.main.langLib.get(799)));
                           this.hitTarget();
                           break;
                        case BattleData.EFFECT_CLEARBUFF_STUN:
                           this.defender.clearBuff();
                           _loc6_ = {
                              "type":BattleData.EFFECT_STUN,
                              "duration":_loc27_.duration
                           };
                           this.defender.setBattleDebuff(_loc6_);
                           this.defender.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(877));
                           this.defender.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(281));
                           this.hitTarget();
                     }
                  }
               }
               switch(_loc19_.effect)
               {
                  case BattleData.ITEM_RESTORE_HP:
                     _loc20_ = _loc19_.amount + 0;
                     break;
                  case BattleData.ITEM_RESTORE_CP:
                     _loc21_ = _loc19_.amount + 0;
                     break;
                  case BattleData.ITEM_SPECIAL_RUNE_SCROLL:
                     _loc20_ = 800;
                     _loc21_ = 800;
                     break;
                  case BattleData.ITEM_PERCENT_HP:
                     _loc20_ = Math.round(attacker.maxHP * ((_loc19_.amount + 0) / 100));
                     break;
                  case BattleData.ITEM_PERCENT_CP:
                     _loc21_ = Math.round(attacker.maxCP * ((_loc19_.amount + 0) / 100));
                     break;
                  case BattleData.ITEM_PERCENT_HPCP:
                     _loc20_ = Math.round(attacker.maxHP * ((_loc19_.amount + 0) / 100));
                     _loc21_ = Math.round(attacker.maxCP * ((_loc19_.amount + 0) / 100));
                     break;
                  case BattleData.EFFECT_DODGE_BONUS:
                     _loc6_ = {
                        "type":_loc19_.effect,
                        "duration":_loc19_.duration,
                        "amount":_loc19_.amount
                     };
                     _loc1_.attackerBuff.push(_loc6_);
                     break;
                  case BattleData.EFFECT_DAMAGE_BONUSA:
                  case BattleData.EFFECT_DAMAGE_BONUS:
                  case BattleData.EFFECT_DAMAGE_REDUCTION:
                  case BattleData.EFFECT_CRITICAL_CHANCE_BONUS:
                     _loc6_ = {
                        "type":_loc19_.effect,
                        "duration":_loc19_.duration,
                        "amount":_loc19_.amount
                     };
                     _loc1_.attackerBuff.push(_loc6_);
                     break;
                  case BattleData.ITEM_DAMAGE_BONUS_N_REDUCTION:
                     _loc6_ = {
                        "type":BattleData.EFFECT_DAMAGE_BONUS,
                        "duration":_loc19_.duration,
                        "amount":_loc19_.amount
                     };
                     _loc1_.attackerBuff.push(_loc6_);
                     _loc6_ = {
                        "type":BattleData.EFFECT_DAMAGE_REDUCTION,
                        "duration":_loc19_.duration,
                        "amount":_loc19_.amount
                     };
                     _loc1_.attackerBuff.push(_loc6_);
                     break;
                  case BattleData.EFFECT_TURKEY_FEAST:
                     _loc6_ = {
                        "type":_loc19_.effect,
                        "duration":_loc19_.duration,
                        "amount":_loc19_.amount
                     };
                     _loc1_.attackerBuff.push(_loc6_);
                     break;
                  case BattleData.ITEM_DODGE_BONUS_N_CRITICAL_CHANCE:
                     _loc6_ = {
                        "type":BattleData.EFFECT_DODGE_BONUS,
                        "duration":_loc19_.duration,
                        "amount":_loc19_.amount
                     };
                     _loc1_.attackerBuff.push(_loc6_);
                     _loc6_ = {
                        "type":BattleData.EFFECT_ADD_CRITICAL_CHANCE,
                        "duration":_loc19_.duration,
                        "amount":_loc19_.amount
                     };
                     _loc1_.attackerBuff.push(_loc6_);
                     break;
                  case BattleData.ITEM_DODGE_BONUS_N_PURIFY_CHANCE:
                     _loc6_ = {
                        "type":BattleData.EFFECT_DODGE_BONUS,
                        "duration":_loc19_.duration,
                        "amount":_loc19_.amount
                     };
                     _loc1_.attackerBuff.push(_loc6_);
                     _loc6_ = {
                        "type":BattleData.EFFECT_ADD_PURIFY_CHANCE,
                        "duration":_loc19_.duration,
                        "amount":_loc19_.amount
                     };
                     _loc1_.attackerBuff.push(_loc6_);
                     break;
                  case BattleData.ITEM_CRITICAL_CHANCE_N_PURIFY_CHANCE:
                     _loc6_ = {
                        "type":BattleData.EFFECT_ADD_CRITICAL_CHANCE,
                        "duration":_loc19_.duration,
                        "amount":_loc19_.amount
                     };
                     _loc1_.attackerBuff.push(_loc6_);
                     _loc6_ = {
                        "type":BattleData.EFFECT_ADD_PURIFY_CHANCE,
                        "duration":_loc19_.duration,
                        "amount":_loc19_.amount
                     };
                     _loc1_.attackerBuff.push(_loc6_);
                     break;
                  case BattleData.ITEM_DAMAGE_BONUS_N_ACCURATE:
                     _loc6_ = {
                        "type":BattleData.EFFECT_DAMAGE_BONUS,
                        "duration":_loc19_.duration,
                        "amount":_loc19_.amount
                     };
                     _loc1_.attackerBuff.push(_loc6_);
                     _loc6_ = {
                        "type":BattleData.EFFECT_ACCURATE,
                        "duration":_loc19_.duration,
                        "amount":_loc19_.amount
                     };
                     _loc1_.attackerBuff.push(_loc6_);
                     break;
                  case BattleData.EFFECT_REGENERATE_HP:
                  case BattleData.EFFECT_ADD_PURIFY_CHANCE:
                  case BattleData.EFFECT_ACCURATE:
                     _loc6_ = {
                        "type":_loc19_.effect,
                        "duration":_loc19_.duration,
                        "amount":_loc19_.amount
                     };
                     _loc1_.attackerBuff.push(_loc6_);
                     break;
                  case BattleData.ITEM_CLEARDEBUFF_RESIST:
                     _loc6_ = {
                        "type":BattleData.EFFECT_PET_DEBUFF_RESIST,
                        "duration":_loc19_.duration,
                        "amount":100
                     };
                     _loc1_.attackerBuff.push(_loc6_);
                     this.attacker.clearAllDebuff();
                     break;
                  case BattleData.ITEM_STRENGTHEN_N_BLEEDING:
                     _loc6_ = {
                        "type":BattleData.EFFECT_DAMAGE_BONUS,
                        "duration":_loc19_.duration,
                        "amount":_loc19_.amount
                     };
                     _loc1_.attackerBuff.push(_loc6_);
                     if(!this.defender.isBattleBuffActive(BattleData.EFFECT_BURN_HP_CP_FIX_NUM_N_IMMUNITY_BLEEDING))
                     {
                        _loc6_ = {
                           "type":BattleData.EFFECT_BLEEDING,
                           "duration":_loc19_.duration,
                           "amount":_loc19_.amount
                        };
                        _loc1_.attackerDebuff.push(_loc6_);
                     }
                     break;
                  case BattleData.ITEM_BOTH_DAMAGE_REDUCTION:
                     _loc6_ = {
                        "type":BattleData.EFFECT_DAMAGE_REDUCTION,
                        "duration":_loc19_.duration,
                        "amount":_loc19_.amount
                     };
                     _loc1_.attackerBuff.push(_loc6_);
                     _loc6_ = {
                        "type":BattleData.EFFECT_PET_WEAKEN,
                        "duration":_loc19_.duration,
                        "amount":_loc19_.amount
                     };
                     _loc1_.attackerDebuff.push(_loc6_);
                     break;
                  case BattleData.ITEM_RESTORE_PET_CP_PRESENT:
                     _loc22_ = Math.round(1000 * ((_loc19_.amount + 0) / 100));
                     break;
                  case BattleData.ITEM_EFFECT_SEAL_GAN:
                     _loc8_ = 0;
                     while(_loc8_ < Central.main.battleRuleArr.length)
                     {
                        switch(Central.main.battleRuleArr[_loc8_].attribute)
                        {
                           case EnemyAttributeData.SEAL_GAN:
                              Central.battle.use_seal_enemy = true;
                              _loc28_ = Math.ceil(this.defender.hp / this.defender.maxHP * 100);
                              _loc29_ = Math.floor(this.defender.hp / this.defender.maxHP * 100);
                              Central.battle.seal_enemy = _loc28_ >= Central.main.battleRuleArr[_loc8_].amount_over && _loc29_ <= Central.main.battleRuleArr[_loc8_].amount_less ? true : false;
                              Out.debug(this,"processbattleaction :: defender >> " + Central.battle.seal_enemy);
                              if(Central.battle.seal_enemy)
                              {
                                 _loc1_.dmg = this.defender.maxHP;
                                 if(Boolean(Central.main.battleModeSpecial) && Central.main.battleModeSpecial == true)
                                 {
                                    Central.battle.specialHpData.finalHP = this.defender.hp;
                                 }
                              }
                        }
                        _loc8_++;
                     }
                     break;
                  case BattleData.ITEM_EFFECT_SPY_CP:
                     _loc21_ = Math.round(attacker.maxCP * ((_loc19_.amount + 0) / 100));
                     Central.battle.spy_enemy = true;
               }
               if(this.attackerBackItem)
               {
                  for each(_loc15_ in this.attackerBackItem.effect)
                  {
                     switch(_loc15_.type)
                     {
                        case BattleData.EFFECT_ITEM_RESTORE_BONUS_PRESENT:
                           if(_loc20_ > 0)
                           {
                              _loc20_ = Math.round(_loc20_ * (1 + _loc15_.amount / 100));
                           }
                           break;
                        case BattleData.EFFECT_ITEM_RESTORE_BONUS:
                           if(_loc20_ > 0)
                           {
                              _loc20_ += _loc15_.amount;
                           }
                           break;
                        case BattleData.EFFECT_ITEM_RESTORE_CP_BONUS_PRESENT:
                           _loc21_ = Math.round(_loc21_ * (1 + _loc15_.amount / 100));
                     }
                  }
               }
               if(this.attackerAccessory)
               {
                  for each(_loc15_ in this.attackerAccessory.effect)
                  {
                     switch(_loc15_.type)
                     {
                        case BattleData.EFFECT_ITEM_RESTORE_BONUS_PRESENT:
                           if(_loc20_ > 0)
                           {
                              _loc20_ = Math.round(_loc20_ * (1 + _loc15_.amount / 100));
                           }
                           break;
                        case BattleData.EFFECT_ITEM_RESTORE_BONUS:
                           if(_loc20_ > 0)
                           {
                              _loc20_ += _loc15_.amount;
                           }
                           break;
                        case BattleData.EFFECT_ITEM_RESTORE_CP_BONUS_PRESENT:
                           _loc21_ = Math.round(_loc21_ * (1 + _loc15_.amount / 100));
                     }
                  }
               }
               if(this.attacker.getBloodlineEffect())
               {
                  for each(_loc15_ in this.attacker.getBloodlineEffect())
                  {
                     switch(_loc15_.type)
                     {
                        case BloodlineData.EFFECT_BL_SKILL_ITEM_ADD_HP_PER:
                           if(_loc20_ > 0)
                           {
                              _loc20_ += Math.round(_loc20_ * _loc15_.amount * 0.01);
                           }
                     }
                  }
               }
               if(this.attacker.isBattleBuffActive(BloodlineData.EFFECT_SKIP_DEAD_CLEAR_DEBUFF))
               {
                  _loc20_ = 0;
               }
               if(_loc20_ > 0)
               {
                  _loc1_.restoreHp = this.updateHP(this.attacker,_loc20_);
               }
               if(_loc21_ > 0)
               {
                  _loc1_.restoreCp = this.updateCP(this.attacker,_loc21_);
               }
               if(Boolean(attacker.pet) && attacker.pet.petMaxEp > 0)
               {
                  if(_loc22_ > 0)
                  {
                     attacker.pet.updatePetCP(_loc22_);
                     _loc1_.restorePetCp = _loc22_;
                  }
               }
               break;
            case "special":
               this.hitTarget();
               break;
            case "bloodline":
               _loc25_ = int(_loc1_.cp);
               if(attacker.isBattleBuffActive(BattleData.EFFECT_EXCITATION_CP))
               {
                  _loc25_ = 0;
               }
               this.updateCP(this.attacker,0 - _loc25_);
               this.hitTarget();
               break;
            case "senjutsu":
               _loc26_ = int(_loc1_.sp);
               attacker.updateSP(0 - _loc26_);
               this.hitTarget();
         }
         this.healTarget();
         this.damageTarget();
         if(Boolean(_loc1_) && Boolean(_loc1_.effect) && _loc1_.effect.type == BattleData.EFFECT_CLEARBUFF_STUN)
         {
            _loc30_ = {
               "type":BattleData.EFFECT_STUN,
               "duration":_loc1_.effect.duration
            };
            _loc1_.effect = _loc30_;
         }
         if(_loc1_.action != "dodge" && _loc1_.action != "pass" && _loc1_.action != "charge")
         {
            if(this.attacker.isBattleDebuffActive(BattleData.EFFECT_CUBE_ILLUSION))
            {
               _loc1_.attackerDamageHp += Math.round(this.attacker.maxHP * 0.03);
               _loc1_.attackerDamageCp += Math.round(this.attacker.maxCP * 0.03);
            }
         }
         if(_loc1_.action == "attack" || _loc1_.action == "weapon_attack")
         {
            _loc31_ = [this.attacker.TYPE_CHARACTER,this.attacker.TYPE_AICHARACTER,this.attacker.TYPE_PVPCHARACTER];
            if(_loc31_.indexOf(this.attacker.type) >= 0)
            {
               _loc1_.attackerRestoreCp += Math.round(this.attacker.maxCP * BattleData.CHAKRA_NATURAL_REGENERATION);
            }
         }
         _loc7_ = 0;
         while(_loc7_ < _loc1_.attackerBuff.length)
         {
            _loc6_ = _loc1_.attackerBuff[_loc7_];
            this.attacker.setBattleBuff(_loc6_);
            _loc7_++;
         }
         _loc7_ = 0;
         while(_loc7_ < _loc1_.attackerDebuff.length)
         {
            _loc6_ = _loc1_.attackerDebuff[_loc7_];
            _loc1_.attackerDebuff[_loc7_] = this.setDebuff(this.attacker,_loc6_);
            _loc7_++;
         }
         _loc7_ = 0;
         while(_loc7_ < _loc1_.defenderBuff.length)
         {
            _loc6_ = _loc1_.defenderBuff[_loc7_];
            this.defender.setBattleBuff(_loc6_);
            _loc7_++;
         }
         _loc7_ = 0;
         while(_loc7_ < _loc1_.defenderDebuff.length)
         {
            _loc6_ = _loc1_.defenderDebuff[_loc7_];
            _loc1_.defenderDebuff[_loc7_] = this.setDebuff(this.defender,_loc6_);
            _loc7_++;
         }
         if(this.attacker.isBattleBuffActive(BloodlineData.EFFECT_ABSORB_CP_RESTORE_HP + ".skill1050"))
         {
            if(_loc1_.defenderDamageCp > 0)
            {
               if(NumberUtil.getRandom() <= this.attacker.getBattleBuff()[BloodlineData.EFFECT_ABSORB_CP_RESTORE_HP + ".skill1050"].chancetoeffect * 0.01)
               {
                  _loc1_.attackerRestoreHp += this.attacker.getBattleBuff()[BloodlineData.EFFECT_ABSORB_CP_RESTORE_HP + ".skill1050"].amount;
               }
            }
         }
         if(this.attacker.isBattleBuffActive(BloodlineData.EFFECT_SKIP_DEAD_CLEAR_DEBUFF))
         {
            if(_loc1_.attackerDamageHp > 0)
            {
               if(NumberUtil.getRandom() <= this.attacker.getBattleBuff()[BloodlineData.EFFECT_SKIP_DEAD_CLEAR_DEBUFF].chancetoeffect * 0.01)
               {
                  _loc1_.attackerDamageHp = 0;
               }
            }
         }
         if(this.defender.isBattleBuffActive(BloodlineData.EFFECT_CPDMG_STUN + ".skill1004"))
         {
            if(_loc1_.defenderDamageCp > 0 || _loc1_.effect != null && _loc1_.effect.damageCp > 0)
            {
               if(NumberUtil.getRandom() <= this.defender.getBattleBuff()[BloodlineData.EFFECT_CPDMG_STUN + ".skill1004"].chancetoeffect * 0.01)
               {
                  _loc6_ = {
                     "type":BattleData.EFFECT_STUN,
                     "duration":2
                  };
                  this.attacker.setBattleDebuff(_loc6_);
               }
            }
         }
         if(this.defender.isBattleBuffActive(BloodlineData.EFFECT_CPDMG + ".skill1004"))
         {
            if(_loc1_.defenderDamageCp > 0 || _loc1_.effect != null && _loc1_.effect.damageCp > 0)
            {
               _loc32_ = 0;
               if(_loc1_.effect != null && _loc1_.effect.damageCp > 0)
               {
                  _loc32_ = int(_loc1_.effect.damageCp);
               }
               _loc1_.attackerDamageHp += (_loc32_ + _loc1_.defenderDamageCp) * this.defender.getBattleBuff()[BloodlineData.EFFECT_CPDMG + ".skill1004"].amount * 0.01;
            }
         }
         if(_loc1_.attackerRestoreHp > 0)
         {
            _loc1_.attackerRestoreHp = this.updateHP(this.attacker,_loc1_.attackerRestoreHp);
         }
         if(_loc1_.attackerRestoreCp > 0)
         {
            _loc1_.attackerRestoreCp = this.updateCP(this.attacker,_loc1_.attackerRestoreCp);
         }
         if(_loc1_.attackerRestoreSp > 0)
         {
            _loc1_.attackerRestoreSp = this.updateSP(this.attacker,_loc1_.attackerRestoreSp);
         }
         if(_loc1_.attackerDamageHp > 0)
         {
            _loc1_.attackerDamageHp = this.updateHP(this.attacker,0 - _loc1_.attackerDamageHp);
         }
         if(_loc1_.attackerDamageCp > 0)
         {
            _loc1_.attackerDamageCp = this.updateCP(this.attacker,0 - _loc1_.attackerDamageCp);
         }
         if(_loc1_.defenderRestoreHp > 0)
         {
            _loc1_.defenderRestoreHp = this.updateHP(this.defender,_loc1_.defenderRestoreHp);
         }
         if(_loc1_.defenderRestoreCp > 0)
         {
            _loc1_.defenderRestoreCp = this.updateCP(this.defender,_loc1_.defenderRestoreCp);
         }
         if(_loc1_.defenderDamageCp > 0)
         {
            _loc1_.defenderDamageCp = this.updateCP(this.defender,0 - _loc1_.defenderDamageCp);
         }
         if(_loc1_.defenderDamageHp > 0)
         {
            _loc1_.defenderDamageHp = this.updateHP(this.defender,0 - _loc1_.defenderDamageHp);
         }
         this.attacker.setBattleAction(_loc1_);
      }
      
      private function hitTarget() : void
      {
         var _loc1_:Object = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:* = undefined;
         var _loc5_:Object = null;
         var _loc6_:String = null;
         var _loc7_:Number = NaN;
         var _loc8_:int = 0;
         var _loc9_:Object = null;
         var _loc10_:Object = null;
         var _loc11_:Object = null;
         var _loc12_:Object = null;
         var _loc13_:Array = null;
         var _loc14_:int = 0;
         var _loc15_:Object = null;
         var _loc16_:int = 0;
         var _loc17_:int = 0;
         var _loc18_:int = 0;
         var _loc19_:int = 0;
         var _loc20_:int = 0;
         var _loc21_:Array = null;
         var _loc22_:* = undefined;
         var _loc23_:String = null;
         var _loc24_:int = 0;
         var _loc25_:Object = null;
         var _loc26_:Object = null;
         var _loc27_:Object = null;
         var _loc28_:Object = null;
         var _loc29_:Object = null;
         var _loc30_:Object = null;
         var _loc31_:Object = null;
         var _loc32_:Object = null;
         var _loc33_:Object = null;
         var _loc34_:Object = null;
         var _loc35_:Array = null;
         var _loc36_:String = null;
         var _loc37_:Object = null;
         var _loc38_:int = 0;
         var _loc39_:int = 0;
         var _loc40_:Number = NaN;
         var _loc41_:Object = null;
         var _loc42_:int = 0;
         _loc1_ = this.attacker.getBattleAction();
         if(!this.checkIsSelfBuff(_loc1_))
         {
            this.checkClone(_loc1_);
         }
         if(_loc1_.action == "bloodline")
         {
            this.checkBloodlineEffect();
         }
         if(_loc1_.action == "senjutsu")
         {
            this.checkSenjutsuEffect();
         }
         if(_loc1_.clones != null)
         {
            if(_loc1_.clones[this.defender.getCharacterId()])
            {
               this.attacker.setBattleAction(_loc1_);
               return;
            }
         }
         if(Boolean(_loc1_.effect) && _loc1_.effect.type == BattleData.EFFECT_DMG_BONUS_N_BLEEDING)
         {
            _loc5_ = {
               "type":BattleData.EFFECT_DAMAGE_BONUS,
               "duration":_loc1_.effect.duration,
               "amount":_loc1_.effect.amount
            };
            _loc1_.attackerBuff.push(_loc5_);
         }
         if(Boolean(_loc1_.effect) && _loc1_.effect.type == BattleData.EFFECT_STUN_EXPANSION)
         {
            _loc5_ = {
               "type":BattleData.EFFECT_EXPANSION,
               "duration":_loc1_.effect.duration - 1,
               "amount":_loc1_.effect.amount
            };
            _loc1_.attackerBuff.push(_loc5_);
         }
         if(_loc1_.dodge == true)
         {
            return;
         }
         if(_loc1_.effect)
         {
            switch(_loc1_.effect.type)
            {
               case BattleData.EFFECT_BLOOD_DRINKER_N_RESTORE_HP:
                  _loc5_ = {
                     "type":BattleData.EFFECT_BLOOD_DRINKER,
                     "duration":_loc1_.effect.duration,
                     "amount":_loc1_.effect.amount
                  };
                  _loc1_.defenderDebuff.push(_loc5_);
                  break;
               case BattleData.EFFECT_BLOOD_DRINKER_N_RESTORE_HP_BUNDLE:
                  _loc5_ = {
                     "type":BattleData.EFFECT_BLOOD_DRINKER,
                     "duration":_loc1_.effect.duration,
                     "amount":_loc1_.effect.amount
                  };
                  _loc1_.defenderDebuff.push(_loc5_);
                  _loc8_ = 0;
                  while(_loc8_ < this.characterArr.length)
                  {
                     if(this.characterArr[_loc8_].isDead == false && this.characterArr[_loc8_].side != this.attacker.side)
                     {
                        this.setDebuff(this.characterArr[_loc8_],_loc5_);
                     }
                     _loc8_++;
                  }
                  _loc5_ = {
                     "type":BattleData.EFFECT_BUNDLE,
                     "duration":_loc1_.effect.duration,
                     "amount":_loc1_.effect.amount
                  };
                  this.defender.setBattleDebuff(_loc5_);
                  _loc8_ = 0;
                  while(_loc8_ < this.characterArr.length)
                  {
                     if(this.characterArr[_loc8_].isDead == false && this.characterArr[_loc8_].side != this.attacker.side)
                     {
                        this.setDebuff(this.characterArr[_loc8_],_loc5_);
                     }
                     _loc8_++;
                  }
                  break;
               case BattleData.EFFECT_SLEEP:
               case BattleData.EFFECT_ECSTATIC_SOUND:
               case BattleData.EFFECT_BLOOD_DRINKER:
                  _loc1_.defenderDebuff.push(_loc1_.effect);
                  _loc8_ = 0;
                  while(_loc8_ < this.characterArr.length)
                  {
                     if(this.characterArr[_loc8_].isDead == false && this.characterArr[_loc8_].side != this.attacker.side)
                     {
                        this.setDebuff(this.characterArr[_loc8_],_loc1_.effect);
                     }
                     _loc8_++;
                  }
                  break;
               case BattleData.EFFECT_DISMANTLE:
               case BattleData.SKILL_341:
               case BattleData.EFFECT_RESTRICT_CHARGE:
               case BattleData.EFFECT_LIGHTING_BUNDLE:
               case BattleData.EFFECT_LIGHTING_BUNDLE_2:
               case BattleData.EFFECT_LIGHTING_BUNDLE_3:
               case BattleData.EFFECT_LIGHTING_BUNDLE_4:
               case BattleData.EFFECT_DARK_CURSE:
               case BattleData.EFFECT_THEFT_HP:
               case BattleData.EFFECT_BUFF_NEGATE:
               case BattleData.EFFECT_PETRIFICATION:
               case BattleData.EFFECT_HIDDEN_MIST:
               case BattleData.EFFECT_DARKNESS:
               case BattleData.SKILL_311:
               case BattleData.SKILL_312:
               case BattleData.EFFECT_SOUL_CHAINS_BUNDLE:
               case BattleData.EFFECT_LIGHT_IMPLUSE:
               case BattleData.EFFECT_DOT_HP:
               case BattleData.EFFECT_DAMAGE_DELAY_INJURY:
                  _loc1_.defenderDebuff.push(_loc1_.effect);
                  break;
               case BattleData.EFFECT_CHAOS:
               case BattleData.EFFECT_WPNEFT_DISABLE:
               case BattleData.EFFECT_PET_DISORIENTED:
               case BattleData.EFFECT_VENOM:
               case BattleData.EFFECT_REDUCE_PURIFY_CHANCE:
                  _loc1_.defenderDebuff.push(_loc1_.effect);
                  _loc8_ = 0;
                  while(_loc8_ < this.characterArr.length)
                  {
                     if(this.characterArr[_loc8_].isDead == false && this.characterArr[_loc8_].side != this.attacker.side)
                     {
                        this.setDebuff(this.characterArr[_loc8_],_loc1_.effect);
                     }
                     _loc8_++;
                  }
                  break;
               case BattleData.EFFECT_CHAOS_THANOS:
                  _loc3_ = 0;
                  if(attacker.getWeapon() == "wpn1596")
                  {
                     _loc2_ = int(Central.main.stateInventory.getStateOnCount(attacker.getCharacterId(),"wpn","wpn1596"));
                     if(_loc2_ >= 0)
                     {
                        _loc3_ = _loc2_;
                     }
                  }
                  _loc1_.defenderDebuff.push({
                     "type":BattleData.EFFECT_CHAOS,
                     "duration":_loc1_.effect.duration + Math.floor(_loc3_ / 3),
                     "amount":_loc1_.effect.amount
                  });
                  _loc8_ = 0;
                  while(_loc8_ < this.characterArr.length)
                  {
                     if(this.characterArr[_loc8_].isDead == false && this.characterArr[_loc8_].side != this.attacker.side)
                     {
                        this.setDebuff(this.characterArr[_loc8_],{
                           "type":BattleData.EFFECT_CHAOS,
                           "duration":_loc1_.effect.duration + Math.floor(_loc3_ / 3),
                           "amount":_loc1_.effect.amount
                        });
                     }
                     _loc8_++;
                  }
                  break;
               case BattleData.EFFECT_EXTRA_CP_RECOVER:
               case BattleData.EFFECT_PET_DODGE_BONUS:
               case BattleData.EFFECT_DAMAGE_BONUS_N_PURIFY:
               case BattleData.EFFECT_SERENE_MIND_N_HEAL:
               case BattleData.EFFECT_DAMAGE_REDUCE_N_ACCURATE:
               case BattleData.EFFECT_DAMAGE_BONUS_ACCURATE:
               case BattleData.EFFECT_CRITICAL_CHANCE_BONUS:
               case BattleData.EFFECT_GUARD:
               case BattleData.EFFECT_PET_ATTENTION:
               case BattleData.EFFECT_PET_DAMAGE_BONUS:
               case BattleData.EFFECT_COMPLETE_GUARD:
               case BattleData.EFFECT_CATALYTIC_MATTER:
               case BattleData.EFFECT_PET_DEBUFF_RESIST:
               case BattleData.EFFECT_PET_DAMAGE_REDUCTION:
               case BattleData.EFFECT_PET_DAMAGE_TO_CP:
               case BattleData.EFFECT_PET_SAVE_CP:
               case BattleData.EFFECT_PET_LIGHTNING:
               case BattleData.EFFECT_PET_DRAIN_HP_KEKKAI:
               case BattleData.EFFECT_ATTACK_MODE:
               case BattleData.EFFECT_DEFENCE_MODE:
               case BattleData.EFFECT_PET_ENERGIZE:
               case BattleData.EFFECT_BATTLE_BUNNY_FRENZY:
               case BattleData.EFFECT_PET_PERSEVERANCE_MASTER:
                  _loc1_.defenderBuff.push(_loc1_.effect);
                  break;
               case BattleData.EFFECT_CRIT_CHANCE_DMG:
               case BattleData.EFFECT_AMONG_ROCKS:
               case BattleData.EFFECT_ALL_CP_DRAIN_HP:
               case BattleData.EFFECT_AGILITY_BONUS:
               case BattleData.EFFECT_DODGE_BONUS:
               case BattleData.EFFECT_ALL_CP_DODGE_BONUS:
               case BattleData.EFFECT_REGENERATE_CHAKRA:
               case BattleData.EFFECT_REGENERATE_HP:
               case BattleData.EFFECT_MANA_SHIELD:
               case BattleData.EFFECT_THUNDERSTORM_MODE:
               case BattleData.EFFECT_REACTIVE_DEBUFF:
               case BattleData.EFFECT_BLOOD_FEED:
               case BattleData.SKILL_310:
               case BattleData.EFFECT_ACCURATE:
               case BattleData.SKILL_335:
               case BattleData.EFFECT_GATE_OPENING:
               case BattleData.EFFECT_REACTIVE_FORCE:
               case BattleData.EFFECT_FRENZY:
               case BattleData.EFFECT_BUNNY_FRENZY:
               case BattleData.EFFECT_DODGE_BONUS_N_HEAL:
               case BattleData.EFFECT_DAMAGE_REDUCE_N_HEAL:
               case BattleData.SKILL_369:
               case BattleData.SKILL_501:
               case BattleData.EFFECT_SUSANOO:
               case BattleData.EFFECT_HALFHP_DAMAGE_REDUCTION:
               case BattleData.EFFECT_HEAL_HP_N_DMG_BONUS_GASHADOKURO:
               case BattleData.EFFECT_HEAL_HP_N_DMG_BONUS:
               case BattleData.EFFECT_HEAL_HP_N_DMG_BONUS_UPGRADE:
               case BattleData.EFFECT_RECEIVED_DMG_BLEEDING:
               case BattleData.EFFECT_SERENE_MIND_DMGBONUS:
               case BattleData.EFFECT_UNHOLY_POISON:
               case BattleData.EFFECT_DISORIENTED_BURN_HP:
                  _loc1_.attackerBuff.push(_loc1_.effect);
                  break;
               case BattleData.SKILL_335_THANOS:
                  _loc3_ = 0;
                  if(attacker.getWeapon() == "wpn1596")
                  {
                     _loc2_ = int(Central.main.stateInventory.getStateOnCount(attacker.getCharacterId(),"wpn","wpn1596"));
                     if(_loc2_ >= 0)
                     {
                        _loc3_ = _loc2_;
                     }
                  }
                  _loc1_.attackerBuff.push({
                     "type":BattleData.SKILL_335,
                     "duration":_loc1_.effect.duration,
                     "amount":_loc1_.effect.amount + 3 * _loc3_
                  });
                  break;
               case BattleData.EFFECT_ADD_MAX_HP_LIMIT:
                  _loc1_.nosee = true;
                  _loc1_.attackerRestoreHp += Math.round(this.attacker.maxHP * (_loc1_.effect.amount / 100));
                  _loc1_.attackerBuff.push(_loc1_.effect);
                  break;
               case BattleData.EFFECT_CLEARBUFF_REDUCE_HP_CP:
               case BattleData.EFFECT_CALM_TARGET:
               case BattleData.EFFECT_CLEARBUFF_REDUCE_HP:
               case BattleData.EFFECT_CLEARBUFF_REDUCE_CP:
               case BattleData.EFFECT_CLEARBUFF_REDUCE_CP_THANOS:
               case BattleData.EFFECT_INTERNAL_INJURY_DARKNESS:
                  _loc8_ = 0;
                  while(_loc8_ < this.characterArr.length)
                  {
                     if(this.characterArr[_loc8_].isDead == false && this.characterArr[_loc8_].side != this.attacker.side)
                     {
                        this.characterArr[_loc8_].clearBuff();
                     }
                     _loc8_++;
                  }
                  break;
               case BattleData.EFFECT_PET_FREEZE:
                  _loc7_ = NumberUtil.getRandom();
                  if(_loc7_ <= _loc1_.effect.amount / 100)
                  {
                     _loc1_.effect.activated = true;
                     _loc1_.defenderDebuff.push(_loc1_.effect);
                     freezeskill = true;
                  }
                  else if(_loc7_ <= _loc1_.effect.chance / 100)
                  {
                     _loc1_.effect.activated = true;
                     _loc1_.defenderDebuff.push(_loc1_.effect);
                     freezeskill = true;
                  }
                  else
                  {
                     _loc1_.effect.activated = false;
                  }
                  break;
               case BattleData.EFFECT_PET_BLEEDING:
                  _loc7_ = NumberUtil.getRandom();
                  if(_loc7_ <= int(_loc1_.effect.chance) / 100 && !this.defender.isBattleBuffActive(BattleData.EFFECT_BURN_HP_CP_FIX_NUM_N_IMMUNITY_BLEEDING))
                  {
                     _loc1_.effect.activated = true;
                     _loc1_.effect = this.setDebuff(this.defender,_loc1_.effect);
                  }
                  else
                  {
                     _loc1_.effect.activated = false;
                  }
                  break;
               case BattleData.EFFECT_STUN_RANDOM:
                  _loc7_ = NumberUtil.getRandom();
                  if(_loc7_ <= int(_loc1_.effect.amount) / 100 && _loc1_.stun == true)
                  {
                     _loc5_ = {
                        "type":BattleData.EFFECT_STUN,
                        "duration":_loc1_.effect.duration,
                        "amount":0
                     };
                     _loc1_.defenderDebuff.push(_loc5_);
                  }
                  break;
               case BattleData.EFFECT_FLAME_EATER:
                  _loc16_ = 0;
                  if(this.defender.isBattleDebuffActive(BattleData.EFFECT_BURN))
                  {
                     _loc16_ += Math.round(this.defender.maxHP * 0.05);
                     this.defender.removeDebuff(BattleData.EFFECT_BURN);
                  }
                  if(this.defender.isBattleDebuffActive(BattleData.EFFECT_PET_BURN))
                  {
                     _loc16_ += Math.round(this.defender.maxHP * 0.05);
                     this.defender.removeDebuff(BattleData.EFFECT_PET_BURN);
                  }
                  if(this.defender.isBattleDebuffActive(BattleData.EFFECT_BURNING))
                  {
                     _loc16_ += Math.round(this.defender.maxHP * 0.05);
                     this.defender.removeDebuff(BattleData.EFFECT_BURNING);
                  }
                  if(_loc16_ == 0)
                  {
                     _loc16_ = int(this.defender.maxHP * 0.01);
                  }
                  _loc16_ = this.updateHP(this.defender,0 - _loc16_);
                  _loc1_.effect.flameEaten = _loc16_;
                  break;
               case BattleData.EFFECT_INTERNAL_INJURY_RANDOM:
                  _loc7_ = NumberUtil.getRandom();
                  if(_loc7_ <= int(_loc1_.effect.amount) / 100)
                  {
                     _loc5_ = {
                        "type":BattleData.EFFECT_INTERNAL_INJURY,
                        "duration":_loc1_.effect.duration,
                        "amount":_loc1_.effect.amount
                     };
                     _loc1_.defenderDebuff.push(_loc5_);
                  }
                  break;
               case BattleData.EFFECT_PET_DRAIN_HP:
                  _loc17_ = Math.round(this.defender.maxHP * int(_loc1_.effect.amount) / 100);
                  _loc17_ = Math.abs(this.updateHP(this.defender,0 - _loc17_));
                  _loc4_ = this.getPetMasterById(this.attacker.getCharacterId());
                  if(_loc4_)
                  {
                     this.updateHP(_loc4_,_loc17_);
                     _loc1_.effect.damageHp = _loc17_;
                  }
                  break;
               case BattleData.EFFECT_PET_DRAIN_CP:
                  _loc18_ = Math.round(this.defender.maxCP * int(_loc1_.effect.amount) / 100);
                  if(_loc18_ > this.defender.cp)
                  {
                     _loc18_ = int(this.defender.cp);
                  }
                  _loc1_.effect.damageCp = Math.abs(this.updateCP(this.defender,0 - _loc18_));
                  _loc4_ = this.getPetMasterById(this.attacker.getCharacterId());
                  if(_loc4_)
                  {
                     this.updateCP(_loc4_,_loc1_.effect.damageCp);
                  }
                  break;
               case BattleData.MONSTER_HP1:
                  _loc1_.attakcerDamageHp += this.attacker.hp - 1;
                  break;
               case BattleData.EFFECT_SILVER_CHAIN_BUNDLE:
                  if(this.defender.hp / this.defender.maxHP >= 0.5)
                  {
                     _loc1_.effect.amount = 1;
                  }
                  else
                  {
                     _loc1_.effect.amount = 2;
                  }
                  _loc1_.defenderDebuff.push(_loc1_.effect);
                  break;
               case BattleData.EFFECT_BURN_CP_FIX_NUM:
                  _loc1_.defenderDamageCp = int(_loc1_.effect.amount);
                  break;
               case BattleData.EFFECT_BERSERKER_MODE:
                  _loc1_.attackerBuff.push(_loc1_.effect);
                  _loc1_.attackerDebuff.push(_loc1_.effect);
                  break;
               case BattleData.EFFECT_DODGE_BONUS_ALL_FRIENDLY:
                  _loc1_.attackerBuff.push(_loc1_.effect);
                  _loc8_ = 0;
                  while(_loc8_ < this.characterArr.length)
                  {
                     if(this.characterArr[_loc8_].isDead == false && this.characterArr[_loc8_].side == this.attacker.side)
                     {
                        this.setBuff(this.characterArr[_loc8_],_loc1_.effect);
                     }
                     _loc8_++;
                  }
                  break;
               case BattleData.EFFECT_WIND_PEACE_SINGLE:
                  _loc1_.attackerBuff.push(_loc1_.effect);
                  break;
               case BattleData.EFFECT_WIND_PEACE:
               case BattleData.EFFECT_WIND_PEACE_2:
               case BattleData.EFFECT_WIND_PEACE_3:
               case BattleData.EFFECT_WIND_PEACE_4:
                  _loc1_.attackerBuff.push(_loc1_.effect);
                  _loc8_ = 0;
                  while(_loc8_ < this.characterArr.length)
                  {
                     if(this.characterArr[_loc8_].isDead == false && this.characterArr[_loc8_].side == this.attacker.side)
                     {
                        this.setBuff(this.characterArr[_loc8_],_loc1_.effect);
                     }
                     _loc8_++;
                  }
                  break;
               case BattleData.EFFECT_CERBERUS:
                  _loc1_.attackerBuff.push(_loc1_.effect);
                  _loc5_ = {
                     "type":BattleData.EFFECT_COMPLETE_GUARD,
                     "duration":1
                  };
                  _loc1_.attackerBuff.push(_loc5_);
                  break;
               case BattleData.EFFECT_FIRE_ENERGY_EXCITATION:
                  _loc5_ = {
                     "type":BattleData.EFFECT_EXCITATION_CP,
                     "duration":_loc1_.effect.amount
                  };
                  _loc1_.attackerBuff.push(_loc5_);
                  _loc5_ = {
                     "type":BattleData.EFFECT_EXCITATION_CHARGE,
                     "duration":_loc1_.effect.duration
                  };
                  _loc1_.attackerBuff.push(_loc5_);
                  break;
               case BattleData.EFFECT_ADD_ALL_COOLDOWN:
                  this.defender.addAllSkillCooldown(_loc1_.effect.amount);
                  break;
               case BattleData.SKILL_285:
               case BattleData.SKILL_302:
               case BattleData.SKILL_251:
               case BattleData.SKILL_268:
               case BattleData.SKILL_268_2:
                  _loc1_.attackerBuff.push(_loc1_.effect);
                  this.attacker.clearAllDebuff();
                  break;
               case BattleData.SKILL_253:
                  _loc1_.defenderDebuff.push(_loc1_.effect);
                  this.defender.addSkillCooldown(_loc1_.effect.duration - 1,SkillData.TYPE_WATER);
                  if(this.attacker.isBattleBuffActive(BattleData.SKILL_251))
                  {
                     _loc5_ = {
                        "type":BattleData.EFFECT_INTERNAL_INJURY,
                        "duration":_loc1_.effect.duration
                     };
                     _loc1_.defenderDebuff.push(_loc5_);
                  }
                  break;
               case BattleData.EFFECT_PURIFY:
                  _loc19_ = 1;
                  _loc7_ = NumberUtil.getRandom();
                  if(this.defender.isBattleDebuffActive(BattleData.SKILL_253))
                  {
                     _loc19_ = 0;
                  }
                  if(_loc7_ <= _loc19_)
                  {
                     this.defender.clearAllDebuff();
                     _loc1_.effect.activated = true;
                  }
                  else
                  {
                     _loc1_.effect.activated = false;
                  }
                  break;
               case BattleData.EFFECT_RESTORE_CP:
                  _loc1_.defenderRestoreCp += int(_loc1_.effect.amount);
                  break;
               case BattleData.EFFECT_ALL_CP_GUARD_RESIST:
                  _loc1_.defenderBuff.push(_loc1_.effect);
                  _loc5_ = {
                     "type":BattleData.EFFECT_PET_DEBUFF_RESIST,
                     "duration":_loc1_.effect.duration,
                     "amount":100
                  };
                  _loc1_.defenderBuff.push(_loc5_);
                  break;
               case BattleData.EFFECT_BLOODLUST_DEDICATION:
                  defender.clearAllDebuff();
                  _loc1_.defenderRestoreHp += Math.round(this.defender.maxHP * int(_loc1_.effect.amount) / 100);
                  break;
               case BattleData.EFFECT_WAKE_UP:
                  if(this.defender.isBattleDebuffActive(BattleData.EFFECT_SLEEP))
                  {
                     this.defender.getBattleDebuff()[BattleData.EFFECT_SLEEP] = null;
                  }
                  break;
               case BattleData.EFFECT_RANDOM_SLEEP:
                  _loc7_ = NumberUtil.getRandom();
                  if(_loc7_ <= int(_loc1_.effect.amount) / 100)
                  {
                     _loc5_ = {
                        "type":BattleData.EFFECT_SLEEP,
                        "duration":_loc1_.effect.duration
                     };
                     _loc1_.defenderDebuff.push(_loc5_);
                  }
                  break;
               case BattleData.EFFECT_ADD_COOLDOWN:
                  this.defender.addRandomSkillCooldown(_loc1_.effect.amount);
                  break;
               case BattleData.EFFECT_CLEARBUFF_DAMAGEREDUCTION:
                  _loc1_.defenderDebuff.push(_loc1_.effect);
                  this.defender.clearBuff();
                  break;
               case BattleData.INSTANT_KILL:
                  _loc1_.dmg = this.defender.maxHP;
                  break;
               case BattleData.INSTANT_CUT_HALF_HP:
                  _loc1_.dmg = defender.maxHP / 2;
                  break;
               case BattleData.EFFECT_BURN_CP_CLEAR_BUFF_WEAK:
                  if(Central.battle.type == Central.battle.TYPE_LOCAL)
                  {
                     _loc23_ = defender.getData(DBCharacterData.ID);
                     _loc24_ = 0;
                     while(_loc24_ < 2)
                     {
                        _loc25_ = _loc24_ == 0 ? defender.getBattleBuff() : defender.getBattleDebuff();
                        if(_loc25_)
                        {
                           _loc26_ = this.getOneRandomNonPassiveEffectFromLists(new Array(_loc25_));
                           if(_loc26_)
                           {
                              if(!_loc1_.removedEffectList)
                              {
                                 _loc1_.removedEffectList = [];
                              }
                              _loc27_ = {
                                 "targetId":_loc23_,
                                 "type":_loc26_.type
                              };
                              _loc1_.removedEffectList.push(_loc27_);
                           }
                        }
                        _loc24_++;
                     }
                  }
                  break;
               case BattleData.EFFECT_REDUCE_CP_MAX_BLEEDING:
                  _loc5_ = {
                     "type":BattleData.EFFECT_REDUCE_CP_MAX,
                     "duration":_loc1_.effect.duration,
                     "amount":_loc1_.effect.amount
                  };
                  _loc1_.defenderDebuff.push(_loc5_);
                  if(!this.defender.isBattleBuffActive(BattleData.EFFECT_BURN_HP_CP_FIX_NUM_N_IMMUNITY_BLEEDING))
                  {
                     _loc5_ = {
                        "type":BattleData.EFFECT_BLEEDING,
                        "duration":_loc1_.effect.duration,
                        "amount":int(_loc1_.effect.amount) + 20
                     };
                     _loc1_.defenderDebuff.push(_loc5_);
                  }
                  break;
               case BattleData.EFFECT_CP_LOCK_AND_DEBUFF_RESIST:
                  switch(_loc1_.target)
                  {
                     case "friendly":
                        _loc8_ = 0;
                        while(_loc8_ < characterArr.length)
                        {
                           if(characterArr[_loc8_].isDead == false && characterArr[_loc8_].side == attacker.side)
                           {
                              _loc31_ = {
                                 "type":BattleData.EFFECT_CP_LOCK,
                                 "duration":_loc1_.effect.duration
                              };
                              this.setBuff(characterArr[_loc8_],_loc31_);
                              _loc31_ = {
                                 "type":BattleData.EFFECT_RESTRICT_CHARGE,
                                 "duration":_loc1_.effect.amount
                              };
                              this.setDebuff(characterArr[_loc8_],_loc31_);
                              _loc31_ = {
                                 "type":BattleData.EFFECT_PET_DEBUFF_RESIST,
                                 "duration":_loc1_.effect.duration,
                                 "amount":100
                              };
                              this.setBuff(characterArr[_loc8_],_loc31_);
                           }
                           _loc8_++;
                        }
                        break;
                     default:
                        _loc31_ = {
                           "type":BattleData.EFFECT_CP_LOCK,
                           "duration":_loc1_.effect.duration
                        };
                        attacker.setBattleBuff(_loc31_);
                        _loc31_ = {
                           "type":BattleData.EFFECT_RESTRICT_CHARGE,
                           "duration":_loc1_.effect.amount
                        };
                        attacker.setBattleDebuff(_loc31_);
                        _loc31_ = {
                           "type":BattleData.EFFECT_PET_DEBUFF_RESIST,
                           "duration":_loc1_.effect.duration,
                           "amount":100
                        };
                        attacker.setBattleBuff(_loc31_);
                  }
                  break;
               case BattleData.EFFECT_THUNDER_MODE_N_DEBUFF_RESIST:
                  _loc31_ = {
                     "type":BattleData.EFFECT_PET_DEBUFF_RESIST,
                     "duration":_loc1_.effect.duration,
                     "amount":100
                  };
                  attacker.setBattleBuff(_loc31_);
                  _loc31_ = {
                     "type":BattleData.EFFECT_THUNDERSTORM_MODE,
                     "duration":_loc1_.effect.duration,
                     "amount":_loc1_.effect.amount
                  };
                  attacker.setBattleBuff(_loc31_);
                  break;
               case BattleData.EFFECT_RECEIVED_BURNING:
                  _loc1_.attackerBuff.push(_loc1_.effect);
                  _loc5_ = {
                     "type":BattleData.EFFECT_DEFENDER_BURNING,
                     "amount":5,
                     "duration":_loc1_.effect.duration
                  };
                  _loc1_.attackerBuff.push(_loc5_);
                  break;
               case BattleData.EFFECT_DMG_BONUS_N_RECEIVED_BURNING:
                  _loc1_.attackerBuff.push(_loc1_.effect);
                  _loc5_ = {
                     "type":BattleData.EFFECT_DAMAGE_BONUS,
                     "amount":_loc1_.effect.amount,
                     "duration":_loc1_.effect.duration
                  };
                  _loc1_.attackerBuff.push(_loc5_);
                  _loc5_ = {
                     "type":BattleData.EFFECT_DEFENDER_BURNING,
                     "amount":5,
                     "duration":_loc1_.effect.duration
                  };
                  _loc1_.attackerBuff.push(_loc5_);
                  break;
               case BattleData.EFFECT_CRITICAL_CHANCE_REGEN_HP:
                  _loc1_.attackerBuff.push(_loc1_.effect);
                  _loc5_ = {
                     "type":BattleData.EFFECT_CRITICAL_CHANCE_BONUS,
                     "amount":_loc1_.effect.amount,
                     "duration":_loc1_.effect.duration
                  };
                  _loc1_.attackerBuff.push(_loc5_);
                  _loc5_ = {
                     "type":BattleData.EFFECT_REGENERATE_HP,
                     "amount":10,
                     "duration":_loc1_.effect.duration
                  };
                  _loc1_.attackerBuff.push(_loc5_);
                  break;
               case BattleData.EFFECT_CRITICAL_BUFF_N_RECEIVED_STUN:
                  _loc1_.attackerBuff.push(_loc1_.effect);
                  _loc5_ = {
                     "type":BattleData.EFFECT_CRITICAL_CHANCE_BONUS,
                     "amount":_loc1_.effect.amount,
                     "duration":_loc1_.effect.duration
                  };
                  _loc1_.attackerBuff.push(_loc5_);
                  _loc5_ = {
                     "type":BattleData.EFFECT_CRITICAL_DMG_BONUS,
                     "amount":_loc1_.effect.amount,
                     "duration":_loc1_.effect.duration
                  };
                  _loc1_.attackerBuff.push(_loc5_);
                  _loc5_ = {
                     "type":BattleData.EFFECT_RECEIVED_DMG_STUN,
                     "duration":_loc1_.effect.duration
                  };
                  _loc1_.attackerBuff.push(_loc5_);
                  break;
               case BattleData.EFFECT_MANA_SHILED_N_PURIFY_BELOW_CP:
                  _loc1_.attackerBuff.push(_loc1_.effect);
                  _loc5_ = {
                     "type":BattleData.EFFECT_MANA_SHIELD,
                     "amount":2,
                     "duration":_loc1_.effect.duration
                  };
                  _loc1_.attackerBuff.push(_loc5_);
                  _loc5_ = {
                     "type":BattleData.EFFECT_PURIFY_BELOW_CP,
                     "amount":_loc1_.effect.amount,
                     "duration":_loc1_.effect.duration
                  };
                  _loc1_.attackerBuff.push(_loc5_);
                  break;
               case BattleData.EFFECT_REDUCE_DMG_N_AGI:
                  _loc1_.attackerBuff.push(_loc1_.effect);
                  _loc5_ = {
                     "type":BattleData.EFFECT_DAMAGE_REDUCTION,
                     "amount":_loc1_.effect.amount,
                     "duration":_loc1_.effect.duration
                  };
                  _loc1_.attackerBuff.push(_loc5_);
                  _loc5_ = {
                     "type":BattleData.EFFECT_RECEIVED_DMG_REDUCE_AGI,
                     "amount":50,
                     "duration":2
                  };
                  _loc1_.attackerBuff.push(_loc5_);
                  break;
               case BattleData.EFFECT_DMG_REDUCE_ATKER_BURN:
                  _loc1_.attackerBuff.push(_loc1_.effect);
                  _loc5_ = {
                     "type":BattleData.EFFECT_DAMAGE_REDUCTION,
                     "amount":_loc1_.effect.amount,
                     "duration":_loc1_.effect.duration
                  };
                  _loc1_.attackerBuff.push(_loc5_);
                  _loc5_ = {
                     "type":BattleData.EFFECT_ATTACKER_BURNING,
                     "amount":5,
                     "duration":_loc1_.effect.duration
                  };
                  _loc1_.attackerBuff.push(_loc5_);
                  break;
               case BattleData.EFFECT_RESTORE_CP_DMG_SHIELD:
                  _loc1_.attackerRestoreCp = this.attacker.maxCP;
                  _loc5_ = {
                     "type":BattleData.EFFECT_MANA_SHIELD,
                     "amount":2,
                     "duration":_loc1_.effect.duration
                  };
                  _loc1_.attackerBuff.push(_loc5_);
                  _loc5_ = {
                     "type":BattleData.EFFECT_DAMAGE_REDUCTION,
                     "duration":_loc1_.effect.duration,
                     "amount":_loc1_.effect.amount
                  };
                  _loc1_.attackerBuff.push(_loc5_);
                  break;
               case BattleData.EFFECT_BERSERKER_BUFF:
                  _loc20_ = 0;
                  switch(_loc1_.target)
                  {
                     case "friendly":
                        _loc8_ = 0;
                        while(_loc8_ < characterArr.length)
                        {
                           if(characterArr[_loc8_].isDead == false && characterArr[_loc8_].side == attacker.side)
                           {
                              for(_loc6_ in this.characterArr[_loc8_].getBattleBuff())
                              {
                                 if(this.characterArr[_loc8_].getBattleBuff()[_loc6_])
                                 {
                                    if(this.characterArr[_loc8_].getBattleBuff()[_loc6_].duration != 999)
                                    {
                                       _loc20_++;
                                    }
                                 }
                              }
                           }
                           _loc8_++;
                        }
                        _loc20_ = _loc20_ * _loc1_.effect.amount + _loc1_.effect.amount;
                        _loc5_ = {
                           "type":BattleData.EFFECT_BERSERKER_BUFF,
                           "amount":_loc20_,
                           "duration":_loc1_.effect.duration
                        };
                        _loc1_.attackerBuff.push(_loc5_);
                        break;
                     default:
                        for(_loc6_ in this.attacker.getBattleBuff())
                        {
                           if(this.attacker.getBattleBuff()[_loc6_])
                           {
                              if(this.attacker.getBattleBuff()[_loc6_].duration != 999)
                              {
                                 _loc20_++;
                              }
                           }
                        }
                        _loc20_ = _loc20_ * _loc1_.effect.amount + _loc1_.effect.amount;
                        _loc5_ = {
                           "type":BattleData.EFFECT_BERSERKER_BUFF,
                           "amount":_loc20_,
                           "duration":_loc1_.effect.duration
                        };
                        _loc1_.attackerBuff.push(_loc5_);
                  }
                  break;
               case BattleData.EFFECT_PET_BURN_FREEZE:
                  _loc5_ = {
                     "type":BattleData.EFFECT_PET_FREEZE,
                     "duration":_loc1_.effect.duration
                  };
                  this.defender.setBattleDebuff(_loc5_);
                  _loc5_ = {
                     "type":BattleData.EFFECT_PET_BURN,
                     "duration":_loc1_.effect.duration,
                     "amount":_loc1_.effect.amount
                  };
                  this.defender.setBattleDebuff(_loc5_);
                  canpetburn = true;
                  break;
               case BattleData.EFFECT_BUNDLE_DARKNESS:
                  _loc5_ = {
                     "type":BattleData.EFFECT_DARKNESS,
                     "duration":_loc1_.effect.duration,
                     "amount":_loc1_.effect.amount
                  };
                  this.defender.setBattleDebuff(_loc5_);
                  _loc5_ = {
                     "type":BattleData.EFFECT_BUNDLE,
                     "duration":_loc1_.effect.duration,
                     "amount":_loc1_.effect.amount
                  };
                  this.defender.setBattleDebuff(_loc5_);
                  break;
               case BattleData.EFFECT_SAND_GUARD:
                  this.attacker.setBattleBuff(_loc1_.effect);
                  break;
               case BattleData.EFFECT_DMG_BONUS_N_REDUCTION_FIX:
                  this.attacker.setBattleBuff(_loc1_.effect);
                  break;
               case BattleData.EFFECT_DMG_BONUS_N_REDUCTION:
                  this.attacker.setBattleBuff(_loc1_.effect);
                  break;
               case BattleData.EFFECT_SKILL_899:
                  this.attacker.setBattleBuff(_loc1_.effect);
                  _loc14_ = int(this.attacker.agility);
                  _loc14_ = _loc14_ + _loc1_.effect.amount * 15;
                  Central.client.getInstance().updateCharacterAgility(this.attacker.getData("character_id"),_loc14_);
                  break;
               case BattleData.EFFECT_AGILITY_BONUS_FIX:
                  this.attacker.setBattleBuff(_loc1_.effect);
                  _loc14_ = int(this.attacker.agility);
                  _loc14_ = _loc14_ + _loc1_.effect.amount;
                  Central.client.getInstance().updateCharacterAgility(this.attacker.getData("character_id"),_loc14_);
                  break;
               case BattleData.EFFECT_DEBUFF_RESIST_EX:
                  this.attacker.setBattleBuff(_loc1_.effect);
                  break;
               case BattleData.EFFECT_ALL_BUFF:
                  _loc5_ = {
                     "type":BattleData.EFFECT_DAMAGE_REDUCTION,
                     "duration":_loc1_.effect.duration,
                     "amount":_loc1_.effect.amount
                  };
                  this.attacker.setBattleBuff(_loc5_);
                  _loc5_ = {
                     "type":BattleData.EFFECT_DAMAGE_BONUS,
                     "duration":_loc1_.effect.duration,
                     "amount":_loc1_.effect.amount
                  };
                  this.attacker.setBattleBuff(_loc5_);
                  _loc5_ = {
                     "type":BattleData.EFFECT_DODGE_BONUS,
                     "duration":_loc1_.effect.duration,
                     "amount":_loc1_.effect.amount
                  };
                  this.attacker.setBattleBuff(_loc5_);
                  _loc5_ = {
                     "type":BattleData.EFFECT_ACCURATE,
                     "duration":_loc1_.effect.duration,
                     "amount":_loc1_.effect.amount
                  };
                  this.attacker.setBattleBuff(_loc5_);
                  break;
               case BattleData.EFFECT_MDF_CD_N_ADD_ATTENTION:
                  _loc5_ = {
                     "type":BattleData.EFFECT_PET_ATTENTION,
                     "duration":_loc1_.effect.duration,
                     "amount":_loc1_.effect.amount
                  };
                  this.attacker.setBattleBuff(_loc5_);
                  break;
               case BattleData.EFFECT_CLEAR_DEBUFF_RST_DMG_HP:
                  _loc1_.attackerRestoreHp += _loc1_.effect.duration;
                  this.attacker.clearAllDebuff();
                  break;
               case BattleData.EFFECT_ADD_HP_CP_SP_PURIFY:
               case BattleData.EFFECT_ADD_HP_CP_SP_PURIFY_RAGE:
                  _loc1_.attackerRestoreHp += Math.round(this.attacker.maxHP * int(_loc1_.effect.amount) / 100);
                  _loc1_.attackerRestoreCp += Math.round(this.attacker.maxCP * int(_loc1_.effect.amount) / 100);
                  _loc1_.attackerRestoreSp += Math.round(this.attacker.maxSP * int(_loc1_.effect.duration) / 100);
                  this.attacker.clearAllDebuff();
                  break;
               case BattleData.EFFECT_ADD_ALL_HP_CP:
                  _loc8_ = 0;
                  while(_loc8_ < this.characterArr.length)
                  {
                     if(this.characterArr[_loc8_].side == this.attacker.side)
                     {
                        this.updateCP(this.characterArr[_loc8_],Math.round(this.characterArr[_loc8_].maxCP * int(_loc1_.effect.amount) / 100));
                        this.characterArr[_loc8_].showOverheadNumber(Timeline.WORD,"+" + Math.round(this.characterArr[_loc8_].maxCP * int(_loc1_.effect.amount) / 100) + Central.main.langLib.titleTxt(TitleData.CP));
                     }
                     _loc8_++;
                  }
                  break;
               case BattleData.EFFECT_ADD_ALL_HP_CP_CLEAR_DEBUFF:
                  _loc8_ = 0;
                  while(_loc8_ < this.characterArr.length)
                  {
                     if(this.characterArr[_loc8_].side == this.attacker.side)
                     {
                        this.updateCP(this.characterArr[_loc8_],Math.round(this.characterArr[_loc8_].maxCP * int(_loc1_.effect.amount) / 100));
                        this.characterArr[_loc8_].showOverheadNumber(Timeline.WORD,"+" + Math.round(this.characterArr[_loc8_].maxCP * int(_loc1_.effect.amount) / 100) + Central.main.langLib.titleTxt(TitleData.CP));
                        this.characterArr[_loc8_].clearAllDebuff();
                     }
                     _loc8_++;
                  }
                  break;
               case BattleData.EFFECT_PROTECT_BY_DUMMY_BURN_PROTECTION:
                  _loc1_.effect.chance = _loc1_.effect.amount;
                  _loc1_.effect.remainClones = _loc1_.effect.duration - 2;
                  _loc1_.attackerBuff.push(_loc1_.effect);
                  _loc5_ = {
                     "type":BattleData.EFFECT_BURN_PROTECTION,
                     "duration":_loc1_.effect.duration,
                     "amount":_loc1_.effect.amount
                  };
                  this.attacker.setBattleBuff(_loc5_);
                  this.attacker.removeDebuff(BattleData.EFFECT_BURN);
                  this.attacker.removeDebuff(BattleData.EFFECT_PET_BURN);
                  this.attacker.removeDebuff(BattleData.EFFECT_BURNING);
                  this.attacker.removeDebuff(BattleData.EFFECT_DOUBLE_BURN);
                  break;
               case BattleData.EFFECT_PROTECT_BY_DUMMY:
               case BattleData.EFFECT_PROTECT_BY_DUMMY_RECEIVED_BURN:
               case BattleData.EFFECT_PROTECT_BY_DUMMY_RECEIVED_STUN:
                  _loc1_.effect.chance = _loc1_.effect.amount;
                  _loc1_.effect.remainClones = _loc1_.effect.duration - 2;
                  _loc1_.attackerBuff.push(_loc1_.effect);
                  trace("battleAction.effect.remainClones  = " + _loc1_.effect.remainClones);
                  break;
               case BattleData.EFFECT_ABSORB_BUFF:
                  _loc21_ = this.getAvailableBuff(this.defender,_loc1_.effect.amount);
                  _loc22_ = this.getOneRandomNonPassiveEffectCanAbsorb(_loc21_);
                  _loc8_ = 0;
                  while(_loc8_ < _loc22_.length)
                  {
                     if(_loc22_[_loc8_] == 2)
                     {
                        _loc1_.attackerBuff.push(_loc21_[_loc8_]);
                        this.defender.removeBuff(_loc21_[_loc8_].type);
                     }
                     else if(_loc22_[_loc8_] == 1)
                     {
                        this.defender.removeBuff(_loc21_[_loc8_].type);
                     }
                     else if(_loc22_[_loc8_] == 0)
                     {
                     }
                     _loc8_++;
                  }
            }
         }
         if(_loc1_.skillId)
         {
            _loc28_ = Central.main.SKILL_DATA[_loc1_.skillId];
            if(_loc28_)
            {
               if(Boolean(_loc28_.extra_effect) && _loc28_.extra_effect != null)
               {
                  _loc29_ = _loc28_.extra_effect;
                  _loc13_ = [];
                  _loc8_ = 0;
                  while(_loc8_ < _loc29_.enemy.length)
                  {
                     _loc13_.push(Central.main.ENEMY_DATA.find(_loc29_.enemy[_loc8_]).name);
                     _loc8_++;
                  }
                  if(defender.type == 4 && _loc13_.indexOf(this.defender.getCharacterName()) >= 0)
                  {
                     switch(_loc29_.type)
                     {
                        case BattleData.EFFECT_CLEAR_BLESS_N_REDUCE_HP:
                           if(this.defender.isBattleBuffActive(BattleData.EFFECT_DEBUFF_RESIST_EX))
                           {
                              delete this.defender.getBattleBuff()[BattleData.EFFECT_DEBUFF_RESIST_EX];
                           }
                           _loc1_.defenderDamageHp += Math.round(this.defender.hp * _loc29_.amount * 0.01);
                     }
                  }
               }
            }
         }
         if(_loc1_.action == "weapon_attack")
         {
            _loc30_ = this.attacker.getBattleBuff();
            if(this.attacker.isBattleBuffActive(BattleData.EFFECT_UNHOLY_POISON))
            {
               _loc5_ = {
                  "type":BattleData.EFFECT_POISON,
                  "duration":2,
                  "amount":_loc30_[BattleData.EFFECT_UNHOLY_POISON].amount
               };
               _loc1_.defenderDebuff.push(_loc5_);
               _loc5_ = {
                  "type":BattleData.EFFECT_PETRIFICATION,
                  "duration":2,
                  "amount":_loc30_[BattleData.EFFECT_UNHOLY_POISON].amount
               };
               _loc1_.defenderDebuff.push(_loc5_);
            }
            if(this.attackerWeapon)
            {
               for each(_loc31_ in this.attackerWeapon.effect)
               {
                  switch(_loc31_.type)
                  {
                     case BattleData.EFFECT_WEAPON_CHAOS_PERCENT:
                        if(NumberUtil.getRandom() <= int(_loc31_.chance) / 100)
                        {
                           _loc5_ = {
                              "type":BattleData.EFFECT_CHAOS,
                              "duration":_loc31_.duration,
                              "amount":_loc31_.amount
                           };
                           _loc1_.defenderDebuff.push(_loc5_);
                        }
                        break;
                     case BattleData.EFFECT_WEAPON_INTERNAL_INJURY:
                        if(NumberUtil.getRandom() <= int(_loc31_.chance) / 100)
                        {
                           _loc5_ = {
                              "type":BattleData.EFFECT_INTERNAL_INJURY,
                              "duration":_loc31_.duration,
                              "amount":_loc31_.amount
                           };
                           _loc1_.defenderDebuff.push(_loc5_);
                           _loc1_.weapon_activated = true;
                        }
                        break;
                     case BattleData.EFFECT_ABSORB_BUFF:
                        if(NumberUtil.getRandom() <= int(_loc31_.chance) / 100)
                        {
                           _loc21_ = this.getAvailableBuff(this.defender,_loc31_.amount);
                           _loc22_ = this.getOneRandomNonPassiveEffectCanAbsorb(_loc21_);
                           _loc8_ = 0;
                           while(_loc8_ < _loc22_.length)
                           {
                              if(_loc22_[_loc8_] == 2)
                              {
                                 _loc1_.attackerBuff.push(_loc21_[_loc8_]);
                                 this.defender.removeBuff(_loc21_[_loc8_].type);
                              }
                              else if(_loc22_[_loc8_] == 1)
                              {
                                 this.defender.removeBuff(_loc21_[_loc8_].type);
                              }
                              else if(_loc22_[_loc8_] == 0)
                              {
                              }
                              _loc8_++;
                           }
                        }
                        break;
                     case BattleData.EFFECT_DEFENDER_PETRIFICATION:
                        if(NumberUtil.getRandom() <= int(_loc31_.chance) / 100)
                        {
                           _loc5_ = {
                              "type":BattleData.EFFECT_PETRIFICATION,
                              "duration":_loc31_.duration,
                              "amount":_loc31_.amount
                           };
                           _loc1_.defenderDebuff.push(_loc5_);
                           _loc1_.weapon_activated = true;
                        }
                        break;
                     case BattleData.EFFECT_TRANSFORM:
                        if(NumberUtil.getRandom() <= int(_loc31_.chance) / 100)
                        {
                           _loc1_.defenderDebuff.push(_loc31_);
                        }
                        break;
                     case BattleData.EFFECT_REDUCE_AGILITY:
                        _loc1_.defenderDebuff.push(_loc31_);
                        break;
                     case BattleData.EFFECT_BLIND:
                        if(NumberUtil.getRandom() <= int(_loc31_.chance) / 100)
                        {
                           _loc1_.defenderDebuff.push(_loc31_);
                           this.defender.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(287));
                        }
                        break;
                     case BattleData.EFFECT_REDUCE_PURIFY_CHANCE:
                        if(NumberUtil.getRandom() <= int(_loc31_.chance) / 100)
                        {
                           _loc1_.defenderDebuff.push(_loc31_);
                        }
                  }
               }
            }
            if(this.attackerWeapon)
            {
               for each(_loc31_ in this.attackerWeapon.effect)
               {
                  switch(_loc31_.type)
                  {
                     case BattleData.EFFECT_JUTSU_POISON:
                     case BattleData.EFFECT_DOUBLE_BURN:
                     case BattleData.EFFECT_BURN:
                     case BattleData.EFFECT_BURNING:
                     case BattleData.EFFECT_PET_BURN:
                     case BattleData.EFFECT_BURN_FIX_NUM:
                     case BattleData.EFFECT_DEFENDER_BURNING:
                        if(this.defender.getBackItem())
                        {
                           _loc32_ = Central.main.BACK_ITEM_DATA.find(this.defender.getBackItem());
                           if(_loc32_)
                           {
                              for each(_loc33_ in _loc32_.effect)
                              {
                                 switch(_loc33_.type)
                                 {
                                    case BattleData.EFFECT_BURN_PROTECTION:
                                       if(NumberUtil.getRandom() <= _loc33_.chance / 100)
                                       {
                                          _loc31_.type = null;
                                       }
                                 }
                              }
                           }
                        }
                        if(this.defender.isBattleBuffActive(BattleData.EFFECT_BURN_PROTECTION))
                        {
                           _loc31_.type = null;
                        }
                        break;
                     case BattleData.EFFECT_INTERNAL_INJURY:
                        if(this.defender.getBackItem())
                        {
                           _loc32_ = Central.main.BACK_ITEM_DATA.find(this.defender.getBackItem());
                           if(_loc32_)
                           {
                              for each(_loc33_ in _loc32_.effect)
                              {
                                 switch(_loc33_.type)
                                 {
                                    case BattleData.EFFECT_INTERNAL_INJURY_PROTECTION:
                                       if(NumberUtil.getRandom() <= _loc33_.chance / 100)
                                       {
                                          _loc31_.type = null;
                                       }
                                 }
                              }
                           }
                        }
                        break;
                     case BattleData.EFFECT_BLEEDING:
                     case BattleData.EFFECT_BLEEDING_FIX_NUM:
                        if(this.defender.getAccessory())
                        {
                           _loc34_ = Central.main.ACCESSORY_DATA.find(this.defender.getAccessory());
                           if(_loc34_)
                           {
                              _loc33_ = null;
                              for each(_loc33_ in _loc34_.effect)
                              {
                                 switch(_loc33_.type)
                                 {
                                    case BattleData.EFFECT_BLEEDING_PROTECTION:
                                       if(NumberUtil.getRandom() <= _loc33_.chance / 100)
                                       {
                                          _loc31_.type = null;
                                       }
                                 }
                              }
                           }
                        }
                        if(this.defender.isBattleBuffActive(BattleData.EFFECT_BURN_HP_CP_FIX_NUM_N_IMMUNITY_BLEEDING))
                        {
                           _loc31_.type = null;
                        }
                  }
                  switch(_loc31_.type)
                  {
                     case BattleData.EFFECT_ATTACKER_RESTORE_HP:
                        _loc1_.attackerRestoreHp += _loc31_.amount;
                        break;
                     case BattleData.EFFECT_ATTACKER_RESTORE_CP:
                        _loc1_.attackerRestoreCp += _loc31_.amount;
                        break;
                     case BattleData.EFFECT_DEFENDER_DAMAGE_CP:
                        _loc1_.defenderDamageCp += _loc31_.amount;
                        break;
                     case BattleData.EFFECT_DEFENDER_DAMAGE_HP:
                        _loc1_.defenderDamageHp += _loc31_.amount;
                        break;
                     case BattleData.EFFECT_DEFENDER_BURNING:
                        if(NumberUtil.getRandom() <= _loc31_.chance / 100)
                        {
                           _loc5_ = {
                              "type":BattleData.EFFECT_BURNING,
                              "duration":_loc31_.duration,
                              "amount":_loc31_.amount
                           };
                           _loc1_.defenderDebuff.push(_loc5_);
                           _loc1_.weapon_activated = true;
                           canburning = true;
                        }
                        break;
                     case BattleData.EFFECT_DEFENDER_BUNDLE:
                        if(NumberUtil.getRandom() <= _loc31_.chance / 100)
                        {
                           _loc5_ = {
                              "type":BattleData.EFFECT_BUNDLE,
                              "duration":_loc31_.duration,
                              "amount":_loc31_.amount
                           };
                           _loc1_.defenderDebuff.push(_loc5_);
                        }
                        break;
                     case BattleData.EFFECT_DEFENDER_POISON:
                        _loc5_ = {
                           "type":BattleData.EFFECT_POISON,
                           "duration":_loc31_.duration,
                           "amount":_loc31_.amount
                        };
                        _loc1_.defenderDebuff.push(_loc5_);
                        break;
                     case BattleData.EFFECT_ATTACKER_DAMAGE_REDUCTION:
                        _loc5_ = {
                           "type":BattleData.EFFECT_DAMAGE_REDUCTION,
                           "duration":_loc31_.duration,
                           "amount":_loc31_.amount
                        };
                        _loc1_.attackerBuff.push(_loc5_);
                        break;
                     case BattleData.EFFECT_ATTACKER_DAMAGE_BONUS:
                        _loc3_ = 0;
                        if(Boolean(attackerWeapon) && Boolean(attackerWeapon.id == "wpn1596") && Boolean(this.attacker))
                        {
                           _loc2_ = int(Central.main.stateInventory.getStateOnCount(this.attacker.getCharacterId(),"wpn","wpn1596"));
                           if(_loc2_ >= 0)
                           {
                              _loc3_ = _loc2_;
                           }
                        }
                        _loc5_ = {
                           "type":BattleData.EFFECT_DAMAGE_BONUS,
                           "duration":_loc31_.duration,
                           "amount":_loc31_.amount + 5 * _loc3_
                        };
                        _loc1_.attackerBuff.push(_loc5_);
                        break;
                     case BattleData.EFFECT_DEFENDER_CLEAR_BUFF:
                        if(NumberUtil.getRandom() <= _loc31_.chance / 100)
                        {
                           this.defender.clearBuff();
                           _loc1_.weapon_activated = true;
                        }
                        break;
                     case BattleData.EFFECT_ATTACKER_REDUCE_COOLDOWN:
                        this.attacker.reduceSkillCooldown(_loc31_.amount,BattleData.REDUCETYPE_SKILL,SkillData.TYPE_GENJUTSU);
                        break;
                     case BattleData.EFFECT_DEFENDER_FREEZE:
                        if(NumberUtil.getRandom() <= _loc31_.chance / 100)
                        {
                           _loc5_ = {
                              "type":BattleData.EFFECT_PET_FREEZE,
                              "duration":_loc31_.duration,
                              "amount":_loc31_.amount
                           };
                           _loc1_.defenderDebuff.push(_loc5_);
                           _loc1_.freeze_weapon_activated = true;
                        }
                        break;
                     case BattleData.EFFECT_BLEEDING_FIX_NUM:
                     case BattleData.EFFECT_BLEEDING:
                        if(!this.defender.isBattleBuffActive(BattleData.EFFECT_BURN_HP_CP_FIX_NUM_N_IMMUNITY_BLEEDING))
                        {
                           _loc1_.defenderDebuff.push(_loc31_);
                        }
                        break;
                     case BattleData.EFFECT_CRITICAL_DAMAGE_BONUS_WEAPON_FIX_NUM:
                        _loc1_.attackerBuff.push(_loc31_);
                        break;
                     case BattleData.EFFECT_BURN_FIX_NUM:
                        _loc1_.defenderDebuff.push(_loc31_);
                        canburnnum = true;
                        break;
                     case BattleData.EFFECT_DAMAGE_HP_FIX_NUM:
                        _loc1_.defenderDebuff.push(_loc31_);
                        break;
                     case BattleData.EFFECT_PET_WEAKEN:
                     case BattleData.EFFECT_PET_WEAKEN_FIX_NUM:
                        _loc1_.defenderDebuff.push(_loc31_);
                        break;
                     case BattleData.EFFECT_DODGE_REDUCTION:
                        _loc1_.defenderDebuff.push(_loc31_);
                        break;
                     case BattleData.EFFECT_REDUCE_SELF_CP_CONSUME:
                        _loc5_ = {
                           "type":BattleData.EFFECT_PET_SAVE_CP,
                           "duration":_loc31_.duration,
                           "amount":_loc31_.amount
                        };
                        _loc1_.attackerBuff.push(_loc5_);
                        break;
                     default:
                        if(_loc31_.type != null)
                        {
                           _loc35_ = _loc31_.type.split(".");
                           if(_loc35_ != null && _loc35_.length > 0 && _loc35_[0] == BattleData.EFFECT_ATTACKER_REDUCE_COOLDOWN)
                           {
                              switch(_loc35_[1])
                              {
                                 case "0":
                                    this.attacker.reduceSkillCooldown(_loc31_.amount,BattleData.REDUCETYPE_ALL);
                                    break;
                                 case "1":
                                    if(_loc35_[2] == null)
                                    {
                                       Out.debug(this,"Skill element undefined.");
                                       break;
                                    }
                                    _loc36_ = "";
                                    switch(_loc35_[2])
                                    {
                                       case "0":
                                          _loc36_ = SkillData.TYPE_FIRE;
                                          break;
                                       case "1":
                                          _loc36_ = SkillData.TYPE_WIND;
                                          break;
                                       case "2":
                                          _loc36_ = SkillData.TYPE_LIGHTNING;
                                          break;
                                       case "3":
                                          _loc36_ = SkillData.TYPE_WATER;
                                          break;
                                       case "4":
                                          _loc36_ = SkillData.TYPE_EARTH;
                                          break;
                                       case "5":
                                          _loc36_ = SkillData.TYPE_TAIJUTSU;
                                          break;
                                       case "6":
                                          _loc36_ = SkillData.TYPE_GENJUTSU;
                                    }
                                    this.attacker.reduceSkillCooldown(_loc31_.amount,BattleData.REDUCETYPE_SKILL,_loc36_);
                                    break;
                                 case "2":
                                    this.attacker.reduceSkillCooldown(_loc31_.amount,BattleData.REDUCETYPE_TALENT);
                              }
                              this.attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(598));
                           }
                        }
                  }
               }
            }
         }
         if(this.attackerBackItem)
         {
            for each(_loc31_ in this.attackerBackItem.effect)
            {
               switch(_loc31_.type)
               {
                  case BattleData.EFFECT_ATTACKER_RESTORE_CP_PRESENT:
                     if(this.attacker.side != this.defender.side)
                     {
                        _loc1_.attackerRestoreCp += Math.round(attacker.maxCP * _loc31_.amount / 100);
                     }
                     break;
                  case BattleData.EFFECT_REDUCE_TARGET_CP:
                     if(_loc1_.action == "weapon_attack")
                     {
                        _loc1_.defenderDamageCp += Math.round(this.defender.maxCP * _loc31_.amount * 0.01);
                     }
                     break;
                  case BattleData.EFFECT_DEFENDER_STUN:
                     if(NumberUtil.getRandom() <= _loc31_.chance / 100 && _loc1_.action == "weapon_attack")
                     {
                        _loc5_ = {
                           "type":BattleData.EFFECT_STUN,
                           "duration":_loc31_.duration,
                           "amount":0
                        };
                        _loc1_.defenderDebuff.push(_loc5_);
                        _loc1_.backitem_activated = true;
                     }
               }
            }
         }
         if(this.attacker.side != this.defender.side)
         {
            if(this.defender.getWeapon())
            {
               _loc37_ = Central.main.WEAPON_DATA.find(this.defender.getWeapon());
               if(_loc37_)
               {
                  for each(_loc31_ in _loc37_.effect)
                  {
                     switch(_loc31_.type)
                     {
                        case BattleData.EFFECT_DEFENDER_CRITICAL_CHANCE:
                           if(NumberUtil.getRandom() <= _loc31_.chance / 100)
                           {
                              _loc1_.defenderBuff.push({
                                 "type":BattleData.EFFECT_CRITICAL_CHANCE_BONUS_WEAPON,
                                 "duration":_loc31_.duration,
                                 "amount":_loc31_.amount
                              });
                           }
                           break;
                        case BattleData.EFFECT_DEFENDER_RESTORE_HP_PRESENT:
                           if(NumberUtil.getRandom() <= _loc31_.chance / 100)
                           {
                              _loc1_.defenderRestoreHp += Math.round(this.defender.maxHP * (_loc31_.amount / 100));
                           }
                           break;
                        case BattleData.EFFECT_ATTACKER_BLEEDING:
                           if(!this.attacker.isBattleBuffActive(BattleData.EFFECT_BURN_HP_CP_FIX_NUM_N_IMMUNITY_BLEEDING))
                           {
                              _loc1_.attackerDebuff.push({
                                 "type":BattleData.EFFECT_BLEEDING,
                                 "duration":_loc31_.duration,
                                 "amount":_loc31_.amount
                              });
                           }
                           break;
                        case BattleData.EFFECT_RECEIVED_DAMAGE_BURN_TARGET:
                           if(NumberUtil.getRandom() <= _loc31_.chance / 100)
                           {
                              _loc5_ = {
                                 "type":BattleData.EFFECT_BURNING,
                                 "duration":_loc31_.duration,
                                 "amount":_loc31_.amount
                              };
                              _loc1_.attackerDebuff.push(_loc5_);
                              canburning = true;
                           }
                           break;
                        case BattleData.EFFECT_RECEIVED_DMG_PARRY:
                           if(NumberUtil.getRandom() <= _loc31_.chance / 100)
                           {
                              _loc5_ = {
                                 "type":BattleData.EFFECT_COMPLETE_GUARD,
                                 "duration":_loc31_.duration
                              };
                              _loc1_.defenderBuff.push(_loc5_);
                           }
                     }
                  }
               }
            }
            if(this.attacker.getAccessory())
            {
               attackerAccessory = Central.main.ACCESSORY_DATA.find(this.attacker.getAccessory());
               if(attackerAccessory)
               {
                  for each(_loc31_ in attackerAccessory.effect)
                  {
                     switch(_loc31_.type)
                     {
                        case BattleData.EFFECT_BLIND:
                           if(_loc1_.action == "weapon_attack")
                           {
                              _loc1_.defenderDebuff.push(_loc31_);
                           }
                           break;
                        case BattleData.EFFECT_PET_WEAKEN:
                           if(_loc1_.action == "weapon_attack")
                           {
                              _loc1_.defenderDebuff.push(_loc31_);
                           }
                           break;
                        case BattleData.EFFECT_DEFENDER_BURNING:
                           _loc31_ = {
                              "type":BattleData.EFFECT_BURNING,
                              "amount":_loc31_.amount,
                              "duration":2
                           };
                           _loc1_.defenderDebuff.push(_loc31_);
                           canburning = true;
                     }
                  }
               }
            }
            if(this.attacker.getGearset())
            {
               _loc9_ = this.attacker.getGearset();
               for(_loc6_ in _loc9_)
               {
                  _loc12_ = Central.main.GEAR_SET_DATA.find(_loc6_);
                  _loc8_ = 0;
                  while(_loc8_ < _loc9_[_loc6_] - 1)
                  {
                     _loc10_ = _loc12_.effect[_loc8_];
                     switch(_loc10_.type)
                     {
                        case BattleData.EFFECT_DEFENDER_POISON:
                           if(_loc1_.action == "weapon_attack")
                           {
                              _loc5_ = {
                                 "type":BattleData.EFFECT_POISON,
                                 "duration":_loc10_.duration,
                                 "amount":_loc10_.amount
                              };
                              _loc1_.defenderDebuff.push(_loc5_);
                           }
                           break;
                        case BattleData.EFFECT_ATTACKER_DAMAGE_BONUS:
                           if(_loc1_.action == "weapon_attack")
                           {
                              _loc5_ = {
                                 "type":BattleData.EFFECT_DAMAGE_BONUS,
                                 "duration":2,
                                 "amount":_loc10_.amount
                              };
                              _loc1_.attackerBuff.push(_loc5_);
                           }
                     }
                     _loc8_++;
                  }
               }
            }
            if(this.defender.getBackItem())
            {
               _loc32_ = Central.main.BACK_ITEM_DATA.find(this.defender.getBackItem());
               if(_loc32_)
               {
                  for each(_loc31_ in _loc32_.effect)
                  {
                     switch(_loc31_.type)
                     {
                        case BattleData.EFFECT_ATTACKER_FREEZE:
                           if(NumberUtil.getRandom() <= _loc31_.chance / 100)
                           {
                              _loc5_ = {
                                 "type":BattleData.EFFECT_PET_FREEZE,
                                 "duration":_loc31_.duration,
                                 "amount":_loc31_.amount
                              };
                              _loc1_.attackerDebuff.push(_loc5_);
                              _loc1_.backitem_activated = true;
                           }
                           break;
                        case BattleData.EFFECT_PET_WEAKEN:
                           _loc1_.attackerDebuff.push(_loc5_);
                           break;
                        case BattleData.EFFECT_ATTACKER_STUN:
                           if(NumberUtil.getRandom() <= _loc31_.chance / 100)
                           {
                              _loc5_ = {
                                 "type":BattleData.EFFECT_STUN,
                                 "duration":_loc31_.duration,
                                 "amount":0
                              };
                              _loc1_.attackerDebuff.push(_loc5_);
                              _loc1_.backitem_activated = true;
                           }
                           break;
                        case BattleData.EFFECT_ABSORB_ATTACKER_HP_PRESENT:
                           if(NumberUtil.getRandom() <= _loc31_.chance / 100)
                           {
                              _loc38_ = Math.round(this.attacker.maxHP * (_loc31_.amount / 100));
                              _loc1_.defenderRestoreHp += _loc38_;
                              _loc1_.attackerDamageHp += _loc38_;
                           }
                           break;
                        case BattleData.EFFECT_RETALIATE:
                           if(NumberUtil.getRandom() <= _loc31_.chance / 100)
                           {
                              _loc38_ = Math.round(_loc1_.dmg * (_loc31_.amount / 100));
                              _loc1_.attackerDamageHp += _loc38_;
                           }
                           break;
                        case BattleData.EFFECT_ATTACK_BUNDLE:
                           if(NumberUtil.getRandom() <= _loc31_.chance / 100)
                           {
                              _loc5_ = {
                                 "type":BattleData.EFFECT_BUNDLE,
                                 "duration":_loc31_.duration
                              };
                              _loc1_.attackerDebuff.push(_loc5_);
                           }
                           break;
                        case BattleData.EFFECT_ATTACKER_BURNING:
                           if(NumberUtil.getRandom() <= _loc31_.chance / 100)
                           {
                              _loc5_ = {
                                 "type":BattleData.EFFECT_BURNING,
                                 "duration":_loc31_.duration,
                                 "amount":_loc31_.amount
                              };
                              _loc1_.attackerDebuff.push(_loc5_);
                              canburning = true;
                           }
                           break;
                        case BattleData.EFFECT_ATTACKER_POISON:
                           if(NumberUtil.getRandom() <= _loc31_.chance / 100)
                           {
                              _loc5_ = {
                                 "type":BattleData.EFFECT_POISON,
                                 "duration":_loc31_.duration,
                                 "amount":_loc31_.amount
                              };
                              _loc1_.attackerDebuff.push(_loc5_);
                           }
                           break;
                        case BattleData.EFFECT_ATTACKER_REDUCE_HP_PRESENT:
                           if(NumberUtil.getRandom() <= _loc31_.chance / 100)
                           {
                              _loc39_ = Math.round(this.attacker.maxHP * (_loc31_.amount / 100));
                              _loc1_.attackerDamageHp += _loc39_;
                           }
                        case BattleData.EFFECT_RECEIVED_CRITICAL_DAMAGE_ADD_HP:
                           if(_loc1_.critical)
                           {
                              _loc40_ = NumberUtil.getRandom();
                              if(_loc40_ <= _loc31_.chance / 100)
                              {
                                 Out.debug(null,"good what is a" + _loc40_);
                                 _loc1_.defenderRestoreHp += Math.round(this.defender.maxHP * (_loc31_.amount / 100));
                              }
                              else
                              {
                                 Out.debug(null,"bad what is a" + _loc40_);
                              }
                           }
                     }
                  }
               }
            }
            if(this.defender.getAccessory())
            {
               _loc34_ = Central.main.ACCESSORY_DATA.find(this.defender.getAccessory());
               if(_loc34_)
               {
                  for each(_loc31_ in _loc34_.effect)
                  {
                     switch(_loc31_.type)
                     {
                        case BattleData.EFFECT_ATTACKER_FREEZE:
                           if(NumberUtil.getRandom() <= _loc31_.chance / 100)
                           {
                              _loc5_ = {
                                 "type":BattleData.EFFECT_PET_FREEZE,
                                 "duration":_loc31_.duration,
                                 "amount":_loc31_.amount
                              };
                              _loc1_.attackerDebuff.push(_loc5_);
                           }
                           break;
                        case BattleData.EFFECT_ABSORB_ATTACKER_HP_PRESENT:
                           if(NumberUtil.getRandom() <= _loc31_.chance / 100)
                           {
                              _loc38_ = Math.round(this.attacker.maxHP * (_loc31_.amount / 100));
                              _loc1_.defenderRestoreHp += _loc38_;
                              _loc1_.attackerDamageHp += _loc38_;
                           }
                           break;
                        case BattleData.EFFECT_ATTACK_BUNDLE:
                           if(NumberUtil.getRandom() <= _loc31_.chance / 100)
                           {
                              _loc5_ = {
                                 "type":BattleData.EFFECT_BUNDLE,
                                 "duration":_loc31_.duration
                              };
                              _loc1_.attackerDebuff.push(_loc5_);
                           }
                     }
                  }
               }
            }
            if(this.defender.getGearset())
            {
               _loc9_ = this.defender.getGearset();
               for(_loc6_ in _loc9_)
               {
                  _loc11_ = Central.main.GEAR_SET_DATA.find(_loc6_);
                  _loc8_ = 0;
                  while(_loc8_ < _loc9_[_loc6_] - 1)
                  {
                     _loc10_ = _loc11_.effect[_loc8_];
                     switch(_loc10_.type)
                     {
                        case BattleData.EFFECT_ABSORB_ATTACKER_HP_PRESENT:
                           if(NumberUtil.getRandom() <= _loc10_.chance * 0.01)
                           {
                              _loc38_ = Math.round(this.attacker.maxHP * (_loc10_.amount * 0.01));
                              _loc1_.defenderRestoreHp += _loc38_;
                              _loc1_.attackerDamageHp += _loc38_;
                           }
                           break;
                        case BattleData.EFFECT_RECIEVE_DAMAGE_CP:
                           _loc1_.defenderRestoreCp += Math.round(Math.abs(_loc1_.dmg) * (_loc10_.amount / 100));
                     }
                     _loc8_++;
                  }
               }
            }
         }
         this.battleMemVariables = {};
         _loc15_ = this.attacker.getBattleDebuff();
         if(_loc15_)
         {
            _loc41_ = BattleProcessor.findEffectObjectInList(_loc15_,BattleData.EFFECT_THEFT_HP);
            if(_loc41_)
            {
               if(!checkIsSelfBuff(_loc1_))
               {
                  _loc42_ = Math.round(this.attacker.maxHP * (int(_loc41_.amount) / 100));
                  _loc1_.attackerDamageHp += _loc42_;
                  battleMemVariables.mem_theft_hp = _loc42_;
               }
            }
         }
         this.attacker.setBattleAction(_loc1_);
      }
      
      public function getBloodlineEffectArr(param1:Object) : Array
      {
         var _loc2_:Object = null;
         var _loc3_:Object = null;
         var _loc4_:Object = null;
         var _loc5_:Array = null;
         _loc2_ = {};
         _loc3_ = {};
         _loc4_ = {};
         _loc5_ = [];
         if(param1 == null)
         {
            return _loc5_;
         }
         if(Boolean(param1.effect_type_1) && param1.effect_type_1 != "")
         {
            _loc2_.type = param1.effect_type_1;
            _loc2_.duration = param1.duration_1;
            _loc2_.target = param1.effect_target_1;
            _loc2_.chancetohit = param1.effect_chancetohit_1;
            _loc2_.chancetoeffect = param1.effect_chancetoeffect_1;
            _loc2_.requirement = param1.effect_requirement_1;
            _loc2_.amount = param1.effect_amount_1;
            _loc2_.hit = false;
            _loc2_.resisted = param1.effect_resisted_1;
            _loc5_.push(_loc2_);
         }
         if(Boolean(param1.effect_type_2) && param1.effect_type_2 != "")
         {
            _loc3_.type = param1.effect_type_2;
            _loc3_.duration = param1.duration_2;
            _loc3_.target = param1.effect_target_2;
            _loc3_.chancetohit = param1.effect_chancetohit_2;
            _loc3_.chancetoeffect = param1.effect_chancetoeffect_2;
            _loc3_.requirement = param1.effect_requirement_2;
            _loc3_.amount = param1.effect_amount_2;
            _loc3_.hit = false;
            _loc3_.resisted = param1.effect_resisted_2;
            _loc5_.push(_loc3_);
         }
         if(Boolean(param1.effect_type_3) && param1.effect_type_3 != "")
         {
            _loc4_.type = param1.effect_type_3;
            _loc4_.duration = param1.duration_3;
            _loc4_.target = param1.effect_target_3;
            _loc4_.chancetohit = param1.effect_chancetohit_3;
            _loc4_.chancetoeffect = param1.effect_chancetoeffect_3;
            _loc4_.requirement = param1.effect_requirement_3;
            _loc4_.amount = param1.effect_amount_3;
            _loc4_.hit = false;
            _loc4_.resisted = param1.effect_resisted_3;
            _loc5_.push(_loc4_);
         }
         return _loc5_;
      }
      
      public function checkBloodlineEffect() : *
      {
         var _loc1_:Object = null;
         var _loc2_:* = undefined;
         var _loc3_:Object = null;
         var _loc4_:String = null;
         var _loc5_:Number = NaN;
         var _loc6_:int = 0;
         var _loc7_:Object = null;
         var _loc8_:String = null;
         var _loc9_:Array = null;
         var _loc10_:Boolean = false;
         _loc1_ = this.attacker.getBattleAction();
         _loc7_ = _loc1_.effect;
         _loc8_ = "";
         if(_loc1_.BLSKILLID)
         {
            _loc8_ = _loc1_.BLSKILLID;
         }
         _loc9_ = getBloodlineEffectArr(_loc7_);
         _loc5_ = NumberUtil.getRandom();
         _loc10_ = true;
         _loc6_ = 0;
         while(_loc6_ < _loc9_.length)
         {
            if(_loc9_[_loc6_].target != 0 && _loc9_[_loc6_].target != 3 && _loc9_[_loc6_].target != 4 && _loc9_[_loc6_].target != 6)
            {
               _loc10_ = false;
            }
            _loc6_++;
         }
         if(_loc10_)
         {
            _loc1_.dodge = false;
         }
         else
         {
            this.checkClone(_loc1_);
         }
         _loc1_.bl_attackerRestoreHp = 0;
         _loc1_.bl_attackerRestoreCp = 0;
         _loc1_.bl_attackerDamageHp = 0;
         _loc1_.bl_attackerDamageCp = 0;
         _loc1_.bl_defenderRestoreHp = 0;
         _loc1_.bl_defenderRestoreCp = 0;
         _loc1_.bl_defenderDamageHp = 0;
         _loc1_.bl_defenderDamageCp = 0;
         _loc6_ = 0;
         while(_loc6_ < _loc9_.length)
         {
            if(_loc5_ <= _loc9_[_loc6_].chancetohit / 100)
            {
               if(!_loc1_.dodge || _loc10_)
               {
                  if(_loc9_[_loc6_].duration == 0)
                  {
                     SetBloodlineInstantEffect(_loc9_[_loc6_],_loc8_,_loc1_);
                     _loc9_[_loc6_].hit = true;
                  }
                  else
                  {
                     SetBloodlineBuffOrDebuffEffect(_loc9_[_loc6_],_loc8_);
                     _loc9_[_loc6_].hit = true;
                  }
               }
            }
            _loc1_.effect["effect_hit_" + [_loc6_ + 1]] = _loc9_[_loc6_].hit;
            _loc6_++;
         }
      }
      
      public function getSenjutsuEffectArr(param1:Object) : Array
      {
         var _loc2_:Object = null;
         var _loc3_:Object = null;
         var _loc4_:Object = null;
         var _loc5_:Array = null;
         _loc2_ = {};
         _loc3_ = {};
         _loc4_ = {};
         _loc5_ = [];
         if(param1 == null)
         {
            return _loc5_;
         }
         if(Boolean(param1.effect_type_1) && param1.effect_type_1 != "")
         {
            _loc2_.type = param1.effect_type_1;
            _loc2_.duration = param1.duration_1;
            _loc2_.target = param1.effect_target_1;
            _loc2_.chancetohit = param1.effect_chancetohit_1;
            _loc2_.chancetoeffect = param1.effect_chancetoeffect_1;
            _loc2_.requirement = param1.effect_requirement_1;
            _loc2_.amount = param1.effect_amount_1;
            _loc2_.hit = false;
            _loc2_.resisted = param1.effect_resisted_1;
            _loc5_.push(_loc2_);
         }
         if(Boolean(param1.effect_type_2) && param1.effect_type_2 != "")
         {
            _loc3_.type = param1.effect_type_2;
            _loc3_.duration = param1.duration_2;
            _loc3_.target = param1.effect_target_2;
            _loc3_.chancetohit = param1.effect_chancetohit_2;
            _loc3_.chancetoeffect = param1.effect_chancetoeffect_2;
            _loc3_.requirement = param1.effect_requirement_2;
            _loc3_.amount = param1.effect_amount_2;
            _loc3_.hit = false;
            _loc3_.resisted = param1.effect_resisted_2;
            _loc5_.push(_loc3_);
         }
         if(Boolean(param1.effect_type_3) && param1.effect_type_3 != "")
         {
            _loc4_.type = param1.effect_type_3;
            _loc4_.duration = param1.duration_3;
            _loc4_.target = param1.effect_target_3;
            _loc4_.chancetohit = param1.effect_chancetohit_3;
            _loc4_.chancetoeffect = param1.effect_chancetoeffect_3;
            _loc4_.requirement = param1.effect_requirement_3;
            _loc4_.amount = param1.effect_amount_3;
            _loc4_.hit = false;
            _loc4_.resisted = param1.effect_resisted_3;
            _loc5_.push(_loc4_);
         }
         return _loc5_;
      }
      
      public function checkSenjutsuEffect() : *
      {
         var _loc1_:Object = null;
         var _loc2_:* = undefined;
         var _loc3_:Object = null;
         var _loc4_:String = null;
         var _loc5_:Number = NaN;
         var _loc6_:int = 0;
         var _loc7_:Object = null;
         var _loc8_:String = null;
         var _loc9_:Array = null;
         var _loc10_:Boolean = false;
         _loc1_ = this.attacker.getBattleAction();
         _loc7_ = _loc1_.effect;
         _loc8_ = "";
         if(_loc1_.SENSKILLID)
         {
            _loc8_ = _loc1_.SENSKILLID;
         }
         _loc9_ = getSenjutsuEffectArr(_loc7_);
         _loc5_ = NumberUtil.getRandom();
         _loc10_ = true;
         _loc6_ = 0;
         while(_loc6_ < _loc9_.length)
         {
            if(_loc9_[_loc6_].target != 0 && _loc9_[_loc6_].target != 3 && _loc9_[_loc6_].target != 4 && _loc9_[_loc6_].target != 6)
            {
               _loc10_ = false;
            }
            _loc6_++;
         }
         if(_loc10_)
         {
            _loc1_.dodge = false;
         }
         else
         {
            this.checkClone(_loc1_);
         }
         _loc1_.sen_attackerRestoreHp = 0;
         _loc1_.sen_attackerRestoreCp = 0;
         _loc1_.sen_attackerDamageHp = 0;
         _loc1_.sen_attackerDamageCp = 0;
         _loc1_.sen_defenderRestoreHp = 0;
         _loc1_.sen_defenderRestoreCp = 0;
         _loc1_.sen_defenderDamageHp = 0;
         _loc1_.sen_defenderDamageCp = 0;
         _loc1_.sen_attackerRestoreSp = 0;
         _loc1_.sen_defenderRestoreSp = 0;
         _loc1_.sen_attackerDamageSp = 0;
         _loc1_.sen_defenderDamageSp = 0;
         _loc6_ = 0;
         while(_loc6_ < _loc9_.length)
         {
            Out.debug("","senjutsu type = " + _loc9_[_loc6_].type);
            if(_loc5_ <= _loc9_[_loc6_].chancetohit / 100)
            {
               if(!_loc1_.dodge || _loc10_)
               {
                  if(_loc9_[_loc6_].duration == 0)
                  {
                     SetSenjutsuInstantEffect(_loc9_[_loc6_],_loc8_,_loc1_);
                     _loc9_[_loc6_].hit = true;
                  }
                  else
                  {
                     SetSenjutsuBuffOrDebuffEffect(_loc9_[_loc6_],_loc8_);
                     _loc9_[_loc6_].hit = true;
                  }
               }
               else
               {
                  Out.debug("rex","senjutsu be dodge");
               }
            }
            _loc1_.effect["effect_hit_" + [_loc6_ + 1]] = _loc9_[_loc6_].hit;
            _loc6_++;
         }
      }
      
      private function healTarget() : void
      {
         var _loc1_:Object = null;
         var _loc2_:int = 0;
         var _loc3_:Number = NaN;
         var _loc4_:int = 0;
         var _loc5_:Object = null;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         _loc1_ = this.attacker.getBattleAction();
         if(_loc1_.effect)
         {
            trace(_loc1_.effect.type);
            switch(_loc1_.effect.type)
            {
               case BattleData.EFFECT_BLOOD_DRINKER_N_RESTORE_HP:
               case BattleData.EFFECT_BLOOD_DRINKER_N_RESTORE_HP_BUNDLE:
                  _loc1_.healTarget = [];
                  _loc4_ = int(_loc1_.effect.amount) * 29;
                  _loc4_ = this.updateHP(this.attacker,_loc4_);
                  _loc5_ = {
                     "target":this.attacker,
                     "heal":_loc4_
                  };
                  _loc1_.healTarget.push(_loc5_);
                  this.attacker.setBattleAction(_loc1_);
                  return;
               case BattleData.SKILL_2000:
                  _loc7_ = this.attacker.getLevel() - 60;
                  if(_loc7_ < 0)
                  {
                     _loc7_ = 0;
                  }
                  _loc4_ = Math.round(1000 + _loc7_ * 70);
                  _loc1_.healTarget = [];
                  _loc6_ = 0;
                  while(_loc6_ < this.characterArr.length)
                  {
                     if(this.characterArr[_loc6_].side == this.attacker.side)
                     {
                        _loc4_ = this.updateHP(this.characterArr[_loc6_],_loc4_);
                        _loc5_ = {
                           "target":this.characterArr[_loc6_],
                           "heal":_loc4_
                        };
                        _loc1_.healTarget.push(_loc5_);
                     }
                     _loc6_++;
                  }
                  this.attacker.setBattleAction(_loc1_);
                  return;
               case BattleData.EFFECT_ADD_ALL_HP_CP:
                  _loc1_.healTarget = [];
                  _loc6_ = 0;
                  while(_loc6_ < this.characterArr.length)
                  {
                     if(this.characterArr[_loc6_].side == this.attacker.side)
                     {
                        _loc4_ = Math.round(this.characterArr[_loc6_].maxHP * _loc1_.effect.amount * 0.01);
                        _loc4_ = this.updateHP(this.characterArr[_loc6_],_loc4_);
                        _loc5_ = {
                           "target":this.characterArr[_loc6_],
                           "heal":_loc4_
                        };
                        _loc1_.healTarget.push(_loc5_);
                     }
                     _loc6_++;
                  }
                  this.attacker.setBattleAction(_loc1_);
                  return;
               case BattleData.EFFECT_ADD_ALL_HP_CP_CLEAR_DEBUFF:
                  _loc1_.healTarget = [];
                  _loc6_ = 0;
                  while(_loc6_ < this.characterArr.length)
                  {
                     if(this.characterArr[_loc6_].side == this.attacker.side)
                     {
                        _loc4_ = Math.round(this.characterArr[_loc6_].maxHP * _loc1_.effect.amount * 0.01);
                        _loc4_ = this.updateHP(this.characterArr[_loc6_],_loc4_);
                        _loc5_ = {
                           "target":this.characterArr[_loc6_],
                           "heal":_loc4_
                        };
                        _loc1_.healTarget.push(_loc5_);
                     }
                     _loc6_++;
                  }
                  this.attacker.setBattleAction(_loc1_);
                  return;
            }
         }
         if(_loc1_.heal == null)
         {
            return;
         }
         _loc2_ = int(_loc1_.heal);
         _loc3_ = Number(int(this.attacker.getData(DBCharacterData.WATER)) * 1 / 100);
         _loc2_ = Math.round(_loc2_ * (1 + _loc3_));
         if(_loc1_.critical == true)
         {
            _loc2_ = Math.round(_loc2_ * this.attacker.criticalBonus);
         }
         if(this.attacker.side != this.defender.side)
         {
            this.defender = this.attacker;
            _loc1_.target = "self";
         }
         _loc2_ = this.updateHP(this.defender,_loc2_);
         _loc1_.heal = _loc2_;
         this.attacker.setBattleAction(_loc1_);
      }
      
      private function damageTarget() : void
      {
         var _loc1_:Object = null;
         var _loc2_:int = 0;
         var _loc3_:Array = null;
         var _loc4_:Array = null;
         var _loc5_:int = 0;
         _loc1_ = this.attacker.getBattleAction();
         _loc3_ = [defender];
         Out.debug(this,"damageTarget :: targetArr.length >> " + _loc3_.length);
         if(_loc1_.target)
         {
            if(_loc1_.target == "all")
            {
               _loc3_ = [];
               _loc2_ = 0;
               while(_loc2_ < this.characterArr.length)
               {
                  if(this.characterArr[_loc2_].side != this.attacker.side && this.characterArr[_loc2_].isDead == false)
                  {
                     _loc3_.push(this.characterArr[_loc2_]);
                  }
                  _loc2_++;
               }
            }
            if(_loc1_.target == "all_friendly")
            {
               _loc3_ = [];
               _loc2_ = 0;
               while(_loc2_ < this.characterArr.length)
               {
                  if(this.characterArr[_loc2_].side == this.attacker.side && this.characterArr[_loc2_].isDead == false)
                  {
                     _loc3_.push(this.characterArr[_loc2_]);
                  }
                  _loc2_++;
               }
            }
            if(_loc1_.target == "allEnemy")
            {
               _loc3_ = [];
               _loc2_ = 0;
               while(_loc2_ < this.characterArr.length)
               {
                  if(this.characterArr[_loc2_].side != this.attacker.side && this.characterArr[_loc2_].isDead == false)
                  {
                     _loc3_.push(this.characterArr[_loc2_]);
                  }
                  _loc2_++;
               }
            }
            if(_loc1_.target == "map")
            {
               _loc3_ = this.characterArr;
            }
            if(_loc1_.target == "friendly")
            {
               _loc3_ = [];
               _loc2_ = 0;
               while(_loc2_ < this.characterArr.length)
               {
                  if(this.characterArr[_loc2_].side == this.attacker.side)
                  {
                     _loc3_.push(this.characterArr[_loc2_]);
                  }
                  _loc2_++;
               }
            }
         }
         _loc2_ = 0;
         while(_loc2_ < _loc3_.length)
         {
            this.processDamage(_loc3_[_loc2_]);
            _loc2_++;
         }
         _loc4_ = _loc1_.dmgArr;
         if(_loc4_)
         {
            _loc2_ = 0;
            while(_loc2_ < _loc4_.length)
            {
               if(_loc4_[_loc2_].characterId == this.defender.getCharacterId())
               {
                  if(_loc4_[_loc2_].dmg != null)
                  {
                     _loc1_.dmg = _loc4_[_loc2_].dmg;
                  }
                  break;
               }
               _loc2_++;
            }
         }
         if(attackerplayer == true)
         {
            _loc5_ = 0;
            if(_loc1_.dmg != undefined)
            {
               _loc5_ = int(_loc1_.dmg);
            }
            if(Central.main.battleFlowLog.battles[Central.main.battleround].step_log.length < 100)
            {
               Central.main.battleFlowLog.battles[Central.main.battleround].step_log.push({
                  "action":battleandaction,
                  "dmg":_loc5_
               });
            }
            trace("this.defender.getCharacterId()" + this.defender.getCharacterId());
            Central.main.battleFlowLog.battles[Central.main.battleround].step = thisbattleround;
         }
         this.attacker.setBattleAction(_loc1_);
      }
      
      private function processDamage(param1:*) : void
      {
         var _loc2_:Object = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:String = null;
         var _loc6_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:Number = NaN;
         var _loc10_:String = null;
         var _loc11_:int = 0;
         var _loc12_:Object = null;
         var _loc13_:Object = null;
         var _loc14_:int = 0;
         var _loc15_:int = 0;
         var _loc16_:int = 0;
         var _loc17_:Number = NaN;
         var _loc18_:int = 0;
         var _loc19_:int = 0;
         var _loc20_:int = 0;
         var _loc21_:Object = null;
         var _loc25_:int = 0;
         var _loc26_:Array = null;
         var _loc27_:Object = null;
         var _loc28_:Object = null;
         var _loc29_:Object = null;
         var _loc30_:int = 0;
         var _loc31_:int = 0;
         var _loc32_:Object = null;
         var _loc33_:int = 0;
         var _loc34_:Object = null;
         var _loc35_:* = undefined;
         var _loc36_:Object = null;
         var _loc37_:Object = null;
         var _loc38_:Object = null;
         var _loc39_:Object = null;
         var _loc40_:Object = null;
         var _loc41_:int = 0;
         var _loc42_:int = 0;
         var _loc43_:int = 0;
         var _loc44_:* = undefined;
         var _loc45_:Object = null;
         var _loc46_:int = 0;
         var _loc47_:int = 0;
         var _loc48_:int = 0;
         var _loc49_:Object = null;
         var _loc50_:String = null;
         var _loc51_:* = undefined;
         var _loc52_:Number = NaN;
         var _loc53_:Object = null;
         var _loc54_:Object = null;
         var _loc55_:Object = null;
         var _loc56_:Object = null;
         var _loc57_:Object = null;
         var _loc58_:Object = null;
         var _loc59_:Object = null;
         var _loc60_:String = null;
         var _loc61_:Object = null;
         var _loc62_:int = 0;
         var _loc63_:Object = null;
         var _loc64_:Number = NaN;
         var _loc65_:Number = NaN;
         var _loc66_:Number = NaN;
         var _loc67_:Number = NaN;
         var _loc68_:Object = null;
         var _loc69_:uint = 0;
         var _loc70_:uint = 0;
         var _loc71_:int = 0;
         var _loc72_:int = 0;
         var _loc73_:int = 0;
         var _loc74_:int = 0;
         var _loc75_:* = undefined;
         var _loc76_:int = 0;
         var _loc77_:int = 0;
         var _loc78_:int = 0;
         Out.debug(this,"processDamage :: target >> " + param1.getCharacterName());
         Out.debug(this,"processDamage :: attacker maxcp >> " + this.attacker.maxCP);
         Out.debug(this,"processDamage :: attacker cp >> " + this.attacker.cp);
         Out.debug(this,"processDamage :: attacker maxhp >> " + this.attacker.maxHP);
         Out.debug(this,"processDamage :: attacker hp >> " + this.attacker.hp);
         Out.debug(this,"processDamage :: defender.type >> " + this.defender.type);
         Out.debug(this,"processDamage :: attacker.type >> " + this.attacker.type);
         _loc2_ = this.attacker.getBattleAction();
         Out.debug(this,"processDamage :: battleAction.dmg >> " + _loc2_.dmg);
         Central.main.petExtraDmg = false;
         Central.main.petExtraDmgAmount = 0;
         if(this.attacker.type == this.attacker.TYPE_CHARACTER || this.attacker.type == this.attacker.TYPE_PET)
         {
            if(!this.HpCondition || !this.CpCondition)
            {
               _loc2_.dmg = 0;
            }
         }
         this.HpCondition = true;
         this.CpCondition = true;
         var _loc7_:Boolean = false;
         _loc8_ = 0 - _loc2_.dmg;
         _loc17_ = 0;
         _loc18_ = 0;
         var _loc22_:int = 3;
         var _loc23_:int = 0;
         var _loc24_:int = 0;
         _loc25_ = 0;
         _loc29_ = {};
         _loc29_.characterType = param1.type;
         _loc29_.characterId = param1.getCharacterId();
         _loc29_.defenderRestoreHp = 0;
         _loc29_.defenderRestoreCp = 0;
         _loc29_.defenderDamageHp = 0;
         _loc29_.defenderDamageCp = 0;
         if(_loc2_.clones != null)
         {
            if(_loc2_.clones[param1.getCharacterId()])
            {
               _loc29_.dmg = 0;
               switch(_loc2_.clones[param1.getCharacterId()].effectName)
               {
                  case BattleData.TYPE_DUMMY_BURN:
                     _loc12_ = {
                        "type":BattleData.EFFECT_BURNING,
                        "duration":3,
                        "amount":5
                     };
                     _loc2_.attackerDebuff.push(_loc12_);
                     canburning = true;
                     break;
                  case BattleData.TYPE_DUMMY_STUN:
                     _loc12_ = {
                        "type":BattleData.EFFECT_STUN,
                        "duration":2
                     };
                     _loc2_.attackerDebuff.push(_loc12_);
               }
               _loc2_.dmgArr.push(_loc29_);
               this.attacker.setBattleAction(_loc2_);
               return;
            }
         }
         if(!Central.battle.seal_enemy)
         {
            if(_loc2_.dodge == true)
            {
               Out.debug(this,"seal enemy was dogde");
               _loc2_.dmgArr.push(_loc29_);
               this.attacker.setBattleAction(_loc2_);
               return;
            }
         }
         else
         {
            Out.debug(this,"seal enemy can\'t dogde");
         }
         if(_loc2_.effect)
         {
            Out.debug(this,"battleAction.effect.type >> " + _loc2_.effect.type);
            switch(_loc2_.effect.type)
            {
               case BattleData.EFFECT_JUTSU_POISON:
               case BattleData.EFFECT_DOUBLE_BURN:
               case BattleData.EFFECT_BURN:
               case BattleData.EFFECT_BURNING:
               case BattleData.EFFECT_PET_BURN:
               case BattleData.EFFECT_BURN_FIX_NUM:
               case BattleData.EFFECT_DEFENDER_BURNING:
                  if(param1.getBackItem())
                  {
                     _loc56_ = Central.main.BACK_ITEM_DATA.find(param1.getBackItem());
                     if(_loc56_)
                     {
                        for each(_loc28_ in _loc56_.effect)
                        {
                           switch(_loc28_.type)
                           {
                              case BattleData.EFFECT_BURN_PROTECTION:
                                 if(NumberUtil.getRandom() <= _loc28_.chance / 100)
                                 {
                                    _loc2_.effect = null;
                                 }
                           }
                        }
                     }
                  }
                  if(param1.isBattleBuffActive(BattleData.EFFECT_BURN_PROTECTION))
                  {
                     _loc2_.effect = null;
                  }
                  if(param1.getAccessory())
                  {
                     _loc27_ = Central.main.ACCESSORY_DATA.find(param1.getAccessory());
                     if(_loc27_)
                     {
                        _loc28_ = null;
                        for each(_loc28_ in _loc27_.effect)
                        {
                           switch(_loc28_.type)
                           {
                              case BattleData.EFFECT_BURN_PROTECTION:
                                 if(NumberUtil.getRandom() <= _loc28_.chance / 100)
                                 {
                                    _loc2_.effect = null;
                                 }
                           }
                        }
                     }
                  }
                  break;
               case BattleData.EFFECT_INTERNAL_INJURY:
                  if(param1.getBackItem())
                  {
                     _loc56_ = Central.main.BACK_ITEM_DATA.find(param1.getBackItem());
                     if(_loc56_)
                     {
                        for each(_loc28_ in _loc56_.effect)
                        {
                           switch(_loc28_.type)
                           {
                              case BattleData.EFFECT_INTERNAL_INJURY_PROTECTION:
                                 if(NumberUtil.getRandom() <= _loc28_.chance / 100)
                                 {
                                    _loc2_.effect = null;
                                 }
                           }
                        }
                     }
                  }
                  break;
               case BattleData.EFFECT_BLEEDING:
               case BattleData.EFFECT_BLEEDING_FIX_NUM:
                  if(param1.getAccessory())
                  {
                     _loc27_ = Central.main.ACCESSORY_DATA.find(param1.getAccessory());
                     if(_loc27_)
                     {
                        _loc28_ = null;
                        for each(_loc28_ in _loc27_.effect)
                        {
                           switch(_loc28_.type)
                           {
                              case BattleData.EFFECT_BLEEDING_PROTECTION:
                                 if(NumberUtil.getRandom() <= _loc28_.chance / 100)
                                 {
                                    _loc2_.effect = null;
                                 }
                           }
                        }
                     }
                  }
                  if(param1.isBattleBuffActive(BattleData.EFFECT_BURN_HP_CP_FIX_NUM_N_IMMUNITY_BLEEDING))
                  {
                     _loc2_.effect = null;
                  }
            }
         }
         if(_loc2_.effect)
         {
            _loc12_ = _loc2_.effect;
            switch(_loc12_.type)
            {
               case BattleData.EFFECT_CLEAR_BUFF_NEGATE_BURNORSTUN:
                  Out.debug(this,"real use ar ");
                  param1.clearBuff();
                  _loc21_ = {
                     "type":BattleData.EFFECT_BUFF_NEGATE,
                     "duration":_loc12_.duration,
                     "amount":_loc12_.amount
                  };
                  param1.setBattleDebuff(_loc21_);
                  if(param1.hp / param1.maxHP > 0.5)
                  {
                     _loc34_ = {
                        "type":BattleData.EFFECT_PET_BURN,
                        "duration":_loc12_.duration,
                        "amount":_loc12_.amount
                     };
                     param1.setBattleDebuff(_loc34_);
                     canpetburn = true;
                  }
                  else if(param1.hp / param1.maxHP <= 0.5)
                  {
                     _loc34_ = {
                        "type":BattleData.EFFECT_STUN,
                        "duration":_loc2_.effect.duration
                     };
                     param1.setBattleDebuff(_loc34_);
                  }
                  break;
               case BattleData.EFFECT_CLEAR_BUFF_NEGATE:
                  param1.clearBuff();
                  _loc21_ = {
                     "type":BattleData.EFFECT_BUFF_NEGATE,
                     "duration":_loc12_.duration,
                     "amount":_loc12_.amount
                  };
                  param1.setBattleDebuff(_loc21_);
                  break;
               case BattleData.EFFECT_STUN:
                  if(_loc2_.stun == true)
                  {
                     _loc2_.effect = this.setDebuff(param1,_loc12_);
                  }
                  break;
               case BattleData.EFFECT_BLOOD_DRINKER:
               case BattleData.EFFECT_DISMANTLE:
               case BattleData.EFFECT_PET_FEAR_WEAKEN:
                  _loc2_.effect = this.setDebuff(param1,_loc12_);
                  break;
               case BattleData.EFFECT_BLEEDING:
               case BattleData.EFFECT_BLEEDING_FIX_NUM:
                  if(!param1.isBattleBuffActive(BattleData.EFFECT_BURN_HP_CP_FIX_NUM_N_IMMUNITY_BLEEDING))
                  {
                     _loc2_.effect = this.setDebuff(param1,_loc12_);
                  }
                  break;
               case BattleData.EFFECT_BURN_HP_N_INTERNAL_INJURY:
                  _loc29_.defenderDamageHp = Math.round(param1.maxHP * _loc2_.effect.amount * 0.01);
                  _loc29_.defenderDamageHp = this.updateHP(param1,0 - _loc29_.defenderDamageHp);
                  _loc21_ = {
                     "type":BattleData.EFFECT_INTERNAL_INJURY,
                     "duration":_loc12_.duration,
                     "amount":0
                  };
                  param1.setBattleDebuff(_loc21_);
                  break;
               case BattleData.EFFECT_BURN_HP_CP_FIX_NUM_N_IMMUNITY_BLEEDING:
                  _loc29_.defenderDamageHp = int(_loc12_.amount);
                  _loc29_.defenderDamageCp = int(_loc12_.amount);
                  _loc29_.defenderDamageHp = this.updateHP(param1,0 - _loc29_.defenderDamageHp);
                  _loc29_.defenderDamageCp = this.updateCP(param1,0 - _loc29_.defenderDamageCp);
                  _loc21_ = {
                     "type":BattleData.EFFECT_BURN_HP_CP_FIX_NUM_N_IMMUNITY_BLEEDING,
                     "duration":_loc12_.duration,
                     "amount":0
                  };
                  this.attacker.setBattleBuff(_loc21_);
                  break;
               case BattleData.EFFECT_BURN_HP_FIX_NUM:
                  _loc29_.defenderDamageHp = Math.round(_loc2_.effect.amount);
                  _loc29_.defenderDamageHp = this.updateHP(param1,0 - _loc29_.defenderDamageHp);
                  break;
               case BattleData.EFFECT_BURN_HP:
                  _loc29_.defenderDamageHp = Math.round(param1.maxHP * _loc2_.effect.amount * 0.01);
                  _loc29_.defenderDamageHp = this.updateHP(param1,0 - _loc29_.defenderDamageHp);
                  break;
               case BattleData.EFFECT_DOUBLE_BURN:
                  _loc29_.defenderDamageHp = Math.round(param1.maxHP * _loc2_.effect.amount * 0.01);
                  _loc29_.defenderDamageHp = this.updateHP(param1,0 - _loc29_.defenderDamageHp);
                  candoburn = true;
                  _loc2_.effect = this.setDebuff(param1,_loc12_);
                  break;
               case BattleData.EFFECT_BURN_CNNT_PURIFY:
                  cancntpurlfyburn = true;
                  _loc2_.effect = this.setDebuff(param1,_loc12_);
                  break;
               case BattleData.EFFECT_BURN:
                  canburn = true;
                  _loc2_.effect = this.setDebuff(param1,_loc12_);
                  break;
               case BattleData.EFFECT_BURN_FIX_NUM:
                  canburnnum = true;
                  _loc2_.effect = this.setDebuff(param1,_loc12_);
                  break;
               case BattleData.EFFECT_DAMAGE_HP_FIX_NUM:
                  _loc2_.effect = this.setDebuff(param1,_loc12_);
                  break;
               case BattleData.EFFECT_PET_FREEZE:
                  _loc9_ = NumberUtil.getRandom();
                  if(_loc9_ <= _loc2_.effect.amount / 100)
                  {
                     _loc2_.effect.activated = true;
                     _loc2_.effect = this.setDebuff(param1,_loc12_);
                  }
                  else if(_loc9_ <= _loc2_.effect.chance / 100)
                  {
                     _loc2_.effect.activated = true;
                     _loc2_.effect = this.setDebuff(param1,_loc12_);
                  }
                  else
                  {
                     _loc2_.effect.activated = false;
                  }
                  break;
               case BattleData.EFFECT_BLEED_N_BURN_HP:
                  _loc29_.defenderDamageHp = Math.round(param1.maxHP * _loc2_.effect.amount / 4 * 0.01);
                  _loc29_.defenderDamageHp = this.updateHP(param1,0 - _loc29_.defenderDamageHp);
                  if(!param1.isBattleBuffActive(BattleData.EFFECT_BURN_HP_CP_FIX_NUM_N_IMMUNITY_BLEEDING))
                  {
                     _loc34_ = {
                        "type":BattleData.EFFECT_BLEEDING,
                        "duration":_loc12_.duration,
                        "amount":_loc12_.amount
                     };
                     param1.setBattleDebuff(_loc34_);
                  }
                  break;
               case BattleData.SKILL_369:
                  _loc29_.defenderDamageHp = Math.round(param1.maxHP * _loc2_.effect.amount * 0.01);
                  _loc29_.defenderDamageHp = this.updateHP(param1,0 - _loc29_.defenderDamageHp);
                  break;
               case BattleData.EFFECT_PROFUSION_OF_GHOSTS:
                  _loc29_.defenderDamageCp = Math.round(param1.maxCP * int(_loc2_.effect.amount) * 0.01);
                  param1.addAllSkillCooldown(_loc2_.effect.duration);
                  _loc29_.defenderDamageCp = this.updateCP(param1,0 - _loc29_.defenderDamageCp);
                  break;
               case BattleData.EFFECT_PET_FREEZE_INTERNAL_INJURY:
                  _loc9_ = NumberUtil.getRandom();
                  if(_loc9_ <= _loc2_.effect.amount / 100)
                  {
                     _loc2_.effect.activated = true;
                     _loc34_ = {
                        "type":BattleData.EFFECT_PET_FREEZE,
                        "duration":_loc12_.duration,
                        "amount":_loc12_.amount
                     };
                     param1.setBattleDebuff(_loc34_);
                     freezeskill = true;
                     _loc34_ = {
                        "type":BattleData.EFFECT_INTERNAL_INJURY,
                        "duration":_loc12_.duration,
                        "amount":0
                     };
                     param1.setBattleDebuff(_loc34_);
                  }
                  else if(_loc9_ <= _loc2_.effect.chance / 100)
                  {
                     _loc2_.effect.activated = true;
                     _loc34_ = {
                        "type":BattleData.EFFECT_PET_FREEZE,
                        "duration":_loc12_.duration,
                        "amount":_loc12_.amount
                     };
                     param1.setBattleDebuff(_loc34_);
                     freezeskill = true;
                     _loc34_ = {
                        "type":BattleData.EFFECT_INTERNAL_INJURY,
                        "duration":_loc12_.duration,
                        "amount":0
                     };
                     param1.setBattleDebuff(_loc34_);
                  }
                  else
                  {
                     _loc2_.effect.activated = false;
                  }
                  break;
               case BattleData.EFFECT_RANDOM_REDUCE_AGI_STUN:
                  _loc9_ = NumberUtil.getRandom();
                  if(_loc9_ <= _loc2_.effect.amount / 100)
                  {
                     _loc2_.effect.activated = true;
                     _loc34_ = {
                        "type":BattleData.EFFECT_REDUCE_AGILITY,
                        "duration":_loc12_.duration,
                        "amount":_loc12_.amount / 2
                     };
                     param1.setBattleDebuff(_loc34_);
                     _loc34_ = {
                        "type":BattleData.EFFECT_STUN,
                        "duration":_loc12_.duration,
                        "amount":_loc12_.amount
                     };
                     param1.setBattleDebuff(_loc34_);
                  }
                  else
                  {
                     _loc2_.effect.activated = false;
                  }
                  break;
               case BattleData.EFFECT_DAMAGE_REDUCE_N_ACCURATE:
                  _loc34_ = {
                     "type":BattleData.EFFECT_DAMAGE_REDUCTION,
                     "duration":_loc12_.duration,
                     "amount":_loc12_.amount
                  };
                  _loc2_.attackerBuff.push(_loc34_);
                  _loc34_ = {
                     "type":BattleData.EFFECT_ACCURATE,
                     "duration":_loc12_.duration,
                     "amount":_loc12_.amount * 2.5
                  };
                  _loc2_.attackerBuff.push(_loc34_);
                  break;
               case BattleData.EFFECT_DAMAGE_REDUCE_N_ACCURATE:
                  _loc34_ = {
                     "type":BattleData.EFFECT_DAMAGE_REDUCTION,
                     "duration":_loc12_.duration,
                     "amount":_loc12_.amount
                  };
                  _loc2_.attackerBuff.push(_loc34_);
                  _loc34_ = {
                     "type":BattleData.EFFECT_ACCURATE,
                     "duration":_loc12_.duration,
                     "amount":_loc12_.amount * 2.5
                  };
                  _loc2_.attackerBuff.push(_loc34_);
                  break;
               case BattleData.EFFECT_VIGOR:
                  param1.setBattleBuff(_loc12_);
                  break;
               case BattleData.EFFECT_MODIFY_COOLDOWN_BLIND:
                  _loc34_ = {
                     "type":BattleData.EFFECT_BLIND,
                     "duration":_loc12_.duration,
                     "amount":_loc12_.amount
                  };
                  param1.setBattleDebuff(_loc34_);
                  break;
               case BattleData.EFFECT_MODIFY_COOLDOWN_BLIND_A:
                  _loc34_ = {
                     "type":BattleData.EFFECT_BLIND,
                     "duration":_loc12_.duration,
                     "amount":_loc12_.amount
                  };
                  param1.setBattleDebuff(_loc34_);
                  break;
               case BattleData.EFFECT_BLIND_N_POISON:
                  _loc34_ = {
                     "type":BattleData.EFFECT_BLIND,
                     "duration":_loc12_.duration,
                     "amount":_loc12_.amount
                  };
                  param1.setBattleDebuff(_loc34_);
                  _loc34_ = {
                     "type":BattleData.EFFECT_POISON,
                     "duration":_loc12_.duration,
                     "amount":_loc12_.amount / 10
                  };
                  param1.setBattleDebuff(_loc34_);
                  break;
               case BattleData.EFFECT_BLIND_N_BLEEDING:
                  _loc34_ = {
                     "type":BattleData.EFFECT_BLIND,
                     "duration":_loc12_.duration,
                     "amount":_loc12_.amount
                  };
                  param1.setBattleDebuff(_loc34_);
                  if(!param1.isBattleBuffActive(BattleData.EFFECT_BURN_HP_CP_FIX_NUM_N_IMMUNITY_BLEEDING))
                  {
                     _loc34_ = {
                        "type":BattleData.EFFECT_BLEEDING,
                        "duration":_loc2_.effect.duration,
                        "amount":_loc2_.effect.amount
                     };
                     param1.setBattleDebuff(_loc34_);
                  }
                  break;
               case BattleData.EFFECT_DRAIN_CP_N_CHARGE_DISABLE:
                  _loc2_.effect.damageCp = Math.abs(this.updateCP(param1,0 - Math.round(param1.cp * int(_loc12_.amount) * 0.01)));
                  _loc2_.effect.damageCp = this.updateCP(this.attacker,_loc2_.effect.damageCp);
                  _loc34_ = {
                     "type":BattleData.EFFECT_MERIDIANS_SEAL,
                     "duration":_loc12_.duration,
                     "amount":_loc12_.amount / 10
                  };
                  param1.setBattleDebuff(_loc34_);
                  break;
               case BattleData.EFFECT_BUNDLE_BLIND:
                  _loc34_ = {
                     "type":BattleData.EFFECT_BUNDLE,
                     "duration":_loc12_.duration,
                     "amount":_loc12_.amount
                  };
                  param1.setBattleDebuff(_loc34_);
                  _loc34_ = {
                     "type":BattleData.EFFECT_BLIND,
                     "duration":_loc12_.duration,
                     "amount":_loc12_.amount
                  };
                  param1.setBattleDebuff(_loc34_);
                  break;
               case BattleData.EFFECT_CHARGE_SEAL_REDUCE_CP:
                  _loc34_ = {
                     "type":BattleData.EFFECT_MERIDIANS_SEAL,
                     "duration":_loc12_.duration
                  };
                  param1.setBattleDebuff(_loc34_);
                  _loc34_ = {
                     "type":BattleData.EFFECT_CLEARBUFF_REDUCE_CP,
                     "duration":_loc12_.duration,
                     "amount":_loc12_.amount
                  };
                  param1.setBattleDebuff(_loc34_);
                  break;
               case BattleData.EFFECT_BLIND:
               case BattleData.EFFECT_ALL_CP_BLIND:
                  if(_loc12_.amount == null || int(_loc12_.amount) <= 0)
                  {
                     _loc12_.amount = 70;
                  }
                  _loc2_.effect = this.setDebuff(param1,_loc12_);
                  break;
               case BattleData.EFFECT_TEARING:
                  if(this.defender.isBattleDebuffActive(BattleData.EFFECT_BLEEDING))
                  {
                     _loc2_.attackerRestoreHp += Math.round(_loc12_.amount * 5 * 10);
                  }
                  _loc2_.effect = this.setDebuff(param1,_loc12_);
                  break;
               case BattleData.EFFECT_BUNDLE:
                  _loc2_.effect = this.setDebuff(param1,_loc12_);
                  break;
               case BattleData.EFFECT_DRAIN_CHAKRA:
                  _loc2_.effect.damageCp = Math.abs(this.updateCP(param1,0 - Math.round(param1.cp * int(_loc12_.amount) * 0.01)));
                  _loc2_.effect.damageCp = this.updateCP(this.attacker,_loc2_.effect.damageCp);
                  break;
               case BattleData.EFFECT_DRAIN_HP:
                  _loc19_ = Math.round(param1.hp * 0.15);
                  _loc19_ = Math.abs(this.updateHP(param1,0 - _loc19_));
                  _loc2_.effect.damageHp = this.updateHP(this.attacker,_loc19_);
                  break;
               case BattleData.EFFECT_DRAIN_DRAIN_HP:
                  _loc19_ = Math.round(param1.hp * int(_loc12_.amount) * 0.01);
                  _loc19_ = Math.abs(this.updateHP(param1,0 - _loc19_));
                  _loc2_.effect.damageHp = this.updateHP(this.attacker,_loc19_);
                  break;
               case BattleData.EFFECT_BLAZING:
               case BattleData.EFFECT_POISON:
                  _loc2_.effect = this.setDebuff(param1,_loc12_);
                  break;
               case BattleData.EFFECT_INTERNAL_INJURY_FEAR_WEAKEN:
                  _loc21_ = {
                     "type":BattleData.EFFECT_FEAR_WEAKEN,
                     "duration":_loc12_.duration,
                     "amount":_loc12_.amount
                  };
                  param1.setBattleDebuff(_loc21_);
                  _loc21_ = {
                     "type":BattleData.EFFECT_INTERNAL_INJURY,
                     "duration":_loc12_.duration,
                     "amount":0
                  };
                  param1.setBattleDebuff(_loc21_);
                  break;
               case BattleData.EFFECT_DAMAGE_BONUS_ACCURATE:
                  _loc34_ = {
                     "type":BattleData.EFFECT_DAMAGE_BONUS,
                     "duration":_loc2_.effect.duration,
                     "amount":_loc2_.effect.amount
                  };
                  _loc2_.attackerBuff.push(_loc34_);
                  _loc34_ = {
                     "type":BattleData.EFFECT_ACCURATE,
                     "duration":_loc2_.effect.duration,
                     "amount":_loc2_.effect.amount * 2.5
                  };
                  _loc2_.attackerBuff.push(_loc34_);
                  break;
               case BattleData.EFFECT_DRAIN_HP_STUN:
                  _loc19_ = Math.round(param1.hp * 0.15);
                  _loc19_ = Math.abs(this.updateHP(param1,0 - _loc19_));
                  _loc2_.effect.damageHp = this.updateHP(this.attacker,_loc19_);
                  _loc34_ = {
                     "type":BattleData.EFFECT_STUN,
                     "duration":_loc2_.effect.duration
                  };
                  param1.setBattleDebuff(_loc34_);
                  break;
               case BattleData.EFFECT_DRAIN_HP_N_CLEAR_BUFF:
                  _loc19_ = Math.round(param1.hp * 0.15);
                  _loc19_ = Math.abs(this.updateHP(param1,0 - _loc19_));
                  _loc2_.effect.damageHp = this.updateHP(this.attacker,_loc19_);
                  param1.clearBuff();
                  break;
               case BattleData.EFFECT_DAMAGE_BONUS_N_PURIFY:
                  _loc34_ = {
                     "type":BattleData.EFFECT_DAMAGE_BONUS,
                     "duration":_loc2_.effect.duration,
                     "amount":_loc2_.effect.amount
                  };
                  _loc2_.attackerBuff.push(_loc34_);
                  _loc41_ = 1;
                  _loc9_ = NumberUtil.getRandom();
                  if(this.defender.isBattleDebuffActive(BattleData.SKILL_253))
                  {
                     _loc41_ = 0;
                  }
                  if(_loc9_ <= _loc41_)
                  {
                     this.defender.clearAllDebuff();
                     _loc2_.effect.activated = true;
                  }
                  else
                  {
                     _loc2_.effect.activated = false;
                  }
                  break;
               case BattleData.EFFECT_DAMAGE_REDUCE_N_HEAL:
                  _loc12_ = {
                     "type":BattleData.EFFECT_DAMAGE_REDUCTION,
                     "duration":_loc12_.duration,
                     "amount":_loc12_.amount
                  };
                  _loc2_.attackerBuff.push(_loc12_);
                  break;
               case BattleData.EFFECT_DODGE_BONUS_N_HEAL:
                  _loc12_ = {
                     "type":BattleData.EFFECT_DODGE_BONUS,
                     "duration":_loc2_.effect.duration,
                     "amount":_loc2_.effect.amount
                  };
                  _loc2_.attackerBuff.push(_loc12_);
                  break;
               case BattleData.EFFECT_DODGE_BONUS_BONUSDMG:
                  _loc12_ = {
                     "type":BattleData.EFFECT_DODGE_BONUS,
                     "duration":_loc2_.effect.duration,
                     "amount":_loc2_.effect.amount
                  };
                  _loc2_.attackerBuff.push(_loc12_);
                  _loc12_ = {
                     "type":BattleData.EFFECT_DAMAGE_BONUS,
                     "duration":_loc2_.effect.duration,
                     "amount":_loc2_.effect.amount
                  };
                  _loc2_.attackerBuff.push(_loc12_);
                  break;
               case BattleData.EFFECT_CRITICAL_CHANCE_SERENE_MIND:
                  _loc12_ = {
                     "type":BattleData.EFFECT_ADD_CRITICAL_CHANCE,
                     "duration":_loc2_.effect.duration,
                     "amount":_loc2_.effect.amount
                  };
                  param1.setBattleBuff(_loc12_);
                  _loc12_ = {
                     "type":BattleData.EFFECT_SERENE_MIND_DMGBONUS,
                     "duration":_loc2_.effect.duration,
                     "amount":_loc2_.effect.amount * 2
                  };
                  param1.setBattleBuff(_loc12_);
                  break;
               case BattleData.EFFECT_DODGE_BOUNUS_N_DEBUFF_DEF_BUFF:
                  this.attacker.clearAllDebuff();
                  _loc12_ = {
                     "type":BattleData.EFFECT_DODGE_BONUS,
                     "duration":_loc2_.effect.duration,
                     "amount":_loc2_.effect.amount
                  };
                  param1.setBattleBuff(_loc12_);
                  break;
               case BattleData.EFFECT_RECV_DMG_BLEEDING_DMG_REDUCTION:
                  this.attacker.setBattleBuff(_loc12_);
                  break;
               case BattleData.EFFECT_DODGE_BONUS_REGEN_HP:
                  _loc12_ = {
                     "type":BattleData.EFFECT_DODGE_BONUS,
                     "duration":_loc2_.effect.duration,
                     "amount":_loc2_.effect.amount
                  };
                  _loc2_.attackerBuff.push(_loc12_);
                  _loc12_ = {
                     "type":BattleData.EFFECT_REGENERATE_HP,
                     "amount":8,
                     "duration":_loc2_.effect.duration
                  };
                  _loc2_.attackerBuff.push(_loc12_);
                  break;
               case BattleData.EFFECT_DODGE_BONUS_N_CD_REDUCTION:
                  _loc12_ = {
                     "type":BattleData.EFFECT_DODGE_BONUS,
                     "duration":_loc2_.effect.duration,
                     "amount":_loc2_.effect.amount
                  };
                  _loc2_.attackerBuff.push(_loc12_);
                  param1.reduceSkillCooldown(_loc12_.duration,BattleData.REDUCETYPE_SKILL);
                  break;
               case BattleData.EFFECT_HANAMI_EXTRA_ATTACK:
                  _loc11_ = NumberUtil.randomInt(20,40);
                  _loc34_ = {
                     "type":BattleData.EFFECT_REDUCE_PURIFY_CHANCE,
                     "duration":_loc12_.duration,
                     "amount":_loc11_
                  };
                  param1.setBattleDebuff(_loc34_);
                  _loc11_ = NumberUtil.randomInt(20,50);
                  _loc34_ = {
                     "type":BattleData.SKILL_304,
                     "duration":_loc12_.duration,
                     "amount":_loc11_
                  };
                  param1.setBattleDebuff(_loc34_);
                  _loc11_ = NumberUtil.randomInt(15,45);
                  _loc34_ = {
                     "type":BattleData.SKILL_270,
                     "duration":_loc12_.duration,
                     "amount":_loc11_
                  };
                  param1.setBattleDebuff(_loc34_);
                  break;
               case BattleData.EFFECT_STUN_DEBUFF_RESIST:
                  _loc34_ = {
                     "type":BattleData.EFFECT_STUN,
                     "duration":_loc12_.duration,
                     "amount":_loc12_.amount
                  };
                  param1.setBattleDebuff(_loc34_);
                  break;
               case BattleData.EFFECT_TITAN_DMG_BONUS_REDUCE_CUT_CLEAR:
                  _loc34_ = {
                     "type":BattleData.EFFECT_SUSANOOB,
                     "duration":_loc2_.effect.duration,
                     "amount":_loc2_.effect.amount
                  };
                  _loc2_.attackerBuff.push(_loc34_);
                  _loc34_ = {
                     "type":BattleData.EFFECT_DAMAGE_BONUSA,
                     "duration":_loc2_.effect.duration,
                     "amount":_loc2_.effect.amount
                  };
                  _loc2_.attackerBuff.push(_loc34_);
                  _loc34_ = {
                     "type":BattleData.EFFECT_DAMAGE_REDUCTIONA,
                     "duration":_loc2_.effect.duration,
                     "amount":_loc2_.effect.amount
                  };
                  _loc2_.attackerBuff.push(_loc34_);
                  break;
               case BattleData.EFFECT_TITAN_DMG_BONUS_BURN:
                  _loc34_ = {
                     "type":BattleData.EFFECT_SUSANOO,
                     "duration":_loc2_.effect.duration,
                     "amount":_loc2_.effect.amount
                  };
                  _loc2_.attackerBuff.push(_loc34_);
                  _loc34_ = {
                     "type":BattleData.EFFECT_DAMAGE_BONUS,
                     "duration":_loc2_.effect.duration,
                     "amount":_loc2_.effect.amount
                  };
                  _loc2_.attackerBuff.push(_loc34_);
                  break;
               case BattleData.EFFECT_THUNDER_MODE_COMBUSTION_CHANCE_REGEN_HP:
                  _loc34_ = {
                     "type":BattleData.EFFECT_THUNDERSTORM_MODE,
                     "duration":_loc2_.effect.duration,
                     "amount":_loc2_.effect.amount
                  };
                  _loc2_.attackerBuff.push(_loc34_);
                  _loc34_ = {
                     "type":BattleData.EFFECT_ADD_COMBUSTION_CHANCE,
                     "duration":_loc2_.effect.duration,
                     "amount":_loc2_.effect.amount + 40
                  };
                  _loc2_.attackerBuff.push(_loc34_);
                  _loc34_ = {
                     "type":BattleData.EFFECT_REGENERATE_HP,
                     "duration":_loc2_.effect.duration,
                     "amount":_loc2_.effect.amount / 5
                  };
                  _loc2_.attackerBuff.push(_loc34_);
                  break;
               case BattleData.EFFECT_TITAN_DMG_BONUS_REDUCE_BURN:
                  _loc34_ = {
                     "type":BattleData.EFFECT_SUSANOOA,
                     "duration":_loc2_.effect.duration,
                     "amount":_loc2_.effect.amount
                  };
                  _loc2_.attackerBuff.push(_loc34_);
                  _loc34_ = {
                     "type":BattleData.EFFECT_DAMAGE_BONUS,
                     "duration":_loc2_.effect.duration,
                     "amount":_loc2_.effect.amount
                  };
                  _loc2_.attackerBuff.push(_loc34_);
                  _loc34_ = {
                     "type":BattleData.EFFECT_DAMAGE_REDUCTION,
                     "duration":_loc2_.effect.duration,
                     "amount":_loc2_.effect.amount
                  };
                  _loc2_.attackerBuff.push(_loc34_);
                  break;
               case BattleData.EFFECT_BLEEDING_WEAKEN:
                  if(!param1.isBattleBuffActive(BattleData.EFFECT_BURN_HP_CP_FIX_NUM_N_IMMUNITY_BLEEDING))
                  {
                     _loc34_ = {
                        "type":BattleData.EFFECT_BLEEDING,
                        "duration":_loc2_.effect.duration,
                        "amount":_loc2_.effect.amount
                     };
                     param1.setBattleDebuff(_loc34_);
                  }
                  _loc34_ = {
                     "type":BattleData.EFFECT_PET_WEAKEN,
                     "duration":_loc2_.effect.duration
                  };
                  param1.setBattleDebuff(_loc34_);
                  break;
               case BattleData.EFFECT_SERENE_MIND_N_HEAL:
                  _loc21_ = {
                     "type":BattleData.EFFECT_SERENE_MIND,
                     "duration":_loc12_.duration
                  };
                  _loc2_.attackerBuff.push(_loc21_);
                  _loc21_ = {
                     "type":BattleData.EFFECT_PET_HEAL,
                     "duration":_loc12_.duration,
                     "amount":_loc12_.amount
                  };
                  _loc2_.attackerBuff.push(_loc21_);
                  break;
               case BattleData.EFFECT_SERENE_MIND_DMGBONUS:
                  _loc21_ = {
                     "type":BattleData.EFFECT_DAMAGE_BONUS,
                     "duration":_loc12_.duration,
                     "amount":_loc12_.amount
                  };
                  _loc2_.attackerBuff.push(_loc21_);
                  break;
               case BattleData.EFFECT_INTERNAL_INJURY_DARKNESS:
                  _loc21_ = {
                     "type":BattleData.EFFECT_DARKNESS,
                     "duration":_loc12_.duration,
                     "amount":_loc12_.amount
                  };
                  param1.setBattleDebuff(_loc21_);
                  _loc21_ = {
                     "type":BattleData.EFFECT_INTERNAL_INJURY,
                     "duration":_loc12_.duration,
                     "amount":0
                  };
                  param1.setBattleDebuff(_loc21_);
                  param1.clearBuff();
                  break;
               case BattleData.EFFECT_FEAR:
               case BattleData.EFFECT_FEAR_WEAKEN:
                  _loc2_.effect = this.setDebuff(param1,_loc12_);
                  break;
               case BattleData.EFFECT_PARASITE:
                  _loc2_.effect = this.setDebuff(param1,_loc12_);
                  break;
               case BattleData.EFFECT_CHAKRA_SUCKER:
                  _loc2_.defenderDamageCp = Math.round(param1.maxCP * int(_loc12_.amount) * 0.01);
                  break;
               case BattleData.EFFECT_BURNING:
                  canburning = true;
                  _loc2_.effect = this.setDebuff(param1,_loc12_);
                  break;
               case BattleData.EFFECT_JUTSU_POISON:
                  _loc2_.effect = this.setDebuff(param1,_loc12_);
                  break;
               case BattleData.EFFECT_DODGE_REDUCTION:
                  _loc2_.effect = this.setDebuff(param1,_loc12_);
                  break;
               case BattleData.EFFECT_PARALYZE:
                  if(_loc2_.critical)
                  {
                     _loc2_.effect = this.setDebuff(param1,_loc12_);
                  }
                  break;
               case BattleData.EFFECT_MERIDIANS_SEAL:
                  _loc2_.effect = this.setDebuff(param1,_loc12_);
                  break;
               case BattleData.EFFECT_CUBE_ILLUSION:
                  _loc2_.effect = this.setDebuff(param1,_loc12_);
                  break;
               case BattleData.EFFECT_HAMSTRING:
                  _loc2_.effect = this.setDebuff(param1,_loc12_);
                  break;
               case BattleData.EFFECT_PET_BLIND:
                  _loc2_.effect = this.setDebuff(param1,_loc12_);
                  break;
               case BattleData.EFFECT_INTERNAL_INJURY:
                  _loc2_.effect = this.setDebuff(param1,_loc12_);
                  break;
               case BattleData.SKILL_342:
                  _loc2_.effect = this.setDebuff(param1,_loc12_);
                  break;
               case BattleData.SKILL_342_THANOS:
                  _loc4_ = 0;
                  if(attacker.getWeapon() == "wpn1596")
                  {
                     _loc3_ = int(Central.main.stateInventory.getStateOnCount(attacker.getCharacterId(),"wpn","wpn1596"));
                     if(_loc3_ >= 0)
                     {
                        _loc4_ = _loc3_;
                     }
                  }
                  _loc2_.effect = this.setDebuff(param1,{
                     "type":BattleData.SKILL_342,
                     "duration":_loc12_.duration + Math.floor(_loc4_ / 3),
                     "amount":_loc12_.amount
                  });
                  break;
               case BattleData.SKILL_377:
                  _loc2_.effect = this.setDebuff(param1,_loc12_);
                  break;
               case BattleData.EFFECT_HEAL_OVER_TIME:
               case BattleData.EFFECT_HEAL_OVER_TIME_NPC:
               case BattleData.EFFECT_HEAL_OVER_TIME_FIX_NUM:
               case BattleData.EFFECT_HEAL_OVER_TIME_FIX_NUM_DARKNESS:
                  Out.debug(this,"processDamage :: effect hank >> " + _loc12_.type);
                  param1.setBattleBuff(_loc12_);
                  _loc12_ = {
                     "type":BattleData.EFFECT_DARKNESS,
                     "duration":_loc2_.effect.duration,
                     "amount":5
                  };
                  param1.setBattleDebuff(_loc12_);
                  break;
               case BattleData.EFFECT_DMGBONUS_FIX_NUM_CRITICAL_CHANCE_BONUS:
                  _loc12_ = {
                     "type":BattleData.EFFECT_DAMAGE_BONUS_FIX_NUM,
                     "duration":_loc2_.effect.duration,
                     "amount":_loc2_.effect.amount
                  };
                  _loc2_.attackerBuff.push(_loc12_);
                  _loc12_ = {
                     "type":BattleData.EFFECT_CRITICAL_CHANCE_BONUS,
                     "duration":_loc2_.effect.duration,
                     "amount":10
                  };
                  _loc2_.attackerBuff.push(_loc12_);
                  break;
               case BattleData.EFFECT_SUSANOO:
               case BattleData.EFFECT_SUSANOOA:
               case BattleData.EFFECT_SUSANOOB:
               case BattleData.SKILL_234:
               case BattleData.EFFECT_DAMAGE_BONUS:
               case BattleData.EFFECT_DAMAGE_REDUCTION:
               case BattleData.EFFECT_SERENE_MIND:
               case BattleData.EFFECT_PET_HEAL:
               case BattleData.EFFECT_PET_REFLECT_ATTACK:
                  param1.setBattleBuff(_loc12_);
                  break;
               case BattleData.EFFECT_DAMAGE_BONUS_FIX_NUM:
                  _loc2_.attackerBuff.push(_loc12_);
                  break;
               case BattleData.EFFECT_DAMAGE_BONUS_FIX_NUM_THANOS:
                  break;
               case BattleData.EFFECT_BLOODY_MIST:
               case BattleData.EFFECT_HIT_SELF:
               case BattleData.EFFECT_CHAOS:
               case BattleData.EFFECT_BUBBLE_PRISON:
               case BattleData.EFFECT_REDUCE_PURIFY_CHANCE:
                  param1.setBattleDebuff(_loc12_);
                  break;
               case BattleData.EFFECT_CHAOS_THANOS:
                  param1.setBattleDebuff({
                     "type":BattleData.EFFECT_CHAOS,
                     "duration":_loc12_.duration,
                     "amount":_loc12_.amount
                  });
                  break;
               case BattleData.SKILL_236:
                  _loc2_.effect = this.setDebuff(param1,_loc12_);
                  param1.addSkillCooldown(4,SkillData.TYPE_WIND);
                  if(this.attacker.isBattleBuffActive(BattleData.SKILL_234))
                  {
                     _loc19_ = Math.round(param1.maxHP * 0.08);
                     _loc2_.effect.damageHp = Math.abs(this.updateHP(param1,0 - _loc19_));
                  }
                  break;
               case BattleData.SKILL_287:
                  _loc21_ = {
                     "type":BattleData.EFFECT_DECREASE_CRITICAL_CHANCE,
                     "duration":_loc12_.duration,
                     "amount":_loc12_.amount
                  };
                  _loc21_ = this.setDebuff(param1,_loc21_);
                  _loc2_.effect.resisted = _loc21_.resisted;
                  param1.addSkillCooldown(3,SkillData.TYPE_LIGHTNING);
                  if(this.attacker.isBattleBuffActive(BattleData.SKILL_285))
                  {
                     _loc8_ = Math.round(_loc8_ * 1.2);
                  }
                  break;
               case BattleData.SKILL_270:
                  _loc2_.effect = this.setDebuff(param1,_loc12_);
                  param1.addSkillCooldown(4,SkillData.TYPE_FIRE);
                  if(this.attacker.isBattleBuffActive(BattleData.SKILL_268))
                  {
                     _loc21_ = {
                        "type":BattleData.EFFECT_DAMAGE_REDUCTION,
                        "duration":5,
                        "amount":50
                     };
                     param1.setBattleDebuff(_loc21_);
                     _loc2_.effect.extraEffect = true;
                  }
                  break;
               case BattleData.EFFECT_HIDDEN_MIST:
                  _loc2_.effect = this.setDebuff(param1,_loc12_);
                  break;
               case BattleData.EFFECT_DARKNESS:
                  _loc2_.effect = this.setDebuff(param1,_loc12_);
                  break;
               case BattleData.SKILL_304:
                  _loc2_.effect = this.setDebuff(param1,_loc12_);
                  param1.addSkillCooldown(4,SkillData.TYPE_EARTH);
                  break;
               case BattleData.SKILL_307:
                  param1.setBattleBuff(_loc12_);
                  param1.clearAllDebuff();
                  break;
               case BattleData.SKILL_359:
                  _loc2_.effect = this.setDebuff(param1,_loc12_);
                  _loc2_.defenderDamageCp = Math.round(param1.maxCP * 0.75);
                  break;
               case BattleData.SKILL_336:
                  _loc2_.effect.damageCp = Math.abs(this.updateCP(param1,0 - Math.round(param1.cp * int(_loc12_.amount) * 0.01)));
                  _loc2_.effect.damageCp = this.updateCP(this.attacker,_loc2_.effect.damageCp);
                  _loc12_ = {
                     "type":BattleData.EFFECT_CHAOS,
                     "duration":_loc12_.duration
                  };
                  param1.setBattleDebuff(_loc12_);
                  break;
               case BattleData.EFFECT_PET_BURN:
                  _loc2_.effect = this.setDebuff(param1,_loc12_);
                  canpetburn = true;
                  break;
               case BattleData.EFFECT_PET_WEAKEN:
               case BattleData.EFFECT_PET_WEAKEN_FIX_NUM:
                  _loc2_.effect = this.setDebuff(param1,_loc12_);
                  break;
               case BattleData.EFFECT_COOLDOWN_REDUCTION:
                  param1.reduceSkillCooldown(_loc12_.amount,BattleData.REDUCETYPE_SKILL);
                  break;
               case BattleData.EFFECT_DODGE_BONUS_ALL_FRIENDLY:
                  param1.setBattleBuff(_loc12_);
                  break;
               case BattleData.EFFECT_WIND_PEACE_SINGLE:
               case BattleData.EFFECT_WIND_PEACE:
               case BattleData.EFFECT_WIND_PEACE_2:
               case BattleData.EFFECT_WIND_PEACE_3:
               case BattleData.EFFECT_WIND_PEACE_4:
               case BattleData.EFFECT_BUBBLE_SHIELD:
                  param1.setBattleBuff(_loc12_);
                  break;
               case BattleData.EFFECT_STEEL_COATING:
                  _loc34_ = {
                     "type":BattleData.EFFECT_DAMAGE_REDUCTION,
                     "duration":_loc2_.effect.duration,
                     "amount":_loc2_.effect.amount
                  };
                  param1.setBattleBuff(_loc34_);
                  _loc34_ = {
                     "type":BattleData.EFFECT_DAMAGE_BONUS,
                     "duration":_loc2_.effect.duration,
                     "amount":_loc2_.effect.amount
                  };
                  param1.setBattleBuff(_loc34_);
                  break;
               case BattleData.EFFECT_DRAIN_HP_CP:
                  _loc2_.effect.damageHp = Math.abs(this.updateHP(param1,0 - Math.round(param1.hp * int(_loc12_.amount) * 0.01)));
                  _loc2_.effect.damageHp = this.updateHP(this.attacker,_loc2_.effect.damageHp);
                  _loc2_.effect.damageCp = Math.abs(this.updateCP(param1,0 - Math.round(param1.cp * int(_loc12_.amount) * 0.01)));
                  _loc2_.effect.damageCp = this.updateCP(this.attacker,_loc2_.effect.damageCp);
                  break;
               case BattleData.EFFECT_DRAIN_HP_N_ACCURACY:
                  _loc2_.effect.damageHp = Math.abs(this.updateHP(param1,0 - Math.round(param1.hp * int(_loc12_.amount) * 0.01)));
                  _loc2_.effect.damageHp = this.updateHP(this.attacker,_loc2_.effect.damageHp);
                  _loc34_ = {
                     "type":BattleData.EFFECT_ACCURATE,
                     "duration":_loc2_.effect.duration,
                     "amount":_loc2_.effect.amount * 2.5
                  };
                  attacker.setBattleBuff(_loc34_);
                  _loc34_ = {
                     "type":BattleData.EFFECT_BLIND,
                     "duration":_loc2_.effect.duration,
                     "amount":_loc2_.effect.amount * 2.5
                  };
                  param1.setBattleDebuff(_loc34_);
                  break;
               case BattleData.EFFECT_REDUCE_HP_CP:
                  param1.setBattleDebuff(_loc12_);
                  break;
               case BattleData.EFFECT_CLEARBUFF_REDUCE_HP_CP:
               case BattleData.EFFECT_CLEARBUFF_REDUCE_HP:
               case BattleData.EFFECT_CLEARBUFF_REDUCE_CP:
                  param1.clearBuff();
                  param1.setBattleDebuff(_loc12_);
                  break;
               case BattleData.EFFECT_CLEARBUFF_REDUCE_CP_THANOS:
                  param1.clearBuff();
                  param1.setBattleDebuff({
                     "type":BattleData.EFFECT_CLEARBUFF_REDUCE_CP,
                     "duration":_loc12_.duration,
                     "amount":_loc12_.amount
                  });
                  break;
               case BattleData.EFFECT_CLEARBUFF_RANDOM_REDUCE_AGI:
                  param1.clearBuff();
                  _loc9_ = NumberUtil.getRandom();
                  if(_loc9_ <= _loc2_.effect.amount / 100)
                  {
                     _loc2_.effect.activated = true;
                     _loc34_ = {
                        "type":BattleData.EFFECT_REDUCE_AGILITY,
                        "duration":_loc12_.duration,
                        "amount":_loc12_.amount / 2
                     };
                     param1.setBattleDebuff(_loc34_);
                  }
                  else
                  {
                     _loc2_.effect.activated = false;
                  }
                  break;
               case BattleData.EFFECT_CLEAR_BUFF_NO_RANDOM:
                  param1.clearBuff();
                  break;
               case BattleData.EFFECT_CLEAR_BUFF:
                  _loc9_ = NumberUtil.getRandom();
                  if(_loc9_ <= int(_loc2_.effect.amount) / 100)
                  {
                     _loc2_.effect.activated = true;
                     param1.clearBuff();
                  }
                  else
                  {
                     _loc2_.effect.activated = false;
                  }
                  break;
               case BattleData.EFFECT_CLEARBUFF_STUN:
                  param1.clearBuff();
                  _loc2_.clearrbuff = true;
                  if(_loc2_.ignoredmg == false)
                  {
                     _loc21_ = {
                        "type":BattleData.EFFECT_STUN,
                        "duration":_loc12_.duration
                     };
                     this.setDebuff(param1,_loc21_);
                  }
                  break;
               case BattleData.EFFECT_CLEARBUFF:
                  param1.clearBuff();
                  if(_loc2_.ignoredmg == false)
                  {
                     _loc21_ = {"type":BattleData.EFFECT_CLEARBUFF};
                     _loc2_.effect = this.setDebuff(param1,_loc21_);
                  }
                  break;
               case BattleData.EFFECT_CLEARBUFF_INTERNAL_INJURY_CHAOS:
                  param1.clearBuff();
                  param1.clearAllDebuff();
                  _loc34_ = {
                     "type":BattleData.EFFECT_CHAOS,
                     "duration":_loc12_.duration,
                     "amount":_loc12_.amount
                  };
                  param1.setBattleDebuff(_loc34_);
                  _loc34_ = {
                     "type":BattleData.EFFECT_INTERNAL_INJURY,
                     "duration":_loc12_.duration + 2,
                     "amount":_loc12_.amount
                  };
                  param1.setBattleDebuff(_loc34_);
                  break;
               case BattleData.EFFECT_REDUCE_CP_EFFECT_DARKNESS:
                  _loc34_ = {
                     "type":BattleData.EFFECT_CLEARBUFF_REDUCE_CP,
                     "duration":_loc12_.duration,
                     "amount":_loc12_.amount
                  };
                  param1.setBattleDebuff(_loc34_);
                  _loc34_ = {
                     "type":BattleData.EFFECT_DARKNESS,
                     "duration":_loc12_.duration,
                     "amount":_loc12_.amount * 5
                  };
                  param1.setBattleDebuff(_loc34_);
                  break;
               case BattleData.EFFECT_BURN_CP_CLEAR_BUFF:
                  param1.clearBuff();
                  param1.clearAllDebuff();
                  _loc42_ = Math.ceil(Math.random() * 25);
                  _loc43_ = Math.round(param1.cp * ((int(_loc2_.effect.amount) - _loc42_) / 100));
                  _loc2_.defenderDamageCp = _loc43_;
                  break;
               case BattleData.EFFECT_CLEAR_BUFF_N_INTERNAL_INJURY_THANOS:
                  _loc5_ = this.attacker.getWeapon();
                  _loc6_ = 0;
                  if(_loc5_ == "wpn1596")
                  {
                     _loc2_.dmg += 1500;
                     _loc6_ += 3;
                  }
                  param1.clearBuff();
                  param1.clearAllDebuff();
                  if(_loc2_.ignoredmg == false)
                  {
                     _loc34_ = {
                        "type":BattleData.EFFECT_INTERNAL_INJURY,
                        "duration":_loc2_.effect.duration + _loc6_,
                        "amount":_loc2_.effect.amount
                     };
                     param1.setBattleDebuff(_loc34_);
                  }
                  break;
               case BattleData.EFFECT_CLEAR_BUFF_N_INTERNAL_INJURY:
                  param1.clearBuff();
                  param1.clearAllDebuff();
                  if(_loc2_.ignoredmg == false)
                  {
                     _loc34_ = {
                        "type":BattleData.EFFECT_INTERNAL_INJURY,
                        "duration":_loc2_.effect.duration,
                        "amount":_loc2_.effect.amount
                     };
                     param1.setBattleDebuff(_loc34_);
                  }
                  break;
               case BattleData.EFFECT_BURN_CP_CLEAR_BUFF_WEAK:
                  if(_loc2_.ignoredmg == false)
                  {
                     _loc48_ = param1.cp * (15 + Math.floor(Math.random() * 21)) / 100;
                     _loc2_.defenderDamageCp = _loc48_;
                  }
                  if(!_loc2_.removedEffectList)
                  {
                     break;
                  }
                  for each(_loc49_ in _loc2_.removedEffectList)
                  {
                     if(param1.getData(DBCharacterData.ID) == _loc49_.targetId)
                     {
                        _loc50_ = _loc49_.type;
                        param1.removeBuff(_loc50_);
                        param1.removeDebuff(_loc50_);
                     }
                  }
                  break;
               case BattleData.EFFECT_CLEAR_SELF_DEBUFF_DEFENDER_BUFF:
                  param1.clearBuff();
                  this.attacker.clearAllDebuff();
                  break;
               case BattleData.EFFECT_SKILL_884:
                  this.attacker.clearAllDebuff();
                  _loc29_.defenderDamageHp = Math.round(this.attacker.hp * int(_loc12_.amount) * 0.01);
                  _loc29_.defenderDamageHp = this.updateHP(param1,0 - _loc29_.defenderDamageHp);
                  this.updateHP(this.attacker,-this.attacker.hp * int(_loc2_.effect.amount) * 0.01);
                  break;
               case BattleData.EFFECT_FINAL_ATTACK:
                  this.attacker.clearAllDebuff();
                  _loc8_ = -100;
                  _loc44_ = Math.random() * int(_loc2_.effect.amount - 1);
                  _loc8_ *= 1 + _loc44_;
                  _loc8_ = int(_loc8_);
                  _loc2_.dmg = _loc8_ * -1;
                  break;
               case BattleData.EFFECT_BURN_CP:
                  _loc29_.defenderDamageCp = Math.round(param1.maxCP * int(_loc12_.amount) * 0.01);
                  _loc29_.defenderDamageCp = this.updateCP(param1,0 - _loc29_.defenderDamageCp);
                  break;
               case BattleData.EFFECT_DAMAGE_DELAY:
               case BattleData.EFFECT_DAMAGE_DELAY_THANOS:
                  _loc4_ = 0;
                  if(_loc2_.effect.type == BattleData.EFFECT_DAMAGE_DELAY_THANOS && attacker.getWeapon() == "wpn1596")
                  {
                     _loc3_ = int(Central.main.stateInventory.getStateOnCount(attacker.getCharacterId(),"wpn","wpn1596"));
                     if(_loc3_ >= 0)
                     {
                        _loc4_ = _loc3_;
                     }
                  }
                  param1.setBattleBuff({
                     "type":BattleData.EFFECT_DAMAGE_DELAY,
                     "duration":_loc12_.duration + Math.floor((_loc4_ + 1) / 3),
                     "amount":_loc12_.amount,
                     "intmem1":0,
                     "intmem2":Math.floor(param1.maxHP * _loc12_.amount * 0.01)
                  });
                  param1.setBattleBuff({
                     "type":BattleData.EFFECT_PET_DEBUFF_RESIST,
                     "duration":_loc12_.duration + Math.floor((_loc4_ + 1) / 3),
                     "amount":100
                  });
                  break;
               case BattleData.EFFECT_INTERNAL_INJURY_BLEEDING:
                  if(!param1.isBattleBuffActive(BattleData.EFFECT_BURN_HP_CP_FIX_NUM_N_IMMUNITY_BLEEDING))
                  {
                     _loc34_ = {
                        "type":BattleData.EFFECT_BLEEDING,
                        "duration":_loc12_.duration,
                        "amount":_loc12_.amount
                     };
                     param1.setBattleDebuff(_loc34_);
                  }
                  _loc34_ = {
                     "type":BattleData.EFFECT_INTERNAL_INJURY,
                     "duration":_loc12_.duration,
                     "amount":100
                  };
                  param1.setBattleDebuff(_loc34_);
                  break;
               case BattleData.EFFECT_TRANSFORM:
                  param1.setBattleDebuff(_loc12_);
                  break;
               case BattleData.EFFECT_BLEEDING_STUN:
                  _loc34_ = {
                     "type":BattleData.EFFECT_STUN,
                     "duration":_loc12_.duration,
                     "amount":_loc12_.amount
                  };
                  param1.setBattleDebuff(_loc34_);
                  if(!param1.isBattleBuffActive(BattleData.EFFECT_BURN_HP_CP_FIX_NUM_N_IMMUNITY_BLEEDING))
                  {
                     _loc34_ = {
                        "type":BattleData.EFFECT_BLEEDING,
                        "duration":_loc12_.duration,
                        "amount":_loc12_.amount
                     };
                     param1.setBattleDebuff(_loc34_);
                  }
                  break;
               case BattleData.EFFECT_CHAOS_N_BURN:
                  _loc34_ = {
                     "type":BattleData.EFFECT_CHAOS,
                     "duration":_loc12_.duration
                  };
                  param1.setBattleDebuff(_loc34_);
                  _loc34_ = {
                     "type":BattleData.EFFECT_BURNING,
                     "duration":_loc12_.duration,
                     "amount":_loc12_.amount
                  };
                  param1.setBattleDebuff(_loc34_);
                  canburning = true;
                  break;
               case BattleData.EFFECT_BURNING_N_JUTSU_POISON:
                  _loc34_ = {
                     "type":BattleData.EFFECT_JUTSU_POISON,
                     "duration":_loc12_.duration,
                     "amount":_loc12_.amount
                  };
                  param1.setBattleDebuff(_loc34_);
                  _loc34_ = {
                     "type":BattleData.EFFECT_BURNING,
                     "duration":_loc12_.duration,
                     "amount":_loc12_.amount
                  };
                  param1.setBattleDebuff(_loc34_);
                  canburning = true;
                  break;
               case BattleData.EFFECT_CHAOS_N_BLEEDING:
                  _loc34_ = {
                     "type":BattleData.EFFECT_CHAOS,
                     "duration":_loc12_.duration
                  };
                  param1.setBattleDebuff(_loc34_);
                  if(!param1.isBattleBuffActive(BattleData.EFFECT_BURN_HP_CP_FIX_NUM_N_IMMUNITY_BLEEDING))
                  {
                     _loc34_ = {
                        "type":BattleData.EFFECT_BLEEDING,
                        "duration":_loc12_.duration + 2,
                        "amount":_loc12_.amount
                     };
                     param1.setBattleDebuff(_loc34_);
                  }
                  break;
               case BattleData.EFFECT_PET_DISORIENTED_BLEEDING:
                  _loc34_ = {
                     "type":BattleData.EFFECT_PET_DISORIENTED,
                     "duration":_loc12_.duration,
                     "amount":_loc12_.amount
                  };
                  param1.setBattleDebuff(_loc34_);
                  if(!param1.isBattleBuffActive(BattleData.EFFECT_BURN_HP_CP_FIX_NUM_N_IMMUNITY_BLEEDING))
                  {
                     _loc34_ = {
                        "type":BattleData.EFFECT_BLEEDING,
                        "duration":_loc12_.duration,
                        "amount":_loc12_.amount
                     };
                     param1.setBattleDebuff(_loc34_);
                  }
                  break;
               case BattleData.EFFECT_DARKNESS_N_BUFF_NEGATE:
                  _loc34_ = {
                     "type":BattleData.EFFECT_DARKNESS,
                     "duration":_loc12_.duration,
                     "amount":_loc12_.amount
                  };
                  param1.setBattleDebuff(_loc34_);
                  _loc34_ = {
                     "type":BattleData.EFFECT_BUFF_NEGATE,
                     "duration":_loc12_.duration,
                     "amount":_loc12_.amount
                  };
                  param1.setBattleDebuff(_loc34_);
                  break;
               case BattleData.EFFECT_FLAME_N_BUFF_NEGATE:
                  _loc34_ = {
                     "type":BattleData.EFFECT_FLAME,
                     "duration":_loc12_.duration,
                     "amount":_loc12_.amount
                  };
                  param1.setBattleDebuff(_loc34_);
                  _loc34_ = {
                     "type":BattleData.EFFECT_BUFF_NEGATE,
                     "duration":_loc12_.duration,
                     "amount":_loc12_.amount
                  };
                  param1.setBattleDebuff(_loc34_);
                  break;
               case BattleData.EFFECT_BURN_HP_CLEAR_BUFF:
                  param1.clearBuff();
                  if(_loc2_.ignoredmg == false)
                  {
                     _loc34_ = {
                        "type":BattleData.EFFECT_PET_BURN,
                        "duration":_loc12_.duration,
                        "amount":_loc12_.amount
                     };
                     param1.setBattleDebuff(_loc34_);
                     canpetburn = true;
                  }
                  break;
               case BattleData.EFFECT_CLEARBUFF_DODGEREDUCTION:
                  param1.clearBuff();
                  if(_loc2_.ignoredmg == false)
                  {
                     Out.debug(this,"BattleProcessor::processDamage, [1], EFFECT_CLEARBUFF_DODGEREDUCTION");
                     param1.setBattleDebuff(_loc2_.effect);
                     Out.debug(this,"BattleProcessor::processDamage, [2], EFFECT_CLEARBUFF_DODGEREDUCTION");
                  }
                  break;
               case BattleData.EFFECT_REDUCE_CP_DAMAGE:
                  _loc29_.defenderDamageCp = Math.round(param1.maxCP * _loc2_.effect.amount * 0.01);
                  _loc2_.effect = this.setDebuff(param1,_loc12_);
                  break;
               case BattleData.EFFECT_BURN_HP_N_MERIDIANS_SEAL:
                  _loc29_.defenderDamageHp = Math.round(param1.maxHP * int(_loc12_.amount) * 0.01);
                  _loc29_.defenderDamageHp = this.updateHP(param1,0 - _loc29_.defenderDamageHp);
                  _loc34_ = {
                     "type":BattleData.EFFECT_MERIDIANS_SEAL,
                     "duration":_loc12_.duration,
                     "amount":_loc12_.amount
                  };
                  param1.setBattleDebuff(_loc34_);
                  break;
               case BattleData.EFFECT_BURN_CP_N_MERIDIANS_SEAL:
                  _loc29_.defenderDamageCp = Math.round(param1.maxCP * int(_loc12_.amount) * 0.01);
                  _loc29_.defenderDamageCp = this.updateCP(param1,0 - _loc29_.defenderDamageCp);
                  _loc34_ = {
                     "type":BattleData.EFFECT_MERIDIANS_SEAL,
                     "duration":_loc12_.duration,
                     "amount":_loc12_.amount
                  };
                  param1.setBattleDebuff(_loc34_);
                  break;
               case BattleData.EFFECT_BURN_CP_HP:
                  _loc29_.defenderDamageHp = Math.round(param1.maxHP * int(_loc12_.amount) * 0.01);
                  _loc29_.defenderDamageCp = Math.round(param1.maxCP * int(_loc12_.amount) * 0.01);
                  _loc29_.defenderDamageHp = this.updateHP(param1,0 - _loc29_.defenderDamageHp);
                  _loc29_.defenderDamageCp = this.updateCP(param1,0 - _loc29_.defenderDamageCp);
                  break;
               case BattleData.EFFECT_REDUCE_PURIFY_N_BURNING:
                  _loc34_ = {
                     "type":BattleData.EFFECT_REDUCE_PURIFY_CHANCE,
                     "duration":_loc12_.duration,
                     "amount":20
                  };
                  param1.setBattleDebuff(_loc34_);
                  _loc34_ = {
                     "type":BattleData.EFFECT_BURNING,
                     "duration":_loc12_.duration,
                     "amount":_loc12_.amount
                  };
                  param1.setBattleDebuff(_loc34_);
                  canburning = true;
                  break;
               case BattleData.EFFECT_UPG_REDUCE_PURIFY_N_BURNING:
                  _loc34_ = {
                     "type":BattleData.EFFECT_REDUCE_PURIFY_CHANCE,
                     "duration":_loc12_.duration,
                     "amount":50
                  };
                  param1.setBattleDebuff(_loc34_);
                  _loc34_ = {
                     "type":BattleData.EFFECT_BURNING,
                     "duration":_loc12_.duration,
                     "amount":_loc12_.amount
                  };
                  param1.setBattleDebuff(_loc34_);
                  canburning = true;
                  break;
               case BattleData.EFFECT_INTERNAL_INJURY_CHAOS:
                  _loc34_ = {
                     "type":BattleData.EFFECT_CHAOS,
                     "duration":3
                  };
                  param1.setBattleDebuff(_loc34_);
                  _loc34_ = {
                     "type":BattleData.EFFECT_INTERNAL_INJURY,
                     "duration":_loc2_.effect.duration,
                     "amount":_loc2_.effect.amount
                  };
                  param1.setBattleDebuff(_loc34_);
                  break;
               case BattleData.EFFECT_BURN_HP_AOE:
                  _loc29_.defenderDamageHp = Math.round(param1.maxHP * _loc2_.effect.amount * 0.01);
                  break;
               case BattleData.EFFECT_CLEAR_DEBUFF_RST_DMG_HP:
                  _loc29_.defenderDamageHp = Math.round(param1.maxHP * _loc2_.effect.amount * 0.01);
                  break;
               case BattleData.EFFECT_ACCUM_BLEEDING:
                  if(!param1.isBattleBuffActive(BattleData.EFFECT_BURN_HP_CP_FIX_NUM_N_IMMUNITY_BLEEDING))
                  {
                     param1.setBattleDebuff(_loc2_.effect);
                  }
                  break;
               case BattleData.EFFECT_BURNING_WITH_DEBUFF_NUM:
                  _loc45_ = param1.getBattleDebuff();
                  _loc46_ = 0;
                  for(_loc51_ in _loc45_)
                  {
                     _loc46_++;
                  }
                  if(_loc46_ > 0)
                  {
                     _loc34_ = {
                        "type":BattleData.EFFECT_ULTRA_BURNING,
                        "amount":5 * _loc46_,
                        "duration":_loc2_.effect.duration
                     };
                     param1.setBattleDebuff(_loc34_);
                  }
                  _loc34_ = {
                     "type":BattleData.EFFECT_BURNING,
                     "amount":_loc2_.effect.amount,
                     "duration":_loc2_.effect.duration
                  };
                  param1.setBattleDebuff(_loc34_);
                  canburning = true;
                  break;
               case BattleData.EFFECT_FLAME:
                  param1.setBattleDebuff(_loc2_.effect);
                  break;
               case BattleData.EFFECT_CUBE_ILLUSION_N_FEAR_WEAKEN:
                  _loc34_ = {
                     "type":BattleData.EFFECT_CUBE_ILLUSION,
                     "duration":_loc2_.effect.duration
                  };
                  param1.setBattleDebuff(_loc34_);
                  _loc34_ = {
                     "type":BattleData.EFFECT_FEAR_WEAKEN,
                     "duration":_loc2_.effect.duration,
                     "amount":_loc2_.effect.amount
                  };
                  param1.setBattleDebuff(_loc34_);
                  break;
               case BattleData.EFFECT_STUN_EXPANSION:
                  _loc34_ = {
                     "type":BattleData.EFFECT_STUN,
                     "duration":_loc2_.effect.duration,
                     "amount":_loc2_.effect.amount
                  };
                  param1.setBattleDebuff(_loc34_);
                  break;
               case BattleData.EFFECT_FEAR_WEAKEN_N_STUN:
                  _loc34_ = {
                     "type":BattleData.EFFECT_STUN,
                     "duration":_loc2_.effect.duration,
                     "amount":_loc2_.effect.amount
                  };
                  param1.setBattleDebuff(_loc34_);
                  _loc34_ = {
                     "type":BattleData.EFFECT_FEAR_WEAKEN,
                     "duration":_loc2_.effect.duration,
                     "amount":_loc2_.effect.amount
                  };
                  param1.setBattleDebuff(_loc34_);
                  break;
               case BattleData.EFFECT_FEAR_WEAKEN_N_BLEEDING:
                  if(!param1.isBattleBuffActive(BattleData.EFFECT_BURN_HP_CP_FIX_NUM_N_IMMUNITY_BLEEDING))
                  {
                     _loc34_ = {
                        "type":BattleData.EFFECT_BLEEDING,
                        "duration":_loc2_.effect.duration,
                        "amount":_loc2_.effect.amount
                     };
                     param1.setBattleDebuff(_loc34_);
                  }
                  _loc34_ = {
                     "type":BattleData.EFFECT_FEAR_WEAKEN,
                     "duration":_loc2_.effect.duration,
                     "amount":_loc2_.effect.amount
                  };
                  param1.setBattleDebuff(_loc34_);
                  break;
               case BattleData.EFFECT_DMG_BONUS_N_BLEEDING:
                  if(!param1.isBattleBuffActive(BattleData.EFFECT_BURN_HP_CP_FIX_NUM_N_IMMUNITY_BLEEDING))
                  {
                     _loc34_ = {
                        "type":BattleData.EFFECT_BLEEDING,
                        "duration":_loc2_.effect.duration,
                        "amount":_loc2_.effect.amount
                     };
                     param1.setBattleDebuff(_loc34_);
                  }
                  break;
               case BattleData.EFFECT_CP_BLEEDING:
                  if(!param1.isBattleBuffActive(BattleData.EFFECT_BURN_HP_CP_FIX_NUM_N_IMMUNITY_BLEEDING))
                  {
                     param1.setBattleDebuff(_loc2_.effect);
                  }
                  break;
               case BattleData.EFFECT_DRAIN_HP_CP_N_ADD_COOLDOWN:
                  _loc2_.effect.damageHp = Math.abs(this.updateHP(param1,0 - Math.round(param1.hp * int(_loc12_.amount) * 0.01)));
                  _loc2_.effect.damageHp = this.updateHP(this.attacker,_loc2_.effect.damageHp);
                  _loc2_.effect.damageCp = Math.abs(this.updateCP(param1,0 - Math.round(param1.cp * int(_loc12_.amount) * 0.01)));
                  _loc2_.effect.damageCp = this.updateCP(this.attacker,_loc2_.effect.damageCp);
                  this.defender.addAllSkillCooldown(_loc2_.effect.duration);
                  break;
               case BattleData.EFFECT_CLEAR_BUFF_N_DISORIENTED:
                  param1.clearBuff();
                  _loc34_ = {
                     "type":BattleData.EFFECT_PET_DISORIENTED,
                     "duration":_loc2_.effect.duration,
                     "amount":_loc2_.effect.amount
                  };
                  param1.setBattleDebuff(_loc34_);
                  break;
               case BattleData.EFFECT_RAPID_ALLY_SLOW_ENEMY:
                  _loc34_ = {
                     "type":BattleData.EFFECT_REDUCE_AGILITY,
                     "duration":_loc2_.effect.duration,
                     "amount":_loc2_.effect.amount
                  };
                  param1.setBattleDebuff(_loc34_);
                  _loc25_ = 0;
                  while(_loc25_ < characterArr.length)
                  {
                     if(characterArr[_loc25_].isDead == false && characterArr[_loc25_].side == attacker.side)
                     {
                        _loc34_ = {
                           "type":BattleData.EFFECT_AGILITY_BONUS_FIX,
                           "duration":_loc2_.effect.duration,
                           "amount":_loc2_.effect.amount
                        };
                        this.setBuff(characterArr[_loc25_],_loc34_);
                     }
                     _loc25_++;
                  }
                  break;
               case BattleData.EFFECT_DISPERSE_N_ADD_ALL_COOLDOWN:
                  param1.clearBuff();
                  param1.addAllSkillCooldown(_loc2_.effect.amount);
                  break;
               case BattleData.EFFECT_REDUCE_AGI_STUN:
                  _loc34_ = {
                     "type":BattleData.EFFECT_REDUCE_AGILITY,
                     "duration":_loc2_.effect.duration,
                     "amount":_loc2_.effect.amount
                  };
                  param1.setBattleDebuff(_loc34_);
                  _loc34_ = {
                     "type":BattleData.EFFECT_STUN,
                     "duration":_loc2_.effect.duration
                  };
                  param1.setBattleDebuff(_loc34_);
                  break;
               case BattleData.EFFECT_DAMAGE_BONUS_N_BLIND:
                  _loc34_ = {
                     "type":BattleData.EFFECT_DAMAGE_BONUS,
                     "duration":_loc2_.effect.duration,
                     "amount":_loc2_.effect.amount
                  };
                  _loc2_.attackerBuff.push(_loc34_);
                  _loc34_ = {
                     "type":BattleData.EFFECT_BLIND,
                     "duration":_loc2_.effect.duration,
                     "amount":_loc2_.effect.amount
                  };
                  _loc2_.defenderDebuff.push(_loc34_);
                  break;
               case BattleData.EFFECT_REDUCE_DEFENDER_AGILITY:
                  _loc34_ = {
                     "type":BattleData.EFFECT_REDUCE_AGILITY,
                     "duration":_loc2_.effect.duration,
                     "amount":_loc2_.effect.amount
                  };
                  _loc2_.defenderDebuff.push(_loc34_);
                  break;
               case BattleData.EFFECT_REDUCE_AGI_N_PET_WEAKEN:
                  _loc34_ = {
                     "type":BattleData.EFFECT_REDUCE_AGILITY,
                     "duration":_loc2_.effect.duration,
                     "amount":_loc2_.effect.amount
                  };
                  param1.setBattleDebuff(_loc34_);
                  _loc34_ = {
                     "type":BattleData.EFFECT_PET_WEAKEN,
                     "duration":_loc2_.effect.duration,
                     "amount":_loc2_.effect.amount
                  };
                  param1.setBattleDebuff(_loc34_);
                  break;
               case BattleData.EFFECT_PET_DISORIENTED_REDUCE_AGILITY:
                  _loc34_ = {
                     "type":BattleData.EFFECT_REDUCE_AGILITY,
                     "duration":_loc2_.effect.duration,
                     "amount":_loc2_.effect.amount
                  };
                  param1.setBattleDebuff(_loc34_);
                  _loc34_ = {
                     "type":BattleData.EFFECT_PET_DISORIENTED,
                     "duration":_loc2_.effect.duration,
                     "amount":_loc2_.effect.amount
                  };
                  param1.setBattleDebuff(_loc34_);
                  _loc47_ = int(param1.agility);
                  _loc47_ = _loc47_ - Math.round(_loc47_ * int(_loc2_.effect.amount) * 0.01);
                  if(_loc47_ < 10)
                  {
                     _loc47_ = 10;
                  }
                  Central.client.getInstance().updateCharacterAgility(param1.getData("character_id"),_loc47_);
                  break;
               case BattleData.EFFECT_COLLIDING_WAVE:
                  _loc34_ = {
                     "type":_loc2_.effect.type,
                     "duration":_loc2_.effect.duration,
                     "amount":_loc2_.effect.amount
                  };
                  param1.setBattleDebuff(_loc34_);
                  _loc34_ = {
                     "type":BattleData.EFFECT_STUN,
                     "duration":_loc2_.effect.duration
                  };
                  param1.setBattleDebuff(_loc34_);
            }
         }
         Out.debug(this,"finiend");
         if(_loc2_.dmg == null)
         {
            _loc2_.dmgArr.push(_loc29_);
            this.attacker.setBattleAction(_loc2_);
            return;
         }
         if(_loc8_ > 0)
         {
            return;
         }
         if(_loc2_.critical)
         {
            _loc8_ *= this.attacker.criticalBonus;
         }
         _loc30_ = 0;
         _loc31_ = 0;
         _loc32_ = Central.main.SKILL_DATA[_loc2_.skillId];
         _loc30_ = this.CalculateBloodlineDamagebonus(_loc2_,_loc12_,_loc32_,_loc8_);
         _loc8_ += _loc30_;
         _loc8_ = calcSenjutsuDamageBonus(_loc8_,this.attacker.getBattleBuff(),this.attacker.getBattleDebuff(),param1.getBattleBuff(),param1.getBattleDebuff());
         if(_loc30_ > 0 && param1.hp > 0 || _loc30_ < 0)
         {
            this.updateHP(param1,_loc30_);
         }
         _loc33_ = this.calculateSkillDamageReduction(_loc2_,_loc12_,_loc32_,_loc8_);
         _loc8_ += _loc33_;
         if(_loc33_ > 0)
         {
            this.updateHP(param1,_loc33_);
         }
         _loc31_ = this.CalculateBloodlineDamageConvert(_loc2_,_loc8_);
         _loc8_ += _loc31_;
         this.updateHP(param1,_loc31_);
         if(this.attackerWeapon)
         {
            for each(_loc34_ in this.attackerWeapon.effect)
            {
               switch(_loc34_.type)
               {
                  case BattleData.EFFECT_DAMAGE_BONUS_WEAPON_FIX_NUM:
                     _loc8_ -= this.updateDamageByHitNum(_loc2_,_loc34_.amount);
                     break;
                  case BattleData.EFFECT_ATTACKER_CRITICAL_DAMAGE_BONUS:
                     if(_loc2_.critical)
                     {
                        _loc8_ *= 1 + _loc34_.amount / 100;
                     }
                     break;
                  case BattleData.EFFECT_ADD_DAMAGE_BONUS:
                     if(_loc2_.action == "weapon_attack")
                     {
                        _loc9_ = NumberUtil.getRandom();
                        if(_loc9_ <= _loc34_.chance / 100)
                        {
                           _loc8_ = Math.round(_loc8_ * (1 + _loc34_.amount / 100));
                        }
                     }
                     else
                     {
                        _loc8_ = Math.round(_loc8_ * (1 + _loc34_.amount / 100));
                     }
                     break;
                  case BattleData.EFFECT_REDUCE_HP_PRESENT:
                     _loc9_ = NumberUtil.getRandom();
                     if(_loc9_ <= _loc34_.chance / 100)
                     {
                        _loc8_ -= Math.round(param1.hp * (_loc34_.amount / 100));
                     }
                     break;
                  case BattleData.EFFECT_INSTANT_KILL_BELOW_HP:
                     _loc52_ = Number(_loc34_.amount);
                     if(_loc2_.action == "weapon_attack")
                     {
                        if(param1.hp / param1.maxHP < _loc52_ / 100)
                        {
                           _loc8_ -= param1.maxHP;
                           _loc2_.weapon_activated = true;
                        }
                     }
                     break;
                  case BattleData.EFFECT_REDUCE_TARGET_CP:
                     if(_loc2_.action == "weapon_attack")
                     {
                        _loc15_ = Math.round(param1.maxCP * (_loc34_.amount / 100));
                        if(_loc15_ <= 0)
                        {
                           _loc15_ = 0;
                        }
                        _loc2_.defenderDamageCp += _loc15_;
                     }
                     break;
                  case BattleData.EFFECT_BLEEDING_WEAKEN:
                     if(_loc2_.action == "weapon_attack")
                     {
                        if(!this.defender.isBattleBuffActive(BattleData.EFFECT_BURN_HP_CP_FIX_NUM_N_IMMUNITY_BLEEDING))
                        {
                           _loc12_ = {
                              "type":BattleData.EFFECT_BLEEDING,
                              "duration":_loc34_.duration,
                              "amount":_loc34_.amount
                           };
                           _loc2_.defenderDebuff.push(_loc12_);
                        }
                        _loc12_ = {
                           "type":BattleData.EFFECT_PET_WEAKEN,
                           "duration":_loc34_.duration,
                           "amount":_loc34_.amount
                        };
                        _loc2_.defenderDebuff.push(_loc12_);
                     }
                     break;
                  case BattleData.EFFECT_REDUCE_TARGET_HP:
                     if(_loc2_.action == "weapon_attack")
                     {
                        _loc16_ = Math.round(param1.maxHP * (_loc34_.amount / 100));
                        if(_loc16_ <= 0)
                        {
                           _loc16_ = 0;
                        }
                        _loc2_.defenderDamageHp += _loc16_;
                     }
                     break;
                  case BattleData.EFFECT_DEFENDER_STUN:
                     if(NumberUtil.getRandom() <= _loc34_.chance / 100 && _loc2_.action == "weapon_attack")
                     {
                        _loc12_ = {
                           "type":BattleData.EFFECT_STUN,
                           "duration":_loc34_.duration,
                           "amount":0
                        };
                        _loc2_.defenderDebuff.push(_loc12_);
                        _loc2_.weapon_activated = true;
                     }
                     break;
                  case BattleData.EFFECT_DRAIN_HP_WEAPON:
                     if(_loc2_.action == "weapon_attack")
                     {
                        _loc19_ = Math.round(param1.maxHP * (_loc34_.amount / 100));
                        _loc19_ = Math.abs(this.updateHP(param1,0 - _loc19_));
                        _loc19_ = this.updateHP(this.attacker,_loc19_);
                        param1.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(482) + String(_loc19_));
                        attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(483) + String(_loc19_));
                     }
                     break;
                  case BattleData.EFFECT_RAMPAGE:
                     if(_loc2_.action == "weapon_attack")
                     {
                        _loc9_ = NumberUtil.getRandom();
                        if(_loc9_ <= _loc34_.chance / 100)
                        {
                           _loc19_ = int(this.attackerWeapon.damage);
                           _loc25_ = 0;
                           while(_loc25_ < this.characterArr.length)
                           {
                              if(this.characterArr[_loc25_].isDead == false && this.characterArr[_loc25_].side != this.attacker.side)
                              {
                                 _loc19_ = Math.abs(this.updateHP(this.characterArr[_loc25_],0 - _loc19_));
                                 this.characterArr[_loc25_].showOverheadNumber(Timeline.WORD,String(_loc19_));
                                 _loc12_ = {
                                    "type":BattleData.EFFECT_STUN,
                                    "duration":_loc34_.duration,
                                    "amount":_loc34_.amount
                                 };
                                 this.setDebuff(this.characterArr[_loc25_],_loc12_);
                              }
                              _loc25_++;
                           }
                        }
                     }
                     break;
                  case BattleData.EFFECT_MAGNETIC_RAY:
                     if(_loc2_.action == "weapon_attack")
                     {
                        _loc9_ = NumberUtil.getRandom();
                        if(_loc9_ <= _loc34_.chance / 100)
                        {
                           _loc25_ = 0;
                           while(_loc25_ < this.characterArr.length)
                           {
                              if(this.characterArr[_loc25_].isDead == false && this.characterArr[_loc25_].side != this.attacker.side)
                              {
                                 _loc19_ = Math.round(this.characterArr[_loc25_].maxHP * (_loc34_.amount / 100));
                                 _loc19_ = Math.abs(this.updateHP(this.characterArr[_loc25_],0 - _loc19_));
                                 this.characterArr[_loc25_].showOverheadNumber(Timeline.WORD,String(_loc19_));
                              }
                              _loc25_++;
                           }
                        }
                     }
                     break;
                  case BattleData.EFFECT_WEAKEN_DMGBONUS_FIX_NUM:
                     if(_loc2_.action == "weapon_attack")
                     {
                        _loc12_ = {
                           "type":BattleData.EFFECT_PET_WEAKEN_FIX_NUM,
                           "duration":_loc34_.duration,
                           "amount":_loc34_.amount
                        };
                        _loc2_.defenderDebuff.push(_loc12_);
                        _loc12_ = {
                           "type":BattleData.EFFECT_DAMAGE_BONUS_FIX_NUM,
                           "duration":_loc34_.duration,
                           "amount":_loc34_.amount
                        };
                        _loc2_.attackerBuff.push(_loc12_);
                     }
                     break;
                  case BattleData.EFFECT_DRAIN_CP:
                     if(_loc2_.action == "weapon_attack")
                     {
                        _loc20_ = Math.round(param1.maxCP * (_loc34_.amount / 100));
                        _loc20_ = Math.abs(this.updateCP(param1,0 - _loc20_));
                        _loc20_ = this.updateCP(this.attacker,_loc20_);
                        param1.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(349) + String(_loc20_));
                        attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(350) + String(_loc20_));
                     }
                     break;
                  case BattleData.EFFECT_WEAPON_DISMANTLE:
                     if(_loc2_.action == "weapon_attack")
                     {
                        _loc9_ = NumberUtil.getRandom();
                        if(_loc9_ <= _loc34_.chance / 100)
                        {
                           _loc12_ = {
                              "type":BattleData.EFFECT_DISMANTLE,
                              "duration":_loc34_.duration,
                              "amount":_loc34_.amount
                           };
                           _loc2_.defenderDebuff.push(_loc12_);
                        }
                     }
                     break;
                  case BattleData.EFFECT_WEAPON_BURN_REDUCE_TARGET_CP:
                     _loc53_ = this.defender.getBattleDebuff();
                     if(_loc2_.action == "weapon_attack")
                     {
                        for(_loc10_ in _loc53_)
                        {
                           _loc12_ = _loc53_[_loc10_];
                           if(_loc53_[_loc10_])
                           {
                              if(_loc12_.type == BattleData.EFFECT_DOUBLE_BURN)
                              {
                                 _loc20_ = Math.round(param1.maxCP * (_loc34_.amount / 100));
                                 _loc20_ = Math.abs(this.updateCP(param1,0 - _loc20_));
                                 param1.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(349) + String(_loc20_));
                                 break;
                              }
                              if(_loc12_.type == BattleData.EFFECT_BURN_CNNT_PURIFY)
                              {
                                 _loc20_ = Math.round(param1.maxCP * (_loc34_.amount / 100));
                                 _loc20_ = Math.abs(this.updateCP(param1,0 - _loc20_));
                                 param1.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(349) + String(_loc20_));
                                 break;
                              }
                              if(_loc12_.type == BattleData.EFFECT_BURN)
                              {
                                 _loc20_ = Math.round(param1.maxCP * (_loc34_.amount / 100));
                                 _loc20_ = Math.abs(this.updateCP(param1,0 - _loc20_));
                                 param1.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(349) + String(_loc20_));
                                 break;
                              }
                              if(_loc12_.type == BattleData.EFFECT_BURN_FIX_NUM)
                              {
                                 _loc20_ = Math.round(param1.maxCP * (_loc34_.amount / 100));
                                 _loc20_ = Math.abs(this.updateCP(param1,0 - _loc20_));
                                 param1.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(349) + String(_loc20_));
                                 break;
                              }
                              if(_loc12_.type == BattleData.EFFECT_BURNING)
                              {
                                 _loc20_ = Math.round(param1.maxCP * (_loc34_.amount / 100));
                                 _loc20_ = Math.abs(this.updateCP(param1,0 - _loc20_));
                                 param1.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(349) + String(_loc20_));
                                 break;
                              }
                              if(_loc12_.type == BattleData.EFFECT_PET_BURN)
                              {
                                 _loc20_ = Math.round(param1.maxCP * (_loc34_.amount / 100));
                                 _loc20_ = Math.abs(this.updateCP(param1,0 - _loc20_));
                                 param1.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(349) + String(_loc20_));
                                 break;
                              }
                           }
                        }
                     }
                     break;
                  case BattleData.EFFECT_WEAPON_EXPLODE:
                     _loc54_ = {};
                     _loc53_ = this.defender.getBattleDebuff();
                     if(_loc2_.action == "weapon_attack")
                     {
                        _loc9_ = NumberUtil.getRandom();
                        if(_loc9_ <= _loc34_.chance / 100)
                        {
                           for(_loc10_ in _loc53_)
                           {
                              _loc12_ = _loc53_[_loc10_];
                              if(_loc53_[_loc10_])
                              {
                                 if(_loc12_.type == BattleData.EFFECT_DOUBLE_BURN && candoburn == true)
                                 {
                                    _loc12_.amount *= _loc34_.amount;
                                    _loc54_[_loc10_] = _loc12_;
                                    _loc2_.candoburn = true;
                                    candoburn = false;
                                 }
                                 else if(_loc12_.type == BattleData.EFFECT_BURN_CNNT_PURIFY && cancntpurlfyburn == true)
                                 {
                                    _loc12_.amount *= _loc34_.amount;
                                    _loc54_[_loc10_] = _loc12_;
                                    _loc2_.cancntpurlfyburn = true;
                                    cancntpurlfyburn = false;
                                 }
                                 else if(_loc12_.type == BattleData.EFFECT_BURN && canburn == true)
                                 {
                                    _loc12_.amount *= _loc34_.amount;
                                    _loc54_[_loc10_] = _loc12_;
                                    _loc2_.canburn = true;
                                    canburn = false;
                                 }
                                 else if(_loc12_.type == BattleData.EFFECT_BURN_FIX_NUM && canburnnum == true)
                                 {
                                    _loc12_.amount *= _loc34_.amount;
                                    _loc54_[_loc10_] = _loc12_;
                                    _loc2_.canburnnum = true;
                                    canburnnum = false;
                                 }
                                 else if(_loc12_.type == BattleData.EFFECT_BURNING && canburning == true)
                                 {
                                    _loc12_.amount *= _loc34_.amount;
                                    _loc54_[_loc10_] = _loc12_;
                                    _loc2_.canburning = true;
                                    canburning = false;
                                 }
                                 else if(_loc12_.type == BattleData.EFFECT_PET_BURN && canpetburn == true)
                                 {
                                    _loc12_.amount *= _loc34_.amount;
                                    _loc54_[_loc10_] = _loc12_;
                                    _loc2_.canpetburn = true;
                                    canpetburn = false;
                                 }
                              }
                           }
                        }
                     }
                     break;
                  case BattleData.EFFECT_CRITICAL_STUN:
                     if(_loc2_.critical)
                     {
                        _loc9_ = NumberUtil.getRandom();
                        if(_loc9_ < _loc34_.chance / 100 && _loc2_.stun == true)
                        {
                           _loc2_.critical_stun = true;
                           _loc12_ = {
                              "type":BattleData.EFFECT_STUN,
                              "duration":_loc34_.duration,
                              "amount":_loc34_.amount
                           };
                           _loc2_.defenderDebuff.push(_loc12_);
                           _loc2_.effect = this.setDebuff(param1,_loc12_);
                        }
                        else
                        {
                           _loc2_.critical_stun = false;
                        }
                     }
                     break;
                  case BattleData.EFFECT_CRITICAL_ADD_HP_PERCENT:
                     if(_loc2_.critical)
                     {
                        _loc2_.attackerRestoreHp += Math.round(this.attacker.maxHP * (_loc34_.amount / 100));
                     }
                     break;
                  case BattleData.EFFECT_CRITICAL_DAMAGE_BONUS_WEAPON_FIX_NUM:
                     if(_loc2_.critical)
                     {
                        _loc8_ -= _loc34_.amount;
                     }
                     break;
                  case BattleData.EFFECT_CRITICAL_SUCCESS_TO_ADD_CHANCE:
                     if(_loc2_.critical)
                     {
                        _loc12_ = {
                           "type":BattleData.EFFECT_CRITICAL_CHANCE_BONUS,
                           "duration":_loc34_.duration,
                           "amount":_loc34_.amount
                        };
                        _loc2_.attackerBuff.push(_loc12_);
                     }
               }
            }
            if(Boolean(this.attackerWeapon.extra_effect) && this.attackerWeapon.extra_effect != null)
            {
               _loc26_ = [];
               _loc34_ = this.attackerWeapon.extra_effect;
               _loc25_ = 0;
               while(_loc25_ < _loc34_.enemy.length)
               {
                  _loc26_.push(Central.main.ENEMY_DATA.find(_loc34_.enemy[_loc25_]).name);
                  _loc25_++;
               }
               if(defender.type == 4 && _loc26_.indexOf(param1.getCharacterName()) >= 0)
               {
                  switch(_loc34_.type)
                  {
                     case BattleData.EFFECT_BURN_CP:
                        _loc2_.defenderDamageCp += Math.round(defender.maxCP * int(_loc34_.amount) * 0.01);
                        break;
                     case BattleData.EFFECT_DOUBLE_BURN:
                     case BattleData.EFFECT_BURN_HP:
                     case BattleData.EFFECT_BURN_HP_N_INTERNAL_INJURY:
                        _loc29_.defenderDamageHp += Math.round(param1.maxHP * int(_loc34_.amount) * 0.01);
                  }
               }
            }
         }
         if(param1.getWeapon())
         {
            _loc55_ = Central.main.WEAPON_DATA.find(param1.getWeapon());
            if(_loc55_)
            {
               for each(_loc34_ in _loc55_.effect)
               {
                  switch(_loc34_.type)
                  {
                     case BattleData.EFFECT_REDUCE_DAMAGE_BONUS:
                        _loc8_ += _loc34_.amount;
                        if(_loc8_ > 0)
                        {
                           _loc8_ = 0;
                        }
                        break;
                     case BattleData.EFFECT_ATTACKER_BLIND:
                        _loc12_ = {};
                        _loc12_.type = BattleData.EFFECT_BLIND;
                        _loc12_.duration = int(_loc34_.duration);
                        _loc12_.amount = int(_loc34_.amount);
                        _loc2_.attackerDebuff.push(_loc12_);
                        break;
                     case BattleData.EFFECT_WEAPON_MANA_SHIELD:
                        _loc14_ = Math.round(_loc8_ * (_loc34_.amount / 100));
                        _loc15_ = Math.round(Math.abs(_loc14_) / 2);
                        if(param1.isBattleBuffActive(BloodlineData.EFFECT_SKIP_DEAD_CLEAR_DEBUFF))
                        {
                           _loc15_ = 0;
                        }
                        if(param1.cp >= _loc15_)
                        {
                           _loc2_.defenderDamageCp += _loc15_;
                        }
                        _loc8_ -= _loc14_;
                        break;
                     case BattleData.EFFECT_REDUCE_DAMAGE_BONUS_PRESENT:
                        _loc4_ = 0;
                        if(_loc55_.id == "wpn1596" && Boolean(param1))
                        {
                           _loc3_ = int(Central.main.stateInventory.getStateOnCount(param1.getCharacterId(),"wpn","wpn1596"));
                           if(_loc3_ >= 0)
                           {
                              _loc4_ = _loc3_;
                           }
                        }
                        _loc8_ = Math.round(_loc8_ * (1 - (_loc34_.amount + 5 * _loc4_) / 100));
                        break;
                     case BattleData.EFFECT_REDUCE_DAMAGE_AMOUNT:
                        _loc8_ = Math.round(_loc8_ * (_loc34_.amount / 100));
                  }
               }
            }
         }
         _loc35_ = {"dmg":_loc8_};
         _loc8_ = int(_loc35_.dmg);
         if(this.attackerBackItem)
         {
            for each(_loc34_ in this.attackerBackItem.effect)
            {
               switch(_loc34_.type)
               {
                  case BattleData.EFFECT_ATTACKER_DAMAGE_BONUS:
                     _loc8_ = Math.round(_loc8_ * (1 + _loc34_.amount / 100));
                     break;
                  case BattleData.EFFECT_ATTACKER_CRITICAL_DAMAGE_BONUS:
                     if(_loc2_.critical)
                     {
                        _loc8_ *= 1 + _loc34_.amount / 100;
                     }
                     break;
                  case BattleData.EFFECT_DAMAGE_BONUS_FIX_NUM:
                     _loc8_ -= this.updateDamageByHitNum(_loc2_,_loc34_.amount);
               }
            }
         }
         if(this.attackerAccessory)
         {
            for each(_loc34_ in this.attackerAccessory.effect)
            {
               switch(_loc34_.type)
               {
                  case BattleData.EFFECT_ATTACKER_DAMAGE_BONUS:
                     _loc8_ = Math.round(_loc8_ * (1 + _loc34_.amount / 100));
                     break;
                  case BattleData.EFFECT_ATTACKER_CRITICAL_DAMAGE_BONUS:
                     if(_loc2_.critical)
                     {
                        _loc8_ *= 1 + _loc34_.amount / 100;
                     }
                     break;
                  case BattleData.EFFECT_DAMAGE_BONUS_FIX_NUM:
                     _loc8_ -= this.updateDamageByHitNum(_loc2_,_loc34_.amount);
               }
            }
            if(Boolean(this.attackerAccessory.extra_effect) && this.attackerAccessory.extra_effect != null)
            {
               _loc26_ = [];
               _loc34_ = this.attackerAccessory.extra_effect;
               _loc25_ = 0;
               while(_loc25_ < _loc34_.enemy.length)
               {
                  _loc26_.push(Central.main.ENEMY_DATA.find(_loc34_.enemy[_loc25_]).name);
                  _loc25_++;
               }
               if(defender.type == 4 && _loc26_.indexOf(param1.getCharacterName()) >= 0)
               {
                  switch(_loc34_.type)
                  {
                     case BattleData.EFFECT_DOUBLE_BURN:
                     case BattleData.EFFECT_BURN_HP:
                     case BattleData.EFFECT_BURN_HP_N_INTERNAL_INJURY:
                        _loc29_.defenderDamageHp += Math.round(param1.maxHP * int(_loc34_.amount) * 0.01);
                  }
               }
            }
         }
         if(this.attacker.getBloodlineEffect())
         {
            for each(_loc34_ in this.attacker.getBloodlineEffect())
            {
               switch(_loc34_.type)
               {
                  case BloodlineData.EFFECT_ADD_DMG_BONUS_RELATE_CP:
                     _loc8_ -= Math.round(this.attacker.maxCP * _loc34_.amount * 0.01);
               }
            }
         }
         if(param1.getBackItem())
         {
            _loc56_ = Central.main.BACK_ITEM_DATA.find(param1.getBackItem());
            if(_loc56_)
            {
               for each(_loc34_ in _loc56_.effect)
               {
                  switch(_loc34_.type)
                  {
                     case BattleData.EFFECT_REDUCE_DAMAGE_AMOUNT:
                        _loc8_ -= Math.round(_loc8_ * (_loc34_.amount / 100));
                        break;
                     case BattleData.EFFECT_REDUCE_DAMAGE_BONUS:
                        _loc8_ += _loc34_.amount;
                        if(_loc8_ > 0)
                        {
                           _loc8_ = 0;
                        }
                        break;
                     case BattleData.EFFECT_REDUCE_DAMAGE_BONUS_PRESENT:
                        _loc8_ = Math.round(_loc8_ * (1 - _loc34_.amount / 100));
                  }
               }
            }
            if(Boolean(_loc56_.extra_effect) && _loc56_.extra_effect != null)
            {
               _loc26_ = [];
               _loc34_ = _loc56_.extra_effect;
               _loc25_ = 0;
               while(_loc25_ < _loc34_.enemy.length)
               {
                  _loc26_.push(Central.main.ENEMY_DATA.find(_loc34_.enemy[_loc25_]).name);
                  _loc25_++;
               }
               if(defender.type == 1 && _loc26_.indexOf(this.attacker.getCharacterName()) >= 0)
               {
                  switch(_loc34_.type)
                  {
                     case BattleData.EFFECT_REDUCE_DAMAGE_BONUS_PRESENT:
                        _loc8_ = Math.round(_loc8_ * (1 - _loc34_.amount / 100));
                  }
               }
            }
         }
         if(param1.getAccessory())
         {
            _loc27_ = Central.main.ACCESSORY_DATA.find(param1.getAccessory());
            if(_loc27_)
            {
               for each(_loc34_ in _loc27_.effect)
               {
                  switch(_loc34_.type)
                  {
                     case BattleData.EFFECT_REDUCE_DAMAGE_AMOUNT:
                        _loc8_ -= Math.round(_loc8_ * (_loc34_.amount / 100));
                        break;
                     case BattleData.EFFECT_REDUCE_DAMAGE_BONUS:
                        _loc8_ += _loc34_.amount;
                        if(_loc8_ > 0)
                        {
                           _loc8_ = 0;
                        }
                        break;
                     case BattleData.EFFECT_REDUCE_DAMAGE_BONUS_PRESENT:
                        _loc8_ = Math.round(_loc8_ * (1 - _loc34_.amount / 100));
                        break;
                     case BattleData.EFFECT_GUARD_BELOW_DAMAGE:
                        if(param1.hp / param1.maxHP < _loc34_.amount / 100 && NumberUtil.getRandom() <= _loc34_.chance / 100)
                        {
                           _loc8_ = 0;
                        }
                  }
               }
            }
         }
         if(param1.getBloodlineEffect())
         {
            for each(_loc34_ in param1.getBloodlineEffect())
            {
               switch(_loc34_.type)
               {
                  case BloodlineData.EFFECT_REDUCE_DMG_BY_CP_PERCENT:
                     _loc8_ += Math.round(Math.abs(_loc8_) * (1 - param1.cp / param1.maxCP) * _loc34_.amount * 0.01);
                     break;
                  case BloodlineData.EFFECT_DMG_REDUCTION:
                     _loc8_ += Math.round(Math.abs(_loc8_) * _loc34_.amount * 0.01);
               }
            }
         }
         if(param1.getGearset())
         {
            _loc13_ = param1.getGearset();
            for(_loc10_ in _loc13_)
            {
               _loc57_ = Central.main.GEAR_SET_DATA.find(_loc10_);
               _loc25_ = 0;
               while(_loc25_ < _loc13_[_loc10_] - 1)
               {
                  _loc58_ = _loc57_.effect[_loc25_];
                  switch(_loc58_.type)
                  {
                     case BattleData.EFFECT_REDUCE_DAMAGE_AMOUNT:
                        _loc8_ += Math.round(Math.abs(_loc8_) * _loc58_.amount * 0.01);
                        break;
                     case BattleData.EFFECT_REDUCE_DAMAGE_BONUS:
                        _loc8_ += _loc58_.amount;
                        if(_loc8_ > 0)
                        {
                           _loc8_ = 0;
                        }
                  }
                  _loc25_++;
               }
            }
         }
         if(this.attacker.getGearset())
         {
            _loc59_ = this.attacker.getGearset();
            for(_loc60_ in _loc59_)
            {
               _loc61_ = Central.main.GEAR_SET_DATA.find(_loc60_);
               _loc62_ = 0;
               while(_loc62_ < _loc59_[_loc60_] - 1)
               {
                  _loc63_ = _loc61_.effect[_loc62_];
                  switch(_loc63_.type)
                  {
                     case BattleData.EFFECT_ADD_DAMAGE_BONUS:
                        _loc8_ = Math.round(_loc8_ * (1 + _loc63_.amount / 100));
                        break;
                     case BattleData.EFFECT_DAMAGE_BONUS_FIX_NUM:
                        _loc8_ -= _loc63_.amount;
                        break;
                     case BattleData.EFFECT_ATTACKER_CRITICAL_DAMAGE_BONUS:
                        if(_loc2_.critical)
                        {
                           _loc8_ *= 1 + _loc63_.amount / 100;
                        }
                     case BattleData.EFFECT_REDUCE_HP_PRESENT:
                        _loc9_ = NumberUtil.getRandom();
                        if(_loc9_ <= _loc34_.chance / 100)
                        {
                           _loc8_ -= Math.round(param1.hp * (_loc63_.amount / 100));
                        }
                  }
                  _loc62_++;
               }
            }
         }
         _loc36_ = this.attacker.getBattleBuff();
         _loc37_ = this.attacker.getBattleDebuff();
         _loc38_ = param1.getBattleBuff();
         _loc39_ = param1.getBattleDebuff();
         for(_loc10_ in _loc36_)
         {
            if(!_loc36_[_loc10_])
            {
               continue;
            }
            if(int(_loc36_[_loc10_].duration) <= 0)
            {
               continue;
            }
            switch(_loc10_)
            {
               case BattleData.EFFECT_DAMAGE_BONUSA:
               case BattleData.EFFECT_DAMAGE_BONUS:
               case BattleData.EFFECT_TURKEY_FEAST:
               case BattleData.SKILL_501:
               case BattleData.EFFECT_PUMPKIN_POWER:
               case BattleData.EFFECT_HEAL_HP_N_DMG_BONUS_GASHADOKURO:
               case BattleData.EFFECT_HEAL_HP_N_DMG_BONUS:
               case BattleData.EFFECT_HEAL_HP_N_DMG_BONUS_UPGRADE:
                  _loc8_ -= Math.round(Math.abs(_loc8_) * (_loc36_[_loc10_].amount / 100));
                  break;
               case SenjutsuData.EFFECT_SS_DAMAGE_BONUS:
                  Out.debug(this,"EFFECT_SS_DAMAGE_BONUS dmg before >> " + _loc8_);
                  _loc8_ -= Math.round(Math.abs(_loc8_) * (_loc36_[_loc10_].amount / 100));
                  Out.debug(this,"EFFECT_SS_DAMAGE_BONUS dmg after >> " + _loc8_);
                  break;
               case BattleData.EFFECT_EXPANSION:
                  _loc8_ -= Math.round(Math.abs(_loc8_) * (_loc36_[_loc10_].amount / 100));
                  break;
               case BattleData.EFFECT_DAMAGE_BONUS_BY_SP:
                  Out.debug(this,"EFFECT_DAMAGE_BONUS_BY_SP dmg before >> " + _loc8_);
                  _loc8_ -= Math.round(Math.abs(this.attacker.maxSP) * (_loc36_[_loc10_].amount / 100));
                  Out.debug(this,"EFFECT_DAMAGE_BONUS_BY_SP dmg after >> " + _loc8_);
                  break;
               case BattleData.EFFECT_DAMAGE_BONUS_FIX_NUM:
                  _loc8_ -= _loc36_[_loc10_].amount;
                  break;
               case BattleData.EFFECT_GATE_OPENING:
                  _loc8_ -= Math.round(Math.abs(_loc8_) * 0.5);
                  break;
               case BattleData.EFFECT_FRENZY:
                  _loc8_ -= Math.round(Math.abs(_loc8_) * 0.2);
                  break;
               case BattleData.EFFECT_BUNNY_FRENZY:
                  _loc8_ += _loc8_;
                  break;
               case BattleData.EFFECT_BATTLE_BUNNY_FRENZY:
                  _loc8_ -= Math.round(Math.abs(_loc8_) * 0.25);
                  break;
               case BattleData.EFFECT_THUNDERSTORM_MODE:
                  _loc8_ -= Math.round(Math.abs(_loc8_) * (_loc36_[_loc10_].amount / 100));
                  break;
               case BattleData.EFFECT_BERSERKER_MODE:
                  _loc8_ -= Math.round(Math.abs(_loc8_) * (_loc36_[_loc10_].amount / 100));
                  break;
               case BattleData.EFFECT_AMONG_ROCKS:
                  if(int(_loc36_[_loc10_].duration) == 1)
                  {
                     _loc8_ -= Math.round(Math.abs(_loc8_) * (_loc36_[_loc10_].amount / 100));
                  }
                  break;
               case BattleData.EFFECT_CERBERUS:
                  _loc8_ -= Math.round(Math.abs(_loc8_) * (_loc36_[_loc10_].amount / 100));
                  break;
               case BattleData.EFFECT_PET_DAMAGE_BONUS:
                  _loc8_ -= Math.round(Math.abs(_loc8_) * (_loc36_[_loc10_].amount / 100));
                  break;
               case BattleData.EFFECT_CATALYTIC_MATTER:
                  _loc8_ -= Math.round(Math.abs(_loc8_) * (_loc36_[_loc10_].amount / 100));
                  break;
               case BattleData.EFFECT_PET_LIGHTNING:
                  _loc8_ -= Math.round(Math.abs(_loc8_) * (_loc36_[_loc10_].amount / 100));
                  break;
               case BattleData.EFFECT_ATTACK_MODE:
                  _loc8_ -= Math.round(Math.abs(_loc8_) * 0.5);
                  break;
               case BattleData.EFFECT_DEFENCE_MODE:
                  _loc8_ += Math.round(Math.abs(_loc8_) * 0.5);
                  break;
               case BattleData.SKILL_310:
                  _loc8_ -= _loc36_[_loc10_].amount;
                  break;
               case BattleData.EFFECT_CRIT_CHANCE_DMG:
                  if(_loc2_.critical)
                  {
                     _loc8_ += Math.round(_loc8_ * _loc36_[_loc10_].amount / 100);
                  }
                  break;
               case BattleData.SKILL_2003:
                  _loc8_ -= Math.round(Math.abs(_loc8_) * (_loc36_[_loc10_].amount / 100));
                  break;
               case BattleData.EFFECT_DAMAGE_BONUS_WEAPON:
                  _loc8_ -= Math.round(Math.abs(_loc8_) * (_loc36_[_loc10_].amount / 100));
                  break;
               case SenjutsuData.EFFECT_SS_CRITICAL_DMG_BONUS:
                  if(attacker.hp * 100 / attacker.maxHP < _loc36_[_loc10_].amount && Boolean(_loc2_.critical))
                  {
                     Out.debug(this,"EFFECT_SS_CRITICAL_DMG_BONUS dmg before >> " + _loc8_);
                     _loc8_ = Math.round(_loc8_ * (1 + _loc36_[_loc10_].chancetoeffect / 100));
                     Out.debug(this,"EFFECT_SS_CRITICAL_DMG_BONUS dmg after >> " + _loc8_);
                  }
                  break;
               case BloodlineData.EFFECT_DMG_BONUS_AND_DODGE_REDUCTION:
                  _loc8_ -= Math.round(Math.abs(_loc8_) * (_loc36_[_loc10_].amount / 100));
                  break;
               case BattleData.EFFECT_CRITICAL_DMG_BONUS:
                  if(_loc2_.critical)
                  {
                     _loc8_ -= Math.round(Math.abs(_loc8_) * _loc36_[_loc10_].amount * 0.01);
                  }
                  break;
               case BattleData.EFFECT_DMG_BONUS_N_REDUCTION_FIX:
                  _loc8_ -= _loc36_[_loc10_].amount;
                  break;
               case BattleData.EFFECT_BERSERKER_BUFF:
                  _loc8_ -= Math.round(Math.abs(_loc8_) * _loc36_[_loc10_].amount * 0.01);
                  break;
               case BattleData.EFFECT_DMG_BONUS_N_REDUCTION:
                  _loc8_ -= Math.round(Math.abs(_loc8_) * _loc36_[_loc10_].amount * 0.01);
            }
         }
         for(_loc10_ in _loc37_)
         {
            if(!_loc37_[_loc10_])
            {
               continue;
            }
            if(int(_loc37_[_loc10_].duration) <= 0)
            {
               continue;
            }
            switch(_loc10_)
            {
               case BattleData.EFFECT_DAMAGE_REDUCTIONA:
               case BattleData.EFFECT_DAMAGE_REDUCTION:
                  _loc8_ += Math.round(Math.abs(_loc8_) * (_loc37_[_loc10_].amount / 100));
                  break;
               case BattleData.EFFECT_FEAR_WEAKEN:
                  if(int(_loc37_[_loc10_].amount) > 0)
                  {
                     _loc8_ -= int(Math.round(_loc8_ * (int(_loc37_[_loc10_].amount) / 100)));
                  }
                  else
                  {
                     _loc8_ = int(Math.round(_loc8_ * 0.85));
                  }
                  break;
               case BattleData.EFFECT_INTERNAL_INJURY_FEAR_WEAKEN:
                  _loc8_ -= int(Math.round(_loc8_ * (int(_loc37_[_loc10_].amount) / 100)));
                  break;
               case BattleData.EFFECT_PET_FEAR_WEAKEN:
                  _loc8_ = Math.round(_loc8_ * ((100 - _loc37_[_loc10_].amount) / 100));
                  break;
               case BattleData.EFFECT_ECSTATIC_SOUND:
                  _loc8_ -= _loc8_ * (_loc37_[_loc10_].amount / 100);
                  break;
               case BattleData.EFFECT_LIGHTING_BUNDLE:
               case BattleData.EFFECT_LIGHTING_BUNDLE_2:
                  _loc11_ = Math.round(this.attacker.maxCP * (8 / 100));
                  _loc2_.attackerDamageCp += _loc11_;
                  break;
               case BattleData.EFFECT_LIGHTING_BUNDLE_3:
               case BattleData.EFFECT_LIGHTING_BUNDLE_4:
                  _loc11_ = Math.round(this.attacker.maxCP * (9 / 100));
                  _loc2_.attackerDamageCp += _loc11_;
                  break;
               case BattleData.EFFECT_DARK_CURSE:
                  _loc8_ = Math.round(_loc8_ * 0.9);
                  break;
               case BattleData.EFFECT_LIGHT_IMPLUSE:
                  if(_loc2_.critical)
                  {
                     _loc8_ = Math.round(_loc8_ * 0.75);
                  }
                  break;
               case BattleData.EFFECT_THEFT_HP:
                  if(this.battleMemVariables.mem_theft_hp)
                  {
                     _loc29_.defenderRestoreHp += this.battleMemVariables.mem_theft_hp;
                  }
                  break;
               case BattleData.EFFECT_HAMSTRING:
                  if(_loc2_.critical)
                  {
                     _loc8_ = Math.round(_loc8_ / 1.5 * (1.5 - _loc37_[_loc10_].amount));
                  }
                  break;
               case BattleData.EFFECT_PET_WEAKEN:
                  _loc8_ = Math.round(_loc8_ * (1 - int(_loc37_[_loc10_].amount) / 100));
                  break;
               case BattleData.EFFECT_PET_WEAKEN_FIX_NUM:
                  _loc8_ += this.updateDamageByHitNum(_loc2_,_loc37_[_loc10_].amount);
                  if(_loc8_ > 0)
                  {
                     _loc8_ = 0;
                  }
                  break;
               case BattleData.SKILL_311:
                  _loc11_ = int(_loc37_[_loc10_].amount);
                  _loc2_.attackerDamageCp += _loc11_;
                  break;
               case BattleData.SKILL_342:
                  _loc8_ = Math.round(_loc8_ * (1 - int(_loc37_[_loc10_].amount) / 100));
                  break;
               case BattleData.EFFECT_REDUCE_CP_DAMAGE:
               case BattleData.SKILL_359:
                  _loc8_ -= _loc8_ * (_loc37_[_loc10_].amount / 100);
                  break;
               case BattleData.EFFECT_CLEARBUFF_DAMAGEREDUCTION:
                  _loc8_ += Math.round(Math.abs(_loc8_) * (_loc37_[_loc10_].amount / 100));
            }
         }
         for(_loc10_ in _loc38_)
         {
            if(!_loc38_[_loc10_])
            {
               continue;
            }
            if(int(_loc38_[_loc10_].duration) <= 0)
            {
               continue;
            }
            _loc12_ = _loc38_[_loc10_];
            switch(_loc10_)
            {
               case SenjutsuData.EFFECT_SS_BURN_HP_CP_SP:
                  _loc64_ = this.attacker.maxHP * (_loc38_[_loc10_].amount / 100);
                  _loc65_ = this.attacker.maxCP * (_loc38_[_loc10_].amount / 100);
                  _loc66_ = this.attacker.maxSP * (_loc38_[_loc10_].amount / 100);
                  _loc2_.attackerDamageHp += int(_loc64_);
                  _loc2_.attackerDamageCp += int(_loc65_);
                  _loc2_.attackerDamageSp += int(_loc66_);
                  break;
               case BattleData.EFFECT_RECV_DMG_BLEEDING_DMG_REDUCTION:
                  _loc8_ += Math.round(Math.abs(_loc8_) * (_loc38_[_loc10_].amount / 100));
                  _loc34_ = {
                     "type":BattleData.EFFECT_BLEEDING,
                     "amount":40,
                     "duration":2
                  };
                  this.attacker.setBattleDebuff(_loc34_);
                  _loc2_.attackerDamageHp += Math.abs(_loc38_[_loc10_].amount * 4);
                  break;
               case BattleData.EFFECT_DAMAGE_REDUCTIONA:
               case BattleData.EFFECT_DAMAGE_REDUCTION:
               case BattleData.EFFECT_EXPANSION:
                  _loc8_ += Math.round(Math.abs(_loc8_) * (_loc38_[_loc10_].amount / 100));
                  break;
               case BattleData.EFFECT_PUMPKIN_POWER:
                  _loc8_ += Math.round(Math.abs(_loc8_) * (_loc38_[_loc10_].amount / 100));
                  break;
               case BattleData.EFFECT_FRENZY:
                  _loc8_ = Math.round(_loc8_ * 1.2);
                  break;
               case BattleData.EFFECT_BUNNY_FRENZY:
                  _loc8_ = Math.round(_loc8_ * 1.2);
                  break;
               case BattleData.EFFECT_BATTLE_BUNNY_FRENZY:
                  break;
               case BattleData.EFFECT_PET_DAMAGE_REDUCTION:
                  _loc8_ += Math.round(Math.abs(_loc8_) * (_loc38_[_loc10_].amount / 100));
                  break;
               case BattleData.EFFECT_PET_REFLECT_ATTACK:
                  _loc12_ = {
                     "type":BattleData.EFFECT_PET_BURN,
                     "duration":2,
                     "amount":int(_loc38_[_loc10_].amount)
                  };
                  canpetburn = true;
                  _loc2_.attackerDebuff.push(_loc12_);
                  break;
               case BattleData.EFFECT_ATTACK_MODE:
                  _loc8_ -= Math.round(Math.abs(_loc8_) * 0.5);
                  break;
               case BattleData.EFFECT_DEFENCE_MODE:
                  _loc8_ += Math.round(Math.abs(_loc8_) * 0.5);
                  break;
               case BattleData.SKILL_307:
                  _loc8_ = 0;
                  break;
               case BattleData.SKILL_285:
                  param1.reduceSkillCooldown(_loc38_[_loc10_].amount,BattleData.REDUCETYPE_SKILL,SkillData.TYPE_WIND);
                  break;
               case BattleData.SKILL_251:
                  _loc8_ = Math.round(_loc8_ * (100 - _loc38_[_loc10_].amount) / 100);
                  break;
               case BattleData.EFFECT_SERENE_MIND_DMGBONUS:
                  _loc17_ = int(_loc38_[_loc10_].amount) / 100;
                  _loc18_ = Math.round(Math.abs(_loc8_) * _loc17_);
                  _loc8_ += _loc18_;
                  _loc2_.attackerDamageHp += Math.abs(_loc18_);
                  break;
               case BattleData.SKILL_335:
                  _loc17_ = int(_loc38_[_loc10_].amount) / 100;
                  _loc18_ = Math.round(Math.abs(_loc8_) * _loc17_);
                  _loc8_ += _loc18_;
                  _loc2_.attackerDamageHp += Math.abs(_loc18_);
                  break;
               case BattleData.SKILL_268:
                  _loc2_.attackerDamageCp += Math.round(this.attacker.cp * 0.1);
                  break;
               case BattleData.SKILL_268_2:
                  _loc2_.attackerDamageCp += Math.round(this.attacker.cp * 0.15);
                  break;
               case BattleData.EFFECT_PET_DAMAGE_TO_CP:
                  _loc11_ = Math.round(Math.abs(_loc8_) * (int(_loc38_[_loc10_].amount) / 100));
                  _loc2_.defenderRestoreCp += _loc11_;
                  break;
               case BloodlineData.EFFECT_SKIP_DEAD_CLEAR_DEBUFF:
                  _loc8_ = 0;
                  break;
               case BattleData.EFFECT_RECEIVED_DMG_BLEEDING:
                  _loc2_.attackerDamageHp = _loc12_.amount;
                  if(!this.attacker.isBattleBuffActive(BattleData.EFFECT_BURN_HP_CP_FIX_NUM_N_IMMUNITY_BLEEDING))
                  {
                     _loc34_ = {
                        "type":BattleData.EFFECT_BLEEDING,
                        "amount":40,
                        "duration":2
                     };
                     this.attacker.setBattleDebuff(_loc34_);
                  }
                  break;
               case BattleData.EFFECT_DISORIENTED_BURN_HP:
                  _loc2_.attackerDamageHp = this.attacker.maxHP * (_loc38_[_loc10_].amount / 100);
                  _loc34_ = {
                     "type":BattleData.EFFECT_PET_DISORIENTED,
                     "amount":_loc38_[_loc10_].amount * 4,
                     "duration":2
                  };
                  this.attacker.setBattleDebuff(_loc34_);
                  break;
               case BattleData.EFFECT_DEFENDER_BURNING:
                  _loc34_ = {
                     "type":BattleData.EFFECT_BURNING,
                     "amount":_loc12_.amount,
                     "duration":2
                  };
                  canburning = true;
                  this.attacker.setBattleDebuff(_loc34_);
                  break;
               case BattleData.EFFECT_RECEIVED_DMG_STUN:
                  _loc34_ = {
                     "type":BattleData.EFFECT_STUN,
                     "duration":2
                  };
                  this.attacker.setBattleDebuff(_loc34_);
                  break;
               case BattleData.EFFECT_RECEIVED_DMG_REDUCE_AGI:
                  _loc34_ = {
                     "type":BattleData.EFFECT_REDUCE_AGILITY,
                     "duration":2,
                     "amount":_loc12_.amount
                  };
                  this.attacker.setBattleDebuff(_loc34_);
                  break;
               case BattleData.EFFECT_SAND_GUARD:
                  _loc2_.defenderRestoreHp += Math.abs(_loc8_) * _loc12_.amount * 0.01;
                  break;
               case BattleData.EFFECT_DMG_BONUS_N_REDUCTION_FIX:
                  _loc8_ += _loc12_.amount;
                  if(_loc8_ > 0)
                  {
                     _loc8_ = 0;
                  }
                  break;
               case BattleData.EFFECT_DMG_BONUS_N_REDUCTION:
                  _loc8_ += Math.round(Math.abs(_loc8_) * _loc12_.amount * 0.01);
            }
         }
         for(_loc10_ in _loc39_)
         {
            Out.debug(this,"processDamage :: defenderDebuff.key >> " + _loc10_);
            if(!_loc39_[_loc10_])
            {
               continue;
            }
            if(_loc39_[_loc10_].duration <= 0)
            {
               continue;
            }
            switch(_loc10_)
            {
               case BattleData.EFFECT_CP_BLEEDING:
                  if(deductCP == true)
                  {
                     _loc2_.defenderDamageCp = this.updateCP(param1,0 - Math.round(param1.cp * int(_loc39_[_loc10_].amount) * 0.01));
                  }
                  deductCP = true;
                  break;
               case BattleData.EFFECT_TEARING:
                  _loc8_ += int(Math.round(_loc8_ * Number(int(_loc39_[_loc10_].amount) / 100) * 5));
                  break;
               case BattleData.EFFECT_BLEEDING:
               case BattleData.EFFECT_PET_BLEEDING:
               case BattleData.EFFECT_ACCUM_BLEEDING:
                  _loc8_ += int(Math.round(_loc8_ * Number(int(_loc39_[_loc10_].amount) / 100)));
                  break;
               case BattleData.EFFECT_BLEEDING_FIX_NUM:
                  Central.main.petExtraDmg = true;
                  Central.main.petExtraDmgAmount = int(_loc39_[_loc10_].amount);
                  _loc8_ -= this.updateDamageByHitNum(_loc2_,int(_loc39_[_loc10_].amount));
                  break;
               case BattleData.EFFECT_PET_FREEZE:
                  if(freezeskill != true)
                  {
                     _loc8_ += Math.round(Math.abs(_loc8_) * 0.8);
                  }
                  break;
               case BattleData.EFFECT_BLOOD_DRINKER:
                  _loc2_.attackerRestoreHp += Math.round(int(_loc39_[_loc10_].amount) / 100 * _loc8_ * -1);
                  break;
               case BattleData.EFFECT_BLOOD_DRINKER_N_RESTORE_HP_BUNDLE:
               case BattleData.EFFECT_BLOOD_DRINKER_N_RESTORE_HP:
                  _loc2_.attackerRestoreHp += Math.round(int(_loc39_[_loc10_].amount) / 100 * _loc8_ * -1);
                  break;
               case BattleData.EFFECT_BERSERKER_MODE:
                  _loc8_ -= Math.round(Math.abs(_loc8_) * (_loc39_[_loc10_].amount / 100));
                  break;
               case BattleData.EFFECT_REDUCE_AGILITY:
                  this.checkAgility(param1);
                  break;
               case BattleData.EFFECT_SKILL_899:
               case BattleData.EFFECT_AGILITY_BONUS_FIX:
                  this.checkAgility(param1);
                  break;
               case BattleData.EFFECT_TRANSFORM:
                  _loc2_.defenderDamageCp = Math.round(Math.abs(_loc8_) * (_loc39_[_loc10_].amount / 100));
            }
         }
         if(param1.isBattleBuffActive(BattleData.EFFECT_GUARD))
         {
            _loc67_ = 0.5;
            _loc9_ = NumberUtil.getRandom();
            if(_loc9_ >= _loc67_)
            {
               _loc8_ = 0;
            }
         }
         if(param1.isBattleBuffActive(BattleData.EFFECT_COMPLETE_GUARD))
         {
            _loc8_ = 0;
         }
         if(param1.isBattleBuffActive(BattleData.EFFECT_ALL_CP_GUARD_RESIST))
         {
            _loc8_ = 0;
         }
         if(param1.isBattleDebuffActive(BattleData.EFFECT_PETRIFICATION))
         {
            _loc8_ = 0;
         }
         if(param1.damageShield > 0)
         {
            Out.debug(this,"processDamage :: dmg before >> " + _loc8_);
            Out.debug(this,"processDamage :: target.damageShield before >> " + param1.damageShield);
            if(param1.damageShield > Math.abs(_loc8_))
            {
               param1.damageShield += _loc8_;
               _loc8_ = 0;
            }
            else
            {
               _loc8_ += param1.damageShield;
               param1.damageShield = 0;
            }
            Out.debug(this,"processDamage :: dmg after >> " + _loc8_);
            Out.debug(this,"processDamage :: target.damageShield after >> " + param1.damageShield);
         }
         if(_loc2_.rebound == true)
         {
            _loc2_.reboundDamage = Math.round(int(_loc2_.reboundDamage) / 100 * Math.abs(_loc8_));
            _loc8_ += _loc2_.reboundDamage;
            _loc2_.reboundDamage = this.updateHP(this.attacker,0 - _loc2_.reboundDamage);
         }
         _loc10_ = BattleData.EFFECT_AMONG_ROCKS;
         if(param1.isBattleBuffActive(_loc10_))
         {
            if(_loc38_[_loc10_].duration == 2)
            {
               _loc8_ = 0;
            }
         }
         _loc10_ = BattleData.EFFECT_SERENE_MIND;
         if(param1.isBattleBuffActive(_loc10_))
         {
            _loc2_.attackerDamageHp += Math.abs(_loc8_);
            _loc8_ = 0;
         }
         _loc10_ = BattleData.EFFECT_HIT_SELF;
         if(this.attacker.isBattleDebuffActive(_loc10_))
         {
            _loc2_.attackerDamageHp += Math.abs(_loc8_);
            _loc8_ = 0;
         }
         _loc10_ = BattleData.EFFECT_SILVER_CHAIN_BUNDLE;
         if(this.attacker.isBattleDebuffActive(_loc10_))
         {
            if(int(_loc37_[_loc10_].amount) == 1)
            {
               _loc8_ = 0;
            }
         }
         if(param1.getWeapon())
         {
            _loc68_ = Central.main.WEAPON_DATA.find(param1.getWeapon());
            if(_loc68_)
            {
               for each(_loc34_ in _loc68_.effect)
               {
                  switch(_loc34_.type)
                  {
                     case BattleData.EFFECT_GUARD_BELOW_DAMAGE:
                        if(param1.hp / param1.maxHP < _loc34_.amount / 100 && NumberUtil.getRandom() <= _loc34_.chance / 100)
                        {
                           _loc8_ = 0;
                        }
                        break;
                     case BattleData.EFFECT_WEAPON_FULL_GUARD:
                        if(NumberUtil.getRandom() <= _loc34_.chance / 100)
                        {
                           _loc8_ = 0;
                        }
                        break;
                     case BattleData.EFFECT_RECIEVE_DAMAGE_CP:
                        _loc11_ = Math.round(Math.abs(_loc8_) * (_loc34_.amount / 100));
                        _loc2_.defenderRestoreCp += _loc11_;
                        break;
                     case BattleData.EFFECT_RECEIVED_DMG_RESTORE_HP:
                        if(NumberUtil.getRandom() <= _loc34_.chance / 100)
                        {
                           _loc11_ = Math.round(Math.abs(_loc8_) * (_loc34_.amount / 100));
                           _loc2_.defenderRestoreHp += _loc11_;
                        }
                        break;
                     case BattleData.EFFECT_RECEIVED_DMG_RESTORE_HP:
                        if(NumberUtil.getRandom() <= _loc34_.chance / 100)
                        {
                           _loc11_ = Math.round(Math.abs(_loc8_) * (_loc34_.amount / 100));
                           _loc2_.defenderRestoreHp += _loc11_;
                        }
                        break;
                     case BattleData.EFFECT_REBOUND_DMG_PERCENT:
                        if(NumberUtil.getRandom() <= int(_loc34_.chance) / 100)
                        {
                           _loc18_ = Math.round(Math.abs(_loc8_) * (_loc34_.amount / 100));
                           _loc8_ = 0;
                           _loc2_.attackerDamageHp += Math.abs(_loc18_);
                        }
                  }
               }
            }
         }
         if(param1.getBackItem())
         {
            _loc56_ = Central.main.BACK_ITEM_DATA.find(param1.getBackItem());
            if(_loc56_)
            {
               for each(_loc34_ in _loc56_.effect)
               {
                  switch(_loc34_.type)
                  {
                     case BattleData.EFFECT_CONVERT_FULLDMG_TO_HP:
                        if(NumberUtil.getRandom() <= _loc34_.chance / 100)
                        {
                           _loc2_.defenderRestoreHp += Math.abs(_loc8_);
                           _loc8_ = 0;
                        }
                        break;
                     case BattleData.EFFECT_BACKITEM_GUARD:
                        if(NumberUtil.getRandom() <= _loc34_.chance / 100)
                        {
                           _loc8_ *= 1 - _loc34_.amount / 100;
                        }
                  }
               }
            }
         }
         if(param1.getAccessory())
         {
            _loc27_ = Central.main.ACCESSORY_DATA.find(param1.getAccessory());
            if(_loc27_)
            {
               for each(_loc34_ in _loc27_.effect)
               {
                  switch(_loc34_.type)
                  {
                     case BattleData.EFFECT_RECIEVE_DAMAGE_CP:
                        _loc11_ = Math.round(Math.abs(_loc8_) * (_loc34_.amount / 100));
                        _loc2_.defenderRestoreCp += _loc11_;
                  }
               }
            }
         }
         _loc10_ = BattleData.EFFECT_ALL_CP_DRAIN_HP;
         if(param1.isBattleBuffActive(_loc10_))
         {
            _loc2_.defenderRestoreHp = Math.abs(_loc8_) * (int(_loc38_[_loc10_].amount) / 100);
            _loc8_ = 0;
         }
         _loc10_ = BattleData.EFFECT_BUBBLE_SHIELD;
         if(param1.isBattleBuffActive(_loc10_))
         {
            _loc2_.defenderRestoreHp = Math.abs(_loc8_) / 2;
            _loc8_ = Math.round(_loc8_ / 2);
         }
         _loc10_ = BattleData.EFFECT_MANA_SHIELD;
         if(param1.isBattleBuffActive(_loc10_))
         {
            _loc15_ = Math.round(Math.abs(_loc8_) / int(_loc38_[_loc10_].amount));
            if(param1.cp >= _loc15_)
            {
               _loc2_.defenderDamageCp += _loc15_;
               _loc8_ = 0;
            }
            else
            {
               _loc2_.defenderDamageCp = param1.cp;
               _loc8_ += Math.round((_loc15_ - param1.cp) * int(_loc38_[_loc10_].amount));
            }
         }
         _loc40_ = this.attacker.getClanEffect();
         if(_loc40_)
         {
            if(_loc40_[ClanData.CLAN_DAMAGE_BONUS])
            {
               _loc8_ += Math.round(_loc8_ * (int(_loc40_[ClanData.CLAN_DAMAGE_BONUS].amount) / 100));
            }
         }
         if(Central.mission.curMissionID == "msn135")
         {
            if(this.attacker.side == BattleData.SIDE_FRIENDLY)
            {
               _loc69_ = uint(param1.getSufferDamageModifier());
               _loc8_ = Math.round(_loc8_ * (_loc69_ / 100));
            }
            else
            {
               _loc70_ = uint(this.attacker.getDealDamageModifier());
               _loc8_ = Math.round(_loc8_ * (_loc70_ / 100));
            }
         }
         if(_loc2_.action == BattleData.ACTION_CLASS_SKILL)
         {
            switch(_loc2_.effect.type)
            {
               case BattleData.SKILL_2004:
                  _loc71_ = Math.round(this.attacker.getLevel() - 60);
                  if(_loc71_ < 0)
                  {
                     _loc71_ = 0;
                  }
                  _loc8_ = _loc72_ = Math.round(-((700 + _loc71_ * 64) * (param1.hp / param1.maxHP)));
                  _loc7_ = true;
            }
         }
         if(_loc2_.action == BattleData.ACTION_SKILL)
         {
            if(_loc2_.effect)
            {
               switch(_loc2_.effect.type)
               {
                  case BattleData.SKILL_345:
                  case BattleData.SKILL_345_THANOS:
                     _loc4_ = 0;
                     if(_loc2_.effect.type == BattleData.SKILL_345_THANOS && attacker.getWeapon() == "wpn1596")
                     {
                        _loc3_ = int(Central.main.stateInventory.getStateOnCount(attacker.getCharacterId(),"wpn","wpn1596"));
                        if(_loc3_ >= 0)
                        {
                           _loc4_ = _loc3_;
                        }
                     }
                     _loc8_ -= Math.round(param1.hp * ((_loc2_.effect.amount + _loc4_) / 100));
                     _loc7_ = true;
                     break;
                  case BattleData.SKILL_368:
                     _loc8_ -= Math.round(param1.maxHP * (_loc2_.effect.amount / 100));
                     _loc7_ = true;
                     break;
                  case BattleData.EFFECT_CRITICAL_DMG_N_DODGE_REDUCTION:
                     if(_loc2_.critical)
                     {
                        _loc73_ = 0;
                        switch(_loc2_.target)
                        {
                           case "allEnemy":
                              _loc25_ = 0;
                              while(_loc25_ < this.characterArr.length)
                              {
                                 if(this.characterArr[_loc25_].isDead == false && this.characterArr[_loc25_].side == this.defender.side)
                                 {
                                    _loc74_ = 0;
                                    for(_loc75_ in this.characterArr[_loc25_].getBattleBuff())
                                    {
                                       if(this.characterArr[_loc25_].getBattleBuff()[_loc75_].druration < 999)
                                       {
                                          _loc74_++;
                                       }
                                    }
                                    if(_loc74_ > _loc73_)
                                    {
                                       _loc73_ = _loc74_;
                                    }
                                 }
                                 _loc25_++;
                              }
                        }
                        _loc8_ *= 1 + _loc2_.effect.amount * _loc73_ * 0.01;
                     }
               }
            }
         }
         for(_loc10_ in _loc38_)
         {
            if(!_loc38_[_loc10_])
            {
               continue;
            }
            if(int(_loc38_[_loc10_].duration) <= 0)
            {
               continue;
            }
            switch(_loc10_)
            {
               case BattleData.EFFECT_DAMAGE_DELAY:
                  _loc76_ = _loc38_[_loc10_].intmem1 + _loc38_[_loc10_].intmem2;
                  _loc77_ = _loc76_ < -_loc8_ ? int(-_loc76_) : _loc8_;
                  _loc78_ = _loc76_ < -_loc8_ ? int(_loc8_ + _loc76_) : 0;
                  _loc38_[_loc10_].intmem1 += _loc77_;
                  _loc8_ = _loc78_;
            }
         }
         for(_loc10_ in _loc36_)
         {
            if(!_loc36_[_loc10_])
            {
               continue;
            }
            if(int(_loc36_[_loc10_].duration) <= 0)
            {
               continue;
            }
            switch(_loc10_)
            {
               case BattleData.EFFECT_PET_DRAIN_HP_KEKKAI:
               case BattleData.EFFECT_BLOOD_FEED:
                  _loc11_ = Math.round(Math.abs(_loc8_) * (int(_loc36_[_loc10_].amount) / 100));
                  _loc2_.attackerRestoreHp += _loc11_;
            }
         }
         for(_loc10_ in _loc39_)
         {
            if(_loc39_[_loc10_])
            {
               if(int(_loc39_[_loc10_].duration) > 0)
               {
                  var _loc81_:String = _loc10_;
                  switch(0)
                  {
                  }
                  break;
               }
            }
         }
         if(Central.battle.seal_enemy)
         {
            _loc8_ = -this.defender.maxHP;
         }
         if(Central.mission.curMissionID == "msn0" && (_loc2_.action == "weapon_attack" || _loc2_.action == "attack"))
         {
            _loc8_ = -this.defender.hp;
         }
         if(Math.abs(_loc8_) > 80000 && adminArr.indexOf(this.attacker.getCharacterId()) < 0 && this.attacker.getWeapon() != "wpn9999" && _loc8_ > Central.battle.getDefender().maxHP && Central.battle.battleRoundCounter <= 4)
         {
            this.checkDmgHack(Math.abs(_loc8_),Central.battle.battleRoundCounter,Central.main.getPartyNpc().toString(),Central.battle.getDefender().enemyObj.id,Central.battle.getDefender().maxHP);
            _loc8_ = Math.random() * 1000 + 300;
         }
         _loc8_ = this.updateHP(param1,_loc8_);
         if(_loc2_.effect)
         {
            _loc12_ = _loc2_.effect;
            switch(_loc12_.type)
            {
               case BattleData.EFFECT_SKILL_888:
                  _loc29_.defenderDamageCp = _loc8_;
                  _loc29_.defenderDamageCp = this.updateCP(param1,0 - _loc29_.defenderDamageCp);
                  _loc34_ = {
                     "type":BattleData.EFFECT_MERIDIANS_SEAL,
                     "duration":_loc12_.duration,
                     "amount":_loc12_.amount
                  };
                  param1.setBattleDebuff(_loc34_);
            }
         }
         if(_loc2_.action == BattleData.ACTION_SKILL)
         {
            if(Central.battle.type == Central.battle.TYPE_NETWORK)
            {
               if(_loc32_.skill_hit_num != null)
               {
                  if(_loc32_.skill_hit_num > 0)
                  {
                     this.updateHP(param1,Math.round(_loc8_ * (_loc32_.skill_hit_num - 1)));
                  }
               }
            }
         }
         if(param1.getBackItem())
         {
            _loc56_ = Central.main.BACK_ITEM_DATA.find(param1.getBackItem());
            if(_loc56_)
            {
               for each(_loc34_ in _loc56_.effect)
               {
                  trace(Math.abs(_loc8_));
                  trace(_loc34_.amount / 100);
                  switch(_loc34_.type)
                  {
                     case BattleData.EFFECT_RECIEVE_DAMAGE_CP:
                        if(_loc8_ < 0)
                        {
                           _loc2_.defenderRestoreCp += Math.round(Math.abs(_loc8_) * (_loc34_.amount / 100));
                        }
                  }
               }
            }
         }
         if(_loc29_.defenderRestoreHp > 0)
         {
            _loc29_.defenderRestoreHp = this.updateHP(param1,_loc29_.defenderRestoreHp);
         }
         if(_loc29_.defenderRestoreCp > 0)
         {
            _loc29_.defenderRestoreCp = this.updateCP(param1,_loc29_.defenderRestoreCp);
         }
         if(_loc29_.defenderDamageHp > 0)
         {
            _loc29_.defenderDamageHp = this.updateHP(param1,0 - _loc29_.defenderDamageHp);
         }
         if(_loc29_.defenderDamageCp > 0)
         {
            _loc29_.defenderDamageCp = this.updateCP(param1,0 - _loc29_.defenderDamageCp);
         }
         this.processDrainHp(_loc2_,_loc8_);
         _loc29_.dmg = _loc8_;
         Central.battle.battleDamageLog = _loc8_;
         if(int(param1.getData(DBCharacterData.RANK)) >= 8)
         {
            calcDmgRestoreSp(_loc8_,param1);
         }
         _loc2_.dmgArr.push(_loc29_);
         this.attacker.setBattleAction(_loc2_);
      }
      
      public function calcDmgRestoreSp(param1:int, param2:*) : void
      {
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         _loc3_ = 0.3;
         _loc4_ = 0.4;
         _loc5_ = Math.random() < 0.5 ? _loc3_ : _loc4_;
         param2.updateSPstatus(SenjutsuData.SP_UPDATE_EXTRA,Math.abs(int(param1 * _loc5_)));
         if(param2.getData(DBCharacterData.ID) == Central.main.getMainChar().getData(DBCharacterData.ID))
         {
            Central.battle.updateSPButton();
            Central.battle.disableSPButton();
         }
      }
      
      public function calcSenjutsuRecoverSPBonus(param1:int, param2:Object, param3:Object, param4:Object, param5:Object, param6:String = "") : int
      {
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:Object = null;
         var _loc10_:Object = null;
         var _loc11_:int = 0;
         var _loc12_:String = null;
         var _loc13_:Object = null;
         var _loc14_:Object = null;
         var _loc15_:Object = null;
         _loc7_ = param1;
         _loc8_ = 0;
         if(this.attackerBackItem)
         {
            for each(_loc9_ in this.attackerBackItem.effect)
            {
               switch(_loc9_.type)
               {
                  case BattleData.EFFECT_BACKITEM_RECOVER_TURN_SP:
                     if(param6 == SenjutsuData.STATUS_ROUND_START)
                     {
                        _loc8_ += int(this.attacker.maxSP * _loc9_.amount * 0.01);
                     }
               }
            }
         }
         if(this.attacker.getGearset())
         {
            _loc13_ = this.attacker.getGearset();
            for(_loc12_ in _loc13_)
            {
               _loc14_ = Central.main.GEAR_SET_DATA.find(_loc12_);
               _loc11_ = 0;
               while(_loc11_ < _loc13_[_loc12_] - 1)
               {
                  _loc15_ = _loc14_.effect[_loc11_];
                  switch(_loc15_.type)
                  {
                     case BattleData.EFFECT_BACKITEM_RECOVER_TURN_SP:
                        if(param6 == SenjutsuData.STATUS_ROUND_START)
                        {
                           _loc8_ += int(this.attacker.maxSP * _loc9_.amount * 0.01);
                        }
                  }
                  _loc11_++;
               }
            }
         }
         return int(_loc7_ + _loc8_);
      }
      
      public function calcSenjutsuDamageBonus(param1:int, param2:Object, param3:Object, param4:Object, param5:Object) : int
      {
         var _loc6_:String = null;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:Object = null;
         var _loc10_:Object = null;
         var _loc11_:int = 0;
         _loc6_ = "";
         _loc7_ = param1;
         _loc8_ = 0;
         if(this.attackerWeapon)
         {
            for each(_loc9_ in this.attackerWeapon.effect)
            {
               switch(_loc9_.type)
               {
                  case BattleData.EFFECT_WEAPON_SENJUTSU_DMG_BONUS:
                     if(this.attacker.getBattleAction().action == "senjutsu")
                     {
                        _loc8_ += int(param1 * _loc9_.amount * 0.01);
                     }
               }
            }
         }
         for(_loc6_ in param2)
         {
            if(!param2[_loc6_])
            {
               continue;
            }
            if(int(param2[_loc6_].duration) <= 0)
            {
               continue;
            }
            switch(_loc6_)
            {
               case SenjutsuData.EFFECT_SENNIN_MODE:
                  _loc7_ += int(_loc7_ * param2[_loc6_].amount * 0.01);
            }
         }
         return int(_loc7_ + _loc8_);
      }
      
      public function calcSenjutsuDodgeBonus(param1:int, param2:Object, param3:Object, param4:Object, param5:Object) : int
      {
         var _loc6_:int = 0;
         return param1;
      }
      
      public function calcSenjutsuRecoverHPBonus(param1:int, param2:Object, param3:Object, param4:Object, param5:Object) : int
      {
         var _loc6_:int = 0;
         return param1;
      }
      
      public function calcSenjutsuRecoverCPBonus(param1:int, param2:Object, param3:Object, param4:Object, param5:Object) : int
      {
         var _loc6_:int = 0;
         return param1;
      }
      
      public function calcSenjutsuAgiBonus(param1:int, param2:Object, param3:Object, param4:Object, param5:Object) : int
      {
         var _loc6_:int = 0;
         return param1;
      }
      
      public function updateHP(param1:*, param2:int) : int
      {
         var _loc3_:Object = null;
         var _loc4_:String = null;
         var _loc5_:Object = null;
         var _loc6_:Boolean = false;
         var _loc7_:Boolean = false;
         _loc3_ = param1.getBattleBuff();
         _loc5_ = param1.getBattleAction();
         _loc6_ = true;
         _loc7_ = false;
         if(_loc5_)
         {
            if(_loc5_.action)
            {
               _loc6_ = false;
               if(_loc5_.action != "item")
               {
                  _loc7_ = true;
               }
            }
         }
         if((Boolean(param1.isBattleDebuffActive(BloodlineData.EFFECT_INTERNAL_INJURY)) || Boolean(param1.isBattleDebuffActive(BattleData.EFFECT_INTERNAL_INJURY))) && (_loc6_ || _loc7_))
         {
            if(param2 > 0)
            {
               param2 = 0;
            }
         }
         if(Boolean(param1.isBattleDebuffActive(BattleData.EFFECT_DAMAGE_DELAY_INJURY)) && param2 > 0)
         {
            param2 = 0;
         }
         if(param1.isBattleDebuffActive(BattleData.SKILL_312))
         {
            if(param2 < 0)
            {
               param2 = 0;
            }
            else
            {
               param2 *= Math.round(int(param1.battleDebuff[BattleData.SKILL_312].amount) / 100);
            }
         }
         if(param1.isBattleBuffActive(BloodlineData.EFFECT_SKIP_DEAD_CLEAR_DEBUFF))
         {
            param2 = 0;
         }
         for(_loc4_ in _loc3_)
         {
            if(!_loc3_[_loc4_])
            {
               continue;
            }
            if(_loc3_[_loc4_].duration <= 0)
            {
               continue;
            }
            switch(_loc4_)
            {
               case BattleData.SKILL_268:
               case BattleData.SKILL_268_2:
                  if(param2 > 0)
                  {
                     param2 = Math.round(param2 * (100 + int(_loc3_[_loc4_].amount)) / 100);
                  }
                  break;
               case BattleData.EFFECT_DAMAGE_DELAY:
                  if(param2 < 0 && _loc3_[_loc4_].intmem1 + _loc3_[_loc4_].intmem2 > 0)
                  {
                     param2 = 0;
                  }
                  break;
               case BattleData.EFFECT_PET_PERSEVERANCE_MASTER:
                  if(param2 < 0 && Math.abs(param2) >= param1.hp)
                  {
                     if(Math.floor(param1.hp / param1.maxHP * 100) >= _loc3_[_loc4_].amount)
                     {
                        param2 = -(param1.hp - 1);
                     }
                  }
                  break;
               case BattleData.EFFECT_VIGOR:
                  if(param2 < 0)
                  {
                     param2 = 0;
                  }
            }
         }
         if(param2 < 0)
         {
            param1.removeDebuff(BattleData.EFFECT_SLEEP);
         }
         param1.updateHP(param2);
         return param2;
      }
      
      private function updateCP(param1:*, param2:int) : int
      {
         var _loc3_:Object = null;
         _loc3_ = param1.getBattleAction();
         if(Boolean(param1.isBattleBuffActive(BattleData.EFFECT_CP_LOCK)) && param2 < 0)
         {
            param2 = 0;
         }
         if(Boolean(param1.isBattleDebuffActive(BattleData.EFFECT_CP_BLEEDING)) && param2 < 0)
         {
            param2 -= Math.abs(param2) * param1.getBattleDebuff()[BattleData.EFFECT_CP_BLEEDING].amount * 0.01;
         }
         if(Boolean(param1.isBattleDebuffActive(BattleData.EFFECT_CP_BLEEDING)) && param2 > 0)
         {
            param2 = 0;
         }
         if(_loc3_)
         {
            if(_loc3_.clones)
            {
               if(_loc3_.clones[param1.getCharacterId()])
               {
                  param2 = 0;
               }
            }
         }
         param1.updateCP(param2);
         return param2;
      }
      
      private function updateSP(param1:*, param2:int) : int
      {
         param1.updateSP(param2);
         return param2;
      }
      
      private function setDebuff(param1:*, param2:Object) : Object
      {
         var _loc3_:uint = 0;
         var _loc4_:Number = NaN;
         var _loc5_:Object = null;
         var _loc6_:Boolean = false;
         var _loc7_:Object = null;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:Object = null;
         if(param2.resisted == null || param2.resisted == false)
         {
            param2.resisted = false;
            if(param1.isStunResist() == true && param2.type == BattleData.EFFECT_STUN)
            {
               param2.resisted = true;
               return param2;
            }
         }
         if(param1.getWeapon())
         {
            _loc7_ = Central.main.WEAPON_DATA.find(param1.getWeapon());
            if(_loc7_)
            {
               for each(_loc5_ in _loc7_.effect)
               {
                  switch(_loc5_.type)
                  {
                     case BattleData.EFFECT_DEBUFF_RESTORE_HP_PRESENT:
                        _loc8_ = Math.round(param1.maxHP * (_loc5_.amount / 100));
                        _loc8_ = this.updateHP(param1,_loc8_);
                        param2.restoreHp = _loc8_;
                        break;
                     case BattleData.EFFECT_DEBUFF_RESTORE_CP_PRESENT:
                        _loc9_ = Math.round(param1.maxCP * (_loc5_.amount / 100));
                        _loc9_ = this.updateCP(param1,_loc9_);
                        param2.restoreCp = _loc9_;
                        break;
                     case BattleData.EFFECT_DEBUFF_RESTORE_CP_HP_PRESENT:
                        _loc8_ = Math.round(param1.maxHP * (_loc5_.amount / 100));
                        _loc9_ = Math.round(param1.maxCP * (_loc5_.amount / 100));
                        _loc9_ = this.updateCP(param1,_loc9_);
                        param2.restoreCp = _loc9_;
                        _loc8_ = this.updateHP(param1,_loc8_);
                        param2.restoreHp = _loc8_;
                  }
               }
            }
         }
         if(param1.getBackItem())
         {
            _loc10_ = Central.main.BACK_ITEM_DATA.find(param1.getBackItem());
            if(_loc10_)
            {
               for each(_loc5_ in _loc10_.effect)
               {
                  switch(_loc5_.type)
                  {
                     case BattleData.EFFECT_DEBUFF_RESTORE_HP_PRESENT:
                        param2.restoreHp = Math.round(param1.maxHP * (_loc5_.amount / 100));
                        param2.restoreHp = this.updateHP(param1,param2.restoreHp);
                  }
               }
            }
         }
         _loc6_ = true;
         _loc6_ = Boolean(param1.setBattleDebuff(param2));
         if(_loc6_ == false)
         {
            param2.resisted = true;
         }
         return param2;
      }
      
      private function setBuff(param1:*, param2:Object) : Object
      {
         param1.setBattleBuff(param2);
         return param2;
      }
      
      private function getPetMasterById(param1:uint) : *
      {
         var _loc2_:int = 0;
         _loc2_ = 0;
         _loc2_ = 0;
         while(_loc2_ < this.characterArr.length)
         {
            if(this.characterArr[_loc2_].pet != null)
            {
               if(this.characterArr[_loc2_].pet.getCharacterId() == param1)
               {
                  return this.characterArr[_loc2_];
               }
            }
            _loc2_++;
         }
      }
      
      private function calcSkillDamage(param1:*, param2:Object) : uint
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:Object = null;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc14_:Number = NaN;
         var _loc15_:int = 0;
         var _loc16_:int = 0;
         _loc4_ = int(param2.damage);
         _loc5_ = param1.getBattleBuff();
         switch(param2.type)
         {
            case "fire":
               _loc3_ = int(param1.getData(DBCharacterData.FIRE));
               break;
            case "wind":
               _loc3_ = int(param1.getData(DBCharacterData.WIND));
               break;
            case "water":
               _loc3_ = int(param1.getData(DBCharacterData.WATER));
               break;
            case "lightning":
               _loc3_ = int(param1.getData(DBCharacterData.LIGHTNING));
               break;
            case "earth":
               _loc3_ = int(param1.getData(DBCharacterData.EARTH));
               break;
            default:
               _loc3_ = 0;
         }
         _loc6_ = 1 * 1 * _loc4_ * (_loc3_ / 100);
         _loc8_ = _loc4_ * (_loc3_ * 0.01);
         _loc9_ = Math.random();
         _loc10_ = _loc4_ * (_loc3_ * 0.01);
         var _loc11_:int = _loc7_;
         _loc12_ = _loc4_ * (_loc3_ * 1 / 100);
         var _loc13_:Boolean = Boolean(_loc7_);
         _loc14_ = _loc4_ * (_loc3_ / 100);
         if(_loc9_ <= 0.2)
         {
            _loc7_ = 1 * (_loc6_ == _loc8_ ? _loc6_ : _loc4_ * (_loc3_ * 1 / 100));
         }
         else if(_loc9_ <= 0.4)
         {
            _loc7_ = _loc8_ == _loc10_ ? _loc8_ : 1 * _loc4_ * (_loc3_ / 100);
         }
         else if(_loc9_ <= 0.6)
         {
            _loc7_ = _loc10_ == _loc12_ ? _loc10_ : _loc4_ * (_loc3_ / 100);
         }
         else if(_loc9_ <= 0.8)
         {
            _loc7_ = _loc12_ == _loc14_ ? _loc12_ : 1 * _loc4_ * (_loc3_ / 100);
         }
         else
         {
            _loc7_ = _loc14_ == _loc6_ ? _loc14_ : 1 * _loc4_ * (_loc3_ / 100);
         }
         _loc15_ = Math.round(_loc4_ * (int(param1.getData(DBCharacterData.FIRE)) * 4 / 1000));
         _loc16_ = 0;
         if(_loc5_[BattleData.EFFECT_COMBUSTION])
         {
            if(_loc5_[BattleData.EFFECT_COMBUSTION].duration > 0)
            {
               _loc16_ = Math.round(_loc4_ * 0.3);
            }
         }
         _loc4_ += Math.round(1 * _loc4_ * (_loc3_ * 0.01)) + _loc15_ + _loc16_;
         return Formula.randomizeValue(_loc4_);
      }
      
      private function randomTarget() : void
      {
         var _loc1_:Array = null;
         var _loc2_:int = 0;
         _loc1_ = [];
         _loc2_ = 0;
         while(_loc2_ < this.characterArr.length)
         {
            if(this.characterArr[_loc2_].side != this.attacker.side && this.characterArr[_loc2_].hp > 0)
            {
               _loc1_.push(this.characterArr[_loc2_]);
            }
            _loc2_++;
         }
         this.defender = _loc1_[NumberUtil.randomInt(0,_loc1_.length - 1)];
      }
      
      private function checkResurrection() : void
      {
         var _loc1_:Object = null;
         var _loc2_:int = 0;
         var _loc3_:Object = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:String = null;
         _loc1_ = this.attacker.getBattleAction();
         _loc1_.resurrectionObj = {};
         _loc4_ = 0;
         _loc5_ = 0;
         _loc6_ = "";
         _loc2_ = 0;
         while(_loc2_ < this.characterArr.length)
         {
            if(this.characterArr[_loc2_].hp <= 0)
            {
               _loc3_ = this.characterArr[_loc2_].checkBloodlineresurrection();
               _loc4_ = int(_loc3_.HPRec);
               _loc5_ = int(_loc3_.CPRec);
               _loc6_ = _loc3_.type;
               if(_loc4_ > 0)
               {
                  this.characterArr[_loc2_].updateHP(_loc4_);
                  this.characterArr[_loc2_].updateCP(_loc5_);
                  _loc5_ = int(characterArr[_loc2_].getData(DBCharacterData.CP));
                  _loc1_.resurrectionObj[this.characterArr[_loc2_].getCharacterId()] = {
                     "hp":_loc4_,
                     "cp":_loc5_,
                     "type":_loc6_
                  };
               }
            }
            _loc2_++;
         }
         this.attacker.setBattleAction(_loc1_);
      }
      
      public function reactiveBufforDebuffTarget(param1:Object) : Object
      {
         var _loc2_:Object = null;
         var _loc4_:Object = null;
         var _loc6_:String = null;
         var _loc7_:String = null;
         var _loc8_:String = null;
         var _loc9_:Array = null;
         var _loc10_:Number = NaN;
         var _loc11_:Array = null;
         var _loc12_:String = null;
         var _loc13_:String = null;
         var _loc14_:Array = null;
         var _loc16_:Object = null;
         var _loc19_:Array = null;
         var _loc20_:Array = null;
         var _loc21_:Array = null;
         var _loc22_:Object = null;
         var _loc23_:int = 0;
         var _loc24_:Object = null;
         var _loc25_:Number = NaN;
         var _loc26_:Boolean = false;
         var _loc27_:Array = null;
         var _loc28_:Object = null;
         var _loc29_:int = 0;
         var _loc30_:int = 0;
         _loc2_ = attacker.getBattleBuff();
         var _loc3_:Object = attacker.getBattleDebuff();
         _loc4_ = defender.getBattleBuff();
         var _loc5_:Object = defender.getBattleDebuff();
         _loc7_ = "";
         _loc8_ = "";
         _loc9_ = [];
         _loc11_ = [];
         _loc12_ = "";
         _loc13_ = "";
         _loc14_ = [];
         var _loc15_:Array = null;
         _loc16_ = {};
         var _loc17_:int = 0;
         var _loc18_:int = 0;
         _loc19_ = [];
         _loc20_ = [];
         _loc21_ = [BattleData.EFFECT_HEAL];
         _loc22_ = {};
         for(_loc6_ in _loc2_)
         {
            _loc9_ = [];
            _loc7_ = "";
            _loc8_ = "";
            _loc11_ = [];
            _loc12_ = "";
            _loc14_ = [];
            _loc13_ = "";
            _loc24_ = {};
            if(!_loc2_[_loc6_])
            {
               continue;
            }
            if(_loc2_[_loc6_].duration <= 0)
            {
               continue;
            }
            _loc9_ = _loc6_.split(".");
            if(_loc9_)
            {
               _loc7_ = _loc9_[0];
               _loc8_ = _loc9_[1];
            }
            if(!(Boolean(_loc7_) && Boolean(_loc2_[_loc6_].chancetoeffect) && _loc2_[_loc6_].chancetoeffect > 0))
            {
               continue;
            }
            _loc10_ = NumberUtil.getRandom();
            _loc25_ = 0;
            if(String(_loc8_).indexOf("skill1034") >= 0)
            {
               _loc25_ = this.GetShadowCaptureBonus();
            }
            if(_loc10_ > (_loc2_[_loc6_].chancetoeffect + _loc25_) / 100)
            {
               continue;
            }
            switch(_loc7_)
            {
               case BloodlineData.EFFECT_REACTIVE_DEBUFF_DEFENDER:
                  _loc12_ = _loc2_[_loc6_].requirement;
                  _loc11_ = _loc12_.split("|");
                  _loc24_ = null;
                  _loc24_ = {};
                  _loc24_.type = _loc11_[0];
                  _loc24_.duration = int(_loc11_[1]) + 0;
                  _loc24_.target = int(_loc11_[2]) + 0;
                  _loc24_.amount = int(_loc11_[3]) + 0;
                  _loc24_.chancetohit = int(_loc11_[4]) + 0;
                  _loc24_.chancetoeffect = int(_loc11_[5]) + 0;
                  _loc24_.requirement = _loc11_[6];
                  _loc13_ = "";
                  if(_loc11_[7])
                  {
                     _loc13_ = _loc11_[7];
                  }
                  if(_loc13_.length > 2)
                  {
                     _loc14_ = _loc13_.split(",");
                     _loc16_ = Central.main.SKILL_DATA[param1.skillId];
                     if((Boolean(_loc16_)) && Boolean(_loc16_.type) && param1.action == BattleData.ACTION_SKILL)
                     {
                        if(_loc14_.indexOf(_loc16_.type) >= 0)
                        {
                           if(_loc16_.damage > 0)
                           {
                              if(_loc21_.indexOf(_loc16_.effect.type) < 0)
                              {
                                 _loc22_ = {};
                                 _loc22_ = {
                                    "Effect":_loc24_,
                                    "BLSkillID":_loc8_,
                                    "charId":defender.getCharacterId()
                                 };
                                 _loc19_.push(_loc22_);
                                 this.defender.setBattleDebuff(_loc24_);
                              }
                           }
                           else if(this.defender == this.attacker && _loc24_.target == BloodlineData.TARGET_SELF)
                           {
                              _loc22_ = {};
                              _loc22_ = {
                                 "Effect":_loc24_,
                                 "BLSkillID":_loc8_,
                                 "charId":defender.getCharacterId()
                              };
                              _loc19_.push(_loc22_);
                              this.defender.setBattleDebuff(_loc24_);
                           }
                        }
                     }
                  }
                  else if(param1.action == BattleData.ACTION_SKILL || param1.action == "weapon_attack" || param1.action == "bloodline" || param1.action == "attack")
                  {
                     _loc26_ = false;
                     _loc27_ = param1.dmgArr;
                     if(_loc27_)
                     {
                        _loc23_ = 0;
                        while(_loc23_ < _loc27_.length)
                        {
                           if(_loc27_[_loc23_].dmg)
                           {
                              if(_loc27_[_loc23_].dmg != 0)
                              {
                                 _loc26_ = true;
                              }
                           }
                           _loc23_++;
                        }
                     }
                     if(_loc26_ == true)
                     {
                        _loc22_ = {};
                        _loc22_ = {
                           "Effect":_loc24_,
                           "BLSkillID":_loc8_,
                           "charId":defender.getCharacterId()
                        };
                        _loc19_.push(_loc22_);
                        this.defender.setBattleDebuff(_loc24_);
                     }
                  }
            }
         }
         for(_loc6_ in _loc4_)
         {
            _loc9_ = [];
            _loc7_ = "";
            _loc8_ = "";
            _loc11_ = [];
            _loc12_ = "";
            _loc14_ = [];
            _loc13_ = "";
            if(!_loc4_[_loc6_])
            {
               continue;
            }
            if(_loc4_[_loc6_].duration <= 0)
            {
               continue;
            }
            _loc9_ = _loc6_.split(".");
            if(_loc9_)
            {
               _loc7_ = _loc9_[0];
               _loc8_ = _loc9_[1];
            }
            if(!(Boolean(_loc7_) && Boolean(_loc4_[_loc6_].chancetoeffect) && _loc4_[_loc6_].chancetoeffect > 0))
            {
               continue;
            }
            _loc10_ = NumberUtil.getRandom();
            if(_loc10_ > _loc4_[_loc6_].chancetoeffect / 100)
            {
               continue;
            }
            switch(_loc7_)
            {
               case BloodlineData.EFFECT_REACTIVE_DEBUFF_ATTACKER:
                  _loc12_ = _loc4_[_loc6_].requirement;
                  _loc11_ = _loc12_.split("|");
                  _loc24_ = null;
                  _loc24_ = {};
                  _loc24_.type = _loc11_[0];
                  _loc24_.duration = int(_loc11_[1]) + 0;
                  _loc24_.target = int(_loc11_[2]) + 0;
                  _loc24_.amount = int(_loc11_[3]) + 0;
                  _loc24_.chancetohit = int(_loc11_[4]) + 0;
                  _loc24_.chancetoeffect = int(_loc11_[5]) + 0;
                  _loc24_.requirement = _loc11_[6];
                  _loc13_ = "";
                  if(_loc11_[7])
                  {
                     _loc13_ = _loc11_[7];
                  }
                  if(_loc13_.length > 2)
                  {
                     _loc14_ = _loc13_.split(",");
                     _loc16_ = Central.main.SKILL_DATA[param1.skillId];
                     if((Boolean(_loc16_)) && Boolean(_loc16_.type) && param1.action == BattleData.ACTION_SKILL)
                     {
                        if(_loc14_.indexOf(_loc16_.type) >= 0 && _loc16_.damage > 0)
                        {
                           _loc22_ = {};
                           _loc22_ = {
                              "Effect":_loc24_,
                              "BLSkillID":_loc8_,
                              "charId":defender.getCharacterId()
                           };
                           _loc20_.push(_loc22_);
                           this.attacker.setBattleDebuff(_loc24_);
                        }
                     }
                  }
                  else if(param1.action == BattleData.ACTION_SKILL || param1.action == "weapon_attack" || param1.action == "bloodline" || param1.action == "attack")
                  {
                     _loc22_ = {};
                     _loc22_ = {
                        "Effect":_loc24_,
                        "BLSkillID":_loc8_,
                        "charId":defender.getCharacterId()
                     };
                     _loc20_.push(_loc22_);
                     this.attacker.setBattleDebuff(_loc24_);
                  }
            }
         }
         param1.EFFECT_REACTIVE_DEBUFF_DEFENDER = _loc19_;
         param1.EFFECT_REACTIVE_DEBUFF_ATTACKER = _loc20_;
         _loc23_ = 0;
         while(_loc23_ < _loc19_.length)
         {
            if(_loc19_[_loc23_].Effect.type == BloodlineData.EFFECT_UPDATE_HP_CP)
            {
               _loc28_ = _loc19_[_loc23_].Effect;
               _loc29_ = 0;
               if(_loc28_.target == BloodlineData.TARGET_SELF)
               {
                  _loc29_ = Math.round(attacker.maxHP * (_loc28_.amount / 100));
                  _loc29_ = applySkill268HpEffect(_loc29_);
                  if(_loc29_ > 0)
                  {
                     param1.attackerRestoreHp = _loc29_;
                  }
                  else if(_loc29_ < 0)
                  {
                     param1.attackerDamageHp = Math.abs(_loc29_);
                  }
               }
               else if(_loc28_.target == BloodlineData.TARGET_ENEMY)
               {
                  _loc29_ = Math.round(defender.maxHP * (_loc28_.amount / 100));
                  _loc29_ = applySkill268HpEffect(_loc29_);
                  if(_loc29_ > 0)
                  {
                     param1.defenderRestoreHp = _loc29_;
                  }
                  else if(_loc29_ < 0)
                  {
                     param1.defenderDamageHp = Math.abs(_loc29_);
                  }
               }
               _loc30_ = 0;
               if(_loc28_.target == BloodlineData.TARGET_SELF)
               {
                  _loc30_ = Math.round(attacker.maxCP * (_loc28_.amount / 100));
                  if(_loc30_ > 0)
                  {
                     param1.attackerRestoreCp = _loc30_;
                  }
                  else if(_loc30_ < 0)
                  {
                     param1.attacterDamageCp = Math.abs(_loc30_);
                  }
               }
               else if(_loc28_.target == BloodlineData.TARGET_ENEMY)
               {
                  _loc30_ = Math.round(defender.maxCP * (_loc28_.amount / 100));
                  defender.updateCP(_loc30_,true,this.attacker);
                  if(_loc30_ > 0)
                  {
                     param1.defenderRestoreCp = _loc30_;
                  }
                  else if(_loc30_ < 0)
                  {
                     param1.defenderDamageCp = Math.abs(_loc30_);
                  }
               }
            }
            _loc23_++;
         }
         return param1;
      }
      
      public function applySkill268HpEffect(param1:int) : int
      {
         var _loc2_:Object = null;
         var _loc3_:String = null;
         _loc2_ = attacker.getBattleBuff();
         for(_loc3_ in _loc2_)
         {
            if(!_loc2_[_loc3_])
            {
               continue;
            }
            if(_loc2_[_loc3_].duration <= 0)
            {
               continue;
            }
            switch(_loc3_)
            {
               case BattleData.SKILL_268:
               case BattleData.SKILL_268_2:
                  param1 = param1 * (100 + _loc2_[_loc3_].amount) / 100;
            }
         }
         return param1;
      }
      
      private function GetShadowCaptureBonus() : Number
      {
         var _loc1_:Array = null;
         var _loc2_:Number = NaN;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         _loc1_ = this.attacker.getData(DBCharacterData.BLOODLINE_SKILL);
         _loc2_ = 0;
         _loc3_ = 0;
         for(; _loc3_ < _loc1_.length; _loc3_++)
         {
            _loc4_ = int(_loc1_[_loc3_].skill_id);
            _loc5_ = int(_loc1_[_loc3_].level);
            if(String(_loc4_) == "1011")
            {
               switch(String(_loc5_))
               {
                  case "1":
                     _loc2_ += 1;
                     break;
                  case "2":
                     _loc2_ += 1.5;
                     break;
                  case "3":
                     _loc2_ += 2;
                     break;
                  case "4":
                     _loc2_ += 3;
                     break;
                  case "5":
                     _loc2_ += 4;
                     break;
                  case "6":
                     _loc2_ += 5;
                     break;
                  case "7":
                     _loc2_ += 6;
                     break;
                  case "8":
                     _loc2_ += 7;
                     break;
                  case "9":
                     _loc2_ += 8.5;
                     break;
                  case "10":
                     _loc2_ += 10;
               }
            }
            if(String(_loc4_) != "1012")
            {
               continue;
            }
            switch(String(_loc5_))
            {
               case "1":
                  _loc2_ += 1;
                  break;
               case "2":
                  _loc2_ += 2;
                  break;
               case "3":
                  _loc2_ += 2;
                  break;
               case "4":
                  _loc2_ += 3;
                  break;
               case "5":
                  _loc2_ += 4.2;
                  break;
               case "6":
                  _loc2_ += 5.6;
                  break;
               case "7":
                  _loc2_ += 6;
                  break;
               case "8":
                  _loc2_ += 7;
                  break;
               case "9":
                  _loc2_ += 8.5;
                  break;
               case "10":
                  _loc2_ += 10;
            }
         }
         return _loc2_;
      }
      
      public function processDrainHp(param1:Object, param2:int) : void
      {
         var _loc4_:Array = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:Object = null;
         var _loc8_:String = null;
         var _loc9_:int = 0;
         var _loc3_:Object = null;
         _loc4_ = getBloodlineEffectArr(param1.effect);
         _loc5_ = 0;
         _loc6_ = 0;
         while(_loc6_ < _loc4_.length)
         {
            _loc7_ = _loc4_[_loc6_];
            _loc8_ = _loc4_[_loc6_].type;
            switch(_loc8_)
            {
               case BloodlineData.EFFECT_DRAIN_HP:
                  _loc9_ = 0;
                  if(_loc7_.target == BloodlineData.TARGET_SELF)
                  {
                     _loc9_ = Math.round(Math.abs(param2) * (_loc7_.amount / 100));
                     _loc9_ = applySkill268HpEffect(_loc9_);
                     if(_loc9_ > 0)
                     {
                        param1.attackerRestoreHp = _loc9_;
                     }
                     else if(_loc5_ < 0)
                     {
                        param1.attackerDamageHp = Math.abs(_loc9_);
                     }
                  }
                  else if(_loc7_.target == BloodlineData.TARGET_ENEMY)
                  {
                     _loc9_ = Math.round(Math.abs(param2) * (_loc7_.amount / 100));
                     _loc3_ = this.defender.getBattleBuff();
                     _loc9_ = applySkill268HpEffect(_loc9_);
                     if(_loc9_ > 0)
                     {
                        param1.defenderRestoreHp = _loc9_;
                     }
                     else if(_loc5_ < 0)
                     {
                        param1.defenderDamageHp = Math.abs(_loc9_);
                     }
                  }
            }
            _loc6_++;
         }
      }
      
      public function SetBloodlineInstantEffect(param1:Object, param2:String, param3:Object = null) : void
      {
         var _loc4_:Array = null;
         var _loc5_:int = 0;
         var _loc6_:uint = 0;
         var _loc7_:String = null;
         var _loc8_:int = 0;
         var _loc10_:int = 0;
         var _loc13_:int = 0;
         var _loc14_:int = 0;
         var _loc15_:int = 0;
         var _loc16_:Object = null;
         var _loc17_:String = null;
         var _loc18_:Array = null;
         var _loc19_:int = 0;
         var _loc20_:Object = null;
         _loc4_ = null;
         _loc5_ = 0;
         _loc6_ = 0;
         _loc7_ = "";
         _loc8_ = 0;
         var _loc9_:Object = null;
         _loc10_ = 0;
         var _loc11_:Array = Central.battle.enemyArr;
         var _loc12_:Array = Central.battle.partyArr;
         switch(param1.type)
         {
            case BloodlineData.EFFECT_CLEAR_BUFF:
               if(param1.target == BloodlineData.TARGET_SELF)
               {
                  this.attacker.clearBuff();
               }
               else if(param1.target == BloodlineData.TARGET_ENEMY)
               {
                  this.defender.clearBuff();
               }
               break;
            case BloodlineData.EFFECT_UPDATE_CP:
               _loc13_ = 0;
               if(param1.target == BloodlineData.TARGET_SELF)
               {
                  _loc13_ = Math.round(this.attacker.maxCP * (param1.amount / 100));
                  if(_loc13_ > 0)
                  {
                     param3.attackerRestoreCp = _loc13_;
                  }
                  else if(_loc13_ < 0)
                  {
                     param3.attackerDamageCp = Math.abs(_loc13_);
                  }
               }
               else if(param1.target == BloodlineData.TARGET_ENEMY)
               {
                  _loc13_ = Math.round(this.defender.maxCP * (param1.amount / 100));
                  if(_loc13_ > 0)
                  {
                     param3.defenderRestoreCp += _loc13_;
                  }
                  else if(_loc13_ < 0)
                  {
                     param3.defenderDamageCp += Math.abs(_loc13_);
                  }
               }
               break;
            case BloodlineData.EFFECT_UPDATE_HP:
               _loc14_ = 0;
               if(param1.target == BloodlineData.TARGET_SELF)
               {
                  _loc14_ = Math.round(this.attacker.maxHP * (param1.amount / 100));
                  _loc16_ = this.attacker.getBattleBuff();
                  _loc14_ = applySkill268HpEffect(_loc14_);
                  this.attacker.updateHP(_loc14_);
                  if(_loc14_ > 0)
                  {
                     param3.attackerRestoreHp = _loc14_;
                  }
                  else if(_loc14_ < 0)
                  {
                     param3.attackerDamageHp = Math.abs(_loc14_);
                  }
               }
               else if(param1.target == BloodlineData.TARGET_ENEMY)
               {
                  _loc14_ = Math.round(defender.maxHP * (param1.amount / 100));
                  _loc9_ = this.defender.getBattleBuff();
                  _loc14_ = applySkill268HpEffect(_loc14_);
                  if(_loc14_ > 0)
                  {
                     param3.defenderRestoreHp = _loc14_;
                  }
                  else if(_loc14_ < 0)
                  {
                     param3.defenderDamageHp = Math.abs(_loc14_);
                  }
               }
               break;
            case BloodlineData.EFFECT_MODIFY_COOLDOWN:
               if(param1.target == BloodlineData.TARGET_SELF)
               {
                  _loc5_ = int(param1.amount);
                  _loc4_ = this.attacker.getData(DBCharacterData.SKILLS);
                  _loc6_ = uint(param3.AttackerRandomSkillSlot);
                  if(_loc6_ != 999)
                  {
                     _loc7_ = _loc4_[_loc6_];
                     _loc8_ = int(this.attacker.getBattleSkillCooldown(_loc7_));
                     _loc8_ = _loc8_ + _loc5_;
                     if(_loc8_ <= 0)
                     {
                        _loc8_ = 0;
                     }
                     this.attacker.battleSkillCooldown[_loc7_] = _loc8_;
                  }
               }
               else if(param1.target == BloodlineData.TARGET_ENEMY)
               {
                  _loc5_ = int(param1.amount);
                  _loc18_ = this.defender.getData(DBCharacterData.SKILLS);
                  _loc6_ = uint(param3.DefenderRandomSkillSlot);
                  if(_loc6_ != 999)
                  {
                     _loc7_ = _loc18_[_loc6_];
                     _loc8_ = int(this.defender.getBattleSkillCooldown(_loc7_));
                     _loc8_ = _loc8_ + _loc5_;
                     if(_loc8_ <= 0)
                     {
                        _loc8_ = 0;
                     }
                     this.defender.battleSkillCooldown[_loc7_] = _loc8_;
                  }
               }
               break;
            case BloodlineData.EFFECT_CLEAR_ALL_TARGET_BUFF:
               switch(int(param1.target))
               {
                  case BloodlineData.TARGET_ENEMY:
                     break;
                  case BloodlineData.TARGET_ENEMY_ALL:
                     param3.target = "allEnemy";
               }
               break;
            case BloodlineData.EFFECT_RESTORE_ALL_PARTY:
               param3.healTarget = [];
               _loc15_ = 0;
               while(_loc15_ < this.characterArr.length)
               {
                  if(this.characterArr[_loc15_].side == this.attacker.side)
                  {
                     _loc19_ = this.updateHP(this.characterArr[_loc15_],param1.amount);
                     _loc20_ = {
                        "target":this.characterArr[_loc15_],
                        "heal":_loc19_
                     };
                     param3.healTarget.push(_loc20_);
                  }
                  _loc15_++;
               }
               break;
            case BloodlineData.EFFECT_DMG_HP_CP:
               _loc10_ = Math.round(this.defender.maxCP * int(param1.amount) * 0.01);
               if(_loc10_ > this.defender.cp)
               {
                  param3.defenderDamageCp += this.defender.cp;
                  param3.defenderDamageHp += _loc10_ - this.defender.cp;
               }
               else
               {
                  param3.defenderDamageCp += _loc10_;
               }
               param3.attackerRestoreCp += _loc10_;
               break;
            case BloodlineData.EFFECT_DMG_CP_AND_STUN:
               _loc10_ = Math.round(this.defender.maxCP * int(param1.amount) * 0.01);
               if(_loc10_ > this.defender.cp)
               {
                  _loc10_ = int(this.defender.cp);
                  this.defender.setBattleDebuff({
                     "type":BattleData.EFFECT_STUN,
                     "duration":param1.chancetoeffect
                  });
               }
               param3.defenderDamageCp += _loc10_;
               param3.attackerRestoreCp += _loc10_;
               break;
            case BloodlineData.EFFECT_UPDATE_CP_N_CP_RESTORE_LOCK:
               _loc10_ = Math.round(this.defender.maxCP * Math.abs(int(param1.amount)) * 0.01);
               if(_loc10_ > this.defender.cp)
               {
                  _loc10_ = int(this.defender.cp);
                  this.defender.setBattleDebuff({
                     "type":BattleData.EFFECT_CP_RESTORE_LOCK,
                     "duration":param1.chancetoeffect
                  });
               }
               param3.defenderDamageCp += _loc10_;
         }
      }
      
      public function SetSenjutsuInstantEffect(param1:Object, param2:String, param3:Object = null) : void
      {
         var _loc10_:Array = null;
         var _loc11_:Array = null;
         var _loc12_:int = 0;
         var _loc13_:int = 0;
         var _loc14_:int = 0;
         var _loc15_:int = 0;
         var _loc16_:int = 0;
         var _loc17_:int = 0;
         var _loc18_:Array = null;
         var _loc19_:int = 0;
         var _loc20_:Array = null;
         var _loc21_:int = 0;
         var _loc4_:Array = null;
         var _loc5_:int = 0;
         var _loc6_:uint = 0;
         var _loc7_:String = "";
         var _loc8_:int = 0;
         var _loc9_:Object = null;
         _loc10_ = Central.battle.enemyArr;
         _loc11_ = Central.battle.partyArr;
         _loc12_ = 0;
         _loc13_ = 0;
         _loc14_ = 0;
         _loc15_ = 0;
         switch(param1.type)
         {
            case BattleData.EFFECT_SENJUTSU_RECOVER_HP_CP:
               _loc16_ = 0;
               if(this.attacker.isBattleBuffActive(SenjutsuData.EFFECT_SENNIN_MODE))
               {
                  _loc16_ = 15;
               }
               _loc13_ += int(this.attacker.maxHP * (param1.amount + _loc16_) * 0.01);
               _loc12_ += int(this.attacker.maxCP * (param1.amount + _loc16_) * 0.01);
               param3.attackerRestoreHp += _loc13_;
               param3.attackerRestoreCp += _loc12_;
               break;
            case SenjutsuData.EFFECT_SS_BURN_CP_HP:
               if(this.defender.isBattleDebuffActive(SenjutsuData.EFFECT_SS_AGILITY_CHANGE))
               {
                  _loc13_ = int(this.defender.maxHP * param1.amount * 0.01 * 2);
                  _loc12_ = int(this.defender.maxCP * param1.amount * 0.01 * 2);
               }
               else
               {
                  _loc13_ = int(this.defender.maxHP * param1.amount * 0.01);
                  _loc12_ = int(this.defender.maxCP * param1.amount * 0.01);
               }
               param3.defenderDamageHp = _loc13_;
               param3.defenderDamageCp = _loc12_;
               break;
            case BattleData.EFFECT_LOSS_HP_DMG_BONUS:
               param3.dmg += int(this.defender.maxHP - this.defender.hp) * param1.amount * 0.01;
               break;
            case BattleData.EFFECT_DAMAGE_SHIELD:
               this.attacker.damageShield = param1.amount;
               break;
            case BattleData.EFFECT_DRAIN_MAX_SP:
               switch(int(param1.target))
               {
                  case SenjutsuData.TARGET_ENEMY:
                     _loc14_ = int(this.defender.maxSP * param1.amount * 0.01);
                     this.defender.DamageSp = -_loc14_;
                     _loc15_ += _loc14_;
                     break;
                  case SenjutsuData.TARGET_ENEMY_ALL:
                     _loc18_ = [defender];
                     _loc19_ = 0;
                     if(attacker.side == BattleData.SIDE_FRIENDLY)
                     {
                        _loc18_ = _loc10_;
                     }
                     else
                     {
                        _loc18_ = [];
                        _loc18_.push(Central.main.getMainChar());
                        if(_loc11_)
                        {
                           _loc18_ = _loc18_.concat(_loc11_);
                        }
                     }
                     _loc19_ = 0;
                     while(_loc19_ < _loc18_.length)
                     {
                        _loc14_ = int(_loc18_[_loc19_].maxSP * param1.amount * 0.01);
                        _loc18_[_loc19_].DamageSp = -_loc14_;
                        _loc15_ += _loc14_;
                        _loc18_[_loc19_].updateSP(-_loc14_);
                        _loc19_++;
                     }
                     param3.target = "allEnemy";
               }
               this.attacker.RestoreSp = _loc15_ / 2;
               this.attacker.updateSP(_loc15_ / 2);
               break;
            case SenjutsuData.EFFECT_SS_JUSTU_STEAL:
               if(this.defender.type == this.defender.TYPE_CHARACTER || this.defender.type == this.defender.TYPE_AICHARACTER || this.defender.type == this.defender.TYPE_PVPCHARACTER)
               {
                  _loc20_ = this.defender.getData(DBCharacterData.SKILLS);
                  if(_loc20_.length !== 0)
                  {
                     _loc21_ = Math.floor(NumberUtil.randomInt(0,_loc20_.length - 1));
                     param3.stealSkillId = _loc20_[_loc21_];
                     this.defender.battleSkillCooldown[param3.stealSkillId] = param1.amount;
                  }
               }
               break;
            case SenjutsuData.EFFECT_SS_DODGE_IGNORE:
               break;
            case SenjutsuData.EFFECT_SS_ABSORB_HPTOSP:
               _loc17_ = int(this.defender.maxHP * param1.chancetoeffect / 100);
               defender.DamageHp = -_loc17_;
               attacker.RestoreSp = _loc17_ / 2;
               attacker.updateSP(_loc17_ / 2);
         }
      }
      
      public function SetBloodlineBuffOrDebuffEffect(param1:Object, param2:String) : void
      {
         var _loc3_:Array = null;
         var _loc4_:Array = null;
         var _loc5_:Array = null;
         var _loc7_:Object = null;
         var _loc8_:String = null;
         var _loc9_:String = null;
         var _loc10_:Array = null;
         var _loc11_:Array = null;
         var _loc12_:int = 0;
         _loc3_ = Central.battle.enemyArr;
         _loc4_ = Central.battle.partyArr;
         _loc5_ = [];
         _loc5_ = BloodlineData.NOT_STACK_ARRAY;
         if(_loc5_.indexOf(param1.type) < 0)
         {
            if(param1.type == BloodlineData.EFFECT_REACTIVE_DEBUFF_ATTACKER || param1.type == BloodlineData.EFFECT_REACTIVE_DEBUFF_DEFENDER)
            {
               param1.type = param1.type + "." + param2 + param1.requirement;
            }
            else
            {
               param1.type = param1.type + "." + param2;
            }
         }
         if(param2 == "skill1011")
         {
            _loc7_ = this.defender.getBattleDebuff();
            _loc9_ = "";
            _loc10_ = [];
            for(_loc8_ in _loc7_)
            {
               _loc10_ = [];
               _loc9_ = "";
               if(!_loc7_[_loc8_])
               {
                  continue;
               }
               if(_loc7_[_loc8_].duration <= 0)
               {
                  continue;
               }
               _loc10_ = _loc8_.split(".");
               if(_loc10_)
               {
                  _loc9_ = _loc10_[0];
               }
               if(!_loc9_)
               {
                  continue;
               }
               switch(_loc9_)
               {
                  case BloodlineData.EFFECT_CAPTURE:
                     param1.amount *= 3;
               }
            }
         }
         var _loc6_:int = 0;
         switch(int(param1.target))
         {
            case BloodlineData.TARGET_SELF:
               this.attacker.setBattleBuff(param1);
               break;
            case BloodlineData.TARGET_ENEMY:
               this.defender.setBattleDebuff(param1);
               break;
            case BloodlineData.TARGET_ARRACKER_DEBUFF:
               this.attacker.setBattleDebuff(param1);
               break;
            case BloodlineData.TARGET_MAIN_CHARACTER_BUFF:
               if(param1.type != BloodlineData.EFFECT_MAX_HP && param1.type != BloodlineData.EFFECT_MAX_CP && param1.type != BloodlineData.EFFECT_SPEED)
               {
                  Central.main.getMainChar().setBattleBuff(param1);
               }
               break;
            case BloodlineData.TARGET_SELF_AND_ENEMY_DEBUFF:
               this.defender.setBattleDebuff(param1);
               this.attacker.setBattleDebuff(param1);
               break;
            case BloodlineData.TARGET_ENEMY_ALL:
               _loc11_ = [defender];
               _loc12_ = 0;
               if(attacker.side == BattleData.SIDE_FRIENDLY)
               {
                  _loc11_ = _loc3_;
               }
               else
               {
                  _loc11_ = [];
                  _loc11_.push(Central.main.getMainChar());
                  if(_loc4_)
                  {
                     _loc11_ = _loc11_.concat(_loc4_);
                  }
               }
               _loc12_ = 0;
               while(_loc12_ < _loc11_.length)
               {
                  _loc11_[_loc12_].setBattleDebuff(param1);
                  _loc12_++;
               }
         }
         if(String(param1.type).split(".")[0] == BloodlineData.EFFECT_MAX_CP_RECOVER)
         {
            this.updateCP(this.defender,0);
         }
      }
      
      public function SetSenjutsuBuffOrDebuffEffect(param1:Object, param2:String) : void
      {
         var _loc3_:Array = null;
         var _loc4_:Array = null;
         var _loc7_:Array = null;
         var _loc8_:int = 0;
         _loc3_ = Central.battle.enemyArr;
         _loc4_ = Central.battle.partyArr;
         var _loc5_:Array = [];
         _loc5_ = SenjutsuData.NOT_STACK_ARRAY;
         if(param2 == "skill3103")
         {
            if(param1.type == SenjutsuData.EFFECT_SS_MAX_CP_CHANGE && Boolean(this.defender.isBattleDebuffActive(BattleData.EFFECT_POISON)))
            {
               return;
            }
            if(param1.type == SenjutsuData.EFFECT_SS_MAX_CP_CHANGE_EXTRA && !this.defender.isBattleDebuffActive(BattleData.EFFECT_POISON))
            {
               return;
            }
         }
         var _loc6_:int = 0;
         switch(int(param1.target))
         {
            case SenjutsuData.TARGET_SELF:
               this.attacker.setBattleBuff(param1);
               break;
            case SenjutsuData.TARGET_ENEMY:
               this.defender.setBattleDebuff(param1);
               break;
            case SenjutsuData.TARGET_ARRACKER_DEBUFF:
               this.attacker.setBattleDebuff(param1);
               break;
            case SenjutsuData.TARGET_MAIN_CHARACTER_BUFF:
               if(param1.type != SenjutsuData.EFFECT_SS_MAX_HP)
               {
                  Central.main.getMainChar().setBattleBuff(param1);
               }
               break;
            case SenjutsuData.TARGET_SELF_AND_ENEMY_DEBUFF:
               this.defender.setBattleDebuff(param1);
               this.attacker.setBattleDebuff(param1);
               break;
            case SenjutsuData.TARGET_ENEMY_ALL:
               _loc7_ = [defender];
               _loc8_ = 0;
               if(attacker.side == BattleData.SIDE_FRIENDLY)
               {
                  _loc7_ = _loc3_;
               }
               else
               {
                  _loc7_ = [];
                  _loc7_.push(Central.main.getMainChar());
                  if(_loc4_)
                  {
                     _loc7_ = _loc7_.concat(_loc4_);
                  }
               }
               _loc8_ = 0;
               while(_loc8_ < _loc7_.length)
               {
                  _loc7_[_loc8_].setBattleDebuff(param1);
                  _loc8_++;
               }
         }
      }
      
      public function updateDamageByHitNum(param1:Object, param2:int) : int
      {
         var _loc3_:Object = null;
         if(param1.action == BattleData.ACTION_SKILL)
         {
            _loc3_ = Central.main.SKILL_DATA[param1.skillId];
            if(_loc3_.skill_hit_num != null)
            {
               if(_loc3_.skill_hit_num > 1)
               {
                  param2 = Math.round(param2 / _loc3_.skill_hit_num);
               }
            }
         }
         return param2;
      }
      
      public function CalculateBloodlineDamagebonus(param1:Object, param2:Object, param3:Object, param4:int) : int
      {
         var _loc5_:Object = null;
         var _loc6_:Object = null;
         var _loc7_:Object = null;
         var _loc8_:Object = null;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:String = null;
         var _loc12_:String = null;
         var _loc13_:Array = null;
         var _loc14_:String = null;
         var _loc15_:Array = null;
         var _loc16_:int = 0;
         var _loc17_:String = null;
         _loc5_ = this.attacker.getBattleBuff();
         _loc6_ = this.attacker.getBattleDebuff();
         _loc7_ = this.defender.getBattleBuff();
         _loc8_ = this.defender.getBattleDebuff();
         _loc9_ = 0;
         _loc10_ = 0;
         if(param4 > 0)
         {
            _loc10_ = 0;
         }
         else
         {
            _loc10_ = Math.abs(param4);
         }
         _loc12_ = "";
         _loc13_ = [];
         _loc14_ = "";
         _loc15_ = [];
         _loc16_ = 0;
         _loc17_ = "";
         var _loc18_:String = "";
         if(param1.BLSKILLID)
         {
            _loc17_ = param1.BLSKILLID;
         }
         if(param1.BLTYPE)
         {
            _loc18_ = param1.BLTYPE;
         }
         for(_loc11_ in _loc5_)
         {
            _loc13_ = [];
            _loc12_ = "";
            _loc15_ = [];
            _loc14_ = "";
            if(!_loc5_[_loc11_])
            {
               continue;
            }
            if(_loc5_[_loc11_].duration <= 0)
            {
               continue;
            }
            _loc13_ = _loc11_.split(".");
            if(_loc13_)
            {
               _loc12_ = _loc13_[0];
            }
            if(!_loc12_)
            {
               continue;
            }
            switch(_loc12_)
            {
               case BloodlineData.EFFECT_MODIFY_DAMAGE_ALL:
                  _loc9_ -= Number(_loc5_[_loc11_].amount) / 100 * _loc10_;
                  break;
               case BloodlineData.EFFECT_MODIFY_DAMAGE_BYTYPE:
                  _loc14_ = _loc5_[_loc11_].requirement;
                  _loc15_ = _loc14_.split(",");
                  if(param1.action == "bloodline")
                  {
                     if(_loc17_ != null)
                     {
                        if(Central.main.BLOODLINE_SKILL_DATA["bloodline_" + _loc17_])
                        {
                           if(_loc15_.indexOf(Central.main.BLOODLINE_SKILL_DATA["bloodline_" + _loc17_].type) >= 0)
                           {
                              _loc9_ -= Number(_loc5_[_loc11_].amount) / 100 * _loc10_;
                           }
                        }
                     }
                  }
                  if(param1.action == "skill")
                  {
                     if(param3)
                     {
                        if(_loc15_.indexOf(param3.type) >= 0)
                        {
                           _loc9_ -= Number(_loc5_[_loc11_].amount) / 100 * _loc10_;
                        }
                     }
                  }
                  break;
               case BloodlineData.EFFECT_MODIFY_DAMAGE_CRITICAL:
                  if(param1.critical)
                  {
                     _loc9_ -= Number(_loc5_[_loc11_].amount) / 100 * _loc10_;
                  }
            }
         }
         for(_loc11_ in _loc6_)
         {
            _loc13_ = [];
            _loc12_ = "";
            _loc15_ = [];
            _loc14_ = "";
            if(!_loc6_[_loc11_])
            {
               continue;
            }
            if(_loc6_[_loc11_].duration <= 0)
            {
               continue;
            }
            _loc13_ = _loc11_.split(".");
            if(_loc13_)
            {
               _loc12_ = _loc13_[0];
            }
            if(!_loc12_)
            {
               continue;
            }
            switch(_loc12_)
            {
               case BloodlineData.EFFECT_MODIFY_DAMAGE_ALL:
                  _loc9_ -= Number(_loc6_[_loc11_].amount) / 100 * _loc10_;
                  break;
               case BloodlineData.EFFECT_MODIFY_DAMAGE_BYTYPE:
                  _loc14_ = _loc6_[_loc11_].requirement;
                  _loc15_ = _loc14_.split(",");
                  if(param1.action == "bloodline")
                  {
                     if(_loc17_ != null)
                     {
                        if(Central.main.BLOODLINE_SKILL_DATA["bloodline_" + _loc17_])
                        {
                           if(_loc15_.indexOf(Central.main.BLOODLINE_SKILL_DATA["bloodline_" + _loc17_].type) >= 0)
                           {
                              _loc9_ -= Number(_loc5_[_loc11_].amount) / 100 * _loc10_;
                           }
                        }
                     }
                  }
                  if(param1.action == "skill")
                  {
                     if(param3)
                     {
                        if(_loc15_.indexOf(param3.type) >= 0)
                        {
                           _loc9_ -= Number(_loc5_[_loc11_].amount) / 100 * _loc10_;
                        }
                     }
                  }
                  break;
               case BloodlineData.EFFECT_MODIFY_DAMAGE_CRITICAL:
                  if(param1.critical)
                  {
                     _loc9_ -= Number(_loc6_[_loc11_].amount) / 100 * _loc10_;
                  }
            }
         }
         for(_loc11_ in _loc7_)
         {
            _loc13_ = [];
            _loc12_ = "";
            _loc15_ = [];
            _loc14_ = "";
            if(!_loc7_[_loc11_])
            {
               continue;
            }
            if(_loc7_[_loc11_].duration <= 0)
            {
               continue;
            }
            _loc13_ = _loc11_.split(".");
            if(_loc13_)
            {
               _loc12_ = _loc13_[0];
            }
            if(!_loc12_)
            {
               continue;
            }
            switch(_loc12_)
            {
               case BloodlineData.EFFECT_MODIFY_DEFENCE_ALL:
                  _loc9_ += Number(_loc7_[_loc11_].amount) / 100 * _loc10_;
                  break;
               case BloodlineData.EFFECT_MODIFY_DEFENCE_BYTYPE:
                  if(Boolean(param3) && Boolean(param3.type))
                  {
                     _loc14_ = _loc7_[_loc11_].requirement;
                     _loc15_ = _loc14_.split(",");
                     if(_loc15_.indexOf(param3.type) >= 0)
                     {
                        _loc9_ += Number(_loc7_[_loc11_].amount) / 100 * _loc10_;
                     }
                  }
                  break;
               case BloodlineData.EFFECT_REDUCE_CP:
                  _loc16_ = Math.round(attacker.maxCP * (_loc7_[_loc11_].amount / 100));
                  if(0 - _loc16_ > 0)
                  {
                     param1.attackerRestoreCp = _loc16_;
                  }
                  else if(0 - _loc16_ < 0)
                  {
                     param1.attackerDamageCp = _loc16_;
                  }
            }
         }
         for(_loc11_ in _loc8_)
         {
            _loc13_ = [];
            _loc12_ = "";
            _loc15_ = [];
            _loc14_ = "";
            if(!_loc8_[_loc11_])
            {
               continue;
            }
            if(_loc8_[_loc11_].duration <= 0)
            {
               continue;
            }
            _loc13_ = _loc11_.split(".");
            if(_loc13_)
            {
               _loc12_ = _loc13_[0];
            }
            if(!_loc12_)
            {
               continue;
            }
            switch(_loc12_)
            {
               case BloodlineData.EFFECT_MODIFY_DEFENCE_ALL:
                  _loc9_ += Number(_loc8_[_loc11_].amount) / 100 * _loc10_;
                  break;
               case BloodlineData.EFFECT_MODIFY_DEFENCE_BYTYPE:
                  if(Boolean(param3) && Boolean(param3.type))
                  {
                     _loc14_ = _loc8_[_loc11_].requirement;
                     _loc15_ = _loc14_.split(",");
                     if(_loc15_.indexOf(param3.type) >= 0)
                     {
                        _loc9_ += Number(_loc8_[_loc11_].amount) / 100 * _loc10_;
                     }
                  }
                  break;
               case BloodlineData.EFFECT_CAPTURE:
                  if(_loc17_ == "skill1012")
                  {
                     _loc9_ += -3 * _loc10_;
                  }
            }
         }
         return _loc9_;
      }
      
      public function CalculateSenjutsuDamagebonus(param1:Object, param2:Object, param3:Object, param4:int) : int
      {
         var _loc5_:Object = null;
         var _loc6_:Object = null;
         var _loc7_:Object = null;
         var _loc8_:Object = null;
         var _loc9_:int = 0;
         var _loc11_:String = null;
         var _loc12_:String = null;
         var _loc13_:Array = null;
         _loc5_ = this.attacker.getBattleBuff();
         _loc6_ = this.attacker.getBattleDebuff();
         _loc7_ = this.defender.getBattleBuff();
         _loc8_ = this.defender.getBattleDebuff();
         _loc9_ = 0;
         var _loc10_:int = 0;
         if(param4 > 0)
         {
            _loc10_ = 0;
         }
         else
         {
            _loc10_ = Math.abs(param4);
         }
         _loc12_ = "";
         _loc13_ = [];
         var _loc14_:String = "";
         var _loc15_:Array = [];
         var _loc16_:int = 0;
         var _loc17_:String = "";
         var _loc18_:String = "";
         if(param1.SENSKILLID)
         {
            _loc17_ = param1.SENSKILLID;
         }
         if(param1.SENTYPE)
         {
            _loc18_ = param1.SENTYPE;
         }
         for(_loc11_ in _loc5_)
         {
            _loc13_ = [];
            _loc12_ = "";
            _loc15_ = [];
            _loc14_ = "";
            if(_loc5_[_loc11_])
            {
               if(_loc5_[_loc11_].duration > 0)
               {
                  _loc13_ = _loc11_.split(".");
                  if(_loc13_)
                  {
                     _loc12_ = _loc13_[0];
                  }
                  if(_loc12_)
                  {
                     var _loc21_:String = _loc12_;
                     switch(0)
                     {
                     }
                     break;
                  }
               }
            }
         }
         for(_loc11_ in _loc6_)
         {
            _loc13_ = [];
            _loc12_ = "";
            _loc15_ = [];
            _loc14_ = "";
            if(_loc6_[_loc11_])
            {
               if(_loc6_[_loc11_].duration > 0)
               {
                  _loc13_ = _loc11_.split(".");
                  if(_loc13_)
                  {
                     _loc12_ = _loc13_[0];
                  }
                  if(_loc12_)
                  {
                     _loc21_ = _loc12_;
                     switch(0)
                     {
                     }
                     break;
                  }
               }
            }
         }
         for(_loc11_ in _loc7_)
         {
            _loc13_ = [];
            _loc12_ = "";
            _loc15_ = [];
            _loc14_ = "";
            if(_loc7_[_loc11_])
            {
               if(_loc7_[_loc11_].duration > 0)
               {
                  _loc13_ = _loc11_.split(".");
                  if(_loc13_)
                  {
                     _loc12_ = _loc13_[0];
                  }
                  if(_loc12_)
                  {
                     _loc21_ = _loc12_;
                     switch(0)
                     {
                     }
                     break;
                  }
               }
            }
         }
         for(_loc11_ in _loc8_)
         {
            _loc13_ = [];
            _loc12_ = "";
            _loc15_ = [];
            _loc14_ = "";
            if(_loc8_[_loc11_])
            {
               if(_loc8_[_loc11_].duration > 0)
               {
                  _loc13_ = _loc11_.split(".");
                  if(_loc13_)
                  {
                     _loc12_ = _loc13_[0];
                  }
                  if(_loc12_)
                  {
                     _loc21_ = _loc12_;
                     switch(0)
                     {
                     }
                     break;
                  }
               }
            }
         }
         return _loc9_;
      }
      
      public function CalculateBloodlineDamageConvert(param1:Object, param2:int) : int
      {
         var _loc5_:Object = null;
         var _loc6_:Object = null;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc11_:int = 0;
         var _loc12_:String = null;
         var _loc13_:String = null;
         var _loc14_:Array = null;
         var _loc3_:Object = this.attacker.getBattleBuff();
         var _loc4_:Object = this.attacker.getBattleDebuff();
         _loc5_ = this.defender.getBattleBuff();
         _loc6_ = this.defender.getBattleDebuff();
         _loc7_ = 0;
         _loc8_ = 0;
         _loc9_ = 0;
         var _loc10_:String = "";
         _loc11_ = 0;
         if(param2 > 0)
         {
            _loc11_ = 0;
         }
         else
         {
            _loc11_ = Math.abs(param2);
         }
         _loc13_ = "";
         _loc14_ = [];
         for(_loc12_ in _loc5_)
         {
            _loc14_ = [];
            _loc13_ = "";
            if(!_loc5_[_loc12_])
            {
               continue;
            }
            if(_loc5_[_loc12_].duration <= 0)
            {
               continue;
            }
            _loc14_ = _loc12_.split(".");
            if(_loc14_)
            {
               _loc13_ = _loc14_[0];
            }
            if(!_loc13_)
            {
               continue;
            }
            switch(_loc13_)
            {
               case BloodlineData.EFFECT_CONVERT_DMG_CP:
                  _loc8_ += Number(_loc5_[_loc12_].amount) / 100 * _loc11_;
                  break;
               case BloodlineData.EFFECT_CONVERT_DMG_HP:
                  _loc9_ += Number(_loc5_[_loc12_].amount) / 100 * _loc11_;
            }
         }
         for(_loc12_ in _loc6_)
         {
            _loc14_ = [];
            _loc13_ = "";
            if(!_loc6_[_loc12_])
            {
               continue;
            }
            if(_loc6_[_loc12_].duration <= 0)
            {
               continue;
            }
            _loc14_ = _loc12_.split(".");
            if(_loc14_)
            {
               _loc13_ = _loc14_[0];
            }
            if(!_loc13_)
            {
               continue;
            }
            switch(_loc13_)
            {
               case BloodlineData.EFFECT_CONVERT_DMG_CP:
                  _loc8_ += Number(_loc6_[_loc12_].amount) / 100 * _loc11_;
                  break;
               case BloodlineData.EFFECT_CONVERT_DMG_HP:
                  _loc9_ += Number(_loc6_[_loc12_].amount) / 100 * _loc11_;
            }
         }
         if(_loc8_ >= _loc11_)
         {
            _loc8_ = _loc11_;
         }
         if(_loc9_ >= _loc11_)
         {
            _loc9_ = _loc11_;
         }
         if(_loc9_ + _loc8_ >= _loc11_)
         {
            _loc7_ = _loc11_;
         }
         else
         {
            _loc7_ = _loc9_ + _loc8_;
         }
         if(_loc9_ > 0)
         {
            _loc5_ = defender.getBattleBuff();
            _loc9_ = this.applySkill268HpEffect(_loc9_);
            param1.defenderRestoreHp = _loc9_;
         }
         if(_loc8_ > 0)
         {
            _loc10_ = "CP +" + _loc8_;
            param1.defenderRestoreCp = _loc8_;
         }
         return _loc7_;
      }
      
      private function CalculateBloodlineDodgebonus() : int
      {
         var _loc1_:Object = null;
         var _loc2_:Object = null;
         var _loc3_:int = 0;
         var _loc4_:String = null;
         var _loc5_:String = null;
         var _loc6_:Array = null;
         var _loc7_:Number = NaN;
         _loc1_ = this.attacker.getBattleBuff();
         _loc2_ = this.attacker.getBattleDebuff();
         _loc3_ = 0;
         _loc5_ = "";
         _loc6_ = [];
         for(_loc4_ in _loc1_)
         {
            _loc6_ = [];
            _loc5_ = "";
            if(!_loc1_[_loc4_])
            {
               continue;
            }
            if(_loc1_[_loc4_].duration <= 0)
            {
               continue;
            }
            _loc6_ = _loc4_.split(".");
            if(_loc6_)
            {
               _loc5_ = _loc6_[0];
            }
            if(!(Boolean(_loc5_) && Boolean(_loc1_[_loc4_].chancetoeffect) && _loc1_[_loc4_].chancetoeffect > 0))
            {
               continue;
            }
            _loc7_ = NumberUtil.getRandom();
            if(_loc7_ > _loc1_[_loc4_].chancetoeffect / 100)
            {
               continue;
            }
            switch(_loc5_)
            {
               case BloodlineData.EFFECT_ACCURATE:
                  _loc3_ -= Number(_loc1_[_loc4_].amount) / 100;
            }
         }
         for(_loc4_ in _loc2_)
         {
            _loc6_ = [];
            _loc5_ = "";
            if(!_loc2_[_loc4_])
            {
               continue;
            }
            if(_loc2_[_loc4_].duration <= 0)
            {
               continue;
            }
            _loc6_ = _loc4_.split(".");
            if(_loc6_)
            {
               _loc5_ = _loc6_[0];
            }
            if(!(Boolean(_loc5_) && Boolean(_loc2_[_loc4_].chancetoeffect) && _loc2_[_loc4_].chancetoeffect > 0))
            {
               continue;
            }
            _loc7_ = NumberUtil.getRandom();
            if(_loc7_ > _loc2_[_loc4_].chancetoeffect / 100)
            {
               continue;
            }
            switch(_loc5_)
            {
               case BloodlineData.EFFECT_ACCURATE:
                  _loc3_ -= Number(_loc2_[_loc4_].amount) / 100;
            }
         }
         return _loc3_;
      }
      
      private function CalculateSenjutsuDodgebonus() : Number
      {
         var _loc1_:Object = null;
         var _loc2_:Object = null;
         var _loc3_:Number = NaN;
         var _loc4_:String = null;
         var _loc5_:String = null;
         var _loc6_:Array = null;
         var _loc7_:Number = NaN;
         var _loc8_:* = undefined;
         var _loc9_:Array = null;
         var _loc10_:Array = null;
         var _loc11_:int = 0;
         _loc1_ = this.attacker.getBattleBuff();
         _loc2_ = this.attacker.getBattleDebuff();
         _loc3_ = 0;
         _loc5_ = "";
         _loc6_ = [];
         _loc8_ = this.attacker.getBattleAction().effect;
         _loc9_ = [];
         _loc10_ = [];
         if(_loc8_ != null)
         {
            if(_loc8_.effect_type_1 != null)
            {
               _loc9_.push(_loc8_.effect_type_1);
               _loc10_.push(_loc8_.effect_chancetoeffect_1);
            }
            if(_loc8_.effect_type_2 != null)
            {
               _loc9_.push(_loc8_.effect_type_2);
               _loc10_.push(_loc8_.effect_chancetoeffect_2);
            }
            if(_loc8_.effect_type_3 != null)
            {
               _loc9_.push(_loc8_.effect_type_3);
               _loc10_.push(_loc8_.effect_chancetoeffect_3);
            }
         }
         _loc11_ = -1;
         _loc11_ = _loc9_.indexOf(SenjutsuData.EFFECT_SS_DODGE_IGNORE);
         if(_loc11_ >= 0)
         {
            _loc3_ -= Number(_loc10_[_loc11_]) / 100;
         }
         for(_loc4_ in _loc1_)
         {
            _loc6_ = [];
            _loc5_ = "";
            if(!_loc1_[_loc4_])
            {
               continue;
            }
            if(_loc1_[_loc4_].duration <= 0)
            {
               continue;
            }
            _loc6_ = _loc4_.split(".");
            if(_loc6_)
            {
               _loc5_ = _loc6_[0];
            }
            if(!(Boolean(_loc5_) && Boolean(_loc1_[_loc4_].chancetoeffect) && _loc1_[_loc4_].chancetoeffect > 0))
            {
               continue;
            }
            _loc7_ = NumberUtil.getRandom();
            if(_loc7_ > _loc1_[_loc4_].chancetoeffect / 100)
            {
               continue;
            }
            switch(_loc5_)
            {
               case SenjutsuData.EFFECT_SS_DODGE_IGNORE:
            }
         }
         for(_loc4_ in _loc2_)
         {
            _loc6_ = [];
            _loc5_ = "";
            if(_loc2_[_loc4_])
            {
               if(_loc2_[_loc4_].duration > 0)
               {
                  _loc6_ = _loc4_.split(".");
                  if(_loc6_)
                  {
                     _loc5_ = _loc6_[0];
                  }
                  if(Boolean(_loc5_) && Boolean(_loc2_[_loc4_].chancetoeffect) && _loc2_[_loc4_].chancetoeffect > 0)
                  {
                     _loc7_ = NumberUtil.getRandom();
                     if(_loc7_ <= _loc2_[_loc4_].chancetoeffect / 100)
                     {
                        var _loc14_:String = _loc5_;
                        switch(0)
                        {
                        }
                        break;
                     }
                  }
               }
            }
         }
         return _loc3_;
      }
      
      private function getOneRandomNonPassiveEffectFromLists(param1:Array) : Object
      {
         var _loc2_:int = 0;
         var _loc3_:Object = null;
         var _loc4_:String = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:Object = null;
         _loc2_ = 0;
         _loc5_ = 0;
         while(_loc5_ < param1.length)
         {
            if(param1[_loc5_])
            {
               _loc3_ = param1[_loc5_];
               for(_loc4_ in _loc3_)
               {
                  if(_loc3_[_loc4_])
                  {
                     if(_loc3_[_loc4_].duration <= BloodlineData.PASSIVE_DEBUFF_IDENTIFIER)
                     {
                        _loc2_++;
                     }
                  }
               }
            }
            _loc5_++;
         }
         if(_loc2_ == 0)
         {
            return null;
         }
         _loc6_ = Math.floor(NumberUtil.getRandom() * _loc2_);
         _loc7_ = 0;
         _loc5_ = 0;
         while(_loc5_ < param1.length)
         {
            if(param1[_loc5_])
            {
               _loc3_ = param1[_loc5_];
               for(_loc4_ in _loc3_)
               {
                  trace("key = ===== " + _loc4_);
                  _loc8_ = _loc3_[_loc4_];
                  trace("value = " + GF.printObject(_loc8_));
                  if(_loc3_[_loc4_].duration <= BloodlineData.PASSIVE_DEBUFF_IDENTIFIER)
                  {
                     if(_loc4_.indexOf(BattleData.EFFECT_DAMAGE_DELAY) < 0)
                     {
                        if(_loc4_.indexOf(BattleData.EFFECT_SUSANOO) < 0)
                        {
                           if(_loc4_.indexOf(BattleData.EFFECT_SUSANOOB) < 0)
                           {
                              if(_loc4_.indexOf(BattleData.EFFECT_DAMAGE_DELAY_INJURY) < 0)
                              {
                                 if(_loc4_.indexOf(SenjutsuData.EFFECT_SENNIN_MODE) < 0)
                                 {
                                    if(_loc4_.indexOf(BloodlineData.EFFECT_TITAN) < 0)
                                    {
                                       if(_loc4_.indexOf(BloodlineData.EFFECT_SKIP_DEAD_CLEAR_DEBUFF) >= 0)
                                       {
                                          trace("getOneRandomNonPassiveEffectFromLists 111111111111111111111111111111111111111111111111");
                                       }
                                       else
                                       {
                                          if(_loc7_ == _loc6_)
                                          {
                                             return _loc3_[_loc4_];
                                          }
                                          _loc7_++;
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
            _loc5_++;
         }
         return null;
      }
      
      private function getOneRandomNonPassiveEffectCanAbsorb(param1:Array) : Array
      {
         var _loc3_:Object = null;
         var _loc4_:String = null;
         var _loc5_:int = 0;
         var _loc6_:Array = null;
         trace("effectList = " + GF.printObject(param1));
         var _loc2_:int = 0;
         _loc6_ = [];
         _loc5_ = 0;
         while(_loc5_ < param1.length)
         {
            if(param1[_loc5_])
            {
               trace("effectList.length = " + param1.length);
               _loc3_ = param1[_loc5_];
               trace("effectObj = " + GF.printObject(_loc3_));
               if(_loc3_.duration > BloodlineData.PASSIVE_DEBUFF_IDENTIFIER)
               {
                  _loc6_.push(1);
               }
               else if(_loc3_.type.indexOf(BattleData.EFFECT_DAMAGE_DELAY) >= 0)
               {
                  _loc6_.push(1);
               }
               else if(_loc3_.type.indexOf(BattleData.EFFECT_SUSANOOB) >= 0)
               {
                  _loc6_.push(1);
               }
               else if(_loc3_.type.indexOf(BattleData.EFFECT_SUSANOO) >= 0)
               {
                  _loc6_.push(1);
               }
               else if(_loc3_.type.indexOf(BattleData.EFFECT_DAMAGE_DELAY_INJURY) >= 0)
               {
                  _loc6_.push(1);
               }
               else if(_loc3_.type.indexOf(SenjutsuData.EFFECT_SENNIN_MODE) >= 0)
               {
                  _loc6_.push(1);
               }
               else if(_loc3_.type.indexOf(BloodlineData.EFFECT_EXTREME) >= 0)
               {
                  trace("getOneRandomNonPassiveEffectCanAbsorb");
                  _loc6_.push(1);
               }
               else if(_loc3_.type.indexOf(BloodlineData.EFFECT_TITAN) >= 0)
               {
                  _loc6_.push(1);
               }
               else if(_loc3_.type.indexOf(BloodlineData.EFFECT_SKIP_DEAD_CLEAR_DEBUFF) >= 0)
               {
                  _loc6_.push(0);
               }
               else
               {
                  _loc6_.push(2);
               }
            }
            _loc5_++;
         }
         return _loc6_;
      }
      
      private function calculateSkillDamageReduction(param1:Object, param2:Object, param3:Object, param4:int) : int
      {
         var _loc5_:int = 0;
         var _loc6_:Object = null;
         var _loc7_:int = 0;
         var _loc8_:Number = NaN;
         var _loc9_:String = null;
         var _loc10_:uint = 0;
         var _loc11_:uint = 0;
         var _loc12_:Number = NaN;
         _loc5_ = param4 > 0 ? 0 : int(Math.abs(param4));
         _loc6_ = this.defender.getBattleBuff();
         _loc7_ = 0;
         _loc8_ = Math.random();
         for(_loc9_ in _loc6_)
         {
            if(_loc6_[_loc9_] == null)
            {
               continue;
            }
            if(_loc6_[_loc9_].duration < 0)
            {
               continue;
            }
            switch(_loc9_)
            {
               case BattleData.EFFECT_HALFHP_DAMAGE_REDUCTION:
                  _loc10_ = 25;
                  _loc11_ = 75;
                  _loc12_ = _loc11_ - _loc10_ + 1;
                  _loc7_ += (Math.floor(_loc8_ * _loc12_) + _loc10_) * 0.01 * _loc5_;
            }
         }
         return _loc7_;
      }
      
      public function checkDmgHack(param1:int, param2:int, param3:String, param4:String, param5:int) : void
      {
         var missionId:String = null;
         var hash:String = null;
         var dmg:int = param1;
         var round:int = param2;
         var members:String = param3;
         var defId:String = param4;
         var defMaxHP:int = param5;
         missionId = Central.mission.curMissionID == null ? "0" : Central.mission.curMissionID;
         hash = Central.main.getHash(String(round) + missionId + String(dmg) + members + defId + String(defMaxHP));
         Central.main.amfClient.service("CharacterDAO.makeBattleBetter",[Account.getAccountSessionKey(),round,missionId,dmg,members,defId,defMaxHP,hash],function(param1:Object):*
         {
            if(!Central.main.validateAmfResponse(param1))
            {
            }
         });
      }
      
      private function setBattleActionFeedback(param1:Object, param2:Object) : *
      {
         if(!param1.feedback)
         {
            param1.feedback = new Array();
         }
         param1.feedback.push(param2);
      }
      
      private function checkIsSelfBuff(param1:Object) : Boolean
      {
         var _loc2_:Object = null;
         var _loc3_:int = 0;
         switch(param1.action)
         {
            case "waepon_attack":
            case "attack":
               return false;
            case "skill":
               if(param1.skillId)
               {
                  _loc2_ = Central.main.SKILL_DATA[param1.skillId];
                  _loc3_ = _loc2_ ? int(_loc2_.target) : 0;
                  switch(_loc3_)
                  {
                     case 1:
                     case 3:
                     case 4:
                        return true;
                  }
               }
               break;
            case "special":
               switch(param1.target)
               {
                  case "master":
                  case "self":
                     return true;
               }
               break;
            case "bloodline":
            case "senjutsu":
               return true;
         }
         return false;
      }
      
      private function checkClone(param1:Object) : void
      {
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         _loc2_ = 0;
         while(_loc2_ < this.characterArr.length)
         {
            if(this.characterArr[_loc2_].isDead == false && this.characterArr[_loc2_].side == this.defender.side)
            {
               for(_loc3_ in this.characterArr[_loc2_].getBattleBuff())
               {
                  switch(_loc3_)
                  {
                     case BattleData.EFFECT_PROTECT_BY_DUMMY_BURN_PROTECTION:
                     case BattleData.EFFECT_PROTECT_BY_DUMMY:
                        if(Boolean(this.characterArr[_loc2_].getBattleBuff()[_loc3_]) && Boolean(this.characterArr[_loc2_].getBattleBuff()[_loc3_].chance / 100 >= NumberUtil.getRandom()) && param1.clones[this.characterArr[_loc2_].getCharacterId()] == null)
                        {
                           if(!param1.clones[this.characterArr[_loc2_].getCharacterId()])
                           {
                              param1.clones[this.characterArr[_loc2_].getCharacterId()] = {};
                           }
                           param1.clones[this.characterArr[_loc2_].getCharacterId()].effectName = BattleData.TYPE_DUMMY;
                           param1.clones[this.characterArr[_loc2_].getCharacterId()].buffName = _loc3_;
                        }
                        break;
                     case BattleData.EFFECT_PROTECT_BY_DUMMY_RECEIVED_BURN:
                        trace("checkClone battleAction = " + param1.clones);
                        trace("checkClone battleAction = " + GF.printObject(param1.clones));
                        trace("checkClone battleAction = " + GF.printObject(param1));
                        if(Boolean(this.characterArr[_loc2_].getBattleBuff()[_loc3_]) && this.characterArr[_loc2_].getBattleBuff()[_loc3_].chance / 100 >= NumberUtil.getRandom())
                        {
                           if(!param1.clones[this.characterArr[_loc2_].getCharacterId()])
                           {
                              param1.clones[this.characterArr[_loc2_].getCharacterId()] = {};
                           }
                           param1.clones[this.characterArr[_loc2_].getCharacterId()].effectName = BattleData.TYPE_DUMMY_BURN;
                           param1.clones[this.characterArr[_loc2_].getCharacterId()].buffName = _loc3_;
                        }
                        break;
                     case BattleData.EFFECT_PROTECT_BY_DUMMY_RECEIVED_STUN:
                        if(Boolean(this.characterArr[_loc2_].getBattleBuff()[_loc3_]) && this.characterArr[_loc2_].getBattleBuff()[_loc3_].chance / 100 >= NumberUtil.getRandom())
                        {
                           if(!param1.clones[this.characterArr[_loc2_].getCharacterId()])
                           {
                              param1.clones[this.characterArr[_loc2_].getCharacterId()] = {};
                           }
                           param1.clones[this.characterArr[_loc2_].getCharacterId()].effectName = BattleData.TYPE_DUMMY_STUN;
                           param1.clones[this.characterArr[_loc2_].getCharacterId()].buffName = _loc3_;
                        }
                  }
               }
            }
            _loc2_++;
         }
      }
      
      private function getAvailableBuff(param1:*, param2:int) : Array
      {
         var _loc3_:Array = null;
         var _loc4_:int = 0;
         var _loc5_:Array = null;
         var _loc6_:Object = null;
         var _loc7_:int = 0;
         var _loc8_:* = undefined;
         _loc3_ = [];
         _loc5_ = [];
         for(_loc8_ in param1.getBattleBuff())
         {
            _loc6_ = param1.getBattleBuff()[_loc8_];
            if(_loc8_ == BloodlineData.EFFECT_SKIP_DEAD_CLEAR_DEBUFF)
            {
               trace("getAvailableBuff 123123123213131231313123123213213211223131212");
            }
            else if(_loc8_ != BattleData.EFFECT_DAMAGE_DELAY)
            {
               if(_loc8_ != SenjutsuData.EFFECT_SENNIN_MODE)
               {
                  if(_loc6_.duration < 900)
                  {
                     _loc3_.push(_loc6_);
                  }
               }
            }
         }
         if(_loc3_.length > 0)
         {
            _loc4_ = 0;
            while(_loc4_ < param2)
            {
               if(_loc4_ >= _loc3_.length)
               {
                  break;
               }
               while(_loc4_ == _loc5_.length)
               {
                  _loc7_ = NumberUtil.randomInt(0,_loc3_.length - 1);
                  if(_loc5_.indexOf(_loc3_[_loc7_]) < 0)
                  {
                     _loc5_.push(_loc3_[_loc7_]);
                  }
               }
               _loc4_++;
            }
         }
         return _loc5_;
      }
   }
}

class InstanceBlocker
{
   
   public function InstanceBlocker()
   {
      super();
   }
}
