package com.utils
{
   public class Delegate
   {
      
      public function Delegate()
      {
         super();
      }
      
      public static function create(param1:Object, param2:Function, ... rest) : Function
      {
         var returnFunction:Function;
         var scope_obj:Object = param1;
         var func:Function = param2;
         var userArguments_array:Array = rest;
         var returnObject:Object = function():*
         {
            var _loc2_:Object = arguments.callee;
            var _loc3_:Array = arguments;
            var _loc4_:Object = _loc2_.scope_obj;
            var _loc5_:Function = _loc2_.func;
            var _loc6_:Array = _loc2_.userArguments_array;
            return _loc5_.apply(_loc4_,_loc3_.concat(_loc6_));
         };
         returnObject.scope_obj = scope_obj;
         returnObject.func = func;
         returnObject.userArguments_array = userArguments_array;
         returnFunction = returnObject as Function;
         return returnFunction;
      }
   }
}

