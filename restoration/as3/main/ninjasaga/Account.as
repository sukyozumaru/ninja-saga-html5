package ninjasaga
{
   import com.utils.Out;
   import com.utils.Sha1Encrypt;
   import ninjasaga.data.Data;
   
   public class Account
   {
      
      private static var account_id:uint;
      
      private static var account_type:uint;
      
      private static var account_balance:int;
      
      private static var account_session_key:String;
      
      private static var accountTypeHash:String;
      
      public static const FREE:uint = 1;
      
      public static const PREMIUM:uint = 2;
      
      public function Account()
      {
         super();
      }
      
      public static function setupAccount(param1:Array, param2:String) : Boolean
      {
         var _loc3_:String = null;
         account_session_key = param1[3];
         Data.sessionKey = account_session_key;
         if(Central.main)
         {
            _loc3_ = param1[0] + "|" + param1[1] + "|" + param1[2];
            if(Central.main.getHash(_loc3_) != param2)
            {
               return false;
            }
         }
         if(param1[0] > 0)
         {
            account_id = param1[0];
            accountTypeHash = Sha1Encrypt.encrypt(String(param1[1]));
            account_type = param1[1];
            account_balance = param1[2];
            return true;
         }
         return false;
      }
      
      public static function getAccountId() : uint
      {
         return account_id;
      }
      
      public static function getAccountType() : uint
      {
         if(accountTypeHash == Sha1Encrypt.encrypt(String(account_type)))
         {
            return account_type;
         }
         Out.data("Account","account type mismatch");
         Central.main.submitData();
         return 1;
      }
      
      public static function getAccountTypeNoVerify() : uint
      {
         return account_type;
      }
      
      public static function getAccountBalance() : int
      {
         return account_balance;
      }
      
      public static function getAccountSessionKey() : String
      {
         return account_session_key;
      }
      
      public static function set balance(param1:int) : void
      {
         account_balance = param1;
      }
   }
}

