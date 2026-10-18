package br.com.stimuli.loading.loadingtypes
{
   import br.com.stimuli.loading.BulkErrorEvent;
   import br.com.stimuli.loading.BulkLoader;
   import flash.display.*;
   import flash.events.*;
   import flash.net.*;
   import flash.utils.*;
   
   public class LoadingItem extends EventDispatcher
   {
      
      public static const STATUS_STOPPED:String = "stopped";
      
      public static const STATUS_STARTED:String = "started";
      
      public static const STATUS_FINISHED:String = "finished";
      
      public static const STATUS_ERROR:String = "error";
      
      public var _type:String;
      
      public var url:URLRequest;
      
      public var _id:String;
      
      public var _uid:String;
      
      public var _additionIndex:int;
      
      public var _priority:int = 0;
      
      public var _isLoaded:Boolean;
      
      public var _isLoading:Boolean;
      
      public var status:String;
      
      public var maxTries:int = 3;
      
      public var numTries:int = 0;
      
      public var weight:int = 1;
      
      public var preventCache:Boolean;
      
      public var _bytesTotal:int = -1;
      
      public var _bytesLoaded:int = 0;
      
      public var _bytesRemaining:int = 10000000;
      
      public var _percentLoaded:Number;
      
      public var _weightPercentLoaded:Number;
      
      public var _addedTime:int;
      
      public var _startTime:int;
      
      public var _responseTime:Number;
      
      public var _latency:Number;
      
      public var _totalTime:int;
      
      public var _timeToDownload:int;
      
      public var _speed:Number;
      
      public var _content:*;
      
      public var _httpStatus:int = -1;
      
      public var context:* = null;
      
      public var specificAvailableProps:Array;
      
      public var propertyParsingErrors:Array;
      
      public function LoadingItem(param1:URLRequest, param2:String, param3:String)
      {
         super();
         this._type = param2;
         this.url = param1;
         if(!specificAvailableProps)
         {
            specificAvailableProps = [];
         }
         this._uid = param3;
      }
      
      public function _parseOptions(param1:Object) : Array
      {
         var _loc3_:String = null;
         preventCache = param1[BulkLoader.PREVENT_CACHING];
         _id = param1[BulkLoader.ID];
         _priority = int(param1[BulkLoader.PRIORITY]) || 0;
         maxTries = int(param1[BulkLoader.MAX_TRIES]) || 3;
         weight = int(param1[BulkLoader.WEIGHT]) || 1;
         var _loc2_:Array = BulkLoader.GENERAL_AVAILABLE_PROPS.concat(specificAvailableProps);
         propertyParsingErrors = [];
         for(_loc3_ in param1)
         {
            if(_loc2_.indexOf(_loc3_) == -1)
            {
               propertyParsingErrors.push(this + ": got a wrong property name: " + _loc3_ + ", with value:" + param1[_loc3_]);
            }
         }
         return propertyParsingErrors;
      }
      
      public function get content() : *
      {
         return _content;
      }
      
      public function load() : void
      {
         _isLoading = true;
         _startTime = getTimer();
      }
      
      public function onHttpStatusHandler(param1:HTTPStatusEvent) : void
      {
         _httpStatus = param1.status;
         dispatchEvent(param1);
      }
      
      public function onProgressHandler(param1:*) : void
      {
         _bytesLoaded = param1.bytesLoaded;
         _bytesTotal = param1.bytesTotal;
         _bytesRemaining = _bytesTotal - bytesLoaded;
         _percentLoaded = _bytesLoaded / _bytesTotal;
         _weightPercentLoaded = _percentLoaded * weight;
         dispatchEvent(param1);
      }
      
      public function onCompleteHandler(param1:Event) : void
      {
         _totalTime = getTimer();
         _timeToDownload = (_totalTime - _responseTime) / 1000;
         if(_timeToDownload == 0)
         {
            _timeToDownload = 0.2;
         }
         _speed = BulkLoader.truncateNumber(bytesTotal / 1024 / _timeToDownload);
         if(_timeToDownload == 0)
         {
            _speed = 3000;
         }
         status = STATUS_FINISHED;
         _isLoaded = true;
         dispatchEvent(param1);
         param1.stopPropagation();
      }
      
      public function onErrorHandler(param1:Event) : void
      {
         var _loc2_:BulkErrorEvent = null;
         ++numTries;
         status = STATUS_ERROR;
         param1.stopPropagation();
         if(numTries >= maxTries)
         {
            _loc2_ = new BulkErrorEvent(BulkErrorEvent.ERROR);
            _loc2_.errors = [this];
            dispatchEvent(_loc2_);
         }
         else
         {
            status = null;
            load();
         }
      }
      
      public function onStartedHandler(param1:Event) : void
      {
         _responseTime = getTimer();
         _latency = BulkLoader.truncateNumber((_responseTime - _startTime) / 1000);
         status = STATUS_STARTED;
         dispatchEvent(param1);
      }
      
      override public function toString() : String
      {
         return "LoadingItem url: " + url.url + ", type:" + _type + ", status: " + status;
      }
      
      public function stop() : void
      {
         if(_isLoaded)
         {
            return;
         }
         status = STATUS_STOPPED;
         _isLoading = false;
      }
      
      public function cleanListeners() : void
      {
      }
      
      public function isVideo() : Boolean
      {
         return false;
      }
      
      public function isSound() : Boolean
      {
         return false;
      }
      
      public function isText() : Boolean
      {
         return false;
      }
      
      public function isXML() : Boolean
      {
         return false;
      }
      
      public function isImage() : Boolean
      {
         return false;
      }
      
      public function isSWF() : Boolean
      {
         return false;
      }
      
      public function isLoader() : Boolean
      {
         return false;
      }
      
      public function isStreamable() : Boolean
      {
         return false;
      }
      
      public function destroy() : void
      {
         _content = null;
      }
      
      public function get bytesTotal() : int
      {
         return _bytesTotal;
      }
      
      public function get bytesLoaded() : int
      {
         return _bytesLoaded;
      }
      
      public function get bytesRemaining() : int
      {
         return _bytesRemaining;
      }
      
      public function get percentLoaded() : Number
      {
         return _percentLoaded;
      }
      
      public function get weightPercentLoaded() : Number
      {
         return _weightPercentLoaded;
      }
      
      public function get priority() : int
      {
         return _priority;
      }
      
      public function get type() : String
      {
         return _type;
      }
      
      public function get isLoaded() : Boolean
      {
         return _isLoaded;
      }
      
      public function get addedTime() : int
      {
         return _addedTime;
      }
      
      public function get startTime() : int
      {
         return _startTime;
      }
      
      public function get responseTime() : Number
      {
         return _responseTime;
      }
      
      public function get latency() : Number
      {
         return _latency;
      }
      
      public function get totalTime() : int
      {
         return _totalTime;
      }
      
      public function get timeToDownload() : int
      {
         return _timeToDownload;
      }
      
      public function get speed() : Number
      {
         return _speed;
      }
      
      public function get httpStatus() : int
      {
         return _httpStatus;
      }
      
      public function get id() : String
      {
         return _id;
      }
      
      public function getStats() : String
      {
         return "Item url:" + url.url + ", total time: " + _timeToDownload + "(s), latency:" + _latency + "(s), speed: " + _speed + " kb/s, size: " + BulkLoader.truncateNumber(_bytesTotal / 1024) + " kb";
      }
   }
}

