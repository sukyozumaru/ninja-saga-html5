package com.pnwrain.flashsocket
{
   import com.adobe.serialization.json.JSON;
   import com.pnwrain.flashsocket.events.FlashSocketEvent;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.HTTPStatusEvent;
   import flash.events.IOErrorEvent;
   import flash.events.SecurityErrorEvent;
   import flash.events.TimerEvent;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   import flash.net.URLRequestMethod;
   import flash.system.Security;
   import flash.utils.Timer;
   import mx.utils.URLUtil;
   import ninjasaga.Central;
   
   public class FlashSocket extends EventDispatcher implements IWebSocketLogger
   {
      
      protected var debug:Boolean = false;
      
      protected var callerUrl:String;
      
      protected var socketURL:String;
      
      protected var webSocket:WebSocket;
      
      public var sessionID:String;
      
      protected var heartBeatTimeout:int;
      
      protected var connectionClosingTimeout:int;
      
      protected var protocols:Array;
      
      private var domain:String;
      
      private var protocol:String;
      
      private var proxyHost:String;
      
      private var proxyPort:int;
      
      private var headers:String;
      
      private var timer:Timer;
      
      private var ackRegexp:RegExp = /(\d+)\+(.*)/;
      
      private var ackId:int = 0;
      
      private var acks:Object = {};
      
      private var errorObj:Object = {};
      
      private var debugArr:Array = [];
      
      public var handShakeDebugArr:Array = [];
      
      private var connectTime:uint;
      
      protected var frame:String = "~m~";
      
      public var connected:Boolean;
      
      public var connecting:Boolean;
      
      public function FlashSocket(param1:String, param2:String = null, param3:String = null, param4:int = 0, param5:String = null, param6:Array = null)
      {
         super();
         this.handShakeDebugArr = param6;
         var _loc7_:String = "http";
         var _loc8_:String = "ws";
         if(URLUtil.isHttpsURL(param1))
         {
            _loc7_ = "https";
            _loc8_ = "wss";
         }
         if(param1.indexOf("://") >= 0)
         {
            param1 = URLUtil.getServerNameWithPort(param1);
         }
         this.socketURL = _loc8_ + "://" + param1 + "/socket.io/1/flashsocket";
         this.callerUrl = _loc7_ + "://localhost/socket.swf";
         this.domain = param1;
         this.protocol = param2;
         this.proxyHost = param3;
         this.proxyPort = param4;
         this.headers = param5;
         var _loc9_:URLRequest = new URLRequest();
         _loc9_.url = _loc7_ + "://" + param1 + "/socket.io/1/?time=" + new Date().getTime();
         this.handShakeDebugArr.push("Time: " + Central.main.pvpDebugTime + " FlashSocket: new URLRequest  >> ");
         this.errorObj["url"] = _loc9_.url;
         _loc9_.method = URLRequestMethod.POST;
         this.errorObj["method"] = _loc9_.method;
         this.debugArr.push(" F1 ");
         var _loc10_:URLLoader = new URLLoader();
         _loc10_.load(_loc9_);
         this.handShakeDebugArr.push("Time: " + Central.main.pvpDebugTime + " FlashSocket: new URLLoader:" + _loc9_.url + " >> ");
         this.debugArr.push(" F2 ");
         this.connectTime = this.getTimeStamp();
         _loc10_.addEventListener(Event.COMPLETE,this.onDiscover);
         _loc10_.addEventListener(HTTPStatusEvent.HTTP_STATUS,this.onDiscoverHTTPError);
         _loc10_.addEventListener(IOErrorEvent.IO_ERROR,this.onDiscoverIOError);
      }
      
      public function getWebSocketArr() : Array
      {
         var wsArr:Array = null;
         wsArr = [];
         try
         {
            wsArr = this.webSocket.getDebugArr();
         }
         catch(e:Error)
         {
            wsArr.push(" -server Undefind-");
         }
         return wsArr;
      }
      
      public function getError() : Object
      {
         this.errorObj["debugArr"] = this.debugArr;
         return this.errorObj;
      }
      
      public function onDiscover(param1:Event) : void
      {
         this.handShakeDebugArr.push("Time: " + Central.main.pvpDebugTime + " FlashSocket: onDiscover:" + param1 + " >> ");
         this.debugArr.push(" F3 >> || " + param1 + " || ");
         var _loc2_:String = param1.target.data;
         var _loc3_:Array = _loc2_.split(":");
         this.sessionID = _loc3_[0];
         this.heartBeatTimeout = _loc3_[1];
         this.connectionClosingTimeout = _loc3_[2];
         this.protocols = _loc3_[3].toString().split(",");
         this.timer = new Timer(Math.ceil(this.heartBeatTimeout * 0.75) * 1000);
         this.timer.addEventListener(TimerEvent.TIMER,this.onHeartBeatTimer);
         this.handShakeDebugArr.push("Time: " + Central.main.pvpDebugTime + " FlashSocket: TimerStart >> ");
         var _loc4_:Boolean = false;
         var _loc5_:int = 0;
         while(_loc5_ < this.protocols.length)
         {
            if(this.protocols[_loc5_] == "flashsocket")
            {
               _loc4_ = true;
               break;
            }
            _loc5_++;
         }
         this.socketURL = this.socketURL + "/" + this.sessionID;
         this.debugArr.push(" F4 ");
         this.onHandshake(param1);
      }
      
      public function onHandshake(param1:Event) : void
      {
         this.debugArr.push(" F5 >> || " + this.socketURL + "|" + this.protocol + "|" + this.proxyHost + "|" + this.proxyPort + "|" + this.headers + " || ");
         this.handShakeDebugArr.push("Time: " + Central.main.pvpDebugTime + " FlashSocket: onHandShake >> ");
         this.loadDefaultPolicyFile(this.socketURL);
         var _loc2_:String = this.getOrigin();
         var _loc3_:String = "";
         var _loc4_:Array = [];
         _loc4_.push(this.protocol);
         this.webSocket = new WebSocket(this.ackId,this.socketURL,_loc4_,_loc2_,this.proxyHost,this.proxyPort,_loc3_,this.headers,this,this.handShakeDebugArr);
         this.handShakeDebugArr.push("Time: " + Central.main.pvpDebugTime + " FlashSocket: new WebSocket >> ackId=" + this.ackId + ", socketURL=" + this.socketURL + ", protocols=" + _loc4_ + ", origin=" + _loc2_ + ", proxyHost=" + this.proxyHost + ", proxyPort=" + this.proxyPort + ", cookie=" + _loc3_ + ", headers=" + this.headers);
         this.webSocket.addEventListener("event",this.onData);
         this.webSocket.addEventListener(Event.CLOSE,this.onClose);
         this.webSocket.addEventListener(Event.CONNECT,this.onConnect);
         this.webSocket.addEventListener(IOErrorEvent.IO_ERROR,this.onIoError);
         this.webSocket.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onSecurityError);
      }
      
      public function onHeartBeatTimer(param1:TimerEvent) : void
      {
         this.debugArr.push(" F23 ");
         this.handShakeDebugArr.push("Time: " + Central.main.pvpDebugTime + " FlashSocket: TimeOut >> ");
         this._onHeartbeat();
      }
      
      public function onDiscoverIOError(param1:Event) : void
      {
         var _loc2_:FlashSocketEvent = null;
         this.debugArr.push(" F2.5 >> || " + param1 + " || ");
         this.handShakeDebugArr.push("Time: " + Central.main.pvpDebugTime + " FlashSocket: onDiscoverIOError, event=" + param1 + " >> ");
         if(param1 is HTTPStatusEvent)
         {
            this.handShakeDebugArr.push("Time: " + Central.main.pvpDebugTime + " FlashSocket: onDiscoverIOError, HTTPStatusEvent.status=" + (param1 as HTTPStatusEvent).status + " >> ");
            this.debugArr.push(" F2.6 >> || " + (param1 as HTTPStatusEvent).status + " || ");
            if((param1 as HTTPStatusEvent).status != 200)
            {
               this.handShakeDebugArr.push("Time: " + Central.main.pvpDebugTime + " FlashSocket: onDiscoverIOError2 >> ");
               this.debugArr.push(" F2.7 ");
               _loc2_ = new FlashSocketEvent(FlashSocketEvent.CONNECT_ERROR);
               dispatchEvent(_loc2_);
            }
         }
      }
      
      public function onDiscoverHTTPError(param1:Event) : void
      {
         var _loc2_:FlashSocketEvent = null;
         this.debugArr.push(" F2.5 >> || " + param1 + " || ");
         this.handShakeDebugArr.push("Time: " + Central.main.pvpDebugTime + " FlashSocket: onDiscoverHTTPError unsure, event=" + param1 + " >> ");
         if(param1 is HTTPStatusEvent)
         {
            this.handShakeDebugArr.push("Time: " + Central.main.pvpDebugTime + " FlashSocket: onDiscoverHTTPError unsure, HTTPStatusEvent.status=" + (param1 as HTTPStatusEvent).status + " >> ");
            this.debugArr.push(" F2.6 >> || " + (param1 as HTTPStatusEvent).status + " || ");
            if((param1 as HTTPStatusEvent).status != 200)
            {
               this.handShakeDebugArr.push("Time: " + Central.main.pvpDebugTime + " FlashSocket: onDiscoverHTTPError2 >> ");
               this.debugArr.push(" F2.7 ");
               _loc2_ = new FlashSocketEvent(FlashSocketEvent.CONNECT_ERROR);
               dispatchEvent(_loc2_);
            }
         }
      }
      
      public function onHandshakeError(param1:Event) : void
      {
         var _loc2_:FlashSocketEvent = null;
         this.debugArr.push(" F3.5 ");
         if(param1 is HTTPStatusEvent)
         {
            if((param1 as HTTPStatusEvent).status != 200)
            {
               _loc2_ = new FlashSocketEvent(FlashSocketEvent.CONNECT_ERROR);
               dispatchEvent(_loc2_);
            }
         }
      }
      
      public function onClose(param1:Event) : void
      {
         this.handShakeDebugArr.push("Time: " + Central.main.pvpDebugTime + " FlashSocket: onClose >> ");
         var _loc2_:FlashSocketEvent = new FlashSocketEvent(FlashSocketEvent.CLOSE);
         this.close();
         dispatchEvent(_loc2_);
      }
      
      public function onConnect(param1:Event) : void
      {
         this.debugArr.push(" F6 ");
         this.handShakeDebugArr.push("Time: " + Central.main.pvpDebugTime + " FlashSocket: onConnect >> ");
         var _loc2_:FlashSocketEvent = new FlashSocketEvent(FlashSocketEvent.CONNECT);
         dispatchEvent(_loc2_);
      }
      
      public function onIoError(param1:Event) : void
      {
         var _loc2_:FlashSocketEvent = new FlashSocketEvent(FlashSocketEvent.IO_ERROR);
         dispatchEvent(_loc2_);
      }
      
      public function onSecurityError(param1:Event) : void
      {
         var _loc2_:FlashSocketEvent = new FlashSocketEvent(FlashSocketEvent.SECURITY_ERROR);
         dispatchEvent(_loc2_);
      }
      
      public function loadDefaultPolicyFile(param1:String) : void
      {
         this.handShakeDebugArr.push("Time: " + Central.main.pvpDebugTime + " FlashSocket: loadDefaultPolicyFile:" + param1 + " >> ");
         var _loc2_:String = "xmlsocket://" + URLUtil.getServerName(param1) + ":843";
         this.debugArr.push(" F6LP >> || " + _loc2_ + " || ");
         this.handShakeDebugArr.push("Time: " + Central.main.pvpDebugTime + " FlashSocket: onConnect" + _loc2_ + " >> ");
         this.log("policy file: " + _loc2_);
         Security.loadPolicyFile(_loc2_);
      }
      
      public function getOrigin() : String
      {
         this.debugArr.push(" F7 >> || " + this.callerUrl + " || ");
         this.handShakeDebugArr.push("Time: " + Central.main.pvpDebugTime + " FlashSocket: getOrigin:" + this.callerUrl + " >> ");
         var _loc1_:String = URLUtil.getProtocol(this.callerUrl) + "://" + URLUtil.getServerNameWithPort(this.callerUrl);
         this.debugArr.push(" F7.5 >> || " + _loc1_ + " || ");
         return (URLUtil.getProtocol(this.callerUrl) + "://" + URLUtil.getServerNameWithPort(this.callerUrl)).toLowerCase();
      }
      
      public function getCallerHost() : String
      {
         return null;
      }
      
      public function log(param1:String) : void
      {
         if(this.debug)
         {
            trace("webSocketLog: " + param1);
         }
      }
      
      public function error(param1:String) : void
      {
         trace("webSocketError: " + param1);
      }
      
      public function fatal(param1:String) : void
      {
         trace("webSocketError: " + param1);
      }
      
      public function onData(param1:*) : void
      {
         var _loc4_:String = null;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc7_:FlashSocketEvent = null;
         var _loc2_:Object = (param1.target as WebSocket).receiveEvents();
         var _loc3_:Object = _loc2_[0];
         this.debugArr.push(" F8 >> || " + _loc3_.type + " || ");
         this.handShakeDebugArr.push("Time: " + Central.main.pvpDebugTime + " FlashSocket: onData:" + _loc3_.type + " >> ");
         if(_loc3_.type == "message")
         {
            this._setTimeout();
            _loc4_ = unescape(_loc3_.data);
            this.handShakeDebugArr.push("Time: " + Central.main.pvpDebugTime + " FlashSocket: OnDataMessage:" + _loc4_ + " >> ");
            this.debugArr.push(" F8.5 >> || " + _loc4_ + " || ");
            if(_loc4_)
            {
               this._onMessage(_loc4_);
            }
         }
         else if(_loc3_.type == "open")
         {
            this._onConnect();
         }
         else if(_loc3_.type == "close")
         {
            _loc5_ = this.getTimeStamp();
            _loc6_ = _loc5_ - this.connectTime;
            this.debugArr.push(" F8.6 >> || " + _loc6_ + " || ");
            _loc7_ = new FlashSocketEvent(FlashSocketEvent.CLOSE);
            dispatchEvent(_loc7_);
         }
         else
         {
            this.log("We got a data message that is not \'message\': " + _loc3_.type);
         }
      }
      
      private function _setTimeout() : void
      {
      }
      
      private function _onMessage(param1:String) : void
      {
         var _loc2_:Object = null;
         var _loc3_:FlashSocketEvent = null;
         var _loc4_:FlashSocketEvent = null;
         var _loc5_:Object = null;
         var _loc6_:FlashSocketEvent = null;
         var _loc7_:Object = null;
         var _loc8_:int = 0;
         var _loc9_:Array = null;
         var _loc10_:Function = null;
         this.debugArr.push(" F9 ");
         _loc2_ = this.deFrame(param1);
         this.handShakeDebugArr.push("Time: " + Central.main.pvpDebugTime + " FlashSocket: _onMessage type:" + _loc2_.type + " >> ");
         this.debugArr.push(" F9.5 >> " + _loc2_.type + " || ");
         switch(_loc2_.type)
         {
            case "0":
               this._onDisconnect();
               break;
            case "1":
               break;
            case "2":
               this._onHeartbeat();
               break;
            case "3":
               _loc3_ = new FlashSocketEvent(FlashSocketEvent.MESSAGE);
               _loc3_.data = _loc2_.msg;
               dispatchEvent(_loc3_);
               break;
            case "4":
               _loc4_ = new FlashSocketEvent(FlashSocketEvent.MESSAGE);
               _loc4_.data = com.adobe.serialization.json.JSON.parse(_loc2_.msg);
               _loc4_.data = com.adobe.serialization.json.JSON.parse(_loc2_.msg);
               this.handShakeDebugArr.push("Time: " + Central.main.pvpDebugTime + " FlashSocket: _onMessage dm.msg:" + _loc2_.msg + " >> ");
               this.handShakeDebugArr.push("Time: " + Central.main.pvpDebugTime + " fe.data:" + _loc4_.data + " >> ");
               dispatchEvent(_loc4_);
               break;
            case "5":
               _loc5_ = com.adobe.serialization.json.JSON.parse(_loc2_.msg);
               _loc6_ = new FlashSocketEvent(_loc5_.name);
               _loc6_.data = _loc5_.args;
               dispatchEvent(_loc6_);
               break;
            case "6":
               _loc7_ = this.ackRegexp.exec(_loc2_.msg);
               _loc8_ = int(_loc7_[1]);
               _loc9_ = com.adobe.serialization.json.JSON.parse(_loc7_[2]);
               if(this.acks.hasOwnProperty(_loc8_))
               {
                  _loc10_ = this.acks[_loc8_] as Function;
                  if(_loc9_.length > _loc10_.length)
                  {
                     _loc10_.apply(null,_loc9_.slice(0,_loc10_.length));
                  }
                  else
                  {
                     _loc10_.apply(null,_loc9_);
                  }
                  delete this.acks[_loc8_];
               }
         }
      }
      
      protected function deFrame(param1:String) : Object
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(_loc3_ < 3)
         {
            _loc2_ = param1.indexOf(":",_loc2_ + 1);
            _loc3_++;
         }
         var _loc4_:String = param1.substring(_loc2_ + 1,param1.length);
         return {
            "type":param1.substr(0,1),
            "msg":_loc4_
         };
      }
      
      private function _decode(param1:String) : Array
      {
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         this.debugArr.push(" F20 ");
         var _loc2_:Array = [];
         while(param1.substr(0,3) === this.frame)
         {
            param1 = param1.substr(3);
            _loc3_ = "";
            _loc4_ = "";
            _loc5_ = 0;
            _loc6_ = param1.length;
            while(_loc5_ < _loc6_)
            {
               _loc4_ = Number(param1.substr(_loc5_,1));
               if(param1.substr(_loc5_,1) != _loc4_)
               {
                  param1 = unescape(param1.substr(_loc3_.length + this.frame.length));
                  _loc3_ = Number(_loc3_);
                  break;
               }
               _loc3_ += _loc4_;
               _loc5_++;
            }
            _loc2_.push(param1.substr(0,_loc3_));
            param1 = param1.substr(_loc3_);
            if(param1 === "")
            {
               return _loc2_;
            }
         }
         return _loc2_;
      }
      
      private function _onHeartbeat() : void
      {
         this.debugArr.push(" F13 ");
         this.webSocket.send("2::");
      }
      
      public function send(param1:Object, param2:String = null, param3:Function = null) : void
      {
         var messageId:String;
         var msg:Object = param1;
         var event:String = param2;
         var callback:Function = param3;
         this.debugArr.push(" F12 ");
         messageId = "";
         this.handShakeDebugArr.push("Time: " + Central.main.pvpDebugTime + "  FlashSocket:send >> ");
         if(null != callback)
         {
            messageId = this.ackId.toString() + "%2B";
            this.acks[this.ackId] = callback;
            ++this.ackId;
         }
         if(event == null)
         {
            if(msg is String)
            {
               this.debugArr.push(" F15 ");
               this.handShakeDebugArr.push("Time: " + Central.main.pvpDebugTime + "  FlashSocket:send:3::| " + msg + " >> ");
               this.webSocket.send("3:" + messageId + "::" + msg as String);
            }
            else
            {
               if(!(msg is Object))
               {
                  try
                  {
                     this.handShakeDebugArr.push("Time: " + Central.main.pvpDebugTime + "  FlashSocket:send Unsupported Message|" + typeof msg + " >> ");
                  }
                  catch(e:Error)
                  {
                     this.handShakeDebugArr.push("Time: " + Central.main.pvpDebugTime + "  FlashSocket:send Unsupported Message >> ");
                  }
                  throw "Unsupported Message Type";
               }
               this.debugArr.push(" F16 ");
               this.handShakeDebugArr.push("Time: " + Central.main.pvpDebugTime + "  FlashSocket:send:4::| " + msg + " >> ");
               this.webSocket.send("4:" + messageId + "::" + com.adobe.serialization.json.JSON.stringify(msg));
            }
         }
         else
         {
            this.handShakeDebugArr.push("Time: " + Central.main.pvpDebugTime + "  FlashSocket:send:5::| " + event + " >> ");
            this.debugArr.push(" F13 ");
            this.webSocket.send("5:" + messageId + "::" + com.adobe.serialization.json.JSON.stringify({
               "name":event,
               "args":msg
            }));
         }
      }
      
      public function emit(param1:String, param2:Object, param3:Function = null) : void
      {
         this.handShakeDebugArr.push("Time: " + Central.main.pvpDebugTime + "  FlashSocket:emit: " + param1 + " >> ");
         this.debugArr.push(" F11 ");
         this.send(param2,param1,param3);
      }
      
      private function _onConnect() : void
      {
         this.debugArr.push(" F10 ");
         this.connected = true;
         this.connecting = false;
         var _loc1_:FlashSocketEvent = new FlashSocketEvent(FlashSocketEvent.CONNECT);
         dispatchEvent(_loc1_);
      }
      
      private function _onDisconnect() : void
      {
         this.connected = false;
         this.connecting = false;
         var _loc1_:FlashSocketEvent = new FlashSocketEvent(FlashSocketEvent.DISCONNECT);
         dispatchEvent(_loc1_);
      }
      
      private function _encode(param1:*, param2:Boolean = false) : String
      {
         var _loc4_:String = null;
         var _loc3_:String = "";
         param1 = param1 is Array ? param1 : [param1];
         var _loc5_:int = 0;
         var _loc6_:int = int(param1.length);
         while(_loc5_ < _loc6_)
         {
            _loc4_ = param1[_loc5_] === null || param1[_loc5_] === undefined ? "" : param1[_loc5_].toString();
            if(param2)
            {
               _loc4_ = "~j~" + _loc4_;
            }
            _loc3_ += this.frame + _loc4_.length + this.frame + _loc4_;
            _loc5_++;
         }
         return _loc3_;
      }
      
      public function close() : void
      {
         this.webSocket.close();
      }
      
      public function getTimeStamp() : uint
      {
         var _loc1_:Date = new Date();
         return _loc1_.getTime();
      }
   }
}

