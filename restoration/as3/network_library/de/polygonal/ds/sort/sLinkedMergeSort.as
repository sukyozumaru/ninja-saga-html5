package de.polygonal.ds.sort
{
   import de.polygonal.ds.SListNode;
   
   public function sLinkedMergeSort(param1:SListNode, param2:Boolean = false) : SListNode
   {
      var _loc4_:SListNode = null;
      var _loc5_:SListNode = null;
      var _loc6_:SListNode = null;
      var _loc7_:SListNode = null;
      var _loc9_:int = 0;
      var _loc10_:* = 0;
      var _loc11_:* = 0;
      var _loc12_:int = 0;
      if(!param1)
      {
         return null;
      }
      var _loc3_:SListNode = param1;
      var _loc8_:int = 1;
      if(param2)
      {
         while(true)
         {
            _loc4_ = _loc3_;
            _loc3_ = _loc7_ = null;
            _loc9_ = 0;
            while(_loc4_)
            {
               _loc9_++;
               _loc12_ = 0;
               _loc10_ = 0;
               _loc5_ = _loc4_;
               while(_loc12_ < _loc8_)
               {
                  _loc10_++;
                  _loc5_ = _loc5_.next;
                  if(!_loc5_)
                  {
                     break;
                  }
                  _loc12_++;
               }
               _loc11_ = _loc8_;
               while(_loc10_ > 0 || Boolean(_loc11_ > 0) && Boolean(_loc5_))
               {
                  if(_loc10_ == 0)
                  {
                     _loc6_ = _loc5_;
                     _loc5_ = _loc5_.next;
                     _loc11_--;
                  }
                  else if(_loc11_ == 0 || !_loc5_)
                  {
                     _loc6_ = _loc4_;
                     _loc4_ = _loc4_.next;
                     _loc10_--;
                  }
                  else if(_loc4_.data - _loc5_.data >= 0)
                  {
                     _loc6_ = _loc4_;
                     _loc4_ = _loc4_.next;
                     _loc10_--;
                  }
                  else
                  {
                     _loc6_ = _loc5_;
                     _loc5_ = _loc5_.next;
                     _loc11_--;
                  }
                  if(_loc7_)
                  {
                     _loc7_.next = _loc6_;
                  }
                  else
                  {
                     _loc3_ = _loc6_;
                  }
                  _loc7_ = _loc6_;
               }
               _loc4_ = _loc5_;
            }
            _loc7_.next = null;
            if(_loc9_ <= 1)
            {
               break;
            }
            _loc8_ <<= 1;
         }
         return _loc3_;
      }
      while(true)
      {
         _loc4_ = _loc3_;
         _loc3_ = _loc7_ = null;
         _loc9_ = 0;
         while(_loc4_)
         {
            _loc9_++;
            _loc12_ = 0;
            _loc10_ = 0;
            _loc5_ = _loc4_;
            while(_loc12_ < _loc8_)
            {
               _loc10_++;
               _loc5_ = _loc5_.next;
               if(!_loc5_)
               {
                  break;
               }
               _loc12_++;
            }
            _loc11_ = _loc8_;
            while(_loc10_ > 0 || Boolean(_loc11_ > 0) && Boolean(_loc5_))
            {
               if(_loc10_ == 0)
               {
                  _loc6_ = _loc5_;
                  _loc5_ = _loc5_.next;
                  _loc11_--;
               }
               else if(_loc11_ == 0 || !_loc5_)
               {
                  _loc6_ = _loc4_;
                  _loc4_ = _loc4_.next;
                  _loc10_--;
               }
               else if(_loc4_.data - _loc5_.data <= 0)
               {
                  _loc6_ = _loc4_;
                  _loc4_ = _loc4_.next;
                  _loc10_--;
               }
               else
               {
                  _loc6_ = _loc5_;
                  _loc5_ = _loc5_.next;
                  _loc11_--;
               }
               if(_loc7_)
               {
                  _loc7_.next = _loc6_;
               }
               else
               {
                  _loc3_ = _loc6_;
               }
               _loc7_ = _loc6_;
            }
            _loc4_ = _loc5_;
         }
         _loc7_.next = null;
         if(_loc9_ <= 1)
         {
            break;
         }
         _loc8_ <<= 1;
      }
      return _loc3_;
   }
}

