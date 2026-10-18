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
   
   [Embed(source="/_assets/assets.swf", symbol="symbol17")]
   public dynamic class popup_news_board_ani_3 extends MovieClip
   {
      
      public var text:TextField;
      
      public function popup_news_board_ani_3()
      {
         super();
         addFrameScript(0,this.frame1,13,this.frame14,99,this.frame100);
      }
      
      internal function frame1() : *
      {
         stop();
      }
      
      internal function frame14() : *
      {
         MovieClip(parent).onShowAdminMessage();
      }
      
      internal function frame100() : *
      {
         this.gotoAndStop("idle");
      }
   }
}

