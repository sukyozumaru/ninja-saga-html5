package ninjasaga.net
{
   import com.adobe.serialization.json.JSON;
   import com.utils.GF;
   import com.utils.Out;
   import ninjasaga.Central;
   
   public class Client
   {
      
      private static var instance:Client;
      
      private var gameName:String;
      
      private var battleController:BattleController;
      
      private const KEY_BATTLE_WIN:* = "BATTLE_HAV_WIN";
      
      public function Client(param1:InstanceBlocker)
      {
         super();
         if(param1 == null)
         {
            throw new Error("Error: Instantiation failed: Use Client.getInstance() instead of new.");
         }
      }
      
      public static function getInstance() : Client
      {
         if(instance == null)
         {
            instance = new Client(new InstanceBlocker());
         }
         return instance;
      }
      
      public function encodeBattleAction(param1:Object) : String
      {
         return com.adobe.serialization.json.JSON.stringify(param1);
      }
      
      public function decodeBattleAction(param1:String) : Object
      {
         return com.adobe.serialization.json.JSON.parse(param1);
      }
      
      public function joinRoom() : void
      {
         var _loc1_:Object = {};
         _loc1_.event = "info";
         _loc1_.state = "join";
         _loc1_.charId = String(Central.main.getMainChar().getData("character_id"));
         _loc1_.charName = String(Central.main.getMainChar().getCharacterName());
         _loc1_.charAgility = String(Central.main.getMainChar().agility);
         _loc1_.charType = "player";
         _loc1_.side = 1;
         if(Central.battle.type == Central.battle.TYPE_LOCAL)
         {
            this.battleController = new BattleController();
            this.battleController.parseClientObject(_loc1_);
         }
         if(Central.battle.type == Central.battle.TYPE_NETWORK)
         {
         }
      }
      
      public function sendData(param1:Object, param2:String = null) : void
      {
         if(param1.state == "battle_win" && param2 != this.KEY_BATTLE_WIN)
         {
            Central.main.onError();
            return;
         }
         if(Central.battle.type == Central.battle.TYPE_LOCAL)
         {
            this.battleController.parseClientObject(param1);
         }
         if(Central.battle.type == Central.battle.TYPE_NETWORK)
         {
            Central.main.socket.sendData(param1);
         }
      }
      
      public function receiveDataHAV(param1:Object) : void
      {
         var _loc3_:String = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:Array = null;
         var _loc8_:Array = null;
         var _loc9_:Object = null;
         var _loc10_:Object = null;
         var _loc11_:Array = null;
         var _loc12_:Object = null;
         var _loc13_:int = 0;
         Out.debug(this,"receiveData :: _obj.userId " + param1.userId + " :: _obj.event " + param1.event + " :: .state " + param1.state);
         var _loc2_:String = param1.event;
         switch(_loc2_)
         {
            case "info":
               _loc3_ = param1.state;
               switch(_loc3_)
               {
                  case "join":
                     Central.main.PvpTeamA = param1.ta;
                     Central.main.PvpTeamB = param1.tb;
                     Central.main.PvpAllPlayer = [];
                     _loc4_ = 0;
                     while(_loc4_ < Central.main.PvpTeamA.length)
                     {
                        Central.main.PvpAllPlayer.push(Central.main.PvpTeamA[_loc4_]);
                        _loc4_++;
                     }
                     if(Central.main.PvpPlayerPlace != "PVE")
                     {
                        _loc4_ = 0;
                        while(_loc4_ < Central.main.PvpTeamB.length)
                        {
                           Central.main.PvpAllPlayer.push(Central.main.PvpTeamB[_loc4_]);
                           _loc4_++;
                        }
                     }
                     if(Central.main.PvpPlayerPlace == "quick")
                     {
                        Central.main.pvpPlayerStatus = "quickLoading";
                     }
                     if(Central.main.PvpPlayerPlace == "tournament")
                     {
                        Central.main.pvpPlayerStatus = "tournamentLoading";
                     }
                     if(Central.main.PvpPlayerPlace == "private")
                     {
                        Central.main.pvpPlayerStatus = "privateLoading";
                     }
                     if(Central.main.PvpPlayerPlace == "PVE")
                     {
                        Central.main.pvpPlayerStatus = "PVELoading";
                     }
                     if(Central.main.PvpPlayerPlace == "PVE")
                     {
                        _loc8_ = [];
                        Central.main.intiedLimbNum = 0;
                        _loc4_ = 0;
                        while(_loc4_ < Central.main.PvpTeamB.length)
                        {
                           _loc9_ = Central.main.ENEMY_DATA.find(Central.main.PvpTeamB[_loc4_].replace("ene_","enemy"));
                           if(Boolean(_loc9_.limb) && _loc9_.limb > 1)
                           {
                              _loc5_ = 0;
                              while(_loc5_ < _loc9_.limb)
                              {
                                 _loc10_ = {};
                                 switch(_loc5_)
                                 {
                                    case 0:
                                       _loc6_ = 1;
                                       break;
                                    case 1:
                                       _loc6_ = 0;
                                       break;
                                    default:
                                       _loc6_ = _loc5_;
                                 }
                                 _loc10_.id = _loc9_.id;
                                 _loc10_.swfName = _loc9_.swfName;
                                 _loc10_.clsName = _loc9_.clsName;
                                 _loc11_ = _loc9_.description.split(",");
                                 _loc10_.name = _loc11_[_loc6_];
                                 _loc10_.level = Central.main.pveCurrEnemyLevel;
                                 _loc10_.minLevel = _loc9_.minLevel;
                                 _loc10_.maxLevel = _loc9_.maxLevel;
                                 _loc10_.type = _loc9_.type;
                                 _loc10_.max_hp = [_loc9_.max_hp[_loc6_]];
                                 _loc10_.max_cp = [_loc9_.max_cp[_loc6_]];
                                 _loc10_.speed = _loc9_.speed;
                                 _loc10_.fire = _loc9_.fire;
                                 _loc10_.water = _loc9_.water;
                                 _loc10_.wind = _loc9_.wind;
                                 _loc10_.earth = _loc9_.earth;
                                 _loc10_.lightning = _loc9_.lightning;
                                 _loc10_.skill = _loc9_.skill;
                                 _loc10_.limb = _loc9_.limb;
                                 _loc8_.push(_loc10_);
                                 _loc5_++;
                              }
                           }
                           else
                           {
                              _loc8_.push(_loc9_);
                           }
                           _loc4_++;
                        }
                        Central.main.setPvEEnemy(_loc8_);
                     }
                     _loc4_ = 0;
                     while(_loc4_ < Central.main.PvpAllPlayer.length)
                     {
                        if(Central.main.getMainChar().getData("character_id") != Central.main.PvpAllPlayer[_loc4_])
                        {
                           Out.debug("","load pvp character~~ charId = " + Central.main.PvpAllPlayer[_loc4_]);
                           Central.main.loadDBCharForBattle(Central.main.PvpAllPlayer[_loc4_]);
                        }
                        _loc4_++;
                     }
                     if(Central.main.PvpPlayerPlace == "PVE")
                     {
                        _loc4_ = 0;
                        while(_loc4_ < _loc8_.length)
                        {
                           switch(_loc4_)
                           {
                              case 0:
                                 _loc6_ = 1;
                                 break;
                              case 1:
                                 _loc6_ = 0;
                                 break;
                              default:
                                 _loc6_ = _loc4_;
                           }
                           Central.main.PvpAllPlayer.push(_loc8_[_loc4_].id.replace("enemy","") + _loc6_);
                           _loc4_++;
                        }
                     }
                     break;
                  case "ready":
                     Central.main.gotReadyInfo(param1.userId);
                     Central.main.resurrection = false;
                     break;
                  case "init":
                     Central.main.initPvPBattle();
                     break;
                  case "start":
                     if(Central.main.PvpOnArena)
                     {
                        Central.main.PvpOnArena = false;
                        Central.main.pvpPlayerStatus = "battleing";
                     }
                     try
                     {
                        if(Central.battle.type == Central.battle.TYPE_NETWORK)
                        {
                           Out.debug("","recevied start message from server");
                           if(param1.bgNum != null)
                           {
                              Out.debug("","sync background");
                              Central.battle.syncBackground(param1.bgNum);
                           }
                           if(Central.main.PvpPlayerPlace == "quick")
                           {
                              Central.main.tracking.generalTrack(Central.main.tracking.TRACK_PVP,Central.main.PvpQMMode,Central.main.tracking.TRACK_PVP_QUICK_MATCH_START);
                           }
                           else if(Central.main.PvpPlayerPlace == "private")
                           {
                              Central.main.tracking.generalTrack(Central.main.tracking.TRACK_PVP,Central.main.PvpPVMode,Central.main.tracking.TRACK_PVP_PRIVATE_START);
                           }
                        }
                     }
                     catch(e:Error)
                     {
                     }
                     Central.main.hideAmfLoading();
                     Central.main.gotoBattle();
                     break;
                  case "start_atb":
                     Central.battle.checkLoadingQuit();
                     Central.battle.processor.init();
                     if(Central.battle.type == Central.battle.TYPE_NETWORK)
                     {
                        Central.main.pvpPlayerStatus = "battleing";
                        Central.main.PvpPlayerPlace = "battle";
                        _loc7_ = param1.atbArr;
                        Central.battle.tweenATB(param1.duration,_loc7_);
                     }
                     else
                     {
                        _loc7_ = param1.atbArr;
                        Central.battle.tweenATB(param1.duration,_loc7_);
                     }
                     break;
                  case "disconnect":
                     Central.main.hideAmfLoading();
                     Central.main.pvpPlayerStatus = "waiting";
                     if(Central.panel.getInstance() != null)
                     {
                        trace("alanlee != null 1");
                        trace("alanlee Central.panel.getInstance() = " + GF.printObject(Central.panel.getInstance()));
                        trace("alanlee Central.panel.getInstance().curPanel = " + Central.panel.getInstance().curPanel);
                        if(Central.panel.getInstance().curPanel != null)
                        {
                           trace("alanlee != null 2");
                           Central.panel.getInstance().curPanel.onLoadingPlayerQuit();
                        }
                        else
                        {
                           trace("alanlee showDisconnect 1");
                           Central.battle.onBackBtn(null);
                        }
                     }
                     if(Central.main.PvpPlayerPost == "quick")
                     {
                        trace("alanlee quick");
                        Central.battle.pvpWinLossPanelSomeoneLeft();
                        Central.battle.updatePvpRematchPanel();
                     }
                     if(Central.main.pvpPlayerPost == "PVE")
                     {
                        trace("alanlee showDisconnect");
                        Central.battle.showPvPBattleLose();
                     }
               }
               break;
            case "command":
               _loc3_ = param1.state;
               switch(_loc3_)
               {
                  case "action":
                     if(param1.battleAction)
                     {
                        param1.battleAction.feedback = null;
                     }
                     if(Central.battle.type == Central.battle.TYPE_NETWORK)
                     {
                        _loc12_ = null;
                        if(param1.charId == Central.main.getMainChar().getCharacterId())
                        {
                           Out.debug("client1","client1 1if");
                           Out.debug("client1",param1.syncCooldown);
                           if(param1.syncCooldown)
                           {
                              Central.battle.syncCoolDownObj = param1.syncCooldown;
                           }
                        }
                        if(param1.battleAction)
                        {
                           _loc12_ = param1.battleAction;
                        }
                        Central.battle.characterTurn(param1.charType,param1.charId,param1.roundObj,_loc12_,param1.syncData);
                     }
                     else
                     {
                        Central.battle.characterTurn(param1.charType,param1.charId,param1.roundObj,param1.battleAction);
                     }
                     break;
                  case "battle_action":
                     if(Central.battle.type == Central.battle.TYPE_NETWORK)
                     {
                        if(param1.time)
                        {
                           _loc13_ = int(this.getTimeStamp());
                           Central.battle.log_time = _loc13_ - Central.battle.log_time;
                           Central.battle.log_time -= param1.time;
                           Central.battle.log_time_user = param1.charId;
                        }
                     }
                     Central.battle.callBattleAction(param1);
                     break;
                  case "continue":
                     Central.battle.startATB();
                     break;
                  case "battle_finish":
                     if(Central.battle.type == Central.battle.TYPE_NETWORK)
                     {
                     }
                     Central.battle.callBattleFinishHAV(param1);
               }
         }
      }
      
      public function getTimeStamp() : uint
      {
         var _loc1_:Date = new Date();
         return _loc1_.getTime();
      }
      
      public function addEnemy(param1:Object) : void
      {
         var _loc2_:Object = {};
         _loc2_.event = "info";
         _loc2_.state = "join";
         _loc2_.charId = param1.id;
         _loc2_.charName = param1.name;
         _loc2_.charAgility = param1.agility;
         _loc2_.charType = "enemy";
         _loc2_.side = 2;
         if(Central.battle.type == Central.battle.TYPE_LOCAL)
         {
            this.battleController.parseClientObject(_loc2_);
         }
      }
      
      public function addParty(param1:Object) : void
      {
         var _loc2_:Object = {};
         _loc2_.event = "info";
         _loc2_.state = "join";
         _loc2_.charId = param1.id;
         _loc2_.charName = param1.name;
         _loc2_.charAgility = param1.agility;
         _loc2_.charType = "party";
         _loc2_.side = 1;
         if(Central.battle.type == Central.battle.TYPE_LOCAL)
         {
            this.battleController.parseClientObject(_loc2_);
         }
      }
      
      public function addPet(param1:Object) : void
      {
         var _loc2_:Object = {};
         _loc2_.event = "info";
         _loc2_.state = "join";
         _loc2_.charId = param1.id;
         _loc2_.charName = param1.name;
         _loc2_.charAgility = param1.agility;
         _loc2_.charType = "pet";
         _loc2_.side = 1;
         if(Central.battle.type == Central.battle.TYPE_LOCAL)
         {
            this.battleController.parseClientObject(_loc2_);
         }
      }
      
      public function updateCharacterAgility(param1:String, param2:int) : void
      {
         this.battleController.characterArr.find(param1).agility = param2;
      }
   }
}

import de.polygonal.ds.HashMap;
import flash.events.MouseEvent;
import ninjasaga.Central;
import ninjasaga.net.Client;

class InstanceBlocker
{
   
   public function InstanceBlocker()
   {
      super();
   }
}

class BattleController
{
   
   private var charArr:HashMap;
   
   private var actionArr:Array = [];
   
   private var onAction:Boolean = false;
   
   public function BattleController()
   {
      super();
      this.charArr = new HashMap();
      Central.battle.destroyProcessor();
   }
   
   public function get characterArr() : HashMap
   {
      return this.charArr;
   }
   
   public function parseClientObject(param1:Object) : void
   {
      var _loc4_:uint = 0;
      var _loc5_:Array = null;
      var _loc7_:String = null;
      var _loc8_:Object = null;
      var _loc9_:Array = null;
      var _loc10_:Number = NaN;
      var _loc11_:Number = NaN;
      var _loc12_:Number = NaN;
      var _loc13_:uint = 0;
      trace("rex parseClientObj.event=" + param1.event);
      var _loc2_:String = param1.event;
      var _loc3_:Object = {};
      var _loc6_:Array = [];
      switch(_loc2_)
      {
         case "info":
            _loc7_ = param1.state;
            switch(_loc7_)
            {
               case "join":
                  _loc8_ = {};
                  _loc8_.id = param1.charId;
                  _loc8_.name = param1.charName;
                  _loc8_.agility = param1.charAgility;
                  _loc8_.type = param1.charType;
                  _loc8_.actionFinish = false;
                  _loc8_.atbReady = false;
                  _loc8_.atbPos = 0;
                  _loc8_.atbFinish = false;
                  _loc8_.isDead = false;
                  _loc8_.side = param1.side;
                  this.charArr.insert(param1.charId,_loc8_);
                  break;
               case "ready":
                  if(this.isAllReady())
                  {
                     _loc3_.event = "info";
                     _loc3_.state = "start";
                     Client.getInstance().receiveDataHAV(_loc3_);
                  }
                  break;
               case "start_atb":
                  this.charArr.find(param1.charId).atbReady = true;
                  if(this.isAllATBReady())
                  {
                     _loc5_ = this.charArr.toArray();
                     _loc9_ = [];
                     _loc10_ = 0;
                     _loc4_ = 0;
                     while(_loc4_ < _loc5_.length)
                     {
                        _loc5_[_loc4_].atbReady = false;
                        _loc11_ = 300 * 48 / (48 - _loc5_[_loc4_].agility / 10);
                        if(_loc10_ == 0 || _loc10_ > (600 - _loc5_[_loc4_].atbPos) / _loc11_)
                        {
                           _loc10_ = (600 - _loc5_[_loc4_].atbPos) / _loc11_;
                        }
                        _loc4_++;
                     }
                     _loc4_ = 0;
                     while(_loc4_ < _loc5_.length)
                     {
                        _loc11_ = 300 * 48 / (48 - _loc5_[_loc4_].agility / 10);
                        _loc12_ = Math.ceil(_loc5_[_loc4_].atbPos + _loc11_ * _loc10_);
                        if(_loc12_ > 600)
                        {
                           _loc12_ = 600;
                        }
                        _loc5_[_loc4_].atbPos = _loc12_;
                        _loc9_.push({
                           "charId":_loc5_[_loc4_].id,
                           "moveTo":_loc12_
                        });
                        _loc4_++;
                     }
                     _loc3_.event = "info";
                     _loc3_.state = "start_atb";
                     _loc3_.duration = _loc10_;
                     _loc3_.atbArr = _loc9_;
                     Client.getInstance().receiveDataHAV(_loc3_);
                  }
                  break;
               case "action":
                  this.charArr.find(param1.charId).atbFinish = true;
                  if(this.isAllATBFinish())
                  {
                     _loc5_ = this.charArr.toArray();
                     _loc4_ = 0;
                     while(_loc4_ < _loc5_.length)
                     {
                        _loc5_[_loc4_].atbFinish = false;
                        if(_loc5_[_loc4_].atbPos >= 600)
                        {
                           _loc5_[_loc4_].atbPos = 0;
                           _loc3_ = {};
                           _loc3_.event = "command";
                           _loc3_.state = "action";
                           _loc3_.charId = _loc5_[_loc4_].id;
                           _loc3_.charType = _loc5_[_loc4_].type;
                           this.actionArr.push(_loc3_);
                        }
                        _loc4_++;
                     }
                     if(!this.onAction)
                     {
                        this.processSequentialAction();
                     }
                  }
                  break;
               case "battle_action":
                  _loc3_ = param1;
                  _loc3_.event = "command";
                  Client.getInstance().receiveDataHAV(_loc3_);
                  break;
               case "battle_command":
                  if(int(param1.charId != Central.battle.processor.getAttacker().getCharacterId()))
                  {
                     throw new Error("Error :: parseClientObject :: battle command from unknown attacker.");
                  }
                  Central.battle.processor.setDefenderById(param1.targetId);
                  Central.battle.processor.processCommand(param1.battleAction);
                  _loc3_ = {};
                  _loc3_.event = "command";
                  _loc3_.state = "battle_action";
                  _loc3_.charId = Central.battle.processor.getAttacker().getCharacterId();
                  _loc3_.targetId = Central.battle.processor.getDefender().getCharacterId();
                  _loc3_.battleAction = Central.battle.processor.getAttacker().getBattleAction();
                  Client.getInstance().receiveDataHAV(_loc3_);
                  break;
               case "action_finish":
                  this.charArr.find(param1.charId).actionFinish = true;
                  if(param1.char_dead)
                  {
                     this.charArr.find(param1.charId).isDead = true;
                  }
                  if(this.isAllActionFinish())
                  {
                     if(Central.battle.processor.checkExtraTurn() == true)
                     {
                        _loc3_ = {};
                        _loc3_.event = "command";
                        _loc3_.state = "battle_action";
                        _loc3_.charId = Central.battle.processor.getAttacker().getCharacterId();
                        _loc3_.targetId = Central.battle.processor.getDefender().getCharacterId();
                        _loc3_.battleAction = Central.battle.processor.getAttacker().getBattleAction();
                        Client.getInstance().receiveDataHAV(_loc3_);
                        return;
                     }
                     _loc13_ = uint(this.processBattleStatus());
                     if(_loc13_ > 0)
                     {
                        _loc5_ = this.charArr.toArray();
                        if(_loc13_ == 1)
                        {
                           _loc4_ = 0;
                           while(_loc4_ < _loc5_.length)
                           {
                              if(_loc5_[_loc4_].side == 1)
                              {
                                 _loc6_.push(_loc5_[_loc4_].id);
                              }
                              _loc4_++;
                           }
                        }
                        if(_loc13_ == 2)
                        {
                           _loc4_ = 0;
                           while(_loc4_ < _loc5_.length)
                           {
                              if(_loc5_[_loc4_].side == 2)
                              {
                                 _loc6_.push(_loc5_[_loc4_].id);
                              }
                              _loc4_++;
                           }
                        }
                     }
                     else
                     {
                        if(Central.battle.spy_enemy)
                        {
                           Central.battle.spy_enemy = false;
                           Central.main.showEnemyHP(this.processSequentialAction);
                           return;
                        }
                        if(Boolean(Central.battle.use_seal_enemy) && !Central.battle.seal_enemy)
                        {
                           Central.battle.use_seal_enemy = false;
                           Central.main.showPopupSealFail(Central.main.sealFailTitle,Central.main.sealFailHint,this.processSequentialAction);
                           return;
                        }
                        this.processSequentialAction();
                     }
                  }
                  break;
               case "battle_win":
                  _loc5_ = this.charArr.toArray();
                  _loc4_ = 0;
                  while(_loc4_ < _loc5_.length)
                  {
                     if(_loc5_[_loc4_].side == 2)
                     {
                        _loc5_[_loc4_].isDead = true;
                     }
                     else
                     {
                        _loc6_.push(_loc5_[_loc4_].id);
                     }
                     _loc4_++;
                  }
                  if(this.processBattleStatus() == 1)
                  {
                     _loc3_.event = "command";
                     _loc3_.state = "battle_finish";
                     _loc3_.winnerIDs = _loc6_;
                     Client.getInstance().receiveDataHAV(_loc3_);
                  }
                  break;
               case "battle_lose":
                  _loc5_ = this.charArr.toArray();
                  _loc4_ = 0;
                  while(_loc4_ < _loc5_.length)
                  {
                     if(_loc5_[_loc4_].side == 1)
                     {
                        _loc5_[_loc4_].isDead = true;
                     }
                     else
                     {
                        _loc6_.push(_loc5_[_loc4_].id);
                     }
                     _loc4_++;
                  }
                  if(this.processBattleStatus() == 2)
                  {
                     _loc3_.event = "command";
                     _loc3_.state = "battle_finish";
                     _loc3_.winnerIDs = _loc6_;
                     Client.getInstance().receiveDataHAV(_loc3_);
                  }
                  break;
               case "reset":
                  _loc5_ = this.charArr.toArray();
                  _loc4_ = 0;
                  while(_loc4_ < _loc5_.length)
                  {
                     _loc5_[_loc4_].actionFinish = true;
                     _loc5_[_loc4_].atbReady = true;
                     _loc5_[_loc4_].atbPos = 0;
                     _loc5_[_loc4_].atbFinish = false;
                     _loc5_[_loc4_].isDead = false;
                     _loc4_++;
                  }
                  this.onAction = false;
                  this.actionArr = [];
            }
      }
   }
   
   private function isAllReady() : Boolean
   {
      return true;
   }
   
   private function isAllATBReady() : Boolean
   {
      var _loc1_:uint = 0;
      return true;
   }
   
   private function isAllATBFinish() : Boolean
   {
      var _loc1_:uint = 0;
      return true;
   }
   
   private function isAllActionFinish() : Boolean
   {
      var _loc1_:uint = 0;
      return true;
   }
   
   private function processSequentialAction(param1:MouseEvent = null) : void
   {
      var _loc3_:uint = 0;
      var _loc4_:Array = null;
      var _loc5_:* = undefined;
      var _loc2_:Object = {};
      this.onAction = true;
      if(this.actionArr.length > 0)
      {
         _loc4_ = this.charArr.toArray();
         _loc3_ = 0;
         while(_loc3_ < _loc4_.length)
         {
            _loc4_[_loc3_].actionFinish = false;
            _loc3_++;
         }
         _loc5_ = this.actionArr.shift();
         Central.battle.processor.characterTurn(_loc5_.charType,_loc5_.charId);
         if(Central.battle.processor.skipBattleTurn)
         {
            trace("skipBattleTurn");
            Central.battle.processor.skipBattleTurn = false;
            Central.battle.processSkipBattleTurn();
            return;
         }
         _loc5_.roundObj = Central.battle.processor.nextRound();
         _loc5_.battleAction = Central.battle.processor.setupAction();
         if(_loc5_.battleAction != null)
         {
            _loc5_.battleAction.targetId = Central.battle.processor.getDefender().getCharacterId();
         }
         Client.getInstance().receiveDataHAV(_loc5_);
      }
      else
      {
         this.onAction = false;
         _loc2_.event = "command";
         _loc2_.state = "continue";
         Client.getInstance().receiveDataHAV(_loc2_);
      }
   }
   
   private function processBattleStatus() : uint
   {
      var _loc1_:uint = 0;
      var _loc2_:Array = this.charArr.toArray();
      var _loc3_:Boolean = true;
      var _loc4_:Boolean = true;
      _loc1_ = 0;
      while(_loc1_ < _loc2_.length)
      {
         if(_loc2_[_loc1_].side == 1 && !_loc2_[_loc1_].isDead)
         {
            _loc4_ = false;
         }
         if(_loc2_[_loc1_].side == 2 && !_loc2_[_loc1_].isDead)
         {
            _loc3_ = false;
         }
         _loc1_++;
      }
      if(_loc3_)
      {
         return 1;
      }
      if(_loc4_)
      {
         return 2;
      }
      return 0;
   }
}
