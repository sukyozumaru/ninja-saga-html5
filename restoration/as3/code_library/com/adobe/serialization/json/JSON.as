package com.adobe.serialization.json
{
   import com.utils.NumberUtil;
   import com.utils.Out;
   import de.polygonal.ds.SListIterator;
   import ninjasaga.*;
   import ninjasaga.base.*;
   import ninjasaga.data.BattleData;
   import ninjasaga.data.BloodlineData;
   import ninjasaga.data.DBCharacterData;
   import ninjasaga.data.SenjutsuData;
   import ninjasaga.data.SkillData;
   
   public class JSON
   {
      
      public function JSON()
      {
         super();
      }
      
      public static function stringify(param1:Object) : String
      {
         var _loc2_:JSONEncoder = new JSONEncoder(param1);
         return _loc2_.getString();
      }
      
      public static function parse(param1:String) : *
      {
         var _loc2_:JSONDecoder = new JSONDecoder(param1);
         return _loc2_.getValue();
      }
   }
}

