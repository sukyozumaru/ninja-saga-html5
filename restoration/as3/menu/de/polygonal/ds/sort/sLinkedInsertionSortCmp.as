package de.polygonal.ds.sort
{
   import de.polygonal.ds.SListNode;
   
   public function sLinkedInsertionSortCmp(node:SListNode, cmp:Function, descending:Boolean = false) : SListNode
   {
      var j:* = 0;
      var i:* = 0;
      var val:* = undefined;
      var a:Array = [];
      var k:* = 0;
      var h:SListNode = node;
      var n:SListNode = node;
      while(n)
      {
         var _loc11_:Number;
         a[_loc11_ = k++] = n.data;
         n = n.next;
      }
      if(descending)
      {
         if(k <= 1)
         {
            return h;
         }
         for(i = 1; i < k; i++)
         {
            val = a[i];
            j = int(i);
            while(j > 0 && cmp(a[int(j - 1)],val) < 0)
            {
               a[j] = a[int(j - 1)];
               j--;
            }
            a[j] = val;
         }
      }
      else
      {
         if(k <= 1)
         {
            return h;
         }
         for(i = 1; i < k; i++)
         {
            val = a[i];
            j = int(i);
            while(j > 0 && cmp(a[int(j - 1)],val) > 0)
            {
               a[j] = a[int(j - 1)];
               j--;
            }
            a[j] = val;
         }
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

