package gs
{
   import flash.events.*;
   import flash.utils.*;
   
   use namespace flash_proxy;
   
   public dynamic class TweenGroup extends Proxy implements IEventDispatcher
   {
      
      public static const version:Number = 1.02;
      
      public static const ALIGN_INIT:String = "init";
      
      public static const ALIGN_START:String = "start";
      
      public static const ALIGN_END:String = "end";
      
      public static const ALIGN_SEQUENCE:String = "sequence";
      
      public static const ALIGN_NONE:String = "none";
      
      protected static var _TweenMax:Class;
      
      protected static var _classInitted:Boolean;
      
      protected static var _overwriteMode:int = OverwriteManager.enabled ? OverwriteManager.mode : OverwriteManager.init();
      
      protected static var _unexpired:Array = [];
      
      protected static var _prevTime:uint = 0;
      
      public var onComplete:Function;
      
      public var onCompleteParams:Array;
      
      public var loop:Number;
      
      public var yoyo:Number;
      
      public var endTime:Number;
      
      public var expired:Boolean;
      
      protected var _tweens:Array;
      
      protected var _pauseTime:Number;
      
      protected var _startTime:Number;
      
      protected var _initTime:Number;
      
      protected var _reversed:Boolean;
      
      protected var _align:String;
      
      protected var _stagger:Number;
      
      protected var _repeatCount:Number;
      
      protected var _dispatcher:EventDispatcher;
      
      public function TweenGroup(param1:Array = null, param2:Class = null, param3:String = "none", param4:Number = 0)
      {
         var $tweens:Array = param1;
         var $DefaultTweenClass:Class = param2;
         var $align:String = param3;
         var $stagger:Number = param4;
         super();
         if(!_classInitted)
         {
            if(TweenLite.version < 9.291)
            {
               trace("TweenGroup error! Please update your TweenLite class or try deleting your ASO files. TweenGroup requires a more recent version. Download updates at http://www.TweenLite.com.");
            }
            try
            {
               _TweenMax = getDefinitionByName("gs.TweenMax") as Class;
            }
            catch($e:Error)
            {
               _TweenMax = Array;
            }
            TweenLite.timingSprite.addEventListener(Event.ENTER_FRAME,checkExpiration,false,-1,true);
            _classInitted = true;
         }
         this.expired = true;
         _repeatCount = 0;
         _align = $align;
         _stagger = $stagger;
         _dispatcher = new EventDispatcher(this);
         if($tweens != null)
         {
            _tweens = parse($tweens,$DefaultTweenClass);
            updateTimeSpan();
            realign();
         }
         else
         {
            _tweens = [];
            _initTime = _startTime = this.endTime = 0;
         }
      }
      
      public static function parse(param1:Array, param2:Class = null) : Array
      {
         var _loc4_:int = 0;
         var _loc5_:Object = null;
         var _loc6_:Number = NaN;
         if(param2 == null)
         {
            param2 = TweenLite;
         }
         var _loc3_:Array = [];
         _loc4_ = 0;
         while(_loc4_ < param1.length)
         {
            if(param1[_loc4_] is TweenLite)
            {
               _loc3_[_loc3_.length] = param1[_loc4_];
            }
            else
            {
               _loc5_ = param1[_loc4_].target;
               _loc6_ = Number(param1[_loc4_].time);
               delete param1[_loc4_].target;
               delete param1[_loc4_].time;
               _loc3_[_loc3_.length] = new param2(_loc5_,_loc6_,param1[_loc4_]);
            }
            _loc4_++;
         }
         return _loc3_;
      }
      
      public static function allTo(param1:Array, param2:Number, param3:Object, param4:Class = null) : TweenGroup
      {
         var _loc5_:int = 0;
         var _loc6_:Object = null;
         var _loc7_:String = null;
         if(param4 == null)
         {
            param4 = TweenLite;
         }
         var _loc8_:TweenGroup = new TweenGroup(null,param4,ALIGN_INIT,Number(param3.stagger) || 0);
         _loc8_.onComplete = param3.onCompleteAll;
         _loc8_.onCompleteParams = param3.onCompleteAllParams;
         delete param3.stagger;
         delete param3.onCompleteAll;
         delete param3.onCompleteAllParams;
         _loc5_ = 0;
         while(_loc5_ < param1.length)
         {
            _loc6_ = {};
            for(_loc7_ in param3)
            {
               _loc6_[_loc7_] = param3[_loc7_];
            }
            _loc8_[_loc8_.length] = new param4(param1[_loc5_],param2,_loc6_);
            _loc5_++;
         }
         if(_loc8_.stagger < 0)
         {
            _loc8_.progressWithDelay = 0;
         }
         return _loc8_;
      }
      
      public static function allFrom(param1:Array, param2:Number, param3:Object, param4:Class = null) : TweenGroup
      {
         param3.runBackwards = true;
         return allTo(param1,param2,param3,param4);
      }
      
      protected static function checkExpiration(param1:Event) : void
      {
         var _loc4_:TweenGroup = null;
         var _loc5_:* = 0;
         var _loc2_:uint = TweenLite.currentTime;
         var _loc3_:Array = _unexpired;
         _loc5_ = int(_loc3_.length - 1);
         while(_loc5_ > -1)
         {
            _loc4_ = _loc3_[_loc5_];
            if(_loc4_.endTime > _prevTime && _loc4_.endTime <= _loc2_ && !_loc4_.paused)
            {
               _loc3_.splice(_loc5_,1);
               _loc4_.expired = true;
               _loc4_.handleCompletion();
            }
            _loc5_--;
         }
         _prevTime = _loc2_;
      }
      
      override flash_proxy function callProperty(param1:*, ... rest) : *
      {
         var _loc3_:* = _tweens[param1].apply(null,rest);
         realign();
         if(!isNaN(_pauseTime))
         {
            pause();
         }
         return _loc3_;
      }
      
      override flash_proxy function getProperty(param1:*) : *
      {
         return _tweens[param1];
      }
      
      override flash_proxy function setProperty(param1:*, param2:*) : void
      {
         onSetProperty(param1,param2);
      }
      
      protected function onSetProperty(param1:*, param2:*) : void
      {
         if(!isNaN(param1) && !(param2 is TweenLite))
         {
            trace("TweenGroup error: an attempt was made to add a non-TweenLite element.");
         }
         else
         {
            _tweens[param1] = param2;
            realign();
            if(!isNaN(_pauseTime) && param2 is TweenLite)
            {
               pauseTween(param2 as TweenLite);
            }
         }
      }
      
      override flash_proxy function hasProperty(param1:*) : Boolean
      {
         var _loc2_:String = " progress progressWithDelay duration durationWithDelay paused reversed timeScale align stagger tweens ";
         if(_tweens.hasOwnProperty(param1))
         {
            return true;
         }
         if(_loc2_.indexOf(" " + param1 + " ") != -1)
         {
            return true;
         }
         return false;
      }
      
      public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         _dispatcher.addEventListener(param1,param2,param3,param4,param5);
      }
      
      public function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
      {
         _dispatcher.removeEventListener(param1,param2,param3);
      }
      
      public function hasEventListener(param1:String) : Boolean
      {
         return _dispatcher.hasEventListener(param1);
      }
      
      public function willTrigger(param1:String) : Boolean
      {
         return _dispatcher.willTrigger(param1);
      }
      
      public function dispatchEvent(param1:Event) : Boolean
      {
         return _dispatcher.dispatchEvent(param1);
      }
      
      public function pause() : void
      {
         if(isNaN(_pauseTime))
         {
            _pauseTime = TweenLite.currentTime;
         }
         var _loc1_:* = int(_tweens.length - 1);
         while(_loc1_ > -1)
         {
            if(_tweens[_loc1_].startTime != 999999999999999)
            {
               pauseTween(_tweens[_loc1_]);
            }
            _loc1_--;
         }
      }
      
      public function resume() : void
      {
         var _loc2_:* = 0;
         var _loc4_:Number = NaN;
         var _loc1_:Array = [];
         var _loc3_:Number = TweenLite.currentTime;
         _loc2_ = int(_tweens.length - 1);
         while(_loc2_ > -1)
         {
            if(_tweens[_loc2_].startTime == 999999999999999)
            {
               resumeTween(_tweens[_loc2_]);
               _loc1_[_loc1_.length] = _tweens[_loc2_];
            }
            if(_tweens[_loc2_].startTime >= _loc3_ && !_tweens[_loc2_].enabled)
            {
               _tweens[_loc2_].enabled = true;
               _tweens[_loc2_].active = false;
            }
            _loc2_--;
         }
         if(!isNaN(_pauseTime))
         {
            _loc4_ = (TweenLite.currentTime - _pauseTime) / 1000;
            _pauseTime = NaN;
            offsetTime(_loc1_,_loc4_);
         }
      }
      
      public function restart(param1:Boolean = false) : void
      {
         setProgress(0,param1);
         _repeatCount = 0;
         resume();
      }
      
      public function reverse(param1:Boolean = true) : void
      {
         var _loc2_:* = 0;
         var _loc3_:TweenLite = null;
         var _loc4_:ReverseProxy = null;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         _reversed = !_reversed;
         var _loc9_:Number = 0;
         var _loc10_:Boolean = false;
         var _loc11_:Number = !isNaN(_pauseTime) ? _pauseTime : TweenLite.currentTime;
         if(this.endTime <= _loc11_)
         {
            _loc9_ = int(this.endTime - _loc11_) + 1;
            _loc10_ = true;
         }
         _loc2_ = int(_tweens.length - 1);
         while(_loc2_ > -1)
         {
            _loc3_ = _tweens[_loc2_];
            if(_loc3_ is _TweenMax)
            {
               _loc5_ = _loc3_.startTime;
               _loc6_ = _loc3_.initTime;
               (_loc3_ as Object).reverse(false,false);
               _loc3_.startTime = _loc5_;
               _loc3_.initTime = _loc6_;
            }
            else if(_loc3_.ease != _loc3_.vars.ease)
            {
               _loc3_.ease = _loc3_.vars.ease;
            }
            else
            {
               _loc4_ = new ReverseProxy(_loc3_);
               _loc3_.ease = _loc4_.reverseEase;
            }
            _loc8_ = _loc3_.combinedTimeScale;
            _loc7_ = ((_loc11_ - _loc3_.initTime) / 1000 - _loc3_.delay / _loc8_) / _loc3_.duration * _loc8_;
            _loc5_ = int(_loc11_ - (1 - _loc7_) * _loc3_.duration * 1000 / _loc8_ + _loc9_);
            _loc3_.initTime = int(_loc5_ - _loc3_.delay * (1000 / _loc8_));
            if(_loc3_.startTime != 999999999999999)
            {
               _loc3_.startTime = _loc5_;
            }
            if(_loc3_.startTime > _loc11_)
            {
               _loc3_.enabled = true;
               _loc3_.active = false;
            }
            _loc2_--;
         }
         updateTimeSpan();
         if(param1)
         {
            if(_loc10_)
            {
               setProgress(0,true);
            }
            resume();
         }
      }
      
      public function getActive() : Array
      {
         var _loc2_:* = 0;
         var _loc3_:Number = NaN;
         var _loc1_:Array = [];
         if(isNaN(_pauseTime))
         {
            _loc3_ = TweenLite.currentTime;
            _loc2_ = int(_tweens.length - 1);
            while(_loc2_ > -1)
            {
               if(_tweens[_loc2_].startTime <= _loc3_ && getEndTime(_tweens[_loc2_]) >= _loc3_)
               {
                  _loc1_[_loc1_.length] = _tweens[_loc2_];
               }
               _loc2_--;
            }
         }
         return _loc1_;
      }
      
      public function mergeGroup(param1:TweenGroup, param2:Number = NaN) : void
      {
         var _loc5_:int = 0;
         if(isNaN(param2) || param2 > _tweens.length)
         {
            param2 = _tweens.length;
         }
         var _loc3_:Array = param1.tweens;
         var _loc4_:uint = _loc3_.length;
         _loc5_ = 0;
         while(_loc5_ < _loc4_)
         {
            _tweens.splice(param2 + _loc5_,0,_loc3_[_loc5_]);
            _loc5_++;
         }
         realign();
      }
      
      public function clear(param1:Boolean = true) : void
      {
         var _loc2_:* = int(_tweens.length - 1);
         while(_loc2_ > -1)
         {
            if(param1)
            {
               TweenLite.removeTween(_tweens[_loc2_],true);
            }
            _tweens[_loc2_] = null;
            _tweens.splice(_loc2_,1);
            _loc2_--;
         }
         if(!this.expired)
         {
            _loc2_ = int(_unexpired.length - 1);
            while(_loc2_ > -1)
            {
               if(_unexpired[_loc2_] == this)
               {
                  _unexpired.splice(_loc2_,1);
                  break;
               }
               _loc2_--;
            }
            this.expired = true;
         }
      }
      
      public function realign() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:int = 0;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:Boolean = false;
         if(_align != ALIGN_NONE && _tweens.length > 1)
         {
            _loc1_ = _tweens.length;
            _loc3_ = _stagger * 1000;
            _loc5_ = _reversed;
            if(_loc5_)
            {
               _loc4_ = this.progressWithDelay;
               reverse();
               this.progressWithDelay = 0;
            }
            if(_align == ALIGN_SEQUENCE)
            {
               setTweenInitTime(_tweens[0],_initTime);
               _loc2_ = 1;
               while(_loc2_ < _loc1_)
               {
                  setTweenInitTime(_tweens[_loc2_],getEndTime(_tweens[_loc2_ - 1]) + _loc3_);
                  _loc2_++;
               }
            }
            else if(_align == ALIGN_INIT)
            {
               _loc2_ = 0;
               while(_loc2_ < _loc1_)
               {
                  setTweenInitTime(_tweens[_loc2_],_initTime + _loc3_ * _loc2_);
                  _loc2_++;
               }
            }
            else if(_align == ALIGN_START)
            {
               _loc2_ = 0;
               while(_loc2_ < _loc1_)
               {
                  setTweenStartTime(_tweens[_loc2_],_startTime + _loc3_ * _loc2_);
                  _loc2_++;
               }
            }
            else
            {
               _loc2_ = 0;
               while(_loc2_ < _loc1_)
               {
                  setTweenInitTime(_tweens[_loc2_],this.endTime - (_tweens[_loc2_].delay + _tweens[_loc2_].duration) * 1000 / _tweens[_loc2_].combinedTimeScale - _loc3_ * _loc2_);
                  _loc2_++;
               }
            }
            if(_loc5_)
            {
               reverse();
               this.progressWithDelay = _loc4_;
            }
         }
         updateTimeSpan();
      }
      
      public function updateTimeSpan() : void
      {
         var _loc1_:* = 0;
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:TweenLite = null;
         if(_tweens.length == 0)
         {
            this.endTime = _startTime = _initTime = 0;
         }
         else
         {
            _loc5_ = _tweens[0];
            _initTime = _loc5_.initTime;
            _startTime = _initTime + _loc5_.delay * (1000 / _loc5_.combinedTimeScale);
            this.endTime = _startTime + _loc5_.duration * (1000 / _loc5_.combinedTimeScale);
            _loc1_ = int(_tweens.length - 1);
            while(_loc1_ > 0)
            {
               _loc5_ = _tweens[_loc1_];
               _loc3_ = _loc5_.initTime;
               _loc2_ = _loc3_ + _loc5_.delay * (1000 / _loc5_.combinedTimeScale);
               _loc4_ = _loc2_ + _loc5_.duration * (1000 / _loc5_.combinedTimeScale);
               if(_loc3_ < _initTime)
               {
                  _initTime = _loc3_;
               }
               if(_loc2_ < _startTime)
               {
                  _startTime = _loc2_;
               }
               if(_loc4_ > this.endTime)
               {
                  this.endTime = _loc4_;
               }
               _loc1_--;
            }
            if(this.expired && this.endTime > TweenLite.currentTime)
            {
               this.expired = false;
               _unexpired[_unexpired.length] = this;
            }
         }
      }
      
      public function toString() : String
      {
         return "TweenGroup( " + _tweens.toString() + " )";
      }
      
      protected function offsetTime(param1:Array, param2:Number) : void
      {
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:Array = null;
         var _loc6_:Boolean = false;
         var _loc7_:TweenLite = null;
         var _loc8_:Boolean = false;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc11_:* = 0;
         var _loc12_:Array = null;
         if(param1.length != 0)
         {
            _loc3_ = param2 * 1000;
            _loc4_ = isNaN(_pauseTime) ? TweenLite.currentTime : _pauseTime;
            _loc5_ = getRenderOrder(param1,_loc4_);
            _loc12_ = [];
            _loc11_ = int(_loc5_.length - 1);
            while(_loc11_ > -1)
            {
               _loc7_ = _loc5_[_loc11_];
               _loc7_.initTime += _loc3_;
               _loc6_ = Boolean(_loc7_.startTime == 999999999999999);
               _loc9_ = _loc7_.initTime + _loc7_.delay * (1000 / _loc7_.combinedTimeScale);
               _loc10_ = getEndTime(_loc7_);
               _loc8_ = (_loc9_ <= _loc4_ || _loc9_ - _loc3_ <= _loc4_) && (_loc10_ >= _loc4_ || _loc10_ - _loc3_ >= _loc4_);
               if(isNaN(_pauseTime) && _loc10_ >= _loc4_)
               {
                  _loc7_.enabled = true;
               }
               if(!_loc6_)
               {
                  _loc7_.startTime = _loc9_;
               }
               if(_loc9_ >= _loc4_)
               {
                  if(!_loc7_.initted)
                  {
                     _loc8_ = false;
                  }
                  _loc7_.active = false;
               }
               if(_loc8_)
               {
                  _loc12_[_loc12_.length] = _loc7_;
               }
               _loc11_--;
            }
            _loc11_ = int(_loc12_.length - 1);
            while(_loc11_ > -1)
            {
               renderTween(_loc12_[_loc11_],_loc4_);
               _loc11_--;
            }
            this.endTime += _loc3_;
            _startTime += _loc3_;
            _initTime += _loc3_;
            if(this.expired && this.endTime > _loc4_)
            {
               this.expired = false;
               _unexpired[_unexpired.length] = this;
            }
         }
      }
      
      protected function renderTween(param1:TweenLite, param2:Number) : void
      {
         var _loc4_:Number = NaN;
         var _loc5_:Boolean = false;
         var _loc6_:Boolean = false;
         var _loc7_:Number = NaN;
         var _loc3_:Number = getEndTime(param1);
         if(param1.startTime == 999999999999999)
         {
            param1.startTime = param1.initTime + param1.delay * (1000 / param1.combinedTimeScale);
            _loc5_ = true;
         }
         if(!param1.initted)
         {
            _loc6_ = param1.active;
            param1.active = false;
            if(_loc5_)
            {
               param1.initTweenVals();
               if(param1.vars.onStart != null)
               {
                  param1.vars.onStart.apply(null,param1.vars.onStartParams);
               }
            }
            else
            {
               param1.activate();
            }
            param1.active = _loc6_;
         }
         if(param1.startTime > param2)
         {
            _loc4_ = param1.startTime;
         }
         else if(_loc3_ < param2)
         {
            _loc4_ = _loc3_;
         }
         else
         {
            _loc4_ = param2;
         }
         if(_loc4_ < 0)
         {
            _loc7_ = param1.startTime;
            param1.startTime -= _loc4_;
            param1.render(0);
            param1.startTime = _loc7_;
         }
         else
         {
            param1.render(_loc4_);
         }
         if(_loc5_)
         {
            param1.startTime = 999999999999999;
         }
      }
      
      protected function getRenderOrder(param1:Array, param2:Number) : Array
      {
         var _loc3_:* = 0;
         var _loc4_:Number = NaN;
         var _loc5_:Array = [];
         var _loc6_:Array = [];
         var _loc7_:Array = [];
         _loc3_ = int(param1.length - 1);
         while(_loc3_ > -1)
         {
            _loc4_ = getStartTime(param1[_loc3_]);
            if(_loc4_ >= param2)
            {
               _loc5_[_loc5_.length] = {
                  "start":_loc4_,
                  "tween":param1[_loc3_]
               };
            }
            else
            {
               _loc6_[_loc6_.length] = {
                  "end":getEndTime(param1[_loc3_]),
                  "tween":param1[_loc3_]
               };
            }
            _loc3_--;
         }
         _loc5_.sortOn("start",Array.NUMERIC);
         _loc6_.sortOn("end",Array.NUMERIC);
         _loc3_ = int(_loc5_.length - 1);
         while(_loc3_ > -1)
         {
            _loc7_[_loc3_] = _loc5_[_loc3_].tween;
            _loc3_--;
         }
         _loc3_ = int(_loc6_.length - 1);
         while(_loc3_ > -1)
         {
            _loc7_[_loc7_.length] = _loc6_[_loc3_].tween;
            _loc3_--;
         }
         return _loc7_;
      }
      
      protected function pauseTween(param1:TweenLite) : void
      {
         if(param1 is _TweenMax)
         {
            (param1 as Object).pauseTime = _pauseTime;
         }
         param1.startTime = 999999999999999;
         param1.enabled = false;
      }
      
      protected function resumeTween(param1:TweenLite) : void
      {
         if(param1 is _TweenMax)
         {
            (param1 as Object).pauseTime = NaN;
         }
         param1.startTime = param1.initTime + param1.delay * (1000 / param1.combinedTimeScale);
      }
      
      protected function getEndTime(param1:TweenLite) : Number
      {
         return param1.initTime + (param1.delay + param1.duration) * (1000 / param1.combinedTimeScale);
      }
      
      protected function getStartTime(param1:TweenLite) : Number
      {
         return param1.initTime + param1.delay * 1000 / param1.combinedTimeScale;
      }
      
      protected function setTweenInitTime(param1:TweenLite, param2:Number) : void
      {
         var _loc3_:Number = param2 - param1.initTime;
         param1.initTime = param2;
         if(param1.startTime != 999999999999999)
         {
            param1.startTime += _loc3_;
         }
      }
      
      protected function setTweenStartTime(param1:TweenLite, param2:Number) : void
      {
         var _loc3_:Number = param2 - getStartTime(param1);
         param1.initTime += _loc3_;
         if(param1.startTime != 999999999999999)
         {
            param1.startTime = param2;
         }
      }
      
      protected function getProgress(param1:Boolean = false) : Number
      {
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         if(_tweens.length == 0)
         {
            return 0;
         }
         _loc2_ = isNaN(_pauseTime) ? TweenLite.currentTime : _pauseTime;
         _loc3_ = param1 ? _initTime : _startTime;
         _loc4_ = (_loc2_ - _loc3_) / (this.endTime - _loc3_);
         if(_loc4_ < 0)
         {
            return 0;
         }
         if(_loc4_ > 1)
         {
            return 1;
         }
         return _loc4_;
      }
      
      protected function setProgress(param1:Number, param2:Boolean = false) : void
      {
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         if(_tweens.length != 0)
         {
            _loc3_ = isNaN(_pauseTime) ? TweenLite.currentTime : _pauseTime;
            _loc4_ = param2 ? _initTime : _startTime;
            offsetTime(_tweens,(_loc3_ - (_loc4_ + (this.endTime - _loc4_) * param1)) / 1000);
         }
      }
      
      public function handleCompletion() : void
      {
         if(!isNaN(this.yoyo) && (_repeatCount < this.yoyo || this.yoyo == 0))
         {
            ++_repeatCount;
            reverse(true);
         }
         else if(!isNaN(this.loop) && (_repeatCount < this.loop || this.loop == 0))
         {
            ++_repeatCount;
            setProgress(0,true);
         }
         if(this.onComplete != null)
         {
            this.onComplete.apply(null,this.onCompleteParams);
         }
         _dispatcher.dispatchEvent(new Event(Event.COMPLETE));
      }
      
      public function get length() : uint
      {
         return _tweens.length;
      }
      
      public function get progress() : Number
      {
         return getProgress(false);
      }
      
      public function set progress(param1:Number) : void
      {
         setProgress(param1,false);
      }
      
      public function get progressWithDelay() : Number
      {
         return getProgress(true);
      }
      
      public function set progressWithDelay(param1:Number) : void
      {
         setProgress(param1,true);
      }
      
      public function get duration() : Number
      {
         if(_tweens.length == 0)
         {
            return 0;
         }
         return (this.endTime - _startTime) / 1000;
      }
      
      public function get durationWithDelay() : Number
      {
         if(_tweens.length == 0)
         {
            return 0;
         }
         return (this.endTime - _initTime) / 1000;
      }
      
      public function get paused() : Boolean
      {
         return !isNaN(_pauseTime);
      }
      
      public function set paused(param1:Boolean) : void
      {
         if(param1)
         {
            pause();
         }
         else
         {
            resume();
         }
      }
      
      public function get reversed() : Boolean
      {
         return _reversed;
      }
      
      public function set reversed(param1:Boolean) : void
      {
         if(_reversed != param1)
         {
            reverse(true);
         }
      }
      
      public function get timeScale() : Number
      {
         var _loc1_:uint = 0;
         while(_loc1_ < _tweens.length)
         {
            if(_tweens[_loc1_] is _TweenMax)
            {
               return _tweens[_loc1_].timeScale;
            }
            _loc1_++;
         }
         return 1;
      }
      
      public function set timeScale(param1:Number) : void
      {
         var _loc2_:* = int(_tweens.length - 1);
         while(_loc2_ > -1)
         {
            if(_tweens[_loc2_] is _TweenMax)
            {
               _tweens[_loc2_].timeScale = param1;
            }
            _loc2_--;
         }
         updateTimeSpan();
      }
      
      public function get align() : String
      {
         return _align;
      }
      
      public function set align(param1:String) : void
      {
         _align = param1;
         realign();
      }
      
      public function get stagger() : Number
      {
         return _stagger;
      }
      
      public function set stagger(param1:Number) : void
      {
         _stagger = param1;
         realign();
      }
      
      public function get tweens() : Array
      {
         return _tweens.slice();
      }
   }
}

import gs.TweenLite;

class ReverseProxy
{
   
   private var _tween:TweenLite;
   
   public function ReverseProxy(param1:TweenLite)
   {
      super();
      _tween = param1;
   }
   
   public function reverseEase(param1:Number, param2:Number, param3:Number, param4:Number) : Number
   {
      return _tween.vars.ease(param4 - param1,param2,param3,param4);
   }
}
