package ninjasaga
{
   import bitemycode.facebook.FBUser;
   import bitemycode.loader.DynamicLoader;
   import bitemycode.net.zendamf.*;
   import br.com.stimuli.loading.BulkErrorEvent;
   import br.com.stimuli.loading.BulkLoader;
   import br.com.stimuli.loading.loadingtypes.*;
   import com.adobe.serialization.json.JSON;
   import com.adobe.utils.StringUtil;
   import com.google.analytics.AnalyticsTracker;
   import com.google.analytics.GATracker;
   import com.utils.AssociateArray;
   import com.utils.CreateFilter;
   import com.utils.GF;
   import com.utils.Mixer;
   import com.utils.NumberUtil;
   import com.utils.Out;
   import com.utils.Sha1Encrypt;
   import com.utils.TextFilter;
   import de.polygonal.ds.HashMap;
   import flash.display.*;
   import flash.events.*;
   import flash.external.ExternalInterface;
   import flash.filters.ColorMatrixFilter;
   import flash.geom.Point;
   import flash.media.Sound;
   import flash.media.SoundMixer;
   import flash.media.SoundTransform;
   import flash.net.*;
   import flash.system.Capabilities;
   import flash.system.Security;
   import flash.utils.*;
   import gs.*;
   import gs.plugins.*;
   import ninjasaga.asset.*;
   import ninjasaga.base.CharacterBase;
   import ninjasaga.battle.*;
   import ninjasaga.core.CoreData;
   import ninjasaga.data.AMFData;
   import ninjasaga.data.AchievementData;
   import ninjasaga.data.AppData;
   import ninjasaga.data.BattleData;
   import ninjasaga.data.BloodlineData;
   import ninjasaga.data.ButtonData;
   import ninjasaga.data.DBCharacterData;
   import ninjasaga.data.DailyLoginEventData;
   import ninjasaga.data.Data;
   import ninjasaga.data.ErrorData;
   import ninjasaga.data.Formula;
   import ninjasaga.data.GameEvents;
   import ninjasaga.data.InventoryData;
   import ninjasaga.data.LanguageData;
   import ninjasaga.data.MissionData;
   import ninjasaga.data.PositionType;
   import ninjasaga.data.PvPData;
   import ninjasaga.data.RankData;
   import ninjasaga.data.StaticVariables;
   import ninjasaga.data.Timeline;
   import ninjasaga.data.TitleData;
   import ninjasaga.data.TokenData;
   import ninjasaga.dbclass.DBCharacter;
   import ninjasaga.objects.AntiMemoryHack;
   import ninjasaga.objects.Npc;
   
   public final class Main
   {
      
      public static var tracker:AnalyticsTracker;
      
      public static const ACC_REG_TUT_STATUS_NONE:int = 0;
      
      public static const ACC_REG_TUT_STATUS_READ:int = 1;
      
      public static const ACC_REG_ACTIVE_STATUS_NOT_REGISTERED:int = 0;
      
      public static const ACC_REG_ACTIVE_STATUS_ACTIVE:int = 1;
      
      private static var _errorCode:String;
      
      private static var _errorMessage:String;
      
      private static var mainChar:Character;
      
      private static var previewChar:Character;
      
      private static var mainMc:MovieClip;
      
      private static var lib:MovieClip;
      
      public static var dataLib:MovieClip;
      
      public static var langLib:MovieClip;
      
      public static var proc:MainProcess;
      
      public static var limitOffer:int;
      
      private static var enemyArr:Array;
      
      private static var aiCharArr:Array;
      
      private static var battleCharacters:Array;
      
      public static var cinematicsMc:MovieClip;
      
      public static var WEAPON_DATA:HashMap;
      
      public static var tradeitem:Boolean;
      
      public static var BACK_ITEM_DATA:HashMap;
      
      public static var ACCESSORY_DATA:HashMap;
      
      public static var TRADING_DATA:HashMap;
      
      public static var GEAR_SET_DATA:HashMap;
      
      public static var actionBase:MovieClip;
      
      public static var SKILL_DATA:Object;
      
      public static var SKILL_DATA_ARR:Array;
      
      public static var BLOODLINE_DATA:Object;
      
      public static var BLOODLINE_SKILL_DATA:Object;
      
      public static var BLOODLINE_SKILL_DATA_ARR:Array;
      
      public static var SENJUTSU_DATA:Object;
      
      public static var SENJUTSU_SKILL_DATA:Object;
      
      public static var SENJUTSU_SKILL_DATA_ARR:Object;
      
      public static var ITEM_DATA:HashMap;
      
      public static var ESSENCE_DATA:HashMap;
      
      public static var MATERIAL_DATA:HashMap;
      
      public static var CURRENCY_DATA:HashMap;
      
      public static var ENEMY_DATA:HashMap;
      
      public static var PET_DATA:HashMap;
      
      public static var MISSION_DATA:Object;
      
      public static var MISSION_DATA_AA:AssociateArray;
      
      public static var HAIR_DATA:HashMap;
      
      public static var WALLFEED_DATA:HashMap;
      
      public static var ACHIEVEMENT_DATA:HashMap;
      
      public static var NEWS:String;
      
      public static var client:*;
      
      public static var tutorialArr:Array;
      
      private static var loadingChars:Array;
      
      private static var loadCharFinish_CB:Function;
      
      public static var challengeFriendUID:String;
      
      private static var _recruitedFriends:Array;
      
      private static var recruitFriend_CB:Function;
      
      public static const PAY_TOKEN:String = "token";
      
      public static const PAY_GOLD:String = "gold";
      
      public static var activeNpc:Array;
      
      private static var loadNpc_CB:Function;
      
      public static var stateInventory:StateInventory;
      
      public static var serverTime:int;
      
      public static var currentDate:int;
      
      public static var selectedPvpServer:*;
      
      private static var chatInputTime:Number;
      
      public static var ads:Array;
      
      public static var socket:*;
      
      public static var EnemyData:*;
      
      public static var paymentStatus:Boolean;
      
      public static var paymentTitle:String;
      
      public static var paymentText:String;
      
      public static var showLearnMoreBtn:Boolean;
      
      public static const LOCK_PAYMENT:* = "payment";
      
      public static const LOCK_HACK:* = "hack";
      
      public static var lockType:String;
      
      public static var lvUpRewardType:int;
      
      private static var achievementPanel:MovieClip;
      
      public static const sageHillWorking:Boolean = false;
      
      private static var _PvpPlayerPost:String;
      
      public static var PvpGameId:String;
      
      public static var PvpRoomId:String;
      
      public static var PvpPassword:String;
      
      public static var PvpZoneId:String;
      
      public static var PvPTargetId:String;
      
      private static var _PvpBattleType:String;
      
      private static var _PvpPlayerPlace:String;
      
      private static var _pvpPlayerStatus:String;
      
      private static var eventPopupPanel_CB:Function;
      
      public static var canClaimGiftBag:Boolean;
      
      public static var clickedLuckyDrawButton:String;
      
      public static var sealFailTitle:String;
      
      public static var sealFailHint:String;
      
      public static var isPopupType:String;
      
      public static var popup_SendGiftList:Array;
      
      public static var popup_SendGift_Remain_Time:int;
      
      public static var minik_xmas_gift:String;
      
      public static var minik_xmas_gift_type:String;
      
      public static var DailyLoginEventLangIndex:int;
      
      public static var ShowPopupLangIndex:int;
      
      public static const EVENT_MIN_LV:int = 5;
      
      public static var ingamepopupLayoutArr:Array;
      
      public static const DISPLAY_LEVEL_LIMIT_NORMAL:int = 20;
      
      public static const DISPLAY_LEVEL_LIMIT_EVENT_LUCKY_DRAW:int = 20;
      
      public static const DISPLAY_LEVEL_LIMIT_EVENT_GAHAPON:int = 20;
      
      public static const DISPLAY_LEVEL_LIMIT_EVENT_SAKURA:int = 9;
      
      public static const DISPLAY_LEVEL_LIMIT_EVENT_EASTER:int = 5;
      
      public static const DISPLAY_LEVEL_LIMIT_BUTTON_TALENT:int = 20;
      
      public static const DISPLAY_LEVEL_LIMIT_BUTTON_CLASS:int = 20;
      
      public static const DISPLAY_LEVEL_LIMIT_BUTTON_PET:int = 20;
      
      public static const DISPLAY_LEVEL_LIMIT_BUILDING_NORMAL:int = 20;
      
      public static const DISPLAY_LEVEL_LIMIT_BUILDING_HUNTING_HOUSE:int = 5;
      
      public static const DISPLAY_LEVEL_LIMIT_BUILDING_TALENT:int = 20;
      
      public static const DISPLAY_LEVEL_LIMIT_BUILDING_CLAN:int = 10;
      
      public static const DISPLAY_LEVEL_LIMIT_BUILDING_PET_SHOP:int = 20;
      
      public static const DISPLAY_LEVEL_LIMIT_BUILDING_SNEJUTSU_HILL:int = 80;
      
      public static const CHAR_CREATE_DATE:Number = 20140312030000;
      
      public static var currAISkillId:uint;
      
      public static var petData:Array;
      
      public static var InvGetBackNum:Array;
      
      public static var Features:FeatureControl;
      
      public static var ACCESS_TOKEN:String;
      
      public static var mixer:Mixer;
      
      public static var isNewAccount:Boolean;
      
      public static var extraData:Object;
      
      public static var dailyDragonHuntObject:*;
      
      public static var xmas2014SpecailReward:Object;
      
      public static var onceGift:Array;
      
      public static var prevNpcArr:Array;
      
      public static var prevPartyMemberArr:Array;
      
      public static var loader:BulkLoader;
      
      private static var post:int;
      
      private static var canShow:Boolean;
      
      private static var isShowing:int;
      
      private static var rPost:int;
      
      private static var rCanShow:Boolean;
      
      private static var rIsShowing:int;
      
      private static var lMaxY:uint;
      
      private static var rMaxY:uint;
      
      private static var lMinY:uint;
      
      private static var rMinY:uint;
      
      public static var currScartchCard:int;
      
      public static var currRequest:int;
      
      public static var currMail:int;
      
      public static const SHIFT_X_RIGHT:String = "X_right";
      
      public static const SHIFT_X_LEFT:String = "X_left";
      
      public static const SHIFT_Y_DOWN:String = "Y_down";
      
      public static const SHIFT_Y_UP:String = "Y_up";
      
      public static const SHIFT_X_RIGHT_TO_LEFT:String = "X_right_to_left";
      
      private static var dimFilter:ColorMatrixFilter = CreateFilter.getSaturationFilter(0);
      
      public static var friendship_kunai:int = 0;
      
      public static var friend_accepted:int = 0;
      
      public static var friend_accepted_reward:Array = new Array();
      
      public static var Theme_Halloween:Boolean = false;
      
      public static var Theme_dailyLogin:Boolean = false;
      
      public static var gameLockout:Boolean = false;
      
      public static var _errorRecover:Boolean = false;
      
      public static var _errorRecoverObj:Object = null;
      
      public static var isNewChar:Boolean = false;
      
      public static var isNewCharByCreate:Boolean = false;
      
      public static var tutorialMsnStep:int = 0;
      
      public static var exitFromTutorial:Boolean = false;
      
      public static var senjutsuFeature:Boolean = false;
      
      public static var senjutsuSystem:int = -1;
      
      public static var senjutsuSlot:uint = 0;
      
      public static const SENJUTSU_BUTTON_ENABLE_ORDER:Array = [3,4,5,6,2,7,1,8];
      
      public static var BODY_SET_BOY:Object = {"set1":{"swfName":"set_01_0"}};
      
      public static var BODY_SET_GIRL:Object = {"set1":{"swfName":"set_01_1"}};
      
      public static var GetHuntingPassport:Boolean = false;
      
      public static var newsArr:Array = [];
      
      public static var newsId:int = -1;
      
      public static var isGraphic:Boolean = false;
      
      public static var challengedFriends:Array = [];
      
      private static var _partyMembers:Array = [];
      
      public static var recruitFriendTmpData:Array = [];
      
      private static var hasLoadRecruitFriends:Boolean = false;
      
      public static var partyNpc:Array = [];
      
      private static var usermap:HashMap = new HashMap();
      
      private static var chatInputArr:Array = [];
      
      public static var MISSION_RETRY:Object = {
         "msn155":0,
         "msn156":0
      };
      
      public static var MISSION_ENGAGE_BG:String = MissionData.ENGAGE_BG;
      
      public static var MISSION_ENGAGE_RESET:Boolean = false;
      
      public static var isShowMainAlert:Boolean = true;
      
      public static var ShowMainAlertMessage:String = "";
      
      private static var _showAds:Boolean = false;
      
      public static var amfSeq:int = 0;
      
      public static var hasLvUpReward:Boolean = false;
      
      public static var lvUpTokenClaimed:Boolean = true;
      
      public static var validLogin:Boolean = false;
      
      public static var pvpDebugTime:int = 0;
      
      public static var villageMap:String = "swf/maps/9th_map_2018.swf";
      
      public static var villageNormalMap:String = "swf/maps/9th_map_2018.swf";
      
      public static var adsArr:Array = [];
      
      public static var pvpstatus:Object = {"status":true};
      
      public static var datetime:String = "";
      
      public static var isShowMsnADs:Boolean = false;
      
      public static var showSJExamPanel:Boolean = false;
      
      public static var oriClassSkill:Array = [];
      
      public static var dayleft:int = -1;
      
      public static var sje_notice:int = 0;
      
      public static var senninDayLeft:int = -1;
      
      public static var sennin_notice:int = 0;
      
      public static var senninExamCountdownStart:int = 0;
      
      public static var senninExamShowZeroDayConfirm:Boolean = true;
      
      public static var senninModeBtn:MovieClip = null;
      
      public static var friendData:Array = [];
      
      public static var isShowDailyLogin:Boolean = false;
      
      public static var dailyLogin:Boolean = true;
      
      public static var dailyRoulette_remainTime:int = 0;
      
      public static var dailyRoulette_spc_remainTime:int = 0;
      
      public static var dailyLoginData:Array = [];
      
      public static var isShowCPMStarAds:Boolean = true;
      
      public static var battleRuleArr:Array = [];
      
      public static var actionChecker:Boolean = true;
      
      public static var petExtraDmg:Boolean = false;
      
      public static var petExtraDmgAmount:int = 0;
      
      public static var claimTokenStatus:Array = [];
      
      public static var file_1:Array = [];
      
      public static var file_2:Array = [];
      
      public static var file_3:Array = [];
      
      public static var tokenskill:Object = null;
      
      public static var upgradeGroupID:int = 0;
      
      public static var closePanel:Boolean = false;
      
      public static var PvpOnArena:Boolean = false;
      
      public static var HitAi:Boolean = false;
      
      public static var afterHitAi:Boolean = false;
      
      public static var waitingquick:Boolean = false;
      
      public static var PvphavePlayerDisconnect:Boolean = false;
      
      public static var openArenaAfterTimetable:Boolean = false;
      
      public static var enterPvpFromMap:* = false;
      
      public static var PvpTeamA:Array = [];
      
      public static var PvpTeamB:Array = [];
      
      public static var PvpTeamAPost:Array = [];
      
      public static var PvpTeamBPost:Array = [];
      
      public static var PvpAllPlayer:Array = [];
      
      public static var PvpPVMode:int = 1;
      
      public static var PvpQMMode:int = 1;
      
      public static var PvpTournamentMode:int = 1;
      
      public static var loadedPvpCharacter:int = 0;
      
      public static var Pvp_Ip:String = "";
      
      public static var PvpPRTeamA:Object = {};
      
      public static var PvpPRTeamB:Object = {};
      
      public static var ramPvpPrTeamA:Object = {};
      
      public static var ramPvpPrTeamB:Object = {};
      
      public static var willChangeTA:Array = [];
      
      public static var willChangeTB:Array = [];
      
      public static var pvpPlayerMap:HashMap = new HashMap();
      
      public static var resurrection:Boolean = false;
      
      public static var PvpMainCharMc:String = "playerMc_1";
      
      public static var PvpBackUpCharObj:Object = {};
      
      public static var PvpPRHostId:String = "";
      
      public static var PvpShuffleMode:Boolean = false;
      
      public static var charAccountType:Object = {};
      
      public static var adminMessage:String = "";
      
      public static var paymentpackage_remain_1:int = 0;
      
      public static var paymentpackage_remain_2:int = 0;
      
      public static var newsfeed_material_posted:Boolean = true;
      
      public static var newsfeed_easter_2014_posted:Boolean = true;
      
      public static var char_crate_date:String = "";
      
      public static var pvpinvite:Boolean = false;
      
      public static var WC2018ClaimReward:int = -1;
      
      public static var clanSeason:String = "00";
      
      public static var crewSeason:String = "00";
      
      public static var premium_daily_token:Boolean = false;
      
      public static var premium_daily_token_display:Boolean = true;
      
      public static var premium_claim_skill_set:Boolean = false;
      
      public static var premium_claim_level:Boolean = false;
      
      public static var claimFatherDay:Boolean = false;
      
      public static var FatherEventIn:Boolean = false;
      
      public static var Anni3BattleMethod:String = "";
      
      public static var Vday2013BattleMethod:String = "";
      
      public static var eventBattleMethod:String = "";
      
      public static var mainMapChange:Boolean = false;
      
      public static var mainMapStatus:int = 1;
      
      public static var mainMapObject:Object = new Object();
      
      public static var preloader_status:int = 0;
      
      public static var christmasCoin:int = 0;
      
      public static var easterCoin:int = 0;
      
      public static var isEventEnd:* = false;
      
      public static var isOldHunting:* = false;
      
      public static var isVDay2017:* = false;
      
      public static var hasClickPuzzleButton:Boolean = false;
      
      public static var gotoStoryPage:String = "";
      
      public static var battleToPage:String = "Panel_Easter_2014_Battle";
      
      public static var changeExpiryItemBtn:Boolean = false;
      
      public static var ItemExpiried:Boolean = false;
      
      public static var daily_login:Boolean = false;
      
      public static var showExpiryTutorial:Boolean = false;
      
      public static var stampRed2X:int = 0;
      
      public static var stampRed3X:int = 0;
      
      public static var stampRed4X:int = 0;
      
      public static var stampYellow:int = 0;
      
      public static var stampBlue:int = 0;
      
      public static var cheese:int = 0;
      
      public static var Mission240_Level:int = 6;
      
      public static var requestData:Array = [];
      
      public static var buyPet:Boolean = false;
      
      public static var claimRemain:int = 0;
      
      public static var isShowMedal:Boolean = false;
      
      public static var medalDay:Boolean = false;
      
      public static var medalReward:Array = [];
      
      public static var sum_1:Array = [];
      
      public static var sum_2:Array = [];
      
      public static var sum_3:Array = [];
      
      public static var country_area:int = 2;
      
      private static var testBuild:Array = ["0.0.1000","0.0.1001","i.m.peChe5TEga58W6TraCha","alan_test_XB42DFH","0.0.1004"];
      
      public static var DailyLoginEvent:Boolean = false;
      
      public static var DailyLoginEventReward:Array = [];
      
      public static var isDisplayDailyLogin:Boolean = false;
      
      public static var GiftBagEvent:Array = [];
      
      public static var ShowPopup:Boolean = true;
      
      public static var isShowPopup:Boolean = true;
      
      public static var popupText:Array = [];
      
      public static var showFanPage:Boolean = true;
      
      public static var showClothingPopup:Boolean = false;
      
      public static var ClanStatus:int = 0;
      
      public static var adPageMax:int = 0;
      
      public static var isShowEarthquakePanel:Boolean = true;
      
      public static var logRewardList:Boolean = true;
      
      public static var logHints:Boolean = true;
      
      public static var showVDailyLogin:Boolean = true;
      
      public static var showVdayNotice:Boolean = true;
      
      public static var checkLogVdayEventButton:Array = [true,true,true,true,true,true,true];
      
      public static var mapKey:int = 0;
      
      public static var mapValue:int = 0;
      
      private static var enterMapCounter:int = 0;
      
      private static var adShown:int = 0;
      
      public static var inGameShowZodiacClothing:Boolean = true;
      
      public static var showNewDailyLogin2017:Boolean = true;
      
      public static var Dailclaim2017:Boolean = true;
      
      public static var showIngameNotice:Boolean = true;
      
      public static var dailyToken:Boolean = true;
      
      public static var ingamePopupBigNewsArr:Array = [];
      
      public static var isShowDailyTask:Boolean = true;
      
      public static var showLuckyPuzzleStatus:int = 0;
      
      public static var EasterHints:Boolean = false;
      
      public static var charCreateDate:String = "";
      
      public static var charClanID:int = 0;
      
      public static var showNewLockPopup:Boolean = false;
      
      public static var blnConditionTest:Boolean = true;
      
      public static var battleModeSpecial:Boolean = false;
      
      public static var battleModeSelected:String = "";
      
      public static var battleId:String = "";
      
      public static var isExpired:Boolean = false;
      
      public static var isTrailEmblem:Boolean = false;
      
      public static var isShowTrial:Boolean = true;
      
      public static var ninecup:Boolean = true;
      
      public static var showDoubleCrewWarReward:Boolean = false;
      
      public static var crewDamage:int = 0;
      
      public static var emblem_xp_bonus_amount:Number = 0;
      
      public static var onmap:Boolean = false;
      
      public static var gameenery:int = 0;
      
      public static var enery_next_update:int = 0;
      
      public static var nowenerytimer:int = 0;
      
      public static var dragonBallList:Array = [[{
         "id":"775",
         "amount":0
      },{
         "id":"776",
         "amount":0
      },{
         "id":"777",
         "amount":0
      },{
         "id":"778",
         "amount":0
      },{
         "id":"779",
         "amount":0
      },{
         "id":"780",
         "amount":0
      },{
         "id":"781",
         "amount":0
      }],[{
         "id":"782",
         "amount":0
      },{
         "id":"783",
         "amount":0
      },{
         "id":"784",
         "amount":0
      },{
         "id":"785",
         "amount":0
      },{
         "id":"786",
         "amount":0
      },{
         "id":"787",
         "amount":0
      },{
         "id":"788",
         "amount":0
      }],[{
         "id":"789",
         "amount":0
      },{
         "id":"790",
         "amount":0
      },{
         "id":"791",
         "amount":0
      },{
         "id":"792",
         "amount":0
      },{
         "id":"793",
         "amount":0
      },{
         "id":"794",
         "amount":0
      },{
         "id":"795",
         "amount":0
      }],[{
         "id":"796",
         "amount":0
      },{
         "id":"797",
         "amount":0
      },{
         "id":"798",
         "amount":0
      },{
         "id":"799",
         "amount":0
      },{
         "id":"800",
         "amount":0
      },{
         "id":"801",
         "amount":0
      },{
         "id":"802",
         "amount":0
      }],[{
         "id":"803",
         "amount":0
      },{
         "id":"804",
         "amount":0
      },{
         "id":"805",
         "amount":0
      },{
         "id":"806",
         "amount":0
      },{
         "id":"807",
         "amount":0
      },{
         "id":"808",
         "amount":0
      },{
         "id":"809",
         "amount":0
      }]];
      
      public static var bPvpUsingRoomList:Boolean = false;
      
      public static var pvpSelectedRoomIdFromRoomList:int = 0;
      
      public static var pvpSelectedRoomLockedFromRoomList:Boolean = false;
      
      public static var onCallCheckHackFunction:Boolean = true;
      
      public static var checkUseTokenInsteadItem:Boolean = false;
      
      private static var antiMemoryHackTrap1:AntiMemoryHack = AntiMemoryHack.copyInstance(AntiMemoryHack.ANTIMEMORYHACK_SECURITY_TYPE_1000);
      
      private static var antiMemoryHackTrap2:AntiMemoryHack = AntiMemoryHack.copyInstance(AntiMemoryHack.ANTIMEMORYHACK_SECURITY_TYPE_2464A3A2);
      
      public static var itfInvGetBackNum:uint = 0;
      
      public static var itpInvGetBackNum:uint = 0;
      
      public static var comInvGetBackNum:uint = 0;
      
      public static var wpnInvGetBackNum:uint = 0;
      
      public static var setInvGetBackNum:uint = 0;
      
      public static var bakInvGetBackNum:uint = 0;
      
      public static var essInvGetBackNum:uint = 0;
      
      public static var mtfInvGetBackNum:uint = 0;
      
      public static var mtpInvGetBackNum:uint = 0;
      
      public static var isDisplayRegTut:Boolean = true;
      
      public static var promoteId:int = 0;
      
      public static var cls:String = "";
      
      public static var accRegTutStatus:int = ACC_REG_TUT_STATUS_NONE;
      
      public static var accRegActiveStatus:int = ACC_REG_ACTIVE_STATUS_NOT_REGISTERED;
      
      public static var doublexpTime:int = 0;
      
      public static var GodSnapCountDown:int = 0;
      
      public static var UnstoppableRageCountDown:int = 0;
      
      public static var thanosCountDownUpdateTimer:int = 0;
      
      public static var huntingprice:int = 5;
      
      public static var pvebuy:int = 70;
      
      public static var pvebuytime:String = "";
      
      public static var doublexpLastUpdateTime:int = 0;
      
      public static var anni_9th_daily_cup_time:int = 0;
      
      public static var easterCombineBoostTime:int = 0;
      
      public static var petBoostLastUpdate:int = 0;
      
      public static var canEasterCombineBoostTime:int = 0;
      
      public static var easterCombineBoostStartTimeLeft:int = 0;
      
      public static var easterCombineBoostEndTimeLeft:int = 0;
      
      public static var currentMusicIndex:int = 0;
      
      public static const MUSIC_PLAY_LIST:Array = ["MainMusic","expiredMainMusic","BattleBGM"];
      
      public static var soundOn:int = 1;
      
      public static var readRewardList:int = 0;
      
      public static var showDailyRoulette:uint = 1;
      
      public static var dailyRouletteMultiplyArr:Array = [];
      
      public static var spinChance:int = 0;
      
      public static var currentLoginDay:uint = 1;
      
      public static var lv80examHackerLockHardMode:* = -1;
      
      public static var clanPrestige:int = 0;
      
      public static var showWelcomePackageAfterShop:int = 1;
      
      public static var showWelcomePackagePage:int = 1;
      
      public static var noExpOverLv80:Boolean = true;
      
      public static var backToEventPanelArr:Array = ["",""];
      
      public static var eventWallFeed:String = "";
      
      public static var needAnni5thTutorial:int = 0;
      
      public static var noBattlePetNotice:Boolean = false;
      
      public static var gotoSanbiPopup:Boolean = false;
      
      public static var showHint:Boolean = true;
      
      public static var doubleXPArr:Array = [];
      
      public static var timeGetExtraData:int = 0;
      
      public static var dragonPetChristmas:Number = 0;
      
      public static var xmasTutorialNeedDisplay:Number = 0;
      
      public static var addingXPInGashapon:Boolean = false;
      
      public static var claimNewYear2015Cloth:Boolean = false;
      
      public static var onceGiftLeft:int = 0;
      
      public static var thisonceGift:int = 0;
      
      public static var onceGiftselet:Boolean = false;
      
      public static var eventName:String = "";
      
      public static var facebookPermissionUserFriends:* = false;
      
      private static var friendListObserverList:Array = [];
      
      private static var friendPermissionObserverList:Array = [];
      
      public static var showSMissionReward:Boolean = false;
      
      public static var sMissionRewardItem:String = "";
      
      public static var sMissionRewardList:Array = [];
      
      public static var isNewClanWar:Boolean = false;
      
      public static var selectedNewClanWar:int = 0;
      
      public static var selectCastle:int = 0;
      
      public static var recruitedMembers:Array = [];
      
      public static var tmpParty:Array = [];
      
      public static var tmpPartyMembers:Array = [];
      
      public static var showHalloween2015Reward:Boolean = false;
      
      public static var Halloween2015EnemyList:Array = [];
      
      public static var Halloween2015RewardList:Array = [];
      
      public static var hashReturnStr:String = "";
      
      public static var pveCurrEnemyLevel:int = 0;
      
      public static var intiedLimbNum:int = 0;
      
      public static var startBattleId:String = "1";
      
      public static var battleFlowLogver:String = "1";
      
      public static var battleFlowLogenemy:Array = [];
      
      public static var battleFlowLogclanenemy:Array = [];
      
      public static var battleround:int = -1;
      
      public static var battleFlowLog:Object = {"battles":Array};
      
      public static var IsBackToPanel:String = "";
      
      private static var iconCanShow:int = 5;
      
      private static var pressLimit:int = 0;
      
      private static var canPress:Boolean = true;
      
      private static var rIconCanShow:int = 5;
      
      private static var rPressLimit:int = 0;
      
      private static var rCanPress:Boolean = true;
      
      private static var setupRightIconX:Boolean = true;
      
      private static var rightIconOriX:uint = 100;
      
      private static var showIconArr:Array = [];
      
      private static var showLIconArr:Array = [];
      
      private static var backUpShowIconArr:Array = [];
      
      private static var ALL_LEFT_BTN_ARR:Array = ["welcome2014Btn","chuninexamBtn","jouninexamBtn","examBtn","senninExamBtn","TrialEmblemBtn","event2017_icon","PackageBtn","MysteriousMerchant_icon","untiyBtn","limitOfferBtn","limitOffer20200826Btn","limitOffer20200805Btn","sakura2020Btn","Easter2020Btn","maskBtn","kageskillBtn","Skill901_icon","Easter2018Btn","GodSnapBtn","newDailyLoginStamp2017_icon","dailyRewardClaimMaintenanceBtn","dailyRewardClaimToken201802Btn","newYearPackage2016Btn","isLearnSkillBtn"];
      
      private static var ALL_RIGHT_BTN_ARR:Array = ["dailyScartchBtn","emblemDailygiftBtn","dailyLoginBtn","rouletteBtn","dailyWallfeedMc","dailyTaskMc","giftBtn","inviteFriendBtn","mailboxBtn","requestPopupBtn"];
      
      private static var _enemyRobotSeq:Array = [];
      
      private static var _charSeq:Array = [];
      
      private static var _charSeqStr:String = "";
      
      public function Main()
      {
         super();
      }
      
      public static function get errorCode() : String
      {
         return _errorCode;
      }
      
      public static function get errorMessage() : String
      {
         return _errorMessage;
      }
      
      public static function getLoginHash(param1:String, param2:String) : String
      {
         return proc.clientLib.getLoginHash(param1,param2);
      }
      
      public static function generateHash(param1:String, param2:String) : String
      {
         return proc.clientLib.generateHash(param1,param2);
      }
      
      public static function getHash(param1:String) : String
      {
         return proc.clientLib.getHash(Account.getAccountSessionKey(),param1);
      }
      
      public static function getArrayHash(param1:Array) : String
      {
         return proc.clientLib.getArrayHash(Account.getAccountSessionKey(),param1);
      }
      
      public static function getHashStr(param1:*, param2:String, param3:Function) : void
      {
         var obj:* = param1;
         var str:String = param2;
         var callBack:Function = param3;
         hashReturnStr = str;
         loader = BulkLoader.createUniqueNamedLoader();
         loader.add(obj.loaderInfo.url);
         loader.addEventListener(BulkLoader.COMPLETE,function(param1:Event):void
         {
            hashReturnStr += loader.getMovieClip(obj.loaderInfo.url).loaderInfo.bytesTotal;
            callBack(proc.clientLib.getHash(Account.getAccountSessionKey(),hashReturnStr));
         });
         loader.start();
      }
      
      public static function updateSequence() : String
      {
         ++amfSeq;
         return getHash(String(amfSeq));
      }
      
      public static function setMainMc(param1:MovieClip) : void
      {
         var _loc3_:String = null;
         mainMc = param1;
         proc = new MainProcess(mainMc);
         Central.main = Main;
         Central.battle = Battle;
         Central.skill = Skill;
         Central.panel = Panel;
         Central.map = Map;
         Central.mission = Mission;
         Central.token = Token;
         Central.sns = SNS;
         Central.clan = Clan;
         Central.main.toolkit = Toolkit;
         stateInventory = new StateInventory();
         TextFilter.dictionaryList = LanguageData.foulLanguage;
         SNS.initFBJSListener();
         var _loc2_:int = 0;
         while(_loc2_ < Data.SECURITY_FILES.length)
         {
            _loc3_ = Data.SECURITY_FILES[_loc2_];
            if(_loc3_.indexOf("/crossdomain.xml") >= 0)
            {
               _loc3_ += "?x=" + Math.floor(Math.random() * 10000);
            }
            Security.loadPolicyFile(_loc3_);
            _loc2_++;
         }
         mixer = Mixer.getInstance();
      }
      
      public static function getMainMc() : MovieClip
      {
         return mainMc;
      }
      
      public static function checkFeatureControl(param1:String = null) : void
      {
         Features = new FeatureControl();
         Features.checkFeatureControl(param1);
         switch(AppData.type)
         {
            case AppData.YM:
            case AppData.RR:
               break;
            case AppData.FB:
            case AppData.MP:
            case AppData.OK:
               callJS("sizeChangeCallback");
         }
      }
      
      public static function initRank() : void
      {
         if(Central.sns.friendList != null)
         {
            return;
         }
         MovieClip(mainMc.parent)["rankMc"].init();
         proc.addState(initRank,30 * 1000,true,"initRank");
      }
      
      public static function preloadData() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:Array = new Array();
         if(mainChar.xp == 0)
         {
            isNewChar = true;
            mainChar.updateCP(-60);
         }
         else
         {
            isNewChar = false;
            Main.MISSION_DATA_AA.removeById("msn0");
         }
         _loc2_.push("swf/library/library.swf");
         if(actionBase == null)
         {
            _loc2_.push("swf/actions/action_base.swf");
         }
         var _loc3_:Array = getMainChar().pendingSkills;
         var _loc4_:Array = mainChar.getSkillListArr();
         var _loc5_:Array = mainChar.getClassSkillListArr();
         var _loc6_:Array = mainChar.getData(DBCharacterData.SENJUTSU);
         if(_loc3_ == null)
         {
            _loc3_ = [];
         }
         _loc1_ = 0;
         while(_loc1_ < _loc4_.length)
         {
            if(!Skill.hasSkill(_loc4_[_loc1_]))
            {
               _loc3_.push("swf/skills/" + SKILL_DATA[_loc4_[_loc1_]].swfName + ".swf");
            }
            _loc1_++;
         }
         getMainChar().pendingSkills = _loc3_;
         _loc1_ = 0;
         while(_loc1_ < _loc6_.length)
         {
            if(!Skill.hasSkill(_loc6_[_loc1_].replace("senjutsu_","")))
            {
               _loc2_.push("swf/skills/" + SENJUTSU_SKILL_DATA[_loc6_[_loc1_]].swf_name + ".swf");
            }
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < _loc5_.length)
         {
            if(!Skill.hasClassSkill(_loc5_[_loc1_]))
            {
               _loc2_.push("swf/skills/" + SKILL_DATA[_loc5_[_loc1_]].swfName + ".swf");
            }
            _loc1_++;
         }
         var _loc7_:Array = mainChar.getBloodlineListArr();
         _loc1_ = 0;
         while(_loc1_ < _loc7_.length)
         {
            if(!Skill.hasSkill("skill" + _loc7_[_loc1_].skill_id))
            {
               _loc2_.push("swf/skills/" + BLOODLINE_SKILL_DATA["bloodline_skill" + _loc7_[_loc1_].skill_id].swf_name + ".swf");
            }
            _loc1_++;
         }
         var _loc8_:Array = mainChar.getSecretListArr();
         _loc1_ = 0;
         while(_loc1_ < _loc8_.length)
         {
            if(!Skill.hasSkill("skill" + _loc8_[_loc1_].skill_id))
            {
               _loc2_.push("swf/skills/" + BLOODLINE_SKILL_DATA["bloodline_skill" + _loc8_[_loc1_].skill_id].swf_name + ".swf");
            }
            _loc1_++;
         }
         if(!Item.hasItem(mainChar.getHair()))
         {
            _loc2_.push("swf/items/" + mainChar.getHair() + ".swf");
         }
         _loc1_ = 0;
         while(_loc1_ < mainChar.pets.length)
         {
            if(mainChar.pets[_loc1_].isEquipped())
            {
               _loc2_.push("swf/pets/" + mainChar.pets[_loc1_].swfName + ".swf");
            }
            _loc1_++;
         }
         if(AppData.type == AppData.RR)
         {
            _loc2_.push(villageNormalMap);
         }
         else
         {
            _loc2_.push(villageMap);
         }
         _loc2_.push(Data.MENU_PATH);
         _loc2_.push(Data.ACHIEVEMENT_PANEL_PATH);
         _loc2_.push(Data.MISSION_COMPLETE_PATH);
         _loc2_.push(Data.REWAED_ALERT_PATH);
         if(AppData.type == AppData.YM)
         {
         }
         if(isNewChar)
         {
            _loc2_.push("swf/mission/mission_01.swf");
         }
         loadSwf(_loc2_,preloadFinish,null,langLib.get(205));
      }
      
      private static function preloadFinish(param1:Object) : void
      {
         var _loc8_:Item = null;
         var _loc9_:* = undefined;
         var _loc10_:String = null;
         var _loc2_:uint = 0;
         lib = param1["swf/library/library.swf"];
         if(actionBase == null)
         {
            actionBase = param1["swf/actions/action_base.swf"];
         }
         mainChar.setActionBase(GF.getAsset(actionBase,"ActionBase"));
         var _loc3_:Array = mainChar.getSkillListArr();
         var _loc4_:Array = mainChar.getClassSkillListArr();
         _loc2_ = 0;
         while(_loc2_ < _loc3_.length)
         {
            if(!Skill.hasSkill(_loc3_[_loc2_]))
            {
               Skill.setSkill(_loc3_[_loc2_],param1["swf/skills/" + SKILL_DATA[_loc3_[_loc2_]].swfName + ".swf"]);
            }
            _loc2_++;
         }
         _loc2_ = 0;
         while(_loc2_ < _loc4_.length)
         {
            if(!Skill.hasClassSkill(_loc4_[_loc2_]))
            {
               Skill.setClassSkill(_loc4_[_loc2_],param1["swf/skills/" + SKILL_DATA[_loc4_[_loc2_]].swfName + ".swf"]);
            }
            _loc2_++;
         }
         var _loc5_:Array = mainChar.getData(DBCharacterData.SENJUTSU);
         _loc2_ = 0;
         while(_loc2_ < _loc5_.length)
         {
            if(!Skill.hasSkill(_loc5_[_loc2_].replace("senjutsu_","")))
            {
               Skill.setSkill(_loc5_[_loc2_].replace("senjutsu_",""),param1["swf/skills/" + SENJUTSU_SKILL_DATA[_loc5_[_loc2_]].swf_name + ".swf"]);
            }
            _loc2_++;
         }
         var _loc6_:Array = mainChar.getBloodlineListArr();
         _loc2_ = 0;
         while(_loc2_ < _loc6_.length)
         {
            if(!Skill.hasSkill("skill" + _loc6_[_loc2_].skill_id))
            {
               Skill.setSkill("skill" + _loc6_[_loc2_].skill_id,param1["swf/skills/" + BLOODLINE_SKILL_DATA["bloodline_skill" + _loc6_[_loc2_].skill_id].swf_name + ".swf"]);
            }
            _loc2_++;
         }
         var _loc7_:Array = mainChar.getSecretListArr();
         _loc2_ = 0;
         while(_loc2_ < _loc7_.length)
         {
            if(!Skill.hasSkill("skill" + _loc7_[_loc2_].skill_id))
            {
               Skill.setSkill("skill" + _loc7_[_loc2_].skill_id,param1["swf/skills/" + BLOODLINE_SKILL_DATA["bloodline_skill" + _loc7_[_loc2_].skill_id].swf_name + ".swf"]);
            }
            _loc2_++;
         }
         if(!Item.hasItem(mainChar.getHair()))
         {
            _loc8_ = new Item(mainChar.getHair());
            _loc8_.setSwf(param1["swf/items/" + mainChar.getHair() + ".swf"]);
            Item.setItem(_loc8_);
         }
         _loc2_ = 0;
         while(_loc2_ < mainChar.pets.length)
         {
            if(mainChar.pets[_loc2_].isEquipped())
            {
               _loc9_ = mainChar.pets[_loc2_];
               Out.debug("Main","set pet swfName>" + _loc9_.swfName);
               _loc9_.loadedSwf = param1["swf/pets/" + _loc9_.swfName + ".swf"];
            }
            _loc2_++;
         }
         mainChar.customizeCharacter();
         if(AppData.type == AppData.RR)
         {
            mainMc.mapMc = param1[villageNormalMap];
         }
         else
         {
            mainMc.mapMc = param1[villageMap];
            Main.mainMapObject[villageMap] = param1[villageMap];
         }
         mainMc.mapMenuMc = param1[Data.MENU_PATH];
         achievementPanel = param1[Data.ACHIEVEMENT_PANEL_PATH];
         popup.mcToPopup(param1[Data.MISSION_COMPLETE_PATH],"missionComplete02","achievementMc");
         popup.mcToPopup(param1[Data.REWAED_ALERT_PATH],"rewardalert","achievementMc");
         if(isNewChar)
         {
            Mission.setMission("msn0",param1["swf/mission/mission_01.swf"]);
         }
         if(activeNpc)
         {
            _loc10_ = activeNpc.toString();
            setNpcParty(activeNpc,startGame,{
               "status":"1",
               "signature":getHash("1" + _loc10_ + Account.getAccountBalance()),
               "npc_id":_loc10_,
               "old_recruit":true
            });
         }
         else
         {
            startGame();
         }
      }
      
      public static function setMainChar(param1:DBCharacter) : void
      {
         StaticVariables.xpStr = proc.encrypt(String(param1[DBCharacterData.XP]));
         StaticVariables.weaponStr = proc.encrypt(String(param1.character_body_parts["weapon"]));
         mainChar = new Character(param1);
         mainChar.securityCheck();
      }
      
      public static function getMainChar() : Character
      {
         return mainChar;
      }
      
      public static function getDBChar() : DBCharacter
      {
         if(mainChar)
         {
            return mainChar.getDBChar();
         }
         return null;
      }
      
      public static function saveCharacter(param1:Boolean = false) : void
      {
      }
      
      public static function saveCharacter_CB() : void
      {
         if(mapMenu)
         {
            mapMenu.displayStatus("");
         }
      }
      
      public static function setPreviewChar() : void
      {
         previewChar = new Character(new DBCharacter());
      }
      
      public static function getPreviewChar() : Character
      {
         return previewChar;
      }
      
      public static function showDialogue(param1:Array, param2:uint) : void
      {
         Central.main.stopMusic();
         mainMc["dialogueMc"].show(param1,param2);
      }
      
      public static function setDialogueCB(param1:Function) : void
      {
         mainMc["dialogueMc"].setDialogueCB(param1);
      }
      
      public static function replaceText(param1:String) : String
      {
         return param1.replace("[playername]",mainChar.getCharacterName());
      }
      
      public static function setNpcParty(param1:Array, param2:Function, param3:Object) : void
      {
         var _loc4_:uint = 0;
         var _loc6_:String = null;
         var _loc7_:int = 0;
         var _loc8_:Object = null;
         if(Central.main.validateAmfResponse(param3))
         {
            _loc6_ = param3.signature;
            if(_loc6_ != getHash(param3.status + param3.npc_id + Account.getAccountBalance()))
            {
               onError("120");
               return;
            }
            if(param3.old_recruit != true)
            {
               _loc4_ = 0;
               while(_loc4_ < param1.length)
               {
                  _loc8_ = param1[_loc4_];
                  _loc7_ += _loc8_.token as int;
                  tracking.trackSale(tracking.SALE_NPC,_loc8_.token,_loc8_.id);
                  _loc4_++;
               }
               Account.balance = Account.getAccountBalance() - _loc7_;
               Central.main.tracking.trackRecruitNpc(2);
            }
            showAmfLoading();
            loadNpc_CB = param2;
            var _loc5_:Array = [];
            activeNpc = param1;
            _loc4_ = 0;
            while(_loc4_ < activeNpc.length)
            {
               if(!Npc.hasNpcSwf(activeNpc[_loc4_].swfName))
               {
                  if(_loc5_.indexOf("swf/npc/" + activeNpc[_loc4_].swfName + ".swf") < 0)
                  {
                     _loc5_.push("swf/npc/" + activeNpc[_loc4_].swfName + ".swf");
                  }
               }
               _loc4_++;
            }
            if(_loc5_.length > 0)
            {
               loadSwf(_loc5_,loadNpcFinish);
            }
            else
            {
               loadNpcFinish(null);
            }
            return;
         }
      }
      
      public static function loadNpcFinish(param1:Object = null) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:int = 0;
         var _loc4_:Object = null;
         if(partyNpc == null)
         {
            partyNpc = [];
         }
         _loc2_ = 0;
         while(_loc2_ < activeNpc.length)
         {
            if(param1 != null)
            {
               if(!Npc.hasNpcSwf(activeNpc[_loc2_].swfName))
               {
                  Npc.addNpcSwf(activeNpc[_loc2_].swfName,param1["swf/npc/" + activeNpc[_loc2_].swfName + ".swf"]);
               }
            }
            _loc3_ = 0;
            if(activeNpc[_loc2_].id != null)
            {
               _loc3_ = int(activeNpc[_loc2_].id);
            }
            activeNpc[_loc2_].npcDataId = _loc3_;
            _loc4_ = new Npc(activeNpc[_loc2_]);
            partyNpc.push(_loc4_);
            _loc2_++;
         }
         activeNpc = null;
         hideAmfLoading();
         if(loadNpc_CB != null)
         {
            loadNpc_CB();
            loadNpc_CB = null;
         }
      }
      
      public static function setMissionNpc(param1:int, param2:String) : void
      {
         switch(Mission.curMissionID)
         {
            case "msn59":
               if(partyNpc == null || partyNpc.length == 0)
               {
                  if(param1 == 0)
                  {
                     setFreeNpcParty([{
                        "name":"Shin",
                        "swfName":"npc_1",
                        "clsName":"Npc_1"
                     },{
                        "name":"Genzu",
                        "swfName":"npc_2",
                        "clsName":"Npc_2"
                     }],null);
                  }
               }
         }
      }
      
      private static function setFreeNpcParty(param1:Array, param2:Function) : void
      {
         var _loc4_:uint = 0;
         showAmfLoading();
         loadNpc_CB = param2;
         var _loc3_:Array = [];
         _partyMembers = param1;
         _loc4_ = 0;
         while(_loc4_ < _partyMembers.length)
         {
            if(!Npc.hasNpcSwf(_partyMembers[_loc4_].swfName))
            {
               if(_loc3_.indexOf("swf/npc/" + _partyMembers[_loc4_].swfName + ".swf") < 0)
               {
                  _loc3_.push("swf/npc/" + _partyMembers[_loc4_].swfName + ".swf");
               }
            }
            _loc4_++;
         }
         if(_loc3_.length > 0)
         {
            loadSwf(_loc3_,loadFreeNpcFinish);
         }
         else
         {
            loadFreeNpcFinish(null);
         }
      }
      
      public static function loadFreeNpcFinish(param1:Object = null) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:int = 0;
         _loc2_ = 0;
         while(_loc2_ < _partyMembers.length)
         {
            if(param1 != null)
            {
               if(!Npc.hasNpcSwf(_partyMembers[_loc2_].swfName))
               {
                  Npc.addNpcSwf(_partyMembers[_loc2_].swfName,param1["swf/npc/" + _partyMembers[_loc2_].swfName + ".swf"]);
               }
            }
            _loc3_ = 0;
            if(_partyMembers[_loc2_].id != null)
            {
               _loc3_ = int(_partyMembers[_loc2_].id);
            }
            _partyMembers[_loc2_] = new Npc(_partyMembers[_loc2_]);
            _partyMembers[_loc2_].npcDataId = _loc3_;
            _loc2_++;
         }
         hideAmfLoading();
         if(loadNpc_CB != null)
         {
            loadNpc_CB();
            loadNpc_CB = null;
         }
      }
      
      public static function setEventFreeNpc(param1:int, param2:Function) : void
      {
         loadNpc_CB = param2;
         switch(Main.eventName)
         {
            case "Vday2019":
               partyNpc = null;
               if(param1 == 0)
               {
                  setFreeNpcParty([{
                     "name":"Cupid",
                     "swfName":"npc_11",
                     "clsName":"Npc_11"
                  }],loadNpc_CB);
               }
               else if(param1 == 1)
               {
                  setFreeNpcParty([{
                     "name":"Venus",
                     "swfName":"npc_12",
                     "clsName":"Npc_12"
                  }],loadNpc_CB);
               }
               else if(param1 == 2)
               {
                  setFreeNpcParty([{
                     "name":"Rose Knight",
                     "swfName":"npc_13",
                     "clsName":"Npc_13"
                  }],loadNpc_CB);
               }
               else
               {
                  setFreeNpcParty([{
                     "name":"Ryuma",
                     "swfName":"npc_3",
                     "clsName":"Npc_3"
                  }],loadNpc_CB);
               }
         }
      }
      
      public static function getCharRank(param1:int) : int
      {
         if(param1 <= 20)
         {
            return 1;
         }
         if(param1 <= 40)
         {
            return 3;
         }
         if(param1 <= 60)
         {
            return 5;
         }
         if(param1 <= 80)
         {
            return 7;
         }
         return 9;
      }
      
      public static function checkPetEP() : void
      {
         if(mainChar.pet.petEP <= 0 && mainChar.pet.petMaxEp > 0)
         {
            Central.main.showOk(AppData.lang == AppData.ZH ? "你現在裝備的寵物能量不足, 請卸下有關寵物!" : "Your Pet\'s energy point is not enough, please unequip!",function():*
            {
            });
            return;
         }
      }
      
      public static function setEnemy(param1:Array) : void
      {
         var _loc3_:uint = 0;
         Battle.type = Battle.TYPE_LOCAL;
         Central.client.getInstance().joinRoom();
         var _loc2_:Array = [];
         aiCharArr = null;
         enemyArr = param1;
         battleFlowLogenemy = param1;
         if(Central.mission.curMissionID == "msn205" || Central.mission.curMissionID == "msn227")
         {
            Central.main.tracking.trackExamPart(Central.mission.curMissionID,Central.mission.curMission.curStage,Central.main.tracking.TRACK_START);
         }
         _loc3_ = 0;
         while(_loc3_ < param1.length)
         {
            if(param1[_loc3_])
            {
               if(!Enemy.hasEnemySwf(param1[_loc3_].swfName))
               {
                  if(_loc2_.indexOf("swf/enemies/" + param1[_loc3_].swfName + ".swf") < 0)
                  {
                     _loc2_.push("swf/enemies/" + param1[_loc3_].swfName + ".swf");
                  }
               }
            }
            else
            {
               Out.error("Main","_enemyArr >> " + param1);
            }
            _loc3_++;
         }
         var _loc4_:Array = getMainChar().pendingSkills;
         if(_loc4_)
         {
            _loc3_ = 0;
            while(_loc3_ < _loc4_.length)
            {
               _loc2_.push(_loc4_[_loc3_]);
               _loc3_++;
            }
         }
         if(_loc2_.length > 0)
         {
            loadSwf(_loc2_,startBattle);
         }
         else
         {
            startBattle();
         }
      }
      
      public static function setPvEEnemy(param1:Array) : void
      {
         var _loc2_:int = 0;
         enemyArr = param1;
         var _loc3_:Array = [];
         _loc2_ = 0;
         while(_loc2_ < param1.length)
         {
            if(param1[_loc2_])
            {
               if(!Enemy.hasEnemySwf(param1[_loc2_].swfName))
               {
                  if(_loc3_.indexOf("swf/enemies/" + param1[_loc2_].swfName + ".swf") < 0)
                  {
                     _loc3_.push("swf/enemies/" + param1[_loc2_].swfName + ".swf");
                  }
               }
            }
            else
            {
               Out.error("Main","_enemyArr >> " + param1);
            }
            _loc2_++;
         }
         if(_loc3_.length > 0)
         {
            loadSwf(_loc3_,loadedPveEnemyCB);
         }
      }
      
      public static function loadedPveEnemyCB(param1:Object = null) : void
      {
         var _loc2_:uint = 0;
         _loc2_ = 0;
         while(_loc2_ < enemyArr.length)
         {
            if(param1 != null)
            {
               if(!Enemy.hasEnemySwf(enemyArr[_loc2_].swfName))
               {
                  Enemy.addEnemySwf(enemyArr[_loc2_].swfName,param1["swf/enemies/" + enemyArr[_loc2_].swfName + ".swf"]);
               }
            }
            _loc2_++;
         }
      }
      
      public static function startBattle(param1:Object = null) : void
      {
         var _loc2_:uint = 0;
         var _loc4_:Array = null;
         var _loc5_:Array = null;
         var _loc6_:Array = null;
         var _loc7_:Array = null;
         var _loc8_:Array = null;
         var _loc9_:Array = null;
         _loc2_ = 0;
         while(_loc2_ < enemyArr.length)
         {
            if(param1 != null)
            {
               if(!Enemy.hasEnemySwf(enemyArr[_loc2_].swfName))
               {
                  Enemy.addEnemySwf(enemyArr[_loc2_].swfName,param1["swf/enemies/" + enemyArr[_loc2_].swfName + ".swf"]);
               }
            }
            _loc2_++;
         }
         if(param1 != null)
         {
            _loc4_ = getMainChar().getSkillListArr();
            if(_loc4_ != null)
            {
               _loc2_ = 0;
               while(_loc2_ < _loc4_.length)
               {
                  if(!Skill.hasSkill(_loc4_[_loc2_]))
                  {
                     Skill.setSkill(_loc4_[_loc2_],param1["swf/skills/" + SKILL_DATA[_loc4_[_loc2_]].swfName + ".swf"]);
                  }
                  _loc2_++;
               }
            }
            _loc5_ = getMainChar().getClassSkillListArr();
            if(_loc5_ != null)
            {
               _loc2_ = 0;
               while(_loc2_ < _loc5_.length)
               {
                  if(!Skill.hasClassSkill(_loc5_[_loc2_]))
                  {
                     Skill.setClassSkill(_loc5_[_loc2_],param1["swf/skills/" + SKILL_DATA[_loc5_[_loc2_]].swfName + ".swf"]);
                  }
                  _loc2_++;
               }
            }
            _loc6_ = getMainChar().getData(DBCharacterData.SENJUTSU);
            if(_loc6_ != null)
            {
               _loc2_ = 0;
               while(_loc2_ < _loc6_.length)
               {
                  if(!Skill.hasSkill(_loc6_[_loc2_].replace("senjutsu_","")))
                  {
                     Skill.setSkill(_loc6_[_loc2_].replace("senjutsu_",""),param1["swf/skills/" + SENJUTSU_SKILL_DATA[_loc6_[_loc2_]].swf_name + ".swf"]);
                  }
                  _loc2_++;
               }
            }
            _loc7_ = mainChar.getBloodlineListArr();
            _loc2_ = 0;
            while(_loc2_ < _loc7_.length)
            {
               if(!Skill.hasSkill("skill" + _loc7_[_loc2_].skill_id))
               {
                  Skill.setSkill("skill" + _loc7_[_loc2_].skill_id,param1["swf/skills/" + BLOODLINE_SKILL_DATA["bloodline_skill" + _loc7_[_loc2_].skill_id].swf_name + ".swf"]);
               }
               _loc2_++;
            }
            _loc8_ = mainChar.getSecretListArr();
            _loc2_ = 0;
            while(_loc2_ < _loc8_.length)
            {
               if(!Skill.hasSkill("skill" + _loc8_[_loc2_].skill_id))
               {
                  Skill.setSkill("skill" + _loc8_[_loc2_].skill_id,param1["swf/skills/" + BLOODLINE_SKILL_DATA["bloodline_skill" + _loc8_[_loc2_].skill_id].swf_name + ".swf"]);
               }
               _loc2_++;
            }
            if(_loc4_ != null || _loc5_ != null || _loc7_ != null || _loc8_ != null)
            {
               _loc9_ = getMainChar().pendingSkills;
               if(_loc9_)
               {
                  getMainChar().pendingSkills = null;
                  getMainChar().updateSkillSwf();
               }
            }
         }
         var _loc3_:Object = {};
         _loc3_.event = "info";
         _loc3_.state = "ready";
         Central.client.getInstance().sendData(_loc3_);
      }
      
      public static function gotoBattle() : void
      {
         if(checkGameStatus() == Timeline.BATTLE && Battle.type == Battle.TYPE_NETWORK)
         {
            Central.battle.resetBattleSetting();
            Central.battle.deleteBattleLikeFinish();
            Central.battle.callMcToReload();
         }
         else
         {
            mainMc.gotoBattle();
         }
      }
      
      public static function addOpponent(param1:DBCharacter, param2:Object) : void
      {
         var _loc3_:* = new PvPCharacter(param1);
         if(param2)
         {
            _loc3_.initPet(dataParser.parsePetData(param2),param2.swfName,param2.clsName);
         }
         battleCharacters.push(_loc3_);
      }
      
      public static function removeOpponent(param1:int) : void
      {
         var _loc2_:uint = 0;
         while(_loc2_ < battleChars.length)
         {
            if(battleChars[_loc2_].getData(DBCharacterData.ID) == param1)
            {
               battleChars.splice(_loc2_,1);
            }
            _loc2_++;
         }
      }
      
      public static function resetOpponent() : void
      {
         battleCharacters = [];
      }
      
      public static function get battleChars() : Array
      {
         return battleCharacters;
      }
      
      public static function initPvPBattle() : void
      {
         Main.achievement.updateBattleStat(achievementData.LIVE_BATTLE,1);
         Battle.type = Battle.TYPE_NETWORK;
         loadCharacterSwf(battleCharacters,pvpBattleLoadFinish);
      }
      
      private static function pvpBattleLoadFinish() : void
      {
         socket.loadBattleCompelete();
      }
      
      public static function initChallenge(param1:Array, param2:String = null) : void
      {
         var _loc3_:uint = 0;
         var _loc4_:AICharacter = null;
         if(param2)
         {
            challengeFriendUID = param2;
         }
         Battle.type = Battle.TYPE_LOCAL;
         Central.client.getInstance().joinRoom();
         enemyArr = null;
         aiCharArr = [];
         Main.achievement.updateCharStat(Main.achievementData.CHALLENGE_DONE,param1.length);
         _loc3_ = 0;
         while(_loc3_ < param1.length)
         {
            _loc4_ = new AICharacter(param1[_loc3_].dbChar);
            if(param1[_loc3_].petData)
            {
               _loc4_.initPet(dataParser.parsePetData(param1[_loc3_].petData),param1[_loc3_].petData.swfName,param1[_loc3_].petData.clsName);
            }
            aiCharArr.push(_loc4_);
            _loc3_++;
         }
         loadCharacterSwf(aiCharArr,challengeLoadFinish);
      }
      
      public static function initAnni3Challenge(param1:Array) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:AICharacter = null;
         Battle.type = Battle.TYPE_LOCAL;
         Central.client.getInstance().joinRoom();
         enemyArr = null;
         aiCharArr = [];
         _loc2_ = 0;
         while(_loc2_ < param1.length)
         {
            _loc3_ = new AICharacter(param1[_loc2_]);
            aiCharArr.push(_loc3_);
            _loc2_++;
         }
         loadCharacterSwf(aiCharArr,challengeLoadFinish);
      }
      
      private static function challengeLoadFinish() : void
      {
         var _loc1_:Object = {};
         _loc1_.event = "info";
         _loc1_.state = "ready";
         Central.client.getInstance().sendData(_loc1_);
      }
      
      public static function loadCharacterSwf(param1:Array, param2:Function) : void
      {
         var _loc4_:uint = 0;
         var _loc6_:Character = null;
         var _loc7_:Array = null;
         var _loc8_:uint = 0;
         var _loc9_:Array = null;
         var _loc10_:Array = null;
         var _loc11_:Array = null;
         var _loc12_:Array = null;
         var _loc13_:Object = null;
         var _loc14_:String = null;
         var _loc15_:String = null;
         loadingChars = param1;
         loadCharFinish_CB = param2;
         var _loc3_:Array = new Array();
         _loc4_ = 0;
         while(_loc4_ < loadingChars.length)
         {
            Out.debug("loadCharacterSwf :: ","loadingChars >> " + loadingChars);
            _loc6_ = loadingChars[_loc4_];
            _loc7_ = _loc6_.getSkillListArr();
            _loc8_ = 0;
            while(_loc8_ < _loc7_.length)
            {
               if(!Skill.hasSkill(_loc7_[_loc8_]))
               {
                  if(SKILL_DATA[_loc7_[_loc8_]])
                  {
                     _loc3_.push("swf/skills/" + SKILL_DATA[_loc7_[_loc8_]].swfName + ".swf");
                  }
                  else
                  {
                     Out.error("Main","loadCharacterSwf :: skill data error :: " + _loc7_[_loc8_]);
                  }
               }
               _loc8_++;
            }
            _loc9_ = _loc6_.getClassSkillListArr();
            _loc8_ = 0;
            while(_loc8_ < _loc9_.length)
            {
               if(!Skill.hasClassSkill(_loc9_[_loc8_]))
               {
                  _loc3_.push("swf/skills/" + SKILL_DATA[_loc9_[_loc8_]].swfName + ".swf");
               }
               _loc8_++;
            }
            _loc10_ = _loc6_.getBloodlineListArr();
            _loc8_ = 0;
            while(_loc8_ < _loc10_.length)
            {
               if(!Skill.hasSkill("skill" + _loc10_[_loc8_].skill_id))
               {
                  _loc3_.push("swf/skills/" + BLOODLINE_SKILL_DATA["bloodline_skill" + _loc10_[_loc8_].skill_id].swf_name + ".swf");
               }
               _loc8_++;
            }
            _loc11_ = _loc6_.getSecretListArr();
            _loc8_ = 0;
            while(_loc8_ < _loc11_.length)
            {
               if(!Skill.hasSkill("skill" + _loc11_[_loc8_].skill_id))
               {
                  _loc3_.push("swf/skills/" + BLOODLINE_SKILL_DATA["bloodline_skill" + _loc11_[_loc8_].skill_id].swf_name + ".swf");
               }
               _loc8_++;
            }
            _loc12_ = _loc6_.getSenjutsuListArr();
            _loc8_ = 0;
            while(_loc8_ < _loc12_.length)
            {
               if(!Skill.hasSkill("skill" + _loc12_[_loc8_].skill_id))
               {
                  _loc3_.push("swf/skills/" + SENJUTSU_SKILL_DATA["senjutsu_skill" + _loc12_[_loc8_].skill_id].swf_name + ".swf");
               }
               _loc8_++;
            }
            if(!Item.hasItem(_loc6_.getFace()))
            {
               _loc3_.push("swf/items/" + _loc6_.getFace() + ".swf");
            }
            if(!Item.hasItem(_loc6_.getHair()))
            {
               _loc3_.push("swf/items/" + _loc6_.getHair() + ".swf");
            }
            _loc13_ = _loc6_.getGender() == 0 ? BODY_SET_BOY : BODY_SET_GIRL;
            if(_loc13_[_loc6_.getBodySet()])
            {
               if(!Item.hasItem(_loc13_[_loc6_.getBodySet()].swfName))
               {
                  _loc3_.push("swf/items/" + _loc13_[_loc6_.getBodySet()].swfName + ".swf");
               }
            }
            else
            {
               Out.error("Main","loadCharacterSwf :: clothing data error :: " + _loc6_.getBodySet());
            }
            _loc14_ = _loc6_.getWeapon();
            Out.debug(null,"equippiedWeaponequippiedWeapon is " + _loc14_);
            if(WEAPON_DATA.containsKey(_loc14_))
            {
               Out.debug(null,"oh ya? equippiedWeaponequippiedWeapon is " + _loc14_);
               if(!Item.hasItem(_loc14_))
               {
                  _loc3_.push("swf/items/" + WEAPON_DATA.find(_loc14_).swfName + ".swf");
               }
            }
            _loc15_ = _loc6_.getBackItem();
            if(BACK_ITEM_DATA.containsKey(_loc15_))
            {
               if(!Item.hasItem(_loc15_))
               {
                  _loc3_.push("swf/items/" + BACK_ITEM_DATA.find(_loc15_).swfName + ".swf");
               }
            }
            if(_loc6_.pet)
            {
               _loc3_.push("swf/pets/" + _loc6_.pet.swfName + ".swf");
            }
            _loc4_++;
         }
         var _loc5_:Array = getMainChar().pendingSkills;
         if(_loc5_)
         {
            _loc4_ = 0;
            while(_loc4_ < _loc5_.length)
            {
               _loc3_.push(_loc5_[_loc4_]);
               _loc4_++;
            }
         }
         if(_loc3_.length == 0)
         {
            loadCharacterSwfFinish(null);
         }
         else
         {
            loadSwf(_loc3_,loadCharacterSwfFinish);
         }
      }
      
      private static function loadCharacterSwfFinish(param1:Object) : void
      {
         var _loc4_:Character = null;
         var _loc5_:Array = null;
         var _loc6_:uint = 0;
         var _loc7_:Array = null;
         var _loc8_:Array = null;
         var _loc9_:Array = null;
         var _loc10_:Array = null;
         var _loc11_:Item = null;
         var _loc12_:Object = null;
         var _loc13_:String = null;
         var _loc14_:String = null;
         var _loc15_:Array = null;
         var _loc2_:uint = 0;
         _loc2_ = 0;
         while(_loc2_ < loadingChars.length)
         {
            _loc4_ = loadingChars[_loc2_];
            _loc4_.setActionBase(GF.getAsset(actionBase,"ActionBase"));
            _loc5_ = _loc4_.getSkillListArr();
            _loc6_ = 0;
            while(_loc6_ < _loc5_.length)
            {
               if(!Skill.hasSkill(_loc5_[_loc6_]))
               {
                  if(SKILL_DATA[_loc5_[_loc6_]])
                  {
                     Skill.setSkill(_loc5_[_loc6_],param1["swf/skills/" + SKILL_DATA[_loc5_[_loc6_]].swfName + ".swf"]);
                  }
               }
               _loc6_++;
            }
            _loc7_ = _loc4_.getClassSkillListArr();
            if(_loc7_ != null)
            {
               _loc6_ = 0;
               while(_loc6_ < _loc7_.length)
               {
                  if(!Skill.hasClassSkill(_loc7_[_loc6_]))
                  {
                     Out.debug("loadCharacterSwfFinish :: ","classSkillList[j] >> " + _loc7_[_loc6_]);
                     Skill.setClassSkill(_loc7_[_loc6_],param1["swf/skills/" + SKILL_DATA[_loc7_[_loc6_]].swfName + ".swf"]);
                  }
                  _loc6_++;
               }
            }
            _loc8_ = _loc4_.getSenjutsuListArr();
            if(_loc8_ != null)
            {
               _loc6_ = 0;
               while(_loc6_ < _loc8_.length)
               {
                  if(!Skill.hasSkill("skill" + _loc8_[_loc6_].skill_id))
                  {
                     Skill.setSkill("skill" + _loc8_[_loc6_].skill_id,param1["swf/skills/" + SENJUTSU_SKILL_DATA["senjutsu_skill" + _loc8_[_loc6_].skill_id].swf_name + ".swf"]);
                  }
                  _loc6_++;
               }
            }
            _loc9_ = _loc4_.getBloodlineListArr();
            _loc6_ = 0;
            while(_loc6_ < _loc9_.length)
            {
               if(!Skill.hasSkill("skill" + _loc9_[_loc6_].skill_id))
               {
                  Skill.setSkill("skill" + _loc9_[_loc6_].skill_id,param1["swf/skills/" + BLOODLINE_SKILL_DATA["bloodline_skill" + _loc9_[_loc6_].skill_id].swf_name + ".swf"]);
               }
               _loc6_++;
            }
            _loc10_ = _loc4_.getSecretListArr();
            _loc6_ = 0;
            while(_loc6_ < _loc10_.length)
            {
               if(!Skill.hasSkill("skill" + _loc10_[_loc6_].skill_id))
               {
                  Skill.setSkill("skill" + _loc10_[_loc6_].skill_id,param1["swf/skills/" + BLOODLINE_SKILL_DATA["bloodline_skill" + _loc10_[_loc6_].skill_id].swf_name + ".swf"]);
               }
               _loc6_++;
            }
            if(!Item.hasItem(_loc4_.getFace()))
            {
               _loc11_ = new Item(_loc4_.getFace());
               _loc11_.setSwf(param1["swf/items/" + _loc4_.getFace() + ".swf"]);
               Item.setItem(_loc11_);
            }
            if(!Item.hasItem(_loc4_.getHair()))
            {
               _loc11_ = new Item(_loc4_.getHair());
               _loc11_.setSwf(param1["swf/items/" + _loc4_.getHair() + ".swf"]);
               Item.setItem(_loc11_);
            }
            _loc12_ = _loc4_.getGender() == 0 ? BODY_SET_BOY : BODY_SET_GIRL;
            if(_loc12_[_loc4_.getBodySet()])
            {
               if(!Item.hasItem(_loc12_[_loc4_.getBodySet()].swfName))
               {
                  _loc11_ = new Item(_loc12_[_loc4_.getBodySet()].swfName);
                  _loc11_.setSwf(param1["swf/items/" + _loc12_[_loc4_.getBodySet()].swfName + ".swf"]);
                  Item.setItem(_loc11_);
               }
            }
            _loc13_ = _loc4_.getWeapon();
            if(WEAPON_DATA.containsKey(_loc13_))
            {
               if(!Item.hasItem(_loc13_))
               {
                  _loc11_ = new Item(_loc13_);
                  _loc11_.setSwf(param1["swf/items/" + WEAPON_DATA.find(_loc13_).swfName + ".swf"]);
                  Item.setItem(_loc11_);
               }
            }
            _loc14_ = _loc4_.getBackItem();
            if(BACK_ITEM_DATA.containsKey(_loc14_))
            {
               if(!Item.hasItem(_loc14_))
               {
                  _loc11_ = new Item(_loc14_);
                  _loc11_.setSwf(param1["swf/items/" + BACK_ITEM_DATA.find(_loc14_).swfName + ".swf"]);
                  Item.setItem(_loc11_);
               }
            }
            _loc4_.updateSkillSwf();
            if(_loc4_.pet)
            {
               _loc4_.pet.loadedSwf = param1["swf/pets/" + _loc4_.pet.swfName + ".swf"];
            }
            _loc2_++;
         }
         var _loc3_:Array = getMainChar().pendingSkills;
         if(_loc3_ != null)
         {
            _loc15_ = getMainChar().getSkillListArr();
            if(_loc15_ != null)
            {
               _loc2_ = 0;
               while(_loc2_ < _loc15_.length)
               {
                  if(!Skill.hasSkill(_loc15_[_loc2_]))
                  {
                     Skill.setSkill(_loc15_[_loc2_],param1["swf/skills/" + SKILL_DATA[_loc15_[_loc2_]].swfName + ".swf"]);
                  }
                  _loc2_++;
               }
            }
            if(_loc15_ != null)
            {
               if(_loc3_)
               {
                  getMainChar().pendingSkills = null;
                  getMainChar().updateSkillSwf();
               }
            }
         }
         loadingChars = null;
         loadCharFinish_CB();
      }
      
      public static function createCharacter(param1:DBCharacter) : Character
      {
         return new Character(param1);
      }
      
      public static function createEnemy(param1:Object) : Enemy
      {
         return new Enemy(param1);
      }
      
      public static function getEnemy() : Array
      {
         return enemyArr;
      }
      
      public static function getAIChars() : Array
      {
         return aiCharArr;
      }
      
      public static function battleWin() : void
      {
         if(Mission.isOnMapMission())
         {
            Mission.killMapEnemy();
            mainMc.gotoMapMission();
            return;
         }
         switch(Mission.onMission())
         {
            case Mission.TYPE_ENGAGE:
               mainMc.gotoEngage();
               return;
            case Mission.TYPE_MAP_MISSION:
         }
         if(Battle.type == Battle.TYPE_NETWORK)
         {
            mainMc.gotoPanel();
         }
         else if(Battle.subType == BattleData.SUBTYPE_CLAN)
         {
            Battle.subType = BattleData.SUBTYPE_NORMAL;
            mainChar.restoreOriginalStatus();
            if(mainChar.pet)
            {
               mainChar.pet.restoreOriginalStatus();
            }
            mainMc.gotoPanel();
         }
         else
         {
            mainMc.gotoMap();
         }
         Battle.subType = BattleData.SUBTYPE_NORMAL;
      }
      
      public static function battleRun() : void
      {
         if(Mission.isOnMapMission())
         {
            Mission.failMission();
            return;
         }
         if(Mission.dispatchGameEvent(GameEvents.BATTLE_LOSE))
         {
            Central.main.showDeadPopup();
            return;
         }
         Main.showInfo(langLib.get(206));
         if(Battle.subType == BattleData.SUBTYPE_CLAN)
         {
            Battle.subType = BattleData.SUBTYPE_NORMAL;
            mainChar.restoreOriginalStatus();
            if(mainChar.pet)
            {
               mainChar.pet.restoreOriginalStatus();
            }
            mainMc.gotoPanel();
         }
         else
         {
            Central.main.showDeadPopup();
            mainMc.gotoMap();
         }
         Battle.subType = BattleData.SUBTYPE_NORMAL;
      }
      
      public static function battleLose() : void
      {
         if(Mission.isOnMapMission())
         {
            Mission.failMission();
            return;
         }
         if(Mission.dispatchGameEvent(GameEvents.BATTLE_LOSE))
         {
            Central.main.showDeadPopup();
            return;
         }
         if(Battle.type == Battle.TYPE_NETWORK)
         {
            mainMc.gotoPanel();
            return;
         }
         if(Battle.subType == BattleData.SUBTYPE_CLAN)
         {
            Battle.subType = BattleData.SUBTYPE_NORMAL;
            mainChar.restoreOriginalStatus();
            if(mainChar.pet)
            {
               mainChar.pet.restoreOriginalStatus();
            }
            mainMc.gotoPanel();
         }
         else
         {
            Main.showInfo(langLib.get(207));
            Central.main.showDeadPopup();
            mainMc.gotoMap();
         }
         Battle.subType = BattleData.SUBTYPE_NORMAL;
      }
      
      public static function playBattleEffect(param1:MovieClip) : void
      {
         if(checkGameStatus() == Timeline.BATTLE)
         {
            mainMc["battleEffectMc"].addChild(param1);
            param1.gotoAndPlay(2);
         }
      }
      
      public static function removeBattleEffect() : void
      {
         if(checkGameStatus() == Timeline.BATTLE)
         {
            GF.removeAllChild(mainMc["battleEffectMc"]);
         }
      }
      
      public static function initMapMission() : void
      {
         var _loc3_:uint = 0;
         var _loc1_:Array = Mission.getMapMissionEnemies();
         var _loc2_:Array = [];
         _loc3_ = 0;
         while(_loc3_ < _loc1_.length)
         {
            if(!Enemy.hasEnemySwf(_loc1_[_loc3_].enemies[0].swfName))
            {
               _loc2_.push("swf/enemies/" + _loc1_[_loc3_].enemies[0].swfName + ".swf");
            }
            _loc3_++;
         }
         if(_loc2_.length > 0)
         {
            loadSwf(_loc2_,startMapMission);
         }
         else
         {
            startMapMission();
         }
      }
      
      private static function startMapMission(param1:Object = null) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:Array = Mission.getMapMissionEnemies();
         _loc2_ = 0;
         while(_loc2_ < _loc3_.length)
         {
            if(param1 != null)
            {
               if(!Enemy.hasEnemySwf(_loc3_[_loc2_].enemies[0].swfName))
               {
                  Enemy.addEnemySwf(_loc3_[_loc2_].enemies[0].swfName,param1["swf/enemies/" + _loc3_[_loc2_].enemies[0].swfName + ".swf"]);
               }
            }
            _loc3_[_loc2_].enemy = new Enemy(_loc3_[_loc2_].enemies[0]);
            _loc2_++;
         }
         mainMc.gotoMapMission();
      }
      
      public static function loadMapEnemies() : void
      {
         var _loc3_:uint = 0;
         var _loc1_:Array = Mission.getMapMissionEnemies();
         var _loc2_:Array = [];
         _loc3_ = 0;
         while(_loc3_ < _loc1_.length)
         {
            if(!Enemy.hasEnemySwf(_loc1_[_loc3_].enemies[0].swfName))
            {
               _loc2_.push("swf/enemies/" + _loc1_[_loc3_].enemies[0].swfName + ".swf");
            }
            _loc3_++;
         }
         if(_loc2_.length > 0)
         {
            loadSwf(_loc2_,loadMapEnemiesFinish);
         }
         else
         {
            loadMapEnemiesFinish();
         }
      }
      
      private static function loadMapEnemiesFinish(param1:Object = null) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:Array = Mission.getMapMissionEnemies();
         _loc2_ = 0;
         while(_loc2_ < _loc3_.length)
         {
            if(param1 != null)
            {
               if(!Enemy.hasEnemySwf(_loc3_[_loc2_].enemies[0].swfName))
               {
                  Enemy.addEnemySwf(_loc3_[_loc2_].enemies[0].swfName,param1["swf/enemies/" + _loc3_[_loc2_].enemies[0].swfName + ".swf"]);
               }
            }
            _loc3_[_loc2_].enemy = new Enemy(_loc3_[_loc2_].enemies[0]);
            _loc2_++;
         }
         Mission.reshowMap();
      }
      
      public static function recruitFriends(param1:Array, param2:Function = null) : void
      {
         var _loc3_:uint = 0;
         var _loc4_:Object = null;
         var _loc5_:AICharacter = null;
         if(_partyMembers == null)
         {
            _partyMembers = [];
         }
         _loc3_ = 0;
         while(_loc3_ < param1.length)
         {
            _loc5_ = new AICharacter(param1[_loc3_]);
            _loc5_.friendly = true;
            _loc5_.restoreOriginalStatus();
            _loc5_.isDead = false;
            _partyMembers.push(_loc5_);
            _loc3_++;
         }
         recruitFriend_CB = param2;
         loadCharacterSwf(_partyMembers,recruitFriendsLoadFinish);
      }
      
      private static function recruitFriendsLoadFinish() : void
      {
         if(recruitFriend_CB != null)
         {
            recruitFriend_CB();
         }
      }
      
      public static function getRecruitedFriends() : Array
      {
         if(_recruitedFriends == null)
         {
            return [];
         }
         return _recruitedFriends;
      }
      
      public static function setRecruitedFriends(param1:String) : void
      {
         if(_recruitedFriends != null)
         {
            _recruitedFriends.push(param1);
         }
         else
         {
            _recruitedFriends = [];
            _recruitedFriends.push(param1);
         }
      }
      
      public static function emptyRecruitedFriends() : void
      {
         _recruitedFriends = [];
      }
      
      public static function get partyMembers() : Array
      {
         if(_partyMembers == null)
         {
            return [];
         }
         return _partyMembers;
      }
      
      public static function set partyMembers(param1:Array) : void
      {
         _partyMembers = param1;
      }
      
      public static function getPartyNpc() : Array
      {
         return partyNpc;
      }
      
      public static function removePartyNpc() : void
      {
         partyNpc = null;
      }
      
      public static function getItemAmount(param1:String) : int
      {
         var _loc2_:Array = null;
         var _loc3_:int = 0;
         if(Central.main.ITEM_DATA.find(param1))
         {
            _loc2_ = Central.main.getMainChar().getInventory(InventoryData.TYPE_ITEM);
         }
         else if(Central.main.ESSENCE_DATA.find(param1))
         {
            _loc2_ = Central.main.getMainChar().getInventory(InventoryData.TYPE_ESSENCE);
         }
         else
         {
            _loc2_ = Central.main.getMainChar().getInventory(InventoryData.TYPE_MATERIAL);
         }
         var _loc4_:int = 0;
         while(_loc4_ < _loc2_.length)
         {
            if(_loc2_[_loc4_] == param1)
            {
               _loc3_++;
            }
            _loc4_++;
         }
         return _loc3_;
      }
      
      public static function initEngage() : void
      {
         mainMc.gotoEngage();
      }
      
      public static function resetEngage() : void
      {
         mainMc.engageMc.pause();
         mainMc.engageMc.hide();
      }
      
      public static function restoreEngageChar() : void
      {
         mainMc.engageMc.addMainChar();
      }
      
      public static function showDeleteConfirmation(param1:String, param2:Function, param3:Function, param4:String = null) : void
      {
         mainMc["confirmationMc"].showDeleteConfirmation(param1,param2,param3,param4);
      }
      
      public static function showIconData(param1:*, param2:String, param3:String = "1", param4:Boolean = false) : void
      {
         if(!param1["skillIcon"] || !param1["rewardIcon"])
         {
            trace("skillicon or rewardicon not ex");
            return;
         }
         GF.removeAllChild(param1["skillIcon"]["iconHolder"]);
         GF.removeAllChild(param1["rewardIcon"]["iconHolder"]);
         param2 = param2.replace("_","");
         var _loc5_:Object = Toolkit.getDisplayData(param2);
         trace("iconData = " + _loc5_);
         if(param2.indexOf("skill") == -1)
         {
            param1["rewardIcon"].visible = true;
            param1["skillIcon"].visible = false;
            param1["rewardIcon"]["iconHolder"].addChild(_loc5_.mc);
         }
         else
         {
            param1["rewardIcon"].visible = false;
            param1["skillIcon"].visible = true;
            param1["skillIcon"]["iconHolder"].addChild(_loc5_.mc);
         }
         if(param1["amountTxt"])
         {
            param1["amountTxt"].text = param3 == "1" ? "" : "x" + param3;
         }
         if(param1["newMc"])
         {
            param1["newMc"].visible = param4;
         }
         Central.main.showDynamicTooltip(param1,String("<font size=\'16\'>" + _loc5_.tooltip + "</font>"));
      }
      
      public static function showlimitOfferIconData(param1:*, param2:String, param3:String = "1", param4:Boolean = false) : void
      {
         GF.removeAllChild(param1["rewardIcon"]["rewardIcon"]["iconHolder"]);
         param2 = param2.replace("_","");
         var _loc5_:Object = Toolkit.getDisplayData(param2);
         trace("iconData = " + _loc5_);
         param1["rewardIcon"]["rewardIcon"]["iconHolder"].addChild(_loc5_.mc);
      }
      
      public static function showIconDataByRaw(param1:*, param2:String, param3:Object, param4:String = "1", param5:Boolean = false) : void
      {
         if(!param1["skillIcon"] || !param1["rewardIcon"])
         {
            trace("showIconDataRaw, skillicon or rewardicon not ex");
            return;
         }
         if(param3 === null || param3.mc === undefined || param3.tooltip === undefined)
         {
            trace("showIconDataRaw, iconData error");
            return;
         }
         GF.removeAllChild(param1["skillIcon"]["iconHolder"]);
         GF.removeAllChild(param1["rewardIcon"]["iconHolder"]);
         if(param2.indexOf("skill") == -1)
         {
            param1["rewardIcon"].visible = true;
            param1["skillIcon"].visible = false;
            param1["rewardIcon"]["iconHolder"].addChild(param3.mc);
         }
         else
         {
            param1["rewardIcon"].visible = false;
            param1["skillIcon"].visible = true;
            param1["skillIcon"]["iconHolder"].addChild(param3.mc);
         }
         if(param1["amountTxt"])
         {
            param1["amountTxt"].text = param4 == "1" ? "" : "x" + param4;
         }
         if(param1["newMc"])
         {
            param1["newMc"].visible = param5;
         }
         Central.main.showDynamicTooltip(param1,String("<font size=\'16\'>" + param3.tooltip + "</font>"));
      }
      
      public static function showDynamicTooltip(param1:*, param2:String, param3:Boolean = false, param4:Boolean = false) : void
      {
         if(param4)
         {
            param2 = "<font size =\'16\'> " + param2 + " </font>";
         }
         mainMc["confirmationMc"].showDynamicTooltip(param1,param2,param3);
      }
      
      public static function hideDynamicTooltip(param1:*) : void
      {
         mainMc["confirmationMc"].hideDynamicTooltip(param1);
      }
      
      public static function showRenameConfirmation(param1:String, param2:Function, param3:Function, param4:int, param5:int, param6:String) : void
      {
         mainMc["confirmationMc"].showRenameConfirmation(param1,param2,param3,param4,param5,param6);
      }
      
      public static function showConfirmation(param1:String, param2:Function, param3:Function, param4:Boolean = true) : void
      {
         mainMc["confirmationMc"].showConfirmation(param1,param2,param3,param4);
      }
      
      public static function showInvFullConfirmation(param1:Function, param2:Object = null, param3:Boolean = true) : void
      {
         mainMc["confirmationMc"].showInvFullConfirmation(param1,param2,param3);
      }
      
      public static function showSecurityPasswordConfirmation(param1:String, param2:Function, param3:Function, param4:Boolean = true) : void
      {
         mainMc["confirmationMc"].showPasswordPopup(param1,param2,param3,param4);
      }
      
      public static function showSecurityPasswordSignupInvitation(param1:String, param2:Function, param3:Function, param4:Boolean = true, param5:Boolean = false) : void
      {
         mainMc["confirmationMc"].showPasswordSignupInvitationPopup(param1,param2,param3,param4,param5);
      }
      
      public static function showPvpInfoBox(param1:String, param2:Function, param3:Function, param4:Function) : void
      {
         mainMc["confirmationMc"].showPvpInfoBox(param1,param2,param3,param4);
      }
      
      public static function showPvpScheduleBox(param1:Boolean, param2:Function = null) : void
      {
         if(param2 == null)
         {
            param2 = new Function();
         }
         mainMc["confirmationMc"].showPvpScheduleBox(param2,param1);
      }
      
      public static function showEnemyHP(param1:Function) : void
      {
         mainMc["confirmationMc"].showEnemyHP(param1);
      }
      
      public static function showRefreshConfirmation(param1:String, param2:String, param3:Function, param4:String) : void
      {
         mainMc["confirmationMc"].showRefreshConfirmation(param1,param2,param3,param4);
      }
      
      public static function showResetSkillConfirmation(param1:String, param2:Function, param3:Function, param4:String, param5:String) : void
      {
         mainMc["confirmationMc"].showResetSkillConfirmation(param1,param2,param3,param4,param5);
      }
      
      public static function showNoticeBoard(param1:String, param2:String, param3:Function, param4:Function, param5:String, param6:Object = null) : void
      {
         mainMc["confirmationMc"].showNoticeBoard(param1,param2,param3,param4,param5,param6);
      }
      
      public static function getGoldToken(param1:String, param2:Function, param3:String) : void
      {
         mainMc["confirmationMc"].getGoldToken(param1,param2,param3);
      }
      
      public static function showOk(param1:String, param2:Function = null, param3:Boolean = true) : void
      {
         if(param2 == null)
         {
            param2 = new Function();
         }
         mainMc["confirmationMc"].showOk(param1,param2,param3);
      }
      
      public static function showPopup(param1:String, param2:String, param3:Function = null, param4:Function = null) : void
      {
         if(param3 == null)
         {
            param3 = new Function();
         }
         if(param4 == null)
         {
            param4 = new Function();
         }
         mainMc["confirmationMc"].showPopup(param1,param2,param3,param4);
      }
      
      public static function showPopupSpecialHpBar(param1:Object) : void
      {
         mainMc["confirmationMc"].showPopupSpecialHpBar(param1);
      }
      
      public static function hidePopupSpecialHpBar() : void
      {
         mainMc["confirmationMc"].hidePopupSpecialHpBar();
      }
      
      public static function showPopupSealFail(param1:String, param2:String, param3:Function = null) : void
      {
         if(param3 == null)
         {
            param3 = new Function();
         }
         mainMc["confirmationMc"].showPopupSealFail(param1,param2,param3);
      }
      
      public static function showShareBox(param1:String, param2:Function, param3:Function) : void
      {
         mainMc["confirmationMc"].showShareBox(param1,param2,param3);
      }
      
      public static function showShareBoxNew(param1:String, param2:String, param3:String, param4:String, param5:Function, param6:Function) : void
      {
         mainMc["confirmationMc"].showShareBoxNew(param1,param2,param3,param4,param5,param6);
      }
      
      public static function showFAQ(param1:String, param2:String, param3:String, param4:String, param5:String, param6:String, param7:String) : void
      {
         mainMc["confirmationMc"].showFAQ(param1,param2,param3,param4,param5,param6,param7);
      }
      
      public static function showPayTokenConfirm(param1:String, param2:int, param3:Function, param4:String = "") : void
      {
         mainMc["confirmationMc"].showPayTokenConfirm(param1,param2,param3,param4);
      }
      
      public static function showPayGoldConfirm(param1:String, param2:int, param3:Function, param4:String = "") : void
      {
         mainMc["confirmationMc"].showPayGoldConfirm(param1,param2,param3,param4);
      }
      
      public static function showGuide(param1:Boolean) : void
      {
         mainMc["confirmationMc"].showGuide(param1);
      }
      
      public static function showDeadPopup() : void
      {
         mainMc["confirmationMc"].gotoAndPlay("deadPopup");
      }
      
      public static function showTrainSkillConfirm(param1:String, param2:String, param3:Function, param4:Function) : void
      {
         mainMc["confirmationMc"].showTrainSkillConfirm(param1,param2,param3,param4);
      }
      
      public static function showGeneralNotice(param1:String, param2:String, param3:String, param4:Function = null) : void
      {
         if(param4 == null)
         {
            param4 = new Function();
         }
         mainMc["confirmationMc"].showGeneralNotice(param1,param2,param3,param4);
      }
      
      public static function showMedal(param1:String) : void
      {
         mainMc["confirmationMc"].showMedal(param1);
      }
      
      public static function showEventDailyLoginGift(param1:String, param2:DailyLoginEventData) : void
      {
         mainMc["confirmationMc"].showEventDailyLoginGift(param1,param2);
      }
      
      public static function showEventGiftBag(param1:Object) : void
      {
         mainMc["confirmationMc"].showEventGiftBag(param1);
      }
      
      public static function showEventDailyTicket(param1:String, param2:String = "", param3:String = "", param4:String = "", param5:String = "") : void
      {
         mainMc["confirmationMc"].showEventDailyTicket(param1,param2,param3,param4,param5);
      }
      
      public static function showGetHuntingPassport() : void
      {
         mainMc["confirmationMc"].showHuntingPassport();
      }
      
      public static function newgetitem(param1:Array) : void
      {
         mainMc["confirmationMc"].showGetReward(param1);
      }
      
      public static function showRewardAlert(param1:Array, param2:String = "", param3:Function = null) : void
      {
         popup.showRewardAlert(param1,param2,param3);
      }
      
      public static function initAmf() : void
      {
         amfClient.initAmf();
         DBCharacter.register();
      }
      
      public static function showAmfLoading() : void
      {
         if(mainMc["amfLoader"])
         {
            mainMc["amfLoader"].show();
         }
      }
      
      public static function hideAmfLoading() : void
      {
         if(mainMc["amfLoader"])
         {
            mainMc["amfLoader"].hide();
         }
      }
      
      public static function checkAmf() : void
      {
         var _loc1_:String = Central.main.getHash(Central.main.cls);
         Central.main.showAmfLoading();
         Central.main.amfClient.service("SystemService.checkAmf",[Data.BUILD_NO,Central.main.cls,_loc1_,Central.main.account.getAccountSessionKey()],checkAmfResponse);
      }
      
      private static function checkAmfResponse(param1:Object) : void
      {
         if(Central.main.validateAmfResponse(param1))
         {
            switch(param1.status)
            {
               case 0:
                  Main.onError("30201");
                  break;
               case 1:
                  mainMc.gotoSelchar();
            }
            Central.main.hideAmfLoading();
         }
      }
      
      public static function onError(param1:String = "0", param2:String = "") : void
      {
         gameLockout = true;
         mainChar = null;
         if(_errorCode == null)
         {
            _errorCode = param1;
            _errorMessage = param2;
         }
         Out.error("Main","onError :: code " + param1 + " :: _errorCode " + _errorCode + " :: _error_message " + _errorMessage);
         Main.tracking.trackErrorCode(param1);
         callGoogleAnalytics("Error",param1,FBUser.uid);
         if(mainMc)
         {
            mainMc.showError();
         }
         mainMc = null;
      }
      
      public static function gotoMap() : void
      {
         Main.showMapCoin(true);
         mainMc.gotoMap();
         Main.onmap = true;
      }
      
      private static function nothing(param1:Object) : void
      {
         var _loc2_:DBCharacter = dataParser.parseRawCharacter(param1.character_data.result,true);
         Central.main.setMainChar(_loc2_);
      }
      
      public static function callGoogleAnalytics(param1:String, param2:String, param3:String) : void
      {
         tracker = new GATracker(mainMc,"UA-63895237-7","AS3",false);
         tracker.trackEvent(param1,param2,param3);
      }
      
      public static function get mapMenu() : MovieClip
      {
         return mainMc["mapMenuMc"];
      }
      
      public static function enableMenu() : void
      {
         mapMenu.enable();
      }
      
      public static function disableMenu() : void
      {
         mapMenu.disable();
      }
      
      public static function enableGearBtn() : void
      {
         mapMenu.enableGearBtn();
      }
      
      public static function disableGearBtn() : void
      {
         mapMenu.disableGearBtn();
      }
      
      public static function updateMenu(param1:Boolean = true) : void
      {
         mapMenu.update(param1);
         if(mainMc.currentLabel == Timeline.MAP)
         {
            showHints();
         }
      }
      
      public static function showMapCoin(param1:Boolean) : void
      {
         if(param1)
         {
            mapMenu.enableMRelate();
         }
         else
         {
            mapMenu.disableMRelate();
         }
      }
      
      public static function hideMenu() : void
      {
         mapMenu.hide();
      }
      
      public static function updateLvStatusBar() : void
      {
         mapMenu.updateLvStatusBar();
      }
      
      public static function hideLvStatusBar() : void
      {
         mapMenu.hideLvStatusBar();
      }
      
      private static function showHints() : void
      {
         var _loc1_:MovieClip = null;
         var _loc5_:* = undefined;
         GF.removeAllChild(mainMc["hintsMc"]);
         var _loc2_:uint = 0;
         if(mainChar.apInvested < mainChar.getLevel())
         {
            _loc1_ = GF.getAsset(mainMc,"Hint");
            _loc1_.name = "profileHint";
            _loc1_["hintIcon"]["icon"].gotoAndStop(2);
            _loc1_["txt"].text = langLib.get(208);
            _loc1_.addEventListener(MouseEvent.CLICK,clickHint);
            _loc1_.buttonMode = true;
            mainMc["hintsMc"].addChild(_loc1_);
            _loc2_++;
         }
         if(mainChar.getInventory(InventoryData.TYPE_ITEM).length == 0)
         {
            _loc1_ = GF.getAsset(mainMc,"Hint");
            _loc1_.name = "itemHint";
            _loc1_["hintIcon"]["icon"].gotoAndStop(1);
            _loc1_["txt"].text = langLib.get(209);
            _loc1_.addEventListener(MouseEvent.CLICK,clickHint);
            _loc1_.buttonMode = true;
            mainMc["hintsMc"].addChild(_loc1_);
            _loc1_.y -= 30 * _loc2_;
            _loc2_++;
         }
         if(mainChar.getData(DBCharacterData.RANK) == RankData.GENIN && int(mainChar.getLevel()) == 20)
         {
            _loc1_ = GF.getAsset(mainMc,"Hint");
            _loc1_.name = "chuninExamHint";
            _loc1_["hintIcon"]["icon"].gotoAndStop(1);
            _loc1_["txt"].text = langLib.get(210);
            _loc1_.addEventListener(MouseEvent.CLICK,clickHint);
            _loc1_.buttonMode = true;
            mainMc["hintsMc"].addChild(_loc1_);
            _loc1_.y -= 30 * _loc2_;
            _loc2_++;
         }
         var _loc3_:Object = Main.getMainChar().getData(DBCharacterData.INVENTORY)[InventoryData.TYPE_MISSION];
         var _loc4_:uint = 0;
         for(_loc5_ in _loc3_)
         {
            if(_loc5_ != null && Boolean(_loc3_[_loc5_].success))
            {
               _loc4_++;
            }
            if(_loc4_ >= 2)
            {
               break;
            }
         }
         if(_loc4_ == 1)
         {
            _loc1_ = GF.getAsset(mainMc,"Hint");
            _loc1_.name = "firstMissionHint";
            _loc1_["txt"].text = langLib.get(697);
            _loc1_.addEventListener(MouseEvent.CLICK,clickHint);
            _loc1_.buttonMode = true;
            mainMc["hintsMc"].addChild(_loc1_);
            _loc1_.y -= 30 * _loc2_;
            _loc2_++;
         }
      }
      
      private static function clickHint(param1:MouseEvent) : void
      {
         var _loc2_:String = param1.currentTarget.name;
         switch(_loc2_)
         {
            case "profileHint":
               mapMenu.show(Timeline.PROFILE);
               break;
            case "itemHint":
               onClickShop();
               break;
            case "chuninExamHint":
               onClickMission();
               break;
            case "firstMissionHint":
               onClickMission();
         }
      }
      
      public static function updateMenuDT() : void
      {
      }
      
      public static function hideMenuDT() : void
      {
      }
      
      public static function onEnterMap() : void
      {
         var payment_rNum:int = 0;
         dispatchGameEvent(GameEvents.MAP_ENTER);
         if(isNewChar)
         {
            MISSION_DATA_AA.removeById("msn0");
         }
         if(int(Main.getMainChar().getData(DBCharacterData.RANK)) >= RankData.TUTOR)
         {
            senjutsuFeature = true;
            senjutsuSlot = Formula.getSenjutsuSlot(int(Main.getMainChar().getData(DBCharacterData.LEVEL)));
            if(mapMenu["characterStatus"].currentFrameLabel != "status2")
            {
               mapMenu.init();
            }
         }
         else
         {
            senjutsuFeature = false;
            if(mapMenu["characterStatus"].currentFrameLabel != "status1")
            {
               mapMenu.init();
            }
         }
         mainChar.restoreOriginalStatus();
         if(mainChar.pet)
         {
            mainChar.pet.restoreOriginalStatus();
         }
         GF.removeAllChild(mainMc["mapHolder"]);
         mainMc.mapMc = Main.mainMapObject[Main.villageMap];
         mainMc["mapHolder"].addChild(mainMc.mapMc);
         initMapButtons();
         updateMenu();
         enableMenu();
         if(Boolean(mainChar.trainingSkill) && mainChar.getTrainingSkillRemaining() <= 0)
         {
            mainChar.verifyTrainingSkill(null);
         }
         mainMc["attentionBtn"].visible = false;
         Central.main.initButton(mainMc["attentionBtn"],proc.showPaymentStatus,null);
         if(paymentStatus)
         {
            mainMc["attentionBtn"].visible = true;
            Central.main.showDynamicTooltip(mainMc["attentionBtn"],String("<font size=\'12\'>" + Central.main.langLib.get(953) + "</font>"));
            payment_rNum = NumberUtil.randomInt(0,1000);
            if(payment_rNum <= 500)
            {
               proc.showPaymentStatus();
            }
         }
         if(Main.getMainChar().getLevel() <= 2)
         {
            mainMc["mapMc"]["btnMission"]["missionBtn1"].visible = false;
            mainMc["mapMc"]["btnMission"]["missionBtn2"].visible = true;
         }
         else
         {
            mainMc["mapMc"]["btnMission"]["missionBtn1"].visible = true;
            mainMc["mapMc"]["btnMission"]["missionBtn2"].visible = false;
         }
         if(tutorialArr != null)
         {
            popup.showTutorial();
         }
         else if(Boolean(AppData.type == AppData.FB && Main.recruitFriendTmpData) && Boolean(Main.recruitFriendTmpData.length > 0) && !Main.hasLoadRecruitFriends)
         {
            Main.recruitFriends(Main.recruitFriendTmpData,Main.loadRecruitFriendFinish);
         }
         else
         {
            Main.proc.streamStartEvents();
         }
         if(!Main.hasLoadRecruitFriends)
         {
            Main.hasLoadRecruitFriends = true;
         }
         invisibleMapSideBtn();
         if(tutorialArr == null)
         {
            updateMapSideBtn();
            if(Main.daily_login)
            {
               Main.daily_login = false;
               try
               {
                  Main.tracking.generalTrack(Central.main.tracking.TRACK_LOGIN_WEAPON,Main.getMainChar().getData(DBCharacterData.LEVEL),Main.getMainChar().getWeapon());
               }
               catch(err:Error)
               {
                  Out.error("Main","TRACK_LOGIN_WEAPON >> " + err.message);
               }
            }
         }
         if(IsBackToPanel != "")
         {
            Panel.getInstance().show(IsBackToPanel);
            IsBackToPanel = "";
         }
      }
      
      private static function loadRecruitFriendFinish() : void
      {
         Main.updateMenu();
         Main.proc.streamStartEvents();
      }
      
      public static function checkPVPinvite() : void
      {
         var _loc1_:String = null;
         if(pvpstatus != null)
         {
            if(pvpstatus.status)
            {
               Out.debug("Main","checkPVPinvite");
               Central.panel.getInstance().show("arena");
            }
            else
            {
               _loc1_ = "";
               if(pvpstatus["status_" + AppData.lang] != null)
               {
                  _loc1_ = pvpstatus["status_" + AppData.lang];
               }
               else
               {
                  _loc1_ = pvpstatus.status_en;
               }
               showGeneralNotice("",String(_loc1_),ButtonData.OK,new Function());
            }
         }
         else
         {
            Out.error("Main","pvpstatus is null!");
         }
      }
      
      public static function showCPMStarAd() : void
      {
         Out.debug("Main","showCPMStarAd");
         popup.showCPMStarAd();
      }
      
      public static function invisibleMapSideBtn() : void
      {
         var _loc1_:uint = 0;
         Main.hideLvStatusBar();
         _loc1_ = 0;
         while(_loc1_ < ALL_LEFT_BTN_ARR.length)
         {
            if(mainMc[ALL_LEFT_BTN_ARR[_loc1_]])
            {
               mainMc[ALL_LEFT_BTN_ARR[_loc1_]].stop();
               mainMc[ALL_LEFT_BTN_ARR[_loc1_]].visible = false;
               if(AppData.type != AppData.RR)
               {
                  if(mainMc[ALL_LEFT_BTN_ARR[_loc1_]]["numMC"])
                  {
                     mainMc[ALL_LEFT_BTN_ARR[_loc1_]]["numMC"].visible = false;
                  }
               }
            }
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < ALL_RIGHT_BTN_ARR.length)
         {
            if(mapMenu[ALL_RIGHT_BTN_ARR[_loc1_]])
            {
               mapMenu[ALL_RIGHT_BTN_ARR[_loc1_]].stop();
               mapMenu[ALL_RIGHT_BTN_ARR[_loc1_]].visible = false;
               if(AppData.type != AppData.RR)
               {
               }
            }
            _loc1_++;
         }
      }
      
      public static function visibleMapSideBtn() : void
      {
         var _loc1_:uint = 0;
         Main.updateLvStatusBar();
         _loc1_ = 0;
         while(_loc1_ < ALL_LEFT_BTN_ARR.length)
         {
            mainMc[ALL_LEFT_BTN_ARR[_loc1_]].visible = true;
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < ALL_RIGHT_BTN_ARR.length)
         {
            mapMenu[ALL_RIGHT_BTN_ARR[_loc1_]].visible = true;
            _loc1_++;
         }
      }
      
      public static function shiftPosMapSideBtn() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         _loc1_ = 0;
         _loc2_ = 0;
         while(_loc2_ < ALL_LEFT_BTN_ARR.length)
         {
            if(mainMc[ALL_LEFT_BTN_ARR[_loc2_]].visible == true)
            {
               mainMc[ALL_LEFT_BTN_ARR[_loc2_]].y = 105 + _loc1_ * 70;
               _loc1_++;
            }
            _loc2_++;
         }
         _loc1_ = 0;
         _loc2_ = 0;
         while(_loc2_ < ALL_RIGHT_BTN_ARR.length)
         {
            if(mapMenu[ALL_RIGHT_BTN_ARR[_loc2_]].visible == true)
            {
               mapMenu[ALL_RIGHT_BTN_ARR[_loc2_]].y = 105 + _loc1_ * 70;
               _loc1_++;
            }
            _loc2_++;
         }
      }
      
      private static function clickMapSideBtn(param1:MouseEvent) : void
      {
         if(param1.currentTarget == null)
         {
            return;
         }
         if(Main.checkGameStatus() == Timeline.MAP)
         {
            switch(String(param1.currentTarget.name))
            {
               case "isLearnSkillBtn":
                  Out.debug("main","Main >> clickMapSideBtn");
                  Main.getMainChar().verifyTrainingSkill(Main.checkisLearnSkill);
                  break;
               case "dailyLoginBtn":
                  Main.loadPopupPanel("daily_login","ninjasaga.linkage.Roulette2");
                  break;
               case "dailyScartchBtn":
                  Main.loadPopupPanel("daily_login_3","ninjasaga.linkage.daily_login3");
                  break;
               case "requestPopupBtn":
                  Panel.getInstance().show("requestBox");
                  break;
               case "inviteFriendBtn":
                  Main.loadPopupPanel("invitFrdReward","ninjasaga.linkage.InviteInstantReward");
                  break;
               case "emblemDailygiftBtn":
                  if(Central.main.extraData.emblem_type == 2 || Account.getAccountType() == Account.FREE)
                  {
                     Central.main.loadPopupPanel("popup_emblemClaim_other","ninjasaga.linkage.EmblemClaim");
                  }
                  else
                  {
                     Central.main.loadPopupPanel("popup_emblemClaim","ninjasaga.linkage.EmblemUserDailyLoginGift");
                  }
                  break;
               case "TrialEmblemBtn":
                  Main.loadPopupPanel("popup_trial_emblem","ninjasaga.linkage.TrialEmblemPanel2");
                  break;
               case "PackageBtn":
                  Main.loadPopupPanel("Popup_Package_panel_2020","ninjasaga.linkage.Package_popup");
                  break;
               case "event2017_icon":
                  Main.loadPopupPanel("Popup_Events_panel_2017","ninjasaga.linkage.Event_popup");
                  break;
               case "sakura2020Btn":
                  Panel.getInstance().show("sakura_mainmenu_2020");
                  break;
               case "maskBtn":
                  Main.loadPopupPanel("mask_package","ninjasaga.linkage.maskPackage");
                  break;
               case "MysteriousMerchant_icon":
                  Main.loadPopupPanel("limited_package_store_2018","ninjasaga.linkage.LimitSkill2018");
                  break;
               case "kageskillBtn":
                  Main.loadPopupPanel("kageskill_package","ninjasaga.linkage.kageskillpanel");
                  break;
               case "Skill901_icon":
                  Main.loadPopupPanel("skill_901package","ninjasaga.linkage.Skill901panel");
                  break;
               case "Easter2020Btn":
                  Panel.getInstance().show("Popup_easter_2020_Menu");
                  break;
               case "Easter2018Btn":
                  Panel.getInstance().show("Popup_easter_2018_Menu");
                  break;
               case "dailyRewardClaimMaintenanceBtn":
                  Main.loadPopupPanel("Popup_DailyTokenMaintenanceClaim","ninjasaga.linkage.DailyClaimMaintenance");
                  break;
               case "dailyRewardClaimToken201802Btn":
                  Main.loadPopupPanel("Popup_valentine_TokenClaim2018","ninjasaga.linkage.DailyClaim20180214");
                  break;
               case "EightAnniversaryshop2017Btn":
                  Main.loadPopupPanel("popup_8th_result","ninjasaga.linkage.EightAnniversaryshop2017");
                  break;
               case "MiniGameWhackAMoleBtn":
                  Panel.getInstance().show("Panel_2016_MinigameCover_1");
                  break;
               case "newYearPackage2016Btn":
                  Panel.getInstance().show("Enemytest");
                  break;
               case "dailyRouletteBtn":
                  Main.loadPopupPanel("Popup_LuckyDraw_2014","ninjasaga.linkage.LuckyRoulette2014");
                  break;
               case "welcome2014Btn":
                  Main.loadPopupPanel("popup_welcome_package_2014","ninjasaga.linkage.WelcomePackage2014");
                  break;
               case "thanks2016Btn":
                  Panel.getInstance().show("Popup_ThanksgivingChef_2016_Menu");
                  break;
               case "limitOfferBtn":
               case "limitOffer20200826Btn":
               case "limitOffer20200805Btn":
                  Central.main.gotoPaymentGateway();
                  break;
               case "Sakura2017_icon":
                  Panel.getInstance().show("Popup_sakuraPackage_2017_Menu");
                  break;
               case "newDailyLoginStamp2017_icon":
                  Main.loadPopupPanel("Panel_New_Daily_Login","ninjasaga.linkage.NewDailyLogin2017");
                  break;
               case "GodSnapBtn":
                  Panel.getInstance().show("Popup_Gauntlet_menu");
            }
         }
      }
      
      public static function checkisLearnSkill() : void
      {
         if(Main.getMainChar().trainingSkill != null)
         {
            Main.loadPopupPanel("popup_skill_progress","ninjasaga.linkage.SkillReduceProgress");
         }
         else
         {
            updateMapSideBtn();
         }
      }
      
      public static function checkExpiryItem() : void
      {
         var _loc1_:Array = null;
         var _loc2_:Array = null;
         var _loc3_:Date = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         if(Mission.curMissionID == null)
         {
            if(Main.checkGameStatus() == Timeline.MAP)
            {
               _loc1_ = Main.getMainChar().getData(DBCharacterData.EXPIRY_ITEM_CURRENT_EXPIRY_ARR);
               _loc2_ = [];
               _loc3_ = new Date();
               _loc4_ = _loc3_.time / 1000;
               _loc5_ = 12;
               if(_loc1_.length > 0)
               {
                  _loc2_ = String(_loc1_[0]).split(":");
                  if(_loc4_ + _loc5_ * 3600 >= int(_loc2_[1]))
                  {
                     Main.changeExpiryItemBtn = true;
                  }
                  else
                  {
                     Main.changeExpiryItemBtn = false;
                  }
                  if(_loc4_ >= int(_loc2_[1]))
                  {
                     Main.loadPopupPanel("popup_expired_item","ninjasaga.linkage.ExpiryItemPopupPanel");
                  }
               }
               else
               {
                  Main.changeExpiryItemBtn = false;
               }
            }
         }
      }
      
      public static function updateMapSideBtn() : void
      {
         var _loc1_:MovieClip = null;
         if(Battle.bossId == "")
         {
         }
         if(Mission.curMissionID == null)
         {
            if(Main.checkGameStatus() == Timeline.MAP)
            {
               invisibleMapSideBtn();
               mainMc["leftIconUp"].visible = true;
               mainMc["leftIconUp"].addEventListener(MouseEvent.CLICK,leftIconUp);
               mainMc["leftIconDown"].visible = true;
               mainMc["leftIconDown"].addEventListener(MouseEvent.CLICK,leftIconDown);
               mainMc["rightIconUp"].visible = true;
               mainMc["rightIconUp"].addEventListener(MouseEvent.CLICK,rightIconUp);
               mainMc["rightIconDown"].visible = true;
               mainMc["rightIconDown"].addEventListener(MouseEvent.CLICK,rightIconDown);
               if(AppData.type == AppData.RR || AppData.type == AppData.YM)
               {
                  mainMc["leftIconUp"].visible = false;
                  mainMc["leftIconDown"].visible = false;
                  mainMc["rightIconUp"].visible = false;
                  mainMc["rightIconDown"].visible = false;
               }
               if(mainMc["yahooXmasDailyGiftBtn"])
               {
                  mainMc["yahooXmasDailyGiftBtn"].visible = false;
               }
               if(mainMc["minikPromoBtn"])
               {
                  mainMc["minikPromoBtn"].visible = false;
               }
               if(Main.getMainChar().getLevel() < 80 && Main.getMainChar().getData(DBCharacterData.RANK) >= RankData.SPECIAL_JOUNIN)
               {
                  mainMc["senninExamBtn"].visible = true;
                  Main.initButton(mainMc["senninExamBtn"],proc.showSenninExam,null);
                  Main.showDynamicTooltip(mainMc["senninExamBtn"],"<font size =\'16\'>" + langLib.titleTxt(TitleData.REQUIREMENT) + ": " + langLib.titleTxt(TitleData.LV) + "80" + "</font>");
               }
               else if(Main.getMainChar().getLevel() >= 80 && Main.getMainChar().getData(DBCharacterData.RANK) < RankData.TUTOR)
               {
                  mainMc["senninExamBtn"].visible = true;
                  Main.showDynamicTooltip(mainMc["senninExamBtn"],"<font size =\'16\'>" + Main.langLib.get(1848)[49] + "</font>");
                  Main.initButton(mainMc["senninExamBtn"],proc.showSenninExam,null);
               }
               else
               {
                  mainMc["senninExamBtn"].stop();
                  mainMc["senninExamBtn"].visible = false;
               }
               if(Features.EXAM_S_JOUNIN_PANEL)
               {
                  if(Main.getMainChar().getLevel() < 60 && Main.getMainChar().getData(DBCharacterData.RANK) >= RankData.JOUNIN)
                  {
                     mainMc["examBtn"].visible = true;
                     Main.initButton(mainMc["examBtn"],proc.showExam,null);
                     Main.showDynamicTooltip(mainMc["examBtn"],"<font size =\'16\'>" + langLib.titleTxt(TitleData.REQUIREMENT) + ": " + langLib.titleTxt(TitleData.LV) + "60" + "</font>");
                  }
                  else if(Main.getMainChar().getLevel() >= 60)
                  {
                     if(Central.main.dayleft == 0 && Main.getMainChar().getData(DBCharacterData.CONTROL) > 0 && Central.main.sje_notice == 0)
                     {
                        Central.main.showOk(Central.main.langLib.get(1437)[33],SJENoticeOk);
                     }
                     Main.showDynamicTooltip(mainMc["examBtn"],"<font size =\'16\'>" + Main.langLib.get(1422) + "</font>");
                     if(Main.getMainChar().getData(DBCharacterData.RANK) == 6 && Main.getMainChar().getData(DBCharacterData.CONTROL) > 0 && Central.main.dayleft != 0)
                     {
                        mainMc["examBtn"].visible = true;
                        Main.initButton(mainMc["examBtn"],confirmActivateHM,null);
                     }
                     else if(Main.getMainChar().getData(DBCharacterData.CONTROL) <= 0)
                     {
                        mainMc["examBtn"].visible = true;
                        Main.initButton(mainMc["examBtn"],confirmActivateHM,null);
                     }
                     else
                     {
                        mainMc["examBtn"].stop();
                        mainMc["examBtn"].visible = false;
                     }
                  }
               }
               if(Features.EXAM_JOUNIN_PANEL)
               {
                  if(Main.getMainChar().getLevel() < 40 && Main.getMainChar().getData(DBCharacterData.RANK) >= 2)
                  {
                     mainMc["jouninexamBtn"].visible = true;
                     Main.initButton(mainMc["jouninexamBtn"],proc.showjouninExamPage,null);
                     Main.showDynamicTooltip(mainMc["jouninexamBtn"],"<font size =\'16\'>" + langLib.titleTxt(TitleData.REQUIREMENT) + ": " + langLib.titleTxt(TitleData.LV) + "40" + "</font>");
                  }
                  else if(Main.getMainChar().getLevel() >= 40 && Main.getMainChar().getData(DBCharacterData.RANK) >= RankData.CHUNIN && Main.getMainChar().getData(DBCharacterData.RANK) < RankData.JOUNIN)
                  {
                     mainMc["jouninexamBtn"].visible = true;
                     Main.initButton(mainMc["jouninexamBtn"],proc.showjouninExamPage,null);
                     Main.showDynamicTooltip(mainMc["jouninexamBtn"],"<font size =\'16\'>" + String(Main.langLib.get(1593)[0]) + "</font>");
                  }
               }
               if(Features.FEATURE_ESSENCE)
               {
                  if(Main.getMainChar().trainingSkill != null)
                  {
                     mainMc["isLearnSkillBtn"].visible = true;
                     Main.initButton(mainMc["isLearnSkillBtn"],clickMapSideBtn,null);
                     Main.showDynamicTooltip(mainMc["isLearnSkillBtn"],"<font size =\'16\'><b>" + Main.langLib.get(1615)[15] + "</b><br><br>" + String(Central.main.SKILL_DATA[Central.main.getMainChar().trainingSkill.id].name) + "</font>");
                  }
               }
               if(Features.FEATURE_PAYMENT_PACKAGE)
               {
               }
               if(Main.getMainChar().getLevel() <= 20 && Account.getAccountType() == 1 && AppData.type == AppData.FB)
               {
                  mainMc["welcome2014Btn"].visible = true;
                  mainMc["welcome2014Btn"]["newMc"].visible = true;
                  mainMc["welcome2014Btn"]["giftBoxMc"]["txtMc"].gotoAndStop(2);
                  if(AppData.type == AppData.ZH)
                  {
                     mainMc["welcome2014Btn"]["giftBoxMc"]["txtMc"].gotoAndStop(3);
                  }
                  else if(Main.getMainChar().getLevel() <= 10)
                  {
                     mainMc["welcome2014Btn"]["giftBoxMc"]["txtMc"].gotoAndStop(1);
                  }
                  Main.initButton(mainMc["welcome2014Btn"],clickMapSideBtn,null);
                  Main.showDynamicTooltip(mainMc["welcome2014Btn"],"<font size =\'16\'> " + String(Main.langLib.get(1863)[0]) + " </font>");
               }
               else
               {
                  mainMc["welcome2014Btn"].visible = false;
                  mainMc["welcome2014Btn"]["newMc"].visible = false;
                  Main.disableButton(mainMc["welcome2014Btn"],clickMapSideBtn,null);
               }
               if(Main.getMainChar().getLevel() >= Main.DISPLAY_LEVEL_LIMIT_EVENT_EASTER && Central.main.account.getAccountType() == Central.main.account.FREE || Boolean(Central.main.isTrailEmblem))
               {
                  mainMc["TrialEmblemBtn"].visible = true;
                  mainMc["TrialEmblemBtn"].filters = null;
                  Main.initButton(mainMc["TrialEmblemBtn"],clickMapSideBtn,null);
                  Main.showDynamicTooltip(mainMc["TrialEmblemBtn"],"<font size =\'16\'> " + (AppData.lang == AppData.ZH ? "試用忍者紋章" : "Trial Emblem") + " </font>");
               }
               else
               {
                  mainMc["TrialEmblemBtn"].visible = false;
                  Main.disableButton(mainMc["TrialEmblemBtn"],clickMapSideBtn,null);
               }
               if(Toolkit.hasItem("wpn9999999") || Toolkit.hasItem("wpn9999"))
               {
                  mainMc["untiyBtn"].visible = true;
                  mainMc["untiyBtn"].filters = null;
                  Main.initButton(mainMc["untiyBtn"],clickMapSideBtn,null);
                  Main.showDynamicTooltip(mainMc["untiyBtn"],"<font size =\'16\'> " + (AppData.lang == AppData.ZH ? "unity" : "unity") + " </font>");
               }
               else
               {
                  mainMc["untiyBtn"].visible = false;
                  Main.disableButton(mainMc["untiyBtn"],clickMapSideBtn,null);
               }
               if((Toolkit.hasItem("wpn9999999") || Toolkit.hasItem("wpn9999")) && NinjaSaga.isTestMode)
               {
                  mainMc["newYearPackage2016Btn"].visible = true;
                  mainMc["newYearPackage2016Btn"].filters = null;
                  Main.initButton(mainMc["newYearPackage2016Btn"],clickMapSideBtn,null);
                  Main.showDynamicTooltip(mainMc["newYearPackage2016Btn"],"<font size =\'16\'> " + (AppData.lang == AppData.ZH ? "2016" : "2016") + " </font>");
               }
               else
               {
                  mainMc["newYearPackage2016Btn"].visible = false;
                  Main.disableButton(mainMc["newYearPackage2016Btn"],clickMapSideBtn,null);
               }
               if(Main.getMainChar().getLevel() >= Main.DISPLAY_LEVEL_LIMIT_EVENT_EASTER)
               {
                  mainMc["sakura2020Btn"].visible = true;
                  mainMc["sakura2020Btn"].filters = null;
                  mainMc["sakura2020Btn"].newMc.visible = true;
                  Main.initButton(mainMc["sakura2020Btn"],clickMapSideBtn,null);
                  Main.showDynamicTooltip(mainMc["sakura2020Btn"],"<font size =\'16\'> " + (AppData.lang == AppData.ZH ? "2020 櫻花節" : "Sakura Event 2020") + " </font>");
               }
               else
               {
                  mainMc["sakura2020Btn"].visible = false;
                  Main.disableButton(mainMc["sakura2020Btn"],clickMapSideBtn,null);
               }
               if(Boolean(Main.getMainChar().getLevel() >= Main.DISPLAY_LEVEL_LIMIT_EVENT_EASTER) && Boolean(Central.main.extraData) && (Central.main.extraData.maskBtn === undefined || Central.main.extraData.maskBtn === true))
               {
                  mainMc["maskBtn"].visible = true;
                  mainMc["maskBtn"].filters = null;
                  if(Central.main.extraData.maskBtn_new === true || Central.main.extraData.maskBtn_new === undefined)
                  {
                     mainMc["maskBtn"].newMc.visible = true;
                  }
                  else
                  {
                     mainMc["maskBtn"].newMc.visible = false;
                  }
                  Main.initButton(mainMc["maskBtn"],clickMapSideBtn,null);
                  Main.showDynamicTooltip(mainMc["maskBtn"],"<font size =\'16\'> " + (AppData.lang == AppData.ZH ? "防護口罩" : "Protective Mask") + " </font>");
               }
               else
               {
                  mainMc["maskBtn"].visible = false;
                  Main.disableButton(mainMc["maskBtn"],clickMapSideBtn,null);
               }
               if(Boolean(Main.getMainChar().getLevel() >= Main.DISPLAY_LEVEL_LIMIT_EVENT_EASTER) && Boolean(Central.main.extraData) && (Central.main.extraData.MysteriousMerchant_icon === undefined || Central.main.extraData.MysteriousMerchant_icon === true))
               {
                  mainMc["MysteriousMerchant_icon"].visible = true;
                  mainMc["MysteriousMerchant_icon"].filters = null;
                  if(Central.main.extraData.MysteriousMerchant_icon_new === true || Central.main.extraData.MysteriousMerchant_icon_new === undefined)
                  {
                     mainMc["MysteriousMerchant_icon"].newMc.visible = true;
                  }
                  else
                  {
                     mainMc["MysteriousMerchant_icon"].newMc.visible = false;
                  }
                  Main.initButton(mainMc["MysteriousMerchant_icon"],clickMapSideBtn,null);
                  Main.showDynamicTooltip(mainMc["MysteriousMerchant_icon"],"<font size =\'16\'> " + (AppData.lang == AppData.ZH ? "神秘商人" : "Mysterious Merchant") + " </font>");
               }
               else
               {
                  mainMc["MysteriousMerchant_icon"].visible = false;
                  Main.disableButton(mainMc["MysteriousMerchant_icon"],clickMapSideBtn,null);
               }
               if(Main.getMainChar().getLevel() >= Main.DISPLAY_LEVEL_LIMIT_EVENT_EASTER)
               {
                  mainMc["kageskillBtn"].visible = true;
                  mainMc["kageskillBtn"].filters = null;
                  mainMc["kageskillBtn"].newMc.visible = true;
                  Main.initButton(mainMc["kageskillBtn"],clickMapSideBtn,null);
                  Main.showDynamicTooltip(mainMc["kageskillBtn"],"<font size =\'16\'> " + (AppData.lang == AppData.ZH ? "村長的學徒" : "Kage Apprenticeship") + " </font>");
               }
               else
               {
                  mainMc["kageskillBtn"].visible = false;
                  Main.disableButton(mainMc["kageskillBtn"],clickMapSideBtn,null);
               }
               if(Boolean(Main.getMainChar().getLevel() >= Main.DISPLAY_LEVEL_LIMIT_EVENT_EASTER) && Boolean(Central.main.extraData) && (Central.main.extraData.Skill901_icon === undefined || Central.main.extraData.Skill901_icon === true))
               {
                  mainMc["Skill901_icon"].visible = true;
                  mainMc["Skill901_icon"].filters = null;
                  mainMc["Skill901_icon"].newMc.visible = true;
                  Main.initButton(mainMc["Skill901_icon"],clickMapSideBtn,null);
                  Main.showDynamicTooltip(mainMc["Skill901_icon"],"<font size =\'16\'> " + (AppData.lang == AppData.ZH ? "禁術：蟾蜍召喚攻擊" : "Kinjutsu: Summon Toad Skill") + " </font>");
               }
               else
               {
                  mainMc["Skill901_icon"].visible = false;
                  Main.disableButton(mainMc["Skill901_icon"],clickMapSideBtn,null);
               }
               if(Main.getMainChar().getLevel() >= Main.DISPLAY_LEVEL_LIMIT_EVENT_EASTER)
               {
                  mainMc["Easter2020Btn"].visible = true;
                  mainMc["Easter2020Btn"].filters = null;
                  mainMc["Easter2020Btn"].newMc.visible = true;
                  Main.initButton(mainMc["Easter2020Btn"],clickMapSideBtn,null);
                  Main.showDynamicTooltip(mainMc["Easter2020Btn"],"<font size =\'16\'> " + (AppData.lang == AppData.ZH ? "2020復活節" : "Easter 2020") + " </font>");
               }
               else
               {
                  mainMc["Easter2020Btn"].visible = false;
                  Main.disableButton(mainMc["Easter2020Btn"],clickMapSideBtn,null);
               }
               if(Main.getMainChar().getLevel() >= Main.DISPLAY_LEVEL_LIMIT_EVENT_EASTER)
               {
                  mainMc["Easter2018Btn"].visible = true;
                  mainMc["Easter2018Btn"].filters = null;
                  mainMc["Easter2018Btn"].newMc.visible = true;
                  Main.initButton(mainMc["Easter2018Btn"],clickMapSideBtn,null);
                  Main.showDynamicTooltip(mainMc["Easter2018Btn"],"<font size =\'16\'> " + (AppData.lang == AppData.ZH ? "復活節巨獸" : "Easter Giant Beasts") + " </font>");
               }
               else
               {
                  mainMc["Easter2018Btn"].visible = false;
                  Main.disableButton(mainMc["Easter2018Btn"],clickMapSideBtn,null);
               }
               if(Main.getMainChar().getLevel() >= Main.DISPLAY_LEVEL_LIMIT_EVENT_EASTER)
               {
                  mainMc["PackageBtn"].visible = true;
                  mainMc["PackageBtn"].filters = null;
                  if(Central.main.extraData.event_btn_new === true)
                  {
                     mainMc["PackageBtn"].newMc.visible = true;
                  }
                  else
                  {
                     mainMc["PackageBtn"].newMc.visible = false;
                  }
                  Main.initButton(mainMc["PackageBtn"],clickMapSideBtn,null);
                  Main.showDynamicTooltip(mainMc["PackageBtn"],"<font size =\'16\'> " + (AppData.lang == AppData.ZH ? "套裝" : "Package") + " </font>");
               }
               else
               {
                  mainMc["PackageBtn"].visible = false;
                  Main.disableButton(mainMc["PackageBtn"],clickMapSideBtn,null);
               }
               if(Main.getMainChar().getLevel() >= Main.DISPLAY_LEVEL_LIMIT_EVENT_EASTER)
               {
                  mainMc["event2017_icon"].visible = true;
                  mainMc["event2017_icon"].filters = null;
                  if(Central.main.extraData.event_btn_new === true)
                  {
                     mainMc["event2017_icon"].newMc.visible = true;
                  }
                  else
                  {
                     mainMc["event2017_icon"].newMc.visible = false;
                  }
                  Main.initButton(mainMc["event2017_icon"],clickMapSideBtn,null);
                  Main.showDynamicTooltip(mainMc["event2017_icon"],"<font size =\'16\'> " + (AppData.lang == AppData.ZH ? "活動" : "Events") + " </font>");
               }
               else
               {
                  mainMc["event2017_icon"].visible = false;
                  Main.disableButton(mainMc["event2017_icon"],clickMapSideBtn,null);
               }
               if(Boolean(Main.getMainChar().getLevel() >= Main.DISPLAY_LEVEL_LIMIT_EVENT_EASTER) && Boolean(Central.main.extraData) && (Central.main.extraData.newDailyLoginStamp2017_icon === undefined || Central.main.extraData.newDailyLoginStamp2017_icon === true))
               {
                  mainMc["newDailyLoginStamp2017_icon"].visible = true;
                  mainMc["newDailyLoginStamp2017_icon"].filters = null;
                  if(Boolean(mainMc["newDailyLoginStamp2017_icon"]) && Boolean(mainMc["newDailyLoginStamp2017_icon"].newMc))
                  {
                     if(Main.extraData.newDailyLoginStamp2017_iconisNew === false)
                     {
                        mainMc["newDailyLoginStamp2017_icon"].newMc.visible = false;
                     }
                     else
                     {
                        mainMc["newDailyLoginStamp2017_icon"].newMc.visible = true;
                     }
                  }
                  Main.initButton(mainMc["newDailyLoginStamp2017_icon"],clickMapSideBtn,null);
                  Main.showDynamicTooltip(mainMc["newDailyLoginStamp2017_icon"],"<font size =\'16\'> " + (AppData.lang == AppData.ZH ? Central.main.extraData.newDailyLoginStamp2017_iconZh : Central.main.extraData.newDailyLoginStamp2017_iconEn) + " </font>");
               }
               else
               {
                  mainMc["newDailyLoginStamp2017_icon"].visible = false;
                  Main.disableButton(mainMc["newDailyLoginStamp2017_icon"],clickMapSideBtn,null);
               }
               if(Features.EXAM_CHUNIN_PANEL)
               {
                  if(Main.getMainChar().getLevel() == 20 && Main.getMainChar().getData(DBCharacterData.RANK) == 1)
                  {
                     mainMc["chuninexamBtn"].visible = true;
                     Main.initButton(mainMc["chuninexamBtn"],proc.showchuninExamPage,null);
                     Main.showDynamicTooltip(mainMc["chuninexamBtn"],"<font size =\'16\'>" + String(Main.langLib.get(1594)[0]) + "</font>");
                  }
                  else
                  {
                     mainMc["chuninexamBtn"].visible = false;
                  }
               }
               if(Features.EVENT_HALLOWEEN_2012)
               {
               }
               if(Features.EVENT_THANKSGIVING_2012)
               {
               }
               if(Boolean(Main.extraData) && Boolean(Main.extraData.limited_offer_20200826 === true) && Main.getMainChar().getLevel() >= Main.DISPLAY_LEVEL_LIMIT_EVENT_EASTER)
               {
                  mainMc["limitOffer20200826Btn"].visible = true;
                  mainMc["limitOffer20200826Btn"].filters = null;
                  Main.initButton(mainMc["limitOffer20200826Btn"],clickMapSideBtn,null);
                  Main.showDynamicTooltip(mainMc["limitOffer20200826Btn"],"<font size =\'16\'> " + (AppData.lang == AppData.ZH ? "限時優惠" : "Limited Offer") + " </font>");
                  if(Boolean(mainMc["limitOffer20200826Btn"]) && Boolean(mainMc["limitOffer20200826Btn"].newMc))
                  {
                     if(Main.extraData.limited_offer_20200826_new === false)
                     {
                        mainMc["limitOffer20200826Btn"].newMc.visible = false;
                     }
                     else
                     {
                        mainMc["limitOffer20200826Btn"].newMc.visible = true;
                     }
                  }
               }
               else
               {
                  mainMc["limitOffer20200826Btn"].visible = false;
                  Main.disableButton(mainMc["limitOffer20200826Btn"],clickMapSideBtn,null);
               }
               if(Boolean(Main.extraData) && Boolean(Main.extraData.limited_offer_20200805 === true) && Main.getMainChar().getLevel() >= Main.DISPLAY_LEVEL_LIMIT_EVENT_EASTER)
               {
                  mainMc["limitOffer20200805Btn"].visible = true;
                  mainMc["limitOffer20200805Btn"].filters = null;
                  Main.initButton(mainMc["limitOffer20200805Btn"],clickMapSideBtn,null);
                  Main.showDynamicTooltip(mainMc["limitOffer20200805Btn"],"<font size =\'16\'> " + (AppData.lang == AppData.ZH ? "限時優惠" : "Limited Offer") + " </font>");
                  if(Boolean(mainMc["limitOffer20200805Btn"]) && Boolean(mainMc["limitOffer20200805Btn"].newMc))
                  {
                     if(Main.extraData.limited_offer_20200805_new === false)
                     {
                        mainMc["limitOffer20200805Btn"].newMc.visible = false;
                     }
                     else
                     {
                        mainMc["limitOffer20200805Btn"].newMc.visible = true;
                     }
                  }
               }
               else
               {
                  mainMc["limitOffer20200805Btn"].visible = false;
                  Main.disableButton(mainMc["limitOffer20200805Btn"],clickMapSideBtn,null);
               }
               if(Boolean(Main.extraData) && (Boolean(Main.extraData.GodSnapBtn === undefined || Main.extraData.GodSnapBtn === true)) && Main.getMainChar().getLevel() >= Main.DISPLAY_LEVEL_LIMIT_EVENT_EASTER)
               {
                  mainMc["GodSnapBtn"].visible = true;
                  mainMc["GodSnapBtn"].filters = null;
                  Main.initButton(mainMc["GodSnapBtn"],clickMapSideBtn,null);
                  Main.showDynamicTooltip(mainMc["GodSnapBtn"],"<font size =\'16\'> " + (AppData.lang == AppData.ZH ? "六元素手套" : "Six-Element Gauntlet") + " </font>");
                  if(Boolean(mainMc["GodSnapBtn"]) && Boolean(mainMc["GodSnapBtn"].newMc))
                  {
                     if(Main.extraData.GodSnapBtn_new === false)
                     {
                        mainMc["GodSnapBtn"].newMc.visible = false;
                     }
                     else
                     {
                        mainMc["GodSnapBtn"].newMc.visible = true;
                     }
                  }
               }
               else
               {
                  mainMc["GodSnapBtn"].visible = false;
                  Main.disableButton(mainMc["GodSnapBtn"],clickMapSideBtn,null);
               }
               if(Features.FEATURE_ROULETTE)
               {
                  Main.initButton(mapMenu["rouletteBtn"],proc.showRoulette,null);
                  if(proc.isShowRoulette)
                  {
                     mapMenu["rouletteBtn"].visible = true;
                     Main.showDynamicTooltip(mapMenu["rouletteBtn"],"<font size =\'16\'>" + langLib.titleTxt(TitleData.DAILYLUCKYDRAW) + "</font>");
                  }
                  else
                  {
                     mapMenu["rouletteBtn"].visible = false;
                     mapMenu["rouletteBtn"].removeEventListener(MouseEvent.CLICK,proc.showRoulette);
                  }
               }
               if(Main.showDailyRoulette > 0 && Main.checkGameStatus() == Timeline.MAP && Main.spinChance > 0 && Main.getMainChar().getLevel() <= 100)
               {
                  mapMenu["dailyRouletteBtn"].visible = true;
                  mapMenu["dailyRouletteBtn"].mouseEnabled = true;
                  mapMenu["dailyRouletteBtn"].addEventListener(MouseEvent.CLICK,clickMapSideBtn);
                  Main.showDynamicTooltip(mapMenu["dailyRouletteBtn"],"<font size =\'16\'>" + String(langLib.get(1859)[8]) + "</font>");
               }
               else
               {
                  mapMenu["dailyRouletteBtn"].visible = false;
                  mapMenu["dailyRouletteBtn"].mouseEnabled = false;
                  mapMenu["dailyRouletteBtn"].removeEventListener(MouseEvent.CLICK,clickMapSideBtn);
               }
               if(Features.FEATURE_DAILY_LOGIN)
               {
                  if(Central.main.dailyLogin)
                  {
                     Main.initButton(mapMenu["dailyLoginBtn"],clickMapSideBtn,null);
                     mapMenu["dailyLoginBtn"].visible = true;
                     mapMenu["dailyLoginBtn"]["newMc"].visible = false;
                     Main.showDynamicTooltip(mapMenu["dailyLoginBtn"],"<font size =\'16\'>" + String(langLib.titleTxt(TitleData.DAILY_LOGIN_TITLE)) + "</font>");
                  }
                  else
                  {
                     Main.disableButton(mapMenu["dailyLoginBtn"],clickMapSideBtn,null);
                     mapMenu["dailyLoginBtn"].visible = false;
                  }
               }
               if(Features.FEATURE_DAILY_SCRATCH)
               {
                  if(Main.getMainChar().getLevel() <= 20)
                  {
                     Main.initButton(mapMenu["dailyScartchBtn"],clickMapSideBtn,null);
                     mapMenu["dailyScartchBtn"].visible = true;
                     mapMenu["dailyScartchBtn"]["newMc"].visible = false;
                     if(Main.currScartchCard > 0)
                     {
                        mapMenu["dailyScartchBtn"]["numMC"].visible = true;
                        mapMenu["dailyScartchBtn"]["numMC"]["numTxt"].text = Main.currScartchCard;
                     }
                     else
                     {
                        mapMenu["dailyScartchBtn"]["numMC"].visible = false;
                        mapMenu["dailyScartchBtn"]["numMC"]["numTxt"].text = "";
                     }
                     Main.showDynamicTooltip(mapMenu["dailyScartchBtn"],"<font size =\'16\'>" + String(langLib.get(1630)[0]) + "</font>");
                  }
                  else
                  {
                     Main.disableButton(mapMenu["dailyScartchBtn"],clickMapSideBtn,null);
                     mapMenu["dailyScartchBtn"].visible = false;
                  }
               }
               if(Features.FEATURE_DAILY_TASK)
               {
                  if(Central.mission.checkDailyTaskStatus() > 0)
                  {
                     if(Central.mission.checkDailyTaskStatus() == 1)
                     {
                        mapMenu["dailyTaskMc"]["starMC"].visible = false;
                     }
                     if(Central.mission.checkDailyTaskStatus() == 2)
                     {
                        mapMenu["dailyTaskMc"]["starMC"].visible = true;
                     }
                     mapMenu["dailyTaskMc"].visible = true;
                     Main.initButton(mapMenu["dailyTaskMc"],showDailyTask,null);
                     Main.showDynamicTooltip(mapMenu["dailyTaskMc"],"<font size =\'16\'>" + langLib.get(402) + "</font>");
                     mapMenu["dailyTaskMc"]["newMc"].visible = false;
                  }
               }
               if(Features.FEATURE_GIFT)
               {
                  mapMenu["giftBtn"].visible = true;
                  mapMenu["giftBtn"]["newMc"].visible = false;
                  mapMenu["giftBtn"]["numMC"].visible = false;
                  mapMenu["giftBtn"]["numMC"]["numTxt"].text = "";
                  Main.initButton(mapMenu["giftBtn"],gotoSendGift,null);
                  Main.showDynamicTooltip(mapMenu["giftBtn"],"<font size =\'16\'>" + langLib.titleTxt(TitleData.NEW_FREE_GIFT) + "</font>");
               }
               if(Features.FEATURE_INVITE_REWARD)
               {
                  if(Features.FEATURE_INVITE_INSTANT_REWRAD)
                  {
                     mapMenu["inviteFriendBtn"].visible = true;
                     mapMenu["inviteFriendBtn"]["newMc"].visible = false;
                     Main.initButton(mapMenu["inviteFriendBtn"],clickMapSideBtn,null);
                     Main.showDynamicTooltip(mapMenu["inviteFriendBtn"],"<font size =\'16\'>" + langLib.titleTxt(TitleData.INVITEREWARDTITLE) + "</font>");
                  }
               }
               if(Features.FEATURE_MAIL)
               {
                  if(Main.currMail != 0)
                  {
                     mapMenu["mailboxBtn"].visible = true;
                     if(proc.newMail)
                     {
                        mapMenu["mailboxBtn"]["starMC"].visible = true;
                     }
                     else
                     {
                        mapMenu["mailboxBtn"]["starMC"].visible = false;
                     }
                     mapMenu["mailboxBtn"].gotoAndStop(2);
                     Main.initButton(mapMenu["mailboxBtn"],popup.showMailbox,null);
                     Main.showDynamicTooltip(mapMenu["mailboxBtn"],"<font size =\'16\'>" + langLib.titleTxt(TitleData.MAILBOX) + "</font>");
                  }
                  else
                  {
                     mapMenu["mailboxBtn"].visible = false;
                  }
               }
               if(Features.FEATURE_EMBLEM_DAILY_GIFT)
               {
                  mapMenu["emblemDailygiftBtn"].visible = true;
                  mapMenu["emblemDailygiftBtn"]["newMc"].visible = Central.main.extraData.emblem_type == 1;
                  Main.initButton(mapMenu["emblemDailygiftBtn"],clickMapSideBtn,null);
                  Main.showDynamicTooltip(mapMenu["emblemDailygiftBtn"],"<font size =\'16\'>" + String(langLib.get(1634)[0]) + "</font>");
               }
               if(Features.FEATURE_REQUEST)
               {
                  mapMenu["requestPopupBtn"].visible = true;
                  if(Main.currRequest > 0)
                  {
                     mapMenu["requestPopupBtn"]["numMC"].visible = true;
                     mapMenu["requestPopupBtn"]["numMC"]["numTxt"].text = Main.currRequest;
                  }
                  else
                  {
                     mapMenu["requestPopupBtn"]["numMC"].visible = false;
                     mapMenu["requestPopupBtn"]["numMC"]["numTxt"].text = "";
                  }
                  Main.initButton(mapMenu["requestPopupBtn"],clickMapSideBtn,null);
                  Main.showDynamicTooltip(mapMenu["requestPopupBtn"],"<font size =\'16\'>" + Main.langLib.get(1615)[1] + "</font>");
               }
               shiftPosMapSideBtn();
               setIconPost();
               setRightIconPost();
               Main.updateLvStatusBar();
               if(Main.Theme_Halloween)
               {
               }
            }
         }
      }
      
      public static function setIconPost() : void
      {
         var _loc2_:uint = 0;
         iconCanShow = 5;
         post = 0;
         canShow = false;
         isShowing = 0;
         canPress = true;
         showLIconArr = new Array();
         var _loc1_:int = 0;
         _loc2_ = 0;
         while(_loc2_ < ALL_LEFT_BTN_ARR.length)
         {
            if(mainMc[ALL_LEFT_BTN_ARR[_loc2_]].visible == true)
            {
               showLIconArr.push(ALL_LEFT_BTN_ARR[_loc2_]);
               mainMc[showLIconArr[_loc1_]].post = _loc1_;
               if(mainMc[showLIconArr[_loc1_]].post >= iconCanShow || mainMc[showLIconArr[_loc1_]].post < 0)
               {
                  TweenLite.to(mainMc[showLIconArr[_loc1_]],0,{
                     "scaleX":0,
                     "scaleY":0
                  });
               }
               else
               {
                  TweenLite.to(mainMc[showLIconArr[_loc1_]],0,{
                     "scaleX":1,
                     "scaleY":1
                  });
               }
               _loc1_++;
               ++isShowing;
            }
            _loc2_++;
         }
         if(isShowing - iconCanShow > 1)
         {
            lMaxY = mainMc[showLIconArr[iconCanShow + 1]].y;
            lMinY = mainMc[showLIconArr[0]].y;
            pressLimit = isShowing - iconCanShow;
         }
         else if(isShowing - iconCanShow > 0)
         {
            lMaxY = mainMc[showLIconArr[iconCanShow]].y;
            lMinY = mainMc[showLIconArr[0]].y;
            pressLimit = isShowing - iconCanShow;
         }
         else
         {
            mainMc["leftIconUp"].visible = false;
            mainMc["leftIconDown"].visible = false;
         }
      }
      
      public static function setRightIconPost() : void
      {
         var _loc2_:uint = 0;
         rIconCanShow = 5;
         rPost = 0;
         rCanShow = false;
         rIsShowing = 0;
         rCanPress = true;
         showIconArr = new Array();
         var _loc1_:int = 0;
         _loc2_ = 0;
         while(_loc2_ < ALL_RIGHT_BTN_ARR.length)
         {
            if(setupRightIconX)
            {
               mapMenu[ALL_RIGHT_BTN_ARR[_loc2_]].rightIconOriX = mapMenu[ALL_RIGHT_BTN_ARR[_loc2_]].x;
            }
            if(mapMenu[ALL_RIGHT_BTN_ARR[_loc2_]].visible == true)
            {
               showIconArr.push(ALL_RIGHT_BTN_ARR[_loc2_]);
               if(mapMenu[showIconArr[_loc1_]].rPost == -1)
               {
                  mapMenu[showIconArr[_loc1_]].x -= 80;
               }
               mapMenu[showIconArr[_loc1_]].rPost = _loc1_;
               if(mapMenu[showIconArr[_loc1_]].rPost >= rIconCanShow || mapMenu[showIconArr[_loc1_]].rPost < 0)
               {
                  TweenLite.to(mapMenu[showIconArr[_loc1_]],0,{
                     "scaleX":0,
                     "scaleY":0
                  });
               }
               else
               {
                  TweenLite.to(mapMenu[showIconArr[_loc1_]],0,{
                     "scaleX":1,
                     "scaleY":1
                  });
               }
               _loc1_++;
               ++rIsShowing;
            }
            _loc2_++;
         }
         setupRightIconX = false;
         if(rIsShowing - rIconCanShow > 1)
         {
            rMaxY = mapMenu[showIconArr[rIconCanShow + 1]].y;
            rMinY = mapMenu[showIconArr[0]].y;
            rPressLimit = rIsShowing - rIconCanShow;
         }
         else if(rIsShowing - rIconCanShow > 0)
         {
            rMaxY = mapMenu[showIconArr[rIconCanShow]].y;
            rMinY = mapMenu[showIconArr[0]].y;
            rPressLimit = rIsShowing - rIconCanShow;
         }
         else
         {
            mainMc["rightIconUp"].visible = false;
            mainMc["rightIconDown"].visible = false;
         }
      }
      
      public static function leftIconUp(param1:MouseEvent) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         if(canPress == true)
         {
            canPress = false;
            _loc3_ = 0;
            while(_loc3_ < showLIconArr.length)
            {
               --mainMc[showLIconArr[_loc3_]].post;
               if(mainMc[showLIconArr[_loc3_]].post == 0 - pressLimit)
               {
                  if(isShowing != 6)
                  {
                     mainMc[showLIconArr[_loc3_]].post = showLIconArr.length - pressLimit;
                     mainMc[showLIconArr[_loc3_]].y = lMaxY;
                  }
               }
               if(mainMc[showLIconArr[_loc3_]].post >= iconCanShow)
               {
                  TweenLite.to(mainMc[showLIconArr[_loc3_]],0.5,{
                     "scaleX":0,
                     "scaleY":0,
                     "y":mainMc[showLIconArr[_loc3_]].y - 70,
                     "onComplete":checkCanPress
                  });
               }
               if(mainMc[showLIconArr[_loc3_]].post < 0)
               {
                  if(isShowing == 6)
                  {
                     TweenLite.to(mainMc[showLIconArr[_loc3_]],0.5,{
                        "scaleX":0,
                        "scaleY":0,
                        "y":mainMc[showLIconArr[_loc3_]].y - 15,
                        "onComplete":checkCanPress,
                        "onCompleteParams":[true,mainMc[showLIconArr[_loc3_]]]
                     });
                  }
                  else
                  {
                     TweenLite.to(mainMc[showLIconArr[_loc3_]],0.5,{
                        "scaleX":0,
                        "scaleY":0,
                        "y":mainMc[showLIconArr[_loc3_]].y - 15,
                        "onComplete":checkCanPress
                     });
                  }
               }
               if(mainMc[showLIconArr[_loc3_]].post < iconCanShow && mainMc[showLIconArr[_loc3_]].post >= 0)
               {
                  TweenLite.to(mainMc[showLIconArr[_loc3_]],0.5,{
                     "scaleX":1,
                     "scaleY":1,
                     "y":mainMc[showLIconArr[_loc3_]].y - 70,
                     "onComplete":checkCanPress
                  });
               }
               _loc3_++;
            }
         }
      }
      
      public static function leftIconDown(param1:MouseEvent) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:Boolean = false;
         if(canPress == true)
         {
            canPress = false;
            _loc3_ = 0;
            while(_loc3_ < showLIconArr.length)
            {
               if(mainMc[showLIconArr[_loc3_]].post == -1)
               {
                  mainMc[showLIconArr[_loc3_]].post = showLIconArr.length - 1;
               }
               if(mainMc[showLIconArr[_loc3_]].post == showLIconArr.length - 1)
               {
                  _loc4_ = true;
               }
               ++mainMc[showLIconArr[_loc3_]].post;
               if(mainMc[showLIconArr[_loc3_]].post == showLIconArr.length)
               {
                  mainMc[showLIconArr[_loc3_]].post = 0;
                  mainMc[showLIconArr[_loc3_]].y = lMinY - 15;
               }
               if(mainMc[showLIconArr[_loc3_]].post >= iconCanShow)
               {
                  TweenLite.to(mainMc[showLIconArr[_loc3_]],0.5,{
                     "scaleX":0,
                     "scaleY":0,
                     "y":mainMc[showLIconArr[_loc3_]].y + 70,
                     "onComplete":checkCanPress
                  });
               }
               if(mainMc[showLIconArr[_loc3_]].post < 0)
               {
                  TweenLite.to(mainMc[showLIconArr[_loc3_]],0.5,{
                     "scaleX":0,
                     "scaleY":0,
                     "y":mainMc[showLIconArr[_loc3_]].y + 15,
                     "onComplete":checkCanPress
                  });
               }
               if(mainMc[showLIconArr[_loc3_]].post < iconCanShow && mainMc[showLIconArr[_loc3_]].post >= 0)
               {
                  if(_loc4_)
                  {
                     TweenLite.to(mainMc[showLIconArr[_loc3_]],0.5,{
                        "scaleX":1,
                        "scaleY":1,
                        "y":mainMc[showLIconArr[_loc3_]].y + 15,
                        "onComplete":checkCanPress
                     });
                     _loc4_ = false;
                  }
                  else
                  {
                     TweenLite.to(mainMc[showLIconArr[_loc3_]],0.5,{
                        "scaleX":1,
                        "scaleY":1,
                        "y":mainMc[showLIconArr[_loc3_]].y + 70,
                        "onComplete":checkCanPress
                     });
                  }
               }
               _loc3_++;
            }
         }
      }
      
      public static function rightIconUp(param1:MouseEvent) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:Boolean = false;
         if(rCanPress == true)
         {
            rCanPress = false;
            _loc3_ = 0;
            while(_loc3_ < showIconArr.length)
            {
               if(mapMenu[showIconArr[_loc3_]].rPost == rIconCanShow)
               {
                  _loc4_ = true;
               }
               --mapMenu[showIconArr[_loc3_]].rPost;
               if(mapMenu[showIconArr[_loc3_]].rPost == 0 - rPressLimit)
               {
                  if(rIsShowing == 6)
                  {
                     mapMenu[showIconArr[_loc3_]].x = mapMenu[showIconArr[_loc3_]].rightIconOriX;
                  }
                  else
                  {
                     mapMenu[showIconArr[_loc3_]].y = rMaxY;
                     mapMenu[showIconArr[_loc3_]].rPost = showIconArr.length - rPressLimit;
                     mapMenu[showIconArr[_loc3_]].x -= 80;
                     mapMenu[showIconArr[_loc3_]].x = mapMenu[showIconArr[_loc3_]].rightIconOriX;
                  }
               }
               if(mapMenu[showIconArr[_loc3_]].rPost >= rIconCanShow)
               {
                  mapMenu[showIconArr[_loc3_]].x += 80;
                  TweenLite.to(mapMenu[showIconArr[_loc3_]],0.5,{
                     "scaleX":0,
                     "scaleY":0,
                     "x":mapMenu[showIconArr[_loc3_]].x - 80,
                     "y":mapMenu[showIconArr[_loc3_]].y - 70,
                     "onComplete":checkCanRpress
                  });
               }
               if(mapMenu[showIconArr[_loc3_]].rPost < 0)
               {
                  if(rIsShowing == 6)
                  {
                     TweenLite.to(mapMenu[showIconArr[_loc3_]],0.5,{
                        "scaleX":0,
                        "scaleY":0,
                        "x":mapMenu[showIconArr[_loc3_]].x + 80,
                        "y":mapMenu[showIconArr[_loc3_]].y - 15,
                        "onComplete":checkCanRpress,
                        "onCompleteParams":[false,mapMenu[showIconArr[_loc3_]],true]
                     });
                  }
                  else
                  {
                     TweenLite.to(mapMenu[showIconArr[_loc3_]],0.5,{
                        "scaleX":0,
                        "scaleY":0,
                        "x":mapMenu[showIconArr[_loc3_]].x + 80,
                        "y":mapMenu[showIconArr[_loc3_]].y - 15,
                        "onComplete":checkCanRpress
                     });
                  }
               }
               if(mapMenu[showIconArr[_loc3_]].rPost < rIconCanShow && mapMenu[showIconArr[_loc3_]].rPost >= 0)
               {
                  if(_loc4_)
                  {
                     mapMenu[showIconArr[_loc3_]].x += 80;
                     TweenLite.to(mapMenu[showIconArr[_loc3_]],0.5,{
                        "scaleX":1,
                        "scaleY":1,
                        "x":mapMenu[showIconArr[_loc3_]].x - 80,
                        "y":mapMenu[showIconArr[_loc3_]].y - 70,
                        "onComplete":checkCanRpress
                     });
                     _loc4_ = false;
                  }
                  else
                  {
                     TweenLite.to(mapMenu[showIconArr[_loc3_]],0.5,{
                        "scaleX":1,
                        "scaleY":1,
                        "y":mapMenu[showIconArr[_loc3_]].y - 70,
                        "onComplete":checkCanRpress
                     });
                  }
               }
               _loc3_++;
            }
         }
      }
      
      public static function rightIconDown(param1:MouseEvent) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:Boolean = false;
         if(rCanPress == true)
         {
            rCanPress = false;
            _loc3_ = 0;
            while(_loc3_ < showIconArr.length)
            {
               if(mapMenu[showIconArr[_loc3_]].rPost == -1)
               {
                  mapMenu[showIconArr[_loc3_]].x -= 80;
                  mapMenu[showIconArr[_loc3_]].rPost = showIconArr.length - 1;
               }
               if(mapMenu[showIconArr[_loc3_]].rPost == showIconArr.length - 1)
               {
                  _loc4_ = true;
               }
               ++mapMenu[showIconArr[_loc3_]].rPost;
               if(mapMenu[showIconArr[_loc3_]].rPost == showIconArr.length)
               {
                  mapMenu[showIconArr[_loc3_]].y = rMinY - 30;
                  mapMenu[showIconArr[_loc3_]].rPost = 0;
               }
               if(mapMenu[showIconArr[_loc3_]].rPost >= rIconCanShow)
               {
                  TweenLite.to(mapMenu[showIconArr[_loc3_]],0.5,{
                     "scaleX":0,
                     "scaleY":0,
                     "x":mapMenu[showIconArr[_loc3_]].x + 80,
                     "y":mapMenu[showIconArr[_loc3_]].y + 70,
                     "onComplete":checkCanRpress,
                     "onCompleteParams":[true,mapMenu[showIconArr[_loc3_]]]
                  });
               }
               if(mapMenu[showIconArr[_loc3_]].rPost <= -1)
               {
                  TweenLite.to(mapMenu[showIconArr[_loc3_]],0.5,{
                     "scaleX":0,
                     "scaleY":0,
                     "x":mapMenu[showIconArr[_loc3_]].x - 80,
                     "y":mapMenu[showIconArr[_loc3_]].y + 30,
                     "onComplete":checkCanRpress
                  });
               }
               if(mapMenu[showIconArr[_loc3_]].rPost < rIconCanShow && mapMenu[showIconArr[_loc3_]].rPost >= 0)
               {
                  if(_loc4_)
                  {
                     mapMenu[showIconArr[_loc3_]].x += 80;
                     TweenLite.to(mapMenu[showIconArr[_loc3_]],0.5,{
                        "scaleX":1,
                        "scaleY":1,
                        "x":mapMenu[showIconArr[_loc3_]].x - 80,
                        "y":mapMenu[showIconArr[_loc3_]].y + 30,
                        "onComplete":checkCanRpress
                     });
                     _loc4_ = false;
                  }
                  else
                  {
                     TweenLite.to(mapMenu[showIconArr[_loc3_]],0.5,{
                        "scaleX":1,
                        "scaleY":1,
                        "y":mapMenu[showIconArr[_loc3_]].y + 70,
                        "onComplete":checkCanRpress
                     });
                  }
               }
               _loc3_++;
            }
         }
      }
      
      public static function checkCanPress(param1:Boolean = false, param2:MovieClip = null) : void
      {
         canPress = true;
         if(param1)
         {
            param2.post = showLIconArr.length - pressLimit;
            param2.y = lMaxY;
         }
      }
      
      public static function checkCanRpress(param1:Boolean = false, param2:MovieClip = null, param3:Boolean = false) : void
      {
         rCanPress = true;
         if(param1)
         {
            param2.x -= 80;
         }
         if(param3)
         {
            param2.rPost = showIconArr.length - rPressLimit;
            param2.y = rMaxY;
            param2.x -= 80;
         }
      }
      
      public static function addInventoryYM() : void
      {
         if(Main.minik_xmas_gift != null)
         {
            switch(Main.minik_xmas_gift_type)
            {
               case "back":
                  Main.getMainChar().addInventory(InventoryData.TYPE_BACK_ITEM,Main.minik_xmas_gift);
                  break;
               case "set":
                  Main.getMainChar().addInventory(InventoryData.TYPE_BODY_SET,Main.minik_xmas_gift);
                  break;
               case "wpn":
                  Main.getMainChar().addInventory(InventoryData.TYPE_WEAPON,Main.minik_xmas_gift);
                  break;
               case "skill":
                  Central.main.getMainChar().addNewSkill(Main.minik_xmas_gift,new Function());
                  break;
               case "token":
                  Main.account.balance = Main.account.getAccountBalance() + 100;
                  Main.updateMenu();
            }
            Main.minik_xmas_gift = null;
         }
      }
      
      private static function SJENoticeOk() : void
      {
         Central.main.showAmfLoading();
         Main.amfClient.service("CharacterDAO.watchSJENotice",[Central.main.account.getAccountSessionKey()],onSJENoticeResult);
      }
      
      public static function onSJENoticeResult(param1:Object) : void
      {
         if(validateAmfResponse(param1))
         {
            ++Main.sje_notice;
         }
         Central.main.hideAmfLoading();
      }
      
      private static function confirmActivateHM(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:String = null;
         var _loc4_:Boolean = false;
         var _loc5_:Object = null;
         if(Main.dayleft < 0)
         {
            _loc4_ = false;
            _loc2_ = 0;
            while(_loc2_ < Data.EXAM_SPECIAL_JOUNIN_ARR.length)
            {
               _loc5_ = Main.getMainChar().checkMissionRecord(Data.EXAM_SPECIAL_JOUNIN_ARR[_loc2_]);
               if(_loc5_.success > 0 || _loc5_.fail > 0)
               {
                  _loc4_ = true;
                  break;
               }
               _loc2_++;
            }
            if(_loc4_)
            {
               _loc3_ = String(Main.langLib.get(1437)[32]);
            }
            else
            {
               _loc3_ = String(Main.langLib.get(1437)[31]);
            }
            Main.showConfirmation(_loc3_,confirmStartSJExam,new Function());
         }
         else
         {
            Main.proc.showExam();
         }
      }
      
      public static function confirmStartSJExam() : void
      {
         Main.showAmfLoading();
         Main.amfClient.service("CharacterService.startSJExam",[Central.main.account.getAccountSessionKey()],responseStartSJExam);
      }
      
      public static function responseStartSJExam(param1:Object) : void
      {
         Main.hideAmfLoading();
         if(validateAmfResponse(param1))
         {
            Main.dayleft = param1.sje_end_date as int;
            Main.proc.showExam();
         }
      }
      
      public static function initMapButtons() : void
      {
         mainMc["mapMc"].initBuildings();
      }
      
      private static function onClickShop(param1:MouseEvent = null) : void
      {
         Panel.getInstance().show("shop_new");
      }
      
      private static function onClickMission(param1:MouseEvent = null) : void
      {
         Panel.getInstance().show("mission_2");
      }
      
      private static function gotoSendGift(param1:MouseEvent = null) : void
      {
         Central.main.loadPopupPanel("popup_sendGift","ninjasaga.linkage.popup_sendGift");
      }
      
      private static function showJouninExam(param1:MouseEvent) : void
      {
         Panel.getInstance().show("jounin_exam");
      }
      
      public static function showNinjaAssociation(param1:String) : void
      {
         Panel.getInstance().show("ninja_association",param1);
      }
      
      public static function highlightMap(param1:uint) : void
      {
         mainMc["mapMc"]["highlightMc"].gotoAndStop(param1);
      }
      
      public static function onClickRandomBattle() : void
      {
         var _loc6_:uint = 0;
         var _loc7_:Object = null;
         tracking.trackStartAction(Central.main.tracking.SA_PRACTICE_BATTLE);
         Mission.clearMission();
         var _loc1_:Array = EnemyData.getInstance().arr;
         var _loc2_:Number = NumberUtil.randomNumber(1,3.999);
         var _loc3_:uint = Math.floor(_loc2_);
         var _loc4_:Array = [];
         var _loc5_:Array = [];
         _loc6_ = 0;
         while(_loc6_ < _loc1_.length)
         {
            _loc7_ = _loc1_[_loc6_];
            if(Boolean(_loc7_.randomBattle) && getMainChar().getLevel() >= _loc7_.minLevel)
            {
               _loc4_.push(_loc7_);
            }
            _loc6_++;
         }
         _loc6_ = 0;
         while(_loc6_ < _loc3_)
         {
            _loc5_.push(_loc4_[Math.floor(NumberUtil.randomNumber(0,_loc4_.length))]);
            _loc6_++;
         }
         setEnemy(_loc5_);
         Battle.setBattleBg(MovieClip(getLib("practice_bg")));
      }
      
      public static function gotoPanel() : void
      {
         mainMc.gotoPanel();
      }
      
      public static function addPanel(param1:MovieClip) : void
      {
         mainMc["panelHolder"].addChild(param1);
      }
      
      public static function getPanel() : MovieClip
      {
         if(checkGameStatus() == Timeline.PANEL)
         {
            if(mainMc["panelHolder"].numChildren > 0)
            {
               return mainMc["panelHolder"].getChildAt(0);
            }
            return null;
         }
         return null;
      }
      
      public static function removePanel(param1:MovieClip) : void
      {
         mainMc["panelHolder"].removeChild(param1);
      }
      
      public static function showPanel() : void
      {
         if(Battle.type == Battle.TYPE_NETWORK)
         {
            Battle.type = null;
            Panel.getInstance().reshow();
         }
         else
         {
            Panel.getInstance().onShowPanel();
         }
      }
      
      public static function showAchievement(param1:MouseEvent = null) : void
      {
         var _loc2_:MovieClip = null;
         if(mainMc["overlayHolder"])
         {
            GF.removeAllChild(mainMc["overlayHolder"]);
            _loc2_ = GF.getAsset(achievementPanel,"ninjasaga.linkage.panel.Achievement");
            mainMc["overlayHolder"].addChild(_loc2_);
            _loc2_.show();
         }
      }
      
      public static function removeOverlayPanel() : void
      {
         if(mainMc["overlayHolder"])
         {
            GF.removeAllChild(mainMc["overlayHolder"]);
         }
      }
      
      public static function showMinikPromotion(param1:MouseEvent = null) : void
      {
         var _loc2_:MovieClip = null;
         if(mainMc["overlayHolder"])
         {
            GF.removeAllChild(mainMc["overlayHolder"]);
            _loc2_ = GF.getAsset(mainMc,"ninjasaga.linkage.panel.MinikPromotion");
            mainMc["overlayHolder"].addChild(_loc2_);
            _loc2_.show();
         }
      }
      
      public static function onAdminMessage(param1:String) : void
      {
         Out.debug("","Rex: testing onAdminMessage");
         adminMessage = param1;
         mainMc["popupAdminMessage"].gotoAndPlay("show");
      }
      
      public static function loadPopupPanel(param1:String, param2:String, param3:Function = null) : void
      {
         Main.showAmfLoading();
         if(!Item.hasItem(param1))
         {
            Main.loadSwf(["swf/panels/" + param1 + ".swf"],showPopupPanel,{
               "swfName":param1,
               "clsName":param2,
               "cbFn":param3
            });
         }
         else
         {
            showPopupPanel(null,{
               "swfName":param1,
               "clsName":param2,
               "cbFn":param3
            });
         }
      }
      
      private static function showPopupPanel(param1:Object, param2:Object) : void
      {
         var _loc3_:Item = null;
         var _loc4_:MovieClip = null;
         Main.hideAmfLoading();
         if(param2 != null)
         {
            if(param1 != null)
            {
               if(!Item.hasItem(param2.swfName))
               {
                  _loc3_ = new Item(param2.swfName);
                  _loc3_.setSwf(param1["swf/panels/" + param2.swfName + ".swf"]);
                  Item.setItem(_loc3_);
               }
            }
            if(param2.cbFn == null)
            {
               if(mainMc["eventPopupHolder"])
               {
                  GF.removeAllChild(mainMc["eventPopupHolder"]);
                  _loc3_ = Item.getItem(param2.swfName);
                  _loc4_ = _loc3_.getAsset(param2.clsName);
                  mainMc["eventPopupHolder"].addChild(_loc4_);
                  _loc4_.show();
               }
            }
            else
            {
               Main.eventPopupPanel_CB = param2.cbFn;
               Main.eventPopupPanel_CB();
            }
         }
      }
      
      public static function removeEventPopupPanel() : void
      {
         if(mainMc["eventPopupHolder"])
         {
            GF.removeAllChild(mainMc["eventPopupHolder"]);
         }
      }
      
      public static function playCinematics(param1:MovieClip) : void
      {
         if(mainMc.currentLabel == Timeline.MC_PLAYER)
         {
            mainMc["mcHolder"].addChild(param1);
         }
         else
         {
            cinematicsMc = param1;
            mainMc.gotoMCPlayer();
         }
      }
      
      public static function removeMC() : void
      {
         GF.removeAllChild(mainMc["mcHolder"]);
      }
      
      public static function loadSwf(param1:Array, param2:Function, param3:Object = null, param4:String = null) : void
      {
         trace("loadSwf: " + param1);
         if(param1.length == 1)
         {
            if(param1[0].indexOf("/mission/") >= 0)
            {
               Mission.stateHash = getHash("loadSwf");
            }
         }
         mainMc["preloader"].loadSwf(param1,param2,param3,param4);
      }
      
      public static function loadSwfByVersion(param1:Array, param2:Function, param3:Object = null, param4:String = null) : void
      {
         mainMc["preloader"].loadSwfByVersion(param1,param2,param3,param4);
      }
      
      public static function dynamicLoad(param1:String, param2:Function) : void
      {
         mainMc["preloader"].dynamicLoad(param1,param2);
      }
      
      public static function loadBossSwf(param1:Array, param2:Function, param3:Object = null) : Boolean
      {
         var BossSwf:String = null;
         var i:int = 0;
         var eneNames:Array = param1;
         var cb:Function = param2;
         var cbParams:Object = param3;
         var returnValue:Boolean = false;
         var swfArr:Array = [];
         var params:Object = new Object();
         try
         {
            i = 0;
            while(i < eneNames.length)
            {
               if(!Item.hasItem(Central.main.ENEMY_DATA.find(eneNames[i]).swfName))
               {
                  swfArr.push("swf/enemies/" + Central.main.ENEMY_DATA.find(eneNames[i]).swfName + ".swf");
               }
               i++;
            }
            if(swfArr.length > 0)
            {
               params.eneNames = eneNames;
               params.cb = cb;
               params.cbParams = cbParams;
               Central.main.loadSwf(swfArr,Main.loadDisplayBossFinish,params);
            }
            else
            {
               returnValue = true;
            }
         }
         catch(err:Error)
         {
            Out.error("Main","Can not loadSwf :: " + err.message);
         }
         return returnValue;
      }
      
      public static function loadDisplayBossFinish(param1:Object, param2:Object) : void
      {
         var item:Item = null;
         var swfObj:Object = param1;
         var params:Object = param2;
         var i:int = 0;
         try
         {
            i = 0;
            while(i < params.eneNames.length)
            {
               if(!Item.hasItem(Central.main.ENEMY_DATA.find(params.eneNames[i]).swfName))
               {
                  item = new Item(Central.main.ENEMY_DATA.find(params.eneNames[i]).swfName);
                  item.setSwf(swfObj["swf/enemies/" + Central.main.ENEMY_DATA.find(params.eneNames[i]).swfName + ".swf"]);
                  Item.setItem(item);
               }
               i++;
            }
         }
         catch(err:Error)
         {
            Out.error("Main","Can not setItem :: " + err.message);
         }
         if(params.cbParams == null)
         {
            params.cb();
         }
         else
         {
            params.cb(params.cbParams);
         }
      }
      
      private static function startGame() : void
      {
         mapMenu.init();
         if(isNewChar)
         {
            Main.updateMenu();
            Mission.start();
         }
         else
         {
            mainMc.gotoMap();
         }
         if(isNewChar == true)
         {
            return;
         }
         achievement.checkSpecialAchievement(achievementData.NINJA_EMBLEM);
         achievement.checkSpecialAchievement(achievementData.SKILL_TRAINED);
         achievement.checkSpecialAchievement(achievementData.KINJUTSU_TRAINED);
         achievement.checkOfflineAchievement();
      }
      
      public static function startInit() : void
      {
         MISSION_DATA = dataLib.getMissionDetail();
         MISSION_DATA_AA = new AssociateArray(MISSION_DATA,"level",Array.NUMERIC);
         Features.setFeatureControl();
         Mission.clearMission();
         mainMc.gotoInit();
      }
      
      public static function selectChar() : void
      {
         mainMc.gotoSelchar();
      }
      
      public static function login(param1:Event = null) : void
      {
         mainMc.gotoLogin();
      }
      
      public static function checkGameStatus() : String
      {
         return mainMc.currentLabel;
      }
      
      public static function restoreMapMissionChar() : void
      {
         mainMc["mapMissionMc"].restoreMainChar();
      }
      
      public static function canVisit() : Boolean
      {
         return !(mainMc["preloader"].isLoading || Mission.curMissionID != null);
      }
      
      public static function dispatchGameEvent(param1:String) : Boolean
      {
         if(Mission.dispatchGameEvent(param1))
         {
            return true;
         }
         return false;
      }
      
      public static function get popup() : MovieClip
      {
         return mainMc.popupMc;
      }
      
      public static function showInfo(param1:String) : void
      {
         popup.showInfo(param1);
      }
      
      public static function showMissionComplete(param1:Object, param2:Boolean) : void
      {
         popup.showMissionComplete(param1,param2);
      }
      
      public static function showUpgradeAccount(param1:String, param2:String) : void
      {
         popup.showUpgradeAccount(param1,param2);
      }
      
      public static function showReportBugForm(param1:MouseEvent) : void
      {
         popup.showBugReportForm();
      }
      
      public static function showLevelUp(param1:Function = null) : void
      {
         popup.showLevelUp(param1);
      }
      
      public static function showTokenEmblemSelection(param1:uint, param2:String = null) : void
      {
         popup.showTokenEmblemSelection(param1,param2);
      }
      
      public static function showGetDailyTask() : void
      {
         mainMc["dailyTaskMc"].gotoGet();
      }
      
      public static function showDailyTask(param1:MouseEvent = null) : void
      {
         if(checkGameStatus() == Timeline.MAP)
         {
            mainMc["dailyTaskMc"].gotoShow();
         }
         else
         {
            showInfo(langLib.get(211));
         }
      }
      
      public static function getLib(param1:String) : *
      {
         var _loc2_:MovieClip = null;
         if(String(param1).indexOf("skill_") >= 0 || String(param1).indexOf("Skill_") >= 0)
         {
            param1 = String(param1).toLowerCase();
            _loc2_ = new MovieClip();
            Item.getSkillIcon(param1,_loc2_);
            return _loc2_;
         }
         return GF.getAsset(lib,param1);
      }
      
      public static function gotoPaymentGateway(param1:MouseEvent = null) : void
      {
         switch(AppData.type)
         {
            case AppData.FB:
               callJS("PopupPurchase");
               break;
            case AppData.OK:
               gotoURL(Data.PAYMENT_GATEWAY + Account.getAccountId() + "&lang=" + AppData.lang,"_blank");
               break;
            case AppData.MP:
               gotoURL(Data.PAYMENT_GATEWAY + Account.getAccountId() + "&lang=" + AppData.lang,"_blank");
               break;
            case AppData.RR:
               gotoURL(Data.PAYMENT_GATEWAY,"_blank");
               break;
            default:
               gotoURL(Data.PAYMENT_PHP,"_blank");
               showInfo("DEBUG: Displaying Payment Gateway...");
         }
      }
      
      public static function gotoTokenExGold(param1:MouseEvent = null) : void
      {
         Central.main.loadPopupPanel("popup_tokenbuygold","ninjasaga.linkage.TokenBuyGold");
      }
      
      public static function buyCrystal(param1:MouseEvent = null) : void
      {
         gotoURL(Data.EARN_TOKEN_URL,"_blank");
      }
      
      public static function gotoEmblemDetail(param1:MouseEvent = null) : void
      {
         gotoURL("http://www.ninjasaga.com/ninja-emblem/","_blank");
      }
      
      public static function gotoEarnTokenPage(param1:MouseEvent = null) : void
      {
         gotoURL("http://www.ninjasaga.com/earn-token/","_blank");
      }
      
      public static function gotoURL(param1:String, param2:String = "_self") : void
      {
         switch(param2)
         {
            case "_self":
               navigateToURL(new URLRequest(param1),"_top");
               break;
            case "_blank":
               navigateToURL(new URLRequest(param1),"_blank");
         }
      }
      
      public static function getAppFBFriends(param1:Function, param2:Boolean = false) : void
      {
         if(AppData.type != AppData.FB)
         {
            return;
         }
         SNS.getAppFriends(param1,param2);
      }
      
      public static function saveChallengeRecord(param1:uint, param2:uint) : void
      {
         var _loc3_:String = null;
         switch(param2)
         {
            case 0:
               _loc3_ = "win";
               break;
            case 1:
               _loc3_ = "lose";
               break;
            case 2:
               _loc3_ = "run";
               break;
            case 3:
               _loc3_ = "run";
               break;
            default:
               _loc3_ = "";
         }
         amfClient.service("FacebookService.saveChallengeRecord",[Account.getAccountSessionKey(),challengeFriendUID,param1,_loc3_],saveChallengeRecordResult);
      }
      
      private static function saveChallengeRecordResult(param1:Object) : void
      {
         if(!validateAmfResponse(param1))
         {
            onError(String(param1.error));
         }
      }
      
      public static function saveRecruitRecord(param1:String, param2:uint, param3:uint) : void
      {
         if(AppData.type == AppData.RR)
         {
            amfClient.service("SocialNetwork.saveRecruitRecord",[Account.getAccountSessionKey(),param1,param2,param3],saveRecruitRecordResult);
         }
         else
         {
            amfClient.service("FacebookService.saveRecruitRecord",[Account.getAccountSessionKey(),param1,param2,param3],saveRecruitRecordResult);
         }
      }
      
      private static function saveRecruitRecordResult(param1:Object) : void
      {
         if(!validateAmfResponse(param1))
         {
            onError(String(param1.error));
         }
      }
      
      public static function submitLogDump() : void
      {
         gameLockout = true;
         var _loc1_:uint = 0;
         if(Main.getMainChar())
         {
            if(Main.getMainChar().getDBChar())
            {
               _loc1_ = Main.getMainChar().getDBChar().character_id;
            }
         }
         amfClient.service("ReportService.reportLogDump",[Account.getAccountSessionKey(),_loc1_,Out.getLoggerDump(),Capabilities.version,Capabilities.playerType,Capabilities.os,Data.BUILD_NO],onSubmitLogDumpResult);
      }
      
      public static function submitData() : void
      {
         gameLockout = true;
         var _loc1_:uint = 0;
         if(Main.getMainChar())
         {
            if(Main.getMainChar().getDBChar())
            {
               _loc1_ = Main.getMainChar().getDBChar().character_id;
            }
         }
         amfClient.service("ReportService.submitData",[Account.getAccountSessionKey(),_loc1_,Out.dataLogger,Capabilities.version,Capabilities.playerType,Capabilities.os,Data.BUILD_NO],onSubmitLogDumpResult);
      }
      
      private static function onSubmitLogDumpResult(param1:Object) : void
      {
         Main.onError();
      }
      
      public static function provision() : void
      {
      }
      
      private static function onProvisionResult(param1:Object) : void
      {
         if(String(param1.status) == AMFData.STATUS_ERROR)
         {
            onError();
            return;
         }
         var _loc2_:Array = param1.result as Array;
         var _loc3_:int = (_loc2_[0] % 7 + 1) * (_loc2_[0] % 1024 + _loc2_[0] % 512 + _loc2_[0] % 11);
         if(_loc3_ != _loc2_[1])
         {
            Main.onError();
         }
         if(Account.getAccountTypeNoVerify() % 2 != _loc2_[0] % 2)
         {
            Main.onError();
         }
      }
      
      public static function saveLog(param1:uint, param2:String) : void
      {
         amfClient.service("ReportService.saveLog",[Account.getAccountSessionKey(),String(param1),param2],saveLogResult);
      }
      
      public static function saveLogResult(param1:Object) : void
      {
      }
      
      public static function selectServer(param1:uint) : void
      {
         selectedPvpServer = param1;
      }
      
      public static function connect() : void
      {
         Out.debug("Main","Hank 1.2.1.1 :: connect");
         if(socket.isConnected())
         {
            Out.debug("Main","Hank 1.2.1.2 :: is Connected");
            if(Central.main.PvpPlayerPlace == "PVE")
            {
               trace("Main connect :: Central.main.PvpPlayerPlace == PVE");
               Central.panel.getInstance().curPanel.play();
            }
            else
            {
               trace("Main connect :: Central.main.PvpPlayerPlace != PVE");
            }
         }
         else
         {
            Out.debug("Main","Hank 1.2.1.3 :: not Connected");
            socket.connect();
         }
         getMainChar().pvpSecurityCheck();
      }
      
      public static function gotReadyInfo(param1:uint) : void
      {
         if(param1 == getMainChar().getData(DBCharacterData.ID))
         {
            return;
         }
         if(checkGameStatus() == Timeline.BATTLE)
         {
            if(Battle.type == Battle.TYPE_NETWORK && (Central.main.PvpPlayerPost == "quick" || Central.main.PvpPlayerPost == "tournament"))
            {
               if(mainMc["battleMc"])
               {
                  if(mainMc["battleMc"].currentLabel == "pvp_win" || mainMc["battleMc"].currentLabel == "pvp_lose")
                  {
                     Battle.showRematch(param1);
                  }
               }
            }
         }
      }
      
      public static function loadDBChar(param1:uint) : void
      {
      }
      
      public static function loadDBCharForBattle(param1:uint) : void
      {
         showAmfLoading();
         amfClient.service("CharacterDAO.getPvpCharacter",[Account.getAccountSessionKey(),param1],onAmfGetCharacterForBattleResult);
      }
      
      private static function onAmfGetCharacterForBattleResult(param1:Object) : void
      {
         var _dbChar:DBCharacter;
         var petData:Object;
         var tempSkills:Array = null;
         var i:int = 0;
         var result:Object = param1;
         Out.debug("Main","onAmfGetCharacterForBattleResult , result " + GF.printObject(result));
         if(String(result.status) == AMFData.STATUS_ERROR)
         {
            onError(String(result.error));
            return;
         }
         _dbChar = dataParser.parseRawCharacter(result.result,true);
         Out.debug("","_dbChar " + _dbChar.character_id + " = " + GF.printObject(_dbChar));
         tempSkills = String(result.result.character_skill).split(",");
         i = 0;
         while(i < tempSkills.length)
         {
            try
            {
               if(SKILL_DATA[tempSkills[i]])
               {
                  if(int(SKILL_DATA[tempSkills[i]].special_class) > 0)
                  {
                     getMainChar().setClassSkillListArr(tempSkills[i]);
                  }
               }
            }
            catch(err:Error)
            {
               Out.error("onAmfGetCharacterForBattleResult : ","Do not have SKILL_DATA " + tempSkills[i]);
            }
            i++;
         }
         if(usermap.containsKey(_dbChar.character_id))
         {
            usermap.remove(_dbChar.character_id);
            usermap.insert(_dbChar.character_id,_dbChar);
         }
         else
         {
            usermap.insert(_dbChar.character_id,_dbChar);
         }
         Out.debug("","usermap = " + GF.printObject(usermap));
         petData = result.pet_data as Object;
         if(loadedPvpCharacter == 0)
         {
            resetOpponent();
         }
         Out.debug("","~~PvpPlayerPlace = " + PvpPlayerPlace);
         if(PvpPlayerPlace == "quick")
         {
            if(loadedPvpCharacter >= PvpQMMode * 2 - 1)
            {
               resetOpponent();
               loadedPvpCharacter = 0;
            }
         }
         else if(PvpPlayerPlace == "tournament")
         {
            Out.debug("","get character pvp result");
            if(loadedPvpCharacter >= PvpTournamentMode * 2 - 1)
            {
               resetOpponent();
               loadedPvpCharacter = 0;
            }
         }
         else if(PvpPlayerPlace == "private")
         {
            if(loadedPvpCharacter >= PvpPVMode * 2 - 1)
            {
               resetOpponent();
               loadedPvpCharacter = 0;
            }
         }
         else if(PvpPlayerPlace == "PVE")
         {
            if(loadedPvpCharacter >= PvpTeamA.length - 1)
            {
               resetOpponent();
               loadedPvpCharacter = 0;
            }
         }
         addOpponent(_dbChar,petData);
         getMainChar().restoreOriginalStatus();
         ++loadedPvpCharacter;
         trace("number tracker PvpQMMode = " + PvpQMMode + ", PvpTournamentMode = " + PvpTournamentMode);
         if(PvpPlayerPlace == "quick")
         {
            trace("load quick complete~~~");
            if(loadedPvpCharacter >= PvpQMMode * 2 - 1)
            {
               socket.loadDBCompleted();
            }
         }
         else if(PvpPlayerPlace == "tournament")
         {
            trace("load tournament complete~~~");
            if(loadedPvpCharacter >= PvpTournamentMode * 2 - 1)
            {
               socket.loadDBCompleted();
            }
         }
         else if(PvpPlayerPlace == "private")
         {
            if(loadedPvpCharacter >= PvpPVMode * 2 - 1)
            {
               socket.loadDBCompleted();
            }
         }
         else if(PvpPlayerPlace == "PVE")
         {
            if(loadedPvpCharacter >= PvpTeamA.length - 1)
            {
               socket.loadDBCompleted();
            }
         }
         else if(PvpPlayerPlace == "AI")
         {
         }
      }
      
      public static function getDBCharFromMap(param1:uint) : DBCharacter
      {
         if(usermap.containsKey(param1))
         {
            return usermap.find(param1);
         }
         return null;
      }
      
      public static function getCharNameFromMap(param1:uint) : String
      {
         if(usermap.containsKey(param1))
         {
            return usermap.find(param1).character_name;
         }
         return null;
      }
      
      public static function isDBCharExist(param1:*) : Boolean
      {
         return usermap.containsKey(param1);
      }
      
      public static function disconnect() : void
      {
         Central.main.socket.logout();
      }
      
      public static function verifyChatInput(param1:String) : String
      {
         var _loc2_:Number = new Date().time;
         param1 = StringUtil.trim(param1);
         if(param1.length == 0)
         {
            return "";
         }
         if(param1.length > Data.CHAT_INPUT_MAX_CHARACTERS)
         {
            showInfo(String(langLib.get(216)).replace("[valmaxchar]",String(Data.CHAT_INPUT_MAX_CHARACTERS)));
            return "";
         }
         if(chatInputTime)
         {
            if(_loc2_ < chatInputTime + Data.CHAT_INPUT_COOLDOWN * 1000)
            {
               showInfo(String(langLib.get(217)).replace("[valinputcooldown]",String(Data.CHAT_INPUT_COOLDOWN)));
               return "";
            }
         }
         if(chatInputArr.indexOf(param1.toLowerCase()) >= 0)
         {
            showInfo(langLib.get(218));
            return "";
         }
         chatInputTime = _loc2_;
         while(chatInputArr.length >= 3)
         {
            chatInputArr.shift();
         }
         chatInputArr.push(param1.toLowerCase());
         return param1;
      }
      
      public static function rankup() : void
      {
         amfClient.service("CharacterDAO.rankup",[Account.getAccountSessionKey()],rankupResult);
      }
      
      private static function rankupResult(param1:Object) : void
      {
         if(String(param1.status) == AMFData.STATUS_ERROR)
         {
            Out.error("Main","rankupResult :: error code " + String(param1.error));
            onError(String(param1.error));
            return;
         }
      }
      
      public static function get tracking() : TrackingSystem
      {
         return TrackingSystem.getInstance();
      }
      
      public static function get dataParser() : DataParser
      {
         return DataParser.getInstance();
      }
      
      public static function get achievement() : Achievement
      {
         return Achievement.getInstance();
      }
      
      public static function get amfClient() : AMFConnector
      {
         return AMFConnector.getInstance();
      }
      
      public static function onAmfResult(param1:Object) : void
      {
         if(validateAmfResponse(param1))
         {
            if(Central.main.checkGameStatus() == Timeline.BATTLE)
            {
               Battle.enableActionBarAllButtons();
            }
         }
         else
         {
            onError();
         }
      }
      
      public static function reportServiceResponse(param1:Object) : void
      {
         if(!validateAmfResponse(param1))
         {
            onError();
         }
      }
      
      public static function validateAmfResponse(param1:Object) : Boolean
      {
         var _loc3_:int = 0;
         if(param1 == null)
         {
            onError();
            return false;
         }
         if(param1.status == null)
         {
            onError();
            return false;
         }
         if(String(param1.status) == AMFData.STATUS_ERROR)
         {
            if(String(param1.error) == "1100")
            {
               if(param1.recover)
               {
                  _errorRecover = param1.recover;
                  _errorRecoverObj = {};
                  _errorRecoverObj.character_id = param1.character_id;
                  _errorRecoverObj.character_name = param1.character_name;
                  _errorRecoverObj.character_level = param1.character_level;
               }
               onError(String(param1.error),String(param1.error_message));
            }
            else
            {
               onError(String(param1.error));
            }
            return false;
         }
         if(String(param1.status) != AMFData.STATUS_SUCCESS)
         {
            onError(String(param1.error));
            return false;
         }
         var _loc2_:* = param1.update_inventory;
         if(_loc2_)
         {
            _loc3_ = int(Central.main.getMainChar().getLevel());
            if(Boolean(_loc2_.add_item_id) && _loc2_.add_item_id.length > 0)
            {
               trace("update_inventory.add_item_id = " + _loc2_.add_item_id);
               Toolkit.addInventoryByArray(_loc2_.add_item_id,_loc2_.add_pet_data ? _loc2_.add_pet_data : null);
               if(_loc2_.showPopup !== false)
               {
                  Central.main.showInfo(AppData.lang == AppData.ZH ? "獲得獎勵" : (AppData.lang == AppData.EN ? "Get Reward" : "Consigue Premio"));
                  mainMc["confirmationMc"].showGetReward(_loc2_.add_item_id);
               }
            }
            if(Boolean(_loc2_.remove_item_id) && _loc2_.remove_item_id.length > 0)
            {
               Toolkit.removeInventoryByArray(_loc2_.remove_item_id,_loc2_.remove_pet_data ? _loc2_.remove_pet_data : null);
            }
            if(_loc2_.xp !== undefined)
            {
               Central.main.getMainChar().setXp(_loc2_.xp,_loc2_.pet_xp);
            }
            if(Central.main.getMainChar().getLevel() > _loc3_)
            {
               Central.main.showLevelUp();
               Central.main.updateLvStatusBar();
               Central.main.initMapButtons();
            }
            if(_loc2_.gold !== undefined)
            {
               Central.main.getMainChar().setGold(_loc2_.gold);
            }
            if(_loc2_.token !== undefined)
            {
               Account.balance = _loc2_.token;
               Out.debug(null,"update_inventory.token" + _loc2_.token);
            }
            if(_loc2_.total_token !== undefined)
            {
               Central.main.extraData.totalToken = _loc2_.total_token;
               Out.debug(null,"update_inventory.totalToken" + _loc2_.total_token);
               Central.main.updateMenu();
            }
            if(_loc2_.MCoin !== undefined)
            {
               Central.main.extraData.MCoin = _loc2_.MCoin;
            }
            Central.main.updateMenu();
            if(_loc2_.totalMCoin !== undefined)
            {
               Central.main.extraData.totalMCoin = _loc2_.totalMCoin;
            }
            Central.main.updateMenu();
         }
         if(param1.reduce_xp_bonus_time)
         {
            --Central.main.extraData.emblem_xp_bonus_times;
         }
         return true;
      }
      
      public static function get formula() : Class
      {
         return Formula;
      }
      
      public static function get account() : *
      {
         return Account;
      }
      
      public static function get coreData() : Class
      {
         return CoreData;
      }
      
      public static function get achievementData() : *
      {
         return AchievementData;
      }
      
      public static function get errorData() : Class
      {
         return ErrorData;
      }
      
      public static function get asset() : Asset
      {
         return Asset.getInstance();
      }
      
      public static function get localCache() : LocalCache
      {
         return LocalCache.getInstance();
      }
      
      public static function get graphicController() : GraphicController
      {
         return GraphicController.getInstance();
      }
      
      public static function get showAds() : Boolean
      {
         return _showAds;
      }
      
      public static function set showAds(param1:Boolean) : void
      {
         if(getMainChar() == null)
         {
            _showAds = false;
         }
         if(getMainChar().getLevel() >= 6)
         {
            _showAds = param1;
         }
         else
         {
            _showAds = false;
         }
      }
      
      public static function set PvpPlayerPlace(param1:String) : void
      {
         _PvpPlayerPlace = param1;
      }
      
      public static function get PvpPlayerPlace() : String
      {
         return _PvpPlayerPlace;
      }
      
      public static function set PvpPlayerPost(param1:String) : void
      {
         _PvpPlayerPost = param1;
      }
      
      public static function get PvpPlayerPost() : String
      {
         return _PvpPlayerPost;
      }
      
      public static function set PvpBattleType(param1:String) : void
      {
         _PvpBattleType = param1;
      }
      
      public static function get PvpBattleType() : String
      {
         return _PvpBattleType;
      }
      
      public static function set pvpPlayerStatus(param1:String) : void
      {
         _pvpPlayerStatus = param1;
      }
      
      public static function get pvpPlayerStatus() : String
      {
         return _pvpPlayerStatus;
      }
      
      public static function visitFriend(param1:uint, param2:String) : void
      {
         if(canVisit() != true)
         {
            showInfo(Main.langLib.get(565));
            return;
         }
         if(checkGameStatus() == Timeline.BATTLE)
         {
            showInfo(Main.langLib.get(532));
            return;
         }
         if(Mission.onMission() != null)
         {
            showInfo(Main.langLib.get(532));
            return;
         }
         if(Panel.getInstance().curPanel)
         {
            Panel.getInstance().curPanel.hide();
         }
         Panel.getInstance().visitCharacterId = param1;
         Panel.getInstance().visitFacebookId = param2;
         if(Features.PANEL_VISIT_FRIEND_1)
         {
            Panel.getInstance().show("visit_friend");
         }
         else if(Features.PANEL_VISIT_FRIEND_2)
         {
            Panel.getInstance().show("visit_friend_2");
         }
         if(param1 != Main.getMainChar().getCharacterId())
         {
            Main.achievement.updateCharStat(Main.achievementData.FRIEND_VISITED,1);
         }
      }
      
      public static function showInviteFriend() : void
      {
         switch(AppData.type)
         {
            case AppData.YM:
            case AppData.FB:
            case AppData.RR:
               callJS("showInviteDialog");
         }
      }
      
      public static function fileCheck(param1:Array) : void
      {
         var _loc4_:String = null;
         var _loc5_:int = 0;
         if(param1 != null || param1.length > 0)
         {
            if(param1[0][0].indexOf("file://") >= 0)
            {
               return;
            }
         }
         if(Central.main.proc == null)
         {
            return;
         }
         if(Central.main.proc.clientLib == null)
         {
            return;
         }
         if(Account.getAccountSessionKey() == null)
         {
            return;
         }
         if(param1[0][0].indexOf("/panels/") >= 0)
         {
            checkPanelFile(param1);
         }
         var _loc2_:Boolean = false;
         var _loc3_:int = 0;
         while(_loc3_ < param1.length)
         {
            if(param1[0][0].indexOf("/panels/") >= 0 || param1[0][0].indexOf("/mission/") >= 0 || param1[0][0].indexOf("/enemies/") >= 0)
            {
               _loc2_ = true;
               break;
            }
            _loc3_++;
         }
         if(_loc2_)
         {
            _loc4_ = "";
            _loc5_ = 0;
            while(_loc5_ < param1.length)
            {
               _loc4_ += param1[1];
               _loc5_++;
            }
            _loc4_ = Central.main.getHash(_loc4_);
            Central.main.showAmfLoading();
            Central.main.amfClient.service("FileChecking.checkHackActivity",[Central.main.account.getAccountSessionKey(),param1,_loc4_],Central.main.getFileCheckResponse);
         }
      }
      
      private static function checkPanelFile(param1:Array) : void
      {
         var _loc2_:Array = null;
         var _loc3_:Array = null;
         var _loc4_:String = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:Array = null;
         if(param1[0][0].indexOf("file://") < 0 && testBuild.indexOf(Data.BUILD_NO) < 0)
         {
            _loc2_ = [];
            _loc3_ = [];
            switch(Central.main.mapKey)
            {
               case 1:
                  _loc2_ = Central.main.file_1;
                  break;
               case 2:
                  _loc2_ = Central.main.file_2;
                  break;
               case 3:
                  _loc2_ = Central.main.file_3;
                  break;
               default:
                  Main.onError("30202");
            }
            switch(Central.main.mapValue)
            {
               case 1:
                  _loc3_ = Central.main.sum_1;
                  break;
               case 2:
                  _loc3_ = Central.main.sum_2;
                  break;
               case 3:
                  _loc3_ = Central.main.sum_3;
                  break;
               default:
                  Main.onError("30203");
            }
            _loc4_ = String(param1[0][0]).split("/").pop();
            _loc5_ = _loc2_.indexOf(_loc4_);
            _loc6_ = int(param1[1]);
            if(_loc5_ < 0)
            {
               Central.main.file_1.push(_loc4_);
               Central.main.file_2.push(_loc4_);
               Central.main.file_3.push(_loc4_);
               _loc7_ = [_loc6_];
               Central.main.sum_1.push(_loc7_);
               Central.main.sum_2.push(_loc7_);
               Central.main.sum_3.push(_loc7_);
            }
            else if(_loc3_[_loc5_].indexOf(_loc6_) < 0)
            {
               Main.onError("30204");
            }
         }
      }
      
      private static function getFileCheckResponse(param1:Object) : void
      {
         if(Central.main.validateAmfResponse(param1))
         {
            Central.main.hideAmfLoading();
         }
      }
      
      public static function dataFilter(param1:Object) : Boolean
      {
         if(testBuild.indexOf(Data.BUILD_NO) >= 0)
         {
            return true;
         }
         if(param1 == null)
         {
            return true;
         }
         if(param1.development == null)
         {
            return true;
         }
         if(param1.development == 0)
         {
            return true;
         }
         Main.onError("106");
         return false;
      }
      
      public static function callJS(param1:String, ... rest) : void
      {
         if(!ExternalInterface.available)
         {
            return;
         }
         ExternalInterface.call(param1,rest);
         var _loc3_:Array = ["publishFeed","showFeed","feedDailyTask","showRankupFeed"];
         if(_loc3_.indexOf(param1) >= 0)
         {
            achievement.updateCharStat(achievementData.WALLFEED_POSTED);
         }
      }
      
      public static function addJSCallBack() : void
      {
         if(!ExternalInterface.available)
         {
            return;
         }
         ExternalInterface.addCallback("getNewsfeedReward",getNewsfeedReward);
         ExternalInterface.addCallback("closeNewsfeed",closeNewsfeed);
         ExternalInterface.addCallback("requestPermissionCallback",requestPermissionCallback);
         ExternalInterface.addCallback("checkWhatPermissionCallback",checkWhatPermissionCallback);
         try
         {
            Security.allowDomain("app.ninjasaga.com");
            ExternalInterface.addCallback("domainResponse",Main.domainResponse);
         }
         catch(err:Error)
         {
         }
      }
      
      public static function requestPermissionCallback(param1:String, param2:Boolean) : void
      {
         if(!param2)
         {
            return;
         }
         getAppFBFriends(gotAppFriends,true);
      }
      
      public static function checkWhatPermissionCallback(param1:Array) : void
      {
         var _loc2_:Boolean = false;
         if(param1.indexOf("user_friends") >= 0)
         {
            _loc2_ = true;
            if(_loc2_ != Central.main.facebookPermissionUserFriends)
            {
               notifyFriendPermissionObserverList(_loc2_);
               Central.main.facebookPermissionUserFriends = _loc2_;
            }
         }
      }
      
      public static function gotAppFriends(param1:Array) : void
      {
         notifyFriendListObserverList(param1);
         Central.main.callJS("checkWhatPermissions");
      }
      
      public static function domainResponse(param1:Boolean) : void
      {
         trace("domainResponse1 is " + param1);
         if(param1 == false)
         {
            Security.allowDomain("app.ninjasaga.net");
            ExternalInterface.addCallback("domainResponse",Main.domainResponse2);
         }
         else
         {
            Central.main.validLogin = param1;
         }
      }
      
      public static function domainResponse2(param1:Boolean) : void
      {
         trace("domainResponse2 is " + param1);
         Central.main.validLogin = param1;
      }
      
      public static function getNewsfeedReward(param1:int) : void
      {
         Central.main.getMainChar().updateGold(param1);
         Central.main.updateMenu();
         Main.amfClient.service("CharacterService.getNewsfeedReward",[Central.main.account.getAccountSessionKey(),Central.main.getMainChar().getData(DBCharacterData.ID),param1],getNewsfeedRewardResponse);
      }
      
      public static function getNewsfeedRewardResponse(param1:Object) : void
      {
         if(String(param1.status) == AMFData.STATUS_ERROR)
         {
            Central.main.onError(String(param1.error));
            return;
         }
         Central.main.proc.hideNewsfeedRewardPopup();
      }
      
      public static function closeNewsfeed() : void
      {
         Central.main.proc.hideNewsfeedRewardPopup();
      }
      
      public static function getTitle(param1:String) : String
      {
         return langLib.titleTxt(param1);
      }
      
      public static function initButton(param1:*, param2:Function, param3:String = null) : void
      {
         var _loc4_:String = null;
         if(param1 == null)
         {
            Out.error("Main","initButton :: btn is null :: txt " + param3);
            return;
         }
         if(param2 == null)
         {
            Out.error("Main","initButton :: fn is null :: txt " + param3);
            return;
         }
         param1.stop();
         param1.gotoAndStop(1);
         if(param1["clickMask"])
         {
            param1["clickMask"].buttonMode = true;
         }
         else
         {
            Out.error("Main","initButton :: clickMask is not found :: txt " + param3);
         }
         param1.addEventListener(MouseEvent.CLICK,param2);
         param1.addEventListener(MouseEvent.MOUSE_OUT,mouseOutFn);
         param1.addEventListener(MouseEvent.MOUSE_OVER,mouseOverFn);
         if(param3 != null)
         {
            _loc4_ = langLib.btnTxt(param3);
            if(_loc4_ != null)
            {
               param1["txt"].text = _loc4_;
            }
            else
            {
               param1["txt"].text = param3;
            }
         }
      }
      
      public static function disableButton(param1:*, param2:Function, param3:String = null) : void
      {
         var _loc4_:String = null;
         if(param1 == null)
         {
            Out.error("Main","disableButton :: btn is null :: txt " + param3);
            return;
         }
         if(param2 == null)
         {
            Out.error("Main","disableButton :: fn is null :: txt " + param3);
            return;
         }
         param1.stop();
         param1.gotoAndStop(1);
         if(param1["clickMask"])
         {
            param1["clickMask"].buttonMode = false;
         }
         else
         {
            Out.error("Main","disableButton :: clickMask is not found :: txt " + param3);
         }
         param1.removeEventListener(MouseEvent.CLICK,param2);
         param1.removeEventListener(MouseEvent.MOUSE_OUT,mouseOutFn);
         param1.removeEventListener(MouseEvent.MOUSE_OVER,mouseOverFn);
         if(param3 != null)
         {
            _loc4_ = Central.main.langLib.btnTxt(param3);
            if(_loc4_ != null)
            {
               param1["txt"].text = _loc4_;
            }
            else
            {
               param1["txt"].text = param3;
            }
         }
      }
      
      public static function mouseOutFn(param1:MouseEvent) : void
      {
         param1.currentTarget.gotoAndStop(1);
      }
      
      public static function mouseOverFn(param1:MouseEvent) : void
      {
         param1.currentTarget.gotoAndStop(2);
      }
      
      public static function calcSkillDamage(param1:*, param2:Object) : uint
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:Object = null;
         var _loc6_:Number = NaN;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         _loc4_ = int(param2.damage);
         _loc5_ = param1.getBattleBuff();
         switch(param2.type)
         {
            case "fire":
               _loc3_ = int(param1.getData(DBCharacterData.FIRE));
               break;
            case "wind":
               _loc3_ = int(param1.getData(DBCharacterData.WIND));
               break;
            case "water":
               _loc3_ = int(param1.getData(DBCharacterData.WATER));
               break;
            case "lightning":
               _loc3_ = int(param1.getData(DBCharacterData.LIGHTNING));
               break;
            case "earth":
               _loc3_ = int(param1.getData(DBCharacterData.EARTH));
               break;
            default:
               _loc3_ = 0;
         }
         _loc6_ = _loc4_ * (_loc3_ / coreData.SKILL_TYPE_BONUS);
         _loc7_ = Math.round(_loc4_ * (int(param1.getData(DBCharacterData.FIRE)) * 4 / 1000));
         _loc8_ = 0;
         if(_loc5_[BattleData.EFFECT_COMBUSTION])
         {
            if(_loc5_[BattleData.EFFECT_COMBUSTION].duration > 0)
            {
               _loc8_ = Math.round(_loc4_ * 0.3);
            }
         }
         _loc4_ += Math.round(_loc6_) + _loc7_ + _loc8_;
         return Formula.randomizeValue(_loc4_);
      }
      
      public static function shiftBtnPos(param1:MovieClip, param2:Array, param3:String, param4:Number = 0, param5:Object = null) : void
      {
         var _loc6_:int = 0;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:int = 0;
         if(param1 == null)
         {
            return;
         }
         if(param2 == null)
         {
            return;
         }
         if(param2.length <= 0)
         {
            return;
         }
         _loc6_ = 0;
         var _loc7_:int = 0;
         _loc8_ = 0;
         _loc9_ = 0;
         if(param5)
         {
            if(param5.startPoint)
            {
               _loc8_ = Number(param5.startPoint);
            }
         }
         else
         {
            switch(param3)
            {
               case SHIFT_X_RIGHT:
                  _loc8_ = Number(param1[param2[0]].x);
                  break;
               case SHIFT_X_LEFT:
                  _loc8_ = Number(param1[param2[param2.length - 1]].x);
                  break;
               case SHIFT_Y_DOWN:
                  _loc8_ = Number(param1[param2[0]].y);
                  break;
               case SHIFT_Y_UP:
                  _loc8_ = Number(param1[param2[param2.length - 1]].y);
                  break;
               case SHIFT_X_RIGHT_TO_LEFT:
                  _loc8_ = Number(param1[param2[param2.length - 1]].x);
            }
         }
         _loc9_ = _loc8_;
         switch(param3)
         {
            case SHIFT_X_RIGHT:
               _loc6_ = 0;
               while(_loc6_ < param2.length)
               {
                  _loc9_ += param1[param2[_loc6_]].width * _loc6_ + _loc6_ * param4;
                  param1[param2[_loc6_]].x = _loc9_;
                  _loc9_ = _loc8_;
                  _loc6_++;
               }
               break;
            case SHIFT_X_LEFT:
               _loc6_ = 0;
               while(_loc6_ < param2.length)
               {
                  _loc9_ -= param1[param2[_loc6_]].width * (param2.length - 1 - _loc6_) - _loc6_ * param4;
                  param1[param2[_loc6_]].x = _loc9_;
                  _loc9_ = _loc8_;
                  _loc6_++;
               }
               break;
            case SHIFT_Y_DOWN:
               _loc6_ = 0;
               while(_loc6_ < param2.length)
               {
                  _loc9_ += param1[param2[_loc6_]].height * _loc6_ + _loc6_ * param4;
                  param1[param2[_loc6_]].y = _loc9_;
                  _loc9_ = _loc8_;
                  _loc6_++;
               }
               break;
            case SHIFT_Y_UP:
               _loc6_ = 0;
               while(_loc6_ < param2.length)
               {
                  _loc9_ -= param1[param2[_loc6_]].height * (param2.length - 1 - _loc6_) - _loc6_ * param4;
                  param1[param2[_loc6_]].y = _loc9_;
                  _loc9_ = _loc8_;
                  _loc6_++;
               }
               break;
            case SHIFT_X_RIGHT_TO_LEFT:
               _loc10_ = 49;
               _loc6_ = 0;
               while(_loc6_ < param2.length)
               {
                  _loc9_ -= _loc10_ * _loc6_ + _loc6_ * param4;
                  param1[param2[param2.length - 1 - _loc6_]].x = _loc9_;
                  _loc9_ = _loc8_;
                  _loc6_++;
               }
         }
      }
      
      public static function getInstance() : MainProcess
      {
         return proc;
      }
      
      public static function itemPrototype(param1:String) : String
      {
         var _loc2_:Array = null;
         _loc2_ = param1.split("_");
         if(_loc2_ == null)
         {
            Out.error("itemPrototype","parameter type not match");
            return null;
         }
         switch(_loc2_[0])
         {
            case "pet":
            case "petxp":
            case "xp":
            case "gold":
               return _loc2_[1];
            case "skill":
            case "back":
            case "item":
            case "material":
            case "wpn":
            case "set":
            case "hair":
               return _loc2_[0] + _loc2_[1];
            default:
               return _loc2_[0] + _loc2_[1];
         }
      }
      
      public static function addCurrency(param1:String) : void
      {
         var _loc2_:* = undefined;
         var _loc3_:int = 0;
         var _loc4_:String = null;
         switch(param1)
         {
            case "item750":
               ++Main.christmasCoin;
               break;
            case "item772":
               ++Main.christmasCoin;
               break;
            case "item773":
               ++Main.easterCoin;
            default:
               _loc4_ = param1.replace("item","");
               _loc2_ = 0;
               while(_loc2_ < 5)
               {
                  _loc3_ = 0;
                  while(_loc3_ < 7)
                  {
                     if(_loc4_ == Main.dragonBallList[_loc2_][_loc3_].id)
                     {
                        ++Main.dragonBallList[_loc2_][_loc3_].amount;
                        break;
                     }
                     _loc3_++;
                  }
                  _loc2_++;
               }
         }
      }
      
      public static function reduceCurrency(param1:String) : void
      {
         switch(param1)
         {
            case "item750":
               --Main.christmasCoin;
               if(Main.christmasCoin < 0)
               {
                  Main.christmasCoin = 0;
                  Out.error("reduceCurrency","christmas coin can\'t be less than zero");
               }
               break;
            case "item772":
               --Main.christmasCoin;
               if(Main.christmasCoin < 0)
               {
                  Main.christmasCoin = 0;
                  Out.error("reduceCurrency","christmas coin can\'t be less than zero");
               }
               break;
            case "item773":
               --Main.easterCoin;
               if(Main.easterCoin < 0)
               {
                  Main.easterCoin = 0;
                  Out.error("reduceCurrency","christmas coin can\'t be less than zero");
               }
         }
      }
      
      public static function recruitFriendPrice(param1:int) : Object
      {
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         var _loc4_:String = null;
         var _loc5_:int = 0;
         _loc2_ = Main.getMainChar().getLevel();
         _loc3_ = Math.abs(param1 - _loc2_);
         if(param1 <= _loc2_)
         {
            _loc4_ = Main.PAY_GOLD;
            _loc5_ = Math.ceil(1 / (1 + _loc3_) * 5 * Math.pow(_loc2_,1.68363));
         }
         else
         {
            _loc4_ = Main.PAY_TOKEN;
            _loc5_ = Math.ceil(_loc3_ * Math.sqrt(param1) / 4);
         }
         return {
            "payType":_loc4_,
            "recruitPrice":_loc5_
         };
      }
      
      public static function checkHackTimerListener(param1:TimerEvent) : void
      {
         if(AntiMemoryHack.check() == false)
         {
            onError("305","");
            param1.target.stop();
            param1.target.removeEventListener(TimerEvent.TIMER,checkHackTimerListener);
         }
      }
      
      public static function playMusic(param1:String) : void
      {
         var _loc2_:Array = null;
         var _loc3_:Sound = null;
         _loc2_ = [];
         _loc3_ = Sound(Main.getLib(param1));
         _loc2_.push(_loc3_);
         Central.main.mixer.playMusic(_loc2_);
      }
      
      public static function updateMusic() : void
      {
         if(currentMusicIndex < MUSIC_PLAY_LIST.length && currentMusicIndex >= 0)
         {
            playMusic(MUSIC_PLAY_LIST[currentMusicIndex]);
         }
      }
      
      public static function setAllSoundEffectVolume(param1:Number) : void
      {
         var _loc2_:SoundTransform = null;
         _loc2_ = SoundMixer.soundTransform;
         _loc2_.volume = param1;
         SoundMixer.soundTransform = _loc2_;
      }
      
      public static function getMusicLength(param1:String) : Number
      {
         var _loc2_:Sound = null;
         _loc2_ = Sound(Main.getLib(param1));
         return _loc2_.length;
      }
      
      public static function stopMusic() : void
      {
         Central.main.mixer.stopMusic();
      }
      
      public static function showUpgradePet(param1:String) : void
      {
         mapMenu.preSelectClsName = param1;
         mapMenu.gotoAndStop(Timeline.PET);
      }
      
      public static function confirmPlayerReadRegAccNotice() : void
      {
         Central.main.amfClient.service("CharacterDAO.AccRegTutNoticeRead",[Account.getAccountSessionKey()],new Function());
      }
      
      public static function getPetMaturity(param1:uint) : int
      {
         var _loc2_:* = undefined;
         _loc2_ = Central.main.getMainChar().getPetById(param1);
         return _loc2_.maturity;
      }
      
      public static function logHuntingMission(param1:Boolean, param2:Boolean = false) : void
      {
         var charLevel:int = 0;
         var enemyDataLog:Array = null;
         var battleEnemyArr:Array = null;
         var enemy:Enemy = null;
         var enemyDataStr:String = null;
         var tmpEnemyData:Object = null;
         var rand:int = 0;
         var functionName:String = null;
         var hash:String = null;
         var level:int = 0;
         var enemyId:int = 0;
         var randWinLossDigitBefore:Boolean = false;
         var isStart:Boolean = param1;
         var winLoss:Boolean = param2;
         if(Central.battle.subType != BattleData.SUBTYPE_BOSS)
         {
            return;
         }
         charLevel = int(Central.main.getMainChar().getData(DBCharacterData.LEVEL));
         if(charLevel < 5 || charLevel > 10)
         {
            return;
         }
         enemyDataLog = new Array();
         battleEnemyArr = Central.battle.getEnemyArr();
         for each(enemy in battleEnemyArr)
         {
            level = enemy.getData(DBCharacterData.LEVEL);
            enemyId = parseInt(String(enemy.public::enemyObj.id).replace("enemy",""));
            enemyDataLog.push([enemyId,level]);
            Out.debug("Main","enemyId=" + enemyId + ", level=" + level);
         }
         enemyDataStr = "";
         for each(tmpEnemyData in enemyDataLog)
         {
            enemyDataStr += tmpEnemyData[0];
            enemyDataStr += tmpEnemyData[1];
         }
         rand = int(Math.random() * (int.MAX_VALUE - 2));
         functionName = "CharacterDAO.startHunting";
         if(!isStart)
         {
            functionName = "CharacterDAO.finishHunting";
         }
         if(!isStart)
         {
            randWinLossDigitBefore = rand % 9 % 2 == 1;
            if(randWinLossDigitBefore != winLoss)
            {
               rand++;
               randWinLossDigitBefore = rand % 9 % 2 == 1;
               if(randWinLossDigitBefore != winLoss)
               {
                  rand++;
               }
            }
         }
         hash = Central.main.getHash(enemyDataStr + rand);
         Central.main.amfClient.service(functionName,[Account.getAccountSessionKey(),enemyDataLog,rand,hash],function(param1:Object):*
         {
            if(Central.main.validateAmfResponse(param1))
            {
               return;
            }
         });
      }
      
      public static function eneSeqLength() : int
      {
         return _enemyRobotSeq.length;
      }
      
      public static function setEnemyRobotSeq(param1:String) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         _loc2_ = parseInt(param1.substr(0,3));
         param1 = param1.substr(3 + 10,param1.length - (3 + 10));
         _enemyRobotSeq = [];
         _loc3_ = _loc2_ % 33;
         while(_loc3_ < param1.length)
         {
            switch(parseInt(param1.charAt(_loc3_)))
            {
               case 0:
               case 7:
                  _enemyRobotSeq.push(Number(2));
                  break;
               case 1:
               case 8:
                  _enemyRobotSeq.push(Number(1));
                  break;
               case 2:
               case 9:
                  _enemyRobotSeq.push(Number(0));
            }
            _loc3_++;
         }
      }
      
      public static function getEnemyRobotSeq(param1:int) : int
      {
         return _enemyRobotSeq[param1 % _enemyRobotSeq.length];
      }
      
      public static function getEnemyRobotSeqHash() : String
      {
         var _loc1_:String = null;
         _loc1_ = _enemyRobotSeq.join("");
         return Central.main.getHash(_loc1_ + "RCGHRjWphyFOmOJGGW4B8TUt");
      }
      
      public static function clearCharSeq() : void
      {
         _charSeq = [];
      }
      
      public static function setCharSeq(param1:String) : void
      {
         _charSeq.push(param1);
      }
      
      public static function getCharSeq() : Array
      {
         return _charSeq;
      }
      
      public static function getCharSeqStr() : String
      {
         var _loc1_:int = 0;
         _charSeqStr = "";
         _loc1_ = 0;
         while(_loc1_ < _charSeq.length)
         {
            _charSeqStr += String(_charSeq[_loc1_]);
            _loc1_++;
         }
         return _charSeqStr;
      }
      
      public static function isDoubleXP() : int
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         _loc1_ = getTimer() / 1000 - Central.main.timeGetExtraData;
         _loc2_ = 0;
         while(_loc2_ < Central.main.doubleXPArr.length)
         {
            if(_loc1_ >= Central.main.doubleXPArr[_loc2_].start && _loc1_ < Central.main.doubleXPArr[_loc2_].end)
            {
               return Central.main.doubleXPArr[_loc2_].end - _loc1_;
            }
            if(_loc1_ < Central.main.doubleXPArr[_loc2_].start && _loc1_ < Central.main.doubleXPArr[_loc2_].end)
            {
               return _loc1_ - Central.main.doubleXPArr[_loc2_].start;
            }
            _loc2_++;
         }
         return 0;
      }
      
      public static function addFriendListObserver(param1:Object) : void
      {
         var _loc2_:String = null;
         if(!param1)
         {
            Out.error("Main::addFriendListObserver","Object null");
            return;
         }
         _loc2_ = "notifyFriendListUpdate";
         if(!(_loc2_ in param1))
         {
            Out.error("Main::addFriendListObserver","notifyMethodName not founnd in object:" + param1.name);
            return;
         }
         if(friendListObserverList.indexOf(param1) >= 0)
         {
            Out.error("Main::addFriendListObserver","Object has already been added to the observer list:" + param1.name);
            return;
         }
         Central.main.friendListObserverList.push(param1);
      }
      
      private static function notifyFriendListObserverList(param1:Array) : void
      {
         var _loc2_:Object = null;
         for each(_loc2_ in friendListObserverList)
         {
            _loc2_.notifyFriendListUpdate(param1);
         }
      }
      
      public static function addFriendPermissionObserver(param1:Object) : void
      {
         var _loc2_:String = null;
         if(!param1)
         {
            Out.error("Main::addFriendListObserver","Object null");
            return;
         }
         _loc2_ = "notifyFriendPermissionUpdate";
         if(!(_loc2_ in param1))
         {
            Out.error("Main::addFriendListObserver","notifyMethodName not founnd in object:" + param1.name);
            return;
         }
         if(Central.main.friendPermissionObserverList.indexOf(param1) >= 0)
         {
            Out.error("Main::addFriendListObserver","Object has already been added to the observer list:" + param1.name);
            return;
         }
         Central.main.friendPermissionObserverList.push(param1);
      }
      
      private static function notifyFriendPermissionObserverList(param1:Boolean) : void
      {
         var _loc2_:Object = null;
         for each(_loc2_ in friendPermissionObserverList)
         {
            _loc2_.notifyFriendPermissionUpdate(param1);
         }
      }
      
      public static function fetchAdjustedWeaponDamage(param1:Object, param2:Object = null) : *
      {
         var _loc3_:CharacterBase = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         if(param1 == null)
         {
            throw new Error("Main::fetchAdjustedWeaponDamage, lib_obj should not be null.");
         }
         switch(param1.id)
         {
            case "wpn1596":
               if(param2 == null)
               {
                  return param1.damage;
               }
               if(param2.character == undefined || param2.character == null)
               {
                  return param1.damage;
               }
               if(param2.stoneCounter == undefined || param2.stoneCounter == null)
               {
                  return param1.damage;
               }
               _loc3_ = param2.character;
               _loc4_ = _loc3_.getData(DBCharacterData.LEVEL);
               _loc5_ = int(param2.stoneCounter);
               return param1.damage + _loc5_ * 75 + _loc4_;
               break;
            default:
               return param1.damage;
         }
      }
      
      public static function formatNum(param1:Number) : String
      {
         var _loc2_:String = null;
         var _loc3_:String = null;
         var _loc4_:Array = null;
         var _loc5_:String = null;
         var _loc6_:* = 0;
         var _loc7_:String = null;
         _loc2_ = "";
         _loc3_ = param1.toString();
         _loc4_ = _loc3_.split(".");
         _loc3_ = _loc4_[0];
         _loc5_ = _loc4_[1] ? "." + _loc4_[1] : "";
         _loc6_ = _loc3_.length;
         while(_loc6_-- > 0)
         {
            _loc7_ = _loc3_.charAt(_loc6_);
            if((_loc3_.length - _loc6_) % 3 == 0)
            {
               _loc2_ = "," + _loc7_ + _loc2_;
            }
            else
            {
               _loc2_ = _loc7_ + _loc2_;
            }
         }
         return _loc2_ + _loc5_;
      }
   }
}

import bitemycode.loader.DynamicLoader;
import bitemycode.security.Obfuscated;
import com.utils.Out;
import flash.display.MovieClip;
import flash.events.MouseEvent;
import flash.events.TimerEvent;
import flash.utils.Timer;
import ninjasaga.Central;
import ninjasaga.Main;
import ninjasaga.Mission;
import ninjasaga.Panel;
import ninjasaga.data.AppData;
import ninjasaga.data.DBCharacterData;
import ninjasaga.data.DailyLoginEventData;
import ninjasaga.data.Data;
import ninjasaga.data.RankData;
import ninjasaga.data.SNSData;
import ninjasaga.data.Timeline;

class MainProcess
{
   
   private var mainMc:MovieClip;
   
   private var onGameStart:Boolean = true;
   
   public var isShowRoulette:Boolean = false;
   
   public var rouletteShown:Boolean = true;
   
   public var newMail:Boolean = false;
   
   public var hasShownPopup:Boolean = false;
   
   private var DailyLoginResponse:Object;
   
   private var isShowDailyLuckyDraw:Boolean = true;
   
   private var isShowDailyScratch:Boolean = true;
   
   private var isShowPVPTimetable:Boolean = false;
   
   private var pvpTimeList:Array = [];
   
   private var isShowAnni3EventPage:Boolean = true;
   
   private var isShowPromote:Boolean = true;
   
   private var isShowRequestBox:Boolean = true;
   
   private var WCInGameClaimReward:Boolean = true;
   
   private var isShowNewYearClothing2015:Boolean = true;
   
   public var fbInviteRecord:Object;
   
   public var clientLib:MovieClip;
   
   public var specialAds:Array;
   
   private var stateMachine:Timer;
   
   private var gameTick:int = 0;
   
   private var stateArr:Array = [];
   
   private var stateRemovalArray:* = [];
   
   public var updateClanTimer:Function;
   
   public var updateEnergyTimer:Function;
   
   private var checkHackTimer:Timer = null;
   
   public function MainProcess(param1:MovieClip)
   {
      super();
      this.mainMc = param1;
      this.initConstant();
      this.initStateMachine();
   }
   
   private function initConstant() : void
   {
      Main.coreData.obfus = new Obfuscated();
      Main.coreData.obfus.ZERO_NUMBER = this.minus(59.23,59.23);
      Main.coreData.obfus.BASE_CRITICAL_CHANCE = this.multiply(0.025,2);
      Main.coreData.obfus.BASE_DODGE_CHANCE = this.multiply(0.025,2);
      Main.coreData.obfus.BASE_CRITICAL_MULTIPLIER = this.multiply(0.5,3);
      Main.coreData.obfus.DAMAGE_LIMIT = this.multiply(2500,4);
      Main.coreData.obfus.SKILL_TYPE_BONUS = this.multiply(20.001,5.001);
   }
   
   private function multiply(param1:Number, param2:Number) : Number
   {
      return param1 * param2;
   }
   
   private function minus(param1:Number, param2:Number) : Number
   {
      return param1 - param2;
   }
   
   private function initStateMachine() : void
   {
      this.stateMachine = new Timer(1000 / 2);
      this.stateMachine.addEventListener(TimerEvent.TIMER,this.updateStateMachine);
      this.stateMachine.start();
   }
   
   private function updateStateMachine(param1:TimerEvent) : void
   {
      var i:uint = 0;
      var constructedStateArr:Array = null;
      var evt:Object = null;
      var tmEvt:TimerEvent = param1;
      ++this.gameTick;
      if(this.gameTick >= 2 * 60 * 10)
      {
         this.gameTick = 0;
      }
      constructedStateArr = [];
      i = 0;
      while(i < this.stateArr.length)
      {
         evt = this.stateArr[i];
         if(this.gameTick % evt.tick == 0)
         {
            Out.debug(this,"stateMachine :: calling >> " + evt.refName);
            try
            {
               evt.fn();
               if(evt.once == false)
               {
                  constructedStateArr.push(evt);
               }
            }
            catch(err:Error)
            {
               Out.error(this,"updateStateMachine :: err >> " + err);
            }
         }
         else
         {
            constructedStateArr.push(evt);
         }
         i++;
      }
      this.stateArr = constructedStateArr;
      if(this.gameTick % (15 * 2) == 0)
      {
         if(this.updateClanTimer != null)
         {
            this.updateClanTimer();
         }
      }
   }
   
   public function addState(param1:Function, param2:int = 0, param3:Boolean = false, param4:String = null) : void
   {
      var _loc5_:uint = 0;
      var _loc6_:Object = null;
      var _loc7_:Object = null;
      Out.debug(this,"addState :: tick >> " + param2);
      if(param2 != 0)
      {
         param2 = param2 / 1000 * 2;
         param2 += Math.round(this.gameTick % param2);
         Out.debug(this,"addState :: new tick >> " + param2);
      }
      _loc6_ = {};
      _loc6_.fn = param1;
      _loc6_.tick = param2;
      _loc6_.once = param3;
      _loc6_.refName = param4;
      _loc5_ = 0;
      while(_loc5_ < this.stateArr.length)
      {
         _loc7_ = this.stateArr[_loc5_];
         if(param1 == this.stateArr[_loc5_].fn)
         {
            this.stateArr[_loc5_] = _loc6_;
            return;
         }
         _loc5_++;
      }
      this.stateArr.push(_loc6_);
   }
   
   public function removeState(param1:Function) : void
   {
      var _loc2_:uint = 0;
      var _loc3_:Array = null;
      var _loc4_:Object = null;
      _loc3_ = [];
      _loc2_ = 0;
      while(_loc2_ < this.stateArr.length)
      {
         _loc4_ = this.stateArr[_loc2_];
         Out.debug(this,"removeState :: prototype >> " + param1.prototype);
         if(param1 == this.stateArr[_loc2_].fn)
         {
            Out.debug(this,"removeState :: fn >> " + param1 + " found and removed.");
         }
         else
         {
            _loc3_.push(this.stateArr[_loc2_]);
         }
         _loc2_++;
      }
      this.stateArr = _loc3_;
   }
   
   public function encrypt(param1:String) : String
   {
      return this.clientLib.encrypt(param1);
   }
   
   public function streamStartEvents() : void
   {
      var _loc1_:int = 0;
      var _loc2_:int = 0;
      var _loc3_:Object = null;
      var _loc4_:MovieClip = null;
      var _loc5_:DailyLoginEventData = null;
      if(!this.onGameStart)
      {
         return;
      }
      if(this.hasShownPopup)
      {
         return;
      }
      if(Main.exitFromTutorial)
      {
         return;
      }
      if(Central.main.extraData.trial_emblem_expire_time)
      {
         _loc1_ = int(Central.main.extraData.trial_emblem_expire_time);
         _loc2_ = Math.round(_loc1_ / (24 * 60 * 60));
      }
      if(Boolean(AppData.FB) || Boolean(AppData.MP) || Boolean(AppData.OK))
      {
         Main.isShowDailyLogin = false;
      }
      if(checkHackTimer == null)
      {
         checkHackTimer = new Timer(3000);
         checkHackTimer.addEventListener(TimerEvent.TIMER,Main.checkHackTimerListener);
         checkHackTimer.start();
      }
      if(Main.Features.FEATURE_DAILY_SCRATCH && Boolean(this.isShowDailyScratch) && Main.dailyRoulette_remainTime > 0 && Main.getMainChar().getLevel() >= 8 && Main.getMainChar().getLevel() <= 20)
      {
         Central.main.loadPopupPanel("daily_login_3","ninjasaga.linkage.daily_login3");
         this.isShowDailyScratch = false;
      }
      else if(Main.onceGiftLeft > 0)
      {
         if(Main.onceGift[Main.thisonceGift].canSelect != null)
         {
            if(Main.onceGift[Main.thisonceGift].canSelect == true)
            {
               Main.loadPopupPanel("get_mask_panel","ninjasaga.linkage.getmask");
               Main.onceGift[Main.thisonceGift].canSelect = false;
            }
         }
         else
         {
            Main.loadPopupPanel("Popup_special_reward_100token","ninjasaga.linkage.xmas2014SpecialReward");
         }
      }
      else if(Main.claimNewYear2015Cloth)
      {
         Main.claimNewYear2015Cloth = false;
         Main.loadPopupPanel("Popup_NewYear_2015","ninjasaga.linkage.newYearClothing2015");
      }
      else if(Main.GiftBagEvent.length > 0 && Main.getMainChar().getLevel() >= 5)
      {
         _loc3_ = Main.GiftBagEvent.shift();
         Main.showEventGiftBag(_loc3_);
      }
      else if(Main.showNewDailyLogin2017)
      {
         Main.showNewDailyLogin2017 = false;
         Main.loadPopupPanel("Panel_New_Daily_Login","ninjasaga.linkage.NewDailyLogin2017");
      }
      else if(Boolean(Central.main.extraData.trial_emblem_expire_time) && Boolean(Main.isShowTrial) && _loc2_ <= 7)
      {
         Main.isShowTrial = false;
         Central.main.loadPopupPanel("popup_trial_emblem","ninjasaga.linkage.TrialEmblemPanel");
      }
      else if(Central.main.extraData.claim_fowte == 1 && Main.isShowTrial)
      {
         Main.isShowTrial = false;
         Central.main.loadPopupPanel("popup_trial_emblem","ninjasaga.linkage.TrialEmblemPanel");
      }
      else if(Central.main.extraData.bank_system_tutorial)
      {
         Central.main.extraData.bank_system_tutorial = false;
         Main.loadPopupPanel("Popup_tutorialbank","ninjasaga.linkage.TutorialBank");
      }
      else if(Central.main.extraData.iphone_2015 > 0)
      {
         Central.main.extraData.iphone_2015 = 0;
         Main.loadPopupPanel("popup_luckydraw_iphone_2015","ninjasaga.linkage.LuckydrawIphone2015PS4");
      }
      else if(Main.getMainChar().getLevel() >= Main.DISPLAY_LEVEL_LIMIT_NORMAL && Central.main.getMainChar().getData(DBCharacterData.RANK) > RankData.GENIN && Main.Features.FEATURE_DAILY_LOGIN && Main.isShowDailyLogin && Main.dailyLogin)
      {
         Main.isShowDailyLogin = false;
         Main.loadPopupPanel("daily_login","ninjasaga.linkage.Roulette2");
      }
      else if(Main.getMainChar().getLevel() >= Main.DISPLAY_LEVEL_LIMIT_EVENT_LUCKY_DRAW && Central.main.getMainChar().getData(DBCharacterData.RANK) > RankData.GENIN && Boolean(this.isShowRoulette) && Boolean(this.rouletteShown) && Main.Features.FEATURE_ROULETTE)
      {
         this.rouletteShown = false;
         _loc4_ = this.mainMc.getAsset("ninjasaga.linkage.Roulette");
         mainMc["rouletteHolder"].addChild(_loc4_);
         _loc4_.show();
      }
      else if(Main.getMainChar().getLevel() < Main.DISPLAY_LEVEL_LIMIT_NORMAL || Mission.getDailyTask(false))
      {
         Mission.getDailyTask(true);
      }
      else if(this.specialAds)
      {
         Main.popup.showAds(this.specialAds);
         this.specialAds = null;
      }
      else if(Main.getMainChar().invite_accepted > 0)
      {
         Main.proc.showInviteFrdEventPopup();
      }
      else if(Main.getMainChar().veteran_return_fk_accepted > 0)
      {
         Main.proc.showVeteranReturnEventPopup();
      }
      else if(Main.showLuckyPuzzleStatus == 2 && Main.showFanPage)
      {
         Main.showFanPage = false;
         Main.showPopup(Central.main.langLib.get(1776)[0],Central.main.langLib.get(1776)[1],this.callback1,this.callback2);
      }
      else if(Main.ItemExpiried && Main.getMainChar().getLevel() >= Main.DISPLAY_LEVEL_LIMIT_NORMAL && Central.main.getMainChar().getData(DBCharacterData.RANK) > RankData.GENIN)
      {
         Main.loadPopupPanel("popup_expired_item","ninjasaga.linkage.ExpiryItemPopupPanel");
      }
      else if(Main.getMainChar().getLevel() >= Main.DISPLAY_LEVEL_LIMIT_NORMAL && Central.main.getMainChar().getData(DBCharacterData.RANK) > RankData.GENIN && Main.DailyLoginEvent && Main.DailyLoginEventReward.length > 0 && Main.isDisplayDailyLogin && Main.getMainChar().getLevel() >= 3)
      {
         Main.isDisplayDailyLogin = false;
         _loc5_ = new DailyLoginEventData();
         Main.showEventDailyLoginGift(_loc5_.dailyLoginLocation,_loc5_);
      }
      else if(Boolean(Central.main.accRegTutStatus == Central.main.ACC_REG_TUT_STATUS_NONE && Central.main.accRegActiveStatus == Central.main.ACC_REG_ACTIVE_STATUS_NOT_REGISTERED) && Boolean(Central.main.isDisplayRegTut) && Central.main.getMainChar().getData(DBCharacterData.RANK) >= 2)
      {
         Main.isDisplayRegTut = false;
         Main.loadPopupPanel("Popup_Password_2014","ninjasaga.linkage.AccRegNotice");
      }
      else if(Boolean(Central.main.extraData.amazing_draw_2014_redraw_ask) && Central.main.extraData.amazing_draw_2014_redraw_ask != 0)
      {
         Central.main.showConfirmation(Central.main.langLib.get(1880),this.redTicketYes,this.redTicketNo);
      }
      else if(Central.main.extraData.emblem_type_upgrade_display)
      {
         Central.main.extraData.emblem_type_upgrade_display = !Central.main.extraData.emblem_type_upgrade_display;
         Central.main.loadPopupPanel("popup_newemblem","ninjasaga.linkage.EmblemClaimChange");
      }
      else if(Main.ninecup == true)
      {
         Main.ninecup = false;
         Central.main.loadPopupPanel("9th_cup_popup_panel","ninjasaga.linkage.nineth_cup_game");
      }
      else if(Main.showIngameNotice)
      {
         Main.showIngameNotice = false;
         Main.loadPopupPanel("Popup_IngameNotice_Menu_2014","ninjasaga.linkage.IngameNoticeMenu2014");
      }
      else
      {
         this.onGameStart = false;
         this.hasShownPopup = true;
      }
   }
   
   private function redTicketYes() : void
   {
      var iWantIt:Boolean = false;
      iWantIt = true;
      Central.main.showInfo(Central.main.langLib.get(1833)[10]);
      Central.main.amfClient.service("SmallEvent.replyAmazingDraw2014",[Central.main.account.getAccountSessionKey(),iWantIt],function(param1:Object):*
      {
         if(Central.main.validateAmfResponse(param1))
         {
            return;
         }
      });
   }
   
   private function redTicketNo() : void
   {
      var iDontWantIt:Boolean = false;
      iDontWantIt = false;
      Central.main.amfClient.service("SmallEvent.replyAmazingDraw2014",[Central.main.account.getAccountSessionKey(),iDontWantIt],function(param1:Object):*
      {
         if(Central.main.validateAmfResponse(param1))
         {
            return;
         }
      });
   }
   
   public function callback1(param1:MouseEvent = null) : void
   {
      var _loc2_:String = null;
      _loc2_ = "";
      switch(AppData.lang)
      {
         case AppData.ZH:
            _loc2_ = "http://www.ninjasaga.com/event_lucky_draw/?lang=zh";
            break;
         default:
            _loc2_ = "http://www.ninjasaga.com/event_lucky_draw/?lang=en";
      }
      Main.gotoURL(_loc2_,"_blank");
   }
   
   public function callback2(param1:MouseEvent = null) : void
   {
      Central.sns.publishFeedById(SNSData.FEED_24,"","","",true);
   }
   
   public function showPaymentStatus(param1:MouseEvent = null) : void
   {
      var _loc2_:MovieClip = null;
      _loc2_ = this.mainMc.getAsset("ninjasaga.linkage.PaymentStatus");
      mainMc["attentionHolder"].addChild(_loc2_);
      _loc2_.show();
   }
   
   public function showRoulette(param1:MouseEvent) : void
   {
      var _loc2_:MovieClip = null;
      _loc2_ = this.mainMc.getAsset("ninjasaga.linkage.Roulette");
      mainMc["rouletteHolder"].addChild(_loc2_);
      _loc2_.show();
   }
   
   public function dailyRouletteRotation(param1:MovieClip) : void
   {
      if(Main.spinChance <= 0)
      {
         param1.gotoAndStop(1);
      }
   }
   
   public function displayRouletteButton() : void
   {
      if(Main.checkGameStatus() == Timeline.MAP && Main.showDailyRoulette > 0 && Main.spinChance > 0)
      {
         Main.mapMenu["dailyRouletteBtn"].visible = true;
         Main.mapMenu["dailyRouletteBtn"].mouseEnabled = true;
      }
      else
      {
         Main.mapMenu["dailyRouletteBtn"].visible = false;
         Main.mapMenu["dailyRouletteBtn"].mouseEnabled = false;
      }
   }
   
   public function showInviteReward(param1:MouseEvent = null) : void
   {
      if(Main.checkGameStatus() == Timeline.MAP)
      {
         Central.main.tracking.trackBuildingSelect("InviteReward");
         Panel.getInstance().show("invitFrdPanel");
      }
   }
   
   public function showSpecialReward(param1:MouseEvent = null) : void
   {
      if(Main.checkGameStatus() == Timeline.MAP)
      {
         this.mainMc["specialRewardMc"].show();
      }
   }
   
   public function showSenninExam(param1:MouseEvent = null) : void
   {
      if(Main.checkGameStatus() == Timeline.MAP)
      {
         Panel.getInstance().show("Panel_lv80exam_battle");
      }
   }
   
   public function showExam(param1:MouseEvent = null) : void
   {
      if(Main.checkGameStatus() == Timeline.MAP)
      {
         Panel.getInstance().show("special_exam");
      }
   }
   
   public function showjouninExamPage(param1:MouseEvent = null) : void
   {
      if(Main.checkGameStatus() == Timeline.MAP)
      {
         Panel.getInstance().show("jouninPanel_exam");
      }
   }
   
   public function showchuninExamPage(param1:MouseEvent = null) : void
   {
      if(Main.checkGameStatus() == Timeline.MAP)
      {
         Panel.getInstance().show("chuninPanel_exam");
      }
   }
   
   public function showInviteFrdEventPopup(param1:MouseEvent = null) : void
   {
      var _loc2_:int = 0;
      _loc2_ = Main.getMainChar().invite_accepted;
      Main.getMainChar().invite_accepted = 0;
      if(Main.checkGameStatus() == Timeline.MAP)
      {
         Main.popup.showInviteFrdDailyLogin(_loc2_);
      }
   }
   
   public function showVeteranReturnEventPopup(param1:MouseEvent = null) : void
   {
      var _loc2_:int = 0;
      _loc2_ = Main.getMainChar().veteran_return_fk_accepted;
      Main.getMainChar().veteran_return_fk_accepted = 0;
      if(Main.checkGameStatus() == Timeline.MAP)
      {
         Main.popup.showVeteranReturnDailyLogin(_loc2_);
      }
   }
   
   public function showInviteFriendPopup(param1:MouseEvent = null) : void
   {
      Main.popup.showInviteFriendPopup();
   }
   
   public function showNewsfeedRewardPopup(param1:MouseEvent = null) : void
   {
      Main.popup.showNewsfeedRewardPopup();
   }
   
   public function hideNewsfeedRewardPopup(param1:MouseEvent = null) : void
   {
      Main.popup.hideNewsfeedRewardPopup();
   }
   
   public function showInviteFriendReminderPopup(param1:MouseEvent = null) : void
   {
      Main.popup.showInviteFriendReminderPopup();
   }
   
   public function hideInviteFriendReminderPopup(param1:MouseEvent = null) : void
   {
      Main.popup.hideInviteFriendReminderPopup();
   }
   
   public function loadIcon(param1:String, param2:MovieClip, param3:String = null, param4:Function = null) : void
   {
      var _loc5_:String = null;
      _loc5_ = Data.genSwfFilePath("icons",param1);
      DynamicLoader.load(_loc5_,param2,param3,param4);
   }
   
   public function loadAd(param1:String, param2:MovieClip, param3:String = null, param4:Function = null) : void
   {
      var _loc5_:String = null;
      _loc5_ = Data.genSwfFilePath("ads",param1 + "_" + AppData.EN);
      DynamicLoader.load(_loc5_,param2,param3,param4,true);
   }
}
