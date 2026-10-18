package ninjasaga.asset
{
   import com.utils.GF;
   import com.utils.Out;
   import flash.display.MovieClip;
   import flash.net.URLRequest;
   import ninjasaga.Central;
   import ninjasaga.loader.AssetLoader;
   
   public class A_Accessory
   {
      
      public var acsyId:String;
      
      private var swf:MovieClip;
      
      private var displayList:Array = [];
      
      private const iconExportName:String = "icon";
      
      private const accessoryExportName:String = "accessory";
      
      public function A_Accessory(param1:String)
      {
         super();
         this.acsyId = param1;
         var _loc2_:String = getSwfPath(param1);
         new AssetLoader(_loc2_,null,null,this.onLoadComplete);
      }
      
      private static function getSwfPath(param1:String) : String
      {
         var _loc3_:String = null;
         var _loc2_:Object = Central.main.ACCESSORY_DATA.find(param1);
         if(_loc2_)
         {
            _loc3_ = _loc2_.swfName;
            return "swf/items/" + _loc3_ + ".swf";
         }
         Out.debug("A_Accessory","getSwfPath :: backId >> " + param1);
         return null;
      }
      
      private function onLoadComplete(param1:AssetLoader) : void
      {
         this.swf = param1.swf;
         this.refreshDisplay();
      }
      
      private function refreshDisplay() : void
      {
         var iconHolder:MovieClip = null;
         if(null == this.swf)
         {
            return;
         }
         while(this.displayList.length > 0)
         {
            iconHolder = this.displayList.shift();
            try
            {
               GF.removeAllChild(iconHolder);
               iconHolder.addChild(GF.getAsset(this.swf,iconHolder.exportName));
            }
            catch(err:Error)
            {
               §§push(err);
               var _temp_1:* = err;
               err = §§pop();
               Out.error(this,"refreshDisplay :: displayList :: " + err.getStackTrace());
            }
         }
      }
      
      public function getDisplay() : MovieClip
      {
         return this.getItem("accessory");
      }
      
      public function getIcon() : MovieClip
      {
         return this.getItem("icon",true);
      }
      
      private function getItem(param1:String, param2:Boolean = false) : MovieClip
      {
         var _loc3_:MovieClip = new MovieClip();
         if(param2)
         {
            _loc3_ = Central.main.getLib("LoadingMc");
         }
         _loc3_.exportName = param1;
         this.displayList.push(_loc3_);
         this.refreshDisplay();
         return _loc3_;
      }
   }
}

