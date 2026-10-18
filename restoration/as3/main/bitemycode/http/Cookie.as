package bitemycode.http
{
   import flash.net.SharedObject;
   
   public class Cookie
   {
      
      private var _time:uint;
      
      private var _name:String;
      
      private var _so:SharedObject;
      
      public function Cookie(param1:String = "ninjasaga", param2:uint = 3600)
      {
         super();
         this._name = param1;
         this._time = param2;
         this._so = SharedObject.getLocal(param1,"/");
      }
      
      public function getAll() : Object
      {
         return this._so.data.cookie;
      }
      
      public function clearTimeOut() : void
      {
         var _loc2_:* = undefined;
         var _loc1_:* = this._so.data.cookie;
         if(_loc1_ == undefined)
         {
            return;
         }
         for(_loc2_ in _loc1_)
         {
            if(_loc1_[_loc2_] == undefined || _loc1_[_loc2_].time == undefined || this.isTimeOut(_loc1_[_loc2_].time))
            {
               delete _loc1_[_loc2_];
            }
         }
         this._so.data.cookie = _loc1_;
         this._so.flush();
      }
      
      private function isTimeOut(param1:uint) : Boolean
      {
         var _loc2_:Date = new Date();
         return param1 + this._time * 1000 < _loc2_.getTime();
      }
      
      public function getTimeOut() : uint
      {
         return this._time;
      }
      
      public function getName() : String
      {
         return this._name;
      }
      
      public function clear() : void
      {
         this._so.clear();
      }
      
      public function put(param1:String, param2:*) : void
      {
         var _loc5_:Object = null;
         var _loc3_:Date = new Date();
         var _loc4_:Object = new Object();
         param1 = "key_" + param1;
         _loc4_.time = _loc3_.getTime();
         _loc4_.value = param2;
         if(this._so.data.cookie == undefined)
         {
            _loc5_ = {};
            _loc5_[param1] = _loc4_;
            this._so.data.cookie = _loc5_;
         }
         else
         {
            this._so.data.cookie[param1] = _loc4_;
         }
         this._so.flush();
      }
      
      public function remove(param1:String) : void
      {
         if(this.isExist(param1))
         {
            delete this._so.data.cookie["key_" + param1];
            this._so.flush();
         }
      }
      
      public function get(param1:String) : Object
      {
         return this.isExist(param1) ? this._so.data.cookie["key_" + param1].value : null;
      }
      
      public function isExist(param1:String) : Boolean
      {
         param1 = "key_" + param1;
         return this._so.data.cookie != undefined && this._so.data.cookie[param1] != undefined;
      }
   }
}

