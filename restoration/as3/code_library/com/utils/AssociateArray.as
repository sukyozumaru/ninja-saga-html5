package com.utils
{
   import br.com.stimuli.loading.*;
   import br.com.stimuli.loading.loadingtypes.*;
   import flash.display.*;
   import flash.events.*;
   import flash.net.*;
   import flash.utils.*;
   import ninjasaga.*;
   import ninjasaga.battle.*;
   import ninjasaga.data.BattleData;
   import ninjasaga.data.DBCharacterData;
   import ninjasaga.data.InventoryData;
   import ninjasaga.dbclass.DBCharacter;
   
   public class AssociateArray
   {
      
      private var storedObj:Object;
      
      private var storedArr:Array = [];
      
      public function AssociateArray(param1:Object = null, param2:Object = null, param3:Object = null)
      {
         var _loc4_:* = undefined;
         super();
         if(param1 == null)
         {
            this.storedObj = {};
         }
         else
         {
            this.storedObj = param1;
            for each(_loc4_ in this.storedObj)
            {
               this.storedArr.push(_loc4_);
            }
            if(param2)
            {
               this.sortOn(param2,param3);
            }
         }
      }
      
      public function contains(param1:*) : Boolean
      {
         if(this.storedObj[param1])
         {
            return true;
         }
         return false;
      }
      
      public function addItem(param1:*, param2:*) : void
      {
         this.storedObj[param1] = param2;
         this.storedArr.push(param2);
      }
      
      public function getById(param1:*) : *
      {
         return this.storedObj[param1];
      }
      
      public function getByPos(param1:uint) : *
      {
         return this.storedArr[param1];
      }
      
      public function removeById(param1:*) : *
      {
         var _loc2_:uint = 0;
         if(this.contains(param1))
         {
            _loc2_ = uint(this.storedArr.indexOf(this.storedObj[param1]));
            this.storedObj[param1] = null;
            return this.storedArr.splice(_loc2_,1)[0];
         }
         return null;
      }
      
      public function removeByPos(param1:uint) : *
      {
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         if(this.storedArr.length <= param1)
         {
            _loc2_ = this.storedArr[param1];
            for(_loc3_ in this.storedObj)
            {
               if(this.storedObj[_loc3_] == _loc2_)
               {
                  this.storedObj[_loc3_] = null;
               }
            }
            return this.storedArr.splice(param1,1)[0];
         }
         return null;
      }
      
      public function sort() : void
      {
         this.storedArr.sort();
      }
      
      public function sortOn(param1:Object, param2:Object = null) : void
      {
         this.storedArr.sortOn(param1,param2);
      }
      
      public function get arr() : Array
      {
         return this.storedArr;
      }
      
      public function get obj() : Object
      {
         return this.storedObj;
      }
      
      public function get length() : uint
      {
         return this.storedArr.length;
      }
   }
}

