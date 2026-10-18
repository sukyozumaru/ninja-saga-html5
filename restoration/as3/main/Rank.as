package
{
   import bitemycode.facebook.FBUser;
   import com.utils.CreateFilter;
   import com.utils.GF;
   import com.utils.LoadPhoto;
   import com.utils.Out;
   import de.polygonal.ds.HashMap;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.filters.ColorMatrixFilter;
   import flash.text.TextField;
   import flash.utils.Timer;
   import ninjasaga.Account;
   import ninjasaga.Central;
   import ninjasaga.data.AMFData;
   import ninjasaga.data.AppData;
   import ninjasaga.data.ButtonData;
   import ninjasaga.data.DBCharacterData;
   import ninjasaga.data.DailyTaskData;
   import ninjasaga.data.Timeline;
   import ninjasaga.dbclass.DBCharacter;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol3140")]
   public class Rank extends MovieClip
   {
      
      public var display_8:MovieClip;
      
      public var errormc:MovieClip;
      
      public var seqTxt_9:TextField;
      
      public var display_9:MovieClip;
      
      public var seqTxt_8:TextField;
      
      public var display_10:MovieClip;
      
      public var blackBlank:MovieClip;
      
      public var seqTxt_7:TextField;
      
      public var seqTxt_6:TextField;
      
      public var seqTxt_5:TextField;
      
      public var nextPageBtn:MovieClip;
      
      public var seqTxt_4:TextField;
      
      public var display_2:MovieClip;
      
      public var seqTxt_3:TextField;
      
      public var display_3:MovieClip;
      
      public var seqTxt_2:TextField;
      
      public var seqTxt_1:TextField;
      
      public var display_1:MovieClip;
      
      public var display_6:MovieClip;
      
      public var btnReqPermission:MovieClip;
      
      public var display_7:MovieClip;
      
      public var prevBtn:MovieClip;
      
      public var display_4:MovieClip;
      
      public var display_5:MovieClip;
      
      public var nextBtn:MovieClip;
      
      public var back:MovieClip;
      
      public var prevPageBtn:MovieClip;
      
      private const NUM_OF_FRIENDS:uint = 9;
      
      private const NUM_OF_HIGH_RANK:uint = 3;
      
      private var selectedRecruitFdMc:MovieClip;
      
      private var usersMap:HashMap = new HashMap();
      
      private var photoHash:HashMap = new HashMap();
      
      private var friendsData:Array;
      
      private var myPos:uint = 0;
      
      private var curPos:int = 3;
      
      private var targetCharacterId:uint;
      
      private var targetSourceId:String;
      
      private var cbFn:Function;
      
      private var isCalling:Boolean = false;
      
      private var sessionKey:String;
      
      private var charId:uint;
      
      private var visitEnabled:Boolean = false;
      
      private var _frameName:String = null;
      
      private var dimFilter:ColorMatrixFilter = CreateFilter.getSaturationFilter(0);
      
      private var displayRetryTimer:Timer;
      
      private var retryDisplayFriendList:Array;
      
      public function Rank()
      {
         super();
         addFrameScript(0,this.frame1,4,this.frame5,8,this.frame9);
         this.displayRetryTimer = new Timer(500);
         this.displayRetryTimer.addEventListener(TimerEvent.TIMER,this.onTimerRetryDisplayFriendListUpdate);
      }
      
      public function init(param1:String = null) : void
      {
         this._frameName = param1;
         if(AppData.type == AppData.RR)
         {
            this.gotoAndStop("rr");
         }
         else
         {
            this.gotoAndStop("fb");
         }
      }
      
      public function initPlatform() : void
      {
         var _loc1_:int = 0;
         var _loc2_:* = undefined;
         var _loc3_:Array = null;
         var _loc4_:String = null;
         _loc1_ = 0;
         while(_loc1_ < this.NUM_OF_FRIENDS)
         {
            _loc2_ = this["display_" + (_loc1_ + 1)];
            _loc2_["btnRecruit"].visible = false;
            _loc2_["btnVisit"].visible = false;
            _loc2_["btnChallenge"].visible = false;
            _loc2_["fbNameTxt"].text = "";
            _loc2_["levelTxt"].text = "-";
            _loc2_["nameTxt"].text = "";
            _loc2_["titleTxt"].text = "";
            _loc1_++;
         }
         this["nextBtn"].gotoAndStop(1);
         this["nextPageBtn"].gotoAndStop(1);
         this["prevBtn"].gotoAndStop(1);
         this["prevPageBtn"].gotoAndStop(1);
         Central.main.initButton(this["btnReqPermission"],this.onClickShowFriend,Central.main.langLib.get(2000)[0]);
         this["btnReqPermission"].visible = true;
         this["blackBlank"].visible = true;
         if(Central.main.extraData.friend_list_avtice == true)
         {
            this["errormc"].visible = false;
            this["back"].visible = false;
         }
         else
         {
            this["errormc"].visible = true;
            if(AppData.lang == AppData.ZH)
            {
               this["errormc"]["errormiszh"].visible = true;
               this["errormc"]["errormisen"].visible = false;
            }
            else
            {
               this["errormc"]["errormisen"].visible = true;
               this["errormc"]["errormiszh"].visible = false;
            }
         }
         switch(AppData.type)
         {
            case AppData.FB:
               if(this._frameName == null)
               {
                  Central.main.getAppFBFriends(this.gotFacebookAppFriends);
               }
               else
               {
                  if(Central.sns.friendList == null)
                  {
                     return;
                  }
                  if(Central.sns.friendList.length <= 0)
                  {
                     return;
                  }
                  _loc3_ = Central.sns.friendList;
                  _loc4_ = "\'" + String(FBUser.uid) + "\'";
                  this.usersMap.insert(FBUser.uid,{
                     "uid":FBUser.uid,
                     "pic_square":FBUser.pic,
                     "name":FBUser.username
                  });
                  _loc1_ = 0;
                  while(_loc1_ < _loc3_.length)
                  {
                     _loc4_ += ",\'" + _loc3_[_loc1_].uid + "\'";
                     this.usersMap.insert(_loc3_[_loc1_].uid,_loc3_[_loc1_]);
                     _loc1_++;
                  }
                  if(Central.sns.friendsData == null)
                  {
                     return;
                  }
                  if(Central.sns.friendsData.length <= 0)
                  {
                     return;
                  }
                  this.updateFrdList(Central.sns.friendsData);
               }
               break;
            case AppData.OK:
               Central.sns.okConnector.conn.getFriends(this.gotFacebookAppFriends);
               break;
            case AppData.MP:
               Central.sns.mpConnector.conn.getFriends(this.gotFacebookAppFriends);
               break;
            default:
               Central.sns.getFriendList(this.gotFacebookAppFriends);
         }
         Central.main.addFriendListObserver(this);
         Central.main.addFriendPermissionObserver(this);
         Central.main.callJS("checkWhatPermissions");
      }
      
      private function clearSNSFriendList() : void
      {
         Central.sns.friendList = null;
      }
      
      private function gotFacebookAppFriends(param1:Array) : void
      {
         var _loc2_:uint = 0;
         if(Central.sns.friendList)
         {
            return;
         }
         Central.sns.friendList = param1;
         if(param1 == null || param1.length <= 0)
         {
            _loc2_ = 0;
            while(_loc2_ < this.NUM_OF_FRIENDS)
            {
               this["seqTxt_" + String(_loc2_ + 1)].text = "";
               if(AppData.type == AppData.RR)
               {
                  this["display_" + String(_loc2_ + 1)].gotoAndStop("invite_rr");
               }
               else
               {
                  this["display_" + String(_loc2_ + 1)].gotoAndStop("invite_fb");
               }
               _loc2_++;
            }
            if(AppData.type == AppData.RR)
            {
               Central.main.initButton(this["display_10"],this.onClickInviteRR,ButtonData.INVITEFRIENDS);
            }
            else
            {
               Central.main.initButton(this["display_10"],this.onClickInviteFB,Central.main.langLib.get(1668)[1]);
            }
            Central.main.disableButton(this["nextBtn"],this.next,null);
            Central.main.disableButton(this["nextPageBtn"],this.nextPage,null);
            Central.main.disableButton(this["prevBtn"],this.prev,null);
            Central.main.disableButton(this["prevPageBtn"],this.prevPage,null);
            return;
         }
         var _loc3_:String = "\'" + String(FBUser.uid) + "\'";
         this.usersMap.insert(FBUser.uid,{
            "uid":FBUser.uid,
            "pic_square":FBUser.pic,
            "name":FBUser.username
         });
         _loc2_ = 0;
         while(_loc2_ < param1.length)
         {
            _loc3_ += ",\'" + param1[_loc2_].uid + "\'";
            this.usersMap.insert(param1[_loc2_].uid,param1[_loc2_]);
            _loc2_++;
         }
         trace("Jane..........uidStr.length = " + _loc3_.length);
         Central.main.amfClient.service("FacebookService.getFriendsData",[Account.getAccountSessionKey(),_loc3_],this.gotFriendsData);
      }
      
      private function gotFriendsData(param1:Object) : void
      {
         if(String(param1.status) == AMFData.STATUS_ERROR)
         {
            Out.error(this,"gotFriendsData :: error code " + String(param1.error));
            return;
         }
         Central.sns.friendsData = param1.result as Array;
         this.updateFrdList(param1.result);
      }
      
      private function updateFrdList(param1:Array) : void
      {
         var _loc2_:MovieClip = null;
         var _loc3_:uint = 0;
         var _loc4_:MovieClip = null;
         var _loc6_:Object = null;
         var _loc7_:Boolean = false;
         var _loc8_:Object = null;
         if(this._frameName == "fb")
         {
            _loc7_ = false;
            _loc3_ = 0;
            while(_loc3_ < this.NUM_OF_HIGH_RANK)
            {
               _loc2_ = this["display_" + (_loc3_ + 1)];
               if(!_loc2_)
               {
                  _loc7_ = true;
                  break;
               }
               if(!_loc2_["fbNameTxt"])
               {
                  _loc7_ = true;
                  break;
               }
               if(!_loc2_["nameTxt"])
               {
                  _loc7_ = true;
                  break;
               }
               if(!_loc2_["levelTxt"])
               {
                  _loc7_ = true;
                  break;
               }
               _loc3_++;
            }
            if(_loc7_)
            {
               this.displayRetryTimer.reset();
               this.displayRetryTimer.start();
               this.retryDisplayFriendList = param1;
               return;
            }
         }
         this.displayRetryTimer.stop();
         this.friendsData = [];
         this.friendsData = param1;
         var _loc5_:int = int(Central.main.getMainChar().getLevel());
         this.friendsData.sortOn(["character_level","character_xp"],[Array.DESCENDING | Array.NUMERIC,Array.DESCENDING | Array.NUMERIC]);
         _loc3_ = 0;
         while(_loc3_ < this.friendsData.length)
         {
            this.friendsData[_loc3_].hasRecruited = this.friendsData[_loc3_].recruit_last_time != null ? true : false;
            _loc3_++;
         }
         if(this.friendsData)
         {
            _loc3_ = 0;
            while(_loc3_ < this.NUM_OF_HIGH_RANK)
            {
               _loc2_ = this["display_" + (_loc3_ + 1)];
               if(this.friendsData[_loc3_])
               {
                  _loc2_.charId = this.friendsData[_loc3_].character_id;
                  _loc2_.sourceId = this.friendsData[_loc3_].source_id;
                  _loc6_ = this.usersMap.find(this.friendsData[_loc3_].source_id);
                  _loc2_["fbNameTxt"].text = this.usersMap.find(this.friendsData[_loc3_].source_id).name;
                  _loc2_["nameTxt"].text = this.friendsData[_loc3_].character_name;
                  _loc2_["levelTxt"].text = this.friendsData[_loc3_].character_level;
                  _loc8_ = Central.main.recruitFriendPrice(this.friendsData[_loc3_].character_level);
                  _loc2_.payType = _loc8_.payType;
                  _loc2_.recruitPrice = _loc8_.recruitPrice;
                  _loc2_.gotoAndStop("highlight");
                  _loc4_ = new MovieClip();
                  _loc2_["photoHolder"].addChild(_loc4_);
                  if(this.usersMap.find(this.friendsData[_loc3_].source_id).pic_square == "" || !this.usersMap.find(this.friendsData[_loc3_].source_id).pic_square)
                  {
                     _loc4_.addChild(new DummyPhoto());
                  }
                  else
                  {
                     LoadPhoto.getInstance().load(this.usersMap.find(this.friendsData[_loc3_].source_id).pic_square,_loc4_);
                  }
                  if(this.friendsData[_loc3_].source_id != FBUser.uid && Boolean(this.friendsData[_loc3_].source_id))
                  {
                     if(Account.getAccountType() == Account.FREE && this.friendsData[_loc3_].recruit_last_time != null)
                     {
                        Central.main.disableButton(_loc2_["btnRecruit"],this.onClickRecruit,ButtonData.RECRUIT_FRIEND);
                        _loc2_["btnRecruit"].filters = [this.dimFilter];
                     }
                     else
                     {
                        Central.main.initButton(_loc2_["btnRecruit"],this.onClickRecruit,ButtonData.RECRUIT_FRIEND);
                     }
                     _loc2_["btnRecruit"].visible = true;
                     Central.main.initButton(_loc2_["btnVisit"],this.onClickVisit,ButtonData.VISIT);
                     _loc2_["btnVisit"].visible = true;
                  }
                  else
                  {
                     _loc2_["btnRecruit"].gotoAndStop(1);
                     _loc2_["btnRecruit"].visible = false;
                     _loc2_["btnVisit"].gotoAndStop(1);
                     _loc2_["btnVisit"].visible = false;
                     _loc2_["btnChallenge"].visible = false;
                  }
               }
               _loc3_++;
            }
            if(this.friendsData.length > this.NUM_OF_HIGH_RANK)
            {
               this.updateDisplay();
            }
            else
            {
               _loc3_ = this.friendsData.length;
               while(_loc3_ < this.NUM_OF_FRIENDS)
               {
                  this["seqTxt_" + String(_loc3_ + 1)].text = "";
                  if(AppData.type == AppData.RR)
                  {
                     this["display_" + String(_loc3_ + 1)].gotoAndStop("invite_rr");
                  }
                  else
                  {
                     this["display_" + String(_loc3_ + 1)].gotoAndStop("invite_fb");
                  }
                  _loc3_++;
               }
               Central.main.disableButton(this["nextBtn"],this.next,null);
               Central.main.disableButton(this["nextPageBtn"],this.nextPage,null);
               Central.main.disableButton(this["prevBtn"],this.prev,null);
               Central.main.disableButton(this["prevPageBtn"],this.prevPage,null);
            }
         }
         else
         {
            _loc3_ = 0;
            while(_loc3_ < this.NUM_OF_FRIENDS)
            {
               this["seqTxt_" + String(_loc3_ + 1)].text = "";
               if(AppData.type == AppData.RR)
               {
                  this["display_" + String(_loc3_ + 1)].gotoAndStop("invite_rr");
               }
               else
               {
                  this["display_" + String(_loc3_ + 1)].gotoAndStop("invite_fb");
               }
               _loc3_++;
            }
            Central.main.disableButton(this["nextBtn"],this.next,null);
            Central.main.disableButton(this["nextPageBtn"],this.nextPage,null);
            Central.main.disableButton(this["prevBtn"],this.prev,null);
            Central.main.disableButton(this["prevPageBtn"],this.prevPage,null);
         }
         this.visitEnabled = true;
         this.updateDisplay();
      }
      
      private function clearDisplay() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:MovieClip = null;
         _loc1_ = this.NUM_OF_HIGH_RANK;
         while(_loc1_ < this.NUM_OF_FRIENDS)
         {
            _loc2_ = this["display_" + (_loc1_ + 1)];
            _loc2_.gotoAndStop("idle");
            if(_loc2_.currentLabel == "idle")
            {
               _loc2_["nameTxt"].text = "";
               _loc2_["fbNameTxt"].text = "";
               _loc2_["levelTxt"].text = "";
               if(_loc2_["photoHolder"].photo)
               {
                  GF.removeAllChild(_loc2_["photoHolder"]);
               }
               _loc2_["btnRecruit"].filters = null;
               _loc2_["btnRecruit"].visible = false;
               _loc2_["btnVisit"].visible = false;
               _loc2_["btnChallenge"].visible = false;
            }
            _loc1_++;
         }
      }
      
      private function clearAllDisplay() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:MovieClip = null;
         _loc1_ = 0;
         while(_loc1_ < this.NUM_OF_FRIENDS)
         {
            this["seqTxt_" + String(_loc1_ + 1)].text = String(_loc1_ + 1);
            _loc2_ = this["display_" + (_loc1_ + 1)];
            _loc2_.gotoAndStop("idle");
            if(_loc2_.currentLabel == "idle")
            {
               _loc2_["nameTxt"].text = "";
               _loc2_["fbNameTxt"].text = "";
               _loc2_["levelTxt"].text = "";
               if(_loc2_["photoHolder"].photo)
               {
                  GF.removeAllChild(_loc2_["photoHolder"]);
               }
               _loc2_["btnRecruit"].filters = null;
               _loc2_["btnRecruit"].visible = false;
               _loc2_["btnVisit"].visible = false;
               _loc2_["btnChallenge"].visible = false;
            }
            _loc1_++;
         }
      }
      
      public function updateDisplay() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:MovieClip = null;
         var _loc3_:MovieClip = null;
         var _loc4_:uint = 0;
         var _loc7_:Object = null;
         var _loc5_:uint = this.NUM_OF_HIGH_RANK;
         var _loc6_:int = int(Central.main.getMainChar().getLevel());
         this.clearDisplay();
         if(this.friendsData.length < this.NUM_OF_FRIENDS)
         {
            _loc4_ = this.NUM_OF_HIGH_RANK;
         }
         else
         {
            _loc4_ = this.curPos + (this.NUM_OF_FRIENDS - this.NUM_OF_HIGH_RANK) > this.friendsData.length ? uint(this.friendsData.length - (this.NUM_OF_FRIENDS - this.NUM_OF_HIGH_RANK)) : uint(this.curPos);
         }
         _loc1_ = _loc4_;
         while(_loc1_ < _loc4_ + (this.NUM_OF_FRIENDS - this.NUM_OF_HIGH_RANK))
         {
            this["seqTxt_" + (_loc5_ + 1)].text = String(_loc1_ + 1);
            _loc2_ = this["display_" + (_loc5_ + 1)];
            if(_loc1_ < this.friendsData.length)
            {
               _loc2_.charId = this.friendsData[_loc1_].character_id;
               _loc2_.sourceId = this.friendsData[_loc1_].source_id;
               _loc2_.hasRecruited = this.friendsData[_loc1_].hasRecruited;
               _loc2_["fbNameTxt"].text = this.usersMap.find(this.friendsData[_loc1_].source_id).name;
               _loc2_["nameTxt"].text = this.friendsData[_loc1_].character_name;
               _loc2_["levelTxt"].text = this.friendsData[_loc1_].character_level;
               _loc7_ = Central.main.recruitFriendPrice(this.friendsData[_loc1_].character_level);
               _loc2_.payType = _loc7_.payType;
               _loc2_.recruitPrice = _loc7_.recruitPrice;
               if(this.photoHash.containsKey(this.friendsData[_loc1_].source_id))
               {
                  _loc3_ = this.photoHash.find(this.friendsData[_loc1_].source_id);
               }
               else
               {
                  _loc3_ = new MovieClip();
                  if(this.usersMap.find(this.friendsData[_loc1_].source_id).pic_square == "")
                  {
                     _loc3_.addChild(new DummyPhoto());
                  }
                  else
                  {
                     LoadPhoto.getInstance().load(this.usersMap.find(this.friendsData[_loc1_].source_id).pic_square,_loc3_);
                  }
               }
               _loc2_["photoHolder"].photo = _loc2_["photoHolder"].addChild(_loc3_);
               if(this.friendsData[_loc1_].source_id != FBUser.uid)
               {
                  if(this.visitEnabled)
                  {
                     if(Account.getAccountType() == Account.FREE && Boolean(this.friendsData[_loc1_].hasRecruited))
                     {
                        Central.main.disableButton(_loc2_["btnRecruit"],this.onClickRecruit,ButtonData.RECRUIT_FRIEND);
                        _loc2_["btnRecruit"].filters = [this.dimFilter];
                     }
                     else
                     {
                        Central.main.initButton(_loc2_["btnRecruit"],this.onClickRecruit,ButtonData.RECRUIT_FRIEND);
                     }
                     _loc2_["btnRecruit"].visible = true;
                     Central.main.initButton(_loc2_["btnVisit"],this.onClickVisit,ButtonData.VISIT);
                     _loc2_["btnVisit"].visible = true;
                  }
               }
               else
               {
                  _loc2_["btnRecruit"].gotoAndStop(1);
                  _loc2_["btnRecruit"].visible = false;
                  _loc2_["btnVisit"].gotoAndStop(1);
                  _loc2_["btnVisit"].visible = false;
                  _loc2_["btnChallenge"].visible = false;
               }
            }
            else
            {
               this["seqTxt_" + (_loc5_ + 1)].text = "";
               if(AppData.type == AppData.RR)
               {
                  _loc2_.gotoAndStop("invite_rr");
               }
               else
               {
                  _loc2_.gotoAndStop("invite_fb");
               }
            }
            _loc5_++;
            _loc1_++;
         }
         if(AppData.type == AppData.RR)
         {
            Central.main.initButton(this["display_10"],this.onClickInviteRR,ButtonData.INVITEFRIENDS);
         }
         else
         {
            Central.main.initButton(this["display_10"],this.onClickInviteFB,Central.main.langLib.get(1668)[1]);
         }
         this.initPageBtn();
      }
      
      private function initPageBtn() : void
      {
         if(this.curPos + (this.NUM_OF_FRIENDS - this.NUM_OF_HIGH_RANK) >= this.friendsData.length)
         {
            Central.main.disableButton(this["nextBtn"],this.next,null);
            Central.main.disableButton(this["nextPageBtn"],this.nextPage,null);
            this["nextBtn"].filters = [this.dimFilter];
            this["nextPageBtn"].filters = [this.dimFilter];
         }
         else
         {
            Central.main.initButton(this["nextBtn"],this.next,null);
            Central.main.initButton(this["nextPageBtn"],this.nextPage,null);
            this["nextBtn"].filters = null;
            this["nextPageBtn"].filters = null;
         }
         if(this.curPos == this.NUM_OF_HIGH_RANK)
         {
            Central.main.disableButton(this["prevBtn"],this.prev,null);
            Central.main.disableButton(this["prevPageBtn"],this.prevPage,null);
            this["prevBtn"].filters = [this.dimFilter];
            this["prevPageBtn"].filters = [this.dimFilter];
         }
         else
         {
            Central.main.initButton(this["prevBtn"],this.prev,null);
            Central.main.initButton(this["prevPageBtn"],this.prevPage,null);
            this["prevBtn"].filters = null;
            this["prevPageBtn"].filters = null;
         }
      }
      
      private function next(param1:MouseEvent) : void
      {
         ++this.curPos;
         this.curPos = this.curPos + (this.NUM_OF_FRIENDS - this.NUM_OF_HIGH_RANK) > this.friendsData.length ? int(this.friendsData.length - (this.NUM_OF_FRIENDS - this.NUM_OF_HIGH_RANK)) : this.curPos;
         this.updateDisplay();
      }
      
      private function prev(param1:MouseEvent) : void
      {
         --this.curPos;
         if(this.curPos < this.NUM_OF_HIGH_RANK)
         {
            this.curPos = this.NUM_OF_HIGH_RANK;
         }
         this.updateDisplay();
      }
      
      private function nextPage(param1:MouseEvent) : void
      {
         this.curPos += this.NUM_OF_FRIENDS - this.NUM_OF_HIGH_RANK;
         this.curPos = this.curPos + (this.NUM_OF_FRIENDS - this.NUM_OF_HIGH_RANK) > this.friendsData.length ? int(this.friendsData.length - (this.NUM_OF_FRIENDS - this.NUM_OF_HIGH_RANK)) : this.curPos;
         this.updateDisplay();
      }
      
      private function prevPage(param1:MouseEvent) : void
      {
         this.curPos -= this.NUM_OF_FRIENDS - this.NUM_OF_HIGH_RANK;
         if(this.curPos < this.NUM_OF_HIGH_RANK)
         {
            this.curPos = this.NUM_OF_HIGH_RANK;
         }
         this.updateDisplay();
      }
      
      private function onClickInviteRR(param1:MouseEvent) : void
      {
         Central.main.tracking.trackClick(Central.main.tracking.TRACK_INVITE,Central.main.tracking.SA_INVITE_RANK);
         Central.main.showInviteFriend();
      }
      
      private function onClickInviteFB(param1:MouseEvent) : void
      {
         if(Central.main.checkGameStatus() == Timeline.BATTLE)
         {
            Central.main.showInfo(Central.main.langLib.get(1668)[0]);
            return;
         }
         if(Central.mission.onMission() != null)
         {
            Central.main.showInfo(Central.main.langLib.get(1668)[0]);
            return;
         }
         if(Central.main.checkGameStatus() != Timeline.BATTLE)
         {
            Central.main.tracking.trackBuildingSelect("InviteReward");
            Central.panel.getInstance().show("invitFrdPanel");
         }
      }
      
      private function onClickShowFriend(param1:MouseEvent) : void
      {
         Central.main.callJS("requestPermission","user_friends");
      }
      
      private function onClickRecruit(param1:MouseEvent) : void
      {
         if(Central.main.checkGameStatus() == Timeline.BATTLE || Central.main.checkGameStatus() == Timeline.MISSION)
         {
            Central.main.showOk(Central.main.langLib.get(532));
            return;
         }
         if(Central.main.getPartyNpc() != null)
         {
            if(Central.main.getPartyNpc().length + Central.main.partyMembers.length >= 2)
            {
               Central.main.showOk(Central.main.langLib.get(40));
               return;
            }
         }
         else if(Central.main.partyMembers.length >= 2)
         {
            Central.main.showOk(Central.main.langLib.get(39));
            return;
         }
         var _loc2_:MovieClip = MovieClip(param1.currentTarget.parent);
         this.selectedRecruitFdMc = _loc2_;
         var _loc3_:Array = Central.main.getRecruitedFriends();
         var _loc4_:String = "";
         _loc4_ = _loc2_.sourceId + "_" + _loc2_.charId;
         if(_loc3_.indexOf(_loc4_) >= 0)
         {
            Central.main.showOk(Central.main.langLib.get(40));
            return;
         }
         switch(_loc2_.payType)
         {
            case Central.main.PAY_TOKEN:
               if(Account.getAccountBalance() < _loc2_.recruitPrice)
               {
                  Central.main.getGoldToken(Central.main.langLib.get(1405),Central.main.gotoPaymentGateway,"token");
                  return;
               }
               Central.main.showPayTokenConfirm(Central.main.langLib.get(1777)[0],_loc2_.recruitPrice,this.payToRecruit,"recruit_friends_2");
               break;
            case Central.main.PAY_GOLD:
               this.payToRecruit();
         }
      }
      
      private function payToRecruit() : void
      {
         Central.main.showAmfLoading();
         Central.main.amfClient.service("FacebookService.payToRecruit",[Account.getAccountSessionKey(),this.selectedRecruitFdMc.charId],this.getRecruitResponse);
      }
      
      private function getRecruitResponse(param1:Object) : void
      {
         var _loc3_:int = 0;
         var _loc2_:String = "";
         if(Central.main.validateAmfResponse(param1))
         {
            if(param1.hasOwnProperty("failreason"))
            {
               Central.main.showInfo(Central.main.langLib.get(1843));
               Central.main.hideAmfLoading();
               return;
            }
            switch(this.selectedRecruitFdMc.payType)
            {
               case Central.main.PAY_TOKEN:
                  Account.balance = Account.getAccountBalance() - this.selectedRecruitFdMc.recruitPrice;
                  break;
               case Central.main.PAY_GOLD:
            }
            Central.main.updateMenu();
            _loc2_ = this.selectedRecruitFdMc.sourceId + "_" + this.selectedRecruitFdMc.charId;
            Central.main.setRecruitedFriends(_loc2_);
            Central.main.showAmfLoading();
            if(Account.getAccountType() == Account.FREE)
            {
               Central.main.disableButton(this.selectedRecruitFdMc["btnRecruit"],this.onClickRecruit,ButtonData.RECRUIT_FRIEND);
               this.selectedRecruitFdMc["btnRecruit"].filters = [this.dimFilter];
               _loc3_ = 0;
               while(_loc3_ < this.friendsData.length)
               {
                  if(this.selectedRecruitFdMc.charId == this.friendsData[_loc3_].character_id)
                  {
                     this.friendsData[_loc3_].hasRecruited = true;
                     break;
                  }
                  _loc3_++;
               }
            }
            Central.main.saveRecruitRecord(this.selectedRecruitFdMc.sourceId,this.selectedRecruitFdMc.charId,0);
            Central.main.amfClient.service("CharacterDAO.getCharacterProfileById",[Account.getAccountSessionKey(),this.selectedRecruitFdMc.charId,true],this.onAmfGetCharacterResult);
         }
      }
      
      private function onAmfGetCharacterResult(param1:Object) : void
      {
         var _loc2_:String = null;
         var _loc4_:Object = null;
         var _loc5_:DBCharacter = null;
         var _loc3_:Array = [];
         if(Central.main.validateAmfResponse(param1))
         {
            _loc5_ = Central.main.dataParser.parseRawCharacter(param1.result,true);
            _loc2_ = _loc5_.character_name;
            Central.mission.updateDailyTask(DailyTaskData.TYPE_RECRUIT,1);
            Central.main.tracking.trackStartAction(Central.main.tracking.SA_RECRUIT_FRIEND);
            Central.main.showInfo(_loc2_ + " " + Central.main.langLib.get(59));
            Central.main.recruitFriends([_loc5_]);
            Central.main.updateMenu();
            Central.main.hideAmfLoading();
         }
      }
      
      private function onClickVisit(param1:MouseEvent) : void
      {
         Central.main.tracking.generalTrack(Central.main.tracking.TRACK_VISIT_FRIEND,Central.main.tracking.TRACK_VISIT_TOTAL,Central.main.tracking.TRACK_VISIT_NUMBER);
         var _loc2_:MovieClip = MovieClip(param1.currentTarget.parent);
         Central.main.visitFriend(_loc2_.charId,_loc2_.sourceId);
      }
      
      public function initInviteBtnRR(param1:MovieClip) : void
      {
         Central.main.initButton(param1["btnInvite"],this.onClickInviteRR,ButtonData.INVITEFRIENDS);
      }
      
      public function initInviteBtnFB(param1:MovieClip) : void
      {
         Central.main.initButton(param1["btnInvite"],this.onClickInviteFB,Central.main.langLib.get(1668)[1]);
      }
      
      public function notifyFriendListUpdate(param1:Array) : void
      {
         var _loc2_:String = "fb";
         this._frameName = _loc2_;
         this.gotoAndStop(_loc2_);
         this.clearAllDisplay();
         this.clearSNSFriendList();
         this.gotFacebookAppFriends(param1);
      }
      
      public function notifyFriendPermissionUpdate(param1:Boolean) : void
      {
         var _loc2_:MovieClip = this["btnReqPermission"];
         var _loc3_:MovieClip = this["blackBlank"];
         if(!_loc2_)
         {
            return;
         }
         if(!_loc3_)
         {
            return;
         }
         _loc2_.visible = !param1;
         _loc3_.visible = !param1;
      }
      
      private function onTimerRetryDisplayFriendListUpdate(param1:TimerEvent) : void
      {
         this.updateFrdList(this.retryDisplayFriendList);
      }
      
      private function getRecruitRank() : int
      {
         var _loc1_:int = int(Central.main.getMainChar().getData(DBCharacterData.RANK));
         switch(_loc1_)
         {
            case 2:
            case 4:
            case 6:
               _loc1_++;
         }
         return _loc1_;
      }
      
      internal function frame1() : *
      {
         this.stop();
      }
      
      internal function frame5() : *
      {
         this.initPlatform();
         this.stop();
      }
      
      internal function frame9() : *
      {
         this.initPlatform();
         this.stop();
      }
   }
}

