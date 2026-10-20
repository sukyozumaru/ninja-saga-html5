package ninjasaga
{
   import bitemycode.net.zendamf.ZendAMFClient;
   import com.utils.Out;
   import de.polygonal.ds.HashMap;
   import flash.events.ErrorEvent;
   import flash.utils.getTimer;
   import ninjasaga.data.DBCharacterData;
   import ninjasaga.data.Data;
   
   public class AMFConnector
   {
      
      private static var instance:AMFConnector;
      
      private var restrictedServices:HashMap = new HashMap();
      
      public var lastService:String;
      
      public function AMFConnector(param1:SingletonBlocker)
      {
         super();
         if(param1 == null)
         {
            throw new Error("Error: Instantiation failed: Use AMFConnector.getInstance() instead of new.");
         }
         this.restrictedServices.insert("CharacterService.updateCharacter",[Character]);
         this.restrictedServices.insert("Achievement.updateData",[Battle]);
         this.restrictedServices.insert("CharacterValidation.validateSkill",[Character]);
      }
      
      public static function getInstance() : AMFConnector
      {
         if(instance == null)
         {
            instance = new AMFConnector(new SingletonBlocker());
         }
         return instance;
      }
      
      private static function getStubResult(param1:String) : *
      {
         switch(param1)
         {
            case "SystemData.get":
               return {};
            case "SystemService.requireLogin":
            case "SystemService.checkAmf":
            case "ReportService.reportFriendError":
               return "";
            default:
               return null;
         }
      }
      
      private static function isStubbed(param1:String) : Boolean
      {
         switch(param1)
         {
            case "SystemService.requireLogin":
            case "SystemService.checkAmf":
            case "SystemData.get":
            case "ReportService.reportFriendError":
               return true;
            default:
               return false;
         }
      }
      
      public function initAmf() : void
      {
         var _loc1_:ZendAMFClient = ZendAMFClient.getInstance();
         _loc1_.addEventListener(ErrorEvent.ERROR,this.onFault);
         if(!_loc1_.isConnected())
         {
            _loc1_.connect(Data.AMF_GATEWAY);
         }
      }
      
      private function onFault(param1:ErrorEvent) : void
      {
         if(param1.text == "null" || param1.text == null || param1.text == "")
         {
            Out.debug(this,"Timeout: " + this.lastService);
            return;
         }
         Out.debug(this,"Fault: " + this.lastService);
         Main.hideAmfLoading();
         Main.onError("2000");
         var _loc2_:* = 0;
         if(Central.main.getMainChar())
         {
            _loc2_ = Central.main.getMainChar().getData(DBCharacterData.ID);
         }
         this.service("ReportService.reportAmfError2",[Central.main.account.getAccountSessionKey(),Central.main.account.getAccountId(),_loc2_,this.lastService,param1.text.substring(0,param1.text.length > 2000 ? 2000 : param1.text.length)],Central.main.reportServiceResponse);
      }
      
      public function service(param1:String, param2:Array, param3:Function, param4:Object = null) : void
      {
         var timedCallback:Function;
         var _loc6_:int;
         var _loc7_:Boolean;
         var _loc8_:Array;
         var _loc5_:Array;
         var serviceName:String = null;
         var origCallback:Function = null;
         var startTime:int = 0;
         serviceName = param1;
         var serviceArgs:Array = param2;
         origCallback = param3;
         var ctx:Object = param4;
         startTime = getTimer();
         Out.debug(this,"AMF -> " + serviceName);
         if(isStubbed(serviceName))
         {
            Out.debug(this,"AMF STUB :: " + serviceName + " (returning fake status=1 without server round-trip)");
            this.lastService = serviceName;
            if(origCallback != null)
            {
               origCallback({
                  "status":1,
                  "result":getStubResult(serviceName)
               });
            }
            return;
         }
         timedCallback = function(param1:Object):void
         {
            Out.debug("AMFConnector","AMF <- " + serviceName + " :: " + (getTimer() - startTime) + "ms" + (Boolean(param1) && param1.status != null ? " status=" + param1.status : "") + (Boolean(param1) && param1.error != null ? " error=" + param1.error : ""));
            if(origCallback != null)
            {
               origCallback(param1);
            }
         };
         _loc6_ = 0;
         _loc7_ = false;
         _loc8_ = null;
         Main.tracking.trackAmfService(serviceName);
         this.lastService = serviceName;
         _loc5_ = this.restrictedServices.getKeySet();
         if(ctx == null)
         {
            if(_loc5_.indexOf(serviceName) >= 0)
            {
               Out.error(this,"service :: cannot connect >> " + serviceName);
               Main.onError("2001");
               return;
            }
            ZendAMFClient.getInstance().service(serviceName,serviceArgs,timedCallback);
         }
         else if(_loc5_.indexOf(serviceName) >= 0)
         {
            _loc7_ = false;
            _loc8_ = this.restrictedServices.find(serviceName);
            if(ctx.constructor)
            {
               _loc6_ = 0;
               while(_loc6_ < _loc8_.length)
               {
                  if(_loc8_[_loc6_] == ctx.constructor)
                  {
                     _loc7_ = true;
                     break;
                  }
                  _loc6_++;
               }
            }
            if(_loc7_ != true)
            {
               Out.error(this,"service :: cannot connect (" + ctx + ") >> " + serviceName);
               Main.onError("2001");
               return;
            }
            ZendAMFClient.getInstance().service(serviceName,serviceArgs,timedCallback);
         }
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
