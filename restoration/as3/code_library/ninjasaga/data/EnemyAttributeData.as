package ninjasaga.data
{
   import com.utils.Out;
   
   public final class EnemyAttributeData
   {
      
      public static const HP:* = "hp";
      
      public static const CP:* = "cp";
      
      public static const ROUND:* = "round";
      
      public static const SEAL_GAN:* = "seal_gan";
      
      public static const OVER:* = 1;
      
      public static const LESS:* = 0;
      
      public static const SEAL_BOSS_LIST:Array = ["enemy289","enemy290","enemy291","enemy292","enemy393"];
      
      public static const SEAL_BOSS_LIST_EASTER:Array = ["enemy338","enemy339","enemy340","enemy341","enemy342"];
      
      private static const EnemyAttributeArr:Array = [{},{
         "id":"enemy338",
         "attribute":"seal_gan",
         "amount_over":0,
         "amount_less":30
      },{
         "id":"enemy339",
         "attribute":"seal_gan",
         "amount_over":0,
         "amount_less":20
      },{
         "id":"enemy340",
         "attribute":"seal_gan",
         "amount_over":0,
         "amount_less":10
      },{
         "id":"enemy341",
         "attribute":"seal_gan",
         "amount_over":0,
         "amount_less":10
      },{
         "id":"enemy342",
         "attribute":"seal_gan",
         "amount_over":0,
         "amount_less":10
      },{
         "id":"enemy289",
         "attribute":"seal_gan",
         "amount_over":0,
         "amount_less":30
      },{
         "id":"enemy290",
         "attribute":"seal_gan",
         "amount_over":0,
         "amount_less":20
      },{
         "id":"enemy291",
         "attribute":"seal_gan",
         "amount_over":0,
         "amount_less":10
      },{
         "id":"enemy292",
         "attribute":"seal_gan",
         "amount_over":0,
         "amount_less":10
      },{
         "id":"enemy393",
         "attribute":"seal_gan",
         "amount_over":0,
         "amount_less":10
      }];
      
      public function EnemyAttributeData()
      {
         super();
      }
      
      public static function getEnemyAttributeById(param1:String) : Array
      {
         var _loc2_:Array = [];
         var _loc3_:int = 0;
         while(_loc3_ < EnemyAttributeArr.length)
         {
            if(EnemyAttributeArr[_loc3_].id == param1)
            {
               _loc2_.push(EnemyAttributeArr[_loc3_]);
            }
            _loc3_++;
         }
         if(_loc2_.length == 0)
         {
            Out.error("EnemyAttributeData",param1 + " not found");
         }
         return _loc2_;
      }
   }
}

