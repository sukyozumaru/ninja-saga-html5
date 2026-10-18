package ninja_saga_fla
{
   import flash.display.MovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol1940")]
   public dynamic class arrow_target_857 extends MovieClip
   {
      
      public function arrow_target_857()
      {
         super();
         addFrameScript(0,this.frame1,14,this.frame15);
      }
      
      internal function frame1() : *
      {
         this.stop();
      }
      
      internal function frame15() : *
      {
         this.gotoAndPlay("show");
      }
   }
}

