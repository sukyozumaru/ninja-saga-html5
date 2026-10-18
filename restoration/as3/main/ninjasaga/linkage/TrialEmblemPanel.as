package ninjasaga.linkage
{
   import com.utils.Delegate;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import ninjasaga.Account;
   import ninjasaga.Central;
   import ninjasaga.data.AppData;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol1243")]
   public class TrialEmblemPanel extends MovieClip
   {
      
      public var panel:MovieClip;
      
      public var panelMC:MovieClip;
      
      internal var day:int;
      
      internal var link:String = "http://www.ninjasaga.com/ninja-emblem/comparsion.php";
      
      internal var wranning:String;
      
      internal var upperWord:String;
      
      internal var minWord:String;
      
      internal var lowerWord:String;
      
      internal var buttonWord:String;
      
      internal var expedWord:String;
      
      internal var mc:MovieClip;
      
      internal var isZh:Boolean = AppData.lang == AppData.ZH;
      
      public function TrialEmblemPanel()
      {
         super();
         addFrameScript(0,this.frame1,6,this.frame7,8,this.frame9,28,this.frame29);
      }
      
      private function initBtnAText() : void
      {
         this.mc["titleTxt"].text = this.isZh ? "試用忍者紋章" : "Trial Emblem";
         this.mc["onlyOne"].text = this.upperWord;
         this.mc["totalValueTxt"].text = this.minWord;
         this.mc["day"].text = this.isZh ? "天後失效" : "Days";
         this.mc["expirWLbl"].text = this.wranning;
         this.mc["expriedDaysRemainTxt"].text = Math.abs(this.day) + (this.isZh ? " 日" : " Days");
         this.mc["expirWLbl2"].text = this.lowerWord;
         this.mc["expirWLbl3"].text = this.expedWord;
         Central.main.disableButton(this.mc["newStartBtn"],this.getEmblem,this.buttonWord);
         Central.main.initButton(this.mc["newStartBtn"],this.getEmblem,this.buttonWord);
         Central.main.disableButton(this.mc["removeBtn"],this.onClickRemove,this.isZh ? "不再廷長使用" : "Not Renew");
         Central.main.initButton(this.mc["removeBtn"],this.onClickRemove,this.isZh ? "不再廷長使用" : "Not Renew");
         this.mc["btnClose"].removeEventListener(MouseEvent.CLICK,this.onClickHide);
         this.mc["btnClose"].addEventListener(MouseEvent.CLICK,this.onClickHide);
         this.mc["btnHelp_0"].removeEventListener(MouseEvent.CLICK,this.onClickInfo);
         this.mc["btnHelp_0"].addEventListener(MouseEvent.CLICK,this.onClickInfo);
         this.mc["emblemMC"].visible = !Central.main.isTrailEmblem;
         this.mc["day"].visible = Central.main.isTrailEmblem && this.day >= 0;
         this.mc["effectMC"].visible = Central.main.isTrailEmblem && this.day < 0;
         this.mc["expriedDaysRemainTxt"].visible = Central.main.isTrailEmblem && this.day < 0 && !Central.main.isExpired;
         this.mc["totalDay"].visible = Central.main.isTrailEmblem;
         this.mc["expirWLbl"].visible = Central.main.isTrailEmblem && !Central.main.isExpired;
         this.mc["expirWLbl2"].visible = !Central.main.isTrailEmblem && !Central.main.isExpired;
         this.mc["expirWLbl3"].visible = Central.main.isTrailEmblem;
         this.mc["btnHelp_0"].visible = !Central.main.isExpired;
         this.mc["removeBtn"].visible = Central.main.isExpired;
         this.mc["totalDay"].htmlText = this.day >= 0 ? "<font color=\'#000000\'>" + this.day + "</font>" : (this.isZh ? "<font color=\'#FFFFFF\'>已逾期</font>" : "<font color=\'#FFFFFF\'>Expired</font>");
      }
      
      public function show() : void
      {
         trace("fucckckckckck");
         this.gotoAndPlay("show");
      }
      
      public function onShow(param1:MovieClip) : void
      {
         this.day = this.calDay();
         this.calFree();
         this.mc = param1["panelMC"];
         this.initBtnAText();
      }
      
      private function onClickHide(param1:MouseEvent) : void
      {
         this.gotoAndPlay("idle");
         if(!Central.main.isExpired)
         {
            Central.main.proc.streamStartEvents();
         }
      }
      
      private function onClickInfo(param1:MouseEvent) : void
      {
         Central.main.gotoURL(this.link,"_blank");
      }
      
      private function calDay() : int
      {
         if(Central.main.isExpired)
         {
            return -1;
         }
         var _loc1_:int = int(Central.main.extraData.trial_emblem_expire_time);
         var _loc2_:int = Math.round(_loc1_ / (24 * 60 * 60));
         if(_loc2_ == 0)
         {
            return 1;
         }
         return _loc2_;
      }
      
      private function getEmblem(param1:MouseEvent) : void
      {
         if(!Central.main.isExpired && Boolean(Central.main.extraData.claim_fowte))
         {
            Central.main.showAmfLoading();
            Central.main.getHash("1");
            Central.main.amfClient.service("SpecialReward.claimTrialEmblem",[Account.getAccountSessionKey(),1,Central.main.getHash("1")],this.getEmblemResponse);
         }
         else
         {
            Central.main.callJS("PopupPurchaseTrialEmblem");
         }
      }
      
      private function getEmblemResponse(param1:Object) : void
      {
         if(Central.main.validateAmfResponse(param1))
         {
            Central.main.callJS("refreshNS");
         }
      }
      
      private function calFree() : void
      {
         if(Central.main.extraData != null && Central.main.extraData.claim_fowte == 1)
         {
            this.wranning = "";
            this.upperWord = this.isZh ? "恭喜您成為本週之星" : "Congratulations for being FoTW winner!";
            this.buttonWord = this.isZh ? "馬上領取(免費)" : "Get It Now(Free)";
            this.minWord = this.isZh ? "您已獲得30天試用忍者紋章" : "You can now enjoy the 30-days Trial Emblem";
            this.lowerWord = this.isZh ? "*每次續約30天只需USD 0.99\n**請於60日內領取" : "*Unlimited renewal 30 Days for USD 0.99\n**Please get it in 60 days";
            this.expedWord = this.isZh ? "你的試用忍者紋章將於" : "Your Trial Emblem will be expired in";
         }
         else if(!Central.main.isExpired)
         {
            this.wranning = this.isZh ? "在" + Central.main.extraData.trial_emblem_expire_date_14 + "前可以享受優惠價 USD 0.99 (原價USD 1.99)延續你的試用忍者紋章。若不延續, 你的帳戶將降級為普通用戶並不會收到任何通知。" : "Trial Emblem Renewal before " + Central.main.extraData.trial_emblem_expire_date_14 + " \nfor ONLY USD 0.99(original prices is USD 1.99)\nOtherwise, your account will be downgraded to free user account without any other notice";
            this.minWord = this.isZh ? "現在可以優惠價延長享受試用忍者紋章" : "Renew now to enjoy\nTrial-Emblem with discount";
            this.lowerWord = this.isZh ? "*每次續約30天只需USD 0.99(原價USD 1.99)" : "*Unlimited renewal 30 Days for USD 0.99(original prices USD 1.99)";
            this.buttonWord = (this.isZh ? "延長試用" : "Renew It Now") + " (USD 0.99 )";
            this.upperWord = this.isZh ? "再次續約30天只需USD 0.99" : "Another 30 Days Trial Renewal for USD 0.99";
            if(this.day < 0)
            {
               this.expedWord = this.isZh ? "你的試用忍者紋章" : "Your Trial Emblem has been";
            }
            else
            {
               this.expedWord = this.isZh ? "你的試用忍者紋章將於" : "Your Trial Emblem will be expired in";
            }
         }
         else if(Central.main.isExpired)
         {
            this.upperWord = this.isZh ? "再次續約30天需要USD 1.99" : "Another 30 Days Trial Renewal for USD 1.99";
            this.buttonWord = (this.isZh ? "延長試用" : "Renew It Now") + " (USD 1.99 )";
            this.minWord = this.isZh ? "保持試用忍者紋章的最後機會!" : "Last chance to keep the Trial Emblem privilege!";
            this.lowerWord = "";
            this.wranning = "";
            this.expedWord = this.isZh ? "你的試用忍者紋章" : "Your Trial Emblem has been";
         }
         else
         {
            this.upperWord = this.isZh ? "30天試用忍者紋章只需USD 2.99" : "30 Days Trial Emblem for ONLY USD 2.99";
            this.wranning = "";
            this.minWord = this.isZh ? "現在可以優先享受試用忍者紋章優惠" : "Join now to enjoy\nEmblem features and benefits";
            this.lowerWord = this.isZh ? "*每次續約30天只需USD 0.99" : "*Unlimited renewal 30 Days for USD 0.99";
            this.buttonWord = (this.isZh ? "馬上取得" : "Get It Now") + " (USD 2.99 )";
            this.expedWord = this.isZh ? "你的試用忍者紋章將於" : "Your Trial Emblem will be expired in";
         }
      }
      
      private function onClickRemove(param1:MouseEvent) : void
      {
         Central.main.showDeleteConfirmation(this.isZh ? "你確定刪除關於試用忍者紋章用戶的所有權限嗎?\n(請輸入\"DELETE\")" : "Are you sure to remove all the benefits and privileges provided by Trial Emblem?\n(Please enter \"Delete\")",Delegate.create(this,this.amfDeletePromptSecurity),new Function());
      }
      
      public function amfDeletePromptSecurity() : void
      {
         if(Central.main.accRegActiveStatus == Central.main.ACC_REG_ACTIVE_STATUS_ACTIVE)
         {
            Central.main.showSecurityPasswordConfirmation(Central.main.langLib.get(1813),this.comfirmRemoveTrailEmblem,this.getEmblem,true);
         }
         else
         {
            Central.main.showSecurityPasswordSignupInvitation(Central.main.langLib.get(1812),this.comfirmRemoveTrailEmblem,this.getEmblem,true,true);
         }
      }
      
      private function comfirmRemoveTrailEmblem(param1:String = "") : void
      {
         Central.main.showAmfLoading();
         Central.main.amfClient.service("CharacterDAO.deleteCharactersOnRemoveTrialEmblem",[Central.main.account.getAccountSessionKey(),param1],this.removeTrailEmblemResponse);
      }
      
      private function removeTrailEmblemResponse(param1:Object) : void
      {
         if(Central.main.validateAmfResponse(param1))
         {
            Central.main.hideAmfLoading();
            if(param1.msg)
            {
               switch(param1.msg)
               {
                  case "wrong_password":
                     Central.main.showInfo(Central.main.langLib.get(1823));
                     break;
                  case "not_registered":
                     Central.main.showInfo("Not Registered");
               }
            }
            else
            {
               Central.main.callJS("refreshNS");
            }
         }
      }
      
      internal function frame1() : *
      {
         this.stop();
      }
      
      internal function frame7() : *
      {
         this.onShow(this);
      }
      
      internal function frame9() : *
      {
         this.stop();
      }
      
      internal function frame29() : *
      {
         this.gotoAndStop("idle");
      }
   }
}

