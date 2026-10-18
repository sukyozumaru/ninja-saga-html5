package ninja_saga_fla
{
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol2671")]
   public dynamic class spinMc_1278 extends MovieClip
   {
      
      public var lbl_spintips:TextField;
      
      public function spinMc_1278()
      {
         super();
         addFrameScript(0,this.frame1,1,this.frame2);
      }
      
      internal function frame1() : *
      {
         stop();
      }
      
      internal function frame2() : *
      {
         stop();
      }
   }
}

