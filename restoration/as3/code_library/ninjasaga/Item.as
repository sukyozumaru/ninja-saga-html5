package ninjasaga
{
   import bitemycode.loader.DynamicLoader;
   import com.utils.GF;
   import com.utils.Out;
   import flash.display.MovieClip;
   import ninjasaga.battle.BattleProcessor;
   import ninjasaga.data.Data;
   import ninjasaga.data.InventoryData;
   import ninjasaga.data.Timeline;
   import ninjasaga.data.TooltipData;
   
   public class Item
   {
      
      private static var itemList:Object = new Object();
      
      private var itemSwf:MovieClip;
      
      public var itemId:String;
      
      public function Item(param1:String)
      {
         super();
         this.itemId = param1;
      }
      
      public static function setItem(param1:Item) : void
      {
         itemList[param1.itemId] = param1;
      }
      
      public static function getItem(param1:String) : Item
      {
         return itemList[param1];
      }
      
      public static function hasItem(param1:String) : Boolean
      {
         var _loc2_:Item = itemList[param1];
         if(_loc2_ != null)
         {
            return true;
         }
         return false;
      }
      
      public static function getWeaponIcon(param1:String, param2:MovieClip, param3:int = 0) : void
      {
         if(param3 == 0)
         {
            param3 = int(Central.main.getMainChar().getCharacterId());
         }
         GF.removeAllChild(param2);
         param2.addChild(Central.main.asset.getWeaponIcon(param1,param3));
      }
      
      public static function getClothIcon(param1:String, param2:MovieClip) : void
      {
         GF.removeAllChild(param2);
         param2.addChild(Central.main.asset.getClothingIcon(param1));
      }
      
      public static function getBackItemIcon(param1:String, param2:MovieClip) : void
      {
         GF.removeAllChild(param2);
         param2.addChild(Central.main.asset.getBackItemIcon(param1));
      }
      
      public static function getAccessoryIcon(param1:String, param2:MovieClip) : void
      {
         GF.removeAllChild(param2);
         param2.addChild(Central.main.asset.getAccessoryIcon(param1));
      }
      
      public static function getHairIcon(param1:String, param2:MovieClip) : void
      {
         var _loc3_:Object = Central.main.HAIR_DATA.find(param1);
         if(Central.main.dataFilter(_loc3_) == false)
         {
            return;
         }
         var _loc4_:String = "swf/items/hair_" + _loc3_.swfName + ".swf";
         new IconLoader(_loc4_,param2);
      }
      
      public static function getItemIcon(param1:String, param2:MovieClip) : void
      {
         var _loc9_:String = null;
         GF.removeAllChild(param2);
         Out.debug("Item","getItemIcon itemId :: >> " + param1);
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:String = String(param1).slice(4);
         var _loc6_:int = int(_loc5_) % 50;
         var _loc7_:int = int(_loc5_) / 50;
         var _loc8_:Object = Central.main.ITEM_DATA.find(param1);
         if(Central.main.dataFilter(_loc8_) == false)
         {
            return;
         }
         _loc9_ = _loc8_.swfName;
         if(_loc6_ == 0)
         {
            _loc3_ = int(_loc5_);
            _loc4_ = int(_loc3_ - 49);
         }
         else
         {
            _loc3_ = int((_loc7_ + 1) * 50);
            _loc4_ = int(_loc3_ - 49);
         }
         var _loc10_:String = "";
         if(int(_loc5_) < 801)
         {
            Out.debug("Item","getItemIcon Tiklong :: >> before 801 >> " + int(_loc5_));
            _loc10_ = Data.genSwfFilePath("library/item_icons",String("item_icon_before_801"));
         }
         else
         {
            Out.debug("Item","getItemIcon Tiklong :: >> " + _loc4_.toString() + "-" + _loc3_.toString());
            _loc10_ = Data.genSwfFilePath("library/item_icons",String("item_icon_" + _loc4_.toString() + "-" + _loc3_.toString()));
         }
         Out.debug("Item","getItemIcon :: path >> " + _loc10_);
         Out.debug("Item","getItemIcon :: clsName >> " + _loc9_);
         DynamicLoader.load(_loc10_,param2,_loc9_,null,true);
      }
      
      public static function getEssenceIcon(param1:String, param2:MovieClip) : void
      {
         var _loc9_:String = null;
         Out.debug("Item","getEssenceIcon itemId :: >> " + param1);
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:String = String(param1).slice(4);
         var _loc6_:int = int(_loc5_) % 50;
         var _loc7_:int = int(_loc5_) / 50;
         var _loc8_:Object = Central.main.ESSENCE_DATA.find(param1);
         if(Central.main.dataFilter(_loc8_) == false)
         {
            return;
         }
         _loc9_ = _loc8_.swfName;
         if(_loc6_ == 0)
         {
            _loc3_ = int(_loc5_);
            _loc4_ = int(_loc3_ - 49);
         }
         else
         {
            _loc3_ = int((_loc7_ + 1) * 50);
            _loc4_ = int(_loc3_ - 49);
         }
         var _loc10_:String = "";
         if(int(_loc5_) < 801)
         {
            Out.debug("Item","getEssenceIcon Tiklong :: >> before 801 >> " + int(_loc5_));
            _loc10_ = Data.genSwfFilePath("library/item_icons",String("item_icon_before_801"));
         }
         else
         {
            Out.debug("Item","getEssenceIcon Tiklong :: >> " + _loc4_.toString() + "-" + _loc3_.toString());
            _loc10_ = Data.genSwfFilePath("library/item_icons",String("item_icon_" + _loc4_.toString() + "-" + _loc3_.toString()));
         }
         Out.debug("Item","getEssenceIcon :: path >> " + _loc10_);
         Out.debug("Item","getEssenceIcon :: clsName >> " + _loc9_);
         DynamicLoader.load(_loc10_,param2,_loc9_,null,true);
      }
      
      public static function getCurrencyIcon(param1:String, param2:MovieClip) : void
      {
         var _loc9_:String = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:String = String(param1).slice(4);
         var _loc6_:int = int(_loc5_) % 50;
         var _loc7_:int = int(_loc5_) / 50;
         var _loc8_:Object = Central.main.CURRENCY_DATA.find(param1);
         if(Central.main.dataFilter(_loc8_) == false)
         {
            return;
         }
         _loc9_ = _loc8_.swfName;
         if(_loc6_ == 0)
         {
            _loc3_ = int(_loc5_);
            _loc4_ = int(_loc3_ - 49);
         }
         else
         {
            _loc3_ = int((_loc7_ + 1) * 50);
            _loc4_ = int(_loc3_ - 49);
         }
         var _loc10_:String = "";
         if(int(_loc5_) < 801)
         {
            _loc10_ = Data.genSwfFilePath("library/item_icons",String("item_icon_before_801"));
         }
         else
         {
            _loc10_ = Data.genSwfFilePath("library/item_icons",String("item_icon_" + _loc4_.toString() + "-" + _loc3_.toString()));
         }
         DynamicLoader.load(_loc10_,param2,_loc9_,null,true);
      }
      
      public static function getMaterialIcon(param1:String, param2:MovieClip) : void
      {
         var _loc9_:String = null;
         Out.debug("Item","getMaterialIcon itemId :: >> " + param1);
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:String = String(param1).slice(4);
         var _loc6_:int = int(_loc5_) % 50;
         var _loc7_:int = int(_loc5_) / 50;
         var _loc8_:Object = Central.main.MATERIAL_DATA.find(param1);
         if(Central.main.dataFilter(_loc8_) == false)
         {
            return;
         }
         _loc9_ = _loc8_.swfName;
         if(_loc6_ == 0)
         {
            _loc3_ = int(_loc5_);
            _loc4_ = int(_loc3_ - 49);
         }
         else
         {
            _loc3_ = int((_loc7_ + 1) * 50);
            _loc4_ = int(_loc3_ - 49);
         }
         var _loc10_:String = "";
         if(int(_loc5_) < 801)
         {
            Out.debug("Item","getMaterialIcon Tiklong :: >> before 801 >> " + int(_loc5_));
            _loc10_ = Data.genSwfFilePath("library/item_icons",String("item_icon_before_801"));
         }
         else
         {
            Out.debug("Item","getMaterialIcon Tiklong :: >> " + _loc4_.toString() + "-" + _loc3_.toString());
            _loc10_ = Data.genSwfFilePath("library/item_icons",String("item_icon_" + _loc4_.toString() + "-" + _loc3_.toString()));
         }
         Out.debug("Item","getMaterialIcon :: path >> " + _loc10_);
         Out.debug("Item","getMaterialIcon :: clsName >> " + _loc9_);
         DynamicLoader.load(_loc10_,param2,_loc9_,null,true);
      }
      
      public static function getSkillIcon(param1:String, param2:MovieClip) : void
      {
         Out.debug("Item","getSkillIcon :: itemId >> " + param1);
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:String = String(param1).slice(6);
         var _loc6_:int = int(_loc5_) % 10;
         var _loc7_:int = int(_loc5_) / 10;
         if(_loc6_ == 0)
         {
            _loc3_ = int(_loc5_);
            _loc4_ = int(_loc3_ - 9);
         }
         else
         {
            _loc3_ = int((_loc7_ + 1) * 10);
            _loc4_ = int(_loc3_ - 9);
         }
         Out.debug("Item","getSkillIcon Hank :: >> " + _loc4_.toString() + "-" + _loc3_.toString());
         var _loc8_:String = Data.genSwfFilePath("library/icons",String("skill_icon_" + _loc4_.toString() + "-" + _loc3_.toString()));
         DynamicLoader.load(_loc8_,param2,param1,null,true);
      }
      
      public static function getWeaponModel(param1:String, param2:MovieClip, param3:Function = null) : void
      {
         var _loc4_:Object = Central.main.WEAPON_DATA.find(param1);
         if(Central.main.dataFilter(_loc4_) == false)
         {
            return;
         }
         var _loc5_:String = "swf/items/" + _loc4_.swfName + ".swf";
         new ModelLoader(_loc5_,"weapon",param1,param2,param3);
      }
      
      public static function getBackItemModel(param1:String, param2:MovieClip, param3:Function = null) : void
      {
         var _loc4_:Object = Central.main.BACK_ITEM_DATA.find(param1);
         if(Central.main.dataFilter(_loc4_) == false)
         {
            return;
         }
         var _loc5_:String = "swf/items/" + _loc4_.swfName + ".swf";
         new ModelLoader(_loc5_,"back_item",param1,param2,param3);
      }
      
      public static function getBodySetModel(param1:uint, param2:String, param3:MovieClip, param4:Function = null) : void
      {
         var _loc6_:String = null;
         var _loc5_:Object = param1 == 0 ? Central.main.BODY_SET_BOY : Central.main.BODY_SET_GIRL;
         if(Central.main.dataFilter(_loc5_[param2]) == false)
         {
            return;
         }
         if(_loc5_[param2])
         {
            _loc6_ = "swf/items/" + _loc5_[param2].swfName + ".swf";
            new ModelLoader(_loc6_,"icon",param2,param3,param4);
         }
      }
      
      public static function getPetModel(param1:String, param2:MovieClip, param3:Function = null) : void
      {
         var _loc4_:String = null;
         var _loc5_:Object = Central.main.PET_DATA.find("pet" + String(param1));
         if(_loc5_)
         {
            _loc4_ = _loc5_.swfName;
         }
         var _loc6_:Object = _loc5_;
         if(Central.main.dataFilter(_loc6_) == false)
         {
            return;
         }
         var _loc7_:String = "swf/pets/" + _loc4_ + ".swf";
         new ModelLoader(_loc7_,"StaticFullBody",param1,param2,param3);
      }
      
      public static function getDisplayData(param1:String) : Object
      {
         var _loc4_:Object = null;
         var _loc5_:String = null;
         var _loc6_:int = 0;
         var _loc7_:String = null;
         var _loc8_:* = undefined;
         var _loc9_:String = null;
         var _loc10_:String = null;
         var _loc11_:Array = null;
         var _loc12_:Object = null;
         var _loc13_:String = null;
         var _loc14_:Object = null;
         var _loc2_:MovieClip = Central.main.getLib("LoadingMc");
         var _loc3_:MovieClip = Central.main.getLib("LoadingMc");
         if(param1 == "emblem")
         {
            _loc7_ = "emblem";
            _loc4_ = new Object();
            GF.removeAllChild(_loc2_);
            _loc2_ = Central.main.getLib("emblemIcon");
            _loc5_ = Central.main.langLib.get(307);
         }
         else if(param1.indexOf("trainslot") >= 0)
         {
            _loc7_ = "trainslot";
            _loc4_ = new Object();
            GF.removeAllChild(_loc2_);
            _loc2_ = Central.main.getLib("trainSlotIcon");
            _loc5_ = "";
         }
         else if(param1.indexOf("gold") >= 0)
         {
            _loc7_ = "gold";
            _loc4_ = new Object();
            GF.removeAllChild(_loc2_);
            _loc2_ = Central.main.getLib("GoldIcon");
            _loc2_["txt"].text = String(param1).replace(_loc7_,"");
            _loc5_ = String(param1).replace(_loc7_,"") + " " + Central.main.langLib.get(1389);
            _loc4_.name = _loc5_;
         }
         else if(param1.indexOf("token") >= 0)
         {
            _loc7_ = "token";
            _loc4_ = new Object();
            GF.removeAllChild(_loc2_);
            _loc2_ = Central.main.getLib("TokenIcon");
            _loc2_["txt"].text = String(param1).replace(_loc7_,"");
            _loc5_ = String(param1).replace(_loc7_,"") + " " + Central.main.langLib.get(1390);
            _loc4_.name = _loc5_;
         }
         else if(param1.indexOf("MCoin") >= 0)
         {
            _loc7_ = "MCoin";
            _loc4_ = new Object();
            GF.removeAllChild(_loc2_);
            _loc2_ = Central.main.getLib("MCoinIcon");
            _loc2_["txt"].text = String(param1).replace(_loc7_,"");
            _loc5_ = String(param1).replace(_loc7_,"") + " " + Central.main.langLib.get(1390);
            _loc4_.name = _loc5_;
         }
         else if(param1.indexOf("wpn") >= 0)
         {
            _loc7_ = "wpn";
            _loc4_ = Central.main.WEAPON_DATA.find(param1);
            if(Central.main.dataFilter(_loc4_) == false)
            {
               return null;
            }
            getWeaponIcon(_loc4_.id,_loc2_);
            _loc5_ = TooltipData.getItemTooltip(TooltipData.TOOLTIP_TYPE_WEAPON,param1);
         }
         else if(param1.indexOf("set") >= 0)
         {
            _loc7_ = "set";
            _loc4_ = Central.main.BODY_SET_BOY[param1];
            if(_loc4_ == null)
            {
               _loc4_ = Central.main.BODY_SET_GIRL[param1];
            }
            if(Central.main.dataFilter(_loc4_) == false)
            {
               return null;
            }
            getClothIcon(_loc4_.id,_loc2_);
            _loc5_ = TooltipData.getItemTooltip(TooltipData.TOOLTIP_TYPE_CLOTHING,param1);
         }
         else if(param1.indexOf("back") >= 0)
         {
            _loc7_ = "back";
            _loc4_ = Central.main.BACK_ITEM_DATA.find(param1);
            if(Central.main.dataFilter(_loc4_) == false)
            {
               return null;
            }
            getBackItemIcon(_loc4_.id,_loc2_);
            _loc5_ = TooltipData.getItemTooltip(TooltipData.TOOLTIP_TYPE_BACKITEM,param1);
         }
         else if(param1.indexOf("acsy") >= 0)
         {
            _loc7_ = "acsy";
            _loc4_ = Central.main.ACCESSORY_DATA.find(param1);
            if(Central.main.dataFilter(_loc4_) == false)
            {
               return null;
            }
            getAccessoryIcon(_loc4_.id,_loc2_);
            _loc5_ = TooltipData.getItemTooltip(TooltipData.TOOLTIP_TYPE_ACCESSORY,param1);
         }
         else if(param1.indexOf("hair") >= 0)
         {
            _loc7_ = "hair";
            _loc4_ = Central.main.HAIR_DATA.find(param1);
            if(Central.main.dataFilter(_loc4_) == false)
            {
               return null;
            }
            getHairIcon(_loc4_.id,_loc2_);
            _loc5_ = TooltipData.getItemTooltip(TooltipData.TOOLTIP_TYPE_HAIR,param1);
         }
         else if(param1.indexOf("item") >= 0 || param1.indexOf("material") >= 0)
         {
            if(param1.indexOf("material") >= 0)
            {
               _loc9_ = String(param1).replace("material","item");
            }
            else
            {
               _loc9_ = param1;
            }
            _loc7_ = "item";
            _loc4_ = Central.main.ITEM_DATA.find(_loc9_);
            if(_loc4_)
            {
               if(Central.main.dataFilter(_loc4_) == false)
               {
                  return null;
               }
               getItemIcon(_loc4_.id,_loc2_);
               _loc5_ = TooltipData.getItemTooltip(TooltipData.TOOLTIP_TYPE_ITEM,_loc9_);
            }
            else
            {
               _loc4_ = Central.main.ESSENCE_DATA.find(_loc9_);
               if(_loc4_)
               {
                  if(Central.main.dataFilter(_loc4_) == false)
                  {
                     return null;
                  }
                  getEssenceIcon(_loc4_.id,_loc2_);
                  _loc5_ = TooltipData.getItemTooltip(TooltipData.TOOLTIP_TYPE_ESSENCE,_loc9_);
               }
               else
               {
                  _loc4_ = Central.main.MATERIAL_DATA.find(_loc9_);
                  if(_loc4_)
                  {
                     if(Central.main.dataFilter(_loc4_) == false)
                     {
                        return null;
                     }
                     getMaterialIcon(_loc4_.id,_loc2_);
                     _loc5_ = TooltipData.getItemTooltip(TooltipData.TOOLTIP_TYPE_MATERIAL,_loc9_);
                  }
                  else
                  {
                     _loc4_ = Central.main.CURRENCY_DATA.find(_loc9_);
                     if(_loc4_)
                     {
                        if(Central.main.dataFilter(_loc4_) == false)
                        {
                           return null;
                        }
                        getCurrencyIcon(_loc4_.id,_loc2_);
                        _loc5_ = TooltipData.getItemTooltip(TooltipData.TOOLTIP_TYPE_CURRENCY,_loc9_);
                     }
                  }
               }
            }
         }
         else if(param1.indexOf("petskill") >= 0)
         {
            _loc7_ = "petskill";
            _loc11_ = param1.split("_");
            _loc6_ = int(_loc11_[1]);
            _loc12_ = Central.main.PET_DATA.find("pet" + String(_loc6_));
            if(_loc12_)
            {
               _loc10_ = _loc8_.swfName;
               _loc4_ = _loc12_;
            }
            if(Central.main.dataFilter(_loc4_) == false)
            {
               return null;
            }
            _loc13_ = "swf/pets/" + _loc10_ + ".swf";
            new ModelLoader(_loc13_,"Skill_" + _loc11_[2],String(_loc6_),_loc2_);
         }
         else if(param1.indexOf("skill") >= 0)
         {
            _loc7_ = "skill";
            _loc4_ = Central.main.SKILL_DATA[param1];
            if(Central.main.dataFilter(_loc4_) == false)
            {
               return null;
            }
            _loc2_ = Central.main.getLib(_loc4_.swfName);
            _loc5_ = TooltipData.getItemTooltip(TooltipData.TOOLTIP_TYPE_SKILL,_loc4_.id);
         }
         else if(param1.indexOf("pet") >= 0)
         {
            _loc7_ = "pet";
            _loc14_ = Central.main.PET_DATA.find(param1);
            if(_loc14_)
            {
               _loc4_ = _loc14_;
            }
            if(Central.main.dataFilter(_loc4_) == false)
            {
               return null;
            }
            getPetModel(_loc4_.id,_loc3_);
            getPetIcon(_loc4_,_loc2_);
            _loc5_ = TooltipData.getItemTooltip(TooltipData.TOOLTIP_TYPE_PET,String(_loc4_.id));
         }
         if(_loc7_ == null)
         {
         }
         if(_loc4_.crystal == null)
         {
            _loc4_.crystal = _loc4_.token;
         }
         return {
            "mc":_loc2_,
            "mcFullBody":_loc3_,
            "itemData":_loc4_,
            "type":_loc7_,
            "tooltip":_loc5_
         };
      }
      
      public static function getPetIcon(param1:Object, param2:MovieClip) : void
      {
         if(Central.main.dataFilter(param1) == false)
         {
            return;
         }
         var _loc3_:String = "swf/pets/" + param1.swfName + ".swf";
         new IconLoader(_loc3_,param2);
      }
      
      public function setSwf(param1:MovieClip) : void
      {
         this.itemSwf = param1;
      }
      
      public function getAsset(param1:String) : MovieClip
      {
         var _clsName:String = param1;
         var cls:Class = null;
         try
         {
            cls = Class(this.itemSwf.loaderInfo.applicationDomain.getDefinition(_clsName));
         }
         catch(e:Error)
         {
            Out.error("Item",_clsName + " not found :: " + e.message);
         }
         if(cls == null)
         {
            return null;
         }
         return MovieClip(new cls());
      }
   }
}

import com.utils.GF;
import flash.display.MovieClip;
import ninjasaga.Central;

class IconLoader
{
   
   private var holder:MovieClip;
   
   public function IconLoader(param1:String, param2:MovieClip)
   {
      super();
      this.holder = param2;
      Central.main.dynamicLoad(param1,this.loadCallback);
   }
   
   private function loadCallback(param1:MovieClip) : void
   {
      GF.removeAllChild(this.holder);
      var _loc2_:MovieClip = GF.getAsset(param1,"icon");
      if(_loc2_)
      {
         this.holder.addChild(_loc2_);
      }
   }
}

class ModelLoader
{
   
   private var holder:MovieClip;
   
   private var modelName:String;
   
   private var cb_fn:Function;
   
   private var itemId:String;
   
   public function ModelLoader(param1:String, param2:String, param3:String, param4:MovieClip, param5:Function = null)
   {
      super();
      this.holder = param4;
      this.modelName = param2;
      this.cb_fn = param5;
      this.itemId = param3;
      var _loc6_:MovieClip = new MovieClip();
      _loc6_ = Central.main.getLib("LoadingMc");
      param4.addChild(_loc6_);
      Central.main.dynamicLoad(param1,this.loadCallback);
   }
   
   private function loadCallback(param1:MovieClip) : void
   {
      GF.removeAllChild(this.holder);
      var _loc2_:MovieClip = GF.getAsset(param1,this.modelName);
      if(this.cb_fn != null)
      {
         this.cb_fn(param1,holder,itemId);
         return;
      }
      if(_loc2_)
      {
         this.holder.addChild(_loc2_);
      }
   }
}
