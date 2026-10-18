package ninjasaga.linkage
{
   import flash.display.MovieClip;
   import ninjasaga.Main;
   
   [SWF(width="550", height="400", backgroundColor="#ffffff", frameRate="24")]
   public class CodeLibrary extends MovieClip
   {
      
      public const codec:String = "85224034668";
      
      public function CodeLibrary()
      {
         var _loc1_:§_o_-_--§ = new §_o_-_--§();
         if(!_loc1_.§_o_---_§(this))
         {
            return;
         }
         super();
      }
      
      public function setMainMc(param1:MovieClip) : void
      {
         Main.setMainMc(param1);
         Main.initAmf();
         Main.cls = String(this.loaderInfo.bytesLoaded);
      }
   }
}

