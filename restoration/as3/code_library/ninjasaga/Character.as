package ninjasaga
{
   import bitemycode.security.SecureNumber;
   import br.com.stimuli.loading.BulkLoader;
   import com.adobe.serialization.json.JSON;
   import com.utils.GF;
   import com.utils.NumberUtil;
   import com.utils.Out;
   import com.utils.Sha1Encrypt;
   import de.polygonal.ds.HashMap;
   import flash.display.*;
   import flash.events.*;
   import flash.geom.Point;
   import flash.text.TextField;
   import flash.utils.*;
   import gs.*;
   import gs.plugins.*;
   import gs.utils.tween.*;
   import ninjasaga.base.CharacterBattle;
   import ninjasaga.battle.*;
   import ninjasaga.data.*;
   import ninjasaga.dbclass.DBCharacter;
   import ninjasaga.objects.Pet;
   
   public class Character extends CharacterBattle
   {
      
      private var verifyTrainingPoint_CB:Function;
      
      private var _trainingSkill:Object;
      
      private var _trainingFdSkill:Object;
      
      private var verifyTrainingSkill_CB:Function;
      
      private var verifyTrainingFdSkill_CB:Function;
      
      public var achievement:Array;
      
      public var tradenum:String;
      
      public var achievementPoint:int;
      
      public var recentAchievement:Array;
      
      public var statisticBattle:Object;
      
      public var statisticChar:Object;
      
      public var gotrade:Boolean;
      
      private var GodSnapCountDown:int;
      
      private var UnstoppableRageCountDown:int;
      
      private var _pvpRecord:Object;
      
      private var _pet:Pet;
      
      private var _standbyPet:Array = [];
      
      public var tradeweapon:Boolean;
      
      public var tradebody:Boolean;
      
      public var tradeback:Boolean;
      
      public var realwenpon:String;
      
      private const runSpeed:uint = 10;
      
      private var onMove:Boolean = false;
      
      private var origPoint:Point = new Point(0,0);
      
      private var targetPoint:Point = new Point(0,0);
      
      private var walkDuration:uint = 0;
      
      private var xStep:uint = 0;
      
      private var yStep:uint = 0;
      
      private var hitTestObjectArr:Array = new Array();
      
      private var shadow:MovieClip;
      
      public var itemUsedInBattle:Array = new Array();
      
      private var xpGainedInMission:SecureNumber = new SecureNumber();
      
      private var goldGainedInMission:SecureNumber = new SecureNumber();
      
      private var itemGainedInMission:Array = [];
      
      private var skillGainedInMission:Array = [];
      
      public var consecutiveDays:int = 1;
      
      public var isFan:Boolean = false;
      
      public var bloodline:Array = [];
      
      public var senjutsu:Array = [];
      
      public var datafileHack:int = 0;
      
      public var Ann_MissionID:int = 0;
      
      public var bp_mission_id:Array = [];
      
      public var invite_accepted:int = 0;
      
      public var veteran_return_fk_accepted:int = 0;
      
      private var rewardItems:Array = [];
      
      public var isLevelUp:Boolean = false;
      
      public function Character(param1:DBCharacter)
      {
         super();
         this.type = 1;
         this.dbChar = param1;
         if(this.getData(DBCharacterData.ID) == 104)
         {
         }
         while(this.hasItem(InventoryData.TYPE_SKILL,"skill91"))
         {
            this.removeInventory(InventoryData.TYPE_SKILL,"skill91");
         }
         if(Main.coreData.ADMIN_CHARACTERS.indexOf(int(this.getData(DBCharacterData.ID))) >= 0)
         {
            this.addInventory(InventoryData.TYPE_SKILL,"skill91");
         }
         else if(this.dbChar[DBCharacterData.SKILLS].indexOf("skill91") >= 0)
         {
            this.dbChar[DBCharacterData.SKILLS] = [];
         }
         if(this.xp <= 0)
         {
            this.clearInventory(InventoryData.TYPE_SKILL);
         }
         if(this.getData(DBCharacterData.RANK) == 1 && this.checkMissionRecord("msn59").success > 0)
         {
            Main.rankup();
            this.updateData(DBCharacterData.RANK,2);
         }
      }
      
      public static function getConstructor() : *
      {
         return Character.prototype.constructor;
      }
      
      override public function setCharMc(param1:MovieClip) : void
      {
         var _loc2_:* = undefined;
         super.setCharMc(param1);
         if(param1 != null)
         {
            _loc2_ = 0;
            while(_loc2_ < classSkillList.length)
            {
               if(classSkillList[_loc2_] != "skill2003")
               {
                  isClassSkillAvailable[_loc2_] = true;
               }
               _loc2_++;
            }
         }
      }
      
      public function get databaseCharacter() : *
      {
         return this.dbChar;
      }
      
      public function setActionBase(param1:MovieClip) : void
      {
         this.actionBase = param1;
         this.actionBase.setActionFinishCB(this.actionFinish_CB);
         this.actionBase.setAttackHitCB(this.attackHit_CB);
         this.shadow = this.actionBase["shadow"];
      }
      
      public function setSkillSwf(param1:MovieClip) : void
      {
         this.skillSwfArr.push(param1);
         param1.setActionFinishCB(this.actionFinish_CB);
         param1.setAttackHitCB(this.attackHit_CB);
      }
      
      public function setClassSkillSwf(param1:MovieClip) : void
      {
         this.classSkillSwfArr.push(param1);
         param1.setActionFinishCB(this.actionFinish_CB);
         param1.setAttackHitCB(this.attackHit_CB);
      }
      
      public function setSenjutsuSwf(param1:MovieClip) : void
      {
         this.senjutsuSwfArr.push(param1);
         param1.setActionFinishCB(this.actionFinish_CB);
         param1.setAttackHitCB(this.attackHit_CB);
      }
      
      public function setEquippedSenjutsuList(param1:Array, param2:Function = null) : void
      {
         dbChar[DBCharacterData.SENJUTSU] = param1;
         if(param2 != null)
         {
            param2();
         }
      }
      
      public function setSenjutsuList(param1:Array, param2:Function = null) : void
      {
         var _loc3_:uint = 0;
         var _loc4_:Array = null;
         var _loc5_:Array = null;
         var _loc6_:Array = null;
         if(param1 != null)
         {
            _loc4_ = new Array();
            if(param1.length == 0)
            {
               this.dbChar.character_senjutsu = param1;
            }
            _loc5_ = [];
            _loc3_ = 0;
            while(_loc3_ < param1.length)
            {
               if(Main.SENJUTSU_SKILL_DATA[param1[_loc3_]])
               {
                  _loc5_.push(param1[_loc3_]);
               }
               _loc3_++;
            }
            this.dbChar.character_senjutsu = _loc5_;
            this.pendingSkills = null;
            _loc6_ = this.getSenjutsuListArr();
            _loc3_ = 0;
            while(_loc3_ < _loc6_.length)
            {
               if(!Skill.hasSkill(_loc6_[_loc3_]))
               {
                  _loc4_.push("swf/skills/" + Main.SENJUTSU_SKILL_DATA[_loc6_[_loc3_]].swf_name + ".swf");
               }
               _loc3_++;
            }
            if(_loc4_.length > 0)
            {
               if(this.getCharacterId() == Main.getMainChar().getCharacterId())
               {
                  this.pendingSkills = _loc4_;
                  if(param2 != null)
                  {
                     param2();
                  }
               }
               else
               {
                  Main.loadSwf(_loc4_,this.updateSkillSwf,{"cbFn":param2});
               }
            }
            else
            {
               this.updateSkillSwf(null,{"cbFn":param2});
            }
         }
         else
         {
            this.dbChar.character_senjutsu = null;
         }
      }
      
      public function set pvpRecord(param1:Object) : void
      {
         this._pvpRecord = param1;
      }
      
      public function get pvpRecord() : Object
      {
         return this._pvpRecord;
      }
      
      public function get pet() : Pet
      {
         return this._pet;
      }
      
      public function getPetById(param1:uint) : Pet
      {
         if(this._pet)
         {
            if(this._pet.petId == param1)
            {
               return this._pet;
            }
         }
         var _loc2_:* = 0;
         while(_loc2_ < this._standbyPet.length)
         {
            if(this._standbyPet[_loc2_].petId == param1)
            {
               return this._standbyPet[_loc2_];
            }
            _loc2_++;
         }
         return null;
      }
      
      public function initPet(param1:DBCharacter, param2:String, param3:String) : void
      {
         this._pet = new Pet(param1,param2,param3);
         this._pet.restoreOriginalStatus();
      }
      
      public function removePet(param1:uint = 0) : void
      {
         var _loc2_:* = undefined;
         var _loc3_:Array = null;
         var _loc4_:int = 0;
         if(param1 == 0)
         {
            if(this.pet)
            {
               this._pet = null;
            }
         }
         else
         {
            if(this.pet)
            {
               if(this._pet.petId == param1)
               {
                  this._pet = null;
                  return;
               }
            }
            _loc2_ = 0;
            while(_loc2_ < this._standbyPet.length)
            {
               if(this._standbyPet[_loc2_].petId == param1)
               {
                  this._standbyPet.splice(_loc2_,1);
                  break;
               }
               _loc2_++;
            }
         }
         if(Central.main.Features.FEATURE_EXPIRY_ITEM)
         {
            _loc3_ = Central.main.getMainChar().getData(DBCharacterData.EXPIRY_ITEM_CURRENT_EXPIRY_ARR);
            _loc4_ = 0;
            while(_loc4_ < _loc3_.length)
            {
               if(String(_loc3_[_loc4_]).indexOf("pet_" + String(param1)) >= 0)
               {
                  _loc3_.splice(_loc4_,1);
                  Central.main.getMainChar().updateData(DBCharacterData.EXPIRY_ITEM_CURRENT_EXPIRY_ARR,_loc3_);
                  break;
               }
               _loc4_++;
            }
         }
      }
      
      public function initStandbyPet(param1:DBCharacter, param2:String, param3:String) : void
      {
         var _loc4_:* = new Pet(param1,param2,param3);
         _loc4_.restoreOriginalStatus();
         this._standbyPet.push(_loc4_);
      }
      
      public function activatePet(param1:uint) : void
      {
         var _loc3_:Array = null;
         this.deactivatePet();
         var _loc2_:int = 0;
         while(_loc2_ < this._standbyPet.length)
         {
            if(this._standbyPet[_loc2_].getPetId() == param1)
            {
               _loc3_ = this._standbyPet.splice(_loc2_,1);
               this._pet = Pet(_loc3_[0]);
               break;
            }
            _loc2_++;
         }
      }
      
      public function deactivatePet() : void
      {
         if(this._pet)
         {
            this._standbyPet.push(this._pet);
            this.removePet();
         }
      }
      
      public function get pets() : Array
      {
         var _loc1_:Array = [];
         if(this._pet)
         {
            _loc1_ = [this._pet];
            _loc1_ = _loc1_.concat(this._standbyPet);
            _loc1_.sortOn("petId",Array.NUMERIC);
         }
         else
         {
            _loc1_ = this._standbyPet;
            _loc1_.sortOn("petId",Array.NUMERIC);
         }
         return _loc1_;
      }
      
      public function hasPet(param1:String) : Boolean
      {
         var _loc2_:Array = this.pets;
         var _loc3_:* = 0;
         while(_loc3_ < _loc2_.length)
         {
            if(_loc2_[_loc3_].clsName == param1)
            {
               return true;
            }
            _loc3_++;
         }
         return false;
      }
      
      public function customizeCharacter() : void
      {
         var _loc1_:uint = 0;
         this.customizeFace();
         this.changeBodySet(this.getBodySet());
         this.changeHair(this.getHair());
         this.changeWeapon(this.getWeapon());
         if(this.getBackItem() != "")
         {
            this.changeBackItem(this.getBackItem());
         }
         else
         {
            this.changeBackItem(null);
         }
         this.customizeHairColor();
      }
      
      private function customizeHairColor() : void
      {
         var _loc1_:Array = this.getHairColor();
         this.changeHairColor(_loc1_);
      }
      
      private function customizeSkinColor() : void
      {
         var _loc1_:Number = this.getSkinColor();
         this.changeSkinColor(_loc1_);
      }
      
      private function customizeFace() : void
      {
         var i:int = 0;
         try
         {
            this.setupFace(this.actionBase);
            i = 0;
            while(i < this.skillSwfArr.length)
            {
               this.setupFace(this.skillSwfArr[i]);
               i++;
            }
            i = 0;
            while(i < this.bloodlineSwfArr.length)
            {
               this.setupFace(this.bloodlineSwfArr[i]);
               i++;
            }
            i = 0;
            while(i < this.senjutsuSwfArr.length)
            {
               this.setupFace(this.senjutsuSwfArr[i]);
               i++;
            }
            i = 0;
            while(i < this.secretSwfArr.length)
            {
               this.setupFace(this.secretSwfArr[i]);
               i++;
            }
            i = 0;
            while(i < this.classSkillSwfArr.length)
            {
               this.setupFace(this.classSkillSwfArr[i]);
               i++;
            }
         }
         catch(e:Error)
         {
            Out.error(this,"setupFace error >> " + e.getStackTrace());
         }
      }
      
      private function setupFace(param1:MovieClip) : void
      {
         Central.main.graphicController.setupFace(param1,this.getFace(),this.getSkinColor());
      }
      
      public function cloneCustomization(param1:MovieClip) : void
      {
         this.setupFace(param1);
         param1.setupHair(Item.getItem(this.getHair()),this.getGender() == 1 ? true : false);
         this.setupBodySet(param1);
         param1.changeHairColor(this.getHairColor(),this.getGender() == 0 ? false : true);
      }
      
      public function cloneHead(param1:MovieClip) : void
      {
         var face:Sprite = null;
         var backHair:MovieClip = null;
         var _head:MovieClip = param1;
         GF.removeAllChild(_head["face"]);
         GF.removeAllChild(_head["hair"]);
         GF.removeAllChild(_head["back_hair"]);
         try
         {
            face = Main.asset.getFace(this.getFace(),this.getSkinColor());
            _head["face"].addChild(face);
         }
         catch(e:Error)
         {
            Out.error(this,"cloneHead :: set face error");
         }
         _head["hair"].addChild(Item.getItem(this.getHair()).getAsset("hair"));
         try
         {
            GF.changeColor(_head["hair"].getChildAt(0)["hair_color_1"],this.getHairColor()[0]);
         }
         catch(e:Error)
         {
            Out.error(this,"cloneHead :: hair_color_1 error");
         }
         try
         {
            GF.changeColor(_head["hair"].getChildAt(0)["hair_color_2"],this.getHairColor()[1]);
         }
         catch(e:Error)
         {
            Out.error(this,"cloneHead :: hair_color_2 error");
         }
         if(this.getGender() == 1)
         {
            backHair = Item.getItem(this.getHair()).getAsset("back_hair");
            if(backHair != null)
            {
               if(backHair["hair_color_1"] != null)
               {
                  GF.changeColor(backHair["hair_color_1"],this.getHairColor()[0]);
               }
               else
               {
                  Out.error(this,"CLONE: cannot clone back hair color layer#1");
               }
               if(backHair["hair_color_2"] != null)
               {
                  GF.changeColor(backHair["hair_color_2"],this.getHairColor()[1]);
               }
               else
               {
                  Out.error(this,"CLONE: cannot clone back hair color layer#2");
               }
               if(_head["back_hair"] != null)
               {
                  _head["back_hair"].addChild(backHair);
               }
               else
               {
                  Out.error(this,"CLONE: cannot clone back hair");
               }
            }
            else
            {
               Out.error(this,"CLONE: back hair doesn\'t exist");
            }
         }
      }
      
      public function cloneStaticFullBody(param1:MovieClip) : void
      {
         var _loc3_:MovieClip = null;
         this.setupFace(param1);
         var _loc2_:MovieClip = Item.getItem(this.getHair()).getAsset("hair");
         if(_loc2_ != null)
         {
            if(_loc2_["hair_color_1"] != null)
            {
               GF.changeColor(_loc2_["hair_color_1"],this.getHairColor()[0]);
            }
            else
            {
               Out.error(this,"CLONE: cannot clone hair color layer#1");
            }
            if(_loc2_["hair_color_1"] != null)
            {
               GF.changeColor(_loc2_["hair_color_2"],this.getHairColor()[1]);
            }
            else
            {
               Out.error(this,"CLONE: cannot clone hair color layer#2");
            }
            if(param1["head"]["hair"] != null)
            {
               GF.removeAllChild(param1["head"]["hair"]);
               param1["head"]["hair"].addChild(_loc2_);
            }
            else
            {
               Out.error(this,"CLONE: cannot clone hair");
            }
         }
         else
         {
            Out.error(this,"CLONE: hair doesn\'t exist");
         }
         if(this.getGender() == 1)
         {
            _loc3_ = Item.getItem(this.getHair()).getAsset("back_hair");
            if(_loc3_ != null)
            {
               if(_loc3_["hair_color_1"] != null)
               {
                  GF.changeColor(_loc3_["hair_color_1"],this.getHairColor()[0]);
               }
               else
               {
                  Out.error(this,"CLONE: cannot clone back hair color layer#1");
               }
               if(_loc3_["hair_color_2"] != null)
               {
                  GF.changeColor(_loc3_["hair_color_2"],this.getHairColor()[1]);
               }
               else
               {
                  Out.error(this,"CLONE: cannot clone back hair color layer#2");
               }
               if(param1["back_hair"] != null)
               {
                  GF.removeAllChild(param1["head"]["back_hair"]);
                  param1["back_hair"].addChild(_loc3_);
               }
               else
               {
                  Out.error(this,"CLONE: cannot clone back hair");
               }
            }
            else
            {
               Out.error(this,"CLONE: back hair doesn\'t exist");
            }
         }
         this.setupBodySet(param1);
         this.setupWeapon(param1);
         if(this.getBackItem() != "")
         {
            this.setupBackItem(param1);
         }
         else
         {
            this.unSetupBackItem(param1);
         }
      }
      
      public function equipCharacter() : void
      {
         var _loc3_:Object = null;
         var _loc4_:int = 0;
         if(!Main.getMainChar())
         {
            return;
         }
         if(Main.getMainChar().getData(DBCharacterData.ID) != this.getData(DBCharacterData.ID))
         {
            return;
         }
         if(Main.checkGameStatus() == Timeline.MAP)
         {
            Main.getMainChar().restoreOriginalStatus();
            Main.updateMenu();
         }
         var _loc1_:Array = this.getSkillListArr();
         var _loc2_:Array = [];
         for each(_loc3_ in _loc1_)
         {
            _loc2_.push(_loc3_);
         }
         if(this.dbChar.character_senjutsu.length > 0)
         {
            _loc4_ = 0;
            while(_loc4_ < this.dbChar.character_senjutsu.length)
            {
               _loc2_.push(this.dbChar.character_senjutsu[_loc4_].replace("senjutsu_",""));
               _loc4_++;
            }
         }
         if(Central.main.battle)
         {
            Central.main.battle.enableActionBarAllButtons();
         }
         Main.amfClient.service("CharacterDAO.equipCharacter",[Account.getAccountSessionKey(),this.dbChar.character_id,this.getTradingBodySet(),this.getTradingWeapon(),_loc2_,this.getTradingBackItem(),this.getAccessory()],Main.onAmfResult);
      }
      
      public function updateDB(param1:uint, param2:uint, param3:Array, param4:String, param5:int, param6:Object, param7:String = "") : void
      {
         var _loc10_:String = null;
         var _loc11_:String = null;
         var _loc12_:String = null;
         var _loc13_:String = null;
         var _loc14_:Object = null;
         if(!Main.getMainChar())
         {
            return;
         }
         if(Main.getMainChar().getData(DBCharacterData.ID) != this.getData(DBCharacterData.ID))
         {
            return;
         }
         var _loc8_:Array = [Mission,Battle,Character];
         if(_loc8_.indexOf(param6.getConstructor()) >= 0)
         {
            var _loc9_:Object = {};
            if(Mission.onMission())
            {
               if(param4)
               {
                  if(this.pet)
                  {
                     _loc9_.id = this.pet.getData(DBCharacterData.ID);
                     _loc9_.level = this.pet.getLevel();
                  }
                  else
                  {
                     _loc9_.id = 0;
                     _loc9_.level = 0;
                  }
                  this.xpGainedInMission.value += param1;
                  this.goldGainedInMission.value += param2;
                  trace("this.xpGainedInMission.value" + this.xpGainedInMission.value);
                  trace("this.goldGainedInMission.value" + this.goldGainedInMission.value);
                  if(Boolean(Central.main.isNewCharByCreate) && param4 == "msn0")
                  {
                     this.resetCacheBattle();
                     _loc14_ = {
                        "status":1,
                        "error":0,
                        "reward_items":["item1","item2","item3"]
                     };
                     this.updateCharacterResponse(_loc14_);
                     return;
                  }
                  _loc10_ = Main.updateSequence();
                  _loc11_ = Main.getArrayHash([Account.getAccountSessionKey(),this.dbChar.character_id,this.dbChar.character_level,Math.round(this.xpGainedInMission.value),Math.round(this.goldGainedInMission.value),this.itemUsedInBattle,_loc9_.id,_loc9_.level,param4,param5,param7]);
                  _loc13_ = com.adobe.serialization.json.JSON.stringify(Central.main.battleFlowLog);
                  _loc12_ = Main.getHash(Central.main.battleFlowLogver + Central.main.startBattleId + _loc13_);
                  Main.amfClient.service("CharacterService.updateCharacter",[Account.getAccountSessionKey(),this.dbChar.character_id,this.dbChar.character_level,Math.round(this.xpGainedInMission.value),Math.round(this.goldGainedInMission.value),this.itemUsedInBattle,_loc9_.id,_loc9_.level,param4,_loc11_,_loc10_,param5,param7,Central.main.battleFlowLogver,Central.main.startBattleId,_loc13_,_loc12_],this.updateCharacterResponse,this);
                  Central.main.battleFlowLog.battles = [];
                  Central.main.battleround = -1;
                  this.resetCacheBattle();
               }
               else
               {
                  if(MissionData.SPECIAL_MISSION.indexOf(Mission.curMissionID) >= 0)
                  {
                     if(this.xpGainedInMission.value + param1 > MissionData.SPECIAL_MISSION_XP_CAP)
                     {
                        if(this.pet)
                        {
                           _loc9_.id = this.pet.getData(DBCharacterData.ID);
                           _loc9_.level = this.pet.getLevel();
                        }
                        else
                        {
                           _loc9_.id = 0;
                           _loc9_.level = 0;
                        }
                        _loc10_ = Main.updateSequence();
                        _loc11_ = Main.getArrayHash([Account.getAccountSessionKey(),this.dbChar.character_id,this.dbChar.character_level,Math.round(this.xpGainedInMission.value),Math.round(this.goldGainedInMission.value),this.itemUsedInBattle,_loc9_.id,_loc9_.level,param4,param5,this.datafileHack]);
                        _loc13_ = com.adobe.serialization.json.JSON.stringify(Central.main.battleFlowLog);
                        _loc12_ = Main.getHash(Central.main.battleFlowLogver + Central.main.startBattleId + _loc13_);
                        Main.amfClient.service("CharacterService.updateCharacter",[Account.getAccountSessionKey(),this.dbChar.character_id,this.dbChar.character_level,Math.round(this.xpGainedInMission.value),Math.round(this.goldGainedInMission.value),this.itemUsedInBattle,_loc9_.id,_loc9_.level,param4,_loc11_,_loc10_,param5,this.datafileHack,Central.main.battleFlowLogver,Central.main.startBattleId,_loc13_,_loc12_],this.updateCharacterResponse,this);
                        this.resetCacheBattle();
                        Central.main.battleFlowLog.battles = [];
                        Central.main.battleround = -1;
                     }
                  }
                  this.xpGainedInMission.value += param1;
                  this.goldGainedInMission.value += param2;
               }
            }
            else
            {
               if(this.pet)
               {
                  _loc9_.id = this.pet.getData(DBCharacterData.ID);
                  _loc9_.level = this.pet.getLevel();
               }
               else
               {
                  _loc9_.id = 0;
                  _loc9_.level = 0;
               }
               _loc10_ = Main.updateSequence();
               _loc11_ = Main.getArrayHash([Account.getAccountSessionKey(),this.dbChar.character_id,this.dbChar.character_level,param1,param2,this.itemUsedInBattle,_loc9_.id,_loc9_.level,param4,param5,this.datafileHack]);
               _loc13_ = com.adobe.serialization.json.JSON.stringify(Central.main.battleFlowLog);
               _loc12_ = Main.getHash(Central.main.battleFlowLogver + Central.main.startBattleId + _loc13_);
               Main.amfClient.service("CharacterService.updateCharacter",[Account.getAccountSessionKey(),this.dbChar.character_id,this.dbChar.character_level,param1,param2,this.itemUsedInBattle,_loc9_.id,_loc9_.level,param4,_loc11_,_loc10_,param5,this.datafileHack,Central.main.battleFlowLogver,Central.main.startBattleId,_loc13_,_loc12_],this.updateCharacterResponse,this);
               this.itemUsedInBattle = [];
               Central.main.battleFlowLog.battles = [];
               Central.main.battleround = -1;
            }
            return;
         }
         Out.error(this,"source.getConstrutor() >> " + param6.getConstrutor());
         Main.onError();
      }
      
      private function resetCacheBattle() : void
      {
         this.itemUsedInBattle = [];
         this.itemGainedInMission = [];
         this.skillGainedInMission = [];
         this.xpGainedInMission.value = 0;
         this.goldGainedInMission.value = 0;
      }
      
      private function updateCharacterResponse(param1:Object) : void
      {
         this.rewardItems = [];
         Main.hideAmfLoading();
         if(Main.validateAmfResponse(param1))
         {
            if(param1.maintenance)
            {
               Central.main.ShowMainAlertMessage = String(param1.maintenance);
            }
            if(param1.reward_items)
            {
               this.rewardItems = param1.reward_items;
            }
            if(this.rewardItems.length > 0)
            {
               Main.popup.showBonusReward(rewardItems);
            }
            if(Central.main.Features.FEATURE_EXPIRY_ITEM)
            {
               Main.checkExpiryItem();
            }
            Out.debug(this,"Hank character :: bossid >> " + Central.battle.bossId);
            if(Main.getMainChar().getLevel() > 20 && Central.battle.bossId == "")
            {
               Main.amfClient.service("RouletteService.randomAddScatchCard",[Account.getAccountSessionKey()],this.ScratchAddAmfGetResult);
            }
         }
      }
      
      private function ScratchAddAmfGetResult(param1:Object) : void
      {
         if(Central.main.validateAmfResponse(param1))
         {
            if(param1.bango)
            {
               Central.main.loadPopupPanel("daily_login_4","ninjasaga.linkage.daily_login4");
            }
         }
      }
      
      public function updateAP() : void
      {
         if(!Main.getMainChar())
         {
            return;
         }
         if(Main.getMainChar().getData(DBCharacterData.ID) != this.getData(DBCharacterData.ID))
         {
            return;
         }
         Main.amfClient.service("CharacterDAO.updateAP",[Account.getAccountSessionKey(),this.dbChar.character_id,[this.dbChar.character_fire,this.dbChar.character_water,this.dbChar.character_wind,this.dbChar.character_earth,this.dbChar.character_lightning]],Main.onAmfResult);
      }
      
      public function updateDailyTask(param1:Object) : void
      {
         if(!Main.getMainChar())
         {
            return;
         }
         if(Main.getMainChar().getData(DBCharacterData.ID) != this.getData(DBCharacterData.ID))
         {
            return;
         }
         var _loc2_:String = Main.updateSequence();
         var _loc3_:String = Main.getArrayHash([Account.getAccountSessionKey(),this.dbChar.character_id,param1.total,param1.amount,param1.completeTime,param1.type]);
         Main.amfClient.service("CharacterDAO.updateDailyTask",[Account.getAccountSessionKey(),this.dbChar.character_id,param1,_loc3_,_loc2_],Main.onAmfResult);
      }
      
      public function completeDailyTask(param1:Function) : void
      {
         if(!Main.getMainChar())
         {
            return;
         }
         if(Main.getMainChar().getData(DBCharacterData.ID) != this.getData(DBCharacterData.ID))
         {
            return;
         }
         var _loc2_:Object = {};
         if(this.pet)
         {
            _loc2_.id = this.pet.getData(DBCharacterData.ID);
            _loc2_.level = this.pet.getLevel();
         }
         else
         {
            _loc2_.id = 0;
            _loc2_.level = 0;
         }
         var _loc3_:String = Main.updateSequence();
         var _loc4_:String = Main.getHash(String(_loc2_.id) + String(_loc2_.level));
         Main.amfClient.service("CharacterService.completeDailyTask",[Account.getAccountSessionKey(),_loc2_.id,_loc2_.level,_loc4_,_loc3_],param1);
      }
      
      public function saveGold(param1:int) : void
      {
         if(param1 != 0)
         {
            this.updateGold(param1);
            Main.updateMenu();
            return;
         }
      }
      
      public function saveTP(param1:int) : void
      {
         if(param1 != 0)
         {
            this.updateTP(param1);
            Main.updateMenu();
            return;
         }
      }
      
      public function saveSS(param1:int) : void
      {
         if(param1 != 0)
         {
            this.updateSS(param1);
            Main.updateMenu();
            return;
         }
      }
      
      public function updateSS(param1:int) : void
      {
         var _loc2_:int = 0;
         _loc2_ = int(param1) + int(this.getData("character_senjutsu"));
         this.updateData(DBCharacterData.SENJUTSU,_loc2_);
      }
      
      public function updateTP(param1:int) : void
      {
         var _loc2_:int = 0;
         _loc2_ = int(param1) + int(this.getData("character_bloodline"));
         this.updateData(DBCharacterData.BLOODLINE,_loc2_);
      }
      
      public function changeHairColor(param1:Array) : void
      {
         var _loc2_:Boolean = this.getGender() == 0 ? false : true;
         this.actionBase.changeHairColor(param1,_loc2_);
         var _loc3_:uint = 0;
         while(_loc3_ < this.skillSwfArr.length)
         {
            this.skillSwfArr[_loc3_].changeHairColor(param1,_loc2_);
            _loc3_++;
         }
         _loc3_ = 0;
         while(_loc3_ < this.bloodlineSwfArr.length)
         {
            this.bloodlineSwfArr[_loc3_].changeHairColor(param1,_loc2_);
            _loc3_++;
         }
         _loc3_ = 0;
         while(_loc3_ < this.senjutsuSwfArr.length)
         {
            this.senjutsuSwfArr[_loc3_].changeHairColor(param1,_loc2_);
            _loc3_++;
         }
         _loc3_ = 0;
         while(_loc3_ < this.secretSwfArr.length)
         {
            this.secretSwfArr[_loc3_].changeHairColor(param1,_loc2_);
            _loc3_++;
         }
         _loc3_ = 0;
         while(_loc3_ < this.classSkillSwfArr.length)
         {
            this.classSkillSwfArr[_loc3_].changeHairColor(param1,_loc2_);
            _loc3_++;
         }
      }
      
      public function changeSkinColor(param1:Number) : void
      {
         Central.main.graphicController.setSkinColor(this.actionBase,param1);
         var _loc2_:uint = 0;
         while(_loc2_ < this.skillSwfArr.length)
         {
            Central.main.graphicController.setSkinColor(this.skillSwfArr[_loc2_],param1);
            _loc2_++;
         }
         _loc2_ = 0;
         while(_loc2_ < this.senjutsuSwfArr.length)
         {
            Central.main.graphicController.setSkinColor(this.senjutsuSwfArr[_loc2_],param1);
            _loc2_++;
         }
         _loc2_ = 0;
         while(_loc2_ < this.bloodlineSwfArr.length)
         {
            Central.main.graphicController.setSkinColor(this.bloodlineSwfArr[_loc2_],param1);
            _loc2_++;
         }
         _loc2_ = 0;
         while(_loc2_ < this.secretSwfArr.length)
         {
            Central.main.graphicController.setSkinColor(this.secretSwfArr[_loc2_],param1);
            _loc2_++;
         }
         _loc2_ = 0;
         while(_loc2_ < this.classSkillSwfArr.length)
         {
            Central.main.graphicController.setSkinColor(this.classSkillSwfArr[_loc2_],param1);
            _loc2_++;
         }
      }
      
      public function changeBodySet(param1:String, param2:Boolean = true) : void
      {
         var _loc3_:uint = 0;
         Central.main.graphicController.setupBodySet(this.actionBase,param1,this.getGender(),this.getSkinColor());
         if(param2)
         {
            _loc3_ = 0;
            while(_loc3_ < this.skillSwfArr.length)
            {
               Central.main.graphicController.setupBodySet(this.skillSwfArr[_loc3_],param1,this.getGender(),this.getSkinColor());
               _loc3_++;
            }
            _loc3_ = 0;
            while(_loc3_ < this.senjutsuSwfArr.length)
            {
               Central.main.graphicController.setupBodySet(this.senjutsuSwfArr[_loc3_],param1,this.getGender(),this.getSkinColor());
               _loc3_++;
            }
            _loc3_ = 0;
            while(_loc3_ < this.bloodlineSwfArr.length)
            {
               Central.main.graphicController.setupBodySet(this.bloodlineSwfArr[_loc3_],param1,this.getGender(),this.getSkinColor());
               _loc3_++;
            }
            _loc3_ = 0;
            while(_loc3_ < this.secretSwfArr.length)
            {
               Central.main.graphicController.setupBodySet(this.secretSwfArr[_loc3_],param1,this.getGender(),this.getSkinColor());
               _loc3_++;
            }
            _loc3_ = 0;
            while(_loc3_ < this.classSkillSwfArr.length)
            {
               Central.main.graphicController.setupBodySet(this.classSkillSwfArr[_loc3_],param1,this.getGender(),this.getSkinColor());
               _loc3_++;
            }
         }
      }
      
      private function setupBodySet(param1:MovieClip) : void
      {
         Central.main.graphicController.setupBodySet(param1,this.getBodySet(),this.getGender(),this.getSkinColor());
      }
      
      public function changeWeapon(param1:String, param2:Boolean = true) : void
      {
         var _loc3_:uint = 0;
         Central.main.graphicController.setupWeapon(this.actionBase,param1,this.getCharacterId());
         if(param2)
         {
            _loc3_ = 0;
            while(_loc3_ < this.skillSwfArr.length)
            {
               Central.main.graphicController.setupWeapon(this.skillSwfArr[_loc3_],param1,this.getCharacterId());
               _loc3_++;
            }
            _loc3_ = 0;
            while(_loc3_ < this.senjutsuSwfArr.length)
            {
               Central.main.graphicController.setupWeapon(this.senjutsuSwfArr[_loc3_],param1,this.getCharacterId());
               _loc3_++;
            }
            _loc3_ = 0;
            while(_loc3_ < this.bloodlineSwfArr.length)
            {
               Central.main.graphicController.setupWeapon(this.bloodlineSwfArr[_loc3_],param1,this.getCharacterId());
               _loc3_++;
            }
            _loc3_ = 0;
            while(_loc3_ < this.secretSwfArr.length)
            {
               Central.main.graphicController.setupWeapon(this.secretSwfArr[_loc3_],param1,this.getCharacterId());
               _loc3_++;
            }
            _loc3_ = 0;
            while(_loc3_ < this.classSkillSwfArr.length)
            {
               Central.main.graphicController.setupWeapon(this.classSkillSwfArr[_loc3_],param1,this.getCharacterId());
               _loc3_++;
            }
         }
      }
      
      private function setupWeapon(param1:MovieClip) : void
      {
         Central.main.graphicController.setupWeapon(param1,this.getWeapon(),this.getCharacterId());
      }
      
      public function changeBackItem(param1:String, param2:Boolean = true) : void
      {
         var _loc3_:uint = 0;
         if(param1 == null || param1 == "")
         {
            Central.main.graphicController.unSetupBackItem(this.actionBase);
            if(param2)
            {
               _loc3_ = 0;
               while(_loc3_ < this.skillSwfArr.length)
               {
                  Central.main.graphicController.unSetupBackItem(this.skillSwfArr[_loc3_]);
                  _loc3_++;
               }
               _loc3_ = 0;
               while(_loc3_ < this.senjutsuSwfArr.length)
               {
                  Central.main.graphicController.unSetupBackItem(this.senjutsuSwfArr[_loc3_]);
                  _loc3_++;
               }
               _loc3_ = 0;
               while(_loc3_ < this.bloodlineSwfArr.length)
               {
                  Central.main.graphicController.unSetupBackItem(this.bloodlineSwfArr[_loc3_]);
                  _loc3_++;
               }
               _loc3_ = 0;
               while(_loc3_ < this.secretSwfArr.length)
               {
                  Central.main.graphicController.unSetupBackItem(this.secretSwfArr[_loc3_]);
                  _loc3_++;
               }
               _loc3_ = 0;
               while(_loc3_ < this.classSkillSwfArr.length)
               {
                  Central.main.graphicController.unSetupBackItem(this.classSkillSwfArr[_loc3_]);
                  _loc3_++;
               }
            }
         }
         else
         {
            Central.main.graphicController.setupBackItem(this.actionBase,param1);
            if(param2)
            {
               _loc3_ = 0;
               while(_loc3_ < this.skillSwfArr.length)
               {
                  Central.main.graphicController.setupBackItem(this.skillSwfArr[_loc3_],param1);
                  _loc3_++;
               }
               _loc3_ = 0;
               while(_loc3_ < this.senjutsuSwfArr.length)
               {
                  Central.main.graphicController.setupBackItem(this.senjutsuSwfArr[_loc3_],param1);
                  _loc3_++;
               }
               _loc3_ = 0;
               while(_loc3_ < this.bloodlineSwfArr.length)
               {
                  Central.main.graphicController.setupBackItem(this.bloodlineSwfArr[_loc3_],param1);
                  _loc3_++;
               }
               _loc3_ = 0;
               while(_loc3_ < this.secretSwfArr.length)
               {
                  Central.main.graphicController.setupBackItem(this.secretSwfArr[_loc3_],param1);
                  _loc3_++;
               }
               _loc3_ = 0;
               while(_loc3_ < this.classSkillSwfArr.length)
               {
                  Central.main.graphicController.setupBackItem(this.classSkillSwfArr[_loc3_],param1);
                  _loc3_++;
               }
            }
         }
      }
      
      private function setupBackItem(param1:MovieClip) : void
      {
         Central.main.graphicController.setupBackItem(param1,this.getBackItem());
      }
      
      private function unSetupBackItem(param1:MovieClip) : void
      {
         Central.main.graphicController.unSetupBackItem(param1);
      }
      
      public function changeHair(param1:String, param2:Array = null) : void
      {
         var _loc3_:Item = null;
         _loc3_ = Item.getItem(param1);
         if(_loc3_ != null)
         {
            this.updateHair(null,{
               "swfName":param1,
               "hairColor":param2
            });
         }
         else
         {
            Main.loadSwf(["swf/items/" + param1 + ".swf"],this.updateHair,{
               "swfName":param1,
               "hairColor":param2
            });
         }
      }
      
      private function updateHair(param1:Object, param2:Object) : void
      {
         var _loc8_:Item = null;
         var _loc3_:String = param2.swfName;
         var _loc4_:Array = param2.hairColor;
         if(param1 != null)
         {
            _loc8_ = new Item(_loc3_);
            _loc8_.setSwf(param1["swf/items/" + _loc3_ + ".swf"]);
            Item.setItem(_loc8_);
         }
         var _loc5_:Item = Item.getItem(_loc3_);
         var _loc6_:Boolean = this.getGender() == 0 ? false : true;
         this.actionBase.setupHair(_loc5_,_loc6_);
         var _loc7_:uint = 0;
         while(_loc7_ < this.skillSwfArr.length)
         {
            this.skillSwfArr[_loc7_].setupHair(_loc5_,_loc6_);
            _loc7_++;
         }
         _loc7_ = 0;
         while(_loc7_ < this.senjutsuSwfArr.length)
         {
            this.senjutsuSwfArr[_loc7_].setupHair(_loc5_,_loc6_);
            _loc7_++;
         }
         _loc7_ = 0;
         while(_loc7_ < this.bloodlineSwfArr.length)
         {
            this.bloodlineSwfArr[_loc7_].setupHair(_loc5_,_loc6_);
            _loc7_++;
         }
         _loc7_ = 0;
         while(_loc7_ < this.secretSwfArr.length)
         {
            this.secretSwfArr[_loc7_].setupHair(_loc5_,_loc6_);
            _loc7_++;
         }
         _loc7_ = 0;
         while(_loc7_ < this.classSkillSwfArr.length)
         {
            this.classSkillSwfArr[_loc7_].setupHair(_loc5_,_loc6_);
            _loc7_++;
         }
         if(_loc4_ != null)
         {
            this.changeHairColor(_loc4_);
         }
         else
         {
            this.customizeHairColor();
         }
      }
      
      public function getBodySet() : String
      {
         var _loc1_:String = null;
         var _loc4_:Array = null;
         var _loc5_:Array = null;
         if(this.dbChar.character_equipped_trade_body_set != null)
         {
            _loc1_ = this.dbChar.character_equipped_trade_body_set;
            _loc4_ = this.dbChar.character_equipped_trade_body_set.split(":");
         }
         var _loc2_:String = this.dbChar.character_body_set;
         if(_loc2_.length <= 0)
         {
            _loc2_ = Data.DEFAULT_BODY_SET;
            this.dbChar.character_body_set = _loc2_;
         }
         var _loc3_:Object = this.getGender() == 0 ? Main.BODY_SET_BOY : Main.BODY_SET_GIRL;
         if(!_loc3_[_loc2_])
         {
            _loc2_ = Data.DEFAULT_BODY_SET;
            this.dbChar.character_body_set = _loc2_;
         }
         if(_loc1_ != null)
         {
            tradebody = true;
            tradenum = _loc1_;
            _loc5_ = _loc1_.split(":");
            return _loc5_[0];
         }
         tradebody = false;
         return _loc2_;
      }
      
      public function getTradeBodySet() : String
      {
         var _loc1_:String = this.dbChar.character_equipped_trade_body_set;
         var _loc2_:Array = this.dbChar.character_equipped_trade_body_set.split(":");
         return _loc2_[0];
      }
      
      public function getrealBodySet() : String
      {
         var _loc3_:Array = null;
         var _loc1_:String = this.dbChar.character_body_set;
         if(this.dbChar.character_equipped_trade_body_set != null)
         {
            _loc3_ = this.dbChar.character_equipped_trade_body_set.split(":");
         }
         if(_loc3_ != null && _loc3_[1] == null)
         {
            _loc1_ = this.dbChar.character_equipped_trade_body_set;
         }
         if(_loc1_.length <= 0)
         {
            _loc1_ = Data.DEFAULT_BODY_SET;
            this.dbChar.character_body_set = _loc1_;
         }
         var _loc2_:Object = this.getGender() == 0 ? Main.BODY_SET_BOY : Main.BODY_SET_GIRL;
         if(!_loc2_[_loc1_])
         {
            _loc1_ = Data.DEFAULT_BODY_SET;
            this.dbChar.character_body_set = _loc1_;
         }
         return _loc1_;
      }
      
      public function getTradingBodySet() : String
      {
         var _loc1_:String = this.dbChar.character_equipped_trade_body_set;
         var _loc2_:String = this.dbChar.character_body_set;
         if(_loc2_.length <= 0)
         {
            _loc2_ = Data.DEFAULT_BODY_SET;
            this.dbChar.character_body_set = _loc2_;
         }
         var _loc3_:Object = this.getGender() == 0 ? Main.BODY_SET_BOY : Main.BODY_SET_GIRL;
         if(!_loc3_[_loc2_])
         {
            _loc2_ = Data.DEFAULT_BODY_SET;
            this.dbChar.character_body_set = _loc2_;
         }
         if(_loc1_ != null)
         {
            return _loc1_;
         }
         return _loc2_;
      }
      
      public function getFace() : String
      {
         var _loc1_:String = this.dbChar.character_face;
         if(_loc1_.length <= 0)
         {
            _loc1_ = Data.DEFAULT_FACE + "_" + this.getGender();
            this.dbChar.character_face = _loc1_;
         }
         return _loc1_;
      }
      
      public function getHair() : String
      {
         var _loc1_:String = this.dbChar.character_hair;
         if(_loc1_.length <= 0)
         {
            _loc1_ = Data.DEFAULT_HAIR + "_" + this.getGender();
            this.dbChar.character_hair = _loc1_;
         }
         return _loc1_;
      }
      
      override public function getWeapon() : String
      {
         var _loc1_:String = null;
         var _loc2_:String = null;
         var _loc3_:Array = null;
         var _loc4_:Array = null;
         if(this.dbChar.character_body_parts["weapon"] != null)
         {
            _loc3_ = this.dbChar.character_body_parts["weapon"].split(":");
            realwenpon = _loc3_[0];
         }
         if(this.dbChar.character_equipped_trade_weapon != null)
         {
            _loc1_ = this.dbChar.character_equipped_trade_weapon;
         }
         if(this.dbChar.character_equipped_weapon != null)
         {
            _loc2_ = this.dbChar.character_equipped_weapon;
         }
         if(_loc3_ != null && _loc3_[1] != null)
         {
            _loc1_ = this.dbChar.character_body_parts["weapon"];
         }
         else
         {
            _loc2_ = this.dbChar.character_body_parts["weapon"];
         }
         if(_loc2_ == null && _loc1_ == null)
         {
            _loc2_ = Data.DEFAULT_WEAPON;
            this.dbChar.character_body_parts["weapon"] = _loc2_;
            StaticVariables.weaponStr = Sha1Encrypt.encrypt(String(this.dbChar.character_body_parts["weapon"]));
         }
         if(!Main.WEAPON_DATA.containsKey(_loc2_))
         {
            _loc2_ = Data.DEFAULT_WEAPON;
            if(_loc1_ == null)
            {
               this.dbChar.character_body_parts["weapon"] = _loc2_;
            }
            StaticVariables.weaponStr = Sha1Encrypt.encrypt(String(this.dbChar.character_body_parts["weapon"]));
         }
         if(_loc1_ != null)
         {
            _loc4_ = _loc1_.split(":");
            tradeweapon = true;
            tradenum = _loc1_;
            return _loc4_[0];
         }
         tradeweapon = false;
         tradenum = _loc2_;
         return _loc2_;
      }
      
      public function getrealWeapon() : String
      {
         var _loc2_:Array = null;
         if(this.dbChar.character_body_parts["weapon"] != null)
         {
            _loc2_ = this.dbChar.character_body_parts["weapon"].split(":");
            realwenpon = _loc2_[0];
         }
         var _loc1_:String = this.dbChar.character_equipped_weapon;
         if(!(_loc2_ != null && _loc2_[1] != null))
         {
            _loc1_ = this.dbChar.character_body_parts["weapon"];
         }
         Out.debug(null,"this.dbChar.character_equipped_weapon" + this.dbChar.character_equipped_weapon);
         if(_loc1_ == null)
         {
            _loc1_ = Data.DEFAULT_WEAPON;
            this.dbChar.character_body_parts["weapon"] = _loc1_;
            StaticVariables.weaponStr = Sha1Encrypt.encrypt(String(this.dbChar.character_body_parts["weapon"]));
         }
         if(!Main.WEAPON_DATA.containsKey(_loc1_))
         {
            _loc1_ = Data.DEFAULT_WEAPON;
            this.dbChar.character_body_parts["weapon"] = _loc1_;
            StaticVariables.weaponStr = Sha1Encrypt.encrypt(String(this.dbChar.character_body_parts["weapon"]));
         }
         return _loc1_;
      }
      
      override public function getTradingWeapon() : String
      {
         var _loc1_:String = this.dbChar.character_equipped_trade_weapon;
         var _loc2_:String = this.dbChar.character_body_parts["weapon"];
         if(_loc2_ == null)
         {
            _loc2_ = Data.DEFAULT_WEAPON;
            this.dbChar.character_body_parts["weapon"] = _loc2_;
            StaticVariables.weaponStr = Sha1Encrypt.encrypt(String(this.dbChar.character_body_parts["weapon"]));
         }
         if(_loc1_ == null)
         {
            return _loc2_;
         }
         return _loc1_;
      }
      
      public function getTradeWeapon() : String
      {
         return this.dbChar.character_equipped_trade_weapon;
      }
      
      override public function getWeaponEffectObj(param1:String) : Object
      {
         var _loc5_:* = undefined;
         var _loc2_:String = this.dbChar.character_body_parts["weapon"];
         if(_loc2_ == null)
         {
            _loc2_ = Data.DEFAULT_WEAPON;
            this.dbChar.character_body_parts["weapon"] = _loc2_;
            StaticVariables.weaponStr = Sha1Encrypt.encrypt(String(this.dbChar.character_body_parts["weapon"]));
         }
         if(!Main.WEAPON_DATA.containsKey(_loc2_))
         {
            _loc2_ = Data.DEFAULT_WEAPON;
            this.dbChar.character_body_parts["weapon"] = _loc2_;
            StaticVariables.weaponStr = Sha1Encrypt.encrypt(String(this.dbChar.character_body_parts["weapon"]));
         }
         var _loc3_:* = null;
         var _loc4_:* = Central.main.WEAPON_DATA.find(_loc2_).effect;
         for(_loc5_ in _loc4_)
         {
            if(_loc4_[_loc5_].type == param1)
            {
               _loc3_ = _loc4_[_loc5_];
               break;
            }
         }
         return _loc3_;
      }
      
      override public function getTradingBackItem() : String
      {
         var _loc1_:String = this.dbChar.character_equipped_trade_back_item;
         var _loc2_:String = this.dbChar.character_body_parts["back"];
         if(_loc2_ == null)
         {
            return Data.DEFAULT_BACK_ITEM;
         }
         if(_loc2_ == null)
         {
            _loc2_ = Data.DEFAULT_BACK_ITEM;
            this.dbChar.character_body_parts["back"] = _loc2_;
            StaticVariables.backitemStr = Sha1Encrypt.encrypt(String(this.dbChar.character_body_parts["back"]));
         }
         if(!Main.BACK_ITEM_DATA.containsKey(_loc2_))
         {
            _loc2_ = Data.DEFAULT_BACK_ITEM;
            this.dbChar.character_body_parts["back"] = _loc2_;
            StaticVariables.backitemStr = Sha1Encrypt.encrypt(String(this.dbChar.character_body_parts["back"]));
         }
         if(_loc1_ == null)
         {
            return _loc2_;
         }
         return _loc1_;
      }
      
      override public function getBackItem() : String
      {
         var _loc1_:String = null;
         var _loc3_:Array = null;
         if(this.dbChar.character_equipped_trade_back_item != null)
         {
            _loc1_ = this.dbChar.character_equipped_trade_back_item;
         }
         var _loc2_:String = this.dbChar.character_body_parts["back"];
         if(_loc2_ == null)
         {
            return Data.DEFAULT_BACK_ITEM;
         }
         if(_loc2_ == null)
         {
            _loc2_ = Data.DEFAULT_BACK_ITEM;
            this.dbChar.character_body_parts["back"] = _loc2_;
            StaticVariables.backitemStr = Sha1Encrypt.encrypt(String(this.dbChar.character_body_parts["back"]));
         }
         if(!Main.BACK_ITEM_DATA.containsKey(_loc2_))
         {
            _loc2_ = Data.DEFAULT_BACK_ITEM;
            this.dbChar.character_body_parts["back"] = _loc2_;
            StaticVariables.backitemStr = Sha1Encrypt.encrypt(String(this.dbChar.character_body_parts["back"]));
         }
         if(_loc1_ == null)
         {
            tradeback = false;
            return _loc2_;
         }
         tradeback = true;
         _loc3_ = _loc1_.split(":");
         tradenum = _loc1_;
         return _loc3_[0];
      }
      
      public function getrealBackItem() : String
      {
         var _loc2_:Array = null;
         var _loc1_:String = this.dbChar.character_equipped_back_item;
         if(this.dbChar.character_body_parts["back"] != null)
         {
            _loc2_ = this.dbChar.character_body_parts["back"].split(":");
            realwenpon = _loc2_[0];
         }
         if(_loc2_[1] == null)
         {
            _loc1_ = this.dbChar.character_body_parts["back"];
         }
         if(this.dbChar.character_equipped_back_item != null)
         {
            _loc1_ = this.dbChar.character_equipped_back_item;
         }
         if(_loc1_ == null)
         {
            _loc1_ = Data.DEFAULT_BACK_ITEM;
            this.dbChar.character_body_parts["back"] = _loc1_;
            StaticVariables.backitemStr = Sha1Encrypt.encrypt(String(this.dbChar.character_body_parts["back"]));
         }
         if(!Main.BACK_ITEM_DATA.containsKey(_loc1_))
         {
            _loc1_ = Data.DEFAULT_BACK_ITEM;
            this.dbChar.character_body_parts["back"] = _loc1_;
            StaticVariables.backitemStr = Sha1Encrypt.encrypt(String(this.dbChar.character_body_parts["back"]));
         }
         return _loc1_;
      }
      
      public function getTradeBackItem() : String
      {
         return this.dbChar.character_equipped_trade_back_item;
      }
      
      override public function getAccessory() : String
      {
         var _loc1_:String = this.dbChar.character_body_parts["accessory"];
         if(_loc1_ == null)
         {
            return Data.DEFAULT_ACCESSORY;
         }
         if(_loc1_ == null)
         {
            _loc1_ = Data.DEFAULT_ACCESSORY;
            this.dbChar.character_body_parts["accessory"] = _loc1_;
            StaticVariables.accessoryStr = Sha1Encrypt.encrypt(String(this.dbChar.character_body_parts["accessory"]));
         }
         if(!Main.ACCESSORY_DATA.containsKey(_loc1_))
         {
            _loc1_ = Data.DEFAULT_ACCESSORY;
            this.dbChar.character_body_parts["accessory"] = _loc1_;
            StaticVariables.accessoryStr = Sha1Encrypt.encrypt(String(this.dbChar.character_body_parts["accessory"]));
         }
         return _loc1_;
      }
      
      override public function getBloodline() : Array
      {
         var _loc1_:int = 0;
         var _loc2_:Array = this.dbChar.bloodline;
         var _loc3_:Array = [];
         _loc1_ = 0;
         while(_loc1_ < _loc2_.length)
         {
            if(_loc2_[_loc1_].level)
            {
               _loc3_.push(_loc2_[_loc1_]);
            }
            _loc1_++;
         }
         return _loc3_;
      }
      
      override public function getBloodlineEffect() : Array
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc1_:int = 3;
         var _loc5_:Object = {};
         var _loc6_:Array = this.dbChar.bloodline;
         var _loc7_:Array = [];
         var _loc8_:Array = [];
         var _loc9_:Object = [];
         var _loc10_:Object = {};
         _loc2_ = 0;
         while(_loc2_ < _loc6_.length)
         {
            if(_loc6_[_loc2_].level)
            {
               _loc7_.push(_loc6_[_loc2_]);
            }
            _loc2_++;
         }
         _loc2_ = 0;
         while(_loc2_ < _loc7_.length)
         {
            _loc5_ = Central.main.BLOODLINE_SKILL_DATA["bloodline_skill" + _loc7_[_loc2_].skill_id].effect;
            _loc9_ = _loc5_[_loc7_[_loc2_].level - 1];
            _loc4_ = 1;
            while(_loc4_ < _loc1_ + 1)
            {
               _loc10_ = {
                  "type":_loc9_["effect_type_" + _loc4_],
                  "amount":_loc9_["effect_amount_" + _loc4_],
                  "chancetohit":_loc9_["effect_chancetohit_" + _loc4_],
                  "chancetoeffect":_loc9_["effect_chancetoeffect_" + _loc4_]
               };
               _loc8_.push(_loc10_);
               _loc4_++;
            }
            _loc2_++;
         }
         return _loc8_;
      }
      
      override public function getGearset() : Object
      {
         var _loc3_:Object = null;
         var _loc1_:Object = {};
         var _loc2_:Object = {
            "wpnData":Main.WEAPON_DATA.find(this.getWeapon()),
            "backData":(this.getBackItem() != "" ? Main.BACK_ITEM_DATA.find(this.getBackItem()) : null),
            "acsyData":(this.getAccessory() != "" ? Main.ACCESSORY_DATA.find(this.getAccessory()) : null),
            "hairData":(Central.main.HAIR_DATA ? Main.HAIR_DATA.find(Toolkit.getIDBySubData("swfName",this.getHair().replace("hair_",""),Central.main.HAIR_DATA)) : null),
            "bodyData":(this.getGender() == 0 ? Main.BODY_SET_BOY[this.getBodySet()] : Main.BODY_SET_GIRL[this.getBodySet()])
         };
         for each(_loc3_ in _loc2_)
         {
            if(Boolean(_loc3_) && Boolean(_loc3_.relate_set))
            {
               if(_loc1_["gearset" + _loc3_.relate_set])
               {
                  _loc1_["gearset" + _loc3_.relate_set] += 1;
               }
               else
               {
                  _loc1_["gearset" + _loc3_.relate_set] = 1;
               }
            }
         }
         return _loc1_;
      }
      
      public function getHairColor() : Array
      {
         var _loc1_:Array = Data.DEFAULT_HAIR_COLOR;
         if(this.dbChar.character_hair_color != null)
         {
            if(this.dbChar.character_hair_color.length > 0)
            {
               _loc1_ = this.dbChar.character_hair_color;
            }
         }
         return _loc1_;
      }
      
      public function getSkinColor() : Number
      {
         var _loc1_:Number = Data.DEFAULT_SKIN_COLOR;
         return Number(this.dbChar.character_skin_color);
      }
      
      public function setTradingBodySet(param1:String) : void
      {
         this.dbChar.character_equipped_trade_body_set = param1;
      }
      
      public function setBodySet(param1:String) : void
      {
         var _loc2_:Object = this.getGender() == 0 ? Main.BODY_SET_BOY : Main.BODY_SET_GIRL;
         if(Boolean(_loc2_[param1].premium) && Account.getAccountType() == Account.FREE)
         {
            Main.showUpgradeAccount(Central.main.langLib.get(380),"Shop");
         }
         else
         {
            if(this.dbChar.character_equipped_trade_body_set != null)
            {
               this.dbChar.character_equipped_trade_body_set = null;
            }
            this.dbChar.character_body_set = param1;
         }
      }
      
      public function setFace(param1:String) : void
      {
         this.dbChar.character_face = param1;
      }
      
      public function setHair(param1:String) : void
      {
         this.dbChar.character_hair = param1;
      }
      
      public function setTradingWeapon(param1:String) : Boolean
      {
         var _loc3_:Array = null;
         var _loc2_:Array = this.dbChar.character_body_parts["weapon"].split(":");
         if(_loc2_[1] == null)
         {
            this.dbChar.character_equipped_weapon = this.dbChar.character_body_parts["weapon"];
         }
         if(param1 != null)
         {
            _loc3_ = param1.split(":");
            if(this.getData(DBCharacterData.LEVEL) < Main.WEAPON_DATA.find(_loc3_[0]).level)
            {
               Main.showInfo(Central.main.langLib.get(381));
               return false;
            }
         }
         this.dbChar.character_equipped_trade_weapon = param1;
         this.dbChar.character_body_parts["weapon"] = param1;
         return true;
      }
      
      public function setWeapon(param1:String, param2:Boolean = true) : Boolean
      {
         if(!Main.WEAPON_DATA.containsKey(param1))
         {
            return false;
         }
         if(this.getData(DBCharacterData.LEVEL) < Main.WEAPON_DATA.find(param1).level)
         {
            Main.showInfo(Central.main.langLib.get(381));
            return false;
         }
         if(Main.WEAPON_DATA.find(param1).premium)
         {
            if(Account.getAccountType() != Account.PREMIUM)
            {
               Main.showUpgradeAccount(Central.main.langLib.get(382),"Shop");
               return false;
            }
            Main.provision();
         }
         if(this.dbChar.character_equipped_trade_weapon != null)
         {
            this.dbChar.character_equipped_trade_weapon = null;
         }
         if(param2)
         {
            this.addInventory(InventoryData.TYPE_WEAPON,this.getrealWeapon());
         }
         this.dbChar.character_equipped_weapon = param1;
         this.dbChar.character_body_parts["weapon"] = param1;
         StaticVariables.weaponStr = Sha1Encrypt.encrypt(String(this.dbChar.character_body_parts["weapon"]));
         if(!this.securityCheck())
         {
            return false;
         }
         return true;
      }
      
      public function setTradingBackItem(param1:String) : void
      {
         this.dbChar.character_equipped_trade_back_item = param1;
         this.dbChar.character_body_parts["back"] = param1;
      }
      
      public function setBackItem(param1:String, param2:Boolean = true) : Boolean
      {
         if(this.getrealBackItem() == "" && (param1 == "" || param1 == null) && this.dbChar.character_body_parts["back"] == null)
         {
            return false;
         }
         if(!Main.BACK_ITEM_DATA.containsKey(param1) && param1 != "")
         {
            return false;
         }
         if(this.dbChar.character_equipped_trade_back_item != null)
         {
            this.dbChar.character_equipped_trade_back_item = null;
         }
         if(this.getrealBackItem() == "")
         {
            this.dbChar.character_body_parts["back"] = param1;
            this.dbChar.character_equipped_back_item = param1;
         }
         else
         {
            if(param2)
            {
               this.addInventory(InventoryData.TYPE_BACK_ITEM,this.getrealBackItem());
            }
            this.dbChar.character_equipped_back_item = param1;
            this.dbChar.character_body_parts["back"] = param1;
         }
         StaticVariables.backitemStr = Sha1Encrypt.encrypt(String(this.dbChar.character_body_parts["back"]));
         if(!this.securityCheck())
         {
            return false;
         }
         Out.debug(null,"setBackItem is ok");
         return true;
      }
      
      public function setAccessory(param1:String, param2:Boolean = true) : Boolean
      {
         if(this.getAccessory() == "" && (param1 == "" || param1 == null))
         {
            return false;
         }
         if(!Main.ACCESSORY_DATA.containsKey(param1) && param1 != "")
         {
            return false;
         }
         if(this.getAccessory() == "")
         {
            this.dbChar.character_body_parts["accessory"] = param1;
         }
         else
         {
            if(param2)
            {
               this.addInventory(InventoryData.TYPE_ACCESSORY,this.getAccessory());
            }
            this.dbChar.character_body_parts["accessory"] = param1;
         }
         StaticVariables.accessoryStr = Sha1Encrypt.encrypt(String(this.dbChar.character_body_parts["accessory"]));
         if(!this.securityCheck())
         {
            return false;
         }
         return true;
      }
      
      public function setGender(param1:uint) : void
      {
         if(param1 == 0 || param1 == 1)
         {
            this.dbChar.character_gender = param1;
         }
      }
      
      public function getHead() : MovieClip
      {
         var _loc1_:MovieClip = GF.getAsset(Main.actionBase,"Head");
         this.cloneHead(_loc1_);
         return _loc1_;
      }
      
      public function getStaticFullBody() : MovieClip
      {
         var _loc1_:MovieClip = GF.getAsset(Main.actionBase,"StaticFullBody");
         this.cloneStaticFullBody(_loc1_);
         return _loc1_;
      }
      
      public function hasItem(param1:String, param2:String, param3:Boolean = false) : Boolean
      {
         var _loc4_:Array = this.getInventory(param1);
         var _loc5_:Boolean = false;
         var _loc6_:String = "";
         if(_loc4_ != null)
         {
            if(_loc4_.indexOf(param2) >= 0)
            {
               _loc5_ = true;
            }
         }
         if(_loc5_ || !param3)
         {
            return _loc5_;
         }
         switch(param1)
         {
            case InventoryData.TYPE_BACK_ITEM:
               _loc6_ = this.getBackItem();
               break;
            case InventoryData.TYPE_ACCESSORY:
               _loc6_ = this.getAccessory();
               break;
            case InventoryData.TYPE_BODY_SET:
               _loc6_ = this.getBodySet();
               break;
            case InventoryData.TYPE_WEAPON:
               _loc6_ = this.getWeapon();
         }
         return _loc6_ == param2;
      }
      
      public function setInventory(param1:String, param2:Object) : void
      {
         this.dbChar.character_inventory[param1] = param2;
      }
      
      public function addInventory(param1:String, param2:String) : void
      {
         if(param1 == null || param2 == null)
         {
            return;
         }
         switch(param1)
         {
            case InventoryData.TYPE_ITEM:
               if(this.calcInventoryUsage() >= Data.INV_SPACE_FREE && Account.getAccountType() == Account.FREE)
               {
                  Main.showUpgradeAccount(String(String(Central.main.langLib.get(54)).replace("[valInvSpaceFree]",Data.INV_SPACE_FREE.toString())).replace("[valInvSpacePrenium]",Data.INV_SPACE_PREMIUM),"Shop");
                  return;
               }
               if(Account.getAccountType() == Account.PREMIUM)
               {
                  Main.provision();
                  if(this.calcInventoryUsage() >= Data.INV_SPACE_PREMIUM)
                  {
                     Main.showInfo(String(Central.main.langLib.get(51)).replace("[valInvSpacePrenium2]",Data.INV_SPACE_PREMIUM.toString()));
                     return;
                  }
               }
         }
         var _loc3_:Array = this.dbChar.character_inventory[param1];
         if(_loc3_ == null)
         {
            _loc3_ = new Array();
         }
         _loc3_.push(param2);
         this.dbChar.character_inventory[param1] = _loc3_;
      }
      
      public function addInventoryForce(param1:String, param2:String) : void
      {
         if(param1 == null || param2 == null)
         {
            return;
         }
         var _loc3_:Array = this.dbChar.character_inventory[param1];
         if(_loc3_ == null)
         {
            _loc3_ = new Array();
         }
         _loc3_.push(param2);
         this.dbChar.character_inventory[param1] = _loc3_;
      }
      
      public function addMagatama(param1:int) : void
      {
         var _loc2_:Object = this.getInventory(InventoryData.TYPE_MAGATAMA);
         if(_loc2_)
         {
            if(_loc2_[param1])
            {
               _loc2_[param1] += 1;
            }
            else
            {
               _loc2_[param1] = 1;
            }
         }
         else
         {
            _loc2_ = {};
            _loc2_[param1] = 1;
         }
         this.dbChar.character_inventory[InventoryData.TYPE_MAGATAMA] = _loc2_;
      }
      
      public function addMissionRecord(param1:String, param2:String) : void
      {
         var _loc3_:Object = this.dbChar.character_inventory[InventoryData.TYPE_MISSION];
         if(_loc3_ == null)
         {
            _loc3_ = {};
         }
         if(_loc3_[param1] == null)
         {
            _loc3_[param1] = {
               "success":0,
               "fail":0,
               "time":Main.serverTime
            };
         }
         ++_loc3_[param1][param2];
         if(param2 == "success")
         {
            _loc3_[param1].time = Main.serverTime;
         }
         this.dbChar.character_inventory[InventoryData.TYPE_MISSION] = _loc3_;
      }
      
      public function checkMissionRecord(param1:String) : Object
      {
         var _loc2_:Object = this.getData(DBCharacterData.INVENTORY)[InventoryData.TYPE_MISSION];
         if(_loc2_ == null)
         {
            _loc2_ = {};
         }
         if(_loc2_[param1] == null)
         {
            _loc2_[param1] = {
               "success":0,
               "fail":0,
               "time":0
            };
         }
         else if(_loc2_[param1].time == null)
         {
            _loc2_[param1].time = 0;
         }
         return _loc2_[param1];
      }
      
      public function removeInventory(param1:String, param2:String) : void
      {
         var _loc3_:Array = this.dbChar.character_inventory[param1];
         if(_loc3_ != null)
         {
            if(_loc3_.indexOf(param2) >= 0)
            {
               _loc3_.splice(_loc3_.indexOf(param2),1);
            }
            else
            {
               new Error(this + " :: removeInventory :: item not found >> " + param2);
            }
         }
      }
      
      public function getInventory(param1:String) : *
      {
         var _loc3_:int = 0;
         var _loc2_:* = this.dbChar.character_inventory[param1];
         if(_loc2_ == null)
         {
            if(param1 == InventoryData.TYPE_MISSION)
            {
               _loc2_ = {
                  "success":0,
                  "fail":0
               };
            }
            else
            {
               if(param1 == InventoryData.TYPE_DAILY_TASK)
               {
                  return null;
               }
               if(param1 == InventoryData.TYPE_MAGATAMA)
               {
                  return null;
               }
               _loc2_ = [];
            }
         }
         if(param1 == InventoryData.TYPE_PET)
         {
            _loc2_ = [];
            _loc3_ = 0;
            while(_loc3_ < this.pets.length)
            {
               _loc2_.push("pet" + this.pets[_loc3_].id);
               _loc3_++;
            }
         }
         if(param1 != InventoryData.TYPE_MISSION && param1 != InventoryData.TYPE_DAILY_TASK && param1 != InventoryData.TYPE_MAGATAMA)
         {
            _loc2_.sort();
         }
         return _loc2_;
      }
      
      public function clearInventory(param1:String) : void
      {
         this.dbChar.character_inventory[param1] = null;
      }
      
      public function getItemCount(param1:String, param2:String) : uint
      {
         var _loc3_:Array = this.getInventory(param1);
         var _loc4_:uint = 0;
         var _loc5_:int = 0;
         while(_loc5_ < _loc3_.length)
         {
            if(_loc3_[_loc5_] == param2)
            {
               _loc4_++;
            }
            _loc5_++;
         }
         return _loc4_;
      }
      
      public function calcInventoryUsage() : uint
      {
         var _loc1_:Array = this.getInventory(InventoryData.TYPE_ITEM);
         return _loc1_.length;
      }
      
      public function calcMaterialInventoryUsage() : uint
      {
         var _loc1_:Array = this.getInventory(InventoryData.TYPE_MATERIAL);
         return _loc1_.length;
      }
      
      public function calcEssenceInventoryUsage() : uint
      {
         var _loc1_:Array = this.getInventory(InventoryData.TYPE_ESSENCE);
         return _loc1_.length;
      }
      
      public function calcWeaponUsage() : uint
      {
         var _loc1_:Array = this.getInventory(InventoryData.TYPE_WEAPON);
         return _loc1_.length + 1;
      }
      
      public function calcBodySetUsage() : uint
      {
         var _loc1_:Array = this.getInventory(InventoryData.TYPE_BODY_SET);
         return _loc1_.length + 1;
      }
      
      public function calcBackItemUsage() : uint
      {
         var _loc1_:Array = this.getInventory(InventoryData.TYPE_BACK_ITEM);
         if(Boolean(this.getBackItem()) && this.getBackItem() != "")
         {
            return _loc1_.length + 1;
         }
         return _loc1_.length;
      }
      
      public function calcAccessoryUsage() : uint
      {
         var _loc1_:Array = this.getInventory(InventoryData.TYPE_ACCESSORY);
         if(Boolean(this.getAccessory()) && this.getAccessory() != "")
         {
            return _loc1_.length + 1;
         }
         return _loc1_.length;
      }
      
      public function setClassSkillListArr(param1:String) : void
      {
         if(this.classSkillList.indexOf(param1) < 0)
         {
            this.classSkillList.push(param1);
         }
      }
      
      public function clearClassSkillListArr(param1:String) : void
      {
         var _loc2_:int = 0;
         if(this.classSkillList.indexOf(param1) >= 0)
         {
            _loc2_ = this.classSkillList.indexOf(param1);
            this.classSkillList.splice(_loc2_,1);
         }
      }
      
      public function foreClearClassSkillListArr() : void
      {
         this.classSkillList = [];
      }
      
      public function getClassSkillListArr() : Array
      {
         return this.classSkillList;
      }
      
      public function setSkillList(param1:Array, param2:Function = null) : void
      {
         var _loc3_:uint = 0;
         var _loc4_:Array = null;
         var _loc5_:Array = null;
         var _loc6_:Array = null;
         if(param1 != null)
         {
            _loc4_ = new Array();
            if(param1.length == 0)
            {
               this.dbChar.character_skills = param1;
            }
            _loc3_ = 0;
            while(_loc3_ < param1.length)
            {
               if(Main.SKILL_DATA[param1[_loc3_]])
               {
                  if(Main.SKILL_DATA[param1[_loc3_]].special_class == 0)
                  {
                     this.dbChar.character_skills = param1;
                     break;
                  }
               }
               _loc3_++;
            }
            this.pendingSkills = null;
            _loc5_ = this.getSkillListArr();
            _loc3_ = 0;
            while(_loc3_ < _loc5_.length)
            {
               if(!Skill.hasSkill(_loc5_[_loc3_]))
               {
                  _loc4_.push("swf/skills/" + Main.SKILL_DATA[_loc5_[_loc3_]].swfName + ".swf");
               }
               _loc3_++;
            }
            _loc6_ = this.getClassSkillListArr();
            _loc3_ = 0;
            while(_loc3_ < _loc6_.length)
            {
               if(!Skill.hasClassSkill(_loc6_[_loc3_]))
               {
                  _loc4_.push("swf/skills/" + Main.SKILL_DATA[_loc6_[_loc3_]].swfName + ".swf");
               }
               _loc3_++;
            }
            if(_loc4_.length > 0)
            {
               if(this.getCharacterId() == Main.getMainChar().getCharacterId())
               {
                  this.pendingSkills = _loc4_;
                  if(param2 != null)
                  {
                     param2();
                  }
               }
               else
               {
                  Main.loadSwf(_loc4_,this.updateSkillSwf,{"cbFn":param2});
               }
            }
            else
            {
               this.updateSkillSwf(null,{"cbFn":param2});
            }
         }
         else
         {
            this.dbChar.character_skills = null;
            this.skillSwfArr = null;
         }
      }
      
      public function updateSkillSwf(param1:Object = null, param2:Object = null) : void
      {
         var _loc5_:MovieClip = null;
         var _loc9_:String = null;
         var _loc10_:MovieClip = null;
         var _loc11_:MovieClip = null;
         var _loc12_:MovieClip = null;
         this.skillCheck();
         var _loc3_:Array = this.dbChar.character_skills;
         var _loc4_:uint = 0;
         this.skillSwfArr = [];
         _loc4_ = 0;
         while(_loc4_ < _loc3_.length)
         {
            if(param1 != null)
            {
               if(!Skill.hasSkill(_loc3_[_loc4_]))
               {
                  Skill.setSkill(_loc3_[_loc4_],param1["swf/skills/" + Main.SKILL_DATA[_loc3_[_loc4_]].swfName + ".swf"]);
               }
            }
            _loc5_ = Skill.getSkill(_loc3_[_loc4_]);
            this.setSkillSwf(_loc5_);
            _loc4_++;
         }
         this.classSkillSwfArr = [];
         _loc4_ = 0;
         while(_loc4_ < this.classSkillList.length)
         {
            if(param1 != null)
            {
               if(!Skill.hasClassSkill(classSkillList[_loc4_]))
               {
                  Skill.setClassSkill(classSkillList[_loc4_],param1["swf/skills/" + Main.SKILL_DATA[classSkillList[_loc4_]].swfName + ".swf"]);
               }
            }
            _loc5_ = Skill.getClassSkill(classSkillList[_loc4_]);
            this.setClassSkillSwf(_loc5_);
            _loc4_++;
         }
         this.senjutsuSwfArr = [];
         var _loc6_:Array = this.dbChar.character_senjutsu;
         _loc4_ = 0;
         while(_loc4_ < _loc6_.length)
         {
            _loc9_ = _loc6_[_loc4_].replace("senjutsu_skill","");
            if(param1 != null)
            {
               if(!Skill.hasSkill("skill" + _loc9_))
               {
                  Skill.setSkill("skill" + _loc9_,param1["swf/skills/" + Main.SENJUTSU_SKILL_DATA[_loc6_[_loc4_]].swf_name + ".swf"]);
               }
            }
            _loc10_ = Skill.getSenjutsu(_loc9_);
            _loc10_.name = Main.SENJUTSU_SKILL_DATA[_loc6_[_loc4_]].swf_name;
            this.setSenjutsuSwf(_loc10_);
            _loc4_++;
         }
         var _loc7_:Array = this.getBloodlineListArr();
         this.bloodlineSwfArr = [];
         _loc4_ = 0;
         while(_loc4_ < _loc7_.length)
         {
            if(param1 != null)
            {
               if(!Skill.hasSkill("skill" + _loc7_[_loc4_].skill_id))
               {
                  Skill.setSkill("skill" + _loc7_[_loc4_].skill_id,param1["swf/skills/" + Main.BLOODLINE_SKILL_DATA["bloodline_skill" + _loc7_[_loc4_].skill_id].swf_name + ".swf"]);
               }
            }
            _loc11_ = Skill.getBloodline(_loc7_[_loc4_].skill_id);
            this.setBloodlineSwf(_loc11_);
            _loc4_++;
         }
         var _loc8_:Array = this.getSecretListArr();
         this.secretSwfArr = [];
         _loc4_ = 0;
         while(_loc4_ < _loc8_.length)
         {
            if(param1 != null)
            {
               if(!Skill.hasSkill("skill" + _loc8_[_loc4_].skill_id))
               {
                  Skill.setSkill("skill" + _loc8_[_loc4_].skill_id,param1["swf/skills/" + Main.BLOODLINE_SKILL_DATA["bloodline_skill" + _loc8_[_loc4_].skill_id].swf_name + ".swf"]);
               }
            }
            _loc12_ = Skill.getBloodline(_loc8_[_loc4_].skill_id);
            this.setSecretSwf(_loc12_);
            _loc4_++;
         }
         this.customizeCharacter();
         if(param2 != null)
         {
            if(param2.cbFn != null)
            {
               param2.cbFn();
            }
         }
         Main.proc.addState(this.validateSkill,60000,true);
      }
      
      public function getSkillSwfArr() : Array
      {
         return this.skillSwfArr;
      }
      
      public function getClassSkillSwfArr() : Array
      {
         return this.classSkillSwfArr;
      }
      
      public function clearClassSkillSwfArr() : void
      {
         this.classSkillSwfArr = [];
      }
      
      public function getSkillTypes(param1:Boolean = false) : HashMap
      {
         var skillList:Array = null;
         var i:uint = 0;
         var type:String = null;
         var record:uint = 0;
         var ninjutsuOnly:Boolean = param1;
         var skillTypes:HashMap = new HashMap();
         skillList = this.getInventory(InventoryData.TYPE_SKILL);
         i = 0;
         while(i < skillList.length)
         {
            try
            {
               type = Main.SKILL_DATA[skillList[i]].type;
            }
            catch(e:Error)
            {
               Out.error(this,"Skill not found: skillList[" + i + "]=" + skillList[i]);
               Out.error(this,"where skill_data(" + skillList[i] + ")=" + GF.printObject(skillList[i]));
               throw new Error("Skill not found, skill=" + GF.printObject(skillList[i]));
            }
            if(type != "taijutsu" && type != "genjutsu" || !ninjutsuOnly)
            {
               record = skillTypes.find(type);
               record++;
               skillTypes.insert(type,record);
            }
            i++;
         }
         return skillTypes;
      }
      
      public function skillCheck() : void
      {
         var _loc1_:Array = this.getSkillTypes(true).toArray();
         if(_loc1_.length <= Data.FREE_JUTSU_NUMBER)
         {
            return;
         }
         if(_loc1_.length > Data.PREMIUM_JUTSU_NUMBER)
         {
            this.dbChar.character_skills = [];
            this.clearInventory(InventoryData.TYPE_SKILL);
            Out.data(this,"skill error :: number of ninjutsu types " + _loc1_.length);
            Main.submitData();
         }
         if(_loc1_.length > Data.FREE_JUTSU_NUMBER && _loc1_.length <= Data.PREMIUM_JUTSU_NUMBER)
         {
            if(Account.getAccountType() == Account.PREMIUM)
            {
               Central.main.provision();
            }
            else
            {
               if(Main.getMainChar().getData("character_id") != this.getData("character_id"))
               {
                  return;
               }
               this.dbChar.character_skills = [];
               this.clearInventory(InventoryData.TYPE_SKILL);
               Out.data(this,"skill error :: number of ninjutsu types " + _loc1_.length);
               Main.submitData();
            }
         }
      }
      
      public function removeEquippedSkill(param1:String) : void
      {
         var _loc2_:Array = this.getSkillListArr();
         if(_loc2_)
         {
            if(_loc2_.length > 0)
            {
               if(_loc2_.indexOf(param1) >= 0)
               {
                  _loc2_.splice(_loc2_.indexOf(param1),1);
                  this.dbChar.character_skills = _loc2_;
               }
            }
         }
      }
      
      public function pvpSecurityCheck() : void
      {
         Out.debug(this,"pvpSecurityCheck");
         Main.proc.addState(this.validateSkill,60000,true);
      }
      
      private function validateSkill() : void
      {
         Out.debug(this,"validateSkill");
         if(this.getCharacterId() != Main.getMainChar().getCharacterId())
         {
            return;
         }
         Main.proc.removeState(this.validateSkill);
         if(Central.main.isNewChar)
         {
            return;
         }
         var _loc1_:String = "CharacterValidation.validateSkill" + this.dbChar.character_skills.toString();
         var _loc2_:String = Main.getHash(_loc1_);
         Main.amfClient.service("CharacterValidation.validateSkill",[Account.getAccountSessionKey(),_loc2_,this.dbChar.character_skills],this.validateSkillResponse,this);
      }
      
      private function validateSkillResponse(param1:Object) : void
      {
         var strToHash:String = null;
         var response:Object = param1;
         try
         {
            if(Main.validateAmfResponse(response))
            {
               strToHash = "CharacterValidation.validateSkill" + response.equipped_skill.toString() + response.status;
               if(response.signature == Main.getHash(strToHash))
               {
               }
            }
         }
         catch(e:Error)
         {
            Main.onError(Main.errorData.CODE_CHARACTER_SKILL_INVALID);
         }
      }
      
      public function hasSkill(param1:String) : Boolean
      {
         var _loc2_:Array = this.getInventory(InventoryData.TYPE_SKILL);
         if(_loc2_.indexOf(param1) >= 0)
         {
            return true;
         }
         return false;
      }
      
      public function hasSkillType(param1:String) : Boolean
      {
         var _loc2_:HashMap = this.getSkillTypes();
         if(_loc2_.containsKey(param1))
         {
            return true;
         }
         return false;
      }
      
      public function get apInvested() : uint
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         _loc2_ = 0;
         while(_loc2_ < DBCharacterData.ALL_ATTRIBUTE_POINTS.length)
         {
            _loc1_ += this.getData(DBCharacterData.ALL_ATTRIBUTE_POINTS[_loc2_]);
            _loc2_++;
         }
         return _loc1_;
      }
      
      public function resetAP(param1:uint) : void
      {
         var _loc2_:uint = 0;
         _loc2_ = 0;
         while(_loc2_ < DBCharacterData.ALL_ATTRIBUTE_POINTS.length)
         {
            this.updateData(DBCharacterData.ALL_ATTRIBUTE_POINTS[_loc2_],0);
            _loc2_++;
         }
         Main.amfClient.service("CharacterDAO.saveResetAP",[Account.getAccountSessionKey(),param1],this.saveResetAPResult);
      }
      
      public function saveResetAPResult(param1:Object) : void
      {
      }
      
      public function get trainingSkill() : Object
      {
         return _trainingSkill;
      }
      
      public function set trainingSkill(param1:Object) : void
      {
         this._trainingSkill = param1;
         if(param1 != null && typeof param1 == "object")
         {
            this._trainingSkill.utime = int(getTimer() * 0.001);
         }
      }
      
      public function setUpdateTrainingSkill(param1:int) : void
      {
         this._trainingSkill.time = param1;
         this._trainingSkill.utime = int(getTimer() * 0.001);
      }
      
      public function getTrainingSkillRemaining() : Number
      {
         return int(this._trainingSkill.time - int(getTimer() * 0.001) + this._trainingSkill.utime);
      }
      
      public function get trainingFdSkill() : Object
      {
         return _trainingFdSkill;
      }
      
      public function set trainingFdSkill(param1:Object) : void
      {
         if(this._trainingFdSkill == null || param1 == null)
         {
            this._trainingFdSkill = param1;
            if(param1 != null && typeof param1 == "object")
            {
               this._trainingFdSkill.utime = int(getTimer() * 0.001);
            }
         }
      }
      
      public function getTrainingFdSkillRemaining() : Number
      {
         return this._trainingFdSkill.time - int(getTimer() * 0.001) + this._trainingFdSkill.utime;
      }
      
      public function verifyTrainingSkill(param1:Function) : void
      {
         if(this._trainingSkill == null)
         {
            param1();
            return;
         }
         this.verifyTrainingSkill_CB = param1;
         Main.showAmfLoading();
         Main.amfClient.service("CharacterDAO.verifyTrainingSkill",[Account.getAccountSessionKey(),this._trainingSkill.id],this.verifyTrainingSkillResult);
      }
      
      private function verifyTrainingSkillResult(param1:Object) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:String = null;
         if(String(param1.status) == AMFData.STATUS_ERROR)
         {
            Main.onError(String(param1.error));
            return;
         }
         _loc3_ = param1.recall as int;
         if(_loc3_ == 1)
         {
            return;
         }
         _loc2_ = param1.result as int;
         if(_loc2_ == 0)
         {
            _loc4_ = this._trainingSkill.id;
            this._trainingSkill = null;
            this.addNewSkill(_loc4_,this.verifyTrainingSkill_CB);
         }
         else
         {
            this.trainingSkill = {
               "id":this._trainingSkill.id,
               "time":_loc2_
            };
            if(this.verifyTrainingSkill_CB != null)
            {
               this.verifyTrainingSkill_CB();
               this.verifyTrainingSkill_CB = null;
            }
         }
         Main.hideAmfLoading();
      }
      
      public function verifyTrainingFdSkill(param1:Function = null) : void
      {
         if(this._trainingFdSkill == null)
         {
            param1();
         }
         else
         {
            this.verifyTrainingFdSkill_CB = param1;
            Main.showAmfLoading();
            Main.amfClient.service("VisitFriendService.getLearningStatus",[Account.getAccountSessionKey()],verifyTrainingFdSkillResult);
         }
      }
      
      private function verifyTrainingFdSkillResult(param1:Object) : void
      {
         var _loc3_:String = null;
         if(String(param1.status) == AMFData.STATUS_ERROR)
         {
            Out.error(this,"onAmfGetLearningStatusResult :: error code " + String(param1.error));
            return;
         }
         var _loc2_:Array = param1.result as Array;
         if(_loc2_)
         {
            this._trainingFdSkill = {};
            this._trainingFdSkill.target = _loc2_[0];
            this._trainingFdSkill.skill = _loc2_[1];
            this._trainingFdSkill.skillType = Central.main.SKILL_DATA[this._trainingFdSkill.skill].type;
            this._trainingFdSkill.progress = _loc2_[2];
            this._trainingFdSkill.lastVisitTime = _loc2_[3];
            this._trainingFdSkill.serverTime = _loc2_[4];
            this._trainingFdSkill.trainingTime = Central.main.SKILL_DATA[this._trainingFdSkill.skill].train_time * 2;
            if(this._trainingFdSkill.trainingTime == 0)
            {
               this._trainingFdSkill.trainingTime = 1;
            }
            this._trainingFdSkill.remainingTime = int(this._trainingFdSkill.lastVisitTime) + int(this._trainingFdSkill.trainingTime) * 60 * 60 - int(this._trainingFdSkill.serverTime);
            _loc3_ = Central.main.getHash(_loc2_[0] + "," + _loc2_[1] + "," + _loc2_[2] + "," + _loc2_[3] + "," + _loc2_[4]);
            if(_loc3_ != param1.hash)
            {
               Out.error(this,"h.error");
               Central.main.onError();
               return;
            }
         }
         else
         {
            this._trainingFdSkill = null;
         }
         if(this.verifyTrainingFdSkill_CB != null)
         {
            this.verifyTrainingFdSkill_CB();
            this.verifyTrainingFdSkill_CB = null;
         }
         Main.hideAmfLoading();
      }
      
      public function addNewSenjutsu(param1:Object, param2:Function = null, param3:Boolean = false) : void
      {
         var _loc6_:Object = null;
         var _loc4_:Array = this.getSenjutsuListArr();
         var _loc5_:Boolean = true;
         for each(_loc6_ in _loc4_)
         {
            if(_loc6_.skill_id == param1.skill_id)
            {
               _loc5_ = false;
               break;
            }
         }
         if(_loc5_)
         {
            _loc4_.push(param1);
         }
         this.dbChar[DBCharacterData.SENJUTSU_SKILL] = _loc4_;
         senjutsu = _loc4_;
         if(param3 == true && this.dbChar[DBCharacterData.SENJUTSU].indexOf(param1.skill_id) < 0)
         {
            this.dbChar[DBCharacterData.SENJUTSU].push("senjutsu_skill" + param1.skill_id);
         }
         if(param2 != null)
         {
            param2();
         }
      }
      
      public function loadEquippedSenjutsuSwf() : void
      {
         var _loc1_:Array = this.dbChar[DBCharacterData.SENJUTSU];
         var _loc2_:Array = new Array();
         var _loc3_:int = 0;
         while(_loc3_ < _loc1_.length)
         {
            if(!Central.skill.hasSkill(_loc1_[_loc3_].replace("senjutsu_","")))
            {
               _loc2_.push("swf/skills/" + Central.main.SENJUTSU_SKILL_DATA[_loc1_[_loc3_]].swf_name + ".swf");
            }
            _loc3_++;
         }
         if(_loc2_.length > 0)
         {
            Central.main.loadSwf(_loc2_,updateEquippedSenjutsuSwf);
         }
      }
      
      public function updateEquippedSenjutsuSwf(param1:Object = null, param2:Object = null) : void
      {
         var _loc5_:MovieClip = null;
         this.senjutsuSwfArr = [];
         var _loc3_:Array = this.dbChar[DBCharacterData.SENJUTSU];
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_.length)
         {
            if(param1 != null)
            {
               if(!Skill.hasSkill(_loc3_[_loc4_].replace("senjutsu_","")))
               {
                  Skill.setSkill(_loc3_[_loc4_].replace("senjutsu_",""),param1["swf/skills/" + Main.SENJUTSU_SKILL_DATA[_loc3_[_loc4_]].swf_name + ".swf"]);
               }
            }
            _loc5_ = Skill.getSenjutsu(_loc3_[_loc4_].replace("senjutsu_skill",""));
            _loc5_.name = Main.SENJUTSU_SKILL_DATA[_loc3_[_loc4_]].swf_name;
            this.setSenjutsuSwf(_loc5_);
            _loc4_++;
         }
         if(param2 != null)
         {
            if(param2.cbFn != null)
            {
               param2.cbFn();
            }
         }
      }
      
      public function addNewSkill(param1:String, param2:Function = null) : void
      {
         var _loc3_:Array = null;
         if(!this.hasSkill(param1))
         {
            Main.showInfo(String(Central.main.langLib.get(383)).replace("[valskillname]",Main.SKILL_DATA[param1].name));
            this.checkSkill(param1);
            SNS.publishFeed(SNSData.FEED_SKILL,Main.SKILL_DATA[param1].name);
            this.addInventory(InventoryData.TYPE_SKILL,param1);
            _loc3_ = this.getSkillListArr();
            if(_loc3_.length < 8)
            {
               if(Central.main.SKILL_DATA[param1].level < this.getLevel())
               {
                  _loc3_.push(param1);
                  if(param2 == null)
                  {
                     this.setSkillList(_loc3_);
                  }
                  else
                  {
                     this.setSkillList(_loc3_,param2);
                  }
               }
               else if(param2 != null)
               {
                  param2();
               }
            }
            else if(param2 != null)
            {
               param2();
            }
         }
         else if(param2 != null)
         {
            param2();
         }
         Main.achievement.checkSpecialAchievement(Main.achievementData.SKILL_TRAINED);
         Main.achievement.checkSpecialAchievement(Main.achievementData.KINJUTSU_TRAINED);
      }
      
      public function checkSkill(param1:String) : void
      {
         if(!Central.main.isTrailEmblem)
         {
            return;
         }
         var _loc2_:* = Main.SKILL_DATA[param1].type;
         var _loc3_:HashMap = this.getSkillTypes(true);
         if(_loc3_.toArray().length + 1 == 3 || _loc3_.toArray().length == 3)
         {
            if(!Central.main.getMainChar().hasSkillType(_loc2_))
            {
               Main.amfClient.service("CharacterDAO.addTrialEmblemThirdSkillType",[Account.getAccountSessionKey(),_loc2_],new Function());
            }
         }
      }
      
      public function resetSkill(param1:String, param2:Function = null) : void
      {
         this.removeInventory(InventoryData.TYPE_SKILL,param1);
      }
      
      public function addEventSkill(param1:String, param2:Function = null) : void
      {
         var _loc3_:Array = null;
         if(!this.hasSkill(param1))
         {
            this.addInventory(InventoryData.TYPE_SKILL,param1);
            _loc3_ = this.getSkillListArr();
            if(_loc3_.length < 8)
            {
               _loc3_.push(param1);
               if(param2 == null)
               {
                  this.setSkillList(_loc3_);
               }
               else
               {
                  this.setSkillList(_loc3_,param2);
               }
            }
            else if(param2 != null)
            {
               param2();
            }
         }
         this.updateDB(0,0,[],null,0,Character);
      }
      
      public function setPlayerCommand(param1:String, param2:* = null, param3:* = null) : Boolean
      {
         var AttackerBattleBuff:Object;
         var AttackerBattleDebuff:Object;
         var adjustedCPRequired:int = 0;
         var tmpEffect:Object = null;
         var skillList:Array = null;
         var skillData:Object = null;
         var skillStr:* = undefined;
         var skillEffectStr:String = null;
         var equipmentId:String = null;
         var fiveElenemtArr:Array = null;
         var blockElementObj:Object = null;
         var BloodLineDataObj:Object = null;
         var BLeffect:Object = null;
         var strToHash:String = null;
         var DLdmg:int = 0;
         var SenjutsuDataObj:Object = null;
         var Senjutsueffect:Object = null;
         var SENdmg:int = 0;
         var charBackItemEffect:Object = null;
         var charWeaponEffect:Object = null;
         var action:String = param1;
         var data:* = param2;
         var skilldata:* = param3;
         lastBattleAction = this.battleAction;
         if(!this.securityCheck())
         {
            Main.disconnect();
            Main.onError();
            return false;
         }
         AttackerBattleBuff = this.getBattleBuff();
         AttackerBattleDebuff = this.getBattleDebuff();
         switch(action)
         {
            case "weapon_attack":
               this.battleAction = {"action":action};
               break;
            case "charge":
               this.battleAction = {
                  "action":action,
                  "animation":action
               };
               break;
            case "skill":
               skillList = this.getSkillListArr();
               skillData = Main.SKILL_DATA[skillList[data]];
               skillStr = String(skillData["id"]) + skillData["dbid"] + skillData["gold"] + skillData["crystal"] + skillData["prestige"] + skillData["pvp_point"] + skillData["merit"] + skillData["damage"] + skillData["rarity"] + skillData["cp"] + skillData["cooldown"] + skillData["level"] + skillData["premium"] + skillData["vendor"] + skillData["train_time"];
               if(skillData["hash"] != Sha1Encrypt.encrypt(skillStr) && !Data.TEST_VERSION)
               {
                  Out.error(this,"Error: " + Main.coreData.SKILL_DATA_ERROR);
                  Main.onError();
                  return false;
               }
               skillEffectStr = String(skillData.id) + String(skillData.effect.type) + String(skillData["effect"]["duration"]) + String(skillData["effect"]["amount"]) + String(skillData.swfName);
               equipmentId = this.getWeapon();
               if(skillData.id == "skill908" && equipmentId == "wpn1596")
               {
                  GodSnapCountDown = Central.main.GodSnapCountDown - (getTimer() - Central.main.thanosCountDownUpdateTimer) / 1000;
                  if(GodSnapCountDown > 0)
                  {
                     Main.showInfo(String(String(Central.main.langLib.get(2060)).replace("[valskillname]",skillData.name)).replace("[valcooldownsec]",this.convertToHHMMSS(GodSnapCountDown)));
                     return false;
                  }
               }
               if(skillData.id == "skill902" && equipmentId == "wpn1596")
               {
                  UnstoppableRageCountDown = Central.main.UnstoppableRageCountDown - (getTimer() - Central.main.thanosCountDownUpdateTimer) / 1000;
                  if(UnstoppableRageCountDown > 0)
                  {
                     Main.showInfo(String(String(Central.main.langLib.get(2060)).replace("[valskillname]",skillData.name)).replace("[valcooldownsec]",this.convertToHHMMSS(UnstoppableRageCountDown)));
                     return false;
                  }
               }
               if(this.isBattleSkillCooldown(skillData.id))
               {
                  Main.showInfo(String(String(Central.main.langLib.get(384)).replace("[valskillname]",skillData.name)).replace("[valcooldoen]",this.battleSkillCooldown[skillData.id]));
                  return false;
               }
               adjustedCPRequired = int(skillData.cp);
               if(skillData.effect != null)
               {
                  if(skillData.effect.type == BattleData.EFFECT_CLEAR_BUFF_N_INTERNAL_INJURY_THANOS && this.getWeapon() == "wpn1596")
                  {
                     adjustedCPRequired = 400;
                  }
               }
               if(skillData.effect != null)
               {
                  if(skillData.effect.type == BattleData.EFFECT_DAMAGE_BONUS_FIX_NUM_THANOS && this.getWeapon() == "wpn1596")
                  {
                     adjustedCPRequired = 200;
                  }
               }
               if(this.isBattleBuffActive(BattleData.EFFECT_EXCITATION_CP))
               {
                  adjustedCPRequired = 0;
               }
               if(this.isBattleBuffActive(BattleData.EFFECT_CP_LOCK))
               {
                  adjustedCPRequired = 0;
               }
               if(this.isBattleBuffActive(BattleData.EFFECT_REDUCE_SELF_CP_CONSUME))
               {
                  adjustedCPRequired = Math.round(adjustedCPRequired * (1 - int(this.getBattleBuff()[BattleData.EFFECT_REDUCE_SELF_CP_CONSUME].amount) / 100));
                  if(this.cp < adjustedCPRequired)
                  {
                     Main.showInfo(Central.main.langLib.get(385));
                     return false;
                  }
               }
               if(this.isBattleBuffActive(BattleData.EFFECT_REDUCE_CP_REQUIRE))
               {
                  adjustedCPRequired = Math.round(adjustedCPRequired * (int(this.getBattleBuff()[BattleData.EFFECT_REDUCE_CP_REQUIRE].amount) / 100));
                  if(this.cp < adjustedCPRequired)
                  {
                     Main.showInfo(Central.main.langLib.get(385));
                     return false;
                  }
               }
               if(this.isBattleBuffActive(BattleData.EFFECT_PET_SAVE_CP))
               {
                  adjustedCPRequired = Math.round(adjustedCPRequired * (1 - this.getBattleBuff()[BattleData.EFFECT_PET_SAVE_CP].amount / 100));
                  if(this.cp < adjustedCPRequired)
                  {
                     Main.showInfo(Central.main.langLib.get(385));
                     return false;
                  }
               }
               if(this.getBackItem())
               {
                  charBackItemEffect = Central.main.BACK_ITEM_DATA.find(this.getBackItem()).effect;
                  for each(tmpEffect in charBackItemEffect)
                  {
                     switch(tmpEffect.type)
                     {
                        case BattleData.EFFECT_REDUCE_CP_REQUIRE:
                           if(tmpEffect.chance == 100)
                           {
                              adjustedCPRequired = Math.round(adjustedCPRequired * (1 - charBackItemEffect.amount * 0.01));
                              if(this.cp < adjustedCPRequired)
                              {
                                 Main.showInfo(Central.main.langLib.get(385));
                                 return false;
                              }
                           }
                     }
                  }
               }
               if(this.getWeapon())
               {
                  charWeaponEffect = Central.main.WEAPON_DATA.find(this.getWeapon()).effect;
                  for each(tmpEffect in charWeaponEffect)
                  {
                     switch(tmpEffect.type)
                     {
                        case BattleData.EFFECT_REDUCE_CP_REQUIRE:
                           if(tmpEffect.amount > 0)
                           {
                              adjustedCPRequired = Math.round(adjustedCPRequired * (tmpEffect.amount / 100));
                              if(this.cp < adjustedCPRequired)
                              {
                                 Main.showInfo(Central.main.langLib.get(385));
                                 return false;
                              }
                           }
                     }
                  }
               }
               if(this.isBattleDebuffActive(BattleData.SKILL_341))
               {
                  adjustedCPRequired = Math.round(adjustedCPRequired * (int(this.getBattleDebuff()[BattleData.SKILL_341].amount) / 100));
                  if(this.cp < adjustedCPRequired)
                  {
                     Main.showInfo(Central.main.langLib.get(385));
                     return false;
                  }
               }
               if(this.isBattleDebuffActive(BattleData.EFFECT_CUBE_ILLUSION))
               {
                  adjustedCPRequired = Math.round(adjustedCPRequired * 1.4);
                  if(this.cp < adjustedCPRequired)
                  {
                     Main.showInfo(Central.main.langLib.get(680));
                     return false;
                  }
               }
               if(this.isBattleDebuffActive(BloodlineData.EFFECT_EXTRA_CP_USE))
               {
                  adjustedCPRequired = Math.round(adjustedCPRequired * 2);
                  if(this.cp < adjustedCPRequired)
                  {
                     Main.showInfo(Central.main.langLib.get(385));
                     return false;
                  }
               }
               if(this.isBattleDebuffActive(BattleData.EFFECT_TRANSFORM))
               {
                  adjustedCPRequired = Math.round(adjustedCPRequired * 3);
                  if(this.cp < adjustedCPRequired)
                  {
                     Main.showInfo(Central.main.langLib.get(385));
                     return false;
                  }
               }
               if(this.isBattleDebuffActive(BattleData.EFFECT_CP_BLEEDING))
               {
                  adjustedCPRequired = Math.round(adjustedCPRequired * (int(this.getBattleDebuff()[BattleData.EFFECT_CP_BLEEDING].amount) * 0.01));
                  if(this.cp < adjustedCPRequired)
                  {
                     Main.showInfo(Central.main.langLib.get(385));
                     return false;
                  }
               }
               fiveElenemtArr = ["fire","wind","earth","water","lightning"];
               blockElementObj = {
                  "fire":"wind",
                  "wind":"lightning",
                  "lightning":"earth",
                  "earth":"water",
                  "water":"fire"
               };
               if(fiveElenemtArr.indexOf(String(skillData.type)) >= 0)
               {
                  if(this.isBattleDebuffActive(BattleData.EFFECT_BUNDLE))
                  {
                     Main.showInfo(Central.main.langLib.get(386));
                     return false;
                  }
                  if(this.isBattleDebuffActive(BattleData.SKILL_377))
                  {
                     Main.showInfo(Central.main.langLib.get(386));
                     return false;
                  }
                  if(this.isBattleDebuffActive(BattleData.EFFECT_MERIDIANS_SEAL))
                  {
                     Main.showInfo(Central.main.langLib.get(526));
                     return false;
                  }
                  if(this.isBattleDebuffActive(BattleData.EFFECT_PARALYZE))
                  {
                     Main.showInfo(Central.main.langLib.get(2050));
                     return false;
                  }
                  if(this.isBattleDebuffActive(BattleData.EFFECT_ECSTATIC_SOUND))
                  {
                     Main.showInfo(Central.main.langLib.get(610));
                     return false;
                  }
                  if(String(skillData.type).indexOf(blockElementObj[String(Central.battle.getBattleBackground().name)]) >= 0)
                  {
                     switch(blockElementObj[String(Central.battle.getBattleBackground().name)])
                     {
                        case "fire":
                           Main.showInfo(Central.main.langLib.get(1842)[0]);
                           break;
                        case "wind":
                           Main.showInfo(Central.main.langLib.get(1842)[1]);
                           break;
                        case "lightning":
                           Main.showInfo(Central.main.langLib.get(1842)[2]);
                           break;
                        case "earth":
                           Main.showInfo(Central.main.langLib.get(1842)[3]);
                           break;
                        case "water":
                           Main.showInfo(Central.main.langLib.get(1842)[4]);
                     }
                     return false;
                  }
               }
               if(this.isBattleDebuffActive(BattleData.EFFECT_PARALYZE))
               {
                  Main.showInfo(Central.main.langLib.get(798));
                  return false;
               }
               if(this.isBattleDebuffActive(BloodlineData.EFFECT_MERIDIAN_BLOCK))
               {
                  Main.showInfo(Central.main.langLib.get(798));
                  return false;
               }
               if(this.isBattleBuffActive(BloodlineData.EFFECT_SKIP_DEAD_CLEAR_DEBUFF))
               {
                  Main.showInfo(Central.main.langLib.get(798));
                  return false;
               }
               if(skillData.id == "skill908" && equipmentId == "wpn1596")
               {
                  GodSnapCountDown = Central.main.GodSnapCountDown - (getTimer() - Central.main.thanosCountDownUpdateTimer) / 1000;
                  if(GodSnapCountDown <= 0)
                  {
                     Main.amfClient.service("GodSnap.updateGodSnap",[Account.getAccountSessionKey(),"",true],callbackGetSnapUse);
                  }
               }
               if(skillData.id == "skill902" && equipmentId == "wpn1596")
               {
                  UnstoppableRageCountDown = Central.main.UnstoppableRageCountDown - (getTimer() - Central.main.thanosCountDownUpdateTimer) / 1000;
                  if(UnstoppableRageCountDown <= 0)
                  {
                     Main.amfClient.service("GodSnap.updateGodSnap",[Account.getAccountSessionKey(),"",false],callbackGetSnapUse);
                  }
               }
               Main.showInfo(skillData.name);
               if(!Central.main.isNewChar)
               {
                  if(this.getCharacterId() == Main.getMainChar().getCharacterId())
                  {
                     Main.achievement.updateBattleStat(Main.achievementData.USE_SKILL,1);
                  }
               }
               try
               {
                  if(Boolean(skillData.type) && Boolean(skillData.id))
                  {
                     if(Central.battle.type != Central.battle.TYPE_NETWORK)
                     {
                        Main.tracking.trackSkillUsed(skillData.type,skillData.id);
                     }
                     else
                     {
                        Main.tracking.generalTrack(Central.main.tracking.TRACK_PVP,skillData.id,Central.main.tracking.TRACK_PVP_SKILL_USED + skillData.type);
                     }
                  }
               }
               catch(err:Error)
               {
                  Out.error(this,"TRACKING :: skillData not found! :: " + err.message);
               }
               switch(skillData.target)
               {
                  case SkillData.TARGET_SELF:
                     Battle.setDefender(this);
               }
               this.battleAction = {
                  "action":action,
                  "skillId":skillData.id
               };
               return true;
               break;
            case "item":
               this.battleAction = {
                  "action":action,
                  "item":data
               };
               return true;
            case "pass":
               this.battleAction = {"action":action};
               return true;
            case "dodge":
               this.battleAction = {"action":action};
               return true;
            case "class_skill":
               this.battleAction = {
                  "action":action,
                  "skillId":data
               };
               return true;
            case "bloodline":
               BloodLineDataObj = skilldata.skillData;
               BLeffect = {};
               strToHash = String(BloodLineDataObj.effect["skill_level"]) + String(BloodLineDataObj.effect["skill_cp"]) + String(BloodLineDataObj.effect["skill_damage"]) + String(BloodLineDataObj.effect["duration_1"]) + String(BloodLineDataObj.effect["effect_target_1"]) + String(BloodLineDataObj.effect["effect_amount_1"]) + String(BloodLineDataObj.effect["effect_chancetohit_1"]) + String(BloodLineDataObj.effect["effect_chancetoeffect_1"]) + String(BloodLineDataObj.effect["duration_2"]) + String(BloodLineDataObj.effect["effect_target_2"]) + String(BloodLineDataObj.effect["effect_amount_2"]) + String(BloodLineDataObj.effect["effect_chancetohit_2"]) + String(BloodLineDataObj.effect["effect_chancetoeffect_2"]) + String(BloodLineDataObj.effect["duration_3"]) + String(BloodLineDataObj.effect["effect_target_3"]) + String(BloodLineDataObj.effect["effect_amount_3"]) + String(BloodLineDataObj.effect["effect_chancetohit_3"]) + String(BloodLineDataObj.effect["effect_chancetoeffect_3"]);
               if(BloodLineDataObj.effect.hash != Sha1Encrypt.encrypt(strToHash))
               {
                  Out.error(this,"Error: " + Main.coreData.SKILL_EFFECT_ERROR);
                  Main.onError();
                  return false;
               }
               if(this.isBattleSkillCooldown(BloodLineDataObj.id))
               {
                  Main.showInfo(String(String(Central.main.langLib.get(384)).replace("[valskillname]",BloodLineDataObj.name)).replace("[valcooldoen]",this.battleSkillCooldown[BloodLineDataObj.id]));
                  return false;
               }
               adjustedCPRequired = int(BloodLineDataObj.cp);
               if(this.isBattleBuffActive(BattleData.EFFECT_EXCITATION_CP))
               {
                  adjustedCPRequired = 0;
               }
               if(this.isBattleBuffActive(BattleData.EFFECT_REDUCE_SELF_CP_CONSUME))
               {
                  adjustedCPRequired = Math.round(adjustedCPRequired * (1 - int(this.getBattleBuff()[BattleData.EFFECT_REDUCE_SELF_CP_CONSUME].amount) / 100));
                  if(this.cp < adjustedCPRequired)
                  {
                     Main.showInfo(Central.main.langLib.get(385));
                     return false;
                  }
               }
               if(this.isBattleBuffActive(BattleData.EFFECT_PET_SAVE_CP))
               {
                  adjustedCPRequired = Math.round(adjustedCPRequired * (1 - this.getBattleBuff()[BattleData.EFFECT_PET_SAVE_CP].amount / 100));
                  if(this.cp < adjustedCPRequired)
                  {
                     Main.showInfo(Central.main.langLib.get(385));
                     return false;
                  }
               }
               if(this.isBattleDebuffActive(BattleData.SKILL_341))
               {
                  adjustedCPRequired = Math.round(adjustedCPRequired * (int(this.getBattleDebuff()[BattleData.SKILL_341].amount) / 100));
                  if(this.cp < adjustedCPRequired)
                  {
                     Main.showInfo(Central.main.langLib.get(385));
                     return false;
                  }
               }
               if(this.isBattleDebuffActive(BattleData.EFFECT_CUBE_ILLUSION))
               {
                  adjustedCPRequired = Math.round(adjustedCPRequired * 1.4);
                  if(this.cp < adjustedCPRequired)
                  {
                     Main.showInfo(Central.main.langLib.get(680));
                     return false;
                  }
               }
               if(this.isBattleDebuffActive(BloodlineData.EFFECT_EXTRA_CP_USE))
               {
                  adjustedCPRequired = Math.round(adjustedCPRequired * 2);
                  if(this.cp < adjustedCPRequired)
                  {
                     Main.showInfo(Central.main.langLib.get(385));
                     return false;
                  }
               }
               if(this.isBattleDebuffActive(BattleData.EFFECT_TRANSFORM))
               {
                  adjustedCPRequired = Math.round(adjustedCPRequired * 3);
                  if(this.cp < adjustedCPRequired)
                  {
                     Main.showInfo(Central.main.langLib.get(385));
                     return false;
                  }
               }
               if(this.isBattleDebuffActive(BattleData.EFFECT_CP_BLEEDING))
               {
                  adjustedCPRequired = Math.round(adjustedCPRequired * (int(this.getBattleDebuff()[BattleData.EFFECT_CP_BLEEDING].amount) * 0.01));
                  if(this.cp < adjustedCPRequired)
                  {
                     Main.showInfo(Central.main.langLib.get(385));
                     return false;
                  }
               }
               if(this.isBattleDebuffActive(BloodlineData.EFFECT_MERIDIAN_BLOCK))
               {
                  Main.showInfo(Central.main.langLib.get(798));
                  return false;
               }
               if(this.isBattleDebuffActive(SenjutsuData.EFFECT_SS_BUNDLE_TALENT))
               {
                  Main.showInfo(Central.main.langLib.get(2001)[7]);
                  return false;
               }
               Main.showInfo(BloodLineDataObj.name);
               DLdmg = int(Main.calcSkillDamage(this,BloodLineDataObj));
               BLeffect = BloodLineDataObj.effect;
               if(DLdmg != 0)
               {
                  this.battleAction = {
                     "action":action,
                     "skillId":data,
                     "posType":BloodLineDataObj.posType,
                     "cp":BloodLineDataObj.cp,
                     "dmg":DLdmg,
                     "effect":BLeffect,
                     "BLSKILLID":BloodLineDataObj.id,
                     "BLTYPE":BloodLineDataObj.bloodline_type
                  };
               }
               else
               {
                  this.battleAction = {
                     "action":action,
                     "skillId":data,
                     "posType":BloodLineDataObj.posType,
                     "cp":BloodLineDataObj.cp,
                     "effect":BLeffect,
                     "BLSKILLID":BloodLineDataObj.id,
                     "BLTYPE":BloodLineDataObj.bloodline_type
                  };
               }
               this.battleSkillCooldown[BloodLineDataObj.id] = BloodLineDataObj.cooldown;
               return true;
               break;
            case "senjutsu":
               SenjutsuDataObj = skilldata.skillData;
               Senjutsueffect = {};
               if(this.isBattleSkillCooldown(SenjutsuDataObj.id))
               {
                  Main.showInfo(String(String(Central.main.langLib.get(384)).replace("[valskillname]",SenjutsuDataObj.name)).replace("[valcooldoen]",this.battleSkillCooldown[SenjutsuDataObj.id]));
                  return false;
               }
               if(this.sp < SenjutsuDataObj.sp)
               {
                  Main.showInfo(Central.main.langLib.get(1862)[1]);
                  return false;
               }
               Main.showInfo(SenjutsuDataObj.name);
               SENdmg = int(Main.calcSkillDamage(this,SenjutsuDataObj));
               Senjutsueffect = SenjutsuDataObj.effect;
               if(SENdmg != 0)
               {
                  this.battleAction = {
                     "action":action,
                     "skillId":data,
                     "posType":SenjutsuDataObj.posType,
                     "sp":SenjutsuDataObj.sp,
                     "dmg":SENdmg,
                     "effect":Senjutsueffect,
                     "SENSKILLID":SenjutsuDataObj.id
                  };
               }
               else
               {
                  this.battleAction = {
                     "action":action,
                     "skillId":data,
                     "posType":SenjutsuDataObj.posType,
                     "sp":SenjutsuDataObj.sp,
                     "effect":Senjutsueffect,
                     "SENSKILLID":SenjutsuDataObj.id
                  };
               }
               this.battleSkillCooldown[SenjutsuDataObj.id] = SenjutsuDataObj.cooldown;
               return true;
               break;
            case "event_action":
               this.battleAction = {"action":action};
         }
         return false;
      }
      
      public function callbackGetSnapUse(param1:Object) : void
      {
         if(Main.validateAmfResponse(param1))
         {
            if(Boolean(param1) && Boolean(param1.result))
            {
               Central.main.GodSnapCountDown = param1.result.GodSnapCountDown;
               Central.main.UnstoppableRageCountDown = param1.result.UnstoppableRageCountDown;
               Central.main.thanosCountDownUpdateTimer = getTimer();
            }
         }
      }
      
      private function getDamage() : int
      {
         var _loc1_:String = this.getWeapon();
         var _loc2_:Object = Main.WEAPON_DATA.find(_loc1_);
         return Formula.calcDamage(_loc2_,{"character":this});
      }
      
      private function checkCoolDown(param1:Object) : *
      {
         var _loc2_:Array = null;
         var _loc3_:int = 0;
         var _loc4_:Object = null;
         if(param1.skill_cooldown_group != 0 && Boolean(param1.skill_cooldown_group))
         {
            _loc2_ = this.getSkillListArr();
            _loc3_ = 0;
            while(_loc3_ < _loc2_.length)
            {
               _loc4_ = Main.SKILL_DATA[_loc2_[_loc3_]];
               if(_loc4_.skill_cooldown_group == param1.skill_cooldown_group)
               {
                  this.battleSkillCooldown[_loc4_.id] = param1.cooldown;
               }
               _loc3_++;
            }
         }
         else
         {
            this.battleSkillCooldown[param1.id] = param1.cooldown;
         }
      }
      
      public function getDBChar() : DBCharacter
      {
         return this.dbChar;
      }
      
      public function getGender() : uint
      {
         return this.dbChar.character_gender;
      }
      
      public function isLevelCap() : Boolean
      {
         if(this.getData(DBCharacterData.RANK) == RankData.GENIN && this.getLevel() >= RankData.GENIN_LEVEL_CAP)
         {
            return true;
         }
         if(this.getData(DBCharacterData.RANK) >= RankData.CHUNIN && this.getLevel() >= RankData.CHUNIN_LEVEL_CAP && this.getData(DBCharacterData.RANK) < RankData.JOUNIN)
         {
            return true;
         }
         if(this.getData(DBCharacterData.RANK) >= RankData.JOUNIN && this.getLevel() >= RankData.JOUNIN_LEVEL_CAP && this.getData(DBCharacterData.RANK) < RankData.SPECIAL_JOUNIN)
         {
            return true;
         }
         if(this.getData(DBCharacterData.RANK) >= RankData.SPECIAL_JOUNIN && this.getLevel() >= RankData.SPECIAL_JOUNIN_LEVEL_CAP && this.getData(DBCharacterData.RANK) < RankData.TUTOR)
         {
            return true;
         }
         if(this.getData(DBCharacterData.RANK) >= RankData.TUTOR && this.getLevel() >= RankData.TUTOR_LEVEL_CAP)
         {
            return true;
         }
         return false;
      }
      
      public function updateXP(param1:int, param2:Boolean = true, param3:Boolean = false) : Boolean
      {
         if(this.getData(DBCharacterData.ID) != Main.getMainChar().getData(DBCharacterData.ID))
         {
            return false;
         }
         if(param1 < 0)
         {
            param1 = 0;
         }
         if(param2)
         {
            if(this.pet)
            {
               if(this.pet.getLevel() < this.getLevel())
               {
                  this.pet.updateXP(Math.round(param1 * 0.2));
               }
            }
         }
         if(Boolean(Central.main.getMainChar().getData(DBCharacterData.RANK) >= RankData.TUTOR) && (Boolean(Central.battle && Central.battle.subType != BattleData.SUBTYPE_BOSS && this.getData(DBCharacterData.ID) == Central.main.getMainChar().getData(DBCharacterData.ID))) && !Central.main.addingXPInGashapon)
         {
            param1 = 0;
         }
         if(this.getData(DBCharacterData.RANK) == RankData.GENIN && this.getLevel() >= RankData.GENIN_LEVEL_CAP)
         {
            param1 = 0;
            return false;
         }
         if(this.getData(DBCharacterData.RANK) >= RankData.CHUNIN && this.getLevel() >= RankData.CHUNIN_LEVEL_CAP && this.getData(DBCharacterData.RANK) < RankData.JOUNIN)
         {
            param1 = 0;
            return false;
         }
         if(this.getData(DBCharacterData.RANK) >= RankData.JOUNIN && this.getLevel() >= RankData.JOUNIN_LEVEL_CAP && this.getData(DBCharacterData.RANK) < RankData.SPECIAL_JOUNIN)
         {
            param1 = 0;
            return false;
         }
         if(this.getData(DBCharacterData.RANK) >= RankData.SPECIAL_JOUNIN && this.getLevel() >= RankData.SPECIAL_JOUNIN_LEVEL_CAP && this.getData(DBCharacterData.RANK) < RankData.TUTOR)
         {
            param1 = 0;
            return false;
         }
         if(this.getData(DBCharacterData.RANK) >= RankData.TUTOR && this.getLevel() >= RankData.TUTOR_LEVEL_CAP)
         {
            param1 = 0;
            return false;
         }
         if(this.getData(DBCharacterData.RANK) >= RankData.TUTOR && !param3)
         {
            param1 = 0;
            return false;
         }
         if(!this.securityCheck())
         {
            return false;
         }
         this.dbChar.character_xp += param1;
         Mission.updateDailyTask(DailyTaskData.TYPE_XP,param1);
         StaticVariables.xpStr = Sha1Encrypt.encrypt(String(this.xp));
         var _loc4_:uint = Formula.getLvByXp(this.xp);
         if(_loc4_ > this.dbChar.character_level)
         {
            this.dbChar.character_level = _loc4_;
            this.restoreOriginalStatus();
            Main.tracking.trackLevelUp();
            return true;
         }
         if(this.dbChar.character_level > _loc4_)
         {
            this.dbChar.character_level = _loc4_;
            this.restoreOriginalStatus();
         }
         return false;
      }
      
      private function verifyLevel() : void
      {
         var _loc1_:uint = Formula.getLvByXp(this.xp);
         if(_loc1_ != this.dbChar.character_level)
         {
            this.dbChar.character_level = _loc1_;
            this.restoreOriginalStatus();
         }
      }
      
      public function get xp() : int
      {
         return this.dbChar.character_xp;
      }
      
      public function checkLvUpReward() : void
      {
         if(int(this.getLevel()) <= 9)
         {
            Central.main.amfClient.service("SpecialReward.getLvUpReward",[Central.main.account.getAccountSessionKey()],this.getLvUpRewardResponse);
         }
      }
      
      private function getLvUpRewardResponse(param1:Object) : void
      {
         var _loc2_:Object = null;
         if(Central.main.validateAmfResponse(param1))
         {
            _loc2_ = param1.result;
            Central.main.hasLvUpReward = _loc2_.haslvupreward;
            Central.main.lvUpRewardType = int(_loc2_.lvuprewardtype);
            Central.main.lvUpTokenClaimed = _loc2_.lvuptokenclaimed;
            if(Central.main.hasLvUpReward)
            {
               Central.main.showGuide(Central.main.hasLvUpReward);
            }
         }
      }
      
      public function hasEnoughGold(param1:uint) : Boolean
      {
         if(this.getGold() - param1 >= 0)
         {
            return true;
         }
         return false;
      }
      
      public function getGold() : uint
      {
         return this.dbChar.character_gold;
      }
      
      public function setGold(param1:int) : void
      {
         this.dbChar.character_gold = param1;
      }
      
      public function setXp(param1:int, param2:int) : void
      {
         Mission.updateDailyTask(DailyTaskData.TYPE_XP,param1 - this.xp);
         this.dbChar.character_xp = param1;
         StaticVariables.xpStr = Sha1Encrypt.encrypt(String(param1));
         var _loc3_:uint = Formula.getLvByXp(param1);
         var _loc4_:* = this.dbChar.character_level;
         if(_loc3_ != _loc4_)
         {
            this.dbChar.character_level = _loc3_;
            this.restoreOriginalStatus();
            if(_loc3_ > _loc4_)
            {
               Main.tracking.trackLevelUp();
            }
         }
         if(param2)
         {
            this.pet.updateXP(param2 - this.pet.xp);
         }
      }
      
      public function updateGold(param1:int) : void
      {
         this.dbChar.character_gold += param1;
         if(this.getCharacterId() == Main.getMainChar().getCharacterId())
         {
            Main.achievement.updateCharStat(Main.achievementData.GOLD_OBTAINED,param1);
         }
      }
      
      public function walkTo(param1:Point) : *
      {
         Out.debug("","swf x = " + this.swf.x);
         Out.debug("","swf y = " + this.swf.y);
         this.origPoint.x = this.swf.x;
         this.origPoint.y = this.swf.y;
         Out.debug("","targetPoint x = " + param1.x);
         Out.debug("","targetPoint y = " + param1.y);
         this.targetPoint.x = param1.x;
         this.targetPoint.y = param1.y;
         this.walkDuration = Math.ceil(Math.sqrt(Math.pow(param1.x - this.swf.x,2) + Math.pow(param1.y - this.swf.y,2)) * runSpeed / 100);
         this.walkDuration = this.walkDuration <= 0 ? 1 : this.walkDuration;
         this.xStep = 0;
         this.yStep = 0;
         if(this.origPoint.x < this.targetPoint.x)
         {
            this.faceRight();
         }
         else
         {
            this.faceLeft();
         }
         if(!this.onMove)
         {
            this.onMove = true;
            this.playRun();
         }
         this.swf.addEventListener(Event.ENTER_FRAME,this.onEnterWalk);
      }
      
      private function onEnterWalk(param1:Event) : *
      {
         var _loc2_:Point = null;
         var _loc3_:Array = null;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:Boolean = false;
         var _loc7_:MovieClip = null;
         var _loc8_:MovieClip = null;
         var _loc9_:MovieClip = null;
         var _loc10_:* = undefined;
         var _loc11_:* = undefined;
         var _loc12_:* = undefined;
         if((this.xStep <= this.walkDuration || this.yStep <= this.walkDuration) && this.onMove)
         {
            _loc2_ = new Point(this.swf.x,this.swf.y);
            this.swf.x = this.linearTween(this.xStep,this.origPoint.x,this.targetPoint.x - this.origPoint.x,this.walkDuration);
            this.swf.y = this.linearTween(this.yStep,this.origPoint.y,this.targetPoint.y - this.origPoint.y,this.walkDuration);
            _loc3_ = Mission.getMapMissionEnemies();
            _loc4_ = 0;
            while(_loc4_ < _loc3_.length)
            {
               if(_loc3_[_loc4_].died == null || _loc3_[_loc4_].died != true)
               {
                  if(_loc3_[_loc4_].enemy.isHitObject(this.hitArea))
                  {
                     GF.removeAllChild(MovieClip(this.swf.parent));
                     _loc3_[_loc4_].enemy.removeParent();
                     this.onMove = false;
                     this.playStand();
                     this.swf.removeEventListener(Event.ENTER_FRAME,this.onEnterWalk);
                     Mission.setCurrentEnemy(_loc4_);
                     Mission.getSetting().charPos = new Point(this.swf.x,this.swf.y);
                     Mission.getSetting().charDir = this.swf.scaleX / Math.abs(this.swf.scaleX);
                     Main.setEnemy(_loc3_[_loc4_].enemies);
                     return;
                  }
               }
               _loc4_++;
            }
            if(Central.main.checkGameStatus() == Timeline.MISSION)
            {
               if(Mission.getMapMissionExit())
               {
                  if(this.hitArea.hitTestObject(Mission.getMapMissionExit()))
                  {
                     this.stopWalk();
                     Main.showConfirmation(Central.main.langLib.get(387),Mission.failMission,new Function());
                  }
               }
            }
            _loc6_ = true;
            if(Mission.getMapMissionType() == MissionData.MAP_TYPE_MULTIPLE)
            {
               _loc7_ = Mission.getCurrentMap()["linkAreaMc"];
               if(_loc7_)
               {
                  trace("this.shadowx" + this.shadow.x);
                  trace("this.shadowy" + this.shadow.y);
                  _loc5_ = 0;
                  while(_loc5_ < _loc7_.numChildren)
                  {
                     if(this.shadow.hitTestObject(MovieClip(_loc7_.getChildAt(_loc5_))))
                     {
                        this.stopWalk();
                        Mission.hitMapMissionLink(_loc5_);
                        break;
                     }
                     _loc5_++;
                  }
               }
               _loc8_ = Mission.getCurrentMap()["blockAreaMc"];
               if(_loc8_ != null)
               {
                  if(_loc8_.numChildren > 0)
                  {
                     _loc10_ = 0;
                     while(_loc10_ < _loc8_.numChildren)
                     {
                        if(this.shadow.hitTestObject(_loc8_.getChildAt(_loc10_)))
                        {
                           _loc6_ = false;
                           break;
                        }
                        _loc10_++;
                     }
                  }
               }
               _loc9_ = Mission.getCurrentMap()["npcMc"];
               if(_loc9_ != null)
               {
                  if(_loc9_.numChildren > 0)
                  {
                     _loc5_ = 0;
                     while(_loc5_ < _loc9_.numChildren)
                     {
                        if(this.swf.hitTestObject(_loc9_.getChildAt(_loc5_)))
                        {
                           if(Mission.hitMapObject(MovieClip(_loc9_.getChildAt(_loc5_)).name))
                           {
                              this.stopWalk();
                              break;
                           }
                        }
                        _loc5_++;
                     }
                  }
               }
            }
            if(!_loc6_)
            {
               _loc11_ = this.swf.y;
               this.swf.y = _loc2_.y;
               _loc6_ = true;
               _loc5_ = 0;
               while(_loc5_ < _loc8_.numChildren)
               {
                  if(this.shadow.hitTestObject(_loc8_.getChildAt(_loc5_)))
                  {
                     _loc6_ = false;
                     break;
                  }
                  _loc5_++;
               }
               if(!_loc6_)
               {
                  this.swf.x = _loc2_.x;
                  this.swf.y = _loc11_;
                  _loc6_ = true;
                  _loc12_ = 0;
                  while(_loc12_ < _loc8_.numChildren)
                  {
                     if(this.shadow.hitTestObject(_loc8_.getChildAt(_loc12_)))
                     {
                        _loc6_ = false;
                        break;
                     }
                     _loc12_++;
                  }
                  if(!_loc6_)
                  {
                     this.swf.x = _loc2_.x;
                     this.swf.y = _loc2_.y;
                     this.stopWalk();
                  }
                  else if(this.yStep <= this.walkDuration)
                  {
                     ++this.yStep;
                  }
               }
               else if(this.xStep <= this.walkDuration)
               {
                  ++this.xStep;
               }
            }
            else
            {
               if(this.xStep <= this.walkDuration)
               {
                  ++this.xStep;
               }
               if(this.yStep <= this.walkDuration)
               {
                  ++this.yStep;
               }
            }
            if(Math.round(_loc2_.x) == Math.round(this.swf.x) && Math.round(_loc2_.y) == Math.round(this.swf.y) && (this.xStep > 1 || this.yStep > 1))
            {
               this.stopWalk();
            }
         }
         else
         {
            this.stopWalk();
         }
      }
      
      private function linearTween(param1:*, param2:*, param3:*, param4:*) : *
      {
         return param3 * param1 / param4 + param2;
      }
      
      public function stopWalk() : void
      {
         this.onMove = false;
         this.playStand();
         this.swf.removeEventListener(Event.ENTER_FRAME,this.onEnterWalk);
      }
      
      public function gotoPoint(param1:Point) : void
      {
         this.swf.x = param1.x;
         this.swf.y = param1.y;
      }
      
      public function faceLeft() : *
      {
         this.swf.scaleX = Math.abs(this.swf.scaleX);
      }
      
      public function faceRight() : *
      {
         this.swf.scaleX = 0 - Math.abs(this.swf.scaleX);
      }
      
      override public function getSwf() : MovieClip
      {
         return super.getSwf();
      }
      
      public function addUsedBattleItem(param1:String) : void
      {
         this.itemUsedInBattle.push(param1);
      }
      
      public function securityCheck() : Boolean
      {
         var _loc4_:String = null;
         var _loc5_:Object = null;
         var _loc6_:String = null;
         var _loc7_:Object = null;
         var _loc8_:String = null;
         if(Main.getMainChar() == null)
         {
            return true;
         }
         if(this.getData(DBCharacterData.ID) != Main.getMainChar().getData(DBCharacterData.ID))
         {
            return true;
         }
         if(Main.coreData.ADMIN_CHARACTERS.indexOf(int(this.getData(DBCharacterData.ID))) >= 0)
         {
            return true;
         }
         if(Account.getAccountType() == Account.PREMIUM)
         {
            Main.provision();
         }
         var _loc1_:String = Sha1Encrypt.encrypt(String(this.xp));
         if(_loc1_ != StaticVariables.xpStr)
         {
            Main.saveLog(1,String(this.xp));
            Main.onError();
            return false;
         }
         if(this.getLevel() <= 0)
         {
            Main.onError();
            return false;
         }
         this.verifyLevel();
         var _loc2_:String = Sha1Encrypt.encrypt(String(this.dbChar[DBCharacterData.BODY_PARTS]["weapon"]));
         if(_loc2_ != StaticVariables.weaponStr && this.dbChar.character_equipped_trade_weapon == null)
         {
            Main.saveLog(2,String(this.dbChar[DBCharacterData.BODY_PARTS]["weapon"]));
            Main.onError();
            return false;
         }
         if(Main.WEAPON_DATA)
         {
            _loc4_ = this.dbChar[DBCharacterData.BODY_PARTS]["weapon"];
            _loc5_ = Main.WEAPON_DATA.find(_loc4_);
            if(_loc5_)
            {
               if(_loc5_.level > this.getLevel() || Boolean(_loc5_[WeaponData.PREMIUM]) && Boolean(Account.getAccountType() == Account.FREE))
               {
                  this.dbChar[DBCharacterData.BODY_PARTS]["weapon"] = "wpn1";
                  StaticVariables.weaponStr = Sha1Encrypt.encrypt("wpn1");
                  Main.saveCharacter(true);
                  Main.saveLog(3,_loc4_);
                  Main.onError();
                  return false;
               }
               _loc6_ = String(_loc5_["id"]) + _loc5_["gold"] + _loc5_["crystal"] + _loc5_["sellable"] + _loc5_["damage"] + _loc5_["rarity"] + _loc5_["level"] + _loc5_["premium"] + _loc5_["agility"] + _loc5_["dodge"] + _loc5_["critical"] + _loc5_["fire"] + _loc5_["wind"] + _loc5_["lightning"] + _loc5_["earth"] + _loc5_["water"] + _loc5_["vendor"];
            }
         }
         if(this._pet)
         {
            _loc7_ = Main.PET_DATA.find(this._pet.id);
            if(_loc7_)
            {
               _loc8_ = String(_loc5_["id"]) + _loc7_["swfName"] + _loc7_["clsName"] + _loc7_["type"] + _loc7_["attack_rate"] + _loc7_["defend_rate"] + _loc7_["support_rate"] + _loc7_["gold"] + _loc7_["token"] + _loc7_["premium"] + _loc7_["vendor"] + _loc7_["forge_material"] + _loc7_["forge_base"] + _loc7_["forge_group_id"] + _loc7_["expiry_hour"] + _loc7_["expiry_group_id"] + _loc7_["expiry_token"];
               if(Sha1Encrypt.encrypt(_loc8_) != _loc7_["hash"] && !Data.TEST_VERSION)
               {
                  Main.onError();
               }
            }
         }
         if(int(this.getData(DBCharacterData.MAX_HP)) != 100)
         {
            Main.saveCharacter(true);
            Main.onError();
            return false;
         }
         if(int(this.getData(DBCharacterData.MAX_CP)) != 100)
         {
            Main.saveCharacter(true);
            Main.onError();
            return false;
         }
         if(int(this.getData(DBCharacterData.AGILITY)) != 10)
         {
            Main.saveCharacter(true);
            Main.onError();
            return false;
         }
         while(this.hasItem(InventoryData.TYPE_SKILL,"skill91"))
         {
            this.removeInventory(InventoryData.TYPE_SKILL,"skill91");
         }
         var _loc3_:Array = this.getSkillListArr();
         if(_loc3_.indexOf("skill91") >= 0)
         {
            Main.onError();
            return false;
         }
         return true;
      }
      
      public function getSenjutsuSwfArr() : Array
      {
         return this.senjutsuSwfArr;
      }
      
      public function getSecretListArr() : Array
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
            if(Boolean(Main.BLOODLINE_SKILL_DATA["bloodline_skill" + _loc3_.skill_id]) && Boolean(Main.BLOODLINE_DATA["bloodline" + _loc3_.bloodline_id]))
            {
               _loc4_ = Main.BLOODLINE_SKILL_DATA["bloodline_skill" + _loc3_.skill_id];
               _loc5_ = Main.BLOODLINE_DATA["bloodline" + _loc3_.bloodline_id];
               if(_loc4_.bloodline_type == BloodlineData.SKILL_TYPE_ACTIVE && _loc5_.type == BloodlineData.SKILL_TYPE_SECRET)
               {
                  _loc1_.push(_loc3_);
               }
            }
         }
         return _loc1_;
      }
      
      public function getPassiveListArr() : Array
      {
         var _loc2_:int = 0;
         var _loc3_:Object = null;
         var _loc4_:Object = null;
         var _loc5_:Object = null;
         var _loc6_:Object = null;
         var _loc7_:Object = null;
         var _loc1_:Array = [];
         if(this.dbChar.bloodline != null)
         {
            for each(_loc3_ in this.dbChar.bloodline)
            {
               if(Boolean(Main.BLOODLINE_SKILL_DATA["bloodline_skill" + _loc3_.skill_id]) && Boolean(Main.BLOODLINE_DATA["bloodline" + _loc3_.bloodline_id]))
               {
                  _loc4_ = Main.BLOODLINE_SKILL_DATA["bloodline_skill" + _loc3_.skill_id];
                  _loc5_ = Main.BLOODLINE_DATA["bloodline" + _loc3_.bloodline_id];
                  if(_loc4_.bloodline_type == BloodlineData.SKILL_TYPE_PASSIVE)
                  {
                     if(Central.battle.type == Central.battle.TYPE_NETWORK)
                     {
                        if(Central.main.resurrection == true)
                        {
                           if(!(!this.isBattleBuffActive(BloodlineData.EFFECT_COPY_JUTSU + ".skill1023") && _loc3_.bloodline_id == 1))
                           {
                              _loc1_.push(_loc3_);
                           }
                        }
                        else
                        {
                           _loc1_.push(_loc3_);
                        }
                     }
                     else if(!(!this.isBattleBuffActive(BloodlineData.EFFECT_COPY_JUTSU + ".skill1023") && _loc3_.bloodline_id == 1))
                     {
                        _loc1_.push(_loc3_);
                     }
                  }
               }
            }
         }
         if(this.dbChar.senjutsu != null)
         {
            for each(_loc6_ in this.dbChar.senjutsu)
            {
               if(Boolean(Main.SENJUTSU_SKILL_DATA["senjutsu_skill" + _loc6_.skill_id]) && Boolean(Main.SENJUTSU_DATA["senjutsu" + _loc6_.senjutsu_id]))
               {
                  _loc7_ = Main.SENJUTSU_SKILL_DATA["senjutsu_skill" + _loc6_.skill_id];
                  if(_loc7_.senjutsu_type == SenjutsuData.SKILL_TYPE_PASSIVE)
                  {
                     _loc1_.push(_loc6_);
                  }
               }
            }
         }
         return _loc1_;
      }
      
      public function getBloodlineSwfArr() : Array
      {
         return this.bloodlineSwfArr;
      }
      
      public function getSecretSwfArr() : Array
      {
         return this.secretSwfArr;
      }
      
      public function setBloodlineSwf(param1:MovieClip) : void
      {
         this.bloodlineSwfArr.push(param1);
         param1.setActionFinishCB(this.actionFinish_CB);
         param1.setAttackHitCB(this.attackHit_CB);
      }
      
      public function setSecretSwf(param1:MovieClip) : void
      {
         this.secretSwfArr.push(param1);
         param1.setActionFinishCB(this.actionFinish_CB);
         param1.setAttackHitCB(this.attackHit_CB);
      }
      
      public function playClassSkill(param1:Object, param2:Point) : void
      {
         this.isPlayingAnimation = true;
         this.clearSwf();
         Out.debug(this,"_battleAction.skillId >> " + param1.skillId);
         if(handleAgsinstSkillMemHack(param1.skillId))
         {
            return;
         }
         var _loc3_:MovieClip = this.classSkillSwfArr[this.getClassSkillListArr().indexOf(param1.skillId)];
         switch(param1.posType)
         {
            case PositionType.MELEE_1:
               if(param2 != null)
               {
                  this.charOrigPoint = new Point(this.charMc.x,this.charMc.y);
                  this.charMc.x = param2.x;
                  this.charMc.y = param2.y;
               }
               break;
            case PositionType.MELEE_2:
               if(param2 != null)
               {
                  this.charOrigPoint = new Point(this.charMc.x,this.charMc.y);
                  this.charHitPoint = param2;
               }
               break;
            case PositionType.MELEE_3:
               if(param2 != null)
               {
                  this.charOrigPoint = new Point(this.charMc.x,this.charMc.y);
                  this.charMc.x = param2.x;
                  this.charMc.y = param2.y;
               }
               break;
            case PositionType.MELEE_4:
               if(param2 != null)
               {
                  this.charOrigPoint = new Point(this.charMc.x,this.charMc.y);
                  this.charMc.x = param2.x;
                  this.charMc.y = param2.y;
               }
         }
         this.swf.addChild(_loc3_);
         _loc3_.playAnimation(param1,param2);
      }
      
      public function playSkill(param1:Object, param2:Point) : void
      {
         var _loc3_:String = null;
         this.isPlayingAnimation = true;
         this.clearSwf();
         var _loc4_:String = this.getWeapon();
         if(handleAgsinstSkillMemHack(param1.skillId))
         {
            return;
         }
         _loc3_ = param1.skillId;
         var _loc5_:MovieClip = this.skillSwfArr[this.getSkillListArr().indexOf(param1.skillId)];
         var _loc6_:String = "";
         if(_loc3_ == "skill908" && _loc4_ == "wpn1596")
         {
            _loc3_ = "skill908A";
            _loc5_ = null;
            _loc6_ = "A";
         }
         if(_loc3_ == "skill902" && _loc4_ == "wpn1596")
         {
            _loc3_ = "skill902A";
            _loc5_ = null;
            _loc6_ = "A";
         }
         if(_loc5_ == null)
         {
            _loc5_ = Central.skill.getSkill(param1.skillId,_loc6_);
            this.cloneCustomization(_loc5_);
            _loc5_.setActionFinishCB(this.actionFinish_CB);
            _loc5_.setAttackHitCB(this.attackHit_CB);
         }
         switch(param1.posType)
         {
            case PositionType.MELEE_1:
               if(param2 != null)
               {
                  this.charOrigPoint = new Point(this.charMc.x,this.charMc.y);
                  this.charMc.x = param2.x;
                  this.charMc.y = param2.y;
               }
               break;
            case PositionType.MELEE_2:
               if(param2 != null)
               {
                  this.charOrigPoint = new Point(this.charMc.x,this.charMc.y);
                  this.charHitPoint = param2;
               }
               break;
            case PositionType.MELEE_3:
               if(param2 != null)
               {
                  this.charOrigPoint = new Point(this.charMc.x,this.charMc.y);
                  this.charMc.x = param2.x;
                  this.charMc.y = param2.y;
               }
               break;
            case PositionType.MELEE_4:
               if(param2 != null)
               {
                  this.charOrigPoint = new Point(this.charMc.x,this.charMc.y);
                  this.charMc.x = param2.x;
                  this.charMc.y = param2.y;
               }
         }
         this.swf.addChild(_loc5_);
         _loc5_.playAnimation(param1,param2);
      }
      
      override protected function initSkill2003Lv() : void
      {
         var _loc1_:MovieClip = MovieClip(this.charMc.parent);
         if(_loc1_["skill_2003_storage"])
         {
            _loc1_["skill_2003_storage"].visible = false;
            this.skill_2003_lv = -1;
         }
         var _loc2_:* = 0;
         while(_loc2_ < classSkillList.length)
         {
            if(classSkillList[_loc2_] == "skill2003")
            {
               isClassSkillAvailable[_loc2_] = false;
            }
            _loc2_++;
         }
      }
      
      public function updateSkill2003Lv() : void
      {
         var _loc3_:MovieClip = null;
         Out.debug(this,this.getCharacterName() + " :: updateSkill2003Lv :: classSkillList >> " + this.classSkillList + " :: skill_2003_lv >> " + this.skill_2003_lv);
         var _loc1_:Boolean = false;
         var _loc2_:* = 0;
         while(_loc2_ < classSkillList.length)
         {
            if(classSkillList[_loc2_] == "skill2003")
            {
               if(!isClassSkillAvailable[_loc2_])
               {
                  _loc3_ = MovieClip(this.charMc.parent);
                  if(_loc3_["skill_2003_storage"])
                  {
                     if(this.skill_2003_lv == 0)
                     {
                        _loc3_["skill_2003_storage"].visible = false;
                     }
                     ++this.skill_2003_lv;
                     if(this.skill_2003_lv <= 7)
                     {
                        if(this.skill_2003_lv == 7)
                        {
                           isClassSkillAvailable[_loc2_] = true;
                        }
                     }
                  }
               }
            }
            _loc2_++;
         }
      }
      
      override public function setBattleBuff(param1:Object) : Boolean
      {
         var _loc2_:Object = null;
         var _loc3_:Object = null;
         super.setBattleBuff(param1);
         if(Central.battle.type != Central.battle.TYPE_NETWORK)
         {
            if(this.getWeapon())
            {
               _loc3_ = Central.main.WEAPON_DATA.find(this.getWeapon());
               if(Boolean(_loc3_) && int(param1.duration) < 100)
               {
                  for each(_loc2_ in _loc3_.effect)
                  {
                     switch(_loc2_.type)
                     {
                        case BattleData.EFFECT_ADD_HP_CP_RECIEVE_BUFF:
                           this.updateHP(Math.round(this.maxHP * (_loc2_.amount * 0.01)));
                           this.updateCP(Math.round(this.maxCP * (_loc2_.amount * 0.01)));
                           this.showOverheadNumber(Timeline.WORD,"+" + Math.round(this.maxHP * (_loc2_.amount * 0.01)) + " HP");
                           this.showOverheadNumber(Timeline.WORD,"+" + Math.round(this.maxCP * (_loc2_.amount * 0.01)) + " CP");
                           return false;
                        case BattleData.EFFECT_ADD_HP_RECIEVE_BUFF:
                           this.updateHP(Math.round(this.maxHP * (_loc2_.amount * 0.01)));
                           this.showOverheadNumber(Timeline.WORD,"+" + Math.round(this.maxHP * (_loc2_.amount * 0.01)) + " HP");
                           return false;
                     }
                  }
               }
            }
         }
         return true;
      }
      
      public function showLevelUp(param1:Boolean) : *
      {
         if(!isLevelUp)
         {
            isLevelUp = param1;
         }
      }
      
      private function handleAgsinstSkillMemHack(param1:String) : Boolean
      {
         var _loc2_:Object = Main.SKILL_DATA[param1];
         var _loc3_:* = String(_loc2_["id"]) + _loc2_["dbid"] + _loc2_["gold"] + _loc2_["crystal"] + _loc2_["prestige"] + _loc2_["pvp_point"] + _loc2_["merit"] + _loc2_["damage"] + _loc2_["rarity"] + _loc2_["cp"] + _loc2_["cooldown"] + _loc2_["level"] + _loc2_["premium"] + _loc2_["vendor"] + _loc2_["train_time"];
         if(_loc2_["hash"] != Sha1Encrypt.encrypt(_loc3_))
         {
            Main.onError("304");
            return true;
         }
         var _loc4_:String = String(_loc2_.id) + String(_loc2_.effect.type) + String(_loc2_["effect"]["duration"]) + String(_loc2_["effect"]["amount"]) + String(_loc2_.swfName);
         if(_loc2_["effect"]["hash"] != Sha1Encrypt.encrypt(_loc4_))
         {
            Main.onError("304");
            return true;
         }
         return false;
      }
      
      internal function convertToHHMMSS(param1:Number) : String
      {
         var _loc2_:Number = param1 % 60;
         var _loc3_:Number = Math.floor(param1 % 3600 / 60);
         var _loc4_:Number = Math.floor(param1 / (60 * 60));
         var _loc5_:String = _loc4_ == 0 ? "" : doubleDigitFormat(_loc4_) + ":";
         var _loc6_:String = doubleDigitFormat(_loc3_) + ":";
         var _loc7_:String = doubleDigitFormat(_loc2_);
         return _loc5_ + _loc6_ + _loc7_;
      }
      
      internal function doubleDigitFormat(param1:uint) : String
      {
         if(param1 < 10)
         {
            return "0" + param1;
         }
         return String(param1);
      }
   }
}

