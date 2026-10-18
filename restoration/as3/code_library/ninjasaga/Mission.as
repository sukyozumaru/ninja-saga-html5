package ninjasaga
{
   import br.com.stimuli.loading.BulkLoader;
   import com.utils.GF;
   import com.utils.Mixer;
   import com.utils.NumberUtil;
   import com.utils.Out;
   import com.utils.Sha1Encrypt;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.utils.getTimer;
   import gs.TweenLite;
   import ninjasaga.battle.*;
   import ninjasaga.data.*;
   import ninjasaga.dbclass.DBCharacter;
   
   public final class Mission
   {
      
      public static var stateHash:String;
      
      private static var curEventData:Array;
      
      private static var mapMissoinDoc:MovieClip;
      
      public static const EVT_TEXT:String = "text";
      
      public static const EVT_BATTLE:String = "battle";
      
      public static const EVT_BATTLE_BUTTON:String = "battle_button";
      
      public static const EVT_END:String = "end";
      
      public static const EVT_MC:String = "mc";
      
      public static const EVT_FINISH:String = "finish";
      
      public static const EVT_FAIL:String = "fail";
      
      public static const EVT_MAP_MISSION:String = "map_mission";
      
      public static const EVT_ENGAGE:String = "engage";
      
      public static const EVT_HIDE:String = "hide";
      
      public static const TYPE_NORMAL:String = "normal";
      
      public static const TYPE_MAP_MISSION:String = "map_mission";
      
      public static const TYPE_ENGAGE:String = "engage";
      
      private static var missionCompleteCb:Function;
      
      public static var missionid:String;
      
      private static var sMissioncomplete:int;
      
      private static var HalloweenComplete2015:int;
      
      private static var tmpCurMissionID:String;
      
      private static var _track:Boolean = true;
      
      public static var state:int = 0;
      
      public static var curMissionStep:uint = 0;
      
      public static var curMission:MovieClip = null;
      
      public static var curMissionID:String = null;
      
      private static var curEventStep:uint = 0;
      
      private static var isPause:Boolean = false;
      
      private static var enemiesArr:Array = new Array();
      
      private static var currentEnemyIndex:int = -1;
      
      public static var isSpecialActionOfEnemy:Boolean = false;
      
      public static var SelfEnemyHPMod:uint = 0;
      
      public static var SelfEnemyCPMod:uint = 0;
      
      public static var SelfEnemyispet:uint = 0;
      
      private static const sjeArr:Array = ["msn205","msn227","msn206","msn229","msn207","msn231","msn208","msn233","msn209","msn235"];
      
      private var doublexpgoldTime:int;
      
      public function Mission()
      {
         super();
      }
      
      public static function getConstructor() : *
      {
         return Mission.prototype.constructor;
      }
      
      private static function checkMissionData() : void
      {
         var _loc1_:Object = null;
         if(curMissionID)
         {
            if(curMissionID == "msn0")
            {
               return;
            }
            _loc1_ = Main.MISSION_DATA[curMissionID];
            if(_loc1_)
            {
               if(String(_loc1_.swfName).replace("mission_") != curMissionID.replace("msn"))
               {
                  Out.error("Mission","Error >> " + Main.coreData.MISSION_DATA_ERROR);
                  Main.getMainChar().datafileHack = Main.coreData.MISSION_DATA_ERROR;
               }
            }
         }
      }
      
      public static function setMission(param1:String, param2:MovieClip) : void
      {
         var _loc3_:Array = null;
         var _loc4_:Array = null;
         if(curMission != param2)
         {
            missionid = param1;
            ++state;
            stateHash = Main.getHash(state + "_setMission_" + param2.toString() + "_" + stateHash);
            if(param1 != "msn0")
            {
               Main.tracking.trackStartAction(Main.tracking.SA_MISSION);
            }
            if(Data.EXAM_CHUNIN_ARR.indexOf(param1) >= 0)
            {
               Main.tracking.trackExam(Main.tracking.TRACK_EXAM_CHUNIN,param1,Main.tracking.TRACK_EXAM_START);
            }
            if(Data.EXAM_JOUNIN_ARR.indexOf(param1) >= 0)
            {
               Main.tracking.trackExam(Main.tracking.TRACK_EXAM_JOUNIN,param1,Main.tracking.TRACK_EXAM_START);
            }
            if(Data.EXAM_SPECIAL_JOUNIN_ARR.indexOf(param1) >= 0)
            {
               Main.tracking.trackExam(Main.tracking.TRACK_EXAM_SPECIAL_JOUNIN,param1,Main.tracking.TRACK_EXAM_START);
            }
            if(Data.EXAM_SPECIAL_JOUNIN_ARR_EASY.indexOf(param1) >= 0)
            {
               Main.tracking.trackExam(Main.tracking.TRACK_EXAM_SPECIAL_JOUNIN,param1,Main.tracking.TRACK_EXAM_START);
            }
            if(Data.EXAM_SENNIN_ARR.indexOf(param1) >= 0)
            {
               Main.tracking.trackExam(Main.tracking.TRACK_EXAM_SENNIN,param1,Main.tracking.TRACK_EXAM_START);
            }
            if(Data.EXAM_SENNIN_ARR_EASY.indexOf(param1) >= 0)
            {
               Main.tracking.trackExam(Main.tracking.TRACK_EXAM_SENNIN,param1,Main.tracking.TRACK_EXAM_START);
            }
            if(sjeArr.indexOf(param1) >= 0)
            {
               _loc4_ = Central.main.getMainChar().getClassSkillListArr();
               if(_loc4_.length > 0)
               {
                  Central.main.oriClassSkill.push(_loc4_[0]);
                  Central.main.getMainChar().foreClearClassSkillListArr();
               }
            }
            _loc3_ = ["msn5","msn6","msn36"];
            if(_loc3_)
            {
               if(_loc3_.indexOf(param1) >= 0)
               {
                  Central.main.isShowMsnADs = true;
               }
            }
            curMissionStep = 0;
            curMission = param2;
            curMissionID = param1;
            curEventStep = 0;
            checkMissionData();
         }
      }
      
      public static function clearMission() : void
      {
         Mixer.getInstance().stopMusic();
         if(curMissionID != null)
         {
            if(isOnMapMission())
            {
               if(mapMissoinDoc)
               {
                  mapMissoinDoc.removeAllChild();
               }
            }
            switch(onMission())
            {
               case TYPE_ENGAGE:
                  Main.resetEngage();
            }
         }
         curMissionStep = 0;
         curMission = null;
         curMissionID = null;
         curEventStep = 0;
         if(Central.main.MISSION_ENGAGE_BG != MissionData.ENGAGE_BG)
         {
            Central.main.MISSION_ENGAGE_RESET = true;
         }
         Central.main.MISSION_ENGAGE_BG = MissionData.ENGAGE_BG;
         isSpecialActionOfEnemy = false;
         state = 0;
      }
      
      public static function pause() : void
      {
         isPause = true;
      }
      
      public static function resume() : void
      {
         isPause = false;
      }
      
      public static function start() : void
      {
         var _loc1_:Object = null;
         var _loc2_:String = null;
         if(curMission != null && !isPause)
         {
            _loc1_ = Main.MISSION_DATA[curMissionID];
            _loc2_ = Main.getHash(missionid);
            Main.disableMenu();
            Main.invisibleMapSideBtn();
            Central.main.battleFlowLog.battles = [];
            Central.main.battleround = -1;
            if(missionid == "msn0")
            {
               dispatchGameEvent();
            }
            else if(curMissionID == "msn284")
            {
               dispatchGameEvent();
            }
            else if(curMissionID == "msn285" || curMissionID == "msn286" || curMissionID == "msn287" || curMissionID == "msn288" || curMissionID == "msn289")
            {
               dispatchGameEvent();
            }
            else if(_loc1_.grade == "S")
            {
               dispatchGameEvent();
            }
            else if(_loc1_.sp > 0)
            {
               dispatchGameEvent();
            }
            else
            {
               Central.main.showAmfLoading();
               Main.amfClient.service("CharacterService.startMission",[Account.getAccountSessionKey(),missionid,_loc2_],settime);
            }
         }
      }
      
      private static function settime(param1:Object) : void
      {
         if(Central.main.validateAmfResponse(param1))
         {
            Central.main.hideAmfLoading();
            Central.main.startBattleId = param1.startBattleId;
         }
         dispatchGameEvent();
      }
      
      public static function dispatchGameEvent(param1:String = null) : Boolean
      {
         if(curMission != null)
         {
            setEventData(curMission.getData(curMissionStep,param1));
            if(curEventData != null)
            {
               return true;
            }
         }
         return false;
      }
      
      public static function setEventData(param1:Array, param2:uint = 1) : void
      {
         var _loc3_:String = null;
         curEventData = param1;
         if(curEventData != null)
         {
            if(curMissionStep == 0 && state == 1)
            {
               ++state;
               stateHash = Main.getHash(state + "_setEventData_" + stateHash);
            }
            curMissionStep += param2;
            curEventStep = 0;
            switch(curEventData[curEventStep].type)
            {
               case EVT_TEXT:
                  Main.showDialogue(curEventData,curEventStep);
                  break;
               case EVT_MC:
                  playCinematics();
                  break;
               case EVT_BATTLE:
                  if(curEventData[curEventStep].enemySelf)
                  {
                     SelfEnemyHPMod = curEventData[curEventStep].enemySelf[0].hpmod;
                     SelfEnemyCPMod = curEventData[curEventStep].enemySelf[0].cpmod;
                     SelfEnemyispet = curEventData[curEventStep].enemySelf[0].ispet;
                     Central.main.showAmfLoading();
                     _loc3_ = String(Central.main.getMainChar().getCharacterId());
                     Main.amfClient.service("CharacterDAO.getCharacterProfileById",[Account.getAccountSessionKey(),_loc3_,true],gotCharacterProfile);
                  }
                  else
                  {
                     Main.setEnemy(curEventData[curEventStep].enemies);
                  }
                  break;
               case EVT_BATTLE_BUTTON:
                  --curMissionStep;
                  Battle.enableButtons(curEventData[curEventStep].buttonArr);
                  break;
               case EVT_MAP_MISSION:
                  if(curMission.mapType == MissionData.MAP_TYPE_MULTIPLE)
                  {
                     setMapMissionEnemies(Mission.curMission.getEnemiesOnMap());
                  }
                  else
                  {
                     setMapMissionEnemies(curEventData[curEventStep].enemies);
                  }
                  Main.initMapMission();
                  break;
               case EVT_ENGAGE:
                  Main.initEngage();
                  break;
               case EVT_FAIL:
                  failMission();
                  break;
               case EVT_FINISH:
                  completeMission();
                  break;
               case EVT_HIDE:
            }
         }
      }
      
      private static function nextStep() : void
      {
         var _loc1_:String = null;
         if(curMission != null)
         {
            ++curEventStep;
            if(curEventData[curEventStep] == null)
            {
               Main.gotoMap();
               return;
            }
            switch(curEventData[curEventStep].type)
            {
               case EVT_TEXT:
                  Main.showDialogue(curEventData,curEventStep);
                  break;
               case EVT_MC:
                  playCinematics();
                  break;
               case EVT_BATTLE:
                  if(curEventData[curEventStep].enemySelf)
                  {
                     SelfEnemyHPMod = curEventData[curEventStep].enemySelf[0].hpmod;
                     SelfEnemyCPMod = curEventData[curEventStep].enemySelf[0].cpmod;
                     SelfEnemyispet = curEventData[curEventStep].enemySelf[0].ispet;
                     Central.main.showAmfLoading();
                     _loc1_ = String(Central.main.getMainChar().getCharacterId());
                     Main.amfClient.service("CharacterDAO.getCharacterProfileById",[Account.getAccountSessionKey(),_loc1_],gotCharacterProfile);
                  }
                  else
                  {
                     Main.setEnemy(curEventData[curEventStep].enemies);
                  }
                  break;
               case EVT_MAP_MISSION:
                  if(curMission.mapType != MissionData.MAP_TYPE_MULTIPLE)
                  {
                     setMapMissionEnemies(curEventData[curEventStep].enemies);
                  }
                  else
                  {
                     setMapMissionEnemies(Mission.curMission.getEnemiesOnMap());
                  }
                  Main.initMapMission();
                  break;
               case EVT_ENGAGE:
                  Main.initEngage();
                  break;
               case EVT_END:
                  if(curEventData[curEventStep].fn != null)
                  {
                     curEventData[curEventStep].fn();
                  }
                  break;
               case EVT_FINISH:
                  completeMission();
                  break;
               case EVT_FAIL:
                  failMission();
                  break;
               case EVT_HIDE:
            }
         }
      }
      
      public static function gotCharacterProfile(param1:Object) : void
      {
         if(String(param1.status) == AMFData.STATUS_ERROR)
         {
            Central.main.onError(String(param1.error));
            return;
         }
         Central.main.hideAmfLoading();
         var _loc2_:DBCharacter = Central.main.dataParser.parseRawCharacter(param1.result,true);
         var _loc3_:Object = param1.pet_data as Object;
         var _loc4_:Object = {};
         _loc2_.character_id = int(1);
         _loc2_.character_hp *= SelfEnemyHPMod;
         _loc2_.character_cp *= SelfEnemyCPMod;
         _loc2_.character_max_hp *= SelfEnemyHPMod;
         _loc2_.character_max_cp *= SelfEnemyCPMod;
         if(SelfEnemyispet == 1)
         {
            _loc3_.id = int(1);
            _loc4_.petData = _loc3_;
         }
         _loc4_.dbChar = _loc2_;
         Central.battle.subType = BattleData.SUBTYPE_NORMAL;
         Central.main.initChallenge([_loc4_]);
      }
      
      public static function prevMissionStep() : void
      {
         --curMissionStep;
      }
      
      public static function dialogueFinish(param1:uint) : void
      {
         if(curMission != null)
         {
            curEventStep = param1;
            nextStep();
         }
      }
      
      public static function getMovieClip(param1:String) : MovieClip
      {
         var _loc2_:MovieClip = null;
         if(curMission != null)
         {
            _loc2_ = GF.getAsset(curMission,param1);
            if(_loc2_ != null)
            {
               return _loc2_;
            }
         }
         return new MovieClip();
      }
      
      public static function getCloseup() : MovieClip
      {
         var _loc1_:MovieClip = null;
         if(curMission != null)
         {
            _loc1_ = curMission.getAsset("closeup");
            if(_loc1_ != null)
            {
               return _loc1_;
            }
         }
         return new MovieClip();
      }
      
      public static function onMission() : String
      {
         if(curMission)
         {
            return curMission.type;
         }
         return null;
      }
      
      public static function getMapMissionType() : uint
      {
         if(curMission)
         {
            return curMission.mapType;
         }
         return 0;
      }
      
      public static function setMapMissionEnemies(param1:Array) : void
      {
         if(curMission != null)
         {
            enemiesArr = param1;
         }
      }
      
      public static function getMapMissionEnemies() : Array
      {
         if(curMission != null)
         {
            return enemiesArr;
         }
         return [];
      }
      
      public static function getSetting() : Object
      {
         if(curMission.getSetting != null)
         {
            return curMission.getSetting();
         }
         return {};
      }
      
      public static function isOnMapMission() : Boolean
      {
         if(curMission != null)
         {
            if(curMission.type != null)
            {
               return curMission.type == TYPE_MAP_MISSION ? true : false;
            }
         }
         return false;
      }
      
      public static function setCurrentEnemy(param1:uint) : void
      {
         currentEnemyIndex = param1;
      }
      
      public static function getCurrentEnemy() : int
      {
         return currentEnemyIndex;
      }
      
      public static function setMapMission(param1:MovieClip) : void
      {
         mapMissoinDoc = param1;
      }
      
      public static function getMapMissionExit() : MovieClip
      {
         if(getMapMissionType() == MissionData.MAP_TYPE_MULTIPLE)
         {
            return getCurrentMap()["exitMc"];
         }
         return mapMissoinDoc["exitMc"];
      }
      
      public static function mapMissionFinish() : void
      {
         if(dispatchGameEvent(GameEvents.MAP_MISSION_FINISH))
         {
            return;
         }
         Main.gotoMap();
      }
      
      public static function getCurrentMap() : MovieClip
      {
         if(curMission != null && getMapMissionType() == MissionData.MAP_TYPE_MULTIPLE)
         {
            return curMission.currentMap;
         }
         return null;
      }
      
      public static function hitMapMissionLink(param1:uint) : void
      {
         var _loc2_:Object = null;
         var _loc3_:MovieClip = null;
         if(curMission)
         {
            if(curMission.id == "msn133")
            {
               if(param1 == 0)
               {
                  if(curMission.Counter + 1 < curMission.MapIndex)
                  {
                     Central.main.showInfo(Central.main.langLib.get(571));
                     _loc2_ = getSetting();
                     _loc3_ = Central.main.getMainChar().getSwf();
                     _loc3_.x = _loc2_.charPos.x;
                     _loc3_.y = _loc2_.charPos.y;
                     _loc3_.scaleX = _loc2_.scale * _loc2_.charDir;
                     _loc3_.scaleY = _loc2_.scale;
                     return;
                  }
               }
            }
            curMission.gotoNextMap(param1);
            setMapMissionEnemies(curMission.getEnemiesOnMap());
            Main.loadMapEnemies();
         }
      }
      
      public static function reshowMap() : void
      {
         if(mapMissoinDoc)
         {
            mapMissoinDoc.reshow();
         }
      }
      
      public static function hitMapObject(param1:String) : Boolean
      {
         if(curMission)
         {
            return curMission.hitMapObject(param1);
         }
         return false;
      }
      
      public static function playCinematics() : void
      {
         var mc:MovieClip = null;
         try
         {
            mc = GF.getAsset(curMission,curEventData[curEventStep].name);
            if(curEventData[curEventStep].fn != null)
            {
               curMission[curEventData[curEventStep].fn](mc);
            }
            curMission.initCinematics(mc);
         }
         catch(e:Error)
         {
            Out.error("Mission","playCinematics :: Step 1 :: " + e.getStackTrace());
            Main.submitLogDump();
         }
         Main.playCinematics(mc);
      }
      
      public static function finishCinematics() : void
      {
         if(curMissionID != null)
         {
         }
         Main.removeMC();
         nextStep();
      }
      
      public static function engageEnemy() : void
      {
         var _loc1_:Array = curMission.enemies;
         Out.debug("Mission","engageEnemy :: enemies.length " + _loc1_.length);
         Main.setEnemy(_loc1_);
      }
      
      public static function engageGoal() : void
      {
         Out.debug("Mission","engageGoal");
         Main.gotoMap();
      }
      
      public static function get minEngageNum() : uint
      {
         return curMission.minEngageNum;
      }
      
      public static function get maxEngageNum() : uint
      {
         return curMission.maxEngageNum;
      }
      
      public static function get engageHitChance() : Number
      {
         return curMission.engageHitChance;
      }
      
      public static function get checkPointNum() : uint
      {
         return curMission.checkPointNum;
      }
      
      public static function set engageHitChance(param1:Number) : void
      {
         curMission.engageHitChance = param1;
      }
      
      public static function set checkPointNum(param1:uint) : void
      {
         curMission.checkPointNum = param1;
      }
      
      public static function completeMission() : void
      {
         var missionData:Object;
         var mainChar:Character;
         var xp:int;
         var xpBonus:int;
         var rewardArr:Array;
         var baseMissionGold:int;
         var goldBonus:int;
         var tp:int;
         var partyMembers:Array;
         var isExam:Boolean;
         var tpMultiplierBonus:Number;
         var levelup:Boolean;
         var doublexpgoldTime:int = 0;
         var i:uint = 0;
         var tmpEffect:Object = null;
         var member:* = undefined;
         var msnRecord:Object = null;
         var mainCharWeapon:Object = null;
         var mainCharBackItem:Object = null;
         var tmpEffectB:Object = null;
         var level:int = 0;
         var gearObj:Object = null;
         var key:String = null;
         var charGearset:Object = null;
         var setEffect:Object = null;
         Out.debug("Mission","completeMission :: curMissionID " + curMissionID);
         ++state;
         stateHash = Main.getHash(state + "_completeMission_" + stateHash);
         missionData = Main.MISSION_DATA[curMissionID];
         mainChar = Main.getMainChar();
         xp = 0;
         xpBonus = 0;
         rewardArr = [];
         baseMissionGold = int(missionData.gold);
         goldBonus = 0;
         tp = 0;
         partyMembers = Central.main.partyMembers;
         if(partyMembers)
         {
            i = 0;
            while(i < partyMembers.length)
            {
               member = partyMembers[i];
               member.isDead = false;
               member.updateHP(member.maxHP);
               i++;
            }
         }
         doublexpgoldTime = Central.main.doublexpTime - (getTimer() / 1000 - Central.main.doublexpLastUpdateTime);
         Main.tracking.trackMission(missionData);
         isExam = false;
         if(Data.EXAM_CHUNIN_ARR.indexOf(curMissionID) >= 0)
         {
            Main.tracking.trackExam(Main.tracking.TRACK_EXAM_CHUNIN,curMissionID,Main.tracking.TRACK_EXAM_SUCCESS);
            isExam = true;
         }
         if(Data.EXAM_JOUNIN_ARR.indexOf(curMissionID) >= 0)
         {
            Main.tracking.trackExam(Main.tracking.TRACK_EXAM_JOUNIN,curMissionID,Main.tracking.TRACK_EXAM_SUCCESS);
            isExam = true;
         }
         if(Data.EXAM_SPECIAL_JOUNIN_ARR.indexOf(curMissionID) >= 0)
         {
            Main.tracking.trackExam(Main.tracking.TRACK_EXAM_SPECIAL_JOUNIN,curMissionID,Main.tracking.TRACK_EXAM_SUCCESS);
            Central.main.getMainChar().foreClearClassSkillListArr();
            isExam = true;
            if(Central.main.oriClassSkill.length > 0)
            {
               Central.main.getMainChar().setClassSkillListArr(Central.main.oriClassSkill[0]);
               Central.main.getMainChar().setSkillList(Central.main.oriClassSkill);
            }
         }
         if(Data.EXAM_SPECIAL_JOUNIN_ARR_EASY.indexOf(curMissionID) >= 0)
         {
            Main.tracking.trackExam(Main.tracking.TRACK_EXAM_SPECIAL_JOUNIN,curMissionID,Main.tracking.TRACK_EXAM_SUCCESS);
            Central.main.getMainChar().foreClearClassSkillListArr();
            isExam = true;
            if(Central.main.oriClassSkill.length > 0)
            {
               Central.main.getMainChar().setClassSkillListArr(Central.main.oriClassSkill[0]);
               Central.main.getMainChar().setSkillList(Central.main.oriClassSkill);
            }
         }
         if(Data.EXAM_SENNIN_ARR.indexOf(curMissionID) >= 0)
         {
            Main.tracking.trackExam(Main.tracking.TRACK_EXAM_SPECIAL_JOUNIN,curMissionID,Main.tracking.TRACK_EXAM_SUCCESS);
            isExam = true;
         }
         if(Data.EXAM_SENNIN_ARR_EASY.indexOf(curMissionID) >= 0)
         {
            Main.tracking.trackExam(Main.tracking.TRACK_EXAM_SPECIAL_JOUNIN,curMissionID,Main.tracking.TRACK_EXAM_SUCCESS);
            isExam = true;
         }
         if(isExam)
         {
            msnRecord = mainChar.checkMissionRecord(curMissionID);
            Main.tracking.trackExamTry(curMissionID,int(msnRecord.fail));
            isExam = false;
            msnRecord = {};
         }
         if(Central.main.Features.FEATURE_DOUBLE_GOLD)
         {
            baseMissionGold *= 2;
         }
         if(mainChar.getData(DBCharacterData.RANK) >= RankData.CHUNIN)
         {
            xp = Formula.calcXpPenalty(mainChar.getLevel() - int(missionData.level),missionData.xp);
         }
         else
         {
            xp = int(missionData.xp);
         }
         if(Central.main.Features.FEATURE_DOUBLE_XP)
         {
            switch(curMissionID)
            {
               case "msn0":
               case "msn46":
               case "msn54":
               case "msn105":
               case "msn106":
               case "msn107":
                  break;
               default:
                  xpBonus += xp;
            }
         }
         if(doublexpgoldTime > 0)
         {
            xpBonus += xp;
            goldBonus += baseMissionGold;
         }
         if(Central.main.getMainChar().getWeapon())
         {
            mainCharWeapon = Central.main.WEAPON_DATA.find(Central.main.getMainChar().getWeapon());
            if(mainCharWeapon)
            {
               for each(tmpEffect in mainCharWeapon.effect)
               {
                  switch(tmpEffect.type)
                  {
                     case "xp_bouns":
                        xpBonus += tmpEffect.amount;
                        break;
                     case "gold_bouns":
                        goldBonus += tmpEffect.amount;
                  }
               }
            }
         }
         tpMultiplierBonus = 1;
         if(Central.main.getMainChar().getBackItem())
         {
            mainCharBackItem = Central.main.BACK_ITEM_DATA.find(Central.main.getMainChar().getBackItem());
            if(mainCharBackItem)
            {
               for each(tmpEffectB in mainCharBackItem.effect)
               {
                  switch(tmpEffectB.type)
                  {
                     case "xp_bouns":
                        xpBonus += tmpEffectB.amount;
                        break;
                     case "gold_bouns":
                        goldBonus += tmpEffectB.amount;
                        break;
                     case "tp_double":
                        tpMultiplierBonus = 2;
                        break;
                     case "gold_bonus_percent":
                        goldBonus += int(baseMissionGold * tmpEffectB.amount / 100);
                        break;
                     case "xp_bonus_percent":
                        xpBonus += int(xp * tmpEffectB.amount / 100);
                        break;
                     case "xp_double":
                        level = int(Central.main.getMainChar().getLevel());
                        switch(Central.main.getMainChar().getBackItem())
                        {
                           case "back459":
                              if(level >= 1 && level <= 10)
                              {
                                 xpBonus += xp;
                              }
                              break;
                           case "back460":
                              if(level >= 11 && level <= 20)
                              {
                                 xpBonus += xp;
                              }
                              break;
                           case "back461":
                              if(level >= 1 && level <= 20)
                              {
                                 xpBonus += xp;
                              }
                              break;
                           default:
                              xpBonus += xp;
                        }
                  }
               }
            }
         }
         if(Central.main.getMainChar().getGearset())
         {
            gearObj = Central.main.getMainChar().getGearset();
            for(key in gearObj)
            {
               charGearset = Central.main.GEAR_SET_DATA.find(key);
               i = 0;
               while(i < gearObj[key] - 1)
               {
                  setEffect = charGearset.effect[i];
                  switch(setEffect.type)
                  {
                     case "xp_bouns":
                        xpBonus += setEffect.amount;
                  }
                  i++;
               }
            }
         }
         if(Data.GRADE_A_MISSION_ARR.indexOf(curMissionID) >= 0 || Data.GRADE_B_MISSION_ARR.indexOf(curMissionID) >= 0 || Data.GRADE_C_MISSION_ARR.indexOf(curMissionID) >= 0)
         {
            if(Central.main.isDoubleXP() > 0)
            {
               xpBonus += xp;
            }
         }
         if(missionData.sp == 0 && missionData.grade != "S")
         {
            if(Central.main.extraData.emblem_xp_bonus_times > 0)
            {
               Central.main.emblem_xp_bonus_amount = NumberUtil.randomInt(15,30) / 100;
               xpBonus += xp * Central.main.emblem_xp_bonus_amount;
            }
         }
         levelup = mainChar.updateXP(xp + xpBonus);
         updateDailyTask(DailyTaskData.TYPE_MISSION,1);
         if(missionData.sp == 0)
         {
            mainChar.saveGold(baseMissionGold + goldBonus);
         }
         tp = int(missionData.tp);
         tp *= tpMultiplierBonus;
         if(Central.main.Features.FEATURE_DOUBLE_TP)
         {
            tp *= 2;
         }
         mainChar.saveTP(tp);
         mainChar.addMissionRecord(curMissionID,"success");
         if(curMissionID == "msn284")
         {
            tmpCurMissionID = curMissionID;
            Mission.HalloweenComplete2015 = 0;
            trace(Central.main.Halloween2015EnemyList.toString() + Central.main.getMainChar().itemUsedInBattle.toString() + 0);
            Central.main.amfClient.service("HalloweenEvent2015.finishBattle",[Account.getAccountSessionKey(),Central.main.Halloween2015EnemyList,Central.main.getMainChar().itemUsedInBattle,Mission.HalloweenComplete2015,Main.getHash(Central.main.Halloween2015EnemyList.toString() + Central.main.getMainChar().itemUsedInBattle.toString() + 0)],getHalloween2015Response);
         }
         else if(curMissionID == "msn285" || curMissionID == "msn286" || curMissionID == "msn287" || curMissionID == "msn288" || curMissionID == "msn289")
         {
            tmpCurMissionID = curMissionID;
            Central.main.amfClient.service("Anni7th.finishBattle",[Account.getAccountSessionKey(),curMissionID,Central.main.getMainChar().itemUsedInBattle,0,Main.getHash(curMissionID + Central.main.getMainChar().itemUsedInBattle.toString() + 0)],get7thResponse);
         }
         else if(missionData.grade == "S")
         {
            tmpCurMissionID = curMissionID;
            Mission.sMissioncomplete = 0;
            Central.main.amfClient.service("SLevelMission.finishMission",[Account.getAccountSessionKey(),curMissionID,Central.main.getMainChar().itemUsedInBattle,Mission.sMissioncomplete,Main.getHash(curMissionID + 0 + Central.main.getMainChar().itemUsedInBattle.toString())],getSGradeResponse);
            Central.main.getMainChar().itemUsedInBattle = [];
         }
         else if(missionData.sp > 0)
         {
            Central.main.amfClient.service("SSTraining.finishSSMission",[Account.getAccountSessionKey(),curMissionID,Central.main.getMainChar().itemUsedInBattle,0,Central.main.getHash(curMissionID + 0)],function(param1:Object):*
            {
               param1.update_inventory.showPopup = false;
               if(Central.main.validateAmfResponse(param1))
               {
                  return;
               }
            });
            Central.main.getMainChar().itemUsedInBattle = [];
         }
         else if(missionData.sp == 0 && missionData.grade != "S")
         {
            Main.getMainChar().updateDB(xp + xpBonus,baseMissionGold + goldBonus,[],curMissionID,0,Mission,stateHash);
            Main.achievement.updateCharStat(Main.achievementData.MISSION_COMPLETED);
            Main.achievement.checkSpecialAchievement(Main.achievementData.SPECIFIC_MISSION_COMPLETED);
         }
         if(missionData.special)
         {
            Main.achievement.updateCharStat(Main.achievementData.SPECIAL_MISSION_COMPLETED);
         }
         if(missionData.daily)
         {
            Main.achievement.updateCharStat(Main.achievementData.DAILY_MISSION_COMPLETED);
         }
         if(curMission.keepParty == false)
         {
            Main.removePartyNpc();
            Main.partyMembers = null;
            Main.emptyRecruitedFriends();
         }
         clearMission();
         Battle.setBattleBg();
         Main.updateMenu();
         Main.gotoMap();
         Main.showMissionComplete(missionData,levelup);
         Main.showAds = true;
      }
      
      private static function getSGradeResponse(param1:Object) : void
      {
         var _loc2_:Array = null;
         if(param1.update_inventory)
         {
            param1.update_inventory.showPopup = false;
         }
         if(Main.validateAmfResponse(param1))
         {
            if(Mission.sMissioncomplete == 1)
            {
               return;
            }
            _loc2_ = param1.update_inventory.add_item_id;
            param1.update_inventory.add_item_id = null;
            Main.showSMissionReward = true;
            Main.sMissionRewardItem = _loc2_[0];
            Main.sMissionRewardList = param1.reward_list;
            Main.MISSION_DATA[tmpCurMissionID].xp = _loc2_[1].replace("xp","").replace("_1","");
            Main.MISSION_DATA[tmpCurMissionID].gold = _loc2_[2].replace("gold","").replace("_1","");
         }
      }
      
      private static function getHalloween2015Response(param1:Object) : void
      {
         var _loc2_:Array = null;
         Central.main.Halloween2015RewardList = [];
         if(param1.update_inventory)
         {
            param1.update_inventory.showPopup = false;
         }
         if(Main.validateAmfResponse(param1))
         {
            if(Mission.HalloweenComplete2015 == 1)
            {
               return;
            }
            _loc2_ = param1.update_inventory.add_item_id;
            Central.main.showHalloween2015Reward = true;
            Central.main.Halloween2015RewardList = param1.update_inventory.add_item_id;
            Main.MISSION_DATA[tmpCurMissionID].xp = _loc2_[0].replace("xp","").replace("_1","");
            Main.MISSION_DATA[tmpCurMissionID].gold = _loc2_[1].replace("gold","").replace("_1","");
         }
      }
      
      private static function get7thResponse(param1:Object) : void
      {
         var _loc2_:Array = null;
         if(param1.update_inventory)
         {
            param1.update_inventory.showPopup = false;
         }
         if(Main.validateAmfResponse(param1))
         {
            _loc2_ = param1.update_inventory.add_item_id;
            Main.MISSION_DATA[tmpCurMissionID].xp = _loc2_[0].replace("xp","");
            Main.MISSION_DATA[tmpCurMissionID].gold = _loc2_[1].replace("gold","");
         }
      }
      
      public static function failMission() : void
      {
         var missionData:Object;
         var curMsnSetting:Object = null;
         var isExam:Boolean = false;
         if(Data.EXAM_CHUNIN_ARR.indexOf(curMissionID) >= 0)
         {
            Main.tracking.trackExam(Main.tracking.TRACK_EXAM_CHUNIN,curMissionID,Main.tracking.TRACK_EXAM_FAIL);
            isExam = true;
         }
         if(Data.EXAM_JOUNIN_ARR.indexOf(curMissionID) >= 0)
         {
            Main.tracking.trackExam(Main.tracking.TRACK_EXAM_JOUNIN,curMissionID,Main.tracking.TRACK_EXAM_FAIL);
            isExam = true;
         }
         if(Data.EXAM_SPECIAL_JOUNIN_ARR.indexOf(curMissionID) >= 0)
         {
            Main.tracking.trackExam(Main.tracking.TRACK_EXAM_SPECIAL_JOUNIN,curMissionID,Main.tracking.TRACK_EXAM_FAIL);
            Central.main.getMainChar().foreClearClassSkillListArr();
            isExam = true;
            if(Central.main.oriClassSkill.length > 0)
            {
               Central.main.getMainChar().setClassSkillListArr(Central.main.oriClassSkill[0]);
               Central.main.getMainChar().setSkillList(Central.main.oriClassSkill);
            }
         }
         if(Data.EXAM_SPECIAL_JOUNIN_ARR_EASY.indexOf(curMissionID) >= 0)
         {
            Main.tracking.trackExam(Main.tracking.TRACK_EXAM_SPECIAL_JOUNIN,curMissionID,Main.tracking.TRACK_EXAM_FAIL);
            Central.main.getMainChar().foreClearClassSkillListArr();
            isExam = true;
            if(Central.main.oriClassSkill.length > 0)
            {
               Central.main.getMainChar().setClassSkillListArr(Central.main.oriClassSkill[0]);
               Central.main.getMainChar().setSkillList(Central.main.oriClassSkill);
            }
         }
         if(isExam)
         {
            curMsnSetting = getSetting();
            if(curMsnSetting != null)
            {
               if(curMsnSetting.curStage != null)
               {
                  Central.main.tracking.trackExamPart(Central.mission.curMissionID,curMsnSetting.curStage,Central.main.tracking.TRACK_FAIL);
               }
            }
            isExam = false;
            curMsnSetting = {};
         }
         Main.getMainChar().addMissionRecord(curMissionID,"fail");
         missionData = Main.MISSION_DATA[curMissionID];
         if(curMissionID == "msn284")
         {
            Mission.HalloweenComplete2015 = 1;
            Central.main.amfClient.service("HalloweenEvent2015.finishBattle",[Account.getAccountSessionKey(),Central.main.Halloween2015EnemyList,Central.main.getMainChar().itemUsedInBattle,Mission.HalloweenComplete2015,Main.getHash(Central.main.Halloween2015EnemyList + Central.main.getMainChar().itemUsedInBattle.toString() + 1)],getHalloween2015Response);
         }
         else if(curMissionID == "msn285" || curMissionID == "msn286" || curMissionID == "msn287" || curMissionID == "msn288" || curMissionID == "msn289")
         {
            Central.main.amfClient.service("Anni7th.finishBattle",[Account.getAccountSessionKey(),curMissionID,Central.main.getMainChar().itemUsedInBattle,1,Main.getHash(curMissionID + Central.main.getMainChar().itemUsedInBattle.toString() + 1)],getHalloween2015Response);
         }
         else if(missionData.grade == "S")
         {
            Mission.sMissioncomplete = 1;
            Central.main.amfClient.service("SLevelMission.finishMission",[Account.getAccountSessionKey(),curMissionID,Central.main.getMainChar().itemUsedInBattle,Mission.sMissioncomplete,Main.getHash(curMissionID + 1 + Central.main.getMainChar().itemUsedInBattle.toString())],getSGradeResponse);
            Central.main.getMainChar().itemUsedInBattle = [];
         }
         else if(missionData.sp > 0)
         {
            Central.main.amfClient.service("SSTraining.finishSSMission",[Account.getAccountSessionKey(),curMissionID,Central.main.getMainChar().itemUsedInBattle,1,Central.main.getHash(curMissionID + 1)],function(param1:Object):*
            {
               if(Central.main.validateAmfResponse(param1))
               {
                  return;
               }
            });
            Central.main.getMainChar().itemUsedInBattle = [];
         }
         else if(missionData.sp == 0 && missionData.grade != "S")
         {
            Main.getMainChar().updateDB(0,0,[],curMissionID,1,Mission);
         }
         clearMission();
         Main.showInfo(Central.main.langLib.get(410));
         Main.gotoMap();
         Main.achievement.updateCharStat(Main.achievementData.MISSION_FAILED);
         Main.showDeadPopup();
      }
      
      public static function killMapEnemy() : void
      {
         if(curMission)
         {
            if(enemiesArr == null)
            {
               return;
            }
            if(enemiesArr[currentEnemyIndex] == null)
            {
               return;
            }
            enemiesArr[currentEnemyIndex].died = true;
            if(getMapMissionType() == MissionData.MAP_TYPE_MULTIPLE)
            {
               curMission.enemiesKilled();
            }
         }
      }
      
      public static function getDailyTask(param1:* = true) : Boolean
      {
         var _loc2_:Object = null;
         if(Main.getMainChar().getLevel() >= 20 && checkDailyTaskStatus() == 1)
         {
            _loc2_ = Main.getMainChar().getInventory(InventoryData.TYPE_DAILY_TASK);
            if(_loc2_.type == DailyTaskData.TYPE_XP)
            {
               Main.getMainChar().clearInventory(InventoryData.TYPE_DAILY_TASK);
            }
         }
         if((checkDailyTaskStatus() == 0 || checkDailyTaskStatus() == -1) && Main.getMainChar().getLevel() >= 3)
         {
            _loc2_ = getRandomDailyTask();
            Main.getMainChar().setInventory(InventoryData.TYPE_DAILY_TASK,_loc2_);
            Main.updateMapSideBtn();
            if(param1)
            {
               Main.showDailyTask();
               return true;
            }
            return false;
         }
         return false;
      }
      
      private static function getRandomDailyTask() : Object
      {
         var _loc1_:Object = {};
         var _loc2_:int = Math.ceil(NumberUtil.randomNumber(0,3.999));
         while(Main.getMainChar().getLevel() >= 15 && _loc2_ == 1)
         {
            _loc2_ = Math.ceil(NumberUtil.randomNumber(0,3.999));
         }
         _loc1_.completeTime = 0;
         _loc1_.amount = 0;
         switch(_loc2_)
         {
            case 0:
               _loc1_.type = DailyTaskData.TYPE_CHALLENGE;
               _loc1_.total = Main.getMainChar().getLevel();
               if(_loc1_.total < 2)
               {
                  _loc1_.total = 2;
               }
               if(_loc1_.total > 5)
               {
                  _loc1_.total = 5;
               }
               break;
            case 1:
               _loc1_.type = DailyTaskData.TYPE_XP;
               _loc1_.total = Main.getMainChar().getLevel() * 20;
               if(_loc1_.total > 400)
               {
                  _loc1_.total = 400;
               }
               break;
            case 2:
               _loc1_.type = DailyTaskData.TYPE_RECRUIT;
               _loc1_.total = Main.getMainChar().getLevel();
               if(_loc1_.total < 2)
               {
                  _loc1_.total = 2;
               }
               if(_loc1_.total > 6)
               {
                  _loc1_.total = 6;
               }
               break;
            default:
               _loc1_.type = DailyTaskData.TYPE_MISSION;
               _loc1_.total = Main.getMainChar().getLevel();
               if(_loc1_.total < 2)
               {
                  _loc1_.total = 2;
               }
               if(_loc1_.total > 4)
               {
                  _loc1_.total = 4;
               }
         }
         return _loc1_;
      }
      
      public static function updateDailyTask(param1:String, param2:int) : void
      {
         var _loc3_:Object = Main.getMainChar().getInventory(InventoryData.TYPE_DAILY_TASK);
         if(_loc3_ != null)
         {
            if(_loc3_.completeTime == 0)
            {
               if(_loc3_.type == param1)
               {
                  _loc3_.amount += param2;
                  if(_loc3_.amount > _loc3_.total)
                  {
                     _loc3_.amount = _loc3_.total;
                  }
                  Main.getMainChar().setInventory(InventoryData.TYPE_DAILY_TASK,_loc3_);
                  if(Main.checkGameStatus() == Timeline.MAP)
                  {
                     Main.updateMapSideBtn();
                  }
                  Main.getMainChar().updateDailyTask(_loc3_);
               }
            }
         }
      }
      
      public static function checkDailyTaskStatus() : int
      {
         var _loc1_:Object = Main.getMainChar().getInventory(InventoryData.TYPE_DAILY_TASK);
         if(_loc1_ == null)
         {
            return 0;
         }
         if(_loc1_.completeTime == 0 && _loc1_.amount < _loc1_.total)
         {
            return 1;
         }
         if(_loc1_.completeTime == 0 && _loc1_.amount == _loc1_.total)
         {
            return 2;
         }
         if(_loc1_.completeTime > 0)
         {
            return -2;
         }
         return -9;
      }
      
      public static function finishDailyTask() : void
      {
         var _loc1_:Object = Central.main.getMainChar().getInventory(InventoryData.TYPE_DAILY_TASK);
         _loc1_.completeTime = Central.main.serverTime;
         Central.main.getMainChar().setInventory(InventoryData.TYPE_DAILY_TASK,_loc1_);
      }
   }
}

