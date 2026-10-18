package de.polygonal.ds
{
   public class SListNode implements LinkedListNode
   {
      
      public var data:*;
      
      public var next:SListNode;
      
      public function SListNode(param1:*)
      {
         super();
         data = param1;
         next = null;
      }
      
      public function insertAfter(param1:SListNode) : void
      {
         param1.next = next;
         next = param1;
      }
      
      public function toString() : String
      {
         return "[SListNode, data=" + data + "]";
      }
   }
}

