package gs.plugins
{
   import bitemycode.net.zendamf.*;
   import flash.display.*;
   import flash.events.ErrorEvent;
   import flash.events.TimerEvent;
   import gs.*;
   import gs.utils.tween.*;
   
   public class EndArrayPlugin extends TweenPlugin
   {
      
      public static const VERSION:Number = 1.01;
      
      public static const API:Number = 1;
      
      protected var _a:Array;
      
      protected var _info:Array = [];
      
      public function EndArrayPlugin()
      {
         super();
         this.propName = "endArray";
         this.overwriteProps = ["endArray"];
      }
      
      override public function onInitTween(param1:Object, param2:*, param3:TweenLite) : Boolean
      {
         if(!(param1 is Array) || !(param2 is Array))
         {
            return false;
         }
         init(param1 as Array,param2);
         return true;
      }
      
      public function init(param1:Array, param2:Array) : void
      {
         _a = param1;
         var _loc3_:* = int(param2.length - 1);
         while(_loc3_ > -1)
         {
            if(param1[_loc3_] != param2[_loc3_] && param1[_loc3_] != null)
            {
               _info[_info.length] = new ArrayTweenInfo(_loc3_,_a[_loc3_],param2[_loc3_] - _a[_loc3_]);
            }
            _loc3_--;
         }
      }
      
      override public function set changeFactor(param1:Number) : void
      {
         var _loc2_:* = 0;
         var _loc3_:ArrayTweenInfo = null;
         var _loc4_:Number = NaN;
         var _loc5_:int = 0;
         if(this.round)
         {
            _loc2_ = int(_info.length - 1);
            while(_loc2_ > -1)
            {
               _loc3_ = _info[_loc2_];
               _loc4_ = _loc3_.start + _loc3_.change * param1;
               _loc5_ = _loc4_ < 0 ? -1 : 1;
               _a[_loc3_.index] = _loc4_ % 1 * _loc5_ > 0.5 ? int(_loc4_) + _loc5_ : int(_loc4_);
               _loc2_--;
            }
         }
         else
         {
            _loc2_ = int(_info.length - 1);
            while(_loc2_ > -1)
            {
               _loc3_ = _info[_loc2_];
               _a[_loc3_.index] = _loc3_.start + _loc3_.change * param1;
               _loc2_--;
            }
         }
      }
   }
}

