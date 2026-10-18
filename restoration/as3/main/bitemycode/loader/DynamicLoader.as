package bitemycode.loader
{
   import com.utils.GF;
   import com.utils.Out;
   import de.polygonal.ds.HashMap;
   import flash.display.MovieClip;
   
   public class DynamicLoader
   {
      
      private static var loaderCounter:int = 0;
      
      private static var storage:HashMap = new HashMap();
      
      protected var loaderId:int;
      
      protected var path:String;
      
      protected var holder:MovieClip;
      
      protected var cls:String;
      
      protected var cbfn:Function;
      
      protected var addCache:Boolean;
      
      public function DynamicLoader(param1:String, param2:MovieClip, param3:String = null, param4:Function = null, param5:Boolean = false)
      {
         super();
         this.path = param1;
         this.holder = param2;
         this.cls = param3;
         this.cbfn = param4;
         this.addCache = param5;
         if(param1 == null)
         {
            Out.error(this,"path is null");
         }
         else if(param5 && this.get(this.path) != null)
         {
            this.loadCallback(this.get(this.path));
         }
         else
         {
            new OneTimeLoader(param1,this.loadCallback);
         }
         this.loaderId = ++loaderCounter;
      }
      
      public static function load(param1:String, param2:MovieClip, param3:String = null, param4:Function = null, param5:Boolean = false) : DynamicLoader
      {
         return new DynamicLoader(param1,param2,param3,param4,param5);
      }
      
      public function getLoaderId() : int
      {
         return this.loaderId;
      }
      
      protected function loadCallback(param1:MovieClip) : void
      {
         if(this.addCache)
         {
            if(this.get(this.path) == null)
            {
               if(param1 != null)
               {
                  this.set(this.path,param1);
               }
            }
         }
         if(this.cls == null)
         {
            this.refreshHolder(param1);
         }
         else
         {
            this.refreshHolder(GF.getAsset(param1,this.cls));
         }
         if(this.cbfn != null)
         {
            this.cbfn(this.loaderId,this.holder);
         }
         this.gc();
      }
      
      protected function refreshHolder(param1:MovieClip) : void
      {
         var _loc2_:int = 0;
         if(param1)
         {
            if(this.holder)
            {
               GF.removeAllChild(this.holder);
               this.holder.addChild(param1);
            }
            else
            {
               Out.error(this,"refreshHolder :: holder is null");
            }
         }
         else
         {
            Out.error(this,"refreshHolder :: mc is null");
         }
      }
      
      protected function gc() : void
      {
         this.path = null;
         this.holder = null;
         this.cls = null;
         this.cbfn = null;
         this.addCache = false;
      }
      
      protected function get(param1:String) : *
      {
         return storage.find(param1);
      }
      
      protected function set(param1:String, param2:*) : void
      {
         storage.insert(param1,param2);
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
      this.loader = null;
      this.callback = null;
      this.path = null;
   }
   
   private function onLoadProgress(param1:BulkProgressEvent) : void
   {
   }
   
   private function onLoadError(param1:BulkErrorEvent) : void
   {
      var _loc2_:* = undefined;
      for each(_loc2_ in param1.errors)
      {
         Out.error(this,"BulkLoader :: " + _loc2_ + " has failed to load.");
      }
   }
}
