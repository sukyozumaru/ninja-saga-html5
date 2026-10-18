package menu_fla
{
   import flash.display.MovieClip;
   import ninjasaga.data.AppData;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol433")]
   public dynamic class icon_scratchCard_panel_38 extends MovieClip
   {
      
      public var scratch3:MovieClip;
      
      public var scratch2:MovieClip;
      
      public var scratch1:MovieClip;
      
      public function icon_scratchCard_panel_38()
      {
         super();
         addFrameScript(0,this.frame1,1,this.frame2);
      }
      
      internal function frame1() : *
      {
         switch(AppData.type)
         {
            case AppData.RR:
               this.gotoAndStop(2);
               break;
            default:
               this.stop();
         }
      }
      
      internal function frame2() : *
      {
         stop();
      }
   }
}

