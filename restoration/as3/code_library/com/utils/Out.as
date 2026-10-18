package com.utils
{
   import de.polygonal.ds.LinkedQueue;
   import ninjasaga.*;
   import ninjasaga.base.*;
   
   public final class Out
   {
      
      public static const QUEUE_SIZE:uint = 50;
      
      public static var logger:LinkedQueue = new LinkedQueue();
      
      private static var _dataLogger:LinkedQueue = new LinkedQueue();
      
      public function Out()
      {
         super();
      }
      
      public static function debug(param1:*, param2:String) : void
      {
         trace("Out :: Debug :: " + param1 + " :: " + param2);
      }
      
      public static function error(param1:*, param2:String) : void
      {
         var _loc3_:String = "Out :: Error :: " + param1 + " :: " + param2;
         if(logger.size < QUEUE_SIZE)
         {
            logger.enqueue(_loc3_);
         }
         else
         {
            logger.dequeue();
            logger.enqueue(_loc3_);
         }
         trace(_loc3_);
      }
      
      public static function data(param1:*, param2:String) : void
      {
         var _loc3_:String = "Out :: Data :: " + param1 + " :: " + param2;
         if(_dataLogger.size < QUEUE_SIZE)
         {
            _dataLogger.enqueue(_loc3_);
         }
         else
         {
            _dataLogger.dequeue();
            _dataLogger.enqueue(_loc3_);
         }
      }
      
      public static function getLoggerDump() : String
      {
         return logger.dump();
      }
      
      public static function get dataLogger() : String
      {
         return _dataLogger.dump();
      }
   }
}

