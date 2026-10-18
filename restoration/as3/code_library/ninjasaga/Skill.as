package ninjasaga
{
   import com.utils.GF;
   import flash.display.MovieClip;
   
   public class Skill
   {
      
      private static var skillList:Object = new Object();
      
      private static var classSkillList:Object = new Object();
      
      private static var senjutsuList:Object = new Object();
      
      public function Skill()
      {
         super();
      }
      
      public static function getBloodline(param1:String) : MovieClip
      {
         var _loc2_:String = "bloodline_skill" + param1;
         var _loc3_:String = String(Central.main.BLOODLINE_SKILL_DATA[_loc2_].swf_name).substr(0,1).toUpperCase() + String(Central.main.BLOODLINE_SKILL_DATA[_loc2_].swf_name).substring(1,String(Central.main.BLOODLINE_SKILL_DATA[_loc2_].swf_name).length);
         param1 = "skill" + param1;
         var _loc4_:MovieClip = GF.getAsset(skillList[param1],_loc3_);
         _loc4_.skillId = param1;
         return _loc4_;
      }
      
      public static function getSenjutsu(param1:String) : MovieClip
      {
         var _loc2_:String = "senjutsu_skill" + param1;
         var _loc3_:String = String(Central.main.SENJUTSU_SKILL_DATA[_loc2_].swf_name).substr(0,1).toUpperCase() + String(Central.main.SENJUTSU_SKILL_DATA[_loc2_].swf_name).substring(1,String(Central.main.SENJUTSU_SKILL_DATA[_loc2_].swf_name).length);
         param1 = "skill" + param1;
         var _loc4_:MovieClip = GF.getAsset(skillList[param1],_loc3_);
         _loc4_.skillId = param1;
         return _loc4_;
      }
      
      public static function setSkill(param1:String, param2:MovieClip) : void
      {
         skillList[param1] = param2;
      }
      
      public static function getSkill(param1:String, param2:String = "") : MovieClip
      {
         var _loc3_:String = String(Central.main.SKILL_DATA[param1].swfName).substr(0,1).toUpperCase() + String(Central.main.SKILL_DATA[param1].swfName).substring(1,String(Central.main.SKILL_DATA[param1].swfName).length);
         _loc3_ += param2;
         var _loc4_:MovieClip = GF.getAsset(skillList[param1],_loc3_);
         _loc4_.skillId = param1;
         return _loc4_;
      }
      
      public static function hasSkill(param1:String) : Boolean
      {
         var _loc2_:MovieClip = skillList[param1];
         if(_loc2_ != null)
         {
            return true;
         }
         return false;
      }
      
      public static function hasClassSkill(param1:String) : Boolean
      {
         var _loc2_:MovieClip = classSkillList[param1];
         if(_loc2_ != null)
         {
            return true;
         }
         return false;
      }
      
      public static function setClassSkill(param1:String, param2:MovieClip) : void
      {
         classSkillList[param1] = param2;
      }
      
      public static function getClassSkill(param1:String) : MovieClip
      {
         var _loc2_:String = String(Central.main.SKILL_DATA[param1].swfName).substr(0,1).toUpperCase() + String(Central.main.SKILL_DATA[param1].swfName).substring(1,String(Central.main.SKILL_DATA[param1].swfName).length);
         var _loc3_:MovieClip = GF.getAsset(classSkillList[param1],_loc2_);
         _loc3_.skillId = param1;
         return _loc3_;
      }
      
      public static function getSpecialEffect(param1:String) : MovieClip
      {
         var _loc2_:MovieClip = new MovieClip();
         if(skillList[param1] != null)
         {
            _loc2_ = GF.getAsset(skillList[param1],"specialEffect");
         }
         else if(classSkillList[param1] != null)
         {
            _loc2_ = GF.getAsset(classSkillList[param1],"specialEffect");
         }
         else
         {
            _loc2_ = GF.getAsset(senjutsuList[param1],"specialEffect");
         }
         return _loc2_;
      }
   }
}

