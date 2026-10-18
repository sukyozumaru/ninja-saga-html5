package com.utils
{
   import flash.display.MovieClip;
   
   public class LoadPhoto
   {
      
      private static var instance:LoadPhoto;
      
      public function LoadPhoto(param1:SingletonBlocker)
      {
         super();
         if(param1 == null)
         {
            throw new Error("Error: Instantiation failed: Use LoadPhoto.getInstance() instead of new.");
         }
      }
      
      public static function getInstance() : LoadPhoto
      {
         if(instance == null)
         {
            instance = new LoadPhoto(new SingletonBlocker());
         }
         return instance;
      }
      
      public function load(param1:String, param2:MovieClip) : void
      {
         var _loc3_:ConnectionInstance = new ConnectionInstance(param1,param2);
      }
   }
}

import com.utils.Out;
import de.polygonal.ds.HashMap;
import flash.display.DisplayObject;
import flash.display.Loader;
import flash.display.LoaderInfo;
import flash.display.MovieClip;
import flash.display.Sprite;
import flash.events.AsyncErrorEvent;
import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.events.SecurityErrorEvent;
import flash.net.URLRequest;
import flash.system.LoaderContext;

class SingletonBlocker
{
   
   public function SingletonBlocker()
   {
      super();
   }
}

class ConnectionInstance
{
   
   private var curLoaders:Array;
   
   private var loaderArr:Array;
   
   private var photoArr:Array;
   
   private var isLoadingPhoto:Boolean = false;
   
   private var loaderMap:HashMap;
   
   private var loaderUnique:uint = 0;
   
   private var photoPath:String;
   
   private var photoHolder:MovieClip;
   
   public function ConnectionInstance(param1:String, param2:MovieClip)
   {
      var i:uint = 0;
      var loader:Loader = null;
      var lctx:LoaderContext = null;
      var _path:String = param1;
      var _photoHolder:MovieClip = param2;
      this.curLoaders = [];
      this.loaderArr = [];
      this.photoArr = [];
      this.loaderMap = new HashMap();
      super();
      try
      {
         if(_path)
         {
            loader = new Loader();
            lctx = new LoaderContext(true);
            loader.contentLoaderInfo.addEventListener(Event.INIT,this.onLoaderInit);
            loader.addEventListener(AsyncErrorEvent.ASYNC_ERROR,this.errorHandlerAsyncErrorEvent);
            loader.addEventListener(IOErrorEvent.IO_ERROR,this.errorHandlerIOErrorEvent);
            loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.errorHandlerSecurityErrorEvent);
            loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.infoIOErrorEvent);
            ++this.loaderUnique;
            this.photoPath = _path;
            this.photoHolder = _photoHolder;
            loader.load(new URLRequest(_path),lctx);
            return;
         }
      }
      catch(error:Error)
      {
         trace("LoadPhoto.as Error " + Error.getErrorMessage);
      }
   }
   
   private function onLoaderInit(param1:Event) : void
   {
      var lInfo:LoaderInfo = null;
      var dO:DisplayObject = null;
      var sprt:Sprite = null;
      var evt:Event = param1;
      lInfo = evt.target as LoaderInfo;
      try
      {
         dO = lInfo.loader.content;
      }
      catch(err:SecurityError)
      {
         sprt = new Sprite();
         sprt.addChild(lInfo.loader);
         dO = sprt as DisplayObject;
      }
      dO.width = 50;
      dO.height = 50;
      this.photoHolder.addChild(dO);
      lInfo.loader.removeEventListener(Event.INIT,this.onLoaderInit);
   }
   
   private function infoIOErrorEvent(param1:IOErrorEvent) : void
   {
      Out.debug(this,"infoIOErrorEvent " + param1.toString());
   }
   
   private function errorHandlerIOErrorEvent(param1:IOErrorEvent) : void
   {
      Out.debug(this,"errorHandlerIOErrorEvent " + param1.toString());
   }
   
   private function errorHandlerAsyncErrorEvent(param1:AsyncErrorEvent) : void
   {
      Out.debug(this,"errorHandlerAsyncErrorEvent " + param1.toString());
   }
   
   private function errorHandlerSecurityErrorEvent(param1:SecurityErrorEvent) : void
   {
      Out.debug(this,"errorHandlerSecurityErrorEvent " + param1.toString());
   }
}
