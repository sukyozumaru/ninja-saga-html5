package ninjasaga.asset
{
   import com.utils.GF;
   import com.utils.Out;
   import flash.display.MovieClip;
   import ninjasaga.Central;
   import ninjasaga.loader.AssetLoader;
   
   public class A_Weapon
   {
      
      public var wpnId:String;
      
      private var characterId:int;
      
      private var debugExtRandId:int;
      
      private var swf:MovieClip;
      
      private var displayList:Array = [];
      
      private const iconExportName:String = "icon";
      
      private const weaponExportName:String = "weapon";
      
      private var randomNo:int;
      
      public function A_Weapon(param1:String, param2:int = 0, param3:int = 0)
      {
         var _loc4_:String = null;
         super();
         this.wpnId = param1;
         this.characterId = param2;
         this.debugExtRandId = param3;
         _loc4_ = getSwfPath(param1);
         new AssetLoader(_loc4_,null,null,this.onLoadComplete);
         randomNo = Math.random() * 89999999 + 10000000;
      }
      
      private static function getSwfPath(param1:String) : String
      {
         var _loc3_:String = null;
         var _loc2_:Object = Central.main.WEAPON_DATA.find(param1);
         if(_loc2_)
         {
            _loc3_ = _loc2_.swfName;
            return "swf/items/" + _loc3_ + ".swf";
         }
         Out.debug("A_Weapon","getSwfPath :: wpnId >> " + param1);
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
         var stateDictionary:Object = null;
         var loadedAsset:* = undefined;
         var stateObjStr:String = null;
         var stateObj:MovieClip = null;
         var stateFrame:int = 0;
         var loadedAssetAsset:MovieClip = null;
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
               loadedAsset = GF.getAsset(this.swf,iconHolder.exportName);
               iconHolder.addChild(loadedAsset);
               stateDictionary = Central.main.stateInventory.getStateDictionary(this.characterId,"wpn",this.wpnId);
               loadedAssetAsset = loadedAsset["asset"];
               if(loadedAssetAsset != null && stateDictionary != null)
               {
                  for(stateObjStr in stateDictionary)
                  {
                     stateFrame = int(stateDictionary[stateObjStr]);
                     stateObj = loadedAssetAsset[stateObjStr];
                     if(stateObj != null)
                     {
                        stateObj.gotoAndStop(stateFrame);
                     }
                  }
               }
               loadedAssetAsset = loadedAsset;
               if(loadedAssetAsset != null && stateDictionary != null)
               {
                  for(stateObjStr in stateDictionary)
                  {
                     stateFrame = int(stateDictionary[stateObjStr]);
                     stateObj = loadedAssetAsset[stateObjStr];
                     if(stateObj != null)
                     {
                        stateObj.gotoAndStop(stateFrame);
                     }
                  }
               }
            }
            catch(err:Error)
            {
               §§push(err);
               var _temp_3:* = err;
               err = §§pop();
               Out.error(this,"refreshDisplay :: displayList :: " + err.getStackTrace());
            }
         }
      }
      
      public function getDisplay() : MovieClip
      {
         return this.getItem("weapon");
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

