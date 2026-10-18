package ninjasaga.linkage
{
   import com.utils.CreateFilter;
   import com.utils.GF;
   import com.utils.Out;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.filters.ColorMatrixFilter;
   import flash.utils.Timer;
   import gs.TweenLite;
   import ninjasaga.Account;
   import ninjasaga.Central;
   import ninjasaga.Item;
   import ninjasaga.data.AMFData;
   import ninjasaga.data.ButtonData;
   import ninjasaga.data.InventoryData;
   import ninjasaga.data.TitleData;
   import ninjasaga.data.TokenData;
   import ninjasaga.data.TooltipData;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol328")]
   public class UIModule_TrainTimer extends MovieClip
   {
      
      public var skillTimerMC:MovieClip;
      
      public var progressHolder:MovieClip;
      
      public var skillFdTimerMC:MovieClip;
      
      private var cb_fn:Function;
      
      private var dimFilter:ColorMatrixFilter = CreateFilter.getSaturationFilter(0);
      
      private var firstUpdateProgress:Boolean = true;
      
      private var trainingTimer:Timer;
      
      private var packageMC:MovieClip;
      
      public function UIModule_TrainTimer()
      {
         super();
         addFrameScript(0,this.frame1);
      }
      
      public function setInterceptCallback(cb_fn:Function) : void
      {
         this.cb_fn = cb_fn;
      }
      
      public function startTrainSkillModule(cb_fn:Function = null) : void
      {
         this.visible = false;
         this.cb_fn = cb_fn;
         Central.main.getMainChar().verifyTrainingSkill(this.verifyTrainingFdSkill);
      }
      
      public function verifyTrainingFdSkill() : void
      {
         Central.main.getMainChar().verifyTrainingFdSkill(this.updateProgress);
      }
      
      public function updateProgress() : void
      {
         var mc:MovieClip = null;
         var time_max:uint = 0;
         this.visible = true;
         var trainingSkill:Object = Central.main.getMainChar().trainingSkill;
         var trainingFdSkill:Object = Central.main.getMainChar().trainingFdSkill;
         if(trainingSkill == null && trainingFdSkill == null)
         {
            this.visible = false;
            Central.main.mapMenu.trainSuccess = true;
         }
         else
         {
            mc = this;
            mc.visible = true;
            if(mc["skillTimerMC"]["iconMC"].hasEventListener(MouseEvent.CLICK))
            {
               Central.main.disableButton(mc["skillTimerMC"]["iconMC"],this.onShowSkillTimer,null);
            }
            if(mc["skillFdTimerMC"]["iconMC"])
            {
               Central.main.disableButton(mc["skillFdTimerMC"]["iconMC"],this.onShowFdSkillTimer,null);
            }
            if(trainingSkill == null)
            {
               mc["skillTimerMC"].visible = false;
               mc["skillFdTimerMC"].visible = true;
               mc["skillFdTimerMC"]["barMC"].x = 14;
               mc["skillFdTimerMC"]["iconMC"]["timeTxt"].visible = false;
               mc["skillFdTimerMC"].x = -14;
               this.updateFdSkillTimerInfo();
            }
            else if(trainingFdSkill == null)
            {
               mc["skillFdTimerMC"].visible = false;
               mc["skillTimerMC"].visible = true;
               mc["skillTimerMC"]["barMC"].x = 14;
               mc["skillTimerMC"]["iconMC"]["timeTxt"].visible = false;
               mc["skillTimerMC"].x = -14;
               this.updateSkillTimerInfo();
            }
            else
            {
               if(this.firstUpdateProgress)
               {
                  mc["skillTimerMC"].x = 88;
                  mc["skillFdTimerMC"].x = 175;
               }
               else
               {
                  mc["skillTimerMC"].x = -14;
                  mc["skillFdTimerMC"].x = 45;
               }
               mc["skillTimerMC"]["barMC"].x = -224;
               mc["skillTimerMC"].visible = true;
               mc["skillFdTimerMC"].visible = true;
               this.updateSkillTimerInfo();
               this.updateFdSkillTimerInfo();
               Central.main.initButton(mc["skillTimerMC"]["iconMC"],this.onShowSkillTimer,null);
               Central.main.initButton(mc["skillFdTimerMC"]["iconMC"],this.onShowFdSkillTimer,null);
            }
            this.gotoUpdateTimerProgress();
            time_max = 0;
            if(trainingSkill != null)
            {
               time_max = uint(Central.main.getMainChar().getTrainingSkillRemaining());
            }
            if(trainingFdSkill != null)
            {
               if(trainingFdSkill.remainingTime > time_max)
               {
                  time_max = uint(trainingFdSkill.remainingTime);
               }
            }
            if(this.trainingTimer == null && time_max > 0)
            {
               this.trainingTimer = new Timer(1000,time_max);
               this.trainingTimer.addEventListener(TimerEvent.TIMER,this.onUpdateProgress);
               this.trainingTimer.start();
            }
         }
         this.firstUpdateProgress = false;
         if(this.cb_fn != null)
         {
            this.cb_fn();
         }
      }
      
      private function onUpdateProgress(evt:TimerEvent) : void
      {
         var trainingSkill:Object = Central.main.getMainChar().trainingSkill;
         var trainingFdSkill:Object = Central.main.getMainChar().trainingFdSkill;
         if(trainingFdSkill != null)
         {
            --trainingFdSkill.remainingTime;
         }
         this.gotoUpdateTimerProgress();
      }
      
      private function gotoUpdateTimerProgress() : void
      {
         var trainingSkill:Object = Central.main.getMainChar().trainingSkill;
         var trainingFdSkill:Object = Central.main.getMainChar().trainingFdSkill;
         if(trainingSkill == null && trainingFdSkill == null)
         {
            this.stopTrainingTimer();
            if(Central.main.isPopupType == "skill")
            {
               this.packageMC.hide();
               GF.removeAllChild(this["progressHolder"]);
            }
            this.visible = false;
         }
         else
         {
            if(Central.main.isPopupType == "skill")
            {
               this.packageMC.updateSkillTimerProgress();
            }
            this.updateSkillTimerProgress();
            this.updateFdSkillTimerProgress();
         }
      }
      
      private function updateSkillTimerProgress() : void
      {
         var remainingTime:int = 0;
         var seconds:int = 0;
         var minutes:int = 0;
         var hours:int = 0;
         var trainingSkill:Object = Central.main.getMainChar().trainingSkill;
         var mc:MovieClip = this["skillTimerMC"]["barMC"];
         var iconMC:MovieClip = this["skillTimerMC"]["iconMC"];
         if(trainingSkill == null)
         {
            if(this["skillTimerMC"].visible == true)
            {
               this["skillTimerMC"].visible = false;
            }
            return;
         }
         remainingTime = int(Central.main.getMainChar().getTrainingSkillRemaining());
         if(remainingTime <= 0)
         {
            if(Central.main.isPopupType == "skill")
            {
               this.packageMC.hide();
               GF.removeAllChild(this["progressHolder"]);
            }
            mc["timeTxt"].text = "00:00:00";
            mc["percentBar"].scaleX = 1;
         }
         if(remainingTime == 0)
         {
            Central.main.getMainChar().verifyTrainingSkill(this.updateProgress);
         }
         if(remainingTime <= 0)
         {
            return;
         }
         seconds = remainingTime;
         minutes = Math.floor(seconds / 60);
         hours = Math.floor(minutes / 60);
         seconds %= 60;
         minutes %= 60;
         mc["timeTxt"].text = this.checkDigits(hours) + ":" + this.checkDigits(minutes) + ":" + this.checkDigits(seconds);
         iconMC["timeTxt"].text = this.checkDigits(hours) + ":" + this.checkDigits(minutes) + ":" + this.checkDigits(seconds);
         if(Central.main.Features.FEATURE_HALF_TRAIN_TIME)
         {
            mc["percentBar"].scaleX = (Central.main.SKILL_DATA[Central.main.getMainChar().trainingSkill.id]["train_time"] * 3600 / 2 - remainingTime) / (Central.main.SKILL_DATA[Central.main.getMainChar().trainingSkill.id]["train_time"] * 3600) / 2;
         }
         else
         {
            mc["percentBar"].scaleX = (Central.main.SKILL_DATA[Central.main.getMainChar().trainingSkill.id]["train_time"] * 3600 - remainingTime) / (Central.main.SKILL_DATA[Central.main.getMainChar().trainingSkill.id]["train_time"] * 3600);
         }
      }
      
      private function updateFdSkillTimerProgress() : void
      {
         var inventory_skill:Array = null;
         var trainingFdSkill:Object = Central.main.getMainChar().trainingFdSkill;
         var mc:MovieClip = this["skillFdTimerMC"]["barMC"];
         var iconMC:MovieClip = this["skillFdTimerMC"]["iconMC"];
         if(trainingFdSkill == null)
         {
            if(this["skillFdTimerMC"].visible == true)
            {
               this["skillFdTimerMC"].visible = false;
            }
            return;
         }
         var fd_second:int = int(trainingFdSkill.remainingTime);
         if(fd_second < 0)
         {
            fd_second = 0;
         }
         var fd_mintue:int = Math.floor(fd_second / 60);
         var fd_hour:int = Math.floor(fd_mintue / 60);
         fd_second %= 60;
         fd_mintue %= 60;
         if(!mc["btnUnlearn"].hasEventListener(MouseEvent.CLICK))
         {
            Central.main.initButton(mc["btnUnlearn"],this.confirmUnlearnSkill,ButtonData.VISITFRIENDSTOP);
         }
         if(mc["percentBar"])
         {
            mc["percentBar"].scaleX = (trainingFdSkill.trainingTime * 60 * 60 - (fd_second + fd_mintue * 60 + fd_hour * 60 * 60)) / (trainingFdSkill.trainingTime * 60 * 60);
         }
         if(mc["timeTxt"])
         {
            mc["timeTxt"].text = this.checkDigits(fd_hour) + ":" + this.checkDigits(fd_mintue) + ":" + this.checkDigits(fd_second);
         }
         iconMC["timeTxt"].text = this.checkDigits(fd_hour) + ":" + this.checkDigits(fd_mintue) + ":" + this.checkDigits(fd_second);
         if(trainingFdSkill.remainingTime > 0 && Boolean(mc["btnPractice"]))
         {
            Central.main.disableButton(mc["btnPractice"],this.practiceFdSkill,"");
            mc["btnPractice"].filters = [this.dimFilter];
         }
         else if(fd_hour == 0 && fd_mintue == 0 && fd_second == 0 && Boolean(mc["btnPractice"]))
         {
            Central.main.initButton(mc["btnPractice"],this.practiceFdSkill,ButtonData.PRACTICE);
            mc["btnPractice"].filters = null;
            mc["timeTxt"].text = "";
            if(trainingFdSkill.progress >= 80)
            {
               inventory_skill = Central.main.getMainChar().getInventory(InventoryData.TYPE_SKILL) as Array;
               if(inventory_skill.indexOf(trainingFdSkill.skill) < 0)
               {
                  if(inventory_skill)
                  {
                     inventory_skill.push(trainingFdSkill.skill);
                  }
                  else
                  {
                     inventory_skill = [trainingFdSkill.skill];
                  }
               }
            }
         }
         if(trainingFdSkill.remainingTime <= -(48 * 60 * 60))
         {
            Central.main.disableButton(mc["btnPractice"],this.practiceFdSkill,"");
            mc["btnPractice"].filters = [this.dimFilter];
            mc["timeTxt"].text = Central.main.langLib.titleTxt(TitleData.VISITFRIENDEXPIRED);
            iconMC["timeTxt"].text = Central.main.langLib.titleTxt(TitleData.VISITFRIENDEXPIRED);
         }
      }
      
      private function updateSkillTimerInfo() : void
      {
         var trainingSkill:Object = Central.main.getMainChar().trainingSkill;
         var mc:MovieClip = this["skillTimerMC"];
         mc["barMC"]["skillTypeIcon"].gotoAndStop(Central.main.SKILL_DATA[trainingSkill.id].type);
         mc["barMC"]["skillNameTxt"].text = Central.main.SKILL_DATA[trainingSkill.id].name;
         Central.main.hideDynamicTooltip(mc["iconMC"]);
         var tooltipStr:String = TooltipData.getItemTooltip(TooltipData.TOOLTIP_TYPE_SKILL,trainingSkill.id);
         Central.main.showDynamicTooltip(mc["iconMC"],String("<font size=\'16\'>" + tooltipStr + "</font>"));
      }
      
      private function updateFdSkillTimerInfo() : void
      {
         var trainingFdSkill:Object = Central.main.getMainChar().trainingFdSkill;
         var mc:MovieClip = this["skillFdTimerMC"];
         mc["barMC"]["skillTypeIcon"].gotoAndStop(Central.main.SKILL_DATA[trainingFdSkill.skill].type);
         mc["barMC"]["skillNameTxt"].text = Central.main.SKILL_DATA[trainingFdSkill.skill].name;
         Central.main.hideDynamicTooltip(mc["iconMC"]);
         var tooltipStr:String = TooltipData.getItemTooltip(TooltipData.TOOLTIP_TYPE_SKILL,trainingFdSkill.skill);
         Central.main.showDynamicTooltip(mc["iconMC"],String("<font size=\'16\'>" + tooltipStr + "</font>"));
      }
      
      private function onShowSkillTimer(evt:MouseEvent = null) : void
      {
         this["skillTimerMC"]["iconMC"]["timeTxt"].visible = false;
         this["skillFdTimerMC"]["iconMC"]["timeTxt"].visible = true;
         TweenLite.to(this["skillTimerMC"],0.6,{
            "x":-14,
            "onComplete":null
         });
         TweenLite.to(this["skillFdTimerMC"],0.6,{
            "x":258,
            "onComplete":null
         });
         TweenLite.to(this["skillTimerMC"]["barMC"],0.6,{
            "x":14,
            "onComplete":null
         });
         TweenLite.to(this["skillFdTimerMC"]["barMC"],0.6,{
            "x":-224,
            "onComplete":null
         });
      }
      
      private function onShowFdSkillTimer(evt:MouseEvent = null) : void
      {
         this["skillTimerMC"]["iconMC"]["timeTxt"].visible = true;
         this["skillFdTimerMC"]["iconMC"]["timeTxt"].visible = false;
         TweenLite.to(this["skillTimerMC"],0.6,{
            "x":-14,
            "onComplete":null
         });
         TweenLite.to(this["skillFdTimerMC"],0.6,{
            "x":45,
            "onComplete":null
         });
         TweenLite.to(this["skillTimerMC"]["barMC"],0.6,{
            "x":-224,
            "onComplete":null
         });
         TweenLite.to(this["skillFdTimerMC"]["barMC"],0.6,{
            "x":14,
            "onComplete":null
         });
      }
      
      private function practiceFdSkillconfirm() : void
      {
         Central.main.showAmfLoading();
         Central.main.amfClient.service("VisitFriendService.getLearnedSkill",[Account.getAccountSessionKey()],this.onPracticeFdSkill);
      }
      
      private function practiceFdSkill(evt:MouseEvent) : void
      {
         this.practiceFdSkillconfirm();
      }
      
      private function onPracticeFdSkill(result:Object) : void
      {
         var inventory_skill:Array = null;
         var mc:MovieClip = null;
         var trainingFdSkill:Object = Central.main.getMainChar().trainingFdSkill;
         Central.main.hideAmfLoading();
         if(String(result.status) == AMFData.STATUS_ERROR)
         {
            Out.error(this,"onAmfUnlearnSkillResult :: error code " + String(result.error));
            return;
         }
         if(String(result.status) == AMFData.STATUS_SUCCESS)
         {
            inventory_skill = Central.main.getMainChar().getInventory(InventoryData.TYPE_SKILL) as Array;
            if(inventory_skill.indexOf(trainingFdSkill.skill) < 0)
            {
               if(inventory_skill)
               {
                  inventory_skill.push(trainingFdSkill.skill);
               }
               else
               {
                  inventory_skill = [trainingFdSkill.skill];
               }
            }
            Central.main.showInfo(Central.main.langLib.get(569));
            mc = this["skillFdTimerMC"]["barMC"];
            mc["btnUnlearn"].visible = false;
            mc["percentBar"].scaleX = 0;
            Central.main.disableButton(mc["btnPractice"],this.practiceFdSkill,"");
            mc["btnPractice"].filters = [this.dimFilter];
            Central.main.getMainChar().trainingFdSkill = null;
            mc["skillNameTxt"].text = "";
            mc["skillTypeIcon"].gotoAndStop("idle");
            mc.visible = false;
         }
         this.cb_fn();
      }
      
      private function confirmUnlearnSkill(evt:MouseEvent = null) : void
      {
         Central.main.showConfirmation(Central.main.langLib.get(1626)[0],this.amfUnlearnSkill,new Function());
      }
      
      private function amfUnlearnSkill(evt:MouseEvent = null) : void
      {
         Central.main.showAmfLoading();
         Central.main.amfClient.service("VisitFriendService.unlearn",[Account.getAccountSessionKey()],this.onAmfUnlearnSkillResult);
      }
      
      private function onAmfUnlearnSkillResult(result:Object) : void
      {
         var trainingFdSkill:Object = Central.main.getMainChar().trainingFdSkill;
         if(String(result.status) == AMFData.STATUS_ERROR)
         {
            Out.error(this,"onAmfUnlearnSkillResult :: error code " + String(result.error));
            return;
         }
         if(String(result.status) == AMFData.STATUS_SUCCESS)
         {
            Central.main.getMainChar().trainingFdSkill = null;
            this.updateProgress();
            Central.main.hideAmfLoading();
         }
      }
      
      public function initinstantLearnBtn() : void
      {
         var mc:MovieClip = this["skillTimerMC"]["barMC"];
         Central.main.initButton(mc["instantLearnBtn"],this.instantTrain,ButtonData.INSTANTLEARN);
         mc["instantLearnBtn"].visible = true;
      }
      
      private function instantTrain(evt:MouseEvent) : void
      {
         if(Central.main.Features.FEATURE_ESSENCE)
         {
            if(!Item.hasItem("popup_skill_progress"))
            {
               Central.main.loadPopupPanel("popup_skill_progress","ninjasaga.linkage.SkillReduceProgress",this.popupProgress);
            }
            else
            {
               this.popupProgress();
            }
         }
         else
         {
            Central.main.showTokenEmblemSelection(TokenData.TYPE_INSTANT_TRAINING);
         }
      }
      
      public function popupProgress() : void
      {
         var panel:Item = null;
         panel = Item.getItem("popup_skill_progress");
         this.packageMC = panel.getAsset("ninjasaga.linkage.SkillReduceProgress");
         GF.removeAllChild(this["progressHolder"]);
         this["progressHolder"].addChild(this.packageMC);
         this.packageMC.show("skill");
      }
      
      public function finalizeInstantTrain() : void
      {
         var mc:MovieClip = this["progressMc"]["skillTimerMC"]["barMC"];
         mc["timeTxt"].text = "00:00:00";
         mc["percentBar"].scaleX = 1;
         Central.main.getMainChar().setUpdateTrainingSkill(0);
         Central.main.getMainChar().verifyTrainingSkill(this.updateProgress);
      }
      
      public function stopTrainSkillModule() : void
      {
         this.stopTrainingTimer();
      }
      
      public function stopTrainingTimer() : void
      {
         if(this.trainingTimer != null)
         {
            this.trainingTimer.reset();
            this.trainingTimer.stop();
            this.trainingTimer = null;
         }
      }
      
      private function checkDigits(value:int) : String
      {
         if(value.toString().length < 2)
         {
            return "0" + value.toString();
         }
         return value.toString();
      }
      
      internal function frame1() : *
      {
         stop();
      }
   }
}

