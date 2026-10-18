package menu_fla
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
   
   [Embed(source="/_assets/assets.swf", symbol="symbol1648")]
   public dynamic class pet_buy_skill_mc_517 extends MovieClip
   {
      
      public var lbl_or1:TextField;
      
      public var lbl_or2:TextField;
      
      public var lbl_cost:TextField;
      
      public var goldMc:MovieClip;
      
      public var materialMc:MovieClip;
      
      public var tokenMc:MovieClip;
      
      public function pet_buy_skill_mc_517()
      {
         super();
         addFrameScript(0,this.frame1,3,this.frame4,6,this.frame7,9,this.frame10);
      }
      
      internal function frame1() : *
      {
         this.stop();
      }
      
      internal function frame4() : *
      {
         MovieClip(parent.parent.parent).onShowTokenGoldPay();
         stop();
      }
      
      internal function frame7() : *
      {
         MovieClip(parent.parent.parent).onShowTokenGoldPay();
         stop();
      }
      
      internal function frame10() : *
      {
         MovieClip(parent.parent.parent).onShowTokenGoldPay();
         stop();
      }
   }
}

