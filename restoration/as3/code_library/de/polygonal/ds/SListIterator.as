package de.polygonal.ds
{
   import com.utils.Out;
   import flash.display.MovieClip;
   import gs.*;
   import gs.plugins.*;
   import gs.utils.tween.*;
   import ninjasaga.Central;
   import ninjasaga.asset.*;
   
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
         if(list)
         {
            node = list.head;
         }
      }
      
      public function next() : *
      {
         var _loc1_:* = undefined;
         if(hasNext())
         {
            _loc1_ = node.data;
            node = node.next;
            return _loc1_;
         }
         return null;
      }
      
      public function hasNext() : Boolean
      {
         return Boolean(node);
      }
      
      public function get data() : *
      {
         if(node)
         {
            return node.data;
         }
         return null;
      }
      
      public function set data(param1:*) : void
      {
         node.data = param1;
      }
      
      public function end() : void
      {
         if(list)
         {
            node = list.tail;
         }
      }
      
      public function forth() : void
      {
         if(node)
         {
            node = node.next;
         }
      }
      
      public function valid() : Boolean
      {
         return Boolean(node);
      }
      
      public function remove() : Boolean
      {
         return list.remove(this);
      }
      
      public function toString() : String
      {
         return "{SListIterator: data=" + node.data + "}";
      }
   }
}

