package ninjasaga
{
   import com.utils.Out;
   import ninjasaga.data.DBCharacterData;
   import ninjasaga.data.InventoryData;
   import ninjasaga.dbclass.DBCharacter;
   
   public class PvPCharacter extends Character
   {
      
      public function PvPCharacter(param1:DBCharacter)
      {
         super(param1);
         this.type = 3;
         this.initClassSkill();
      }
      
      private function initClassSkill() : void
      {
         var _loc1_:Array = this.getInventory(InventoryData.TYPE_SKILL);
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_.length)
         {
            if(Central.main.SKILL_DATA[_loc1_[_loc2_]] == null)
            {
               Out.error(this,"skill not exist :: " + _loc1_[_loc2_]);
               this.removeInventory(InventoryData.TYPE_SKILL,_loc1_[_loc2_]);
               this.databaseCharacter[DBCharacterData.SKILLS] = [];
            }
            else if(int(Central.main.SKILL_DATA[_loc1_[_loc2_]].special_class) > 0)
            {
               if(int(Central.main.SKILL_DATA[_loc1_[_loc2_]].special_class) == this.getData(DBCharacterData.CONTROL))
               {
                  this.setClassSkillListArr(_loc1_[_loc2_]);
                  this.removeInventory(InventoryData.TYPE_SKILL,_loc1_[_loc2_]);
               }
               else
               {
                  Out.error(this,"Class Skill not match :: " + _loc1_[_loc2_]);
               }
            }
            _loc2_++;
         }
      }
      
      override public function skillCheck() : void
      {
      }
   }
}

