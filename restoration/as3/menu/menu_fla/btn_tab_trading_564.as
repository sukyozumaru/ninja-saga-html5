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
   
   [Embed(source="/_assets/assets.swf", symbol="symbol1704")]
   public dynamic class btn_tab_trading_564 extends MovieClip
   {
      
      public var clickMask:MovieClip;
      
      public var btn:MovieClip;
      
      public function btn_tab_trading_564()
      {
         super();
         addFrameScript(0,this.frame1,6,this.frame7);
      }
      
      internal function frame1() : *
      {
         stop();
         MovieClip(parent.parent).onRemoveTab(this);
      }
      
      internal function frame7() : *
      {
         this.stop();
         MovieClip(parent.parent).onTab(this);
      }
   }
}

