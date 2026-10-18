package ninjasaga.linkage
{
   import br.com.stimuli.loading.BulkErrorEvent;
   import br.com.stimuli.loading.BulkLoader;
   import br.com.stimuli.loading.BulkProgressEvent;
   import com.utils.GF;
   import com.utils.Out;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.utils.getTimer;
   import ninjasaga.Central;
   import ninjasaga.data.AppData;
   import ninjasaga.data.Data;
   import ninjasaga.data.StaticVariables;
   import ninjasaga.data.Timeline;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol48")]
   public class Preloader extends MovieClip
   {
      
      public var preloaderMC:MovieClip;
      
      private var byVersion:Boolean = false;
      
      private var loadSwfArr:Array = null;
      
      private var onCompleteFn:Function;
      
      private var completeParams:Object;
      
      private var _displayText:String;
      
      private var _tipDisplayText:String;
      
      private var loader:BulkLoader;
      
      private var loadingShown:Boolean = false;
      
      public function Preloader()
      {
         super();
         addFrameScript(0,this.frame1,9,this.frame10);
      }
      
      public function show() : void
      {
         this.gotoAndStop(Timeline.SHOW);
      }
      
      public function hide() : void
      {
         this.loadingShown = false;
         this.gotoAndStop(Timeline.IDLE);
      }
      
      public function get isLoading() : Boolean
      {
         if(this.currentLabel == Timeline.IDLE)
         {
            return false;
         }
         return true;
      }
      
      public function onShow() : void
      {
         this.stop();
         if(Boolean(Central.main) && Central.main.preloader_status == 1)
         {
            this["preloaderMC"].gotoAndPlay("old_mc");
         }
         else
         {
            this["preloaderMC"].gotoAndPlay("new_mc");
         }
      }
      
      public function updateMc() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:String = null;
         this.loadingShown = true;
         if(this["preloaderMC"]["percentTxt"])
         {
            this["preloaderMC"]["percentTxt"].text = "0";
         }
         if(this["preloaderMC"]["loadingIcon"]["loadingBar"])
         {
            this["preloaderMC"]["loadingIcon"]["loadingBar"].gotoAndStop(1);
         }
         if(Central.main)
         {
            switch(AppData.lang)
            {
               case AppData.CN:
                  this["preloaderMC"]["statusTxt"].text = "载入中......";
                  break;
               case AppData.ZH:
                  this["preloaderMC"]["statusTxt"].text = "載入中......";
                  break;
               default:
                  this["preloaderMC"]["statusTxt"].text = "Loading...";
            }
         }
         else
         {
            switch(AppData.lang)
            {
               case AppData.CN:
                  this["preloaderMC"]["statusTxt"].text = "载入中......";
                  break;
               case AppData.ZH:
                  this["preloaderMC"]["statusTxt"].text = "載入中......";
                  break;
               default:
                  this["preloaderMC"]["statusTxt"].text = "Loading...";
            }
         }
         if(this._displayText)
         {
            this["preloaderMC"]["statusTxt"].text = this._displayText;
         }
         if(this.loadSwfArr != null)
         {
            if(this.loadSwfArr.length == 0)
            {
               this.onLoadFinish(null);
               return;
            }
            this.loader = BulkLoader.createUniqueNamedLoader();
            _loc1_ = 0;
            while(_loc1_ < this.loadSwfArr.length)
            {
               if(this.byVersion)
               {
                  if(StaticVariables.loadType == Data.LOAD_TYPE_LOCAL || String(this.loadSwfArr[_loc1_].path).indexOf("http://") >= 0)
                  {
                     _loc2_ = this.loadSwfArr[_loc1_].path;
                  }
                  else
                  {
                     _loc2_ = Data.STATIC_SERVER + "swf/" + this.loadSwfArr[_loc1_].version + "/" + this.loadSwfArr[_loc1_].path;
                  }
               }
               else if(StaticVariables.loadType == Data.LOAD_TYPE_LOCAL || String(this.loadSwfArr[_loc1_]).indexOf("http://") >= 0)
               {
                  _loc2_ = this.loadSwfArr[_loc1_];
               }
               else
               {
                  _loc2_ = Data.STATIC_SERVER + "swf/" + Data.BUILD_NO + "/" + this.loadSwfArr[_loc1_];
               }
               this.loader.add(_loc2_);
               _loc1_++;
            }
            this.loader.addEventListener(BulkLoader.COMPLETE,this.onLoadFinish);
            this.loader.addEventListener(BulkLoader.PROGRESS,this.onLoadProgress);
            this.loader.addEventListener(BulkLoader.ERROR,this.onLoadError);
            this.loader.start();
         }
      }
      
      private function onIdle() : void
      {
      }
      
      private function onLoadFinish(param1:Event) : void
      {
         var _loc6_:String = null;
         var _loc7_:String = null;
         var _loc8_:int = 0;
         var _loc2_:Object = new Object();
         var _loc3_:Object = new Object();
         var _loc4_:Array = [];
         var _loc5_:uint = 0;
         while(_loc5_ < this.loadSwfArr.length)
         {
            _loc6_ = "";
            while(!_loc2_[_loc6_])
            {
               if(this.byVersion)
               {
                  _loc6_ = this.loadSwfArr[_loc5_].path;
                  if(StaticVariables.loadType == Data.LOAD_TYPE_LOCAL || String(this.loadSwfArr[_loc5_].path).indexOf("http://") >= 0)
                  {
                     _loc2_[this.loadSwfArr[_loc5_].path] = this.loader.getMovieClip(this.loadSwfArr[_loc5_].path);
                  }
                  else
                  {
                     _loc2_[this.loadSwfArr[_loc5_].path] = this.loader.getMovieClip(Data.STATIC_SERVER + "swf/" + this.loadSwfArr[_loc5_].version + "/" + this.loadSwfArr[_loc5_].path);
                  }
               }
               else
               {
                  _loc6_ = this.loadSwfArr[_loc5_];
                  if(StaticVariables.loadType == Data.LOAD_TYPE_LOCAL || String(_loc6_).indexOf("http://") >= 0)
                  {
                     _loc2_[_loc6_] = this.loader.getMovieClip(_loc6_);
                  }
                  else
                  {
                     _loc2_[_loc6_] = this.loader.getMovieClip(Data.STATIC_SERVER + "swf/" + Data.BUILD_NO + "/" + _loc6_);
                  }
               }
               if(!_loc2_[_loc6_])
               {
                  _loc8_ = getTimer();
                  while(getTimer() - _loc8_ < 1000)
                  {
                  }
               }
            }
            _loc7_ = _loc2_[_loc6_].loaderInfo.url;
            _loc4_.push([_loc7_,_loc2_[_loc6_].loaderInfo.bytesTotal,_loc2_[_loc6_].loaderInfo.bytesLoaded,_loc2_[_loc6_].loaderInfo.sameDomain,_loc2_[_loc6_].loaderInfo.swfVersion,_loc2_[_loc6_].loaderInfo.actionScriptVersion,_loc2_[_loc6_].loaderInfo.parameters]);
            _loc5_++;
         }
         this.loader.removeAll();
         this.loadSwfArr = null;
         this.hide();
         trace("rockman>>>>>>>>>>>>>>>>>onloadfinish swfObj = " + GF.printObject(_loc2_));
         if(this.completeParams == null)
         {
            this.onCompleteFn(_loc2_);
         }
         else
         {
            this.onCompleteFn(_loc2_,this.completeParams);
         }
         if(Central.main.isNewChar)
         {
            return;
         }
         trace("rockman>>>>>>>>>>>>>>>>>onloadfinish before fileCheck check.");
         if(Central.main != null)
         {
            if("fileCheck" in Central.main)
            {
               trace("rockman>>>>>>>>>>>>>>>>>onloadfinish fileCheck found");
               Central.main.fileCheck(_loc4_);
            }
            else
            {
               trace("rockman>>>>>>>>>>>>>>>>>onloadfinish fileCheck NOT found");
               Central.main.onError("302");
            }
         }
      }
      
      private function onLoadProgress(param1:BulkProgressEvent) : void
      {
         var _loc2_:Number = param1.percentLoaded;
         if(_loc2_ > 0)
         {
            this.showLoadingProgress(_loc2_);
         }
      }
      
      private function onLoadError(param1:BulkErrorEvent) : void
      {
         var _loc2_:* = undefined;
         for each(_loc2_ in param1.errors)
         {
            Out.error(this," BulkLoader :: " + _loc2_ + " has failed to load.");
            Central.main.onError("0","Some files failed to load. Please reload the game.");
         }
      }
      
      public function loadSwf(param1:Array, param2:Function, param3:Object, param4:String = null) : void
      {
         this.byVersion = false;
         this.loadSwfArr = param1;
         this.onCompleteFn = param2;
         this.completeParams = param3;
         this._displayText = param4;
         this.show();
      }
      
      public function loadSwfByVersion(param1:Array, param2:Function, param3:Object, param4:String = null) : void
      {
         this.byVersion = true;
         this.loadSwfArr = param1;
         this.onCompleteFn = param2;
         this.completeParams = param3;
         this._displayText = param4;
         this.show();
      }
      
      public function set displayText(param1:String) : void
      {
         this["preloaderMC"]["statusTxt"].text = param1;
      }
      
      public function showLoadingProgress(param1:Number) : void
      {
         var _loc2_:int = 0;
         if(this.loadingShown)
         {
            _loc2_ = Math.ceil(param1 * 100);
            this["preloaderMC"]["percentTxt"].text = String(_loc2_);
            if(_loc2_ == 0)
            {
               this["preloaderMC"]["loadingIcon"]["loadingBar"].gotoAndStop(1);
            }
            else
            {
               this["preloaderMC"]["loadingIcon"]["loadingBar"].gotoAndStop(_loc2_);
            }
         }
      }
      
      public function dynamicLoad(param1:String, param2:Function) : void
      {
         if(!(StaticVariables.loadType == Data.LOAD_TYPE_LOCAL || String(param1).indexOf("http://") >= 0 || String(param1).indexOf("https://") >= 0))
         {
            param1 = Data.STATIC_SERVER + "swf/" + Data.BUILD_NO + "/" + param1;
         }
         new OneTimeLoader(param1,param2);
      }
      
      internal function frame1() : *
      {
         this.onShow();
      }
      
      internal function frame10() : *
      {
         this.onIdle();
      }
   }
}

import br.com.stimuli.loading.BulkErrorEvent;
import br.com.stimuli.loading.BulkLoader;
import br.com.stimuli.loading.BulkProgressEvent;
import com.utils.Out;
import flash.display.MovieClip;
import flash.events.Event;

class OneTimeLoader
{
   
   private var path:String;
   
   private var callback:Function;
   
   private var loader:BulkLoader;
   
   public function OneTimeLoader(param1:String, param2:Function)
   {
      super();
      this.path = param1;
      this.callback = param2;
      this.loader = BulkLoader.createUniqueNamedLoader();
      this.loader.add(this.path);
      this.loader.addEventListener(BulkLoader.COMPLETE,this.onLoadFinish);
      this.loader.addEventListener(BulkLoader.PROGRESS,this.onLoadProgress);
      this.loader.addEventListener(BulkLoader.ERROR,this.onLoadError);
      this.loader.start();
   }
   
   private function onLoadFinish(param1:Event) : void
   {
      var _loc2_:MovieClip = this.loader.getMovieClip(this.path);
      this.loader.removeAll();
      this.loader.removeEventListener(BulkLoader.COMPLETE,this.onLoadFinish);
      this.loader.removeEventListener(BulkLoader.PROGRESS,this.onLoadProgress);
      this.loader.removeEventListener(BulkLoader.ERROR,this.onLoadError);
      this.callback(_loc2_);
   }
   
   private function onLoadProgress(param1:BulkProgressEvent) : void
   {
   }
   
   private function onLoadError(param1:BulkErrorEvent) : void
   {
      var _loc2_:* = undefined;
      for each(_loc2_ in param1.errors)
      {
         Out.error(this,"BulkLoader :: OneTimeLoader :: " + _loc2_ + " has failed to load.");
      }
   }
}
