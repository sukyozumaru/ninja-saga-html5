package br.com.stimuli.loading
{
   import flash.events.Event;
   
   public class BulkErrorEvent extends Event
   {
      
      public static const ERROR:String = "error";
      
      public var name:String;
      
      public var errors:Array;
      
      public function BulkErrorEvent(name:String, bubbles:Boolean = true, cancelable:Boolean = false)
      {
         super(name,bubbles,cancelable);
         this.name = name;
      }
      
      override public function clone() : Event
      {
         var b:BulkErrorEvent = new BulkErrorEvent(this.name,bubbles,cancelable);
         b.errors = this.errors ? this.errors.slice() : [];
         return b;
      }
      
      override public function toString() : String
      {
         return super.toString();
      }
   }
}

