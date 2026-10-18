package menu_fla
{
   import flash.display.MovieClip;
   import ninjasaga.data.AppData;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol362")]
   public dynamic class icon_mailBox_18 extends MovieClip
   {
      
      public function icon_mailBox_18()
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

