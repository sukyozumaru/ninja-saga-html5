package ninjasaga
{
   import br.com.stimuli.loading.BulkErrorEvent;
   import com.utils.Out;
   import de.polygonal.ds.HashMap;
   import flash.display.*;
   import flash.events.*;
   import ninjasaga.data.DBCharacterData;
   import ninjasaga.data.Data;
   import ninjasaga.data.Formula;
   import ninjasaga.data.GameEvents;
   import ninjasaga.data.InventoryData;
   import ninjasaga.data.TitleData;
   import ninjasaga.data.TooltipData;
   import ninjasaga.dbclass.DBCharacter;
   
   public class Toolkit
   {
      
      private static var loadPetSwfNow:Boolean = false;
      
      private static var loadPetSwf:Array = [];
      
      public function Toolkit()
      {
         super();
      }
      
      public static function setRedirect(param1:String, param2:*) : void
      {
         Central.main.RedirectData = {
            "type":param1,
            "item":param2
         };
      }
      
      public static function clearRedirect() : void
      {
         Central.main.RedirectData = null;
      }
      
      public static function hasItem(param1:String) : Boolean
      {
         var _loc3_:Object = null;
         var _loc2_:String = "";
         if(param1.indexOf("wpn") >= 0)
         {
            _loc2_ = InventoryData.TYPE_WEAPON;
         }
         else if(param1.indexOf("back") >= 0)
         {
            _loc2_ = InventoryData.TYPE_BACK_ITEM;
         }
         else if(param1.indexOf("set") >= 0)
         {
            _loc2_ = InventoryData.TYPE_BODY_SET;
         }
         else if(param1.indexOf("item") >= 0)
         {
            _loc3_ = Toolkit.getDisplayData(param1);
            if(_loc3_.type == "item")
            {
               _loc2_ = InventoryData.TYPE_ITEM;
            }
            else if(_loc3_.type == "essence")
            {
               _loc2_ = InventoryData.TYPE_ESSENCE;
            }
            else if(_loc3_.type == "material")
            {
               _loc2_ = InventoryData.TYPE_MATERIAL;
            }
            else if(_loc3_.type == "currency")
            {
               _loc2_ = InventoryData.TYPE_CURRENCY;
            }
         }
         else if(param1.indexOf("pet") >= 0)
         {
            _loc2_ = InventoryData.TYPE_PET;
         }
         else if(param1.indexOf("hair") >= 0)
         {
            _loc2_ = InventoryData.TYPE_HAIR;
         }
         else if(param1.indexOf("skill") >= 0)
         {
            _loc2_ = InventoryData.TYPE_SKILL;
         }
         else if(param1.indexOf("acsy") >= 0)
         {
            _loc2_ = InventoryData.TYPE_ACCESSORY;
         }
         if(_loc2_ == "")
         {
            return false;
         }
         return Central.main.getMainChar().hasItem(_loc2_,param1,true);
      }
      
      public static function getItemCount(param1:String) : int
      {
         var _loc3_:Object = null;
         var _loc2_:String = "";
         if(param1.indexOf("wpn") >= 0)
         {
            _loc2_ = InventoryData.TYPE_WEAPON;
         }
         else if(param1.indexOf("back") >= 0)
         {
            _loc2_ = InventoryData.TYPE_BACK_ITEM;
         }
         else if(param1.indexOf("set") >= 0)
         {
            _loc2_ = InventoryData.TYPE_BODY_SET;
         }
         else if(param1.indexOf("item") >= 0)
         {
            _loc3_ = Toolkit.getDisplayData(param1);
            if(_loc3_.type == "item")
            {
               _loc2_ = InventoryData.TYPE_ITEM;
            }
            else if(_loc3_.type == "essence")
            {
               _loc2_ = InventoryData.TYPE_ESSENCE;
            }
            else if(_loc3_.type == "material")
            {
               _loc2_ = InventoryData.TYPE_MATERIAL;
            }
            else if(_loc3_.type == "currency")
            {
               _loc2_ = InventoryData.TYPE_CURRENCY;
            }
         }
         else if(param1.indexOf("pet") >= 0)
         {
            _loc2_ = InventoryData.TYPE_PET;
         }
         else if(param1.indexOf("hair") >= 0)
         {
            _loc2_ = InventoryData.TYPE_HAIR;
         }
         else if(param1.indexOf("skill") >= 0)
         {
            _loc2_ = InventoryData.TYPE_SKILL;
         }
         else if(param1.indexOf("acsy") >= 0)
         {
            _loc2_ = InventoryData.TYPE_ACCESSORY;
         }
         if(_loc2_ == "")
         {
            return 0;
         }
         return Central.main.getMainChar().getItemCount(_loc2_,param1);
      }
      
      public static function getDisplayData(param1:String, param2:Object = null) : Object
      {
         var _loc3_:MovieClip = null;
         var _loc5_:MovieClip = null;
         var _loc6_:Object = null;
         var _loc7_:String = null;
         var _loc8_:int = 0;
         var _loc10_:String = null;
         var _loc12_:String = null;
         var _loc13_:Array = null;
         var _loc14_:String = null;
         var _loc15_:Object = null;
         var _loc16_:MovieClip = null;
         var _loc17_:int = 0;
         var _loc4_:MovieClip = Central.main.getLib("LoadingMc");
         var _loc9_:int = 1;
         var _loc11_:int = 0;
         if(param1.indexOf("mgt") >= 0)
         {
            _loc10_ = "mgt";
            _loc6_ = {
               "id":param1,
               "crystal":0
            };
            _loc4_ = Central.main.getLib(param1.replace("mgt","MGT_"));
            _loc4_.width = 125;
            _loc4_.height = 125;
            _loc4_.x = -_loc4_.width / 2 * 0.8;
            _loc4_.y = -_loc4_.height * 0.81;
            if(_loc4_["txt"])
            {
               _loc4_["txt"].text = "";
            }
            _loc7_ = "";
         }
         if(param1.indexOf("scratch") >= 0)
         {
            _loc10_ = "dummy";
            _loc6_ = {
               "id":"scratch",
               "crystal":0
            };
            _loc4_ = Central.main.getLib("scratch_card");
            _loc4_["txt"].text = "";
            _loc7_ = Central.main.langLib.get(1681)[51];
         }
         if(param1.indexOf("huntermaster") >= 0)
         {
            _loc10_ = "dummy";
            _loc6_ = {
               "id":"huntermaster",
               "crystal":0
            };
            _loc4_ = Central.main.getLib(param1);
            _loc7_ = Central.main.langLib.get(1662)[30];
         }
         if(param1.indexOf("emblem") >= 0)
         {
            _loc10_ = "dummy";
            _loc6_ = {
               "id":"emblem",
               "crystal":0
            };
            _loc4_ = Central.main.getLib("emblemIcon");
            _loc7_ = Central.main.langLib.get(1665)[22];
         }
         if(param1.indexOf("wpn") >= 0)
         {
            _loc10_ = "wpn";
            _loc6_ = Central.main.WEAPON_DATA.find(param1);
            if(Central.main.dataFilter(_loc6_) == false)
            {
               return null;
            }
            Item.getWeaponIcon(_loc6_.id,_loc4_);
            _loc7_ = TooltipData.getItemTooltip(TooltipData.TOOLTIP_TYPE_WEAPON,param1);
         }
         if(param1.indexOf("set") >= 0)
         {
            _loc10_ = "set";
            _loc6_ = Central.main.BODY_SET_BOY[param1];
            if(_loc6_ == null)
            {
               _loc6_ = Central.main.BODY_SET_GIRL[param1];
            }
            if(Central.main.dataFilter(_loc6_) == false)
            {
               return null;
            }
            Item.getClothIcon(_loc6_.id,_loc4_);
            _loc7_ = TooltipData.getItemTooltip(TooltipData.TOOLTIP_TYPE_CLOTHING,param1);
         }
         if(param1.indexOf("acsy") >= 0)
         {
            _loc10_ = "acsy";
            _loc6_ = Central.main.ACCESSORY_DATA.find(param1);
            if(Central.main.dataFilter(_loc6_) == false)
            {
               return null;
            }
            Item.getAccessoryIcon(_loc6_.id,_loc4_);
            _loc7_ = TooltipData.getItemTooltip(TooltipData.TOOLTIP_TYPE_ACCESSORY,param1);
         }
         if(param1.indexOf("back") >= 0)
         {
            _loc10_ = "back";
            _loc6_ = Central.main.BACK_ITEM_DATA.find(param1);
            if(Central.main.dataFilter(_loc6_) == false)
            {
               return null;
            }
            Item.getBackItemIcon(_loc6_.id,_loc4_);
            _loc7_ = TooltipData.getItemTooltip(TooltipData.TOOLTIP_TYPE_BACKITEM,param1);
         }
         if(param1.indexOf("hair") >= 0)
         {
            _loc10_ = "hair";
            _loc6_ = Central.main.HAIR_DATA.find(param1);
            if(Central.main.dataFilter(_loc6_) == false)
            {
               return null;
            }
            Item.getHairIcon(_loc6_.id,_loc4_);
            _loc7_ = TooltipData.getItemTooltip(TooltipData.TOOLTIP_TYPE_HAIR,param1);
         }
         if(param1.indexOf("item") >= 0 || param1.indexOf("material") >= 0)
         {
            _loc6_ = Central.main.ITEM_DATA.find(param1);
            if(Central.main.dataFilter(_loc6_) == false)
            {
               return null;
            }
            if(_loc6_)
            {
               _loc10_ = "item";
               Item.getItemIcon(_loc6_.id,_loc4_);
               _loc7_ = TooltipData.getItemTooltip(TooltipData.TOOLTIP_TYPE_ITEM,param1);
            }
            if(!_loc6_)
            {
               _loc6_ = Central.main.ESSENCE_DATA.find(param1);
               if(_loc6_)
               {
                  _loc10_ = "essence";
                  Item.getEssenceIcon(_loc6_.id,_loc4_);
                  _loc7_ = TooltipData.getItemTooltip(TooltipData.TOOLTIP_TYPE_ESSENCE,param1);
               }
            }
            if(!_loc6_)
            {
               _loc13_ = [];
               _loc13_ = param1.split("_");
               param1 = _loc13_[0];
               _loc6_ = Central.main.CURRENCY_DATA.find(param1);
               if(_loc6_)
               {
                  _loc10_ = "currency";
                  if(String(param1).indexOf("item741") >= 0 || String(param1).indexOf("item742") >= 0)
                  {
                     _loc4_ = Central.main.getLib("item_741");
                     if(_loc13_[1] != null)
                     {
                        _loc8_ = int(_loc13_[1]);
                        _loc4_.txt.text = _loc8_;
                     }
                     _loc7_ = TooltipData.getItemTooltip(TooltipData.TOOLTIP_TYPE_CURRENCY,param1);
                  }
                  else
                  {
                     Item.getCurrencyIcon(_loc6_.id,_loc4_);
                     _loc7_ = TooltipData.getItemTooltip(TooltipData.TOOLTIP_TYPE_CURRENCY,param1);
                  }
               }
            }
            if(!_loc6_)
            {
               if(param1.indexOf("material") >= 0)
               {
                  _loc14_ = String(param1).replace("material","item");
               }
               else
               {
                  _loc14_ = param1;
               }
               _loc6_ = Central.main.MATERIAL_DATA.find(_loc14_);
               if(_loc6_)
               {
                  _loc10_ = "material";
                  Item.getMaterialIcon(_loc6_.id,_loc4_);
                  _loc7_ = TooltipData.getItemTooltip(TooltipData.TOOLTIP_TYPE_MATERIAL,_loc14_);
               }
            }
         }
         if(param1.indexOf("skill") >= 0)
         {
            if(int(param1.replace("skill","")) >= 3500 && int(param1.replace("skill","")) < 5000)
            {
               _loc10_ = "senjutsu";
               _loc6_ = Central.main.SENJUTSU_SKILL_DATA["senjutsu_" + param1];
               if(Central.main.dataFilter(_loc6_) == false)
               {
                  return null;
               }
               Item.getSkillIcon(_loc6_.swf_name,_loc4_);
               _loc7_ = TooltipData.getItemTooltip(TooltipData.TOOLTIP_TYPE_SENJUTSU,"senjutsu_" + _loc6_.skill_id);
            }
            else
            {
               _loc10_ = "skill";
               _loc6_ = Central.main.SKILL_DATA[param1];
               if(Central.main.dataFilter(_loc6_) == false)
               {
                  return null;
               }
               Item.getSkillIcon(_loc6_.swfName,_loc4_);
               _loc7_ = TooltipData.getItemTooltip(TooltipData.TOOLTIP_TYPE_SKILL,_loc6_.id);
            }
         }
         if(param1.indexOf("pet") >= 0)
         {
            _loc10_ = "pet";
            _loc15_ = Central.main.PET_DATA.find(param1);
            if(_loc15_)
            {
               _loc6_ = _loc15_;
            }
            if(Central.main.dataFilter(_loc6_) == false)
            {
               return null;
            }
            _loc5_ = new MovieClip();
            _loc16_ = Central.main.getLib("LoadingMc");
            _loc16_.x = 90;
            _loc16_.y = 100;
            _loc5_.addChild(_loc16_);
            Item.getPetModel(_loc6_.id,_loc5_);
            Item.getPetIcon(_loc6_,_loc4_);
            _loc7_ = "<b>" + _loc6_.name + "</b><br>(" + Central.main.langLib.titleTxt(TitleData.PETS) + ")<br><br>" + _loc6_.description;
         }
         if(param1.indexOf("friendshipkunai") >= 0 || param1.indexOf("fk") >= 0)
         {
            _loc10_ = "friendshipkunai";
            _loc8_ = Number(param1.replace(_loc10_,""));
            _loc8_ = 1;
            _loc6_ = {"id":_loc10_};
            _loc9_ = _loc8_;
            _loc4_ = Central.main.getLib("FriendshipKunaiIcon");
            _loc4_.txt.text = _loc8_;
            _loc7_ = Central.main.langLib.titleTxt(TitleData.KUNAI) + " x " + _loc8_;
         }
         if(param1.indexOf("gold") >= 0)
         {
            _loc10_ = "gold";
            _loc8_ = Number(param1.replace(_loc10_,""));
            _loc6_ = {"id":_loc10_};
            _loc9_ = _loc8_;
            _loc4_ = Central.main.getLib("GoldIcon");
            _loc4_.txt.text = _loc8_;
            _loc17_ = 5;
            if(_loc4_.txt.text.length > _loc17_)
            {
               _loc4_.txt.text = _loc4_.txt.text.replace(/[0-9][0-9][0-9]$/,"k");
            }
            if(_loc4_.txt.text.length > _loc17_)
            {
               _loc4_.txt.text = _loc4_.txt.text.replace(/[0-9][0-9][0-9]k$/,"m");
            }
            if(_loc4_.txt.text.length > _loc17_)
            {
               _loc4_.txt.text = _loc4_.txt.text.replace(/[0-9][0-9][0-9]m$/,"b");
            }
            if(_loc8_ > 0)
            {
               _loc7_ = Central.main.langLib.titleTxt(TitleData.GOLD) + " x " + _loc8_;
            }
            else
            {
               _loc4_.txt.text = "";
               _loc7_ = Central.main.langLib.titleTxt(TitleData.GOLD);
            }
         }
         if(param1.indexOf("token") >= 0)
         {
            _loc10_ = "token";
            _loc8_ = Number(param1.replace(_loc10_,""));
            _loc6_ = {"id":_loc10_};
            _loc9_ = _loc8_;
            _loc4_ = Central.main.getLib("TokenIcon");
            _loc4_.txt.text = _loc8_;
            if(_loc8_ > 0)
            {
               _loc7_ = Central.main.langLib.titleTxt(TitleData.TOKEN) + " x " + _loc8_;
            }
            else
            {
               _loc7_ = Central.main.langLib.titleTxt(TitleData.TOKEN);
               _loc4_.txt.text = "";
            }
         }
         if(param1.indexOf("MCoin") >= 0)
         {
            _loc10_ = "MCoin";
            _loc8_ = Number(param1.replace(_loc10_,""));
            _loc6_ = {"id":_loc10_};
            _loc9_ = _loc8_;
            _loc4_ = Central.main.getLib("MCoinIcon");
            _loc4_.txt.text = _loc8_;
            if(_loc8_ > 0)
            {
               _loc7_ = Central.main.langLib.titleTxt(TitleData.MCOIN) + " x " + _loc8_;
            }
            else
            {
               _loc7_ = Central.main.langLib.titleTxt(TitleData.MCOIN);
               _loc4_.txt.text = "";
            }
         }
         if(param1.indexOf("tp") >= 0)
         {
            _loc10_ = "tp";
            _loc8_ = Number(param1.replace(_loc10_,""));
            _loc6_ = {"id":_loc10_};
            _loc9_ = _loc8_;
            _loc4_ = Central.main.getLib("TPIcon");
            _loc4_.txt.text = _loc8_;
            if(_loc8_ > 0)
            {
               _loc7_ = "TP" + " x " + _loc8_;
            }
            else
            {
               _loc7_ = "TP";
               _loc4_.txt.text = "";
            }
         }
         if(param1.indexOf("sp") >= 0)
         {
            _loc10_ = "sp";
            _loc8_ = Number(param1.replace(_loc10_,""));
            _loc6_ = {"id":_loc10_};
            _loc9_ = _loc8_;
            _loc4_ = Central.main.getLib("SPIcon");
            _loc4_.txt.text = _loc8_;
            _loc4_.txt.textColor = 13395456;
            if(_loc8_ > 0)
            {
               _loc7_ = "Ss" + " x " + _loc8_;
            }
            else
            {
               _loc7_ = "Ss";
               _loc4_.txt.text = "";
            }
         }
         if(param1.indexOf("xp") >= 0)
         {
            _loc10_ = "xp";
            if(param1.indexOf("%") >= 0)
            {
               _loc12_ = param1.replace("%","");
               _loc11_ = int(_loc12_.replace(_loc10_,""));
               param1 = "xp" + (Formula.getXpByLv(Central.main.getMainChar().getLevel() + 1) - Formula.getXpByLv(Central.main.getMainChar().getLevel())) * _loc11_ / 100;
            }
            _loc8_ = Number(param1.replace(_loc10_,""));
            _loc6_ = {"id":_loc10_};
            _loc9_ = _loc8_;
            _loc4_ = Central.main.getLib("XPIcon");
            _loc4_.txt.text = _loc11_ > 0 ? _loc11_ + "%" : _loc8_;
            if(_loc8_ > 0)
            {
               _loc7_ = Central.main.langLib.titleTxt(TitleData.XP) + " x " + _loc8_;
            }
            else
            {
               _loc7_ = Central.main.langLib.titleTxt(TitleData.XP);
               _loc4_.txt.text = "";
            }
         }
         if(_loc10_ == null)
         {
            Out.error("Toolkit :: getDisplayData :: ","type not found :: " + param1);
         }
         if(_loc6_.crystal == null)
         {
            _loc6_.crystal = _loc6_.token;
         }
         if(_loc10_ == "fk")
         {
            _loc4_.x = -50;
            _loc4_.y = -100;
            _loc4_.height = _loc4_.width = 120;
         }
         return {
            "mc":_loc4_,
            "mcFullBody":_loc5_,
            "itemData":_loc6_,
            "type":_loc10_,
            "tooltip":_loc7_,
            "amount":_loc9_,
            "petdata":param2
         };
      }
      
      public static function addInventoryByArray(param1:Array, param2:Array = null) : void
      {
         var _loc4_:Array = null;
         var _loc5_:String = null;
         var _loc6_:int = 0;
         var _loc7_:Object = null;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc3_:int = 0;
         while(_loc3_ < param1.length)
         {
            _loc4_ = param1[_loc3_].split("_");
            _loc5_ = _loc4_[0];
            _loc6_ = _loc4_.length > 1 ? int(_loc4_[1]) : 1;
            _loc7_ = Toolkit.getDisplayData(_loc5_);
            _loc8_ = 0;
            while(_loc8_ < _loc6_)
            {
               if(_loc5_.indexOf("pet") >= 0)
               {
                  _loc9_ = 0;
                  while(_loc9_ < param2.length)
                  {
                     if("pet" + param2[_loc9_].petId == _loc5_)
                     {
                        _loc7_.petdata = param2[_loc9_];
                        param2.splice(_loc9_,1);
                        break;
                     }
                     _loc9_++;
                  }
               }
               Toolkit.DisplayDataAddInventory(_loc7_);
               _loc8_++;
            }
            _loc3_++;
         }
      }
      
      public static function removeInventoryByArray(param1:Array, param2:Array = null) : void
      {
         var _loc4_:Array = null;
         var _loc5_:String = null;
         var _loc6_:int = 0;
         var _loc7_:Object = null;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc3_:int = 0;
         while(_loc3_ < param1.length)
         {
            _loc4_ = param1[_loc3_].split("_");
            _loc5_ = _loc4_[0];
            _loc6_ = _loc4_.length > 1 ? int(_loc4_[1]) : 1;
            _loc7_ = Toolkit.getDisplayData(_loc5_);
            _loc8_ = 0;
            while(_loc8_ < _loc6_)
            {
               if(_loc5_.indexOf("pet") >= 0)
               {
                  _loc9_ = 0;
                  while(_loc9_ < param2.length)
                  {
                     if("pet" + param2[_loc9_].petId == _loc5_)
                     {
                        _loc7_.petdata = param2[_loc9_];
                        param2.splice(_loc9_,1);
                        break;
                     }
                     _loc9_++;
                  }
               }
               switch(_loc7_.type)
               {
                  case "wpn":
                     Central.main.getMainChar().removeInventory(InventoryData.TYPE_WEAPON,_loc5_);
                     break;
                  case "back":
                     Central.main.getMainChar().removeInventory(InventoryData.TYPE_BACK_ITEM,_loc5_);
                     break;
                  case "set":
                     Central.main.getMainChar().removeInventory(InventoryData.TYPE_BODY_SET,_loc5_);
                     break;
                  case "skill":
                     Central.main.getMainChar().removeInventory(InventoryData.TYPE_SKILL,_loc5_);
                     Central.main.getMainChar().removeEquippedSkill(_loc5_);
                     break;
                  case "essence":
                     Central.main.getMainChar().removeInventory(InventoryData.TYPE_ESSENCE,_loc5_);
                     break;
                  case "item":
                     Central.main.getMainChar().removeInventory(InventoryData.TYPE_ITEM,_loc5_);
                     break;
                  case "material":
                     Central.main.getMainChar().removeInventory(InventoryData.TYPE_MATERIAL,_loc5_);
                     break;
                  case "currency":
                     Central.main.getMainChar().removeInventory(InventoryData.TYPE_CURRENCY,_loc5_);
                     break;
                  case "hair":
                     Central.main.getMainChar().removeInventory(InventoryData.TYPE_HAIR,_loc5_);
                     break;
                  case "pet":
                     Central.main.getMainChar().removePet(_loc5_);
                     break;
                  case "acsy":
                     Central.main.getMainChar().removeInventory(InventoryData.TYPE_ACCESSORY,_loc5_);
               }
               _loc8_++;
            }
            _loc3_++;
         }
      }
      
      public static function checkInventoryByArray(param1:Array) : Boolean
      {
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         var _loc7_:* = undefined;
         var _loc8_:* = undefined;
         var _loc9_:* = undefined;
         var _loc2_:int = 0;
         while(_loc2_ < param1.length)
         {
            if(param1[_loc2_].indexOf("item") >= 0)
            {
               _loc6_ = param1[_loc2_].split("_")[0];
               param1[_loc2_] = param1[_loc2_].replace("item",Toolkit.getDisplayData(_loc6_).type);
            }
            _loc2_++;
         }
         var _loc3_:Object = {};
         for each(_loc4_ in param1)
         {
            _loc7_ = _loc4_.split("_");
            _loc8_ = _loc7_.length > 1 ? int(_loc7_[1]) : 1;
            _loc9_ = _loc7_[0].replace(/[0-9]*$/,"");
            if(!_loc3_[_loc9_])
            {
               _loc3_[_loc9_] = 0;
            }
            _loc3_[_loc9_] += _loc8_;
         }
         for(_loc5_ in _loc3_)
         {
            if(!Toolkit.checkInventory(_loc5_,_loc3_[_loc5_]))
            {
               return false;
            }
         }
         return true;
      }
      
      public static function checkInventory(param1:String = "wpn,set,back,item,material,essence,pet", param2:int = 1) : Boolean
      {
         var _loc3_:Array = param1.split(",");
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_.length)
         {
            switch(_loc3_[_loc4_])
            {
               case "wpn":
                  if(Central.main.getMainChar().getInventory(InventoryData.TYPE_WEAPON).length + param2 + 1 > Data.INV_SPACE_WEAPON)
                  {
                     return false;
                  }
                  break;
               case "acsy":
                  if(Central.main.getMainChar().getInventory(InventoryData.TYPE_ACCESSORY).length + param2 + 1 > Data.INV_SPACE_ACCESSORY)
                  {
                     return false;
                  }
                  break;
               case "set":
                  if(Central.main.getMainChar().getInventory(InventoryData.TYPE_BODY_SET).length + param2 + 1 > Data.INV_SPACE_BODYSET)
                  {
                     return false;
                  }
                  break;
               case "back":
                  if(Central.main.getMainChar().getBackItem() != "")
                  {
                     if(Central.main.getMainChar().getInventory(InventoryData.TYPE_BACK_ITEM).length + param2 + 1 > Data.INV_SPACE_BACKITEM)
                     {
                        return false;
                     }
                  }
                  else if(Central.main.getMainChar().getInventory(InventoryData.TYPE_BACK_ITEM).length + param2 > Data.INV_SPACE_BACKITEM)
                  {
                     return false;
                  }
                  break;
               case "item":
                  if(Account.getAccountType() == Account.FREE)
                  {
                     if(Central.main.getMainChar().getInventory(InventoryData.TYPE_ITEM).length + param2 > Data.INV_SPACE_FREE)
                     {
                        return false;
                     }
                  }
                  else if(Central.main.getMainChar().getInventory(InventoryData.TYPE_ITEM).length + param2 > Data.INV_SPACE_PREMIUM)
                  {
                     return false;
                  }
                  break;
               case "material":
                  if(Account.getAccountType() == Account.PREMIUM)
                  {
                     if(Central.main.getMainChar().getInventory(InventoryData.TYPE_MATERIAL).length + param2 > Data.INV_SPACE_MATERIAL_PREMIUM)
                     {
                        return false;
                     }
                  }
                  else if(Central.main.getMainChar().getInventory(InventoryData.TYPE_MATERIAL).length + param2 > Data.INV_SPACE_MATERIAL_FREE)
                  {
                     return false;
                  }
                  break;
               case "essence":
                  if(Central.main.getMainChar().getInventory(InventoryData.TYPE_ESSENCE).length + param2 > Data.INV_SPACE_ESSENCE)
                  {
                     return false;
                  }
                  break;
               case "pet":
                  if(Account.getAccountType() == Account.PREMIUM)
                  {
                     if(Central.main.getMainChar().pets.length + param2 > Data.INV_SPACE_PET_PREMIUM)
                     {
                        return false;
                     }
                  }
                  else if(Central.main.getMainChar().pets.length + param2 > Data.INV_SPACE_PET_FREE)
                  {
                     return false;
                  }
            }
            _loc4_++;
         }
         return true;
      }
      
      public static function DisplayDataAddInventory(param1:Object, param2:Boolean = false, param3:Function = null, param4:Object = null) : void
      {
         var _loc6_:DBCharacter = null;
         var _loc5_:int = 0;
         if(param1.type != "xp" && param1.type != "gold" && param1.type != "fk" && param1.type != "token" && param1.type != "tp" && param1.type != "sp")
         {
            _loc5_ = 0;
            while(_loc5_ < param1.amount)
            {
               if(param2 == true && checkInventory(param1.type) == false)
               {
                  if(param3 == null)
                  {
                     return;
                  }
                  if(param4 != null)
                  {
                     param3(param4);
                  }
                  else
                  {
                     param3();
                  }
               }
               switch(param1.type)
               {
                  case "wpn":
                     Central.main.getMainChar().addInventory(InventoryData.TYPE_WEAPON,String(param1.itemData.id));
                     break;
                  case "set":
                     if(!Central.main.getMainChar().hasItem(InventoryData.TYPE_BODY_SET,String(param1.itemData.id)) && Central.main.getMainChar().getBodySet() != String(param1.itemData.id))
                     {
                        Central.main.getMainChar().addInventory(InventoryData.TYPE_BODY_SET,String(param1.itemData.id));
                     }
                     break;
                  case "acsy":
                     Central.main.getMainChar().addInventory(InventoryData.TYPE_ACCESSORY,String(param1.itemData.id));
                     break;
                  case "back":
                     Central.main.getMainChar().addInventory(InventoryData.TYPE_BACK_ITEM,String(param1.itemData.id));
                     break;
                  case "item":
                     Central.main.getMainChar().addInventory(InventoryData.TYPE_ITEM,String(param1.itemData.id));
                     break;
                  case "material":
                     Central.main.getMainChar().addInventory(InventoryData.TYPE_MATERIAL,String(param1.itemData.id));
                     break;
                  case "currency":
                     Central.main.getMainChar().addInventory(InventoryData.TYPE_CURRENCY,String(param1.itemData.id));
                     break;
                  case "essence":
                     if(Central.main.getMainChar().getInventory(InventoryData.TYPE_ESSENCE).length < Data.INV_SPACE_ESSENCE)
                     {
                        Central.main.getMainChar().addInventory(InventoryData.TYPE_ESSENCE,String(param1.itemData.id));
                     }
                     break;
                  case "skill":
                     Central.main.getMainChar().addInventory(InventoryData.TYPE_SKILL,String(param1.itemData.id));
                     break;
                  case "hair":
                     Central.main.getMainChar().addInventory(InventoryData.TYPE_HAIR,String(param1.itemData.id));
                     break;
                  case "pet":
                     _loc6_ = Central.main.dataParser.parsePetData(param1.petdata);
                     Central.main.getMainChar().initStandbyPet(_loc6_,param1.petdata.swfName,param1.petdata.clsName);
                     if(!Toolkit.loadPetSwfNow)
                     {
                        Toolkit.loadPetSwfNow = true;
                        Central.main.loadSwf(["swf/pets/" + param1.petdata.swfName + ".swf"],loadPetFinish,{"petdata":param1.petdata},Central.main.langLib.get(102));
                     }
                     else
                     {
                        Toolkit.loadPetSwf.push([["swf/pets/" + param1.petdata.swfName + ".swf"],{"petdata":param1.petdata}]);
                     }
                     break;
                  case "currency":
                     Central.main.addCurrency(param1.itemData.id);
               }
               _loc5_++;
            }
         }
         else
         {
            switch(param1.type)
            {
               case "xp":
                  Central.main.getMainChar().showLevelUp(Central.main.getMainChar().updateXP(param1.amount));
                  break;
               case "gold":
                  Central.main.getMainChar().updateGold(param1.amount);
                  break;
               case "fk":
                  Central.main.getMainChar().updateKunai(param1.amount);
                  break;
               case "token":
                  Central.main.account.balance = Central.main.account.getAccountBalance() + param1.amount;
                  break;
               case "tp":
                  Central.main.getMainChar().updateData(DBCharacterData.BLOODLINE,int(param1.amount) + int(Central.main.getMainChar().getData(DBCharacterData.BLOODLINE)));
                  break;
               case "sp":
                  Central.main.getMainChar().updateData(DBCharacterData.SENJUTSU_SS,int(param1.amount) + int(Central.main.getMainChar().getData(DBCharacterData.SENJUTSU_SS)));
            }
         }
      }
      
      private static function loadPetFinish(param1:Object = null, param2:Object = null) : void
      {
         var _loc3_:Array = null;
         var _loc4_:int = 0;
         var _loc5_:Array = null;
         if(param1)
         {
            _loc3_ = Central.main.getMainChar().pets;
            _loc4_ = 0;
            while(_loc4_ < _loc3_.length)
            {
               if(_loc3_[_loc4_].getPetId() == param2.petdata.id)
               {
                  _loc3_[_loc4_].loadedSwf = param1["swf/pets/" + param2.petdata.swfName + ".swf"];
               }
               _loc4_++;
            }
            Central.main.updateMenu();
         }
         if(Toolkit.loadPetSwf.length > 0)
         {
            _loc5_ = Toolkit.loadPetSwf.shift();
            Central.main.loadSwf(_loc5_[0],loadPetFinish,_loc5_[1],Central.main.langLib.get(102));
         }
         else
         {
            Toolkit.loadPetSwfNow = false;
         }
      }
      
      public static function addExpiryItem(param1:String) : void
      {
         var _loc2_:* = Central.main.itemPrototype(param1);
         var _loc3_:Array = param1.split("_");
         switch(_loc3_[0])
         {
            case "wpn":
               Central.main.getMainChar().addInventory(InventoryData.TYPE_WEAPON,_loc2_);
               break;
            case "back":
               Central.main.getMainChar().addInventory(InventoryData.TYPE_BACK_ITEM,_loc2_);
               break;
            case "set":
               Central.main.getMainChar().addInventory(InventoryData.TYPE_BODY_SET,_loc2_);
               break;
            case "skill":
               Central.main.getMainChar().addInventory(InventoryData.TYPE_SKILL,_loc2_);
               break;
            case "essence":
            case "item":
            case "material":
            case "currency":
            case "hair":
         }
      }
      
      public static function removeExpiryItem(param1:String) : void
      {
         var _loc2_:String = Central.main.itemPrototype(param1);
         var _loc3_:Array = param1.split("_");
         switch(_loc3_[0])
         {
            case "wpn":
               Central.main.getMainChar().removeInventory(InventoryData.TYPE_WEAPON,_loc2_);
               break;
            case "back":
               Central.main.getMainChar().removeInventory(InventoryData.TYPE_BACK_ITEM,_loc2_);
               break;
            case "set":
               Central.main.getMainChar().removeInventory(InventoryData.TYPE_BODY_SET,_loc2_);
               break;
            case "skill":
               Central.main.getMainChar().removeInventory(InventoryData.TYPE_SKILL,_loc2_);
               Central.main.getMainChar().removeEquippedSkill(_loc2_);
               break;
            case "essence":
            case "item":
            case "material":
            case "hair":
         }
         if(param1.indexOf("pet") >= 0)
         {
            Central.main.getMainChar().removePet(_loc2_);
         }
      }
      
      public static function equipExpiryItem(param1:String) : void
      {
         var _loc2_:Boolean = false;
         var _loc3_:* = Central.main.itemPrototype(param1);
         var _loc4_:Array = param1.split("_");
         switch(_loc4_[0])
         {
            case "wpn":
               Central.main.getMainChar().setWeapon(_loc3_,_loc2_);
               break;
            case "back":
               Central.main.getMainChar().setBackItem(_loc3_,_loc2_);
               break;
            case "set":
            case "hair":
         }
      }
      
      public static function getItemType(param1:String) : String
      {
         if(param1.indexOf("wpn") >= 0)
         {
            return InventoryData.TYPE_WEAPON;
         }
         if(param1.indexOf("back") >= 0)
         {
            return InventoryData.TYPE_BACK_ITEM;
         }
         if(param1.indexOf("hair") >= 0)
         {
            return InventoryData.TYPE_HAIR;
         }
         if(param1.indexOf("set") >= 0)
         {
            return InventoryData.TYPE_BODY_SET;
         }
         if(param1.indexOf("acsy") >= 0)
         {
            return InventoryData.TYPE_ACCESSORY;
         }
         return "";
      }
      
      public static function getItemDataByID(param1:String) : Object
      {
         var _loc2_:String = Toolkit.getItemType(param1);
         switch(_loc2_)
         {
            case InventoryData.TYPE_WEAPON:
               return Central.main.WEAPON_DATA.find(param1);
            case InventoryData.TYPE_BACK_ITEM:
               return Central.main.BACK_ITEM_DATA.find(param1);
            case InventoryData.TYPE_HAIR:
               return Central.main.HAIR_DATA.find(param1);
            case InventoryData.TYPE_BODY_SET:
               return Central.main.getMainChar().getGender() == 0 ? Central.main.BODY_SET_BOY[param1] : Central.main.BODY_SET_GIRL[param1];
            case InventoryData.TYPE_ACCESSORY:
               return Central.main.ACCESSORY_DATA.find(param1);
            default:
               return null;
         }
      }
      
      public static function getIDBySubData(param1:String, param2:String, param3:HashMap) : String
      {
         var _loc4_:Array = param3.getKeySet();
         var _loc5_:* = 0;
         while(_loc5_ < _loc4_.length)
         {
            if(param3.find(_loc4_[_loc5_])[param1] == param2)
            {
               return param3.find(_loc4_[_loc5_]).id;
            }
            _loc5_++;
         }
         return "";
      }
   }
}

