package com.pnwrain.flashsocket.events
{
   import flash.events.Event;
   
   public class FlashSocketEvent extends Event
   {
      
      public static const CLOSE:String = "close";
      
      public static const CONNECT:String = "connect";
      
      public static const MESSAGE:String = "message";
      
      public static const IO_ERROR:String = "ioError";
      
      public static const SECURITY_ERROR:String = "securityError";
      
      public static const DISCONNECT:String = "disconnect";
      
      public static const CONNECT_ERROR:String = "connectError";
      
      public var data:*;
      
      public function FlashSocketEvent(param1:String, param2:Boolean = true, param3:Boolean = false)
      {
         super(param1,param2,param3);
      }
   }
}

