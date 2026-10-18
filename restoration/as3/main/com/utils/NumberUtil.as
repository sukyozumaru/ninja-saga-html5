package com.utils
{
   import com.de.polygonal.math.PM_PRNG;
   
   public final class NumberUtil
   {
      
      public function NumberUtil()
      {
         super();
      }
      
      public static function randomNumber(param1:Number, param2:Number) : Number
      {
         return Math.floor((param1 + getRandom() * (param2 - param1)) * 10000) / 10000;
      }
      
      public static function getRandom() : Number
      {
         var _loc1_:* = new PM_PRNG();
         return _loc1_.nextDoubleRange(0,1);
      }
      
      public static function randomInt(param1:int, param2:int) : int
      {
         var _loc3_:* = new PM_PRNG();
         var _loc4_:int = int(_loc3_.nextIntRange(param1,param2));
         if(_loc4_ < param1)
         {
            _loc4_ = param1;
         }
         if(_loc4_ > param2)
         {
            _loc4_ = param2;
         }
         return _loc4_;
      }
   }
}

