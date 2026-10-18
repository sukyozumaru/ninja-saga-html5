package ninjasaga
{
   import com.utils.NumberUtil;
   import com.utils.Out;
   import flash.events.*;
   import flash.utils.*;
   import gs.*;
   import ninjasaga.data.ClanData;
   
   public final class Clan
   {
      
      private static var instance:Clan;
      
      public var clanData:Object;
      
      public var buildingData:Array;
      
      public var history:Array;
      
      public var battleClanData:Object;
      
      public var battleBuildingData:Array;
      
      public function Clan(param1:SingletonBlocker)
      {
         super();
         if(param1 == null)
         {
            throw new Error("Error: Instantiation failed: Use getInstance() instead of new.");
         }
      }
      
      public static function getInstance() : Clan
      {
         if(instance == null)
         {
            instance = new Clan(new SingletonBlocker());
         }
         return instance;
      }
      
      public static function get proc() : Clan
      {
         if(instance == null)
         {
            instance = new Clan(new SingletonBlocker());
         }
         return instance;
      }
      
      public function getAttackerBonus(param1:String) : Number
      {
         if(this.buildingData == null)
         {
            return 0;
         }
         return this.getBuildingBonus(this.buildingData,param1);
      }
      
      public function getDefenderBonus(param1:String) : Number
      {
         if(this.battleBuildingData == null)
         {
            return 0;
         }
         return this.getBuildingBonus(this.battleBuildingData,param1);
      }
      
      private function getBuildingBonus(param1:Array, param2:String) : Number
      {
         var _loc3_:uint = 0;
         _loc3_ = 0;
         while(_loc3_ < param1.length)
         {
            if(ClanData.BUILDING_DATA[int(param1[_loc3_].id)].bonusType == param2)
            {
               return int(param1[_loc3_].level) * ClanData.BUILDING_DATA[int(param1[_loc3_].id)].bonus;
            }
            _loc3_++;
         }
         return 0;
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
