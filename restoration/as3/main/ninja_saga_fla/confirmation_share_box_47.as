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
   
   [Embed(source="/_assets/assets.swf", symbol="symbol128")]
   public dynamic class confirmation_share_box_47 extends MovieClip
   {
      
      public var shareBtn:MovieClip;
      
      public var titleTxt:TextField;
      
      public var skipBtn:SimpleButton;
      
      public var iconHolder:MovieClip;
      
      public var feedCaptionTxt:TextField;
      
      public var feedTitleTxt:TextField;
      
      public function confirmation_share_box_47()
      {
         super();
         addFrameScript(0,this.frame1,6,this.frame7);
      }
      
      internal function frame1() : *
      {
         stop();
      }
      
      internal function frame7() : *
      {
         MovieClip(parent).onShareBoxNew();
      }
   }
}

