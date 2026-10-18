package ninja_saga_fla
{
   import flash.display.MovieClip;
   import ninjasaga.data.AppData;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol2096")]
   public dynamic class battle_atb_mc_926 extends MovieClip
   {
      
      public var holder:MovieClip;
      
      public function battle_atb_mc_926()
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

