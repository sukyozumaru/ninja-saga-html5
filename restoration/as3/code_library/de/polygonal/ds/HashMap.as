package de.polygonal.ds
{
   import flash.utils.Dictionary;
   
   public class HashMap implements Collection, DummyInterface
   {
      
      private var _keyMap:Dictionary;
      
      private var _dupMap:Dictionary;
      
      private var _initSize:int;
      
      private var _maxSize:int;
      
      private var _size:int;
      
      private var _pair:PairNode;
      
      private var _head:PairNode;
      
      private var _tail:PairNode;
      
      public function HashMap(param1:int = 500)
      {
         super();
         _initSize = _maxSize = Math.max(10,param1);
         _keyMap = new Dictionary(true);
         _dupMap = new Dictionary(true);
         _size = 0;
         var _loc2_:PairNode = new PairNode();
         _head = _tail = _loc2_;
         var _loc3_:int = _initSize + 1;
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            _loc2_.next = new PairNode();
            _loc2_ = _loc2_.next;
            _loc4_++;
         }
         _tail = _loc2_;
      }
      
      public function insert(param1:*, param2:*) : Boolean
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         if(param1 == null)
         {
            return false;
         }
         if(param2 == null)
         {
            return false;
         }
         if(_keyMap[param1])
         {
            return false;
         }
         if(_size++ == _maxSize)
         {
            _loc4_ = (_maxSize = _maxSize + _initSize) + 1;
            _loc5_ = 0;
            while(_loc5_ < _loc4_)
            {
               _tail.next = new PairNode();
               _tail = _tail.next;
               _loc5_++;
            }
         }
         var _loc3_:PairNode = _head;
         _head = _head.next;
         _loc3_.key = param1;
         _loc3_.obj = param2;
         _loc3_.next = _pair;
         if(_pair)
         {
            _pair.prev = _loc3_;
         }
         _pair = _loc3_;
         _keyMap[param1] = _loc3_;
         if(_dupMap[param2])
         {
            var _loc6_:Dictionary = _dupMap;
            §§push(_loc6_);
            var _temp_5:* = param2;
            var _loc7_:* = param2;
            var _loc8_:Number = §§pop()[_loc7_] + 1;
            _loc6_[_loc7_] = _loc8_;
         }
         else
         {
            _dupMap[param2] = 1;
         }
         return true;
      }
      
      public function find(param1:*) : *
      {
         var _loc2_:PairNode = _keyMap[param1];
         if(_loc2_)
         {
            return _loc2_.obj;
         }
         return null;
      }
      
      public function remove(param1:*) : *
      {
         var _loc3_:* = undefined;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc2_:PairNode = _keyMap[param1];
         if(_loc2_)
         {
            _loc3_ = _loc2_.obj;
            delete _keyMap[param1];
            if(_loc2_.prev)
            {
               _loc2_.prev.next = _loc2_.next;
            }
            if(_loc2_.next)
            {
               _loc2_.next.prev = _loc2_.prev;
            }
            if(_loc2_ == _pair)
            {
               _pair = _loc2_.next;
            }
            _loc2_.prev = null;
            _loc2_.next = null;
            _tail.next = _loc2_;
            _tail = _loc2_;
            if(--_dupMap[_loc3_] <= 0)
            {
               delete _dupMap[_loc3_];
            }
            if(--_size <= _maxSize - _initSize)
            {
               _loc4_ = (_maxSize = _maxSize - _initSize) + 1;
               _loc5_ = 0;
               while(_loc5_ < _loc4_)
               {
                  _head = _head.next;
                  _loc5_++;
               }
            }
            return _loc3_;
         }
         return null;
      }
      
      public function containsKey(param1:*) : Boolean
      {
         return _keyMap[param1] != undefined;
      }
      
      public function getKeySet() : Array
      {
         var _loc2_:* = 0;
         var _loc3_:PairNode = null;
         var _loc1_:Array = new Array(_size);
         for each(_loc3_ in _keyMap)
         {
            var _loc6_:Number;
            _loc1_[_loc6_ = _loc2_++] = _loc3_.key;
         }
         return _loc1_;
      }
      
      public function contains(param1:*) : Boolean
      {
         return _dupMap[param1] > 0;
      }
      
      public function clear() : void
      {
         var _loc1_:PairNode = null;
         _keyMap = new Dictionary(true);
         _dupMap = new Dictionary(true);
         var _loc2_:PairNode = _pair;
         while(_loc2_)
         {
            _loc1_ = _loc2_.next;
            _loc2_.next = _loc2_.prev = null;
            _loc2_.key = null;
            _loc2_.obj = null;
            _tail.next = _loc2_;
            _tail = _tail.next;
            _loc2_ = _loc1_;
         }
         _pair = null;
         _size = 0;
      }
      
      public function getIterator() : Iterator
      {
         return new HashMapIterator(_pair);
      }
      
      public function get size() : int
      {
         return _size;
      }
      
      public function isEmpty() : Boolean
      {
         return _size == 0;
      }
      
      public function toArray() : Array
      {
         var _loc2_:* = 0;
         var _loc3_:PairNode = null;
         var _loc1_:Array = new Array(_size);
         for each(_loc3_ in _keyMap)
         {
            var _loc6_:Number;
            _loc1_[_loc6_ = _loc2_++] = _loc3_.obj;
         }
         return _loc1_;
      }
      
      public function toString() : String
      {
         return "[HashMap, size=" + size + "]";
      }
      
      public function dump() : String
      {
         var _loc2_:PairNode = null;
         var _loc1_:String = "HashMap:\n";
         for each(_loc2_ in _keyMap)
         {
            _loc1_ += "[key: " + _loc2_.key + ", val:" + _loc2_.obj + "]\n";
         }
         return _loc1_;
      }
   }
}

import de.polygonal.ds.DummyInterface;
import de.polygonal.ds.Iterator;

class PairNode
{
   
   public var key:*;
   
   public var obj:*;
   
   public var prev:PairNode;
   
   public var next:PairNode;
   
   public function PairNode()
   {
      super();
   }
}

class HashMapIterator implements Iterator, DummyInterface
{
   
   private var _pair:PairNode;
   
   private var _walker:PairNode;
   
   public function HashMapIterator(param1:PairNode)
   {
      super();
      _pair = _walker = param1;
   }
   
   public function get data() : *
   {
      return _walker.obj;
   }
   
   public function set data(param1:*) : void
   {
      _walker.obj = param1;
   }
   
   public function start() : void
   {
      _walker = _pair;
   }
   
   public function hasNext() : Boolean
   {
      return _walker != null;
   }
   
   public function next() : *
   {
      var _loc1_:* = _walker.obj;
      _walker = _walker.next;
      return _loc1_;
   }
}
