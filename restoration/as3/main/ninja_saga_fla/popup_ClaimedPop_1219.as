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
   
   [Embed(source="/_assets/assets.swf", symbol="symbol3039")]
   public dynamic class popup_ClaimedPop_1219 extends MovieClip
   {
      
      public var panelMC:MovieClip;
      
      public function popup_ClaimedPop_1219()
      {
         super();
         addFrameScript(0,this.frame1,7,this.frame8,19,this.frame20);
      }
      
      internal function frame1() : *
      {
         this.stop();
      }
      
      internal function frame8() : *
      {
         MovieClip(parent.parent).onShowGetReward(this);
      }
      
      internal function frame20() : *
      {
         this.gotoAndStop("idle");
      }
   }
}

