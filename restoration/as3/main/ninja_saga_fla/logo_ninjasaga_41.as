package ninja_saga_fla
{
   import flash.display.MovieClip;
   import ninjasaga.data.AppData;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol108")]
   public dynamic class logo_ninjasaga_41 extends MovieClip
   {
      
      public function logo_ninjasaga_41()
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
         this.stop();
      }
   }
}

