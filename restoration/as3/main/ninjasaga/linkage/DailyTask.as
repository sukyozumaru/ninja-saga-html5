package ninjasaga.linkage
{
   import com.utils.CreateFilter;
   import com.utils.Out;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.filters.ColorMatrixFilter;
   import flash.text.TextField;
   import gs.TweenLite;
   import ninjasaga.Central;
   import ninjasaga.data.AppData;
   import ninjasaga.data.ButtonData;
   import ninjasaga.data.DBCharacterData;
   import ninjasaga.data.DailyTaskData;
   import ninjasaga.data.InventoryData;
   import ninjasaga.data.SNSData;
   import ninjasaga.data.Timeline;
   import ninjasaga.data.TitleData;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol1926")]
   public class DailyTask extends MovieClip
   {
      
      public var showMc:MovieClip;
      
      public var clickableMask:MovieClip;
      
      public var npcTxt:TextField;
      
      public var rewardMc:MovieClip;
      
      private var dimFilter:ColorMatrixFilter = CreateFilter.getSaturationFilter(0);
      
      private var connectingAmf:Boolean = false;
      
      private var dialogStep:uint = 0;
      
      private var dialogArr:Array = [Central.main.langLib.get(224),Central.main.langLib.get(225),Central.main.langLib.get(226)];
      
      private const dialogText:String = Central.main.langLib.get(227);
      
      private var taskMsg:String;
      
      private var rewardType:String;
      
      private var rewardMsg:String;
      
      private var reward:Object;
      
      private var rewards:Object;
      
      private var dailyTask:Object;
      
      private var claimXP:Boolean = false;
      
      public function DailyTask()
      {
         super();
         addFrameScript(0,this.frame1,5,this.frame6,10,this.frame11,15,this.frame16);
      }
      
      public function gotoGet() : void
      {
         this.dialogStep = 0;
         this.gotoAndStop("get");
      }
      
      public function gotoShow() : void
      {
         this.gotoAndStop(Timeline.SHOW);
      }
      
      private function gotoReward(param1:MouseEvent) : void
      {
         Central.main.showAmfLoading();
         this.dailyTask = Central.main.getMainChar().getInventory(InventoryData.TYPE_DAILY_TASK);
         if(this.dailyTask)
         {
            this.dailyTask.completeTime = 1;
            Central.main.getMainChar().setInventory(InventoryData.TYPE_DAILY_TASK,this.dailyTask);
         }
         Central.main.getMainChar().completeDailyTask(this.completeDailyTaskCallback);
      }
      
      private function completeDailyTaskCallback(param1:Object) : void
      {
         var _loc2_:String = null;
         var _loc3_:String = null;
         if(Central.main.validateAmfResponse(param1))
         {
            this.rewards = param1.dt_reward as Object;
            _loc2_ = Central.main.account.getAccountSessionKey();
            _loc3_ = Central.main.updateSequence();
            Central.main.amfClient.service("FriendReward.getFriendReward",[_loc2_,"3","","","",Central.main.getHash(String(_loc2_ + "3" + "" + "" + "")),_loc3_],this.respondFriendReward);
         }
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
               if(_loc2_ != this.reward.hash_str)
               {
                  Central.main.onError("120","");
               }
            }
         }
         this.gotoAndPlay("reward");
      }
      
      public function hide(param1:MouseEvent = null) : void
      {
         this.gotoAndStop(Timeline.IDLE);
         Central.main.proc.streamStartEvents();
      }
      
      private function onGet() : void
      {
         var _loc2_:String = null;
         var _loc1_:String = String(this.dialogArr[this.dialogStep]).replace("[playername]",Central.main.getMainChar().getData(DBCharacterData.NAME));
         var _loc3_:Object = Central.main.getMainChar().getInventory(InventoryData.TYPE_DAILY_TASK);
         switch(_loc3_.type)
         {
            case DailyTaskData.TYPE_XP:
               _loc2_ = String(Central.main.langLib.get(228)).replace("[valdailytasktotal]",String(_loc3_.total));
         }
         this["npcTxt"].htmlText = _loc1_.replace("[task_description]",_loc2_);
         this["clickableMask"].addEventListener(MouseEvent.CLICK,this.nextDialog);
      }
      
      private function onShow() : void
      {
         var _loc4_:String = null;
         var _loc1_:MovieClip = this["showMc"];
         this.tweenOpen(_loc1_);
         _loc1_["closeBtn"].addEventListener(MouseEvent.CLICK,this.onClose);
         var _loc2_:String = this.dialogText.replace("[playername]",Central.main.getMainChar().getData(DBCharacterData.NAME));
         this["npcTxt"].htmlText = _loc2_;
         _loc1_["claimRewardBtn"].buttonMode = true;
         var _loc3_:Object = Central.main.getMainChar().getInventory(InventoryData.TYPE_DAILY_TASK);
         switch(_loc3_.type)
         {
            case DailyTaskData.TYPE_CHALLENGE:
               _loc1_["typeTxt"].text = Central.main.langLib.titleTxt(TitleData.DAILYTASK_CHALLENGE) + " : " + _loc3_.amount + " / " + _loc3_.total;
               break;
            case DailyTaskData.TYPE_MISSION:
               _loc1_["typeTxt"].text = Central.main.langLib.titleTxt(TitleData.DAILYTASK_MISSION) + " : " + _loc3_.amount + " / " + _loc3_.total;
               break;
            case DailyTaskData.TYPE_RECRUIT:
               _loc1_["typeTxt"].text = Central.main.langLib.titleTxt(TitleData.DAILYTASK_RECRUIT) + " : " + _loc3_.amount + " / " + _loc3_.total;
               break;
            case DailyTaskData.TYPE_XP:
               _loc1_["typeTxt"].text = Central.main.langLib.titleTxt(TitleData.DAILYTASK_XP) + " : " + _loc3_.amount + " / " + _loc3_.total;
               break;
            default:
               _loc1_["typeTxt"].text = _loc3_.type + " : " + _loc3_.amount + " / " + _loc3_.total;
         }
         if(Central.mission.checkDailyTaskStatus() == 2)
         {
            _loc1_["claimRewardBtn"].removeEventListener(MouseEvent.CLICK,this.notFinished);
            Central.main.initButton(_loc1_["claimRewardBtn"],this.gotoReward,ButtonData.CLAIMREWARD);
            _loc1_["giftMc"].gotoAndStop(2);
         }
         if(Central.mission.checkDailyTaskStatus() == 1)
         {
            _loc1_["claimRewardBtn"].addEventListener(MouseEvent.CLICK,this.notFinished);
            this.disableButton(_loc1_["claimRewardBtn"],ButtonData.CLAIMREWARD);
            _loc1_["giftMc"].gotoAndStop(1);
         }
         _loc1_["lbl_dailytask_title"].text = Central.main.langLib.titleTxt(TitleData.DAILYTASK);
         switch(_loc3_.type)
         {
            case DailyTaskData.TYPE_XP:
               _loc4_ = String(Central.main.langLib.get(230)).replace("[valdailytasktotal]",String(_loc3_.total));
               break;
            case DailyTaskData.TYPE_CHALLENGE:
               _loc4_ = String(Central.main.langLib.get(231)).replace("[valdailytasktotal]",String(_loc3_.total));
               break;
            case DailyTaskData.TYPE_MISSION:
               _loc4_ = String(Central.main.langLib.get(232)).replace("[valdailytasktotal]",String(_loc3_.total));
               break;
            case DailyTaskData.TYPE_RECRUIT:
               _loc4_ = String(Central.main.langLib.get(233)).replace("[valdailytasktotal]",String(_loc3_.total));
         }
         _loc1_["descriptionTxt"].text = _loc4_;
      }
      
      private function disableButton(param1:*, param2:String = null) : void
      {
         param1.stop();
         param1["clickMask"].buttonMode = false;
         param1.filters = [this.dimFilter];
         param1.gotoAndStop(1);
         if(param2 != null)
         {
            param1["txt"].text = Central.main.langLib.btnTxt(param2);
         }
      }
      
      private function onReward() : void
      {
         var _loc4_:MovieClip = null;
         var _loc5_:String = null;
         var _loc6_:Object = null;
         var _loc7_:MovieClip = null;
         var _loc8_:MovieClip = null;
         this.stop();
         var _loc1_:MovieClip = this["rewardMc"];
         _loc1_["lbl_dailytask_title"].text = Central.main.langLib.titleTxt(TitleData.DAILYTASK);
         this["npcTxt"].htmlText = String(Central.main.langLib.get(234)).replace("[valplayname]",String(Central.main.getMainChar().getCharacterName()));
         this.tweenOpen(_loc1_);
         Central.mission.finishDailyTask();
         switch(this.rewards.type)
         {
            case DailyTaskData.REWARD_GOLD:
               _loc1_["iconsMc"].gotoAndStop("gold");
               _loc1_["rewardTxt"].text = "+ " + String(this.rewards.amount) + " " + Central.main.langLib.titleTxt(TitleData.GOLD);
               Central.main.getMainChar().saveGold(this.rewards.amount);
               this.rewardType = "gold";
               this.rewardMsg = String(Central.main.langLib.get(235)).replace("[valamount]",String(this.rewards.amount));
               break;
            case DailyTaskData.REWARD_SKILL:
               _loc1_["iconsMc"].gotoAndStop("skill");
               _loc1_["rewardTxt"].text = Central.main.SKILL_DATA[this.rewards.id].name;
               _loc4_ = Central.main.getLib(Central.main.SKILL_DATA[this.rewards.id].swfName);
               _loc1_["iconsMc"]["holder"].addChild(_loc4_);
               Central.main.getMainChar().addNewSkill(this.rewards.id);
               this.rewardType = Central.main.SKILL_DATA[this.rewards.id].type;
               this.rewardMsg = String(String(String(Central.main.langLib.get(236)).replace("[valrewardlevel]",String(Central.main.SKILL_DATA[this.rewards.id].level))).replace("[valrewardtype]",Central.main.SKILL_DATA[this.rewards.id].type)).replace("[valrewardname]",Central.main.SKILL_DATA[this.rewards.id].name);
               break;
            case DailyTaskData.REWARD_WEAPON:
               _loc1_["iconsMc"].gotoAndStop("weapon");
               _loc1_["rewardTxt"].text = Central.main.WEAPON_DATA.find(this.rewards.id).name;
               Central.main.getMainChar().addInventory(InventoryData.TYPE_WEAPON,this.rewards.id);
               this.rewardType = "weapon";
               this.rewardMsg = String(Central.main.langLib.get(237)).replace("[valrewardname]",Central.main.WEAPON_DATA.find(this.rewards.id).name);
               break;
            case DailyTaskData.REWARD_XP:
               _loc1_["iconsMc"].gotoAndStop("xp");
               _loc1_["rewardTxt"].text = "+ " + String(this.rewards.amount) + " " + Central.main.langLib.titleTxt(TitleData.XP);
               Central.main.getMainChar().updateXP(this.rewards.amount);
               this.rewardType = "xp";
               this.rewardMsg = String(Central.main.langLib.get(238)).replace("[valamount]",String(this.rewards.amount));
               this.claimXP = true;
               break;
            case DailyTaskData.REWARD_ITEM:
               this.rewardType = "item";
               _loc1_["iconsMc"].gotoAndStop("skill");
               _loc5_ = this.rewards.id.replace("_","");
               _loc6_ = Central.main.toolkit.getDisplayData(_loc5_);
               _loc1_["rewardTxt"].text = _loc6_.itemData.name;
               _loc1_["iconsMc"]["iconHolder"].addChild(_loc6_.mc);
               switch(_loc6_.itemData.animation)
               {
                  case "material":
                     Central.main.getMainChar().addInventory(InventoryData.TYPE_MATERIAL,_loc6_.itemData.id);
                     break;
                  case "essence":
                     Central.main.getMainChar().addInventory(InventoryData.TYPE_ESSENCE,_loc6_.itemData.id);
                     break;
                  case "currency":
                     Central.main.addCurrency(_loc6_.itemData.id);
               }
               this.rewardMsg = Central.main.langLib.get(1615)[41].replace("[Item]",_loc6_.itemData.name);
               break;
            default:
               Out.error(this,"Reward Type Not Found, type=" + this.rewards.type);
         }
         switch(this.dailyTask.type)
         {
            case DailyTaskData.TYPE_XP:
               this.taskMsg = String(Central.main.langLib.get(239)).replace("[valdailytasktotal]",String(this.dailyTask.total));
               break;
            case DailyTaskData.TYPE_CHALLENGE:
               this.taskMsg = String(Central.main.langLib.get(240)).replace("[valdailytasktotal]",String(this.dailyTask.total));
               break;
            case DailyTaskData.TYPE_MISSION:
               this.taskMsg = String(Central.main.langLib.get(241)).replace("[valdailytasktotal]",String(this.dailyTask.total));
               break;
            case DailyTaskData.TYPE_RECRUIT:
               this.taskMsg = String(Central.main.langLib.get(242)).replace("[valdailytasktotal]",String(this.dailyTask.total));
         }
         var _loc2_:MovieClip = this["rewardMc"]["shareBoxMC"];
         var _loc3_:MovieClip = this["rewardMc"]["btnMC"];
         if(AppData.type == AppData.RR)
         {
            _loc3_.visible = true;
            _loc2_.visible = false;
            Central.main.initButton(_loc3_["okBtn"],this.onClose,ButtonData.OK);
         }
         else
         {
            _loc3_.visible = false;
            _loc2_.visible = true;
            _loc1_ = new MovieClip();
            _loc1_ = _loc2_;
            Central.main.initButton(_loc1_["skipBtn"],this.onClose,ButtonData.SKIP);
            _loc7_ = new LoadingMc();
            _loc7_.scaleX = 0.7;
            _loc7_.scaleY = 0.7;
            _loc1_["iconHolder"].addChild(_loc7_);
            _loc8_ = new MovieClip();
            _loc1_["iconHolder"].addChild(_loc8_);
            _loc8_.scaleX = 0.7;
            _loc8_.scaleY = 0.7;
            if(int(this.reward.status) > 0)
            {
               switch(this.reward.reward_id)
               {
                  case "1120":
                     Central.main.initButton(_loc1_["shareBtn"],this.onPublishDailyTask,ButtonData.SHAREXP);
                     _loc1_["feedTitleTxt"].text = Central.main.langLib.get(712);
                     _loc1_["congDescTxt"].text = String(Central.main.langLib.get(713)).replace("[value]",this.reward.reward_amount);
                     Central.main.proc.loadIcon("wf_14",_loc8_,"wf_14",null);
                     break;
                  case "1130":
                     Central.main.initButton(_loc1_["shareBtn"],this.onPublishDailyTask,ButtonData.SHAREGOLD);
                     _loc1_["feedTitleTxt"].text = Central.main.langLib.get(714);
                     _loc1_["congDescTxt"].text = String(Central.main.langLib.get(715)).replace("[value]",this.reward.reward_amount);
                     Central.main.proc.loadIcon("wf_1",_loc8_,"wf_1",null);
                     break;
                  case "1140":
                     Central.main.initButton(_loc1_["shareBtn"],this.onPublishDailyTask,ButtonData.SHARETOKEN);
                     _loc1_["feedTitleTxt"].text = Central.main.langLib.get(716);
                     _loc1_["congDescTxt"].text = String(Central.main.langLib.get(717)).replace("[value]",this.reward.reward_amount);
                     Central.main.proc.loadIcon("wf_2",_loc8_,"wf_2",null);
                     break;
                  case "1150":
                     Central.main.initButton(_loc1_["shareBtn"],this.onPublishDailyTask,ButtonData.SHARECLOTHING);
                     _loc1_["feedTitleTxt"].text = Central.main.langLib.get(718);
                     _loc1_["congDescTxt"].text = String(Central.main.langLib.get(719));
                     Central.main.proc.loadIcon("wf_19",_loc8_,"wf_19",null);
                     break;
                  case "1160":
                     Central.main.initButton(_loc1_["shareBtn"],this.onPublishDailyTask,ButtonData.SHAREWEAPON);
                     _loc1_["feedTitleTxt"].text = Central.main.langLib.get(720);
                     _loc1_["congDescTxt"].text = String(Central.main.langLib.get(721));
                     Central.main.proc.loadIcon("wf_13",_loc8_,"wf_13",null);
                     break;
                  case "1170":
                     Central.main.initButton(_loc1_["shareBtn"],this.onPublishDailyTask,ButtonData.SHAREBACK);
                     _loc1_["feedTitleTxt"].text = Central.main.langLib.get(722);
                     _loc1_["congDescTxt"].text = String(Central.main.langLib.get(723));
                     Central.main.proc.loadIcon("wf_10",_loc8_,"wf_10",null);
               }
            }
         }
         Central.main.hideAmfLoading();
         Central.main.updateMenu();
      }
      
      private function onPublishDailyTask(param1:MouseEvent) : void
      {
         if(!Central.main.facebookPermissionUserFriends)
         {
            Central.main.showInfo(Central.main.langLib.get(2000)[1]);
            return;
         }
         var _loc2_:String = Central.main.getHash(String(String(this.reward.status) + String(this.reward.reward_type) + String(this.reward.reward_amount) + String(this.reward.reward_id) + String(this.reward.wallfeed_id)));
         if(int(this.reward.status) > 0)
         {
            if(_loc2_ == this.reward.hash_str)
            {
               switch(this.reward.reward_id)
               {
                  case "1120":
                     Central.sns.publishShareFeed(SNSData.FEED_FR_DT_XP,this.reward.wallfeed_id,this.reward.reward_amount);
                     break;
                  case "1130":
                     Central.sns.publishShareFeed(SNSData.FEED_FR_DT_GOLD,this.reward.wallfeed_id,this.reward.reward_amount);
                     break;
                  case "1140":
                     Central.sns.publishShareFeed(SNSData.FEED_FR_DT_TOKEN,this.reward.wallfeed_id,this.reward.reward_amount);
                     break;
                  case "1150":
                     Central.sns.publishShareFeed(SNSData.FEED_FR_DT_CLOTHING,this.reward.wallfeed_id,this.reward.reward_amount);
                     break;
                  case "1160":
                     Central.sns.publishShareFeed(SNSData.FEED_FR_DT_WEAPON,this.reward.wallfeed_id,this.reward.reward_amount);
                     break;
                  case "1170":
                     Central.sns.publishShareFeed(SNSData.FEED_FR_DT_BACKITEM,this.reward.wallfeed_id,this.reward.reward_amount);
               }
            }
            else
            {
               Central.main.onError("120","");
            }
         }
         this.onClose(param1);
      }
      
      private function nextDialog(param1:MouseEvent) : void
      {
         var _loc2_:String = null;
         var _loc3_:String = null;
         var _loc4_:Object = null;
         ++this.dialogStep;
         if(this.dialogStep >= this.dialogArr.length)
         {
            this.gotoShow();
         }
         else
         {
            _loc2_ = String(this.dialogArr[this.dialogStep]).replace("[playername]",Central.main.getMainChar().getData(DBCharacterData.NAME));
            _loc4_ = Central.main.getMainChar().getInventory(InventoryData.TYPE_DAILY_TASK);
            switch(_loc4_.type)
            {
               case DailyTaskData.TYPE_XP:
                  _loc3_ = String(Central.main.langLib.get(243)).replace("[valdailytasktotal]",String(_loc4_.total));
            }
            this["npcTxt"].htmlText = _loc2_.replace("[task_description]",_loc3_);
         }
      }
      
      private function notFinished(param1:MouseEvent) : void
      {
         Central.main.showInfo(Central.main.langLib.get(244));
      }
      
      private function onClose(param1:MouseEvent) : void
      {
         var _loc2_:MovieClip = null;
         switch(this.currentLabel)
         {
            case Timeline.SHOW:
               _loc2_ = this["showMc"];
               break;
            case "reward":
               _loc2_ = this["rewardMc"];
         }
         if(this.claimXP)
         {
            this.claimXP = false;
            Central.main.getMainChar().checkLvUpReward();
         }
         Central.main.updateMapSideBtn();
         this.tweenClose(_loc2_,this.hide);
      }
      
      public function tweenOpen(param1:MovieClip) : void
      {
         param1.scaleX = 0;
         param1.scaleY = 0;
         TweenLite.to(param1,0.25,{
            "scaleX":1,
            "scaleY":1
         });
      }
      
      public function tweenClose(param1:MovieClip, param2:Function = null) : void
      {
         var _loc3_:Object = {};
         _loc3_.scaleX = 0;
         _loc3_.scaleY = 0;
         if(param2 != null)
         {
            _loc3_.onComplete = param2;
         }
         TweenLite.to(param1,0.3,_loc3_);
      }
      
      internal function frame1() : *
      {
         this.stop();
      }
      
      internal function frame6() : *
      {
         this.onGet();
      }
      
      internal function frame11() : *
      {
         this.onShow();
      }
      
      internal function frame16() : *
      {
         this.onReward();
      }
   }
}

