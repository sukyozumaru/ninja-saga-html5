package ninjasaga.base
{
   import br.com.stimuli.loading.BulkLoader;
   import com.utils.CreateFilter;
   import com.utils.GF;
   import com.utils.NumberUtil;
   import com.utils.Out;
   import com.utils.Sha1Encrypt;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.filters.ColorMatrixFilter;
   import flash.filters.GlowFilter;
   import flash.geom.Point;
   import flash.net.URLRequest;
   import flash.text.TextField;
   import ninjasaga.*;
   import ninjasaga.asset.*;
   import ninjasaga.battle.*;
   import ninjasaga.data.*;
   import ninjasaga.dbclass.DBCharacter;
   import ninjasaga.loader.AssetLoader;
   
   public class CharacterDisplay extends CharacterBase
   {
      
      protected var swf:MovieClip = new MovieClip();
      
      protected var actionBase:MovieClip;
      
      protected var skillSwfArr:Array = new Array();
      
      protected var bloodlineSwfArr:Array = new Array();
      
      protected var secretSwfArr:Array = new Array();
      
      protected var classSkillSwfArr:Array = new Array();
      
      protected var senjutsuSwfArr:Array = new Array();
      
      public var charMc:MovieClip;
      
      public var charOrigPoint:Point = null;
      
      public var charHitPoint:Point = null;
      
      public var speedBonus:int = 0;
      
      protected var battleAction_CB:Function = null;
      
      protected var battleAttackHit_CB:Function = null;
      
      public var atbTimer:uint = 0;
      
      protected var _clanEffect:Object = {};
      
      protected var threat:Object = {};
      
      protected var enemyGlowFilter:GlowFilter = CreateFilter.getGlowFilter();
      
      protected var commandGlowFilter:GlowFilter = CreateFilter.getGlowFilter({"color":16777215});
      
      private var dimFilter:ColorMatrixFilter = CreateFilter.getSaturationFilter(0);
      
      private var anni4Enemy:Array = ["enemy293","enemy294","enemy295","enemy296","enemy297","enemy298"];
      
      public var isPlayingAnimation:Boolean = false;
      
      private var hpHashString:String;
      
      private var cpHashString:String;
      
      private var spHashString:String;
      
      protected var BG_elemental:int = 0;
      
      protected var elemental_Mode:int = 0;
      
      protected var SufferDamageModifier:uint = 100;
      
      protected var DealDamageModifier:uint = 100;
      
      public var checkTitanRes:Boolean = false;
      
      public var titanRes:Boolean = false;
      
      public var resurrection:Boolean = false;
      
      protected var fuckNoBloodline:Boolean = false;
      
      public var waitingForCommand:Boolean = false;
      
      public var lastBattleAction:Object;
      
      public var pendingSkills:Array;
      
      public var skill_2003_lv:int = 0;
      
      private var buttonEnableArr:Array = [true,true,true,true];
      
      private var skillButtonEnableArr:Array = [true,true,true,true,true,true,true,true];
      
      private var senjutsuButtonEnableArr:Array = [false,false,false,false,false,false,false,false];
      
      private var bloodlineButtonEnableArr:Array = [true,true,true,true];
      
      private var secretButtonEnableArr:Array = [true,true,true,true];
      
      public var startResurrection:Boolean = false;
      
      public function CharacterDisplay()
      {
         super();
      }
      
      public function getSwf() : MovieClip
      {
         this.restoreScale();
         return this.swf;
      }
      
      public function setCharMc(param1:MovieClip) : void
      {
         this.charMc = param1;
         if(param1 != null)
         {
            resetCharMc();
         }
      }
      
      public function resetCharMc() : void
      {
         var _loc3_:MovieClip = null;
         var _loc4_:Array = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         if(this.charMc == null)
         {
            Out.debug("CharacterDisplay ","");
         }
         var _loc1_:MovieClip = MovieClip(this.charMc.parent);
         var _loc2_:Array = _loc1_.name.split("_");
         if(_loc2_[0].indexOf("enemyMc") >= 0)
         {
            _loc3_ = _loc1_.parent["detail_box_" + _loc2_[1]];
            (_loc3_ as MovieClip).visible = false;
            _loc4_ = new Array();
            _loc5_ = 0;
            while(_loc5_ < skillSwfArr.length)
            {
               _loc4_.push(_loc5_);
               _loc5_++;
            }
            _loc6_ = 0;
            while(_loc6_ < 4)
            {
               _loc7_ = _loc6_ + 1;
               if(_loc6_ < skillSwfArr.length)
               {
                  _loc8_ = Math.floor(NumberUtil.getRandom() * _loc4_.length);
                  _loc3_["skill_" + _loc7_]["holder"].addChild(skillSwfArr[_loc4_[_loc8_]].getAsset("icon"));
                  _loc4_.splice(_loc8_,1);
               }
               else
               {
                  (_loc3_["skill_" + _loc7_] as MovieClip).visible = false;
               }
               _loc6_++;
            }
         }
         initSkill2003Lv();
      }
      
      public function getHitArea() : Object
      {
         if(this.actionBase == null)
         {
            Out.error(this,"getHitArea :: action base is null");
         }
         if(this.actionBase["hitAreaMc"] == null)
         {
            Out.error(this,"getHitArea :: hit area is null");
         }
         return {
            "width":this.actionBase["hitAreaMc"].width,
            "height":this.actionBase["hitAreaMc"].height
         };
      }
      
      public function get hitArea() : MovieClip
      {
         if(this.actionBase == null)
         {
            Out.error(this,"hitArea :: action base is null");
         }
         if(this.actionBase["hitAreaMc"] == null)
         {
            Out.error(this,"hitArea :: hit area is null");
         }
         return this.actionBase["hitAreaMc"];
      }
      
      public function isHitObject(param1:MovieClip) : Boolean
      {
         if(this.swf != null && param1 != null)
         {
            return this.swf.hitTestObject(param1);
         }
         return false;
      }
      
      public function removeParent() : void
      {
         GF.removeParent(this.swf);
         this.clearSwf();
         this.swf.stop();
      }
      
      public function setScale(param1:Number) : void
      {
         this.swf.scaleX *= param1;
         this.swf.scaleY *= Math.abs(param1);
      }
      
      public function restoreScale() : void
      {
         this.swf.scaleX = 1;
         this.swf.scaleY = 1;
         this.swf.x = 0;
         this.swf.y = 0;
      }
      
      public function getCloseup() : MovieClip
      {
         var _loc1_:MovieClip = GF.cloneAsBitmap(this.actionBase["head"],1,25,25);
         _loc1_.scaleX *= -1;
         _loc1_.x += _loc1_.width;
         return _loc1_;
      }
      
      public function getHalfBody(param1:Number = 1, param2:Number = 115, param3:Number = 250, param4:Number = 100, param5:Number = 150) : MovieClip
      {
         return GF.cloneAsBitmap(this.actionBase,param1,param2,param3,{
            "width":param4,
            "height":param5
         });
      }
      
      public function moveToFront() : void
      {
         if(this.charMc != null)
         {
            GF.moveToFront(MovieClip(this.charMc.parent));
         }
      }
      
      public function getCharacterName() : String
      {
         return this.dbChar.character_name;
      }
      
      public function setCharacterName(param1:String) : void
      {
         this.dbChar.character_name = param1;
      }
      
      public function getName() : String
      {
         return this.dbChar.character_name;
      }
      
      public function restoreOriginalStatus() : void
      {
         if(this.getData(DBCharacterData.SESSION_PLAYTIME) == -1)
         {
            this.updateHP(0 - this.maxHP);
            this.updateHP(this.maxHP / 2);
            this.updateCP(0 - this.maxCP);
            this.updatePetCP(0 - this.petMaxCP);
         }
         else
         {
            this.updateHP(this.maxHP);
            this.updateCP(this.maxCP);
            this.updateSP(-this.maxSP);
            this.updatePetCP(this.petMaxCP);
         }
      }
      
      public function pvpPlayerDisconnect() : void
      {
         var _loc1_:MovieClip = new MovieClip();
         _loc1_ = Central.main.getLib("disconnect_Icon");
         var _loc2_:MovieClip = Central.battle.getCharacterHolder(this.getData(DBCharacterData.ID));
         _loc2_["disconnect_holder"].addChild(_loc1_);
         if(this.swf.scaleX > 0)
         {
         }
         if(this.isDead == true)
         {
         }
      }
      
      public function removePvpPlayerDisconnectIcon() : void
      {
         this.charMc.parent["disconnect_holder"].removeChildAt(0);
      }
      
      public function SetBloodlinePassiveSkill() : void
      {
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:Array = null;
         var _loc10_:int = 0;
         var _loc1_:Array = this.dbChar.bloodline;
         var _loc2_:Object = {};
         var _loc3_:Object = {};
         var _loc4_:Object = {};
         Out.debug("characterDisplay","SetBloodlinePassiveSkill ");
         if(_loc1_)
         {
            _loc5_ = 0;
            for(; _loc5_ < _loc1_.length; _loc5_++)
            {
               _loc6_ = int(_loc1_[_loc5_].skill_id);
               _loc7_ = int(_loc1_[_loc5_].level);
               _loc8_ = 0;
               while(_loc8_ < Central.main.BLOODLINE_SKILL_DATA_ARR.length)
               {
                  if(Central.main.BLOODLINE_SKILL_DATA_ARR[_loc8_].skill_id == String("skill" + _loc6_) && Central.main.BLOODLINE_SKILL_DATA_ARR[_loc8_].bloodline_type == BloodlineData.SKILL_TYPE_PASSIVE)
                  {
                     _loc9_ = Central.main.BLOODLINE_SKILL_DATA_ARR[_loc8_].effect;
                     _loc10_ = 0;
                     while(_loc10_ < _loc9_.length)
                     {
                        if(_loc9_[_loc10_].skill_level == _loc7_)
                        {
                           if(_loc9_[_loc10_].effect_type_1)
                           {
                              _loc2_ = {};
                              _loc2_.type = _loc9_[_loc10_].effect_type_1;
                              _loc2_.duration = _loc9_[_loc10_].duration_1;
                              _loc2_.target = _loc9_[_loc10_].effect_target_1;
                              _loc2_.chancetohit = _loc9_[_loc10_].effect_chancetohit_1;
                              _loc2_.chancetoeffect = _loc9_[_loc10_].effect_chancetoeffect_1;
                              _loc2_.requirement = _loc9_[_loc10_].effect_requirement_1;
                              _loc2_.amount = _loc9_[_loc10_].effect_amount_1;
                              SetBloodlineBuffOrDebuffEffect(_loc2_,String("skill" + _loc6_));
                           }
                           if(_loc9_[_loc10_].effect_type_2)
                           {
                              _loc3_ = {};
                              _loc3_.type = _loc9_[_loc10_].effect_type_2;
                              _loc3_.duration = _loc9_[_loc10_].duration_2;
                              _loc3_.target = _loc9_[_loc10_].effect_target_2;
                              _loc3_.chancetohit = _loc9_[_loc10_].effect_chancetohit_2;
                              _loc3_.chancetoeffect = _loc9_[_loc10_].effect_chancetoeffect_2;
                              _loc3_.requirement = _loc9_[_loc10_].effect_requirement_2;
                              _loc3_.amount = _loc9_[_loc10_].effect_amount_2;
                              SetBloodlineBuffOrDebuffEffect(_loc3_,String("skill" + _loc6_));
                           }
                           if(_loc9_[_loc10_].effect_type_3)
                           {
                              _loc4_ = {};
                              _loc4_.type = _loc9_[_loc10_].effect_type_3;
                              _loc4_.duration = _loc9_[_loc10_].duration_3;
                              _loc4_.target = _loc9_[_loc10_].effect_target_3;
                              _loc4_.chancetohit = _loc9_[_loc10_].effect_chancetohit_3;
                              _loc4_.chancetoeffect = _loc9_[_loc10_].effect_chancetoeffect_3;
                              _loc4_.requirement = _loc9_[_loc10_].effect_requirement_3;
                              _loc4_.amount = _loc9_[_loc10_].effect_amount_3;
                              SetBloodlineBuffOrDebuffEffect(_loc4_,String("skill" + _loc6_));
                           }
                        }
                        _loc10_++;
                     }
                     break;
                  }
                  _loc8_++;
               }
            }
         }
      }
      
      public function SetSenjutsuPassiveSkill() : void
      {
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:Array = null;
         var _loc10_:int = 0;
         var _loc1_:Array = this.dbChar.senjutsu;
         var _loc2_:Object = {};
         var _loc3_:Object = {};
         var _loc4_:Object = {};
         Out.debug("characterDisplay","SetSenjutsuPassiveSkill ");
         if(_loc1_)
         {
            _loc5_ = 0;
            for(; _loc5_ < _loc1_.length; _loc5_++)
            {
               _loc6_ = int(_loc1_[_loc5_].skill_id);
               _loc7_ = int(_loc1_[_loc5_].level);
               _loc8_ = 0;
               while(_loc8_ < Central.main.SENJUTSU_SKILL_DATA_ARR.length)
               {
                  if(Central.main.SENJUTSU_SKILL_DATA_ARR[_loc8_].skill_id == String("skill" + _loc6_) && Central.main.SENJUTSU_SKILL_DATA_ARR[_loc8_].senjutsu_type == SenjutsuData.SKILL_TYPE_PASSIVE)
                  {
                     _loc9_ = Central.main.SENJUTSU_SKILL_DATA_ARR[_loc8_].effect;
                     _loc10_ = 0;
                     while(_loc10_ < _loc9_.length)
                     {
                        if(_loc9_[_loc10_].skill_level == _loc7_)
                        {
                           if(_loc9_[_loc10_].effect_type_1)
                           {
                              _loc2_ = {};
                              _loc2_.type = _loc9_[_loc10_].effect_type_1;
                              _loc2_.duration = _loc9_[_loc10_].duration_1;
                              _loc2_.target = _loc9_[_loc10_].effect_target_1;
                              _loc2_.chancetohit = _loc9_[_loc10_].effect_chancetohit_1;
                              _loc2_.chancetoeffect = _loc9_[_loc10_].effect_chancetoeffect_1;
                              _loc2_.requirement = _loc9_[_loc10_].effect_requirement_1;
                              _loc2_.amount = _loc9_[_loc10_].effect_amount_1;
                              SetSenjutsuBuffOrDebuffEffect(_loc2_,String("skill" + _loc6_));
                           }
                           if(_loc9_[_loc10_].effect_type_2)
                           {
                              _loc3_ = {};
                              _loc3_.type = _loc9_[_loc10_].effect_type_2;
                              _loc3_.duration = _loc9_[_loc10_].duration_2;
                              _loc3_.target = _loc9_[_loc10_].effect_target_2;
                              _loc3_.chancetohit = _loc9_[_loc10_].effect_chancetohit_2;
                              _loc3_.chancetoeffect = _loc9_[_loc10_].effect_chancetoeffect_2;
                              _loc3_.requirement = _loc9_[_loc10_].effect_requirement_2;
                              _loc3_.amount = _loc9_[_loc10_].effect_amount_2;
                              SetSenjutsuBuffOrDebuffEffect(_loc3_,String("skill" + _loc6_));
                           }
                           if(_loc9_[_loc10_].effect_type_3)
                           {
                              _loc4_ = {};
                              _loc4_.type = _loc9_[_loc10_].effect_type_3;
                              _loc4_.duration = _loc9_[_loc10_].duration_3;
                              _loc4_.target = _loc9_[_loc10_].effect_target_3;
                              _loc4_.chancetohit = _loc9_[_loc10_].effect_chancetohit_3;
                              _loc4_.chancetoeffect = _loc9_[_loc10_].effect_chancetoeffect_3;
                              _loc4_.requirement = _loc9_[_loc10_].effect_requirement_3;
                              _loc4_.amount = _loc9_[_loc10_].effect_amount_3;
                              SetSenjutsuBuffOrDebuffEffect(_loc4_,String("skill" + _loc6_));
                           }
                        }
                        _loc10_++;
                     }
                     break;
                  }
                  _loc8_++;
               }
            }
         }
      }
      
      public function SetBloodlineBuffOrDebuffEffect(param1:Object, param2:String) : void
      {
         var _loc3_:Array = [];
         _loc3_ = BloodlineData.NOT_STACK_ARRAY;
         if(_loc3_.indexOf(param1.type) < 0)
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
         switch(int(param1.target))
         {
            case BloodlineData.TARGET_MAIN_CHARACTER_BUFF:
               if(param1.type != BloodlineData.EFFECT_MAX_HP && param1.type != BloodlineData.EFFECT_MAX_CP && param1.type != BloodlineData.EFFECT_SPEED)
               {
                  this.setBattleBuff(param1);
               }
         }
      }
      
      public function SetSenjutsuBuffOrDebuffEffect(param1:Object, param2:String) : void
      {
         var _loc3_:Array = [];
         switch(int(param1.target))
         {
            case SenjutsuData.TARGET_MAIN_CHARACTER_BUFF:
               if(param1.type != SenjutsuData.EFFECT_SS_MAX_HP)
               {
                  this.setBattleBuff(param1);
               }
         }
      }
      
      public function syncHp(param1:int) : void
      {
         var _loc2_:int = param1;
         if(_loc2_ < 0)
         {
            _loc2_ = 0;
         }
         if(_loc2_ > this.maxHP)
         {
            _loc2_ = int(this.maxHP);
         }
         this.hpHashString = Sha1Encrypt.encrypt(String(_loc2_));
         this.updateData(DBCharacterData.HP,_loc2_);
      }
      
      public function syncCp(param1:int) : void
      {
         var _loc2_:int = param1;
         if(_loc2_ < 0)
         {
            _loc2_ = 0;
         }
         if(_loc2_ > this.maxCP)
         {
            _loc2_ = int(this.maxCP);
         }
         this.cpHashString = Sha1Encrypt.encrypt(String(_loc2_));
         this.updateData(DBCharacterData.CP,_loc2_);
      }
      
      public function syncSp(param1:int) : void
      {
         var _loc2_:int = param1;
         if(_loc2_ < 0)
         {
            _loc2_ = 0;
         }
         if(_loc2_ > this.maxSP)
         {
            _loc2_ = int(this.maxSP);
         }
         this.spHashString = Sha1Encrypt.encrypt(String(_loc2_));
         this.updateData(DBCharacterData.SP,_loc2_);
      }
      
      override public function updateHP(param1:int) : uint
      {
         if(!this.hpCheck())
         {
            Main.onError();
         }
         var _loc2_:int = super.updateHP(param1);
         this.hpHashString = Sha1Encrypt.encrypt(String(_loc2_));
         if(param1 < 0)
         {
            this.removeDebuff(BattleData.EFFECT_SLEEP);
         }
         return _loc2_;
      }
      
      protected function hpCheck() : Boolean
      {
         var _loc1_:String = null;
         if(this.hpHashString)
         {
            _loc1_ = Sha1Encrypt.encrypt(String(hp));
            if(_loc1_ == this.hpHashString)
            {
               return true;
            }
            return false;
         }
         return true;
      }
      
      public function updateCP(param1:int, param2:Boolean = false, param3:* = null) : uint
      {
         var _loc4_:int = this.getData(DBCharacterData.CP);
         if(!this.cpCheck())
         {
            Main.onError();
         }
         var _loc5_:int = _loc4_;
         _loc4_ += param1;
         if(_loc4_ < 0)
         {
            _loc4_ = 0;
         }
         if(_loc4_ > this.maxCP)
         {
            _loc4_ = int(this.maxCP);
         }
         var _loc6_:Number = this.getBloodlineCPMax();
         var _loc7_:Number = this.maxCP * _loc6_ / 100;
         if(_loc4_ > this.maxCP + _loc7_)
         {
            _loc4_ = this.maxCP + _loc7_;
         }
         if(_loc4_ > this.maxCP)
         {
            _loc4_ = int(this.maxCP);
         }
         var _loc8_:int = _loc4_;
         var _loc9_:int = _loc8_ - _loc5_;
         this.cpHashString = Sha1Encrypt.encrypt(String(_loc4_));
         if(Central.battle.type != Central.battle.TYPE_NETWORK)
         {
            if(param2 && Boolean(param3))
            {
               this.triggerFeedbackOnUpdateCP(param3,param1,_loc9_);
            }
         }
         this.updateData(DBCharacterData.CP,_loc4_);
         if(_loc4_ < 0)
         {
            _loc4_ = 0;
         }
         return _loc4_;
      }
      
      protected function cpCheck() : Boolean
      {
         var _loc1_:String = null;
         if(this.cpHashString)
         {
            _loc1_ = Sha1Encrypt.encrypt(String(cp));
            if(_loc1_ == this.cpHashString)
            {
               return true;
            }
            return false;
         }
         return true;
      }
      
      public function Add_Dbchar_Bloodline(param1:Array) : void
      {
         this.dbChar.bloodline = param1;
      }
      
      public function Add_Dbchar_Senjutsu(param1:Array) : void
      {
         this.dbChar.senjutsu = param1;
      }
      
      public function Get_Dbchar_Bloodline() : Array
      {
         return this.dbChar.bloodline;
      }
      
      public function Get_Dbchar_Senjutsu() : Array
      {
         return this.dbChar.senjutsu;
      }
      
      public function getSpecialClass() : uint
      {
         return this.dbChar[DBCharacterData.CONTROL];
      }
      
      protected function actionFinish_CB() : void
      {
         var _loc1_:int = 0;
         var _loc3_:Boolean = false;
         var _loc4_:Array = null;
         var _loc5_:Array = null;
         var _loc6_:int = 0;
         var _loc7_:uint = 0;
         var _loc8_:* = undefined;
         var _loc9_:* = undefined;
         var _loc10_:Object = null;
         var _loc11_:Boolean = false;
         var _loc12_:Object = null;
         var _loc13_:int = 0;
         var _loc14_:Point = null;
         var _loc15_:Object = null;
         var _loc16_:* = undefined;
         var _loc17_:* = undefined;
         var _loc18_:* = undefined;
         var _loc19_:String = null;
         var _loc20_:Object = null;
         var _loc21_:Object = null;
         var _loc22_:Object = null;
         var _loc23_:int = 0;
         var _loc24_:Array = null;
         var _loc25_:int = 0;
         var _loc26_:Boolean = false;
         var _loc27_:Object = null;
         var _loc28_:int = 0;
         var _loc29_:Object = null;
         var _loc30_:Boolean = false;
         var _loc31_:Object = null;
         var _loc32_:int = 0;
         var _loc33_:Object = null;
         var _loc34_:Object = null;
         var _loc35_:String = null;
         var _loc36_:Object = null;
         var _loc37_:int = 0;
         Central.main.getMainChar().securityCheck();
         var _loc2_:Object = Central.battle.getAttacker().getBattleAction();
         if(Boolean(Central.battle.seal_enemy) && Boolean(Central.main.actionChecker))
         {
            Central.main.actionChecker = false;
            Central.battle.getDefender().isDead = true;
            Central.battle.getDefender().playDead();
            this.isPlayingAnimation = false;
            _loc2_.titan = false;
            _loc2_.titanc = false;
            return;
         }
         if(this.hp > 0)
         {
            if(this.startResurrection == false)
            {
               this.playStandby();
            }
         }
         else if(!this.isDead)
         {
            _loc3_ = true;
            if(_loc2_)
            {
               if(_loc2_.resurrectionObj)
               {
                  if(_loc2_.resurrectionObj[this.getCharacterId()] != null)
                  {
                     _loc3_ = false;
                  }
               }
            }
            if(_loc3_)
            {
               this.isDead = true;
               _loc2_.titan = false;
               _loc2_.titanc = false;
               if(Boolean(this.limb) && this.limb > 1)
               {
                  this.playStandby();
                  this.actionFinish_CB();
                  return;
               }
               this.playDead();
               if(this.getCharacterId() == Main.getMainChar().getCharacterId())
               {
                  Main.achievement.updateBattleStat(Main.achievementData.DEATH,1);
               }
               _loc4_ = [30714278,30714554,47864495,44490146,55951532,8333357,56291997,9300982,29675282,103195,62998342,62299565,62543662,64183147,64053942,64986164,31935389,63586083,40248560,64676239,30712310,65152595,64978655,67190509,65152634,66764216,66965816,66108746,65152630,66966519,65152642];
               _loc5_ = [20000,32985,48257,65425,70254,71581,72485,125463];
               _loc6_ = int(Central.battle.battleRoundCounter);
               _loc7_ = 8;
               if(_loc6_ > _loc7_)
               {
                  _loc6_ = int(_loc7_);
               }
               _loc8_ = Central.battle.getDefender();
               _loc9_ = Central.battle.getAttacker();
               _loc10_ = Central.main.WEAPON_DATA.find(_loc9_.getWeapon());
               _loc11_ = true;
               if(Boolean(_loc10_) && Boolean(_loc10_.effect))
               {
                  _loc1_ = 0;
                  while(_loc1_ < _loc10_.effect.length)
                  {
                     _loc12_ = _loc10_.effect[_loc1_];
                     switch(_loc12_.type)
                     {
                        case BattleData.EFFECT_INSTANT_KILL_BELOW_HP:
                           _loc13_ = int(_loc12_.amount);
                           if(_loc8_.hp <= _loc8_.maxHP * _loc12_.amount / 100)
                           {
                              if(Central.battle.battleDamageLog > -(_loc8_.maxHP + 1) * 4)
                              {
                                 _loc11_ = false;
                              }
                           }
                     }
                     _loc1_++;
                  }
               }
               if(_loc2_.effect)
               {
                  if(_loc2_.effect.type == BattleData.INSTANT_KILL && Central.battle.battleDamageLog > -(_loc8_.maxHP * 4 + 1))
                  {
                     _loc11_ = false;
                  }
                  if(_loc2_.effect.type == BattleData.INSTANT_CUT_HALF_HP && Central.battle.battleDamageLog > -(_loc8_.maxHP * 2 + 1))
                  {
                     _loc11_ = false;
                  }
               }
               return;
            }
         }
         if(this.charOrigPoint != null)
         {
            this.charMc.x = this.charOrigPoint.x;
            this.charMc.y = this.charOrigPoint.y;
            this.charOrigPoint = null;
         }
         if(_loc2_ == null)
         {
            Out.debug("CharacterDisplay","startResurrection n");
         }
         if(_loc2_.resurrectionObj != null && _loc2_.resurrectionObj[this.getCharacterId()] != null)
         {
            if(_loc2_.titan == false && this.startResurrection == false && _loc2_.titanc == false && _loc2_.titana == false && _loc2_.titanb == false)
            {
               this.startResurrection = true;
               this.fuckNoBloodline = true;
               _loc14_ = null;
               _loc15_ = {};
               _loc16_ = Central.battle.getDefender();
               _loc17_ = Central.battle.getAttacker();
               if(Central.battle.type == Central.battle.TYPE_NETWORK)
               {
                  if(_loc2_.resurrectionObj[this.getCharacterId()] != null)
                  {
                     if(this.getCharacterId() == Main.getMainChar().getCharacterId())
                     {
                        Central.main.resurrection = true;
                     }
                  }
               }
               _loc14_ = new Point(0,0);
               _loc19_ = "";
               _loc20_ = {};
               _loc21_ = {};
               _loc22_ = {};
               trace("Phillip:this.getCharacterId()" + this.getCharacterId());
               trace("Phillip:attacker.getCharacterId()" + _loc17_.getCharacterId());
               trace("Phillip:defender.getCharacterId()" + _loc16_.getCharacterId());
               trace("Phillip:battleAction.resurrectionObj[this.getCharacterId()]" + _loc2_.resurrectionObj[this.getCharacterId()]);
               if(this.getCharacterId() == _loc17_.getCharacterId())
               {
                  _loc18_ = _loc17_;
               }
               else if(this.getCharacterId() == _loc16_.getCharacterId())
               {
                  _loc18_ = _loc16_;
               }
               else
               {
                  _loc18_ = Central.battle.getCharacterById(this.getCharacterId());
               }
               if(_loc18_.getBloodline())
               {
                  _loc24_ = _loc18_.getBloodline();
                  _loc25_ = 3;
                  _loc26_ = false;
                  _loc27_ = null;
                  _loc28_ = 0;
                  _loc29_ = null;
                  _loc30_ = false;
                  _loc31_ = null;
                  _loc32_ = 0;
                  _loc33_ = null;
                  _loc34_ = null;
                  _loc1_ = 0;
                  while(_loc1_ < _loc24_.length)
                  {
                     _loc20_ = Central.main.BLOODLINE_SKILL_DATA["bloodline_skill" + _loc24_[_loc1_].skill_id];
                     _loc37_ = 0;
                     while(_loc37_ < _loc20_.effect.length)
                     {
                        if(_loc20_.effect[_loc37_].skill_level == _loc24_[_loc1_].level)
                        {
                           _loc36_ = _loc20_.effect[_loc37_];
                           break;
                        }
                        _loc37_++;
                     }
                     _loc23_ = 1;
                     while(_loc23_ < _loc25_ + 1)
                     {
                        switch(_loc36_["effect_type_" + _loc23_])
                        {
                           case BloodlineData.EFFECT_RESURRECTION:
                              _loc26_ = true;
                              _loc28_ = _loc1_;
                              _loc27_ = _loc24_[_loc1_];
                              _loc29_ = _loc20_;
                              break;
                           case BloodlineData.EFFECT_REBORN:
                              _loc30_ = true;
                              _loc31_ = _loc24_[_loc1_];
                              _loc32_ = _loc1_;
                              _loc33_ = _loc20_;
                              _loc34_ = _loc36_;
                        }
                        _loc23_++;
                     }
                     if(_loc26_ || _loc30_)
                     {
                        break;
                     }
                     _loc1_++;
                  }
                  for(_loc35_ in this.battleBuff)
                  {
                     if(this.battleBuff[_loc35_])
                     {
                        if(this.battleBuff[_loc35_].duration <= BloodlineData.PASSIVE_BUFF_IDENTIFIER)
                        {
                           this.battleBuff[_loc35_] = null;
                        }
                     }
                  }
                  this.setActiveDebuff({});
                  if(_loc26_)
                  {
                     _loc21_.id = "skill" + _loc27_.skill_id;
                     _loc21_.level = _loc27_.level;
                     _loc21_.type = Central.main.BLOODLINE_DATA["bloodline" + _loc27_.bloodline_id].type;
                     _loc21_.location = _loc28_;
                     _loc21_.posType = _loc29_.postype;
                     this.removeBuff(BloodlineData.EFFECT_RESURRECTION);
                     this.removeBuff(BloodlineData.EFFECT_COPY_JUTSU);
                     this.removeBuff(BloodlineData.EFFECT_REFLECT_GENJUTSU);
                  }
                  else if(_loc30_)
                  {
                     _loc21_.id = "skill" + _loc31_.skill_id;
                     _loc21_.level = _loc31_.level;
                     _loc21_.type = Central.main.BLOODLINE_DATA["bloodline" + _loc31_.bloodline_id].type;
                     _loc21_.posType = _loc33_.postype;
                     _loc21_.location = _loc32_;
                     this.removeBuff(BloodlineData.EFFECT_REBORN);
                     _loc22_.type = String(_loc34_["effect_type_2"]);
                     _loc22_.duration = int(_loc34_["duration_2"]);
                     _loc22_.target = int(_loc34_["effect_target_2"]);
                     _loc22_.amount = int(_loc34_["effect_amount_2"]);
                     _loc22_.chancetohit = int(_loc34_["effect_chancetohit_2"]);
                     _loc22_.chancetoeffect = int(_loc34_["effect_chancetoeffect_2"]);
                     this.setBattleBuff(_loc22_);
                     _loc22_.type = String(_loc34_["effect_type_3"]);
                     _loc22_.duration = int(_loc34_["duration_3"]);
                     _loc22_.target = int(_loc34_["effect_target_3"]);
                     _loc22_.amount = int(_loc34_["effect_amount_3"]);
                     _loc22_.chancetohit = int(_loc34_["effect_chancetohit_3"]);
                     _loc22_.chancetoeffect = int(_loc34_["effect_chancetoeffect_3"]);
                     this.setBattleBuff(_loc22_);
                  }
                  _loc15_ = {
                     "action":"bloodline",
                     "skillId":_loc21_.location,
                     "posType":_loc21_.posType,
                     "cp":0,
                     "dmg":0,
                     "effect":{},
                     "BLSKILLID":_loc21_.id,
                     "BLTYPE":_loc21_.type
                  };
                  _loc2_.copyJutsu = false;
                  this.playBloodline(_loc15_,_loc14_);
                  this.showOverheadNumber(Timeline.WORD,"+" + _loc2_.resurrectionObj[this.getCharacterId()].hp + " " + String(Central.main.langLib.get(483)).replace("+",""));
                  this.showOverheadNumber(Timeline.WORD,"+" + _loc2_.resurrectionObj[this.getCharacterId()].cp + " " + String(Central.main.langLib.get(350)).replace("+",""));
                  this.removeBuff(BloodlineData.EFFECT_REBORN);
                  this.removeBuff(BloodlineData.EFFECT_RESURRECTION);
                  this.removeBuff(BloodlineData.EFFECT_COPY_JUTSU);
                  this.removeBuff(BloodlineData.EFFECT_REFLECT_GENJUTSU);
                  if(Battle.type == Battle.TYPE_NETWORK)
                  {
                     this.updateHP(_loc2_.resurrectionObj[this.getCharacterId()].hp);
                     this.updateCP(_loc2_.resurrectionObj[this.getCharacterId()].cp);
                  }
                  _loc2_.resurrectionObj[this.getCharacterId()] = null;
                  _loc18_.setBattleAction(_loc2_);
               }
               return;
            }
            titanRes = false;
         }
         else if(startResurrection == true)
         {
            startResurrection = false;
         }
         if(startResurrection == false)
         {
            this.isPlayingAnimation = false;
            if(this.battleAction_CB != null)
            {
               this.battleAction_CB();
            }
         }
      }
      
      protected function attackHit_CB() : void
      {
         this.moveToHitBox();
         if(this.battleAttackHit_CB != null)
         {
            this.battleAttackHit_CB();
         }
      }
      
      public function moveToHitBox() : void
      {
         if(this.charHitPoint != null)
         {
            this.charMc.x = this.charHitPoint.x;
            this.charMc.y = this.charHitPoint.y;
            this.charHitPoint = null;
         }
      }
      
      public function setBattleActionCB(param1:Function) : void
      {
         this.battleAction_CB = param1;
      }
      
      public function setBattleAttackHitCB(param1:Function) : void
      {
         this.battleAttackHit_CB = param1;
      }
      
      public function updateBattleFrame() : void
      {
         var _loc3_:MovieClip = null;
         var _loc4_:String = null;
         var _loc5_:String = null;
         var _loc6_:String = null;
         var _loc7_:String = null;
         if(this.charMc == null)
         {
            Out.error(this,"updateBattleFrame :: charMc is null");
            return;
         }
         var _loc1_:MovieClip = MovieClip(this.charMc.parent);
         if(_loc1_ == null)
         {
            Out.error(this,"updateBattleFrame :: battleFrame is null");
            return;
         }
         _loc1_["nameTxt"].text = Central.main.langLib.titleTxt(TitleData.LV) + this.getLevel() + " " + this.getCharacterName();
         _loc1_["hpBar"].scaleX = this.hp / this.maxHP;
         if(this.anni4Enemy.indexOf(Central.battle.bossId) >= 0 && _loc1_.name == "enemyMc_1")
         {
            _loc1_["hpBar"].filters = [this.dimFilter];
         }
         else
         {
            _loc1_["hpBar"].filters = null;
         }
         var _loc2_:Array = _loc1_.name.split("_");
         if(_loc2_[0].indexOf("enemyMc") >= 0)
         {
            _loc3_ = _loc1_.parent["detail_box_" + _loc2_[1]];
            _loc3_.visible = false;
            _loc4_ = "";
            _loc5_ = "";
            _loc6_ = "";
            _loc7_ = "";
            if(this.hp >= 10000)
            {
               _loc4_ = Math.round(this.hp / 1000) + "k";
            }
            else
            {
               _loc4_ = String(this.hp);
            }
            if(this.maxHP >= 10000)
            {
               _loc5_ = Math.round(this.maxHP / 1000) + "k";
            }
            else
            {
               _loc5_ = String(this.maxHP);
            }
            if(this.cp >= 10000)
            {
               _loc6_ = Math.round(this.cp / 1000) + "k";
            }
            else
            {
               _loc6_ = String(this.cp);
            }
            if(this.hp >= 10000)
            {
               _loc7_ = Math.round(this.maxCP / 1000) + "k";
            }
            else
            {
               _loc7_ = String(this.maxCP);
            }
            (_loc3_["txt_hp"] as TextField).text = _loc4_ + "/" + _loc5_;
            (_loc3_["txt_cp"] as TextField).text = _loc6_ + "/" + _loc7_;
         }
         if(Central.main.getMainChar().pet)
         {
            if(_loc2_[0].indexOf("playerPetMc") >= 0)
            {
               if(this.petMaxEp > 0)
               {
                  _loc1_.parent["petStatus"].visible = true;
                  _loc1_.parent["petStatus"]["hpTxt"].text = this.hp + "/" + this.maxHP;
                  _loc1_.parent["petStatus"]["cpTxt"].text = this.petCP + "/" + this.petMaxCP;
                  _loc1_.parent["petStatus"]["hpBar"].scaleX = this.hp / this.maxHP;
                  _loc1_.parent["petStatus"]["cpBar"].scaleX = this.petCP / this.petMaxCP;
               }
               else
               {
                  _loc1_.parent["petStatus"].visible = false;
               }
            }
         }
         else
         {
            _loc1_.parent["petStatus"].visible = false;
         }
         if(RankData.ALL_RANK.indexOf(this.getData(DBCharacterData.RANK)) >= 0)
         {
            _loc1_["rankIcon"].gotoAndStop(this.getData(DBCharacterData.RANK));
         }
         else
         {
            _loc1_["rankIcon"].visible = false;
         }
      }
      
      public function showOverheadNumber(param1:String, param2:String) : void
      {
         trace("thischarMc" + this.charMc);
         var _loc3_:MovieClip = MovieClip(this.charMc.parent);
         _loc3_["ohNumber"].showNumber(param1,param2);
         var _loc4_:Object = this.getHitArea();
         if(this.swf.scaleX > 0)
         {
            _loc3_["ohNumber"].x = this.charMc.x - _loc4_.width * Data.BATTLE_CHAR_SCALE / 2;
         }
         else
         {
            _loc3_["ohNumber"].x = this.charMc.x + _loc4_.width * Data.BATTLE_CHAR_SCALE / 2;
         }
         _loc3_["ohNumber"].y = this.charMc.y - _loc4_.height * Data.BATTLE_CHAR_SCALE;
      }
      
      public function resetBattleData() : void
      {
         this.battleSkillCooldown = {};
         this.battleBuff = {};
         this.battleDebuff = {};
         this.atbTimer = 0;
         this.isPlayingAnimation = false;
         this.clanEffect = {};
         this.threat = {};
         this.senjustuSkillFirstUseArr = [];
         this.damageShield = 0;
      }
      
      public function setElemental(param1:int) : void
      {
         this.BG_elemental = param1;
      }
      
      public function getElemental() : Object
      {
         return this.BG_elemental;
      }
      
      public function setElemental_Mode(param1:int) : void
      {
         this.elemental_Mode = param1;
      }
      
      public function getElemental_Mode() : Object
      {
         return this.elemental_Mode;
      }
      
      public function setSufferDamageModifier(param1:uint) : void
      {
         this.SufferDamageModifier = param1;
      }
      
      public function getSufferDamageModifier() : Object
      {
         return this.SufferDamageModifier;
      }
      
      public function setDealDamageModifier(param1:uint) : void
      {
         this.DealDamageModifier = param1;
      }
      
      public function getDealDamageModifier() : Object
      {
         return this.DealDamageModifier;
      }
      
      public function setThreat(param1:Object, param2:int = 0, param3:int = 0, param4:Object = null, param5:String = "") : void
      {
         var _loc22_:Object = null;
         var _loc6_:int = 200;
         var _loc7_:int = 5;
         var _loc8_:int = 5;
         var _loc9_:int = 20;
         var _loc10_:int = 1500;
         var _loc11_:int = 0 - 1500;
         var _loc12_:int = 2000;
         var _loc13_:int = int(param1.getData(DBCharacterData.LEVEL)) * _loc6_;
         var _loc14_:int = int(param1.maxHP) * _loc7_;
         var _loc15_:int = _loc13_ + _loc14_;
         var _loc16_:int = Math.abs(param2) * _loc8_;
         var _loc17_:int = Math.abs(param3) * _loc9_;
         var _loc18_:int = 0;
         if(param4)
         {
            if(String(param4.type).length > 0)
            {
               _loc18_ = _loc10_;
            }
         }
         var _loc19_:int = 0;
         var _loc20_:int = 0;
         switch(param5)
         {
            case "CHARGE":
               _loc19_ = _loc11_;
               break;
            case "BUFF":
               _loc20_ = _loc12_;
         }
         var _loc21_:int = _loc16_ + _loc18_ + _loc17_ + _loc19_ + _loc20_;
         if(this.threat[param1.getData(DBCharacterData.ID)])
         {
            this.threat[param1.getData(DBCharacterData.ID)].base = _loc15_;
            this.threat[param1.getData(DBCharacterData.ID)].accuthreat = this.threat[param1.getData(DBCharacterData.ID)].accuthreat + _loc21_;
            this.threat[param1.getData(DBCharacterData.ID)].total = this.threat[param1.getData(DBCharacterData.ID)].base + this.threat[param1.getData(DBCharacterData.ID)].accuthreat;
         }
         else
         {
            _loc22_ = {};
            _loc22_.base = _loc15_;
            _loc22_.accuthreat = _loc21_;
            _loc22_.total = _loc15_ + _loc21_;
            this.threat[param1.getData(DBCharacterData.ID)] = _loc22_;
         }
      }
      
      public function getThreat() : Object
      {
         return this.threat;
      }
      
      public function clearTargetDeBuff(param1:Object) : void
      {
         var _loc2_:String = null;
         for(_loc2_ in this.battleDebuff)
         {
            if(_loc2_ == param1.type)
            {
               this.battleDebuff[_loc2_] = null;
            }
         }
      }
      
      public function clearDeBuff(param1:Object) : void
      {
         var _loc2_:String = null;
         for(_loc2_ in this.battleDebuff)
         {
            if(this.battleDebuff[_loc2_])
            {
               if(this.battleDebuff[_loc2_].duration <= BloodlineData.PASSIVE_DEBUFF_IDENTIFIER)
               {
                  this.battleDebuff[_loc2_] = null;
               }
            }
         }
      }
      
      public function removeBattleBuff() : void
      {
         this.battleBuff = {};
      }
      
      public function removeBuff(param1:String) : void
      {
         delete this.battleBuff[param1];
      }
      
      public function updateATB() : Boolean
      {
         ++this.atbTimer;
         if(atbTimer >= Data.BATTLE_ATB_ACTION_TIME - Math.round(this.agility / 10))
         {
            atbTimer = 0;
            return true;
         }
         return false;
      }
      
      public function get atbScale() : Number
      {
         return atbTimer / (Data.BATTLE_ATB_ACTION_TIME - Math.round(this.agility / 10));
      }
      
      public function get agility() : int
      {
         return Formula.calcAgility(this,Central.main.BLOODLINE_SKILL_DATA_ARR,Central.main.SENJUTSU_SKILL_DATA_ARR) + this.speedBonus;
      }
      
      public function get critical() : Number
      {
         return Formula.calcCritical(this,Central.main.BLOODLINE_SKILL_DATA_ARR,Central.main.SENJUTSU_SKILL_DATA_ARR);
      }
      
      public function get dodge() : Number
      {
         return Formula.calcDodge(this,Central.main.BLOODLINE_SKILL_DATA_ARR,Central.main.SENJUTSU_SKILL_DATA_ARR);
      }
      
      public function get criticalBonus() : Number
      {
         var _loc1_:Number = 0.008;
         var _loc2_:Number = Main.coreData.BASE_CRITICAL_MULTIPLIER + Number(int(this.getData(DBCharacterData.LIGHTNING)) * _loc1_);
         if(this.isBattleBuffActive(BattleData.EFFECT_CRITICAL_DAMAGE_BONUS_WEAPON))
         {
            _loc2_ += int(this.getBattleBuff()[BattleData.EFFECT_CRITICAL_DAMAGE_BONUS_WEAPON].amount) / 100;
         }
         if(this.isBattleBuffActive(BattleData.EFFECT_CRITICAL_DAMAGE_BONUS_WEAPON_FIX_NUM))
         {
            _loc2_ += this.getBattleBuff()[BattleData.EFFECT_CRITICAL_DAMAGE_BONUS_WEAPON_FIX_NUM].amount;
         }
         return _loc2_;
      }
      
      public function enableSelection() : void
      {
         var _loc1_:MovieClip = MovieClip(this.charMc.parent);
         _loc1_.buttonMode = true;
         _loc1_.addEventListener(MouseEvent.CLICK,Battle.selectTarget);
      }
      
      public function disableSelection() : void
      {
         this.hideSelection();
         var _loc1_:MovieClip = MovieClip(this.charMc.parent);
         _loc1_.buttonMode = false;
         _loc1_.removeEventListener(MouseEvent.CLICK,Battle.selectTarget);
      }
      
      public function displaySelection() : void
      {
         var _loc3_:int = 0;
         var _loc4_:Boolean = false;
         var _loc5_:Array = null;
         var _loc6_:uint = 0;
         var _loc7_:uint = 0;
         var _loc8_:int = 0;
         var _loc9_:MovieClip = null;
         var _loc10_:DisplayObject = null;
         var _loc1_:MovieClip = MovieClip(this.charMc.parent);
         if(Boolean(this.limb) && this.limb > 1)
         {
            _loc3_ = this.getCharacterId() - int(this.getCharacterId() / 10) * 10;
            _loc4_ = false;
            _loc5_ = [];
            _loc6_ = 0;
            while(_loc6_ < _loc1_.parent["enemyMc_1"]["charMc"].numChildren)
            {
               _loc7_ = 0;
               while(_loc7_ < _loc1_.parent["enemyMc_1"]["charMc"].getChildAt(_loc6_).numChildren)
               {
                  _loc8_ = 0;
                  while(_loc8_ < _loc1_.parent["enemyMc_1"]["charMc"].getChildAt(_loc6_).getChildAt(_loc7_).numChildren)
                  {
                     _loc9_ = _loc1_.parent["enemyMc_1"]["charMc"].getChildAt(_loc6_).getChildAt(_loc7_);
                     if(_loc9_)
                     {
                        _loc10_ = _loc9_.getChildByName("limb_" + _loc3_);
                        if(_loc10_)
                        {
                           _loc10_.filters = [this.enemyGlowFilter];
                           _loc4_ = true;
                           break;
                        }
                     }
                     _loc8_++;
                  }
                  if(_loc4_)
                  {
                     break;
                  }
                  _loc7_++;
               }
               if(_loc4_)
               {
                  break;
               }
               _loc6_++;
            }
         }
         else
         {
            _loc1_.filters = [this.enemyGlowFilter];
         }
         _loc1_["targetArrow"].gotoAndPlay(Timeline.SHOW);
         var _loc2_:Object = this.getHitArea();
         if(this.swf.scaleX > 0)
         {
            _loc1_["targetArrow"].x = this.charMc.x - _loc2_.width * Data.BATTLE_CHAR_SCALE / 2;
         }
         else
         {
            _loc1_["targetArrow"].x = this.charMc.x + _loc2_.width * Data.BATTLE_CHAR_SCALE / 2;
         }
         _loc1_["targetArrow"].y = this.charMc.y - _loc2_.height * Data.BATTLE_CHAR_SCALE;
      }
      
      public function hideSelection() : void
      {
         var _loc2_:int = 0;
         var _loc3_:Boolean = false;
         var _loc4_:Array = null;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc7_:int = 0;
         var _loc8_:MovieClip = null;
         var _loc9_:DisplayObject = null;
         if(this.charMc == null)
         {
            return;
         }
         if(this.charMc.parent == null)
         {
            return;
         }
         var _loc1_:MovieClip = MovieClip(this.charMc.parent);
         if(_loc1_ == null)
         {
            return;
         }
         if(_loc1_["targetArrow"] == null)
         {
            return;
         }
         if(Boolean(this.limb) && this.limb > 1)
         {
            _loc2_ = this.getCharacterId() - int(this.getCharacterId() / 10) * 10;
            _loc3_ = false;
            _loc4_ = [];
            _loc5_ = 0;
            while(_loc5_ < _loc1_.parent["enemyMc_1"]["charMc"].numChildren)
            {
               _loc6_ = 0;
               while(_loc6_ < _loc1_.parent["enemyMc_1"]["charMc"].getChildAt(_loc5_).numChildren)
               {
                  _loc7_ = 0;
                  while(_loc7_ < _loc1_.parent["enemyMc_1"]["charMc"].getChildAt(_loc5_).getChildAt(_loc6_).numChildren)
                  {
                     _loc8_ = _loc1_.parent["enemyMc_1"]["charMc"].getChildAt(_loc5_).getChildAt(_loc6_);
                     if(_loc8_)
                     {
                        _loc9_ = _loc8_.getChildByName("limb_" + _loc2_);
                        if(_loc9_)
                        {
                           _loc9_.filters = null;
                           _loc3_ = true;
                           break;
                        }
                     }
                     _loc7_++;
                  }
                  if(_loc3_)
                  {
                     break;
                  }
                  _loc6_++;
               }
               if(_loc3_)
               {
                  break;
               }
               _loc5_++;
            }
         }
         else
         {
            _loc1_.filters = null;
         }
         _loc1_["targetArrow"].gotoAndStop(Timeline.IDLE);
      }
      
      public function showCmdDisplay() : void
      {
         var _loc1_:MovieClip = MovieClip(this.charMc.parent);
         _loc1_.filters = [this.commandGlowFilter];
      }
      
      public function hideCmdDisplay() : void
      {
         var _loc1_:MovieClip = MovieClip(this.charMc.parent);
         _loc1_.filters = null;
      }
      
      public function set clanEffect(param1:Object) : void
      {
         this._clanEffect = param1;
      }
      
      public function getClanEffect() : Object
      {
         return this._clanEffect;
      }
      
      public function pauseAnimation() : void
      {
         var _loc1_:MovieClip = MovieClip(this.swf.getChildAt(0));
         _loc1_.stop();
      }
      
      public function resumeAnimation() : void
      {
         var _loc1_:MovieClip = MovieClip(this.swf.getChildAt(0));
         _loc1_.play();
      }
      
      protected function clearSwf() : void
      {
         GF.removeAllChild(this.swf);
      }
      
      public function playRun() : void
      {
         this.clearSwf();
         this.swf.addChild(this.actionBase);
         this.actionBase.gotoRun();
      }
      
      public function playStand() : void
      {
         this.clearSwf();
         this.swf.addChild(this.actionBase);
         this.actionBase.gotoStand();
      }
      
      public function playStandby() : void
      {
         this.clearSwf();
         this.swf.addChild(this.actionBase);
         this.actionBase.gotoStandby();
      }
      
      public function playWin() : void
      {
         var _loc1_:Object = null;
         var _loc2_:String = null;
         var _loc3_:Boolean = false;
         var _loc4_:String = null;
         this.clearSwf();
         this.swf.addChild(this.actionBase);
         _loc3_ = false;
         switch(this.type)
         {
            case 1:
            case 2:
            case 3:
               if(!this.getWeapon())
               {
                  break;
               }
               _loc1_ = Central.main.WEAPON_DATA.find(this.getWeapon());
               if(_loc1_ == null)
               {
                  break;
               }
               _loc2_ = _loc1_[WeaponData.ANIMATION];
               if(_loc2_ == "attack_10")
               {
                  _loc3_ = true;
                  this.actionBase.gotoWin_TypeAttack10();
               }
         }
         if(!_loc3_)
         {
            this.actionBase.gotoWin();
         }
      }
      
      public function playBloodline(param1:Object, param2:Point) : void
      {
         var _loc4_:uint = 0;
         var _loc5_:String = null;
         var _loc6_:uint = 0;
         var _loc7_:String = null;
         Out.debug(this,this.getCharacterId() + " :: " + this.getCharacterName() + " :: playBloodline");
         this.isPlayingAnimation = true;
         this.clearSwf();
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
         var _loc3_:String = String(param1.BLSKILLID).replace("skill","");
         if(param1.BLTYPE == BloodlineData.SKILL_TYPE_BLOODLINE)
         {
            _loc4_ = 0;
            while(_loc4_ < this.bloodlineSwfArr.length)
            {
               _loc5_ = String(String(this.bloodlineSwfArr[_loc4_]).replace("[object Skill_","")).replace("]","");
               if(_loc3_ == _loc5_)
               {
                  this.swf.addChild(this.bloodlineSwfArr[_loc4_]);
                  this.bloodlineSwfArr[_loc4_].playAnimation(param1,param2);
               }
               _loc4_++;
            }
         }
         else
         {
            _loc6_ = 0;
            while(_loc6_ < this.secretSwfArr.length)
            {
               _loc7_ = String(String(this.secretSwfArr[_loc6_]).replace("[object Skill_","")).replace("]","");
               if(_loc3_ == _loc7_)
               {
                  this.swf.addChild(this.secretSwfArr[_loc6_]);
                  this.secretSwfArr[_loc6_].playAnimation(param1,param2);
               }
               _loc6_++;
            }
         }
      }
      
      public function playSenjutsu(param1:Object, param2:Point) : void
      {
         var _loc5_:String = null;
         Out.debug(this,this.getCharacterId() + " :: " + this.getCharacterName() + " :: playSenjutsu");
         this.isPlayingAnimation = true;
         this.clearSwf();
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
         }
         var _loc3_:String = String(param1.SENSKILLID).replace("skill","");
         var _loc4_:uint = 0;
         while(_loc4_ < this.senjutsuSwfArr.length)
         {
            _loc5_ = String(String(this.senjutsuSwfArr[_loc4_]).replace("[object Skill_","")).replace("]","");
            if(_loc3_ == _loc5_)
            {
               this.swf.addChild(this.senjutsuSwfArr[_loc4_]);
               this.senjutsuSwfArr[_loc4_].playAnimation(param1,param2);
            }
            _loc4_++;
         }
      }
      
      public function showCharacterSenjutsuBuffAndDebuff() : void
      {
         var _loc1_:Object = null;
         for each(_loc1_ in this.battleBuff)
         {
            if(_loc1_ == null)
            {
               continue;
            }
            if(_loc1_.duration <= 0)
            {
               continue;
            }
            switch(_loc1_.type)
            {
               case SenjutsuData.EFFECT_SENNIN_MODE:
                  this.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(1862)[0].replace("[valturn]",_loc1_.duration));
            }
         }
      }
      
      public function playAttack(param1:Object, param2:Point = null) : void
      {
         this.isPlayingAnimation = true;
         this.clearSwf();
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
         this.swf.addChild(this.actionBase);
         this.actionBase.gotoPlay(param1,param2);
      }
      
      public function playCharge() : void
      {
         this.isPlayingAnimation = true;
         this.clearSwf();
         this.swf.addChild(this.actionBase);
         this.actionBase.gotoCharge();
      }
      
      public function playSkip() : void
      {
         this.isPlayingAnimation = true;
         this.clearSwf();
         this.swf.addChild(this.actionBase);
         this.actionBase.gotoSkip();
      }
      
      public function playHit() : void
      {
         this.isPlayingAnimation = true;
         this.clearSwf();
         this.swf.addChild(this.actionBase);
         this.actionBase.gotoHit();
      }
      
      public function playDead() : void
      {
         this.isPlayingAnimation = true;
         this.clearSwf();
         this.swf.addChild(this.actionBase);
         this.actionBase.gotoDead();
      }
      
      public function playRevival() : void
      {
         this.isPlayingAnimation = true;
         this.clearSwf();
         this.swf.addChild(this.actionBase);
         this.actionBase.gotoStandby();
      }
      
      public function playAction(param1:String, param2:Boolean = true) : void
      {
         this.isPlayingAnimation = param2;
         this.clearSwf();
         this.swf.addChild(this.actionBase);
         this.actionBase.gotoAction(param1);
      }
      
      public function playBattleAction(param1:Object, param2:Point) : void
      {
         this.isPlayingAnimation = true;
         this.clearSwf();
         if(param2 != null)
         {
            switch(param1.posType)
            {
               case PositionType.MELEE_1:
                  this.charOrigPoint = new Point(this.charMc.x,this.charMc.y);
                  this.charMc.x = param2.x;
                  this.charMc.y = param2.y;
                  break;
               case PositionType.MELEE_2:
                  this.charOrigPoint = new Point(this.charMc.x,this.charMc.y);
                  this.charHitPoint = param2;
                  break;
               case PositionType.MELEE_3:
                  this.charOrigPoint = new Point(this.charMc.x,this.charMc.y);
                  this.charMc.x = param2.x;
                  this.charMc.y = param2.y;
                  break;
               case PositionType.MELEE_4:
                  this.charOrigPoint = new Point(this.charMc.x,this.charMc.y);
                  this.charMc.x = param2.x;
                  this.charMc.y = param2.y;
            }
         }
         this.swf.addChild(this.actionBase);
         this.actionBase.gotoPlay(param1,param2);
      }
      
      public function getEffectResistance() : Array
      {
         return this.effectResistance;
      }
      
      public function getBloodlineCPMax() : Number
      {
         var _loc1_:String = null;
         var _loc5_:Number = NaN;
         var _loc2_:String = "";
         var _loc3_:String = "";
         var _loc4_:Array = [];
         var _loc6_:Object = {};
         var _loc7_:Array = [];
         var _loc8_:String = "";
         var _loc9_:String = "";
         var _loc10_:Array = [];
         var _loc11_:Boolean = false;
         var _loc12_:Number = 0;
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
            _loc5_ = NumberUtil.getRandom();
            if(_loc5_ > this.battleBuff[_loc1_].chancetoeffect / 100)
            {
               continue;
            }
            switch(_loc2_)
            {
               case BloodlineData.EFFECT_MAX_CP_RECOVER:
                  if(!_loc11_)
                  {
                     _loc12_ = 0;
                     _loc12_ = _loc12_ + int(this.battleBuff[_loc1_].amount);
                     _loc11_ = true;
                  }
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
            _loc5_ = NumberUtil.getRandom();
            if(_loc5_ > this.battleDebuff[_loc1_].chancetoeffect / 100)
            {
               continue;
            }
            switch(_loc2_)
            {
               case BloodlineData.EFFECT_MAX_CP_RECOVER:
                  if(!_loc11_)
                  {
                     _loc12_ = 0;
                     _loc12_ = _loc12_ + int(this.battleDebuff[_loc1_].amount);
                     _loc11_ = true;
                  }
            }
         }
         return _loc12_;
      }
      
      public function showClassSkillDetail() : void
      {
         var _loc3_:MovieClip = null;
         var _loc1_:MovieClip = MovieClip(this.charMc.parent);
         var _loc2_:Array = _loc1_.name.split("_");
         if(_loc2_[0].indexOf("enemyMc") >= 0)
         {
            _loc3_ = _loc1_.parent["detail_box_" + _loc2_[1]];
            (_loc3_ as MovieClip).visible = true;
         }
      }
      
      public function hideClassSkillDetail() : void
      {
         var _loc3_:MovieClip = null;
         var _loc1_:MovieClip = MovieClip(this.charMc.parent);
         var _loc2_:Array = _loc1_.name.split("_");
         if(_loc2_[0].indexOf("enemyMc") >= 0)
         {
            _loc3_ = _loc1_.parent["detail_box_" + _loc2_[1]];
            (_loc3_ as MovieClip).visible = false;
         }
      }
      
      public function getIsClassSkillAvailable(param1:int) : Boolean
      {
         return isClassSkillAvailable[param1];
      }
      
      public function setIsClassSkillAvailable(param1:int, param2:Boolean) : void
      {
         var _loc3_:MovieClip = MovieClip(this.charMc.parent);
         if(!param2 && Boolean(_loc3_["skill_2003_storage"]))
         {
            _loc3_["skill_2003_storage"].visible = false;
         }
         isClassSkillAvailable[param1] = param2;
      }
      
      public function getButtonEnableArr() : Array
      {
         return buttonEnableArr;
      }
      
      public function getSkillButtonEnableArr() : Array
      {
         return skillButtonEnableArr;
      }
      
      public function getBloodlineButtonEnableArr() : Array
      {
         return bloodlineButtonEnableArr;
      }
      
      public function getSecretButtonEnableArr() : Array
      {
         return secretButtonEnableArr;
      }
      
      public function getSenjutsuButtonEnableArr() : Array
      {
         var _loc1_:int = 0;
         while(_loc1_ < senjutsuButtonEnableArr.length)
         {
            if(_loc1_ < Central.main.senjutsuSlot)
            {
               senjutsuButtonEnableArr[Central.main.SENJUTSU_BUTTON_ENABLE_ORDER[_loc1_] - 1] = true;
            }
            else
            {
               senjutsuButtonEnableArr[Central.main.SENJUTSU_BUTTON_ENABLE_ORDER[_loc1_] - 1] = false;
            }
            _loc1_++;
         }
         return senjutsuButtonEnableArr;
      }
      
      protected function initSkill2003Lv() : void
      {
         var _loc1_:MovieClip = MovieClip(this.charMc.parent);
         if(_loc1_["skill_2003_storage"])
         {
            _loc1_["skill_2003_storage"].visible = false;
         }
      }
      
      private function triggerFeedbackOnUpdateCP(param1:*, param2:int, param3:int) : void
      {
         var _loc5_:String = null;
         var _loc6_:Object = null;
         var _loc7_:int = 0;
         var _loc8_:Object = null;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:Object = null;
         var _loc12_:Object = null;
         var _loc4_:Object = param1.getBattleAction();
         _loc5_ = BloodlineData.EFFECT_CPDMG + ".skill1039";
         if(this.isBattleBuffActive(_loc5_))
         {
            if(param3 < 0)
            {
               _loc6_ = this.getBattleBuff()[_loc5_];
               if(_loc6_)
               {
                  if(!_loc4_.feedback_skipcheck)
                  {
                     _loc4_.feedback_skipcheck = new Array();
                  }
                  _loc7_ = int(param3 * _loc6_.amount * 0.01);
                  _loc8_ = {
                     "type":BloodlineData.EFFECT_CPDMG,
                     "damage":-_loc7_
                  };
                  _loc4_.feedback_skipcheck.push(_loc8_);
                  if(this.isBattleBuffActive(BloodlineData.EFFECT_CPDMG_STUN + ".skill1039"))
                  {
                     _loc9_ = int(this.getBattleBuff()[BloodlineData.EFFECT_CPDMG_STUN + ".skill1039"].chancetohit);
                     _loc10_ = Math.random() * 100;
                     if(_loc10_ < _loc9_)
                     {
                        _loc11_ = {};
                        _loc11_.type = BattleData.EFFECT_STUN;
                        _loc11_.duration = 2;
                        param1.setBattleDebuff(_loc11_);
                        _loc12_ = {};
                        _loc12_.type = BloodlineData.EFFECT_CPDMG_STUN;
                        _loc4_.feedback_skipcheck.push(_loc12_);
                     }
                  }
               }
            }
         }
      }
   }
}

