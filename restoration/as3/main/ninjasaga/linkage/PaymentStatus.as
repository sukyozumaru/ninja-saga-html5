package ninjasaga.linkage
{
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import ninjasaga.Central;
   import ninjasaga.data.AppData;
   import ninjasaga.data.ButtonData;
   import ninjasaga.data.Timeline;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol2801")]
   public class PaymentStatus extends MovieClip
   {
      
      public var goBtn:MovieClip;
      
      public var btnClose:SimpleButton;
      
      public var attention_title:TextField;
      
      public var attentionTxt:TextField;
      
      public var helpBtn:MovieClip;
      
      public var ps_en:TextField;
      
      public var ps_zh:TextField;
      
      public function PaymentStatus()
      {
         super();
         addFrameScript(0,this.frame1,4,this.frame5,9,this.frame10);
         this.stop();
      }
      
      public function show() : void
      {
         if(Central.main.showNewLockPopup == true)
         {
            this.gotoAndPlay("show_new");
            return;
         }
         this.gotoAndPlay(Timeline.SHOW);
      }
      
      public function hide(param1:MouseEvent = null) : void
      {
         this.gotoAndStop(Timeline.IDLE);
      }
      
      public function gotoLink(param1:MouseEvent) : void
      {
         switch(AppData.lang)
         {
            case AppData.ZH:
               Central.main.gotoURL("http://apps.facebook.com/ninjasaga_zh/support_form/","_blank");
               break;
            case AppData.ES:
               Central.main.gotoURL("http://apps.facebook.com/ninjasaga_es/support_form/","_blank");
               break;
            default:
               Central.main.gotoURL("http://apps.facebook.com/ninjasaga/support_form/","_blank");
         }
      }
      
      public function onShow() : void
      {
         this.stop();
         this["btnClose"].addEventListener(MouseEvent.CLICK,this.hide);
         if(Central.main.showLearnMoreBtn)
         {
            this["helpBtn"].visible = true;
            Central.main.initButton(this["helpBtn"],this.detail,ButtonData.LEARN_MORE);
         }
         else
         {
            this["helpBtn"].visible = false;
            Central.main.disableButton(this["helpBtn"],this.detail,ButtonData.LEARN_MORE);
         }
         Central.main.initButton(this["goBtn"],this.gotoLink,ButtonData.SUPPORT_FORM);
         this["attention_title"].htmlText = String(Central.main.paymentTitle);
         this["attentionTxt"].htmlText = String(Central.main.paymentText);
         if(Central.main.showNewLockPopup == true)
         {
            switch(AppData.lang)
            {
               case AppData.ZH:
                  this["ps_zh"].visible = true;
                  this["ps_en"].visible = false;
                  break;
               default:
                  this["ps_zh"].visible = false;
                  this["ps_en"].visible = true;
            }
         }
      }
      
      public function detail(param1:MouseEvent) : void
      {
         Central.main.showFAQ(Central.main.langLib.get(947),Central.main.langLib.get(948),Central.main.langLib.get(949),Central.main.langLib.get(950),Central.main.langLib.get(951),Central.main.langLib.get(1724)[0],Central.main.langLib.get(1724)[1]);
      }
      
      internal function frame1() : *
      {
         stop();
      }
      
      internal function frame5() : *
      {
         this.onShow();
      }
      
      internal function frame10() : *
      {
         this.onShow();
      }
   }
}

