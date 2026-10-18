package menu_fla
{
   import flash.display.MovieClip;
   import ninjasaga.data.AppData;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol387")]
   public dynamic class graphic_btn_bg_rrcopy_33 extends MovieClip
   {
      
      public function graphic_btn_bg_rrcopy_33()
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
               this.gotoAndStop(2);
         }
      }
      
      internal function frame2() : *
      {
         stop();
      }
   }
}

