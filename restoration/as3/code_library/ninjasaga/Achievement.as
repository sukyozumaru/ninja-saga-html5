package ninjasaga
{
   import com.utils.GF;
   import com.utils.Out;
   import de.polygonal.ds.HashMap;
   import ninjasaga.data.AppData;
   import ninjasaga.data.Data;
   import ninjasaga.data.InventoryData;
   import ninjasaga.data.SNSData;
   
   public class Achievement
   {
      
      private static var instance:Achievement;
      
      private var battleStat:Object;
      
      private var charStat:Object;
      
      public var gotAchievement:Array = [];
      
      public var wallfeedQueue:Array = [];
      
      public var wallfeedProcessing:Boolean = false;
      
      public function Achievement(param1:SingletonBlocker)
      {
         super();
         if(param1 == null)
         {
            throw new Error("Error: Instantiation failed: Use Achievement.getInstance() instead of new.");
         }
         this.initBattleStat();
         this.initCharStat();
      }
      
      public static function getInstance() : Achievement
      {
         if(instance == null)
         {
            instance = new Achievement(new SingletonBlocker());
         }
         return instance;
      }
      
      public function updateBattleStat(param1:int, param2:int, param3:Boolean = false) : void
      {
         this.battleStat[param1] += param2;
         var _loc4_:String = Main.achievementData.getAchievementTypeData(param1);
         Main.getMainChar().statisticBattle[_loc4_] = int(Main.getMainChar().statisticBattle[_loc4_]) + param2;
         var _loc5_:int = this.checkAchievement(param1,int(Main.getMainChar().statisticBattle[_loc4_]));
         if(_loc5_ > 0 || param3 == true)
         {
            this.flushBattleStat();
         }
      }
      
      public function flushBattleStat() : void
      {
         var _loc1_:String = Main.getHash("Achievement.flushBattleStat" + GF.objectToArray(this.battleStat).toString());
         Main.amfClient.service("Achievement.flushBattleStat",[Central.main.account.getAccountSessionKey(),Main.updateSequence(),_loc1_,this.battleStat],this.flushBattleStatResponse);
         this.initBattleStat();
      }
      
      private function flushBattleStatResponse(param1:Object) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:int = 0;
         var _loc4_:String = null;
         var _loc5_:int = 0;
         if(Main.validateAmfResponse(param1))
         {
            _loc2_ = 0;
            while(_loc2_ < Main.achievementData.ALL_BATTLE_STAT.length)
            {
               _loc3_ = int(Main.achievementData.ALL_BATTLE_STAT[_loc2_]);
               _loc4_ = Main.achievementData.getAchievementTypeData(_loc3_);
               _loc5_ = this.checkAchievement(_loc3_,int(Main.getMainChar().statisticBattle[_loc4_]));
               if(_loc5_ > 0)
               {
                  Out.debug(this,"going to validate achievement >> " + _loc5_);
                  this.validateAchievement(_loc5_);
               }
               _loc2_++;
            }
         }
      }
      
      private function initBattleStat() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:int = 0;
         this.battleStat = {};
         _loc1_ = 0;
         while(_loc1_ < Main.achievementData.ALL_BATTLE_STAT.length)
         {
            _loc2_ = int(Main.achievementData.ALL_BATTLE_STAT[_loc1_]);
            this.battleStat[_loc2_] = 0;
            _loc1_++;
         }
      }
      
      public function updateCharStat(param1:int, param2:int = 1, param3:Boolean = false) : void
      {
         this.charStat[param1] += param2;
         var _loc4_:String = Main.achievementData.getAchievementTypeData(param1);
         Main.getMainChar().statisticChar[_loc4_] = int(Main.getMainChar().statisticChar[_loc4_]) + param2;
         var _loc5_:int = int(Main.getMainChar().statisticChar[_loc4_]);
         var _loc6_:int = this.checkAchievement(param1,_loc5_);
         if(int(this.charStat[Main.achievementData.GOLD_OBTAINED]) >= Main.getMainChar().getLevel() * 50)
         {
            param3 = true;
         }
         if(int(this.charStat[Main.achievementData.FRIEND_VISITED]) >= 2)
         {
            param3 = true;
         }
         if(int(this.charStat[Main.achievementData.CHALLENGE_DONE]) >= 1)
         {
            param3 = true;
         }
         if(int(this.charStat[Main.achievementData.FRIEND_RECRUITED]) >= 2)
         {
            param3 = true;
         }
         if(int(this.charStat[Main.achievementData.WALLFEED_POSTED]) >= 1)
         {
            param3 = true;
         }
         if(_loc6_ > 0 || param3 == true)
         {
            this.flushCharStat();
         }
      }
      
      public function flushCharStat() : void
      {
         var _loc1_:String = GF.objectToArray(this.charStat).toString();
         Out.debug(this,"flushCharStat :: str >> " + _loc1_);
         var _loc2_:String = Main.getHash("Achievement.flushCharStat" + _loc1_);
         Main.amfClient.service("Achievement.flushCharStat",[Central.main.account.getAccountSessionKey(),Main.updateSequence(),_loc2_,this.charStat],this.flushCharStatResponse);
         this.initCharStat();
      }
      
      private function flushCharStatResponse(param1:Object) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:int = 0;
         var _loc4_:String = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         if(Main.validateAmfResponse(param1))
         {
            _loc2_ = 0;
            while(_loc2_ < Main.achievementData.ALL_CHAR_STAT.length)
            {
               _loc3_ = int(Main.achievementData.ALL_CHAR_STAT[_loc2_]);
               _loc4_ = Main.achievementData.getAchievementTypeData(_loc3_);
               _loc5_ = int(Main.getMainChar().statisticChar[_loc4_]);
               _loc6_ = this.checkAchievement(_loc3_,_loc5_);
               if(_loc6_ > 0)
               {
                  this.validateAchievement(_loc6_);
               }
               _loc2_++;
            }
         }
      }
      
      private function initCharStat() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:int = 0;
         this.charStat = {};
         _loc1_ = 0;
         while(_loc1_ < Main.achievementData.ALL_CHAR_STAT.length)
         {
            _loc2_ = int(Main.achievementData.ALL_CHAR_STAT[_loc1_]);
            this.charStat[_loc2_] = 0;
            _loc1_++;
         }
      }
      
      private function checkAchievement(param1:int, param2:int) : int
      {
         var _loc7_:Object = null;
         var _loc8_:int = 0;
         var _loc3_:Array = this.getAchievementByType(param1);
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         while(_loc6_ < _loc3_.length)
         {
            _loc7_ = Main.ACHIEVEMENT_DATA.find(_loc3_[_loc6_]);
            _loc8_ = int(_loc7_.requirement);
            if(_loc8_ > _loc4_ && param2 >= _loc8_)
            {
               if(Main.getMainChar().achievement.indexOf(_loc7_.id) >= 0)
               {
                  _loc5_ = 0;
               }
               else
               {
                  _loc4_ = _loc8_;
                  _loc5_ = int(_loc7_.id);
               }
            }
            _loc6_++;
         }
         return _loc5_;
      }
      
      public function getProgress(param1:int, param2:int, param3:Object = null) : Object
      {
         var _loc4_:* = undefined;
         var _loc11_:Object = null;
         var _loc12_:int = 0;
         if(param3 == null)
         {
            _loc4_ = Main.getMainChar();
         }
         else
         {
            _loc4_ = param3;
         }
         var _loc5_:Array = this.getAchievementByType(param1);
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         while(_loc9_ < _loc5_.length)
         {
            var _temp_1:* = Main.ACHIEVEMENT_DATA.find(_loc5_[_loc9_]);
            _loc11_ = Main.ACHIEVEMENT_DATA.find(_loc5_[_loc9_]);
            _loc12_ = int(_loc11_.requirement);
            if((_loc6_ > _loc12_ || _loc6_ == 0) && _loc4_.achievement.indexOf(_loc11_.id) < 0)
            {
               _loc7_ = int(_loc11_.id);
               _loc8_ = _loc12_ - param2;
               _loc6_ = _loc12_;
            }
            _loc9_++;
         }
         var _loc10_:Object = {};
         _loc10_.achievementId = _loc7_;
         _loc10_.progressValue = _loc8_;
         return _loc10_;
      }
      
      public function checkSpecialAchievement(param1:int) : void
      {
         var invSkill:Array = null;
         var i:int = 0;
         var k:int = 0;
         var achievementArr:Array = null;
         var achievementData:Object = null;
         var invMission:Object = null;
         var kinjutsu:int = 0;
         var skillData:Object = null;
         var missionRequired:Array = null;
         var type:int = param1;
         var achievementId:int = 0;
         switch(type)
         {
            case Main.achievementData.SKILL_TRAINED:
               invSkill = Main.getMainChar().getInventory(InventoryData.TYPE_SKILL);
               achievementId = this.checkAchievement(type,invSkill.length);
               break;
            case Main.achievementData.NINJA_EMBLEM:
               if(Central.main.account.getAccountType() == Central.main.account.PREMIUM)
               {
                  achievementArr = this.getAchievementByType(Main.achievementData.NINJA_EMBLEM);
                  i = 0;
                  while(i < achievementArr.length)
                  {
                     achievementData = Main.ACHIEVEMENT_DATA.find(achievementArr[i]);
                     if(Main.getMainChar().achievement.indexOf(achievementData.id) < 0)
                     {
                        achievementId = int(achievementData.id);
                     }
                     i++;
                  }
               }
               break;
            case Main.achievementData.KINJUTSU_TRAINED:
               invSkill = Main.getMainChar().getInventory(InventoryData.TYPE_SKILL);
               kinjutsu = 0;
               i = 0;
               while(i < invSkill.length)
               {
                  try
                  {
                     skillData = Main.SKILL_DATA[invSkill[i]];
                     if(skillData == null)
                     {
                        throw new Error("Skill not found, skill=" + invSkill[i]);
                     }
                  }
                  catch(e:Error)
                  {
                     Out.error(this,"Skill not found, invSkill[" + i + "]=" + invSkill[i]);
                     Out.error(this,"where skill_data(" + invSkill[i] + ")=" + skillData);
                     throw e;
                  }
                  if(skillData.rarity == 4 || skillData.rarity == 5)
                  {
                     kinjutsu++;
                  }
                  i++;
               }
               achievementId = this.checkAchievement(type,kinjutsu);
               break;
            case Main.achievementData.SPECIFIC_MISSION_COMPLETED:
               invMission = Main.getMainChar().getInventory(InventoryData.TYPE_MISSION);
               achievementArr = this.getAchievementByType(Main.achievementData.SPECIFIC_MISSION_COMPLETED);
               i = 0;
               while(i < achievementArr.length)
               {
                  achievementData = Main.ACHIEVEMENT_DATA.find(achievementArr[i]);
                  if(Main.getMainChar().achievement.indexOf(achievementData.id) < 0)
                  {
                     missionRequired = String(achievementData.requirement).split(",");
                     k = 0;
                     while(k < missionRequired.length)
                     {
                        if(invMission["msn" + missionRequired[k]] != null)
                        {
                           if(invMission["msn" + missionRequired[k]].success)
                           {
                              achievementId = int(achievementData.id);
                              break;
                           }
                        }
                        k++;
                     }
                  }
                  i++;
               }
         }
         if(achievementId > 0)
         {
            this.validateAchievement(achievementId);
         }
      }
      
      public function checkOfflineAchievement() : void
      {
         var _loc1_:int = this.checkAchievement(Main.achievementData.FRIEND_INVITED,int(Main.getMainChar().statisticChar[Main.achievementData.getAchievementTypeData(Main.achievementData.FRIEND_INVITED)]));
         this.validateAchievement(_loc1_);
         _loc1_ = 0;
         _loc1_ = this.checkAchievement(Main.achievementData.DAYS_PLAYED,int(Main.getMainChar().statisticChar[Main.achievementData.getAchievementTypeData(Main.achievementData.DAYS_PLAYED)]));
         this.validateAchievement(_loc1_);
      }
      
      private function validateAchievement(param1:int) : void
      {
         var _loc2_:String = null;
         if(Central.main.getMainChar().getLevel() >= 2)
         {
            if(param1 > 0)
            {
               trace("achievementId--->" + param1);
               _loc2_ = Main.getHash("Achievement.validate" + String(param1));
               Main.amfClient.service("Achievement.validate",[Central.main.account.getAccountSessionKey(),Main.updateSequence(),_loc2_,param1],this.validateResponse);
            }
         }
      }
      
      private function validateResponse(param1:Object) : void
      {
         var _loc2_:int = 0;
         var _loc3_:Object = null;
         var _loc4_:Array = null;
         var _loc5_:int = 0;
         if(Main.validateAmfResponse(param1))
         {
            if(param1.achievement_id != null)
            {
               _loc2_ = int(param1.achievement_id);
               Main.getMainChar().achievement.push(_loc2_);
               this.gotAchievement.push(_loc2_);
               Main.popup.showAchievement();
               _loc3_ = Main.ACHIEVEMENT_DATA.find(_loc2_);
               Main.getMainChar().achievementPoint = Main.getMainChar().achievementPoint + _loc3_.achievement_point;
               if(param1.extra_achievement)
               {
                  _loc4_ = param1.extra_achievement;
                  _loc5_ = 0;
                  while(_loc5_ < _loc4_.length)
                  {
                     Main.getMainChar().achievement.push(int(_loc4_[_loc5_]));
                     _loc5_++;
                  }
               }
               if(param1.recent_achievement)
               {
                  Main.getMainChar().recentAchievement = param1.recent_achievement as Array;
               }
               if(this.wallfeedQueue.length < 3 && AppData.type == AppData.FB)
               {
                  this.wallfeedQueue.push(_loc2_);
                  this.procWallfeedQueue();
               }
            }
         }
      }
      
      private function procWallfeedQueue() : void
      {
         var _loc1_:int = 0;
         var _loc2_:Object = null;
         if(this.wallfeedProcessing == false && this.wallfeedQueue.length > 0)
         {
            this.wallfeedProcessing = true;
            _loc1_ = this.wallfeedQueue.shift();
            _loc2_ = Main.ACHIEVEMENT_DATA.find(_loc1_);
            SNS.publishFeed(SNSData.FEED_ACHIEVEMENT_GAIN,"ach_" + _loc2_.id,_loc2_.name,String(_loc2_.description).toLowerCase(),this.shareWallfeedCallback);
         }
      }
      
      private function shareWallfeedCallback() : void
      {
         this.wallfeedProcessing = false;
         this.procWallfeedQueue();
      }
      
      private function getAchievementByType(param1:int) : Array
      {
         var _loc2_:Array = [];
         var _loc3_:Array = Main.ACHIEVEMENT_DATA.toArray();
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_.length)
         {
            if(_loc3_[_loc4_].type == param1)
            {
               _loc2_.push(_loc3_[_loc4_].id);
            }
            _loc4_++;
         }
         return _loc2_;
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
