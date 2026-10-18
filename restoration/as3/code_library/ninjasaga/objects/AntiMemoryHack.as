package ninjasaga.objects
{
   import com.utils.Out;
   import flash.geom.Point;
   import ninjasaga.*;
   
   public class AntiMemoryHack
   {
      
      public static const ANTIMEMORYHACK_SECURITY_TYPE_NULL:int = 0;
      
      public static const ANTIMEMORYHACK_SECURITY_TYPE_1000:int = 1;
      
      public static const ANTIMEMORYHACK_SECURITY_TYPE_2464A3A2:int = 2;
      
      private static var grp:Array = [];
      
      private var securityType:int = 0;
      
      private var intTestValue1:int = Math.random() * int.MAX_VALUE;
      
      private var intTestValue2:int = Math.random() * int.MAX_VALUE;
      
      private var doubleTestValue1:Number = Math.random() * Number.MAX_VALUE;
      
      private var intPlusOneValue1:int = Math.random() * int.MAX_VALUE;
      
      private var intPlusOneValue2:int = Math.random() * int.MAX_VALUE;
      
      private var doubleMultiThousandValue1:Number = Math.random() * Number.MAX_VALUE;
      
      public function AntiMemoryHack(param1:int)
      {
         super();
         securityType = param1;
         setCheckValues(param1);
      }
      
      public static function copyInstance(param1:int) : AntiMemoryHack
      {
         var _loc2_:AntiMemoryHack = new AntiMemoryHack(param1);
         AntiMemoryHack.grp.push(_loc2_);
         return _loc2_;
      }
      
      public static function check() : Boolean
      {
         var _loc1_:AntiMemoryHack = null;
         for each(_loc1_ in grp)
         {
            if(_loc1_.check() == false)
            {
               return false;
            }
         }
         return true;
      }
      
      private function setCheckValues(param1:int) : void
      {
         switch(securityType)
         {
            case ANTIMEMORYHACK_SECURITY_TYPE_1000:
               doubleTestValue1 = 0.01;
               doubleMultiThousandValue1 = 10;
               break;
            case ANTIMEMORYHACK_SECURITY_TYPE_2464A3A2:
               intTestValue1 = 610575266;
               intTestValue2 = 2728616996;
               intPlusOneValue1 = 610575267;
               intPlusOneValue2 = 2728616997;
         }
      }
      
      public function check() : Boolean
      {
         switch(securityType)
         {
            case ANTIMEMORYHACK_SECURITY_TYPE_1000:
               return doubleTestValue1 * 1000 == doubleMultiThousandValue1;
            case ANTIMEMORYHACK_SECURITY_TYPE_2464A3A2:
               return intTestValue1 + 1 == intPlusOneValue1 && intTestValue2 + 1 == intPlusOneValue2;
            default:
               return false;
         }
      }
   }
}

