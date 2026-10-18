package de.polygonal.ds
{
   public class SListIterator implements Iterator
   {
      
      public var node:SListNode;
      
      public var list:SLinkedList;
      
      public function SListIterator(param1:SLinkedList = null, param2:SListNode = null)
      {
         super();
         this.list = param1;
         this.node = param2;
      }
      
      public function start() : void
      {
         if(this.list)
         {
            this.node = this.list.head;
         }
      }
      
      public function next() : *
      {
         var _loc1_:* = undefined;
         if(this.hasNext())
         {
            _loc1_ = this.node.data;
            this.node = this.node.next;
            return _loc1_;
         }
         return null;
      }
      
      public function hasNext() : Boolean
      {
         return Boolean(this.node);
      }
      
      public function get data() : *
      {
         if(this.node)
         {
            return this.node.data;
         }
         return null;
      }
      
      public function set data(param1:*) : void
      {
         this.node.data = param1;
      }
      
      public function end() : void
      {
         if(this.list)
         {
            this.node = this.list.tail;
         }
      }
      
      public function forth() : void
      {
         if(this.node)
         {
            this.node = this.node.next;
         }
      }
      
      public function valid() : Boolean
      {
         return Boolean(this.node);
      }
      
      public function remove() : Boolean
      {
         return this.list.remove(this);
      }
      
      public function toString() : String
      {
         return "{SListIterator: data=" + this.node.data + "}";
      }
   }
}

