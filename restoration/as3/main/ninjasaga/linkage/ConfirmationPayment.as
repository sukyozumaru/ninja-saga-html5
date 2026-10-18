package ninjasaga.linkage
{
   import adobe.utils.*;
   import flash.accessibility.*;
   import flash.desktop.*;
   import flash.display.*;
   import flash.errors.*;
   import flash.events.*;
   import flash.external.*;
   import flash.filters.*;
   import flash.geom.*;
   import flash.globalization.*;
   import flash.media.*;
   import flash.net.*;
   import flash.net.drm.*;
   import flash.printing.*;
   import flash.profiler.*;
   import flash.sampler.*;
   import flash.sensors.*;
   import flash.system.*;
   import flash.text.*;
   import flash.text.engine.*;
   import flash.text.ime.*;
   import flash.ui.*;
   import flash.utils.*;
   import flash.xml.*;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol686")]
   public dynamic class ConfirmationPayment extends MovieClip
   {
      
      public var expiryDayBtn_0:MovieClip;
      
      public var displayTxt:TextField;
      
      public var cooldownTxt:TextField;
      
      public var expiryDayBtn_2:MovieClip;
      
      public var skillTypeIcon:MovieClip;
      
      public var cpTxt:TextField;
      
      public var iconChakra:MovieClip;
      
      public var lbl_yourmagatama:TextField;
      
      public var clickMask:MovieClip;
      
      public var yourMagatamaMc:MovieClip;
      
      public var noBtn:SimpleButton;
      
      public var lbl_ninjaemblem_title:TextField;
      
      public var iconMC:MovieClip;
      
      public var iconLv:MovieClip;
      
      public var lvTxt:TextField;
      
      public var healTxt:TextField;
      
      public var quantityBox:MovieClip;
      
      public var healIcon:MovieClip;
      
      public var iconCooldown:MovieClip;
      
      public var boxMC:MovieClip;
      
      public var emblemMc:MovieClip;
      
      public var ownTxt:TextField;
      
      public var damageTxt:TextField;
      
      public var expiryDayBtn_1:MovieClip;
      
      public var damageIcon:MovieClip;
      
      public function ConfirmationPayment()
      {
         super();
         addFrameScript(0,this.frame1,5,this.frame6,9,this.frame10,13,this.frame14,17,this.frame18);
      }
      
      internal function frame1() : *
      {
         this.stop();
      }
      
      internal function frame6() : *
      {
         this.stop();
         this.onShowBuySellQuantity(this);
      }
      
      internal function frame10() : *
      {
         this.stop();
         this.onShowSkill(this);
      }
      
      internal function frame14() : *
      {
         this.stop();
         MovieClip(parent).onShowBuySellQuantity(this);
      }
      
      internal function frame18() : *
      {
         this.stop();
         this.onShowMaga(this);
      }
   }
}

