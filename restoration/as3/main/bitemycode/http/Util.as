package bitemycode.http
{
   import flash.net.URLRequest;
   import flash.net.navigateToURL;
   
   public class Util
   {
      
      public function Util()
      {
         super();
      }
      
      public static function gotoUrlBlank(param1:String) : void
      {
         var _loc2_:URLRequest = new URLRequest(param1);
         navigateToURL(_loc2_,"_blank");
      }
   }
}

