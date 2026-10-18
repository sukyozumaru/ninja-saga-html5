package ninja_saga_fla
{
   import flash.display.MovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol324")]
   public dynamic class lucky_roulette_ani_120 extends MovieClip
   {
      
      public var circleMc:MovieClip;
      
      public function lucky_roulette_ani_120()
      {
         super();
         addFrameScript(0,this.frame1,24,this.frame25);
      }
      
      internal function frame1() : *
      {
         stop();
      }
      
      internal function frame25() : *
      {
         gotoAndPlay(2);
      }
   }
}

