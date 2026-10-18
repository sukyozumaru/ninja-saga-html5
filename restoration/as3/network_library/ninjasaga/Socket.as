package ninjasaga
{
   import com.dynamicflash.util.Base64;
   import com.pnwrain.flashsocket.FlashSocket;
   import com.pnwrain.flashsocket.events.FlashSocketEvent;
   import com.utils.GF;
   import com.utils.Out;
   import com.utils.TextFilter;
   import de.polygonal.ds.HashMap;
   import flash.utils.ByteArray;
   import ninjasaga.data.AppData;
   import ninjasaga.data.DBCharacterData;
   import ninjasaga.data.Timeline;
   import ninjasaga.net.Client;
   
   public final class Socket
   {
      
      private var server:FlashSocket;
      
      private var _room:String;
      
      private var _isLoggedIn:Boolean = false;
      
      private var PvpDisconnect:Boolean = false;
      
      private var nowRoomId:int;
      
      private var nowZoneId:int;
      
      private var nowGameId:int;
      
      private var backFromP:Boolean = false;
      
      private var hostLeave:Boolean = false;
      
      private var lobbyId:int;
      
      private var backupPrivateRoomId:int;
      
      private var startBattle:Boolean = false;
      
      private var log_time:uint;
      
      private var disconnect:Boolean = false;
      
      public var changeServerStart:Boolean = false;
      
      private var lobbyArr:Array = ["Lobby0","Lobby1","Lobby2","Lobby3","Lobby4","Lobby5","Lobby6","Lobby7","Lobby8","Lobby9"];
      
      private var serverName:String = "ns_dev_1";
      
      private var serverArr:Array;
      
      private var serverObj:Object;
      
      private var debugMode:Boolean = false;
      
      private var debugId:int = 1;
      
      private const LB_CHAT_MSG:String = "lobby_chat_message";
      
      private const RM_JOIN:String = "join_room";
      
      private const RM_CHAT_MSG:String = "room_chat_message";
      
      private const BATTLE_START:String = "battle_start";
      
      private const BATTLE_MSG:String = "battle_msg";
      
      private const AUTH:String = "auth";
      
      private const COUNT:String = "count";
      
      private const PRM_MSG:String = "private_room_message";
      
      private const READY:String = "ready";
      
      private const CANCEL_READY:String = "cancel_ready";
      
      private const KICK_USER:String = "kick_user";
      
      private const LEAVE_ROOM:String = "leave_room";
      
      private const UPDATE_TEAM:String = "updateTeam";
      
      private const SYSTEM_GET_USER:String = "system_get_user";
      
      private const START_SET:String = "start_set_team";
      
      private const RESET_READY:String = "reset_ready";
      
      private const BACK_DOOR_MESSAGE:String = "back_door_message";
      
      private const GET_ROOM_SUMMARY:String = "get_room_summary";
      
      private const ADMIN_MESSAGE:String = "admin_message";
      
      private const ADMIN_MESSAGE_TIMER:String = "admin_message_timer";
      
      private const ONLINE_COUNT:String = "online_count";
      
      private const DISCONNECT:String = "disconnect";
      
      public var debug_arr:Array = [];
      
      public var handShakeDebugArr:Array = [];
      
      private var create_room:Boolean = false;
      
      private var javaDisconnect:Boolean = false;
      
      public var secretCommandObj:Object = {"status":false};
      
      public var sercetCommandArr:Array = [];
      
      public var errorPlayerId:Array = [];
      
      public function Socket()
      {
         super();
         this.serverArr = [];
         this.serverObj = {};
      }
      
      public function init() : void
      {
      }
      
      public function setServer(param1:Array) : void
      {
         this.serverArr = param1;
         this.init();
      }
      
      public function secretCommand(param1:String) : void
      {
         var _loc2_:String = param1;
         var _loc3_:Array = _loc2_.split(" ");
         var _loc4_:String = _loc3_[0].slice(1,_loc3_[0].length);
         var _loc5_:int = this.sercetCommandArr.indexOf(_loc4_);
         var _loc6_:String = "";
         if(_loc5_ == 0)
         {
            this.secretCommandObj.status = true;
            _loc6_ = "Command Mode On";
         }
         if(this.secretCommandObj.status == true)
         {
            switch(_loc5_)
            {
               case 1:
                  this.secretCommandObj["ip"] = _loc3_[1];
                  _loc6_ = "Set Ip to " + this.secretCommandObj.ip;
                  break;
               case 2:
                  this.secretCommandObj["port"] = _loc3_[1];
                  _loc6_ = "Set port to " + this.secretCommandObj.port;
                  break;
               case 3:
                  _loc6_ = "ip:" + this.serverObj.ip + " port:" + this.serverObj.port;
                  break;
               case 4:
                  this.clearSecretCommand();
                  _loc6_ = "Reset";
                  break;
               case 5:
                  this.secretCommandObj.status = false;
                  _loc6_ = "Command Mode Off";
                  break;
               case 6:
                  this.secretCommandObj["ip"] = _loc3_[1];
                  this.secretCommandObj["port"] = _loc3_[2];
                  Central.panel.getInstance().curPanel.onCommandChangeServer();
            }
         }
         else
         {
            _loc6_ = "Command Mode Is Off";
         }
         _loc6_ = "<System>" + _loc6_;
         Central.panel.getInstance().curPanel.onIncomingRoomMessage(Base64.encode(_loc6_));
      }
      
      public function clearSecretCommand() : void
      {
         if(this.secretCommandObj.ip)
         {
            this.secretCommandObj.ip = "";
         }
         if(this.secretCommandObj.port)
         {
            this.secretCommandObj.port = "";
         }
      }
      
      public function setUpServer(param1:Array, param2:String, param3:Function) : void
      {
         this.debug_arr.push(" 1 ");
         this.serverObj = param1[0];
         if(this.secretCommandObj.status == true)
         {
            if(Boolean(this.secretCommandObj.ip) && this.secretCommandObj.ip != "")
            {
               this.serverObj.ip = this.secretCommandObj.ip;
            }
            if(Boolean(this.secretCommandObj.port) && this.secretCommandObj.port != "")
            {
               this.serverObj.port = this.secretCommandObj.port;
            }
         }
         if(this.errorPlayerId.indexOf(param2) >= 0)
         {
            this.serverObj = param1[2];
            Central.panel.getInstance().curPanel.problemPlayerGetin();
         }
         param3();
      }
      
      public function connect() : void
      {
         this.javaDisconnect = false;
         this.debug_arr.push(" 2 ");
         this.disconnect = false;
         Central.main.showAmfLoading();
         this.debug_arr.push("|| 3  >> " + this.serverObj.ip + " , 4 >>" + this.serverObj.port + " ||");
         this.server = new FlashSocket(this.serverObj.ip + ":" + this.serverObj.port,null,null,0,null,this.handShakeDebugArr);
         this.handShakeDebugArr = [];
         this.server.handShakeDebugArr = this.handShakeDebugArr;
         this.handShakeDebugArr.push("Time: " + Central.main.pvpDebugTime + " Time: " + Central.main.pvpDebugTime + " Socket: new FlashSocket >> ");
         this.debug_arr.push(" 5 , >> server >> " + this.server);
         var _loc1_:Object = this.server.getError();
         this.debug_arr.push("6 , >> " + _loc1_.url + "|| 7 , >> " + _loc1_.method);
         this.server.addEventListener(FlashSocketEvent.CONNECT,this.onConnectionResponse);
         this.server.addEventListener(FlashSocketEvent.MESSAGE,this.onMessage);
         this.server.addEventListener(FlashSocketEvent.IO_ERROR,this.onError);
         this.server.addEventListener(FlashSocketEvent.SECURITY_ERROR,this.onError);
         this.server.addEventListener(FlashSocketEvent.CLOSE,this.onConnectionClosedEvent);
         this.server.addEventListener(FlashSocketEvent.DISCONNECT,this.onConnectionClosedEvent);
      }
      
      public function changeServer(param1:int) : void
      {
      }
      
      private function onConnectionResponse(param1:*) : void
      {
         Out.debug("onConnectionResponse :: ","char=" + Central.main.getMainChar().getData(DBCharacterData.ID) + ">>>>> " + param1);
         Out.debug("onConnectionResponse object :: ","char=" + Central.main.getMainChar().getData(DBCharacterData.ID) + ">>>>> " + GF.printObject(param1));
         this.login();
      }
      
      private function login() : void
      {
         this.debug_arr.push(" 8 ");
         this.handShakeDebugArr.push("Time: " + Central.main.pvpDebugTime + " Socket: on Login, Send \'auth\' >> ");
         Out.debug("socket",Account.getAccountSessionKey() + ", char=" + Central.main.getMainChar().getData(DBCharacterData.ID));
         this.server.emit("auth",{"sessionKey":Account.getAccountSessionKey()});
      }
      
      public function getFSErrorArr() : Array
      {
         var _loc1_:Object = this.server.getError();
         return _loc1_.debugArr;
      }
      
      public function getHandShakeArr() : Array
      {
         return this.handShakeDebugArr;
      }
      
      public function getWSDebugArr() : Array
      {
         var canConnect:Boolean;
         var nullArr:Array = [];
         nullArr.push("null Arr");
         canConnect = true;
         try
         {
            return this.server.getWebSocketArr();
         }
         catch(err:Error)
         {
            canConnect = false;
         }
         if(canConnect == false)
         {
            return nullArr;
         }
         return nullArr;
      }
      
      private function onMessage(param1:FlashSocketEvent) : void
      {
         this.handShakeDebugArr.push("Time: " + Central.main.pvpDebugTime + " Socket: onMessage:" + param1.data.event + " >> ");
         switch(param1.data.event)
         {
            case this.AUTH:
               this.debug_arr.push(" 9 ");
               this.onLoginResponse(param1.data.status);
               break;
            case this.LB_CHAT_MSG:
               this.onLobbyMessageEvent(param1.data.message);
               break;
            case this.RM_CHAT_MSG:
               Out.debug("socket :: ","e.data >> " + GF.printObject(param1.data));
               if(param1.data.room == "lobby")
               {
                  this.onLobbyMessageEvent(param1.data.message);
               }
               else
               {
                  this.onPrivateMessageEvent(param1.data.message);
               }
               break;
            case this.ADMIN_MESSAGE:
               Central.main.onAdminMessage(this.processAdminMessage(param1.data.message));
               break;
            case this.ADMIN_MESSAGE_TIMER:
               Central.main.onAdminMessage(this.processAdminMessage(param1.data.message[AppData.lang]));
               break;
            case this.BATTLE_MSG:
               Central.main.waitingquick = false;
               this.onPluginMessageEvent(param1.data.message);
               break;
            case this.RM_JOIN:
               this.onJoinRoomEvent(param1.data);
               break;
            case this.COUNT:
               this.onGetUserCountResponse(param1.data.count);
               break;
            case this.READY:
               this.onPlayerReady(param1.data);
               break;
            case this.CANCEL_READY:
               this.onPlayerCancelReady(param1.data);
               break;
            case this.KICK_USER:
               this.onKickUser(param1.data);
               break;
            case this.LEAVE_ROOM:
               this.onPlayerLeave(param1.data);
               break;
            case this.SYSTEM_GET_USER:
               this.onGetUserCountResponse(param1.data);
               break;
            case this.UPDATE_TEAM:
               this.onUpdateTeam(param1.data);
               break;
            case this.START_SET:
               this.onstartSetTeam();
               break;
            case this.RESET_READY:
               this.onResetReady();
               break;
            case this.BACK_DOOR_MESSAGE:
               this.onServerMessage(param1.data);
               break;
            case this.GET_ROOM_SUMMARY:
               this.onGetRoomSummary(param1.data);
               break;
            case "destroy_battle":
               this.onDestoryBattle();
               break;
            case this.ONLINE_COUNT:
               this.onOnlineCount(param1.data.count);
         }
      }
      
      private function onDisconnect(param1:Object) : void
      {
      }
      
      private function onOnlineCount(param1:int) : void
      {
         Out.debug("","rex online count = " + param1);
         if(Central.main.checkGameStatus() == Timeline.PANEL)
         {
            if(Central.panel.getInstance().getCurPanelName() == "arena")
            {
               if(Central.panel.getInstance().curPanel)
               {
                  Central.panel.getInstance().curPanel.onPlayerCount(param1.toString());
               }
            }
         }
      }
      
      private function onDestoryBattle() : void
      {
         Central.main.pvpPlayerStatus = "custerDown";
         Central.battle.custerSerDisconnect();
      }
      
      private function onResetReady() : void
      {
         Central.panel.getInstance().curPanel.onResetReady();
      }
      
      private function onLoginResponse(param1:int) : void
      {
         var status:int = param1;
         this.debug_arr.push(" 10 ");
         this.handShakeDebugArr.push("Time: " + Central.main.pvpDebugTime + " Socket: onLoginResponse:" + status + " >> ");
         if(status == 1)
         {
            this.debug_arr.push(" 11 ");
            this._isLoggedIn = true;
            this.changeServerStart = false;
            Central.panel.getInstance().curPanel.play();
            Central.main.hideAmfLoading();
         }
         else
         {
            this.debug_arr.push(" 12 ");
            try
            {
               this.debug_arr.push(" 13 ");
            }
            catch(e:Error)
            {
               debug_arr.push(" 14 ");
            }
            this.onError(null);
         }
      }
      
      public function onServerMessage(param1:Object) : void
      {
         try
         {
            if(Central.panel.getInstance().getCurPanelName() == "arena")
            {
               Central.panel.getInstance().curPanel.onServerMessage(param1.msg);
            }
         }
         catch(e:Error)
         {
         }
      }
      
      private function getRoomSummaryRoomArraySingleObjectForDebug(param1:Array, param2:Array, param3:Array, param4:String, param5:int, param6:String) : Object
      {
         var _loc7_:Object = new Object();
         var _loc8_:Object = new Object();
         _loc8_.ta = param1;
         _loc8_.tb = param2;
         _loc8_.character_array = param3;
         _loc8_.room_name = param4;
         _loc8_.room_type = param5;
         _loc8_.has_password = param6;
         _loc7_.room_array = _loc8_;
         return _loc7_;
      }
      
      public function onGetRoomSummary(param1:Object) : void
      {
         var _loc8_:* = undefined;
         var _loc10_:Object = null;
         var _loc11_:Object = null;
         var _loc12_:Array = null;
         var _loc13_:Array = null;
         Out.debug("Socket::onGetRoomSummary","e >> " + GF.printObject(param1));
         var _loc2_:int = int(param1.pktver);
         if(_loc2_ != 1)
         {
            Out.debug("Socket::onGetRoomSummary","packetVersion does not match.  e >> " + GF.printObject(param1));
            return;
         }
         var _loc3_:Array = param1.room_array;
         var _loc4_:Array = param1.char_array;
         var _loc5_:int = int(param1.char_count);
         var _loc6_:Boolean = Boolean(param1.char_loaded);
         var _loc7_:HashMap = new HashMap();
         if(_loc4_ != null)
         {
            _loc8_ = 0;
            while(_loc8_ < _loc4_.length)
            {
               _loc10_ = new Object();
               _loc10_.charId = _loc4_[_loc8_].char_id;
               _loc10_.source = _loc4_[_loc8_].source;
               _loc10_.sourceId = _loc4_[_loc8_].source_id;
               _loc10_.charName = this.EncodeUtf16(_loc4_[_loc8_].char_name);
               _loc10_.charLevel = _loc4_[_loc8_].char_level;
               _loc10_.charSkillStr = _loc4_[_loc8_].char_skills;
               _loc10_.charElement1 = _loc4_[_loc8_].element1;
               _loc10_.charElement2 = _loc4_[_loc8_].element2;
               _loc10_.charElement3 = _loc4_[_loc8_].element3;
               _loc7_.insert(_loc10_.charId,_loc10_);
               _loc8_++;
            }
         }
         var _loc9_:Array = new Array();
         if(_loc3_ != null)
         {
            _loc8_ = 0;
            while(_loc8_ < _loc3_.length)
            {
               if(_loc3_[_loc8_].room_type != null)
               {
                  _loc11_ = new Object();
                  _loc11_.roomType = _loc3_[_loc8_].room_type;
                  _loc12_ = _loc3_[_loc8_].ta;
                  _loc13_ = _loc3_[_loc8_].tb;
                  _loc11_.teamA = _loc12_;
                  _loc11_.teamB = _loc13_;
                  _loc11_.roomName = _loc3_[_loc8_].room_name;
                  _loc11_.bPasswordLocked = _loc3_[_loc8_].has_password ? true : false;
                  _loc11_.sortRank = this.computeRoomRank(_loc12_,_loc13_,_loc11_.bPasswordLocked,parseInt(_loc11_.roomType));
                  _loc11_.quest = _loc3_[_loc8_].quest;
                  _loc9_.push(_loc11_);
               }
               _loc8_++;
            }
            _loc9_.sortOn("sortRank",Array.NUMERIC | Array.DESCENDING);
         }
         Out.debug("Socket::onGetRoomSummary","charCount=" + _loc5_ + ", bCharLoadSucceeded=" + _loc6_);
         Out.debug("Socket::onGetRoomSummary","charMap=" + _loc7_.dump());
         Out.debug("Socket::onGetRoomSummary","roomList=" + GF.printObject(_loc9_));
         Central.panel.getInstance().curPanel.updateRoomSummaryPanel(_loc9_,_loc7_,_loc6_);
      }
      
      private function computeRoomRank(param1:Array, param2:Array, param3:Boolean, param4:int) : int
      {
         var _loc5_:int = this.getFixedLengthArrayCountNotNull(param1);
         var _loc6_:int = this.getFixedLengthArrayCountNotNull(param2);
         var _loc7_:int = _loc5_ + _loc6_;
         var _loc8_:Boolean = _loc5_ >= _loc7_ && _loc6_ >= _loc7_;
         if(_loc8_)
         {
            return 0;
         }
         if(!param3)
         {
            _loc7_ += 7;
         }
         return _loc7_;
      }
      
      private function getFixedLengthArrayCountNotNull(param1:Array) : int
      {
         if(param1 == null)
         {
            return 0;
         }
         var _loc2_:* = 0;
         var _loc3_:int = 0;
         while(_loc3_ < param1.length)
         {
            if(param1[_loc3_] == null)
            {
               break;
            }
            if(param1[_loc3_] == "")
            {
               break;
            }
            _loc2_++;
            _loc3_++;
         }
         return _loc2_;
      }
      
      public function getUserCount() : void
      {
         this.server.send({"event":this.SYSTEM_GET_USER});
      }
      
      private function onGetUserCountResponse(param1:Object) : void
      {
         if(Central.main.checkGameStatus() == Timeline.PANEL)
         {
            if(Central.panel.getInstance().getCurPanelName() == "arena")
            {
               if(Central.panel.getInstance().curPanel)
               {
                  Central.panel.getInstance().curPanel.onPlayerCount(param1.users.toString());
               }
            }
         }
      }
      
      public function leaveRoom(param1:String = "") : void
      {
         this.joinLobby();
      }
      
      private function onJoinRoomEvent(param1:Object) : void
      {
         var _loc4_:String = null;
         var _loc5_:Array = null;
         var _loc6_:Array = null;
         var _loc7_:String = null;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         Out.debug("onJoinRoomEvent :: ","char=" + Central.main.getMainChar().getData(DBCharacterData.ID) + ", obj >>" + GF.printObject(param1));
         var _loc2_:String = param1.room_name;
         var _loc3_:Array = param1.character_array;
         trace("Phillip:Socket" + _loc2_);
         if(Central.main.PvpPlayerPlace == "PVE" && _loc2_ == "lobby")
         {
            Central.panel.getInstance().curPanel.joinLobby();
            return;
         }
         if(this.create_room == true)
         {
            Central.panel.getInstance().curPanel.creatRoom(_loc2_,_loc3_);
            this.create_room = false;
         }
         else if(this.create_room == false)
         {
            if(param1.status == 1)
            {
               _loc4_ = param1.characterId;
               _loc5_ = param1.ta;
               _loc6_ = param1.tb;
               _loc7_ = param1.creator;
               _loc8_ = int(param1.roomType);
               _loc9_ = int(param1.quest);
               if(_loc4_ == Central.main.getMainChar().getData("character_id"))
               {
                  if(Central.main.PvpPlayerPlace == "PVE")
                  {
                     Central.panel.getInstance().curPanel.selfJoinRoom(_loc2_,_loc4_,_loc3_,_loc5_,_loc6_,_loc7_,_loc8_,_loc9_);
                  }
                  else
                  {
                     Central.panel.getInstance().curPanel.selfJoinRoom(_loc2_,_loc4_,_loc3_,_loc5_,_loc6_,_loc7_,_loc8_);
                  }
               }
               else
               {
                  Central.panel.getInstance().curPanel.joinRoom(_loc2_,_loc4_,_loc3_,_loc5_,_loc6_,_loc7_,_loc8_);
               }
            }
            else
            {
               Central.panel.getInstance().curPanel.joinRoomFail(param1.status);
            }
         }
      }
      
      private function onPlayerReady(param1:Object) : void
      {
         Out.debug("","rex onPlayerReady");
         if(Central.main.pvpPlayerStatus == "waiting")
         {
            Out.debug("","rex to ClickReadyResponse");
            Central.panel.getInstance().curPanel.ClickReadyResponse(param1.character_array);
         }
      }
      
      private function onPlayerCancelReady(param1:Object) : void
      {
         if(param1 == null)
         {
            Out.debug(this,"onPlayerCancelReady, obj = null");
            return;
         }
         if(this.javaDisconnect == true)
         {
            Out.debug(this,"onPlayerCancelReady, javaIsDisconnect");
            return;
         }
         Out.debug(this,"onPlayerCancelReady >> " + param1.character_array + ", pvpPlayerStatus >> " + Central.main.pvpPlayerStatus);
         switch(Central.main.pvpPlayerStatus)
         {
            case "waiting":
               if(param1.character_array == null)
               {
                  Out.debug(this,"obj.character_array = null");
                  return;
               }
               if(Central.main.PvpPlayerPost != "quick")
               {
                  Central.panel.getInstance().curPanel.cancelReadyResponse(param1.character_array);
               }
               break;
            case "battleing":
               if(Central.main.PvpPlayerPost == "PVE")
               {
                  return;
               }
               Central.battle.cancelReadyResponse();
         }
      }
      
      private function onKickUser(param1:Object) : void
      {
         Out.debug("onKickUser :: "," obj >> " + GF.printObject(param1));
         Central.panel.getInstance().curPanel.onKickEvent(param1.character_id);
      }
      
      public function removePlayerOnList(param1:String) : void
      {
         var _loc2_:int = 1;
         while(_loc2_ <= Central.main.PvpPVMode)
         {
            if(Central.main.PvpPRTeamA[_loc2_] == param1)
            {
               Central.main.PvpPRTeamA[_loc2_] = "";
            }
            if(Central.main.PvpPRTeamB[_loc2_] == param1)
            {
               Central.main.PvpPRTeamB[_loc2_] = "";
            }
            _loc2_++;
         }
         if(param1 == Central.main.PvpPRHostId)
         {
            Central.main.PvpPRHostId = "";
         }
      }
      
      private function onPlayerLeave(param1:Object) : void
      {
         trace("alanlee disconnect");
         if(this.javaDisconnect == true)
         {
            return;
         }
         if(Central.main.PvpOnArena)
         {
            trace("onPlayerLeave ");
            Central.main.hideAmfLoading();
            Central.panel.getInstance().curPanel.playerLeave(param1.character_id);
         }
         else
         {
            Central.main.PvphavePlayerDisconnect = true;
            Central.battle.playerDisconnect(param1.character_id);
            this.removePlayerOnList(param1.character_id);
            if(Central.battle.pvpPlayerPost == "quick")
            {
               Central.battle.onPlayerLeaveQuickMatch();
            }
            if(Central.battle.pvpPlayerPost == "tournament")
            {
               Central.battle.onPlayerLeaveTournament();
            }
         }
         if(Central.main.pvpPlayerStatus == "quickLoading")
         {
            Central.main.hideAmfLoading();
            Central.panel.getInstance().curPanel.onLoadingPlayerQuit();
         }
         if(Central.main.pvpPlayerStatus == "tournamentLoading")
         {
            Central.main.hideAmfLoading();
            Central.panel.getInstance().curPanel.onLoadingPlayerQuit();
         }
         if(Central.main.pvpPlayerStatus == "privateLoading")
         {
            Central.battle.loadingQuitArr.push(param1.character_id);
         }
      }
      
      private function onUpdateTeam(param1:Object) : void
      {
         var _loc2_:Array = null;
         var _loc3_:Array = null;
         if(Central.main.pvpPlayerStatus == "waiting")
         {
            _loc2_ = param1.ta;
            _loc3_ = param1.tb;
            Central.panel.getInstance().curPanel.onConfirmSetPostEvent(_loc2_,_loc3_);
         }
      }
      
      private function onstartSetTeam() : void
      {
         Central.panel.getInstance().curPanel.hostStartSetTeam();
      }
      
      private function onPrivateMessageEvent(param1:String) : void
      {
         if(Central.main.checkGameStatus() == Timeline.PANEL)
         {
            if(Central.main.PvpPlayerPlace == "private" || Central.main.PvpPlayerPlace == "PVE")
            {
               Central.panel.getInstance().curPanel.onIncomingRoomMessage(param1);
            }
         }
         if(Central.main.checkGameStatus() == Timeline.BATTLE)
         {
            Central.battle.onIncomingRoomMessage(param1);
         }
      }
      
      private function onBattleMessageEvent(param1:String) : void
      {
         Central.battle.onIncomingRoomMessage(param1);
      }
      
      private function onError(param1:*) : void
      {
         Central.main.hideAmfLoading();
         Central.main.showInfo(Central.main.langLib.get(212));
         if(param1 != null)
         {
            try
            {
            }
            catch(e:Error)
            {
            }
         }
         Central.main.gotoMap();
      }
      
      public function isConnected() : Boolean
      {
         return this._isLoggedIn;
      }
      
      private function onLobbyAdminMessageEvent(param1:String) : *
      {
         Out.debug("","[!]entering battle Central.main.checkGameStatus() = " + Central.main.checkGameStatus());
         if(Central.main.checkGameStatus() == Timeline.BATTLE)
         {
            Central.main.onAdminMessage(param1);
            return;
         }
         Out.debug("","send admin message to panel");
         if(Central.main.PvpPlayerPlace == "lobby" || Central.main.PvpPlayerPlace == "quick" || Central.main.PvpPlayerPlace == "tournament")
         {
            Central.panel.getInstance().curPanel.onAdminMessage(param1);
         }
      }
      
      private function onPrivateAdminMessageEvent(param1:String) : *
      {
         if(Central.main.checkGameStatus() == Timeline.BATTLE)
         {
            Central.main.onAdminMessage(param1);
         }
         else
         {
            Central.main.onAdminMessage(param1);
         }
      }
      
      private function onLobbyMessageEvent(param1:String) : void
      {
         switch(Central.main.PvpPlayerPlace)
         {
            case "lobby":
            case "quick":
            case "tournament":
               Central.panel.getInstance().curPanel.onIncomingRoomMessage(param1);
               break;
            case "PVE":
               Central.panel.getInstance().curPanel.onIncomingLobbyMessage(param1);
         }
      }
      
      public function sendLobbyMessage(param1:String) : void
      {
         param1 = TextFilter.filter(param1);
         param1 = Central.main.getMainChar().getDBChar().character_name + ": " + param1;
         param1 = Base64.encode(param1);
         this.server.send({
            "event":this.RM_CHAT_MSG,
            "message":param1
         });
      }
      
      public function sendBattleMessage(param1:String) : void
      {
         param1 = TextFilter.filter(param1);
         param1 = Central.main.getMainChar().getDBChar().character_name + ": " + param1;
         param1 = Base64.encode(param1);
         this.server.send({
            "event":this.RM_CHAT_MSG,
            "message":param1
         });
      }
      
      private function onConnectionClosedEvent(param1:*) : void
      {
         if(this.changeServerStart == true)
         {
            return;
         }
         Out.debug("socket","char=" + Central.main.getMainChar().getData(DBCharacterData.ID) + ", e" + GF.printObject(param1));
         this.disconnect = true;
         if(Central.panel.getInstance().getCurPanelName() == "arena" || Central.panel.getInstance().getCurPanelName() == "Panel_PVE_2016")
         {
            this.resetPvpVar();
            if(Central.main.checkGameStatus() == Timeline.BATTLE)
            {
               Central.battle.battleFinish();
            }
            Central.main.gotoMap();
         }
         if(Central.main.checkGameStatus() == Timeline.BATTLE)
         {
            if(Central.battle.type == Central.battle.TYPE_NETWORK)
            {
               this.resetPvpVar();
               Central.battle.battleFinish();
               Central.main.gotoMap();
            }
         }
         Central.main.hideAmfLoading();
         if(Central.main.closePanel == false)
         {
            Central.main.showInfo(Central.main.langLib.get(212));
         }
      }
      
      private function resetPvpVar() : void
      {
         Central.main.PvpPlayerPost = null;
         Central.main.PvpGameId = "";
         Central.main.PvpRoomId = "";
         Central.main.PvpZoneId = "";
         Central.main.PvPTargetId = "";
         Central.main.closePanel = true;
         Central.main.PvpBattleType = "";
         Central.main.PvpPlayerPlace = "";
         Central.main.PvpTeamA = [];
         Central.main.PvpTeamB = [];
         Central.main.PvpTeamAPost = [];
         Central.main.PvpTeamBPost = [];
         Central.main.PvpAllPlayer = [];
         Central.main.loadedPvpCharacter = 0;
         Central.main.socket.logout();
      }
      
      public function logout() : void
      {
         this._isLoggedIn = false;
         this._room = null;
         this.server.close();
      }
      
      public function rematch() : void
      {
         this.sendData({
            "event":"info",
            "state":"ready"
         });
      }
      
      public function createRoom(param1:String, param2:int = -1) : void
      {
         Out.debug("create Room :: ","send join_room, pw >>" + param1 + "|" + Central.main.PvpPVMode + ", char=" + Central.main.getMainChar().getData(DBCharacterData.ID));
         this.create_room = true;
         if(param2 > -1)
         {
            this.server.send({
               "event":this.RM_JOIN,
               "password":param1,
               "mode":Central.main.PvpPVMode,
               "quest":param2
            });
         }
         else
         {
            this.server.send({
               "event":this.RM_JOIN,
               "password":param1,
               "mode":Central.main.PvpPVMode
            });
         }
      }
      
      public function getRoomSummary() : void
      {
         Out.debug("get Room Summary :: ","");
         this.server.send({"event":this.GET_ROOM_SUMMARY});
      }
      
      public function joinRoom(param1:int, param2:String) : void
      {
         this.create_room = false;
         this.server.send({
            "event":this.RM_JOIN,
            "room_name":param1,
            "password":param2
         });
      }
      
      public function joinLobby() : void
      {
         Out.debug("joinLobby :: ","Send Join Lobby" + ", char=" + Central.main.getMainChar().getData(DBCharacterData.ID));
         this.server.send({
            "event":this.RM_JOIN,
            "room_name":"lobby"
         });
      }
      
      public function playerReady(param1:String) : void
      {
         this.server.send({
            "event":this.READY,
            "character_id":param1
         });
      }
      
      public function cancelPlayerReady(param1:String) : void
      {
         this.server.send({
            "event":this.CANCEL_READY,
            "character_id":param1
         });
      }
      
      public function startSetTeam() : void
      {
         this.server.send({"event":this.START_SET});
      }
      
      public function onConfirmSetPost(param1:Array, param2:Array) : void
      {
         this.server.send({
            "event":this.UPDATE_TEAM,
            "ta":param1,
            "tb":param2
         });
      }
      
      public function startGame(param1:String = null, param2:Array = null, param3:Array = null) : void
      {
         if(param1)
         {
            this.server.send({
               "event":this.READY,
               "character_id":param1,
               "ta":param2,
               "tb":param3
            });
         }
         else
         {
            this.server.send({
               "event":this.READY,
               "data":{}
            });
         }
      }
      
      public function kickPlayer(param1:String) : void
      {
         this.server.send({
            "event":this.KICK_USER,
            "character_id":param1
         });
      }
      
      public function changeBg(param1:String) : void
      {
      }
      
      public function joinQMQueue() : void
      {
         this.server.send({
            "event":"enqueue",
            "mode":Central.main.PvpQMMode,
            "charRank":Central.main.getMainChar().getData(DBCharacterData.RANK)
         });
      }
      
      public function joinQMAi() : void
      {
         this.server.send({
            "event":"hit_ai",
            "mode":Central.main.PvpQMMode,
            "charRank":Central.main.getMainChar().getData(DBCharacterData.RANK)
         });
      }
      
      public function joinTournamentQueue() : void
      {
         Out.debug("","send queue tournament message to nodejs server");
         this.server.send({
            "event":"enqueueTournament",
            "mode":Central.main.PvpTournamntMode,
            "charRank":Central.main.getMainChar().getData(DBCharacterData.RANK)
         });
      }
      
      public function leaveQMQueue() : void
      {
         Out.debug("","leaveQMQueue");
         this.server.send({"event":"dequeue"});
      }
      
      public function leaveTournamentQueue() : void
      {
         Out.debug("","leaveTournamentQueue");
         this.server.send({"event":"dequeueTournament"});
      }
      
      public function loadDBCompleted() : void
      {
         this.sendData({
            "event":"info",
            "state":"init"
         });
      }
      
      public function loadBattleCompelete() : void
      {
         this.sendData({
            "event":"info",
            "state":"ready"
         });
      }
      
      private function onPluginMessageEvent(param1:Object) : void
      {
         if(this.debugMode)
         {
            Central.main.amfClient.service("PVPServiceDebug.logData" + this.debugId,[Central.main.getMainChar().getCharacterId(),"recv",param1],new Function());
         }
         if(param1.event == "battleDisconnect")
         {
            Central.main.showOk("You have disconnected from PVP server.",new Function());
            this.javaDisconnect = true;
            this.onConnectionClosedEvent({"javaDisconnect":true});
         }
         Client.getInstance().receiveDataHAV(param1);
      }
      
      public function sendData(param1:Object) : void
      {
         if(this.debugMode)
         {
            Central.main.amfClient.service("PVPServiceDebug.logData" + this.debugId,[Central.main.getMainChar().getCharacterId(),"send",param1],new Function());
         }
         if(this.disconnect == true)
         {
            this.disconnect = false;
            return;
         }
         if(param1.state)
         {
            if(param1.state == "battle_command")
            {
               switch(param1.battleAction.action)
               {
                  case "senjutsu":
                     param1.battleAction = {
                        "skillId":param1.battleAction.SENSKILLID,
                        "action":param1.battleAction.action
                     };
                     break;
                  case "bloodline":
                     param1.battleAction = {
                        "skillId":param1.battleAction.BLSKILLID,
                        "action":param1.battleAction.action
                     };
                     break;
                  case "skill":
                     param1.battleAction = {
                        "skillId":param1.battleAction.skillId,
                        "action":param1.battleAction.action
                     };
                     break;
                  case "item":
                     param1.battleAction = {
                        "item":param1.battleAction.item,
                        "action":param1.battleAction.action
                     };
                     break;
                  case "charge":
                  case "pass":
                  case "dodge":
                  case "weapon_attack":
               }
            }
         }
         this.server.send({
            "event":this.BATTLE_MSG,
            "message":param1
         });
      }
      
      public function getTimeStamp() : uint
      {
         var _loc1_:Date = new Date();
         return _loc1_.getTime();
      }
      
      private function EncodeUtf8(param1:String) : String
      {
         var _loc2_:ByteArray = new ByteArray();
         _loc2_.writeUTFBytes(param1);
         var _loc3_:ByteArray = new ByteArray();
         var _loc4_:int = 0;
         while(_loc4_ < _loc2_.length)
         {
            if(_loc2_[_loc4_] == 194)
            {
               _loc3_.writeByte(_loc2_[_loc4_ + 1]);
               _loc4_++;
            }
            else if(_loc2_[_loc4_] == 195)
            {
               _loc3_.writeByte(_loc2_[_loc4_ + 1] + 64);
               _loc4_++;
            }
            else
            {
               _loc3_.writeByte(_loc2_[_loc4_]);
            }
            _loc4_++;
         }
         _loc3_.position = 0;
         return _loc3_.readMultiByte(_loc3_.bytesAvailable,"chinese");
      }
      
      private function EncodeUtf16(param1:String) : String
      {
         var _loc2_:ByteArray = new ByteArray();
         _loc2_.writeMultiByte(param1,"iso-8859-1");
         _loc2_.position = 0;
         return _loc2_.readMultiByte(_loc2_.length,"utf-8");
      }
      
      private function processAdminMessage(param1:String) : String
      {
         var _loc2_:String = Base64.decode(param1);
         Out.debug("","message = " + _loc2_);
         var _loc3_:* = _loc2_.split(":");
         Out.debug("","messageAry = " + GF.printObject(_loc3_));
         var _loc4_:String = "";
         if(_loc3_[2] != null)
         {
            _loc4_ = _loc3_[2];
         }
         Out.debug("","postMessage = " + _loc4_);
         return _loc4_;
      }
      
      public function setDebugMode() : void
      {
         this.debugMode = true;
         this.debugId = int(Math.random() * 100);
      }
   }
}

