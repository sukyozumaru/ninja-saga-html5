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
   
   [Embed(source="/_assets/assets.swf", symbol="symbol2121")]
   public dynamic class Timeline_936 extends MovieClip
   {
      
      public var enemyMc1:MovieClip;
      
      public var partyMc2_pvp:MovieClip;
      
      public var partyMc2:MovieClip;
      
      public var partyMc1:MovieClip;
      
      public var partyMc1_pvp:MovieClip;
      
      public var playerMc_pvp:MovieClip;
      
      public var playerMc:MovieClip;
      
      public var enemyMc2:MovieClip;
      
      public var enemyMc3:MovieClip;
      
      public var nameTxt:TextField;
      
      public function Timeline_936()
      {
         super();
         addFrameScript(0,this.frame1,4,this.frame5,28,this.frame29);
      }
      
      internal function frame1() : *
      {
         this.stop();
      }
      
      internal function frame5() : *
      {
         MovieClip(this.parent).addCloseup();
      }
      
      internal function frame29() : *
      {
         this.gotoAndStop(1);
      }
   }
}

