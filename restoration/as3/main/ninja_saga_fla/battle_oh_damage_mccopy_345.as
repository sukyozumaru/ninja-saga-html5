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
   
   [Embed(source="/_assets/assets.swf", symbol="symbol929")]
   public dynamic class battle_oh_damage_mccopy_345 extends MovieClip
   {
      
      public var textMc:MovieClip;
      
      public function battle_oh_damage_mccopy_345()
      {
         super();
         addFrameScript(0,this.frame1,1,this.frame2,21,this.frame22);
      }
      
      internal function frame1() : *
      {
         this.stop();
      }
      
      internal function frame2() : *
      {
         MovieClip(this.parent).onShow("damage");
      }
      
      internal function frame22() : *
      {
         this.gotoAndStop("idle");
      }
   }
}

