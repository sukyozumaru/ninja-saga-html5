package de.polygonal.ds
{
   import br.com.stimuli.loading.BulkLoader;
   import ninjasaga.*;
   
   public class LinkedQueue implements Collection
   {
      
      private var _list:SLinkedList;
      
      public function LinkedQueue(param1:SLinkedList = null)
      {
         super();
         if(param1 == null)
         {
            _list = new SLinkedList();
         }
         else
         {
            _list = param1;
         }
      }
      
      public function peek() : *
      {
         return _list.size > 0 ? _list.head.data : null;
      }
      
      public function back() : *
      {
         return _list.size > 0 ? _list.tail.data : null;
      }
      
      public function enqueue(param1:*) : void
      {
         _list.append(param1);
      }
      
      public function dequeue() : *
      {
         var _loc1_:* = undefined;
         if(_list.size > 0)
         {
            _loc1_ = _list.head.data;
            _list.removeHead();
            return _loc1_;
         }
         return null;
      }
      
      public function contains(param1:*) : Boolean
      {
         return _list.contains(param1);
      }
      
      public function clear() : void
      {
         _list.clear();
      }
      
      public function getIterator() : Iterator
      {
         return _list.getIterator();
      }
      
      public function get size() : int
      {
         return _list.size;
      }
      
      public function isEmpty() : Boolean
      {
         return _list.size == 0;
      }
      
      public function toArray() : Array
      {
         return _list.toArray();
      }
      
      public function toString() : String
      {
         return "[LinkedQueue > " + _list + "]";
      }
      
      public function dump() : String
      {
         return "LinkedQueue:\n" + _list.dump();
      }
   }
}

