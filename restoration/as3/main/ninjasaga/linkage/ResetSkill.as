package ninjasaga.linkage
{
   import com.utils.CreateFilter;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.filters.ColorMatrixFilter;
   import ninjasaga.Account;
   import ninjasaga.Central;
   import ninjasaga.data.ButtonData;
   import ninjasaga.data.Timeline;
   import ninjasaga.data.TitleData;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol2602")]
   public class ResetSkill extends MovieClip
   {
      
      public static const ALL_NINJUTSU_TYPES:Array = ["wind","fire","lightning","earth","water"];
      
      public static const SKILL_TYPE_BUTTON_NAME_ARR:Array = [ButtonData.WIND,ButtonData.FIRE,ButtonData.THUNDER,ButtonData.EARTH,ButtonData.WATER,ButtonData.TAIJUTSU,ButtonData.GENJUTSU];
      
      public static const ALL_NINJUTSU_BLOODLINE:Array = ["mirrorEye","eight","darkEye","deadBone","demonSound","lava","shadow","forest"];
      
      public static const ALL_NINJUTSU_BLOODLINE_NAME:Array = ["Eye of Mirror","Eight Extremities","Dark Eye","Deadly Performance","Demon Sound","Explosive Lava","Hidden Silhouette","Enraged Forest"];
      
      public var panel:MovieClip;
      
      private const PRICER_RESET_SKILL_FREE:uint = 1000;
      
      private const PRICER_RESET_SKILL_PREM:uint = 200;
      
      private const PRICER_RESET_TALENT:uint = 5000;
      
      private var priceResetSkill:uint;
      
      private var frame:String;
      
      private var selectedSkillType:String = null;
      
      private var dimFilter:ColorMatrixFilter = CreateFilter.getSaturationFilter(0);
      
      private const CHAR_GENDER:int = int(Central.main.getMainChar().getGender());
      
      private var clo:String;
      
      public function ResetSkill()
      {
         super();
         addFrameScript(0,this.frame1,5,this.frame6,6,this.frame7,24,this.frame25);
      }
      
      public function show(param1:String = null) : void
      {
         this.frame = param1;
         this.gotoAndPlay(Timeline.SHOW);
      }
      
      public function hide(param1:MouseEvent = null) : void
      {
         var _loc2_:MovieClip = null;
         if(this.frame != null)
         {
            _loc2_ = Central.panel.getInstance().curPanel;
         }
         this.gotoAndPlay(Timeline.EXIT);
      }
      
      public function onShow(param1:MovieClip) : void
      {
         param1 = this["panel"];
         param1["titleTxt"].text = Central.main.langLib.titleTxt(TitleData.SECRET_KINJUTSU_RITUAL);
         param1["subTitleTxt"].text = Central.main.langLib.get(1410);
         param1["npcTxt"].text = Central.main.langLib.get(1404);
         param1["dialogueMC"]["dialogueTxt"].text = Central.main.langLib.get(1376);
         param1["warnTxt"].htmlText = Central.main.langLib.get(1377);
         param1["btnClose"].addEventListener(MouseEvent.CLICK,this.hide);
         this.updateButton();
         if(Account.getAccountType() == Account.PREMIUM)
         {
            param1["panelMC"].gotoAndPlay("premiumUser");
            this.priceResetSkill = this.PRICER_RESET_SKILL_PREM;
         }
         else
         {
            this.priceResetSkill = this.PRICER_RESET_SKILL_FREE;
         }
      }
      
      public function onFreeUser() : void
      {
         var _loc1_:MovieClip = this["panel"]["panelMC"];
         _loc1_["userTxt1"].text = Central.main.langLib.titleTxt(TitleData.FREEUSER);
         _loc1_["userTxt2"].text = Central.main.langLib.titleTxt(TitleData.PREMIMUSER);
         _loc1_["priceMc1"]["txt_token"].text = this.PRICER_RESET_SKILL_FREE;
         _loc1_["priceMc2"]["txt_token"].text = this.PRICER_RESET_SKILL_PREM;
         if(!_loc1_["btnResetSkill"].hasEventListener(MouseEvent.CLICK))
         {
            Central.main.initButton(_loc1_["btnResetSkill"],this.showConfirm,ButtonData.RESET_JUTSU);
         }
         if(!_loc1_["emblemBtn2"].hasEventListener(MouseEvent.CLICK))
         {
            Central.main.initButton(_loc1_["emblemBtn2"],this.showUpgradePage,ButtonData.GET_EMBLEM);
         }
      }
      
      public function onPremiumUser() : void
      {
         var _loc1_:MovieClip = this["panel"]["panelMC"];
         _loc1_["userTxt1"].text = Central.main.langLib.titleTxt(TitleData.FREEUSER);
         _loc1_["userTxt2"].text = Central.main.langLib.titleTxt(TitleData.PREMIMUSER);
         _loc1_["priceMc1"]["txt_token"].text = this.PRICER_RESET_SKILL_FREE;
         _loc1_["priceMc2"]["txt_token"].text = this.PRICER_RESET_SKILL_PREM;
         if(!_loc1_["btnResetSkill"].hasEventListener(MouseEvent.CLICK))
         {
            Central.main.initButton(_loc1_["btnResetSkill"],this.showConfirm,ButtonData.RESET_JUTSU);
         }
      }
      
      private function showUpgradePage(param1:MouseEvent) : void
      {
         Central.main.showUpgradeAccount(Central.main.langLib.get(1453),"ResetSkill");
      }
      
      public function updateButton() : void
      {
         var _loc2_:* = undefined;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc1_:MovieClip = this["panel"];
         var _loc5_:Array = Central.main.getMainChar().bloodline;
         _loc4_ = 1;
         _loc2_ = 0;
         while(_loc2_ < ALL_NINJUTSU_TYPES.length)
         {
            if(Central.main.getMainChar().hasSkillType(ALL_NINJUTSU_TYPES[_loc2_]))
            {
               trace(_loc2_ + "           " + _loc4_);
               _loc1_["btnLearnSkill" + _loc4_].skillType = ALL_NINJUTSU_TYPES[_loc2_];
               _loc1_["btnLearnSkill" + _loc4_]["iconMC"].gotoAndStop(ALL_NINJUTSU_TYPES[_loc2_]);
               _loc4_++;
            }
            _loc2_++;
         }
         _loc2_ = _loc4_;
         while(_loc2_ <= 3)
         {
            _loc1_["btnLearnSkill" + _loc2_]["iconMC"].gotoAndStop("element" + _loc2_);
            _loc2_++;
         }
      }
      
      private function showSelected(param1:MouseEvent) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:MovieClip = this["panel"];
         _loc3_["panelMC"].visible = true;
         _loc3_["warnTxt"].visible = true;
         _loc2_ = 1;
         while(_loc2_ <= 3)
         {
            if(param1.currentTarget.name == "btnLearnSkill" + _loc2_)
            {
               _loc3_["btnLearnSkill" + _loc2_]["highlight"].gotoAndStop("show");
               this.selectedSkillType = _loc3_["btnLearnSkill" + _loc2_].skillType;
            }
            else
            {
               _loc3_["btnLearnSkill" + _loc2_]["highlight"].gotoAndStop("idle");
            }
            _loc2_++;
         }
      }
      
      private function getSkillTypeName(param1:String) : String
      {
         var _loc2_:* = 0;
         while(_loc2_ < ALL_NINJUTSU_TYPES.length)
         {
            if(ALL_NINJUTSU_TYPES[_loc2_] == param1)
            {
               return Central.main.langLib.btnTxt(SKILL_TYPE_BUTTON_NAME_ARR[_loc2_]);
            }
            _loc2_++;
         }
         return null;
      }
      
      private function showConfirm(param1:MouseEvent) : void
      {
         var _loc2_:String = new String();
         if(Account.getAccountBalance() < this.priceResetSkill)
         {
            Central.main.getGoldToken(Central.main.langLib.get(1405),Central.main.gotoPaymentGateway,"token");
            return;
         }
         _loc2_ = Central.main.langLib.get(1377) + Central.main.langLib.get(1411);
         Central.main.showDeleteConfirmation(_loc2_,this.confirmResetSkill,new Function(),"resetSkill");
      }
      
      private function confirmResetSkill() : *
      {
         var _loc1_:uint = 0;
         var _loc2_:Array = Central.main.SKILL_DATA_ARR;
         var _loc3_:Object = Central.main.getMainChar().trainingSkill;
         Central.main.showAmfLoading();
         Central.main.amfClient.service("CharacterDAO.resetSkill",[Account.getAccountSessionKey(),this.selectedSkillType],this.callReset_cb);
         this.gotoAndStop("idle");
      }
      
      private function callReset_cb(param1:Object) : void
      {
         var _loc2_:MovieClip = null;
         var _loc3_:uint = 0;
         var _loc4_:Array = null;
         var _loc5_:Object = null;
         var _loc6_:Array = null;
         var _loc7_:Array = null;
         if(Central.main.validateAmfResponse(param1))
         {
            Central.main.tracking.trackResetSkill();
            Account.balance = Account.getAccountBalance() - this.priceResetSkill;
            if(this.frame == "academy")
            {
               _loc2_ = Central.panel.getInstance().curPanel;
               _loc2_.reset_cb(this.selectedSkillType);
            }
            else if(this.frame == "profile")
            {
               _loc3_ = 0;
               _loc4_ = Central.main.SKILL_DATA_ARR;
               _loc5_ = Central.main.getMainChar().trainingSkill;
               _loc3_ = 0;
               while(_loc3_ < _loc4_.length)
               {
                  if(_loc4_[_loc3_].type != "taijutsu" && _loc4_[_loc3_].type != "genjutsu" && Boolean(Central.main.getMainChar().hasSkill(_loc4_[_loc3_].id)))
                  {
                     Central.main.getMainChar().resetSkill(_loc4_[_loc3_].id);
                  }
                  _loc3_++;
               }
               _loc6_ = Central.main.getMainChar().getSkillListArr();
               _loc7_ = new Array();
               Central.main.getMainChar().setSkillList(_loc7_);
               if(Central.main.getMainChar().trainingSkill != null)
               {
                  if(Central.main.SKILL_DATA[Central.main.getMainChar().trainingSkill.id].type != "taijutsu" && Central.main.SKILL_DATA[Central.main.getMainChar().trainingSkill.id].type != "genjutsu")
                  {
                     Central.main.getMainChar().trainingSkill = null;
                     Central.main.mapMenu.stopTrainingTimer();
                  }
               }
               Central.main.updateMenu();
               Central.main.mapMenu.gotoAndPlay(Timeline.SKILL);
            }
         }
         Central.main.hideAmfLoading();
      }
      
      private function disableButton(param1:*, param2:Function, param3:String = null) : void
      {
         var btn:* = param1;
         var fn:Function = param2;
         var txt:String = param3;
         btn.stop();
         btn["clickMask"].buttonMode = false;
         btn.gotoAndStop(1);
         if(btn.hasEventListener(MouseEvent.MOUSE_OUT))
         {
            btn.removeEventListener(MouseEvent.MOUSE_OUT,function(param1:MouseEvent):*
            {
               param1.currentTarget.gotoAndStop(1);
            });
         }
         btn.addEventListener(MouseEvent.MOUSE_OUT,function(param1:MouseEvent):*
         {
            param1.currentTarget.gotoAndStop(1);
         });
         if(btn.hasEventListener(MouseEvent.MOUSE_OVER))
         {
            btn.removeEventListener(MouseEvent.MOUSE_OVER,function(param1:MouseEvent):*
            {
               param1.currentTarget.gotoAndStop(2);
            });
         }
         btn.addEventListener(MouseEvent.MOUSE_OVER,function(param1:MouseEvent):*
         {
            param1.currentTarget.gotoAndStop(1);
         });
         if(btn.hasEventListener(MouseEvent.CLICK))
         {
            btn.removeEventListener(MouseEvent.CLICK,fn);
         }
         btn.filters = [this.dimFilter];
      }
      
      internal function frame1() : *
      {
         this.stop();
      }
      
      internal function frame6() : *
      {
         this.onShow(this);
      }
      
      internal function frame7() : *
      {
         stop();
      }
      
      internal function frame25() : *
      {
         this.gotoAndStop("idle");
      }
   }
}

