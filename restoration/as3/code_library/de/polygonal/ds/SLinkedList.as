package de.polygonal.ds
{
   import br.com.stimuli.loading.BulkLoader;
   import br.com.stimuli.loading.loadingtypes.*;
   import com.utils.Out;
   import de.polygonal.ds.sort.compare.compareStringCaseInSensitive;
   import de.polygonal.ds.sort.compare.compareStringCaseInSensitiveDesc;
   import de.polygonal.ds.sort.compare.compareStringCaseSensitive;
   import de.polygonal.ds.sort.compare.compareStringCaseSensitiveDesc;
   import de.polygonal.ds.sort.sLinkedInsertionSort;
   import de.polygonal.ds.sort.sLinkedInsertionSortCmp;
   import de.polygonal.ds.sort.sLinkedMergeSort;
   import de.polygonal.ds.sort.sLinkedMergeSortCmp;
   import flash.display.*;
   import flash.events.*;
   import flash.geom.Point;
   import flash.net.*;
   import flash.utils.*;
   import gs.*;
   import ninjasaga.*;
   import ninjasaga.data.DBCharacterData;
   import ninjasaga.data.Data;
   import ninjasaga.data.InventoryData;
   import ninjasaga.data.NPCData;
   import ninjasaga.dbclass.DBCharacter;
   
   public class SLinkedList implements Collection
   {
      
      public static const INSERTION_SORT:int = 1 << 1;
      
      public static const MERGE_SORT:int = 1 << 2;
      
      public static const NUMERIC:int = 1 << 3;
      
      public static const DESCENDING:int = 1 << 4;
      
      private var _count:int;
      
      public var head:SListNode;
      
      public var tail:SListNode;
      
      public function SLinkedList(... rest)
      {
         super();
         head = tail = null;
         _count = 0;
         if(rest.length > 0)
         {
            append.apply(this,rest);
         }
      }
      
      public function append(... rest) : SListNode
      {
         var _loc4_:SListNode = null;
         var _loc5_:int = 0;
         var _loc2_:int = int(rest.length);
         var _loc3_:SListNode = new SListNode(rest[0]);
         if(head)
         {
            tail.next = _loc3_;
            tail = _loc3_;
         }
         else
         {
            head = tail = _loc3_;
         }
         if(_loc2_ > 1)
         {
            _loc4_ = _loc3_;
            _loc5_ = 1;
            while(_loc5_ < _loc2_)
            {
               _loc3_ = new SListNode(rest[_loc5_]);
               tail.next = _loc3_;
               tail = _loc3_;
               _loc5_++;
            }
            _count += _loc2_;
            return _loc4_;
         }
         ++_count;
         return _loc3_;
      }
      
      public function prepend(... rest) : SListNode
      {
         var _loc4_:SListNode = null;
         var _loc5_:* = 0;
         var _loc2_:int = int(rest.length);
         var _loc3_:SListNode = new SListNode(rest[int(_loc2_ - 1)]);
         if(head)
         {
            _loc3_.next = head;
            head = _loc3_;
         }
         else
         {
            head = tail = _loc3_;
         }
         if(_loc2_ > 1)
         {
            _loc4_ = _loc3_;
            _loc5_ = int(_loc2_ - 2);
            while(_loc5_ >= 0)
            {
               _loc3_ = new SListNode(rest[_loc5_]);
               _loc3_.next = head;
               head = _loc3_;
               _loc5_--;
            }
            _count += _loc2_;
            return _loc4_;
         }
         ++_count;
         return _loc3_;
      }
      
      public function insertAfter(param1:SListIterator, param2:*) : SListNode
      {
         var _loc3_:SListNode = null;
         if(param1.list != this)
         {
            return null;
         }
         if(param1.node)
         {
            _loc3_ = new SListNode(param2);
            param1.node.insertAfter(_loc3_);
            if(param1.node == tail)
            {
               tail = param1.node.next;
            }
            ++_count;
            return _loc3_;
         }
         return append(param2);
      }
      
      public function remove(param1:SListIterator) : Boolean
      {
         if(param1.list != this || !param1.node)
         {
            return false;
         }
         var _loc2_:SListNode = head;
         if(param1.node == head)
         {
            param1.forth();
            removeHead();
            return true;
         }
         while(_loc2_.next != param1.node)
         {
            _loc2_ = _loc2_.next;
         }
         param1.forth();
         if(_loc2_.next == tail)
         {
            tail = _loc2_;
         }
         _loc2_.next = param1.node;
         --_count;
         return true;
      }
      
      public function removeHead() : *
      {
         var _loc1_:* = undefined;
         var _loc2_:SListNode = null;
         if(head)
         {
            _loc1_ = head.data;
            if(head == tail)
            {
               head = tail = null;
            }
            else
            {
               _loc2_ = head;
               head = head.next;
               _loc2_.next = null;
               if(head == null)
               {
                  tail = null;
               }
            }
            --_count;
            return _loc1_;
         }
         return null;
      }
      
      public function removeTail() : *
      {
         var _loc1_:* = undefined;
         var _loc2_:SListNode = null;
         if(tail)
         {
            _loc1_ = tail.data;
            if(head == tail)
            {
               head = tail = null;
            }
            else
            {
               _loc2_ = head;
               while(_loc2_.next != tail)
               {
                  _loc2_ = _loc2_.next;
               }
               tail = _loc2_;
               _loc2_.next = null;
            }
            --_count;
            return _loc1_;
         }
         return null;
      }
      
      public function merge(... rest) : void
      {
         var _loc2_:SLinkedList = null;
         if(rest.length == 0)
         {
            return;
         }
         _loc2_ = rest[0];
         if(_loc2_.head)
         {
            if(head)
            {
               tail.next = _loc2_.head;
               tail = _loc2_.tail;
            }
            else
            {
               head = _loc2_.head;
               tail = _loc2_.tail;
            }
            _count += _loc2_.size;
         }
         var _loc3_:int = int(rest.length);
         var _loc4_:int = 1;
         while(_loc4_ < _loc3_)
         {
            _loc2_ = rest[_loc4_];
            if(_loc2_.head)
            {
               tail.next = _loc2_.head;
               tail = _loc2_.tail;
               _count += _loc2_.size;
            }
            _loc4_++;
         }
      }
      
      public function concat(... rest) : SLinkedList
      {
         var _loc3_:SLinkedList = null;
         var _loc4_:SListNode = null;
         var _loc2_:SLinkedList = new SLinkedList();
         _loc4_ = head;
         while(_loc4_)
         {
            _loc2_.append(_loc4_.data);
            _loc4_ = _loc4_.next;
         }
         var _loc5_:int = int(rest.length);
         var _loc6_:int = 0;
         while(_loc6_ < _loc5_)
         {
            _loc3_ = rest[_loc6_];
            _loc4_ = _loc3_.head;
            while(_loc4_)
            {
               _loc2_.append(_loc4_.data);
               _loc4_ = _loc4_.next;
            }
            _loc6_++;
         }
         return _loc2_;
      }
      
      public function sort(... rest) : void
      {
         var _loc2_:int = 0;
         var _loc3_:Function = null;
         var _loc4_:* = undefined;
         if(_count <= 1)
         {
            return;
         }
         if(rest.length > 0)
         {
            _loc2_ = 0;
            _loc3_ = null;
            _loc4_ = rest[0];
            if(_loc4_ is Function)
            {
               _loc3_ = _loc4_;
               if(rest.length > 1)
               {
                  _loc4_ = rest[1];
                  if(_loc4_ is int)
                  {
                     _loc2_ = _loc4_;
                  }
               }
            }
            else if(_loc4_ is int)
            {
               _loc2_ = _loc4_;
            }
            if(Boolean(_loc3_))
            {
               if(_loc2_ & 2)
               {
                  head = sLinkedInsertionSortCmp(head,_loc3_,_loc2_ == 18);
               }
               else
               {
                  head = sLinkedMergeSortCmp(head,_loc3_,_loc2_ == 16);
               }
            }
            else if(_loc2_ & 2)
            {
               if(_loc2_ & 4)
               {
                  if(_loc2_ == 22)
                  {
                     head = sLinkedInsertionSortCmp(head,compareStringCaseSensitiveDesc);
                  }
                  else if(_loc2_ == 14)
                  {
                     head = sLinkedInsertionSortCmp(head,compareStringCaseInSensitive);
                  }
                  else if(_loc2_ == 30)
                  {
                     head = sLinkedInsertionSortCmp(head,compareStringCaseInSensitiveDesc);
                  }
                  else
                  {
                     head = sLinkedInsertionSortCmp(head,compareStringCaseSensitive);
                  }
               }
               else
               {
                  head = sLinkedInsertionSort(head,_loc2_ == 18);
               }
            }
            else if(_loc2_ & 4)
            {
               if(_loc2_ == 20)
               {
                  head = sLinkedMergeSortCmp(head,compareStringCaseSensitiveDesc);
               }
               else if(_loc2_ == 12)
               {
                  head = sLinkedMergeSortCmp(head,compareStringCaseInSensitive);
               }
               else if(_loc2_ == 28)
               {
                  head = sLinkedMergeSortCmp(head,compareStringCaseInSensitiveDesc);
               }
               else
               {
                  head = sLinkedMergeSortCmp(head,compareStringCaseSensitive);
               }
            }
            else if(_loc2_ & 0x10)
            {
               head = sLinkedMergeSort(head,true);
            }
         }
         else
         {
            head = sLinkedMergeSort(head);
         }
      }
      
      public function nodeOf(param1:*, param2:SListIterator = null) : SListIterator
      {
         if(param2 != null)
         {
            if(param2.list != null)
            {
               return null;
            }
         }
         var _loc3_:SListNode = param2 == null ? head : param2.node;
         while(_loc3_)
         {
            if(_loc3_.data === param1)
            {
               return new SListIterator(this,_loc3_);
            }
            _loc3_ = _loc3_.next;
         }
         return null;
      }
      
      public function splice(param1:SListIterator, param2:uint = 4294967295, ... rest) : SLinkedList
      {
         var _loc4_:SListNode = null;
         var _loc5_:SListNode = null;
         var _loc6_:SLinkedList = null;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:SListNode = null;
         if(param1)
         {
            if(param1.list != this)
            {
               return null;
            }
         }
         if(param1.node)
         {
            _loc4_ = param1.node;
            _loc5_ = head;
            while(_loc5_.next != _loc4_)
            {
               _loc5_ = _loc5_.next;
            }
            _loc6_ = new SLinkedList();
            if(param2 == 4294967295)
            {
               if(param1.node == tail)
               {
                  return _loc6_;
               }
               while(param1.node)
               {
                  _loc6_.append(param1.node.data);
                  param1.remove();
               }
               param1.list = _loc6_;
               param1.node = _loc4_;
               return _loc6_;
            }
            _loc7_ = 0;
            while(_loc7_ < param2)
            {
               if(!param1.node)
               {
                  break;
               }
               _loc6_.append(param1.node.data);
               param1.remove();
               _loc7_++;
            }
            _loc8_ = int(rest.length);
            if(_loc8_ > 0)
            {
               if(_count == 0)
               {
                  _loc7_ = 0;
                  while(_loc7_ < _loc8_)
                  {
                     append(rest[_loc7_]);
                     _loc7_++;
                  }
               }
               else if(_loc5_ == null)
               {
                  _loc9_ = prepend(rest[0]);
                  _loc7_ = 1;
                  while(_loc7_ < _loc8_)
                  {
                     _loc9_.insertAfter(new SListNode(rest[_loc7_]));
                     if(_loc9_ == tail)
                     {
                        tail = _loc9_.next;
                     }
                     _loc9_ = _loc9_.next;
                     ++_count;
                     _loc7_++;
                  }
               }
               else
               {
                  _loc9_ = _loc5_;
                  _loc7_ = 0;
                  while(_loc7_ < _loc8_)
                  {
                     _loc9_.insertAfter(new SListNode(rest[_loc7_]));
                     if(_loc9_ == tail)
                     {
                        tail = _loc9_.next;
                     }
                     _loc9_ = _loc9_.next;
                     ++_count;
                     _loc7_++;
                  }
               }
               param1.node = _loc9_;
            }
            else
            {
               param1.node = _loc4_;
            }
            param1.list = _loc6_;
            return _loc6_;
         }
         return null;
      }
      
      public function shiftUp() : void
      {
         var _loc1_:SListNode = head;
         if(head.next == tail)
         {
            head = tail;
            tail = _loc1_;
            tail.next = null;
            head.next = tail;
         }
         else
         {
            head = head.next;
            tail.next = _loc1_;
            _loc1_.next = null;
            tail = _loc1_;
         }
      }
      
      public function popDown() : void
      {
         var _loc2_:SListNode = null;
         var _loc1_:SListNode = tail;
         if(head.next == tail)
         {
            tail = head;
            head = _loc1_;
            tail.next = null;
            head.next = tail;
         }
         else
         {
            _loc2_ = head;
            while(_loc2_.next != tail)
            {
               _loc2_ = _loc2_.next;
            }
            tail = _loc2_;
            tail.next = null;
            _loc1_.next = head;
            head = _loc1_;
         }
      }
      
      public function reverse() : void
      {
         if(_count == 0)
         {
            return;
         }
         var _loc1_:Array = new Array(_count);
         var _loc2_:* = 0;
         var _loc3_:SListNode = head;
         while(_loc3_)
         {
            var _loc4_:*;
            _loc1_[_loc4_ = _loc2_++] = _loc3_;
            _loc3_ = _loc3_.next;
         }
         _loc1_.reverse();
         _loc3_ = head = _loc1_[0];
         _loc2_ = 1;
         while(_loc2_ < _count)
         {
            _loc3_.next = _loc4_ = _loc1_[_loc2_];
            _loc3_ = _loc4_;
            _loc2_++;
         }
         _loc3_.next = null;
         tail = _loc3_;
         _loc1_ = null;
      }
      
      public function join(param1:*) : String
      {
         if(_count == 0)
         {
            return "";
         }
         var _loc2_:String = "";
         var _loc3_:SListNode = head;
         while(_loc3_.next)
         {
            _loc2_ += _loc3_.data + param1;
            _loc3_ = _loc3_.next;
         }
         return _loc2_ + _loc3_.data;
      }
      
      public function contains(param1:*) : Boolean
      {
         var _loc2_:SListNode = head;
         while(_loc2_)
         {
            if(_loc2_.data == param1)
            {
               return true;
            }
            _loc2_ = _loc2_.next;
         }
         return false;
      }
      
      public function clear() : void
      {
         var _loc2_:SListNode = null;
         var _loc1_:SListNode = head;
         head = null;
         while(_loc1_)
         {
            _loc2_ = _loc1_.next;
            _loc1_.next = null;
            _loc1_ = _loc2_;
         }
         _count = 0;
      }
      
      public function getIterator() : Iterator
      {
         return new SListIterator(this,head);
      }
      
      public function getListIterator() : SListIterator
      {
         return new SListIterator(this,head);
      }
      
      public function get size() : int
      {
         return _count;
      }
      
      public function isEmpty() : Boolean
      {
         return _count == 0;
      }
      
      public function toArray() : Array
      {
         var _loc1_:Array = [];
         var _loc2_:SListNode = head;
         while(_loc2_)
         {
            _loc1_.push(_loc2_.data);
            _loc2_ = _loc2_.next;
         }
         return _loc1_;
      }
      
      public function toString() : String
      {
         return "[SlinkedList, size=" + size + "]";
      }
      
      public function dump() : String
      {
         if(!head)
         {
            return "SLinkedList: (empty)";
         }
         var _loc1_:String = "SLinkedList: has " + _count + " node" + (_count == 1 ? "" : "s") + "\n|< Head\n";
         var _loc2_:SListIterator = getListIterator();
         while(_loc2_.valid())
         {
            _loc1_ += "\t" + _loc2_.data + "\n";
            _loc2_.forth();
         }
         return _loc1_ + "Tail >|";
      }
   }
}

