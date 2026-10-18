package de.polygonal.ds
{
   public class LinkedQueue implements Collection
   {
      
      private var _list:SLinkedList;
      
      public function LinkedQueue(list:SLinkedList = null)
      {
         super();
         if(list == null)
         {
            this._list = new SLinkedList();
         }
         else
         {
            this._list = list;
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
      
      public function enqueue(obj:*) : void
      {
         this._list.append(obj);
      }
      
      public function dequeue() : *
      {
         var front:* = undefined;
         if(this._list.size > 0)
         {
            front = this._list.head.data;
            this._list.removeHead();
            return front;
         }
         return null;
      }
      
      public function contains(obj:*) : Boolean
      {
         return this._list.contains(obj);
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

