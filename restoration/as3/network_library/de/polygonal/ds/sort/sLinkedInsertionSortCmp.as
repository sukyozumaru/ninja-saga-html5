package de.polygonal.ds.sort
{
   import de.polygonal.ds.SListNode;
   
   public function sLinkedInsertionSortCmp(param1:SListNode, param2:Function, param3:Boolean = false) : SListNode
   {
      var _loc8_:* = 0;
      var _loc9_:* = 0;
      var _loc10_:* = undefined;
      var _loc4_:Array = [];
      var _loc5_:* = 0;
      var _loc6_:SListNode = param1;
      var _loc7_:SListNode = param1;
      while(_loc7_)
      {
         var _loc11_:Number;
         _loc4_[_loc11_ = _loc5_++] = _loc7_.data;
         _loc7_ = _loc7_.next;
      }
      if(param3)
      {
         if(_loc5_ <= 1)
         {
            return _loc6_;
         }
         _loc9_ = 1;
         while(_loc9_ < _loc5_)
         {
            _loc10_ = _loc4_[_loc9_];
            _loc8_ = int(_loc9_);
            while(_loc8_ > 0 && param2(_loc4_[int(_loc8_ - 1)],_loc10_) < 0)
            {
               _loc4_[_loc8_] = _loc4_[int(_loc8_ - 1)];
               _loc8_--;
            }
            _loc4_[_loc8_] = _loc10_;
            _loc9_++;
         }
      }
      else
      {
         if(_loc5_ <= 1)
         {
            return _loc6_;
         }
         _loc9_ = 1;
         while(_loc9_ < _loc5_)
         {
            _loc10_ = _loc4_[_loc9_];
            _loc8_ = int(_loc9_);
            while(_loc8_ > 0 && param2(_loc4_[int(_loc8_ - 1)],_loc10_) > 0)
            {
               _loc4_[_loc8_] = _loc4_[int(_loc8_ - 1)];
               _loc8_--;
            }
            _loc4_[_loc8_] = _loc10_;
            _loc9_++;
         }
      }
      _loc7_ = _loc6_;
      _loc9_ = 0;
      while(_loc7_)
      {
         _loc7_.data = _loc4_[_loc9_++];
         _loc7_ = _loc7_.next;
      }
      return _loc6_;
   }
}

