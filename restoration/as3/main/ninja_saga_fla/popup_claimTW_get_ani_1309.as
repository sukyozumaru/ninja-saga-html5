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
   
   [Embed(source="/_assets/assets.swf", symbol="symbol2631")]
   public dynamic class popup_claimTW_get_ani_1309 extends MovieClip
   {
      
      public var panel:MovieClip;
      
      public function popup_claimTW_get_ani_1309()
      {
         super();
         addFrameScript(0,this.frame1,6,this.frame7,25,this.frame26);
      }
      
      internal function frame1() : *
      {
         this.stop();
      }
      
      internal function frame7() : *
      {
         MovieClip(parent.parent).onClaim();
      }
      
      internal function frame26() : *
      {
         this.gotoAndStop("idle");
      }
   }
}

