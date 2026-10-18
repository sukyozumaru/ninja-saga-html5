package ninjasaga.objects
{
   import br.com.stimuli.loading.BulkLoader;
   import com.utils.GF;
   import com.utils.Out;
   import com.utils.Sha1Encrypt;
   import flash.display.MovieClip;
   import flash.events.*;
   import flash.net.URLRequest;
   import flash.utils.*;
   import gs.*;
   import ninjasaga.*;
   import ninjasaga.base.CharacterBattle;
   import ninjasaga.data.BattleData;
   import ninjasaga.data.DBCharacterData;
   import ninjasaga.data.Formula;
   import ninjasaga.data.Timeline;
   import ninjasaga.dbclass.DBCharacter;
   
   public class Pet extends CharacterBattle
   {
      
      public var id:uint;
      
      public var swfName:String;
      
      public var clsName:String;
      
      private var _loadedSwf:MovieClip;
      
      private var petXpStr:String;
      
      private var _training:Object;
      
      private var verifyTrainingPet_CB:Function;
      
      private var _maturity:int;
      
      private var _requiredMaturity:int;
      
      private var _requiredLevel:int;
      
      private var _requirement:String;
      
      private var _petEP:int;
      
      public function Pet(param1:DBCharacter, param2:String, param3:String)
      {
         super();
         this.type = 5;
         this.dbChar = param1;
         this.dbChar[DBCharacterData.LEVEL] = Formula.getPetLvByXp(this.dbChar[DBCharacterData.XP]);
         this.swfName = param2;
         this.clsName = param3;
         this.petXpStr = Sha1Encrypt.encrypt(String(this.xp));
         var _loc4_:Array = Central.main.PET_DATA.toArray();
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_.length)
         {
            if(_loc4_[_loc5_].swfName == this.swfName)
            {
               this.id = uint(_loc4_[_loc5_].id);
               this.dbChar[DBCharacterData.PET_MAX_EP] = uint(_loc4_[_loc5_].ep_max);
               break;
            }
            _loc5_++;
         }
      }
      
      public function set loadedSwf(param1:MovieClip) : void
      {
         var _loc2_:uint = 0;
         Out.debug(this,this.getCharacterId() + " :: loadedSwf");
         this._loadedSwf = param1;
         this.actionBase = GF.getAsset(this._loadedSwf,this.clsName);
         Out.debug(this,"loadedSwf=" + this._loadedSwf + ", clsName=" + this.clsName);
         this.actionBase.setActionFinishCB(this.actionFinish_CB);
         this.actionBase.setAttackHitCB(this.attackHit_CB);
         this.setupAvailableSkills();
         this.setupDamage();
         var _loc3_:Array = this.actionBase.skillData;
         _loc2_ = 0;
         while(_loc2_ < _loc3_.length)
         {
            if(_loc3_[_loc2_])
            {
               if(Number(_loc3_[_loc2_].damageBonus) > Main.coreData.PET_MAX_DAMAGE_BONUS)
               {
                  Out.error(this,"Error >> " + Main.coreData.PET_DAMAGE_ERROR);
                  Main.getMainChar().datafileHack = Main.coreData.PET_DAMAGE_ERROR;
                  Main.onError();
               }
            }
            _loc2_++;
         }
      }
      
      override public function setBattleAction(param1:Object = null) : void
      {
         var _loc2_:Object = null;
         if(this.securityCheck())
         {
            if(param1)
            {
               this.battleAction = param1;
            }
            else if(this.isBattleDebuffActive(BattleData.EFFECT_BUNDLE))
            {
               _loc2_ = {"action":"pass"};
               this.battleAction = _loc2_;
               this.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(325));
            }
            else if(this.isBattleDebuffActive(BattleData.SKILL_377))
            {
               _loc2_ = {"action":"pass"};
               this.battleAction = _loc2_;
               this.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(325));
            }
            else
            {
               this.battleAction = this.actionBase.getBattleAction(this.petId);
            }
         }
         if(this.battleAction)
         {
            if(this.battleAction.dmg)
            {
               if(Main.petExtraDmg)
               {
                  if(Math.abs(int(this.battleAction.dmg)) > Math.round(Main.coreData.PET_MAX_DAMAGE_PER_LEVEL * this.getLevel() + Main.petExtraDmgAmount) || this.isEquipped() && this.getLevel() > Main.getMainChar().getLevel())
                  {
                     Main.petExtraDmgAmount = 0;
                     Out.error(this,"Error >> " + Main.coreData.PET_DAMAGE_ERROR);
                     Main.getMainChar().datafileHack = Main.coreData.PET_DAMAGE_ERROR;
                     Main.onError("2974","");
                  }
               }
               else if(Math.abs(int(this.battleAction.dmg)) > Math.round(Main.coreData.PET_MAX_DAMAGE_PER_LEVEL * this.getLevel()) || this.isEquipped() && this.getLevel() > Main.getMainChar().getLevel())
               {
                  Out.error(this,"Error >> " + Main.coreData.PET_DAMAGE_ERROR);
                  Main.getMainChar().datafileHack = Main.coreData.PET_DAMAGE_ERROR;
                  Main.onError("2974","");
               }
            }
         }
      }
      
      public function getStaticFullBody() : MovieClip
      {
         return GF.getAsset(this._loadedSwf,"StaticFullBody");
      }
      
      public function getPetIcon() : MovieClip
      {
         return GF.getAsset(this._loadedSwf,"icon");
      }
      
      public function get xp() : uint
      {
         return this.getData(DBCharacterData.XP);
      }
      
      public function trainUpdateXP(param1:uint) : Boolean
      {
         if(param1 < 0)
         {
            param1 = 0;
         }
         if(param1 == 0)
         {
            return false;
         }
         this.dbChar.character_xp += param1;
         this.petXpStr = Sha1Encrypt.encrypt(String(this.xp));
         var _loc2_:uint = Formula.getPetLvByXp(this.xp);
         if(_loc2_ > this.dbChar.character_level)
         {
            this.dbChar.character_level = _loc2_;
            this.restoreOriginalStatus();
            return true;
         }
         if(this.dbChar.character_level > _loc2_)
         {
            this.dbChar.character_level = _loc2_;
            this.restoreOriginalStatus();
            Main.saveCharacter();
         }
         return false;
      }
      
      public function updateXP(param1:uint) : Boolean
      {
         if(Main.getMainChar().pet == null)
         {
            return false;
         }
         if(this.getData(DBCharacterData.ID) != Main.getMainChar().pet.getData(DBCharacterData.ID))
         {
            return false;
         }
         if(param1 < 0)
         {
            param1 = 0;
         }
         if(param1 == 0)
         {
            return false;
         }
         if(!this.securityCheck())
         {
            return false;
         }
         this.dbChar.character_xp += param1;
         this.petXpStr = Sha1Encrypt.encrypt(String(this.xp));
         var _loc2_:uint = Formula.getPetLvByXp(this.xp);
         if(_loc2_ > this.dbChar.character_level)
         {
            this.dbChar.character_level = _loc2_;
            this.restoreOriginalStatus();
            this.setupDamage();
            return true;
         }
         if(this.dbChar.character_level > _loc2_)
         {
            this.dbChar.character_level = _loc2_;
            this.restoreOriginalStatus();
            Main.saveCharacter();
         }
         return false;
      }
      
      public function get skillData() : Array
      {
         Out.debug("Pet",".actionBase >> " + this.actionBase);
         return this.actionBase.skillData;
      }
      
      public function getSkillIcon(param1:uint) : MovieClip
      {
         return GF.getAsset(this._loadedSwf,this.skillData[param1].cls);
      }
      
      public function setupAvailableSkills() : void
      {
         this.actionBase.setupAvailableSkills(this.getData(DBCharacterData.SKILLS));
      }
      
      public function setupDamage() : void
      {
         this.actionBase.setupDamage(this.getLevel());
      }
      
      public function getDamage() : int
      {
         return this.actionBase.getDamage();
      }
      
      public function getPetId() : uint
      {
         return this.dbChar.character_id;
      }
      
      public function get petId() : uint
      {
         return this.dbChar.character_id;
      }
      
      public function isEquipped() : Boolean
      {
         if(Main.getMainChar().pet)
         {
            if(Main.getMainChar().pet.petId == this.dbChar.character_id)
            {
               return true;
            }
            return false;
         }
         return false;
      }
      
      public function securityCheck() : Boolean
      {
         var _loc1_:String = Sha1Encrypt.encrypt(String(this.xp));
         if(_loc1_ != this.petXpStr)
         {
            Main.saveLog(1,String(this.xp));
            Main.onError();
            return false;
         }
         return true;
      }
      
      public function resetSkillCooldown() : void
      {
         this.actionBase.resetSkillCooldown();
      }
      
      public function get training() : Object
      {
         return _training;
      }
      
      public function set training(param1:Object) : void
      {
         this._training = param1;
      }
      
      public function get maturity() : int
      {
         return _maturity;
      }
      
      public function set maturity(param1:int) : void
      {
         this._maturity = param1;
      }
      
      public function get requiredMaturity() : int
      {
         return _requiredMaturity;
      }
      
      public function set requiredMaturity(param1:int) : void
      {
         this._requiredMaturity = param1;
      }
      
      public function get requiredLevel() : int
      {
         return _requiredLevel;
      }
      
      public function set requiredLevel(param1:int) : void
      {
         this._requiredLevel = param1;
      }
      
      public function get requirement() : String
      {
         return _requirement;
      }
      
      public function set requirement(param1:String) : void
      {
         this._requirement = param1;
      }
      
      public function get petEP() : int
      {
         return this._petEP;
      }
      
      public function set petEP(param1:int) : void
      {
         this._petEP = param1;
      }
      
      public function decRemainTimer() : Boolean
      {
         if(this._training)
         {
            if(this._training.remainTimer)
            {
               if(this._training.remainTimer > 0)
               {
                  --this._training.remainTimer;
                  return true;
               }
            }
         }
         return false;
      }
      
      public function getPetClassName() : String
      {
         return this.clsName;
      }
   }
}

