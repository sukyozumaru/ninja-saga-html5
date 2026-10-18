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
   
   [Embed(source="/_assets/assets.swf", symbol="symbol1670")]
   public dynamic class popup_pet_upgrade_with_mat_536 extends MovieClip
   {
      
      public var panelMC:MovieClip;
      
      public function popup_pet_upgrade_with_mat_536()
      {
         super();
         addFrameScript(0,this.frame1,18,this.frame19,24,this.frame25,49,this.frame50);
      }
      
      internal function frame1() : *
      {
         this.stop();
      }
      
      internal function frame19() : *
      {
         MovieClip(parent).onShowPetUpgradeWithMaterial(this);
      }
      
      internal function frame25() : *
      {
         this.stop();
      }
      
      internal function frame50() : *
      {
         this.gotoAndStop("idle");
      }
   }
}

