package com.utils
{
   public class TextFilter
   {
      
      public static var dictionaryList:Array;
      
      public static var blockList:Array;
      
      public function TextFilter()
      {
         super();
      }
      
      public static function isBlockWords(param1:String) : Boolean
      {
         var _loc2_:Boolean = false;
         var _loc3_:int = 0;
         while(_loc3_ < blockList.length)
         {
            if(param1.indexOf(blockList[_loc3_]) >= 0)
            {
               _loc2_ = true;
            }
            _loc3_++;
         }
         return _loc2_;
      }
      
      public static function filter(param1:String) : String
      {
         var _loc3_:RegExp = null;
         var _loc2_:int = 0;
         while(_loc2_ < dictionaryList.length)
         {
            _loc3_ = dictionaryList[_loc2_];
            param1 = regexReplace(_loc3_,param1);
            _loc2_++;
         }
         return param1;
      }
      
      private static function regexReplace(param1:RegExp, param2:String) : String
      {
         var _loc3_:Array = null;
         var _loc4_:String = null;
         var _loc5_:uint = 0;
         while(param1.test(param2) != false)
         {
            _loc3_ = param2.match(param1);
            _loc4_ = "";
            if(_loc3_)
            {
               _loc5_ = 0;
               while(_loc5_ < _loc3_[0].length)
               {
                  _loc4_ += "?";
                  _loc5_++;
               }
            }
            else
            {
               _loc4_ = "?";
            }
            param2 = param2.replace(param1,_loc4_);
         }
         return param2;
      }
      
      public static function regexCheck(param1:RegExp, param2:String) : Boolean
      {
         var _loc3_:Array = null;
         while(param1.test(param2) != false)
         {
            _loc3_ = param2.match(param1);
            if(_loc3_)
            {
               return true;
            }
         }
         return false;
      }
      
      public static function isEng(param1:String) : Boolean
      {
         var _loc2_:RegExp = /^[a-z A-Z 0-9 \- \_]+$/gi;
         return _loc2_.test(param1);
      }
      
      public static function isChi(param1:String) : Boolean
      {
         var _loc2_:RegExp = /^[一-龥]+$/gi;
         return _loc2_.test(param1);
      }
      
      public static function isNotException(param1:String) : Boolean
      {
         if(param1.indexOf("`") == -1 && param1.indexOf("~") == -1 && param1.indexOf("!") == -1 && param1.indexOf("@") == -1 && param1.indexOf("#") == -1 && param1.indexOf("$") == -1 && param1.indexOf("%") == -1 && param1.indexOf("^") == -1 && param1.indexOf("&") == -1 && param1.indexOf("*") == -1 && param1.indexOf("(") == -1 && param1.indexOf(")") == -1 && param1.indexOf("+") == -1 && param1.indexOf("=") == -1 && param1.indexOf("{") == -1 && param1.indexOf("[") == -1 && param1.indexOf("]") == -1 && param1.indexOf("}") == -1 && param1.indexOf("\\") == -1 && param1.indexOf("|") == -1 && param1.indexOf(";") == -1 && param1.indexOf(":") == -1 && param1.indexOf("\'") == -1 && param1.indexOf("\"") == -1 && param1.indexOf(".") == -1 && param1.indexOf("==") == -1 && param1.indexOf("<") == -1 && param1.indexOf(">") == -1 && param1.indexOf(",") == -1 && param1.indexOf("/") == -1 && param1.indexOf("-") == -1 && param1.indexOf("_") == -1 && param1.indexOf("?") == -1)
         {
            return true;
         }
         return false;
      }
   }
}

