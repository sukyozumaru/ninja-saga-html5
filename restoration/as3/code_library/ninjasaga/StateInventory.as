package ninjasaga
{
   public final class StateInventory
   {
      
      private var charInvDict:Object = {};
      
      public function StateInventory()
      {
         super();
      }
      
      public function getStateDictionary(param1:int, param2:String, param3:String) : Object
      {
         var _loc4_:Object = null;
         var _loc5_:Object = null;
         var _loc6_:int = 0;
         if(this.charInvDict[param1] != undefined)
         {
            _loc5_ = charInvDict[param1];
            if(_loc5_[param3] != undefined)
            {
               _loc4_ = {};
               _loc6_ = 0;
               while(_loc6_ < _loc5_[param3].length)
               {
                  _loc4_["stateObj" + (_loc6_ + 1)] = _loc5_[param3][_loc6_] + 1;
                  _loc6_++;
               }
               return _loc4_;
            }
         }
         return null;
      }
      
      public function getStateOnCount(param1:int, param2:String, param3:String) : Object
      {
         var _loc4_:Object = null;
         var _loc5_:Object = null;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         if(this.charInvDict[param1] != undefined)
         {
            _loc5_ = charInvDict[param1];
            if(_loc5_[param3] != undefined)
            {
               _loc4_ = {};
               _loc6_ = 0;
               while(_loc6_ < _loc5_[param3].length)
               {
                  _loc7_ += _loc5_[param3][_loc6_] == 1 ? 1 : 0;
                  _loc6_++;
               }
               return _loc7_;
            }
         }
         return -1;
      }
      
      public function setStateDictionary(param1:int, param2:String, param3:String) : void
      {
         var _loc4_:Array = null;
         var _loc6_:int = 0;
         var _loc5_:Object = {};
         if(this.charInvDict[param1] == undefined)
         {
            this.charInvDict[param1] = {};
         }
         _loc4_ = param3.split(",");
         _loc6_ = 0;
         while(_loc6_ < _loc4_.length)
         {
            _loc4_[_loc6_] = parseInt(_loc4_[_loc6_]);
            _loc6_++;
         }
         this.charInvDict[param1][param2] = _loc4_;
      }
   }
}

