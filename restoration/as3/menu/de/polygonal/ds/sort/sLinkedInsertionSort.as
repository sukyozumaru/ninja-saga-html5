package de.polygonal.ds.sort
{
   import de.polygonal.ds.SListNode;
   
   public function sLinkedInsertionSort(node:SListNode, descending:Boolean = false) : SListNode
   {
      var j:* = 0;
      var val:Number = NaN;
      var a:Array = [];
      var k:* = 0;
      var h:SListNode = node;
      var n:SListNode = node;
      while(n)
      {
         var _loc10_:Number;
         a[_loc10_ = k++] = n.data;
         n = n.next;
      }
      if(k <= 1)
      {
         return h;
      }
      for(var i:* = 1; i < k; i++)
      {
         val = Number(a[i]);
         j = int(i);
         while(j > 0 && a[int(j - 1)] > val)
         {
            a[j] = a[int(j - 1)];
            j--;
         }
         a[j] = val;
      }
      n = h;
      i = 0;
      while(n)
      {
         n.data = a[i++];
         n = n.next;
      }
      return h;
   }
}

