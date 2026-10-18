package ninjasaga
{
   import bitemycode.facebook.FBUser;
   import br.com.stimuli.loading.loadingtypes.*;
   import com.adobe.serialization.json.JSON;
   import com.dynamicflash.util.Base64;
   import com.utils.CreateFilter;
   import com.utils.Environment;
   import com.utils.GF;
   import com.utils.NumberUtil;
   import com.utils.Out;
   import com.utils.Sha1Encrypt;
   import flash.display.*;
   import flash.events.*;
   import flash.filters.ColorMatrixFilter;
   import flash.geom.Point;
   import flash.media.Sound;
   import flash.net.*;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import flash.utils.*;
   import gs.*;
   import gs.easing.Linear;
   import ninjasaga.battle.*;
   import ninjasaga.data.*;
   import ninjasaga.dbclass.DBCharacter;
   import ninjasaga.linkage.BattleDoc;
   import ninjasaga.loader.AssetLoader;
   import ninjasaga.objects.Npc;
   import ninjasaga.objects.Pet;
   
   public final class Battle
   {
      
      public static const REMATCH_TIME_LIMIT:int = 31;
      
      private static var battleMc:BattleDoc;
      
      public static var round:uint;
      
      private static var attacker:*;
      
      private static var defender:*;
      
      private static var selectedTarget:*;
      
      public static var partyArr:Array;
      
      public static var enemyArr:Array;
      
      public static var petArr:Array;
      
      private static var battleMusic:Sound;
      
      private static var battleBgDefault:MovieClip;
      
      private static var battleBg:MovieClip;
      
      private static var consumablesUsedHash:String;
      
      private static var rematchTimes:uint;
      
      private static var bWaitingToStartRematch:Boolean;
      
      private static var battleType:String;
      
      public static const TYPE_LOCAL:String = "local";
      
      public static const TYPE_NETWORK:String = "network";
      
      private static var _battleResult:uint;
      
      private static var repGain:int;
      
      private static var prestigeGain:int;
      
      public static var feedReward:Object;
      
      public static var lastBattleAction:Object;
      
      public static var showEffectCharId:String;
      
      public static var log_time:int;
      
      public static var log_server_time:int;
      
      public static var log_total_time:int;
      
      public static var log_time_user:String;
      
      public static var whole_battle_time:int;
      
      public static var start_battle_time:int;
      
      public static var finish_battle_time:int;
      
      private static var bRematchAnyPlayerOpponentLeft:Boolean;
      
      private static var bRematchTimedOut:Boolean;
      
      private static var bRematchPressedOk:Boolean;
      
      private static var bRematchOnePlayerWantRematch:Boolean;
      
      public static var commandActionSyncData:Array;
      
      private static var throck:Object;
      
      private static var myPvEReward:Array;
      
      private static var myPvEScore:int;
      
      private static var middleRowY:Number;
      
      private static var rewardList:Array;
      
      private static var characterArr:Array = [];
      
      private static var onBattleMusic:Boolean = false;
      
      public static var whattodo:int = 0;
      
      private static var atbDisplayObj:Object = {};
      
      private static var isShowLevelUp:Boolean = false;
      
      private static var tweenGroup:TweenGroup = new TweenGroup();
      
      public static var consumablesUsed:uint = 0;
      
      public static var subType:uint = 0;
      
      private static var connectingAmf:Boolean = false;
      
      private static var battleLog:String = "";
      
      private static var disconnect:Boolean = false;
      
      public static var bossId:String = "";
      
      public static var seal_enemy:Boolean = false;
      
      public static var use_seal_enemy:Boolean = false;
      
      public static var spy_enemy:Boolean = false;
      
      private static var bossRewardXp:int = 0;
      
      private static var bossRewardPetXp:int = 0;
      
      private static var bossRewardGold:int = 0;
      
      private static var bossRewardWeapon:int = 0;
      
      private static var bossRewardMagatama:int = 0;
      
      private static var eventBossArr:Array = ["enemy309","enemy310","enemy311","enemy312","enemy313","enemy314","enemy315","enemy317"];
      
      private static var isEventEnd:Boolean = Central.main.isEventEnd;
      
      private static var isOldHunting:Boolean = Central.main.isOldHunting;
      
      public static var roomId:int = 0;
      
      private static var huntingHash:String = "";
      
      private static var isVDay2017:Boolean = Central.main.isVDay2017;
      
      private static var ClanWarHash:String = "";
      
      private static var bossRewardSkill:int = 0;
      
      public static var isPartyControllable:Boolean = false;
      
      public static var AttackerRandomSkillSlot:int = 999;
      
      public static var DefenderRandomSkillSlot:int = 999;
      
      private static var pvpSyncLogSaved:Boolean = false;
      
      private static var pvpLogTimeSaved:Boolean = false;
      
      private static var isTriggerSkill2002:Boolean = false;
      
      public static var isPlayingSkillAnimation:Boolean = false;
      
      public static var syncCoolDownObj:Object = {};
      
      public static var noCoolDown:Boolean = false;
      
      public static var loadingQuitArr:Array = [];
      
      private static var defaultTarget:* = null;
      
      private static var canSelectparty:Boolean = false;
      
      private static var _selectedPartySkillID:int = -1;
      
      public static var holdTargetIsMember:* = null;
      
      private static var canSelectpartyDead:Boolean = false;
      
      private static const dimFilter:ColorMatrixFilter = CreateFilter.getSaturationFilter(0);
      
      private static var bGearBtnEnabled:Boolean = true;
      
      private static var throckrewardList:Array = [];
      
      public static var battleRoundCounter:int = 0;
      
      private static var battleDamageLog:int = 0;
      
      public static var specialHpData:Object = {
         "display":true,
         "textCatch":"catch",
         "textRangeLess":0,
         "textRangeOver":0,
         "texthpTxt":"",
         "canClick":true,
         "textButton":"catch now",
         "clickFn":new Function(),
         "showConfirm":false,
         "textShowConfirm":"use",
         "textShowConfirmDetailUse":"",
         "textShowConfirmDetailBuy":"",
         "itemId":"",
         "iconData":new Object(),
         "specialRate":1,
         "showGlowBackground":false
      };
      
      public static var isActionBarShow:Boolean = false;
      
      private static var myCurrencyGain:int = 0;
      
      private static var myEventCurrencyGain:int = 0;
      
      private static var myPointGain:int = 0;
      
      private static var pvpCurrencyGainDisplay:Boolean = false;
      
      private static var pvpEventCurrencyGainDisplay:Boolean = false;
      
      private static var pvpPointGainDisplay:Boolean = false;
      
      private static var pvpshowMyDisconnectText:Boolean = false;
      
      public static var isCompletedDailyFirstBonus:Boolean = false;
      
      public function Battle()
      {
         super();
      }
      
      private static function get selectedPartySkillID() : int
      {
         return _selectedPartySkillID;
      }
      
      private static function set selectedPartySkillID(param1:int) : void
      {
         if(!canSelectparty && param1 != -1)
         {
            Out.error("Battle","Party Skill selected when Select Party not allowed.");
         }
         if(param1 > 7 || param1 < -1)
         {
            Out.error("Battle","Party Skill selected invalid, skillPos=" + param1 + ".");
         }
         _selectedPartySkillID = param1;
      }
      
      public static function getConstructor() : *
      {
         return Battle.prototype.constructor;
      }
      
      public static function setBattleMusic(param1:Sound) : void
      {
         battleMusic = param1;
      }
      
      public static function setBattleBg(param1:MovieClip = null) : void
      {
         battleBg = param1;
      }
      
      public static function get battleResult() : uint
      {
         return _battleResult;
      }
      
      public static function set battleResult(param1:uint) : void
      {
         _battleResult = param1;
      }
      
      public static function changeBg(param1:MovieClip) : void
      {
         if(battleMc != null)
         {
            GF.removeAllChild(battleMc["bgHolder"]);
            battleMc["bgHolder"].addChild(param1);
            if(Mission.curMissionID == "msn135")
            {
               battleMc["bgHolder"].getChildAt(battleMc["bgHolder"].numChildren - 1).name = "bg";
            }
         }
      }
      
      public static function initBattle(param1:BattleDoc) : void
      {
         var classSkillList:Array;
         var i:*;
         var clanEffect:Object = null;
         var hpBonus:int = 0;
         var cpBonus:int = 0;
         var dmgBonus:int = 0;
         var _battleMc:BattleDoc = param1;
         battleMc = _battleMc;
         Main.hideMenu();
         Main.disableMenu();
         Main.invisibleMapSideBtn();
         bRematchAnyPlayerOpponentLeft = false;
         bRematchTimedOut = false;
         bRematchPressedOk = false;
         bRematchOnePlayerWantRematch = false;
         bWaitingToStartRematch = false;
         isTriggerSkill2002 = false;
         isPlayingSkillAnimation = false;
         classSkillList = Central.main.getMainChar().getClassSkillListArr();
         i = 0;
         while(i < classSkillList.length)
         {
            if(classSkillList[i] == "skill2002")
            {
               isTriggerSkill2002 = true;
            }
            i++;
         }
         battleBgDefault = Central.main.getLib("BattleBG");
         battleBgDefault.name = "";
         if(battleBg == null)
         {
            changeBg(battleBgDefault);
            Out.debug("","load default bg");
         }
         else
         {
            changeBg(battleBg);
            Out.debug("","load bg~~~");
         }
         resetVariables();
         partyArr = new Array();
         enemyArr = new Array();
         petArr = [];
         disconnect = false;
         Main.getMainChar().setBattleActionCB(actionFinish_CB);
         Main.getMainChar().setBattleAttackHitCB(attackHit_CB);
         Main.getMainChar().resetBattleData();
         Main.showMapCoin(false);
         characterArr.push(Main.getMainChar());
         if(subType == BattleData.SUBTYPE_CLAN)
         {
            clanEffect = {};
            hpBonus = Clan.proc.getAttackerBonus(ClanData.CLAN_HP_BONUS);
            if(hpBonus > 0)
            {
               clanEffect[ClanData.CLAN_HP_BONUS] = {};
               clanEffect[ClanData.CLAN_HP_BONUS].amount = hpBonus;
            }
            cpBonus = Clan.proc.getAttackerBonus(ClanData.CLAN_CP_BONUS);
            if(cpBonus > 0)
            {
               clanEffect[ClanData.CLAN_CP_BONUS] = {};
               clanEffect[ClanData.CLAN_CP_BONUS].amount = cpBonus;
            }
            dmgBonus = Clan.proc.getAttackerBonus(ClanData.CLAN_DAMAGE_BONUS);
            if(dmgBonus > 0)
            {
               clanEffect[ClanData.CLAN_DAMAGE_BONUS] = {};
               clanEffect[ClanData.CLAN_DAMAGE_BONUS].amount = dmgBonus;
            }
            Main.getMainChar().clanEffect = clanEffect;
            Main.getMainChar().restoreOriginalStatus();
            Main.getMainChar().updateBattleFrame();
            Main.updateMenu();
         }
         if(Mission.curMissionID == null)
         {
            Mission.isSpecialActionOfEnemy = false;
         }
         try
         {
            Main.tracking.trackBattleWeapon();
         }
         catch(err:Error)
         {
            Out.error("Battle","initBattle :: TRACKING - trackBattleWeapon");
         }
      }
      
      private static function resetVariables() : void
      {
         round = 0;
         attacker = null;
         defender = null;
         selectedTarget = null;
         consumablesUsed = 0;
         consumablesUsedHash = Sha1Encrypt.encrypt(String(0));
         rematchTimes = 0;
         battleResult = 0;
         repGain = 0;
         battleLog = "";
         bossRewardXp = 0;
         bossRewardGold = 0;
         bossRewardWeapon = 0;
         bossRewardMagatama = 0;
         bossRewardSkill = 0;
      }
      
      public static function resetBattleSetting() : void
      {
         var i:int = 0;
         try
         {
            resetVariables();
            Main.getMainChar().playStandby();
            Main.getMainChar().resetBattleData();
            atbDisplayObj.main_char.x = 0;
            i = 0;
            while(i < enemyArr.length)
            {
               enemyArr[i].restoreOriginalStatus();
               enemyArr[i].isDead = false;
               enemyArr[i].playStandby();
               enemyArr[i].updateBattleFrame();
               enemyArr[i].resetBattleData();
               atbDisplayObj["enemy_" + i].x = 0;
               i++;
            }
            if(partyArr)
            {
               i = 0;
               while(i < partyArr.length)
               {
                  partyArr[i].restoreOriginalStatus();
                  partyArr[i].isDead = false;
                  partyArr[i].playStandby();
                  partyArr[i].updateBattleFrame();
                  partyArr[i].resetBattleData();
                  atbDisplayObj["party_" + i].x = 0;
                  i++;
               }
            }
            if(petArr)
            {
               i = 0;
               while(i < petArr.length)
               {
                  petArr[i].restoreOriginalStatus();
                  petArr[i].isDead = false;
                  petArr[i].playStandby();
                  petArr[i].updateBattleFrame();
                  petArr[i].resetBattleData();
                  petArr[i].resetSkillCooldown();
                  atbDisplayObj["pet_" + i].x = 0;
                  i++;
               }
            }
            if(Battle.type == TYPE_NETWORK)
            {
               Main.getMainChar().restoreOriginalStatus();
               Main.getMainChar().SetBloodlinePassiveSkill();
               Main.getMainChar().SetSenjutsuPassiveSkill();
               Main.getMainChar().isDead = false;
               Main.getMainChar().updateBattleFrame();
               Main.updateMenu();
            }
            consumablesUsed = 0;
            consumablesUsedHash = Sha1Encrypt.encrypt(String(0));
         }
         catch(e:Error)
         {
            Out.error("Battle","resetBattle :: " + e.getStackTrace());
            Main.submitLogDump();
         }
      }
      
      private static function sendResetBattleMessage() : void
      {
         var _loc1_:Object = {};
         _loc1_.event = "info";
         _loc1_.state = "reset";
         Out.debug("sendData_event=" + _loc1_.event + ":" + _loc1_.state + " CharacterID=" + Main.getMainChar().getData(DBCharacterData.ID),"");
         Central.client.getInstance().sendData(_loc1_);
      }
      
      public static function addEnemy(param1:*) : void
      {
         var _loc3_:Object = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc2_:Object = {};
         _loc2_.name = param1.getData(DBCharacterData.NAME);
         _loc2_.id = String(param1.getData(DBCharacterData.ID));
         _loc2_.agility = param1.agility;
         Central.client.getInstance().addEnemy(_loc2_);
         param1.side = BattleData.SIDE_HOSTILE;
         param1.setBattleActionCB(actionFinish_CB);
         param1.setBattleAttackHitCB(attackHit_CB);
         param1.updateBattleFrame();
         param1.resetBattleData();
         if(subType == BattleData.SUBTYPE_CLAN)
         {
            _loc3_ = {};
            _loc4_ = Clan.proc.getDefenderBonus(ClanData.CLAN_HP_BONUS);
            if(_loc4_ > 0)
            {
               _loc3_[ClanData.CLAN_HP_BONUS] = {};
               _loc3_[ClanData.CLAN_HP_BONUS].amount = _loc4_;
            }
            _loc5_ = Clan.proc.getDefenderBonus(ClanData.CLAN_CP_BONUS);
            if(_loc5_ > 0)
            {
               _loc3_[ClanData.CLAN_CP_BONUS] = {};
               _loc3_[ClanData.CLAN_CP_BONUS].amount = _loc5_;
            }
            _loc6_ = Clan.proc.getDefenderBonus(ClanData.CLAN_DAMAGE_BONUS);
            if(_loc6_ > 0)
            {
               _loc3_[ClanData.CLAN_DAMAGE_BONUS] = {};
               _loc3_[ClanData.CLAN_DAMAGE_BONUS].amount = _loc6_;
            }
            param1.clanEffect = _loc3_;
            param1.restoreOriginalStatus();
            param1.updateBattleFrame();
         }
         enemyArr.push(param1);
         characterArr.push(param1);
      }
      
      public static function addParty(param1:*) : void
      {
         var _loc3_:Object = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc2_:Object = {};
         _loc2_.name = param1.getData(DBCharacterData.NAME);
         _loc2_.id = String(param1.getData(DBCharacterData.ID));
         _loc2_.agility = param1.agility;
         Central.client.getInstance().addParty(_loc2_);
         param1.setBattleActionCB(actionFinish_CB);
         param1.setBattleAttackHitCB(attackHit_CB);
         param1.resetBattleData();
         if(subType == BattleData.SUBTYPE_CLAN)
         {
            _loc3_ = {};
            _loc4_ = Clan.proc.getAttackerBonus(ClanData.CLAN_HP_BONUS);
            if(_loc4_ > 0)
            {
               _loc3_[ClanData.CLAN_HP_BONUS] = {};
               _loc3_[ClanData.CLAN_HP_BONUS].amount = _loc4_;
            }
            _loc5_ = Clan.proc.getAttackerBonus(ClanData.CLAN_CP_BONUS);
            if(_loc5_ > 0)
            {
               _loc3_[ClanData.CLAN_CP_BONUS] = {};
               _loc3_[ClanData.CLAN_CP_BONUS].amount = _loc5_;
            }
            _loc6_ = Clan.proc.getAttackerBonus(ClanData.CLAN_DAMAGE_BONUS);
            if(_loc6_ > 0)
            {
               _loc3_[ClanData.CLAN_DAMAGE_BONUS] = {};
               _loc3_[ClanData.CLAN_DAMAGE_BONUS].amount = _loc6_;
            }
            param1.clanEffect = _loc3_;
            param1.restoreOriginalStatus();
         }
         param1.updateBattleFrame();
         partyArr.push(param1);
         characterArr.push(param1);
      }
      
      public static function addPet(param1:Pet) : void
      {
         var _loc3_:Object = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc2_:Object = {};
         _loc2_.name = param1.getData(DBCharacterData.NAME);
         _loc2_.id = param1.getData(DBCharacterData.ID);
         _loc2_.agility = param1.agility;
         Central.client.getInstance().addPet(_loc2_);
         param1.setBattleActionCB(actionFinish_CB);
         param1.setBattleAttackHitCB(attackHit_CB);
         param1.resetBattleData();
         param1.resetSkillCooldown();
         if(subType == BattleData.SUBTYPE_CLAN)
         {
            _loc3_ = {};
            switch(param1.side)
            {
               case BattleData.SIDE_FRIENDLY:
                  _loc4_ = Clan.proc.getAttackerBonus(ClanData.CLAN_HP_BONUS);
                  _loc5_ = Clan.proc.getAttackerBonus(ClanData.CLAN_CP_BONUS);
                  _loc6_ = Clan.proc.getAttackerBonus(ClanData.CLAN_DAMAGE_BONUS);
                  break;
               case BattleData.SIDE_HOSTILE:
                  _loc4_ = Clan.proc.getDefenderBonus(ClanData.CLAN_HP_BONUS);
                  _loc5_ = Clan.proc.getDefenderBonus(ClanData.CLAN_CP_BONUS);
                  _loc6_ = Clan.proc.getDefenderBonus(ClanData.CLAN_DAMAGE_BONUS);
            }
            if(_loc4_ > 0)
            {
               _loc3_[ClanData.CLAN_HP_BONUS] = {};
               _loc3_[ClanData.CLAN_HP_BONUS].amount = _loc4_;
            }
            if(_loc5_ > 0)
            {
               _loc3_[ClanData.CLAN_CP_BONUS] = {};
               _loc3_[ClanData.CLAN_CP_BONUS].amount = _loc5_;
            }
            if(_loc6_ > 0)
            {
               _loc3_[ClanData.CLAN_DAMAGE_BONUS] = {};
               _loc3_[ClanData.CLAN_DAMAGE_BONUS].amount = _loc6_;
            }
            param1.clanEffect = _loc3_;
            param1.restoreOriginalStatus();
         }
         param1.updateBattleFrame();
         petArr.push(param1);
      }
      
      public static function restoreMainChar() : void
      {
         battleMc.addMainChar();
      }
      
      public static function onBattleStart() : void
      {
         var _loc4_:MovieClip = null;
         var _loc5_:uint = 0;
         var _loc6_:TextFormat = null;
         var _loc7_:String = null;
         battleMc["autoBattleBtn"].visible = false;
         var _loc1_:int = int(battleMc["atbBar"]["holder"].numChildren);
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_)
         {
            battleMc["atbBar"]["holder"].removeChildAt(0);
            _loc2_++;
         }
         var _loc3_:Array = [];
         if(!Central.main.mixer.isPlayingMusic())
         {
            if(battleMusic == null)
            {
               battleMusic = Sound(Main.getLib("BattleBGM"));
            }
            if(Mission.curMissionID == "msn0")
            {
               _loc3_.push(Sound(Main.getLib("TutorialBGM")));
            }
            else if(battleMusic != null)
            {
               _loc3_.push(battleMusic);
            }
            Central.main.mixer.playMusic(_loc3_);
            onBattleMusic = true;
         }
         _loc4_ = Main.getMainChar().getStaticFullBody();
         _loc4_.scaleX = -Data.BATTLE_ATB_CHAR_SCALE;
         _loc4_.scaleY = Data.BATTLE_ATB_CHAR_SCALE;
         _loc4_.y = 0 - _loc4_.height;
         atbDisplayObj.main_char = _loc4_;
         battleMc["atbBar"]["holder"].addChild(_loc4_);
         Out.debug("","resetCharMc Main.getMainChar() = " + GF.printObject(Main.getMainChar()));
         Out.debug("","Main.getMainChar() type = " + typeof Main.getMainChar());
         Main.getMainChar().resetCharMc();
         _loc5_ = 0;
         while(_loc5_ < enemyArr.length)
         {
            _loc4_ = enemyArr[_loc5_].getStaticFullBody();
            _loc4_.scaleX = -Data.BATTLE_ATB_CHAR_SCALE;
            _loc4_.scaleY = Data.BATTLE_ATB_CHAR_SCALE;
            if(Boolean(enemyArr[_loc5_].limb) && enemyArr[_loc5_].limb > 1)
            {
               if(_loc5_ == 0)
               {
                  battleMc["atbBar"]["holder"].addChild(_loc4_);
               }
            }
            else
            {
               battleMc["atbBar"]["holder"].addChild(_loc4_);
            }
            atbDisplayObj["enemy_" + _loc5_] = _loc4_;
            enemyArr[_loc5_].resetCharMc();
            _loc5_++;
         }
         if(partyArr)
         {
            _loc5_ = 0;
            while(_loc5_ < partyArr.length)
            {
               _loc4_ = partyArr[_loc5_].getStaticFullBody();
               _loc4_.scaleX = -Data.BATTLE_ATB_CHAR_SCALE;
               _loc4_.scaleY = Data.BATTLE_ATB_CHAR_SCALE;
               atbDisplayObj["party_" + _loc5_] = _loc4_;
               battleMc["atbBar"]["holder"].addChild(_loc4_);
               partyArr[_loc5_].resetCharMc();
               _loc5_++;
            }
         }
         if(petArr)
         {
            _loc5_ = 0;
            while(_loc5_ < petArr.length)
            {
               _loc4_ = petArr[_loc5_].getStaticFullBody();
               _loc4_.scaleX = -Data.BATTLE_ATB_CHAR_SCALE;
               _loc4_.scaleY = Data.BATTLE_ATB_CHAR_SCALE;
               atbDisplayObj["pet_" + _loc5_] = _loc4_;
               battleMc["atbBar"]["holder"].addChild(_loc4_);
               petArr[_loc5_].resetCharMc();
               _loc5_++;
            }
         }
         if(Battle.type == TYPE_NETWORK || Central.main.HitAi == true)
         {
            _loc6_ = new TextFormat();
            _loc6_.font = "Arial";
            _loc6_.size = 14;
            battleMc["chatDisplayMc"].setStyle("textFormat",_loc6_);
            battleMc["chatDisplayMc"].bgAlpha = 0.5;
            battleMc["chatDisplayMc"].bgOpaqueColor = 0;
            battleMc["chatDisplayMc"].visible = true;
            Main.mapMenu.showChatInput();
            _loc7_ = "";
            if(Central.main.PvpBattleType == "quickMatch" || Central.main.PvpBattleType == "tournament" || Central.main.HitAi == true)
            {
               _loc7_ = "scrollDisplayMc_1";
            }
            if(Central.main.PvpBattleType == "private")
            {
               _loc5_ = 0;
               while(_loc5_ < Central.main.PvpPVMode)
               {
                  if(Central.main.PvpTeamA[_loc5_] == Main.getMainChar().getData(DBCharacterData.ID))
                  {
                     _loc7_ = "scrollDisplayMc_" + (_loc5_ + 1);
                  }
                  if(Central.main.PvpTeamB[_loc5_] == Main.getMainChar().getData(DBCharacterData.ID))
                  {
                     _loc7_ = "scrollDisplayMc_" + (_loc5_ + 1);
                  }
                  _loc5_++;
               }
            }
            if(Central.main.PvpBattleType != "PVE")
            {
               _loc5_ = 1;
               while(_loc5_ <= BattleData.CONSUMABLE_LIMIT)
               {
                  battleMc[_loc7_]["scroll_" + String(_loc5_)].gotoAndStop(1);
                  _loc5_++;
               }
            }
            start_battle_time = int(getTimeStamp());
         }
         else
         {
            ++Central.main.battleround;
            battleMc["chatDisplayMc"].visible = false;
            Main.mapMenu.hideChatInput();
         }
         if(!Central.main.isOldHunting)
         {
            Central.main.logHuntingMission(true);
         }
         if(Central.main.senjutsuFeature)
         {
            Central.main.senninModeBtn.visible = true;
            Central.main.senninModeBtn.mouseEnabled = false;
            Central.main.senninModeBtn.mouseChildren = false;
            Central.main.senninModeBtn.filters = [dimFilter];
         }
      }
      
      public static function startBattle() : void
      {
         var i:uint = 0;
         var tmpInt:int = 0;
         if(Battle.type == TYPE_NETWORK)
         {
            bWaitingToStartRematch = false;
         }
         if(Battle.type == TYPE_LOCAL)
         {
            Main.getMainChar().setCharMc(battleMc["playerMc_1"]["charMc"]);
         }
         else if(Battle.type == TYPE_NETWORK)
         {
            Main.getMainChar().setCharMc(battleMc[Main.PvpMainCharMc]["charMc"]);
         }
         if(Boolean(battleMc) && Boolean(battleMc["playerMc_1"]) && Boolean(battleMc["playerMc_1"]["charMc"]))
         {
            middleRowY = battleMc["playerMc_1"]["charMc"].y;
         }
         else
         {
            middleRowY = Main.getMainChar().charMc.y;
         }
         Main.updateMenu();
         if(!Main.dispatchGameEvent(GameEvents.BATTLE_START))
         {
            startATB();
         }
         Mission135_SpecialAction();
         if(Main.getMainChar())
         {
            Main.getMainChar().SetBloodlinePassiveSkill();
            Main.getMainChar().SetSenjutsuPassiveSkill();
         }
         i = 0;
         while(i < enemyArr.length)
         {
            if(enemyArr[i])
            {
               enemyArr[i].SetBloodlinePassiveSkill();
               enemyArr[i].SetSenjutsuPassiveSkill();
               if(Boolean(enemyArr[i].limb) && enemyArr[i].limb > 1)
               {
                  switch(i)
                  {
                     case 0:
                        tmpInt = 1;
                        break;
                     case 1:
                        tmpInt = 0;
                        break;
                     default:
                        tmpInt = int(i);
                  }
               }
               else
               {
                  tmpInt = int(i);
               }
               enemyArr[i].setCharMc(battleMc["enemyMc_" + (i + 1)]["charMc"]);
               enemyArr[i].updateBattleFrame();
            }
            i++;
         }
         if(partyArr)
         {
            i = 0;
            while(i < partyArr.length)
            {
               if(partyArr[i])
               {
                  partyArr[i].SetBloodlinePassiveSkill();
                  partyArr[i].SetSenjutsuPassiveSkill();
               }
               i++;
            }
         }
         if(Main.battleModeSpecial && Main.battleModeSpecial == true)
         {
            specialHpData.showGlowBackground = false;
            specialHpData.showConfirm = false;
            specialHpData.canClick = true;
            specialHpData.display = true;
            specialHpData.lv = enemyArr[0].getLevel();
         }
         if(Battle.type == TYPE_NETWORK)
         {
            try
            {
               Central.main.tracking.generalTrack(Central.main.tracking.TRACK_PVP,Central.main.getMainChar().pet.swfName,"Pet");
               Central.main.tracking.generalTrack(Central.main.tracking.TRACK_PVP,Central.main.getMainChar().getWeapon(),Central.main.tracking.TRACK_WEAPON_TAKEN);
               if(Central.main.account.getAccountType() == Central.main.account.PREMIUM)
               {
                  Central.main.tracking.generalTrack(Central.main.tracking.TRACK_PVP,Central.main.getMainChar().getLevel(),Central.main.tracking.TRACK_START + "Premuim");
               }
               else
               {
                  Central.main.tracking.generalTrack(Central.main.tracking.TRACK_PVP,Central.main.getMainChar().getLevel(),Central.main.tracking.TRACK_START + "Free");
               }
               trackSkillType();
            }
            catch(err:Error)
            {
               Out.error("Battle","startBattle :: TRACKING - trackSkillType");
            }
         }
      }
      
      public static function getCharacterHolder(param1:int) : MovieClip
      {
         var _loc2_:int = 0;
         var _loc3_:int = 3;
         if(battleMc["playerMc_1"].charID == param1)
         {
            return battleMc["playerMc_1"];
         }
         _loc2_ = 1;
         while(_loc2_ < _loc3_)
         {
            if(battleMc["partyMc_" + _loc2_].charID == param1)
            {
               return battleMc["partyMc_" + _loc2_];
            }
            _loc2_++;
         }
         _loc2_ = 1;
         while(_loc2_ < _loc3_ + 1)
         {
            if(battleMc["enemyMc_" + _loc2_].charID == param1)
            {
               return battleMc["enemyMc_" + _loc2_];
            }
            _loc2_++;
         }
         return null;
      }
      
      private static function trackSkillType() : void
      {
         var _loc1_:int = int(Central.main.getMainChar().getLevel());
         var _loc2_:Array = new Array();
         var _loc3_:Array = ["wind","fire","lightning","earth","water"];
         var _loc4_:Boolean = false;
         var _loc5_:Boolean = false;
         var _loc6_:Boolean = false;
         var _loc7_:Boolean = false;
         var _loc8_:Boolean = false;
         var _loc9_:int = 0;
         for(; _loc9_ < _loc3_.length; _loc9_++)
         {
            if(!Central.main.getMainChar().hasSkillType(_loc3_[_loc9_]))
            {
               continue;
            }
            switch(_loc3_[_loc9_])
            {
               case "wind":
                  _loc4_ = true;
                  _loc2_.push(_loc3_[_loc9_]);
                  break;
               case "fire":
                  _loc5_ = true;
                  _loc2_.push(_loc3_[_loc9_]);
                  break;
               case "lightning":
                  _loc6_ = true;
                  _loc2_.push(_loc3_[_loc9_]);
                  break;
               case "earth":
                  _loc7_ = true;
                  _loc2_.push(_loc3_[_loc9_]);
                  break;
               case "water":
                  _loc8_ = true;
                  _loc2_.push(_loc3_[_loc9_]);
            }
         }
         if(_loc2_.length == 1)
         {
            Central.main.tracking.generalTrack(Central.main.tracking.TRACK_PVP_ELEMENTS,_loc1_,_loc2_[0]);
         }
         if(_loc2_.length == 2)
         {
            if(_loc7_ && _loc5_)
            {
               if(Central.main.getMainChar().getLevel() == 80)
               {
                  Central.main.tracking.generalTrack(Central.main.tracking.TRACK_PVP_ELEMENTS,"Earth_Fire","Lv80");
               }
               else
               {
                  Central.main.tracking.generalTrack(Central.main.tracking.TRACK_PVP_ELEMENTS,_loc1_,"Earth_Fire");
               }
            }
            if(_loc7_ && _loc6_)
            {
               if(Central.main.getMainChar().getLevel() == 80)
               {
                  Central.main.tracking.generalTrack(Central.main.tracking.TRACK_PVP_ELEMENTS,"Earth_Lighting","Lv80");
               }
               else
               {
                  Central.main.tracking.generalTrack(Central.main.tracking.TRACK_PVP_ELEMENTS,_loc1_,"Earth_Lighting");
               }
            }
            if(_loc7_ && _loc8_)
            {
               if(Central.main.getMainChar().getLevel() == 80)
               {
                  Central.main.tracking.generalTrack(Central.main.tracking.TRACK_PVP_ELEMENTS,"Earth_Water","Lv80");
               }
               else
               {
                  Central.main.tracking.generalTrack(Central.main.tracking.TRACK_PVP_ELEMENTS,_loc1_,"Earth_Water");
               }
            }
            if(_loc7_ && _loc4_)
            {
               if(Central.main.getMainChar().getLevel() == 80)
               {
                  Central.main.tracking.generalTrack(Central.main.tracking.TRACK_PVP_ELEMENTS,"Earth_Wind","Lv80");
               }
               else
               {
                  Central.main.tracking.generalTrack(Central.main.tracking.TRACK_PVP_ELEMENTS,_loc1_,"Earth_Wind");
               }
            }
            if(_loc5_ && _loc6_)
            {
               if(Central.main.getMainChar().getLevel() == 80)
               {
                  Central.main.tracking.generalTrack(Central.main.tracking.TRACK_PVP_ELEMENTS,"Fire_Lighting","Lv80");
               }
               else
               {
                  Central.main.tracking.generalTrack(Central.main.tracking.TRACK_PVP_ELEMENTS,_loc1_,"Fire_Lighting");
               }
            }
            if(_loc5_ && _loc8_)
            {
               if(Central.main.getMainChar().getLevel() == 80)
               {
                  Central.main.tracking.generalTrack(Central.main.tracking.TRACK_PVP_ELEMENTS,"Fire_Water","Lv80");
               }
               else
               {
                  Central.main.tracking.generalTrack(Central.main.tracking.TRACK_PVP_ELEMENTS,_loc1_,"Fire_Water");
               }
            }
            if(_loc5_ && _loc4_)
            {
               if(Central.main.getMainChar().getLevel() == 80)
               {
                  Central.main.tracking.generalTrack(Central.main.tracking.TRACK_PVP_ELEMENTS,"Fire_Wind","Lv80");
               }
               else
               {
                  Central.main.tracking.generalTrack(Central.main.tracking.TRACK_PVP_ELEMENTS,_loc1_,"Fire_Wind");
               }
            }
            if(_loc6_ && _loc8_)
            {
               if(Central.main.getMainChar().getLevel() == 80)
               {
                  Central.main.tracking.generalTrack(Central.main.tracking.TRACK_PVP_ELEMENTS,"Lighting_Water","Lv80");
               }
               else
               {
                  Central.main.tracking.generalTrack(Central.main.tracking.TRACK_PVP_ELEMENTS,_loc1_,"Lighting_Water");
               }
            }
            if(_loc6_ && _loc4_)
            {
               if(Central.main.getMainChar().getLevel() == 80)
               {
                  Central.main.tracking.generalTrack(Central.main.tracking.TRACK_PVP_ELEMENTS,"Lighting_Wind","Lv80");
               }
               else
               {
                  Central.main.tracking.generalTrack(Central.main.tracking.TRACK_PVP_ELEMENTS,_loc1_,"Lighting_Wind");
               }
            }
            if(_loc8_ && _loc4_)
            {
               if(Central.main.getMainChar().getLevel() == 80)
               {
                  Central.main.tracking.generalTrack(Central.main.tracking.TRACK_PVP_ELEMENTS,"Water_Wind","Lv80");
               }
               else
               {
                  Central.main.tracking.generalTrack(Central.main.tracking.TRACK_PVP_ELEMENTS,_loc1_,"Water_Wind");
               }
            }
         }
         if(_loc2_.length == 3)
         {
            if(_loc7_ && _loc5_ && _loc6_)
            {
               if(Central.main.getMainChar().getLevel() == 80)
               {
                  Central.main.tracking.generalTrack(Central.main.tracking.TRACK_PVP_ELEMENTS,"Earth_Fire_Lighting","Lv80");
               }
               else
               {
                  Central.main.tracking.generalTrack(Central.main.tracking.TRACK_PVP_ELEMENTS,_loc1_,"Earth_Fire_Lighting");
               }
            }
            if(_loc7_ && _loc5_ && _loc8_)
            {
               if(Central.main.getMainChar().getLevel() == 80)
               {
                  Central.main.tracking.generalTrack(Central.main.tracking.TRACK_PVP_ELEMENTS,"Earth_Fire_Water","Lv80");
               }
               else
               {
                  Central.main.tracking.generalTrack(Central.main.tracking.TRACK_PVP_ELEMENTS,_loc1_,"Earth_Fire_Water");
               }
            }
            if(_loc7_ && _loc5_ && _loc4_)
            {
               if(Central.main.getMainChar().getLevel() == 80)
               {
                  Central.main.tracking.generalTrack(Central.main.tracking.TRACK_PVP_ELEMENTS,"Earth_Fire_Wind","Lv80");
               }
               else
               {
                  Central.main.tracking.generalTrack(Central.main.tracking.TRACK_PVP_ELEMENTS,_loc1_,"Earth_Fire_Wind");
               }
            }
            if(_loc7_ && _loc6_ && _loc8_)
            {
               if(Central.main.getMainChar().getLevel() == 80)
               {
                  Central.main.tracking.generalTrack(Central.main.tracking.TRACK_PVP_ELEMENTS,"Earth_Lighting_Water","Lv80");
               }
               else
               {
                  Central.main.tracking.generalTrack(Central.main.tracking.TRACK_PVP_ELEMENTS,_loc1_,"Earth_Lighting");
               }
            }
            if(_loc7_ && _loc6_ && _loc4_)
            {
               if(Central.main.getMainChar().getLevel() == 80)
               {
                  Central.main.tracking.generalTrack(Central.main.tracking.TRACK_PVP_ELEMENTS,"Earth_Lighting_Water","Lv80");
               }
               else
               {
                  Central.main.tracking.generalTrack(Central.main.tracking.TRACK_PVP_ELEMENTS,_loc1_,"Earth_Lighting");
               }
            }
            if(_loc7_ && _loc8_ && _loc4_)
            {
               if(Central.main.getMainChar().getLevel() == 80)
               {
                  Central.main.tracking.generalTrack(Central.main.tracking.TRACK_PVP_ELEMENTS,"Earth_Water_Wind","Lv80");
               }
               else
               {
                  Central.main.tracking.generalTrack(Central.main.tracking.TRACK_PVP_ELEMENTS,_loc1_,"Earth_Water_Wind");
               }
            }
            if(_loc5_ && _loc6_ && _loc8_)
            {
               if(Central.main.getMainChar().getLevel() == 80)
               {
                  Central.main.tracking.generalTrack(Central.main.tracking.TRACK_PVP_ELEMENTS,"Fire_Lighting_Water","Lv80");
               }
               else
               {
                  Central.main.tracking.generalTrack(Central.main.tracking.TRACK_PVP_ELEMENTS,_loc1_,"Fire_Lighting_Water");
               }
            }
            if(_loc5_ && _loc6_ && _loc4_)
            {
               if(Central.main.getMainChar().getLevel() == 80)
               {
                  Central.main.tracking.generalTrack(Central.main.tracking.TRACK_PVP_ELEMENTS,"Fire_Lighting_Wind","Lv80");
               }
               else
               {
                  Central.main.tracking.generalTrack(Central.main.tracking.TRACK_PVP_ELEMENTS,_loc1_,"Fire_Lighting_Wind");
               }
            }
            if(_loc5_ && _loc8_ && _loc4_)
            {
               if(Central.main.getMainChar().getLevel() == 80)
               {
                  Central.main.tracking.generalTrack(Central.main.tracking.TRACK_PVP_ELEMENTS,"Fire_Water_Wind","Lv80");
               }
               else
               {
                  Central.main.tracking.generalTrack(Central.main.tracking.TRACK_PVP_ELEMENTS,_loc1_,"Fire_Water_Wind");
               }
            }
            if(_loc6_ && _loc8_ && _loc4_)
            {
               if(Central.main.getMainChar().getLevel() == 80)
               {
                  Central.main.tracking.generalTrack(Central.main.tracking.TRACK_PVP_ELEMENTS,"Lighting_Water_Wind","Lv80");
               }
               else
               {
                  Central.main.tracking.generalTrack(Central.main.tracking.TRACK_PVP_ELEMENTS,_loc1_,"Lighting_Water_Wind");
               }
            }
         }
      }
      
      public static function onBattle() : void
      {
         if(battleMc)
         {
            if(battleMc["actionBar"])
            {
               battleMc["actionBar"].hide();
               isActionBarShow = false;
               if(Central.main.senjutsuFeature)
               {
                  disableSPButton();
               }
               if(Main.battleModeSpecial && Main.battleModeSpecial == true)
               {
                  Main.hidePopupSpecialHpBar();
               }
            }
         }
         Main.hideMenu();
         Main.disableMenu();
         disableTargetSelection();
         var _loc1_:* = Central.battle.getAttacker();
         _loc1_.hideCmdDisplay();
      }
      
      public static function getAttacker() : *
      {
         return attacker;
      }
      
      public static function getDefender() : *
      {
         return defender;
      }
      
      public static function getShowEffectChar() : String
      {
         return showEffectCharId;
      }
      
      public static function getEnemyArr() : Array
      {
         return enemyArr;
      }
      
      public static function getPetMasterById(param1:uint) : *
      {
         var _loc2_:uint = 0;
         if(Main.getMainChar().pet)
         {
            if(int(Main.getMainChar().pet.getData(DBCharacterData.ID)) == param1)
            {
               return Main.getMainChar();
            }
         }
         _loc2_ = 0;
         while(_loc2_ < enemyArr.length)
         {
            if(enemyArr[_loc2_].type != 4 && Boolean(enemyArr[_loc2_].pet))
            {
               if(int(enemyArr[_loc2_].pet.getData(DBCharacterData.ID)) == param1)
               {
                  return enemyArr[_loc2_];
               }
            }
            _loc2_++;
         }
         if(partyArr)
         {
            _loc2_ = 0;
            while(_loc2_ < partyArr.length)
            {
               if(partyArr[_loc2_].pet)
               {
                  if(int(partyArr[_loc2_].getData(DBCharacterData.ID)) == param1)
                  {
                     return partyArr[_loc2_];
                  }
               }
               _loc2_++;
            }
         }
         return null;
      }
      
      public static function tweenATB(param1:Number, param2:Array) : void
      {
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc7_:int = 0;
         tweenGroup.clear();
         tweenGroup.align = TweenGroup.ALIGN_START;
         var _loc6_:Boolean = false;
         _loc3_ = 0;
         while(_loc3_ < param2.length)
         {
            if(param2[_loc3_].charId == Main.getMainChar().getData(DBCharacterData.ID))
            {
               if(Main.getMainChar().isDead)
               {
                  atbDisplayObj.main_char.x = 0;
               }
               else
               {
                  tweenGroup.push(TweenLite.to(atbDisplayObj.main_char,param1,{
                     "x":param2[_loc3_].moveTo,
                     "ease":Linear.easeNone
                  }));
               }
            }
            else
            {
               _loc4_ = 0;
               while(_loc4_ < enemyArr.length)
               {
                  if(param2[_loc3_].charId == enemyArr[_loc4_].getData(DBCharacterData.ID))
                  {
                     if(Boolean(enemyArr[_loc4_].isDead) && !(enemyArr[_loc4_].limb && enemyArr[_loc4_].limb > 1))
                     {
                        atbDisplayObj["enemy_" + _loc4_].x = 0;
                     }
                     else if(Boolean(enemyArr[_loc4_].limb) && enemyArr[_loc4_].limb > 1)
                     {
                        _loc5_ = 0;
                        while(_loc5_ < enemyArr.length)
                        {
                           if(enemyArr[_loc5_].getCharacterId() == int(enemyArr[_loc5_].getCharacterId() / 10) * 10 + 1)
                           {
                              _loc7_ = int(_loc5_);
                           }
                           _loc5_++;
                        }
                        if(!_loc6_)
                        {
                           tweenGroup.push(TweenLite.to(atbDisplayObj["enemy_" + _loc7_],param1,{
                              "x":param2[_loc3_].moveTo,
                              "ease":Linear.easeNone
                           }));
                           _loc6_ = true;
                        }
                     }
                     else
                     {
                        tweenGroup.push(TweenLite.to(atbDisplayObj["enemy_" + _loc4_],param1,{
                           "x":param2[_loc3_].moveTo,
                           "ease":Linear.easeNone
                        }));
                     }
                     break;
                  }
                  _loc4_++;
               }
               if(partyArr)
               {
                  _loc4_ = 0;
                  while(_loc4_ < partyArr.length)
                  {
                     if(param2[_loc3_].charId == partyArr[_loc4_].getData(DBCharacterData.ID))
                     {
                        if(partyArr[_loc4_].isDead)
                        {
                           atbDisplayObj["party_" + _loc4_].x = 0;
                        }
                        else
                        {
                           tweenGroup.push(TweenLite.to(atbDisplayObj["party_" + _loc4_],param1,{
                              "x":param2[_loc3_].moveTo,
                              "ease":Linear.easeNone
                           }));
                        }
                        break;
                     }
                     _loc4_++;
                  }
               }
               if(petArr)
               {
                  _loc4_ = 0;
                  while(_loc4_ < petArr.length)
                  {
                     if(param2[_loc3_].charId == petArr[_loc4_].getData(DBCharacterData.ID))
                     {
                        if(petArr[_loc4_].isDead)
                        {
                           atbDisplayObj["pet_" + _loc4_].x = 0;
                        }
                        else
                        {
                           tweenGroup.push(TweenLite.to(atbDisplayObj["pet_" + _loc4_],param1,{
                              "x":param2[_loc3_].moveTo,
                              "ease":Linear.easeNone
                           }));
                        }
                        break;
                     }
                     _loc4_++;
                  }
               }
            }
            _loc3_++;
         }
         tweenGroup.onComplete = tweenATBFinish;
      }
      
      public static function tweenATBFinish() : void
      {
         var _loc1_:Object = {};
         _loc1_.event = "info";
         _loc1_.state = "action";
         _loc1_.charId = Main.getMainChar().getData("character_id");
         Central.client.getInstance().sendData(_loc1_);
      }
      
      private static function resetATBPosition() : void
      {
         if(atbDisplayObj.main_char.x >= 600)
         {
            atbDisplayObj.main_char.x = 0;
         }
         var _loc1_:uint = 0;
         _loc1_ = 0;
         while(_loc1_ < enemyArr.length)
         {
            if(atbDisplayObj["enemy_" + _loc1_].x >= 600)
            {
               atbDisplayObj["enemy_" + _loc1_].x = 0;
            }
            _loc1_++;
         }
         if(partyArr)
         {
            _loc1_ = 0;
            while(_loc1_ < partyArr.length)
            {
               if(atbDisplayObj["party_" + _loc1_].x >= 600)
               {
                  atbDisplayObj["party_" + _loc1_].x = 0;
               }
               _loc1_++;
            }
         }
         if(petArr)
         {
            _loc1_ = 0;
            while(_loc1_ < petArr.length)
            {
               if(atbDisplayObj["pet_" + _loc1_].x >= 600)
               {
                  atbDisplayObj["pet_" + _loc1_].x = 0;
               }
               _loc1_++;
            }
         }
      }
      
      public static function startATB() : void
      {
         var _loc1_:Object = {};
         _loc1_.event = "info";
         _loc1_.state = "start_atb";
         _loc1_.charId = Main.getMainChar().getData("character_id");
         Central.client.getInstance().sendData(_loc1_);
      }
      
      public static function checkCanSync(param1:String, param2:Object) : Boolean
      {
         var _loc3_:int = 0;
         var _loc4_:Object = null;
         if(Boolean(param2) && Boolean(param2.debuff))
         {
            _loc3_ = 0;
            while(_loc3_ < param2.debuff.length)
            {
               _loc4_ = param2.debuff[_loc3_];
               if(_loc4_.type == BattleData.EFFECT_CHAOS)
               {
                  return false;
               }
               _loc3_++;
            }
         }
         if(param1 == "pet" || param1 == "enemy")
         {
            return false;
         }
         return true;
      }
      
      public static function characterTurn(param1:String, param2:uint, param3:Object, param4:Object, param5:Array = null) : void
      {
         var _loc6_:uint = 0;
         var _loc7_:Boolean = true;
         _loc7_ = checkCanSync(param1,param3);
         if(_loc7_ == true)
         {
            commandActionSyncData = param5;
         }
         else
         {
            commandActionSyncData = [];
         }
         showEffectCharId = String(param2);
         switch(param1)
         {
            case "player":
               if(param2 == int(Main.getMainChar().getData("character_id")))
               {
                  if(Battle.type == TYPE_NETWORK)
                  {
                     Main.getMainChar().SetSenjutsuPassiveSkill();
                  }
                  Main.getMainChar().updateSkill2003Lv();
                  nextAction(Main.getMainChar(),param3,param4);
                  disablePartySelection();
                  if(isTriggerSkill2002 && !((Central.main.getMainChar() as Character).isBattleDebuffActive(BattleData.EFFECT_STUN) || (Central.main.getMainChar() as Character).isBattleDebuffActive(BattleData.EFFECT_SLEEP)))
                  {
                     isTriggerSkill2002 = false;
                     triggerSkill2002();
                  }
               }
               else
               {
                  _loc6_ = 0;
                  while(_loc6_ < enemyArr.length)
                  {
                     if(param2 == enemyArr[_loc6_].getData(DBCharacterData.ID))
                     {
                        nextAction(enemyArr[_loc6_],param3,param4);
                        break;
                     }
                     _loc6_++;
                  }
                  _loc6_ = 0;
                  while(_loc6_ < partyArr.length)
                  {
                     if(param2 == partyArr[_loc6_].getData(DBCharacterData.ID))
                     {
                        nextAction(partyArr[_loc6_],param3,param4);
                        break;
                     }
                     _loc6_++;
                  }
               }
               break;
            case "enemy":
               _loc6_ = 0;
               while(_loc6_ < enemyArr.length)
               {
                  if(param2 == enemyArr[_loc6_].getData(DBCharacterData.ID))
                  {
                     nextAction(enemyArr[_loc6_],param3,param4);
                     break;
                  }
                  _loc6_++;
               }
               break;
            case "party":
               _loc6_ = 0;
               while(_loc6_ < partyArr.length)
               {
                  if(param2 == partyArr[_loc6_].getData(DBCharacterData.ID))
                  {
                     nextAction(partyArr[_loc6_],param3,param4);
                     break;
                  }
                  _loc6_++;
               }
               break;
            case "pet":
               _loc6_ = 0;
               while(_loc6_ < petArr.length)
               {
                  if(param2 == petArr[_loc6_].getData(DBCharacterData.ID))
                  {
                     nextAction(petArr[_loc6_],param3,param4);
                     break;
                  }
                  _loc6_++;
               }
         }
      }
      
      private static function nextAction(param1:*, param2:Object, param3:Object) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         attacker = param1;
         if(Boolean(attacker.limb) && attacker.limb > 1)
         {
            _loc4_ = 0;
            while(_loc4_ < attacker.limb)
            {
               switch(_loc4_)
               {
                  case 0:
                     _loc5_ = 1;
                     break;
                  case 1:
                     _loc5_ = 0;
                     break;
                  default:
                     _loc5_ = _loc4_;
               }
               getCharacterById(int(attacker.getCharacterId() / 10) * 10 + _loc5_).moveToFront();
               _loc4_++;
            }
         }
         else
         {
            attacker.moveToFront();
         }
         if(param2 == null)
         {
            return;
         }
         if(attacker.isDead)
         {
            actionFinish_CB();
         }
         else
         {
            if(param3)
            {
               attacker.setBattleAction(param3);
            }
            Out.debug("Battle","nextAction :: nextRound");
            Out.debug("Battle","rex:A pvp show word roundObj.debuff.length=" + param2.debuff.length);
            attacker.nextRound(param2);
            Out.debug("Battle","rex:B pvp show word roundObj.debuff.length=" + param2.debuff.length);
            setupAction(param3);
         }
         if(Battle.type == TYPE_LOCAL)
         {
            if(attacker.getData(DBCharacterData.ID) == Main.getMainChar().getData(DBCharacterData.ID))
            {
               ++battleRoundCounter;
            }
            if(attacker.getData(DBCharacterData.ID) == Main.getMainChar().getData(DBCharacterData.ID) && round != 0)
            {
               Mission135_SpecialAction();
            }
         }
      }
      
      public static function resetHpCpLimitOver() : void
      {
         if(attacker.hp > attacker.maxHP)
         {
            attacker.hp == attacker.maxHP;
         }
         if(attacker.cp > attacker.maxCP)
         {
            attacker.cp == attacker.maxCP;
         }
         if(attacker.sp > attacker.maxSP)
         {
            attacker.sp == attacker.maxSP;
         }
         if(defender.hp > defender.maxHP)
         {
            defender.hp == defender.maxHP;
         }
         if(defender.cp > defender.maxCP)
         {
            defender.cp == defender.maxCP;
         }
         if(defender.sp > defender.maxSP)
         {
            defender.sp == defender.maxSP;
         }
         attacker.syncHp(attacker.hp);
         attacker.syncCp(attacker.cp);
         attacker.syncSp(attacker.sp);
         defender.syncHp(defender.hp);
         defender.syncCp(defender.cp);
         defender.syncSp(defender.sp);
      }
      
      public static function syncHpCpCommandAction() : void
      {
         var _loc3_:Object = null;
         var _loc4_:int = 0;
         var _loc5_:* = undefined;
         Out.debug("syncHpCpCommandAction >> ",">>");
         var _loc1_:Array = commandActionSyncData;
         Out.debug("syncHpCpCommandAction","syncData >> " + _loc1_);
         var _loc2_:* = 0;
         while(_loc2_ < _loc1_.length)
         {
            _loc3_ = _loc1_[_loc2_];
            Out.debug("syncHpCpCommandAction","syncObj >> " + GF.printObject(_loc3_));
            if(_loc3_.type == 1 || _loc3_.type == 4)
            {
               _loc4_ = 0;
               while(_loc4_ < Central.main.PvpAllPlayer.length)
               {
                  if(_loc3_.ID == Central.main.PvpAllPlayer[_loc4_])
                  {
                     _loc5_ = getCharacterById(int(_loc3_.ID));
                     Out.debug("syncHpCpCommandAction","SyncHp B4 >> " + _loc5_.hp);
                     Out.debug("syncHpCpCommandAction","SyncCp B4 >> " + _loc5_.cp);
                     Out.debug("syncHpCpCommandAction","SyncSp B4 >> " + _loc5_.sp);
                     _loc5_.syncHp(_loc3_.HP);
                     _loc5_.syncCp(_loc3_.CP);
                     _loc5_.syncSp(_loc3_.SP);
                     Out.debug("syncHpCpCommandAction","SyncHp After >> " + _loc5_.hp);
                     Out.debug("syncHpCpCommandAction","SyncCp After >> " + _loc5_.cp);
                     Out.debug("syncHpCpCommandAction","SyncSp After >> " + _loc5_.sp);
                     _loc5_.updateBattleFrame();
                  }
                  _loc4_++;
               }
            }
            _loc2_++;
         }
         Central.main.updateMenu();
      }
      
      private static function setupAction(param1:Object) : void
      {
         var _loc3_:String = null;
         var _loc5_:uint = 0;
         var _loc6_:int = 0;
         var _loc7_:uint = 0;
         var _loc9_:Object = null;
         var _loc14_:Object = null;
         var _loc2_:Object = attacker.getBattleDebuff();
         var _loc4_:Object = {};
         var _loc8_:uint = 0;
         var _loc10_:Array = [];
         var _loc11_:Array = [];
         var _loc12_:Array = [];
         var _loc13_:Boolean = false;
         if(param1 != null && param1.debuffOverride != true)
         {
            Out.debug("Battle","setupAction :: battleAction >> " + GF.objectToString(param1));
            if(Battle.type == TYPE_NETWORK)
            {
               attacker.setBattleAction(param1);
            }
            if(param1.targetType != null && int(param1.targetId) > 0)
            {
               setDefenderById(param1.targetId);
            }
            else
            {
               defender = Main.getMainChar();
            }
            switch(param1.action)
            {
               case BattleData.EFFECT_SILVER_CHAIN_BUNDLE:
                  attacker.showOverheadNumber(Timeline.WORD,String(Central.main.langLib.get(677)).replace("[valturn]",param1.duration));
            }
            _loc4_.battleAction = param1;
            _loc4_.targetId = param1.targetId;
            callBattleAction(_loc4_);
            return;
         }
         if(Battle.type == TYPE_LOCAL || attacker.getData("character_id") == Main.getMainChar().getData("character_id"))
         {
            _loc13_ = true;
         }
         else if(Main.getMainChar().pet != null)
         {
            if(attacker.getData(DBCharacterData.ID) == Main.getMainChar().pet.getData(DBCharacterData.ID))
            {
               _loc13_ = true;
            }
         }
         if(_loc13_)
         {
            for(_loc3_ in _loc2_)
            {
               switch(_loc3_)
               {
                  case BattleData.EFFECT_CUBE_ILLUSION:
                     if(_loc2_[_loc3_] != null)
                     {
                        if(_loc2_[_loc3_].duration > 0)
                        {
                           if(Battle.type != TYPE_NETWORK)
                           {
                              defender.showOverheadNumber(Timeline.WORD,String(Central.main.langLib.get(674)).replace("[valturn]",Math.round(_loc2_[_loc3_].duration).toString()));
                           }
                        }
                     }
               }
            }
            if(attacker.constructor == Enemy)
            {
               _loc10_.push(Main.getMainChar());
               if(partyArr)
               {
                  _loc5_ = 0;
                  while(_loc5_ < partyArr.length)
                  {
                     if(!partyArr[_loc5_].isDead)
                     {
                        _loc10_.push(partyArr[_loc5_]);
                     }
                     _loc5_++;
                  }
               }
               defender = _loc10_[Math.floor(NumberUtil.randomNumber(0,_loc10_.length - 0.001))];
               whattodo = 11;
               sendCommand();
            }
            if(attacker.constructor == AICharacter)
            {
               attacker.skillCheck();
               if(isPartyControllable == true)
               {
                  if(selectedTarget)
                  {
                     selectedTarget.hideSelection();
                     if(selectedTarget.isDead)
                     {
                        _loc5_ = 0;
                        while(_loc5_ < enemyArr.length)
                        {
                           if(!enemyArr[_loc5_].isDead)
                           {
                              selectedTarget = enemyArr[_loc5_];
                              break;
                           }
                           _loc5_++;
                        }
                     }
                  }
                  else
                  {
                     _loc5_ = 0;
                     while(_loc5_ < enemyArr.length)
                     {
                        if(!enemyArr[_loc5_].isDead)
                        {
                           selectedTarget = enemyArr[_loc5_];
                           break;
                        }
                        _loc5_++;
                     }
                  }
                  selectedTarget.displaySelection();
                  defender = selectedTarget;
                  onPlayerCommand();
               }
               else
               {
                  if(attacker.friendly)
                  {
                     _loc5_ = 0;
                     while(_loc5_ < enemyArr.length)
                     {
                        if(!enemyArr[_loc5_].isDead)
                        {
                           _loc9_ = enemyArr[_loc5_].getBattleDebuff();
                           if(_loc9_[BattleData.EFFECT_SLEEP] == null)
                           {
                              _loc10_.push(_loc5_);
                           }
                           else
                           {
                              _loc11_.push(_loc5_);
                           }
                        }
                        _loc5_++;
                     }
                     _loc6_ = Math.floor(Main.getMainChar().hp / Main.getMainChar().maxHP * 100);
                     holdTargetIsMember = Main.getMainChar();
                     _loc5_ = 0;
                     while(_loc5_ < partyArr.length)
                     {
                        if(!partyArr[_loc5_].isDead && partyArr[_loc5_] != attacker)
                        {
                           if(Math.floor(partyArr[_loc5_].hp / partyArr[_loc5_].maxHP * 100) < _loc6_)
                           {
                              holdTargetIsMember = partyArr[_loc5_];
                           }
                        }
                        _loc5_++;
                     }
                     if(_loc10_.length == 0)
                     {
                        _loc7_ = uint(_loc11_[Math.floor(NumberUtil.randomNumber(0,_loc11_.length - 0.001))]);
                     }
                     else
                     {
                        _loc7_ = uint(_loc10_[Math.floor(NumberUtil.randomNumber(0,_loc10_.length - 0.001))]);
                     }
                     defender = enemyArr[_loc7_];
                  }
                  else
                  {
                     _loc6_ = 0;
                     _loc5_ = 0;
                     while(_loc5_ < enemyArr.length)
                     {
                        if(!enemyArr[_loc5_].isDead && enemyArr[_loc5_] != attacker)
                        {
                           if(_loc6_ == 0 || Math.floor(enemyArr[_loc5_].hp / enemyArr[_loc5_].maxHP * 100) < _loc6_)
                           {
                              _loc6_ = Math.floor(enemyArr[_loc5_].hp / enemyArr[_loc5_].maxHP * 100);
                              holdTargetIsMember = enemyArr[_loc5_];
                           }
                        }
                        _loc5_++;
                     }
                     defender = Main.getMainChar();
                  }
                  sendCommand();
               }
            }
            if(attacker.constructor == Npc)
            {
               _loc5_ = 0;
               while(_loc5_ < enemyArr.length)
               {
                  if(!enemyArr[_loc5_].isDead)
                  {
                     _loc9_ = enemyArr[_loc5_].getBattleDebuff();
                     if(_loc9_[BattleData.EFFECT_SLEEP] == null)
                     {
                        _loc10_.push(_loc5_);
                     }
                     else
                     {
                        _loc11_.push(_loc5_);
                     }
                  }
                  _loc5_++;
               }
               if(_loc10_.length == 0)
               {
                  _loc7_ = uint(_loc11_[Math.floor(NumberUtil.randomNumber(0,_loc11_.length - 0.001))]);
               }
               else
               {
                  _loc7_ = uint(_loc10_[Math.floor(NumberUtil.randomNumber(0,_loc10_.length - 0.001))]);
               }
               defender = enemyArr[_loc7_];
               whattodo = 12;
               sendCommand();
            }
            if(attacker.constructor == Character)
            {
               if(selectedTarget)
               {
                  selectedTarget.hideSelection();
                  if(selectedTarget.isDead)
                  {
                     _loc5_ = 0;
                     while(_loc5_ < enemyArr.length)
                     {
                        if(!enemyArr[_loc5_].isDead)
                        {
                           selectedTarget = enemyArr[_loc5_];
                           break;
                        }
                        _loc5_++;
                     }
                  }
               }
               else
               {
                  _loc5_ = 0;
                  while(_loc5_ < enemyArr.length)
                  {
                     if(!enemyArr[_loc5_].isDead)
                     {
                        selectedTarget = enemyArr[_loc5_];
                        break;
                     }
                     _loc5_++;
                  }
               }
               selectedTarget.displaySelection();
               defender = selectedTarget;
               if(param1 != null)
               {
                  if(param1.debuffOverride == true)
                  {
                     _loc14_ = {};
                     _loc14_[BattleData.EFFECT_STUN] = Main.langLib.get(281);
                     _loc14_[BattleData.EFFECT_PET_FREEZE] = Main.langLib.get(820);
                     _loc14_[BattleData.EFFECT_PETRIFICATION] = Main.langLib.get(954);
                     _loc14_[BattleData.EFFECT_SLEEP] = Main.langLib.get(280);
                     _loc14_[BloodlineData.EFFECT_HALLUCINATIONS + ".skill1020"] = Main.langLib.get(820);
                     _loc14_[BattleData.EFFECT_CHAOS] = Main.langLib.get(734);
                     _loc14_[BattleData.EFFECT_FEAR] = Main.langLib.get(304);
                     if(_loc2_[BattleData.EFFECT_CHAOS])
                     {
                        Main.showInfo(String(Central.main.langLib.get(1454)).replace("[valamount]",_loc14_[BattleData.EFFECT_CHAOS]));
                     }
                     else
                     {
                        Main.showInfo(String(Central.main.langLib.get(1454)).replace("[valamount]",_loc14_[param1.action]));
                     }
                  }
               }
               onPlayerCommand();
            }
            if(attacker.constructor == Pet)
            {
               if(attacker.side == BattleData.SIDE_FRIENDLY)
               {
                  _loc5_ = 0;
                  while(_loc5_ < enemyArr.length)
                  {
                     if(!enemyArr[_loc5_].isDead)
                     {
                        _loc9_ = enemyArr[_loc5_].getBattleDebuff();
                        if(_loc9_[BattleData.EFFECT_SLEEP] == null)
                        {
                           _loc10_.push(_loc5_);
                        }
                        else
                        {
                           _loc11_.push(_loc5_);
                           defender = enemyArr[_loc5_];
                        }
                     }
                     _loc5_++;
                  }
                  if(_loc10_.length != 0)
                  {
                     _loc7_ = uint(_loc10_[Math.floor(NumberUtil.randomNumber(0,_loc10_.length - 0.001))]);
                     defender = enemyArr[_loc7_];
                  }
               }
               if(attacker.side == BattleData.SIDE_HOSTILE)
               {
                  defender = Main.getMainChar();
               }
               whattodo = 13;
               sendCommand();
            }
         }
      }
      
      private static function sendCommand() : void
      {
         var _loc1_:Object = {};
         _loc1_.event = "info";
         _loc1_.state = "battle_command";
         _loc1_.charId = attacker.getCharacterId();
         _loc1_.targetId = defender.getCharacterId();
         _loc1_.battleAction = attacker.getBattleAction();
         Central.client.getInstance().sendData(_loc1_);
      }
      
      public static function callBattleAction(param1:Object) : void
      {
         var _loc3_:int = 0;
         var _loc4_:Object = null;
         var _loc5_:Object = null;
         var _loc6_:String = null;
         var _loc7_:String = null;
         var _loc8_:Object = null;
         Out.debug("Battle","callBattleAction :: _dataObj >> " + GF.printObject(param1));
         var _loc2_:Object = param1.battleAction;
         lastBattleAction = _loc2_;
         if(attacker.getData(DBCharacterData.ID) == Main.getMainChar().getData(DBCharacterData.ID))
         {
            ++round;
            Out.debug("","rex round counter= " + round);
         }
         if(_loc2_.action == "weapon_attack")
         {
            _loc5_ = Central.main.WEAPON_DATA.find(attacker.getWeapon());
            _loc6_ = _loc5_[WeaponData.ANIMATION];
            switch(_loc6_)
            {
               case "attack_01":
                  _loc7_ = PositionType.MELEE_2;
                  break;
               default:
                  _loc7_ = PositionType.MELEE_1;
            }
            _loc2_.animation = _loc6_;
            _loc2_.posType = _loc7_;
         }
         attacker.setBattleAction(_loc2_);
         setDefenderById(param1.targetId);
         if(_loc2_.attackerBuff)
         {
            _loc3_ = 0;
            while(_loc3_ < _loc2_.attackerBuff.length)
            {
               if(Battle.type == TYPE_NETWORK)
               {
                  _loc4_ = _loc2_.attackerBuff[_loc3_];
                  attacker.setBattleBuff(_loc4_);
               }
               _loc3_++;
            }
         }
         if(_loc2_.attackerDebuff)
         {
            _loc3_ = 0;
            while(_loc3_ < _loc2_.attackerDebuff.length)
            {
               if(checkResisted(_loc2_.attackerDebuff[_loc3_].resisted,attacker) == false)
               {
                  _loc4_ = _loc2_.attackerDebuff[_loc3_];
                  attacker.setBattleDebuff(_loc4_);
               }
               else
               {
                  attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(484));
               }
               _loc3_++;
            }
         }
         if(_loc2_.defenderBuff)
         {
            _loc3_ = 0;
            while(_loc3_ < _loc2_.defenderBuff.length)
            {
               if(Battle.type == TYPE_NETWORK)
               {
                  _loc4_ = _loc2_.defenderBuff[_loc3_];
                  defender.setBattleBuff(_loc4_);
               }
               _loc3_++;
            }
         }
         if(_loc2_.defenderDebuff)
         {
            _loc3_ = 0;
            while(_loc3_ < _loc2_.defenderDebuff.length)
            {
               if(checkResisted(_loc2_.defenderDebuff[_loc3_].resisted,defender) == false)
               {
                  _loc4_ = _loc2_.defenderDebuff[_loc3_];
                  defender.setBattleDebuff(_loc4_);
               }
               else
               {
                  defender.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(484));
               }
               _loc3_++;
            }
         }
         if(Battle.type == TYPE_LOCAL && _loc2_.dodge == true)
         {
            if(defender.getCharacterId() == Main.getMainChar().getCharacterId())
            {
               Main.achievement.updateBattleStat(Main.achievementData.DODGE,1);
            }
         }
         if(Boolean(Battle.type == TYPE_NETWORK) && Boolean(_loc2_.dodge) && Boolean(_loc2_.dodge[Main.getMainChar().getCharacterId]) && _loc2_.dodge[Main.getMainChar().getCharacterId] == true)
         {
            Main.achievement.updateBattleStat(Main.achievementData.DODGE,1);
         }
         switch(_loc2_.action)
         {
            case "skill":
               if(_loc2_)
               {
                  if(_loc2_.withoutCP)
                  {
                     attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(1370));
                  }
               }
               if(Battle.type == TYPE_NETWORK)
               {
                  if(attacker.type == 4)
                  {
                     _loc2_.action = "special";
                     characterTurn(param1.charType,param1.charId,param1.roundObj,_loc2_,param1.syncData);
                  }
                  else
                  {
                     _loc8_ = Main.SKILL_DATA[_loc2_.skillId];
                     attacker.updateCP(0 - _loc2_.cp);
                     if(!noCoolDown)
                     {
                        attacker.setSkillCooldown(_loc8_);
                     }
                     else
                     {
                        noCoolDown = false;
                     }
                  }
               }
               break;
            case "bloodline":
               if(_loc2_)
               {
                  if(_loc2_.withoutCP)
                  {
                     attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(1370));
                  }
               }
               if(Battle.type == TYPE_NETWORK)
               {
                  attacker.updateCP(0 - _loc2_.cp);
               }
               break;
            case "senjutsu":
               if(_loc2_)
               {
                  if(_loc2_.withoutSP)
                  {
                     attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(1862)[2]);
                  }
               }
               if(Battle.type == TYPE_NETWORK)
               {
                  attacker.updateSP(0 - _loc2_.sp);
               }
         }
         if(Battle.type == TYPE_NETWORK)
         {
            if(_loc2_.defenderDamageShield != null)
            {
               defender.damageShield = _loc2_.defenderDamageShield;
            }
         }
         else
         {
            Out.debug("Battle","rex defenderDamageShield shoudld not exist");
         }
         actionFlow();
         Central.main.getMainChar().securityCheck();
      }
      
      public static function callBattleFinishHAV(param1:Object) : void
      {
         var winnerIDs:Array;
         var currencyGainList:Object;
         var eventCurrencyGainList:Object;
         var pointGainList:Object;
         var pveRewardList:Object;
         var scoreList:Object;
         var EventArray:Array;
         var isMeWinner:Boolean;
         var i:uint = 0;
         var j:uint = 0;
         var signature:String = null;
         var hash:String = null;
         var jsonStr2:String = null;
         var charId:int = 0;
         var additem:Array = null;
         var ai:int = 0;
         var key:String = null;
         var value:int = 0;
         var thissplit:Array = null;
         var reward_id:String = null;
         var reward_amount:int = 0;
         var signatureData:String = null;
         var _dataObj:Object = param1;
         if(godModeHackCheck())
         {
            Main.onError("2973","");
            return;
         }
         if(Battle.type == TYPE_LOCAL)
         {
            if(Main.dispatchGameEvent(GameEvents.BATTLE_FINISH))
            {
               return;
            }
         }
         Main.achievement.updateBattleStat(Main.achievementData.BATTLE,1);
         if(Battle.type == TYPE_NETWORK)
         {
            bWaitingToStartRematch = true;
            Main.showAmfLoading();
            Main.getMainChar().updateDB(0,0,[],"",2,Battle);
         }
         winnerIDs = _dataObj.winnerIDs as Array;
         currencyGainList = _dataObj.currencyGainList as Object;
         eventCurrencyGainList = _dataObj.eventCurrencyGainList as Object;
         pointGainList = _dataObj.pointGainList as Object;
         pveRewardList = _dataObj.reward as Object;
         scoreList = _dataObj.score as Object;
         Battle.myCurrencyGain = 0;
         Battle.myEventCurrencyGain = 0;
         Battle.myPointGain = 0;
         Battle.pvpCurrencyGainDisplay = false;
         Battle.pvpEventCurrencyGainDisplay = false;
         Battle.pvpPointGainDisplay = false;
         Battle.pvpshowMyDisconnectText = false;
         trace("eventCurrencyGainList" + GF.printObject(eventCurrencyGainList));
         if(Central.main.getMainChar().getCharacterId())
         {
            charId = int(Central.main.getMainChar().getCharacterId());
            if(currencyGainList)
            {
               Battle.pvpCurrencyGainDisplay = true;
               Battle.myCurrencyGain = currencyGainList[charId];
               if(Battle.myCurrencyGain == 0)
               {
                  Battle.pvpshowMyDisconnectText = true;
               }
            }
            if(eventCurrencyGainList)
            {
               Battle.pvpEventCurrencyGainDisplay = true;
               Battle.myEventCurrencyGain = eventCurrencyGainList[charId];
               Toolkit.addInventoryByArray(["item1041_" + String(Battle.myEventCurrencyGain)],null);
               throck = eventCurrencyGainList[charId];
               additem = [];
               ai = 0;
               for(key in throck)
               {
                  value = int(throck[key]);
                  thissplit = key.split("_");
                  reward_id = thissplit[0] + thissplit[1];
                  reward_amount = value;
                  if(reward_amount > 1)
                  {
                     additem[ai] = reward_id + "_" + reward_amount;
                  }
                  else
                  {
                     additem[ai] = reward_id;
                  }
                  throckrewardList.push({
                     "id":reward_id,
                     "amount":reward_amount
                  });
                  ai++;
               }
               Toolkit.addInventoryByArray(additem,null);
               if(Battle.myEventCurrencyGain == 0)
               {
               }
            }
            if(pointGainList)
            {
               Battle.pvpPointGainDisplay = true;
               Battle.myPointGain = pointGainList[charId];
            }
            if(pveRewardList)
            {
               Battle.myPvEReward = pveRewardList[charId];
            }
            if(scoreList)
            {
               GF.printObject(scoreList);
               Battle.myPvEScore = scoreList[charId];
            }
         }
         EventArray = [];
         EventArray[0] = Central.main.eventBattleMethod;
         EventArray[1] = int(seal_enemy);
         if(Main.battleModeSpecial && Main.battleModeSpecial == true)
         {
            EventArray[1] = battleRoundCounter;
            if(specialHpData.finalHP)
            {
               EventArray[2] = specialHpData.finalHP;
            }
            else
            {
               EventArray[2] = 0;
            }
            EventArray[3] = specialHpData.lv;
            EventArray[4] = Central.main.battleId;
            EventArray[5] = int(seal_enemy);
         }
         isMeWinner = false;
         i = 0;
         while(i < winnerIDs.length)
         {
            if(Main.getMainChar().getData(DBCharacterData.ID).toString() == winnerIDs[i].toString())
            {
               isMeWinner = true;
               break;
            }
            i++;
         }
         if(isMeWinner)
         {
            if(Battle.type == TYPE_NETWORK)
            {
               if(_dataObj.disconnect != null)
               {
                  disconnect = true;
                  Main.showInfo(Main.langLib.get(214));
               }
               showPvPBattleWin();
            }
            else if(Central.main.HitAi == true)
            {
               showPvPaiBattleWin();
            }
            else if(subType == BattleData.SUBTYPE_CLAN)
            {
               if(connectingAmf)
               {
                  return;
               }
               connectingAmf = true;
               Main.showAmfLoading();
               battleResult = 1;
               if(round > 5)
               {
                  battleLog = "";
               }
               else
               {
                  battleLog = "Round " + String(round) + " || " + battleLog;
               }
               signature = Main.getHash(String(battleResult) + battleLog + Account.getAccountSessionKey());
               jsonStr2 = com.adobe.serialization.json.JSON.stringify(Central.main.battleFlowLog);
               hash = Main.getHash(Central.main.battleFlowLogver + Central.main.startBattleId + jsonStr2);
               i = 0;
               while(i < Central.main.battleFlowLogclanenemy.length)
               {
                  Central.main.battleFlowLog.battles[Central.main.battleround].enemyid.push(Central.main.battleFlowLogclanenemy[i]);
                  i++;
               }
               Main.amfClient.service("ClanWar.generateBattleResult",[Account.getAccountSessionKey(),Main.updateSequence(),String(battleResult),battleLog,signature,Central.main.battleFlowLogver,Central.main.startBattleId,jsonStr2,hash],gotClanBattleResult);
               Central.main.battleFlowLog.battles = [];
               Central.main.battleround = -1;
            }
            else if(subType == BattleData.SUBTYPE_BOSS)
            {
               if(connectingAmf)
               {
                  return;
               }
               connectingAmf = true;
               Main.showAmfLoading();
               if(!Central.main.isOldHunting)
               {
                  Central.main.logHuntingMission(false,true);
               }
               if(isEventEnd)
               {
                  signature = Main.getHash(String(bossId) + "|0|");
                  Main.amfClient.service("ItemDAO.getBossReward",[Account.getAccountSessionKey(),signature,bossId,0],getBossRewardResponse02);
               }
               else if(Central.main.isOldHunting)
               {
                  huntingHash = Main.getHash(String(roomId) + 0);
                  Central.main.isOldHunting = false;
                  jsonStr2 = com.adobe.serialization.json.JSON.stringify(Central.main.battleFlowLog);
                  hash = Main.getHash(Central.main.battleFlowLogver + Central.main.startBattleId + jsonStr2);
                  Main.amfClient.service("EudemonGarden.finishHunting",[Account.getAccountSessionKey(),roomId,Central.main.getMainChar().itemUsedInBattle,0,huntingHash,Central.main.battleFlowLogver,Central.main.startBattleId,jsonStr2,hash],getBossRewardResponse02);
                  Central.main.battleFlowLog.battles = [];
                  Central.main.battleround = -1;
               }
               else if(Central.main.isVDay2017)
               {
                  huntingHash = Main.getHash(String(0) + 0);
                  Central.main.isVDay2017 = false;
                  Main.amfClient.service("ValentinesDay2017.finishHunting",[Account.getAccountSessionKey(),0,Central.main.getMainChar().itemUsedInBattle,0,huntingHash],getBossRewardResponse02);
               }
               else if(Central.main.isNewClanWar)
               {
                  jsonStr2 = com.adobe.serialization.json.JSON.stringify(Central.main.battleFlowLog);
                  hash = Central.main.getHash(Central.main.battleFlowLogver + Central.main.startBattleId + jsonStr2);
                  Central.main.extraData.crew_merit += 10;
                  Central.main.getMainChar().itemUsedInBattle = Central.main.getMainChar().itemUsedInBattle ? Central.main.getMainChar().itemUsedInBattle : [];
                  ClanWarHash = Main.getHash(String(Central.main.getMainChar().itemUsedInBattle + Central.main.recruitedMembers.toString() + Central.main.selectedNewClanWar + 0));
                  Main.amfClient.service("CrewWar.finishLandHunt",[Account.getAccountSessionKey(),Central.main.getMainChar().itemUsedInBattle,Central.main.recruitedMembers.toString(),Central.main.selectedNewClanWar,0,Central.main.updateSequence(),ClanWarHash,Central.main.battleFlowLogver,Central.main.startBattleId,jsonStr2,hash],getBossRewardResponse02);
                  Central.main.battleFlowLog.battles = [];
                  Central.main.battleround = -1;
               }
               else
               {
                  signatureData = "";
                  j = 0;
                  while(j < EventArray.length)
                  {
                     signatureData += EventArray[j];
                     if(j < EventArray.length - 1)
                     {
                        signatureData += ",";
                     }
                     j++;
                  }
                  signature = Main.getHash(String(bossId) + "|0|" + signatureData);
                  jsonStr2 = com.adobe.serialization.json.JSON.stringify(Central.main.battleFlowLog);
                  hash = Main.getHash(Central.main.battleFlowLogver + Central.main.startBattleId + jsonStr2);
                  Main.amfClient.service("ItemDAO.getBossReward",[Account.getAccountSessionKey(),signature,bossId,0,EventArray,Central.main.battleFlowLogver,Central.main.startBattleId,jsonStr2,hash],getBossRewardResponse02);
                  Central.main.battleFlowLog.battles = [];
                  Central.main.battleround = -1;
               }
               Main.removePartyNpc();
               Main.partyMembers = null;
               Main.emptyRecruitedFriends();
               if(Central.main.eventName == "Vday2019")
               {
                  Central.main.partyNpc = Central.main.prevNpcArr;
                  Central.main.partyMembers = Central.main.prevPartyMemberArr;
               }
            }
            else
            {
               showBattleWin();
            }
            return;
         }
         if(Battle.type != TYPE_NETWORK)
         {
            if(subType == BattleData.SUBTYPE_CLAN)
            {
               if(connectingAmf)
               {
                  return;
               }
               connectingAmf = true;
               Main.showAmfLoading();
               battleResult = 2;
               if(round > 5)
               {
                  battleLog = "";
               }
               else
               {
                  battleLog = "Round " + String(round) + " || " + battleLog;
               }
               jsonStr2 = com.adobe.serialization.json.JSON.stringify(Central.main.battleFlowLog);
               hash = Main.getHash(Central.main.battleFlowLogver + Central.main.startBattleId + jsonStr2);
               signature = Main.getHash(String(battleResult) + battleLog + Account.getAccountSessionKey());
               i = 0;
               while(i < Central.main.battleFlowLogclanenemy.length)
               {
                  Central.main.battleFlowLog.battles[Central.main.battleround].enemyid.push(Central.main.battleFlowLogclanenemy[i]);
                  i++;
               }
               Main.amfClient.service("ClanWar.generateBattleResult",[Account.getAccountSessionKey(),Main.updateSequence(),String(battleResult),battleLog,signature,Central.main.battleFlowLogver,Central.main.startBattleId,jsonStr2,hash],gotClanBattleResult);
               Central.main.battleFlowLog.battles = [];
               Central.main.battleround = -1;
               return;
            }
            if(Central.main.HitAi == true)
            {
               showPvPaiBattleLose();
            }
         }
         if(Battle.type == TYPE_NETWORK)
         {
            showPvPBattleLose();
            return;
         }
         if(Main.challengeFriendUID != null)
         {
            if(Main.challengedFriends.indexOf(Main.challengeFriendUID) == -1)
            {
               switch(AppData.type)
               {
                  case AppData.FB:
                     break;
                  case AppData.OK:
                     SNS.sendNotification(String(String(Central.main.langLib.get(299)).replace("[valfbuserusername]",FBUser.username)).replace("[valapplicationurl]",Data.APPLICATION_URL),[Main.challengeFriendUID]);
                     break;
                  case AppData.MP:
                     SNS.sendNotification(String(String(Central.main.langLib.get(298)).replace("[valfbuserusername]",FBUser.username)).replace("[valapplicationurl]",Data.APPLICATION_URL),[Main.challengeFriendUID]);
               }
               Main.challengedFriends.push(Main.challengeFriendUID);
            }
            i = 0;
            while(i < enemyArr.length)
            {
               Main.saveChallengeRecord(enemyArr[i].getData(DBCharacterData.ID),1);
               Panel.getInstance().setChallenged(int(enemyArr[i].getData(DBCharacterData.ID)));
               i++;
            }
            Mission.updateDailyTask(DailyTaskData.TYPE_CHALLENGE,1);
            Main.challengeFriendUID = null;
         }
         if(subType == BattleData.SUBTYPE_CLAN)
         {
            battleResult = 2;
            battleMc.gotoClanResult();
         }
         else
         {
            try
            {
               Central.main.tracking.trackHuntBoss(bossId,Central.main.tracking.TRACK_HUNT_BOSS + Central.main.tracking.TRACK_FAIL);
            }
            catch(err:Error)
            {
               Out.error("Battle","callBattleFinish :: TRACKING - trackHuntBoss(TRACK_FAIL)");
            }
            battleLose();
         }
      }
      
      private static function setDefenderById(param1:int) : void
      {
         var _loc2_:uint = 0;
         Out.debug("Battle","setDefenderById :: _id >> " + param1);
         if(Main.getMainChar().getData("character_id") == param1)
         {
            defender = Main.getMainChar();
            return;
         }
         _loc2_ = 0;
         while(_loc2_ < enemyArr.length)
         {
            if(enemyArr[_loc2_].getData("character_id") == param1)
            {
               defender = enemyArr[_loc2_];
               return;
            }
            _loc2_++;
         }
         if(partyArr)
         {
            _loc2_ = 0;
            while(_loc2_ < partyArr.length)
            {
               if(partyArr[_loc2_].getData(DBCharacterData.ID) == param1)
               {
                  defender = partyArr[_loc2_];
                  return;
               }
               _loc2_++;
            }
         }
         if(petArr)
         {
            _loc2_ = 0;
            while(_loc2_ < petArr.length)
            {
               if(petArr[_loc2_].getData(DBCharacterData.ID) == param1)
               {
                  defender = petArr[_loc2_];
                  return;
               }
               _loc2_++;
            }
         }
      }
      
      public static function setDefender(param1:*) : void
      {
         defender = param1;
      }
      
      public static function getCharacterById(param1:int) : *
      {
         var _loc2_:uint = 0;
         if(Main.getMainChar().getData("character_id") == param1)
         {
            return Main.getMainChar();
         }
         _loc2_ = 0;
         while(_loc2_ < enemyArr.length)
         {
            if(enemyArr[_loc2_].getData("character_id") == param1)
            {
               return enemyArr[_loc2_];
            }
            _loc2_++;
         }
         if(partyArr)
         {
            _loc2_ = 0;
            while(_loc2_ < partyArr.length)
            {
               if(partyArr[_loc2_].getData(DBCharacterData.ID) == param1)
               {
                  return partyArr[_loc2_];
               }
               _loc2_++;
            }
         }
         if(petArr)
         {
            _loc2_ = 0;
            while(_loc2_ < petArr.length)
            {
               if(petArr[_loc2_].getData(DBCharacterData.ID) == param1)
               {
                  return petArr[_loc2_];
               }
               _loc2_++;
            }
         }
      }
      
      private static function actionFlow() : void
      {
         var _loc1_:Object = null;
         var _loc3_:Object = null;
         var _loc4_:Object = null;
         var _loc5_:Object = null;
         var _loc6_:int = 0;
         _loc1_ = attacker.getBattleAction();
         var _loc2_:Point = null;
         if(Battle.type == TYPE_LOCAL && _loc1_.dodge == true || Boolean(Battle.type == TYPE_NETWORK && _loc1_.dodge) && Boolean(_loc1_.dodge[defender.getCharacterId()] == true))
         {
            if(defender.getWeapon())
            {
               if(Central.main.WEAPON_DATA.find(defender.getWeapon()))
               {
                  _loc4_ = Central.main.WEAPON_DATA.find(defender.getWeapon());
                  if(_loc4_)
                  {
                     for each(_loc3_ in _loc4_.effect)
                     {
                        switch(_loc3_.type)
                        {
                           case BattleData.EFFECT_DODGE_SUCCESS_DAMAGE_BONUS:
                              defender.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(330));
                        }
                     }
                  }
               }
            }
         }
         Out.debug("Battle","actionFlow :: battleAction >> " + GF.objectToString(_loc1_));
         Out.debug("Battle","actionFlow :: attacker >> " + attacker.getCharacterName() + " :: defender >> " + defender.getCharacterName() + " :: posType >> " + _loc1_.posType);
         if(_loc1_.posType != null)
         {
            switch(_loc1_.posType)
            {
               case PositionType.MELEE_1:
                  if(attacker.charMc.x < defender.charMc.x)
                  {
                     _loc2_ = new Point(defender.charMc.x - defender.getHitArea().width * Data.BATTLE_CHAR_SCALE - attacker.getHitArea().width * Data.BATTLE_CHAR_SCALE,defender.charMc.y);
                  }
                  else
                  {
                     _loc2_ = new Point(defender.charMc.x + defender.getHitArea().width * Data.BATTLE_CHAR_SCALE + attacker.getHitArea().width * Data.BATTLE_CHAR_SCALE,defender.charMc.y);
                  }
                  break;
               case PositionType.MELEE_2:
                  if(attacker.charMc.x < defender.charMc.x)
                  {
                     _loc2_ = new Point(defender.charMc.x - defender.getHitArea().width * Data.BATTLE_CHAR_SCALE - attacker.getHitArea().width * Data.BATTLE_CHAR_SCALE,defender.charMc.y);
                  }
                  else
                  {
                     _loc2_ = new Point(defender.charMc.x + defender.getHitArea().width * Data.BATTLE_CHAR_SCALE + attacker.getHitArea().width * Data.BATTLE_CHAR_SCALE,defender.charMc.y);
                  }
                  break;
               case PositionType.MELEE_3:
                  Out.debug("Battle","MELEE_3");
                  if(attacker.charMc.x < defender.charMc.x)
                  {
                     _loc2_ = new Point(defender.charMc.x - defender.getHitArea().width * Data.BATTLE_CHAR_SCALE - attacker.getHitArea().width * Data.BATTLE_CHAR_SCALE - 300,defender.charMc.y);
                  }
                  else
                  {
                     _loc2_ = new Point(defender.charMc.x + defender.getHitArea().width * Data.BATTLE_CHAR_SCALE + attacker.getHitArea().width * Data.BATTLE_CHAR_SCALE + 300,defender.charMc.y);
                  }
                  break;
               case PositionType.MELEE_4:
                  if(defender.charMc.x > Data.GAME_WIDTH / 2)
                  {
                     _loc2_ = new Point(Data.GAME_WIDTH / 2 - PositionType.RANGE_2_OFFSET * Data.BATTLE_CHAR_SCALE * 2 / 3,middleRowY);
                  }
                  if(defender.charMc.x < Data.GAME_WIDTH / 2)
                  {
                     _loc2_ = new Point(Data.GAME_WIDTH / 2 + PositionType.RANGE_2_OFFSET * Data.BATTLE_CHAR_SCALE * 2 / 3,middleRowY);
                  }
                  break;
               case PositionType.RANGE_1:
                  if(attacker.charMc.x < defender.charMc.x)
                  {
                     _loc2_ = new Point(defender.charMc.x,defender.charMc.y - defender.getHitArea().height * Data.BATTLE_CHAR_SCALE / 2);
                  }
                  else
                  {
                     _loc2_ = new Point(defender.charMc.x,defender.charMc.y - defender.getHitArea().height * Data.BATTLE_CHAR_SCALE / 2);
                  }
                  break;
               case PositionType.RANGE_2:
                  if(attacker.charMc.x < defender.charMc.x)
                  {
                     _loc2_ = new Point(defender.charMc.x - PositionType.RANGE_2_OFFSET * Data.BATTLE_CHAR_SCALE,defender.charMc.y);
                  }
                  else
                  {
                     _loc2_ = new Point(defender.charMc.x + defender.getHitArea().width * Data.BATTLE_CHAR_SCALE * 3,defender.charMc.y);
                  }
                  break;
               case PositionType.RANGE_3:
                  if(defender.charMc.x > Data.GAME_WIDTH / 2)
                  {
                     _loc2_ = new Point(defender.charMc.x - defender.getHitArea().width * Data.BATTLE_CHAR_SCALE / 2,defender.charMc.y);
                  }
                  if(defender.charMc.x < Data.GAME_WIDTH / 2)
                  {
                     _loc2_ = new Point(defender.charMc.x + defender.getHitArea().width * Data.BATTLE_CHAR_SCALE / 2,defender.charMc.y);
                  }
            }
         }
         Out.debug("Battle","actionFlow :: battleAction.action >> " + _loc1_.action);
         switch(_loc1_.action)
         {
            case "pass":
               break;
            case "attack":
               if(_loc1_.skillCP)
               {
                  attacker.updatePetCP(0 - _loc1_.skillCP);
                  attacker.updateBattleFrame();
               }
               playAttack(attacker,_loc1_,_loc2_);
               break;
            case "weapon_attack":
               if(Central.main.isNewChar)
               {
                  _loc1_.animation = "attack_01";
               }
               playAttack(attacker,_loc1_,_loc2_);
               break;
            case "charge":
               playCharge(attacker);
               break;
            case "skill":
               attacker.updateBattleFrame();
               playSkill(attacker,_loc1_,_loc2_);
               break;
            case "class_skill":
               playClassSkill(attacker,_loc1_,_loc2_);
               break;
            case "item":
               _loc5_ = Main.ITEM_DATA.find(_loc1_.item);
               if(_loc5_ != null)
               {
                  playAction(attacker,_loc5_.animation);
               }
               defender.updateBattleFrame();
               break;
            case "special":
               if(_loc1_.skillCP)
               {
                  attacker.updatePetCP(0 - _loc1_.skillCP);
                  attacker.updateBattleFrame();
               }
               if(Boolean(attacker.limb) && attacker.limb > 1)
               {
                  _loc6_ = int(attacker.getCharacterId() / 10) * 10 + 1;
                  playBattleAction(getCharacterById(_loc6_),_loc1_,_loc2_);
               }
               else
               {
                  playBattleAction(attacker,_loc1_,_loc2_);
               }
               break;
            case BattleData.EFFECT_STUN:
               attacker.showOverheadNumber(Timeline.WORD,String(Central.main.langLib.get(332)).replace("[valamt]",_loc1_.duration));
               break;
            case "bloodline":
               attacker.updateBattleFrame();
               playBloodline(attacker,_loc1_,_loc2_);
               break;
            case "senjutsu":
               attacker.updateBattleFrame();
               playSenjutsu(attacker,_loc1_,_loc2_);
               break;
            case "event_action":
               playAttack(attacker,_loc1_,_loc2_);
               break;
            case "dodge":
               attacker.updateBattleFrame();
               playSkip(attacker);
         }
         actionFinish_CB();
      }
      
      public static function attackHit_CB() : void
      {
         var _loc1_:Object = null;
         var _loc2_:Object = null;
         var _loc7_:String = null;
         var _loc8_:Number = NaN;
         var _loc9_:int = 0;
         var _loc14_:Array = null;
         var _loc15_:Array = null;
         var _loc22_:* = undefined;
         var _loc23_:int = 0;
         var _loc24_:int = 0;
         var _loc25_:int = 0;
         var _loc26_:Object = null;
         var _loc27_:Object = null;
         var _loc28_:Object = null;
         var _loc29_:String = null;
         var _loc30_:Object = null;
         var _loc31_:Object = null;
         var _loc32_:Object = null;
         var _loc33_:Array = null;
         var _loc34_:Object = null;
         var _loc35_:Object = null;
         var _loc36_:Array = null;
         var _loc37_:Array = null;
         var _loc38_:Number = NaN;
         var _loc39_:int = 0;
         var _loc40_:Object = null;
         var _loc41_:String = null;
         var _loc42_:* = undefined;
         var _loc43_:Object = null;
         var _loc44_:Number = NaN;
         var _loc45_:int = 0;
         var _loc46_:Object = null;
         var _loc47_:String = null;
         var _loc48_:* = undefined;
         var _loc49_:Array = null;
         var _loc50_:uint = 0;
         var _loc51_:String = null;
         var _loc52_:int = 0;
         var _loc53_:Object = null;
         var _loc54_:String = null;
         var _loc55_:Object = null;
         var _loc56_:Object = null;
         var _loc57_:Object = null;
         var _loc58_:Array = null;
         var _loc59_:String = null;
         var _loc60_:Boolean = false;
         var _loc61_:int = 0;
         var _loc62_:Object = null;
         var _loc63_:* = undefined;
         if(Main.dispatchGameEvent(GameEvents.BATTLE_ATK_HIT))
         {
            attacker.pauseAnimation();
            return;
         }
         attacker.resumeAnimation();
         _loc1_ = attacker.getBattleAction();
         var _loc3_:Object = attacker.getBattleBuff();
         var _loc4_:Object = attacker.getBattleDebuff();
         var _loc5_:Object = defender.getBattleBuff();
         var _loc6_:Object = attacker.getBattleDebuff();
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         var _loc12_:int = 0;
         var _loc13_:int = 0;
         var _loc16_:uint = 0;
         var _loc17_:String = "";
         var _loc18_:int = 0;
         var _loc19_:uint = 0;
         var _loc20_:String = "";
         var _loc21_:int = 0;
         if(_loc1_.hitNum == null)
         {
            _loc1_.hitNum = 1;
         }
         else
         {
            ++_loc1_.hitNum;
         }
         if(_loc1_.hitNum > 1)
         {
            if(defender.hp <= 0)
            {
               return;
            }
            if(defender.isDead)
            {
               return;
            }
            if(_loc1_.resurrectionObj != null && Boolean(_loc1_.resurrectionObj.hasOwnProperty(defender.getCharacterId())))
            {
               return;
            }
         }
         if(Battle.type == TYPE_LOCAL && _loc1_.dodge == false || Boolean(Battle.type == TYPE_NETWORK && _loc1_.dodge) && Boolean(_loc1_.dodge[defender.getCharacterId()] == false))
         {
            if(_loc1_.critical == true)
            {
               if(attacker.getCharacterId() == Main.getMainChar().getCharacterId())
               {
                  Main.achievement.updateBattleStat(Main.achievementData.CRITICAL,1);
               }
            }
            if(_loc1_.effect)
            {
               if(_loc1_.effect.restoreHp)
               {
                  if(Battle.type == TYPE_NETWORK)
                  {
                     defender.updateHP(_loc1_.effect.restoreHp);
                  }
                  defender.showOverheadNumber(Timeline.WORD,"+" + _loc1_.effect.restoreHp + " " + String(Central.main.langLib.get(483)).replace("+",""));
               }
               if(_loc1_.effect.restoreCp)
               {
                  if(Battle.type == TYPE_NETWORK)
                  {
                     defender.updateCP(_loc1_.effect.restoreCp);
                  }
                  defender.showOverheadNumber(Timeline.WORD,"+" + _loc1_.effect.restoreCp + " " + String(Central.main.langLib.get(350)).replace("+",""));
               }
               defender.updateBattleFrame();
               Main.updateMenu();
               updateSPButton();
               Out.debug("battleAction :: "," battleAction >> " + GF.printObject(_loc1_));
               if(checkResisted(_loc1_.effect.resisted,defender) == true)
               {
                  Out.debug("checkResisted"," 2120");
                  defender.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(484));
               }
               if(_loc1_.effect.resisted == false || _loc1_.effect.resisted == null)
               {
               }
               if(checkResisted(_loc1_.effect.resisted,defender) == false)
               {
                  switch(_loc1_.effect.type)
                  {
                     case BattleData.EFFECT_SLEEP:
                        if(Battle.type == TYPE_NETWORK)
                        {
                           defender.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(280));
                           defender.setBattleDebuff(_loc1_.effect);
                        }
                        break;
                     case BattleData.EFFECT_PET_FEAR_WEAKEN:
                        if(Battle.type == TYPE_NETWORK)
                        {
                           defender.setBattleDebuff(_loc1_.effect);
                        }
                        break;
                     case BattleData.EFFECT_PET_FREEZE:
                        if(_loc1_.effect.activated == true)
                        {
                           defender.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(820));
                           if(Battle.type == TYPE_NETWORK)
                           {
                              defender.setBattleDebuff(_loc1_.effect);
                           }
                        }
                        break;
                     case BattleData.EFFECT_DOUBLE_BURN:
                        if(Battle.type == TYPE_NETWORK)
                        {
                           defender.updateHP(0 - int(_loc1_.effect.damageHp));
                        }
                        break;
                     case BattleData.EFFECT_BURN_CP_FIX_NUM:
                        if(Battle.type == TYPE_NETWORK)
                        {
                           defender.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(349) + String(_loc1_.effect.damageCp));
                           defender.updateCP(0 - _loc1_.effect.damageCp);
                        }
                        break;
                     case BattleData.EFFECT_ECSTATIC_SOUND:
                        defender.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(609));
                        if(Battle.type == TYPE_NETWORK)
                        {
                           defender.setBattleDebuff(_loc1_.effect);
                        }
                        break;
                     case BattleData.EFFECT_PET_REDUCE_CHARGE:
                        defender.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(804));
                        break;
                     case BattleData.EFFECT_BURN_CP_HP:
                        if(Battle.type == TYPE_NETWORK)
                        {
                           defender.updateHP(-int(_loc1_.effect.damageHp));
                           defender.updateCP(0 - int(_loc1_.effect.damageCp));
                        }
                        break;
                     case BattleData.EFFECT_PET_BLEEDING:
                        if(_loc1_.effect.activated == true)
                        {
                           defender.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(286) + "(" + String(_loc1_.effect.amount) + "%)");
                           if(Battle.type == TYPE_NETWORK)
                           {
                              defender.setBattleDebuff(_loc1_.effect);
                           }
                        }
                        break;
                     case BattleData.EFFECT_FLAME_EATER:
                        defender.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(482) + String(_loc1_.effect.flameEaten));
                        if(Battle.type == TYPE_NETWORK)
                        {
                           defender.removeDebuff(BattleData.EFFECT_BURN);
                           defender.removeDebuff(BattleData.EFFECT_PET_BURN);
                           defender.removeDebuff(BattleData.EFFECT_BURNING);
                           defender.updateHP(int(_loc1_.effect.flameEaten));
                        }
                        break;
                     case BattleData.EFFECT_CLEAR_BUFF:
                        if(_loc1_.effect.activated == true)
                        {
                           defender.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(877));
                           defender.clearBuff();
                        }
                        break;
                     case BattleData.EFFECT_ADD_COOLDOWN:
                        defender.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(744));
                        if(Battle.type == TYPE_NETWORK)
                        {
                           addSkillCoolDown(_loc1_.effect,_loc1_);
                        }
                        break;
                     case BattleData.EFFECT_ADD_ALL_COOLDOWN:
                        defender.showOverheadNumber(Timeline.WORD,Central.main.langLib.titleTxt(TitleData.COOLDOWN) + " + " + (_loc1_.effect.amount - 1));
                        if(Battle.type == TYPE_NETWORK)
                        {
                           defender.addAllSkillCooldown(_loc1_.effect.amount);
                        }
                        break;
                     case BattleData.EFFECT_PET_DRAIN_HP:
                        _loc24_ = int(_loc1_.effect.damageHp);
                        defender.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(482) + String(_loc24_));
                        if(Battle.type == TYPE_NETWORK)
                        {
                           defender.updateHP(0 - _loc24_);
                        }
                        _loc22_ = getPetMasterById(attacker.getPetId());
                        if(_loc22_)
                        {
                           _loc22_.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(483) + String(_loc24_));
                           if(Battle.type == TYPE_NETWORK)
                           {
                              _loc22_.updateHP(_loc24_);
                           }
                        }
                        break;
                     case BattleData.EFFECT_PET_DRAIN_CP:
                        _loc25_ = int(_loc1_.effect.damageCp);
                        defender.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(349) + String(_loc25_));
                        if(Battle.type == TYPE_NETWORK)
                        {
                           defender.updateCP(0 - _loc25_);
                        }
                        _loc22_ = getPetMasterById(attacker.getPetId());
                        if(_loc22_)
                        {
                           _loc22_.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(350) + String(_loc25_));
                           if(Battle.type == TYPE_NETWORK)
                           {
                              _loc22_.updateCP(_loc25_);
                           }
                        }
                        break;
                     case BattleData.EFFECT_EXTRA_CP_RECOVER:
                        defender.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(755));
                        break;
                     case BattleData.EFFECT_RESTRICT_CHARGE:
                        if(Battle.type == TYPE_NETWORK)
                        {
                           defender.setBattleDebuff(_loc1_.effect);
                        }
                        break;
                     case BattleData.EFFECT_CRIT_CHANCE_DMG:
                        attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(292));
                        attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(747));
                        break;
                     case BattleData.EFFECT_CERBERUS:
                        attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(2068));
                        break;
                     case BattleData.EFFECT_AMONG_ROCKS:
                        attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(617));
                        break;
                     case BattleData.EFFECT_HEAL_OVER_TIME:
                        attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(596));
                        if(Battle.type == TYPE_NETWORK)
                        {
                           attacker.setBattleBuff(_loc1_.effect);
                        }
                        break;
                     case BattleData.MONSTER_HP1:
                        attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(596));
                        if(Battle.type == TYPE_NETWORK)
                        {
                           attacker.updateHP(_loc1_.effect.damageHp);
                        }
                        break;
                     case BattleData.EFFECT_CHAOS:
                        if(Battle.type == TYPE_NETWORK)
                        {
                           defender.setBattleDebuff(_loc1_.effect);
                        }
                        break;
                     case SkillData.EFFECT_TYPE_HEAL:
                     case BattleData.EFFECT_ALL_CP_HEAL:
                        healTarget();
                        break;
                     case BattleData.EFFECT_SILVER_CHAIN_BUNDLE:
                        defender.showOverheadNumber(Timeline.WORD,String(Central.main.langLib.get(676)));
                        if(Battle.type == TYPE_NETWORK)
                        {
                           defender.setBattleDebuff(_loc1_.effect);
                        }
                        break;
                     case BattleData.EFFECT_PET_DEBUFF_RESIST:
                        attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(822));
                        break;
                     case BattleData.EFFECT_AGILITY_BONUS:
                        attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(282));
                        break;
                     case BattleData.EFFECT_DODGE_BONUS:
                        attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(306));
                        break;
                     case BattleData.EFFECT_ALL_CP_DODGE_BONUS:
                        attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(306));
                        break;
                     case BattleData.EFFECT_PET_DODGE_BONUS:
                        defender.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(306));
                        break;
                     case BattleData.EFFECT_CRITICAL_CHANCE_BONUS:
                        attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(292));
                        break;
                     case BattleData.EFFECT_REGENERATE_CHAKRA:
                        attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(324));
                        if(Battle.type == TYPE_NETWORK)
                        {
                           attacker.setBattleBuff(_loc1_.effect);
                        }
                        break;
                     case BattleData.EFFECT_REGENERATE_HP:
                        attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(490));
                        break;
                     case BattleData.EFFECT_MANA_SHIELD:
                        attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(594));
                        break;
                     case BattleData.EFFECT_BERSERKER_BUFF:
                        attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(2051));
                        break;
                     case BattleData.EFFECT_BERSERKER_MODE:
                        attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(599));
                        break;
                     case BattleData.EFFECT_THUNDERSTORM_MODE:
                        attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(601));
                        setbuffThreat(_loc1_.effect);
                        break;
                     case BattleData.EFFECT_DODGE_BONUS_ALL_FRIENDLY:
                        attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(306));
                        if(attacker.side == BattleData.SIDE_FRIENDLY)
                        {
                           if(attacker.getCharacterId() != Main.getMainChar().getCharacterId())
                           {
                              Main.getMainChar().showOverheadNumber(Timeline.WORD,Central.main.langLib.get(306));
                              if(Battle.type == TYPE_NETWORK)
                              {
                                 Main.getMainChar().setBattleBuff(_loc1_.effect);
                              }
                           }
                           if(partyArr)
                           {
                              _loc9_ = 0;
                              while(_loc9_ < partyArr.length)
                              {
                                 if(!partyArr[_loc9_].isDead && partyArr[_loc9_].getCharacterId() != attacker.getCharacterId())
                                 {
                                    partyArr[_loc9_].showOverheadNumber(Timeline.WORD,Central.main.langLib.get(306));
                                    if(Battle.type == TYPE_NETWORK)
                                    {
                                       partyArr[_loc9_].setBattleBuff(_loc1_.effect);
                                    }
                                 }
                                 _loc9_++;
                              }
                           }
                        }
                        if(attacker.side == BattleData.SIDE_HOSTILE)
                        {
                           _loc9_ = 0;
                           while(_loc9_ < enemyArr.length)
                           {
                              if(!enemyArr[_loc9_].isDead)
                              {
                                 enemyArr[_loc9_].showOverheadNumber(Timeline.WORD,Central.main.langLib.get(306));
                                 if(Battle.type == TYPE_NETWORK)
                                 {
                                    enemyArr[_loc9_].setBattleBuff(_loc1_.effect);
                                 }
                              }
                              _loc9_++;
                           }
                        }
                        setbuffThreat(_loc1_.effect);
                        break;
                     case BattleData.EFFECT_WIND_PEACE_SINGLE:
                        attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(611));
                        setbuffThreat(_loc1_.effect);
                        break;
                     case BattleData.EFFECT_ADD_ALL_HP_CP:
                        if(attacker.side == BattleData.SIDE_FRIENDLY)
                        {
                           if(Battle.type == TYPE_NETWORK)
                           {
                              attacker.showOverheadNumber(Timeline.WORD,"HP +" + _loc1_.addhp);
                              attacker.showOverheadNumber(Timeline.WORD,"CP +" + _loc1_.addcp);
                           }
                           if(partyArr)
                           {
                              _loc9_ = 0;
                              while(_loc9_ < partyArr.length)
                              {
                                 if(!partyArr[_loc9_].isDead)
                                 {
                                    if(Battle.type == TYPE_NETWORK)
                                    {
                                       partyArr[_loc9_].showOverheadNumber(Timeline.WORD,"HP +" + _loc1_.addhp);
                                       partyArr[_loc9_].showOverheadNumber(Timeline.WORD,"CP +" + _loc1_.addcp);
                                    }
                                 }
                                 _loc9_++;
                              }
                           }
                        }
                        break;
                     case BattleData.EFFECT_ADD_ALL_HP_CP_CLEAR_DEBUFF:
                        if(attacker.side == BattleData.SIDE_FRIENDLY)
                        {
                           attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(356));
                           if(Battle.type == TYPE_NETWORK)
                           {
                              attacker.clearAllDebuff();
                              attacker.showOverheadNumber(Timeline.WORD,"HP +" + _loc1_.addhp);
                              attacker.showOverheadNumber(Timeline.WORD,"CP +" + _loc1_.addcp);
                           }
                           if(partyArr)
                           {
                              _loc9_ = 0;
                              while(_loc9_ < partyArr.length)
                              {
                                 if(!partyArr[_loc9_].isDead)
                                 {
                                    partyArr[_loc9_].showOverheadNumber(Timeline.WORD,Central.main.langLib.get(356));
                                    if(Battle.type == TYPE_NETWORK)
                                    {
                                       partyArr[_loc9_].clearAllDebuff();
                                       partyArr[_loc9_].showOverheadNumber(Timeline.WORD,"HP +" + _loc1_.addhp);
                                       partyArr[_loc9_].showOverheadNumber(Timeline.WORD,"CP +" + _loc1_.addcp);
                                    }
                                 }
                                 _loc9_++;
                              }
                           }
                        }
                        if(attacker.side == BattleData.SIDE_HOSTILE)
                        {
                           _loc9_ = 0;
                           while(_loc9_ < enemyArr.length)
                           {
                              if(!enemyArr[_loc9_].isDead)
                              {
                                 enemyArr[_loc9_].showOverheadNumber(Timeline.WORD,Central.main.langLib.get(356));
                                 if(Battle.type == TYPE_NETWORK)
                                 {
                                    enemyArr[_loc9_].clearAllDebuff();
                                 }
                              }
                              _loc9_++;
                           }
                        }
                        break;
                     case BattleData.EFFECT_DAMAGE_BONUS_N_PURIFY:
                        attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(330));
                        if(_loc1_.effect.activated == true)
                        {
                           attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(356));
                        }
                        if(attacker.side == BattleData.SIDE_FRIENDLY)
                        {
                           if(attacker.getCharacterId() != Main.getMainChar().getCharacterId())
                           {
                              Main.getMainChar().showOverheadNumber(Timeline.WORD,Central.main.langLib.get(330));
                              if(_loc1_.effect.activated == true)
                              {
                                 Main.getMainChar().showOverheadNumber(Timeline.WORD,Central.main.langLib.get(356));
                              }
                              if(Battle.type == TYPE_NETWORK)
                              {
                                 Main.getMainChar().setBattleBuff(_loc1_.effect);
                                 if(_loc1_.effect.activated == true)
                                 {
                                    Main.getMainChar().clearAllDebuff();
                                 }
                              }
                           }
                           if(partyArr)
                           {
                              _loc9_ = 0;
                              while(_loc9_ < partyArr.length)
                              {
                                 if(!partyArr[_loc9_].isDead)
                                 {
                                    partyArr[_loc9_].showOverheadNumber(Timeline.WORD,Central.main.langLib.get(330));
                                    partyArr[_loc9_].showOverheadNumber(Timeline.WORD,Central.main.langLib.get(356));
                                    if(Battle.type == TYPE_NETWORK)
                                    {
                                       partyArr[_loc9_].setBattleBuff(_loc1_.effect);
                                       partyArr[_loc9_].clearAllDebuff();
                                    }
                                 }
                                 _loc9_++;
                              }
                           }
                        }
                        if(attacker.side == BattleData.SIDE_HOSTILE)
                        {
                           _loc9_ = 0;
                           while(_loc9_ < enemyArr.length)
                           {
                              if(!enemyArr[_loc9_].isDead)
                              {
                                 enemyArr[_loc9_].showOverheadNumber(Timeline.WORD,Central.main.langLib.get(330));
                                 enemyArr[_loc9_].showOverheadNumber(Timeline.WORD,Central.main.langLib.get(356));
                                 if(Battle.type == TYPE_NETWORK)
                                 {
                                    enemyArr[_loc9_].setBattleBuff(_loc1_.effect);
                                    enemyArr[_loc9_].clearAllDebuff();
                                 }
                              }
                              _loc9_++;
                           }
                        }
                        setbuffThreat(_loc1_.effect);
                        break;
                     case BattleData.EFFECT_SERENE_MIND_N_HEAL:
                        attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(622));
                        attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(830));
                        if(attacker.side == BattleData.SIDE_FRIENDLY)
                        {
                           if(attacker.getCharacterId() != Main.getMainChar().getCharacterId())
                           {
                              Main.getMainChar().showOverheadNumber(Timeline.WORD,Central.main.langLib.get(622));
                              Main.getMainChar().showOverheadNumber(Timeline.WORD,Central.main.langLib.get(830));
                              if(Battle.type == TYPE_NETWORK)
                              {
                                 Main.getMainChar().setBattleBuff(_loc1_.effect);
                              }
                           }
                           if(partyArr)
                           {
                              _loc9_ = 0;
                              while(_loc9_ < partyArr.length)
                              {
                                 if(!partyArr[_loc9_].isDead)
                                 {
                                    partyArr[_loc9_].showOverheadNumber(Timeline.WORD,Central.main.langLib.get(622));
                                    partyArr[_loc9_].showOverheadNumber(Timeline.WORD,Central.main.langLib.get(830));
                                    if(Battle.type == TYPE_NETWORK)
                                    {
                                       partyArr[_loc9_].setBattleBuff(_loc1_.effect);
                                    }
                                 }
                                 _loc9_++;
                              }
                           }
                        }
                        if(attacker.side == BattleData.SIDE_HOSTILE)
                        {
                           _loc9_ = 0;
                           while(_loc9_ < enemyArr.length)
                           {
                              if(!enemyArr[_loc9_].isDead)
                              {
                                 enemyArr[_loc9_].showOverheadNumber(Timeline.WORD,Central.main.langLib.get(622));
                                 enemyArr[_loc9_].showOverheadNumber(Timeline.WORD,Central.main.langLib.get(830));
                                 if(Battle.type == TYPE_NETWORK)
                                 {
                                    enemyArr[_loc9_].setBattleBuff(_loc1_.effect);
                                 }
                              }
                              _loc9_++;
                           }
                        }
                        setbuffThreat(_loc1_.effect);
                        break;
                     case BattleData.EFFECT_DAMAGE_REDUCE_N_ACCURATE:
                        attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(322));
                        attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(735));
                        if(attacker.side == BattleData.SIDE_FRIENDLY)
                        {
                           if(attacker.getCharacterId() != Main.getMainChar().getCharacterId())
                           {
                              Main.getMainChar().showOverheadNumber(Timeline.WORD,Central.main.langLib.get(322));
                              Main.getMainChar().showOverheadNumber(Timeline.WORD,Central.main.langLib.get(735));
                              if(Battle.type == TYPE_NETWORK)
                              {
                                 Main.getMainChar().setBattleBuff(_loc1_.effect);
                              }
                           }
                           if(partyArr)
                           {
                              _loc9_ = 0;
                              while(_loc9_ < partyArr.length)
                              {
                                 if(!partyArr[_loc9_].isDead)
                                 {
                                    partyArr[_loc9_].showOverheadNumber(Timeline.WORD,Central.main.langLib.get(322));
                                    partyArr[_loc9_].showOverheadNumber(Timeline.WORD,Central.main.langLib.get(735));
                                    if(Battle.type == TYPE_NETWORK)
                                    {
                                       partyArr[_loc9_].setBattleBuff(_loc1_.effect);
                                    }
                                 }
                                 _loc9_++;
                              }
                           }
                        }
                        if(attacker.side == BattleData.SIDE_HOSTILE)
                        {
                           _loc9_ = 0;
                           while(_loc9_ < enemyArr.length)
                           {
                              if(!enemyArr[_loc9_].isDead)
                              {
                                 enemyArr[_loc9_].showOverheadNumber(Timeline.WORD,Central.main.langLib.get(322));
                                 enemyArr[_loc9_].showOverheadNumber(Timeline.WORD,Central.main.langLib.get(735));
                                 if(Battle.type == TYPE_NETWORK)
                                 {
                                    enemyArr[_loc9_].setBattleBuff(_loc1_.effect);
                                 }
                              }
                              _loc9_++;
                           }
                        }
                        setbuffThreat(_loc1_.effect);
                        break;
                     case BattleData.EFFECT_WIND_PEACE:
                     case BattleData.EFFECT_WIND_PEACE_2:
                     case BattleData.EFFECT_WIND_PEACE_3:
                     case BattleData.EFFECT_WIND_PEACE_4:
                        attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(611));
                        if(attacker.side == BattleData.SIDE_FRIENDLY)
                        {
                           if(attacker.getCharacterId() != Main.getMainChar().getCharacterId())
                           {
                              Main.getMainChar().showOverheadNumber(Timeline.WORD,Central.main.langLib.get(611));
                              if(Battle.type == TYPE_NETWORK)
                              {
                                 Main.getMainChar().setBattleBuff(_loc1_.effect);
                              }
                           }
                           if(partyArr)
                           {
                              _loc9_ = 0;
                              while(_loc9_ < partyArr.length)
                              {
                                 if(!partyArr[_loc9_].isDead)
                                 {
                                    partyArr[_loc9_].showOverheadNumber(Timeline.WORD,Central.main.langLib.get(611));
                                    if(Battle.type == TYPE_NETWORK)
                                    {
                                       partyArr[_loc9_].setBattleBuff(_loc1_.effect);
                                    }
                                 }
                                 _loc9_++;
                              }
                           }
                        }
                        if(attacker.side == BattleData.SIDE_HOSTILE)
                        {
                           _loc9_ = 0;
                           while(_loc9_ < enemyArr.length)
                           {
                              if(!enemyArr[_loc9_].isDead)
                              {
                                 enemyArr[_loc9_].showOverheadNumber(Timeline.WORD,Central.main.langLib.get(611));
                                 if(Battle.type == TYPE_NETWORK)
                                 {
                                    enemyArr[_loc9_].setBattleBuff(_loc1_.effect);
                                 }
                              }
                              _loc9_++;
                           }
                        }
                        setbuffThreat(_loc1_.effect);
                        break;
                     case BattleData.EFFECT_FIRE_ENERGY_EXCITATION:
                        attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(613));
                        if(Battle.type == TYPE_NETWORK)
                        {
                           _loc2_ = {
                              "type":BattleData.EFFECT_EXCITATION_CP,
                              "duration":_loc1_.effect.amount
                           };
                           attacker.setBattleBuff(_loc2_);
                           _loc2_ = {
                              "type":BattleData.EFFECT_EXCITATION_CHARGE,
                              "duration":_loc1_.effect.duration
                           };
                           attacker.setBattleBuff(_loc2_);
                        }
                        break;
                     case BattleData.EFFECT_LIGHTING_BUNDLE:
                     case BattleData.EFFECT_LIGHTING_BUNDLE_2:
                     case BattleData.EFFECT_LIGHTING_BUNDLE_3:
                     case BattleData.EFFECT_LIGHTING_BUNDLE_4:
                        defender.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(615));
                        if(Battle.type == TYPE_NETWORK)
                        {
                           defender.setBattleDebuff(_loc1_.effect);
                        }
                        break;
                     case BattleData.EFFECT_AMONG_ROCKS:
                        attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(617));
                        break;
                     case BattleData.EFFECT_DARK_CURSE:
                        defender.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(649));
                        if(Battle.type == TYPE_NETWORK)
                        {
                           defender.setBattleDebuff(_loc1_.effect);
                        }
                        break;
                     case BattleData.EFFECT_CLEARBUFF_REDUCE_HP_CP:
                     case BattleData.EFFECT_CALM_TARGET:
                     case BattleData.EFFECT_CLEARBUFF_REDUCE_HP:
                     case BattleData.EFFECT_CLEARBUFF_REDUCE_CP:
                     case BattleData.EFFECT_CLEARBUFF_REDUCE_CP_THANOS:
                        defender.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(737));
                        if(Battle.type == TYPE_NETWORK)
                        {
                           defender.clearBuff();
                        }
                        break;
                     case BattleData.EFFECT_DRAIN_HP_CP_N_ADD_COOLDOWN:
                        if(Battle.type == TYPE_NETWORK)
                        {
                           defender.addAllSkillCooldown(_loc1_.effect.duration);
                        }
                        break;
                     case BattleData.EFFECT_BLOOD_DRINKER:
                        defender.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(819));
                        if(Battle.type == TYPE_NETWORK)
                        {
                           defender.setBattleDebuff(_loc1_.effect);
                        }
                        break;
                     case BattleData.EFFECT_BLOOD_DRINKER_N_RESTORE_HP_BUNDLE:
                        healTarget();
                        defender.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(819));
                        defender.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(325));
                        if(Battle.type == TYPE_NETWORK)
                        {
                           defender.setBattleDebuff(_loc1_.effect);
                        }
                        break;
                     case BattleData.EFFECT_BLOOD_DRINKER_N_RESTORE_HP:
                        healTarget();
                        defender.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(819));
                        if(Battle.type == TYPE_NETWORK)
                        {
                           defender.setBattleDebuff(_loc1_.effect);
                        }
                        break;
                     case BattleData.EFFECT_THEFT_HP:
                        defender.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(2034) + "(" + _loc1_.effect.amount + "%)(" + String(_loc1_.effect.duration - 1) + ")");
                        if(Battle.type == TYPE_NETWORK)
                        {
                           defender.setBattleDebuff(_loc1_.effect);
                        }
                        break;
                     case BattleData.EFFECT_CLEAR_BUFF_NEGATE_BURNORSTUN:
                        defender.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(877));
                        defender.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(2035) + "(" + String(_loc1_.effect.duration - 1) + ")");
                        if(Battle.type == TYPE_NETWORK)
                        {
                           defender.clearBuff();
                           defender.setBattleDebuff(_loc1_.effect);
                        }
                        break;
                     case BattleData.EFFECT_BUFF_NEGATE:
                        defender.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(2035) + "(" + String(_loc1_.effect.duration - 1) + ")");
                        if(Battle.type == TYPE_NETWORK)
                        {
                           defender.setBattleDebuff(_loc1_.effect);
                        }
                        break;
                     case BattleData.EFFECT_PETRIFICATION:
                        defender.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(954));
                        if(Battle.type == TYPE_NETWORK)
                        {
                           defender.setBattleDebuff(_loc1_.effect);
                        }
                        break;
                     case BattleData.EFFECT_BLOOD_FEED:
                        attacker.showOverheadNumber(Timeline.WORD,String(Central.main.langLib.get(683)));
                        break;
                     case BattleData.SKILL_307:
                        attacker.showOverheadNumber(Timeline.WORD,String(Central.main.langLib.get(1366)));
                        if(Battle.type == TYPE_NETWORK)
                        {
                           attacker.setBattleBuff(_loc1_.effect);
                           attacker.clearAllDebuff();
                        }
                        break;
                     case BattleData.EFFECT_ADD_HP_CP_SP_PURIFY_RAGE:
                        attacker.showOverheadNumber(Timeline.WORD,String(Central.main.langLib.get(2067)));
                        break;
                     case BattleData.EFFECT_ADD_HP_CP_SP_PURIFY:
                        attacker.showOverheadNumber(Timeline.WORD,String(Central.main.langLib.get(1366)));
                        break;
                     case BattleData.EFFECT_CLEAR_DEBUFF_RST_DMG_HP:
                        attacker.showOverheadNumber(Timeline.WORD,String(Central.main.langLib.get(1366)));
                        break;
                     case BattleData.SKILL_310:
                        attacker.showOverheadNumber(Timeline.WORD,String("SKILL 310   open"));
                        break;
                     case BattleData.SKILL_311:
                        defender.showOverheadNumber(Timeline.WORD,String("SKILL 311   open"));
                        if(Battle.type == TYPE_NETWORK)
                        {
                           defender.setBattleDebuff(_loc1_.effect);
                        }
                        break;
                     case BattleData.SKILL_312:
                        attacker.showOverheadNumber(Timeline.WORD,String("SKILL 312   open"));
                        if(Battle.type == TYPE_NETWORK)
                        {
                           defender.setBattleDebuff(_loc1_.effect);
                        }
                        break;
                     case BattleData.EFFECT_ACCURATE:
                        attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(735));
                        break;
                     case BattleData.EFFECT_PET_DISORIENTED:
                        defender.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(891));
                        break;
                     case BattleData.EFFECT_INTERNAL_INJURY_DARKNESS:
                        defender.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(877));
                        defender.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(799));
                        if(Battle.type == TYPE_NETWORK)
                        {
                           defender.clearBuff();
                           defender.setBattleDebuff(_loc1_.effect);
                        }
                        break;
                     case BattleData.SKILL_335:
                        attacker.showOverheadNumber(Timeline.WORD,String(Central.main.langLib.get(1369)));
                        setbuffThreat(_loc1_.effect);
                        if(Battle.type == TYPE_NETWORK)
                        {
                           attacker.setBattleBuff(_loc1_.effect);
                        }
                        break;
                     case BattleData.SKILL_285:
                        attacker.showOverheadNumber(Timeline.WORD,String(Central.main.langLib.get(1366)));
                        attacker.showOverheadNumber(Timeline.WORD,String(Central.main.langLib.get(1355)));
                        if(Battle.type == TYPE_NETWORK)
                        {
                           attacker.setBattleBuff(_loc1_.effect);
                           attacker.clearAllDebuff();
                        }
                        break;
                     case BattleData.SKILL_302:
                        attacker.showOverheadNumber(Timeline.WORD,String(Central.main.langLib.get(1366)));
                        attacker.showOverheadNumber(Timeline.WORD,String(Central.main.langLib.get(1358)));
                        if(Battle.type == TYPE_NETWORK)
                        {
                           attacker.clearAllDebuff();
                        }
                        break;
                     case BattleData.SKILL_251:
                        attacker.showOverheadNumber(Timeline.WORD,String(Central.main.langLib.get(1366)));
                        attacker.showOverheadNumber(Timeline.WORD,String(Central.main.langLib.get(748)));
                        if(Battle.type == TYPE_NETWORK)
                        {
                           attacker.clearAllDebuff();
                        }
                        break;
                     case BattleData.SKILL_268:
                     case BattleData.SKILL_268_2:
                        attacker.showOverheadNumber(Timeline.WORD,String(Central.main.langLib.get(1363)));
                        attacker.showOverheadNumber(Timeline.WORD,String(Central.main.langLib.get(1366)));
                        if(Battle.type == TYPE_NETWORK)
                        {
                           attacker.setBattleBuff(_loc1_.effect);
                           attacker.clearAllDebuff();
                        }
                        break;
                     case BattleData.SKILL_304:
                        defender.showOverheadNumber(Timeline.WORD,String(Central.main.langLib.get(1359)));
                        defender.showOverheadNumber(Timeline.WORD,String(Central.main.langLib.get(1360)));
                        if(Battle.type == TYPE_NETWORK)
                        {
                           defender.addSkillCooldown(4,SkillData.TYPE_EARTH);
                        }
                        break;
                     case BattleData.SKILL_253:
                        defender.showOverheadNumber(Timeline.WORD,String(Central.main.langLib.get(1361)));
                        defender.showOverheadNumber(Timeline.WORD,String(Central.main.langLib.get(1362)));
                        if(Battle.type == TYPE_NETWORK)
                        {
                           defender.addSkillCooldown(4,SkillData.TYPE_WATER);
                        }
                        break;
                     case BattleData.EFFECT_GATE_OPENING:
                        attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(296));
                        _loc2_ = _loc1_.effect;
                        break;
                     case BattleData.EFFECT_DAMAGE_BONUS_N_PURIFY:
                     case BattleData.EFFECT_PURIFY:
                        if(_loc1_.effect.activated == true)
                        {
                           defender.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(356));
                           if(defender.isBattleDebuffActive(BattleData.SKILL_253) == true)
                           {
                              defender.showOverheadNumber(Timeline.WORD,String(Central.main.langLib.get(1361) + "(" + defender.getBattleDebuff()[BattleData.SKILL_253].duration + ")"));
                           }
                           if(Battle.type == TYPE_NETWORK)
                           {
                              defender.clearAllDebuff();
                              if(_loc1_.effect.restoreHp != null || _loc1_.effect.restoreHp > 0)
                              {
                              }
                           }
                           else
                           {
                              checkWeaponPurifyRestore(defender);
                              checBackItemPurifyRestore(defender);
                           }
                        }
                        break;
                     case BattleData.EFFECT_SOUL_CHAINS_BUNDLE:
                        _loc2_ = _loc1_.effect;
                        defender.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(329));
                        if(Battle.type == TYPE_NETWORK)
                        {
                           defender.setBattleDebuff(_loc2_);
                        }
                        break;
                     case BattleData.EFFECT_RESTORE_CP:
                        defender.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(350) + _loc1_.effect.amount);
                        if(Battle.type == TYPE_NETWORK)
                        {
                           defender.updateCP(_loc1_.effect.amount);
                        }
                        break;
                     case BattleData.EFFECT_REACTIVE_FORCE:
                        attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(533));
                        _loc2_ = _loc1_.effect;
                        break;
                     case BattleData.EFFECT_FRENZY:
                        attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(834));
                        break;
                     case BattleData.EFFECT_GUARD:
                     case BattleData.EFFECT_ALL_CP_GUARD_RESIST:
                        defender.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(636));
                        break;
                     case BattleData.EFFECT_LIGHT_IMPLUSE:
                        defender.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(651));
                        if(Battle.type == TYPE_NETWORK)
                        {
                           defender.setBattleDebuff(_loc1_.effect);
                        }
                        break;
                     case BattleData.EFFECT_PET_ATTENTION:
                        defender.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(807));
                        break;
                     case BattleData.EFFECT_PET_DAMAGE_BONUS:
                        Out.debug("","this is pet");
                        defender.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(330));
                        _loc2_ = _loc1_.effect;
                        break;
                     case BattleData.EFFECT_COMPLETE_GUARD:
                        defender.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(636));
                        break;
                     case BattleData.EFFECT_CATALYTIC_MATTER:
                        defender.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(814));
                        break;
                     case BattleData.EFFECT_PET_DEBUFF_RESIST:
                        defender.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(822));
                        break;
                     case BattleData.EFFECT_PET_DAMAGE_REDUCTION:
                        defender.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(322));
                        break;
                     case BattleData.EFFECT_RECV_DMG_BLEEDING_DMG_REDUCTION:
                        attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(2062));
                        break;
                     case BattleData.EFFECT_DODGE_BONUS_N_HEAL:
                        attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(830));
                        break;
                     case BattleData.EFFECT_DODGE_BONUS_BONUSDMG:
                        attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(306));
                        attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(330));
                        break;
                     case BattleData.EFFECT_DODGE_BONUS_REGEN_HP:
                        attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(830));
                        attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(306));
                        break;
                     case BattleData.EFFECT_DAMAGE_REDUCE_N_HEAL:
                        defender.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(830));
                        break;
                     case BattleData.EFFECT_PET_DAMAGE_TO_CP:
                        defender.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(832));
                        break;
                     case BattleData.EFFECT_PET_SAVE_CP:
                        defender.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(805));
                        break;
                     case BattleData.EFFECT_PET_LIGHTNING:
                        defender.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(875));
                        break;
                     case BattleData.EFFECT_PET_DRAIN_HP_KEKKAI:
                     case BattleData.EFFECT_ALL_CP_DRAIN_HP:
                        defender.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(878));
                        break;
                     case BattleData.EFFECT_BLOODLUST_DEDICATION:
                        defender.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(356));
                        if(Battle.type == TYPE_NETWORK)
                        {
                           defender.clearAllDebuff();
                        }
                        else
                        {
                           checkWeaponPurifyRestore(defender);
                        }
                        break;
                     case BattleData.EFFECT_ATTACK_MODE:
                        defender.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(881));
                        break;
                     case BattleData.EFFECT_DEFENCE_MODE:
                        defender.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(883));
                        break;
                     case BattleData.EFFECT_WAKE_UP:
                        defender.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(890));
                        if(Battle.type == TYPE_NETWORK)
                        {
                           defender.getBattleDebuff()[BattleData.EFFECT_SLEEP] = null;
                        }
                        break;
                     case BattleData.EFFECT_PET_ENERGIZE:
                        defender.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(893));
                        break;
                     case BattleData.EFFECT_BUNNY_FRENZY:
                        attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(834));
                        break;
                     case BattleData.EFFECT_BATTLE_BUNNY_FRENZY:
                        defender.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(1871));
                        if(Battle.type == TYPE_NETWORK)
                        {
                           defender.setBattleBuff(_loc1_.effect);
                        }
                        break;
                     case BattleData.SKILL_501:
                        if(Battle.type == TYPE_NETWORK)
                        {
                           attacker.setBattleBuff(_loc1_.effect);
                        }
                        break;
                     case BattleData.EFFECT_DOT_HP:
                        if(Battle.type == TYPE_NETWORK)
                        {
                           attacker.setBattleBuff(_loc1_.effect);
                        }
                        break;
                     case BattleData.EFFECT_CLEARBUFF_DAMAGEREDUCTION:
                        defender.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(737));
                        defender.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(801));
                        if(Battle.type == TYPE_NETWORK)
                        {
                           defender.setBattleDebuff(_loc1_.effect);
                           defender.clearBuff();
                        }
                        break;
                     case BattleData.SKILL_341:
                        defender.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(817));
                        defender.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(762));
                        if(Battle.type == TYPE_NETWORK)
                        {
                           defender.setBattleDebuff(_loc1_.effect);
                        }
                        break;
                     case BattleData.EFFECT_DAMAGE_DELAY_INJURY:
                        defender.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(648));
                        break;
                     case BattleData.EFFECT_HEAL_MEMBER:
                        healTarget();
                        break;
                     case BattleData.EFFECT_PET_PERSEVERANCE_MASTER:
                        defender.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(1807)[0]);
                        break;
                     case BattleData.EFFECT_HEAL_HP_N_DMG_BONUS_GASHADOKURO:
                        attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(2063));
                        break;
                     case BattleData.EFFECT_HEAL_HP_N_DMG_BONUS:
                     case BattleData.EFFECT_HEAL_HP_N_DMG_BONUS_UPGRADE:
                        attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(2007));
                        break;
                     case BattleData.EFFECT_INTERNAL_INJURY_CHAOS:
                        if(Battle.type == TYPE_NETWORK)
                        {
                           switch(_loc1_.target)
                           {
                              case "friendly":
                                 _loc9_ = 0;
                                 while(_loc9_ < characterArr.length)
                                 {
                                    if(characterArr[_loc9_].isDead == false && characterArr[_loc9_].side == defender.side)
                                    {
                                       _loc26_ = {
                                          "type":BattleData.EFFECT_CHAOS,
                                          "duration":3
                                       };
                                       characterArr[_loc9_].setBattleDebuff(_loc26_);
                                       _loc26_ = {
                                          "type":BattleData.EFFECT_INTERNAL_INJURY,
                                          "duration":_loc1_.effect.duration,
                                          "amount":_loc1_.effect.amount
                                       };
                                       characterArr[_loc9_].setBattleDebuff(_loc26_);
                                    }
                                    _loc9_++;
                                 }
                                 break;
                              default:
                                 _loc26_ = {
                                    "type":BattleData.EFFECT_CHAOS,
                                    "duration":3
                                 };
                                 defender.setBattleDebuff(_loc26_);
                                 _loc26_ = {
                                    "type":BattleData.EFFECT_INTERNAL_INJURY,
                                    "duration":_loc1_.effect.duration,
                                    "amount":_loc1_.effect.amount
                                 };
                                 defender.setBattleDebuff(_loc26_);
                           }
                        }
                        break;
                     case BattleData.EFFECT_CP_LOCK_AND_DEBUFF_RESIST:
                        if(Battle.type == TYPE_NETWORK)
                        {
                           switch(_loc1_.target)
                           {
                              case "allEnemy":
                                 _loc9_ = 0;
                                 while(_loc9_ < characterArr.length)
                                 {
                                    if(characterArr[_loc9_].isDead == false && characterArr[_loc9_].side == attacker.side)
                                    {
                                       characterArr[_loc9_].showOverheadNumber(Timeline.WORD,Central.main.langLib.get(2013));
                                       _loc26_ = {
                                          "type":BattleData.EFFECT_CP_LOCK,
                                          "duration":_loc1_.effect.duration
                                       };
                                       characterArr[_loc9_].setBattleBuff(_loc26_);
                                       _loc26_ = {
                                          "type":BattleData.EFFECT_RESTRICT_CHARGE,
                                          "duration":_loc1_.effect.amount
                                       };
                                       characterArr[_loc9_].setBattleDebuff(_loc26_);
                                       _loc26_ = {
                                          "type":BattleData.EFFECT_PET_DEBUFF_RESIST,
                                          "duration":_loc1_.effect.duration,
                                          "amount":100
                                       };
                                       characterArr[_loc9_].setBattleBuff(_loc26_);
                                    }
                                    _loc9_++;
                                 }
                                 break;
                              default:
                                 attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(2013));
                                 _loc26_ = {
                                    "type":BattleData.EFFECT_CP_LOCK,
                                    "duration":_loc1_.effect.duration
                                 };
                                 attacker.setBattleBuff(_loc26_);
                                 _loc26_ = {
                                    "type":BattleData.EFFECT_RESTRICT_CHARGE,
                                    "duration":_loc1_.effect.amount
                                 };
                                 attacker.setBattleDebuff(_loc26_);
                                 _loc26_ = {
                                    "type":BattleData.EFFECT_PET_DEBUFF_RESIST,
                                    "duration":_loc1_.effect.duration,
                                    "amount":100
                                 };
                                 attacker.setBattleBuff(_loc26_);
                           }
                        }
                        break;
                     case BattleData.EFFECT_THUNDER_MODE_N_DEBUFF_RESIST:
                        attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(601));
                        _loc26_ = {
                           "type":BattleData.EFFECT_PET_DEBUFF_RESIST,
                           "duration":_loc1_.effect.duration,
                           "amount":100
                        };
                        attacker.setBattleDebuff(_loc26_);
                        _loc26_ = {
                           "type":BattleData.EFFECT_THUNDERSTORM_MODE,
                           "duration":_loc1_.effect.duration,
                           "amount":_loc1_.effect.amount
                        };
                        attacker.setBattleBuff(_loc26_);
                        break;
                     case BattleData.EFFECT_FLAME:
                        switch(_loc1_.target)
                        {
                           case "allEnemy":
                              trace(GF.printObject(characterArr));
                              _loc9_ = 0;
                              while(_loc9_ < characterArr.length)
                              {
                                 if(characterArr[_loc9_].isDead == false && characterArr[_loc9_].side == defender.side)
                                 {
                                    if(Battle.type == Battle.TYPE_NETWORK)
                                    {
                                       characterArr[_loc9_].setBattleDebuff(_loc1_.effect);
                                    }
                                 }
                                 _loc9_++;
                              }
                        }
                        break;
                     case BattleData.EFFECT_SAND_GUARD:
                        attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(2025));
                        if(Battle.type == Battle.TYPE_NETWORK)
                        {
                           _loc26_ = {
                              "type":BattleData.EFFECT_REACTIVE_FORCE,
                              "duration":_loc1_.effect.duration,
                              "chance":int(_loc1_.effect.amount) + 10
                           };
                           attacker.setBattleBuff(_loc26_);
                           _loc26_ = {
                              "type":BattleData.EFFECT_RECEIVED_DMG_RESTORE_HP,
                              "duration":_loc1_.effect.duration,
                              "amount":_loc1_.effect.amount
                           };
                           attacker.setBattleBuff(_loc26_);
                        }
                        break;
                     case BattleData.EFFECT_DMG_BONUS_N_REDUCTION_FIX:
                        attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(2026));
                        if(Battle.type == Battle.TYPE_NETWORK)
                        {
                           attacker.setBattleBuff(_loc1_.effect);
                        }
                        break;
                     case BattleData.EFFECT_DMG_BONUS_N_REDUCTION:
                        attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(2027));
                        if(Battle.type == Battle.TYPE_NETWORK)
                        {
                           attacker.setBattleBuff(_loc1_.effect);
                        }
                        break;
                     case BattleData.EFFECT_DEBUFF_RESIST_EX:
                        attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(2028));
                        break;
                     case BattleData.EFFECT_ALL_BUFF:
                        attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(2029));
                        break;
                     case BattleData.EFFECT_PROTECT_BY_DUMMY:
                     case BattleData.EFFECT_PROTECT_BY_DUMMY_RECEIVED_BURN:
                     case BattleData.EFFECT_PROTECT_BY_DUMMY_RECEIVED_STUN:
                        attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(2030));
                        break;
                     case BattleData.EFFECT_PROTECT_BY_DUMMY_BURN_PROTECTION:
                        attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(2065));
                        break;
                     case BattleData.EFFECT_ABSORB_BUFF:
                        attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(2031));
                  }
               }
            }
            if(_loc1_.reflectEffect)
            {
               defender.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(752));
               checkReflectGenjutsu(_loc1_.reflectEffect);
               if(Battle.type == TYPE_NETWORK)
               {
                  attacker.setBattleDebuff(_loc1_.reflectEffect);
               }
            }
            attacker.updateBattleFrame();
            defender.updateBattleFrame();
         }
         switch(_loc1_.action)
         {
            case "attack":
               damageTarget();
               break;
            case "weapon_attack":
               if(attacker.getWeapon())
               {
                  _loc34_ = Central.main.WEAPON_DATA.find(attacker.getWeapon());
                  if(_loc34_)
                  {
                     for each(_loc26_ in _loc34_.effect)
                     {
                        switch(_loc26_.type)
                        {
                           case BattleData.EFFECT_INSTANT_KILL_BELOW_HP:
                              if(attacker.getWeapon() == "wpn332" && Boolean(_loc1_.weapon_activated))
                              {
                                 defender.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(887));
                                 _loc1_.weapon_activated = false;
                              }
                              break;
                           case BattleData.EFFECT_DEFENDER_POISON:
                              defender.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(321));
                              break;
                           case BattleData.EFFECT_WEAPON_INTERNAL_INJURY:
                              if(_loc1_.weapon_activated)
                              {
                                 defender.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(648));
                                 _loc1_.weapon_activated = false;
                                 if(Battle.type == TYPE_NETWORK)
                                 {
                                    defender.setBattleDebuff(_loc1_.effect);
                                 }
                              }
                              break;
                           case BattleData.EFFECT_DEFENDER_PETRIFICATION:
                              if(_loc1_.weapon_activated)
                              {
                                 defender.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(954));
                                 _loc1_.weapon_activated = false;
                              }
                              break;
                           case BattleData.EFFECT_DEFENDER_CLEAR_BUFF:
                              if(_loc1_.weapon_activated)
                              {
                                 defender.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(877));
                                 _loc1_.weapon_activated = false;
                              }
                              break;
                           case BattleData.EFFECT_ATTACKER_REDUCE_COOLDOWN:
                              if(Battle.type == TYPE_LOCAL && _loc1_.dodge == false || Boolean(Battle.type == TYPE_NETWORK && _loc1_.dodge) && Boolean(_loc1_.dodge[defender.getCharacterId()] == false))
                              {
                                 attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(1609));
                                 if(Battle.type == TYPE_NETWORK)
                                 {
                                    attacker.reduceSkillCooldown(_loc26_.amount,BattleData.REDUCETYPE_SKILL,SkillData.TYPE_GENJUTSU);
                                 }
                              }
                              break;
                           case BattleData.EFFECT_SKILL_899:
                              attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(1609));
                              attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(2001)[10]);
                              break;
                           case "attack_reduce_cooldown.0":
                              if(Battle.type == TYPE_LOCAL && _loc1_.dodge == false || Boolean(Battle.type == TYPE_NETWORK && _loc1_.dodge) && Boolean(_loc1_.dodge[defender.getCharacterId()] == false))
                              {
                                 attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(1609));
                              }
                              break;
                           case BattleData.EFFECT_DEFENDER_FREEZE:
                              if(_loc1_.freeze_weapon_activated)
                              {
                                 defender.showOverheadNumber(Timeline.WORD,String(Central.main.langLib.get(820)));
                                 _loc1_.freeze_weapon_activated = false;
                              }
                              break;
                           case BattleData.EFFECT_DEFENDER_STUN:
                              if(Boolean(Battle.type == TYPE_LOCAL) && Boolean(_loc1_.weapon_activated) || Battle.type == TYPE_NETWORK)
                              {
                                 defender.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(331));
                                 _loc1_.weapon_activated = false;
                              }
                        }
                     }
                  }
               }
               if(attacker.getBackItem())
               {
                  _loc35_ = Central.main.BACK_ITEM_DATA.find(attacker.getBackItem());
                  if(_loc34_)
                  {
                     for each(_loc26_ in _loc35_.effect)
                     {
                        switch(_loc26_.type)
                        {
                           case BattleData.EFFECT_DEFENDER_STUN:
                              if(_loc1_.backitem_activated)
                              {
                                 defender.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(331));
                                 _loc1_.backitem_activated = false;
                              }
                        }
                     }
                  }
               }
               damageTarget();
               break;
            case "charge":
               if(attacker.isBattleBuffActive(BattleData.EFFECT_EXTRA_CP_RECOVER))
               {
                  attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(755));
               }
               if(_loc1_.restoreHp)
               {
                  attacker.showOverheadNumber(Timeline.HEAL,"+" + _loc1_.restoreHp + " " + String(Central.main.langLib.get(483)).replace("+",""));
               }
               if(Battle.type == TYPE_NETWORK)
               {
                  attacker.updateCP(_loc1_.cpRestore);
                  if(_loc1_.restoreHp)
                  {
                     attacker.updateHP(_loc1_.restoreHp);
                  }
               }
               attacker.updateBattleFrame();
               setchargeThreat();
               break;
            case "skill":
               if(_loc1_.effect != null)
               {
                  switch(_loc1_.effect.type)
                  {
                     case BattleData.EFFECT_ADD_ALL_HP_CP:
                        healTarget();
                        break;
                     case BattleData.EFFECT_ADD_ALL_HP_CP_CLEAR_DEBUFF:
                        healTarget();
                  }
               }
               damageTarget();
               break;
            case "class_skill":
               switch(_loc1_.effect.type)
               {
                  case BattleData.SKILL_2000:
                     healTarget();
                     break;
                  case BattleData.SKILL_2001:
                     _loc2_ = _loc1_.effect;
                     attacker.showOverheadNumber(Timeline.WORD,String(Central.main.langLib.get(1366)));
                     if(Battle.type == TYPE_NETWORK)
                     {
                        attacker.clearAllDebuff();
                     }
                     break;
                  case BattleData.SKILL_2003:
                     _loc2_ = _loc1_.effect;
                     if(Battle.type == TYPE_NETWORK)
                     {
                        attacker.setBattleDebuff(_loc2_);
                     }
               }
               damageTarget();
               break;
            case "item":
               _loc27_ = Central.main.ITEM_DATA.find(_loc1_.item);
               switch(_loc27_.effect)
               {
                  case BattleData.ITEM_PERCENT_HP:
                  case BattleData.ITEM_RESTORE_HP:
                     _loc10_ = int(_loc1_.restoreHp);
                     if(Battle.type == TYPE_NETWORK)
                     {
                        attacker.updateHP(_loc10_);
                     }
                     attacker.updateBattleFrame();
                     attacker.showOverheadNumber(Timeline.HEAL,"+" + _loc10_ + " " + String(Central.main.langLib.get(483)).replace("+",""));
                     break;
                  case BattleData.ITEM_PERCENT_CP:
                  case BattleData.ITEM_RESTORE_CP:
                     _loc11_ = int(_loc1_.restoreCp);
                     if(Battle.type == TYPE_NETWORK)
                     {
                        attacker.updateCP(_loc11_);
                     }
                     attacker.updateBattleFrame();
                     attacker.showOverheadNumber(Timeline.WORD,"+" + _loc11_ + " " + String(Central.main.langLib.get(350)).replace("+",""));
                     break;
                  case BattleData.ITEM_PERCENT_HPCP:
                  case BattleData.ITEM_SPECIAL_RUNE_SCROLL:
                     _loc10_ = int(_loc1_.restoreHp);
                     _loc11_ = int(_loc1_.restoreCp);
                     if(Battle.type == TYPE_NETWORK)
                     {
                        attacker.updateHP(_loc10_);
                        attacker.updateCP(_loc11_);
                     }
                     attacker.updateBattleFrame();
                     attacker.showOverheadNumber(Timeline.HEAL,"+" + _loc10_ + " " + String(Central.main.langLib.get(483)).replace("+",""));
                     attacker.showOverheadNumber(Timeline.WORD,"+" + _loc11_ + " " + String(Central.main.langLib.get(350)).replace("+",""));
                     break;
                  case BattleData.EFFECT_DAMAGE_BONUSA:
                  case BattleData.EFFECT_DAMAGE_BONUS:
                     Out.debug("","this is on999");
                     attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(330));
                     break;
                  case BattleData.EFFECT_DMG_BONUS_N_BLEEDING:
                     if(Battle.type == TYPE_NETWORK)
                     {
                        attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(330));
                     }
                     break;
                  case BattleData.EFFECT_DMG_REDUCE_ATKER_BURN:
                  case BattleData.EFFECT_DAMAGE_REDUCTIONA:
                  case BattleData.EFFECT_DAMAGE_REDUCTION:
                     attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(322));
                     break;
                  case BattleData.EFFECT_TURKEY_FEAST:
                     attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(2057));
                     break;
                  case BattleData.ITEM_DAMAGE_BONUS_N_REDUCTION:
                     attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(330));
                     attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(322));
                     break;
                  case BattleData.EFFECT_DODGE_BONUS:
                     attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(306));
                     break;
                  case BattleData.EFFECT_CRITICAL_CHANCE_BONUS:
                     attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(292));
                     break;
                  case BattleData.ITEM_DODGE_BONUS_N_CRITICAL_CHANCE:
                     attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(306));
                     attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(292));
                     break;
                  case BattleData.ITEM_DODGE_BONUS_N_PURIFY_CHANCE:
                     attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(306));
                     attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(1688));
                     break;
                  case BattleData.ITEM_CRITICAL_CHANCE_N_PURIFY_CHANCE:
                     attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(292));
                     attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(1688));
                     break;
                  case BattleData.ITEM_DAMAGE_BONUS_N_ACCURATE:
                     attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(735));
                     attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(745));
                     break;
                  case BattleData.EFFECT_REGENERATE_HP:
                     attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(490));
                     break;
                  case BattleData.EFFECT_ADD_PURIFY_CHANCE:
                     attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(1688));
                     break;
                  case BattleData.EFFECT_ACCURATE:
                     attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(735));
                     break;
                  case BattleData.ITEM_CLEARDEBUFF_RESIST:
                     attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(737));
                     attacker.clearAllDebuff();
                     break;
                  case BattleData.ITEM_STRENGTHEN_N_BLEEDING:
                     attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(330));
                     attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(286));
                     break;
                  case BattleData.ITEM_BOTH_DAMAGE_REDUCTION:
                     attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(322));
                     attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(801));
                     break;
                  case BattleData.ITEM_EFFECT_SEAL_GAN:
                     attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(1725)[0]);
                     break;
                  case BattleData.ITEM_EFFECT_SPY_CP:
                     _loc11_ = int(_loc1_.restoreCp);
                     if(Battle.type == TYPE_NETWORK)
                     {
                        attacker.updateCP(_loc11_);
                     }
                     attacker.updateBattleFrame();
                     attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(1725)[1]);
                     attacker.showOverheadNumber(Timeline.WORD,"+" + _loc11_ + " " + String(Central.main.langLib.get(350)).replace("+",""));
                     break;
                  case BattleData.ITEM_RESTORE_PET_CP_PRESENT:
                     _loc12_ = int(_loc1_.restorePetCp);
                     if(Battle.type == TYPE_NETWORK)
                     {
                        if(Boolean(attacker.pet) && attacker.pet.petMaxEp > 0)
                        {
                           attacker.pet.updatePetCP(_loc12_);
                        }
                     }
                     if(attacker.pet)
                     {
                        attacker.pet.updateBattleFrame();
                        attacker.showOverheadNumber(Timeline.WORD,"+" + _loc12_ + " " + AppData.lang == AppData.ZH ? "寵物CP" : "Pet CP");
                     }
               }
               break;
            case "special":
               trace("battle battleAction = " + _loc1_);
               trace("battle battleAction.effect = " + _loc1_.effect);
               switch(_loc1_.effect.type)
               {
                  case BattleData.EFFECT_PET_RANDOM_EFFECT_ON_DEFENDER:
                     _loc2_ = _loc1_.effect;
                     _loc36_ = [];
                     if(_loc2_.EffectArray)
                     {
                        _loc36_ = _loc2_.EffectArray;
                        _loc38_ = NumberUtil.getRandom();
                        _loc39_ = 0;
                        _loc40_ = {};
                        _loc41_ = "";
                        _loc42_ = 0;
                        while(_loc42_ < _loc36_.length)
                        {
                           if(_loc38_ >= _loc36_[_loc42_].chance)
                           {
                              _loc39_ = _loc42_;
                           }
                           _loc42_++;
                        }
                        _loc40_ = _loc36_[_loc39_];
                        _loc41_ = GetOverHeadString(_loc40_);
                        if(!_loc1_.dodge)
                        {
                           if(_loc40_.isDebuff == true)
                           {
                              if(defender.setBattleDebuff(_loc40_))
                              {
                                 defender.showOverheadNumber(Timeline.WORD,_loc41_);
                                 if(_loc40_.type == BattleData.EFFECT_COLLIDING_WAVE)
                                 {
                                    _loc43_ = {};
                                    _loc43_.type = BattleData.EFFECT_STUN;
                                    _loc43_.duration = _loc40_.duration;
                                    defender.setBattleDebuff(_loc43_);
                                 }
                              }
                              else
                              {
                                 defender.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(484));
                              }
                           }
                           else
                           {
                              defender.setBattleBuff(_loc40_);
                              defender.showOverheadNumber(Timeline.WORD,_loc41_);
                           }
                        }
                     }
                     break;
                  case BattleData.EFFECT_PET_RANDOM_EFFECT_ON_MASTER:
                     _loc2_ = _loc1_.effect;
                     _loc37_ = [];
                     if(_loc2_.EffectArray)
                     {
                        _loc37_ = _loc2_.EffectArray;
                        _loc44_ = NumberUtil.getRandom();
                        _loc45_ = 0;
                        _loc46_ = {};
                        _loc47_ = "";
                        _loc48_ = 0;
                        while(_loc48_ < _loc37_.length)
                        {
                           if(_loc44_ >= _loc37_[_loc48_].chance)
                           {
                              _loc45_ = _loc48_;
                           }
                           _loc48_++;
                        }
                        _loc46_ = _loc37_[_loc45_];
                        _loc47_ = GetOverHeadString(_loc46_);
                        switch(_loc46_.type)
                        {
                           case SkillData.EFFECT_TYPE_HEAL:
                              healTarget();
                              break;
                           case BattleData.EFFECT_RESTORE_CP:
                              defender.showOverheadNumber(Timeline.WORD,_loc47_ + _loc46_.amount);
                              defender.updateCP(_loc46_.amount);
                              break;
                           case BattleData.EFFECT_COOLDOWN_REDUCTION:
                              defender.showOverheadNumber(Timeline.WORD,_loc47_);
                              _loc49_ = defender.getData(DBCharacterData.SKILLS);
                              _loc50_ = 0;
                              _loc51_ = "";
                              _loc52_ = 0;
                              _loc50_ = 0;
                              while(_loc50_ < _loc49_.length)
                              {
                                 _loc51_ = _loc49_[_loc50_];
                                 if(defender.isBattleSkillCooldown(_loc51_))
                                 {
                                    _loc52_ = int(defender.getBattleSkillCooldown(_loc51_));
                                    _loc52_ = _loc52_ - int(_loc46_.amount);
                                    if(_loc52_ <= 0)
                                    {
                                       _loc52_ = 0;
                                    }
                                    defender.battleSkillCooldown[_loc51_] = _loc52_;
                                 }
                                 _loc50_++;
                              }
                        }
                     }
               }
               damageTarget();
               break;
            case "bloodline":
               if(_loc1_.effect != null)
               {
                  _loc53_ = _loc1_.effect;
                  _loc54_ = "";
                  if(_loc1_.BLSKILLID)
                  {
                     _loc54_ = _loc1_.BLSKILLID;
                  }
                  _loc55_ = {};
                  _loc56_ = {};
                  _loc57_ = {};
                  _loc58_ = [];
                  if(Boolean(_loc53_.effect_type_1) && _loc53_.effect_type_1 != "")
                  {
                     _loc55_.type = _loc53_.effect_type_1;
                     _loc55_.duration = _loc53_.duration_1;
                     _loc55_.target = _loc53_.effect_target_1;
                     _loc55_.chancetohit = _loc53_.effect_chancetohit_1;
                     _loc55_.chancetoeffect = _loc53_.effect_chancetoeffect_1;
                     _loc55_.requirement = _loc53_.effect_requirement_1;
                     _loc55_.amount = _loc53_.effect_amount_1;
                     _loc55_.hit = _loc53_.effect_hit_1;
                     _loc55_.resisted = _loc53_.effect_resisted_1 ? _loc53_.effect_resisted_1 : false;
                     _loc58_.push(_loc55_);
                  }
                  if(Boolean(_loc53_.effect_type_2) && _loc53_.effect_type_2 != "")
                  {
                     _loc56_.type = _loc53_.effect_type_2;
                     _loc56_.duration = _loc53_.duration_2;
                     _loc56_.target = _loc53_.effect_target_2;
                     _loc56_.chancetohit = _loc53_.effect_chancetohit_2;
                     _loc56_.chancetoeffect = _loc53_.effect_chancetoeffect_2;
                     _loc56_.requirement = _loc53_.effect_requirement_2;
                     _loc56_.amount = _loc53_.effect_amount_2;
                     _loc56_.hit = _loc53_.effect_hit_2;
                     _loc56_.resisted = _loc53_.effect_resisted_2 ? _loc53_.effect_resisted_2 : false;
                     _loc58_.push(_loc56_);
                  }
                  if(Boolean(_loc53_.effect_type_3) && _loc53_.effect_type_3 != "")
                  {
                     _loc57_.type = _loc53_.effect_type_3;
                     _loc57_.duration = _loc53_.duration_3;
                     _loc57_.target = _loc53_.effect_target_3;
                     _loc57_.chancetohit = _loc53_.effect_chancetohit_3;
                     _loc57_.chancetoeffect = _loc53_.effect_chancetoeffect_3;
                     _loc57_.requirement = _loc53_.effect_requirement_3;
                     _loc57_.amount = _loc53_.effect_amount_3;
                     _loc57_.hit = _loc53_.effect_hit_3;
                     _loc57_.resisted = _loc53_.effect_resisted_3 ? _loc53_.effect_resisted_3 : false;
                     _loc58_.push(_loc57_);
                  }
                  _loc59_ = "";
                  _loc60_ = true;
                  _loc9_ = 0;
                  while(_loc9_ < _loc58_.length)
                  {
                     if(_loc58_[_loc9_].target != 0 && _loc58_[_loc9_].target != 3 && _loc58_[_loc9_].target != 4 && _loc58_[_loc9_].target != 6)
                     {
                        _loc60_ = false;
                     }
                     _loc9_++;
                  }
                  if(_loc60_)
                  {
                     _loc1_.dodge = false;
                  }
                  _loc9_ = 0;
                  while(_loc9_ < _loc58_.length)
                  {
                     if(_loc58_[_loc9_].type != "")
                     {
                        showBloodlineEffect(_loc58_[_loc9_],_loc54_,_loc1_);
                     }
                     _loc9_++;
                  }
               }
               damageTarget();
               break;
            case "senjutsu":
               _loc28_ = _loc1_.effect;
               _loc29_ = "";
               if(_loc1_.SENSKILLID)
               {
                  _loc29_ = _loc1_.SENSKILLID;
               }
               _loc30_ = {};
               _loc31_ = {};
               _loc32_ = {};
               _loc33_ = [];
               if(Boolean(_loc28_.effect_type_1) && _loc28_.effect_type_1 != "")
               {
                  _loc30_.type = _loc28_.effect_type_1;
                  _loc30_.duration = _loc28_.duration_1;
                  _loc30_.target = _loc28_.effect_target_1;
                  _loc30_.chancetohit = _loc28_.effect_chancetohit_1;
                  _loc30_.chancetoeffect = _loc28_.effect_chancetoeffect_1;
                  _loc30_.requirement = _loc28_.effect_requirement_1;
                  _loc30_.amount = _loc28_.effect_amount_1;
                  _loc30_.hit = _loc28_.effect_hit_1;
                  _loc30_.resisted = _loc28_.effect_resisted_1;
                  _loc33_.push(_loc30_);
               }
               if(Boolean(_loc28_.effect_type_2) && _loc28_.effect_type_2 != "")
               {
                  _loc31_.type = _loc28_.effect_type_2;
                  _loc31_.duration = _loc28_.duration_2;
                  _loc31_.target = _loc28_.effect_target_2;
                  _loc31_.chancetohit = _loc28_.effect_chancetohit_2;
                  _loc31_.chancetoeffect = _loc28_.effect_chancetoeffect_2;
                  _loc31_.requirement = _loc28_.effect_requirement_2;
                  _loc31_.amount = _loc28_.effect_amount_2;
                  _loc31_.hit = _loc28_.effect_hit_2;
                  _loc31_.resisted = _loc28_.effect_resisted_2;
                  _loc33_.push(_loc31_);
               }
               if(Boolean(_loc28_.effect_type_3) && _loc28_.effect_type_3 != "")
               {
                  _loc32_.type = _loc28_.effect_type_3;
                  _loc32_.duration = _loc28_.duration_3;
                  _loc32_.target = _loc28_.effect_target_3;
                  _loc32_.chancetohit = _loc28_.effect_chancetohit_3;
                  _loc32_.chancetoeffect = _loc28_.effect_chancetoeffect_3;
                  _loc32_.requirement = _loc28_.effect_requirement_3;
                  _loc32_.amount = _loc28_.effect_amount_3;
                  _loc32_.hit = _loc28_.effect_hit_3;
                  _loc32_.resisted = _loc28_.effect_resisted_3;
                  _loc33_.push(_loc32_);
               }
               _loc59_ = "";
               _loc60_ = true;
               _loc9_ = 0;
               while(_loc9_ < _loc33_.length)
               {
                  if(_loc33_[_loc9_].target != 0 && _loc33_[_loc9_].target != 3 && _loc33_[_loc9_].target != 4 && _loc33_[_loc9_].target != 6)
                  {
                     _loc60_ = false;
                  }
                  _loc9_++;
               }
               if(_loc60_)
               {
                  _loc1_.dodge = false;
               }
               _loc9_ = 0;
               while(_loc9_ < _loc33_.length)
               {
                  showSenjutsuEffect(_loc33_[_loc9_],_loc29_,_loc1_);
                  _loc9_++;
               }
               damageTarget();
               break;
            case "event_action":
               damageTarget();
         }
         checkBloodlineHpCpChange(_loc1_);
         checkSenjutsuHpCpChange(_loc1_);
         if(Battle.type == TYPE_LOCAL)
         {
            if(_loc1_.attackerExtraHp != null)
            {
               if(_loc1_.attackerExtraHp > 0)
               {
                  attacker.showOverheadNumber(Timeline.WORD,"+" + _loc1_.attackerExtraHp + Central.main.langLib.titleTxt(TitleData.HP));
                  if(Battle.type == TYPE_NETWORK)
                  {
                     attacker.updateHP(_loc1_.attackerExtraHp);
                  }
               }
            }
            if(_loc1_.attackerExtraCp != null)
            {
               if(_loc1_.attackerExtraCp > 0)
               {
                  attacker.showOverheadNumber(Timeline.WORD,"+" + _loc1_.attackerExtraCp + Central.main.langLib.titleTxt(TitleData.CP));
                  if(Battle.type == TYPE_NETWORK)
                  {
                     attacker.updateCP(_loc1_.attackerExtraCp);
                  }
               }
            }
            if(_loc1_.attackerExtraSp != null)
            {
               if(_loc1_.attackerExtraSp > 0)
               {
                  attacker.showOverheadNumber(Timeline.WORD,"+" + _loc1_.attackerExtraSp + Central.main.langLib.titleTxt(TitleData.SP));
                  if(Battle.type == TYPE_NETWORK)
                  {
                     attacker.updateSP(_loc1_.attackerExtraSp);
                  }
               }
            }
            if(_loc1_.defenderExtraHp != null)
            {
               if(_loc1_.defenderExtraHp > 0)
               {
                  defender.showOverheadNumber(Timeline.WORD,"+" + _loc1_.defenderExtraHp + Central.main.langLib.titleTxt(TitleData.HP));
                  if(Battle.type == TYPE_NETWORK)
                  {
                     defender.updateHP(_loc1_.defenderExtraHp);
                  }
               }
            }
            if(_loc1_.defenderExtraCp != null)
            {
               trace("1111111111111111111111111111111111111111111111111111111");
               if(_loc1_.defenderExtraCp > 0)
               {
                  defender.showOverheadNumber(Timeline.WORD,"+" + _loc1_.defenderExtraCp + Central.main.langLib.titleTxt(TitleData.CP));
                  if(Battle.type == TYPE_NETWORK)
                  {
                     defender.updateCP(_loc1_.defenderExtraCp);
                  }
               }
            }
            if(_loc1_.defenderExtraSp != null)
            {
               if(_loc1_.defenderExtraSp > 0)
               {
                  defender.showOverheadNumber(Timeline.WORD,"+" + _loc1_.defenderExtraSp + Central.main.langLib.titleTxt(TitleData.SP));
                  if(Battle.type == TYPE_NETWORK)
                  {
                     defender.updateSP(_loc1_.defenderExtraSp);
                  }
               }
            }
         }
         else if(Battle.type == TYPE_NETWORK)
         {
            if(_loc1_.extraRestore)
            {
               if(_loc1_.extraRestore.length > 0)
               {
                  _loc61_ = 0;
                  while(_loc61_ < _loc1_.extraRestore.length)
                  {
                     _loc62_ = _loc1_.extraRestore[_loc61_];
                     _loc63_ = getCharacterById(_loc62_.charId);
                     switch(_loc62_.type)
                     {
                        case "hp":
                           if(_loc62_.amount != 0)
                           {
                              _loc63_.showOverheadNumber(Timeline.WORD,"+" + _loc62_.amount + Central.main.langLib.titleTxt(TitleData.HP));
                              _loc63_.updateHP(_loc62_.amount);
                           }
                           break;
                        case "cp":
                           if(_loc62_.amount != 0)
                           {
                              trace("111111111111111111111111111111111111111111111111111111132131313");
                              _loc63_.showOverheadNumber(Timeline.WORD,"+" + _loc62_.amount + Central.main.langLib.titleTxt(TitleData.CP));
                              _loc63_.updateCP(_loc62_.amount);
                           }
                           break;
                        case "sp":
                           if(_loc62_.amount != 0)
                           {
                              _loc63_.showOverheadNumber(Timeline.WORD,"+" + _loc62_.amount + Central.main.langLib.titleTxt(TitleData.SP));
                              _loc63_.updateSP(_loc62_.amount);
                           }
                     }
                     _loc61_++;
                  }
               }
            }
         }
         Main.updateMenu();
      }
      
      public static function showBloodlineEffect(param1:Object, param2:String, param3:Object = null, param4:* = null) : void
      {
         var _loc14_:int = 0;
         var _loc16_:* = undefined;
         var _loc19_:Array = null;
         var _loc20_:int = 0;
         var _loc21_:Number = NaN;
         var _loc5_:String = "";
         var _loc6_:Array = null;
         var _loc7_:String = "";
         var _loc8_:Array = null;
         var _loc9_:int = 0;
         var _loc10_:uint = 0;
         var _loc11_:String = "";
         var _loc12_:int = 0;
         var _loc13_:Array = [];
         _loc13_ = BloodlineData.NOT_STACK_ARRAY;
         var _loc15_:Boolean = false;
         var _loc17_:Boolean = false;
         var _loc18_:Array = [];
         if(Battle.type == TYPE_LOCAL && param3.dodge == false || Battle.type == TYPE_NETWORK)
         {
            if(param1.hit != false)
            {
               if(param1.duration == 0)
               {
                  if(Battle.type == TYPE_LOCAL && param1.resisted == false || Battle.type == TYPE_LOCAL && param1.resisted == null || Battle.type == TYPE_NETWORK)
                  {
                     switch(param1.type)
                     {
                        case BloodlineData.EFFECT_CLEAR_BUFF:
                           _loc5_ = Central.main.langLib.get(737);
                           if(param1.target == BloodlineData.TARGET_SELF)
                           {
                              if(Battle.type == TYPE_NETWORK)
                              {
                                 if(Boolean(param3.dodge) && param3.dodge[attacker.getCharacterId()] == false)
                                 {
                                    if(checkResisted(param1.resisted,attacker) == false)
                                    {
                                       attacker.clearBuff();
                                       attacker.showOverheadNumber(Timeline.WORD,_loc5_);
                                    }
                                 }
                              }
                              else
                              {
                                 attacker.showOverheadNumber(Timeline.WORD,_loc5_);
                              }
                           }
                           else if(param1.target == BloodlineData.TARGET_ENEMY)
                           {
                              if(Battle.type == TYPE_NETWORK)
                              {
                                 if(param4 == null)
                                 {
                                    if(Boolean(param3.dodge) && param3.dodge[defender.getCharacterId()] == false)
                                    {
                                       if(checkResisted(param1.resisted,defender) == false)
                                       {
                                          defender.clearBuff();
                                       }
                                       defender.showOverheadNumber(Timeline.WORD,_loc5_);
                                    }
                                 }
                                 else if(Boolean(param3.dodge) && param3.dodge[param4.getCharacterId()] == false)
                                 {
                                    if(checkResisted(param1.resisted,param4) == false)
                                    {
                                       param4.clearBuff();
                                    }
                                    param4.showOverheadNumber(Timeline.WORD,_loc5_);
                                 }
                              }
                              else
                              {
                                 defender.showOverheadNumber(Timeline.WORD,_loc5_);
                              }
                           }
                           break;
                        case BloodlineData.EFFECT_UPDATE_HP:
                        case BloodlineData.EFFECT_UPDATE_HP_CP:
                        case BloodlineData.EFFECT_DRAIN_HP:
                           if(param1.target == BloodlineData.TARGET_SELF)
                           {
                              if(haveSkill268HpEffect())
                              {
                                 if(Battle.type == TYPE_NETWORK)
                                 {
                                    if(Boolean(param3.dodge) && param3.dodge[attacker.getCharacterId()] == false)
                                    {
                                       if(checkResisted(param1.resisted,attacker) == false)
                                       {
                                          attacker.showOverheadNumber(Timeline.WORD,String(Central.main.langLib.get(1363)));
                                       }
                                    }
                                 }
                                 else
                                 {
                                    attacker.showOverheadNumber(Timeline.WORD,String(Central.main.langLib.get(1363)));
                                 }
                              }
                           }
                           else if(param1.target == BloodlineData.TARGET_ENEMY)
                           {
                              if(haveSkill268HpEffect())
                              {
                                 if(Battle.type == TYPE_NETWORK)
                                 {
                                    if(Boolean(param3.dodge) && param3.dodge[attacker.getCharacterId()] == false)
                                    {
                                       if(checkResisted(param1.resisted,attacker) == false)
                                       {
                                          attacker.showOverheadNumber(Timeline.WORD,String(Central.main.langLib.get(1363)));
                                       }
                                    }
                                 }
                                 else
                                 {
                                    attacker.showOverheadNumber(Timeline.WORD,String(Central.main.langLib.get(1363)));
                                 }
                              }
                           }
                           break;
                        case BloodlineData.EFFECT_MODIFY_COOLDOWN:
                           if(Battle.type == TYPE_NETWORK)
                           {
                              addSkillCoolDown(param1,param3);
                           }
                           else
                           {
                              if(param1.amount < 0)
                              {
                                 _loc5_ = Central.main.langLib.titleTxt(TitleData.COOLDOWN) + " ";
                              }
                              else
                              {
                                 _loc5_ = Central.main.langLib.titleTxt(TitleData.COOLDOWN) + " + ";
                              }
                              if(param1.target == BloodlineData.TARGET_SELF)
                              {
                                 _loc9_ = int(param1.amount);
                                 _loc6_ = attacker.getData(DBCharacterData.SKILLS);
                                 _loc10_ = uint(param3.AttackerRandomSkillSlot);
                                 if(_loc10_ != 999)
                                 {
                                    if(Battle.type == TYPE_NETWORK)
                                    {
                                       _loc11_ = _loc6_[_loc10_];
                                       _loc12_ = int(attacker.getBattleSkillCooldown(_loc11_));
                                       _loc12_ = _loc12_ + _loc9_;
                                       if(_loc12_ <= 0)
                                       {
                                          _loc12_ = 0;
                                       }
                                       if(checkResisted(param1.resisted,attacker) == false)
                                       {
                                          attacker.battleSkillCooldown[_loc11_] = _loc12_;
                                          attacker.showOverheadNumber(Timeline.WORD,_loc5_ + " : " + String(_loc9_));
                                       }
                                    }
                                    else
                                    {
                                       attacker.showOverheadNumber(Timeline.WORD,_loc5_ + " : " + String(_loc9_));
                                    }
                                 }
                              }
                              else if(param1.target == BloodlineData.TARGET_ENEMY)
                              {
                                 _loc9_ = int(param1.amount);
                                 if(param4 == null)
                                 {
                                    _loc19_ = defender.getData(DBCharacterData.SKILLS);
                                 }
                                 else
                                 {
                                    _loc19_ = param4.getData(DBCharacterData.SKILLS);
                                 }
                                 _loc10_ = uint(param3.DefenderRandomSkillSlot);
                                 if(_loc10_ != 999)
                                 {
                                    if(Battle.type == TYPE_NETWORK)
                                    {
                                       _loc11_ = _loc19_[_loc10_];
                                       _loc12_ = int(defender.getBattleSkillCooldown(_loc11_));
                                       _loc12_ = _loc12_ + _loc9_;
                                       if(_loc12_ <= 0)
                                       {
                                          _loc12_ = 0;
                                       }
                                       if(param4 == null)
                                       {
                                          if(Boolean(param3.dodge) && param3.dodge[defender.getCharacterId()] == false)
                                          {
                                             if(checkResisted(param1.resisted,defender) == false)
                                             {
                                                defender.battleSkillCooldown[_loc11_] = _loc12_;
                                                defender.showOverheadNumber(Timeline.WORD,_loc5_ + " : " + String(_loc9_));
                                             }
                                          }
                                       }
                                       else if(Boolean(param3.dodge) && param3.dodge[param4.getCharacterId()] == false)
                                       {
                                          if(checkResisted(param1.resisted,param4) == false)
                                          {
                                             param4.battleSkillCooldown[_loc11_] = _loc12_;
                                             param4.showOverheadNumber(Timeline.WORD,_loc5_ + " : " + String(_loc9_));
                                          }
                                       }
                                    }
                                    else
                                    {
                                       defender.showOverheadNumber(Timeline.WORD,_loc5_ + " : " + String(_loc9_));
                                    }
                                 }
                              }
                           }
                           _loc5_ = "";
                           break;
                        case BloodlineData.EFFECT_CLEAR_ALL_TARGET_BUFF:
                           _loc5_ = Central.main.langLib.get(737);
                           if(Battle.type == Battle.TYPE_NETWORK)
                           {
                              if(param3.isClearBuff)
                              {
                                 if(attacker.side == BattleData.SIDE_FRIENDLY)
                                 {
                                    _loc18_ = enemyArr;
                                 }
                                 else
                                 {
                                    _loc18_ = [];
                                    _loc18_.push(Central.main.getMainChar());
                                    if(partyArr)
                                    {
                                       _loc18_ = _loc18_.concat(partyArr);
                                    }
                                 }
                                 _loc20_ = 0;
                                 while(_loc20_ < _loc18_.length)
                                 {
                                    _loc18_[_loc20_].showOverheadNumber(Timeline.WORD,_loc5_);
                                    _loc18_[_loc20_].clearBuff();
                                    _loc20_++;
                                 }
                              }
                           }
                           else
                           {
                              switch(int(param1.target))
                              {
                                 case BloodlineData.TARGET_ENEMY:
                                    break;
                                 case BloodlineData.TARGET_ENEMY_ALL:
                                    _loc18_ = [defender];
                                    _loc20_ = 0;
                                    if(attacker.side == BattleData.SIDE_FRIENDLY)
                                    {
                                       _loc18_ = enemyArr;
                                    }
                                    else
                                    {
                                       _loc18_ = [];
                                       _loc18_.push(Central.main.getMainChar());
                                       if(partyArr)
                                       {
                                          _loc18_ = _loc18_.concat(partyArr);
                                       }
                                    }
                                    _loc21_ = NumberUtil.getRandom();
                                    if(_loc21_ <= param1.amount / 100)
                                    {
                                       _loc20_ = 0;
                                       while(_loc20_ < _loc18_.length)
                                       {
                                          _loc18_[_loc20_].showOverheadNumber(Timeline.WORD,_loc5_);
                                          _loc18_[_loc20_].clearBuff();
                                          _loc20_++;
                                       }
                                    }
                              }
                           }
                           break;
                        case BloodlineData.EFFECT_RESTORE_ALL_PARTY:
                           healTarget();
                     }
                  }
               }
               else
               {
                  switch(param1.type)
                  {
                     case BloodlineData.EFFECT_ACCURATE:
                        if(param1.amount > 0)
                        {
                           _loc5_ = Central.main.langLib.get(735);
                        }
                        else
                        {
                           _loc5_ = Central.main.langLib.get(287);
                        }
                        break;
                     case BloodlineData.EFFECT_CAPTURE:
                        _loc5_ = Central.main.langLib.get(736);
                        break;
                     case BloodlineData.EFFECT_CLEAR_BUFF:
                        _loc5_ = Central.main.langLib.get(737);
                        break;
                     case BloodlineData.EFFECT_CONVERT_DMG_CP:
                        _loc5_ = Central.main.langLib.get(738);
                        break;
                     case BloodlineData.EFFECT_CONVERT_DMG_HP:
                        _loc5_ = Central.main.langLib.get(739);
                        break;
                     case BloodlineData.EFFECT_CRITICAL:
                        if(param1.amount > 0)
                        {
                           _loc5_ = Central.main.langLib.get(740);
                        }
                        else
                        {
                           _loc5_ = Central.main.langLib.get(670);
                        }
                        break;
                     case BloodlineData.EFFECT_DODGE:
                        if(param1.amount > 0)
                        {
                           _loc5_ = Central.main.langLib.get(741);
                        }
                        else
                        {
                           _loc5_ = Central.main.langLib.get(799);
                        }
                        break;
                     case BloodlineData.EFFECT_MAX_CP:
                        _loc5_ = "";
                        break;
                     case BloodlineData.EFFECT_MAX_CP_RECOVER:
                        _loc5_ = Central.main.langLib.get(742);
                        break;
                     case BloodlineData.EFFECT_MAX_HP:
                        _loc5_ = "";
                        break;
                     case BloodlineData.EFFECT_MERIDIAN_BLOCK:
                        _loc5_ = Central.main.langLib.get(743);
                        break;
                     case BloodlineData.EFFECT_MODIFY_COOLDOWN:
                        if(param1.amount > 0)
                        {
                           _loc5_ = Central.main.langLib.get(744);
                        }
                        else
                        {
                           _loc5_ = Central.main.langLib.get(800);
                        }
                        break;
                     case BloodlineData.EFFECT_MODIFY_DAMAGE_ALL:
                        if(param1.amount > 0)
                        {
                           Out.debug("","this is oover");
                           _loc5_ = Central.main.langLib.get(745);
                        }
                        else
                        {
                           _loc5_ = Central.main.langLib.get(801);
                        }
                        break;
                     case BloodlineData.EFFECT_MODIFY_DAMAGE_BYTYPE:
                        _loc7_ = param1.requirement;
                        _loc7_ = String(_loc7_).replace("fire",Central.main.langLib.titleTxt(TitleData.FIRE));
                        _loc7_ = String(_loc7_).replace("wind",Central.main.langLib.titleTxt(TitleData.WIND));
                        _loc7_ = String(_loc7_).replace("lightning",Central.main.langLib.titleTxt(TitleData.THUNDER));
                        _loc7_ = String(_loc7_).replace("water",Central.main.langLib.titleTxt(TitleData.WATER));
                        _loc7_ = String(_loc7_).replace("earth",Central.main.langLib.titleTxt(TitleData.EARTH));
                        _loc7_ = String(_loc7_).replace("taijutsu",Central.main.langLib.btnTxt(ButtonData.TAIJUTSU));
                        _loc7_ = String(_loc7_).replace("genjutsu",Central.main.langLib.btnTxt(ButtonData.GENJUTSU));
                        _loc8_ = null;
                        _loc8_ = _loc7_.split(",");
                        if(param1.amount > 0)
                        {
                           Out.debug("","this is 746");
                           _loc5_ = Central.main.langLib.get(746);
                        }
                        else
                        {
                           _loc5_ = Central.main.langLib.get(801);
                        }
                        break;
                     case BloodlineData.EFFECT_MODIFY_DAMAGE_CRITICAL:
                        if(param1.amount > 0)
                        {
                           _loc5_ = Central.main.langLib.get(747);
                        }
                        else
                        {
                           _loc5_ = Central.main.langLib.get(688);
                        }
                        break;
                     case BloodlineData.EFFECT_MODIFY_DEFENCE_ALL:
                        if(param1.amount > 0)
                        {
                           _loc5_ = Central.main.langLib.get(748);
                        }
                        else
                        {
                           _loc5_ = Central.main.langLib.get(802);
                        }
                        break;
                     case BloodlineData.EFFECT_MODIFY_DEFENCE_BYTYPE:
                        _loc7_ = param1.requirement;
                        _loc7_ = String(_loc7_).replace("fire",Central.main.langLib.titleTxt(TitleData.FIRE));
                        _loc7_ = String(_loc7_).replace("wind",Central.main.langLib.titleTxt(TitleData.WIND));
                        _loc7_ = String(_loc7_).replace("lightning",Central.main.langLib.titleTxt(TitleData.THUNDER));
                        _loc7_ = String(_loc7_).replace("water",Central.main.langLib.titleTxt(TitleData.WATER));
                        _loc7_ = String(_loc7_).replace("earth",Central.main.langLib.titleTxt(TitleData.EARTH));
                        _loc7_ = String(_loc7_).replace("taijutsu",Central.main.langLib.btnTxt(ButtonData.TAIJUTSU));
                        _loc7_ = String(_loc7_).replace("genjutsu",Central.main.langLib.btnTxt(ButtonData.GENJUTSU));
                        _loc8_ = null;
                        _loc8_ = _loc7_.split(",");
                        if(param1.amount > 0)
                        {
                           _loc5_ = Central.main.langLib.get(748);
                        }
                        else
                        {
                           _loc5_ = Central.main.langLib.get(803);
                        }
                        break;
                     case BloodlineData.EFFECT_REACTIVE_DEBUFF_ATTACKER:
                        _loc5_ = Central.main.langLib.get(749);
                        break;
                     case BloodlineData.EFFECT_REACTIVE_DEBUFF_DEFENDER:
                        _loc5_ = Central.main.langLib.get(750);
                        break;
                     case BloodlineData.EFFECT_REFLECT_DAMAGE:
                        break;
                     case BloodlineData.EFFECT_STUN:
                        _loc5_ = Central.main.langLib.get(281);
                        break;
                     case BloodlineData.EFFECT_UPDATE_CP:
                        _loc5_ = "";
                        break;
                     case BloodlineData.EFFECT_UPDATE_HP:
                        _loc5_ = "";
                        if(param2 == "skill1019")
                        {
                           _loc5_ = Central.main.langLib.get(753);
                        }
                        if(param2 == "skill1011")
                        {
                           _loc5_ = Central.main.langLib.get(1735);
                        }
                        break;
                     case BloodlineData.EFFECT_RESTRICT_CHARGE:
                        _loc5_ = Central.main.langLib.get(754);
                        break;
                     case BloodlineData.EFFECT_EXTRA_CHARGE_RECOVER:
                        if(param1.amount > 0)
                        {
                           _loc5_ = Central.main.langLib.get(755);
                        }
                        else
                        {
                           _loc5_ = Central.main.langLib.get(804);
                        }
                        break;
                     case BloodlineData.EFFECT_RESIST_DEBUFF:
                        _loc5_ = Central.main.langLib.get(756);
                        break;
                     case BloodlineData.EFFECT_DRAIN_HP:
                        _loc5_ = Central.main.langLib.get(757);
                        break;
                     case BloodlineData.EFFECT_MODIFY_TAIJUTSU_SELFHIT:
                        if(param1.amount > 0)
                        {
                           _loc5_ = Central.main.langLib.get(758);
                        }
                        else
                        {
                           _loc5_ = Central.main.langLib.get(806);
                        }
                        break;
                     case BloodlineData.EFFECT_INTERNAL_INJURY:
                        _loc5_ = Central.main.langLib.get(648);
                        break;
                     case BloodlineData.EFFECT_RESURRECTION:
                        _loc5_ = Central.main.langLib.get(759);
                        break;
                     case BloodlineData.EFFECT_COPY_JUTSU:
                        _loc5_ = Central.main.langLib.get(760);
                        break;
                     case BloodlineData.EFFECT_TITAN:
                        _loc5_ = Central.main.langLib.get(761);
                        break;
                     case BloodlineData.EFFECT_EXTRA_CP_USE:
                        if(param1.amount > 0)
                        {
                           _loc5_ = Central.main.langLib.get(805);
                        }
                        else
                        {
                           _loc5_ = Central.main.langLib.get(762);
                        }
                        if(Battle.type == TYPE_NETWORK)
                        {
                           if(param4 == null)
                           {
                              if(checkResisted(param1.resisted,defender) == false)
                              {
                                 defender.setBattleDebuff(param1);
                              }
                           }
                           else if(checkResisted(param1.resisted,param4) == false)
                           {
                              param4.setBattleDebuff(param1);
                           }
                        }
                        break;
                     case BloodlineData.EFFECT_EXTREME:
                        if(param4 == null)
                        {
                           if(checkResisted(param1.resisted,defender) == false)
                           {
                           }
                        }
                        else if(checkResisted(param1.resisted,param4) == false)
                        {
                        }
                        _loc5_ = Central.main.langLib.get(763);
                        break;
                     case BloodlineData.EFFECT_HALLUCINATIONS:
                        _loc5_ = Central.main.langLib.get(734);
                        break;
                     case BloodlineData.EFFECT_BUNDLE:
                        _loc5_ = Central.main.langLib.get(325);
                        break;
                     case BloodlineData.EFFECT_PET_FREEZE:
                        _loc5_ = Central.main.langLib.get(820);
                        break;
                     case BloodlineData.EFFECT_REDUCE_CP:
                        _loc5_ = Central.main.langLib.get(1657);
                        break;
                     case BloodlineData.EFFECT_BL_UPDATE_HP_FIX_NUM:
                        _loc5_ = Central.main.langLib.get(2011);
                  }
                  if(_loc13_.indexOf(param1.type) < 0)
                  {
                     if(param1.type == BloodlineData.EFFECT_REACTIVE_DEBUFF_ATTACKER || param1.type == BloodlineData.EFFECT_REACTIVE_DEBUFF_DEFENDER)
                     {
                        param1.type = param1.type + "." + param2 + param1.requirement;
                     }
                     else
                     {
                        param1.type = param1.type + "." + param2;
                     }
                  }
                  switch(int(param1.target))
                  {
                     case BloodlineData.TARGET_SELF:
                        if(_loc8_)
                        {
                           _loc14_ = 0;
                           while(_loc14_ < _loc8_.length)
                           {
                              if(checkResisted(param1.resisted,attacker) == false)
                              {
                                 attacker.showOverheadNumber(Timeline.WORD,_loc8_[_loc14_] + " " + _loc5_);
                              }
                              else
                              {
                                 attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(484));
                              }
                              _loc14_++;
                           }
                        }
                        else if(checkResisted(param1.resisted,attacker) == false)
                        {
                           attacker.showOverheadNumber(Timeline.WORD,_loc5_);
                        }
                        else
                        {
                           attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(484));
                        }
                        break;
                     case BloodlineData.TARGET_ENEMY:
                        if(Battle.type == TYPE_LOCAL)
                        {
                           if(!param1.resisted)
                           {
                              _loc15_ = false;
                           }
                           else
                           {
                              _loc15_ = true;
                           }
                        }
                        else if(Battle.type == TYPE_NETWORK)
                        {
                           _loc17_ = false;
                           if(param4 == null)
                           {
                              _loc15_ = checkResisted(param1.resisted,defender);
                              if(Boolean(param3.dodge) && param3.dodge[defender.getCharacterId()] == true)
                              {
                                 _loc17_ = true;
                              }
                           }
                           else
                           {
                              _loc15_ = checkResisted(param1.resisted,param4);
                              if(Boolean(param3.dodge) && param3.dodge[param4.getCharacterId()] == true)
                              {
                                 _loc17_ = true;
                              }
                           }
                        }
                        if(_loc15_ == false && _loc17_ == false)
                        {
                           if(_loc8_)
                           {
                              _loc14_ = 0;
                              while(_loc14_ < _loc8_.length)
                              {
                                 if(param4 == null)
                                 {
                                    defender.showOverheadNumber(Timeline.WORD,_loc8_[_loc14_] + " " + _loc5_);
                                 }
                                 else
                                 {
                                    param4.showOverheadNumber(Timeline.WORD,_loc8_[_loc14_] + " " + _loc5_);
                                 }
                                 _loc14_++;
                              }
                           }
                           else if(param4 == null)
                           {
                              defender.showOverheadNumber(Timeline.WORD,_loc5_);
                           }
                           else
                           {
                              param4.showOverheadNumber(Timeline.WORD,_loc5_);
                           }
                        }
                        else if(_loc17_ == false)
                        {
                           if(param4 == null)
                           {
                              defender.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(484));
                           }
                           else
                           {
                              param4.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(484));
                           }
                        }
                        break;
                     case BloodlineData.TARGET_ARRACKER_DEBUFF:
                        if(Battle.type == TYPE_LOCAL)
                        {
                           if(!param1.resisted)
                           {
                              _loc15_ = false;
                           }
                           else
                           {
                              _loc15_ = true;
                           }
                        }
                        else if(Battle.type == TYPE_NETWORK)
                        {
                           _loc17_ = false;
                           if(param4 == null)
                           {
                              _loc15_ = checkResisted(param1.resisted,defender);
                              if(Boolean(param3.dodge) && param3.dodge[defender.getCharacterId()] == true)
                              {
                                 _loc17_ = true;
                              }
                           }
                           else
                           {
                              _loc15_ = checkResisted(param1.resisted,param4);
                              if(Boolean(param3.dodge) && param3.dodge[param4.getCharacterId()] == true)
                              {
                                 _loc17_ = true;
                              }
                           }
                        }
                        if(_loc15_ == false && _loc17_ == false)
                        {
                           if(_loc8_)
                           {
                              _loc14_ = 0;
                              while(_loc14_ < _loc8_.length)
                              {
                                 attacker.showOverheadNumber(Timeline.WORD,_loc8_[_loc14_] + " " + _loc5_);
                                 _loc14_++;
                              }
                           }
                           else
                           {
                              attacker.showOverheadNumber(Timeline.WORD,_loc5_);
                           }
                        }
                        else if(_loc17_ == false)
                        {
                           attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(484));
                        }
                        break;
                     case BloodlineData.TARGET_MAIN_CHARACTER_BUFF:
                        if(param1.type != BloodlineData.EFFECT_MAX_HP && param1.type != BloodlineData.EFFECT_MAX_CP && param1.type != BloodlineData.EFFECT_SPEED)
                        {
                           if(_loc8_)
                           {
                              _loc14_ = 0;
                              while(_loc14_ < _loc8_.length)
                              {
                                 Central.main.getMainChar().showOverheadNumber(Timeline.WORD,_loc8_[_loc14_] + " " + _loc5_);
                                 _loc14_++;
                              }
                           }
                           else
                           {
                              Central.main.getMainChar().showOverheadNumber(Timeline.WORD,_loc5_);
                           }
                        }
                        break;
                     case BloodlineData.TARGET_SELF_AND_ENEMY_DEBUFF:
                        if(Battle.type == TYPE_LOCAL)
                        {
                           if(!param1.resisted)
                           {
                              _loc15_ = false;
                           }
                           else
                           {
                              _loc15_ = true;
                           }
                        }
                        else if(Battle.type == TYPE_NETWORK)
                        {
                           _loc17_ = false;
                           if(param4 == null)
                           {
                              _loc15_ = checkResisted(param1.resisted,defender);
                              if(Boolean(param3.dodge) && param3.dodge[defender.getCharacterId()] == true)
                              {
                                 _loc17_ = true;
                              }
                           }
                           else
                           {
                              _loc15_ = checkResisted(param1.resisted,param4);
                              if(Boolean(param3.dodge) && param3.dodge[param4.getCharacterId()] == true)
                              {
                                 _loc17_ = true;
                              }
                           }
                        }
                        if(_loc15_ == false && _loc17_ == false)
                        {
                           if(_loc8_)
                           {
                              _loc14_ = 0;
                              while(_loc14_ < _loc8_.length)
                              {
                                 if(param4 == null)
                                 {
                                    defender.showOverheadNumber(Timeline.WORD,_loc8_[_loc14_] + " " + _loc5_);
                                 }
                                 else
                                 {
                                    param4.showOverheadNumber(Timeline.WORD,_loc8_[_loc14_] + " " + _loc5_);
                                 }
                                 _loc14_++;
                              }
                           }
                           else if(param4 == null)
                           {
                              defender.showOverheadNumber(Timeline.WORD,_loc5_);
                           }
                           else
                           {
                              param4.showOverheadNumber(Timeline.WORD,_loc5_);
                           }
                        }
                        else if(_loc17_ == false)
                        {
                           if(param4 == null)
                           {
                              defender.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(484));
                           }
                           else
                           {
                              param4.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(484));
                           }
                        }
                        if(Battle.type == TYPE_LOCAL)
                        {
                           if(!param1.resisted)
                           {
                              _loc15_ = false;
                           }
                           else
                           {
                              _loc15_ = true;
                           }
                        }
                        else if(Battle.type == TYPE_NETWORK)
                        {
                           _loc15_ = checkResisted(param1.resisted,attacker);
                        }
                        if(_loc15_ == false)
                        {
                           if(_loc8_)
                           {
                              _loc14_ = 0;
                              while(_loc14_ < _loc8_.length)
                              {
                                 attacker.showOverheadNumber(Timeline.WORD,_loc8_[_loc14_] + " " + _loc5_);
                                 _loc14_++;
                              }
                           }
                           else
                           {
                              attacker.showOverheadNumber(Timeline.WORD,_loc5_);
                           }
                        }
                        else
                        {
                           attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(484));
                        }
                        break;
                     case BloodlineData.TARGET_ENEMY_ALL:
                        _loc18_ = [defender];
                        if(attacker.side == BattleData.SIDE_FRIENDLY)
                        {
                           _loc18_ = enemyArr;
                        }
                        else
                        {
                           _loc18_ = [];
                           _loc18_.push(Main.getMainChar());
                           if(partyArr)
                           {
                              _loc18_ = _loc18_.concat(partyArr);
                           }
                        }
                        _loc20_ = 0;
                        while(_loc20_ < _loc18_.length)
                        {
                           if(Battle.type == TYPE_LOCAL)
                           {
                              if(!param1.resisted)
                              {
                                 _loc15_ = false;
                              }
                              else
                              {
                                 _loc15_ = true;
                              }
                           }
                           else if(Battle.type == TYPE_NETWORK)
                           {
                              _loc17_ = false;
                              if(param4 == null)
                              {
                                 _loc15_ = checkResisted(param1.resisted,_loc18_[_loc20_]);
                                 if(Boolean(param3.dodge) && param3.dodge[_loc18_[_loc20_].getCharacterId()] == true)
                                 {
                                    _loc17_ = true;
                                 }
                              }
                              else
                              {
                                 _loc15_ = checkResisted(param1.resisted,param4);
                                 if(Boolean(param3.dodge) && param3.dodge[param4.getCharacterId()] == true)
                                 {
                                    _loc17_ = true;
                                 }
                              }
                           }
                           if(_loc15_ == false && _loc17_ == false)
                           {
                              if(_loc8_)
                              {
                                 _loc14_ = 0;
                                 while(_loc14_ < _loc8_.length)
                                 {
                                    if(param4 == null)
                                    {
                                       if(Battle.type == TYPE_LOCAL || Boolean(Battle.type == TYPE_NETWORK && param3.dodge) && Boolean(param3.dodge[_loc18_[_loc20_].getData(DBCharacterData.ID)] == false))
                                       {
                                          _loc18_[_loc20_].showOverheadNumber(Timeline.WORD,_loc8_[_loc14_] + " " + _loc5_);
                                       }
                                    }
                                    else
                                    {
                                       param4.showOverheadNumber(Timeline.WORD,_loc8_[_loc14_] + " " + _loc5_);
                                    }
                                    _loc14_++;
                                 }
                              }
                              else if(param4 == null)
                              {
                                 if(Battle.type == TYPE_LOCAL || Boolean(Battle.type == TYPE_NETWORK && param3.dodge) && Boolean(param3.dodge[_loc18_[_loc20_].getData(DBCharacterData.ID)] == false))
                                 {
                                    _loc18_[_loc20_].showOverheadNumber(Timeline.WORD,_loc5_);
                                 }
                              }
                              else
                              {
                                 param4.showOverheadNumber(Timeline.WORD,_loc8_[_loc14_] + " " + _loc5_);
                              }
                           }
                           else if(_loc17_ == false)
                           {
                              if(param4 == null)
                              {
                                 if(Battle.type == TYPE_LOCAL || Boolean(Battle.type == TYPE_NETWORK && param3.dodge) && Boolean(param3.dodge[_loc18_[_loc20_].getData(DBCharacterData.ID)] == false))
                                 {
                                    _loc18_[_loc20_].showOverheadNumber(Timeline.WORD,Central.main.langLib.get(484));
                                 }
                              }
                              else
                              {
                                 param4.showOverheadNumber(Timeline.WORD,_loc8_[_loc14_] + " " + _loc5_);
                              }
                           }
                           _loc20_++;
                        }
                  }
                  if(String(param1.type).split(".")[0] == BloodlineData.EFFECT_MAX_CP_RECOVER)
                  {
                     if(Battle.type == TYPE_NETWORK)
                     {
                        if(param4 == null)
                        {
                           defender.setBattleBuff(param1);
                           defender.updateCP(0);
                        }
                        else
                        {
                           param4.setBattleBuff(param1);
                           param4.updateCP(0);
                        }
                        Main.updateMenu();
                     }
                  }
               }
            }
         }
         attacker.updateBattleFrame();
         if(param4 == null)
         {
            defender.updateBattleFrame();
         }
         else
         {
            param4.updateBattleFrame();
         }
         Main.updateMenu();
      }
      
      public static function haveSkill268HpEffect() : Boolean
      {
         var _loc2_:String = null;
         var _loc1_:Object = attacker.getBattleBuff();
         for(_loc2_ in _loc1_)
         {
            if(!_loc1_[_loc2_])
            {
               continue;
            }
            if(_loc1_[_loc2_].duration <= 0)
            {
               continue;
            }
            switch(_loc2_)
            {
               case BattleData.SKILL_268:
               case BattleData.SKILL_268_2:
                  return true;
            }
         }
         return false;
      }
      
      public static function showSenjutsuEffect(param1:Object, param2:String, param3:Object = null, param4:* = null) : void
      {
         var _loc14_:int = 0;
         var _loc16_:* = undefined;
         var _loc18_:Array = null;
         var _loc19_:int = 0;
         Out.debug("","showSenjutsuEffect effect.type" + param1.type);
         Out.debug("","effect.duration:" + param1.duration);
         Out.debug(""," effect.hit=" + param1.hit);
         Out.debug("","effect.resisted=" + param1.resisted);
         var _loc5_:String = "";
         var _loc6_:Array = null;
         var _loc7_:String = "";
         var _loc8_:Array = null;
         var _loc9_:int = 0;
         var _loc10_:uint = 0;
         var _loc11_:String = "";
         var _loc12_:int = 0;
         var _loc13_:Array = [];
         var _loc15_:Boolean = false;
         var _loc17_:Boolean = false;
         if(Battle.type == TYPE_LOCAL && param3.dodge == false || Battle.type == TYPE_NETWORK)
         {
            if(param1.hit != false)
            {
               if(param1.duration == 0)
               {
                  if(Battle.type == TYPE_LOCAL && param1.resisted == false || Battle.type == TYPE_LOCAL && param1.resisted == null || Battle.type == TYPE_NETWORK)
                  {
                     switch(param1.type)
                     {
                        case BattleData.EFFECT_DAMAGE_SHIELD:
                           if(param3.damageShield)
                           {
                              attacker.damageShield = param3.damageShield;
                              Out.debug("Battle","attacker.damageShield = " + param3.damageShield);
                           }
                           else
                           {
                              Out.debug("Battle","rex0624: damage shield don\'t exsit!! ");
                           }
                           attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(2001)[2] + "(HP:" + attacker.damageShield + ")");
                           break;
                        case SenjutsuData.EFFECT_SS_REDUCE_AGILITY_DMG_BONUS:
                           if(Boolean(defender.isBattleDebuffActive(BattleData.EFFECT_REDUCE_AGILITY)) || Boolean(defender.isBattleDebuffActive(BattleData.EFFECT_REDUCE_AGILITY + ".skill3002")))
                           {
                              Out.debug("Battle>showSenjutsuEffect","battleAction.effect.damageHp=" + int(param3.effect.damageHp));
                              if(Battle.type == TYPE_NETWORK)
                              {
                                 if(param3.isReduceAgility == null)
                                 {
                                    Out.debug("","skill3003 not dmg bonus XXX");
                                 }
                                 defender.updateHP(-int(param3.effect.damageHp));
                              }
                              else
                              {
                                 defender.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(482) + String(int(-1 * param3.dmg * param1.amount / 100)));
                              }
                           }
                           break;
                        case BattleData.EFFECT_LOSS_HP_DMG_BONUS:
                           if(Battle.type == TYPE_NETWORK)
                           {
                              if(Boolean(param3.dodge) && param3.dodge[attacker.getCharacterId()] == false)
                              {
                                 if(checkResisted(param1.resisted,defender) == false)
                                 {
                                    defender.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(2001)[5]);
                                 }
                              }
                           }
                           else
                           {
                              defender.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(2001)[4]);
                           }
                           break;
                        case SenjutsuData.EFFECT_SS_JUSTU_STEAL:
                           if(Battle.type == TYPE_NETWORK)
                           {
                              Out.debug(null,"on EFFECT_SS_JUSTU_STEAL, [1], battleAction=" + GF.printObject(param3));
                              if(!param3.dodge || !param3.dodge[defender.getCharacterId()] || param3.dodge[defender.getCharacterId()] == false)
                              {
                                 defender.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(2001)[9]);
                                 defender.setBattleSkillCooldown("skill" + param3.stealSkillId,int(param1.amount));
                              }
                           }
                           else
                           {
                              defender.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(2001)[9]);
                           }
                           break;
                        case SenjutsuData.EFFECT_SS_DODGE_IGNORE:
                           break;
                        case BattleData.EFFECT_DRAIN_MAX_SP:
                           attacker.showOverheadNumber(Timeline.WORD,"Skill 3010");
                           break;
                        case SenjutsuData.EFFECT_SS_ABSORB_HPTOSP:
                           attacker.showOverheadNumber(Timeline.WORD,"Skill 3110");
                     }
                  }
               }
               else
               {
                  switch(param1.type)
                  {
                     case SenjutsuData.EFFECT_SENNIN_MODE:
                        break;
                     case SenjutsuData.TARGET_MAIN_CHARACTER_BUFF:
                        if(param1.type != SenjutsuData.EFFECT_SS_MAX_HP)
                        {
                           if(_loc8_)
                           {
                              _loc14_ = 0;
                              while(_loc14_ < _loc8_.length)
                              {
                                 Central.main.getMainChar().showOverheadNumber(Timeline.WORD,_loc8_[_loc14_] + " " + _loc5_);
                                 _loc14_++;
                              }
                           }
                           else
                           {
                              Central.main.getMainChar().showOverheadNumber(Timeline.WORD,_loc5_);
                           }
                        }
                        break;
                     case BattleData.EFFECT_REDUCE_AGILITY:
                        _loc5_ = Central.main.langLib.get(2001)[0];
                        break;
                     case BattleData.EFFECT_PETRIFICATION:
                        _loc5_ = Central.main.langLib.get(954);
                        break;
                     case BattleData.EFFECT_POISON:
                        _loc5_ = Central.main.langLib.get(321);
                        break;
                     case SenjutsuData.EFFECT_SS_MAX_CP_CHANGE_EXTRA:
                        if(defender.isBattleDebuffActive(BattleData.EFFECT_POISON))
                        {
                           _loc5_ = Central.main.langLib.get(2001)[1] + "Extra";
                        }
                        break;
                     case SenjutsuData.EFFECT_SS_MAX_CP_CHANGE:
                        if(!defender.isBattleDebuffActive(BattleData.EFFECT_POISON))
                        {
                           _loc5_ = Central.main.langLib.get(2001)[1];
                        }
                        break;
                     case SenjutsuData.EFFECT_SS_CRITICAL_CHANCE_BONUS:
                        _loc5_ = Central.main.langLib.get(292);
                        Out.debug("battle","EFFECT_SS_CRITICAL_CHANCE_BONUS :: " + _loc5_);
                        break;
                     case SenjutsuData.EFFECT_SS_SKIP_BATTLE_TURN:
                        _loc5_ = Central.main.langLib.get(2001)[8];
                        Out.debug("battle","EFFECT_SS_SKIP_BATTLE_TURN :: " + _loc5_);
                        break;
                     case BattleData.EFFECT_DAMAGE_BONUS_BY_SP:
                        Out.debug("","this is on9999");
                        _loc5_ = Central.main.langLib.get(330);
                        break;
                     case SenjutsuData.EFFECT_SS_BUNDLE_TALENT:
                        _loc5_ = Central.main.langLib.get(2001)[6];
                        break;
                     case SenjutsuData.EFFECT_SS_BURN_HP_CP_SP:
                        _loc5_ = Central.main.langLib.get(2008);
                        Out.debug("","showSenjutsuEffect > word > skill3106");
                        break;
                     case SenjutsuData.EFFECT_SS_IGNORE_DMG:
                        _loc5_ = Central.main.langLib.get(2009);
                        break;
                     case SenjutsuData.EFFECT_SS_WEAPON_ONLY:
                        _loc5_ = Central.main.langLib.get(2010);
                        break;
                     case SenjutsuData.EFFECT_SS_DIVIDE_CHAOS:
                        _loc5_ = Central.main.langLib.get(2008);
                        break;
                     case SenjutsuData.EFFECT_SS_ABSORB_HPTOSP:
                        _loc5_ = "Absorb HP to SP";
                  }
                  switch(int(param1.target))
                  {
                     case SenjutsuData.TARGET_SELF:
                     case SenjutsuData.TARGET_MAIN_CHARACTER_BUFF:
                        if(_loc8_)
                        {
                           _loc14_ = 0;
                           while(_loc14_ < _loc8_.length)
                           {
                              if(checkResisted(param1.resisted,attacker) == false)
                              {
                                 attacker.showOverheadNumber(Timeline.WORD,_loc8_[_loc14_] + " " + _loc5_);
                              }
                              else
                              {
                                 attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(484));
                              }
                              _loc14_++;
                           }
                        }
                        else
                        {
                           attacker.showOverheadNumber(Timeline.WORD,_loc5_);
                        }
                        break;
                     case SenjutsuData.TARGET_ENEMY:
                        if(Battle.type == TYPE_LOCAL)
                        {
                           if(!param1.resisted)
                           {
                              _loc15_ = false;
                           }
                           else
                           {
                              _loc15_ = true;
                           }
                        }
                        else if(Battle.type == TYPE_NETWORK)
                        {
                           _loc17_ = false;
                           if(param4 == null)
                           {
                              _loc15_ = checkResisted(param1.resisted,defender);
                              if(Boolean(param3.dodge) && param3.dodge[defender.getCharacterId()] == true)
                              {
                                 _loc17_ = true;
                              }
                           }
                           else
                           {
                              _loc15_ = checkResisted(param1.resisted,param4);
                              if(Boolean(param3.dodge) && param3.dodge[param4.getCharacterId()] == true)
                              {
                                 _loc17_ = true;
                              }
                           }
                        }
                        if(_loc15_ == false && _loc17_ == false)
                        {
                           if(_loc8_)
                           {
                              _loc14_ = 0;
                              while(_loc14_ < _loc8_.length)
                              {
                                 if(param4 == null)
                                 {
                                    defender.showOverheadNumber(Timeline.WORD,_loc8_[_loc14_] + " " + _loc5_);
                                 }
                                 else
                                 {
                                    param4.showOverheadNumber(Timeline.WORD,_loc8_[_loc14_] + " " + _loc5_);
                                 }
                                 _loc14_++;
                              }
                           }
                           else if(param4 == null)
                           {
                              defender.showOverheadNumber(Timeline.WORD,_loc5_);
                           }
                           else
                           {
                              param4.showOverheadNumber(Timeline.WORD,_loc5_);
                           }
                        }
                        else if(_loc17_ == false)
                        {
                           if(param4 == null)
                           {
                              defender.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(484));
                           }
                           else
                           {
                              param4.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(484));
                           }
                        }
                        break;
                     case SenjutsuData.TARGET_ARRACKER_DEBUFF:
                        if(Battle.type == TYPE_LOCAL)
                        {
                           if(!param1.resisted)
                           {
                              _loc15_ = false;
                           }
                           else
                           {
                              _loc15_ = true;
                           }
                        }
                        else if(Battle.type == TYPE_NETWORK)
                        {
                           _loc17_ = false;
                           if(param4 == null)
                           {
                              _loc15_ = checkResisted(param1.resisted,defender);
                              if(Boolean(param3.dodge) && param3.dodge[defender.getCharacterId()] == true)
                              {
                                 _loc17_ = true;
                              }
                           }
                           else
                           {
                              _loc15_ = checkResisted(param1.resisted,param4);
                              if(Boolean(param3.dodge) && param3.dodge[param4.getCharacterId()] == true)
                              {
                                 _loc17_ = true;
                              }
                           }
                        }
                        if(_loc15_ == false && _loc17_ == false)
                        {
                           if(_loc8_)
                           {
                              _loc14_ = 0;
                              while(_loc14_ < _loc8_.length)
                              {
                                 attacker.showOverheadNumber(Timeline.WORD,_loc8_[_loc14_] + " " + _loc5_);
                                 _loc14_++;
                              }
                           }
                           else
                           {
                              attacker.showOverheadNumber(Timeline.WORD,_loc5_);
                           }
                        }
                        else if(_loc17_ == false)
                        {
                           attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(484));
                        }
                        break;
                     case SenjutsuData.TARGET_SELF_AND_ENEMY_DEBUFF:
                        if(Battle.type == TYPE_LOCAL)
                        {
                           if(!param1.resisted)
                           {
                              _loc15_ = false;
                           }
                           else
                           {
                              _loc15_ = true;
                           }
                        }
                        else if(Battle.type == TYPE_NETWORK)
                        {
                           _loc17_ = false;
                           if(param4 == null)
                           {
                              _loc15_ = checkResisted(param1.resisted,defender);
                              if(Boolean(param3.dodge) && param3.dodge[defender.getCharacterId()] == true)
                              {
                                 _loc17_ = true;
                              }
                           }
                           else
                           {
                              _loc15_ = checkResisted(param1.resisted,param4);
                              if(Boolean(param3.dodge) && param3.dodge[param4.getCharacterId()] == true)
                              {
                                 _loc17_ = true;
                              }
                           }
                        }
                        if(_loc15_ == false && _loc17_ == false)
                        {
                           if(_loc8_)
                           {
                              _loc14_ = 0;
                              while(_loc14_ < _loc8_.length)
                              {
                                 if(param4 == null)
                                 {
                                    defender.showOverheadNumber(Timeline.WORD,_loc8_[_loc14_] + " " + _loc5_);
                                 }
                                 else
                                 {
                                    param4.showOverheadNumber(Timeline.WORD,_loc8_[_loc14_] + " " + _loc5_);
                                 }
                                 _loc14_++;
                              }
                           }
                           else if(param4 == null)
                           {
                              defender.showOverheadNumber(Timeline.WORD,_loc5_);
                           }
                           else
                           {
                              param4.showOverheadNumber(Timeline.WORD,_loc5_);
                           }
                        }
                        else if(_loc17_ == false)
                        {
                           if(param4 == null)
                           {
                              defender.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(484));
                           }
                           else
                           {
                              param4.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(484));
                           }
                        }
                        if(Battle.type == TYPE_LOCAL)
                        {
                           if(!param1.resisted)
                           {
                              _loc15_ = false;
                           }
                           else
                           {
                              _loc15_ = true;
                           }
                        }
                        else if(Battle.type == TYPE_NETWORK)
                        {
                           _loc15_ = checkResisted(param1.resisted,attacker);
                        }
                        if(_loc15_ == false)
                        {
                           if(_loc8_)
                           {
                              _loc14_ = 0;
                              while(_loc14_ < _loc8_.length)
                              {
                                 attacker.showOverheadNumber(Timeline.WORD,_loc8_[_loc14_] + " " + _loc5_);
                                 _loc14_++;
                              }
                           }
                           else
                           {
                              attacker.showOverheadNumber(Timeline.WORD,_loc5_);
                           }
                        }
                        else
                        {
                           attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(484));
                        }
                        break;
                     case SenjutsuData.TARGET_ENEMY_ALL:
                        _loc18_ = [defender];
                        _loc19_ = 0;
                        if(attacker.side == BattleData.SIDE_FRIENDLY)
                        {
                           _loc18_ = enemyArr;
                        }
                        else
                        {
                           _loc18_ = [];
                           _loc18_.push(Main.getMainChar());
                           if(partyArr)
                           {
                              _loc18_ = _loc18_.concat(partyArr);
                           }
                        }
                        _loc19_ = 0;
                        while(_loc19_ < _loc18_.length)
                        {
                           if(Battle.type == TYPE_LOCAL)
                           {
                              if(!param1.resisted)
                              {
                                 _loc15_ = false;
                              }
                              else
                              {
                                 _loc15_ = true;
                              }
                           }
                           else if(Battle.type == TYPE_NETWORK)
                           {
                              _loc17_ = false;
                              if(param4 == null)
                              {
                                 _loc15_ = checkResisted(param1.resisted,_loc18_[_loc19_]);
                                 if(Boolean(param3.dodge) && param3.dodge[_loc18_[_loc19_].getCharacterId()] == true)
                                 {
                                    _loc17_ = true;
                                 }
                              }
                              else
                              {
                                 _loc15_ = checkResisted(param1.resisted,param4);
                                 if(Boolean(param3.dodge) && param3.dodge[param4.getCharacterId()] == true)
                                 {
                                    _loc17_ = true;
                                 }
                              }
                           }
                           if(_loc15_ == false && _loc17_ == false)
                           {
                              if(_loc8_)
                              {
                                 _loc14_ = 0;
                                 while(_loc14_ < _loc8_.length)
                                 {
                                    if(param4 == null)
                                    {
                                       if(Battle.type == TYPE_LOCAL || Boolean(Battle.type == TYPE_NETWORK && param3.dodge) && Boolean(param3.dodge[_loc18_[_loc19_].getData(DBCharacterData.ID)] == false))
                                       {
                                          _loc18_[_loc19_].showOverheadNumber(Timeline.WORD,_loc8_[_loc14_] + " " + _loc5_);
                                       }
                                    }
                                    else
                                    {
                                       param4.showOverheadNumber(Timeline.WORD,_loc8_[_loc14_] + " " + _loc5_);
                                    }
                                    _loc14_++;
                                 }
                              }
                              else if(param4 == null)
                              {
                                 if(Battle.type == TYPE_LOCAL || Boolean(Battle.type == TYPE_NETWORK && param3.dodge) && Boolean(param3.dodge[_loc18_[_loc19_].getData(DBCharacterData.ID)] == false))
                                 {
                                    _loc18_[_loc19_].showOverheadNumber(Timeline.WORD,_loc5_);
                                 }
                              }
                              else
                              {
                                 param4.showOverheadNumber(Timeline.WORD,_loc8_[_loc14_] + " " + _loc5_);
                              }
                           }
                           else if(_loc17_ == false)
                           {
                              if(param4 == null)
                              {
                                 if(Battle.type == TYPE_LOCAL || Boolean(Battle.type == TYPE_NETWORK && param3.dodge) && Boolean(param3.dodge[_loc18_[_loc19_].getData(DBCharacterData.ID)] == false))
                                 {
                                    _loc18_[_loc19_].showOverheadNumber(Timeline.WORD,Central.main.langLib.get(484));
                                 }
                              }
                              else
                              {
                                 param4.showOverheadNumber(Timeline.WORD,_loc8_[_loc14_] + " " + _loc5_);
                              }
                           }
                           _loc19_++;
                        }
                  }
               }
            }
         }
         attacker.updateBattleFrame();
         if(param4 == null)
         {
            defender.updateBattleFrame();
         }
         else
         {
            param4.updateBattleFrame();
         }
         Main.updateMenu();
      }
      
      public static function addSkillCoolDown(param1:Object, param2:Object) : void
      {
         var _loc3_:Array = null;
         var _loc4_:* = undefined;
         var _loc5_:String = null;
         var _loc6_:int = 0;
         var _loc7_:String = null;
         var _loc8_:int = 0;
         var _loc9_:uint = 0;
         var _loc10_:String = null;
         var _loc11_:int = 0;
         if(param2.coolDownUpdate)
         {
            _loc3_ = param2.coolDownUpdate;
            _loc8_ = 0;
            _loc9_ = 0;
            _loc10_ = "";
            _loc11_ = 0;
            _loc6_ = 0;
            while(_loc6_ < _loc3_.length)
            {
               if(_loc3_[_loc6_].amount < 0)
               {
                  _loc7_ = Central.main.langLib.titleTxt(TitleData.COOLDOWN) + " ";
               }
               else
               {
                  _loc7_ = Central.main.langLib.titleTxt(TitleData.COOLDOWN) + " + ";
               }
               _loc8_ = int(_loc3_[_loc6_].amount);
               _loc10_ = _loc3_[_loc6_].skillId;
               _loc4_ = getCharacterById(_loc3_[_loc6_].charId);
               _loc5_ = "skill" + _loc10_;
               _loc11_ = int(_loc4_.getBattleSkillCooldown(_loc5_));
               _loc11_ = _loc11_ + _loc8_;
               if(_loc11_ <= 0)
               {
                  _loc11_ = 0;
               }
               if(Boolean(param2.dodge) && param2.dodge[_loc4_.getCharacterId()] == false)
               {
                  if(checkResisted(param1.resisted,_loc4_) == false)
                  {
                     _loc4_.battleSkillCooldown[_loc5_] = _loc11_;
                     _loc4_.showOverheadNumber(Timeline.WORD,_loc7_ + " : " + String(_loc8_ - 1));
                  }
               }
               _loc6_++;
            }
         }
      }
      
      public static function checkReflectGenjutsu(param1:Object) : void
      {
         var _loc2_:int = 0;
         if(checkResisted(param1.resisted,attacker) == true)
         {
            attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(484));
         }
         if(checkResisted(param1.resisted,attacker) == false)
         {
            if(param1.attackerDamageCp != null)
            {
               if(param1.attackerDamageCp < 0)
               {
                  trace("1111111111111111111111111111111111111111111111111111111321432454545");
                  attacker.showOverheadNumber(Timeline.WORD,"-" + param1.attackerDamageCp + Central.main.langLib.titleTxt(TitleData.CP));
                  if(Battle.type == TYPE_NETWORK)
                  {
                     attacker.updateCP(param1.attackerDamageCp);
                  }
               }
            }
            if(param1.attackerRestoreCp != null)
            {
               if(param1.attackerRestoreCp > 0)
               {
                  trace("111111111111111111111111111111111111111111111111111111786876868681");
                  attacker.showOverheadNumber(Timeline.WORD,"+" + param1.attackerRestoreCp + Central.main.langLib.titleTxt(TitleData.CP));
                  if(Battle.type == TYPE_NETWORK)
                  {
                     attacker.updateCP(param1.attackerRestoreCp);
                  }
               }
            }
            if(param1.attackerDamageHp != null)
            {
               if(param1.attackerDamageHp < 0)
               {
                  attacker.showOverheadNumber(Timeline.WORD,"-" + param1.attackerDamageHp + Central.main.langLib.titleTxt(TitleData.HP));
                  if(Battle.type == TYPE_NETWORK)
                  {
                     attacker.updateHP(param1.attackerDamageHp);
                  }
               }
            }
            if(param1.attackerRestoreHp != null)
            {
               if(param1.attackerRestoreHp > 0)
               {
                  attacker.showOverheadNumber(Timeline.WORD,"+" + param1.attackerRestoreHp + Central.main.langLib.titleTxt(TitleData.HP));
                  if(Battle.type == TYPE_NETWORK)
                  {
                     attacker.updateHP(param1.attackerRestoreHp);
                  }
               }
            }
            if(param1.defenderDamageCp != null)
            {
               if(param1.defenderDamageCp < 0)
               {
                  trace("11111111111111111111111111111111111111111111111111111111231232131232132131232131");
                  defender.showOverheadNumber(Timeline.WORD,"-" + param1.defenderDamageCp + Central.main.langLib.titleTxt(TitleData.CP));
                  if(Battle.type == TYPE_NETWORK)
                  {
                     defender.updateCP(param1.defenderDamageCp);
                  }
               }
            }
            if(param1.defenderRestoreCp != null)
            {
               if(param1.defenderRestoreCp > 0)
               {
                  trace("11111111111111111111111111111111111111111111111111111119989879987987987");
                  defender.showOverheadNumber(Timeline.WORD,"+" + param1.defenderRestoreCp + Central.main.langLib.titleTxt(TitleData.CP));
                  if(Battle.type == TYPE_NETWORK)
                  {
                     defender.updateCP(param1.defenderRestoreCp);
                  }
               }
            }
            if(param1.defenderDamageHp != null)
            {
               if(param1.defenderDamageHp < 0)
               {
                  defender.showOverheadNumber(Timeline.WORD,"-" + param1.defenderDamageHp + Central.main.langLib.titleTxt(TitleData.HP));
                  if(Battle.type == TYPE_NETWORK)
                  {
                     defender.updateHP(param1.defenderDamageHp);
                  }
               }
            }
            if(param1.defenderRestoreHp != null)
            {
               if(param1.defenderRestoreHp > 0)
               {
                  defender.showOverheadNumber(Timeline.WORD,"+" + param1.defenderRestoreHp + Central.main.langLib.titleTxt(TitleData.HP));
                  if(Battle.type == TYPE_NETWORK)
                  {
                     defender.updateHP(param1.defenderRestoreHp);
                  }
               }
            }
            switch(param1.type)
            {
               case BattleData.EFFECT_PROFUSION_OF_GHOSTS:
                  attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(744));
                  if(Battle.type == TYPE_NETWORK)
                  {
                     attacker.addAllSkillCooldown(param1.duration);
                  }
                  break;
               case BattleData.EFFECT_CALM_TARGET:
                  attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(737));
                  if(Battle.type == TYPE_NETWORK)
                  {
                     attacker.clearBuff();
                  }
                  break;
               case BattleData.EFFECT_SILVER_CHAIN_BUNDLE:
                  attacker.showOverheadNumber(Timeline.WORD,String(Central.main.langLib.get(676)));
                  if(Battle.type == TYPE_NETWORK)
                  {
                     attacker.setBattleDebuff(param1);
                  }
                  break;
               case BattleData.SKILL_336:
                  attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(349) + String(_loc2_));
                  defender.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(350) + String(_loc2_));
                  break;
               case BattleData.SKILL_345:
                  break;
               case BattleData.EFFECT_INTERNAL_INJURY_DARKNESS:
                  attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(877));
                  attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(799));
                  if(Battle.type == TYPE_NETWORK)
                  {
                     attacker.clearBuff();
                     attacker.setBattleDebuff(param1);
                  }
                  break;
               case BattleData.EFFECT_CLEARBUFF_DAMAGEREDUCTION:
                  attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(737));
                  attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(801));
                  if(Battle.type == TYPE_NETWORK)
                  {
                     attacker.setBattleDebuff(param1);
                     attacker.clearBuff();
                  }
                  break;
               case BattleData.EFFECT_CHAOS:
                  if(Battle.type == TYPE_NETWORK)
                  {
                     attacker.setBattleDebuff(param1);
                  }
            }
         }
      }
      
      public static function checkResisted(param1:*, param2:*) : Boolean
      {
         var _loc3_:int = int(param2.getData(DBCharacterData.ID));
         Out.debug("checkResisted :: ","type >> " + Battle.type);
         if(Battle.type == TYPE_LOCAL)
         {
            if(Boolean(param1) && param1 == true)
            {
               return true;
            }
            if(param1 == false || param1 == null)
            {
               Out.debug("checkResisted :: ","resisted >> " + param1);
               return false;
            }
         }
         else if(Battle.type == TYPE_NETWORK)
         {
            if(Boolean(param1) && Boolean(param1[_loc3_]) && param1[_loc3_] == true)
            {
               return true;
            }
            if(!param1 || !param1[_loc3_] || param1[_loc3_] == false)
            {
               Out.debug("checkResisted !???:: ","resisted >> " + param1);
               return false;
            }
         }
         Out.debug("checkResisted Last:: ","resisted >> " + param1);
         return false;
      }
      
      public static function checkBloodlineHpCpChange(param1:Object) : void
      {
         if(param1.bl_attackerRestoreHp != null)
         {
            if(param1.bl_attackerRestoreHp > 0)
            {
               attacker.showOverheadNumber(Timeline.WORD,"+" + param1.bl_attackerRestoreHp + Central.main.langLib.titleTxt(TitleData.HP));
               if(Battle.type == TYPE_NETWORK)
               {
                  attacker.updateHP(param1.bl_attackerRestoreHp);
               }
            }
         }
         if(param1.bl_attackerRestoreCp != null)
         {
            if(param1.bl_attackerRestoreCp > 0)
            {
               trace("1111111111111111111111111111111111111111112313213131231313213111111111111111222");
               attacker.showOverheadNumber(Timeline.WORD,"+" + param1.bl_attackerRestoreCp + Central.main.langLib.titleTxt(TitleData.CP));
               if(Battle.type == TYPE_NETWORK)
               {
                  attacker.updateCP(param1.bl_attackerRestoreCp);
               }
            }
         }
         if(param1.bl_attackerDamageHp != null)
         {
            if(param1.bl_attackerDamageHp < 0)
            {
               attacker.showOverheadNumber(Timeline.WORD,param1.bl_attackerDamageHp + Central.main.langLib.titleTxt(TitleData.HP));
               if(Battle.type == TYPE_NETWORK)
               {
                  attacker.updateHP(param1.bl_attackerDamageHp);
               }
            }
         }
         if(param1.bl_attackerDamageCp != null)
         {
            if(param1.bl_attackerDamageCp < 0)
            {
               trace("111111111111111111111111111111111111111111111111114321432312654654311111");
               attacker.showOverheadNumber(Timeline.WORD,param1.bl_attackerDamageCp + Central.main.langLib.titleTxt(TitleData.CP));
               if(Battle.type == TYPE_NETWORK)
               {
                  attacker.updateCP(param1.bl_attackerDamageCp);
               }
            }
         }
         if(param1.bl_defenderRestoreHp != null)
         {
            if(param1.bl_defenderRestoreHp > 0)
            {
               defender.showOverheadNumber(Timeline.WORD,"+" + param1.bl_defenderRestoreHp + Central.main.langLib.titleTxt(TitleData.HP));
               if(Battle.type == TYPE_NETWORK)
               {
                  defender.updateHP(param1.bl_defenderRestoreHp);
               }
            }
         }
         if(param1.bl_defenderRestoreCp != null)
         {
            if(param1.bl_defenderRestoreCp > 0)
            {
               trace("1111111111111111111111111111111111111143543678698779711111111111111111");
               defender.showOverheadNumber(Timeline.WORD,"+" + param1.bl_defenderRestoreCp + Central.main.langLib.titleTxt(TitleData.CP));
               if(Battle.type == TYPE_NETWORK)
               {
                  defender.updateCP(param1.bl_defenderRestoreCp);
               }
            }
         }
         if(param1.bl_defenderDamageHp != null)
         {
            if(param1.bl_defenderDamageHp < 0)
            {
               defender.showOverheadNumber(Timeline.WORD,param1.bl_defenderDamageHp + Central.main.langLib.titleTxt(TitleData.HP));
               if(Battle.type == TYPE_NETWORK)
               {
                  defender.updateHP(param1.bl_defenderDamageHp);
               }
            }
         }
         if(param1.bl_defenderDamageCp != null)
         {
            if(param1.bl_defenderDamageCp < 0)
            {
               trace("1111111111111111111111111111111111111111117657573645431111111111111");
               defender.showOverheadNumber(Timeline.WORD,param1.bl_defenderDamageCp + Central.main.langLib.titleTxt(TitleData.CP));
               if(Battle.type == TYPE_NETWORK)
               {
                  defender.updateCP(param1.bl_defenderDamageCp);
               }
            }
         }
      }
      
      public static function checkSenjutsuHpCpChange(param1:Object) : void
      {
         if(param1.sen_attackerRestoreHp != null)
         {
            if(param1.sen_attackerRestoreHp > 0)
            {
               attacker.showOverheadNumber(Timeline.WORD,"+" + param1.sen_attackerRestoreHp + Central.main.langLib.titleTxt(TitleData.HP));
               if(Battle.type == TYPE_NETWORK)
               {
                  attacker.updateHP(param1.sen_attackerRestoreHp);
               }
            }
         }
         if(param1.sen_attackerRestoreCp != null)
         {
            if(param1.sen_attackerRestoreCp > 0)
            {
               trace("111111111111111111111111111111111111111111111111111111333333331");
               attacker.showOverheadNumber(Timeline.WORD,"+" + param1.sen_attackerRestoreCp + Central.main.langLib.titleTxt(TitleData.CP));
               if(Battle.type == TYPE_NETWORK)
               {
                  attacker.updateCP(param1.sen_attackerRestoreCp);
               }
            }
         }
         if(param1.sen_attackerRestoreSp != null)
         {
            if(param1.sen_attackerRestoreSp > 0)
            {
               attacker.showOverheadNumber(Timeline.WORD,"+" + param1.sen_attackerRestoreSp + Central.main.langLib.titleTxt(TitleData.SP));
               if(Battle.type == TYPE_NETWORK)
               {
                  attacker.updateSP(param1.sen_attackerRestoreSp);
               }
            }
         }
         if(param1.sen_attackerDamageHp != null)
         {
            if(param1.sen_attackerDamageHp < 0)
            {
               attacker.showOverheadNumber(Timeline.WORD,param1.sen_attackerDamageHp + Central.main.langLib.titleTxt(TitleData.HP));
               if(Battle.type == TYPE_NETWORK)
               {
                  attacker.updateHP(param1.sen_attackerDamageHp);
               }
            }
         }
         if(param1.sen_attackerDamageCp != null)
         {
            if(param1.sen_attackerDamageCp < 0)
            {
               attacker.showOverheadNumber(Timeline.WORD,param1.sen_attackerDamageCp + Central.main.langLib.titleTxt(TitleData.CP));
               if(Battle.type == TYPE_NETWORK)
               {
                  attacker.updateCP(param1.sen_attackerDamageCp);
               }
            }
         }
         if(param1.sen_attackerDamageSp != null)
         {
            if(param1.sen_attackerDamageSp < 0)
            {
               attacker.showOverheadNumber(Timeline.WORD,param1.sen_attackerDamageSp + Central.main.langLib.titleTxt(TitleData.SP));
               if(Battle.type == TYPE_NETWORK)
               {
                  attacker.updateSP(param1.sen_attackerDamageSp);
               }
            }
         }
         if(param1.sen_defenderRestoreHp != null)
         {
            if(param1.sen_defenderRestoreHp > 0)
            {
               defender.showOverheadNumber(Timeline.WORD,"+" + param1.sen_defenderRestoreHp + Central.main.langLib.titleTxt(TitleData.HP));
               if(Battle.type == TYPE_NETWORK)
               {
                  defender.updateHP(param1.sen_defenderRestoreHp);
               }
            }
         }
         if(param1.sen_defenderRestoreCp != null)
         {
            if(param1.sen_defenderRestoreCp > 0)
            {
               trace("11111111111111111111745662345353211111111111111111111111111111111111");
               defender.showOverheadNumber(Timeline.WORD,"+" + param1.sen_defenderRestoreCp + Central.main.langLib.titleTxt(TitleData.CP));
               if(Battle.type == TYPE_NETWORK)
               {
                  defender.updateCP(param1.sen_defenderRestoreCp);
               }
            }
         }
         if(param1.sen_defenderDamageHp != null)
         {
            if(param1.sen_defenderDamageHp < 0)
            {
               defender.showOverheadNumber(Timeline.WORD,param1.sen_defenderDamageHp + Central.main.langLib.titleTxt(TitleData.HP));
               if(Battle.type == TYPE_NETWORK)
               {
                  defender.updateHP(param1.sen_defenderDamageHp);
               }
            }
         }
         if(param1.sen_defenderDamageCp != null)
         {
            if(param1.sen_defenderDamageCp < 0)
            {
               trace("111111111111111111111145325587987687654323245111111111111111111111111111111111");
               defender.showOverheadNumber(Timeline.WORD,param1.sen_defenderDamageCp + Central.main.langLib.titleTxt(TitleData.CP));
               if(Battle.type == TYPE_NETWORK)
               {
                  defender.updateCP(param1.sen_defenderDamageCp);
               }
            }
         }
         if(param1.sen_defenderDamageSp != null)
         {
            if(param1.sen_defenderDamageSp < 0)
            {
               defender.showOverheadNumber(Timeline.WORD,param1.sen_defenderDamageSp + Central.main.langLib.titleTxt(TitleData.SP));
               if(Battle.type == TYPE_NETWORK)
               {
                  defender.updateSP(param1.sen_defenderDamageSp);
               }
            }
         }
         if(param1.sen_defenderRestoreSp != null)
         {
            if(param1.sen_defenderRestoreSp > 0)
            {
               defender.showOverheadNumber(Timeline.WORD,"+" + param1.sen_defenderRestoreSp + Central.main.langLib.titleTxt(TitleData.SP));
               if(Battle.type == TYPE_NETWORK)
               {
                  defender.updateSP(param1.sen_defenderRestoreSp);
               }
            }
         }
         var _loc2_:int = 0;
         while(_loc2_ < characterArr.length)
         {
            if(characterArr[_loc2_].RestoreHp != null)
            {
               if(characterArr[_loc2_].RestoreHp > 0)
               {
                  characterArr[_loc2_].showOverheadNumber(Timeline.WORD,"+" + characterArr[_loc2_].RestoreHp + Central.main.langLib.titleTxt(TitleData.HP));
                  if(Battle.type == TYPE_NETWORK)
                  {
                     characterArr[_loc2_].updateHP(characterArr[_loc2_].RestoreHp);
                  }
                  trace("checkSenjutsuHpCpChange RestoreHp >> " + characterArr[_loc2_].RestoreHp);
                  characterArr[_loc2_].RestoreHp = 0;
               }
            }
            if(characterArr[_loc2_].RestoreCp != null)
            {
               if(characterArr[_loc2_].RestoreCp > 0)
               {
                  trace("11111111111111111111111111111111111111111111111111111114444444");
                  characterArr[_loc2_].showOverheadNumber(Timeline.WORD,"+" + characterArr[_loc2_].RestoreCp + Central.main.langLib.titleTxt(TitleData.CP));
                  if(Battle.type == TYPE_NETWORK)
                  {
                     characterArr[_loc2_].updateCP(characterArr[_loc2_].RestoreCp);
                  }
                  trace("checkSenjutsuHpCpChange RestoreCp >> " + characterArr[_loc2_].RestoreCp);
                  characterArr[_loc2_].RestoreCp = 0;
               }
            }
            if(characterArr[_loc2_].RestoreSp != null)
            {
               if(characterArr[_loc2_].RestoreSp > 0)
               {
                  characterArr[_loc2_].showOverheadNumber(Timeline.WORD,"+" + characterArr[_loc2_].RestoreSp + Central.main.langLib.titleTxt(TitleData.SP));
                  if(Battle.type == TYPE_NETWORK)
                  {
                     characterArr[_loc2_].updateSP(characterArr[_loc2_].RestoreSp);
                  }
                  trace("checkSenjutsuHpCpChange RestoreSp >> " + characterArr[_loc2_].RestoreSp);
                  characterArr[_loc2_].RestoreSp = 0;
               }
            }
            if(characterArr[_loc2_].DamageHp != null)
            {
               if(characterArr[_loc2_].DamageHp < 0)
               {
                  characterArr[_loc2_].showOverheadNumber(Timeline.WORD,characterArr[_loc2_].DamageHp + Central.main.langLib.titleTxt(TitleData.HP));
                  if(Battle.type == TYPE_NETWORK)
                  {
                     characterArr[_loc2_].updateHP(characterArr[_loc2_].DamageHp);
                  }
                  trace("checkSenjutsuHpCpChange DamageHp >> " + characterArr[_loc2_].DamageHp);
                  characterArr[_loc2_].DamageHp = 0;
               }
            }
            if(characterArr[_loc2_].DamageCp != null)
            {
               if(characterArr[_loc2_].DamageCp < 0)
               {
                  trace("1111111111111111111111111111111111111111111111111111115555551");
                  characterArr[_loc2_].showOverheadNumber(Timeline.WORD,characterArr[_loc2_].DamageCp + Central.main.langLib.titleTxt(TitleData.CP));
                  if(Battle.type == TYPE_NETWORK)
                  {
                     characterArr[_loc2_].updateCP(characterArr[_loc2_].DamageCp);
                  }
                  trace("checkSenjutsuHpCpChange DamageCp >> " + characterArr[_loc2_].DamageCp);
                  characterArr[_loc2_].DamageCp = 0;
               }
            }
            if(characterArr[_loc2_].DamageSp != null)
            {
               if(characterArr[_loc2_].DamageSp < 0)
               {
                  characterArr[_loc2_].showOverheadNumber(Timeline.WORD,characterArr[_loc2_].DamageSp + Central.main.langLib.titleTxt(TitleData.SP));
                  if(Battle.type == TYPE_NETWORK)
                  {
                     characterArr[_loc2_].updateSP(characterArr[_loc2_].DamageSp);
                  }
                  trace("checkSenjutsuHpCpChange DamageSp >> " + characterArr[_loc2_].DamageSp);
                  characterArr[_loc2_].DamageSp = 0;
               }
            }
            _loc2_++;
         }
      }
      
      private static function processDamage(param1:Object) : void
      {
         var _loc2_:* = undefined;
         var _loc3_:Object = null;
         var _loc4_:* = undefined;
         var _loc5_:Object = null;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:Object = null;
         var _loc9_:String = null;
         var _loc10_:Object = null;
         var _loc11_:int = 0;
         var _loc12_:Object = null;
         var _loc13_:Object = null;
         var _loc16_:Array = null;
         var _loc17_:Array = null;
         var _loc18_:Object = null;
         var _loc19_:String = null;
         var _loc20_:String = null;
         var _loc21_:int = 0;
         var _loc22_:Object = null;
         var _loc23_:int = 0;
         var _loc24_:Object = null;
         var _loc25_:String = null;
         var _loc26_:Object = null;
         var _loc27_:Object = null;
         var _loc28_:Array = null;
         var _loc29_:String = null;
         var _loc30_:Boolean = false;
         var _loc31_:int = 0;
         var _loc32_:String = null;
         var _loc33_:int = 0;
         var _loc34_:int = 0;
         var _loc35_:int = 0;
         var _loc36_:Point = null;
         var _loc37_:Point = null;
         if(godModeHackCheck())
         {
            Main.onError("2973","");
            return;
         }
         trace("processDamageprocessDamageprocessDamageprocessDamageprocessDamageprocessDamageprocessDamageprocessDamage");
         _loc2_ = getCharacterById(param1.characterId);
         _loc3_ = attacker.getBattleAction();
         if(Boolean(Battle.type == TYPE_LOCAL) && Boolean(_loc3_.dodge) || Boolean(Battle.type == TYPE_NETWORK && _loc3_.dodge) && Boolean(_loc3_.dodge[_loc2_.getCharacterId()] == true))
         {
            if(Boolean(_loc2_.limb) && _loc2_.limb > 1)
            {
               playAction(getCharacterById(int(_loc2_.getCharacterId() / 10) * 10 + 1),"dodge");
            }
            else
            {
               playAction(_loc2_,"dodge");
            }
            _loc2_.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(293) + "!");
            return;
         }
         if(defender.damageShield > 0 && defender.damageShield > Math.abs(param1.dmg))
         {
            _loc4_ = defender;
            Out.debug("Battle","rex0624: defender hold damageshield.");
         }
         else
         {
            _loc4_ = null;
         }
         if(_loc4_ != null)
         {
            Out.debug("Battle","rex0624: damageShield" + _loc4_.damageShield);
            Out.debug("Battle","rex0624: damageShieldCharacterInfo" + GF.printObject(_loc4_));
            _loc4_.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(2001)[2] + "(HP:" + _loc4_.damageShield + ")");
         }
         if(_loc3_.effect != null && checkResisted(_loc3_.effect.resisted,_loc2_) == false)
         {
            _loc5_ = _loc3_.effect;
            if(_loc3_.critical_stun == true)
            {
               _loc2_.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(281));
               if(Battle.type == TYPE_NETWORK)
               {
                  _loc2_.setBattleDebuff(_loc3_.effect);
               }
            }
            if(_loc3_.clearrbuff == true)
            {
               _loc2_.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(877));
               if(Battle.type == TYPE_NETWORK)
               {
                  _loc2_.clearBuff();
               }
            }
            switch(_loc5_.type)
            {
               case BattleData.EFFECT_BURN_CP:
                  break;
               case BattleData.EFFECT_STUN:
                  if(Battle.type == TYPE_NETWORK)
                  {
                     _loc2_.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(281));
                     _loc2_.setBattleDebuff(_loc3_.effect);
                  }
                  else
                  {
                     _loc2_.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(281));
                  }
                  break;
               case BattleData.EFFECT_STUN_DEBUFF_RESIST:
                  trace("EFFECT_STUN_DEBUFF_RESIST-----3");
                  attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(822));
                  _loc2_.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(331));
                  if(Battle.type == TYPE_NETWORK)
                  {
                     _loc2_.setBattleDebuff(_loc3_.effect);
                     attacker.clearAllDebuff();
                  }
                  break;
               case BattleData.EFFECT_CLEARBUFF_STUN:
               case BattleData.EFFECT_CLEAR_BUFF_NO_RANDOM:
                  _loc2_.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(877));
                  if(Battle.type == TYPE_NETWORK)
                  {
                     _loc2_.clearBuff();
                  }
                  break;
               case BattleData.EFFECT_ECSTATIC_SOUND:
                  _loc2_.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(609));
                  if(Battle.type == TYPE_NETWORK)
                  {
                     _loc2_.setBattleDebuff(_loc3_.effect);
                  }
                  break;
               case BattleData.EFFECT_PET_HEAL:
                  _loc2_.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(830));
                  break;
               case BattleData.EFFECT_PET_REFLECT_ATTACK:
                  _loc2_.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(873));
                  break;
               case BattleData.EFFECT_DISMANTLE:
                  _loc2_.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(817));
                  if(Battle.type == TYPE_NETWORK)
                  {
                     _loc2_.setBattleDebuff(_loc3_.effect);
                  }
                  break;
               case BattleData.EFFECT_PET_DISORIENTED_REDUCE_AGILITY:
                  _loc2_.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(2001)[0]);
                  _loc2_.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(891));
                  if(Battle.type == TYPE_NETWORK)
                  {
                     _loc2_.setBattleDebuff(_loc3_.effect);
                  }
                  break;
               case BattleData.EFFECT_BURN_HP_N_INTERNAL_INJURY:
                  _loc2_.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(648));
                  if(Battle.type == TYPE_NETWORK)
                  {
                     _loc2_.setBattleDebuff(_loc3_.effect);
                     _loc2_.showOverheadNumber(Timeline.WORD,Central.main.langLib.titleTxt(TitleData.HP) + String("-" + _loc3_.effect.damageHp));
                     _loc2_.updateHP(0 - int(_loc3_.effect.damageHp));
                  }
                  break;
               case BattleData.EFFECT_REDUCE_AGI_N_PET_WEAKEN:
                  _loc2_.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(2001)[0]);
                  _loc2_.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(801));
                  if(Battle.type == TYPE_NETWORK)
                  {
                     _loc2_.setBattleDebuff(_loc3_.effect);
                  }
                  break;
               case BattleData.EFFECT_CLEARBUFF_RANDOM_REDUCE_AGI:
                  _loc2_.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(877));
                  if(Battle.type == TYPE_NETWORK)
                  {
                     _loc2_.clearBuff();
                  }
                  if(_loc3_.effect.activated == true)
                  {
                     _loc2_.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(2001)[0]);
                     if(Battle.type == TYPE_NETWORK)
                     {
                        _loc2_.setBattleDebuff(_loc3_.effect);
                     }
                  }
                  break;
               case BattleData.EFFECT_RANDOM_REDUCE_AGI_STUN:
                  if(_loc3_.effect.activated == true)
                  {
                     _loc2_.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(2001)[0]);
                     _loc2_.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(281));
                     if(Battle.type == TYPE_NETWORK)
                     {
                        _loc2_.setBattleDebuff(_loc3_.effect);
                     }
                  }
                  break;
               case BattleData.EFFECT_REDUCE_AGILITY:
                  _loc2_.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(2001)[0]);
                  if(Battle.type == TYPE_NETWORK)
                  {
                     _loc2_.setBattleDebuff(_loc3_.effect);
                  }
                  break;
               case BattleData.EFFECT_REDUCE_AGI_STUN:
                  _loc2_.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(2001)[0]);
                  _loc2_.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(281));
                  if(Battle.type == TYPE_NETWORK)
                  {
                     _loc2_.setBattleDebuff(_loc3_.effect);
                  }
                  break;
               case BattleData.EFFECT_WPNEFT_DISABLE:
                  _loc2_.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(2047));
                  if(Battle.type == TYPE_NETWORK)
                  {
                     _loc2_.setBattleDebuff(_loc3_.effect);
                  }
                  break;
               case BattleData.EFFECT_HIDDEN_MIST:
                  _loc2_.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(2049));
                  if(Battle.type == TYPE_NETWORK)
                  {
                     _loc2_.setBattleDebuff(_loc3_.effect);
                  }
                  break;
               case BattleData.EFFECT_TEARING:
                  _loc2_.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(2054));
                  if(Battle.type == TYPE_NETWORK)
                  {
                     _loc2_.setBattleDebuff(_loc3_.effect);
                  }
                  break;
               case BattleData.EFFECT_DARKNESS:
                  _loc2_.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(1088));
                  if(Battle.type == TYPE_NETWORK)
                  {
                     _loc2_.setBattleDebuff(_loc3_.effect);
                  }
                  break;
               case SenjutsuData.EFFECT_SS_MAX_CP_CHANGE:
                  _loc2_.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(2001)[1]);
                  Out.debug("code_library","rex show word EFFECT_SS_MAX_CP_CHANGE < processDamage");
                  if(Battle.type == TYPE_NETWORK)
                  {
                     _loc2_.setBattleDebuff(_loc3_.effect);
                  }
                  break;
               case SenjutsuData.EFFECT_SS_MAX_CP_CHANGE_EXTRA:
                  _loc2_.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(2001)[1] + "Extra");
                  Out.debug("code_library","rex show word EFFECT_SS_MAX_CP_CHANGE_EXTRA < processDamage");
                  if(Battle.type == TYPE_NETWORK)
                  {
                     _loc2_.setBattleDebuff(_loc3_.effect);
                  }
                  break;
               case BattleData.EFFECT_BLEEDING:
                  _loc2_.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(286) + "(" + String(_loc5_.amount) + "%)");
                  if(Battle.type == TYPE_NETWORK)
                  {
                     _loc2_.setBattleDebuff(_loc5_);
                  }
                  break;
               case BattleData.EFFECT_BLEEDING_FIX_NUM:
                  _loc2_.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(286));
                  if(Battle.type == TYPE_NETWORK)
                  {
                     _loc2_.setBattleDebuff(_loc5_);
                  }
                  break;
               case BattleData.EFFECT_DMG_BONUS_N_BLEEDING:
                  _loc2_.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(286));
                  if(Battle.type == TYPE_NETWORK)
                  {
                     _loc2_.setBattleDebuff(_loc5_);
                  }
                  break;
               case BattleData.SKILL_377:
                  _loc2_.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(325));
                  if(Battle.type == TYPE_NETWORK)
                  {
                     _loc2_.setBattleDebuff(_loc5_);
                  }
                  break;
               case BattleData.EFFECT_CRITICAL_CHANCE_REGEN_HP:
                  attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(292));
                  attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(490));
                  break;
               case BattleData.EFFECT_DAMAGE_BONUS_ACCURATE:
                  _loc2_.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(330));
                  attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(735));
                  if(Battle.type == TYPE_NETWORK)
                  {
                     _loc2_.setBattleBuff(_loc5_);
                  }
                  break;
               case BattleData.SKILL_369:
                  attacker.setBattleBuff(_loc3_.effect);
                  if(Battle.type == TYPE_NETWORK)
                  {
                  }
                  break;
               case BattleData.EFFECT_BURN_CNNT_PURIFY:
               case BattleData.EFFECT_BURN_FIX_NUM:
               case BattleData.EFFECT_DOUBLE_BURN:
               case BattleData.EFFECT_BURN:
               case BattleData.EFFECT_BLAZING:
                  _loc2_.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(288));
                  if(Battle.type == TYPE_NETWORK)
                  {
                     _loc2_.setBattleDebuff(_loc5_);
                  }
                  break;
               case BattleData.EFFECT_BURNING_N_JUTSU_POISON:
               case BattleData.EFFECT_JUTSU_POISON:
                  _loc2_.showOverheadNumber(Timeline.WORD,String(Central.main.langLib.get(321)).replace("[valamt]",Math.round(_loc5_.amount).toString()));
                  if(Battle.type == TYPE_NETWORK)
                  {
                     _loc2_.setBattleDebuff(_loc5_);
                  }
                  break;
               case BattleData.EFFECT_CLEARBUFF_REDUCE_CP:
               case BattleData.EFFECT_CLEARBUFF_REDUCE_CP_THANOS:
                  _loc2_.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(737));
                  if(Battle.type == TYPE_NETWORK)
                  {
                     _loc2_.clearBuff();
                  }
                  break;
               case BattleData.EFFECT_BLIND:
               case BattleData.EFFECT_ALL_CP_BLIND:
                  _loc2_.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(287));
                  if(Battle.type == TYPE_NETWORK)
                  {
                     _loc2_.setBattleDebuff(_loc5_);
                  }
                  break;
               case BattleData.EFFECT_BUNDLE:
                  _loc2_.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(325));
                  if(Battle.type == TYPE_NETWORK)
                  {
                     _loc2_.setBattleDebuff(_loc5_);
                  }
                  break;
               case BattleData.EFFECT_DRAIN_HP_STUN:
                  _loc7_ = int(_loc5_.damageHp);
                  _loc2_.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(482) + String(_loc7_));
                  attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(483) + String(_loc7_));
                  _loc2_.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(281));
                  if(Battle.type == TYPE_NETWORK)
                  {
                     _loc2_.updateHP(0 - _loc7_);
                     attacker.updateHP(_loc7_);
                  }
                  break;
               case BattleData.EFFECT_DRAIN_HP_N_CLEAR_BUFF:
                  _loc7_ = int(_loc5_.damageHp);
                  _loc2_.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(482) + String(_loc7_));
                  attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(483) + String(_loc7_));
                  _loc2_.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(877));
                  if(Battle.type == TYPE_NETWORK)
                  {
                     _loc2_.updateHP(0 - _loc7_);
                     attacker.updateHP(_loc7_);
                     _loc2_.clearBuff();
                  }
                  break;
               case BattleData.EFFECT_DAMAGE_BONUS_N_PURIFY:
                  _loc2_.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(330));
                  if(_loc3_.effect.activated == true)
                  {
                     defender.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(356));
                     if(defender.isBattleDebuffActive(BattleData.SKILL_253) == true)
                     {
                        defender.showOverheadNumber(Timeline.WORD,String(Central.main.langLib.get(1361) + "(" + defender.getBattleDebuff()[BattleData.SKILL_253].duration + ")"));
                     }
                     if(Battle.type == TYPE_NETWORK)
                     {
                        defender.clearAllDebuff();
                        if(_loc3_.effect.restoreHp != null || _loc3_.effect.restoreHp > 0)
                        {
                        }
                     }
                     else
                     {
                        checkWeaponPurifyRestore(defender);
                        checBackItemPurifyRestore(defender);
                     }
                  }
                  break;
               case BattleData.EFFECT_DAMAGE_REDUCE_N_HEAL:
                  _loc2_.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(322));
                  break;
               case BattleData.EFFECT_DODGE_BONUS_N_HEAL:
                  _loc2_.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(306));
                  break;
               case BattleData.EFFECT_BLEEDING_WEAKEN:
                  _loc2_.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(286));
                  _loc2_.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(801));
                  if(Battle.type == TYPE_NETWORK)
                  {
                     _loc2_.setBattleDebuff(_loc5_);
                  }
                  break;
               case BattleData.EFFECT_SERENE_MIND_N_HEAL:
                  _loc2_.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(622));
                  defender.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(830));
                  break;
               case BattleData.EFFECT_BURN_HP_CP_FIX_NUM_N_IMMUNITY_BLEEDING:
                  attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(2056));
                  break;
               case BattleData.EFFECT_DAMAGE_REDUCE_N_ACCURATE:
                  _loc2_.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(322));
                  attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(735));
                  break;
               case BattleData.EFFECT_DRAIN_CP_N_CHARGE_DISABLE:
                  _loc6_ = int(_loc5_.damageCp);
                  _loc2_.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(349) + String(_loc6_));
                  attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(350) + String(_loc6_));
                  _loc2_.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(527));
                  if(Battle.type == TYPE_NETWORK)
                  {
                     _loc2_.updateCP(0 - _loc6_);
                     attacker.updateCP(_loc6_);
                     _loc2_.setBattleDebuff(_loc5_);
                  }
                  break;
               case BattleData.EFFECT_CHARGE_SEAL_REDUCE_CP:
                  _loc2_.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(527));
                  if(Battle.type == TYPE_NETWORK)
                  {
                     _loc2_.setBattleDebuff(_loc5_);
                  }
                  break;
               case BattleData.EFFECT_DRAIN_CHAKRA:
                  _loc6_ = int(_loc5_.damageCp);
                  _loc2_.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(349) + String(_loc6_));
                  attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(350) + String(_loc6_));
                  if(Battle.type == TYPE_NETWORK)
                  {
                     _loc2_.updateCP(0 - _loc6_);
                     attacker.updateCP(_loc6_);
                  }
                  break;
               case BattleData.EFFECT_DRAIN_HP_WEAPON:
                  _loc7_ = int(_loc5_.damageHp);
                  _loc2_.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(482) + String(_loc7_));
                  attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(483) + String(_loc7_));
                  if(Battle.type == TYPE_NETWORK)
                  {
                     _loc2_.updateHP(0 - _loc7_);
                     attacker.updateHP(_loc7_);
                  }
                  break;
               case BattleData.EFFECT_DRAIN_HP:
                  _loc7_ = int(_loc5_.damageHp);
                  _loc2_.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(482) + String(_loc7_));
                  attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(483) + String(_loc7_));
                  if(Battle.type == TYPE_NETWORK)
                  {
                     _loc2_.updateHP(0 - _loc7_);
                     attacker.updateHP(_loc7_);
                  }
                  break;
               case BattleData.EFFECT_DRAIN_DRAIN_HP:
                  _loc7_ = int(_loc5_.damageHp);
                  _loc2_.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(482) + String(_loc7_));
                  attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(483) + String(_loc7_));
                  if(Battle.type == TYPE_NETWORK)
                  {
                     _loc2_.updateHP(0 - _loc7_);
                     attacker.updateHP(_loc7_);
                  }
                  break;
               case BattleData.EFFECT_DRAIN_CP:
                  _loc6_ = int(_loc5_.damageCp);
                  _loc2_.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(349) + String(_loc6_));
                  attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(350) + String(_loc6_));
                  if(Battle.type == TYPE_NETWORK)
                  {
                     _loc2_.updateCP(0 - _loc6_);
                     attacker.updateCP(_loc6_);
                  }
                  break;
               case BattleData.EFFECT_POISON:
                  _loc2_.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(321));
                  if(Battle.type == TYPE_NETWORK)
                  {
                     _loc2_.setBattleDebuff(_loc5_);
                  }
                  break;
               case BattleData.EFFECT_PET_FREEZE_INTERNAL_INJURY:
                  if(_loc3_.effect.activated == true)
                  {
                     _loc2_.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(820));
                     _loc2_.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(648));
                     if(Battle.type == TYPE_NETWORK)
                     {
                        _loc2_.setBattleDebuff(_loc5_);
                     }
                  }
                  break;
               case BattleData.EFFECT_BLIND_N_POISON:
                  _loc2_.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(287));
                  _loc2_.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(321));
                  if(Battle.type == TYPE_NETWORK)
                  {
                     _loc2_.setBattleDebuff(_loc5_);
                  }
                  break;
               case BattleData.EFFECT_PROFUSION_OF_GHOSTS:
                  _loc6_ = int(_loc5_.damageCp);
                  _loc2_.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(744));
                  if(Battle.type == TYPE_NETWORK)
                  {
                     _loc2_.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(349) + String(_loc6_));
                     _loc2_.updateCP(0 - _loc6_);
                     if(_loc3_.effect.extraEffect == true)
                     {
                        _loc2_.addAllSkillCooldown(_loc3_.effect.duration);
                     }
                  }
                  break;
               case BattleData.EFFECT_FEAR:
                  _loc2_.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(304));
                  if(Battle.type == TYPE_NETWORK)
                  {
                     _loc2_.setBattleDebuff(_loc5_);
                  }
                  break;
               case BattleData.EFFECT_INTERNAL_INJURY_FEAR_WEAKEN:
               case BattleData.EFFECT_FEAR_WEAKEN:
               case BattleData.EFFECT_PET_FEAR_WEAKEN:
                  _loc2_.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(305));
                  if(Battle.type == TYPE_NETWORK)
                  {
                     _loc2_.setBattleDebuff(_loc5_);
                  }
                  break;
               case BattleData.EFFECT_INTERNAL_INJURY:
                  _loc2_.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(648));
                  if(Battle.type == TYPE_NETWORK)
                  {
                     _loc2_.setBattleDebuff(_loc5_);
                  }
                  break;
               case BattleData.EFFECT_PARASITE:
                  _loc2_.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(319));
                  if(Battle.type == TYPE_NETWORK)
                  {
                     _loc2_.setBattleDebuff(_loc5_);
                  }
                  break;
               case BattleData.EFFECT_CHAKRA_SUCKER:
                  _loc6_ = int(_loc5_.damageCp);
                  _loc2_.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(349) + String(_loc6_));
                  if(Battle.type == TYPE_NETWORK)
                  {
                     _loc2_.updateCP(0 - _loc6_);
                  }
                  break;
               case BattleData.EFFECT_BURNING_N_JUTSU_POISON:
               case BattleData.EFFECT_BURNING:
                  _loc2_.showOverheadNumber(Timeline.WORD,String(Central.main.langLib.get(289)).replace("[valamt]",Math.round(_loc5_.amount).toString()));
                  if(Battle.type == TYPE_NETWORK)
                  {
                     _loc2_.setBattleDebuff(_loc5_);
                  }
                  break;
               case BattleData.EFFECT_DODGE_REDUCTION:
                  _loc2_.showOverheadNumber(Timeline.WORD,String(Central.main.langLib.get(799)));
                  if(Battle.type == TYPE_NETWORK)
                  {
                     _loc2_.setBattleDebuff(_loc5_);
                  }
                  break;
               case BattleData.EFFECT_PARALYZE:
                  if(_loc3_.critical)
                  {
                     _loc2_.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(2050));
                     if(Battle.type == TYPE_NETWORK)
                     {
                        _loc2_.setBattleDebuff(_loc5_);
                     }
                  }
                  break;
               case BattleData.EFFECT_MERIDIANS_SEAL:
                  _loc2_.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(527));
                  if(Battle.type == TYPE_NETWORK)
                  {
                     _loc2_.setBattleDebuff(_loc5_);
                  }
                  break;
               case BattleData.EFFECT_CUBE_ILLUSION:
                  if(Battle.type == TYPE_NETWORK)
                  {
                     _loc2_.setBattleDebuff(_loc5_);
                  }
                  break;
               case BattleData.EFFECT_HAMSTRING:
                  if(Battle.type == TYPE_NETWORK)
                  {
                     _loc2_.setBattleDebuff(_loc5_);
                  }
                  break;
               case BattleData.EFFECT_PET_BLIND:
                  _loc2_.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(287));
                  if(Battle.type == TYPE_NETWORK)
                  {
                     _loc2_.setBattleDebuff(_loc5_);
                     _loc2_.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(331));
                  }
                  break;
               case BattleData.SKILL_342:
                  _loc2_.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(1361));
                  _loc2_.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(799));
                  _loc2_.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(305));
                  if(Battle.type == TYPE_NETWORK)
                  {
                     _loc2_.setBattleDebuff(_loc5_);
                  }
                  break;
               case BattleData.EFFECT_HEAL_OVER_TIME_NPC:
               case BattleData.EFFECT_HEAL_OVER_TIME_FIX_NUM:
                  _loc2_.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(596));
                  if(Battle.type == TYPE_NETWORK)
                  {
                     _loc2_.setBattleBuff(_loc5_);
                  }
                  break;
               case BattleData.SKILL_234:
                  _loc2_.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(807));
                  _loc2_.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(74));
                  if(Battle.type == TYPE_NETWORK)
                  {
                     _loc2_.setBattleBuff(_loc5_);
                  }
                  break;
               case BattleData.EFFECT_HEAL_OVER_TIME_FIX_NUM_DARKNESS:
                  _loc2_.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(596));
                  _loc2_.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(799));
                  if(Battle.type == TYPE_NETWORK)
                  {
                     _loc2_.setBattleBuff(_loc5_);
                  }
                  break;
               case BattleData.EFFECT_ADD_MAX_HP_LIMIT:
                  attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(2045));
                  if(Battle.type == TYPE_NETWORK)
                  {
                     attacker.setBattleBuff(_loc5_);
                  }
                  break;
               case BattleData.EFFECT_HANAMI_EXTRA_ATTACK:
                  attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(2066));
                  if(Battle.type == TYPE_NETWORK)
                  {
                     attacker.setBattleBuff(_loc5_);
                  }
                  break;
               case BattleData.EFFECT_GIANT_TOAD:
                  attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(2058));
                  if(Battle.type == TYPE_NETWORK)
                  {
                     attacker.setBattleBuff(_loc5_);
                  }
                  break;
               case BattleData.EFFECT_GIANT_TOAD_BIG:
                  attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(2058));
                  if(Battle.type == TYPE_NETWORK)
                  {
                     attacker.setBattleBuff(_loc5_);
                  }
                  break;
               case BattleData.EFFECT_SUSANOO:
                  attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(2044));
                  if(Battle.type == TYPE_NETWORK)
                  {
                     attacker.setBattleBuff(_loc5_);
                  }
                  break;
               case BattleData.EFFECT_SUSANOOA:
                  attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(2044));
                  if(Battle.type == TYPE_NETWORK)
                  {
                     attacker.setBattleBuff(_loc5_);
                  }
                  break;
               case BattleData.EFFECT_SUSANOOB:
                  attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(2044));
                  if(_loc3_.abc == true)
                  {
                     defender.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(877));
                     defender.clearBuff();
                  }
                  break;
               case BattleData.EFFECT_TITAN_DMG_BONUS_BURN:
                  if(Battle.type == TYPE_NETWORK)
                  {
                  }
                  break;
               case BattleData.EFFECT_TITAN_DMG_BONUS_REDUCE_BURN:
                  if(Battle.type == TYPE_NETWORK)
                  {
                  }
                  break;
               case BattleData.EFFECT_TITAN_DMG_BONUS_REDUCE_CUT_CLEAR:
                  if(Battle.type == TYPE_NETWORK)
                  {
                  }
                  break;
               case BattleData.EFFECT_AGILITY_BONUS_FIX:
                  _loc2_.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(2001)[10] + "(" + String(_loc2_.getBattleBuff()[BattleData.EFFECT_AGILITY_BONUS_FIX].duration - 1) + ")");
                  if(Battle.type == TYPE_NETWORK)
                  {
                     _loc2_.setBattleBuff(_loc5_);
                  }
                  break;
               case BattleData.EFFECT_DAMAGE_BONUS_FIX_NUM:
                  attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(330));
                  if(Battle.type == TYPE_NETWORK)
                  {
                     attacker.setBattleBuff(_loc5_);
                     if(_loc3_.effect.extraextraEffect == true)
                     {
                        attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(622));
                        _loc3_.effect.extraextraEffect == false;
                     }
                  }
                  break;
               case BattleData.EFFECT_DMGBONUS_FIX_NUM_CRITICAL_CHANCE_BONUS:
                  attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(330));
                  attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(292));
                  if(Battle.type == TYPE_NETWORK)
                  {
                     attacker.setBattleBuff(_loc5_);
                     if(_loc3_.effect.extraextraEffect == true)
                     {
                        attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(622));
                        _loc3_.effect.extraextraEffect == false;
                     }
                  }
                  break;
               case BattleData.EFFECT_DAMAGE_BONUS:
                  _loc2_.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(330));
                  if(Battle.type == TYPE_NETWORK)
                  {
                     _loc2_.setBattleBuff(_loc5_);
                     if(_loc3_.effect.extraextraEffect == true)
                     {
                        _loc2_.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(622));
                        _loc3_.effect.extraextraEffect == false;
                     }
                  }
                  break;
               case BattleData.EFFECT_DAMAGE_REDUCTIONA:
               case BattleData.EFFECT_DAMAGE_REDUCTION:
                  _loc2_.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(322));
                  break;
               case BattleData.EFFECT_SERENE_MIND_DMGBONUS:
               case BattleData.EFFECT_SERENE_MIND:
                  _loc2_.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(622));
                  break;
               case BattleData.EFFECT_EXPANSION:
                  _loc2_.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(2053));
                  break;
               case BattleData.EFFECT_UNHOLY_POISON:
                  _loc2_.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(2048));
                  break;
               case BattleData.EFFECT_DISORIENTED_BURN_HP:
                  attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(2052));
                  break;
               case BattleData.EFFECT_HIT_SELF:
                  _loc2_.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(2041));
                  break;
               case BattleData.SKILL_236:
                  _loc2_.showOverheadNumber(Timeline.WORD,String(Central.main.langLib.get(799)));
                  _loc2_.showOverheadNumber(Timeline.WORD,String(Central.main.langLib.get(1357)));
                  if(_loc5_.damageHp != null)
                  {
                     _loc2_.showOverheadNumber(Timeline.WORD,"-" + _loc5_.damageHp + Central.main.langLib.titleTxt(TitleData.HP));
                  }
                  if(Battle.type == TYPE_NETWORK)
                  {
                     _loc2_.addSkillCooldown(4,SkillData.TYPE_WIND);
                     if(_loc5_.damageHp != null)
                     {
                        _loc2_.updateHP(0 - _loc5_.damageHp);
                     }
                  }
                  break;
               case BattleData.EFFECT_REDUCE_PURIFY_CHANCE:
                  _loc2_.showOverheadNumber(Timeline.WORD,String(Central.main.langLib.get(1361)));
                  break;
               case BattleData.SKILL_287:
                  _loc2_.showOverheadNumber(Timeline.WORD,String(Central.main.langLib.get(670)));
                  _loc2_.showOverheadNumber(Timeline.WORD,String(Central.main.langLib.get(1356)));
                  if(Battle.type == TYPE_NETWORK)
                  {
                     _loc2_.addSkillCooldown(4,SkillData.TYPE_LIGHTNING);
                     _loc2_.setBattleDebuff({
                        "type":BattleData.EFFECT_DECREASE_CRITICAL_CHANCE,
                        "duration":4,
                        "amount":20
                     });
                  }
                  break;
               case BattleData.SKILL_270:
                  _loc2_.showOverheadNumber(Timeline.WORD,String(Central.main.langLib.get(1365)));
                  _loc2_.showOverheadNumber(Timeline.WORD,String(Central.main.langLib.get(1364)));
                  if(Battle.type == TYPE_NETWORK)
                  {
                     _loc2_.addSkillCooldown(4,SkillData.TYPE_FIRE);
                     if(_loc3_.effect.extraEffect == true)
                     {
                        _loc2_.setBattleDebuff({
                           "type":BattleData.EFFECT_DAMAGE_REDUCTION,
                           "duration":5,
                           "amount":50
                        });
                     }
                  }
                  break;
               case BattleData.EFFECT_DAMAGE_DELAY:
                  attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(1807)[1]);
                  if(Battle.type == TYPE_NETWORK)
                  {
                     _loc2_.setBattleBuff(_loc5_);
                     _loc5_ = {
                        "type":BattleData.EFFECT_PET_DEBUFF_RESIST,
                        "duration":_loc5_.duration,
                        "amount":100
                     };
                     _loc2_.setBattleBuff(_loc5_);
                  }
                  break;
               case BattleData.EFFECT_REDUCE_CP_DAMAGE:
                  trace("EFFECT_REDUCE_CP_DAMAGE::" + Timeline.WORD + "," + Central.main.langLib.get(305));
                  _loc2_.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(305));
                  if(Battle.type == TYPE_NETWORK)
                  {
                     _loc2_.setBattleDebuff(_loc5_);
                  }
                  break;
               case BattleData.SKILL_359:
                  _loc2_.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(305));
                  if(Battle.type == TYPE_NETWORK)
                  {
                     _loc2_.setBattleDebuff(_loc5_);
                  }
                  break;
               case BattleData.SKILL_336:
                  _loc6_ = int(_loc5_.damageCp);
                  _loc2_.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(349) + String(_loc6_));
                  attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(350) + String(_loc6_));
                  if(Battle.type == TYPE_NETWORK)
                  {
                     _loc2_.updateCP(0 - _loc6_);
                     attacker.updateCP(_loc6_);
                  }
                  break;
               case BattleData.EFFECT_PET_BURN:
                  _loc2_.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(288));
                  if(Battle.type == TYPE_NETWORK)
                  {
                     _loc2_.setBattleDebuff(_loc5_);
                  }
                  break;
               case BattleData.EFFECT_PET_WEAKEN:
                  _loc2_.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(801));
                  if(Battle.type == TYPE_NETWORK)
                  {
                     _loc2_.setBattleDebuff(_loc5_);
                  }
                  break;
               case BattleData.EFFECT_COOLDOWN_REDUCTION:
                  _loc2_.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(598));
                  if(Battle.type == TYPE_NETWORK)
                  {
                     _loc2_.reduceSkillCooldown(_loc5_.amount,BattleData.REDUCETYPE_SKILL);
                  }
                  break;
               case BattleData.EFFECT_DODGE_BONUS_N_CD_REDUCTION:
                  _loc2_.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(306));
                  _loc2_.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(598));
                  if(Battle.type == TYPE_NETWORK)
                  {
                     _loc2_.reduceSkillCooldown(_loc5_.duration,BattleData.REDUCETYPE_SKILL);
                  }
                  break;
               case BattleData.EFFECT_DRAIN_HP_CP:
                  if(Battle.type == TYPE_NETWORK)
                  {
                     break;
                  }
                  _loc7_ = int(_loc5_.damageHp);
                  _loc2_.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(482) + String(_loc7_));
                  attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(483) + String(_loc7_));
                  _loc6_ = int(_loc5_.damageCp);
                  _loc2_.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(349) + String(_loc6_));
                  attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(350) + String(_loc6_));
                  break;
               case BattleData.EFFECT_DRAIN_HP_N_ACCURACY:
                  _loc7_ = int(_loc5_.damageHp);
                  attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(685).replace("[valamt]",Math.round(_loc5_.amount).toString()));
                  _loc2_.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(287));
                  if(Battle.type != TYPE_NETWORK)
                  {
                     _loc2_.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(482) + String(_loc7_));
                     attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(483) + String(_loc7_));
                  }
                  if(Battle.type == TYPE_NETWORK)
                  {
                     attacker.setBattleBuff({
                        "type":BattleData.EFFECT_ACCURATE,
                        "duration":_loc5_.duration,
                        "amount":_loc5_.amount * 2.5
                     });
                     _loc2_.setBattleDebuff({
                        "type":BattleData.EFFECT_BLIND,
                        "duration":_loc5_.duration,
                        "amount":_loc5_.amount * 2.5
                     });
                  }
                  break;
               case BattleData.EFFECT_BURN_CP_CLEAR_BUFF:
                  _loc2_.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(1366));
                  _loc2_.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(877));
                  if(Battle.type == TYPE_NETWORK)
                  {
                     _loc2_.clearBuff();
                     _loc2_.clearAllDebuff();
                  }
                  break;
               case BattleData.EFFECT_CLEARBUFF_INTERNAL_INJURY_CHAOS:
               case BattleData.EFFECT_CLEAR_BUFF_N_INTERNAL_INJURY:
                  _loc2_.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(1366));
                  _loc2_.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(877));
                  if(Battle.type == TYPE_NETWORK)
                  {
                     _loc2_.clearBuff();
                     _loc2_.clearAllDebuff();
                  }
                  break;
               case BattleData.EFFECT_BURN_HP_FIX_NUM:
               case BattleData.EFFECT_BURN_HP:
                  if(Battle.type == TYPE_NETWORK)
                  {
                     _loc2_.showOverheadNumber(Timeline.WORD,Central.main.langLib.titleTxt(TitleData.HP) + String("-" + _loc3_.effect.damageHp));
                     _loc2_.updateHP(0 - int(_loc3_.effect.damageHp));
                  }
                  break;
               case BattleData.EFFECT_BURN_HP_CLEAR_BUFF:
                  _loc2_.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(877));
                  if(Battle.type == TYPE_NETWORK)
                  {
                     _loc2_.clearBuff();
                  }
                  break;
               case BattleData.EFFECT_CLEARBUFF_DODGEREDUCTION:
                  _loc2_.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(877));
                  _loc2_.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(799));
                  if(Battle.type == TYPE_NETWORK)
                  {
                     _loc2_.clearBuff();
                  }
                  break;
               case BattleData.EFFECT_BURN_CP_CLEAR_BUFF_WEAK:
                  _loc2_.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(877));
                  for each(_loc24_ in _loc3_.removedEffectList)
                  {
                     if(_loc2_.getData(DBCharacterData.ID) == _loc24_.targetId)
                     {
                        _loc25_ = _loc24_.type;
                        _loc2_.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(1809).replace("[valeffecttype]",EffectLangData.getEffectNameByType(_loc25_)));
                        if(Battle.type == TYPE_NETWORK)
                        {
                           _loc2_.removeBuff(_loc25_);
                           _loc2_.removeDebuff(_loc25_);
                        }
                     }
                  }
                  break;
               case BattleData.EFFECT_CLEAR_SELF_DEBUFF_DEFENDER_BUFF:
                  _loc2_.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(877));
                  attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(1366));
                  if(Battle.type == TYPE_NETWORK)
                  {
                     _loc2_.clearBuff();
                     attacker.clearAllDebuff();
                  }
                  break;
               case BattleData.EFFECT_SKILL_884:
                  if(Battle.type == TYPE_NETWORK)
                  {
                     attacker.clearAllDebuff();
                  }
                  break;
               case BattleData.EFFECT_FINAL_ATTACK:
                  attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(2001)[3]);
                  if(Battle.type == TYPE_NETWORK)
                  {
                     attacker.clearAllDebuff();
                  }
                  break;
               case BattleData.EFFECT_CLEARBUFF:
               case BattleData.EFFECT_CLEARBUFF_STUN:
                  _loc2_.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(1366));
                  _loc2_.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(877));
                  if(Battle.type == TYPE_NETWORK)
                  {
                     _loc2_.clearBuff();
                  }
                  break;
               case BattleData.EFFECT_HALFHP_DAMAGE_REDUCTION:
                  _loc2_.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(748));
                  break;
               case BattleData.EFFECT_HEAL_MEMBER:
                  _loc6_ = int(_loc5_.cpDisplay);
                  _loc23_ = int(_loc5_.regenCP);
                  _loc2_.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(350) + String(_loc23_));
                  attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(349) + String(_loc6_));
                  defender.updateCP(_loc23_);
                  break;
               case BattleData.EFFECT_INTERNAL_INJURY_BLEEDING:
                  _loc2_.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(286) + "(" + String(_loc5_.amount) + "%)");
                  _loc2_.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(648));
                  break;
               case BattleData.EFFECT_DRAIN_HP_CP_N_ADD_COOLDOWN:
                  if(Battle.type == TYPE_NETWORK)
                  {
                     break;
                  }
                  _loc7_ = int(_loc5_.damageHp);
                  _loc2_.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(482) + String(_loc7_));
                  attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(483) + String(_loc7_));
                  _loc6_ = int(_loc5_.damageCp);
                  _loc2_.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(349) + String(_loc6_));
                  attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(350) + String(_loc6_));
                  break;
               case BattleData.EFFECT_CHAOS_N_BURN:
                  if(Battle.type == TYPE_NETWORK)
                  {
                     _loc2_.showOverheadNumber(Timeline.WORD,String(Main.langLib.get(734)));
                  }
                  break;
               case BattleData.EFFECT_CHAOS_N_BLEEDING:
                  if(Battle.type == TYPE_NETWORK)
                  {
                     _loc2_.showOverheadNumber(Timeline.WORD,String(Main.langLib.get(734)));
                  }
                  break;
               case BattleData.EFFECT_COLLIDING_WAVE:
                  Out.debug(null,"Battle::processDamage, EFFECT_COLLIDING_WAVE, target=" + _loc3_.target);
                  _loc2_.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(619));
                  if(Battle.type == TYPE_NETWORK)
                  {
                     _loc2_.setBattleDebuff(_loc3_.effect);
                  }
            }
         }
         else if(_loc3_.effect != null && checkResisted(_loc3_.effect.resisted,_loc2_) == true)
         {
            _loc2_.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(484));
         }
         if(_loc2_.getBackItem())
         {
            _loc26_ = Central.main.BACK_ITEM_DATA.find(_loc2_.getBackItem());
            if(_loc26_)
            {
               for each(_loc27_ in _loc26_.effect)
               {
                  switch(_loc27_.type)
                  {
                     case BattleData.EFFECT_ATTACKER_FREEZE:
                        if(_loc3_.backitem_activated)
                        {
                           attacker.showOverheadNumber(Timeline.WORD,String(Central.main.langLib.get(820)));
                           _loc3_.backitem_activated = false;
                        }
                        break;
                     case BattleData.EFFECT_ATTACKER_STUN:
                        if(_loc3_.backitem_activated)
                        {
                           attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(331));
                           _loc3_.backitem_activated = false;
                        }
                        break;
                     case BattleData.EFFECT_DEFENDER_STUN:
                        if(_loc3_.backitem_activated)
                        {
                           attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(331));
                           _loc3_.backitem_activated = false;
                        }
                  }
               }
            }
         }
         if(attacker.getWeapon())
         {
            _loc8_ = Central.main.WEAPON_DATA.find(attacker.getWeapon());
            if(_loc8_)
            {
               for each(_loc18_ in _loc8_.effect)
               {
                  switch(_loc18_.type)
                  {
                     case BattleData.EFFECT_WEAPON_EXPLODE:
                        if(_loc3_.action == "weapon_attack")
                        {
                           if(_loc3_.candoburn == true || _loc3_.canburn == true || _loc3_.canburnnum == true || _loc3_.canburning == true || _loc3_.canpetburn == true || _loc3_.cancntpurlfyburn == true)
                           {
                              _loc2_.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(2046));
                           }
                        }
                        break;
                     case BattleData.EFFECT_WEAPON_DISMANTLE:
                        if(_loc3_.action == "weapon_attack")
                        {
                           defender.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(817));
                        }
                  }
               }
            }
         }
         if(Battle.type == TYPE_NETWORK && _loc3_.action == "weapon_attack")
         {
            if(attacker.getWeapon())
            {
               _loc8_ = Central.main.WEAPON_DATA.find(attacker.getWeapon());
               if(_loc8_)
               {
                  for each(_loc18_ in _loc8_.effect)
                  {
                     switch(_loc18_.type)
                     {
                        case "attack_reduce_cooldown.0":
                           _loc28_ = _loc18_.type.split(".");
                           if(Battle.type == TYPE_NETWORK)
                           {
                              attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(598));
                              switch(_loc28_[1])
                              {
                                 case "0":
                                    attacker.reduceSkillCooldown(_loc18_.amount,BattleData.REDUCETYPE_ALL);
                                    break;
                                 case "1":
                                    if(_loc28_[2] == null)
                                    {
                                       break;
                                    }
                                    _loc29_ = "";
                                    switch(_loc28_[2])
                                    {
                                       case "0":
                                          _loc29_ = SkillData.TYPE_FIRE;
                                          break;
                                       case "1":
                                          _loc29_ = SkillData.TYPE_WIND;
                                          break;
                                       case "2":
                                          _loc29_ = SkillData.TYPE_LIGHTNING;
                                          break;
                                       case "3":
                                          _loc29_ = SkillData.TYPE_WATER;
                                          break;
                                       case "4":
                                          _loc29_ = SkillData.TYPE_EARTH;
                                          break;
                                       case "5":
                                          _loc29_ = SkillData.TYPE_TAIJUTSU;
                                          break;
                                       case "6":
                                          _loc29_ = SkillData.TYPE_GENJUTSU;
                                    }
                                    attacker.reduceSkillCooldown(_loc18_.amount,BattleData.REDUCETYPE_SKILL,_loc29_);
                                    break;
                                 case "2":
                                    attacker.reduceSkillCooldown(_loc18_.amount,BattleData.REDUCETYPE_TALENT);
                              }
                           }
                     }
                  }
               }
            }
         }
         if(param1.defenderRestoreHp > 0)
         {
            _loc2_.showOverheadNumber(Timeline.HEAL,"+" + param1.defenderRestoreHp + Central.main.langLib.titleTxt(TitleData.HP));
            if(Battle.type == TYPE_NETWORK)
            {
               _loc2_.updateHP(param1.defenderRestoreHp);
            }
         }
         if(param1.defenderRestoreCp > 0)
         {
            _loc2_.showOverheadNumber(Timeline.WORD,"+" + param1.defenderRestoreCp + Central.main.langLib.titleTxt(TitleData.CP));
            if(Battle.type == TYPE_NETWORK)
            {
               _loc2_.updateCP(param1.defenderRestoreCp);
            }
         }
         if(param1.defenderDamageCp < 0)
         {
            _loc2_.showOverheadNumber(Timeline.WORD,param1.defenderDamageCp + Central.main.langLib.titleTxt(TitleData.CP));
            if(Battle.type == TYPE_NETWORK)
            {
               _loc2_.updateCP(param1.defenderDamageCp);
            }
         }
         if(param1.defenderDamageHp < 0)
         {
            _loc2_.showOverheadNumber(Timeline.WORD,param1.defenderDamageHp + Central.main.langLib.titleTxt(TitleData.HP));
            if(Battle.type == TYPE_NETWORK)
            {
               _loc2_.updateHP(param1.defenderDamageHp);
            }
         }
         if(param1.defenderDamageSp < 0)
         {
            _loc2_.showOverheadNumber(Timeline.WORD,param1.defenderDamageSp + Central.main.langLib.titleTxt(TitleData.SP));
            if(Battle.type == TYPE_NETWORK)
            {
               _loc2_.updateSP(param1.defenderDamageSp);
            }
         }
         if(_loc3_.defenderRestoreHp != null)
         {
            if(_loc3_.defenderRestoreHp > 0)
            {
               defender.showOverheadNumber(Timeline.WORD,"+" + _loc3_.defenderRestoreHp + Central.main.langLib.titleTxt(TitleData.HP));
               if(Battle.type == TYPE_NETWORK)
               {
                  defender.updateHP(_loc3_.defenderRestoreHp);
               }
            }
         }
         if(_loc3_.defenderRestoreCp != null)
         {
            if(_loc3_.defenderRestoreCp > 0)
            {
               defender.showOverheadNumber(Timeline.WORD,"+" + _loc3_.defenderRestoreCp + Central.main.langLib.titleTxt(TitleData.CP));
               if(Battle.type == TYPE_NETWORK)
               {
                  defender.updateHP(_loc3_.defenderRestoreCp);
               }
            }
         }
         if(_loc3_.defenderDamageCp != null)
         {
            if(_loc3_.defenderDamageCp < 0)
            {
               defender.showOverheadNumber(Timeline.WORD,_loc3_.defenderDamageCp + Central.main.langLib.titleTxt(TitleData.CP));
               if(Battle.type == TYPE_NETWORK)
               {
                  defender.updateCP(_loc3_.defenderDamageCp);
               }
            }
         }
         if(_loc3_.defenderDamageHp != null)
         {
            if(_loc3_.defenderDamageHp < 0)
            {
               defender.showOverheadNumber(Timeline.WORD,_loc3_.defenderDamageHp + Central.main.langLib.titleTxt(TitleData.HP));
               if(Battle.type == TYPE_NETWORK)
               {
                  defender.updateHP(_loc3_.defenderDamageHp);
               }
            }
         }
         if(_loc3_.defenderDamageSp != null)
         {
            if(_loc3_.defenderDamageSp < 0)
            {
               defender.showOverheadNumber(Timeline.WORD,_loc3_.defenderDamageSp + Central.main.langLib.titleTxt(TitleData.SP));
               if(Battle.type == TYPE_NETWORK)
               {
                  defender.updateSP(_loc3_.defenderDamageSp);
               }
            }
            Out.debug("","2015-7-13 sucees show word defender damage sp");
         }
         if(_loc3_.selfhit != null)
         {
            _loc30_ = false;
            _loc31_ = 0;
            if(_loc3_.skillId != null)
            {
               _loc31_ = int(_loc3_.skillId);
               _loc10_ = Central.main.SKILL_DATA[_loc3_.skillId];
               if(_loc10_ != null && _loc10_.effect.type == BattleData.EFFECT_HEAL_MEMBER)
               {
                  _loc30_ = true;
               }
            }
            if(_loc30_)
            {
               attacker.showOverheadNumber(Timeline.WORD,"-" + _loc3_.selfhit + Central.main.langLib.titleTxt(TitleData.HP));
            }
            else
            {
               attacker.showOverheadNumber(Timeline.WORD,String(Central.main.langLib.get(333)).replace("[valamt]",_loc3_.selfhit));
            }
            if(Battle.type == TYPE_NETWORK)
            {
               attacker.updateHP(0 - _loc3_.selfhit);
            }
         }
         if(Boolean(_loc3_.clones) && Boolean(_loc3_.clones != null) && Boolean(_loc3_.clones[_loc2_.getCharacterId()]))
         {
            _loc32_ = Battle.type == TYPE_LOCAL ? _loc3_.clones[_loc2_.getCharacterId()].effectName : _loc3_.clones[_loc2_.getCharacterId()];
            switch(_loc32_)
            {
               case BattleData.TYPE_DUMMY:
                  _loc2_.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(2030) + "(-1)");
                  playAction(_loc2_,BattleData.DUMMY);
                  break;
               case BattleData.TYPE_DUMMY_BURN:
                  _loc2_.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(2030) + "(-1)");
                  playAction(_loc2_,BattleData.DUMMY_BURN);
                  break;
               case BattleData.TYPE_DUMMY_STUN:
                  _loc2_.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(2030) + "(-1)");
                  playAction(_loc2_,BattleData.DUMMY_STUN);
            }
         }
         if(param1.dmg == null)
         {
            return;
         }
         _loc11_ = int(param1.dmg);
         _loc12_ = _loc2_.getBattleBuff();
         _loc13_ = _loc2_.getBattleDebuff();
         for(_loc9_ in _loc12_)
         {
            if(!_loc12_[_loc9_])
            {
               continue;
            }
            if(int(_loc12_[_loc9_].duration) <= 0)
            {
               continue;
            }
            switch(_loc9_)
            {
               case BattleData.SKILL_285:
                  _loc2_.showOverheadNumber(Timeline.WORD,String(Central.main.langLib.get(1355)));
                  if(Battle.type == TYPE_NETWORK)
                  {
                     _loc2_.reduceSkillCooldown(_loc12_[_loc9_].amount,BattleData.REDUCETYPE_SKILL,SkillData.TYPE_WIND);
                  }
                  break;
               case BattleData.EFFECT_DISORIENTED_BURN_HP:
                  attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(891));
                  if(Battle.type == TYPE_NETWORK)
                  {
                  }
            }
         }
         for(_loc9_ in _loc13_)
         {
            if(!_loc13_[_loc9_])
            {
               continue;
            }
            if(int(_loc13_[_loc9_].duration) <= 0)
            {
               continue;
            }
            switch(_loc9_)
            {
               case BattleData.EFFECT_STUN:
                  if(_loc3_.effect != null && checkResisted(_loc3_.effect.resisted,_loc2_) == false)
                  {
                     _loc5_ = _loc3_.effect;
                     switch(_loc5_.type)
                     {
                        case BattleData.EFFECT_STUN_RANDOM:
                           _loc2_.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(281));
                     }
                  }
            }
         }
         var _loc14_:int = 0;
         var _loc15_:int = 0;
         _loc10_ = Main.SKILL_DATA[_loc3_.skillId];
         _loc16_ = [];
         _loc17_ = [];
         _loc18_ = {};
         _loc19_ = "";
         if(_loc3_.EFFECT_REACTIVE_DEBUFF_DEFENDER)
         {
            _loc16_ = _loc3_.EFFECT_REACTIVE_DEBUFF_DEFENDER;
            _loc21_ = 0;
            while(_loc21_ < _loc16_.length)
            {
               _loc18_ = {};
               _loc19_ = "";
               _loc20_ = "";
               _loc18_ = _loc16_[_loc21_].Effect;
               _loc19_ = _loc16_[_loc21_].BLSkillID;
               _loc20_ = _loc16_[_loc21_].charId;
               if(_loc20_ == _loc2_.getData(DBCharacterData.ID) || _loc20_ == attacker.getCharacterId())
               {
                  showBloodlineEffect(_loc18_,_loc19_,_loc3_,_loc2_);
               }
               _loc21_++;
            }
            _loc3_.EFFECT_REACTIVE_DEBUFF_DEFENDER = null;
         }
         if(_loc3_.EFFECT_REACTIVE_DEBUFF_ATTACKER)
         {
            _loc17_ = _loc3_.EFFECT_REACTIVE_DEBUFF_ATTACKER;
            _loc21_ = 0;
            while(_loc21_ < _loc17_.length)
            {
               _loc18_ = {};
               _loc19_ = "";
               _loc20_ = "";
               _loc18_ = _loc17_[_loc21_].Effect;
               _loc19_ = _loc17_[_loc21_].BLSkillID;
               _loc20_ = _loc17_[_loc21_].charId;
               if(_loc20_ == _loc2_.getData(DBCharacterData.ID) || _loc20_ == attacker.getCharacterId())
               {
                  showBloodlineEffect(_loc18_,_loc19_,_loc3_,_loc2_);
               }
               _loc21_++;
            }
            _loc3_.EFFECT_REACTIVE_DEBUFF_ATTACKER = null;
         }
         if(_loc3_.critical)
         {
            _loc2_.showOverheadNumber(Timeline.CRITICAL,Math.abs(_loc11_));
         }
         else
         {
            _loc2_.showOverheadNumber(Timeline.NORMAL,Math.abs(_loc11_));
         }
         if(Boolean(_loc3_.clones) && Boolean(_loc3_.clones != null) && Boolean(_loc3_.clones[_loc2_.getCharacterId()]))
         {
            if(Battle.type == TYPE_LOCAL)
            {
               --_loc2_.getBattleBuff()[_loc3_.clones[_loc2_.getCharacterId()].buffName].remainClones;
               if(_loc2_.getBattleBuff()[_loc3_.clones[_loc2_.getCharacterId()].buffName].remainClones == 0)
               {
                  trace("target.getBattleBuff()[battleAction.clones[target.getCharacterId()].buffName] = " + GF.printObject(_loc2_.getBattleBuff()[_loc3_.clones[_loc2_.getCharacterId()].buffName]));
                  _loc2_.getBattleBuff()[_loc3_.clones[_loc2_.getCharacterId()].buffName] = null;
               }
            }
         }
         else
         {
            if(Boolean(_loc2_.limb) && _loc2_.limb > 1)
            {
               playHit(getCharacterById(int(_loc2_.getCharacterId() / 10) * 10 + 1));
            }
            else
            {
               playHit(_loc2_);
            }
            if(Battle.type == TYPE_NETWORK)
            {
               if(param1.defenderRestoreHp > 0 && Math.abs(_loc11_) > _loc2_.hp)
               {
                  _loc11_ = -(_loc2_.hp - param1.defenderRestoreHp);
               }
               _loc2_.updateHP(_loc11_);
            }
         }
         if(int(_loc3_.hitNum) > 1 && Battle.type == TYPE_LOCAL)
         {
            _loc33_ = 99;
            if(_loc3_.action == BattleData.ACTION_SKILL)
            {
               _loc10_ = Main.SKILL_DATA[_loc3_.skillId];
               if(_loc10_.skill_hit_num > 0)
               {
                  _loc33_ = int(_loc10_.skill_hit_num);
               }
            }
            Out.debug("Battle","battleAction.hitNum >> " + _loc3_.hitNum + " :: maxHit >> " + _loc33_);
            if(int(_loc3_.hitNum) <= _loc33_)
            {
               _loc2_.updateHP(_loc11_);
            }
         }
         if(Battle.type == TYPE_LOCAL)
         {
            if(_loc3_.rebound == true)
            {
               attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(751));
               attacker.updateBattleFrame();
            }
         }
         else if(Battle.type == TYPE_NETWORK)
         {
            if(_loc3_.rebound)
            {
               if(_loc3_.rebound.length > 0)
               {
                  _loc34_ = 0;
                  while(_loc34_ < _loc3_.rebound.length)
                  {
                     _loc35_ = int(_loc3_.rebound[_loc34_].damage);
                     if(_loc2_.getData(DBCharacterData.ID) == _loc3_.rebound[_loc34_].charId)
                     {
                        attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(751));
                        attacker.updateHP(_loc35_);
                        attacker.updateBattleFrame();
                     }
                     _loc34_++;
                  }
               }
            }
         }
         if(!Central.main.isNewChar)
         {
            if(_loc2_.hp <= 0 && attacker.getCharacterId() == Main.getMainChar().getCharacterId())
            {
               Main.achievement.updateBattleStat(Main.achievementData.ENEMY_KILLED,1);
            }
         }
         _loc22_ = _loc3_.reactiveEffect;
         if(_loc22_ != null)
         {
            if(checkResisted(_loc22_.resisted,attacker) == false)
            {
               switch(_loc22_.type)
               {
                  case BattleData.EFFECT_STUN:
                     attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(331));
                     break;
                  case BattleData.EFFECT_SLEEP:
                     attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(280));
                     break;
                  case BattleData.EFFECT_BUNDLE:
                     attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(325));
                     break;
                  case BattleData.EFFECT_MERIDIANS_SEAL:
                     attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(527));
               }
               if(Battle.type == TYPE_NETWORK)
               {
                  attacker.setBattleDebuff(_loc22_);
               }
            }
            else
            {
               attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(484));
            }
            if(Battle.type == TYPE_NETWORK)
            {
               _loc2_.removeBuff(BattleData.EFFECT_REACTIVE_DEBUFF);
            }
         }
         if(_loc3_.titan == true || _loc3_.titanc == true)
         {
            _loc36_ = null;
            _loc37_ = null;
            if(attacker.charMc.x < _loc2_.charMc.x)
            {
               _loc36_ = new Point(_loc2_.charMc.x - PositionType.RANGE_2_OFFSET * Data.BATTLE_CHAR_SCALE,_loc2_.charMc.y);
               _loc37_ = new Point(defender.charMc.x - defender.getHitArea().width * Data.BATTLE_CHAR_SCALE - attacker.getHitArea().width * Data.BATTLE_CHAR_SCALE,defender.charMc.y);
            }
            else
            {
               _loc36_ = new Point(_loc2_.charMc.x + _loc2_.getHitArea().width * Data.BATTLE_CHAR_SCALE * 3,_loc2_.charMc.y);
               _loc37_ = new Point(defender.charMc.x + defender.getHitArea().width * Data.BATTLE_CHAR_SCALE + attacker.getHitArea().width * Data.BATTLE_CHAR_SCALE,defender.charMc.y);
            }
            _loc3_.TitanattackPoint = _loc36_;
            _loc3_.TitanattackPointc = _loc37_;
            attacker.setBattleAction(_loc3_);
         }
         _loc2_.updateBattleFrame();
      }
      
      private static function damageTarget() : void
      {
         var _loc1_:Object = null;
         var _loc2_:Array = null;
         var _loc3_:Object = null;
         var _loc4_:uint = 0;
         var _loc5_:int = 0;
         var _loc6_:String = null;
         var _loc7_:int = 0;
         _loc1_ = attacker.getBattleAction();
         _loc2_ = _loc1_.dmgArr;
         _loc4_ = 0;
         while(_loc4_ < _loc2_.length)
         {
            processDamage(_loc2_[_loc4_]);
            _loc4_++;
         }
         if(_loc1_.feedback)
         {
            if(_loc1_.feedback.length > 0)
            {
               _loc5_ = 0;
               while(_loc5_ < _loc1_.feedback.length)
               {
                  _loc6_ = _loc1_.feedback[_loc5_].type;
                  _loc7_ = int(_loc1_.feedback[_loc5_].damage);
                  if(_loc1_.feedback[_loc5_].resisted)
                  {
                     attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(484));
                  }
                  switch(_loc6_)
                  {
                     case BattleData.EFFECT_REACTIVE_FORCE:
                        attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(533));
                        attacker.showOverheadNumber(Timeline.WORD,"-" + _loc7_ + Central.main.langLib.titleTxt(TitleData.HP));
                        break;
                     case BattleData.EFFECT_BERSERKER_MODE:
                        attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(599));
                        attacker.showOverheadNumber(Timeline.WORD,"-" + _loc7_ + Central.main.langLib.titleTxt(TitleData.HP));
                        break;
                     case BloodlineData.EFFECT_PASSIVE_STUN:
                        attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(1870));
                        break;
                     case BloodlineData.EFFECT_CPDMG:
                        attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(1869) + " -" + _loc7_ + "HP");
                        break;
                     case BloodlineData.EFFECT_CPDMG_STUN:
                        attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(1870));
                  }
                  _loc5_++;
               }
            }
         }
         else if(_loc1_.feed == true)
         {
            attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(533));
         }
         if(_loc1_.effect)
         {
            switch(_loc1_.effect.type)
            {
               case BattleData.EFFECT_MODIFY_COOLDOWN:
               case BattleData.EFFECT_MODIFY_COOLDOWN_BLIND:
               case BattleData.EFFECT_MODIFY_COOLDOWN_BLIND_A:
               case BattleData.EFFECT_MDF_CD_N_ADD_ATTENTION:
                  if(Battle.type == TYPE_NETWORK)
                  {
                     addSkillCoolDown(_loc1_.effect,_loc1_);
                     if(_loc1_.effect.skillCooldown)
                     {
                        attacker.battleSkillCooldown[_loc1_.skillId] = _loc1_.effect.skillCooldown;
                     }
                  }
            }
         }
         if(_loc1_.effect)
         {
            _loc3_ = _loc1_.effect;
            switch(_loc1_.effect.type)
            {
               case BattleData.EFFECT_DAMAGE_BONUS_FIX_NUM_THANOS:
                  attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(2059));
                  if(Battle.type == TYPE_NETWORK)
                  {
                     attacker.setBattleBuff(_loc3_);
                     if(_loc1_.effect.extraextraEffect == true)
                     {
                        attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(622));
                        _loc1_.effect.extraextraEffect == false;
                     }
                  }
            }
         }
         if(_loc1_.attackerRestoreHp != null)
         {
            if(_loc1_.attackerRestoreHp > 0 && _loc1_.nosee != true)
            {
               attacker.showOverheadNumber(Timeline.HEAL,"+" + _loc1_.attackerRestoreHp + Central.main.langLib.titleTxt(TitleData.HP));
               if(Battle.type == TYPE_NETWORK)
               {
                  attacker.updateHP(_loc1_.attackerRestoreHp);
               }
            }
            else
            {
               _loc1_.nosee = false;
            }
         }
         if(_loc1_.attackerRestoreCp != null)
         {
            if(_loc1_.attackerRestoreCp > 0)
            {
               trace("11111111111111111111111111111111111111111111111111111119999");
               attacker.showOverheadNumber(Timeline.WORD,"+" + _loc1_.attackerRestoreCp + Central.main.langLib.titleTxt(TitleData.CP));
               if(Battle.type == TYPE_NETWORK)
               {
                  attacker.updateCP(_loc1_.attackerRestoreCp);
               }
            }
         }
         if(_loc1_.fdRestoreCp != null)
         {
            if(_loc1_.fdRestoreCp > 0)
            {
               if(Battle.type == TYPE_NETWORK)
               {
                  _loc5_ = 0;
                  while(_loc5_ < characterArr.length)
                  {
                     if(characterArr[_loc5_].side == attacker.side)
                     {
                        characterArr[_loc5_].showOverheadNumber(Timeline.WORD,"+" + _loc1_.fdRestoreCp + Central.main.langLib.titleTxt(TitleData.CP));
                        characterArr[_loc5_].updateCP(_loc1_.fdRestoreCp);
                     }
                     _loc5_++;
                  }
               }
            }
         }
         if(_loc1_.attackerRestoreSp != null)
         {
            if(_loc1_.attackerRestoreSp > 0)
            {
               attacker.showOverheadNumber(Timeline.WORD,"+" + _loc1_.attackerRestoreSp + Central.main.langLib.titleTxt(TitleData.SP));
               if(Battle.type == TYPE_NETWORK)
               {
                  attacker.updateSP(_loc1_.attackerRestoreSp);
               }
            }
         }
         if(_loc1_.attackerDamageHp != null)
         {
            if(_loc1_.attackerDamageHp < 0)
            {
               attacker.showOverheadNumber(Timeline.WORD,_loc1_.attackerDamageHp + Central.main.langLib.titleTxt(TitleData.HP));
               if(Battle.type == TYPE_NETWORK)
               {
                  attacker.updateHP(_loc1_.attackerDamageHp);
               }
            }
         }
         if(_loc1_.attackerDamageCp != null)
         {
            if(_loc1_.attackerDamageCp < 0)
            {
               attacker.showOverheadNumber(Timeline.WORD,_loc1_.attackerDamageCp + Central.main.langLib.titleTxt(TitleData.CP));
               if(Battle.type == TYPE_NETWORK)
               {
                  attacker.updateCP(_loc1_.attackerDamageCp);
               }
            }
         }
         if(_loc1_.attackerDamageSp != null)
         {
            if(_loc1_.attackerDamageSp < 0)
            {
               attacker.showOverheadNumber(Timeline.WORD,_loc1_.attackerDamageSp + Central.main.langLib.titleTxt(TitleData.SP));
               if(Battle.type == TYPE_NETWORK)
               {
                  attacker.updateSP(0 - _loc1_.attackerDamageSp);
               }
            }
         }
         if(Battle.type == TYPE_NETWORK)
         {
            _loc1_.effect = null;
            _loc1_.feedback = null;
         }
         attacker.updateBattleFrame();
      }
      
      public static function healTarget() : void
      {
         var _loc1_:Object = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:Object = null;
         var _loc5_:* = undefined;
         _loc1_ = attacker.getBattleAction();
         if(_loc1_.healTarget)
         {
            _loc2_ = 0;
            while(_loc2_ < _loc1_.healTarget.length)
            {
               _loc4_ = _loc1_.healTarget[_loc2_];
               if(Battle.type == TYPE_NETWORK)
               {
                  _loc5_ = getCharacterById(_loc4_.target);
                  _loc5_.updateHP(_loc4_.heal);
                  _loc5_.updateBattleFrame();
                  _loc5_.showOverheadNumber(Timeline.HEAL,_loc4_.heal);
               }
               else
               {
                  _loc4_.target.updateBattleFrame();
                  _loc4_.target.showOverheadNumber(Timeline.HEAL,_loc4_.heal);
               }
               _loc2_++;
            }
            return;
         }
         if(_loc1_.heal == null)
         {
            return;
         }
         _loc3_ = int(_loc1_.heal);
         if(_loc1_.target)
         {
            switch(_loc1_.target)
            {
               case "self":
                  defender = attacker;
            }
         }
         if(Battle.type == TYPE_NETWORK)
         {
            defender.updateHP(_loc3_);
         }
         defender.updateBattleFrame();
         sethealThreat(_loc3_);
         if(_loc1_.critical)
         {
            defender.showOverheadNumber(Timeline.HEAL,_loc3_);
         }
         else
         {
            defender.showOverheadNumber(Timeline.HEAL,_loc3_);
         }
      }
      
      public static function setdamageThreat(param1:int, param2:Object) : void
      {
         defender.setThreat(attacker,param1,0,param2);
      }
      
      public static function sethealThreat(param1:int) : void
      {
         var _loc2_:int = 0;
         _loc2_ = 0;
         while(_loc2_ < enemyArr.length)
         {
            enemyArr[_loc2_].setThreat(attacker,0,param1);
            _loc2_++;
         }
      }
      
      public static function setchargeThreat() : void
      {
         var _loc1_:int = 0;
         _loc1_ = 0;
         while(_loc1_ < enemyArr.length)
         {
            enemyArr[_loc1_].setThreat(attacker,0,0,null,"CHARGE");
            _loc1_++;
         }
      }
      
      public static function setbuffThreat(param1:Object = null) : void
      {
         var _loc2_:int = 0;
         _loc2_ = 0;
         while(_loc2_ < enemyArr.length)
         {
            enemyArr[_loc2_].setThreat(attacker,0,0,null,"BUFF");
            _loc2_++;
         }
      }
      
      public static function setDebuffThreat(param1:Object = null) : void
      {
         defender.setThreat(attacker,0,0,null,"DEBUFF");
      }
      
      private static function playExtraAttack() : Boolean
      {
         var _loc1_:Object = null;
         var _loc2_:Object = null;
         var _loc3_:Object = null;
         var _loc4_:Object = null;
         var _loc5_:Array = null;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:Object = null;
         var _loc11_:Object = null;
         var _loc12_:Object = null;
         var _loc13_:Object = null;
         var _loc14_:Object = null;
         var _loc15_:Object = null;
         var _loc16_:Point = null;
         var _loc17_:Object = null;
         var _loc18_:Object = null;
         var _loc19_:Object = null;
         var _loc20_:Object = null;
         var _loc21_:Object = null;
         var _loc22_:Point = null;
         var _loc23_:Object = null;
         var _loc24_:Object = null;
         var _loc25_:Object = null;
         var _loc26_:Object = null;
         var _loc27_:Object = null;
         var _loc28_:Point = null;
         var _loc29_:Object = null;
         var _loc30_:Object = null;
         var _loc31_:Object = null;
         var _loc32_:Object = null;
         var _loc33_:Object = null;
         var _loc34_:Point = null;
         var _loc35_:Object = null;
         var _loc36_:Object = null;
         var _loc37_:Object = null;
         var _loc38_:Object = null;
         var _loc39_:Object = null;
         var _loc40_:Object = null;
         var _loc41_:Object = null;
         var _loc42_:Object = null;
         var _loc43_:Object = null;
         var _loc44_:Object = null;
         var _loc45_:Point = null;
         var _loc46_:Object = null;
         var _loc47_:Object = null;
         _loc1_ = attacker.getBattleAction();
         if(_loc1_ == null)
         {
            return false;
         }
         Out.debug("Battle",attacker.getCharacterName() + " :: defender.hp >> " + defender.hp + " :: playExtraAttack :: .titan >> " + _loc1_.titan);
         if(_loc1_.titan == true)
         {
            attacker.isPlayingAnimation = true;
            _loc2_ = {};
            _loc3_ = Central.main.BLOODLINE_SKILL_DATA["bloodline_skill1021"];
            _loc4_ = {};
            _loc5_ = attacker.getBloodlineListArr();
            _loc6_ = 0;
            _loc7_ = 0;
            _loc8_ = 0;
            while(_loc8_ < _loc5_.length)
            {
               if(_loc5_[_loc8_].skill_id == "1021")
               {
                  _loc6_ = int(_loc5_[_loc8_].level);
                  _loc7_ = _loc8_;
               }
               _loc8_++;
            }
            _loc9_ = 0;
            while(_loc9_ < 10)
            {
               if(_loc3_.effect[_loc9_].skill_level == _loc6_)
               {
                  _loc4_ = _loc3_.effect[_loc9_];
               }
               _loc9_++;
            }
            _loc10_ = {};
            _loc10_.id = _loc3_.skill_id;
            _loc10_.dbid = String(_loc3_.skill_id).replace("skill","");
            _loc10_.name = _loc3_.name;
            _loc10_.gold = 0;
            _loc10_.crystal = 0;
            _loc10_.damage = 0 - int(_loc1_.titanDamage);
            _loc10_.rarity = _loc3_.rarity;
            _loc10_.swfName = _loc3_.swf_name;
            _loc10_.description = _loc3_.description;
            _loc10_.cp = 0;
            _loc10_.cooldown = _loc3_.cooldown;
            _loc10_.posType = _loc3_.postype;
            _loc10_.tooltip = _loc3_.tooltip;
            _loc10_.type = _loc3_.type;
            _loc10_.effect = _loc4_;
            _loc10_.level = _loc4_.skill_level;
            _loc10_.premium = _loc3_.premium;
            _loc10_.vendor = _loc3_.vendor;
            _loc10_.train_time = 0;
            _loc10_.bloodline_id = _loc3_.bloodline_id;
            _loc10_.bloodline_type = Central.main.BLOODLINE_DATA["bloodline1"].type;
            _loc11_ = {};
            if(_loc1_.titanstun == true)
            {
               _loc11_ = _loc1_.titanEffect;
            }
            else
            {
               _loc11_ = {};
            }
            _loc2_ = {
               "action":"bloodline",
               "skillId":_loc7_,
               "posType":_loc10_.posType,
               "cp":0,
               "dmg":_loc10_.damage,
               "effect":_loc11_,
               "BLSKILLID":_loc10_.id,
               "BLTYPE":_loc10_.bloodline_type
            };
            if(_loc1_.BLSKILLID)
            {
               _loc1_.BLSKILLID = null;
            }
            _loc12_ = {};
            _loc12_.characterType = defender.type;
            _loc12_.characterId = defender.getCharacterId();
            _loc12_.dmg = _loc2_.dmg;
            _loc1_.dmgArr = [_loc12_];
            Out.debug("Battle","playExtraAttack :: .dmgObj.dmg >> " + _loc12_.dmg);
            _loc1_.titan = false;
            _loc1_.effect = _loc2_.effect;
            attacker.setBattleAction(_loc1_);
            playBloodline(attacker,_loc2_,_loc1_.TitanattackPoint);
            return true;
         }
         if(_loc1_.titanc == true)
         {
            attacker.isPlayingAnimation = true;
            _loc13_ = {};
            _loc14_ = Central.main.SKILL_DATA["skill813"];
            _loc15_ = {};
            _loc16_ = null;
            _loc15_.id = _loc14_.id;
            _loc15_.name = _loc14_.name;
            _loc15_.gold = 0;
            _loc15_.crystal = 0;
            _loc15_.damage = 0 - int(_loc1_.titanDamagec);
            _loc15_.posType = _loc14_.posType;
            _loc15_.rarity = _loc14_.rarity;
            _loc15_.swfName = _loc14_.swfName;
            _loc15_.description = _loc14_.description;
            _loc15_.cp = 0;
            _loc17_ = _loc1_.titanEffectc;
            _loc13_ = {
               "action":"skill",
               "skillId":_loc15_.id,
               "posType":_loc15_.posType,
               "cp":0,
               "dmg":_loc15_.damage,
               "effect":_loc17_
            };
            _loc18_ = {};
            _loc18_.characterType = defender.type;
            _loc18_.characterId = defender.getCharacterId();
            _loc18_.dmg = _loc13_.dmg;
            _loc1_.dmgArr = [_loc18_];
            _loc1_.effect = _loc13_.effect;
            _loc1_.titanc = false;
            attacker.setBattleAction(_loc1_);
            if(attacker.charMc.x < defender.charMc.x)
            {
               _loc16_ = new Point(defender.charMc.x - defender.getHitArea().width * Data.BATTLE_CHAR_SCALE - attacker.getHitArea().width * Data.BATTLE_CHAR_SCALE,defender.charMc.y);
            }
            else
            {
               _loc16_ = new Point(defender.charMc.x + defender.getHitArea().width * Data.BATTLE_CHAR_SCALE + attacker.getHitArea().width * Data.BATTLE_CHAR_SCALE,defender.charMc.y);
            }
            attacker.updateBattleFrame();
            playSkill(attacker,_loc13_,_loc16_);
            return true;
         }
         if(_loc1_.titana == true)
         {
            attacker.isPlayingAnimation = true;
            _loc19_ = {};
            _loc20_ = Central.main.SKILL_DATA["skill814"];
            _loc21_ = {};
            _loc22_ = null;
            _loc21_.id = _loc20_.id;
            _loc21_.name = _loc20_.name;
            _loc21_.gold = 0;
            _loc21_.crystal = 0;
            _loc21_.damage = 0 - int(_loc1_.titanDamagea);
            _loc21_.posType = _loc20_.posType;
            _loc21_.rarity = _loc20_.rarity;
            _loc21_.swfName = _loc20_.swfName;
            _loc21_.description = _loc20_.description;
            _loc21_.cp = 0;
            _loc23_ = _loc1_.titanEffecta;
            _loc19_ = {
               "action":"skill",
               "skillId":_loc21_.id,
               "posType":_loc21_.posType,
               "cp":0,
               "dmg":_loc21_.damage,
               "effect":_loc23_
            };
            _loc24_ = {};
            _loc24_.characterType = defender.type;
            _loc24_.characterId = defender.getCharacterId();
            _loc24_.dmg = _loc19_.dmg;
            _loc1_.dmgArr = [_loc24_];
            _loc1_.effect = _loc19_.effect;
            _loc1_.titana = false;
            attacker.setBattleAction(_loc1_);
            if(attacker.charMc.x < defender.charMc.x)
            {
               _loc22_ = new Point(defender.charMc.x - defender.getHitArea().width * Data.BATTLE_CHAR_SCALE - attacker.getHitArea().width * Data.BATTLE_CHAR_SCALE,defender.charMc.y);
            }
            else
            {
               _loc22_ = new Point(defender.charMc.x + defender.getHitArea().width * Data.BATTLE_CHAR_SCALE + attacker.getHitArea().width * Data.BATTLE_CHAR_SCALE,defender.charMc.y);
            }
            attacker.updateBattleFrame();
            playSkill(attacker,_loc19_,_loc22_);
            return true;
         }
         if(_loc1_.titanb == true)
         {
            attacker.isPlayingAnimation = true;
            _loc25_ = {};
            _loc26_ = Central.main.SKILL_DATA["skill815"];
            _loc27_ = {};
            _loc28_ = null;
            _loc27_.id = _loc26_.id;
            _loc27_.name = _loc26_.name;
            _loc27_.gold = 0;
            _loc27_.crystal = 0;
            _loc27_.damage = 0 - int(_loc1_.titanDamageb);
            _loc27_.posType = _loc26_.posType;
            _loc27_.rarity = _loc26_.rarity;
            _loc27_.swfName = _loc26_.swfName;
            _loc27_.description = _loc26_.description;
            _loc27_.cp = 0;
            _loc29_ = {};
            _loc25_ = {
               "action":"skill",
               "skillId":_loc27_.id,
               "posType":_loc27_.posType,
               "cp":0,
               "dmg":_loc27_.damage,
               "effect":_loc29_
            };
            _loc30_ = {};
            _loc30_.characterType = defender.type;
            _loc30_.characterId = defender.getCharacterId();
            _loc30_.dmg = _loc25_.dmg;
            _loc1_.dmgArr = [_loc30_];
            _loc1_.effect = _loc25_.effect;
            _loc1_.titanb = false;
            _loc1_.defenderDamageHp = -_loc1_.titanDefenderDamageHp;
            if(Battle.type == TYPE_LOCAL)
            {
               defender.updateHP(_loc1_.defenderDamageHp);
            }
            attacker.setBattleAction(_loc1_);
            if(attacker.charMc.x < defender.charMc.x)
            {
               _loc28_ = new Point(defender.charMc.x - defender.getHitArea().width * Data.BATTLE_CHAR_SCALE - attacker.getHitArea().width * Data.BATTLE_CHAR_SCALE,defender.charMc.y);
            }
            else
            {
               _loc28_ = new Point(defender.charMc.x + defender.getHitArea().width * Data.BATTLE_CHAR_SCALE + attacker.getHitArea().width * Data.BATTLE_CHAR_SCALE,defender.charMc.y);
            }
            attacker.updateBattleFrame();
            playSkill(attacker,_loc25_,_loc28_);
            if(_loc1_.showclearbuff == true)
            {
               defender.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(877));
               defender.clearBuff();
            }
            return true;
         }
         if(_loc1_.exat == true)
         {
            attacker.isPlayingAnimation = true;
            _loc31_ = {};
            _loc32_ = Central.main.SKILL_DATA["skill5016"];
            _loc33_ = {};
            _loc34_ = null;
            _loc35_ = {};
            _loc33_.id = _loc32_.id;
            _loc33_.name = _loc32_.name;
            _loc33_.gold = 0;
            _loc33_.crystal = 0;
            _loc33_.damage = 0 - int(_loc1_.exatDamagea);
            _loc33_.posType = _loc32_.posType;
            _loc33_.rarity = _loc32_.rarity;
            _loc33_.swfName = _loc32_.swfName;
            _loc33_.description = _loc32_.description;
            _loc33_.cp = 0;
            _loc31_ = {
               "action":"skill",
               "skillId":_loc33_.id,
               "posType":_loc33_.posType,
               "cp":0,
               "dmg":_loc33_.damage,
               "effect":_loc35_,
               "target":"allEnemy"
            };
            _loc36_ = {};
            _loc36_.characterType = defender.type;
            _loc36_.characterId = defender.getCharacterId();
            _loc36_.dmg = _loc31_.dmg;
            _loc1_.dmgArr = [_loc36_];
            _loc1_.effect = _loc31_.effect;
            _loc1_.exat = false;
            attacker.setBattleAction(_loc1_);
            if(attacker.charMc.x < defender.charMc.x)
            {
               _loc34_ = new Point(defender.charMc.x - defender.getHitArea().width * Data.BATTLE_CHAR_SCALE - attacker.getHitArea().width * Data.BATTLE_CHAR_SCALE,defender.charMc.y);
            }
            else
            {
               _loc34_ = new Point(defender.charMc.x + defender.getHitArea().width * Data.BATTLE_CHAR_SCALE + attacker.getHitArea().width * Data.BATTLE_CHAR_SCALE,defender.charMc.y);
            }
            attacker.updateBattleFrame();
            playSkill(attacker,_loc31_,_loc34_);
            return true;
         }
         if(_loc1_.toad == true)
         {
            attacker.isPlayingAnimation = true;
            _loc37_ = {};
            _loc38_ = Central.main.SKILL_DATA["skill900"];
            _loc39_ = {};
            _loc39_.id = _loc38_.id;
            _loc39_.name = _loc38_.name;
            _loc39_.gold = 0;
            _loc39_.crystal = 0;
            _loc39_.damage = 0 - int(_loc1_.toadDamagea);
            _loc39_.posType = _loc38_.posType;
            _loc39_.rarity = _loc38_.rarity;
            _loc39_.swfName = _loc38_.swfName;
            _loc39_.description = _loc38_.description;
            _loc39_.cp = 0;
            _loc40_ = {};
            _loc37_ = {
               "action":"skill",
               "skillId":_loc39_.id,
               "posType":_loc39_.posType,
               "cp":0,
               "dmg":_loc39_.damage,
               "effect":_loc40_
            };
            _loc41_ = {};
            _loc41_.characterType = defender.type;
            _loc41_.characterId = defender.getCharacterId();
            _loc41_.dmg = _loc37_.dmg;
            _loc1_.dmgArr = [_loc41_];
            _loc1_.effect = _loc37_.effect;
            _loc1_.toad = false;
            attacker.setBattleAction(_loc1_);
            if(attacker.charMc.x < defender.charMc.x)
            {
               _loc34_ = new Point(defender.charMc.x - defender.getHitArea().width * Data.BATTLE_CHAR_SCALE - attacker.getHitArea().width * Data.BATTLE_CHAR_SCALE,defender.charMc.y);
            }
            else
            {
               _loc34_ = new Point(defender.charMc.x + defender.getHitArea().width * Data.BATTLE_CHAR_SCALE + attacker.getHitArea().width * Data.BATTLE_CHAR_SCALE,defender.charMc.y);
            }
            attacker.updateBattleFrame();
            playSkill(attacker,_loc37_,_loc34_);
            return true;
         }
         if(_loc1_.toadbig == true)
         {
            attacker.isPlayingAnimation = true;
            _loc42_ = {};
            _loc43_ = Central.main.SKILL_DATA["skill901"];
            _loc44_ = {};
            _loc45_ = null;
            _loc44_.id = _loc43_.id;
            _loc44_.name = _loc43_.name;
            _loc44_.gold = 0;
            _loc44_.crystal = 0;
            _loc44_.damage = 0 - int(_loc1_.toadbigDamagea);
            _loc44_.posType = _loc43_.posType;
            _loc44_.rarity = _loc43_.rarity;
            _loc44_.swfName = _loc43_.swfName;
            _loc44_.description = _loc43_.description;
            _loc44_.cp = 0;
            _loc46_ = {};
            if(_loc1_.toadef == true)
            {
               _loc46_ = _loc1_.toadbigEffect;
            }
            if(_loc1_.showall == true)
            {
               defender.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(281));
               defender.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(286));
            }
            else if(_loc1_.showa == true)
            {
               defender.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(281));
            }
            else if(_loc1_.showb == true)
            {
               defender.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(286));
            }
            _loc42_ = {
               "action":"skill",
               "skillId":_loc44_.id,
               "posType":_loc44_.posType,
               "cp":0,
               "dmg":_loc44_.damage,
               "effect":_loc46_
            };
            _loc47_ = {};
            _loc47_.characterType = defender.type;
            _loc47_.characterId = defender.getCharacterId();
            _loc47_.dmg = _loc42_.dmg;
            _loc1_.dmgArr = [_loc47_];
            _loc1_.effect = _loc42_.effect;
            _loc1_.toadbig = false;
            attacker.setBattleAction(_loc1_);
            if(attacker.charMc.x < defender.charMc.x)
            {
               _loc45_ = new Point(defender.charMc.x - defender.getHitArea().width * Data.BATTLE_CHAR_SCALE - attacker.getHitArea().width * Data.BATTLE_CHAR_SCALE,defender.charMc.y);
            }
            else
            {
               _loc45_ = new Point(defender.charMc.x + defender.getHitArea().width * Data.BATTLE_CHAR_SCALE + attacker.getHitArea().width * Data.BATTLE_CHAR_SCALE,defender.charMc.y);
            }
            attacker.updateBattleFrame();
            playSkill(attacker,_loc42_,_loc45_);
            return true;
         }
         return false;
      }
      
      public static function playerDisconnect(param1:String) : void
      {
         var _loc2_:* = undefined;
         if(Battle.pvpCurrencyGainDisplay)
         {
            if(Battle.myCurrencyGain == 0)
            {
               param1 = Central.main.getMainChar().getCharacterId();
            }
         }
         _loc2_ = getCharacterById(int(param1));
         _loc2_.pvpPlayerDisconnect();
      }
      
      public static function checkLoadingQuit() : void
      {
         var _loc1_:int = 0;
         var _loc2_:* = undefined;
         _loc1_ = 0;
         while(_loc1_ < loadingQuitArr.length)
         {
            _loc2_ = getCharacterById(int(loadingQuitArr[_loc1_]));
            _loc2_.pvpPlayerDisconnect();
            _loc1_++;
         }
         loadingQuitArr = [];
      }
      
      private static function actionFinish_CB() : void
      {
         var checkActionFinish:Boolean = false;
         var i:* = undefined;
         var j:uint = 0;
         var EventArray:Array = null;
         var signature:String = null;
         var signatureData:String = null;
         var battleAction:Object = null;
         var dataObj:Object = null;
         var hash:String = null;
         var jsonStr2:String = null;
         var skillData:Object = null;
         var itemData:Object = null;
         var decreaseItem:Boolean = false;
         var isEventBoss:Boolean = false;
         var tmpAttacker:* = undefined;
         var tmpDefender:* = undefined;
         var confirmBattleLose:Function = null;
         var revival:Function = null;
         var reviveBattleCharacter:Function = null;
         var revivalPrice:int = 0;
         var serverAttackerHP:int = 0;
         var serverAttackerCP:int = 0;
         var serverAttackerSP:int = 0;
         var serverDefenderHP:int = 0;
         var serverDefenderCP:int = 0;
         var serverDefenderSP:int = 0;
         var logToServer:Boolean = false;
         var syncData:Array = null;
         var syncObj:Object = null;
         var k:int = 0;
         var target:* = undefined;
         var action:String = null;
         var actionItem:String = null;
         var attackerWeapon:String = null;
         var attackerBackitem:String = null;
         var attackerPetId:int = 0;
         var attackerAPStr:String = null;
         var attackerSkillList:Array = null;
         var attackerClassSkillList:Array = null;
         var attackerSkill:String = null;
         var attackerBLObj:Object = null;
         var attackerBloodline:String = null;
         var attackerSENObj:Object = null;
         var attackerSenjutsu:String = null;
         var defenderWeapon:String = null;
         var defenderBackitem:String = null;
         var defenderPetId:int = 0;
         var defenderAPStr:String = null;
         var defenderSkillList:Array = null;
         var defenderClassSkillList:Array = null;
         var defenderSkill:String = null;
         var defenderBLObj:Object = null;
         var defenderBloodline:String = null;
         var defenderSENObj:Object = null;
         var defenderSenjutsu:String = null;
         Out.debug("battle","actionFinish_CB");
         checkActionFinish = isAllActionFinish();
         holdTargetIsMember = null;
         EventArray = [];
         EventArray[0] = Central.main.eventBattleMethod;
         EventArray[1] = int(seal_enemy);
         if(Main.battleModeSpecial && Main.battleModeSpecial == true)
         {
            EventArray[1] = battleRoundCounter;
            if(specialHpData.finalHP)
            {
               EventArray[2] = specialHpData.finalHP;
            }
            else
            {
               EventArray[2] = 0;
            }
            EventArray[3] = specialHpData.lv;
            EventArray[4] = Central.main.battleId;
            EventArray[5] = int(seal_enemy);
         }
         signatureData = "";
         j = 0;
         while(j < EventArray.length)
         {
            signatureData += EventArray[j];
            if(j < EventArray.length - 1)
            {
               signatureData += ",";
            }
            j++;
         }
         if(!checkActionFinish)
         {
            Out.debug("battle","checkActionFinish");
            return;
         }
         battleAction = attacker.getBattleAction();
         try
         {
            if(int(battleAction.hitNum) > 1 && battleAction.action == "skill")
            {
               skillData = Main.SKILL_DATA[battleAction.skillId];
               if(int(skillData.skill_hit_num) != int(battleAction.hitNum))
               {
                  Main.amfClient.service("ReportService.pvpActionHitLog",[battleAction.action,battleAction.skillId,int(battleAction.hitNum),int(skillData.skill_hit_num)],Main.saveLogResult);
               }
            }
         }
         catch(e:Error)
         {
            Out.error("Battle","pvpActionHitLog error");
         }
         if(playExtraAttack() == true)
         {
            Out.debug("battle","playExtraAttack");
            return;
         }
         if(Battle.type == TYPE_LOCAL && !attacker.isDead)
         {
            if(attacker.getBattleAction().action == "item")
            {
               itemData = Main.ITEM_DATA.find(attacker.getBattleAction().item);
               if(itemData.effect == BattleData.ITEM_SMOKE)
               {
                  decreaseItem = false;
                  if(Mission.curMissionID == "msn0")
                  {
                     Main.dispatchGameEvent(GameEvents.BATTLE_RUN);
                     return;
                  }
                  if(Main.challengeFriendUID != null)
                  {
                     if(Main.challengedFriends.indexOf(Main.challengeFriendUID) == -1)
                     {
                        switch(AppData.type)
                        {
                           case AppData.FB:
                              break;
                           case AppData.OK:
                              SNS.sendNotification(String(String(Central.main.langLib.get(301)).replace("[valfbuserusername]",FBUser.username)).replace("[valapplicationurl]",Data.APPLICATION_URL),[Main.challengeFriendUID]);
                              break;
                           case AppData.MP:
                              SNS.sendNotification(String(String(Central.main.langLib.get(300)).replace("[valfbuserusername]",FBUser.username)).replace("[valapplicationurl]",Data.APPLICATION_URL),[Main.challengeFriendUID]);
                        }
                        Main.challengedFriends.push(Main.challengeFriendUID);
                     }
                     i = 0;
                     while(i < enemyArr.length)
                     {
                        Main.saveChallengeRecord(enemyArr[i].getData(DBCharacterData.ID),2);
                        Panel.getInstance().setChallenged(int(enemyArr[i].getData(DBCharacterData.ID)));
                        i++;
                     }
                     Mission.updateDailyTask(DailyTaskData.TYPE_CHALLENGE,1);
                     Main.challengeFriendUID = null;
                     decreaseItem = true;
                  }
                  if(subType == BattleData.SUBTYPE_BOSS)
                  {
                     decreaseItem = true;
                     isEventBoss = false;
                     i = 0;
                     while(i < eventBossArr.length)
                     {
                        if(bossId.indexOf(eventBossArr[i]) >= 0)
                        {
                           isEventBoss = true;
                           break;
                        }
                        i++;
                     }
                     if(Central.main.isOldHunting)
                     {
                        huntingHash = Main.getHash(String(roomId) + 1);
                        Central.main.isOldHunting = false;
                        jsonStr2 = com.adobe.serialization.json.JSON.stringify(Central.main.battleFlowLog);
                        hash = Main.getHash(Central.main.battleFlowLogver + Central.main.startBattleId + jsonStr2);
                        Main.amfClient.service("EudemonGarden.finishHunting",[Account.getAccountSessionKey(),roomId,Central.main.getMainChar().itemUsedInBattle,1,huntingHash,Central.main.battleFlowLogver,Central.main.startBattleId,jsonStr2,hash],getBossRewardResponse04);
                        Central.main.battleFlowLog.battles = [];
                        Central.main.battleround = -1;
                     }
                     if(Central.main.isVDay2017)
                     {
                        huntingHash = Main.getHash(String(roomId) + 1);
                        Central.main.isVDay2017 = false;
                        Main.amfClient.service("ValentinesDay2017.finishHunting",[Account.getAccountSessionKey(),roomId,Central.main.getMainChar().itemUsedInBattle,1,huntingHash],getBossRewardResponse04);
                     }
                     if(Central.main.isNewClanWar)
                     {
                        Central.main.extraData.crew_merit += 2;
                        Central.main.getMainChar().itemUsedInBattle = Central.main.getMainChar().itemUsedInBattle ? Central.main.getMainChar().itemUsedInBattle : [];
                        ClanWarHash = Main.getHash(String(Central.main.getMainChar().itemUsedInBattle + Central.main.recruitedMembers.toString() + Central.main.selectedNewClanWar + 1));
                        Main.amfClient.service("CrewWar.finishLandHunt",[Account.getAccountSessionKey(),Central.main.getMainChar().itemUsedInBattle,Central.main.recruitedMembers.toString(),Central.main.selectedNewClanWar,1,Central.main.updateSequence(),ClanWarHash],getBossRewardResponse04);
                     }
                     if(isEventBoss)
                     {
                        Main.showAmfLoading();
                        signature = Main.getHash(String(bossId) + "|1|" + signatureData);
                        jsonStr2 = com.adobe.serialization.json.JSON.stringify(Central.main.battleFlowLog);
                        hash = Main.getHash(Central.main.battleFlowLogver + Central.main.startBattleId + jsonStr2);
                        Main.amfClient.service("ItemDAO.getBossReward",[Account.getAccountSessionKey(),signature,bossId,1,EventArray,Central.main.battleFlowLogver,Central.main.startBattleId,jsonStr2,hash],getBossRewardResponse04);
                        Central.main.battleFlowLog.battles = [];
                        Central.main.battleround = -1;
                     }
                  }
                  if(decreaseItem)
                  {
                     decreaseItem = false;
                     Main.getMainChar().updateDB(0,0,[],"",1,Battle);
                  }
                  try
                  {
                     Central.main.tracking.trackHuntBoss(Central.main.bossId,Central.main.tracking.TRACK_HUNT_BOSS + Central.main.tracking.TRACK_FAIL);
                  }
                  catch(err:Error)
                  {
                     Out.error("Battle","actionFinish_CB :: TRACKING - trackHuntBoss(TRACK_FAIL)");
                  }
                  battleFinish();
                  if(Central.main.eventName == "Vday2019")
                  {
                     Central.main.partyNpc = Central.main.prevNpcArr;
                     Central.main.partyMembers = Central.main.prevPartyMemberArr;
                     Central.main.eventName = "";
                  }
                  Main.battleRun();
                  return;
               }
            }
         }
         dataObj = {};
         resetATBPosition();
         if(battleAction != null)
         {
            if(battleAction.copyJutsu == true)
            {
               tmpAttacker = attacker;
               tmpDefender = defender;
               attacker = null;
               defender = null;
               attacker = tmpDefender;
               defender = tmpAttacker;
               attacker.moveToFront();
               attacker.showOverheadNumber(Timeline.WORD,Central.main.BLOODLINE_SKILL_DATA["bloodline_skill1023"].name);
               noCoolDown = true;
            }
         }
         dataObj.event = "info";
         dataObj.charId = String(Main.getMainChar().getData("character_id"));
         if(Battle.type == TYPE_LOCAL)
         {
            if(isBattleWin())
            {
               dataObj.state = "battle_win";
               Central.client.getInstance().sendData(dataObj,"BATTLE_HAV_WIN");
               return;
            }
            if(isBattleLose())
            {
               confirmBattleLose = function():*
               {
                  if(subType == BattleData.SUBTYPE_BOSS)
                  {
                     if(Central.main.isOldHunting)
                     {
                        Main.showAmfLoading();
                        huntingHash = Main.getHash(String(roomId) + 1);
                        Central.main.isOldHunting = false;
                        jsonStr2 = com.adobe.serialization.json.JSON.stringify(Central.main.battleFlowLog);
                        hash = Main.getHash(Central.main.battleFlowLogver + Central.main.startBattleId + jsonStr2);
                        Main.amfClient.service("EudemonGarden.finishHunting",[Account.getAccountSessionKey(),roomId,Central.main.getMainChar().itemUsedInBattle,1,huntingHash,Central.main.battleFlowLogver,Central.main.startBattleId,jsonStr2,hash],getBossRewardResponse03);
                        Central.main.battleFlowLog.battles = [];
                        Central.main.battleround = -1;
                     }
                     else if(Central.main.isVDay2017)
                     {
                        huntingHash = Main.getHash(String(roomId) + 1);
                        Central.main.isVDay2017 = false;
                        Main.amfClient.service("ValentinesDay2017.finishHunting",[Account.getAccountSessionKey(),roomId,Central.main.getMainChar().itemUsedInBattle,1,huntingHash],getBossRewardResponse04);
                     }
                     else if(Central.main.isNewClanWar)
                     {
                        Main.showAmfLoading();
                        Central.main.extraData.crew_merit += 2;
                        Central.main.getMainChar().itemUsedInBattle = Central.main.getMainChar().itemUsedInBattle ? Central.main.getMainChar().itemUsedInBattle : [];
                        ClanWarHash = Main.getHash(String(Central.main.getMainChar().itemUsedInBattle + Central.main.recruitedMembers.toString() + Central.main.selectedNewClanWar + 1));
                        Main.amfClient.service("CrewWar.finishLandHunt",[Account.getAccountSessionKey(),Central.main.getMainChar().itemUsedInBattle,Central.main.recruitedMembers.toString(),Central.main.selectedNewClanWar,1,Central.main.updateSequence(),ClanWarHash],getBossRewardResponse03);
                     }
                     else
                     {
                        Central.main.logHuntingMission(false,false);
                        Main.showAmfLoading();
                        signature = Main.getHash(String(bossId) + "|1|" + signatureData);
                        jsonStr2 = com.adobe.serialization.json.JSON.stringify(Central.main.battleFlowLog);
                        hash = Main.getHash(Central.main.battleFlowLogver + Central.main.startBattleId + jsonStr2);
                        Main.amfClient.service("ItemDAO.getBossReward",[Account.getAccountSessionKey(),signature,bossId,1,EventArray,Central.main.battleFlowLogver,Central.main.startBattleId,jsonStr2,hash],getBossRewardResponse03);
                        Central.main.battleFlowLog.battles = [];
                        Central.main.battleround = -1;
                     }
                  }
                  if(Main.challengeFriendUID != null)
                  {
                     Main.getMainChar().updateDB(0,0,[],"",1,Battle);
                  }
                  dataObj.state = "battle_lose";
                  Central.client.getInstance().sendData(dataObj);
               };
               revival = function(param1:Object):*
               {
                  if(Central.main.validateAmfResponse(param1))
                  {
                     Central.main.hideAmfLoading();
                     Central.main.getMainChar().updateHP(Math.round(Main.getMainChar().maxHP * 0.3));
                     Central.main.getMainChar().updateBattleFrame();
                     Central.main.getMainChar().isDead = false;
                     Central.main.getMainChar().playStandby();
                     Central.main.getMainChar().playRevival();
                     Central.main.getMainChar().isPlayingAnimation = false;
                     Central.main.getMainChar().resetBattleData();
                     Central.main.updateMenu();
                     Central.battle.actionFinish_CB();
                     Central.main.getMainChar().updateBattleFrame();
                     Central.main.getMainChar().resetBattleData();
                  }
               };
               reviveBattleCharacter = function():*
               {
                  Central.main.showAmfLoading();
                  Central.main.amfClient.service("CharacterService.reviveBattleCharacter",[Account.getAccountSessionKey()],revival);
               };
               revivalPrice = 50;
               if(Central.main.getMainChar().isDead)
               {
                  if(Central.main.account.getAccountBalance() >= revivalPrice)
                  {
                     Central.main.showConfirmation(AppData.lang == AppData.ZH ? "是否使用" + revivalPrice + "藍幣復活？（回復30%生命值）" : "Do you want to revive by using " + revivalPrice + " token? (Revert 30% HP)",reviveBattleCharacter,confirmBattleLose);
                  }
                  else
                  {
                     confirmBattleLose();
                  }
               }
               return;
            }
            dataObj.state = "action_finish";
            Central.client.getInstance().sendData(dataObj);
         }
         else
         {
            try
            {
               logToServer = false;
               syncData = lastBattleAction.syncData;
               j = 0;
               while(j < syncData.length)
               {
                  syncObj = syncData[j];
                  if(syncObj.type == 1)
                  {
                     if(attacker.getCharacterId() == int(syncObj.ID))
                     {
                        serverAttackerHP = int(syncObj.HP);
                     }
                     if(defender.getCharacterId() == int(syncObj.ID))
                     {
                        serverDefenderHP = int(syncObj.HP);
                     }
                     if(attacker.getCharacterId() == int(syncObj.ID))
                     {
                        serverAttackerCP = int(syncObj.CP);
                     }
                     if(defender.getCharacterId() == int(syncObj.ID))
                     {
                        serverDefenderCP = int(syncObj.CP);
                     }
                     if(attacker.getData(DBCharacterData.RANK) >= 8 && attacker.getCharacterId() == int(syncObj.ID))
                     {
                        serverAttackerSP = int(syncObj.SP);
                     }
                     if(defender.getData(DBCharacterData.RANK) >= 8 && defender.getCharacterId() == int(syncObj.ID))
                     {
                        serverDefenderSP = int(syncObj.SP);
                     }
                  }
                  j++;
               }
               try
               {
                  i = 0;
                  while(i < syncData.length)
                  {
                     syncObj = syncData[i];
                     if(syncObj.type == 1)
                     {
                        k = 0;
                        while(k < Central.main.PvpAllPlayer.length)
                        {
                           if(syncObj.ID == Central.main.PvpAllPlayer[k])
                           {
                              target = getCharacterById(int(syncObj.ID));
                              Out.debug("syncHpCpCommandAction","SyncHp B4 >> " + target.hp);
                              Out.debug("syncHpCpCommandAction","SyncCp B4 >> " + target.cp);
                              Out.debug("syncHpCpCommandAction","SyncSp B4 >> " + target.sp);
                              target.syncHp(syncObj.HP);
                              target.syncCp(syncObj.CP);
                              target.syncSp(syncObj.SP);
                              Out.debug("syncHpCpCommandAction","SyncHp After >> " + target.hp);
                              Out.debug("syncHpCpCommandAction","SyncCp After >> " + target.cp);
                              Out.debug("syncHpCpCommandAction","SyncSp After >> " + target.sp);
                              target.updateBattleFrame();
                              if(Math.abs(target.hp - syncObj.HP) > 300)
                              {
                                 logToServer = true;
                              }
                              if(Math.abs(target.cp - syncObj.CP) > 300)
                              {
                                 logToServer = true;
                              }
                              if(Central.main.senjutsuFeature)
                              {
                                 target.syncSp(syncObj.SP);
                                 Out.debug("syncHpCpCommandAction","SyncSp B4 >> " + target.sp);
                                 Out.debug("syncHpCpCommandAction","SyncSp After >> " + target.sp);
                                 if(Math.abs(target.sp - syncObj.SP) > 300)
                                 {
                                    logToServer = true;
                                 }
                              }
                           }
                           k++;
                        }
                     }
                     i++;
                  }
                  attacker.updateBattleFrame();
                  defender.updateBattleFrame();
                  Central.main.updateMenu();
               }
               catch(e:Error)
               {
                  Out.error("Battle","syncHpCp error");
               }
               if(serverAttackerHP != attacker.hp)
               {
                  logToServer = true;
               }
               if(serverAttackerCP != attacker.cp)
               {
                  logToServer = true;
               }
               if(serverDefenderHP != defender.hp)
               {
               }
               if(serverDefenderCP != defender.cp)
               {
                  logToServer = true;
               }
               if(Central.main.senjutsuFeature)
               {
                  if(serverAttackerSP != attacker.sp)
                  {
                     logToServer = true;
                  }
                  logToServer = true;
                  if(serverDefenderSP != defender.sp)
                  {
                     logToServer = true;
                  }
               }
               if(logToServer == true && Battle.type == TYPE_NETWORK)
               {
                  action = lastBattleAction.action;
                  actionItem = "";
                  switch(action)
                  {
                     case "weapon_attack":
                        actionItem = attacker.getWeapon();
                        break;
                     case "skill":
                     case "class_skill":
                        actionItem = lastBattleAction.skillId;
                        break;
                     case "bloodline":
                        actionItem = lastBattleAction.BLSKILLID;
                        break;
                     case "senjutsu":
                        actionItem = lastBattleAction.SENSKILLID;
                  }
                  attackerWeapon = "";
                  attackerBackitem = "";
                  attackerPetId = 0;
                  attackerAPStr = "";
                  attackerSkillList = [];
                  attackerClassSkillList = [];
                  attackerSkill = "";
                  attackerBLObj = {};
                  attackerBloodline = "";
                  attackerSENObj = {};
                  attackerSenjutsu = "";
                  attackerWeapon = attacker.getWeapon();
                  attackerBackitem = attacker.getBackItem();
                  switch(attacker.type)
                  {
                     case 1:
                     case 2:
                     case 3:
                     case 6:
                        if(attacker.pet != null)
                        {
                           attackerPetId = int(attacker.pet.id);
                        }
                  }
                  attackerSkillList = attacker.getSkillListArr();
                  j = 0;
                  while(j < attackerSkillList.length)
                  {
                     if(attackerSkill == "")
                     {
                        attackerSkill = attackerSkillList[j];
                     }
                     else
                     {
                        attackerSkill = attackerSkill + "," + attackerSkillList[j];
                     }
                     j++;
                  }
                  switch(attacker.type)
                  {
                     case 1:
                     case 2:
                     case 3:
                     case 6:
                        attackerClassSkillList = attacker.getClassSkillListArr();
                        j = 0;
                        while(j < attackerClassSkillList.length)
                        {
                           if(attackerSkill == "")
                           {
                              attackerSkill = attackerClassSkillList[j];
                           }
                           else
                           {
                              attackerSkill = attackerSkill + "," + attackerClassSkillList[j];
                           }
                           j++;
                        }
                        for each(attackerBLObj in attacker.bloodline)
                        {
                           if(attackerBloodline == "")
                           {
                              attackerBloodline = attackerBLObj.bloodline_id + "|" + attackerBLObj.skill_id + "|" + attackerBLObj.level;
                           }
                           else
                           {
                              attackerBloodline = attackerBloodline + "," + attackerBLObj.bloodline_id + "|" + attackerBLObj.skill_id + "|" + attackerBLObj.level;
                           }
                        }
                        if(Central.main.senjutsuFeature)
                        {
                           for each(attackerSENObj in attacker.senjutsu)
                           {
                              if(attackerSenjutsu == "")
                              {
                                 attackerSenjutsu = attackerSENObj.senjutsu_id + "|" + attackerSENObj.skill_id + "|" + attackerSENObj.level;
                              }
                              else
                              {
                                 attackerBloodline = attackerSenjutsu + "," + attackerSENObj.senjutsu_id + "|" + attackerSENObj.skill_id + "|" + attackerSENObj.level;
                              }
                           }
                        }
                  }
                  defenderWeapon = "";
                  defenderBackitem = "";
                  defenderPetId = 0;
                  defenderAPStr = "";
                  defenderSkillList = [];
                  defenderClassSkillList = [];
                  defenderSkill = "";
                  defenderBLObj = {};
                  defenderBloodline = "";
                  defenderSENObj = {};
                  defenderSenjutsu = "";
                  defenderWeapon = defender.getWeapon();
                  defenderBackitem = defender.getBackItem();
                  switch(defender.type)
                  {
                     case 1:
                     case 2:
                     case 3:
                     case 6:
                        if(defender.pet != null)
                        {
                           defenderPetId = int(defender.pet.id);
                        }
                  }
                  defenderSkillList = defender.getSkillListArr();
                  j = 0;
                  while(j < defenderSkillList.length)
                  {
                     if(defenderSkill == "")
                     {
                        defenderSkill = defenderSkillList[j];
                     }
                     else
                     {
                        defenderSkill = defenderSkill + "," + defenderSkillList[j];
                     }
                     j++;
                  }
                  switch(attacker.type)
                  {
                     case 1:
                     case 2:
                     case 3:
                     case 6:
                        defenderClassSkillList = attacker.getClassSkillListArr();
                        j = 0;
                        while(j < defenderClassSkillList.length)
                        {
                           if(defenderSkill == "")
                           {
                              defenderSkill = defenderClassSkillList[j];
                           }
                           else
                           {
                              defenderSkill = defenderSkill + "," + defenderClassSkillList[j];
                           }
                           j++;
                        }
                        if(defender.type != 4)
                        {
                           for each(defenderBLObj in defender.bloodline)
                           {
                              if(defenderBloodline == "")
                              {
                                 defenderBloodline = defenderBLObj.bloodline_id + "|" + defenderBLObj.skill_id + "|" + defenderBLObj.level;
                              }
                              else
                              {
                                 defenderBloodline = defenderBloodline + "," + defenderBLObj.bloodline_id + "|" + defenderBLObj.skill_id + "|" + defenderBLObj.level;
                              }
                           }
                           for each(defenderSENObj in defender.senjutsu)
                           {
                              if(defenderSenjutsu == "")
                              {
                                 defenderSenjutsu = defenderSENObj.senjutsu_id + "|" + defenderSENObj.skill_id + "|" + defenderSENObj.level;
                              }
                              else
                              {
                                 defenderSenjutsu = defenderSenjutsu + "," + defenderSENObj.senjutsu_id + "|" + defenderSENObj.skill_id + "|" + defenderSENObj.level;
                              }
                           }
                        }
                  }
                  if(pvpSyncLogSaved == false)
                  {
                  }
               }
            }
            catch(e:Error)
            {
               Out.error("Battle","pvp sync report error, Stack:" + e.getStackTrace());
            }
            if(String(log_time_user) == String(Main.getMainChar().getData("character_id")))
            {
               if(pvpLogTimeSaved == false)
               {
                  pvpLogTimeSaved = true;
               }
            }
            if(Main.getMainChar().isDead)
            {
               dataObj.char_dead = true;
            }
            else
            {
               dataObj.char_dead = false;
            }
            dataObj.state = "action_finish";
            Central.client.getInstance().sendData(dataObj);
            if(Battle.type == TYPE_NETWORK)
            {
               Out.debug("7940 - Battle.as actionFinish_CB","attacker.getDebuff" + GF.printObject(attacker.getBattleDebuff()));
               Out.debug("7941 - Battle.as actionFinish_CB","defender.getDebuff" + GF.printObject(defender.getBattleDebuff()));
               if((Central.main.getMainChar() as Character).isBattleDebuffActive(BattleData.EFFECT_STUN) || (Central.main.getMainChar() as Character).isBattleDebuffActive(BattleData.EFFECT_SLEEP) || (Central.main.getMainChar() as Character).isBattleDebuffActive(BattleData.EFFECT_FEAR) || (Central.main.getMainChar() as Character).isBattleDebuffActive(BattleData.EFFECT_CHAOS) || (Central.main.getMainChar() as Character).isBattleDebuffActive(BattleData.EFFECT_BUNDLE))
               {
                  bGearBtnEnabled = false;
                  Out.debug("","Rex debug: try to fix can use item when stun");
               }
               else
               {
                  bGearBtnEnabled = true;
               }
               attacker.resetBuff();
               defender.resetBuff();
            }
         }
         Main.updateMenu();
      }
      
      private static function getBossRewardResponse03(param1:Object) : void
      {
         var i:uint = 0;
         var tempArr:Array = null;
         var addItem:Boolean = false;
         var response:Object = param1;
         Main.hideAmfLoading();
         if(Main.validateAmfResponse(response))
         {
            connectingAmf = false;
            tempArr = String(bossId).split(",");
            addItem = true;
            i = 0;
            while(i < eventBossArr.length)
            {
               if(tempArr.indexOf(eventBossArr[i]) >= 0)
               {
                  addItem = false;
                  break;
               }
               i++;
            }
            if(addItem)
            {
               try
               {
                  Central.main.tracking.generalTrack(Central.main.tracking.TRACK_HUNTING_HOUSE_2012,bossId,"Boss_loss");
               }
               catch(err:Error)
               {
                  Out.error("Battle","TRACK_HUNT_BOSS >> " + err.message);
               }
            }
            Central.main.Sakura2013BattleMethod == "";
            Main.getMainChar().updateDB(0,0,[],"",1,Battle);
            if(Central.main.isNewClanWar)
            {
               Central.main.isNewClanWar = false;
               Central.main._partyMembers = Central.main.tmpPartyMembers;
               Central.main._partyMembers = Central.main.recruitFriendTmpData;
               Central.panel.getInstance().show("newclan_village");
            }
         }
      }
      
      private static function getBossRewardResponse04(param1:Object) : void
      {
         var i:uint = 0;
         var response:Object = param1;
         Main.hideAmfLoading();
         if(Main.validateAmfResponse(response))
         {
            try
            {
               Central.main.tracking.generalTrack(Central.main.tracking.TRACK_HUNTING_HOUSE_2012,bossId,"Boss_loss");
            }
            catch(err:Error)
            {
               Out.error("Battle","TRACK_HUNT_BOSS >> " + err.message);
            }
            Central.main.Sakura2013BattleMethod == "";
         }
         if(Central.main.isNewClanWar)
         {
            Central.main.partyNpc = Central.main.tmpParty;
            Central.main._partyMembers = Central.main.recruitFriendTmpData;
            trace("fdsafsafsafsadfsa" + Central.main.isNewClanWar);
            trace("fdsafsafsafsafdasfsafsadfsa" + Central.main.partyNpc);
            Central.panel.getInstance().show("newclan_village");
         }
         Central.main.isNewClanWar = false;
      }
      
      public static function isAllActionFinish() : Boolean
      {
         var _loc1_:uint = 0;
         if(Main.getMainChar().isPlayingAnimation)
         {
            Out.debug("battle","isAllActionFinish ：：  getMainChar");
            return false;
         }
         _loc1_ = 0;
         while(_loc1_ < enemyArr.length)
         {
            if(enemyArr[_loc1_].isPlayingAnimation)
            {
               Out.debug("battle","isAllActionFinish ：：  enemyArr");
               return false;
            }
            _loc1_++;
         }
         if(partyArr)
         {
            _loc1_ = 0;
            while(_loc1_ < partyArr.length)
            {
               if(partyArr[_loc1_].isPlayingAnimation)
               {
                  Out.debug("battle","isAllActionFinish ：：  partyArr");
                  return false;
               }
               _loc1_++;
            }
         }
         if(petArr)
         {
            _loc1_ = 0;
            while(_loc1_ < petArr.length)
            {
               if(petArr[_loc1_].isPlayingAnimation)
               {
                  Out.debug("battle","isAllActionFinish ：：  petArr");
                  return false;
               }
               _loc1_++;
            }
         }
         return true;
      }
      
      private static function isBattleWin() : Boolean
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         Out.debug("battle","isBattleWin :: hhhhhhhhhhhhhhhhhhhank");
         if(Mission.curMissionID == "msn136")
         {
            if(enemyArr)
            {
               _loc2_ = 0;
               while(_loc2_ < enemyArr.length)
               {
                  if(enemyArr[_loc2_].getData(DBCharacterData.SESSION_PLAYTIME) == -1 && enemyArr[_loc2_].hp <= 0)
                  {
                     return true;
                  }
                  if(enemyArr[_loc2_].getData(DBCharacterData.SESSION_PLAYTIME) == -2 && enemyArr[_loc2_].hp / enemyArr[_loc2_].maxHP <= 0.5)
                  {
                     return true;
                  }
                  _loc2_++;
               }
            }
         }
         _loc1_ = 0;
         while(_loc1_ < enemyArr.length)
         {
            if(enemyArr[_loc1_].hp > 0)
            {
               return false;
            }
            enemyArr[_loc1_].updateHP(0);
            _loc1_++;
         }
         return true;
      }
      
      private static function isBattleLose() : Boolean
      {
         var _loc1_:uint = 0;
         var _loc2_:int = 0;
         if(Mission.curMissionID == "msn135" || Central.main.eventName == "Vday2019")
         {
            if(partyArr)
            {
               _loc1_ = 0;
               while(_loc1_ < partyArr.length)
               {
                  if(partyArr[_loc1_].hp <= 0)
                  {
                     if(Central.main.eventName == "Vday2019")
                     {
                        Central.main.partyNpc = Central.main.prevNpcArr;
                        Central.main.partyMembers = Central.main.prevPartyMemberArr;
                        Central.main.eventName = "";
                     }
                     return true;
                  }
                  _loc1_++;
               }
            }
         }
         Out.debug("battle","isBattleLose :: round >> " + round);
         if(Central.main.battleRuleArr.length > 0)
         {
            _loc2_ = 0;
            while(_loc2_ < Central.main.battleRuleArr.length)
            {
               switch(Central.main.battleRuleArr[_loc2_].attribute)
               {
                  case EnemyAttributeData.ROUND:
                     if(Central.main.battleRuleArr[_loc2_].type == EnemyAttributeData.OVER)
                     {
                        if(round >= Central.main.battleRuleArr[_loc2_].amount)
                        {
                           return true;
                        }
                     }
               }
               _loc2_++;
            }
         }
         if(Main.getMainChar().isDead)
         {
            return true;
         }
         return false;
      }
      
      private static function gotClanBattleResult(param1:Object) : void
      {
         if(Main.validateAmfResponse(param1))
         {
            Main.hideAmfLoading();
            connectingAmf = false;
            if(param1.quit_clan)
            {
               Central.main.showOk(Central.main.langLib.get(1792)[6],membershipRemoved);
               return;
            }
            repGain = param1.result;
            prestigeGain = param1.prestige_gain;
            Clan.getInstance().clanData.reputation = int(Clan.getInstance().clanData.reputation) + repGain;
            Clan.getInstance().battleClanData.reputation = Clan.getInstance().battleClanData.reputation;
            battleMc.gotoClanResult();
         }
      }
      
      private static function membershipRemoved() : void
      {
         battleFinish();
         Battle.subType = BattleData.SUBTYPE_NORMAL;
         Central.main.gotoMap();
      }
      
      private static function getBossRewardResponse02(param1:Object) : void
      {
         var i:uint = 0;
         var bossRewardList:Array = null;
         var bossRewardGetList:Array = null;
         var reward:Array = null;
         var reward_get:Array = null;
         var rewardId:String = null;
         var myEffect:Object = null;
         var mData:Object = null;
         var tempArr:Array = null;
         var addItem:Boolean = false;
         var reward_favor:int = 0;
         var tmp:Array = null;
         var extra_reward_get:Array = null;
         var reward_petData:Array = null;
         var extra_reward:Array = null;
         var response:Object = param1;
         Main.hideAmfLoading();
         if(Main.validateAmfResponse(response))
         {
            connectingAmf = false;
            bossRewardList = [];
            bossRewardGetList = [];
            reward = response.reward;
            reward_get = response.reward_get;
            if(response.result != null)
            {
               reward_favor = int(response.result.add_favorability);
            }
            rewardId = "";
            Central.main.petData = [];
            i = 0;
            while(i < reward.length)
            {
               rewardId = itemPrototype(reward[i]);
               if(String(reward[i]).indexOf("petxp") >= 0)
               {
                  bossRewardPetXp = int(rewardId);
               }
               else if(String(reward[i]).indexOf("xp") >= 0)
               {
                  bossRewardXp = int(rewardId);
                  Main.getMainChar().showLevelUp(Main.getMainChar().updateXP(bossRewardXp,true,true));
               }
               else if(String(reward[i]).indexOf("gold") >= 0)
               {
                  bossRewardGold = int(rewardId);
                  Central.main.getMainChar().updateGold(bossRewardGold);
               }
               else if(String(reward[i]).indexOf("item_741") >= 0 || String(reward[i]).indexOf("item_742") >= 0)
               {
                  tmp = [];
                  tmp = reward[i].split("_");
                  rewardId = tmp[0] + tmp[1] + "_" + String(parseInt(tmp[2]) + 1);
                  bossRewardList.push(rewardId);
               }
               else if(String(reward[i]).indexOf("pet") >= 0)
               {
                  Central.main.petData.push(response.player_pet);
                  bossRewardList.push(rewardId);
               }
               else
               {
                  bossRewardList.push(rewardId);
               }
               i++;
            }
            i = 0;
            while(i < reward_get.length)
            {
               rewardId = itemPrototype(reward_get[i]);
               if(!(String(reward_get[i]).indexOf("petxp") >= 0 || String(reward_get[i]).indexOf("xp") >= 0 || String(reward_get[i]).indexOf("gold") >= 0))
               {
                  bossRewardGetList.push(rewardId);
               }
               i++;
            }
            if(Boolean(response.extra_reward) && Boolean(response.extra_reward_get) && Boolean(response.pet))
            {
               extra_reward_get = response.extra_reward_get;
               reward_petData = response.pet;
               extra_reward = response.extra_reward;
               i = 0;
               while(i < extra_reward.length)
               {
                  tmp = extra_reward[i].split("_");
                  rewardId = tmp[0] + tmp[1];
                  bossRewardList.push(rewardId);
                  i++;
               }
               i = 0;
               while(i < extra_reward_get.length)
               {
                  tmp = extra_reward_get[i].split("_");
                  rewardId = tmp[0] + tmp[1];
                  bossRewardGetList.push(rewardId);
                  Central.main.petData = reward_petData;
                  i++;
               }
            }
            myEffect = {
               "gold_effect":1,
               "xp_effect":1
            };
            mData = {
               "gold":bossRewardGold,
               "tp":0,
               "xp":bossRewardXp,
               "name":" ",
               "type":subType
            };
            if(Number(mData.gold) == 0 && Number(mData.xp) == 0)
            {
               BattleReward();
            }
            else
            {
               if(Central.main.eventName == "Vday2019")
               {
                  Central.main.eventName = "";
                  Central.main.showInfo(Central.main.langLib.get(1897)[14] + " + " + reward_favor);
               }
               Central.main.popup.missionComplete02.init(true,true,mData,myEffect,bossRewardList,bossRewardGetList,battleWin);
            }
            Main.updateMenu(false);
            tempArr = String(bossId).split(",");
            addItem = true;
            i = 0;
            while(i < eventBossArr.length)
            {
               if(tempArr.indexOf(eventBossArr[i]) >= 0)
               {
                  addItem = false;
                  break;
               }
               i++;
            }
            if(addItem)
            {
               try
               {
                  Central.main.tracking.generalTrack(Central.main.tracking.TRACK_HUNTING_HOUSE_2012,bossId,"Boss_win");
               }
               catch(err:Error)
               {
                  Out.error("Battle","TRACK_HUNT_BOSS >> " + err.message);
               }
            }
            Main.getMainChar().updateDB(0,0,[],"",0,Battle);
            if(Central.main.isNewClanWar)
            {
               Central.main.partyNpc = Central.main.tmpParty;
               Central.main._partyMembers = Central.main.recruitFriendTmpData;
               Central.main.isNewClanWar = false;
               Central.main.crewDamage = response.dmg;
               Central.main.showDoubleCrewWarReward = response.double_reward;
            }
         }
      }
      
      private static function itemPrototype(param1:String) : String
      {
         var _loc2_:Array = null;
         _loc2_ = param1.split("_");
         if(_loc2_ == null)
         {
            Out.error("itemPrototype","parameter type not match");
            return null;
         }
         if(_loc2_.length <= 1)
         {
            return _loc2_[0];
         }
         switch(_loc2_[0])
         {
            case "petxp":
            case "xp":
            case "gold":
               return _loc2_[1];
            case "item":
               return _loc2_[0] + _loc2_[1];
            default:
               return _loc2_[0] + _loc2_[1];
         }
      }
      
      public static function addBattleReward(param1:Array) : *
      {
         rewardList = param1;
      }
      
      public static function BattleReward() : *
      {
         if(rewardList != null && rewardList.length != 0)
         {
            Central.main.mainMc.popupMc.addReward(rewardList);
            Central.main.mainMc.popupMc.showReward();
         }
         rewardList = new Array();
         battleWin();
      }
      
      public static function onClanResult() : void
      {
         Central.main.partyMembers = null;
         battleMc["lbl_battle_result_title"].text = Central.main.langLib.titleTxt(TitleData.BATTLERESULT);
         battleMc["lbl_battle_result_win"].text = Central.main.langLib.titleTxt(TitleData.WIN);
         battleMc["lbl_battle_result_lose"].text = Central.main.langLib.titleTxt(TitleData.LOSE);
         battleMc["lbl_reputation_win"].text = Central.main.langLib.titleTxt(TitleData.REPUTATION) + ":";
         battleMc["lbl_reputation_lose"].text = Central.main.langLib.titleTxt(TitleData.REPUTATION) + ":";
         switch(battleResult)
         {
            case 1:
               battleMc["winClanTxt"].text = Clan.getInstance().clanData.name;
               battleMc["loseClanTxt"].text = Clan.getInstance().battleClanData.name;
               battleMc["winRepTxt"].text = String(repGain);
               battleMc["SelfWinRepTxt"].text = String(prestigeGain);
               Central.main.clanPrestige += prestigeGain;
               battleMc["loseRepTxt"].text = "";
               battleMc["selfLoseRepTxt"].text = "-";
               battleMc["winTotalRepTxt"].text = String(Clan.getInstance().clanData.reputation);
               battleMc["loseTotalRepTxt"].text = String(Clan.getInstance().battleClanData.reputation);
               battleMc["okBtn"].addEventListener(MouseEvent.CLICK,battleWin);
               break;
            case 2:
               battleMc["winClanTxt"].text = Clan.getInstance().battleClanData.name;
               battleMc["loseClanTxt"].text = Clan.getInstance().clanData.name;
               battleMc["winRepTxt"].text = "0";
               battleMc["SelfWinRepTxt"].text = "-";
               Central.main.clanPrestige += prestigeGain;
               battleMc["loseRepTxt"].text = "";
               battleMc["selfLoseRepTxt"].text = String(prestigeGain);
               battleMc["winTotalRepTxt"].text = String(Clan.getInstance().battleClanData.reputation);
               battleMc["loseTotalRepTxt"].text = String(Clan.getInstance().clanData.reputation);
               battleMc["okBtn"].addEventListener(MouseEvent.CLICK,battleLose);
               break;
            default:
               return;
         }
      }
      
      public static function showBattleWin() : void
      {
         var _loc1_:Object = null;
         if(Mission.curMissionID)
         {
            _loc1_ = Main.MISSION_DATA[Mission.curMissionID];
            if(_loc1_.sp > 0 || _loc1_.grade == "S" || Mission.curMissionID == "msn284")
            {
               if(isShowLevelUp)
               {
                  isShowLevelUp = false;
                  Main.showLevelUp(battleWin);
               }
               else
               {
                  battleFinish();
                  Main.battleWin();
               }
            }
            else
            {
               battleMc.gotoWin();
            }
         }
         else
         {
            battleMc.gotoWin();
         }
      }
      
      public static function onShowBattleWin() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         var _loc3_:Array = null;
         var _loc4_:Array = null;
         var _loc5_:uint = 0;
         var _loc6_:String = null;
         var _loc7_:Array = null;
         var _loc8_:String = null;
         var _loc9_:Array = null;
         _loc1_ = 0;
         _loc2_ = 0;
         _loc3_ = [];
         _loc4_ = [];
         _loc7_ = [];
         battleMc["okBtn"].addEventListener(MouseEvent.CLICK,battleWin);
         Main.getMainChar().playWin();
         battleMc["itemTitle"].visible = false;
         GF.removeAllChild(battleMc["displayHolder"]);
         GF.removeAllChild(battleMc["specialHolder"]);
         if(Battle.type == TYPE_LOCAL)
         {
            if(subType != BattleData.SUBTYPE_BOSS)
            {
               _loc5_ = 0;
               while(_loc5_ < enemyArr.length)
               {
                  _loc2_ += enemyArr[_loc5_].rewardGold;
                  _loc1_ += enemyArr[_loc5_].rewardXP;
                  if(Main.challengeFriendUID != null)
                  {
                     _loc7_.push(enemyArr[_loc5_].getData(DBCharacterData.ID));
                     switch(AppData.type)
                     {
                        case AppData.FB:
                           if(enemyArr[_loc5_].getData(DBCharacterData.XP) > 0)
                           {
                              _loc6_ = "";
                           }
                           else
                           {
                              _loc6_ = "";
                           }
                           break;
                        case AppData.OK:
                           if(enemyArr[_loc5_].getData(DBCharacterData.XP) > 0)
                           {
                              _loc6_ = String(Central.main.langLib.get(278)).replace("[valfbuserusername]",FBUser.username);
                              _loc6_ = String(_loc6_).replace("[valdbcharacterdataname]",enemyArr[_loc5_].getData(DBCharacterData.NAME));
                              _loc6_ = String(_loc6_).replace("[valapplicationurl]",Data.APPLICATION_URL);
                           }
                           else
                           {
                              _loc6_ = String(Central.main.langLib.get(303)).replace("[valfbuserusername]",FBUser.username);
                              _loc6_ = String(_loc6_).replace("[valapplicationurl]",Data.APPLICATION_URL);
                           }
                           break;
                        case AppData.MP:
                           if(enemyArr[_loc5_].getData(DBCharacterData.XP) > 0)
                           {
                              _loc6_ = String(Central.main.langLib.get(297)).replace("[valfbuserusername]",FBUser.username);
                              _loc6_ = String(_loc6_).replace("[valdbcharacterdataname]",enemyArr[_loc5_].getData(DBCharacterData.NAME));
                              _loc6_ = String(_loc6_).replace("[valapplicationurl]",Data.APPLICATION_URL);
                           }
                           else
                           {
                              _loc6_ = String(Central.main.langLib.get(302)).replace("[valfbuserusername]",FBUser.username);
                              _loc6_ = String(_loc6_).replace("[valapplicationurl]",Data.APPLICATION_URL);
                           }
                     }
                     Main.saveChallengeRecord(enemyArr[_loc5_].getData(DBCharacterData.ID),0);
                     Panel.getInstance().setChallenged(int(enemyArr[_loc5_].getData(DBCharacterData.ID)));
                  }
                  _loc5_++;
               }
               battleMc["xpTxt"].text = String(_loc1_);
               battleMc["goldTxt"].text = String(_loc2_);
               isShowLevelUp = Main.getMainChar().updateXP(_loc1_);
               Main.getMainChar().saveGold(_loc2_);
               _loc8_ = "";
               if(_loc3_.length > 0 || _loc4_.length > 0)
               {
                  if(Main.getMainChar().calcInventoryUsage() >= Data.INV_SPACE_FREE && Account.getAccountType() == Account.FREE)
                  {
                     Main.showInfo(Central.main.langLib.get(348));
                     _loc3_ = [];
                     _loc4_ = [];
                  }
                  if(Main.getMainChar().calcInventoryUsage() >= Data.INV_SPACE_FREE && Account.getAccountType() == Account.PREMIUM)
                  {
                     Main.provision();
                     if(Main.getMainChar().calcInventoryUsage() >= Data.INV_SPACE_PREMIUM)
                     {
                        Main.showInfo(Central.main.langLib.get(348));
                        _loc3_ = [];
                        _loc4_ = [];
                     }
                  }
               }
               _loc9_ = new Array();
               if(_loc4_.length > 0)
               {
                  _loc8_ += _loc4_[0].name + "<br>";
                  Main.getMainChar().addInventory(InventoryData.TYPE_WEAPON,_loc4_[0].id);
                  battleMc["itemTitle"].visible = true;
                  _loc9_.push(_loc4_[0].id);
               }
               _loc5_ = 0;
               while(_loc5_ < (_loc3_.length > 3 ? 3 : _loc3_.length))
               {
                  _loc8_ += _loc3_[_loc5_].name + "<br>";
                  Main.getMainChar().addInventory(InventoryData.TYPE_ITEM,_loc3_[_loc5_].id);
                  battleMc["itemTitle"].visible = true;
                  _loc9_.push(_loc3_[0].id);
                  _loc5_++;
               }
               battleMc["itemTxt"].htmlText = _loc8_;
            }
         }
         if(Main.challengeFriendUID != null)
         {
            SNS.publishFeed(SNSData.FEED_CHALLENGE_WON,SNS.challengeFriendName);
            if(Main.challengedFriends.indexOf(Main.challengeFriendUID) == -1)
            {
               if(_loc6_ != "")
               {
                  SNS.sendNotification(_loc6_,[Main.challengeFriendUID]);
               }
               Main.challengedFriends.push(Main.challengeFriendUID);
            }
            Mission.updateDailyTask(DailyTaskData.TYPE_CHALLENGE,1);
            Main.challengeFriendUID = null;
         }
         if(Main.getMainChar().getData(DBCharacterData.RANK) >= 8 && subType != BattleData.SUBTYPE_BOSS)
         {
            _loc1_ = 0;
         }
         Main.getMainChar().updateDB(_loc1_,_loc2_,[],null,0,Battle);
         Main.updateMenu();
         battleMc["itemTitle"].htmlText = Central.main.langLib.titleTxt(TitleData.ITEMS) + ":";
         battleMc["lbl_battle_result"].htmlText = Central.main.langLib.titleTxt(TitleData.VICTORY) + "!";
      }
      
      private static function battleWin(param1:MouseEvent = null) : void
      {
         if(isShowLevelUp)
         {
            isShowLevelUp = false;
            Main.showLevelUp(battleWin);
         }
         else
         {
            battleFinish();
            Main.battleWin();
         }
      }
      
      private static function battleLose(param1:MouseEvent = null) : void
      {
         battleFinish();
         Main.battleLose();
      }
      
      private static function showPvPaiBattleWin() : void
      {
         if(Central.main.HitAi != true)
         {
            return;
         }
         battleResult = 1;
         battleMc.gotoPvPaiWin();
      }
      
      private static function showPvPaiBattleLose() : void
      {
         if(Central.main.HitAi != true)
         {
            return;
         }
         battleResult = 2;
         battleMc.gotoPvPailose();
      }
      
      private static function showPvPBattleWin() : void
      {
         if(Battle.type != TYPE_NETWORK)
         {
            return;
         }
         battleResult = 1;
         trace("Central.main.PvpPlayerPost = " + Central.main.PvpPlayerPost);
         if(Central.main.PvpPlayerPost == "quick")
         {
            battleMc.gotoPvPWinQuick();
            return;
         }
         if(Central.main.PvpPlayerPost == "tournament")
         {
            battleMc.gotoPvPWinTournament();
            return;
         }
         if(Central.main.PvpPlayerPost == "PVE")
         {
            battleMc.gotoPveWin();
            return;
         }
         battleMc.gotoPvPWin();
      }
      
      private static function showPvPBattleLose() : void
      {
         if(Battle.type != TYPE_NETWORK && Central.main.HitAi != true)
         {
            return;
         }
         battleResult = 2;
         if(Central.main.PvpPlayerPost == "quick")
         {
            battleMc.gotoPvPLoseQuick();
            return;
         }
         if(Central.main.PvpPlayerPost == "tournament")
         {
            battleMc.gotoPvPLoseTournament();
            return;
         }
         battleMc.gotoPvPLose();
      }
      
      private static function updatePvpailoseBattleFinishResult() : void
      {
         var _loc1_:TextField = null;
         var _loc2_:TextField = null;
         if(Boolean(battleMc["mc_pvp_currency"]) && Boolean(battleMc["mc_pvp_currency"]["txt_value"]))
         {
            battleMc["mc_pvp_currency"].visible = true;
            _loc1_ = battleMc["mc_pvp_currency"]["txt_value"];
            _loc1_.text = Battle.myCurrencyGain + "";
            Main.getMainChar().pvpRecord[PvPData.PVP_CURRENCY] = Main.getMainChar().pvpRecord[PvPData.PVP_CURRENCY] + Battle.myCurrencyGain;
         }
         if(battleMc["mc_pvp_event_currency"])
         {
            battleMc["mc_pvp_event_currency"].visible = false;
         }
         if(Boolean(battleMc["mc_pvp_point"]) && Boolean(battleMc["mc_pvp_point"]["txt_value"]))
         {
            battleMc["mc_pvp_point"].visible = Battle.pvpPointGainDisplay;
            _loc1_ = battleMc["mc_pvp_point"]["txt_value"];
            _loc1_.text = Battle.pvpPointGainDisplay ? Battle.myPointGain + "" : "TBA";
         }
         Out.debug("","pvp currency gain = " + Battle.myCurrencyGain);
         isCompletedDailyFirstBonus = true;
      }
      
      private static function updatePvpaiwinBattleFinishResult() : void
      {
         var _loc1_:TextField = null;
         var _loc2_:TextField = null;
         if(Boolean(battleMc["mc_pvp_currency"]) && Boolean(battleMc["mc_pvp_currency"]["txt_value"]))
         {
            battleMc["mc_pvp_currency"].visible = true;
            _loc1_ = battleMc["mc_pvp_currency"]["txt_value"];
            _loc1_.text = Battle.myCurrencyGain + "";
            Main.getMainChar().pvpRecord[PvPData.PVP_CURRENCY] = Main.getMainChar().pvpRecord[PvPData.PVP_CURRENCY] + Battle.myCurrencyGain;
         }
         if(battleMc["mc_pvp_event_currency"])
         {
            battleMc["mc_pvp_event_currency"].visible = false;
         }
         if(Boolean(battleMc["mc_pvp_point"]) && Boolean(battleMc["mc_pvp_point"]["txt_value"]))
         {
            battleMc["mc_pvp_point"].visible = Battle.pvpPointGainDisplay;
            _loc1_ = battleMc["mc_pvp_point"]["txt_value"];
            _loc1_.text = Battle.pvpPointGainDisplay ? Battle.myPointGain + "" : "TBA";
         }
         Out.debug("","pvp currency gain = " + Battle.myCurrencyGain);
         isCompletedDailyFirstBonus = true;
      }
      
      private static function updatePvpBattleFinishResult() : void
      {
         var _loc1_:TextField = null;
         var _loc2_:TextField = null;
         var _loc3_:int = 0;
         var _loc4_:Object = null;
         var _loc5_:int = 0;
         Out.debug("","Battle.pvpCurrencyGainDisplay=" + Battle.pvpCurrencyGainDisplay);
         Out.debug("","Battle.myCurrencyGain=" + Battle.myCurrencyGain);
         Out.debug("","Battle.myEventCurrencyGain=" + Battle.myEventCurrencyGain);
         Out.debug("","Battle.pvpPointGainDisplay=" + Battle.pvpPointGainDisplay);
         Out.debug("","Battle.myPointGain=" + Battle.myPointGain);
         if(Boolean(battleMc["mc_pvp_currency"]) && Boolean(battleMc["mc_pvp_currency"]["txt_value"]))
         {
            battleMc["mc_pvp_currency"].visible = Battle.pvpCurrencyGainDisplay;
            _loc1_ = battleMc["mc_pvp_currency"]["txt_value"];
            _loc1_.text = Battle.pvpCurrencyGainDisplay ? Battle.myCurrencyGain + "" : "TBA";
         }
         if(battleMc["mc_pvp_event_currency"])
         {
            battleMc["mc_pvp_event_currency"].visible = false;
         }
         if(throckrewardList.length > 0)
         {
            battleMc["mc_pvp_event_currency"].visible = true;
            _loc3_ = 0;
            while(_loc3_ < throckrewardList.length)
            {
               _loc4_ = Central.main.toolkit.getDisplayData(throckrewardList[_loc3_].id);
               battleMc["mc_pvp_event_currency"]["rewardItem" + _loc3_].visible = true;
               battleMc["mc_pvp_event_currency"]["rewardItem" + _loc3_]["holder"].addChild(_loc4_.mc);
               Central.main.showIconData(battleMc["mc_pvp_event_currency"]["rewardItem" + _loc3_],throckrewardList[_loc3_].id);
               Central.main.showDynamicTooltip(battleMc["mc_pvp_event_currency"]["rewardItem" + _loc3_],String("<font size=\'16\'>" + _loc4_.tooltip + "</font>"));
               battleMc["mc_pvp_event_currency"]["rewardItem" + _loc3_]["txt"].text = "x" + throckrewardList[_loc3_].amount;
               _loc3_++;
            }
            if(throckrewardList.length < 6)
            {
               _loc5_ = int(throckrewardList.length);
               while(_loc5_ < 6)
               {
                  battleMc["mc_pvp_event_currency"]["rewardItem" + _loc5_].visible = false;
                  _loc5_++;
               }
            }
            throckrewardList = [];
         }
         if(Boolean(battleMc["mc_pvp_point"]) && Boolean(battleMc["mc_pvp_point"]["txt_value"]))
         {
            battleMc["mc_pvp_point"].visible = Battle.pvpPointGainDisplay;
            _loc1_ = battleMc["mc_pvp_point"]["txt_value"];
            _loc1_.text = Battle.pvpPointGainDisplay ? Battle.myPointGain + "" : "TBA";
         }
         Out.debug("","pvp currency gain = " + Battle.myCurrencyGain);
         Main.getMainChar().pvpRecord[PvPData.PVP_CURRENCY] = Main.getMainChar().pvpRecord[PvPData.PVP_CURRENCY] + Battle.myCurrencyGain;
         Main.getMainChar().pvpRecord[PvPData.PVP_POINT] = Main.getMainChar().pvpRecord[PvPData.PVP_POINT] + Battle.myPointGain;
         isCompletedDailyFirstBonus = true;
         if(Central.main.PvpPlayerPost == "tournament")
         {
            Main.getMainChar().pvpRecord[PvPData.PVP_TOURNAMENT_TICKET] = Main.getMainChar().pvpRecord[PvPData.PVP_TOURNAMENT_TICKET] - 1;
         }
      }
      
      public static function onShowPvEBattleWin() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:Array = null;
         if(Battle.type != TYPE_NETWORK)
         {
            return;
         }
         _loc2_ = 10;
         _loc3_ = [];
         Main.achievement.updateBattleStat(Main.achievementData.LIVE_BATTLE_WIN,1);
         battleMc["skin_0_reward"]["lbl_ninjaemblem_title"].text = AppData.lang == AppData.ZH ? "擊退成功!" : "Defeat Success!";
         battleMc["skin_0_reward"]["MissionTxt"].text = AppData.lang == AppData.ZH ? "獎勵" : "Reward";
         battleMc["skin_0_reward"]["nameTxt"].text = AppData.lang == AppData.ZH ? "獎勵" : "Reward";
         _loc1_ = 0;
         while(_loc1_ < Battle.myPvEReward.length)
         {
            if(Battle.myPvEReward[_loc1_].indexOf("xp") >= 0)
            {
               battleMc["skin_0_reward"]["goldTxt"]["txt"].text = int(Battle.myPvEReward[_loc1_].replace("xp",""));
               Main.getMainChar().showLevelUp(Main.getMainChar().updateXP(int(Battle.myPvEReward[_loc1_].replace("xp","")),true,true));
            }
            else if(Battle.myPvEReward[_loc1_].indexOf("gold") >= 0)
            {
               battleMc["skin_0_reward"]["xpTxt"]["txt"].text = int(Battle.myPvEReward[_loc1_].replace("gold",""));
               Central.main.getMainChar().updateGold(int(Battle.myPvEReward[_loc1_].replace("gold","")));
            }
            else
            {
               _loc3_.push(Battle.myPvEReward[_loc1_]);
            }
            _loc1_++;
         }
         battleMc["skin_0_reward"]["scoreTxt"]["txt"].text = Battle.myPvEScore;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            if(_loc1_ < _loc3_.length)
            {
               battleMc["skin_0_reward"]["rewardIcon_" + _loc1_].visible = true;
               Central.main.showIconData(battleMc["skin_0_reward"]["rewardIcon_" + _loc1_],_loc3_[_loc1_],"1",false);
            }
            else
            {
               battleMc["skin_0_reward"]["rewardIcon_" + _loc1_].visible = false;
            }
            _loc1_++;
         }
         Toolkit.addInventoryByArray(_loc3_,null);
         Central.main.disableButton(battleMc["skin_0_reward"]["shareBtn"],onBackBtn);
         Central.main.initButton(battleMc["skin_0_reward"]["shareBtn"],onBackBtn,AppData.lang == AppData.ZH ? "確定" : "OK");
         Main.updateMenu(false);
      }
      
      public static function onShowPvPaiBattleWin() : void
      {
         var _loc1_:Object = null;
         var _loc2_:Object = null;
         var _loc3_:Array = null;
         var _loc5_:Object = null;
         var _loc6_:Array = null;
         var _loc7_:Date = null;
         var _loc8_:String = null;
         _loc1_ = new Object();
         _loc2_ = new Object();
         _loc3_ = new Array();
         var _loc4_:Boolean = false;
         _loc5_ = new Object();
         _loc6_ = new Array();
         _loc7_ = new Date();
         _loc6_[0] = new Object();
         _loc6_[1] = new Object();
         _loc6_[0].team_id = 1;
         _loc6_[0].win = 1;
         _loc6_[1].team_id = 2;
         _loc6_[1].win = 2;
         _loc5_.team = _loc6_;
         _loc5_.match_mode = "AI";
         _loc5_.num_in_row = 1;
         _loc5_.room_size = 1;
         _loc5_.battle_time = _loc7_.getTime() / 1000;
         _loc1_.battle = _loc5_;
         _loc1_.turnNum = 10;
         _loc1_.comment = [];
         _loc1_.startGameTime = "10000";
         _loc1_.endGameTime = "12000";
         _loc2_.char_id = int(Central.main.getMainChar().getData(DBCharacterData.ID));
         _loc2_.team_id = 1;
         _loc2_.disconnected = 0;
         _loc2_.rank = 1;
         _loc2_.lvl_avg = 1;
         _loc2_.daily_count = 1;
         _loc2_.stat_use_skill = "skill689";
         _loc3_[0] = _loc2_;
         _loc1_.chars = _loc3_;
         _loc8_ = com.adobe.serialization.json.JSON.stringify(_loc1_);
         Central.main.amfClient.service("PVPService.pvpFinishRecord",[Central.main.account.getAccountSessionKey(),_loc8_,0],onrealShowPvPaiBattleWin);
      }
      
      private static function onrealShowPvPaiBattleWin(param1:Object) : void
      {
         if(Central.main.validateAmfResponse(param1))
         {
            if(Central.main.HitAi != true)
            {
               return;
            }
            Battle.myCurrencyGain = param1.result.data.currency_gain_list[Main.getMainChar().getData(DBCharacterData.ID)];
            ++Main.getMainChar().pvpRecord[PvPData.PLAY];
            var _loc2_:Object = Main.getMainChar().pvpRecord;
            var _loc3_:String;
            var _loc4_:Number = _loc2_[_loc3_ = PvPData.WIN] + 1;
            _loc2_[_loc3_] = _loc4_;
            Battle.updatePvpaiwinBattleFinishResult();
            Main.achievement.updateBattleStat(Main.achievementData.LIVE_BATTLE_WIN,1);
            battleMc["lbl_rematch_title"].text = "";
            battleMc["lbl_rematch_title"].visible = false;
            battleMc["lbl_battle_result"].text = Central.main.langLib.get(183);
            disableButtonsOnRematchTimerCompleted();
            pvpWinLossPanelSomeoneLeft();
            if(battleMc["lbl_rematch_title"])
            {
               battleMc["lbl_rematch_title"].text = Battle.getPvpWinLossPanelMessage();
            }
            Central.main.HitAi = false;
            Central.main.afterHitAi = true;
            battleMc["backBtn"].addEventListener(MouseEvent.CLICK,onBackBtn);
         }
      }
      
      private static function onpvploading(param1:Object) : void
      {
      }
      
      public static function onShowPvPaiBattleLose() : void
      {
         var _loc1_:Object = null;
         var _loc2_:Object = null;
         var _loc3_:Array = null;
         var _loc5_:Object = null;
         var _loc6_:Array = null;
         var _loc7_:Date = null;
         var _loc8_:String = null;
         _loc1_ = new Object();
         _loc2_ = new Object();
         _loc3_ = new Array();
         var _loc4_:Boolean = false;
         _loc5_ = new Object();
         _loc6_ = new Array();
         _loc7_ = new Date();
         _loc6_[0] = new Object();
         _loc6_[1] = new Object();
         _loc6_[0].team_id = 1;
         _loc6_[0].win = 1;
         _loc6_[1].team_id = 2;
         _loc6_[1].win = 2;
         _loc5_.team = _loc6_;
         _loc5_.match_mode = "AI";
         _loc5_.num_in_row = 1;
         _loc5_.room_size = 1;
         _loc5_.battle_time = _loc7_.getTime() / 1000;
         _loc1_.battle = _loc5_;
         _loc1_.turnNum = 10;
         _loc1_.comment = [];
         _loc1_.startGameTime = "10000";
         _loc1_.endGameTime = "12000";
         _loc2_.char_id = int(Central.main.getMainChar().getData(DBCharacterData.ID));
         _loc2_.team_id = 2;
         _loc2_.disconnected = 0;
         _loc2_.rank = 1;
         _loc2_.lvl_avg = 1;
         _loc2_.daily_count = 1;
         _loc2_.stat_use_skill = "skill689";
         _loc3_[0] = _loc2_;
         _loc1_.chars = _loc3_;
         _loc8_ = com.adobe.serialization.json.JSON.stringify(_loc1_);
         Central.main.amfClient.service("PVPService.pvpFinishRecord",[Central.main.account.getAccountSessionKey(),_loc8_,0],onrealShowPvPaiBattleLose);
      }
      
      private static function onrealShowPvPaiBattleLose(param1:Object) : void
      {
         if(Central.main.validateAmfResponse(param1))
         {
            if(Central.main.HitAi != true)
            {
               return;
            }
            Battle.myCurrencyGain = param1.result.data.currency_gain_list[Main.getMainChar().getData(DBCharacterData.ID)];
            Central.main.socket.sendailoseData();
            ++Main.getMainChar().pvpRecord[PvPData.PLAY];
            ++Main.getMainChar().pvpRecord[PvPData.LOSE];
            Battle.updatePvpailoseBattleFinishResult();
            battleMc["lbl_rematch_title"].text = "";
            battleMc["lbl_rematch_title"].visible = false;
            battleMc["lbl_battle_result"].text = Central.main.langLib.get(347);
            disableButtonsOnRematchTimerCompleted();
            pvpWinLossPanelSomeoneLeft();
            if(battleMc["lbl_rematch_title"])
            {
               battleMc["lbl_rematch_title"].text = Battle.getPvpWinLossPanelMessage();
            }
            Central.main.HitAi = false;
            Central.main.afterHitAi = true;
            battleMc["backBtn"].addEventListener(MouseEvent.CLICK,onBackBtn);
         }
      }
      
      public static function onShowPvPBattleWin() : void
      {
         if(Battle.type != TYPE_NETWORK)
         {
            return;
         }
         ++Main.getMainChar().pvpRecord[PvPData.PLAY];
         ++Main.getMainChar().pvpRecord[PvPData.WIN];
         Battle.updatePvpBattleFinishResult();
         Main.achievement.updateBattleStat(Main.achievementData.LIVE_BATTLE_WIN,1);
         battleMc["lbl_rematch_title"].text = "";
         battleMc["lbl_rematch_title"].visible = false;
         battleMc["lbl_battle_result"].text = Central.main.langLib.get(183);
         if(Central.main.PvpPlayerPost == "quick")
         {
            battleMc["lbl_rematch_title"].text = "";
            battleMc["lbl_rematch_title"].visible = true;
            enableButtonsOnRematchRequest();
            battleMc.startRematchCountdown(REMATCH_TIME_LIMIT);
            if(Central.main.PvphavePlayerDisconnect)
            {
               disableButtonsOnRematchTimerCompleted();
               pvpWinLossPanelSomeoneLeft();
               if(battleMc["lbl_rematch_title"])
               {
                  battleMc["lbl_rematch_title"].text = Battle.getPvpWinLossPanelMessage();
               }
            }
         }
         else
         {
            battleMc["defeatBarTxt"].visible = false;
            battleMc["signalMc"].visible = false;
            battleMc["okBtn"].visible = false;
            battleMc["noBtn"].visible = false;
            battleMc["backBtn"].visible = true;
            battleMc["lbl_rematch_title"].visible = true;
            battleMc["backBtn"].addEventListener(MouseEvent.CLICK,onBackBtn);
         }
      }
      
      public static function onShowPvPBattleLose() : void
      {
         if(Battle.type != TYPE_NETWORK)
         {
            return;
         }
         ++Main.getMainChar().pvpRecord[PvPData.PLAY];
         ++Main.getMainChar().pvpRecord[PvPData.LOSE];
         Battle.updatePvpBattleFinishResult();
         battleMc["lbl_rematch_title"].text = "";
         battleMc["lbl_rematch_title"].visible = false;
         battleMc["lbl_battle_result"].text = Central.main.langLib.get(347);
         if(Central.main.PvpPlayerPost == "quick")
         {
            battleMc["lbl_rematch_title"].text = "";
            battleMc["lbl_rematch_title"].visible = true;
            enableButtonsOnRematchRequest();
            battleMc.startRematchCountdown(REMATCH_TIME_LIMIT);
            battleMc["lbl_disconnect"].visible = false;
            if(Battle.pvpshowMyDisconnectText)
            {
               battleMc["lbl_disconnect"].visible = true;
               Battle.pvpshowMyDisconnectText = false;
               battleMc["lbl_disconnect"].text = AppData.lang == AppData.ZH ? "你已經斷線,請檢查你的網絡" : "Disconnect";
            }
            if(Central.main.PvphavePlayerDisconnect)
            {
               disableButtonsOnRematchTimerCompleted();
               pvpWinLossPanelSomeoneLeft();
               if(battleMc["lbl_rematch_title"])
               {
                  battleMc["lbl_rematch_title"].text = Battle.getPvpWinLossPanelMessage();
               }
            }
         }
         else
         {
            battleMc["defeatBarTxt"].visible = false;
            battleMc["signalMc"].visible = false;
            battleMc["okBtn"].visible = false;
            battleMc["noBtn"].visible = false;
            battleMc["backBtn"].visible = true;
            battleMc["lbl_rematch_title"].visible = false;
            battleMc["backBtn"].addEventListener(MouseEvent.CLICK,onBackBtn);
            battleMc["okBtn"].addEventListener(MouseEvent.CLICK,onOkBtn);
            battleMc["noBtn"].addEventListener(MouseEvent.CLICK,onNoBtn);
         }
      }
      
      public static function onOkBtn(param1:MouseEvent) : void
      {
         battleMc["okBtn"].removeEventListener(MouseEvent.CLICK,onOkBtn);
         battleMc["noBtn"].removeEventListener(MouseEvent.CLICK,onNoBtn);
         battleMc["okBtn"].alpha = 0.5;
         battleMc["okBtn"].filters = [CreateFilter.getSaturationFilter(0.5)];
         battleMc["okBtn"].enabled = false;
         battleMc["noBtn"].alpha = 0.5;
         battleMc["noBtn"].filters = [CreateFilter.getSaturationFilter(0.5)];
         battleMc["noBtn"].enabled = false;
         pvpWinLossPanelPressedOk();
         if(battleMc["lbl_rematch_title"] != null)
         {
            battleMc["lbl_rematch_title"].text = getPvpWinLossPanelMessage();
         }
         sendResetBattleMessage();
         ++rematchTimes;
         Main.socket.rematch();
      }
      
      public static function onNoBtn(param1:MouseEvent) : void
      {
         if(Central.main.PvpPlayerPost == "quick" || Central.main.PvpPlayerPost == "tournament")
         {
            Central.main.socket.leaveRoom();
         }
         battleFinish();
         Main.battleWin();
      }
      
      public static function onBackBtn(param1:MouseEvent) : void
      {
         Out.debug("battle","onBackBtn PvpPlayerPost >> " + Central.main.PvpPlayerPost);
         if(Central.main.PvpPlayerPost == "quick" || Central.main.PvpPlayerPost == "tournament" || Central.main.PvpPlayerPost == "PVE")
         {
            Central.main.socket.leaveRoom();
         }
         battleFinish();
         Main.battleWin();
         if(Central.main.afterHitAi == true)
         {
            Central.main.tracking.trackBuildingSelect("Arena-LivePvP");
            Central.main.tracking.trackBuildingSelect("Arena-LivePvP-Exact");
            Central.main.proc.streamStartEvents();
            Central.main.openArenaAfterTimetable = false;
            Central.panel.getInstance().show("arena");
         }
      }
      
      public static function showRematch(param1:uint) : void
      {
         pvpWinLossPanelSomeoneWantRematch();
         if(battleMc["lbl_rematch_title"])
         {
            battleMc["lbl_rematch_title"].text = getPvpWinLossPanelMessage();
         }
      }
      
      public static function updatePvpRematchPanel() : void
      {
         if(battleMc["lbl_rematch_title"])
         {
            battleMc["lbl_rematch_title"].text = getPvpWinLossPanelMessage();
         }
         switch(getPvpWinLossPanelStatus())
         {
            case "allow_go_away":
               disableButtonsOnRematchTimerCompleted();
               break;
            case "confirmed":
               disableButtonsNoExitOnRematchTimerCompleted();
               break;
            case "unstated":
               enableButtonsOnRematchRequest();
         }
      }
      
      public static function showDisconnect() : void
      {
         battleMc["backBtn"].visible = true;
         battleMc["backBtn"].addEventListener(MouseEvent.CLICK,onBackBtn);
         battleMc["rematchMc"].visible = false;
         battleMc["okBtn"].visible = false;
         battleMc["noBtn"].visible = false;
         Main.showInfo(Main.langLib.get(214));
      }
      
      public static function battleFinish() : void
      {
         var i:uint = 0;
         var enemy:* = undefined;
         var teamate:* = undefined;
         var pet:* = undefined;
         var hairColorArr_all:Array = null;
         var skinColorArr_all:Array = null;
         var countryAreaMatch:Array = null;
         battleMc.stage.focus = null;
         try
         {
            if(battleMc != null)
            {
               battleMc.gotoAndStop(Timeline.IDLE);
            }
         }
         catch(e:Error)
         {
            Out.error("Battle","battleFinish :: Step 1 :: " + e.getStackTrace());
            Main.submitLogDump();
         }
         try
         {
            Main.getMainChar().resetBattleData();
            Main.getMainChar().removeParent();
            Main.getMainChar().setCharMc(null);
         }
         catch(e:Error)
         {
            Out.error("Battle","battleFinish :: Step 2 :: " + e.getStackTrace());
            Main.submitLogDump();
         }
         try
         {
            if(enemyArr != null)
            {
               i = 0;
               while(i < enemyArr.length)
               {
                  enemy = enemyArr[i];
                  enemy.resetBattleData();
                  enemy.removeParent();
                  enemy.setCharMc(null);
                  i++;
               }
            }
            if(partyArr)
            {
               i = 0;
               while(i < partyArr.length)
               {
                  teamate = partyArr[i];
                  teamate.resetBattleData();
                  teamate.removeParent();
                  teamate.setCharMc(null);
                  i++;
               }
            }
            if(petArr)
            {
               i = 0;
               while(i < petArr.length)
               {
                  pet = petArr[i];
                  pet.resetBattleData();
                  pet.removeParent();
                  pet.setCharMc(null);
                  pet.resetSkillCooldown();
                  i++;
               }
            }
         }
         catch(e:Error)
         {
            Out.error("Battle","battleFinish :: Step 3 :: " + e.getStackTrace());
            Main.submitLogDump();
         }
         try
         {
            if(onBattleMusic)
            {
               Central.main.mixer.stopMusic();
               onBattleMusic = false;
            }
         }
         catch(e:Error)
         {
            Out.error("Battle","battleFinish :: Step 4.1 :: " + e.getStackTrace());
         }
         try
         {
            Main.mapMenu.hideChatInput();
         }
         catch(e:Error)
         {
            Out.error("Battle","battleFinish :: Step 5 :: " + e.getStackTrace());
            Main.submitLogDump();
         }
         try
         {
            GF.removeAllChild(battleMc["displayHolder"]);
            GF.removeAllChild(battleMc["specialHolder"]);
            enemyArr = null;
            partyArr = null;
            petArr = null;
            attacker = null;
            defender = null;
            selectedTarget = null;
            battleMc = null;
            consumablesUsed = 0;
            rematchTimes = 0;
            battleResult = 0;
            repGain = 0;
            bossId = "";
            use_seal_enemy = false;
            seal_enemy = false;
            spy_enemy = false;
            Central.main.battleRuleArr = [];
            Central.main.actionChecker = true;
            Central.main.battleId = "";
            Central.main.battleModeSpecial = false;
            isPartyControllable = false;
            pvpSyncLogSaved = false;
            pvpLogTimeSaved = false;
            specialHpData = {};
            battleRoundCounter = 0;
            battleDamageLog = 0;
            if(Central.main.senjutsuFeature)
            {
               Central.main.senninModeBtn.visible = false;
               Central.main.senninModeBtn.mouseEnabled = false;
               Central.main.senninModeBtn.mouseChildren = false;
            }
         }
         catch(e:Error)
         {
            Out.error("Battle","battleFinish :: Step 4.2 :: " + e.getStackTrace());
            Main.submitLogDump();
         }
         if(Battle.type == TYPE_NETWORK)
         {
            try
            {
               if(Central.main.account.getAccountType() == Central.main.account.PREMIUM)
               {
                  Central.main.tracking.generalTrack(Central.main.tracking.TRACK_PVP,Central.main.getMainChar().getLevel(),Central.main.tracking.TRACK_COMPLETE + "Premuim");
               }
               else
               {
                  Central.main.tracking.generalTrack(Central.main.tracking.TRACK_PVP,Central.main.getMainChar().getLevel(),Central.main.tracking.TRACK_COMPLETE + "Free");
               }
               if(Central.main.PvpPlayerPlace == "quick")
               {
                  Central.main.tracking.generalTrack(Central.main.tracking.TRACK_PVP,Central.main.PvpQMMode,Central.main.tracking.TRACK_PVP_QUICK_MATCH_FINISH);
               }
               else if(Central.main.PvpPlayerPlace == "private")
               {
                  Central.main.tracking.generalTrack(Central.main.tracking.TRACK_PVP,Central.main.PvpPVMode,Central.main.tracking.TRACK_PVP_PRIVATE_FINISH);
               }
            }
            catch(err:Error)
            {
               Out.error("Battle","battleFinish :: TRACKING - TRACK_PVP(TRACK_COMPLETE)");
            }
            finish_battle_time = int(getTimeStamp());
            whole_battle_time = finish_battle_time - start_battle_time;
         }
         if(Boolean(Central.main.isNewChar) && Boolean(Central.main.isNewCharByCreate))
         {
            Central.main.isNewChar = false;
            hairColorArr_all = Data.getHairColorArr();
            skinColorArr_all = Data.getSkinColorArr();
            countryAreaMatch = [[7,2],[7,7],[1,0],[7,6],[0,0]];
            Central.main.showAmfLoading();
            Central.main.amfClient.service("CharacterDAO.createCharacter",[Account.getAccountSessionKey(),Central.main.getDBChar().character_name,Central.main.getDBChar().character_gender,hairColorArr_all.indexOf(Central.main.getMainChar().getData("character_hair_color")),skinColorArr_all.indexOf(Central.main.getMainChar().getData("character_skin_color")),Central.main.getDBChar().character_hair.replace("hair_",""),Central.main.getDBChar().character_face.replace("face_","")],onAmfCreateCharacter);
         }
         else
         {
            Main.achievement.flushBattleStat();
         }
      }
      
      private static function onAmfCreateCharacter(param1:Object) : void
      {
         if(Main.validateAmfResponse(param1))
         {
            Central.main.getDBChar().character_id = param1.character_id;
            Central.main.amfClient.service("SystemData.getCreateCharacter",[Account.getAccountSessionKey(),Data.TEST_VERSION],onAmfGetCreateCharacter);
         }
      }
      
      private static function onAmfGetCreateCharacter(param1:Object) : void
      {
         var _loc2_:String = null;
         if(Central.main.dataParser.parseSystemData(param1))
         {
            _loc2_ = Central.main.getHash(String(Central.main.getMainChar().xp));
            Central.main.amfClient.service("CharacterDAO.getExtraData",[Account.getAccountSessionKey(),_loc2_,Central.main.ACCESS_TOKEN],getExtraDataResult);
         }
      }
      
      private static function getExtraDataResult(param1:Object) : void
      {
         var _loc2_:Object = null;
         if(Main.validateAmfResponse(param1))
         {
            _loc2_ = param1.result as Object;
            if(Central.main.dataParser.parseCharacterData(_loc2_))
            {
               if(_loc2_.char_login_per_day == 0)
               {
                  Central.main.tracking.trackAppLang(Central.main.tracking.TRACK_APP_LANG);
                  Central.main.tracking.trackACBalance(Central.main.tracking.TRACK_GOLD);
                  if(Account.getAccountType() == Account.FREE)
                  {
                     Central.main.tracking.trackClick2(Central.main.tracking.TRACK_LOGIN,Central.main.tracking.TRACK_FREE + Central.main.tracking.TRACK_UNIQUE);
                     Central.main.tracking.generalTrack(Central.main.tracking.TRACK_LONGIN_LV,Central.main.getMainChar().getLevel());
                  }
               }
               if(Environment.IS_IN_BROWSER)
               {
                  Central.main.initRank();
               }
               Central.main.hideAmfLoading();
               Central.main.amfClient.service("CharacterService.selectFreeSkill",[Central.main.account.getAccountSessionKey(),Central.main.getDBChar().character_skills[0]],Central.main.onAmfResult);
            }
            else
            {
               Out.error("main","getExtraDataResult :: parseCharacterData failed");
            }
         }
      }
      
      public static function updateSPButton() : void
      {
         var _loc1_:Object = null;
         var _loc2_:Boolean = false;
         if(Central.main.senjutsuFeature)
         {
            if(Main.getMainChar().getData(DBCharacterData.SP) >= Main.getMainChar().maxSP && !Main.getMainChar().isBattleBuffActive(BloodlineData.EFFECT_SKIP_DEAD_CLEAR_DEBUFF))
            {
               Main.updateMenu();
               _loc1_ = Central.battle.getAttacker().getBattleAction();
               _loc2_ = false;
               if(Boolean(_loc1_) && _loc1_.debuffOverride == true)
               {
                  _loc2_ = true;
               }
               if(isActionBarShow && !_loc2_)
               {
                  Central.main.senninModeBtn.visible = true;
                  Central.main.senninModeBtn.mouseEnabled = true;
                  Central.main.senninModeBtn.mouseChildren = true;
                  Central.main.senninModeBtn.buttonMode = true;
                  Central.main.senninModeBtn.filters = null;
               }
               else
               {
                  Central.main.senninModeBtn.visible = true;
                  Central.main.senninModeBtn.mouseEnabled = false;
                  Central.main.senninModeBtn.mouseChildren = false;
                  Central.main.senninModeBtn.buttonMode = false;
                  if(!_loc2_)
                  {
                     Central.main.senninModeBtn.filters = null;
                  }
                  else
                  {
                     Central.main.senninModeBtn.filters = [dimFilter];
                  }
               }
            }
            else
            {
               Central.main.senninModeBtn.visible = true;
               Central.main.senninModeBtn.mouseEnabled = false;
               Central.main.senninModeBtn.mouseChildren = false;
               Central.main.senninModeBtn.buttonMode = false;
               Central.main.senninModeBtn.filters = [dimFilter];
            }
         }
      }
      
      public static function enableSPButton() : void
      {
         updateSPButton();
      }
      
      public static function disableSPButton() : void
      {
         Central.main.senninModeBtn.mouseEnabled = false;
         Central.main.senninModeBtn.mouseChildren = false;
         Central.main.senninModeBtn.buttonMode = false;
      }
      
      private static function onPlayerCommand() : void
      {
         var _loc1_:* = undefined;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         _loc1_ = Central.battle.getAttacker();
         _loc1_.showCmdDisplay();
         enableTargetSelection();
         battleMc["actionBar"].show();
         isActionBarShow = true;
         if(Main.battleModeSpecial && Main.battleModeSpecial == true)
         {
            _loc2_ = Math.ceil(defender.hp / defender.maxHP * 100);
            _loc3_ = Math.floor(defender.hp / defender.maxHP * 100);
            if(Main.battleModeSpecial && Main.battleModeSpecial == true && _loc2_ >= Central.main.battleRuleArr[0].amount_over && _loc3_ <= Central.main.battleRuleArr[0].amount_less)
            {
               specialHpData.showGlowBackground = true;
            }
            else
            {
               specialHpData.showGlowBackground = false;
            }
            if(!((Central.main.getMainChar() as Character).isBattleDebuffActive(BattleData.EFFECT_STUN) || (Central.main.getMainChar() as Character).isBattleDebuffActive(BattleData.EFFECT_SLEEP) || (Central.main.getMainChar() as Character).isBattleDebuffActive(BattleData.EFFECT_FEAR) || (Central.main.getMainChar() as Character).isBattleDebuffActive(BattleData.EFFECT_CHAOS)))
            {
               Main.showPopupSpecialHpBar(specialHpData);
            }
         }
         if(!isPlayingSkillAnimation)
         {
            Main.enableMenu();
         }
         enableSPButton();
         refreshGearBtn();
      }
      
      private static function refreshGearBtn() : void
      {
         bGearBtnEnabled = true;
         if((Central.main.getMainChar() as Character).isBattleDebuffActive(BattleData.EFFECT_STUN) || (Central.main.getMainChar() as Character).isBattleDebuffActive(BattleData.EFFECT_SLEEP) || (Central.main.getMainChar() as Character).isBattleDebuffActive(BattleData.EFFECT_FEAR) || (Central.main.getMainChar() as Character).isBattleDebuffActive(BattleData.EFFECT_CHAOS) || Central.main.PvpPlayerPost == "PVE")
         {
            bGearBtnEnabled = false;
         }
         if(selectedPartySkillID != -1)
         {
            bGearBtnEnabled = false;
         }
         if(bGearBtnEnabled)
         {
            Main.enableGearBtn();
         }
         else
         {
            Main.disableGearBtn();
         }
      }
      
      private static function refreshPartySelectCancelBtnPosition() : void
      {
         var _loc1_:MovieClip = null;
         var _loc2_:int = 0;
         var _loc3_:MovieClip = null;
         var _loc4_:MovieClip = null;
         if(battleMc == null)
         {
            return;
         }
         _loc1_ = battleMc["actionBar"];
         if(_loc1_ == null)
         {
            return;
         }
         _loc2_ = 0;
         while(_loc2_ < 8)
         {
            _loc3_ = _loc1_["skill_" + _loc2_];
            if(_loc3_ != null)
            {
               _loc4_ = MovieClip(_loc3_.getChildByName("redcross"));
               if(_loc4_ != null)
               {
                  _loc4_.visible = _loc2_ == selectedPartySkillID;
               }
            }
            _loc2_++;
         }
      }
      
      public static function onPass() : void
      {
         if(selectedPartySkillID != -1)
         {
            disablePartySelection();
         }
         onBattle();
         Character(attacker).setPlayerCommand("pass");
         whattodo = 1;
         sendCommand();
      }
      
      public static function onAttack(param1:Event) : void
      {
         if(Mission.curMissionID == "msn0" && Boolean(Central.main.isNewAccount))
         {
            Central.main.tracking.generalTrack(Central.main.tracking.TRACK_CREATE_CHAR,"Attack","Step9");
            Central.main.amfClient.service("Tracking.tutTracking",[Central.main.account.getAccountSessionKey(),"STEP9"],trackingResponse);
         }
         if(selectedPartySkillID != -1)
         {
            Main.showInfo(String(Central.main.langLib.get(1801)[0]));
            return;
         }
         if(!Central.main.isNewChar)
         {
            if(attacker.getCharacterId() == Main.getMainChar().getCharacterId())
            {
               Main.achievement.updateBattleStat(Main.achievementData.USE_WEAPON,1);
            }
         }
         if(attacker.isBattleDebuffActive(BloodlineData.EFFECT_MERIDIAN_BLOCK))
         {
            Main.showInfo(Central.main.langLib.get(797));
            return;
         }
         if(attacker.isBattleDebuffActive(BattleData.EFFECT_PARALYZE))
         {
            Main.showInfo(Central.main.langLib.get(797));
            return;
         }
         if(attacker.isBattleDebuffActive(BattleData.EFFECT_DISMANTLE))
         {
            Main.showInfo(Central.main.langLib.get(797));
            return;
         }
         if(attacker.isBattleDebuffActive(BattleData.EFFECT_PARALYZE))
         {
            Main.showInfo(Central.main.langLib.get(2050));
            return;
         }
         if(attacker.isBattleDebuffActive(BattleData.SKILL_341))
         {
            Main.showInfo(Central.main.langLib.get(797));
            return;
         }
         onBattle();
         Character(attacker).setPlayerCommand("weapon_attack");
         whattodo = 2;
         sendCommand();
      }
      
      public static function onCharge(param1:Event) : void
      {
         if(Mission.curMissionID == "msn0" && Boolean(Central.main.isNewAccount))
         {
            Central.main.tracking.generalTrack(Central.main.tracking.TRACK_CREATE_CHAR,"Charge","Step7");
            Central.main.amfClient.service("Tracking.tutTracking",[Central.main.account.getAccountSessionKey(),"STEP7"],trackingResponse);
         }
         if(selectedPartySkillID != -1)
         {
            Main.showInfo(String(Central.main.langLib.get(1801)[0]));
            return;
         }
         if(attacker.isBattleDebuffActive(BattleData.EFFECT_MERIDIANS_SEAL))
         {
            Main.showInfo(Central.main.langLib.get(526));
            return;
         }
         if(attacker.isBattleDebuffActive(BattleData.EFFECT_PARALYZE))
         {
            Main.showInfo(Central.main.langLib.get(2050));
            return;
         }
         if(attacker.isBattleDebuffActive(BattleData.EFFECT_RESTRICT_CHARGE))
         {
            Main.showInfo(Central.main.langLib.get(796));
            return;
         }
         if(attacker.isBattleBuffActive(BattleData.EFFECT_EXCITATION_CHARGE))
         {
            Main.showInfo(Central.main.langLib.get(621));
            return;
         }
         if(attacker.isBattleDebuffActive(BloodlineData.EFFECT_RESTRICT_CHARGE))
         {
            Main.showInfo(Central.main.langLib.get(796));
            return;
         }
         onBattle();
         Character(attacker).setPlayerCommand("charge");
         whattodo = 3;
         sendCommand();
      }
      
      public static function onSkill(param1:Event) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:Array = null;
         var _loc4_:Object = null;
         var _loc5_:Boolean = false;
         var _loc6_:int = 0;
         if(Mission.curMissionID == "msn0" && Boolean(Central.main.isNewAccount))
         {
            if(Central.main.tutorialMsnStep == 0)
            {
               Central.main.tracking.generalTrack(Central.main.tracking.TRACK_CREATE_CHAR,"Skill","Step6");
               Central.main.amfClient.service("Tracking.tutTracking",[Central.main.account.getAccountSessionKey(),"STEP6"],trackingResponse);
            }
            else if(Central.main.tutorialMsnStep == 1)
            {
               Central.main.tracking.generalTrack(Central.main.tracking.TRACK_CREATE_CHAR,"Skill","Step8");
               Central.main.amfClient.service("Tracking.tutTracking",[Central.main.account.getAccountSessionKey(),"STEP8"],trackingResponse);
            }
         }
         _loc2_ = uint(int(String(param1.currentTarget.name).split("_")[1]));
         if(selectedPartySkillID == _loc2_)
         {
            disablePartySelection();
            _loc6_ = 0;
            while(_loc6_ < enemyArr.length)
            {
               if(!enemyArr[_loc6_].isDead)
               {
                  enemyArr[_loc6_].enableSelection();
               }
               else
               {
                  enemyArr[_loc6_].diableSelection();
               }
               enemyArr[_loc6_].hideSelection();
               _loc6_++;
            }
            if(defaultTarget)
            {
               selectedTarget = defaultTarget;
            }
            else
            {
               _loc6_ = 0;
               while(_loc6_ < enemyArr.length)
               {
                  if(!enemyArr[_loc6_].isDead)
                  {
                     selectedTarget = enemyArr[_loc6_];
                     break;
                  }
                  _loc6_++;
               }
            }
            selectedTarget.displaySelection();
            defender = selectedTarget;
            return;
         }
         _loc3_ = Central.main.getMainChar().getSkillListArr();
         _loc4_ = Main.SKILL_DATA[_loc3_[_loc2_]];
         if(_loc3_[_loc2_])
         {
            switch(_loc4_.target)
            {
               case SkillData.TARGET_SINGLE_FRIENDLY:
                  if(partyArr.length < 1)
                  {
                     Main.showInfo(String(Central.main.langLib.get(1801)[1]));
                     return;
                  }
                  _loc5_ = false;
                  _loc6_ = 0;
                  while(_loc6_ < partyArr.length)
                  {
                     if(!partyArr[_loc6_].isDead)
                     {
                        _loc5_ = true;
                        break;
                     }
                     _loc6_++;
                  }
                  if(!_loc5_)
                  {
                     Main.showInfo(String(Central.main.langLib.get(1801)[1]));
                     return;
                  }
                  if(selectedPartySkillID == -1 && Character(attacker).setPlayerCommand("skill",_loc2_))
                  {
                     selectedPartySkillID = _loc2_;
                     enablePartySelection();
                     return;
                  }
            }
         }
         if(selectedPartySkillID == -1)
         {
            if(Character(attacker).setPlayerCommand("skill",_loc2_))
            {
               onBattle();
               whattodo = 4;
               sendCommand();
            }
         }
         else
         {
            Main.showInfo(String(Central.main.langLib.get(1801)[0]));
         }
      }
      
      public static function enableSageMode() : Boolean
      {
         if(attacker.sp == attacker.maxSP)
         {
            return true;
         }
         return false;
      }
      
      public static function onDodge(param1:Event) : void
      {
         if(selectedPartySkillID != -1)
         {
            Main.showInfo(String(Central.main.langLib.get(1801)[0]));
            return;
         }
         onBattle();
         Character(attacker).setPlayerCommand("dodge");
         whattodo = 5;
         sendCommand();
      }
      
      public static function onClassSkill(param1:Event) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:Array = null;
         _loc2_ = uint(int(String(param1.currentTarget.name).split("_")[1]));
         _loc3_ = Central.main.getMainChar().getClassSkillListArr();
         if(selectedPartySkillID != -1)
         {
            Main.showInfo(String(Central.main.langLib.get(1801)[0]));
            return;
         }
         if((attacker as Character).getIsClassSkillAvailable(_loc2_ - 1) && _loc3_[_loc2_ - 1] != "skill2002")
         {
            (attacker as Character).setIsClassSkillAvailable(_loc2_ - 1,false);
            onBattle();
            attacker.setPlayerCommand("class_skill",_loc3_[_loc2_ - 1]);
            whattodo = 6;
            sendCommand();
         }
      }
      
      public static function onClassSkillMouseOver(param1:Event) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:Array = null;
         var _loc4_:* = undefined;
         _loc2_ = uint(int(String(param1.currentTarget.name).split("_")[1]));
         _loc3_ = Central.main.getMainChar().getClassSkillListArr();
         if(_loc3_[_loc2_ - 1] == "skill2002")
         {
            _loc4_ = 0;
            while(_loc4_ < enemyArr.length)
            {
               enemyArr[_loc4_].showClassSkillDetail();
               _loc4_++;
            }
         }
      }
      
      public static function onClassSkillMouseOut(param1:Event) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:Array = null;
         var _loc4_:* = undefined;
         _loc2_ = uint(int(String(param1.currentTarget.name).split("_")[1]));
         _loc3_ = Central.main.getMainChar().getClassSkillListArr();
         if(_loc3_[_loc2_ - 1] == "skill2002")
         {
            _loc4_ = 0;
            while(_loc4_ < enemyArr.length)
            {
               enemyArr[_loc4_].hideClassSkillDetail();
               _loc4_++;
            }
         }
      }
      
      private static function triggerSkill2002() : void
      {
         var _loc1_:MovieClip = null;
         isPlayingSkillAnimation = true;
         Central.main.disableMenu();
         _loc1_ = Skill.getSpecialEffect("skill2002");
         addSpecialEffect(_loc1_);
      }
      
      public static function onRun(param1:MouseEvent) : void
      {
         if(selectedPartySkillID != -1)
         {
            Main.showInfo(String(Central.main.langLib.get(1801)[0]));
            return;
         }
         if(Battle.type == TYPE_NETWORK || Central.main.HitAi == true)
         {
            Main.showInfo(Central.main.langLib.get(343));
            return;
         }
         if(Mission.curMissionID == "msn0")
         {
            onBattle();
            Character(attacker).setPlayerCommand("item","item1");
            whattodo = 7;
            sendCommand();
         }
         else
         {
            Main.showConfirmation(Central.main.langLib.get(285),checkRun,new Function());
         }
      }
      
      public static function checkRun() : void
      {
         var _loc1_:Number = NaN;
         _loc1_ = NumberUtil.getRandom();
         if(_loc1_ < BattleData.BATTLE_RUN_CHANGE)
         {
            Main.achievement.updateBattleStat(Main.achievementData.RUN,1);
            onBattle();
            Character(attacker).setPlayerCommand("item","item1");
            whattodo = 7;
            sendCommand();
         }
         else
         {
            Main.showInfo(Central.main.langLib.get(345));
            onBattle();
            Character(attacker).setPlayerCommand("pass");
            actionFinish_CB();
         }
      }
      
      public static function useItem(param1:String) : void
      {
         var check:String = null;
         var numberToHash:uint = 0;
         var scrollMc:String = null;
         var i:int = 0;
         var itemId:String = param1;
         check = Sha1Encrypt.encrypt(consumablesUsed.toString());
         if(check != consumablesUsedHash)
         {
            return;
         }
         numberToHash = Math.round(consumablesUsed + 0);
         if(consumablesUsed >= BattleData.CONSUMABLE_LIMIT)
         {
            Main.showInfo(String(Central.main.langLib.get(339)).replace("[valconsumablelimit]",BattleData.CONSUMABLE_LIMIT.toString()));
            return;
         }
         if(Battle.type == TYPE_NETWORK || Central.main.HitAi == true)
         {
            ++consumablesUsed;
            numberToHash++;
            consumablesUsedHash = Sha1Encrypt.encrypt(numberToHash.toString());
            scrollMc = "";
            if(Central.main.PvpBattleType == "quickMatch" || Central.main.PvpPlayerPost == "tournament" || Central.main.HitAi == true)
            {
               scrollMc = "scrollDisplayMc_1";
            }
            if(Central.main.PvpBattleType == "private")
            {
               i = 0;
               while(i < Central.main.PvpPVMode)
               {
                  if(Central.main.PvpTeamA[i] == Main.getMainChar().getData(DBCharacterData.ID))
                  {
                     scrollMc = "scrollDisplayMc_" + (i + 1);
                  }
                  if(Central.main.PvpTeamB[i] == Main.getMainChar().getData(DBCharacterData.ID))
                  {
                     scrollMc = "scrollDisplayMc_" + (i + 1);
                  }
                  i++;
               }
            }
            battleMc[scrollMc]["scroll_" + consumablesUsed].gotoAndStop(2);
            try
            {
               Central.main.tracking.generalTrack(Central.main.tracking.TRACK_PVP,itemId,Central.main.tracking.TRACK_ITEM_USED);
            }
            catch(err:Error)
            {
               Out.error("Battle","useItem :: TRACKING - TRACK_PVP(TRACK_ITEM_USED)");
            }
         }
         onBattle();
         attacker.setPlayerCommand("item",itemId);
         if(Main.checkUseTokenInsteadItem)
         {
            Main.checkUseTokenInsteadItem = false;
         }
         else
         {
            Main.getMainChar().addUsedBattleItem(itemId);
         }
         whattodo = 7;
         sendCommand();
      }
      
      private static function enableTargetSelection() : void
      {
         var _loc1_:uint = 0;
         _loc1_ = 0;
         while(_loc1_ < enemyArr.length)
         {
            if(!enemyArr[_loc1_].isDead)
            {
               if(Boolean(selectedTarget) && Boolean(defaultTarget))
               {
                  selectedTarget.hideSelection();
                  selectedTarget = defaultTarget;
                  defender = selectedTarget;
                  defaultTarget = null;
                  selectedTarget.displaySelection();
               }
               enemyArr[_loc1_].enableSelection();
            }
            _loc1_++;
         }
      }
      
      private static function disableTargetSelection() : void
      {
         var _loc1_:uint = 0;
         _loc1_ = 0;
         while(_loc1_ < enemyArr.length)
         {
            enemyArr[_loc1_].disableSelection();
            _loc1_++;
         }
      }
      
      private static function enablePartySelection() : void
      {
         var _loc1_:uint = 0;
         if(selectedTarget)
         {
            defaultTarget = selectedTarget;
            selectedTarget.hideSelection();
         }
         _loc1_ = 0;
         while(_loc1_ < partyArr.length)
         {
            if(!partyArr[_loc1_].isDead)
            {
               partyArr[_loc1_].enableSelection();
            }
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < partyArr.length)
         {
            if(!partyArr[_loc1_].isDead)
            {
               selectedTarget = partyArr[_loc1_];
               break;
            }
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < enemyArr.length)
         {
            enemyArr[_loc1_].disableSelection();
            _loc1_++;
         }
         selectedTarget.displaySelection();
         defender = selectedTarget;
         canSelectparty = true;
         refreshGearBtn();
         refreshPartySelectCancelBtnPosition();
      }
      
      private static function disablePartySelection() : void
      {
         var _loc1_:uint = 0;
         _loc1_ = 0;
         while(_loc1_ < partyArr.length)
         {
            partyArr[_loc1_].disableSelection();
            partyArr[_loc1_].hideSelection();
            _loc1_++;
         }
         canSelectparty = false;
         selectedPartySkillID = -1;
         refreshGearBtn();
         refreshPartySelectCancelBtnPosition();
      }
      
      private static function enablePetSelection() : void
      {
         var _loc1_:uint = 0;
         _loc1_ = 0;
         while(_loc1_ < petArr.length)
         {
            if(!petArr[_loc1_].isDead)
            {
               if(Boolean(selectedTarget) && Boolean(defaultTarget))
               {
                  selectedTarget.hideSelection();
                  selectedTarget = defaultTarget;
                  defender = selectedTarget;
                  defaultTarget = null;
                  selectedTarget.displaySelection();
               }
               petArr[_loc1_].enableSelection();
            }
            _loc1_++;
         }
      }
      
      private static function disablePetSelection() : void
      {
         var _loc1_:uint = 0;
         _loc1_ = 0;
         while(_loc1_ < petArr.length)
         {
            petArr[_loc1_].disableSelection();
            _loc1_++;
         }
      }
      
      private static function enableDeadSelection() : void
      {
         var _loc1_:uint = 0;
         canSelectpartyDead = true;
         _loc1_ = 0;
         while(_loc1_ < partyArr.length)
         {
            if(partyArr[_loc1_].isDead)
            {
               if(Boolean(selectedTarget) && defaultTarget == null)
               {
                  defaultTarget = selectedTarget;
                  selectedTarget.hideSelection();
               }
               selectedTarget = partyArr[_loc1_];
               selectedTarget.displaySelection();
               partyArr[_loc1_].enableSelection();
            }
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < enemyArr.length)
         {
            enemyArr[_loc1_].disableSelection();
            _loc1_++;
         }
      }
      
      private static function disableDeadSelection() : void
      {
         var _loc1_:uint = 0;
         canSelectpartyDead = false;
         _loc1_ = 0;
         while(_loc1_ < petArr.length)
         {
            petArr[_loc1_].disableSelection();
            _loc1_++;
         }
      }
      
      public static function selectTarget(param1:MouseEvent) : void
      {
         var _loc2_:* = undefined;
         var _loc3_:int = 0;
         _loc2_ = param1.currentTarget.char;
         if(!_loc2_.isDead)
         {
            if(selectedTarget)
            {
               selectedTarget.hideSelection();
            }
            selectedTarget = _loc2_;
            selectedTarget.displaySelection();
            defender = selectedTarget;
            if(canSelectparty)
            {
               holdTargetIsMember = selectedTarget;
               disablePartySelection();
               onBattle();
               whattodo = 8;
               sendCommand();
            }
         }
         else if(canSelectpartyDead)
         {
            if(selectedTarget)
            {
               selectedTarget.hideSelection();
            }
            selectedTarget = _loc2_;
            selectedTarget.displaySelection();
            defender = selectedTarget;
            defender.isDead = false;
            holdTargetIsMember = selectedTarget;
            disableDeadSelection();
            onBattle();
            whattodo = 8;
            sendCommand();
         }
      }
      
      private static function playAttack(param1:*, param2:Object, param3:Point) : void
      {
         param1.playAttack(param2,param3);
      }
      
      private static function playCharge(param1:*) : void
      {
         param1.playCharge();
      }
      
      private static function playSkill(param1:*, param2:Object, param3:Point) : void
      {
         param1.playSkill(param2,param3);
      }
      
      private static function playSkip(param1:*) : void
      {
         param1.playSkip();
      }
      
      private static function playClassSkill(param1:*, param2:Object, param3:Point) : void
      {
         param1.playClassSkill(param2,param3);
      }
      
      private static function playHit(param1:*) : void
      {
         if(!param1.isDead || param1.limb > 1)
         {
            param1.playHit();
         }
      }
      
      private static function playAction(param1:*, param2:String) : void
      {
         param1.playAction(param2);
      }
      
      private static function playBattleAction(param1:*, param2:Object, param3:Point) : void
      {
         param1.playBattleAction(param2,param3);
      }
      
      private static function playBloodline(param1:*, param2:Object, param3:Point) : void
      {
         param1.playBloodline(param2,param3);
      }
      
      private static function playSenjutsu(param1:*, param2:Object, param3:Point) : void
      {
         param1.playSenjutsu(param2,param3);
      }
      
      public static function enableButtons(param1:Array) : void
      {
         var _loc2_:uint = 0;
         _loc2_ = 0;
         while(_loc2_ < param1.length)
         {
            battleMc["actionBar"].enableButton(param1[_loc2_]);
            _loc2_++;
         }
      }
      
      public static function showTutorialTips(param1:String) : void
      {
         var _loc2_:MovieClip = null;
         var _loc3_:MovieClip = null;
         _loc2_ = Central.main.getMainMc();
         _loc2_["tutorialHintMc"].visible = true;
         _loc2_["tutorialHintMc"]["tutorialTipsMc"].gotoAndStop(param1);
         _loc3_ = _loc2_["tutorialHintMc"]["tutorialTipsMc"];
         _loc3_["lbl_tutorial_attack"].text = "";
         _loc3_["lbl_tutorial_useskill"].text = "";
         _loc3_["lbl_tutorial_charge"].text = "";
         _loc3_["lbl_tutorial_run"].text = "";
         _loc3_["lbl_tutorial_skill"].text = "";
         switch(param1)
         {
            case "attack":
               _loc2_["tutorialHintMc"]["tutorialTipsMc"]["lbl_tutorial_attack"].text = Central.main.langLib.get(411);
               break;
            case "charge":
               _loc2_["tutorialHintMc"]["tutorialTipsMc"]["lbl_tutorial_useskill"].text = Central.main.langLib.get(413);
               _loc2_["tutorialHintMc"]["tutorialTipsMc"]["lbl_tutorial_charge"].text = Central.main.langLib.get(412);
               break;
            case "run":
               _loc2_["tutorialHintMc"]["tutorialTipsMc"]["lbl_tutorial_run"].text = Central.main.langLib.get(414);
               break;
            case "skill":
               _loc2_["tutorialHintMc"]["tutorialTipsMc"]["lbl_tutorial_skill"].text = Central.main.langLib.get(415);
         }
      }
      
      public static function addSpecialEffect(param1:MovieClip) : void
      {
         Main.playBattleEffect(param1);
      }
      
      private static function removeSpecialEffect() : void
      {
         Main.removeBattleEffect();
      }
      
      public static function checkWeaponPurifyRestore(param1:*) : void
      {
         var _loc3_:Object = null;
         var _loc4_:Object = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc2_:Object = {};
         _loc3_ = Central.main.WEAPON_DATA.find(param1.getWeapon());
         if(_loc3_ != null)
         {
            if(_loc3_.effect.length > 0)
            {
               _loc5_ = 0;
               while(_loc5_ < _loc3_.effect.length)
               {
                  _loc4_ = _loc3_.effect[_loc5_];
                  if(_loc4_.type == BattleData.EFFECT_PURIFY_RESTORE_HP)
                  {
                     _loc6_ = Math.round(int(param1.maxHP) * (_loc4_.amount / 100));
                  }
                  _loc5_++;
               }
               if(_loc6_ > 0)
               {
                  param1.updateHP(_loc6_);
                  param1.showOverheadNumber(Timeline.HEAL,_loc6_);
               }
            }
         }
      }
      
      public static function checBackItemPurifyRestore(param1:*) : void
      {
         var _loc3_:Object = null;
         var _loc4_:Object = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc2_:Object = {};
         _loc3_ = Central.main.BACK_ITEM_DATA.find(param1.getBackItem());
         if(_loc3_ != null)
         {
            if(_loc3_.effect.length > 0)
            {
               _loc5_ = 0;
               while(_loc5_ < _loc3_.effect.length)
               {
                  _loc4_ = _loc3_.effect[_loc5_];
                  if(_loc4_.type == BattleData.EFFECT_PURIFY_RESTORE_HP)
                  {
                     _loc6_ = Math.round(int(param1.maxHP) * (_loc4_.amount / 100));
                  }
                  _loc5_++;
               }
               if(_loc6_ > 0)
               {
                  param1.updateHP(_loc6_);
                  param1.showOverheadNumber(Timeline.HEAL,_loc6_);
               }
            }
         }
      }
      
      public static function onIncomingRoomMessage(param1:String) : void
      {
         param1 = Base64.decode(param1);
         if(battleMc["chatDisplayMc"])
         {
            if(String(battleMc["chatDisplayMc"].htmlText).length >= Data.CHAT_MAX_DISPLAY_CHARACTERS)
            {
               battleMc["chatDisplayMc"].htmlText = String(battleMc["chatDisplayMc"].htmlText).substr(200,String(battleMc["chatDisplayMc"].htmlText).length - 200);
            }
            battleMc["chatDisplayMc"].htmlText += "<font color=\'#FFFFFF\'>" + param1 + "</font>";
            battleMc["chatDisplayMc"].verticalScrollPosition = battleMc["chatDisplayMc"].maxVerticalScrollPosition;
         }
      }
      
      public static function set type(param1:String) : void
      {
         battleType = param1;
      }
      
      public static function get type() : String
      {
         return battleType;
      }
      
      public static function Mission135_SpecialAction() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:Array = null;
         var _loc5_:uint = 0;
         var _loc6_:String = null;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         if(Mission.curMissionID == "msn135")
         {
            _loc1_ = uint(Central.mission.curMission.NoofTurnChange);
            _loc2_ = uint(Central.mission.curMission.NoofTurnChangeBG_Modifier);
            _loc4_ = [];
            if(enemyArr != null)
            {
               _loc3_ = 0;
               while(_loc3_ < enemyArr.length)
               {
                  if(!enemyArr[_loc3_].isDead)
                  {
                     _loc4_.push(enemyArr[_loc3_]);
                  }
                  _loc3_++;
               }
            }
            _loc5_ = 0;
            _loc5_ = Math.abs(_loc4_.length - 3);
            _loc1_ -= _loc5_ * _loc2_;
            if(round == 0 || round % _loc1_ == 0)
            {
               _loc6_ = MovieClip(battleMc["bgHolder"].getChildByName("bg")).currentLabel;
               _loc7_ = Math.floor(NumberUtil.randomInt(1,5));
               _loc8_ = int(String(_loc6_).replace("bg_",""));
               if(_loc7_ == _loc8_)
               {
                  _loc7_++;
               }
               if(_loc7_ >= 6)
               {
                  _loc7_ = 1;
               }
               switch(_loc7_)
               {
                  case 1:
                     MovieClip(battleMc["bgHolder"].getChildByName("bg")).gotoAndPlay("bg_1");
                     Mission135_SetElementalMan(_loc7_,_loc4_);
                     break;
                  case 2:
                     MovieClip(battleMc["bgHolder"].getChildByName("bg")).gotoAndPlay("bg_2");
                     Mission135_SetElementalMan(_loc7_,_loc4_);
                     break;
                  case 3:
                     MovieClip(battleMc["bgHolder"].getChildByName("bg")).gotoAndPlay("bg_3");
                     Mission135_SetElementalMan(_loc7_,_loc4_);
                     break;
                  case 4:
                     MovieClip(battleMc["bgHolder"].getChildByName("bg")).gotoAndPlay("bg_4");
                     Mission135_SetElementalMan(_loc7_,_loc4_);
                     break;
                  case 5:
                     MovieClip(battleMc["bgHolder"].getChildByName("bg")).gotoAndPlay("bg_5");
                     Mission135_SetElementalMan(_loc7_,_loc4_);
               }
            }
         }
      }
      
      public static function Mission135_SetElementalMan(param1:uint, param2:Array) : void
      {
         var _loc3_:uint = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         _loc4_ = Math.floor(NumberUtil.randomInt(0,param2.length - 1));
         _loc5_ = int(param1);
         _loc6_ = 0;
         _loc3_ = 0;
         while(_loc3_ < param2.length)
         {
            if(_loc3_ == _loc4_)
            {
               Mission135_SetElementalMan_attribute(param1,param2[_loc3_],param1,param2.length);
            }
            else
            {
               while(true)
               {
                  _loc5_ = Math.floor(NumberUtil.randomInt(1,5));
                  if(!(_loc5_ == param1 || _loc5_ == _loc6_))
                  {
                     break;
                  }
               }
               Mission135_SetElementalMan_attribute(param1,param2[_loc3_],_loc5_,param2.length);
               _loc6_ = _loc5_;
            }
            _loc3_++;
         }
      }
      
      public static function Mission135_SetElementalMan_attribute(param1:uint, param2:*, param3:uint, param4:uint) : void
      {
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc7_:uint = 0;
         var _loc8_:uint = 0;
         var _loc9_:uint = 0;
         var _loc12_:Number = NaN;
         var _loc13_:Number = NaN;
         var _loc14_:Number = NaN;
         var _loc15_:Number = NaN;
         var _loc16_:Number = NaN;
         var _loc17_:Number = NaN;
         var _loc18_:uint = 0;
         var _loc19_:uint = 0;
         var _loc20_:uint = 0;
         var _loc21_:uint = 0;
         var _loc22_:uint = 0;
         var _loc23_:uint = 0;
         _loc6_ = uint(Central.mission.curMission.MaxAttribute);
         _loc7_ = uint(Central.mission.curMission.MinAttribute);
         _loc8_ = uint(Central.mission.curMission.NormalAttribute);
         _loc9_ = uint(Central.mission.curMission.SecondAttribute);
         var _loc10_:uint = uint(Central.mission.curMission.SecondAttribute);
         var _loc11_:uint = uint(Central.mission.curMission.SecondAttribute);
         _loc12_ = Number(Central.mission.curMission.EnemyDealDamageModifier_2);
         _loc13_ = Number(Central.mission.curMission.EnemySufferDamageModifier_2);
         _loc14_ = Number(Central.mission.curMission.EnemyDealDamageModifier_1);
         _loc15_ = Number(Central.mission.curMission.EnemySufferDamageModifier_1);
         _loc16_ = 1;
         _loc17_ = 1;
         if(!param4)
         {
            param4 = 0;
         }
         switch(param4)
         {
            case 3:
               _loc16_ = 1;
               _loc17_ = 1;
               break;
            case 2:
               _loc16_ = _loc12_;
               _loc17_ = _loc13_;
               break;
            case 1:
               _loc16_ = _loc14_;
               _loc17_ = _loc15_;
               break;
            default:
               _loc16_ = 1;
               _loc17_ = 1;
         }
         _loc18_ = Math.round(Central.mission.curMission.NormalDealDamageModifier * _loc16_);
         _loc19_ = Math.round(Central.mission.curMission.NormalSufferDamageModifier * _loc17_);
         _loc20_ = Math.round(Central.mission.curMission.SuperDealDamageModifier * _loc16_);
         _loc21_ = Math.round(Central.mission.curMission.SuperSufferDamageModifier * _loc17_);
         _loc22_ = Math.round(Central.mission.curMission.WeakenDealDamageModifier * _loc16_);
         _loc23_ = Math.round(Central.mission.curMission.WeakenSufferDamageModifier * _loc17_);
         switch(param3)
         {
            case 1:
               param2.updateData(DBCharacterData.LIGHTNING,_loc9_);
               param2.updateData(DBCharacterData.FIRE,_loc8_);
               param2.updateData(DBCharacterData.WATER,_loc7_);
               param2.updateData(DBCharacterData.WIND,_loc7_);
               param2.updateData(DBCharacterData.EARTH,_loc9_);
               param2.setElemental(param1);
               param2.setElemental_Mode(param3);
               param2.setSufferDamageModifier(_loc19_);
               param2.setDealDamageModifier(_loc18_);
               if(param1 == 1)
               {
                  param2.updateData(DBCharacterData.LIGHTNING,_loc8_);
                  param2.updateData(DBCharacterData.FIRE,_loc6_);
                  param2.updateData(DBCharacterData.WATER,_loc9_);
                  param2.updateData(DBCharacterData.WIND,_loc9_);
                  param2.updateData(DBCharacterData.EARTH,_loc9_);
                  param2.setSufferDamageModifier(_loc21_);
                  param2.setDealDamageModifier(_loc20_);
               }
               else if(param1 == 5)
               {
                  param2.updateData(DBCharacterData.LIGHTNING,_loc7_);
                  param2.updateData(DBCharacterData.FIRE,_loc7_);
                  param2.updateData(DBCharacterData.WATER,_loc7_);
                  param2.updateData(DBCharacterData.WIND,_loc7_);
                  param2.updateData(DBCharacterData.EARTH,_loc7_);
                  param2.setSufferDamageModifier(_loc23_);
                  param2.setDealDamageModifier(_loc22_);
               }
               break;
            case 2:
               param2.updateData(DBCharacterData.LIGHTNING,_loc7_);
               param2.updateData(DBCharacterData.FIRE,_loc7_);
               param2.updateData(DBCharacterData.WATER,_loc9_);
               param2.updateData(DBCharacterData.WIND,_loc8_);
               param2.updateData(DBCharacterData.EARTH,_loc7_);
               param2.setElemental(param1);
               param2.setElemental_Mode(param3);
               param2.setSufferDamageModifier(_loc19_);
               param2.setDealDamageModifier(_loc18_);
               if(param1 == 2)
               {
                  param2.updateData(DBCharacterData.LIGHTNING,_loc9_);
                  param2.updateData(DBCharacterData.FIRE,_loc9_);
                  param2.updateData(DBCharacterData.WATER,_loc8_);
                  param2.updateData(DBCharacterData.WIND,_loc6_);
                  param2.updateData(DBCharacterData.EARTH,_loc9_);
                  param2.setSufferDamageModifier(_loc21_);
                  param2.setDealDamageModifier(_loc20_);
               }
               else if(param1 == 1)
               {
                  param2.updateData(DBCharacterData.LIGHTNING,_loc7_);
                  param2.updateData(DBCharacterData.FIRE,_loc7_);
                  param2.updateData(DBCharacterData.WATER,_loc7_);
                  param2.updateData(DBCharacterData.WIND,_loc7_);
                  param2.updateData(DBCharacterData.EARTH,_loc7_);
                  param2.setSufferDamageModifier(_loc23_);
                  param2.setDealDamageModifier(_loc22_);
               }
               break;
            case 3:
               param2.updateData(DBCharacterData.LIGHTNING,_loc8_);
               param2.updateData(DBCharacterData.FIRE,_loc7_);
               param2.updateData(DBCharacterData.WATER,_loc7_);
               param2.updateData(DBCharacterData.WIND,_loc9_);
               param2.updateData(DBCharacterData.EARTH,_loc7_);
               param2.setElemental(param1);
               param2.setElemental_Mode(param3);
               param2.setSufferDamageModifier(_loc19_);
               param2.setDealDamageModifier(_loc18_);
               if(param1 == 3)
               {
                  param2.updateData(DBCharacterData.LIGHTNING,_loc6_);
                  param2.updateData(DBCharacterData.FIRE,_loc9_);
                  param2.updateData(DBCharacterData.WATER,_loc8_);
                  param2.updateData(DBCharacterData.WIND,_loc8_);
                  param2.updateData(DBCharacterData.EARTH,_loc8_);
                  param2.setSufferDamageModifier(_loc21_);
                  param2.setDealDamageModifier(_loc20_);
               }
               else if(param1 == 4)
               {
                  param2.updateData(DBCharacterData.LIGHTNING,_loc7_);
                  param2.updateData(DBCharacterData.FIRE,_loc7_);
                  param2.updateData(DBCharacterData.WATER,_loc7_);
                  param2.updateData(DBCharacterData.WIND,_loc7_);
                  param2.updateData(DBCharacterData.EARTH,_loc7_);
                  param2.setSufferDamageModifier(_loc23_);
                  param2.setDealDamageModifier(_loc22_);
               }
               break;
            case 4:
               param2.updateData(DBCharacterData.LIGHTNING,_loc7_);
               param2.updateData(DBCharacterData.FIRE,_loc9_);
               param2.updateData(DBCharacterData.WATER,_loc7_);
               param2.updateData(DBCharacterData.WIND,_loc7_);
               param2.updateData(DBCharacterData.EARTH,_loc8_);
               param2.setElemental(param1);
               param2.setElemental_Mode(param3);
               param2.setSufferDamageModifier(_loc19_);
               param2.setDealDamageModifier(_loc18_);
               if(param1 == 4)
               {
                  param2.updateData(DBCharacterData.LIGHTNING,_loc9_);
                  param2.updateData(DBCharacterData.FIRE,_loc8_);
                  param2.updateData(DBCharacterData.WATER,_loc9_);
                  param2.updateData(DBCharacterData.WIND,_loc9_);
                  param2.updateData(DBCharacterData.EARTH,_loc6_);
                  param2.setSufferDamageModifier(_loc21_);
                  param2.setDealDamageModifier(_loc20_);
               }
               else if(param1 == 2)
               {
                  param2.updateData(DBCharacterData.LIGHTNING,_loc7_);
                  param2.updateData(DBCharacterData.FIRE,_loc7_);
                  param2.updateData(DBCharacterData.WATER,_loc7_);
                  param2.updateData(DBCharacterData.WIND,_loc7_);
                  param2.updateData(DBCharacterData.EARTH,_loc7_);
                  param2.setSufferDamageModifier(_loc23_);
                  param2.setDealDamageModifier(_loc22_);
               }
               break;
            case 5:
               param2.updateData(DBCharacterData.LIGHTNING,_loc7_);
               param2.updateData(DBCharacterData.FIRE,_loc7_);
               param2.updateData(DBCharacterData.WATER,_loc8_);
               param2.updateData(DBCharacterData.WIND,_loc7_);
               param2.updateData(DBCharacterData.EARTH,_loc9_);
               param2.setElemental(param1);
               param2.setElemental_Mode(param3);
               param2.setSufferDamageModifier(_loc19_);
               param2.setDealDamageModifier(_loc18_);
               if(param1 == 5)
               {
                  param2.updateData(DBCharacterData.LIGHTNING,_loc9_);
                  param2.updateData(DBCharacterData.FIRE,_loc9_);
                  param2.updateData(DBCharacterData.WATER,_loc6_);
                  param2.updateData(DBCharacterData.WIND,_loc9_);
                  param2.updateData(DBCharacterData.EARTH,_loc8_);
                  param2.setSufferDamageModifier(_loc21_);
                  param2.setDealDamageModifier(_loc20_);
               }
               else if(param1 == 3)
               {
                  param2.updateData(DBCharacterData.LIGHTNING,_loc7_);
                  param2.updateData(DBCharacterData.FIRE,_loc7_);
                  param2.updateData(DBCharacterData.WATER,_loc7_);
                  param2.updateData(DBCharacterData.WIND,_loc7_);
                  param2.updateData(DBCharacterData.EARTH,_loc7_);
                  param2.setSufferDamageModifier(_loc23_);
                  param2.setDealDamageModifier(_loc22_);
               }
               break;
            default:
               param2.updateData(DBCharacterData.LIGHTNING,_loc8_);
               param2.updateData(DBCharacterData.FIRE,_loc8_);
               param2.updateData(DBCharacterData.WATER,_loc8_);
               param2.updateData(DBCharacterData.WIND,_loc8_);
               param2.updateData(DBCharacterData.EARTH,_loc8_);
               param2.setElemental(1);
               param2.setElemental_Mode(1);
               param2.setSufferDamageModifier(_loc19_);
               param2.setDealDamageModifier(_loc18_);
         }
      }
      
      public static function onBloodline(param1:Event) : void
      {
         var BloodlineId:uint = 0;
         var btn:MovieClip = null;
         var evt:Event = param1;
         if(selectedPartySkillID != -1)
         {
            Main.showInfo(String(Central.main.langLib.get(1801)[0]));
            return;
         }
         BloodlineId = uint(int(String(evt.currentTarget.name).split("_")[1]));
         btn = MovieClip(evt.currentTarget);
         btn.dispatchEvent(new MouseEvent(MouseEvent.ROLL_OUT));
         if(Character(attacker).setPlayerCommand("bloodline",BloodlineId,btn))
         {
            onBattle();
            try
            {
               if(Battle.type == TYPE_NETWORK)
               {
                  Central.main.tracking.generalTrack(Central.main.tracking.TRACK_PVP,String(String(evt.currentTarget.name).split("_")[0]) + "_" + btn.skillData.id,Central.main.tracking.TRACK_PVP_SKILL_USED + "Talent");
               }
               else
               {
                  Central.main.tracking.generalTrack(Central.main.tracking.TRACK_SKILL_USED,String(String(evt.currentTarget.name).split("_")[0]) + "_" + btn.skillData.id,"Talent");
               }
            }
            catch(err:Error)
            {
               Out.error("Battle","onBloodline :: TRACKING - TRACK_PVP/TRACK_SKILL_USED");
            }
            whattodo = 9;
            sendCommand();
         }
      }
      
      public static function onSenjutsu(param1:Event) : void
      {
         var SenjutsuId:uint = 0;
         var btn:MovieClip = null;
         var evt:Event = param1;
         if(selectedPartySkillID != -1)
         {
            Main.showInfo(String(Central.main.langLib.get(1801)[0]));
            return;
         }
         SenjutsuId = 8;
         if(Central.main.senninModeBtn != evt.currentTarget)
         {
            SenjutsuId = uint(int(String(evt.currentTarget.name).split("_")[1]));
         }
         btn = MovieClip(evt.currentTarget);
         btn.dispatchEvent(new MouseEvent(MouseEvent.ROLL_OUT));
         if(Character(attacker).setPlayerCommand("senjutsu",SenjutsuId,btn))
         {
            onBattle();
            try
            {
               if(Battle.type == TYPE_NETWORK)
               {
                  Central.main.tracking.generalTrack(Central.main.tracking.TRACK_PVP,String(String(evt.currentTarget.name).split("_")[0]) + "_" + btn.skillData.id,Central.main.tracking.TRACK_PVP_SKILL_USED + "Senjutsu");
               }
               else
               {
                  Central.main.tracking.generalTrack(Central.main.tracking.TRACK_SKILL_USED,String(String(evt.currentTarget.name).split("_")[0]) + "_" + btn.skillData.id,"Senjutsu");
               }
            }
            catch(err:Error)
            {
               Out.error("Battle","onSenjutsu :: TRACKING - TRACK_PVP/TRACK_SKILL_USED");
            }
            whattodo = 10;
            sendCommand();
         }
      }
      
      public static function getTimeStamp() : uint
      {
         var _loc1_:Date = null;
         _loc1_ = new Date();
         return _loc1_.getTime();
      }
      
      public static function GetOverHeadString(param1:Object) : String
      {
         var _loc2_:String = null;
         _loc2_ = "";
         switch(param1.type)
         {
            case BattleData.EFFECT_DODGE_BONUS:
            case BattleData.EFFECT_ALL_CP_DODGE_BONUS:
            case BattleData.EFFECT_PET_DODGE_BONUS:
               _loc2_ = Central.main.langLib.get(306);
               break;
            case BattleData.EFFECT_CRITICAL_CHANCE_BONUS:
               _loc2_ = Central.main.langLib.get(292);
               break;
            case BattleData.EFFECT_REGENERATE_HP:
               _loc2_ = Central.main.langLib.get(490);
               break;
            case BattleData.EFFECT_SOUL_CHAINS_BUNDLE:
               _loc2_ = Central.main.langLib.get(329);
               break;
            case BattleData.EFFECT_STUN:
               _loc2_ = Central.main.langLib.get(281);
               break;
            case BattleData.EFFECT_REDUCE_AGILITY:
               _loc2_ = Central.main.langLib.get(2001)[0];
               break;
            case SenjutsuData.EFFECT_SS_MAX_CP_CHANGE:
               _loc2_ = Central.main.langLib.get(2001)[1];
               break;
            case SenjutsuData.EFFECT_SS_MAX_CP_CHANGE_EXTRA:
               _loc2_ = Central.main.langLib.get(2001)[1] + " Extra";
               break;
            case BattleData.EFFECT_SLEEP:
               _loc2_ = Central.main.langLib.get(280);
               break;
            case BattleData.EFFECT_INTERNAL_INJURY_FEAR_WEAKEN:
            case BattleData.EFFECT_FEAR_WEAKEN:
            case BattleData.EFFECT_PET_FEAR_WEAKEN:
               _loc2_ = Central.main.langLib.get(305);
               break;
            case BattleData.EFFECT_BUNDLE:
            case BattleData.SKILL_377:
               _loc2_ = Central.main.langLib.get(325);
               break;
            case BattleData.EFFECT_HEAL:
               _loc2_ = "";
               break;
            case BattleData.EFFECT_RESTORE_CP:
               _loc2_ = Central.main.langLib.get(350);
               break;
            case BattleData.EFFECT_COOLDOWN_REDUCTION:
               _loc2_ = Central.main.langLib.get(598);
               break;
            case BattleData.EFFECT_PET_BURN:
               _loc2_ = Central.main.langLib.get(288) + " (" + String(param1.amount) + "%)";
               break;
            case BattleData.EFFECT_BLIND:
            case BattleData.EFFECT_ALL_CP_BLIND:
               _loc2_ = Central.main.langLib.get(287);
               break;
            case BattleData.EFFECT_DODGE_REDUCTION:
               _loc2_ = String(Central.main.langLib.get(308)).replace("[valamt]",Math.round(param1.amount).toString() + "%");
               break;
            case BattleData.EFFECT_CRITICAL_CHANCE_BONUS:
               _loc2_ = Central.main.langLib.get(292);
               break;
            case BattleData.EFFECT_HAMSTRING:
               _loc2_ = Central.main.langLib.get(688);
               break;
            case BattleData.EFFECT_COLLIDING_WAVE:
               _loc2_ = Central.main.langLib.get(619);
               break;
            case BattleData.EFFECT_POISON:
               _loc2_ = Central.main.langLib.get(321);
               break;
            case BattleData.EFFECT_FIRE_ENERGY_EXCITATION:
            case BattleData.EFFECT_EXCITATION_CP:
            case BattleData.EFFECT_EXCITATION_CHARGE:
               _loc2_ = Central.main.langLib.get(613);
               break;
            case BattleData.EFFECT_INTERNAL_INJURY:
               _loc2_ = Central.main.langLib.get(648);
               break;
            case BattleData.EFFECT_DAMAGE_DELAY_INJURY:
               _loc2_ = Central.main.langLib.get(648);
               break;
            default:
               _loc2_ = "";
         }
         return _loc2_;
      }
      
      public static function get processor() : BattleProcessor
      {
         return BattleProcessor.getInstance();
      }
      
      public static function destroyProcessor() : void
      {
         BattleProcessor.destroyInstance();
      }
      
      public static function reverseShowChaosChecking() : void
      {
         BattleProcessor.showOHN_chaos = !BattleProcessor.showOHN_chaos;
      }
      
      public static function getShowChaos() : Boolean
      {
         return BattleProcessor.showOHN_chaos;
      }
      
      private static function godModeHackCheck() : Boolean
      {
         var _loc1_:int = 0;
         _loc1_ = Central.main.getMainChar().getData(DBCharacterData.WIND) + Central.main.getMainChar().getData(DBCharacterData.FIRE) + Central.main.getMainChar().getData(DBCharacterData.LIGHTNING) + Central.main.getMainChar().getData(DBCharacterData.WATER) + Central.main.getMainChar().getData(DBCharacterData.EARTH);
         Out.debug("battle","godModeHackCheck :: ap point >> " + _loc1_);
         Out.debug("battle","godModeHackCheck :: char lv >> " + Central.main.getMainChar().getLevel());
         if(_loc1_ < 0 || _loc1_ > Central.main.getMainChar().getLevel())
         {
            return true;
         }
         return false;
      }
      
      private static function trackingResponse(param1:Object = null) : void
      {
      }
      
      public static function setRematchPanelOnCancelReadyResponse() : void
      {
         if(!bWaitingToStartRematch)
         {
            return;
         }
         if(battleMc == null)
         {
            return;
         }
         disableButtonsOnRematchTimerCompleted();
         pvpWinLossPanelSomeoneLeft();
         if(battleMc["lbl_rematch_title"])
         {
            battleMc["lbl_rematch_title"].text = getPvpWinLossPanelMessage();
         }
      }
      
      public static function cancelReadyResponse() : void
      {
         setRematchPanelOnCancelReadyResponse();
      }
      
      public static function onPlayerLeaveQuickMatch() : void
      {
         setRematchPanelOnCancelReadyResponse();
      }
      
      public static function onPlayerLeaveTournament() : void
      {
         setRematchPanelOnCancelReadyResponse();
      }
      
      public static function callMcToReload() : void
      {
         battleMc.cancelRematchCountdown();
         battleMc.gotoAndStop("init");
      }
      
      public static function deleteBattleLikeFinish() : void
      {
         var i:uint = 0;
         var enemy:* = undefined;
         var teamate:* = undefined;
         var pet:* = undefined;
         battleMc.removeChild(battleMc["atbBar"]);
         battleMc.removeChild(battleMc["playerMc_1"]);
         battleMc.removeChild(battleMc["playerPetMc"]);
         battleMc.removeChild(battleMc["partyMc_1"]);
         battleMc.removeChild(battleMc["partyPetMc1"]);
         battleMc.removeChild(battleMc["partyMc_2"]);
         battleMc.removeChild(battleMc["partyPetMc2"]);
         battleMc.removeChild(battleMc["enemyMc_1"]);
         battleMc.removeChild(battleMc["enemyPetMc_1"]);
         battleMc.removeChild(battleMc["enemyMc_2"]);
         battleMc.removeChild(battleMc["enemyPetMc_2"]);
         battleMc.removeChild(battleMc["enemyMc_3"]);
         battleMc.removeChild(battleMc["enemyPetMc_3"]);
         try
         {
            if(battleMc != null)
            {
               battleMc.gotoAndStop(Timeline.IDLE);
            }
         }
         catch(e:Error)
         {
            Out.error("Battle","battleFinish :: Step 1 :: " + e.getStackTrace());
            Main.submitLogDump();
         }
         try
         {
            Main.getMainChar().resetBattleData();
            Main.getMainChar().removeParent();
            Main.getMainChar().setCharMc(null);
         }
         catch(e:Error)
         {
            Out.error("Battle","battleFinish :: Step 2 :: " + e.getStackTrace());
            Main.submitLogDump();
         }
         try
         {
            if(enemyArr != null)
            {
               i = 0;
               while(i < enemyArr.length)
               {
                  enemy = enemyArr[i];
                  enemy.resetBattleData();
                  enemy.removeParent();
                  enemy.setCharMc(null);
                  i++;
               }
            }
            if(partyArr)
            {
               i = 0;
               while(i < partyArr.length)
               {
                  teamate = partyArr[i];
                  teamate.resetBattleData();
                  teamate.removeParent();
                  teamate.setCharMc(null);
                  i++;
               }
            }
            if(petArr)
            {
               i = 0;
               while(i < petArr.length)
               {
                  pet = petArr[i];
                  pet.resetBattleData();
                  pet.removeParent();
                  pet.setCharMc(null);
                  pet.resetSkillCooldown();
                  i++;
               }
            }
         }
         catch(e:Error)
         {
            Out.error("Battle","battleFinish :: Step 3 :: " + e.getStackTrace());
            Main.submitLogDump();
         }
         try
         {
            Main.mapMenu.hideChatInput();
         }
         catch(e:Error)
         {
            Out.error("Battle","battleFinish :: Step 5 :: " + e.getStackTrace());
            Main.submitLogDump();
         }
         try
         {
            GF.removeAllChild(battleMc["displayHolder"]);
            GF.removeAllChild(battleMc["specialHolder"]);
            attacker = null;
            defender = null;
            selectedTarget = null;
            consumablesUsed = 0;
            rematchTimes = 0;
            battleResult = 0;
            repGain = 0;
            bossId = "";
            use_seal_enemy = false;
            seal_enemy = false;
            spy_enemy = false;
            Central.main.battleRuleArr = [];
            Central.main.actionChecker = true;
            isPartyControllable = false;
            pvpSyncLogSaved = false;
            pvpLogTimeSaved = false;
            if(Central.main.PvpPlayerPost == "quick")
            {
               Central.main.PvpPlayerPlace = "quick";
            }
            else if(Central.main.PvpPlayerPost == "tournament")
            {
               Central.main.PvpPlayerPlace = "tournament";
            }
         }
         catch(e:Error)
         {
            Out.error("Battle","battleFinish :: Step 4.2 :: " + e.getStackTrace());
            Main.submitLogDump();
         }
      }
      
      public static function disableButtonsOnRematchTimerCompleted() : void
      {
         battleMc["okBtn"].alpha = 0.5;
         battleMc["okBtn"].filters = [CreateFilter.getSaturationFilter(0.5)];
         battleMc["okBtn"].enabled = false;
         battleMc["okBtn"].removeEventListener(MouseEvent.CLICK,onOkBtn);
         battleMc["noBtn"].alpha = 0.5;
         battleMc["noBtn"].filters = [CreateFilter.getSaturationFilter(0.5)];
         battleMc["noBtn"].enabled = false;
         battleMc["noBtn"].removeEventListener(MouseEvent.CLICK,onNoBtn);
         battleMc["backBtn"].visible = true;
         battleMc["backBtn"].addEventListener(MouseEvent.CLICK,onBackBtn);
         battleMc["lbl_rematch_title"].visible = true;
      }
      
      public static function disableButtonsNoExitOnRematchTimerCompleted() : void
      {
         battleMc["okBtn"].alpha = 0.5;
         battleMc["okBtn"].filters = [CreateFilter.getSaturationFilter(0.5)];
         battleMc["okBtn"].enabled = false;
         battleMc["okBtn"].removeEventListener(MouseEvent.CLICK,onOkBtn);
         battleMc["noBtn"].alpha = 0.5;
         battleMc["noBtn"].filters = [CreateFilter.getSaturationFilter(0.5)];
         battleMc["noBtn"].enabled = false;
         battleMc["noBtn"].removeEventListener(MouseEvent.CLICK,onNoBtn);
         battleMc["backBtn"].visible = false;
         battleMc["backBtn"].removeEventListener(MouseEvent.CLICK,onBackBtn);
         battleMc["lbl_rematch_title"].visible = true;
      }
      
      public static function enableButtonsOnRematchRequest() : void
      {
         battleMc["signalMc"].gotoAndStop("show");
         battleMc["signalMc"].visible = true;
         battleMc["okBtn"].visible = true;
         battleMc["okBtn"].alpha = 1;
         battleMc["okBtn"].addEventListener(MouseEvent.CLICK,onOkBtn);
         battleMc["noBtn"].visible = true;
         battleMc["noBtn"].alpha = 1;
         battleMc["noBtn"].addEventListener(MouseEvent.CLICK,onNoBtn);
         battleMc["backBtn"].visible = false;
         battleMc["backBtn"].addEventListener(MouseEvent.CLICK,onBackBtn);
      }
      
      public static function getPvpWinLossPanelStatus() : String
      {
         if(bRematchAnyPlayerOpponentLeft || bRematchTimedOut)
         {
            return "allow_go_away";
         }
         if(bRematchPressedOk)
         {
            return "confirmed";
         }
         return "unstated";
      }
      
      public static function getPvpWinLossPanelMessage() : String
      {
         if(Battle.pvpCurrencyGainDisplay && Battle.myCurrencyGain == 0)
         {
            Central.main.getMainChar().pvpPlayerDisconnect();
            return Central.main.langLib.titleTxt(TitleData.DISCONNECT);
         }
         if(bRematchAnyPlayerOpponentLeft)
         {
            return Central.main.langLib.get(1840)[3];
         }
         if(bRematchTimedOut)
         {
            return Central.main.langLib.get(1840)[4];
         }
         if(bRematchPressedOk)
         {
            return Central.main.langLib.get(1840)[0];
         }
         if(bRematchOnePlayerWantRematch)
         {
            return Central.main.langLib.get(1840)[1];
         }
         return "";
      }
      
      public static function pvpWinLossPanelSomeoneWantRematch() : void
      {
         bRematchOnePlayerWantRematch = true;
      }
      
      public static function pvpWinLossPanelSomeoneLeft() : void
      {
         bRematchAnyPlayerOpponentLeft = true;
      }
      
      public static function pvpWinLossPanelTimedOut() : void
      {
         bRematchTimedOut = true;
      }
      
      public static function pvpWinLossPanelPressedOk() : void
      {
         bRematchPressedOk = true;
      }
      
      public static function getBattleBackground() : MovieClip
      {
         if(battleBg != null)
         {
            return battleBg;
         }
         return battleBgDefault;
      }
      
      public static function enableActionBarAllButtons() : *
      {
         if(battleMc == null || battleMc["actionBar"] == null)
         {
            return;
         }
         battleMc["actionBar"].updateButtonAttributes();
      }
      
      public static function processSkipBattleTurn() : void
      {
         var _loc1_:Object = null;
         Out.debug("battle","processSkipBattleTurn");
         _loc1_ = {};
         resetATBPosition();
         _loc1_.event = "info";
         _loc1_.charId = String(Main.getMainChar().getData("character_id"));
         _loc1_.state = "action_finish";
         Central.client.getInstance().sendData(_loc1_);
      }
      
      public static function syncBackground(param1:String) : *
      {
         var _loc2_:* = undefined;
         Out.debug("","syncBackground num = " + param1);
         _loc2_ = [];
         _loc2_.push("swf/panels/arena_bg.swf");
         Main.loadSwf(_loc2_,loadBackgroundComplete,{"backgroundNumber":param1});
      }
      
      public static function loadBackgroundComplete(param1:Object, param2:Object) : void
      {
         var _loc3_:MovieClip = null;
         Out.debug("","function loadBackgroundComplete");
         Main.showAmfLoading();
         _loc3_ = GF.getAsset(param1["swf/panels/arena_bg.swf"],"background" + param2.backgroundNumber);
         Main.hideAmfLoading();
         if(battleBg == null)
         {
            changeBg(_loc3_);
         }
         else
         {
            Out.debug("","failure load background, already loaded background");
         }
      }
      
      private function onClickReturnPVE(param1:MouseEvent) : void
      {
      }
   }
}

