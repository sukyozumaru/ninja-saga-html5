package ninjasaga.linkage
{
   import flash.display.MovieClip;
   import ninjasaga.Central;
   import ninjasaga.Socket;
   import ninjasaga.net.Client;
   
   [SWF(width="550", height="400", backgroundColor="#ffffff", frameRate="60")]
   public class NetworkLibrary extends MovieClip
   {
      
      public function NetworkLibrary()
      {
         super();
      }
      
      public function init() : void
      {
         var _loc1_:Socket = new Socket();
         Central.main.socket = _loc1_;
         Central.client = Client;
      }
   }
}

