package ninjasaga
{
   import bitemycode.net.zendamf.ZendAMFClient;
   import com.utils.Out;
   import de.polygonal.ds.HashMap;
   import flash.events.ErrorEvent;
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
         Out.error(this," AMF Client :: " + param1.text);
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
         var _loc6_:int = 0;
         var _loc7_:Boolean = false;
         var _loc8_:Array = null;
         Main.tracking.trackAmfService(param1);
         this.lastService = param1;
         var _loc5_:Array = this.restrictedServices.getKeySet();
         if(param4 == null)
         {
            if(_loc5_.indexOf(param1) >= 0)
            {
               Out.error(this,"service :: cannot connect >> " + param1);
               Main.onError("2001");
               return;
            }
            ZendAMFClient.getInstance().service(param1,param2,param3);
         }
         else if(_loc5_.indexOf(param1) >= 0)
         {
            _loc7_ = false;
            _loc8_ = this.restrictedServices.find(param1);
            if(param4.constructor)
            {
               _loc6_ = 0;
               while(_loc6_ < _loc8_.length)
               {
                  if(_loc8_[_loc6_] == param4.constructor)
                  {
                     _loc7_ = true;
                     break;
                  }
                  _loc6_++;
               }
            }
            if(_loc7_ != true)
            {
               Out.error(this,"service :: cannot connect (" + param4 + ") >> " + param1);
               Main.onError("2001");
               return;
            }
            ZendAMFClient.getInstance().service(param1,param2,param3);
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
