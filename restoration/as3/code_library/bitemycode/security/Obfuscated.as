package bitemycode.security
{
   import flash.utils.Proxy;
   import flash.utils.flash_proxy;
   import ninjasaga.*;
   import ninjasaga.data.BloodlineData;
   import ninjasaga.data.DBCharacterData;
   
   use namespace flash_proxy;
   
   public dynamic class Obfuscated extends Proxy
   {
      
      private var _multiples:Object = {};
      
      private var _additives:Object = {};
      
      private var _subtractives:Object = {};
      
      private var _values:Object = {};
      
      public function Obfuscated()
      {
         super();
      }
      
      override flash_proxy function hasProperty(param1:*) : Boolean
      {
         return _hasProperty(param1);
      }
      
      private function _hasProperty(param1:*) : Boolean
      {
         var _loc3_:String = null;
         var _loc2_:Boolean = false;
         for(_loc3_ in _multiples)
         {
            if(_loc3_ == param1)
            {
               _loc2_ = true;
               break;
            }
         }
         return _loc2_;
      }
      
      override flash_proxy function setProperty(param1:*, param2:*) : void
      {
         if(param2 is int == false && param2 is Number == false)
         {
            return;
         }
         if(_hasProperty(param1) == false)
         {
            _multiples[param1] = Math.random() < 0.5 ? 2 : 3;
            _additives[param1] = Math.floor(Math.random() * 100);
            _subtractives[param1] = Math.floor(Math.random() * 100000);
         }
         _values[param1] = param2 * _multiples[param1] + _additives[param1] - _subtractives[param1];
      }
      
      override flash_proxy function getProperty(param1:*) : *
      {
         var _loc2_:* = undefined;
         if(_hasProperty(param1) == false)
         {
            return 0;
         }
         _loc2_ = _values[param1];
         _loc2_ += _subtractives[param1];
         _loc2_ -= _additives[param1];
         return _loc2_ / _multiples[param1];
      }
   }
}

