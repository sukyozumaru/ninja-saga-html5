package menu_fla
{
   import flash.display.MovieClip;
   import ninjasaga.data.AppData;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol411")]
   public dynamic class graphic_scratchCard_smallcopy_39 extends MovieClip
   {
      
      public function graphic_scratchCard_smallcopy_39()
      {
         super();
         addFrameScript(0,this.frame1,5,this.frame6);
      }
      
      internal function frame1() : *
      {
         switch(AppData.type)
         {
            case AppData.RR:
               this.gotoAndStop("rr");
               break;
            default:
               this.stop();
         }
      }
      
      internal function frame6() : *
      {
         stop();
      }
   }
}

