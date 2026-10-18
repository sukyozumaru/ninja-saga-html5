package menu_fla
{
   import flash.display.MovieClip;
   import ninjasaga.data.AppData;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol342")]
   public dynamic class graphic_giftbag_6 extends MovieClip
   {
      
      public function graphic_giftbag_6()
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

