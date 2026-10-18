package ninjasaga.linkage
{
   import com.utils.GF;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.text.TextField;
   import flash.utils.Timer;
   import ninjasaga.Central;
   import ninjasaga.data.AppData;
   import ninjasaga.data.Data;
   import ninjasaga.data.SNSData;
   import ninjasaga.data.Timeline;
   import ninjasaga.data.TitleData;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol2722")]
   public class Roulette extends MovieClip
   {
      
      private static const TL_INTRODUCTION:String = "introduction";
      
      private static const TL_RUN:String = "run";
      
      private static const TL_REWARD:String = "reward";
      
      private static const TL_RESULT:String = "result";
      
      public var okBtn:SimpleButton;
      
      public var npcTxt:TextField;
      
      public var lbl_loginnotice:TextField;
      
      public var rewardMc:MovieClip;
      
      public var blurMc:MovieClip;
      
      public var lbl_draw_title:TextField;
      
      public var helpBtn:MovieClip;
      
      public var closeBtn:SimpleButton;
      
      public var spinMc:MovieClip;
      
      public var dayBar:MovieClip;
      
      public var playBtn:SimpleButton;
      
      public var rouletteMc:MovieClip;
      
      private var connectingAmf:Boolean = false;
      
      private var loginDay:int;
      
      private var rewardType:int;
      
      private var rewardAmountId:int;
      
      private var rewardAmountOriginal:int;
      
      private var rewardAmount:int;
      
      private var rewardBonus:int;
      
      private var reward:Object;
      
      private var spinTimer:Timer;
      
      public function Roulette()
      {
         super();
         addFrameScript(0,this.frame1,7,this.frame8,10,this.frame11,15,this.frame16,21,this.frame22);
         this.loginDay = int(Central.main.getMainChar().consecutiveDays);
      }
      
      public function show() : void
      {
         if(Central.main.getMainChar().isFan)
         {
            this.gotoRun();
         }
         else
         {
            this.gotoAndPlay(TL_INTRODUCTION);
         }
      }
      
      public function hide(param1:MouseEvent = null) : void
      {
         if(Central.main.checkGameStatus() == Timeline.MAP)
         {
            Central.main.getMainChar().checkLvUpReward();
            Central.main.updateMapSideBtn();
         }
         this.stopSpinTimer();
         Central.main.proc.streamStartEvents();
         this.gotoAndStop(Timeline.IDLE);
         GF.removeParent(this);
      }
      
      private function onIntroduction() : void
      {
         this.stop();
         this["playBtn"].addEventListener(MouseEvent.CLICK,this.gotoRun);
         this["npcTxt"].text = Central.main.langLib.get(220);
         this["helpBtn"].visible = false;
         this["lbl_draw_title"].text = Central.main.langLib.titleTxt(TitleData.DAILYLUCKYDRAW);
         this["lbl_loginnotice"].text = Central.main.langLib.get(223);
         this.initPlayDays();
      }
      
      private function gotoRun(param1:MouseEvent = null) : void
      {
         this.gotoAndPlay(TL_RUN);
      }
      
      private function onRun() : void
      {
         this.stop();
         this["helpBtn"].visible = false;
         this["lbl_draw_title"].text = Central.main.langLib.titleTxt(TitleData.DAILYLUCKYDRAW);
         this["lbl_loginnotice"].text = Central.main.langLib.get(223);
         this["closeBtn"].addEventListener(MouseEvent.CLICK,this.hide);
         if(Central.main.getMainChar().isFan)
         {
            this.initPlayDays();
            this["spinMc"].addEventListener(MouseEvent.CLICK,this.spin);
            this["spinMc"].buttonMode = true;
            this["spinMc"]["lbl_spintips"].text = Central.main.langLib.get(221);
         }
         else
         {
            this["blurMc"].gotoAndStop(2);
            this["spinMc"].gotoAndStop(2);
            this["spinMc"].addEventListener(MouseEvent.CLICK,this.gotoApplicationPage);
            this["spinMc"].buttonMode = true;
            this["spinMc"]["lbl_spintips"].text = Central.main.langLib.get(222);
         }
      }
      
      private function spin(param1:MouseEvent) : void
      {
         if(this.connectingAmf)
         {
            return;
         }
         this["rouletteMc"].play();
         this["spinMc"].removeEventListener(MouseEvent.CLICK,this.spin);
         Central.main.amfClient.service("RouletteService.getReward",[Central.main.account.getAccountSessionKey()],this.getRewardResponse);
      }
      
      private function getRewardResponse(param1:Object) : void
      {
         if(Central.main.validateAmfResponse(param1))
         {
            this.connectingAmf = false;
            this.rewardType = int(param1.reward_type);
            this.rewardAmountId = int(param1.reward_amount_id);
            this.rewardAmountOriginal = int(param1.reward_original_amount);
            this.rewardBonus = int(param1.reward_bonus);
            this.rewardAmount = int(param1.reward_amount);
            if(Central.main.getHash(String(this.rewardType) + String(this.rewardAmountId) + String(this.rewardAmount) + String(Central.main.getMainChar().consecutiveDays)) != String(param1.signature))
            {
               Central.main.onError();
               return;
            }
            if(this.rewardType == 1)
            {
               Central.main.account.balance = Central.main.account.getAccountBalance() + this.rewardAmount;
            }
            else if(this.rewardType == 2)
            {
               Central.main.getMainChar().updateGold(this.rewardAmount);
            }
            else
            {
               Central.main.getMainChar().updateXP(this.rewardAmount);
            }
            Central.main.updateMenu();
            this.spinTimer = new Timer(3000,1);
            this.spinTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.gotoReward);
            this.spinTimer.start();
         }
      }
      
      private function gotoReward(param1:TimerEvent) : void
      {
         this.stopSpinTimer();
         if(this.currentLabel != Timeline.IDLE)
         {
            this.gotoAndPlay(TL_REWARD);
         }
      }
      
      private function onReward() : void
      {
         this.stop();
         this["rouletteMc"].gotoAndStop(this.rewardAmountId);
      }
      
      public function gotoResult() : void
      {
         this.gotoAndPlay(TL_RESULT);
      }
      
      private function onResult() : void
      {
         var _loc2_:String = null;
         var _loc3_:String = null;
         this.stop();
         this["okBtn"].addEventListener(MouseEvent.CLICK,this.hide);
         Central.main.proc.isShowRoulette = false;
         Central.main.mapMenu["rouletteBtn"].gotoAndStop(Timeline.IDLE);
         Central.main.mapMenu["rouletteBtn"].removeEventListener(MouseEvent.CLICK,Central.main.proc.showRoulette);
         var _loc1_:String = Central.main.account.getAccountSessionKey();
         if(this.rewardType == 1)
         {
            this["rewardMc"].gotoAndStop(3);
            _loc3_ = "3";
         }
         if(this.rewardType == 2)
         {
            this["rewardMc"].gotoAndStop(2);
            _loc3_ = "1";
         }
         if(this.rewardType == 3)
         {
            this["rewardMc"].gotoAndStop(4);
            _loc3_ = "2";
         }
         _loc2_ = _loc1_ + "4" + "" + _loc3_ + this.rewardAmount.toString();
         var _loc4_:String = Central.main.updateSequence();
         Central.main.amfClient.service("FriendReward.getFriendReward",[_loc1_,"4","",_loc3_,this.rewardAmount.toString(),Central.main.getHash(String(_loc2_)),_loc4_],this.respondFriendReward);
      }
      
      private function respondFriendReward(param1:Object) : void
      {
         var _loc2_:String = null;
         if(Central.main.validateAmfResponse(param1))
         {
            this.connectingAmf = false;
            this.reward = param1;
            _loc2_ = Central.main.getHash(String(String(this.reward.status) + String(this.reward.reward_type) + String(this.reward.reward_amount) + String(this.reward.reward_id) + String(this.reward.wallfeed_id)));
            if(int(this.reward.status) > 0)
            {
               if(_loc2_ == this.reward.hash_str)
               {
                  switch(this.reward.reward_id)
                  {
                     case "1180":
                        Central.sns.publishShareFeed(SNSData.FEED_FR_LUCKY_DRAW_XP,this.reward.wallfeed_id,this.reward.reward_amount);
                        break;
                     case "1190":
                        Central.sns.publishShareFeed(SNSData.FEED_FR_LUCKY_DRAW_GOLD,this.reward.wallfeed_id,this.reward.reward_amount);
                        break;
                     case "1200":
                        Central.sns.publishShareFeed(SNSData.FEED_FR_LUCKY_DRAW_TOKEN,this.reward.wallfeed_id,this.reward.reward_amount);
                  }
               }
               else
               {
                  Central.main.onError("120","");
               }
            }
         }
      }
      
      public function displayReward() : void
      {
         this["rewardMc"]["rewardTxt"].htmlText = String(this.rewardAmount);
      }
      
      private function initPlayDays() : void
      {
         if(this.loginDay > 6)
         {
            this["dayBar"].gotoAndStop("day6");
         }
         else
         {
            this["dayBar"].gotoAndStop("day" + String(this.loginDay));
         }
      }
      
      private function stopSpinTimer() : void
      {
         if(this.spinTimer)
         {
            this.spinTimer.reset();
            this.spinTimer.stop();
            this.spinTimer = null;
         }
      }
      
      private function gotoApplicationPage(param1:MouseEvent = null) : void
      {
         switch(AppData.lang)
         {
            case AppData.ZH:
               Central.main.gotoURL("http://www.facebook.com/apps/application.php?id=113478732008371");
               break;
            case AppData.ES:
               Central.main.gotoURL("http://www.facebook.com/apps/application.php?id=115997521773834");
               break;
            default:
               Central.main.gotoURL(Data.FB_APPLICATION_PAGE);
         }
      }
      
      internal function frame1() : *
      {
         stop();
      }
      
      internal function frame8() : *
      {
         this.onIntroduction();
      }
      
      internal function frame11() : *
      {
         this.onRun();
      }
      
      internal function frame16() : *
      {
         this.onReward();
      }
      
      internal function frame22() : *
      {
         this.onResult();
      }
   }
}

