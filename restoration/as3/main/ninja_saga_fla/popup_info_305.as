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
   
   [Embed(source="/_assets/assets.swf", symbol="symbol820")]
   public dynamic class popup_info_305 extends MovieClip
   {
      
      public var msgTxt:TextField;
      
      public function popup_info_305()
      {
         super();
         addFrameScript(0,this.frame1,14,this.frame15,48,this.frame49);
      }
      
      internal function frame1() : *
      {
         this.stop();
      }
      
      internal function frame15() : *
      {
         MovieClip(this.parent).onInfo();
      }
      
      internal function frame49() : *
      {
         this.gotoAndPlay("info");
      }
   }
}

