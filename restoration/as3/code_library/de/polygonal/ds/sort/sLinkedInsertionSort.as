package de.polygonal.ds.sort
{
   import de.polygonal.ds.SListNode;
   
   public function sLinkedInsertionSort(param1:SListNode, param2:Boolean = false) : SListNode
   {
      var _loc7_:* = 0;
      var _loc8_:Number = NaN;
      var _loc3_:Array = [];
      var _loc4_:* = 0;
      var _loc5_:SListNode = param1;
      var _loc6_:SListNode = param1;
      while(_loc6_)
      {
         var _loc10_:Number;
         _loc3_[_loc10_ = _loc4_++] = _loc6_.data;
         _loc6_ = _loc6_.next;
      }
      if(_loc4_ <= 1)
      {
         return _loc5_;
      }
      var _loc9_:* = 1;
      while(_loc9_ < _loc4_)
      {
         _loc8_ = Number(_loc3_[_loc9_]);
         _loc7_ = int(_loc9_);
         while(_loc7_ > 0 && _loc3_[int(_loc7_ - 1)] > _loc8_)
         {
            _loc3_[_loc7_] = _loc3_[int(_loc7_ - 1)];
            _loc7_--;
         }
         _loc3_[_loc7_] = _loc8_;
         _loc9_++;
      }
      _loc6_ = _loc5_;
      _loc9_ = 0;
      while(_loc6_)
      {
         _loc6_.data = _loc3_[_loc9_++];
         _loc6_ = _loc6_.next;
      }
      return _loc5_;
   }
}

