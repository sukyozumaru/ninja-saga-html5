package ninjasaga.loader
{
   import com.utils.GF;
   import de.polygonal.ds.HashMap;
   import flash.display.MovieClip;
   import ninjasaga.*;
   
   public class AssetLoader
   {
      
      private static var loadingPathArray:Array = [];
      
      private static var loadingCallbacks:HashMap = new HashMap();
      
      public var path:String;
      
      private var holder:*;
      
      private var clsName:String;
      
      private var callback:Function;
      
      public var swf:MovieClip;
      
      public var displayObj:MovieClip;
      
      public function AssetLoader(param1:String, param2:*, param3:String, param4:Function = null)
      {
         super();
         this.path = param1;
         this.holder = param2;
         this.clsName = param3;
         this.callback = param4;
         var _loc5_:MovieClip = Central.main.localCache.get(this.path);
         if(null == _loc5_)
         {
            if(loadingPathArray.indexOf(this.path) >= 0)
            {
               if(loadingCallbacks.containsKey(this.path))
               {
                  loadingCallbacks.insert(this.path,loadingCallbacks.find(this.path).push(this));
               }
               else
               {
                  loadingCallbacks.insert(this.path,[this]);
               }
            }
            else
            {
               loadingPathArray.push(this.path);
               Central.main.dynamicLoad(this.path,this.loadCallback);
            }
         }
         else
         {
            this.loadCallback(_loc5_);
         }
      }
      
      private function loadCallback(param1:MovieClip) : void
      {
         var _loc2_:MovieClip = null;
         Central.main.localCache.set(this.path,param1);
         loadingPathArray.splice(loadingPathArray.indexOf(this.path),1);
         this.swf = param1;
         if(null != this.holder)
         {
            _loc2_ = GF.getAsset(param1,this.clsName);
            this.holder.addChild(_loc2_);
            this.displayObj = _loc2_;
         }
         if(null != this.callback)
         {
            this.callback(this);
         }
         this.refreshAllCallback();
         this.gc();
      }
      
      private function gc() : void
      {
         this.path = null;
         this.holder = null;
         this.clsName = null;
         this.callback = null;
         this.swf = null;
         this.displayObj = null;
      }
      
      private function refreshAllCallback() : void
      {
         var _loc1_:Array = null;
         var _loc2_:int = 0;
         if(loadingCallbacks.containsKey(this.path))
         {
            _loc1_ = loadingCallbacks.find(this.path);
            loadingCallbacks.remove(this.path);
            _loc2_ = 0;
            while(_loc2_ < _loc1_.length)
            {
               _loc1_[_loc2_].loadCallback(this.swf);
               _loc2_++;
            }
         }
      }
   }
}

