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
   
   [Embed(source="/_assets/assets.swf", symbol="symbol182")]
   public dynamic class popup_you_win_ani_56 extends MovieClip
   {
      
      public var panel:MovieClip;
      
      public function popup_you_win_ani_56()
      {
         super();
         addFrameScript(0,this.frame1,10,this.frame11,15,this.frame16,28,this.frame29);
      }
      
      internal function frame1() : *
      {
         this.stop();
      }
      
      internal function frame11() : *
      {
         MovieClip(parent).onShowPasswordPopup(this);
      }
      
      internal function frame16() : *
      {
         this.stop();
      }
      
      internal function frame29() : *
      {
         this.gotoAndStop("idle");
      }
   }
}

