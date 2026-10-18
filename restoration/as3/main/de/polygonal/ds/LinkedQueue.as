package de.polygonal.ds
{
   public class LinkedQueue implements Collection
   {
      
      private var _list:SLinkedList;
      
      public function LinkedQueue(param1:SLinkedList = null)
      {
         super();
         if(param1 == null)
         {
            this._list = new SLinkedList();
         }
         else
         {
            this._list = param1;
         }
      }
      
      public function peek() : *
      {
         return this._list.size > 0 ? this._list.head.data : null;
      }
      
      public function back() : *
      {
         return this._list.size > 0 ? this._list.tail.data : null;
      }
      
      public function enqueue(param1:*) : void
      {
         this._list.append(param1);
      }
      
      public function dequeue() : *
      {
         var _loc1_:* = undefined;
         if(this._list.size > 0)
         {
            _loc1_ = this._list.head.data;
            this._list.removeHead();
            return _loc1_;
         }
         return null;
      }
      
      public function contains(param1:*) : Boolean
      {
         return this._list.contains(param1);
      }
      
      public function clear() : void
      {
         this._list.clear();
      }
      
      public function getIterator() : Iterator
      {
         return this._list.getIterator();
      }
      
      public function get size() : int
      {
         return this._list.size;
      }
      
      public function isEmpty() : Boolean
      {
         return this._list.size == 0;
      }
      
      public function toArray() : Array
      {
         return this._list.toArray();
      }
      
      public function toString() : String
      {
         return "[LinkedQueue > " + this._list + "]";
      }
      
      public function dump() : String
      {
         return "LinkedQueue:\n" + this._list.dump();
      }
   }
}

