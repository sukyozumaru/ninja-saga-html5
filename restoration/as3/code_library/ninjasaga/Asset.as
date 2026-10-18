package ninjasaga
{
   import com.utils.GF;
   import com.utils.Out;
   import de.polygonal.ds.HashMap;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import ninjasaga.asset.A_Accessory;
   import ninjasaga.asset.A_BackItem;
   import ninjasaga.asset.A_BodySet;
   import ninjasaga.asset.A_Face;
   import ninjasaga.asset.A_Sound;
   import ninjasaga.asset.A_Weapon;
   import ninjasaga.data.*;
   import ninjasaga.loader.AssetLoader;
   
   public class Asset
   {
      
      private static var instance:Asset;
      
      private var bodySetStorage:HashMap = new HashMap();
      
      private var weaponStroage:HashMap = new HashMap();
      
      private var backitemStroage:HashMap = new HashMap();
      
      private var accessoryStroage:HashMap = new HashMap();
      
      public function Asset(param1:SingletonBlocker)
      {
         super();
         if(param1 == null)
         {
            throw new Error("Error: Instantiation failed: Use Asset.getInstance() instead of new.");
         }
      }
      
      public static function getInstance() : Asset
      {
         if(instance == null)
         {
            instance = new Asset(new SingletonBlocker());
         }
         return instance;
      }
      
      public function getFace(param1:String, param2:Number = -1) : Sprite
      {
         return new A_Face(param1,param2);
      }
      
      private function getClothing(param1:String, param2:int) : A_BodySet
      {
         var _loc4_:A_BodySet = null;
         var _loc3_:String = param1 + "_" + param2;
         if(this.bodySetStorage.containsKey(_loc3_))
         {
            _loc4_ = this.bodySetStorage.find(_loc3_);
         }
         else
         {
            _loc4_ = new A_BodySet(param1,param2);
            this.bodySetStorage.insert(_loc3_,_loc4_);
         }
         return _loc4_;
      }
      
      public function getBodyPart(param1:String, param2:int, param3:String, param4:Number = -1) : Sprite
      {
         return this.getClothing(param1,param2).getPart(param3,param4);
      }
      
      public function getClothingIcon(param1:String) : MovieClip
      {
         var _loc2_:int = int(Central.main.getMainChar().getGender());
         if(param1 != "set1")
         {
            if(Central.main.BODY_SET_BOY[param1] == null)
            {
               _loc2_ = 1;
            }
            else
            {
               _loc2_ = 0;
            }
         }
         return this.getClothing(param1,_loc2_).getIcon();
      }
      
      private function getWeaponStroage(param1:String, param2:int, param3:int) : A_Weapon
      {
         var _loc6_:A_Weapon = null;
         var _loc4_:String = param1;
         var _loc5_:String = "";
         if(param1 == "wpn1596")
         {
            _loc5_ = "_" + param2;
         }
         if(this.weaponStroage.containsKey(_loc4_ + _loc5_))
         {
            _loc6_ = this.weaponStroage.find(_loc4_ + _loc5_);
         }
         else
         {
            _loc6_ = new A_Weapon(param1,param2,param3);
            this.weaponStroage.insert(_loc4_ + _loc5_,_loc6_);
         }
         return _loc6_;
      }
      
      public function getWeaponGraphic(param1:String, param2:int, param3:int) : MovieClip
      {
         return this.getWeaponStroage(param1,param2,param3).getDisplay();
      }
      
      public function getWeaponIcon(param1:String, param2:int = 0) : MovieClip
      {
         return this.getWeaponStroage(param1,param2,0).getIcon();
      }
      
      private function getBackItemStroage(param1:String) : A_BackItem
      {
         var _loc3_:A_BackItem = null;
         var _loc2_:String = param1;
         if(this.backitemStroage.containsKey(_loc2_))
         {
            _loc3_ = this.backitemStroage.find(_loc2_);
         }
         else
         {
            _loc3_ = new A_BackItem(param1);
            this.backitemStroage.insert(_loc2_,_loc3_);
         }
         return _loc3_;
      }
      
      public function getBackItemGraphic(param1:String) : MovieClip
      {
         return this.getBackItemStroage(param1).getDisplay();
      }
      
      public function getBackItemIcon(param1:String) : MovieClip
      {
         return this.getBackItemStroage(param1).getIcon();
      }
      
      private function getAccessoryStroage(param1:String) : A_Accessory
      {
         var _loc3_:A_Accessory = null;
         var _loc2_:String = param1;
         if(this.accessoryStroage.containsKey(_loc2_))
         {
            _loc3_ = this.accessoryStroage.find(_loc2_);
         }
         else
         {
            _loc3_ = new A_Accessory(param1);
            this.accessoryStroage.insert(_loc2_,_loc3_);
         }
         return _loc3_;
      }
      
      public function getAccessoryGraphic(param1:String) : MovieClip
      {
         return this.getAccessoryStroage(param1).getDisplay();
      }
      
      public function getAccessoryIcon(param1:String) : MovieClip
      {
         return this.getAccessoryStroage(param1).getIcon();
      }
      
      public function loadSound(param1:String, param2:String, param3:Function) : void
      {
         new A_Sound(param1,param2,param3);
      }
   }
}

class SingletonBlocker
{
   
   public function SingletonBlocker()
   {
      super();
   }
}
