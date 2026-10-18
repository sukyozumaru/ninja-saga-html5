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
   
   [Embed(source="/_assets/assets.swf", symbol="symbol178")]
   public dynamic class popup_you_win_mc_57 extends MovieClip
   {
      
      public var mcInactivePanel:MovieClip;
      
      public var mcActivePanel:MovieClip;
      
      public function popup_you_win_mc_57()
      {
         super();
         addFrameScript(0,this.frame1,1,this.frame2);
      }
      
      internal function frame1() : *
      {
         this.stop();
         MovieClip(parent.parent).onShowPasswordActive(this);
      }
      
      internal function frame2() : *
      {
         this.stop();
         MovieClip(parent.parent).onShowPasswordInactive(this);
      }
   }
}

