package bitemycode.net.zendamf
{
   import de.polygonal.ds.HashMap;
   import flash.events.ErrorEvent;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IOErrorEvent;
   import flash.events.NetStatusEvent;
   import flash.events.SecurityErrorEvent;
   import flash.events.TimerEvent;
   import flash.net.NetConnection;
   import flash.net.Responder;
   import flash.utils.Timer;
   
   public class ZendAMFClient extends EventDispatcher
   {
      
      private static var instance:ZendAMFClient;
      
      private static var gateway:String;
      
      private static var connection:NetConnection;
      
      private static var serviceArr:Array = [];
      
      private static var curService:Object = null;
      
      private static var onService:Boolean = false;
      
      private static var sendAgain:Boolean = false;
      
      private static var lastService:Object = [];
      
      private static var retryNum:int = 0;
      
      private var _serviceQueue:HashMap = new HashMap();
      
      private var _onQueuedService:Boolean = false;
      
      private var _queuedServiceTimer:Timer = new Timer(10000,1);
      
      private var retryServiceTimer:Timer;
      
      public function ZendAMFClient(param1:SingletonBlocker)
      {
         super();
         if(param1 == null)
         {
            throw new Error("Error: Instantiation failed: Use ZendAMFClient.getInstance() instead of new.");
         }
         gateway = "";
         connection = new NetConnection();
      }
      
      public static function getInstance() : ZendAMFClient
      {
         if(instance == null)
         {
            instance = new ZendAMFClient(new SingletonBlocker());
         }
         return instance;
      }
      
      public function connect(param1:String) : void
      {
         var _gateway:String = param1;
         gateway = _gateway;
         try
         {
            connection.connect(gateway);
            connection.addEventListener(NetStatusEvent.NET_STATUS,netStatusHandler);
            connection.addEventListener(SecurityErrorEvent.SECURITY_ERROR,securityErrorHandler);
            connection.addEventListener(IOErrorEvent.IO_ERROR,ioErrorHandler);
         }
         catch(err:Error)
         {
            §§push(err);
            var _temp_1:* = err;
            err = §§pop();
            dispatchEvent(new ErrorEvent(ErrorEvent.ERROR,false,false,"Error:" + err.message));
         }
      }
      
      public function queuedService(param1:String, param2:Array, param3:Function) : void
      {
         var _serviceName:String = param1;
         var _args:Array = param2;
         var _callBackFn:Function = param3;
         try
         {
            _serviceQueue.insert(_serviceName,{
               "serviceName":_serviceName,
               "args":_args,
               "callBackFn":_callBackFn
            });
            runQueue();
         }
         catch(e:Error)
         {
            §§push(e);
            var _temp_1:* = e;
            e = §§pop();
            dispatchEvent(new ErrorEvent(ErrorEvent.ERROR,false,false,"queuedServie Error:" + e.getStackTrace()));
         }
      }
      
      public function service(param1:String, param2:Array, param3:Function) : void
      {
         serviceArr.push({
            "serviceName":param1,
            "args":param2,
            "callBackFn":param3
         });
         if(!onService)
         {
            process();
         }
      }
      
      private function localCallBack(param1:Object) : void
      {
         curService.callBackFn(param1);
         process();
      }
      
      private function process() : void
      {
         var _serviceName:String = null;
         var _args:Array = null;
         var responder:Responder = null;
         var args:Array = null;
         if(gateway == "")
         {
            dispatchEvent(new IOErrorEvent(IOErrorEvent.IO_ERROR,false,false,"Connection not available"));
         }
         else if(serviceArr.length > 0)
         {
            onService = true;
            curService = serviceArr.shift();
            lastService = curService;
            _serviceName = curService.serviceName;
            _args = curService.args;
            responder = new Responder(localCallBack,onFault);
            args = new Array(_serviceName,responder);
            try
            {
               connection.call.apply(null,args.concat(_args));
            }
            catch(err:Error)
            {
               dispatchEvent(new ErrorEvent(ErrorEvent.ERROR,false,false,"Error:" + err.message));
            }
         }
         else
         {
            onService = false;
            retryNum = 0;
         }
      }
      
      private function runQueue() : void
      {
         try
         {
            if(gateway == "")
            {
               dispatchEvent(new IOErrorEvent(IOErrorEvent.IO_ERROR,false,false,"Connection not available"));
            }
            else if(!this._onQueuedService)
            {
               this._onQueuedService = true;
               this._queuedServiceTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.processQueuedService);
               this._queuedServiceTimer.start();
            }
         }
         catch(e:Error)
         {
            §§push(e);
            var _temp_1:* = e;
            e = §§pop();
            dispatchEvent(new ErrorEvent(ErrorEvent.ERROR,false,false,"runQueue Error:" + e.getStackTrace()));
         }
      }
      
      private function processQueuedService(param1:TimerEvent) : void
      {
         var qServiceArr:Array = null;
         var i:uint = 0;
         var obj:Object = null;
         var evt:TimerEvent = param1;
         try
         {
            this._queuedServiceTimer.stop();
            this._queuedServiceTimer.reset();
            if(this._serviceQueue.size > 0)
            {
               qServiceArr = this._serviceQueue.toArray();
               this._serviceQueue.clear();
               this._onQueuedService = false;
               i = 0;
               while(i < qServiceArr.length)
               {
                  obj = qServiceArr[i];
                  this.service(obj.serviceName,obj.args,obj.callBackFn);
                  i++;
               }
            }
         }
         catch(e:Error)
         {
            §§push(e);
            var _temp_2:* = e;
            e = §§pop();
            dispatchEvent(new ErrorEvent(ErrorEvent.ERROR,false,false,"processQueuedService Error:" + e.getStackTrace()));
         }
      }
      
      public function isConnected() : Boolean
      {
         return gateway == "" ? false : true;
      }
      
      private function onFault(param1:Object) : void
      {
         dispatchEvent(new ErrorEvent(ErrorEvent.ERROR,false,false,param1.description));
         process();
      }
      
      override public function dispatchEvent(param1:Event) : Boolean
      {
         if(hasEventListener(param1.type) || param1.bubbles)
         {
            return super.dispatchEvent(param1);
         }
         return true;
      }
      
      public function netStatusHandler(param1:NetStatusEvent) : void
      {
         var _loc2_:int = 0;
         if((param1.info.description.indexOf("503") > -1 || param1.info.description.indexOf("502") > -1) && retryNum < 4)
         {
            onService = false;
            var _loc3_:* = §§findproperty(retryNum);
            var _loc4_:Number = _loc3_.retryNum + 1;
            _loc3_.retryNum = _loc4_;
            _loc2_ = Math.floor(Math.random() * (7000 - 3000 + 1)) + 3000;
            retryServiceTimer = new Timer(_loc2_,1);
            retryServiceTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.processRetryService);
            retryServiceTimer.start();
         }
         else
         {
            dispatchEvent(new ErrorEvent(ErrorEvent.ERROR,false,false,"NetStatus Error:" + param1.info.code));
            process();
         }
      }
      
      private function processRetryService(param1:TimerEvent) : void
      {
         var evt:TimerEvent = param1;
         try
         {
            this.retryServiceTimer.stop();
            service(lastService.serviceName,lastService.args,lastService.callBackFn);
         }
         catch(e:Error)
         {
            §§push(e);
            var _temp_1:* = e;
            e = §§pop();
            dispatchEvent(new ErrorEvent(ErrorEvent.ERROR,false,false,"processRetryService Error:" + e.getStackTrace()));
         }
      }
      
      public function securityErrorHandler(param1:SecurityErrorEvent) : void
      {
         dispatchEvent(new ErrorEvent(ErrorEvent.ERROR,false,false,"Security Error:" + param1.text));
         process();
      }
      
      public function ioErrorHandler(param1:IOErrorEvent) : void
      {
         dispatchEvent(new ErrorEvent(ErrorEvent.ERROR,false,false,"IO Error:" + param1.text));
         process();
      }
   }
}

class SingletonBlocker
{
   
   public function SingletonBlocker()
   {
      super();
   }
}
