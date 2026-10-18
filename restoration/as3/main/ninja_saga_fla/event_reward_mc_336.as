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
   
   [Embed(source="/_assets/assets.swf", symbol="symbol918")]
   public dynamic class event_reward_mc_336 extends MovieClip
   {
      
      public var IconMC0:MovieClip;
      
      public var IconMC1:MovieClip;
      
      public var IconMC2:MovieClip;
      
      public function event_reward_mc_336()
      {
         super();
         addFrameScript(0,this.frame1,3,this.frame4,6,this.frame7,9,this.frame10);
      }
      
      internal function frame1() : *
      {
         this.stop();
      }
      
      internal function frame4() : *
      {
         this.stop();
         MovieClip(parent).updateDailyLoginGiftMc(this);
      }
      
      internal function frame7() : *
      {
         this.stop();
         MovieClip(parent).updateEventGiftBagMc(this);
      }
      
      internal function frame10() : *
      {
         this.stop();
         MovieClip(parent).updateEventGiftBagMc(this);
      }
   }
}

