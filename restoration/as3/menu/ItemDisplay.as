package
{
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol1797")]
   public dynamic class ItemDisplay extends MovieClip
   {
      
      public var upgradeIcon:MovieClip;
      
      public var highlight:MovieClip;
      
      public var msgTxt:TextField;
      
      public var iconMC:MovieClip;
      
      public var levelTxt:TextField;
      
      public var btnEquip:MovieClip;
      
      public var nameTxt:TextField;
      
      public function ItemDisplay()
      {
         super();
         addFrameScript(0,this.frame1,5,this.frame6);
      }
      
      internal function frame1() : *
      {
         this.stop();
      }
      
      internal function frame6() : *
      {
         this.stop();
      }
   }
}

