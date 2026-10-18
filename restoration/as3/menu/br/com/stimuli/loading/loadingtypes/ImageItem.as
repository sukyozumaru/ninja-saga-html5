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
      
      public function ImageItem(url:URLRequest, type:String, uid:String)
      {
         specificAvailableProps = [BulkLoader.CONTEXT];
         super(url,type,uid);
      }
      
      override public function _parseOptions(props:Object) : Array
      {
         context = props[BulkLoader.CONTEXT] || null;
         return super._parseOptions(props);
      }
      
      override public function load() : void
      {
         super.load();
         this.loader = new Loader();
         this.loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS,onProgressHandler,false,0,true);
         this.loader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onCompleteHandler,false,0,true);
         this.loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.onErrorHandler,false,100,true);
         this.loader.contentLoaderInfo.addEventListener(Event.OPEN,onStartedHandler,false,0,true);
         this.loader.contentLoaderInfo.addEventListener(HTTPStatusEvent.HTTP_STATUS,super.onHttpStatusHandler,false,0,true);
         this.loader.load(url,context);
      }
      
      public function _onHttpStatusHandler(evt:HTTPStatusEvent) : void
      {
         _httpStatus = evt.status;
         dispatchEvent(evt);
      }
      
      override public function onErrorHandler(evt:Event) : void
      {
         super.onErrorHandler(evt);
      }
      
      override public function onCompleteHandler(evt:Event) : void
      {
         try
         {
            _content = this.loader.content;
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
            if(this.loader)
            {
               this.loader.close();
            }
         }
         catch(e:Error)
         {
         }
         super.stop();
      }
      
      override public function cleanListeners() : void
      {
         var removalTarget:Object = null;
         if(this.loader)
         {
            removalTarget = this.loader.contentLoaderInfo;
            removalTarget.removeEventListener(ProgressEvent.PROGRESS,onProgressHandler,false);
            removalTarget.removeEventListener(Event.COMPLETE,this.onCompleteHandler,false);
            removalTarget.removeEventListener(IOErrorEvent.IO_ERROR,this.onErrorHandler,false);
            removalTarget.removeEventListener(BulkLoader.OPEN,onStartedHandler,false);
            removalTarget.removeEventListener(HTTPStatusEvent.HTTP_STATUS,super.onHttpStatusHandler,false);
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
         this.stop();
         this.cleanListeners();
         _content = null;
         this.loader = null;
      }
   }
}

