package ninjasaga.linkage
{
   import com.utils.CreateFilter;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.filters.ColorMatrixFilter;
   import flash.filters.GlowFilter;
   import flash.system.Capabilities;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   import ninjasaga.Account;
   import ninjasaga.Central;
   import ninjasaga.data.AppData;
   import ninjasaga.data.SNSData;
   import ninjasaga.data.Timeline;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol134")]
   public class NewDailyLogin2017 extends MovieClip
   {
      
      public var panel:MovieClip;
      
      private var langArrIndex:int = 1888;
      
      private var stampReward:Array = [];
      
      private var loginDay:Array = [];
      
      private var rewardDay:Array = [];
      
      private var serviceWithClaimDailyReward:* = "NewDailyRewardStamp2017.claimReward";
      
      private var serviceWithShow:* = "NewDailyRewardStamp2017.getStatus";
      
      private var showResponse:Object;
      
      private var serverDesc:Object = {};
      
      private var countdownTimeCounting:EnergyRefillSystem = new EnergyRefillSystem();
      
      private var isZh:Boolean = AppData.lang == AppData.ZH;
      
      private var claimNum:int;
      
      private var nowtime:int;
      
      private var countdownTime:Array = [];
      
      private var part2:Boolean = false;
      
      private var maxClaimNum:int;
      
      private var dimFilter:ColorMatrixFilter = CreateFilter.getSaturationFilter(0);
      
      private var langArr:Array;
      
      private var mc:MovieClip;
      
      private const QTY_X:Number = 12;
      
      private const QTY_Y:Number = 14;
      
      public function NewDailyLogin2017()
      {
         addFrameScript(0,this.frame1,9,this.frame10,12,this.frame13,28,this.frame29);
         super();
      }
      
      private function initButtonAndText() : void
      {
         var i:int = 0;
         var txt:String = null;
         var func:Function = null;
         var mc:* = undefined;
         var tmpArr:Array = null;
         var txtIndex:Array = [["titleTxt"],this.serverDesc.desc1,["titleTxt2"],this.serverDesc.desc2,["titleTxt3"],this.serverDesc.desc3,["titleTxt4"],this.isZh ? "伺服器時間:" : "Server Time:",["hourtxt"],this.isZh ? "時" : "hour",["mintxt"],this.isZh ? "分" : "min"];
         var arr:Array = [];
         var arrD:Array = [];
         var arrE:Array = [];
         var arrB:Array = [["btnClose"],this.hide];
         var arrC:Array = [];
         var arrF:Array = [];
         var GetMc:Function = function(param1:*, param2:Array):*
         {
            var _loc3_:int = 0;
            while(_loc3_ < param2.length)
            {
               if(!param1[param2[_loc3_]])
               {
                  return null;
               }
               param1 = param1[param2[_loc3_]];
               _loc3_++;
            }
            return param1;
         };
         tmpArr = txtIndex;
         i = 0;
         while(i < tmpArr.length)
         {
            mc = GetMc(this.mc,tmpArr[i]);
            if(mc)
            {
               txt = tmpArr[i + 1];
               mc.htmlText = txt;
            }
            i += 2;
         }
         tmpArr = arr;
         i = 0;
         while(i < tmpArr.length)
         {
            mc = GetMc(this.mc,tmpArr[i]);
            if(mc)
            {
               func = tmpArr[i + 1];
               txt = tmpArr[i + 2];
               Central.main.initButton(mc,func,txt);
            }
            i += 3;
         }
         tmpArr = arrB;
         i = 0;
         while(i < tmpArr.length)
         {
            mc = GetMc(this.mc,tmpArr[i]);
            if(mc)
            {
               func = tmpArr[i + 1];
               mc.removeEventListener(MouseEvent.CLICK,func);
               mc.addEventListener(MouseEvent.CLICK,func);
            }
            i += 2;
         }
         tmpArr = arrC;
         i = 0;
         while(i < tmpArr.length)
         {
            mc = GetMc(this.mc,tmpArr[i]);
            if(mc)
            {
               txt = tmpArr[i + 1];
               mc.stop();
               Central.main.hideDynamicTooltip(mc);
               Central.main.showDynamicTooltip(mc,txt);
            }
            i += 2;
         }
         tmpArr = arrD;
         i = 0;
         while(i < tmpArr.length)
         {
            mc = GetMc(this.mc,tmpArr[i]);
            if(mc)
            {
               func = tmpArr[i + 1];
               txt = tmpArr[i + 2];
               Central.main.disableButton(mc,func,txt);
               mc.filters = [this.dimFilter];
               if(tmpArr[i + 3])
               {
                  Central.main.initButton(mc,func,txt);
                  mc.filters = null;
               }
            }
            i += 4;
         }
         tmpArr = arrE;
         i = 0;
         while(i < tmpArr.length)
         {
            mc = GetMc(this.mc,tmpArr[i]);
            if(mc)
            {
               mc.visible = tmpArr[i + 1];
            }
            i += 2;
         }
         tmpArr = arrF;
         i = 0;
         while(i < tmpArr.length)
         {
            mc = GetMc(this.mc,tmpArr[i]);
            if(mc)
            {
               if(tmpArr[i + 1])
               {
                  mc.filters = null;
               }
               else
               {
                  mc.filters = [this.dimFilter];
               }
            }
            i += 2;
         }
         Central.main.updateMenu();
      }
      
      public function ChildrenDay2016() : void
      {
         this.langArr = Central.main.langLib.get(this.langArrIndex);
      }
      
      public function show(param1:String = null) : void
      {
         Central.main.showAmfLoading();
         Central.main.amfClient.service(this.serviceWithShow,[Account.getAccountSessionKey(),AppData.lang],this.showResponseFunction);
      }
      
      private function showResponseFunction(param1:Object) : void
      {
         var _loc2_:Array = null;
         var _loc3_:Array = null;
         var _loc4_:int = 0;
         var _loc5_:String = null;
         if(Central.main.validateAmfResponse(param1))
         {
            Central.main.hideAmfLoading();
            this.showResponse = param1;
            this.stampReward = [];
            this.loginDay = param1.loginDay;
            this.rewardDay = param1.rewardDay;
            _loc2_ = param1.item_list;
            this.serverDesc = param1.txt;
            this.nowtime = param1.now_time;
            if(param1.part2 == true)
            {
               this.part2 = true;
            }
            if(param1.part2 == true)
            {
               _loc4_ = 10;
            }
            else
            {
               _loc4_ = 0;
            }
            while(_loc4_ < _loc2_.length)
            {
               if(_loc2_[_loc4_])
               {
                  _loc3_ = _loc2_[_loc4_];
                  _loc5_ = _loc3_.join(",");
                  this.stampReward.push(_loc5_);
               }
               _loc4_++;
            }
            this.gotoAndPlay(Timeline.SHOW);
         }
      }
      
      public function onShow(param1:MovieClip) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         this.mc = param1["panel"];
         if(Capabilities.playerType == "Desktop" || Capabilities.playerType == "Mobile")
         {
            this.mc.scaleY = 0.75;
         }
         this.initButtonAndText();
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            this.mc["d" + (_loc3_ + 1)].visible = false;
            _loc3_++;
         }
         _loc2_ = 31;
         _loc3_ = 0;
         _loc3_ = 0;
         var _loc4_:Array = null;
         while(_loc3_ < 6)
         {
            _loc4_ = String(this.stampReward[_loc3_]).split("_");
            Central.main.showIconData(this.mc["Icon_" + _loc3_],_loc4_[0],_loc4_.length > 1 ? _loc4_[1] : "1");
            this.setIconQty(this.mc["Icon_" + _loc3_],_loc4_.length > 1 ? int(_loc4_[1]) : 1);
            Central.main.initButton(this.mc["claimBtn" + _loc3_],this.claimDailyReward,AppData.lang == AppData.ZH ? "領取" : "Claim");
            this.mc["DAY0" + (_loc3_ + 1)].text = this.rewardDay[_loc3_];
            _loc3_++;
         }
         this.countdownTimeCounting.stopTimer();
         this.updateCountTimer();
         this.countdownTimeCounting.startTimer(null,this.nowtime,null,this.updateCountCounting,"[time]");
         this.updatePanel();
      }
      
      private function updatePanel() : void
      {
         var _loc1_:int = 0;
         _loc1_ = 0;
         while(_loc1_ < 31)
         {
            if(this.showResponse.loginDay[_loc1_] == "0")
            {
               this.mc["s" + (_loc1_ + 1)].visible = false;
               this.mc["d" + (_loc1_ + 1)].visible = true;
            }
            else if(this.showResponse.loginDay[_loc1_] == "1")
            {
               this.mc["s" + (_loc1_ + 1)].visible = true;
               this.mc["d" + (_loc1_ + 1)].visible = true;
            }
            else
            {
               if(this.mc["s" + (_loc1_ + 1)])
               {
                  this.mc["s" + (_loc1_ + 1)].visible = false;
               }
               if(this.mc["d" + (_loc1_ + 1)])
               {
                  this.mc["d" + (_loc1_ + 1)].visible = false;
               }
            }
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < 6)
         {
            if(this.showResponse.claimReward[_loc1_] == "0")
            {
               this.mc["tick_" + _loc1_].visible = false;
               this.mc["claimBtn" + _loc1_].visible = false;
            }
            else if(this.showResponse.claimReward[_loc1_] == "1")
            {
               this.mc["tick_" + _loc1_].visible = false;
               this.mc["claimBtn" + _loc1_].visible = true;
            }
            else if(this.showResponse.claimReward[_loc1_] == "2")
            {
               this.mc["tick_" + _loc1_].visible = true;
               this.mc["claimBtn" + _loc1_].visible = false;
            }
            _loc1_++;
         }
      }
      
      private function claimDailyReward(param1:MouseEvent) : void
      {
         var _loc2_:Array = null;
         this.claimNum = int(param1.currentTarget.name.replace("claimBtn",""));
         trace("this.stampReward = " + this.stampReward[param1.currentTarget.name.replace("claimBtn","")]);
         var _loc3_:* = "";
         switch(this.stampReward[param1.currentTarget.name.replace("claimBtn","")])
         {
            case "item_1051":
            case "item_1052":
            case "item_1053":
            case "item_1054":
            case "item_1055":
            case "item_1056":
               if(!Central.main.toolkit.checkInventory())
               {
                  Central.main.showInfo(Central.main.langLib.get(348));
                  return;
               }
               break;
            case "item_1057":
            case "item_1058":
               break;
            default:
               _loc2_ = this.stampReward[param1.currentTarget.name.replace("claimBtn","")].split("_");
               if(!Central.main.toolkit.checkInventory() && _loc2_[0] == "item")
               {
                  Central.main.showInfo(Central.main.langLib.get(348));
                  return;
               }
               _loc3_ = this.stampReward[param1.currentTarget.name.replace("claimBtn","")];
         }
         Central.main.showAmfLoading();
         Central.main.amfClient.service(this.serviceWithClaimDailyReward,[Account.getAccountSessionKey(),this.claimNum],this.getDailyReward);
      }
      
      private function getDailyReward(param1:Object) : void
      {
         if(Central.main.validateAmfResponse(param1))
         {
            Central.main.hideAmfLoading();
            this.showResponse.claimReward[this.claimNum] = "2";
            this.updatePanel();
         }
      }
      
      private function setIconQty(param1:MovieClip, param2:int) : void
      {
         var _loc3_:TextFormat = null;
         if(param1 == null)
         {
            return;
         }
         var _loc4_:TextField = param1.getChildByName("qtyLbl") as TextField;
         if(param2 <= 1)
         {
            if(_loc4_)
            {
               param1.removeChild(_loc4_);
            }
            return;
         }
         if(_loc4_ == null)
         {
            _loc4_ = new TextField();
            _loc4_.name = "qtyLbl";
            _loc4_.selectable = false;
            _loc4_.mouseEnabled = false;
            _loc4_.autoSize = TextFieldAutoSize.LEFT;
            _loc4_.x = this.QTY_X;
            _loc4_.y = this.QTY_Y;
            _loc3_ = new TextFormat();
            _loc3_.font = "Arial";
            _loc3_.size = 22;
            _loc3_.bold = true;
            _loc3_.color = 16776960;
            _loc4_.defaultTextFormat = _loc3_;
            _loc4_.filters = [new GlowFilter(0,1,4,4,6)];
            param1.addChild(_loc4_);
         }
         _loc4_.text = "x" + param2;
      }
      
      private function hide(param1:MouseEvent = null) : void
      {
         Central.main.proc.streamStartEvents();
         this.gotoAndPlay(Timeline.EXIT);
      }
      
      private function gotoSendRequest(param1:MouseEvent) : void
      {
         Central.sns.publishFeedById(SNSData.FEED_51,"","","",true);
      }
      
      private function updateCountCounting() : void
      {
         ++this.nowtime;
         this.updateCountTimer();
      }
      
      private function updateCountTimer() : void
      {
         var _loc1_:Object = this.convertTimeToDate(this.nowtime);
         this.countdownTime = [];
         this.countdownTime.push(this.convertToDigit(_loc1_.hour,2));
         this.countdownTime.push(this.convertToDigit(_loc1_.minute,2));
         this.countdownTime.push(this.convertToDigit(_loc1_.second,2));
         this.mc["hour"].text = this.countdownTime[0] > 0 ? String(this.countdownTime[0]) : String(this.countdownTime[1]);
         this.mc["min"].text = this.countdownTime[0] > 0 ? String(this.countdownTime[1]) : String(this.countdownTime[2]);
      }
      
      private function convertTimeToDate(param1:int) : Object
      {
         var _loc2_:int = Math.floor(param1 / (60 * 60 * 24));
         param1 -= _loc2_ * 60 * 60 * 24;
         var _loc3_:int = Math.floor(param1 / (60 * 60));
         param1 -= _loc3_ * 60 * 60;
         var _loc4_:int = Math.floor(param1 / 60);
         param1 -= _loc4_ * 60;
         var _loc5_:Object = {};
         _loc5_.hour = _loc3_;
         _loc5_.minute = _loc4_;
         _loc5_.second = param1;
         return _loc5_;
      }
      
      private function convertToDigit(param1:String, param2:int) : String
      {
         if(param1 == null)
         {
            param1 = "";
         }
         while(param1.length < param2)
         {
            param1 = "0" + param1;
         }
         return param1;
      }
      
      internal function frame1() : *
      {
         this.stop();
      }
      
      internal function frame10() : *
      {
         this.onShow(this);
      }
      
      internal function frame13() : *
      {
         this.stop();
      }
      
      internal function frame29() : *
      {
         this.gotoAndStop("idle");
      }
   }
}

import flash.display.MovieClip;
import flash.events.TimerEvent;
import flash.utils.Timer;

class EnergyRefillSystem
{
   
   private var energyTimer:Timer = null;
   
   private var slotHolder:MovieClip;
   
   private var energyTime:uint;
   
   private var remainingTime:int;
   
   private var cbFnComplete:Function;
   
   private var cbFnUpdate:Function;
   
   private var desText:String;
   
   public function EnergyRefillSystem()
   {
      super();
   }
   
   public function startTimer(param1:MovieClip, param2:int, param3:Function, param4:Function, param5:String) : *
   {
      var _loc6_:int = 0;
      var _loc7_:int = 0;
      var _loc8_:String = null;
      this.slotHolder = param1;
      this.remainingTime = param2;
      this.cbFnComplete = param3;
      this.cbFnUpdate = param4;
      this.desText = param5;
      if(this.remainingTime == 0)
      {
         this.cbFnComplete();
         return;
      }
      if(this.energyTimer == null)
      {
         if(this.slotHolder)
         {
            this.slotHolder["timeTxt"].visible = true;
         }
         _loc6_ = int(this.remainingTime);
         if(_loc6_ < 0)
         {
            _loc6_ = 0;
         }
         _loc7_ = Math.floor(_loc6_ / 60);
         _loc6_ %= 60;
         _loc7_ %= 60;
         _loc8_ = String(this.checkDigits(_loc7_) + ":" + this.checkDigits(_loc6_));
         if(this.slotHolder)
         {
            this.slotHolder["timeTxt"].text = this.desText.replace("[time]",_loc8_);
         }
         this.energyTimer = new Timer(1000,this.remainingTime);
         this.energyTimer.addEventListener(TimerEvent.TIMER,this.onUpdateProgress);
         this.energyTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.onTimerComplete);
         this.energyTimer.start();
      }
   }
   
   private function onUpdateProgress(param1:TimerEvent) : void
   {
      var _loc2_:int = 0;
      var _loc3_:int = 0;
      var _loc4_:String = null;
      if(this.remainingTime > 0)
      {
         this.cbFnUpdate();
         --this.remainingTime;
      }
      if(Boolean(this.slotHolder) && Boolean(this.slotHolder["timeTxt"]))
      {
         _loc2_ = int(this.remainingTime);
         if(_loc2_ < 0)
         {
            _loc2_ = 0;
         }
         _loc3_ = Math.floor(_loc2_ / 60);
         _loc2_ %= 60;
         _loc3_ %= 60;
         _loc4_ = String(this.checkDigits(_loc3_) + ":" + this.checkDigits(_loc2_));
         if(this.slotHolder)
         {
            this.slotHolder["timeTxt"].text = this.desText.replace("[time]",_loc4_);
         }
      }
   }
   
   private function onTimerComplete(param1:TimerEvent) : void
   {
      if(this.cbFnComplete != null)
      {
         this.stopTimer();
         this.cbFnComplete();
      }
   }
   
   public function stopTimer() : *
   {
      if(this.energyTimer != null)
      {
         this.energyTimer.reset();
         this.energyTimer.stop();
         this.energyTimer.removeEventListener(TimerEvent.TIMER,this.onUpdateProgress);
         this.energyTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.onTimerComplete);
         this.energyTimer = null;
      }
   }
   
   private function checkDigits(param1:int) : String
   {
      if(param1.toString().length < 2)
      {
         return "0" + param1.toString();
      }
      return param1.toString();
   }
}
