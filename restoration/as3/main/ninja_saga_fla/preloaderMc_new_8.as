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
   
   [Embed(source="/_assets/assets.swf", symbol="symbol47")]
   public dynamic class preloaderMc_new_8 extends MovieClip
   {
      
      public var percentIcon:TextField;
      
      public var loadingTipsMc:MovieClip;
      
      public var loadingIcon:MovieClip;
      
      public var percentTxt:TextField;
      
      public var statusTxt:TextField;
      
      public var adHolder:MovieClip;
      
      public function preloaderMc_new_8()
      {
         super();
         addFrameScript(0,this.frame1,9,this.frame10);
      }
      
      internal function frame1() : *
      {
         this.stop();
         MovieClip(parent).updateMc();
      }
      
      internal function frame10() : *
      {
         this.stop();
         MovieClip(parent).updateMc();
      }
   }
}

