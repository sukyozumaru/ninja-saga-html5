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
   
   [Embed(source="/_assets/assets.swf", symbol="symbol1649")]
   public dynamic class pet_train_confirmMc_511 extends MovieClip
   {
      
      public var lbl_yourmagatama:TextField;
      
      public var yourMaterialMc:MovieClip;
      
      public var trainMethodMC:MovieClip;
      
      public var noBtn:SimpleButton;
      
      public var lbl_confirmation:TextField;
      
      public function pet_train_confirmMc_511()
      {
         super();
         addFrameScript(0,this.frame1,5,this.frame6);
      }
      
      internal function frame1() : *
      {
         stop();
      }
      
      internal function frame6() : *
      {
         MovieClip(parent.parent).onShowConfirmation();
         this.stop();
      }
   }
}

