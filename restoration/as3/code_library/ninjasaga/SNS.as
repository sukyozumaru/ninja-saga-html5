package ninjasaga
{
   import bitemycode.facebook.FBUser;
   import com.utils.Delegate;
   import com.utils.GF;
   import com.utils.NumberUtil;
   import com.utils.Out;
   import de.polygonal.ds.HashMap;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.net.LocalConnection;
   import flash.utils.getTimer;
   import ninjasaga.battle.*;
   import ninjasaga.data.AppData;
   import ninjasaga.data.BattleData;
   import ninjasaga.data.BloodlineData;
   import ninjasaga.data.ButtonData;
   import ninjasaga.data.Data;
   import ninjasaga.data.SNSData;
   import ninjasaga.data.SkillData;
   import ninjasaga.data.TitleData;
   
   public final class SNS
   {
      
      public static var fbConnector:MovieClip;
      
      public static var okConnector:MovieClip;
      
      public static var mpConnector:MovieClip;
      
      public static var challengeFriendName:String;
      
      private static var _cb:Function;
      
      public static var friendsData:Array;
      
      public static var friendList:Array;
      
      public static var friendListHash:HashMap;
      
      private static var getAppFriendsCallback:Function;
      
      private static var instance:SNS;
      
      private static var _isPublish:Boolean = false;
      
      private static var fbjsConnection:LocalConnection = new LocalConnection();
      
      public static var fbFeedGold:int = 0;
      
      public static var fbFeedIcon:int = 0;
      
      private static var savedFeedId:uint = 0;
      
      public static var friendListRetry:int = 0;
      
      public static var FB_GRAPH_API:String = "https://graph.facebook.com/";
      
      private var connector:MovieClip;
      
      public function SNS(param1:InstanceBlocker)
      {
         super();
         if(param1 == null)
         {
            throw new Error("Error: [SNS] Instantiation failed: Use SNS.getInstance() instead of new.");
         }
      }
      
      public static function getInstance() : SNS
      {
         if(instance == null)
         {
            instance = new SNS(new InstanceBlocker());
         }
         return instance;
      }
      
      public static function get isPublish() : Boolean
      {
         if(_isPublish)
         {
            _isPublish = false;
            return true;
         }
         return false;
      }
      
      public static function set isPublish(param1:Boolean) : void
      {
         _isPublish = param1;
      }
      
      public static function replaceMsg(param1:String, param2:String = "", param3:String = "", param4:String = "") : String
      {
         return String(param1).replace("[p1]",param2).replace("[p2]",param3).replace("[p3]",param4);
      }
      
      public static function publishFeedById(param1:String, param2:String = "", param3:String = "", param4:String = "", param5:Boolean = false, param6:Function = null) : void
      {
         var _loc9_:String = null;
         var _loc10_:String = null;
         var _loc11_:String = null;
         var _loc12_:String = null;
         Out.debug("SNS","publishFeedById :: " + param1 + " :: " + param2 + " :: " + param3 + " :: " + param4);
         var _loc7_:Object = Central.main.WALLFEED_DATA.find(param1);
         if(_loc7_ == null)
         {
            Out.error("SNS","WALLFEED NOT FOUND IN DATA LIBRARIES!");
            return;
         }
         _cb = param6;
         var _loc8_:String = String(_loc7_.type);
         switch(AppData.type)
         {
            case AppData.FB:
               if(param5)
               {
                  confirmPublishFeedById(_loc8_,param2,param3,param4);
               }
               else
               {
                  _loc9_ = "";
                  _loc10_ = "";
                  _loc11_ = "";
                  _loc12_ = "";
                  _loc9_ = replaceMsg(String(_loc7_.title),param2,param3,param4);
                  _loc10_ = replaceMsg(String(_loc7_.content),param2,param3,param4);
                  _loc11_ = String(_loc7_.image);
                  _loc12_ = replaceMsg(String(_loc7_.button),param2,param3,param4);
                  Main.showShareBoxNew(_loc9_,_loc10_,_loc11_,_loc12_,Delegate.create(null,confirmPublishFeedById,_loc8_,param2,param3,param4),rejectPublishFeed);
               }
               break;
            case AppData.MP:
               Main.callJS("publishActivity",_loc8_,Main.getMainChar().getCharacterName(),param2,param3,param4);
               publishCallback();
               break;
            case AppData.YM:
               Main.callJS("publishFeed",_loc8_,Main.getMainChar().getCharacterName(),param2,param3,param4);
               publishCallback();
               break;
            default:
               publishCallback();
         }
      }
      
      public static function publishFeed(param1:String, param2:String = "", param3:String = "", param4:String = "", param5:Function = null) : void
      {
         var _loc6_:String = null;
         var _loc7_:String = null;
         var _loc8_:String = null;
         var _loc9_:String = null;
         Out.debug("SNS","publishFeed :: " + param1 + " :: " + param2 + " :: " + param3 + " :: " + param4);
         _cb = param5;
         switch(AppData.type)
         {
            case AppData.FB:
               switch(param1)
               {
                  case SNSData.FEED_NEW_CHAR:
                     _loc6_ = Central.main.langLib.get(388);
                     fbFeedGold = 300;
                     fbFeedIcon = 5;
                     generatedFeed(340);
                     break;
                  case SNSData.FEED_GENIN:
                     _loc6_ = Central.main.langLib.get(389);
                     fbFeedGold = 500;
                     fbFeedIcon = 14;
                     generatedFeed(330);
                     break;
                  case SNSData.FEED_SPECIAL_MISSION:
                     generatedFeed(220);
                     confirmPublishFeed(param1,param2,param3,param4);
                     break;
                  case SNSData.FEED_CHALLENGE_WON:
                     _loc6_ = String(Central.main.langLib.get(391)).replace("[valp1]",param2);
                     fbFeedIcon = 11;
                     generatedFeed(210);
                     break;
                  case SNSData.FEED_CHARACTER_CUSTOMIZED:
                     _loc6_ = Central.main.langLib.get(392);
                     fbFeedIcon = 14;
                     generatedFeed(310);
                     break;
                  case SNSData.FEED_SKILL:
                     if(param3 == "trainfromother" && param3 != null && param3 != "")
                     {
                        _loc6_ = String(Central.main.langLib.get(592)).replace("[valp1]",param2);
                     }
                     else
                     {
                        _loc6_ = String(Central.main.langLib.get(393)).replace("[valp1]",param2);
                     }
                     fbFeedIcon = 10;
                     generatedFeed(230);
                     break;
                  case SNSData.FEED_CLOTH_SET:
                     _loc6_ = String(Central.main.langLib.get(394)).replace("[valp1]",param2);
                     fbFeedIcon = 1;
                     generatedFeed(350);
                     break;
                  case SNSData.FEED_WEAPON:
                     _loc6_ = String(Central.main.langLib.get(395)).replace("[valp1]",param2);
                     fbFeedIcon = 4;
                     generatedFeed(370);
                     break;
                  case SNSData.FEED_PET:
                     _loc6_ = String(Central.main.langLib.get(396)).replace("[valp1]",param2);
                     fbFeedIcon = 3;
                     generatedFeed(360);
                     break;
                  case SNSData.FEED_FIRST_NINJUTSU:
                     _loc6_ = String(Central.main.langLib.get(393)).replace("[valp1]",param4);
                     fbFeedGold = 400;
                     fbFeedIcon = 10;
                     generatedFeed(320);
                     break;
                  case SNSData.FEED_ROULETTE:
                     if(int(param2) == 1)
                     {
                        _loc6_ = String(Central.main.langLib.get(481)).replace("[token]",param3);
                        fbFeedIcon = 13;
                        generatedFeed(280);
                     }
                     if(int(param2) == 2)
                     {
                        _loc6_ = String(Central.main.langLib.get(480)).replace("[gold]",param3);
                        _loc6_ = _loc6_.replace("[gold]",param3);
                        fbFeedIcon = 12;
                        generatedFeed(240);
                     }
                     if(int(param2) == 3)
                     {
                        _loc6_ = Central.main.langLib.FeedDataText(SNSData.FEED_ROULETTE).xpconfirmmsg;
                        _loc6_ = _loc6_.replace("[amount]",param3);
                        _loc6_ = _loc6_.replace("[amount]",param3);
                        fbFeedIcon = 22;
                        generatedFeed(1050);
                     }
                     break;
                  case SNSData.FEED_BOSS_DEFEATED:
                     _loc6_ = Central.main.langLib.get(491);
                     generatedFeed(270);
                     break;
                  case SNSData.FEED_WEAPON_UPGRADE:
                     _loc6_ = Central.main.langLib.get(492);
                     generatedFeed(290);
                     break;
                  case SNSData.FEED_GIFT_SEND:
                     generatedFeed(380);
                     confirmPublishFeed(param1,param2,param3,param4);
                     break;
                  case SNSData.FEED_GIFT_RECEIVE:
                     _loc6_ = String(Central.main.langLib.get(558)).replace("[valreward]",param3);
                     generatedFeed(390);
                     break;
                  case SNSData.FEED_JOUNIN_EXAM_PART_1:
                     generatedFeed(400);
                     confirmPublishFeed(param1,param2,param3,param4);
                     break;
                  case SNSData.FEED_JOUNIN_EXAM_PART_2:
                     generatedFeed(410);
                     confirmPublishFeed(param1,param2,param3,param4);
                     break;
                  case SNSData.FEED_JOUNIN_EXAM_PART_3:
                     generatedFeed(420);
                     confirmPublishFeed(param1,param2,param3,param4);
                     break;
                  case SNSData.FEED_JOUNIN_EXAM_PART_4:
                     generatedFeed(430);
                     confirmPublishFeed(param1,param2,param3,param4);
                     break;
                  case SNSData.FEED_JOUNIN_EXAM_PART_5:
                     generatedFeed(440);
                     confirmPublishFeed(param1,param2,param3,param4);
                     break;
                  case SNSData.FEED_MISSION_PHOTO_HUNT:
                     generatedFeed(890);
                     confirmPublishFeed(param1,param2,param3,param4);
                     break;
                  case SNSData.FEED_MISSION_MEMORY_GAME:
                     generatedFeed(900);
                     confirmPublishFeed(param1,param2,param3,param4);
                     break;
                  case SNSData.FEED_MISSION_SPEED:
                     generatedFeed(910);
                     confirmPublishFeed(param1,param2,param3,param4);
                     break;
                  case SNSData.FEED_MISSION_TREASURE_BOX:
                     generatedFeed(920);
                     confirmPublishFeed(param1,param2,param3,param4);
                     break;
                  case SNSData.FEED_DUMMY_BOSS:
                     _loc6_ = Central.main.langLib.FeedDataText(SNSData.FEED_DUMMY_BOSS).confirmmsg;
                     fbFeedIcon = 21;
                     generatedFeed(930);
                     break;
                  case SNSData.FEED_CLAIM_PREMIUM_SET:
                     _loc6_ = Central.main.langLib.FeedDataText(SNSData.FEED_CLAIM_PREMIUM_SET).confirmmsg;
                     fbFeedIcon = 19;
                     generatedFeed(940);
                     break;
                  case SNSData.FEED_CLAIM_DUMMY_PET:
                     _loc6_ = Central.main.langLib.FeedDataText(SNSData.FEED_CLAIM_DUMMY_PET).confirmmsg;
                     fbFeedIcon = 19;
                     generatedFeed(950);
                     break;
                  case SNSData.FEED_BADGE_CLOTH:
                     _loc6_ = Central.main.langLib.FeedDataText(SNSData.FEED_BADGE_CLOTH).confirmmsg;
                     fbFeedIcon = 19;
                     generatedFeed(960);
                     break;
                  case SNSData.FEED_BADGE_WEAPON:
                     _loc6_ = Central.main.langLib.FeedDataText(SNSData.FEED_BADGE_WEAPON).confirmmsg;
                     fbFeedIcon = 19;
                     generatedFeed(970);
                     break;
                  case SNSData.FEED_BADGE_BACK_ITEM:
                     _loc6_ = Central.main.langLib.FeedDataText(SNSData.FEED_BADGE_BACK_ITEM).confirmmsg;
                     fbFeedIcon = 19;
                     generatedFeed(980);
                     break;
                  case SNSData.FEED_LUCKYDRAW_EMBLEM:
                     fbFeedIcon = 18;
                     generatedFeed(990);
                     confirmPublishFeed(param1,param2,param3,param4);
                     break;
                  case SNSData.FEED_LUCKYDRAW_TOKENS:
                     fbFeedIcon = 18;
                     generatedFeed(1000);
                     confirmPublishFeed(param1,param2,param3,param4);
                     break;
                  case SNSData.FEED_LUCKYDRAW_PET:
                     fbFeedIcon = 18;
                     generatedFeed(1010);
                     confirmPublishFeed(param1,param2,param3,param4);
                     break;
                  case SNSData.FEED_LUCKYDRAW_TOKENS2:
                     generatedFeed(1020);
                     confirmPublishFeed(param1,param2,param3,param4);
                     break;
                  case SNSData.FEED_LUCKYDRAW_GOLD:
                     fbFeedIcon = 18;
                     generatedFeed(1030);
                     confirmPublishFeed(param1,param2,param3,param4);
                     break;
                  case SNSData.FEED_LUCKYDRAW_MAGATAMA:
                     fbFeedIcon = 18;
                     generatedFeed(1040);
                     confirmPublishFeed(param1,param2,param3,param4);
                     break;
                  case SNSData.FEED_ACHIEVEMENT_GAIN:
                     _loc7_ = String(Central.main.langLib.get(1086)).replace("[achievement_name]",param3);
                     _loc6_ = String(Central.main.langLib.get(1087)).replace("[achievement_desc]",param4);
                     _loc8_ = param2;
                     _loc9_ = ButtonData.SHARE;
                     break;
                  case SNSData.FEED_SJ_NORMAL:
                     _loc7_ = String(Central.main.langLib.get(1440)).replace("[playername]",Central.main.getMainChar().getCharacterName());
                     _loc6_ = String(Central.main.langLib.get(1442)).replace("[playername]",Central.main.getMainChar().getCharacterName());
                     _loc8_ = "wf_77";
                     _loc9_ = ButtonData.SHARE;
                     break;
                  case SNSData.FEED_SJ_TENSAI:
                     _loc7_ = String(Central.main.langLib.get(1441)).replace("[playername]",Central.main.getMainChar().getCharacterName());
                     _loc6_ = String(Central.main.langLib.get(1443)).replace("[playername]",Central.main.getMainChar().getCharacterName());
                     _loc8_ = "wf_78";
                     _loc9_ = ButtonData.SHARE;
                     break;
                  case SNSData.FEED_SPECIAL_JOUNIN_EXAM:
                     confirmPublishFeed(param1,param2,param3,param4);
                     break;
                  case SNSData.FEED_FORTUNE_CARD:
                     _loc7_ = String(Central.main.langLib.get(1617)[18]);
                     _loc6_ = String(Central.main.langLib.get(1617)[19]);
                     _loc8_ = "wf_85";
                     _loc9_ = ButtonData.SHARE;
               }
               if(_loc6_)
               {
                  if(param1 == SNSData.FEED_SKILL && param3 == "trainfromother" && param3 != null && param3 != "")
                  {
                     Main.showShareBox(_loc6_,Delegate.create(null,confirmPublishFeed,param1,param2,param3,param4),rejectPublishFeed2);
                  }
                  else if(param1 == SNSData.FEED_ACHIEVEMENT_GAIN || param1 == SNSData.FEED_SJ_TENSAI || param1 == SNSData.FEED_SJ_NORMAL)
                  {
                     Main.showShareBoxNew(_loc7_,_loc6_,_loc8_,_loc9_,Delegate.create(null,confirmPublishFeed,param1,param2,param3,param4),rejectPublishFeed);
                  }
                  else if(param1 == SNSData.FEED_FORTUNE_CARD)
                  {
                     Main.showShareBoxNew(_loc7_,_loc6_,_loc8_,_loc9_,Delegate.create(null,confirmPublishFeed,param1,param2,param3,param4),rejectPublishFeed);
                  }
                  else
                  {
                     Main.showShareBox(_loc6_,Delegate.create(null,confirmPublishFeed,param1,param2,param3,param4),rejectPublishFeed);
                  }
               }
               break;
            case AppData.MP:
               Main.callJS("publishActivity",param1,Main.getMainChar().getCharacterName(),param2,param3,param4);
               publishCallback();
               break;
            case AppData.YM:
               Out.debug("SNS","YM :: publishFeed :: type >> " + param1);
               Main.callJS("publishFeed",param1,Main.getMainChar().getCharacterName(),param2,param3,param4);
               publishCallback();
               break;
            case AppData.RR:
               Out.debug("SNS","YM :: publishFeed :: type >> " + param1);
               Central.main.proc.showNewsfeedRewardPopup();
               Main.callJS("publishFeed",param1,Main.getMainChar().getCharacterName(),param2,param3,param4);
               publishCallback();
               break;
            default:
               publishCallback();
         }
      }
      
      public static function publishShareFeed(param1:String, param2:String = "", param3:String = "", param4:String = "", param5:Function = null) : void
      {
         var _loc6_:String = null;
         var _loc7_:String = null;
         var _loc8_:String = null;
         var _loc9_:String = null;
         Out.debug("SNS","publishShareFeed :: " + param1 + " :: " + param2 + " :: " + param3 + " :: " + param4);
         _cb = param5;
         switch(AppData.type)
         {
            case AppData.FB:
               switch(param1)
               {
                  case SNSData.FEED_FR_FIRST_SP:
                     _loc7_ = Central.main.langLib.get(698);
                     _loc6_ = Central.main.langLib.get(699);
                     _loc8_ = "wf_3";
                     _loc9_ = ButtonData.SHAREXP;
                     generatedFeed(1050);
                     break;
                  case SNSData.FEED_FR_SP_XP:
                     _loc7_ = Central.main.langLib.get(700);
                     _loc6_ = String(Central.main.langLib.get(701)).replace("[value]",param3);
                     _loc8_ = "wf_4";
                     _loc9_ = ButtonData.SHAREXP;
                     generatedFeed(1060);
                     break;
                  case SNSData.FEED_FR_SP_GOLD:
                     _loc7_ = Central.main.langLib.get(702);
                     _loc6_ = String(Central.main.langLib.get(703)).replace("[value]",param3);
                     _loc8_ = "wf_1";
                     _loc9_ = ButtonData.SHAREGOLD;
                     generatedFeed(1070);
                     break;
                  case SNSData.FEED_FR_SP_TOKEN:
                     _loc7_ = Central.main.langLib.get(704);
                     _loc6_ = String(Central.main.langLib.get(705)).replace("[value]",param3);
                     _loc8_ = "wf_2";
                     _loc9_ = ButtonData.SHARETOKEN;
                     generatedFeed(1080);
                     break;
                  case SNSData.FEED_FR_SP_CLOTHING:
                     _loc7_ = Central.main.langLib.get(706);
                     _loc6_ = Central.main.langLib.get(707);
                     _loc8_ = "wf_20";
                     _loc9_ = ButtonData.SHARECLOTHING;
                     generatedFeed(1090);
                     break;
                  case SNSData.FEED_FR_SP_WEAPON:
                     _loc7_ = Central.main.langLib.get(708);
                     _loc6_ = Central.main.langLib.get(709);
                     _loc8_ = "wf_12";
                     _loc9_ = ButtonData.SHAREWEAPON;
                     generatedFeed(1100);
                     break;
                  case SNSData.FEED_FR_SP_BACKITEM:
                     _loc7_ = Central.main.langLib.get(710);
                     _loc6_ = Central.main.langLib.get(711);
                     _loc8_ = "wf_9";
                     _loc9_ = ButtonData.SHAREBACK;
                     generatedFeed(1110);
                     break;
                  case SNSData.FEED_FR_DT_XP:
                     generatedFeed(1120);
                     confirmPublishFeed(param1,param2,param3,param4);
                     break;
                  case SNSData.FEED_FR_DT_GOLD:
                     generatedFeed(1130);
                     confirmPublishFeed(param1,param2,param3,param4);
                     break;
                  case SNSData.FEED_FR_DT_TOKEN:
                     generatedFeed(1140);
                     confirmPublishFeed(param1,param2,param3,param4);
                     break;
                  case SNSData.FEED_FR_DT_CLOTHING:
                     generatedFeed(1150);
                     confirmPublishFeed(param1,param2,param3,param4);
                     break;
                  case SNSData.FEED_FR_DT_WEAPON:
                     generatedFeed(1160);
                     confirmPublishFeed(param1,param2,param3,param4);
                     break;
                  case SNSData.FEED_FR_DT_BACKITEM:
                     generatedFeed(1170);
                     confirmPublishFeed(param1,param2,param3,param4);
                     break;
                  case SNSData.FEED_FR_LUCKY_DRAW_XP:
                     _loc7_ = Central.main.langLib.get(724);
                     _loc6_ = String(Central.main.langLib.get(725)).replace("[value]",param3);
                     _loc8_ = "wf_14";
                     _loc9_ = ButtonData.SHAREXP;
                     generatedFeed(1180);
                     break;
                  case SNSData.FEED_FR_LUCKY_DRAW_GOLD:
                     _loc7_ = Central.main.langLib.get(726);
                     _loc6_ = String(Central.main.langLib.get(727)).replace("[value]",param3);
                     _loc8_ = "wf_1";
                     _loc9_ = ButtonData.SHAREGOLD;
                     generatedFeed(1190);
                     break;
                  case SNSData.FEED_FR_LUCKY_DRAW_TOKEN:
                     _loc7_ = Central.main.langLib.get(728);
                     _loc6_ = String(Central.main.langLib.get(729)).replace("[value]",param3);
                     _loc8_ = "wf_2";
                     _loc9_ = ButtonData.SHARETOKEN;
                     generatedFeed(1200);
                     break;
                  case SNSData.FEED_FR_DISCOVER_BLOODLINE:
                     generatedFeed(1210);
                     confirmPublishFeed(param1,param2,param3,param4);
                     break;
                  case SNSData.FEED_FR_UPGRADE_BLOODLINE:
                     generatedFeed(1220);
                     confirmPublishFeed(param1,param2,param3,param4);
                     break;
                  case SNSData.FEED_SEND_DAILY_GIFT:
                     generatedFeed(1310);
                     confirmPublishFeed(param1,param2,param3,param4);
                     break;
                  case SNSData.FEED_THANKSGIVING_BALLOON:
                     _loc7_ = Central.main.langLib.titleTxt(TitleData.CLAIM_BALLOON);
                     _loc6_ = Central.main.langLib.get(896);
                     _loc8_ = "wf_28";
                     _loc9_ = ButtonData.SHARE;
                     generatedFeed(1320);
                     break;
                  case SNSData.FEED_TURKEY_PET:
                     _loc7_ = Central.main.langLib.titleTxt(TitleData.CLAIM_TURKEY);
                     _loc6_ = Central.main.langLib.get(897);
                     _loc8_ = "wf_29";
                     _loc9_ = ButtonData.SHARE;
                     generatedFeed(1330);
                     break;
                  case SNSData.FEED_XMAS_POSTWALL:
                     confirmPublishFeed(param1,param2,param3,param4);
                     break;
                  case SNSData.FEED_XMAS_SET_CLAIM:
                     _loc8_ = "wf_92";
                     _loc7_ = Central.main.langLib.get(1621)[61];
                     _loc6_ = String(Central.main.langLib.get(1621)[62]).replace("[reward]",param3);
                     _loc9_ = ButtonData.SHARE;
                     break;
                  case "newyearcloth":
                  case "xmasluckydraw":
                  case "dailyscratch":
                     _loc7_ = param2;
                     _loc6_ = param3;
                     _loc8_ = param4;
                     _loc9_ = ButtonData.SHARE;
                     break;
                  case SNSData.FEED_NEW_YEAR_SKILL:
                     _loc8_ = "wf_94";
                     _loc7_ = Central.main.langLib.get(1628)[8];
                     _loc6_ = String(Central.main.langLib.get(1628)[11]);
                     _loc9_ = ButtonData.SHARE;
                     break;
                  case SNSData.FEED_VDAY_COLLECT_MAILER:
                  case SNSData.FEED_VDAY_COLLECT_STAINEDPAPER:
                     confirmPublishFeed(param1,param2,param3,param4);
                     break;
                  case SNSData.FEED_VDAY_COLLECT_SET_CLAIM:
                     _loc8_ = "wf_102";
                     _loc7_ = param2;
                     _loc6_ = String(param3).replace("[item_name]",param4);
                     _loc9_ = ButtonData.SHARE;
                     break;
                  case SNSData.FEED_VDAY_COLLECT_SET_CLAIM_ALL:
                     _loc8_ = "wf_101";
                     _loc7_ = param2;
                     _loc6_ = param3;
                     _loc9_ = ButtonData.SHARE;
                     break;
                  case SNSData.FEED_HUNTING_BOSS_MATERIAL:
                  case SNSData.FEED_EASTEREVENT2012:
                  case SNSData.FEED_HOLLOWEEN2012:
                  case SNSData.FEED_HEARTOFKRI:
                  case SNSData.FEED_DRAGONBALL_EASTEREVENT2014:
                     confirmPublishFeed(param1,param2,param3,param4);
               }
               if(_loc6_)
               {
                  Central.main.showShareBoxNew(_loc7_,_loc6_,_loc8_,_loc9_,Delegate.create(null,confirmPublishFeed,param1,param2,param3,param4),rejectPublishFeed);
               }
               break;
            case AppData.MP:
               Main.callJS("publishActivity",param1,Main.getMainChar().getCharacterName(),param2,param3,param4);
               publishCallback();
               break;
            case AppData.RR:
               Out.debug("SNS","YM :: publishShareFeed->publishFeed :: type >> " + param1);
               Main.callJS("publishFeed",param1,Main.getMainChar().getCharacterName(),param2,param3,param4);
               publishCallback();
            default:
               publishCallback();
         }
      }
      
      public static function sendRequestNotify(param1:String = "", param2:String = "", param3:String = "", param4:String = "", param5:Function = null) : void
      {
         Out.debug("SNS","sendRequestNotify :: requestListShowDialog :: " + param1 + " :: " + param2 + " :: " + param3 + " :: " + param4);
         Main.callJS("requestListShowDialog",param1,param2,param3,param4);
      }
      
      public static function deleteRequestNotify(param1:String = "", param2:String = "", param3:String = "", param4:Function = null) : void
      {
         Out.debug("SNS","deleteRequestNotify :: requestShowDialog :: " + param1 + " :: " + param2 + " :: " + param3);
         Main.callJS("deleteRequest",param1);
      }
      
      public static function deleteRequestNotifyArr(param1:Array = null, param2:String = "", param3:String = "", param4:Function = null) : void
      {
         Out.debug("SNS","deleteRequestNotifyArr :: deleteRequestByRequestId :: " + param1 + " :: " + param2 + " :: " + param3);
         if(param1 == null)
         {
            param1 = new Array();
         }
         Main.callJS("deleteRequestByRequestId",param1);
      }
      
      public static function confirmRequestNotify(param1:String = "", param2:String = "", param3:String = "", param4:String = "", param5:Function = null) : void
      {
         Out.debug("SNS","confirmRequestNotify :: requestShowDialog :: " + param1 + " :: " + param2 + " :: " + param3 + " :: " + param4);
         Main.callJS("requestShowDialog",param1,param2,param3,param4);
      }
      
      public static function sendRequestNotification(param1:String = "", param2:String = "", param3:String = "", param4:Function = null) : void
      {
         Out.debug("SNS","sendRequest :: " + param1 + " :: " + param2 + " :: " + param3);
         Main.callJS("sendRequest",param1,param2,param3);
      }
      
      public static function deleteRequestNotification(param1:String = "", param2:String = "", param3:String = "", param4:Function = null) : void
      {
         Out.debug("SNS","deleteRequest :: " + param1 + " :: " + param2 + " :: " + param3);
         Main.callJS("deleteRequest",param1);
      }
      
      public static function confirmRequestNotification(param1:String = "", param2:String = "", param3:String = "", param4:Function = null) : void
      {
         Out.debug("SNS","confirmRequest :: " + param1 + " :: " + param2 + " :: " + param3);
         Main.callJS("confirmRequest",param1,param2,param3);
      }
      
      private static function confirmPublishFeedById(param1:String, param2:String, param3:String, param4:String) : void
      {
         switch(AppData.type)
         {
            case AppData.FB:
               Out.debug("SNS","confirmPublishFeedById");
               Main.callJS("newPublishFeed",param1,Main.getMainChar().getCharacterName(),param2,param3,param4);
               publishCallback();
               break;
            default:
               Main.showInfo("DEBUG: Publish Feed: " + param1);
         }
      }
      
      private static function confirmPublishFeed(param1:String, param2:String, param3:String, param4:String) : void
      {
         switch(AppData.type)
         {
            case AppData.FB:
            case AppData.RR:
               Main.callJS("publishFeed",param1,Main.getMainChar().getCharacterName(),param2,param3,param4);
               publishCallback();
               break;
            case AppData.MP:
         }
      }
      
      private static function rejectPublishFeed() : void
      {
         fbFeedGold = 0;
         publishCallback();
      }
      
      private static function rejectPublishFeed2() : void
      {
         fbFeedGold = 0;
         Central.main.showOk(Central.main.langLib.get(645),new Function());
      }
      
      public static function publishLevelupFeed() : void
      {
         var _loc1_:String = null;
         switch(AppData.type)
         {
            case AppData.FB:
               _loc1_ = String(Central.main.langLib.get(398)).replace("[vallevel]",Main.getMainChar().getLevel());
               Main.showShareBox(_loc1_,confirmPublishLevelup,rejectPublishFeed);
               fbFeedIcon = 7;
               generatedFeed(10);
               break;
            case AppData.MP:
               confirmPublishLevelup();
               break;
            case AppData.OK:
               _loc1_ = String(Central.main.langLib.get(398)).replace("[vallevel]",Main.getMainChar().getLevel());
               Main.showConfirmation(_loc1_,confirmPublishLevelup,new Function());
               break;
            case AppData.RR:
               confirmPublishLevelup();
         }
      }
      
      private static function confirmPublishLevelup() : void
      {
         var _loc11_:String = null;
         var _loc1_:String = Main.getMainChar().getGender() == 0 ? "male" : "female";
         var _loc2_:String = String(Main.getMainChar().getLevel());
         var _loc3_:Boolean = false;
         var _loc4_:Boolean = false;
         var _loc5_:Boolean = false;
         var _loc6_:Boolean = false;
         var _loc7_:Boolean = false;
         var _loc8_:Boolean = false;
         var _loc9_:Boolean = false;
         var _loc10_:HashMap = Main.getMainChar().getSkillTypes();
         if(_loc10_.containsKey(SkillData.TYPE_FIRE))
         {
            _loc3_ = true;
         }
         if(_loc10_.containsKey(SkillData.TYPE_WATER))
         {
            _loc4_ = true;
         }
         if(_loc10_.containsKey(SkillData.TYPE_LIGHTNING))
         {
            _loc5_ = true;
         }
         if(_loc10_.containsKey(SkillData.TYPE_WIND))
         {
            _loc6_ = true;
         }
         if(_loc10_.containsKey(SkillData.TYPE_EARTH))
         {
            _loc7_ = true;
         }
         if(_loc10_.containsKey(SkillData.TYPE_TAIJUTSU))
         {
            _loc8_ = true;
         }
         if(_loc10_.containsKey(SkillData.TYPE_GENJUTSU))
         {
            _loc9_ = true;
         }
         switch(AppData.type)
         {
            case AppData.FB:
               Main.callJS("showFeed",_loc1_,_loc2_,_loc3_,_loc4_,_loc5_,_loc6_,_loc7_,_loc8_,_loc9_);
               break;
            case AppData.MP:
               Main.callJS("publishActivity","levelup",Main.getMainChar().getCharacterName(),_loc1_,_loc2_,_loc3_,_loc4_,_loc5_,_loc6_,_loc7_,_loc8_,_loc9_);
               break;
            case AppData.OK:
               _loc11_ = Central.main.langLib.get(400);
               _loc11_ = String(_loc11_).replace("[valapplicationurl]",Data.APPLICATION_URL);
               _loc11_ = String(_loc11_).replace("[valcharactername]",Central.main.getMainChar().getCharacterName());
               _loc11_ = String(_loc11_).replace("[valcharacterlevel]",Central.main.getMainChar().getLevel());
               okConnector.conn.createActivity(Central.main.langLib.get(399),_loc11_);
               break;
            case AppData.RR:
               Main.callJS("publishFeed",SNSData.FEED_LEVEL_UP,Main.getMainChar().getCharacterName(),_loc2_);
         }
      }
      
      public static function publishDailyTask(param1:*, param2:*, param3:*) : void
      {
         var _loc4_:String = null;
         switch(AppData.type)
         {
            case AppData.FB:
               _loc4_ = Central.main.langLib.get(401);
               confirmPublishDailyTask(param1,param2,param3);
               generatedFeed(250);
               break;
            case AppData.MP:
               confirmPublishDailyTask(param1,param2,param3);
               break;
            case AppData.OK:
               _loc4_ = Central.main.langLib.get(401);
               Main.showConfirmation(_loc4_,Delegate.create(null,confirmPublishDailyTask,param1,param2,param3),new Function());
               break;
            case AppData.RR:
               confirmPublishDailyTask(param1,param2,param3);
         }
      }
      
      private static function confirmPublishDailyTask(param1:*, param2:*, param3:*) : void
      {
         var _loc4_:String = null;
         var _loc5_:String = null;
         if(Main.getMainChar().getGender() == 0)
         {
            _loc4_ = "male";
         }
         else
         {
            _loc4_ = "female";
         }
         switch(AppData.type)
         {
            case AppData.FB:
               Main.callJS("feedDailyTask",_loc4_,Main.getMainChar().getCharacterName(),param1,param2,param3);
               break;
            case AppData.MP:
               Main.callJS("publishActivity","daily_task",Main.getMainChar().getCharacterName(),param1,param2,param3);
               break;
            case AppData.OK:
               _loc5_ = Central.main.langLib.get(403);
               _loc5_ = String(_loc5_).replace("[valapplicationurl]",Data.APPLICATION_URL);
               _loc5_ = String(_loc5_).replace("[valcharactername]",Main.getMainChar().getCharacterName());
               okConnector.conn.createActivity(Central.main.langLib.get(402),_loc5_);
               break;
            case AppData.RR:
               Main.callJS("publishFeed",Main.getMainChar().getCharacterName(),param1,param2,param3);
         }
      }
      
      public static function sendNotification(param1:String, param2:Array, param3:String = "user_to_user") : void
      {
         switch(AppData.type)
         {
            case AppData.FB:
               fbConnector.sendNotification(param1,param2,param3);
               break;
            case AppData.OK:
               okConnector.conn.sendMessage(param2,Central.main.langLib.get(404),param1);
               break;
            case AppData.MP:
               mpConnector.conn.sendNotification(param2,param1);
         }
      }
      
      public static function publishRankup(param1:uint) : void
      {
         switch(AppData.type)
         {
            case AppData.FB:
               generatedFeed(300);
               Main.callJS("showRankupFeed",Main.getMainChar().getCharacterName(),param1);
               break;
            case AppData.MP:
               Main.callJS("publishActivity","rankup",Main.getMainChar().getCharacterName(),param1);
               break;
            case AppData.RR:
               Main.callJS("publishFeed","rankup",Main.getMainChar().getCharacterName(),param1);
         }
      }
      
      public static function togglePublish(param1:MouseEvent) : void
      {
         if(MovieClip(param1.currentTarget.parent).currentLabel == "unchecked")
         {
            MovieClip(param1.currentTarget.parent).gotoAndStop("checked");
            isPublish = true;
         }
         else
         {
            MovieClip(param1.currentTarget.parent).gotoAndStop("unchecked");
            isPublish = false;
         }
      }
      
      private static function publishCallback() : void
      {
         if(_cb != null)
         {
            _cb();
         }
      }
      
      public static function callFBJS(param1:String, ... rest) : void
      {
      }
      
      public static function initFBJSListener() : void
      {
      }
      
      private static function generatedFeed(param1:uint) : *
      {
         var _loc2_:String = Main.updateSequence();
         Central.main.amfClient.service("Tracking.generated",[Account.getAccountSessionKey(),param1,_loc2_],Main.onAmfResult);
         savedFeedId = param1;
      }
      
      private static function postedFeed() : *
      {
         var _loc1_:String = null;
         if(savedFeedId > 0)
         {
            _loc1_ = Main.updateSequence();
            Central.main.amfClient.service("Tracking.posted",[Account.getAccountSessionKey(),savedFeedId,_loc1_],Main.onAmfResult);
            savedFeedId = 0;
         }
      }
      
      public static function visitRandomFriend() : void
      {
         if(AppData.type != AppData.FB)
         {
            Out.debug("SNS","visitRandomFriend :: not Facebook application");
            return;
         }
         if(friendsData == null)
         {
            Out.debug("SNS","visitRandomFriend :: no friend or character");
            return;
         }
         if(friendsData.length <= 0)
         {
            Out.debug("SNS","visitRandomFriend :: no friend or character");
            return;
         }
         var _loc1_:Array = [];
         var _loc2_:int = 0;
         while(_loc2_ < friendsData.length)
         {
            if(friendsData[_loc2_])
            {
               if(friendsData[_loc2_].source_id != FBUser.uid)
               {
                  _loc1_.push(friendsData[_loc2_]);
               }
            }
            _loc2_++;
         }
         var _loc3_:int = NumberUtil.randomInt(0,_loc1_.length - 1);
         if(_loc1_[_loc3_])
         {
            if(_loc1_[_loc3_].character_id)
            {
               Main.visitFriend(_loc1_[_loc3_].character_id,FBUser.uid);
               return;
            }
         }
         Out.error("SNS","visitRandomFriend :: friendCharArr[" + _loc3_ + "] is null :: friendCharArr.length >> " + _loc1_.length);
      }
      
      public static function getAppFriends(param1:Function, param2:Boolean = false) : void
      {
         if(Boolean(friendList) && !param2)
         {
            param1(friendList);
            return;
         }
         if(friendListRetry >= 3)
         {
            Main.showConfirmation("Sorry! We are unable to connect to the Facebook server to acquire your friend list.",new Function(),new Function());
            return;
         }
         if(friendListRetry == 0)
         {
            fbConnector.getAppFriends(param1);
         }
         else
         {
            getAppFriendsCallback = param1;
            Main.amfClient.service("FacebookService.getFriendList",[Main.ACCESS_TOKEN],getFriendListResponse);
         }
         ++friendListRetry;
      }
      
      public static function getRenRenAppFriends(param1:Function) : void
      {
         if(friendList == null)
         {
            getAppFriendsCallback = param1;
            Main.amfClient.service("SocialNetwork.getFriends",[Data.sessionKey,Central.main.RR_SESSION_KEY],getRenRenFriendListResponse);
         }
         else
         {
            param1(friendList);
         }
      }
      
      private static function getRenRenFriendListResponse(param1:Object) : *
      {
         var _loc2_:HashMap = null;
         var _loc3_:HashMap = null;
         var _loc4_:Array = null;
         var _loc5_:Array = null;
         var _loc6_:* = undefined;
         var _loc7_:int = 0;
         var _loc8_:Array = null;
         var _loc9_:Array = null;
         var _loc10_:Object = null;
         var _loc11_:Object = null;
         var _loc12_:String = null;
         var _loc13_:Array = null;
         if(Main.validateAmfResponse(param1))
         {
            if(param1.friend_list == null || param1.char_list == null)
            {
               if(getAppFriendsCallback != null)
               {
                  getAppFriendsCallback(_loc5_);
               }
               return;
            }
            friendListHash = new HashMap();
            _loc2_ = new HashMap();
            _loc3_ = new HashMap();
            _loc4_ = param1.friend_list;
            _loc5_ = param1.char_list;
            _loc8_ = [];
            _loc9_ = [];
            _loc6_ = 0;
            while(_loc6_ < _loc4_.length)
            {
               _loc10_ = {};
               _loc10_.uid = _loc4_[_loc6_].id;
               _loc10_.name = _loc4_[_loc6_].name;
               _loc10_.pic_square = _loc4_[_loc6_].pic_square;
               _loc8_.push(_loc10_);
               friendListHash.insert(_loc10_.uid,_loc10_);
               _loc6_++;
            }
            Central.sns.friendList = _loc8_;
            _loc6_ = 0;
            while(_loc6_ < _loc5_.length)
            {
               _loc11_ = {};
               _loc11_.source_id = _loc5_[_loc6_].source_id;
               _loc11_.character_id = _loc5_[_loc6_].character_id;
               _loc11_.character_name = _loc5_[_loc6_].character_name;
               _loc11_.character_level = _loc5_[_loc6_].character_level;
               _loc11_.character_xp = _loc5_[_loc6_].character_xp;
               _loc11_.character_gender = _loc5_[_loc6_].character_gender;
               _loc11_.account_type = _loc5_[_loc6_].account_type;
               _loc11_.character_rank = uint(_loc5_[_loc6_].character_rank);
               _loc11_.server_time = _loc5_[_loc6_].server_time;
               _loc11_.thumbnail_url = _loc5_[_loc6_].thumbnail_url;
               _loc11_.server_time = _loc5_[_loc6_].display_name;
               _loc11_.achievement_point = _loc5_[_loc6_].achievement_point;
               _loc11_.recruited_time = _loc5_[_loc6_].recruited_time;
               _loc9_.push(_loc11_);
               _loc6_++;
            }
            _loc6_ = 0;
            while(_loc6_ < _loc8_.length)
            {
               _loc12_ = String(_loc8_[_loc6_].uid);
               _loc13_ = [];
               _loc7_ = 0;
               while(_loc7_ < _loc9_.length)
               {
                  if(String(_loc9_[_loc7_].source_id) == _loc12_)
                  {
                     _loc3_.insert(_loc9_[_loc7_].character_id,_loc9_[_loc7_]);
                     _loc13_.push(_loc9_[_loc7_]);
                  }
                  _loc7_++;
               }
               _loc2_.insert(_loc12_,_loc13_);
               _loc6_++;
            }
            Central.panel.getInstance().addChallengeCharCache(_loc2_);
            Central.panel.getInstance().addRecruitCharCache(_loc3_);
            Central.main.friendData = Central.panel.getInstance().recruitCharCache.toArray();
            if(getAppFriendsCallback != null)
            {
               getAppFriendsCallback(_loc5_);
            }
         }
      }
      
      private static function getFriendListResponse(param1:Object) : *
      {
         var _loc2_:Array = null;
         var _loc3_:int = 0;
         var _loc4_:Array = null;
         var _loc5_:Object = null;
         if(Main.validateAmfResponse(param1))
         {
            if(param1.friend_list == null)
            {
               return;
            }
            _loc2_ = param1.friend_list;
            _loc4_ = [];
            _loc3_ = 0;
            while(_loc3_ < _loc2_.length)
            {
               _loc5_ = {};
               _loc5_.uid = _loc2_[_loc3_].id;
               _loc5_.name = _loc2_[_loc3_].name;
               _loc5_.pic_square = FB_GRAPH_API + _loc2_[_loc3_].id + "/picture?access_token=" + Main.ACCESS_TOKEN;
               _loc4_.push(_loc5_);
               _loc3_++;
            }
            if(getAppFriendsCallback != null)
            {
               getAppFriendsCallback(_loc4_);
            }
         }
      }
      
      public static function getFriendList(param1:Function) : void
      {
         getInstance().getFriendList(param1);
      }
      
      public function setConnector(param1:MovieClip) : void
      {
         this.connector = param1;
      }
      
      public function getFriendList(param1:Function) : void
      {
         if(AppData.type == AppData.RR)
         {
            getRenRenAppFriends(param1);
         }
         else
         {
            if(this.connector == null)
            {
               param1([]);
               return;
            }
            this.connector.getFriendList(param1);
         }
      }
   }
}

class InstanceBlocker
{
   
   public function InstanceBlocker()
   {
      super();
   }
}
