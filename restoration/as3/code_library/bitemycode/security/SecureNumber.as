package bitemycode.security
{
   import com.utils.Sha1Encrypt;
   import ninjasaga.*;
   
   public class SecureNumber
   {
      
      private var _number:Number;
      
      private var _numberHash:String;
      
      public function SecureNumber(param1:Number = 0)
      {
         super();
         this._number = param1;
         this._numberHash = Sha1Encrypt.encrypt(String(param1));
      }
      
      public function set value(param1:Number) : void
      {
         this._number = param1;
         this._numberHash = Sha1Encrypt.encrypt(String(param1));
      }
      
      public function get value() : Number
      {
         if(Sha1Encrypt.encrypt(String(this._number)) != this._numberHash)
         {
            Central.main.onError();
         }
         return this._number;
      }
   }
}

