package ninjasaga.linkage
{
   import com.utils.CreateFilter;
   import com.utils.GF;
   import com.utils.MovieClipButton;
   import com.utils.Out;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.filters.ColorMatrixFilter;
   import flash.text.TextField;
   import flash.utils.ByteArray;
   import flash.utils.Timer;
   import flash.utils.getTimer;
   import gs.TweenGroup;
   import gs.TweenLite;
   import libs.greensock.easing.*;
   import ninjasaga.Central;
   import ninjasaga.data.BattleData;
   import ninjasaga.data.BloodlineData;
   import ninjasaga.data.ButtonData;
   import ninjasaga.data.GameEvents;
   import ninjasaga.data.SenjutsuData;
   import ninjasaga.data.Timeline;
   import ninjasaga.data.TitleData;
   import ninjasaga.data.TooltipData;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol2283")]
   public class BattleActionBar extends MovieClip
   {
      
      private static var senjutsuList:Array = [];
      
      private static var senjutsuSageMode:Array = [];
      
      private static var senjutsuSageMode_swf:Array = [];
      
      private static var SenjutsuSwfArr:Array = [];
      
      public var bl_1:MovieClip;
      
      public var pass_3:MovieClip;
      
      public var btnDodge:MovieClip;
      
      public var bl_2:MovieClip;
      
      public var pass_10:MovieClip;
      
      public var pass_4:MovieClip;
      
      public var bl_3:MovieClip;
      
      public var pass_11:MovieClip;
      
      public var pass_5:MovieClip;
      
      public var boardMC:MovieClip;
      
      public var pass_6:MovieClip;
      
      public var fullMaskMc:MovieClip;
      
      public var skill_0:MovieClip;
      
      public var btnAttack:MovieClip;
      
      public var pass_7:MovieClip;
      
      public var skill_1:MovieClip;
      
      public var pass_8:MovieClip;
      
      public var skill_2:MovieClip;
      
      public var pass_9:MovieClip;
      
      public var atk_turnTimerTxt:MovieClip;
      
      public var skill_3:MovieClip;
      
      public var btnClassSkill_1:MovieClip;
      
      public var se_0:MovieClip;
      
      public var skill_4:MovieClip;
      
      public var btnRun:MovieClip;
      
      public var btnCharge:MovieClip;
      
      public var se_1:MovieClip;
      
      public var eyeAni:MovieClip;
      
      public var reverseBtn:MovieClip;
      
      public var skill_5:MovieClip;
      
      public var se_2:MovieClip;
      
      public var skill_6:MovieClip;
      
      public var se_3:MovieClip;
      
      public var skill_7:MovieClip;
      
      public var bloodline_Logo:MovieClip;
      
      public var pass_0:MovieClip;
      
      public var pass_1:MovieClip;
      
      public var bl_0:MovieClip;
      
      public var starMC:MovieClip;
      
      public var pass_2:MovieClip;
      
      public var consumableTxt:TextField;
      
      private const BTN_GENERAL:Array = ["btnAttack","btnCharge","btnRun","btnDodge"];
      
      private var GodSnapCountDown:int;
      
      private var UnstoppableRageCountDown:int;
      
      private const SKILL_BUTTON_NUMBER:uint = 8;
      
      private const BLOODLINE_BUTTON_NUMBER:uint = 4;
      
      private const SECRET_BUTTON_NUMBER:uint = 4;
      
      private const PASSIVE_BUTTON_NUMBER:uint = 12;
      
      private const CLASS_SKILL_BUTTON_NUMBER:uint = 1;
      
      private const SENJUTSU_BUTTON_NUMBER:uint = 4;
      
      private const SENJUTSU_BUTTON_MAX_NUMBER:uint = 8;
      
      private const SENJUTSU_BUTTON_REVERSE:Array = ["ninjutsuToSenjutsuBtn","senjutsuToNinjutsuBtn"];
      
      private const SKILL_BAR_CURRENT_STATUS:Array = ["skill","senjutsu"];
      
      private var skillBarCurrStatus:String = "";
      
      private var timerDisplay:Number;
      
      private var turnTimer:Timer;
      
      private var tweenGroup:TweenGroup = new TweenGroup();
      
      private var saturationFilter:ColorMatrixFilter = CreateFilter.getSaturationFilter(0);
      
      public function BattleActionBar()
      {
         super();
         addFrameScript(0,this.frame1,4,this.frame5);
      }
      
      public function hide() : void
      {
         if(Central.main.senjutsuFeature)
         {
            Central.main.hideDynamicTooltip(Central.main.senninModeBtn);
         }
         this.gotoAndStop(Timeline.IDLE);
         Central.main.getMainMc()["tutorialHintMc"].visible = false;
      }
      
      public function show() : void
      {
         var _loc1_:String = null;
         var _loc2_:* = undefined;
         if(Central.main.senjutsuFeature)
         {
            _loc1_ = TooltipData.getItemTooltip(TooltipData.TOOLTIP_TYPE_SENJUTSU,"senjutsu_skill3000");
            _loc2_ = Central.battle.getAttacker();
            Central.main.showDynamicTooltip(Central.main.senninModeBtn,String("<font size=\'16\'>" + _loc1_ + "</font>"));
         }
         this.gotoAndStop(Timeline.SHOW);
      }
      
      public function initButtons() : void
      {
         var _loc2_:Object = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc22_:Array = null;
         var _loc23_:Array = null;
         var _loc24_:Array = null;
         var _loc25_:String = null;
         var _loc26_:Object = null;
         var _loc27_:Object = null;
         var _loc28_:Object = null;
         var _loc29_:int = 0;
         var _loc30_:int = 0;
         var _loc31_:String = null;
         var _loc32_:Object = null;
         var _loc33_:Object = null;
         var _loc34_:int = 0;
         var _loc35_:int = 0;
         var _loc36_:MovieClip = null;
         var _loc37_:String = null;
         var _loc1_:int = 0;
         this["btnAttack"].fn = Central.battle.onAttack;
         this["btnCharge"].fn = Central.battle.onCharge;
         this["btnRun"].fn = Central.battle.onRun;
         this["btnDodge"].fn = Central.battle.onDodge;
         this.initActionButton(this["btnAttack"]["btnAttack"],ButtonData.ATTACK);
         this.initActionButton(this["btnCharge"]["btnEffect"],ButtonData.CHARGE);
         this.initActionButton(this["btnRun"]["btnRun"],ButtonData.RUN);
         this.initActionButton(this["btnDodge"]["btnDodge"],ButtonData.DODGE);
         var _loc8_:* = Central.battle.getAttacker();
         var _loc9_:Array = _loc8_.getSkillSwfArr();
         var _loc10_:Array = _loc8_.getSkillListArr();
         var _loc11_:Array = _loc8_.getClassSkillSwfArr();
         var _loc12_:Array = _loc8_.getClassSkillListArr();
         var _loc13_:int = 0;
         _loc13_ = int(_loc8_.getLevel());
         this.skillBarCurrStatus = this.SKILL_BAR_CURRENT_STATUS[0];
         this.initSenjutsuReverseButton();
         if(Boolean(Central.main.senjutsuFeature) && _loc8_.getData("character_senjutsu").length > 0)
         {
            _loc22_ = _loc8_.getSenjutsuListArr();
            _loc23_ = _loc8_.getSenjutsuSwfArr();
            _loc24_ = _loc8_.getData("character_senjutsu");
            senjutsuSageMode_swf = [];
            senjutsuSageMode = [];
            SenjutsuSwfArr = [];
            senjutsuList = [];
            for each(_loc25_ in _loc24_)
            {
               if(_loc25_.indexOf("3000") >= 0)
               {
                  _loc5_ = 0;
                  while(_loc5_ < _loc22_.length)
                  {
                     if(_loc25_.indexOf(_loc22_[_loc5_].skill_id) >= 0)
                     {
                        senjutsuSageMode.push(_loc22_[_loc5_]);
                        break;
                     }
                     _loc5_++;
                  }
               }
               else
               {
                  _loc5_ = 0;
                  while(_loc5_ < _loc22_.length)
                  {
                     if(_loc25_.indexOf(_loc22_[_loc5_].skill_id) >= 0)
                     {
                        senjutsuList.push(_loc22_[_loc5_]);
                        break;
                     }
                     _loc5_++;
                  }
                  _loc6_ = 0;
                  while(_loc6_ < _loc23_.length)
                  {
                     if(String(_loc23_[_loc6_]).indexOf(_loc25_.replace("senjutsu_skill","")) >= 0)
                     {
                        SenjutsuSwfArr.push(_loc23_[_loc6_]);
                     }
                     _loc6_++;
                  }
               }
            }
            if(!Central.main.senninModeBtn.hasEventListener(MouseEvent.CLICK))
            {
               Central.main.senninModeBtn.addEventListener(MouseEvent.CLICK,Central.battle.onSenjutsu);
               _loc26_ = Central.main.SENJUTSU_SKILL_DATA["senjutsu_skill3000"];
               _loc27_ = {};
               _loc7_ = 0;
               while(_loc7_ < 10)
               {
                  if(Boolean(_loc26_.effect[_loc7_]) && _loc26_.effect[_loc7_].skill_level == senjutsuSageMode[0].level)
                  {
                     _loc27_ = _loc26_.effect[_loc7_];
                  }
                  _loc7_++;
               }
               _loc28_ = {};
               _loc29_ = 0;
               _loc30_ = 0;
               _loc29_ = int(_loc8_.maxSP);
               _loc30_ = int(_loc27_.skill_damage);
               _loc28_.id = _loc26_.skill_id;
               _loc28_.dbid = String(_loc26_.skill_id).replace("skill","");
               _loc28_.name = _loc26_.name;
               _loc28_.gold = 0;
               _loc28_.crystal = 0;
               _loc28_.damage = _loc30_;
               _loc28_.rarity = _loc26_.rarity;
               _loc28_.swfName = _loc26_.swf_name;
               _loc28_.description = _loc26_.description;
               _loc28_.sp = _loc29_;
               _loc28_.cooldown = _loc26_.cooldown;
               _loc28_.posType = _loc26_.postype;
               _loc28_.tooltip = _loc26_.tooltip;
               _loc28_.type = _loc26_.type;
               _loc28_.effect = _loc27_;
               _loc28_.level = _loc27_.skill_level;
               _loc28_.premium = _loc26_.premium;
               _loc28_.vendor = _loc26_.vendor;
               _loc28_.train_time = 0;
               _loc28_.senjutsu_id = _loc26_.senjutsu_id;
               Central.main.senninModeBtn.skillData = _loc28_;
            }
         }
         var _loc14_:* = 1;
         while(_loc14_ <= this.CLASS_SKILL_BUTTON_NUMBER)
         {
            if(this.hasOwnProperty("btnClassSkill_" + _loc14_))
            {
               if(_loc12_[_loc14_ - 1])
               {
                  GF.removeAllChild(this["btnClassSkill_" + _loc14_]["holder"]);
                  this["btnClassSkill_" + _loc14_].fn = Central.battle.onClassSkill;
                  this["btnClassSkill_" + _loc14_].addEventListener(MouseEvent.MOUSE_OVER,Central.battle.onClassSkillMouseOver);
                  this["btnClassSkill_" + _loc14_].addEventListener(MouseEvent.MOUSE_OUT,Central.battle.onClassSkillMouseOut);
                  this["btnClassSkill_" + _loc14_]["holder"].addChild(Central.main.getLib(Central.main.SKILL_DATA[_loc12_[_loc3_]].swfName));
                  if(_loc12_[_loc3_] == "skill2003")
                  {
                     this["btnClassSkill_" + (_loc3_ + 1)]["cdTxt"].text = 7 - _loc8_.skill_2003_lv <= 0 ? "" : 7 - _loc8_.skill_2003_lv;
                  }
                  else
                  {
                     this["btnClassSkill_" + (_loc3_ + 1)]["cdTxt"].text = "";
                  }
                  if(Central.main.SKILL_DATA[_loc12_[_loc14_ - 1]])
                  {
                     _loc31_ = TooltipData.getItemTooltip(TooltipData.TOOLTIP_TYPE_SKILL_CLASS,Central.main.SKILL_DATA[_loc12_[_loc14_ - 1]].id);
                     if(_loc12_[_loc3_] != "skill2002")
                     {
                        Central.main.showDynamicTooltip(this["btnClassSkill_" + _loc14_],String("<font size=\'16\'>" + _loc31_ + "</font>"));
                     }
                  }
               }
               else
               {
                  this["btnClassSkill_" + _loc14_].visible = false;
               }
            }
            _loc14_++;
         }
         _loc4_ = 0;
         while(_loc4_ < 8)
         {
            GF.removeAllChild(this["skill_" + _loc4_]["holder"]);
            this["skill_" + _loc4_].skillData = null;
            Central.main.hideDynamicTooltip(this["skill_" + _loc4_]);
            _loc4_++;
         }
         this.updateSkillCPAndTooltip();
         _loc4_ = 0;
         while(_loc4_ < 4)
         {
            GF.removeAllChild(this["bl_" + _loc4_]["holder"]);
            this["bl_" + _loc4_].skillData = null;
            Central.main.hideDynamicTooltip(this["bl_" + _loc4_]);
            _loc4_++;
         }
         _loc4_ = 0;
         while(_loc4_ < this.PASSIVE_BUTTON_NUMBER)
         {
            GF.removeAllChild(this["pass_" + _loc4_]["holder"]);
            this["pass_" + _loc4_].skillData = null;
            Central.main.hideDynamicTooltip(this["pass_" + _loc4_]);
            _loc4_++;
         }
         var _loc15_:Array = _loc8_.getBloodlineListArr();
         var _loc16_:Array = _loc8_.getBloodlineSwfArr();
         var _loc17_:uint = 0;
         while(_loc17_ < _loc15_.length)
         {
            if(_loc15_[_loc17_].skill_id == "1022")
            {
               this.disableButton("bl_" + _loc17_);
            }
            else if(_loc15_[_loc17_].skill_id == "1046")
            {
               this.disableButton("bl_" + _loc17_);
            }
            else
            {
               this["bl_" + _loc17_].fn = Central.battle.onBloodline;
               this["bl_" + _loc17_]["holder"].addChild(_loc16_[_loc17_].getAsset("icon"));
            }
            _loc17_++;
         }
         this.updateBloodlineCPAndTooltip();
         _loc4_ = 0;
         while(_loc4_ < 4)
         {
            GF.removeAllChild(this["se_" + _loc4_]["holder"]);
            this["se_" + _loc4_].skillData = null;
            Central.main.hideDynamicTooltip(this["se_" + _loc4_]);
            _loc4_++;
         }
         var _loc18_:Array = _loc8_.getSecretListArr();
         var _loc19_:Array = _loc8_.getSecretSwfArr();
         _loc17_ = 0;
         while(_loc17_ < _loc18_.length)
         {
            this["se_" + _loc17_].fn = Central.battle.onBloodline;
            this["se_" + _loc17_]["holder"].addChild(_loc19_[_loc17_].getAsset("icon"));
            _loc17_++;
         }
         this.updateSecretCPAndTooltip();
         var _loc20_:Array = _loc8_.getPassiveListArr();
         var _loc21_:int = 0;
         while(_loc21_ < _loc20_.length)
         {
            _loc32_ = {};
            _loc33_ = {};
            _loc34_ = 0;
            _loc35_ = 0;
            _loc37_ = "";
            if(int(_loc20_[_loc21_].skill_id) >= 3000 && int(_loc20_[_loc21_].skill_id) < 4000)
            {
               _loc32_ = Central.main.SENJUTSU_SKILL_DATA["senjutsu_skill" + _loc20_[_loc21_].skill_id];
               _loc3_ = 0;
               while(_loc3_ < 10)
               {
                  if(_loc32_.effect[_loc3_].skill_level == _loc20_[_loc21_].level)
                  {
                     _loc33_ = _loc32_.effect[_loc3_];
                  }
                  _loc3_++;
               }
               _loc36_ = Central.main.getLib(_loc32_.swf_name);
               this["pass_" + _loc21_]["holder"].addChild(_loc36_);
               _loc37_ = this.GetSenjutsuSkillTooltips(_loc32_,_loc33_,_loc35_,_loc34_);
               Central.main.showDynamicTooltip(this["pass_" + _loc21_],String("<font size=\'16\'>" + _loc37_ + "</font>"));
            }
            else
            {
               _loc32_ = Central.main.BLOODLINE_SKILL_DATA["bloodline_skill" + _loc20_[_loc21_].skill_id];
               _loc3_ = 0;
               while(_loc3_ < 10)
               {
                  if(_loc32_.effect[_loc3_].skill_level == _loc20_[_loc21_].level)
                  {
                     _loc33_ = _loc32_.effect[_loc3_];
                  }
                  _loc3_++;
               }
               _loc36_ = Central.main.getLib(_loc32_.swf_name);
               this["pass_" + _loc21_]["holder"].addChild(_loc36_);
               _loc37_ = this.GetBloodlineSkillTooltips(_loc32_,_loc33_,_loc35_,_loc34_);
               Central.main.showDynamicTooltip(this["pass_" + _loc21_],String("<font size=\'16\'>" + _loc37_ + "</font>"));
            }
            _loc21_++;
         }
         if(_loc15_[0])
         {
            if(int(_loc15_[0].bloodline_id) < 12)
            {
               this["bloodline_Logo"].gotoAndStop("bl_" + int(_loc15_[0].bloodline_id));
            }
         }
         if(_loc20_.length > 0 || _loc18_.length > 0 || _loc15_.length > 0)
         {
            this["starMC"].visible = true;
            this["boardMC"].visible = true;
            this["bloodline_Logo"].visible = true;
            _loc4_ = 0;
            while(_loc4_ < 4)
            {
               this["bl_" + _loc4_].visible = true;
               this["se_" + _loc4_].visible = true;
               _loc4_++;
            }
            _loc4_ = 0;
            while(_loc4_ < this.PASSIVE_BUTTON_NUMBER)
            {
               this["pass_" + _loc4_].visible = true;
               _loc4_++;
            }
         }
         else
         {
            this["starMC"].visible = false;
            this["boardMC"].visible = false;
            this["bloodline_Logo"].visible = false;
            _loc4_ = 0;
            while(_loc4_ < 4)
            {
               this["bl_" + _loc4_].visible = false;
               this["se_" + _loc4_].visible = false;
               _loc4_++;
            }
            _loc4_ = 0;
            while(_loc4_ < this.PASSIVE_BUTTON_NUMBER)
            {
               this["pass_" + _loc4_].visible = false;
               _loc4_++;
            }
         }
      }
      
      private function initSenjutsuReverseButton() : void
      {
         if(this.skillBarCurrStatus == "")
         {
            this.skillBarCurrStatus = this.SKILL_BAR_CURRENT_STATUS[0];
         }
         this.initActionButton(this["reverseBtn"][this.SENJUTSU_BUTTON_REVERSE[0]]);
         this.initActionButton(this["reverseBtn"][this.SENJUTSU_BUTTON_REVERSE[1]]);
         if(Central.main.senjutsuFeature)
         {
            this["reverseBtn"][this.SENJUTSU_BUTTON_REVERSE[0]].addEventListener(MouseEvent.CLICK,this.onReverse);
            this["reverseBtn"][this.SENJUTSU_BUTTON_REVERSE[1]].addEventListener(MouseEvent.CLICK,this.onReverse);
            this["reverseBtn"][this.SENJUTSU_BUTTON_REVERSE[0]].visible = true;
            this["reverseBtn"][this.SENJUTSU_BUTTON_REVERSE[0]].mouseEnabled = true;
            this["reverseBtn"][this.SENJUTSU_BUTTON_REVERSE[1]].visible = false;
            this["reverseBtn"][this.SENJUTSU_BUTTON_REVERSE[1]].mouseEnabled = false;
            this["reverseBtn"].visible = true;
            this["reverseBtn"].mouseEnabled = true;
         }
         else
         {
            this["reverseBtn"].visible = false;
            this["reverseBtn"].mouseEnabled = false;
         }
      }
      
      private function onReverse(param1:MouseEvent) : void
      {
         if(this.skillBarCurrStatus == this.SKILL_BAR_CURRENT_STATUS[0])
         {
            this.skillBarCurrStatus = this.SKILL_BAR_CURRENT_STATUS[1];
         }
         else if(this.skillBarCurrStatus == this.SKILL_BAR_CURRENT_STATUS[1])
         {
            this.skillBarCurrStatus = this.SKILL_BAR_CURRENT_STATUS[0];
         }
         else if(this.skillBarCurrStatus == "")
         {
            this.skillBarCurrStatus = this.SKILL_BAR_CURRENT_STATUS[0];
         }
         this.updateReverseButtonGraphic();
         this.disableAllReversibleButtons();
         this["fullMaskMc"].visible = true;
         this["fullMaskMc"].mouseEnabled = true;
         if(this.skillBarCurrStatus == this.SKILL_BAR_CURRENT_STATUS[1])
         {
            this["eyeAni"].play();
         }
         this.onPlayReverseAni();
      }
      
      private function onPlayReverseAni() : void
      {
         var _loc1_:Number = 0;
         var _loc2_:Number = 0.05;
         var _loc3_:TweenGroup = new TweenGroup();
         var _loc4_:uint = 0;
         while(_loc4_ < 8)
         {
            GF.removeAllChild(this["skill_" + _loc4_]["holder"]);
            this["skill_" + _loc4_].skillData = null;
            Central.main.hideDynamicTooltip(this["skill_" + _loc4_]);
            this["skill_" + _loc4_].rotationY = -180;
            this["skill_" + _loc4_].reverseSkill = true;
            _loc3_.push(TweenLite.to(this["skill_" + _loc4_],1,{
               "delay":_loc1_,
               "rotationY":0,
               "onUpdate":this.reverseAniStageOneCompleted,
               "onUpdateParams":[this["skill_" + _loc4_]]
            }));
            _loc1_ += _loc2_;
            _loc4_++;
         }
         _loc3_.onComplete = this.reverseAniStageTwoCompleted;
      }
      
      private function updateReverseButtonGraphic() : void
      {
         if(this.skillBarCurrStatus == this.SKILL_BAR_CURRENT_STATUS[0] || this.skillBarCurrStatus == "")
         {
            this["reverseBtn"]["senjutsuToNinjutsuBtn"].visible = false;
            this["reverseBtn"]["senjutsuToNinjutsuBtn"].mouseEnabled = false;
            this["reverseBtn"]["senjutsuToNinjutsuBtn"].mouseChildren = false;
            this["reverseBtn"]["ninjutsuToSenjutsuBtn"].visible = true;
            this["reverseBtn"]["ninjutsuToSenjutsuBtn"].mouseEnabled = true;
            this["reverseBtn"]["ninjutsuToSenjutsuBtn"].mouseChildren = true;
         }
         else if(this.skillBarCurrStatus == this.SKILL_BAR_CURRENT_STATUS[1])
         {
            this["reverseBtn"]["senjutsuToNinjutsuBtn"].visible = true;
            this["reverseBtn"]["senjutsuToNinjutsuBtn"].mouseEnabled = true;
            this["reverseBtn"]["senjutsuToNinjutsuBtn"].mouseChildren = true;
            this["reverseBtn"]["ninjutsuToSenjutsuBtn"].visible = false;
            this["reverseBtn"]["ninjutsuToSenjutsuBtn"].mouseEnabled = false;
            this["reverseBtn"]["ninjutsuToSenjutsuBtn"].mouseChildren = false;
         }
      }
      
      private function reverseAniStageOneCompleted(param1:MovieClip) : void
      {
         if(param1.reverseSkill == null)
         {
            return;
         }
         if(param1.rotationY >= 0)
         {
            return;
         }
         param1.reverseSkill = false;
         this.reverseAniStageOneUpdate(param1);
      }
      
      private function reverseAniStageOneUpdate(param1:MovieClip) : void
      {
         var _loc2_:Object = null;
         var _loc3_:* = undefined;
         var _loc4_:Array = null;
         var _loc5_:Array = null;
         var _loc6_:Array = null;
         var _loc7_:ByteArray = null;
         var _loc8_:Object = null;
         var _loc9_:Object = null;
         var _loc10_:Object = null;
         var _loc11_:Object = null;
         var _loc12_:String = null;
         var _loc13_:Array = null;
         var _loc14_:int = 0;
         var _loc15_:Object = null;
         var _loc16_:Object = null;
         var _loc17_:Object = null;
         var _loc18_:int = 0;
         var _loc19_:int = 0;
         var _loc20_:String = null;
         var _loc21_:int = 0;
         var _loc22_:int = 0;
         _loc2_ = Central.battle.getAttacker().getBattleAction();
         if(this.skillBarCurrStatus == this.SKILL_BAR_CURRENT_STATUS[0])
         {
            _loc3_ = Central.battle.getAttacker();
            _loc4_ = _loc3_.getSkillSwfArr();
            _loc5_ = _loc3_.getSkillListArr();
            _loc6_ = param1.name.split("_");
            param1.visible = true;
            if(_loc5_.length <= int(_loc6_[1]))
            {
               return;
            }
            param1.fn = Central.battle.onSkill;
            param1["holder"].addChild(_loc4_[int(_loc6_[1])].getAsset("icon"));
            _loc7_ = new ByteArray();
            _loc7_.writeObject(Central.main.SKILL_DATA[_loc5_[int(_loc6_[1])]]);
            _loc7_.position = 0;
            _loc8_ = _loc7_.readObject();
            param1.skillData = _loc8_;
            _loc22_ = int(_loc8_.cp);
            if(_loc8_.effect != null)
            {
               if(_loc8_.effect.type == BattleData.EFFECT_CLEAR_BUFF_N_INTERNAL_INJURY_THANOS && _loc3_.getWeapon() == "wpn1596")
               {
                  _loc22_ = 400;
               }
            }
            if(_loc8_.effect != null)
            {
               if(_loc8_.effect.type == BattleData.EFFECT_DAMAGE_BONUS_FIX_NUM_THANOS && _loc3_.getWeapon() == "wpn1596")
               {
                  _loc22_ = 200;
               }
            }
            if(_loc3_.isBattleBuffActive(BattleData.EFFECT_EXCITATION_CP))
            {
               _loc22_ = 0;
            }
            if(_loc3_.isBattleBuffActive(BattleData.EFFECT_CP_LOCK))
            {
               _loc22_ = 0;
            }
            if(_loc3_.isBattleBuffActive(BattleData.EFFECT_REDUCE_SELF_CP_CONSUME))
            {
               _loc22_ = Math.round(_loc22_ * (1 - int(_loc3_.getBattleBuff()[BattleData.EFFECT_REDUCE_SELF_CP_CONSUME].amount) / 100));
            }
            if(_loc3_.isBattleBuffActive(BattleData.EFFECT_REDUCE_CP_REQUIRE))
            {
               _loc22_ = Math.round(_loc22_ * (int(_loc3_.getBattleBuff()[BattleData.EFFECT_REDUCE_CP_REQUIRE].amount) / 100));
            }
            if(_loc3_.isBattleBuffActive(BattleData.EFFECT_PET_SAVE_CP))
            {
               _loc22_ = Math.round(_loc22_ * (1 - _loc3_.getBattleBuff()[BattleData.EFFECT_PET_SAVE_CP].amount / 100));
            }
            if(_loc3_.getBackItem())
            {
               _loc9_ = Central.main.BACK_ITEM_DATA.find(_loc3_.getBackItem()).effect;
               for each(_loc11_ in _loc9_)
               {
                  switch(_loc11_.type)
                  {
                     case BattleData.EFFECT_REDUCE_CP_REQUIRE:
                        if(_loc11_.chance == 100)
                        {
                           _loc22_ = Math.round(_loc22_ * (1 - _loc9_.amount * 0.01));
                        }
                  }
               }
            }
            if(_loc3_.getWeapon())
            {
               _loc10_ = Central.main.WEAPON_DATA.find(_loc3_.getWeapon()).effect;
               for each(_loc11_ in _loc10_)
               {
                  switch(_loc11_.type)
                  {
                     case BattleData.EFFECT_REDUCE_CP_REQUIRE:
                        if(_loc11_.amount > 0)
                        {
                           _loc22_ = Math.round(_loc22_ * (_loc11_.amount / 100));
                        }
                  }
               }
            }
            if(_loc3_.isBattleDebuffActive(BattleData.SKILL_341))
            {
               _loc22_ = Math.round(_loc22_ * (int(_loc3_.getBattleDebuff()[BattleData.SKILL_341].amount) / 100));
            }
            if(_loc3_.isBattleDebuffActive(BattleData.EFFECT_CUBE_ILLUSION))
            {
               _loc22_ = Math.round(_loc22_ * 1.4);
            }
            if(_loc3_.isBattleDebuffActive(BloodlineData.EFFECT_EXTRA_CP_USE))
            {
               _loc22_ = Math.round(_loc22_ * 2);
            }
            if(_loc3_.isBattleDebuffActive(BattleData.EFFECT_TRANSFORM))
            {
               _loc22_ = Math.round(_loc22_ * 3);
            }
            if(_loc3_.isBattleDebuffActive(BattleData.EFFECT_CP_BLEEDING))
            {
               _loc22_ = Math.round(_loc22_ * (int(_loc3_.getBattleDebuff()[BattleData.EFFECT_CP_BLEEDING].amount) * 0.01));
            }
            param1.skillData.cp = _loc22_;
            _loc12_ = TooltipData.getItemTooltip(TooltipData.TOOLTIP_TYPE_SKILL,param1.skillData.id);
            Central.main.showDynamicTooltip(param1,String("<font size=\'16\'>" + _loc12_ + "</font>"));
            if(_loc2_ != null)
            {
               if(_loc2_.debuffOverride == true)
               {
                  this.disableButton(param1.name);
                  return;
               }
            }
            this.enableButton(param1.name);
         }
         else
         {
            _loc3_ = Central.battle.getAttacker();
            _loc13_ = senjutsuList;
            _loc6_ = param1.name.split("_");
            _loc14_ = 0;
            param1.visible = true;
            if(!(_loc3_.getSenjutsuButtonEnableArr()[int(_loc6_[1])] == true && Boolean(_loc13_[Central.main.SENJUTSU_BUTTON_ENABLE_ORDER.indexOf(int(_loc6_[1]) + 1)])))
            {
               if(!_loc3_.getSenjutsuButtonEnableArr()[int(_loc6_[1])])
               {
                  param1.visible = false;
               }
               return;
            }
            _loc14_ = int(Central.main.SENJUTSU_BUTTON_ENABLE_ORDER.indexOf(int(_loc6_[1]) + 1));
            param1.fn = Central.battle.onSenjutsu;
            param1["holder"].addChild(SenjutsuSwfArr[_loc14_].getAsset("icon"));
            _loc15_ = Central.main.SENJUTSU_SKILL_DATA["senjutsu_skill" + _loc13_[_loc14_].skill_id];
            _loc16_ = {};
            _loc21_ = 0;
            while(_loc21_ < 10)
            {
               if(Boolean(_loc15_.effect[_loc21_]) && _loc15_.effect[_loc21_].skill_level == _loc13_[_loc14_].level)
               {
                  _loc16_ = _loc15_.effect[_loc21_];
                  break;
               }
               _loc21_++;
            }
            _loc17_ = {};
            _loc18_ = 0;
            _loc19_ = 0;
            if(_loc3_.isBattleBuffActive(SenjutsuData.EFFECT_SENNIN_MODE))
            {
               _loc18_ = 0;
            }
            else
            {
               _loc18_ = int(_loc16_.skill_sp);
            }
            _loc19_ = int(_loc16_.skill_damage);
            _loc17_.id = _loc15_.skill_id;
            _loc17_.dbid = String(_loc15_.skill_id).replace("skill","");
            _loc17_.name = _loc15_.name;
            _loc17_.gold = 0;
            _loc17_.crystal = 0;
            _loc17_.damage = _loc19_;
            _loc17_.rarity = _loc15_.rarity;
            _loc17_.swfName = _loc15_.swf_name;
            _loc17_.description = _loc15_.description;
            _loc17_.sp = _loc18_;
            _loc17_.cooldown = _loc15_.cooldown;
            _loc17_.posType = _loc15_.postype;
            _loc17_.tooltip = _loc15_.tooltip;
            _loc17_.type = _loc15_.type;
            _loc17_.effect = _loc16_;
            _loc17_.level = _loc16_.skill_level;
            _loc17_.premium = _loc15_.premium;
            _loc17_.vendor = _loc15_.vendor;
            _loc17_.train_time = 0;
            _loc17_.senjutsu_id = _loc15_.senjutsu_id;
            param1.skillData = _loc17_;
            _loc20_ = this.GetSenjutsuSkillTooltips(_loc15_,_loc16_,_loc19_,_loc18_);
            Central.main.showDynamicTooltip(param1,String("<font size=\'16\'>" + _loc20_ + "</font>"));
            if(_loc2_ != null)
            {
               if(_loc2_.debuffOverride == true)
               {
                  this.disableButton(param1.name);
                  return;
               }
            }
            this.enableSenjutsuButton(param1.name);
         }
      }
      
      private function reverseAniStageTwoCompleted() : void
      {
         this["fullMaskMc"].visible = false;
         this["fullMaskMc"].mouseEnabled = false;
      }
      
      public function initActionButton(param1:*, param2:String = null) : void
      {
         var btn:* = param1;
         var txt:String = param2;
         if(btn == null)
         {
            Out.error("Main","initButton :: btn is null");
            return;
         }
         btn.stop();
         btn["clickMask"].buttonMode = true;
         btn.addEventListener(MouseEvent.MOUSE_OUT,function(param1:MouseEvent):*
         {
            param1.currentTarget.gotoAndStop(1);
         });
         btn.addEventListener(MouseEvent.MOUSE_OVER,function(param1:MouseEvent):*
         {
            param1.currentTarget.gotoAndStop(2);
         });
         btn.gotoAndStop(1);
         if(txt != null)
         {
            btn["txt"].text = Central.main.langLib.btnTxt(txt);
         }
      }
      
      public function enableButton(param1:String) : void
      {
         var _loc2_:Boolean = false;
         var _loc3_:String = null;
         var _loc4_:Array = null;
         var _loc5_:* = undefined;
         if(this[param1] != null)
         {
            this[param1].filters = null;
            if(!this[param1].hasEventListener(MouseEvent.CLICK) && this[param1].fn != null)
            {
               this[param1].addEventListener(MouseEvent.CLICK,this[param1].fn);
            }
            if(this.BTN_GENERAL.indexOf(param1) < 0)
            {
               if(this[param1].skillData)
               {
                  _loc2_ = false;
                  _loc3_ = Central.main.getMainChar().getWeapon();
                  this.UnstoppableRageCountDown = Central.main.UnstoppableRageCountDown - (getTimer() - Central.main.thanosCountDownUpdateTimer) / 1000;
                  this.GodSnapCountDown = Central.main.GodSnapCountDown - (getTimer() - Central.main.thanosCountDownUpdateTimer) / 1000;
                  _loc4_ = ["fire","wind","earth","water","lightning"];
                  if(_loc4_.indexOf(String(this[param1].skillData.type)) >= 0)
                  {
                     _loc2_ = true;
                  }
                  this[param1]["cdTxt"].text = "";
                  _loc5_ = Central.battle.getAttacker();
                  if(this.GodSnapCountDown > 0 && this[param1].skillData.id == "skill908" && _loc3_ == "wpn1596")
                  {
                     this.disableButton(param1);
                     if(!this[param1].hasEventListener(MouseEvent.CLICK))
                     {
                        this[param1].addEventListener(MouseEvent.CLICK,this[param1].fn);
                     }
                     this[param1]["cdTxt"].text = "24HR";
                  }
                  else if(this.UnstoppableRageCountDown > 0 && this[param1].skillData.id == "skill902" && _loc3_ == "wpn1596")
                  {
                     this.disableButton(param1);
                     if(!this[param1].hasEventListener(MouseEvent.CLICK))
                     {
                        this[param1].addEventListener(MouseEvent.CLICK,this[param1].fn);
                     }
                     this[param1]["cdTxt"].text = "24HR";
                  }
                  else if(Boolean(_loc5_.isBattleSkillCooldown(this[param1].skillData.id)) || Boolean(_loc5_.isBattleBuffActive(BloodlineData.EFFECT_SKIP_DEAD_CLEAR_DEBUFF)))
                  {
                     this.disableButton(param1);
                     if(!this[param1].hasEventListener(MouseEvent.CLICK))
                     {
                        this[param1].addEventListener(MouseEvent.CLICK,this[param1].fn);
                     }
                     this[param1]["cdTxt"].text = String(_loc5_.getBattleSkillCooldown(this[param1].skillData.id));
                  }
                  else if(_loc5_.cp < this[param1].skillData.cp)
                  {
                     if(_loc5_.isBattleBuffActive(BattleData.EFFECT_EXCITATION_CP))
                     {
                        if(!Central.battle.getAttacker().isBattleSkillCooldown(this[param1].skillData.id))
                        {
                           MovieClipButton.enableButton(this[param1]);
                           this[param1].gotoAndStop(Timeline.ENABLE);
                           return;
                        }
                     }
                     this.disableButton(param1);
                     if(!this[param1].hasEventListener(MouseEvent.CLICK))
                     {
                        this[param1].addEventListener(MouseEvent.CLICK,this[param1].fn);
                     }
                  }
                  else if(Boolean(_loc5_.isBattleDebuffActive(BattleData.EFFECT_BUNDLE)) && _loc2_)
                  {
                     if(!this[param1].hasEventListener(MouseEvent.CLICK))
                     {
                        this[param1].addEventListener(MouseEvent.CLICK,this[param1].fn);
                     }
                  }
                  else if(Boolean(_loc5_.isBattleDebuffActive(BattleData.SKILL_377)) && _loc2_)
                  {
                     if(!this[param1].hasEventListener(MouseEvent.CLICK))
                     {
                        this[param1].addEventListener(MouseEvent.CLICK,this[param1].fn);
                     }
                  }
                  else if(_loc5_.isBattleDebuffActive(BloodlineData.EFFECT_MERIDIAN_BLOCK))
                  {
                     if(!this[param1].hasEventListener(MouseEvent.CLICK))
                     {
                        this[param1].addEventListener(MouseEvent.CLICK,this[param1].fn);
                     }
                  }
                  else if(_loc5_.isBattleBuffActive(BloodlineData.EFFECT_SKIP_DEAD_CLEAR_DEBUFF))
                  {
                     if(!this[param1].hasEventListener(MouseEvent.CLICK))
                     {
                        this[param1].addEventListener(MouseEvent.CLICK,this[param1].fn);
                     }
                  }
                  else
                  {
                     MovieClipButton.enableButton(this[param1]);
                     this[param1].gotoAndStop(Timeline.ENABLE);
                  }
               }
            }
         }
      }
      
      public function disableButton(param1:String) : void
      {
         this[param1].filters = [this.saturationFilter];
         if(this[param1].hasEventListener(MouseEvent.CLICK))
         {
            this[param1].removeEventListener(MouseEvent.CLICK,this[param1].fn);
         }
         if(this.BTN_GENERAL.indexOf(param1) < 0)
         {
            if(param1.indexOf("btnClassSkill_") >= 0)
            {
               MovieClipButton.disableButton(this[param1]);
            }
            else
            {
               MovieClipButton.disableButton(this[param1]);
               this[param1]["cdTxt"].text = "";
            }
         }
      }
      
      public function updateButtonAttributes() : void
      {
         trace("BattleActionBar::updateButtonAttributes, [1], updateButtonAttributes=" + this.skillBarCurrStatus);
         if(this.skillBarCurrStatus == this.SKILL_BAR_CURRENT_STATUS[0])
         {
            this.updateSkillCPAndTooltip();
            this.enableAllButtons();
         }
         this.updateBloodlineCPAndTooltip();
         this.updateSecretCPAndTooltip();
      }
      
      private function updateSecretCPAndTooltip() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:Object = null;
         var _loc4_:Object = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:Object = null;
         var _loc8_:String = null;
         var _loc9_:* = Central.battle.getAttacker();
         var _loc10_:Array = _loc9_.getSecretListArr();
         _loc1_ = 0;
         while(_loc1_ < _loc10_.length)
         {
            _loc3_ = Central.main.BLOODLINE_SKILL_DATA["bloodline_skill" + _loc10_[_loc1_].skill_id];
            _loc4_ = {};
            _loc2_ = 0;
            while(_loc2_ < 10)
            {
               if(_loc3_.effect[_loc2_].skill_level == _loc10_[_loc1_].level)
               {
                  _loc4_ = _loc3_.effect[_loc2_];
               }
               _loc2_++;
            }
            _loc7_ = {};
            _loc5_ = int(_loc9_.getLevel() * (_loc4_.skill_cp / 100));
            _loc6_ = int(_loc9_.getLevel() * (_loc4_.skill_damage / 100));
            if(_loc9_.isBattleDebuffActive(BattleData.EFFECT_EXCITATION_CP))
            {
               _loc5_ = 0;
            }
            if(_loc9_.isBattleBuffActive(BattleData.EFFECT_REDUCE_SELF_CP_CONSUME))
            {
               _loc5_ = Math.round(_loc5_ * (1 - int(_loc9_.getBattleBuff()[BattleData.EFFECT_REDUCE_SELF_CP_CONSUME].amount) / 100));
            }
            if(_loc9_.isBattleBuffActive(BattleData.EFFECT_PET_SAVE_CP))
            {
               _loc5_ *= 1 - _loc9_.getBattleBuff()[BattleData.EFFECT_PET_SAVE_CP].amount / 100;
            }
            if(_loc9_.isBattleDebuffActive(BattleData.SKILL_341))
            {
               _loc5_ = Math.round(_loc5_ * (int(_loc9_.getBattleDebuff()[BattleData.SKILL_341].amount) / 100));
            }
            if(_loc9_.isBattleDebuffActive(BattleData.EFFECT_CUBE_ILLUSION))
            {
               _loc5_ *= 1.4;
            }
            if(_loc9_.isBattleDebuffActive(BloodlineData.EFFECT_EXTRA_CP_USE))
            {
               _loc5_ *= 2;
            }
            if(_loc9_.isBattleDebuffActive(BattleData.EFFECT_TRANSFORM))
            {
               _loc5_ = Math.round(_loc5_ * (int(_loc9_.getBattleDebuff()[BattleData.EFFECT_CP_BLEEDING]) / 100));
            }
            if(_loc9_.isBattleDebuffActive(BattleData.EFFECT_CP_BLEEDING))
            {
               _loc5_ = Math.round(_loc5_ * 3);
            }
            _loc7_.id = _loc3_.skill_id;
            _loc7_.dbid = String(_loc3_.skill_id).replace("skill","");
            _loc7_.name = _loc3_.name;
            _loc7_.gold = 0;
            _loc7_.crystal = 0;
            _loc7_.damage = _loc6_;
            _loc7_.rarity = _loc3_.rarity;
            _loc7_.swfName = _loc3_.swf_name;
            _loc7_.description = _loc3_.description;
            _loc7_.cp = _loc5_;
            _loc7_.cooldown = _loc3_.cooldown;
            _loc7_.posType = _loc3_.postype;
            _loc7_.tooltip = _loc3_.tooltip;
            _loc7_.type = _loc3_.type;
            _loc7_.effect = _loc4_;
            _loc7_.level = _loc4_.skill_level;
            _loc7_.premium = _loc3_.premium;
            _loc7_.vendor = _loc3_.vendor;
            _loc7_.train_time = 0;
            _loc7_.bloodline_id = _loc3_.bloodline_id;
            _loc7_.bloodline_type = Central.main.BLOODLINE_DATA["bloodline" + _loc3_.bloodline_id].type;
            this["se_" + _loc1_].skillData = _loc7_;
            _loc8_ = this.GetBloodlineSkillTooltips(_loc3_,_loc4_,_loc6_,_loc5_);
            Central.main.showDynamicTooltip(this["se_" + _loc1_],String("<font size=\'16\'>" + _loc8_ + "</font>"));
            _loc1_++;
         }
      }
      
      private function updateBloodlineCPAndTooltip() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:Object = null;
         var _loc4_:Object = null;
         var _loc5_:Object = null;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:String = null;
         var _loc9_:* = Central.battle.getAttacker();
         var _loc10_:Array = _loc9_.getBloodlineListArr();
         _loc1_ = 0;
         while(_loc1_ < _loc10_.length)
         {
            if(this["bl_" + _loc1_] == null)
            {
               return;
            }
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < _loc10_.length)
         {
            if(_loc10_[_loc1_].skill_id != "1022")
            {
               if(_loc10_[_loc1_].skill_id != "1046")
               {
                  _loc3_ = Central.main.BLOODLINE_SKILL_DATA["bloodline_skill" + _loc10_[_loc1_].skill_id];
                  _loc4_ = {};
                  _loc2_ = 0;
                  while(_loc2_ < 10)
                  {
                     if(_loc3_.effect[_loc2_].skill_level == _loc10_[_loc1_].level)
                     {
                        _loc4_ = _loc3_.effect[_loc2_];
                     }
                     _loc2_++;
                  }
                  _loc5_ = {};
                  _loc6_ = int(_loc9_.getLevel() * (_loc4_.skill_cp / 100));
                  _loc7_ = int(_loc9_.getLevel() * (_loc4_.skill_damage / 100));
                  if(_loc9_.isBattleDebuffActive(BattleData.EFFECT_EXCITATION_CP))
                  {
                     _loc6_ = 0;
                  }
                  if(_loc9_.isBattleBuffActive(BattleData.EFFECT_REDUCE_SELF_CP_CONSUME))
                  {
                     _loc6_ = Math.round(_loc6_ * (1 - int(_loc9_.getBattleBuff()[BattleData.EFFECT_REDUCE_SELF_CP_CONSUME].amount) / 100));
                  }
                  if(_loc9_.isBattleBuffActive(BattleData.EFFECT_PET_SAVE_CP))
                  {
                     _loc6_ *= 1 - _loc9_.getBattleBuff()[BattleData.EFFECT_PET_SAVE_CP].amount / 100;
                  }
                  if(_loc9_.isBattleDebuffActive(BattleData.SKILL_341))
                  {
                     _loc6_ = Math.round(_loc6_ * (int(_loc9_.getBattleDebuff()[BattleData.SKILL_341].amount) / 100));
                  }
                  if(_loc9_.isBattleDebuffActive(BattleData.EFFECT_CUBE_ILLUSION))
                  {
                     _loc6_ *= 1.4;
                  }
                  if(_loc9_.isBattleDebuffActive(BloodlineData.EFFECT_EXTRA_CP_USE))
                  {
                     _loc6_ *= 2;
                  }
                  if(_loc9_.isBattleDebuffActive(BattleData.EFFECT_TRANSFORM))
                  {
                     _loc6_ = Math.round(_loc6_ * (int(_loc9_.getBattleDebuff()[BattleData.EFFECT_CP_BLEEDING]) / 100));
                  }
                  if(_loc9_.isBattleDebuffActive(BattleData.EFFECT_CP_BLEEDING))
                  {
                     _loc6_ = Math.round(_loc6_ * 3);
                  }
                  _loc5_.id = _loc3_.skill_id;
                  _loc5_.dbid = String(_loc3_.skill_id).replace("skill","");
                  _loc5_.name = _loc3_.name;
                  _loc5_.gold = 0;
                  _loc5_.crystal = 0;
                  _loc5_.damage = _loc7_;
                  _loc5_.rarity = _loc3_.rarity;
                  _loc5_.swfName = _loc3_.swf_name;
                  _loc5_.description = _loc3_.description;
                  _loc5_.cp = _loc6_;
                  _loc5_.cooldown = _loc3_.cooldown;
                  _loc5_.posType = _loc3_.postype;
                  _loc5_.tooltip = _loc3_.tooltip;
                  _loc5_.type = _loc3_.type;
                  _loc5_.effect = _loc4_;
                  _loc5_.level = _loc4_.skill_level;
                  _loc5_.premium = _loc3_.premium;
                  _loc5_.vendor = _loc3_.vendor;
                  _loc5_.train_time = 0;
                  _loc5_.bloodline_id = _loc3_.bloodline_id;
                  _loc5_.bloodline_type = Central.main.BLOODLINE_DATA["bloodline" + _loc3_.bloodline_id].type;
                  this["bl_" + _loc1_].skillData = _loc5_;
                  _loc8_ = this.GetBloodlineSkillTooltips(_loc3_,_loc4_,_loc7_,_loc6_);
                  Central.main.showDynamicTooltip(this["bl_" + _loc1_],String("<font size=\'16\'>" + _loc8_ + "</font>"));
                  if(!_loc9_.isBattleBuffActive(BloodlineData.EFFECT_COPY_JUTSU + ".skill1023") && this["bl_" + _loc1_].skillData.bloodline_id == 1)
                  {
                     this.disableButton("bl_" + _loc1_);
                  }
                  if(!_loc9_.isBattleBuffActive(BloodlineData.EFFECT_EXTREME + ".skill1009") && _loc10_[_loc1_].skill_id == "1010")
                  {
                     this.disableButton("bl_" + _loc1_);
                  }
               }
            }
            _loc1_++;
         }
      }
      
      private function updateSkillCPAndTooltip() : void
      {
         var _loc1_:Object = null;
         var _loc2_:int = 0;
         var _loc5_:Object = null;
         var _loc6_:String = null;
         var _loc7_:ByteArray = null;
         var _loc8_:uint = 0;
         var _loc9_:Object = null;
         var _loc10_:Object = null;
         var _loc3_:* = Central.battle.getAttacker();
         var _loc4_:Array = _loc3_.getSkillListArr();
         _loc8_ = 0;
         while(_loc8_ < _loc4_.length)
         {
            if(this["skill_" + _loc8_] == null)
            {
               return;
            }
            _loc8_++;
         }
         var _loc11_:Array = _loc3_.getSkillSwfArr();
         _loc8_ = 0;
         while(_loc8_ < _loc4_.length)
         {
            this["skill_" + _loc8_].fn = Central.battle.onSkill;
            this["skill_" + _loc8_]["holder"].addChild(_loc11_[_loc8_].getAsset("icon"));
            _loc7_ = new ByteArray();
            _loc7_.writeObject(Central.main.SKILL_DATA[_loc4_[_loc8_]]);
            _loc7_.position = 0;
            _loc5_ = _loc7_.readObject();
            this["skill_" + _loc8_].skillData = _loc5_;
            _loc8_++;
         }
         _loc8_ = 0;
         while(_loc8_ < _loc4_.length)
         {
            _loc5_ = this["skill_" + _loc8_].skillData;
            _loc2_ = int(Central.main.SKILL_DATA[_loc4_[_loc8_]].cp);
            if(_loc5_.effect != null)
            {
               if(_loc5_.effect.type == BattleData.EFFECT_CLEAR_BUFF_N_INTERNAL_INJURY_THANOS && _loc3_.getWeapon() == "wpn1596")
               {
                  _loc2_ = 400;
               }
            }
            if(_loc5_.effect != null)
            {
               if(_loc5_.effect.type == BattleData.EFFECT_DAMAGE_BONUS_FIX_NUM_THANOS && _loc3_.getWeapon() == "wpn1596")
               {
                  _loc2_ = 200;
               }
            }
            if(_loc3_.isBattleBuffActive(BattleData.EFFECT_EXCITATION_CP))
            {
               _loc2_ = 0;
            }
            if(_loc3_.isBattleBuffActive(BattleData.EFFECT_CP_LOCK))
            {
               _loc2_ = 0;
            }
            if(_loc3_.isBattleBuffActive(BattleData.EFFECT_REDUCE_SELF_CP_CONSUME))
            {
               _loc2_ = Math.round(_loc2_ * (1 - int(_loc3_.getBattleBuff()[BattleData.EFFECT_REDUCE_SELF_CP_CONSUME].amount) / 100));
            }
            if(_loc3_.isBattleBuffActive(BattleData.EFFECT_REDUCE_CP_REQUIRE))
            {
               _loc2_ = Math.round(_loc2_ * (int(_loc3_.getBattleBuff()[BattleData.EFFECT_REDUCE_CP_REQUIRE].amount) / 100));
            }
            if(_loc3_.isBattleBuffActive(BattleData.EFFECT_PET_SAVE_CP))
            {
               _loc2_ = Math.round(_loc2_ * (1 - _loc3_.getBattleBuff()[BattleData.EFFECT_PET_SAVE_CP].amount / 100));
            }
            if(_loc3_.getBackItem())
            {
               _loc9_ = Central.main.BACK_ITEM_DATA.find(_loc3_.getBackItem()).effect;
               for each(_loc1_ in _loc9_)
               {
                  switch(_loc1_.type)
                  {
                     case BattleData.EFFECT_REDUCE_CP_REQUIRE:
                        if(_loc1_.chance == 100)
                        {
                           _loc2_ = Math.round(_loc2_ * (1 - _loc9_.amount * 0.01));
                        }
                  }
               }
            }
            if(_loc3_.getWeapon())
            {
               _loc10_ = Central.main.WEAPON_DATA.find(_loc3_.getWeapon()).effect;
               for each(_loc1_ in _loc10_)
               {
                  switch(_loc1_.type)
                  {
                     case BattleData.EFFECT_REDUCE_CP_REQUIRE:
                        if(_loc1_.amount > 0)
                        {
                           _loc2_ = Math.round(_loc2_ * (_loc1_.amount / 100));
                        }
                  }
               }
            }
            if(_loc3_.isBattleDebuffActive(BattleData.SKILL_341))
            {
               _loc2_ = Math.round(_loc2_ * (int(_loc3_.getBattleDebuff()[BattleData.SKILL_341].amount) / 100));
            }
            if(_loc3_.isBattleDebuffActive(BattleData.EFFECT_CUBE_ILLUSION))
            {
               _loc2_ = Math.round(_loc2_ * 1.4);
            }
            if(_loc3_.isBattleDebuffActive(BloodlineData.EFFECT_EXTRA_CP_USE))
            {
               _loc2_ = Math.round(_loc2_ * 2);
            }
            if(_loc3_.isBattleDebuffActive(BattleData.EFFECT_TRANSFORM))
            {
               _loc2_ = Math.round(_loc2_ * 3);
            }
            if(_loc3_.isBattleDebuffActive(BattleData.EFFECT_CP_BLEEDING))
            {
               _loc2_ = Math.round(_loc2_ * (int(_loc3_.getBattleDebuff()[BattleData.EFFECT_CP_BLEEDING].amount) * 0.01));
            }
            _loc5_.cp = _loc2_;
            _loc8_++;
         }
         _loc8_ = 0;
         while(_loc8_ < _loc4_.length)
         {
            _loc6_ = TooltipData.getItemTooltip(TooltipData.TOOLTIP_TYPE_SKILL,this["skill_" + _loc8_].skillData.id);
            Central.main.showDynamicTooltip(this["skill_" + _loc8_],String("<font size=\'16\'>" + _loc6_ + "</font>"));
            _loc8_++;
         }
      }
      
      public function enableAllButtons() : void
      {
         var _loc10_:Object = null;
         var _loc11_:Object = null;
         var _loc12_:Object = null;
         if(!this.hasOwnProperty(this.BTN_GENERAL[0]))
         {
            return;
         }
         var _loc1_:* = Central.battle.getAttacker();
         var _loc2_:Array = _loc1_.getSkillListArr();
         var _loc3_:Array = _loc1_.getClassSkillListArr();
         var _loc4_:Array = _loc1_.getButtonEnableArr();
         var _loc5_:uint = 0;
         _loc5_ = 0;
         while(_loc5_ < this.BTN_GENERAL.length)
         {
            if(_loc4_[_loc5_])
            {
               this.enableButton(this.BTN_GENERAL[_loc5_]);
            }
            _loc5_++;
         }
         _loc5_ = 0;
         while(_loc5_ < _loc3_.length)
         {
            if(_loc1_.isBattleBuffActive(BloodlineData.EFFECT_SKIP_DEAD_CLEAR_DEBUFF))
            {
               this["btnClassSkill_" + (_loc5_ + 1)].buttonMode = false;
               this.disableButton("btnClassSkill_" + (_loc5_ + 1));
            }
            else if(Boolean(_loc1_.getIsClassSkillAvailable(_loc5_)) && Boolean(this["btnClassSkill_" + (_loc5_ + 1)]))
            {
               this["btnClassSkill_" + (_loc5_ + 1)].buttonMode = true;
               this.enableButton("btnClassSkill_" + (_loc5_ + 1));
            }
            _loc5_++;
         }
         _loc5_ = 0;
         while(_loc5_ < _loc2_.length)
         {
            if(_loc1_.getSkillButtonEnableArr()[_loc5_])
            {
               if(Boolean(_loc1_.isBattleBuffActive(BloodlineData.EFFECT_SKIP_DEAD_CLEAR_DEBUFF)) || Boolean(_loc1_.isBattleDebuffActive(BattleData.EFFECT_CHAOS_THANOS)))
               {
                  this.disableButton("skill_" + _loc5_);
               }
               else
               {
                  this.enableButton("skill_" + _loc5_);
               }
            }
            _loc5_++;
         }
         var _loc6_:Array = _loc1_.getBloodlineListArr();
         _loc5_ = 0;
         while(_loc5_ < _loc6_.length)
         {
            if(_loc1_.getBloodlineButtonEnableArr()[_loc5_])
            {
               if(_loc6_[_loc5_].skill_id == "1022")
               {
                  this.disableButton("bl_" + _loc5_);
               }
               else if(_loc6_[_loc5_].skill_id == "1046")
               {
                  this.disableButton("bl_" + _loc5_);
               }
               else
               {
                  this.enableButton("bl_" + _loc5_);
                  _loc10_ = this["bl_" + _loc5_].skillData;
                  if(Central.battle.getAttacker().isBattleSkillCooldown(_loc10_.id))
                  {
                     this["bl_" + _loc5_].filters = [this.saturationFilter];
                  }
                  else if(_loc10_.cp > Central.battle.getAttacker().cp && !_loc1_.isBattleBuffActive(BattleData.EFFECT_EXCITATION_CP))
                  {
                     this["bl_" + _loc5_].filters = [this.saturationFilter];
                  }
                  else
                  {
                     this["bl_" + _loc5_].filters = null;
                  }
                  if(!_loc1_.isBattleBuffActive(BloodlineData.EFFECT_COPY_JUTSU + ".skill1023") && this["bl_" + _loc5_].skillData.bloodline_id == 1)
                  {
                     if(Central.battle.type == Central.battle.TYPE_NETWORK)
                     {
                        if(Central.main.resurrection == true)
                        {
                           this.disableButton("bl_" + _loc5_);
                        }
                     }
                     else
                     {
                        this.disableButton("bl_" + _loc5_);
                     }
                  }
                  if(Central.battle.type == Central.battle.TYPE_NETWORK)
                  {
                     if(_loc6_[_loc5_].skill_id == "1010")
                     {
                        _loc11_ = _loc1_.getBattleBuff();
                        if(_loc11_[BloodlineData.EFFECT_EXTREME] != null)
                        {
                           this.enableButton("bl_" + _loc5_);
                        }
                        else
                        {
                           this.disableButton("bl_" + _loc5_);
                        }
                     }
                  }
                  else if(!_loc1_.isBattleBuffActive(BloodlineData.EFFECT_EXTREME + ".skill1009") && _loc6_[_loc5_].skill_id == "1010")
                  {
                     this.disableButton("bl_" + _loc5_);
                  }
                  Out.debug("","BattleActionBar > enable button");
                  Out.debug("","** attacter debuff= " + GF.printObject(_loc1_.getBattleDebuff()));
                  if(Boolean(_loc1_.isBattleDebuffActive(SenjutsuData.EFFECT_SS_BUNDLE_TALENT)) || Boolean(_loc1_.isBattleDebuffActive(SenjutsuData.EFFECT_SS_WEAPON_ONLY)))
                  {
                     this.disableButton("bl_" + _loc5_);
                  }
                  if(_loc1_.isBattleDebuffActive(SenjutsuData.EFFECT_SS_WEAPON_ONLY))
                  {
                     _loc5_ = 0;
                     while(_loc5_ < _loc2_.length)
                     {
                        this.disableButton("skill_" + _loc5_);
                        _loc5_++;
                     }
                  }
                  if(Boolean(_loc1_.isBattleBuffActive(BloodlineData.EFFECT_SKIP_DEAD_CLEAR_DEBUFF)) || Boolean(_loc1_.isBattleDebuffActive(BattleData.EFFECT_CHAOS_THANOS)))
                  {
                     this.disableButton("bl_" + _loc5_);
                  }
               }
            }
            _loc5_++;
         }
         var _loc7_:Array = _loc1_.getSecretListArr();
         _loc5_ = 0;
         while(_loc5_ < _loc7_.length)
         {
            if(_loc1_.getSecretButtonEnableArr()[_loc5_])
            {
               this.enableButton("se_" + _loc5_);
               _loc12_ = this["se_" + _loc5_].skillData;
               if(Central.battle.getAttacker().isBattleSkillCooldown(_loc12_.id))
               {
                  this["se_" + _loc5_].filters = [this.saturationFilter];
               }
               else if(_loc12_.cp <= Central.battle.getAttacker().cp || Boolean(_loc1_.isBattleBuffActive(BattleData.EFFECT_EXCITATION_CP)))
               {
                  this["se_" + _loc5_].filters = null;
               }
               else
               {
                  this["se_" + _loc5_].filters = [this.saturationFilter];
               }
               Out.debug("","BattleActionBar > enable button");
               Out.debug("","** attacter debuff= " + GF.printObject(_loc1_.getBattleDebuff()));
               if(Boolean(_loc1_.isBattleDebuffActive(SenjutsuData.EFFECT_SS_BUNDLE_TALENT)) || Boolean(_loc1_.isBattleBuffActive(BloodlineData.EFFECT_SKIP_DEAD_CLEAR_DEBUFF)))
               {
                  this.disableButton("se_" + _loc5_);
               }
            }
            _loc5_++;
         }
         var _loc8_:Array = _loc1_.getPassiveListArr();
         var _loc9_:int = 0;
         while(_loc9_ < _loc8_.length)
         {
            this["pass_" + _loc9_].gotoAndStop(Timeline.ENABLE);
            this["pass_" + _loc9_]["cdTxt"].text = "";
            this["pass_" + _loc9_].filters = null;
            this["pass_" + _loc9_].visible = true;
            _loc9_++;
         }
      }
      
      public function disableAllButtons() : void
      {
         var _loc1_:uint = 0;
         _loc1_ = 0;
         while(_loc1_ < this.BTN_GENERAL.length)
         {
            this.disableButton(this.BTN_GENERAL[_loc1_]);
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < this.SKILL_BUTTON_NUMBER)
         {
            this.disableButton("skill_" + _loc1_);
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < this.BLOODLINE_BUTTON_NUMBER)
         {
            this.disableButton("bl_" + _loc1_);
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < this.SECRET_BUTTON_NUMBER)
         {
            this.disableButton("se_" + _loc1_);
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < this.PASSIVE_BUTTON_NUMBER)
         {
            this.disableButton("pass_" + _loc1_);
            this["pass_" + _loc1_].visible = false;
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < this.CLASS_SKILL_BUTTON_NUMBER)
         {
            this["btnClassSkill_" + (_loc1_ + 1)].buttonMode = false;
            this.disableButton("btnClassSkill_" + (_loc1_ + 1));
            _loc1_++;
         }
      }
      
      public function disableAllReversibleButtons() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < 8)
         {
            this.disableButton("skill_" + _loc1_);
            _loc1_++;
         }
      }
      
      public function enableSenjutsuButton(param1:String) : void
      {
         var _loc2_:* = undefined;
         this[param1].filters = null;
         if(!this[param1].hasEventListener(MouseEvent.CLICK))
         {
            this[param1].addEventListener(MouseEvent.CLICK,this[param1].fn);
         }
         if(this[param1].skillData)
         {
            this[param1]["cdTxt"].text = "";
            _loc2_ = Central.battle.getAttacker();
            Out.debug("","enableSenjutsuButton skill3105 disable button when reverse to senjutsu skill, Button Name= " + this[param1]);
            Out.debug("","enableSenjutsuButton attacker debuff=" + GF.printObject(_loc2_.getBattleDebuff()));
            if(Boolean(_loc2_.isBattleDebuffActive(SenjutsuData.EFFECT_SS_BUNDLE_TALENT)) || Boolean(_loc2_.isBattleDebuffActive(SenjutsuData.EFFECT_SS_WEAPON_ONLY)) || Boolean(_loc2_.isBattleBuffActive(BloodlineData.EFFECT_SKIP_DEAD_CLEAR_DEBUFF)))
            {
               this.disableButton(param1);
               if(this[param1].hasEventListener(MouseEvent.CLICK))
               {
                  this[param1].removeEventListener(MouseEvent.CLICK,this[param1].fn);
               }
            }
            else if(_loc2_.isBattleSkillCooldown(this[param1].skillData.id))
            {
               this.disableButton(param1);
               if(!this[param1].hasEventListener(MouseEvent.CLICK))
               {
                  this[param1].addEventListener(MouseEvent.CLICK,this[param1].fn);
               }
               this[param1]["cdTxt"].text = String(_loc2_.getBattleSkillCooldown(this[param1].skillData.id));
            }
            else if(_loc2_.sp < this[param1].skillData.sp)
            {
               this.disableButton(param1);
               if(!this[param1].hasEventListener(MouseEvent.CLICK))
               {
                  this[param1].addEventListener(MouseEvent.CLICK,this[param1].fn);
               }
            }
            else
            {
               MovieClipButton.enableButton(this[param1]);
               this[param1].gotoAndStop(Timeline.ENABLE);
            }
         }
      }
      
      public function enableAllReversibleButtons() : void
      {
         var _loc3_:Array = null;
         var _loc4_:Array = null;
         var _loc1_:* = Central.battle.getAttacker();
         var _loc2_:int = 0;
         if(this.skillBarCurrStatus == this.SKILL_BAR_CURRENT_STATUS[0])
         {
            _loc3_ = _loc1_.getSkillListArr();
            _loc4_ = _loc1_.getButtonEnableArr();
            _loc2_ = 0;
            while(_loc2_ < _loc3_.length)
            {
               if(_loc1_.getSkillButtonEnableArr()[_loc2_])
               {
                  this.enableButton("skill_" + _loc2_);
               }
               _loc2_++;
            }
         }
         else
         {
            _loc3_ = senjutsuList;
            _loc2_ = 0;
            while(_loc2_ < 8)
            {
               if(_loc1_.getSenjutsuButtonEnableArr()[_loc2_] == true && Boolean(_loc3_[Central.main.SENJUTSU_BUTTON_ENABLE_ORDER.indexOf(_loc2_ + 1)]))
               {
                  this.enableButton("skill_" + _loc2_);
               }
               _loc2_++;
            }
         }
      }
      
      private function onTurnTimer(param1:TimerEvent) : void
      {
         if(Central.battle.type == null)
         {
            this.turnTimer.stop();
            return;
         }
         if(this.currentLabel != Timeline.SHOW)
         {
            if(this.turnTimer)
            {
               this.turnTimer.stop();
               this.turnTimer.reset();
            }
            return;
         }
         --this.timerDisplay;
         if(this.currentLabel == Timeline.SHOW && this.timerDisplay >= 0)
         {
            this["atk_turnTimerTxt"]["txt"].text = String(this.timerDisplay);
            this["atk_turnTimerTxt"].visible = true;
         }
         if(this.timerDisplay <= 0)
         {
            this.disableAllButtons();
            if(this.timerDisplay <= -1)
            {
               this.turnTimer.stop();
               this.turnTimer.reset();
               if(this.currentLabel == Timeline.SHOW)
               {
                  Central.battle.onPass();
               }
            }
         }
      }
      
      private function onIdle() : void
      {
      }
      
      private function onShow() : void
      {
         var _loc2_:Object = null;
         var _loc3_:* = undefined;
         var _loc4_:Array = null;
         var _loc5_:int = 0;
         this.stop();
         this.initButtons();
         this.disableAllButtons();
         this["fullMaskMc"].visible = false;
         this["fullMaskMc"].mouseEnabled = false;
         this["atk_turnTimerTxt"].visible = false;
         var _loc1_:MovieClip = Central.main.getMainMc();
         if(Central.mission.curMissionID != "msn0")
         {
            _loc1_["tutorialHintMc"].visible = false;
         }
         if(!Central.main.dispatchGameEvent(GameEvents.BATTLE_SHOW_ACTION_BAR))
         {
            _loc1_["tutorialHintMc"]["tutorialTipsMc"].gotoAndStop(Timeline.IDLE);
            if(Central.battle.type == Central.battle.TYPE_NETWORK || Central.main.HitAi == true)
            {
               this["consumableTxt"].text = Central.battle.consumablesUsed.toString() + "/" + BattleData.CONSUMABLE_LIMIT;
               this.timerDisplay = BattleData.PVP_TURN_TIME;
               this["atk_turnTimerTxt"]["txt"].text = String(this.timerDisplay);
               this["atk_turnTimerTxt"].visible = true;
               if(this.turnTimer)
               {
                  this.turnTimer.stop();
                  this.turnTimer.reset();
                  this.turnTimer = null;
               }
               this.turnTimer = new Timer(1000,BattleData.PVP_TURN_TIME + 1);
               this.turnTimer.addEventListener(TimerEvent.TIMER,this.onTurnTimer);
               this.turnTimer.start();
            }
            _loc2_ = Central.battle.getAttacker().getBattleAction();
            Out.debug(this,"onShow :: " + Central.battle.getAttacker().getCharacterName() + " :: battleAction >> " + GF.objectToString(_loc2_));
            if(_loc2_ != null)
            {
               if(_loc2_.debuffOverride == true)
               {
                  this.enableButton("btnDodge");
                  _loc3_ = Central.main.getMainChar();
                  _loc4_ = _loc3_.getClassSkillListArr();
                  _loc5_ = 0;
                  while(_loc5_ < _loc4_.length)
                  {
                     if(Boolean(_loc3_.isClassSkillActive(_loc4_[_loc5_])) && Boolean(this["btnClassSkill_" + (_loc5_ + 1)]))
                     {
                        this["btnClassSkill_" + (_loc5_ + 1)].buttonMode = true;
                        this.enableButton("btnClassSkill_" + (_loc5_ + 1));
                     }
                     _loc5_++;
                  }
                  return;
               }
            }
            this.enableAllButtons();
         }
      }
      
      private function GetBloodlineSkillTooltips(param1:Object, param2:Object, param3:int, param4:int) : String
      {
         var _loc5_:* = 0;
         var _loc6_:String = "";
         var _loc7_:String = "";
         var _loc8_:String = "";
         var _loc9_:Array = [];
         var _loc10_:Array = [];
         var _loc11_:Array = [];
         _loc6_ = String("<b>" + param1.name + "</b>");
         if(param1.bloodline_type == BloodlineData.SKILL_TYPE_PASSIVE)
         {
            _loc6_ = _loc6_ + "<br><font color=\'#CC9900\'>(" + Central.main.langLib.titleTxt(TitleData.PASSIVE) + " " + Central.main.langLib.titleTxt(TitleData.SKILL) + ")</font>";
            _loc6_ = _loc6_ + "<br><br><font color=\'#FF0000\'>" + Central.main.langLib.titleTxt(TitleData.DAMAGE) + ": -</font>";
            _loc6_ = _loc6_ + "<br><font color=\'#0000FF\'>" + Central.main.langLib.titleTxt(TitleData.CP) + ": -</font>";
            _loc6_ = _loc6_ + "<br><font color=\'#CC9900\'>" + Central.main.langLib.titleTxt(TitleData.COOLDOWN) + ": -</font>";
         }
         else
         {
            if(param2.skill_damage == 0)
            {
               _loc6_ = _loc6_ + "<br><br><font color=\'#FF0000\'>" + Central.main.langLib.titleTxt(TitleData.DAMAGE) + ": -</font>";
            }
            else
            {
               _loc6_ = _loc6_ + "<br><br><font color=\'#FF0000\'>" + Central.main.langLib.titleTxt(TitleData.DAMAGE) + ": " + String(param3) + "</font>";
            }
            if(param2.skill_cp == 0)
            {
               _loc6_ = _loc6_ + "<br><font color=\'#0000FF\'>" + Central.main.langLib.titleTxt(TitleData.CP) + ": -</font>";
            }
            else
            {
               _loc6_ = _loc6_ + "<br><font color=\'#0000FF\'>" + Central.main.langLib.titleTxt(TitleData.CP) + ": " + String(param4) + "</font>";
            }
            _loc6_ = _loc6_ + "<br><font color=\'#CC9900\'>" + Central.main.langLib.titleTxt(TitleData.COOLDOWN) + ": " + String(param1.cooldown) + "</font>";
         }
         _loc7_ = param1.tooltip;
         if(String(param2.effect_requirement_1).length > 0)
         {
            _loc9_ = param2.effect_requirement_1.split("|");
         }
         if(String(param2.effect_requirement_2).length > 0)
         {
            _loc10_ = param2.effect_requirement_2.split("|");
         }
         if(String(param2.effect_requirement_3).length > 0)
         {
            _loc11_ = param2.effect_requirement_3.split("|");
         }
         var _loc12_:Object = [{
            "replaceTarget":"[valCHANCETOEFFECT_1]",
            "replaceStr":Math.abs(param2.effect_chancetoeffect_1)
         },{
            "replaceTarget":"[valCHANCETOEFFECT_2]",
            "replaceStr":Math.abs(param2.effect_chancetoeffect_2)
         },{
            "replaceTarget":"[valCHANCETOEFFECT_3]",
            "replaceStr":Math.abs(param2.effect_chancetoeffect_3)
         },{
            "replaceTarget":"[valCHANCETOHIT_1]",
            "replaceStr":Math.abs(param2.effect_chancetohit_1)
         },{
            "replaceTarget":"[valCHANCETOHIT_2]",
            "replaceStr":Math.abs(param2.effect_chancetohit_2)
         },{
            "replaceTarget":"[valCHANCETOHIT_3]",
            "replaceStr":Math.abs(param2.effect_chancetohit_3)
         },{
            "replaceTarget":"[valAMOUNT_1]",
            "replaceStr":Math.abs(param2.effect_amount_1)
         },{
            "replaceTarget":"[valAMOUNT_2]",
            "replaceStr":Math.abs(param2.effect_amount_2)
         },{
            "replaceTarget":"[valAMOUNT_3]",
            "replaceStr":Math.abs(param2.effect_amount_3)
         },{
            "replaceTarget":"[val100minusAMOUNT_1]",
            "replaceStr":String(100 - param2.effect_amount_1)
         },{
            "replaceTarget":"[val100minusAMOUNT_2]",
            "replaceStr":String(100 - param2.effect_amount_2)
         },{
            "replaceTarget":"[val100minusAMOUNT_3]",
            "replaceStr":String(100 - param2.effect_amount_3)
         },{
            "replaceTarget":"[val100plusAMOUNT_1]",
            "replaceStr":String(100 + param2.effect_amount_1)
         },{
            "replaceTarget":"[val100plusAMOUNT_2]",
            "replaceStr":String(100 + param2.effect_amount_2)
         },{
            "replaceTarget":"[val100minusAMOUNT_3]",
            "replaceStr":String(100 + param2.effect_amount_3)
         },{
            "replaceTarget":"[valTURN_1]",
            "replaceStr":Math.abs(int(param2.duration_1) - 1)
         },{
            "replaceTarget":"[valTURN_2]",
            "replaceStr":Math.abs(int(param2.duration_2) - 1)
         },{
            "replaceTarget":"[valTURN_3]",
            "replaceStr":Math.abs(int(param2.duration_3) - 1)
         },{
            "replaceTarget":"[valDAMAGE]",
            "replaceStr":Math.abs(param2.skill_damage)
         },{
            "replaceTarget":"[valLEVEL]",
            "replaceStr":Math.abs(param2.skill_level)
         }];
         _loc5_ = 0;
         while(_loc5_ < _loc12_.length)
         {
            if(_loc7_.indexOf(_loc12_[_loc5_].replaceTarget) >= 0)
            {
               _loc7_ = String(_loc7_).replace(_loc12_[_loc5_].replaceTarget,_loc12_[_loc5_].replaceStr);
               _loc5_--;
            }
            _loc5_++;
         }
         if(_loc9_.length > 0)
         {
            _loc7_ = String(_loc7_).replace("[valreqAMOUNT_1]",Math.abs(_loc9_[3]));
         }
         if(_loc10_.length > 0)
         {
            _loc7_ = String(_loc7_).replace("[valreqAMOUNT_2]",Math.abs(_loc10_[3]));
         }
         if(_loc11_.length > 0)
         {
            _loc7_ = String(_loc7_).replace("[valreqAMOUNT_3]",Math.abs(_loc11_[3]));
         }
         if(_loc7_ == "")
         {
            _loc8_ = String("<font size=\'13\'>" + _loc6_ + "</font>");
         }
         else
         {
            _loc8_ = String("<font size=\'13\'>" + _loc6_ + "<br>" + _loc7_ + "</font>");
         }
         return _loc8_;
      }
      
      private function GetSenjutsuSkillTooltips(param1:Object, param2:Object, param3:int, param4:int) : String
      {
         var _loc5_:String = "";
         var _loc6_:String = "";
         var _loc7_:String = "";
         var _loc8_:Array = [];
         var _loc9_:Array = [];
         var _loc10_:Array = [];
         _loc5_ = String("<b>" + param1.name + "</b>");
         if(param1.senjutsu_type == SenjutsuData.SKILL_TYPE_PASSIVE)
         {
            _loc5_ = _loc5_ + "<br><font color=\'#CC9900\'>(" + Central.main.langLib.titleTxt(TitleData.PASSIVE) + " " + Central.main.langLib.titleTxt(TitleData.SKILL) + ")</font>";
            _loc5_ = _loc5_ + "<br><br><font color=\'#FF0000\'>" + Central.main.langLib.titleTxt(TitleData.DAMAGE) + ": -</font>";
            _loc5_ = _loc5_ + "<br><font color=\'#FF5300\'>" + Central.main.langLib.titleTxt(TitleData.SP) + ": -</font>";
            _loc5_ = _loc5_ + "<br><font color=\'#CC9900\'>" + Central.main.langLib.titleTxt(TitleData.COOLDOWN) + ": -</font>";
         }
         else
         {
            if(param2.skill_damage == 0)
            {
               _loc5_ = _loc5_ + "<br><br><font color=\'#FF0000\'>" + Central.main.langLib.titleTxt(TitleData.DAMAGE) + ": -</font>";
            }
            else
            {
               _loc5_ = _loc5_ + "<br><br><font color=\'#FF0000\'>" + Central.main.langLib.titleTxt(TitleData.DAMAGE) + ": " + String(param3) + "</font>";
            }
            if(param2.skill_cp == 0)
            {
               _loc5_ = _loc5_ + "<br><font color=\'#FF5300\'>" + Central.main.langLib.titleTxt(TitleData.SP) + ": -</font>";
            }
            else
            {
               _loc5_ = _loc5_ + "<br><font color=\'#FF5300\'>" + Central.main.langLib.titleTxt(TitleData.SP) + ": " + String(param4) + "</font>";
            }
            _loc5_ = _loc5_ + "<br><font color=\'#CC9900\'>" + Central.main.langLib.titleTxt(TitleData.COOLDOWN) + ": " + String(param1.cooldown) + "</font>";
         }
         _loc6_ = param1.tooltip;
         if(String(param2.effect_requirement_1).length > 0)
         {
            _loc8_ = param2.effect_requirement_1.split("|");
         }
         if(String(param2.effect_requirement_2).length > 0)
         {
            _loc9_ = param2.effect_requirement_2.split("|");
         }
         if(String(param2.effect_requirement_3).length > 0)
         {
            _loc10_ = param2.effect_requirement_3.split("|");
         }
         _loc6_ = String(_loc6_).replace("[valCHANCETOEFFECT_1]",Math.abs(param2.effect_chancetoeffect_1));
         _loc6_ = String(_loc6_).replace("[valCHANCETOEFFECT_2]",Math.abs(param2.effect_chancetoeffect_2));
         _loc6_ = String(_loc6_).replace("[valCHANCETOEFFECT_3]",Math.abs(param2.effect_chancetoeffect_3));
         _loc6_ = String(_loc6_).replace("[valCHANCETOHIT_1]",Math.abs(param2.effect_chancetohit_1));
         _loc6_ = String(_loc6_).replace("[valCHANCETOHIT_2]",Math.abs(param2.effect_chancetohit_2));
         _loc6_ = String(_loc6_).replace("[valCHANCETOHIT_3]",Math.abs(param2.effect_chancetohit_3));
         _loc6_ = String(_loc6_).replace("[valAMOUNT_1]",Math.abs(param2.effect_amount_1));
         _loc6_ = String(_loc6_).replace("[valAMOUNT_2]",Math.abs(param2.effect_amount_2));
         _loc6_ = String(_loc6_).replace("[valAMOUNT_3]",Math.abs(param2.effect_amount_3));
         _loc6_ = String(_loc6_).replace("[val100minusAMOUNT_1]",String(100 - Number(param2.effect_amount_1)));
         _loc6_ = String(_loc6_).replace("[val100minusAMOUNT_2]",String(100 - Number(param2.effect_amount_2)));
         _loc6_ = String(_loc6_).replace("[val100minusAMOUNT_3]",String(100 - Number(param2.effect_amount_3)));
         _loc6_ = String(_loc6_).replace("[val100plusAMOUNT_1]",String(100 + Number(param2.effect_amount_1)));
         _loc6_ = String(_loc6_).replace("[val100plusAMOUNT_2]",String(100 + Number(param2.effect_amount_2)));
         _loc6_ = String(_loc6_).replace("[val100plusAMOUNT_3]",String(100 + Number(param2.effect_amount_3)));
         _loc6_ = String(_loc6_).replace("[valTURN_1]",Math.abs(int(param2.duration_1) - 1));
         _loc6_ = String(_loc6_).replace("[valTURN_2]",Math.abs(int(param2.duration_2) - 1));
         _loc6_ = String(_loc6_).replace("[valTURN_3]",Math.abs(int(param2.duration_3) - 1));
         _loc6_ = String(_loc6_).replace("[valDAMAGE]",Math.abs(param2.skill_damage));
         _loc6_ = String(_loc6_).replace("[valLEVEL]",Math.abs(param2.skill_level));
         if(_loc8_.length > 0)
         {
            _loc6_ = String(_loc6_).replace("[valreqAMOUNT_1]",Math.abs(_loc8_[3]));
         }
         if(_loc9_.length > 0)
         {
            _loc6_ = String(_loc6_).replace("[valreqAMOUNT_2]",Math.abs(_loc9_[3]));
         }
         if(_loc10_.length > 0)
         {
            _loc6_ = String(_loc6_).replace("[valreqAMOUNT_3]",Math.abs(_loc10_[3]));
         }
         if(_loc6_ == "")
         {
            _loc7_ = String("<font size=\'13\'>" + _loc5_ + "</font>");
         }
         else
         {
            _loc7_ = String("<font size=\'13\'>" + _loc5_ + "<br>" + _loc6_ + "</font>");
         }
         return _loc7_;
      }
      
      internal function frame1() : *
      {
         this.stop();
      }
      
      internal function frame5() : *
      {
         this.onShow();
      }
   }
}

