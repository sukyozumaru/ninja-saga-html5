package br.com.stimuli.loading.loadingtypes
{
   import br.com.stimuli.loading.BulkLoader;
   import flash.display.*;
   import flash.events.*;
   import flash.net.*;
   import flash.utils.*;
   
   public class ImageItem extends LoadingItem
   {
      
      public var loader:Loader;
      
      public function ImageItem(param1:URLRequest, param2:String, param3:String)
      {
         specificAvailableProps = [BulkLoader.CONTEXT];
         super(param1,param2,param3);
      }
      
      override public function _parseOptions(param1:Object) : Array
      {
         context = param1[BulkLoader.CONTEXT] || null;
         return super._parseOptions(param1);
      }
      
      override public function load() : void
      {
         super.load();
         loader = new Loader();
         loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS,onProgressHandler,false,0,true);
         loader.contentLoaderInfo.addEventListener(Event.COMPLETE,onCompleteHandler,false,0,true);
         loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,onErrorHandler,false,100,true);
         loader.contentLoaderInfo.addEventListener(Event.OPEN,onStartedHandler,false,0,true);
         loader.contentLoaderInfo.addEventListener(HTTPStatusEvent.HTTP_STATUS,super.onHttpStatusHandler,false,0,true);
         loader.load(url,context);
      }
      
      public function _onHttpStatusHandler(param1:HTTPStatusEvent) : void
      {
         _httpStatus = param1.status;
         dispatchEvent(param1);
      }
      
      override public function onErrorHandler(param1:Event) : void
      {
         super.onErrorHandler(param1);
      }
      
      override public function onCompleteHandler(param1:Event) : void
      {
         var evt:Event = param1;
         try
         {
            _content = loader.content;
         }
         catch(err:Error)
         {
            trace("BulkLoader (Error) :: " + this + " :: onCompleteHandler :: error >> " + err);
            _content = new MovieClip();
         }
         super.onCompleteHandler(evt);
      }
      
      override public function stop() : void
      {
         try
         {
            if(loader)
            {
               loader.close();
            }
         }
         catch(e:Error)
         {
         }
         super.stop();
      }
      
      override public function cleanListeners() : void
      {
         var _loc1_:Object = null;
         if(loader)
         {
            _loc1_ = loader.contentLoaderInfo;
            _loc1_.removeEventListener(ProgressEvent.PROGRESS,onProgressHandler,false);
            _loc1_.removeEventListener(Event.COMPLETE,onCompleteHandler,false);
            _loc1_.removeEventListener(IOErrorEvent.IO_ERROR,onErrorHandler,false);
            _loc1_.removeEventListener(BulkLoader.OPEN,onStartedHandler,false);
            _loc1_.removeEventListener(HTTPStatusEvent.HTTP_STATUS,super.onHttpStatusHandler,false);
         }
      }
      
      override public function isImage() : Boolean
      {
         return type == BulkLoader.TYPE_IMAGE;
      }
      
      override public function isSWF() : Boolean
      {
         return type == BulkLoader.TYPE_MOVIECLIP;
      }
      
      override public function destroy() : void
      {
         stop();
         cleanListeners();
         _content = null;
         loader = null;
      }
   }
}

