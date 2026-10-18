package ninja_saga_fla
{
   import flash.display.MovieClip;
   import ninjasaga.data.AppData;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol52")]
   public dynamic class bg_login_graphic_19 extends MovieClip
   {
      
      public function bg_login_graphic_19()
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

