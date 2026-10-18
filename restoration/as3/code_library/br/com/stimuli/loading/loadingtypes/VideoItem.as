package br.com.stimuli.loading.loadingtypes
{
   import br.com.stimuli.loading.BulkLoader;
   import flash.display.*;
   import flash.events.*;
   import flash.net.*;
   import flash.utils.*;
   
   public class VideoItem extends LoadingItem
   {
      
      private var nc:NetConnection;
      
      internal var stream:NetStream;
      
      private var dummyEventTrigger:Sprite;
      
      private var _checkPolicyFile:Boolean;
      
      internal var pausedAtStart:Boolean = false;
      
      private var _metaData:Object;
      
      private var _canBeginStreaming:Boolean = false;
      
      public function VideoItem(param1:URLRequest, param2:String, param3:String)
      {
         specificAvailableProps = [BulkLoader.CHECK_POLICY_FILE,BulkLoader.PAUSED_AT_START];
         super(param1,param2,param3);
      }
      
      override public function _parseOptions(param1:Object) : Array
      {
         pausedAtStart = Boolean(param1[BulkLoader.PAUSED_AT_START]);
         _checkPolicyFile = Boolean(param1[BulkLoader.CHECK_POLICY_FILE]);
         return super._parseOptions(param1);
      }
      
      override public function load() : void
      {
         var customClient:Object;
         super.load();
         nc = new NetConnection();
         nc.connect(null);
         stream = new NetStream(nc);
         stream.addEventListener(IOErrorEvent.IO_ERROR,onErrorHandler,false,0,true);
         stream.addEventListener(NetStatusEvent.NET_STATUS,onNetStatus,false,0,true);
         dummyEventTrigger = new Sprite();
         dummyEventTrigger.addEventListener(Event.ENTER_FRAME,createNetStreamEvent,false,0,true);
         customClient = new Object();
         customClient.onCuePoint = function(... rest):void
         {
         };
         customClient.onMetaData = onVideoMetadata;
         customClient.onPlayStatus = function(... rest):void
         {
         };
         stream.client = customClient;
         stream.play(url.url,_checkPolicyFile);
         stream.seek(0);
      }
      
      public function createNetStreamEvent(param1:Event) : void
      {
         var _loc2_:Event = null;
         var _loc3_:Event = null;
         var _loc4_:ProgressEvent = null;
         var _loc5_:int = 0;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         if(_bytesTotal == _bytesLoaded && _bytesTotal > 8)
         {
            if(dummyEventTrigger)
            {
               dummyEventTrigger.removeEventListener(Event.ENTER_FRAME,createNetStreamEvent,false);
            }
            _loc2_ = new Event(Event.COMPLETE);
            onCompleteHandler(_loc2_);
         }
         else if(_bytesTotal == 0 && stream.bytesTotal > 4)
         {
            _loc3_ = new Event(Event.OPEN);
            onStartedHandler(_loc3_);
            _bytesLoaded = stream.bytesLoaded;
            _bytesTotal = stream.bytesTotal;
         }
         else if(stream)
         {
            _loc4_ = new ProgressEvent(ProgressEvent.PROGRESS,false,false,stream.bytesLoaded,stream.bytesTotal);
            if(Boolean(isVideo()) && Boolean(metaData) && !_canBeginStreaming)
            {
               _loc5_ = getTimer() - responseTime;
               _loc6_ = bytesLoaded / (_loc5_ / 1000);
               _loc7_ = _bytesRemaining / (_loc6_ * 0.8);
               _loc8_ = metaData.duration - stream.bufferLength;
               if(_loc8_ > _loc7_)
               {
                  fireCanBeginStreamingEvent();
               }
            }
            super.onProgressHandler(_loc4_);
         }
      }
      
      override public function onCompleteHandler(param1:Event) : void
      {
         _content = stream;
         super.onCompleteHandler(param1);
      }
      
      override public function onStartedHandler(param1:Event) : void
      {
         _content = stream;
         if(pausedAtStart && Boolean(stream))
         {
            stream.pause();
         }
         super.onStartedHandler(param1);
      }
      
      override public function stop() : void
      {
         try
         {
            if(stream)
            {
               stream.close();
            }
         }
         catch(e:Error)
         {
         }
         super.stop();
      }
      
      override public function cleanListeners() : void
      {
         if(stream)
         {
            stream.removeEventListener(IOErrorEvent.IO_ERROR,onErrorHandler,false);
            stream.removeEventListener(NetStatusEvent.NET_STATUS,onNetStatus,false);
         }
         if(dummyEventTrigger)
         {
            dummyEventTrigger.removeEventListener(Event.ENTER_FRAME,createNetStreamEvent,false);
            dummyEventTrigger = null;
         }
      }
      
      override public function isVideo() : Boolean
      {
         return true;
      }
      
      override public function isStreamable() : Boolean
      {
         return true;
      }
      
      override public function destroy() : void
      {
         if(!stream)
         {
         }
         stop();
         cleanListeners();
         stream = null;
         super.destroy();
      }
      
      internal function onNetStatus(param1:NetStatusEvent) : void
      {
         var _loc2_:Event = null;
         if(!stream)
         {
            return;
         }
         stream.removeEventListener(NetStatusEvent.NET_STATUS,onNetStatus,false);
         if(param1.info.code == "NetStream.Play.Start")
         {
            _content = stream;
            _loc2_ = new Event(Event.OPEN);
            onStartedHandler(_loc2_);
         }
         else if(param1.info.code == "NetStream.Play.StreamNotFound")
         {
            onErrorHandler(param1);
         }
      }
      
      internal function onVideoMetadata(param1:*) : void
      {
         _metaData = param1;
      }
      
      public function get metaData() : Object
      {
         return _metaData;
      }
      
      public function get checkPolicyFile() : Object
      {
         return _checkPolicyFile;
      }
      
      private function fireCanBeginStreamingEvent() : void
      {
         if(_canBeginStreaming)
         {
            return;
         }
         _canBeginStreaming = true;
         var _loc1_:Event = new Event(BulkLoader.CAN_BEGIN_PLAYING);
         dispatchEvent(_loc1_);
      }
   }
}

