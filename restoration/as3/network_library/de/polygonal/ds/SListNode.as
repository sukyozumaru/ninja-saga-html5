package de.polygonal.ds
{
   public class SListNode implements LinkedListNode
   {
      
      public var data:*;
      
      public var next:SListNode;
      
      public function SListNode(param1:*)
      {
         super();
         this.data = param1;
         this.next = null;
      }
      
      public function insertAfter(param1:SListNode) : void
      {
         param1.next = this.next;
         this.next = param1;
      }
      
      public function toString() : String
      {
         return "[SListNode, data=" + this.data + "]";
      }
   }
}

