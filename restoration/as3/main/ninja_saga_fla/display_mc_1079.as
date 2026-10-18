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
   
   [Embed(source="/_assets/assets.swf", symbol="symbol3109")]
   public dynamic class display_mc_1079 extends MovieClip
   {
      
      public var inviteMc:MovieClip;
      
      public var fbNameTxt:TextField;
      
      public var btnRecruit:MovieClip;
      
      public var btnChallenge:SimpleButton;
      
      public var levelTxt:TextField;
      
      public var titleTxt:TextField;
      
      public var btnInvite:MovieClip;
      
      public var nameTxt:TextField;
      
      public var photoHolder:MovieClip;
      
      public var btnVisit:MovieClip;
      
      public function display_mc_1079()
      {
         super();
         addFrameScript(0,this.frame1,1,this.frame2,2,this.frame3,4,this.frame5);
      }
      
      internal function frame1() : *
      {
         this.stop();
      }
      
      internal function frame2() : *
      {
         this.stop();
      }
      
      internal function frame3() : *
      {
         this.stop();
         MovieClip(parent).initInviteBtnFB(this);
      }
      
      internal function frame5() : *
      {
         this.stop();
         MovieClip(parent).initInviteBtnRR(this);
      }
   }
}

