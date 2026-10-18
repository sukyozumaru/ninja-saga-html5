package br.com.stimuli.loading
{
   import com.utils.GF;
   import com.utils.NumberUtil;
   import flash.events.Event;
   import ninjasaga.*;
   import ninjasaga.battle.*;
   import ninjasaga.data.AppData;
   import ninjasaga.data.BattleData;
   import ninjasaga.data.BloodlineData;
   import ninjasaga.data.DBCharacterData;
   import ninjasaga.data.Data;
   import ninjasaga.data.SenjutsuData;
   
   public class BulkErrorEvent extends Event
   {
      
      public static const ERROR:String = "error";
      
      public var name:String;
      
      public var errors:Array;
      
      public function BulkErrorEvent(param1:String, param2:Boolean = true, param3:Boolean = false)
      {
         super(param1,param2,param3);
         this.name = param1;
      }
      
      override public function clone() : Event
      {
         var _loc1_:BulkErrorEvent = new BulkErrorEvent(name,bubbles,cancelable);
         _loc1_.errors = errors ? errors.slice() : [];
         return _loc1_;
      }
      
      override public function toString() : String
      {
         return super.toString();
      }
   }
}

