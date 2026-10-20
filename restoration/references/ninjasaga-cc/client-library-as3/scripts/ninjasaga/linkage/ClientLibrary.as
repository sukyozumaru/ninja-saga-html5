package ninjasaga.linkage
{
   import com.utils.Sha1Encrypt;
   import flash.display.MovieClip;
   
   [SWF(width="550", height="400", backgroundColor="#ffffff", frameRate="24")]
   public class ClientLibrary extends MovieClip
   {
      
      private var _s:String = "Vmn34aAciYK00Hen26nT01";
      
      public function ClientLibrary()
      {
         super();
      }
      
      public function encrypt(param1:String) : String
      {
         return Sha1Encrypt.encrypt(param1);
      }
      
      public function getLoginHash(param1:String, param2:String) : String
      {
         var _loc3_:String = param2 + this._s;
         return this.generateHash(param1,_loc3_);
      }
      
      public function generateHash(param1:String, param2:String) : String
      {
         var _loc3_:String = param2;
         return Sha1Encrypt.encrypt(_loc3_);
      }
      
      public function getHash(param1:String, param2:String) : String
      {
         var _loc3_:String = param2 + this._s + param1;
         return this.generateHash(param1,_loc3_);
      }
      
      public function getArrayHash(param1:String, param2:Array) : String
      {
         var _loc3_:String = param2.toString() + this._s + param1;
         return this.generateHash(param1,_loc3_);
      }
   }
}

