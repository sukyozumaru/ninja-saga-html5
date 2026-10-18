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
   
   [Embed(source="/_assets/assets.swf", symbol="symbol547")]
   public dynamic class buyType_151 extends MovieClip
   {
      
      public var itemEmblemBtn:MovieClip;
      
      public var requireTxt:TextField;
      
      public var itemFKBtn:MovieClip;
      
      public var kunaiBtn:MovieClip;
      
      public var itemGoldBtn:MovieClip;
      
      public var ortxt:TextField;
      
      public var buyBtn:MovieClip;
      
      public var kunaiMc:MovieClip;
      
      public var itemTokenBtn:MovieClip;
      
      public var requireTxt2:TextField;
      
      public var goldMc:MovieClip;
      
      public var typeTxt:TextField;
      
      public var sellBtn:MovieClip;
      
      public var magatamaMc:MovieClip;
      
      public var tokenMc:MovieClip;
      
      public var tokenBtn:MovieClip;
      
      public function buyType_151()
      {
         super();
         addFrameScript(0,this.frame1,2,this.frame3,5,this.frame6,9,this.frame10,17,this.frame18,20,this.frame21,24,this.frame25,29,this.frame30,34,this.frame35,38,this.frame39,41,this.frame42,44,this.frame45);
      }
      
      internal function frame1() : *
      {
         stop();
      }
      
      internal function frame3() : *
      {
         MovieClip(parent).initBoxItemBuy(this);
         stop();
      }
      
      internal function frame6() : *
      {
         MovieClip(parent).initBoxItemSell(this);
         stop();
      }
      
      internal function frame10() : *
      {
         MovieClip(parent).initBoxFKTokenPay(this);
         stop();
      }
      
      internal function frame18() : *
      {
         MovieClip(parent).initBoxTokenPay(this);
         stop();
      }
      
      internal function frame21() : *
      {
         MovieClip(parent).initBoxGoldPay(this);
         stop();
      }
      
      internal function frame25() : *
      {
         MovieClip(parent).initBoxGoldSell(this);
         stop();
      }
      
      internal function frame30() : *
      {
         MovieClip(parent).initBoxFkTokenBuy(this);
         stop();
      }
      
      internal function frame35() : *
      {
         MovieClip(parent).initBoxFkEmblemTokenBuy(this);
         stop();
      }
      
      internal function frame39() : *
      {
         MovieClip(parent).initBoxMagaTokenPay(this);
         stop();
      }
      
      internal function frame42() : *
      {
         MovieClip(parent).initBoxMagaPay(this);
         stop();
      }
      
      internal function frame45() : *
      {
         MovieClip(parent).initBoxFKEmblemTokenPay(this);
         stop();
      }
   }
}

