package ninja_saga_fla
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
   
   [Embed(source="/_assets/assets.swf", symbol="symbol2592")]
   public dynamic class reset_price_mc_1328 extends MovieClip
   {
      
      public var userTxt2:TextField;
      
      public var userTxt1:TextField;
      
      public var priceMc2:MovieClip;
      
      public var priceMc1:MovieClip;
      
      public var emblemBtn:SimpleButton;
      
      public var emblemBtn2:MovieClip;
      
      public var btnResetSkill:MovieClip;
      
      public function reset_price_mc_1328()
      {
         super();
         addFrameScript(1,this.frame2,6,this.frame7);
      }
      
      internal function frame2() : *
      {
         MovieClip(parent.parent).onFreeUser();
         stop();
      }
      
      internal function frame7() : *
      {
         MovieClip(parent.parent).onPremiumUser();
         stop();
      }
   }
}

