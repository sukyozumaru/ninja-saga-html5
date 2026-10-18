package ninjasaga.graphic
{
   import com.utils.GF;
   import com.utils.NumberUtil;
   import com.utils.Out;
   import flash.display.MovieClip;
   import ninjasaga.*;
   import ninjasaga.battle.*;
   import ninjasaga.data.BattleData;
   import ninjasaga.data.BloodlineData;
   import ninjasaga.data.DBCharacterData;
   import ninjasaga.data.Formula;
   import ninjasaga.data.SenjutsuData;
   import ninjasaga.data.WeaponData;
   
   public class G_Character implements GI_Character
   {
      
      private var asset:Asset;
      
      private const BODY_PART_ARRAY:* = ["upper_body","lower_body","left_upper_arm","left_lower_arm","left_hand","left_upper_leg","left_lower_leg","left_shoe","right_upper_arm","right_lower_arm","right_hand","right_upper_leg","right_lower_leg","right_shoe"];
      
      public function G_Character()
      {
         super();
         this.asset = Asset.getInstance();
      }
      
      public function setupFace(param1:MovieClip, param2:String, param3:Number) : void
      {
         var faceMc:MovieClip = null;
         var face:* = undefined;
         var mc:MovieClip = param1;
         var faceId:String = param2;
         var skinColor:Number = param3;
         try
         {
            faceMc = mc["head"]["face"];
            if(faceMc.numChildren > 0)
            {
               face = faceMc.getChildAt(0);
               if(face != null)
               {
                  if(faceId == face.faceId)
                  {
                     face.setColor(skinColor);
                     return;
                  }
               }
            }
         }
         catch(e:Error)
         {
            Out.error(this,"setupFace :: 1 :: " + mc + " :: " + faceId + " :: " + e.getStackTrace());
         }
         try
         {
            GF.removeAllChild(faceMc);
            faceMc.addChild(this.asset.getFace(faceId,skinColor));
         }
         catch(e:Error)
         {
            Out.error(this,"setupFace :: 2 :: " + mc + " :: " + faceId + " :: " + e.getStackTrace());
         }
      }
      
      public function setFaceColor(param1:MovieClip, param2:Number) : void
      {
         var faceMc:MovieClip = null;
         var mc:MovieClip = param1;
         var skinColor:Number = param2;
         try
         {
            faceMc = mc["head"]["face"].getChildAt(0).setColor(skinColor);
         }
         catch(e:Error)
         {
            Out.error(this,"setFaceColor :: " + mc + " :: " + skinColor + " :: " + e.getStackTrace());
         }
      }
      
      public function setupBodySet(param1:MovieClip, param2:String, param3:int, param4:Number) : void
      {
         var bodyPartArr:Array = null;
         var i:uint = 0;
         var mc:MovieClip = param1;
         var setId:String = param2;
         var gender:int = param3;
         var skinColor:Number = param4;
         try
         {
            bodyPartArr = BODY_PART_ARRAY;
            i = 0;
            while(i < bodyPartArr.length)
            {
               GF.removeAllChild(mc[bodyPartArr[i]]);
               mc[bodyPartArr[i]].addChild(this.asset.getBodyPart(setId,gender,bodyPartArr[i],skinColor));
               i++;
            }
            if(gender == 1)
            {
               GF.removeAllChild(mc["skirt"]);
               mc["skirt"].addChild(this.asset.getBodyPart(setId,gender,"skirt",skinColor));
            }
         }
         catch(e:Error)
         {
            Out.error(this,"setupBodySet :: " + mc + " :: " + setId + " :: " + skinColor + " :: " + e.getStackTrace());
         }
      }
      
      public function setBodySetColor(param1:MovieClip, param2:Number) : void
      {
         var _loc3_:Array = BODY_PART_ARRAY;
         var _loc4_:uint = 0;
         while(_loc4_ < _loc3_.length)
         {
            param1[_loc3_[_loc4_]].getChildAt(0).setColor(param2);
            _loc4_++;
         }
      }
      
      public function setupWeapon(param1:MovieClip, param2:String, param3:int) : void
      {
         var weaponData:Object = null;
         var inventoryAsset:MovieClip = null;
         var animation:String = null;
         var stateDictionary:Object = null;
         var stateObjStr:String = null;
         var stateObj:MovieClip = null;
         var stateFrame:int = 0;
         var loadedAssetAsset:MovieClip = null;
         var randomNoId:int = 0;
         var mc:MovieClip = param1;
         var wpnId:String = param2;
         var charId:int = param3;
         try
         {
            GF.removeAllChild(mc["handweapon"]);
            GF.removeAllChild(mc["weapon"]);
            randomNoId = Math.random() * 8999 + 1000;
            weaponData = Central.main.WEAPON_DATA.find(wpnId);
            if(weaponData != null)
            {
               animation = weaponData[WeaponData.ANIMATION];
            }
            inventoryAsset = this.asset.getWeaponGraphic(wpnId,charId,randomNoId);
            stateDictionary = Central.main.stateInventory.getStateDictionary(charId,"wpn",wpnId);
            loadedAssetAsset = inventoryAsset;
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
            if(animation == "attack_10")
            {
               mc["handweapon"].addChild(inventoryAsset);
            }
            else
            {
               mc["weapon"].addChild(inventoryAsset);
            }
         }
         catch(e:Error)
         {
            Out.error(this,"setupWeapon :: " + mc + " :: " + wpnId + " :: " + e.getStackTrace());
         }
      }
      
      public function setupBackItem(param1:MovieClip, param2:String) : void
      {
         var mc:MovieClip = param1;
         var backId:String = param2;
         try
         {
            GF.removeAllChild(mc["back"]);
            mc["back"].addChild(this.asset.getBackItemGraphic(backId));
         }
         catch(e:Error)
         {
            Out.error(this,"setupBackItem :: " + mc + " :: " + backId + " :: " + e.getStackTrace());
         }
      }
      
      public function unSetupBackitem(param1:MovieClip) : void
      {
         var mc:MovieClip = param1;
         try
         {
            GF.removeAllChild(mc["back"]);
         }
         catch(e:Error)
         {
            §§push(e);
            var _temp_1:* = e;
            e = §§pop();
            Out.error(this,"unSetupBackitem :: " + mc + " :: " + e.getStackTrace());
         }
      }
   }
}

import flash.display.MovieClip;

interface GI_Character
{
   
   function setupFace(param1:MovieClip, param2:String, param3:Number) : void;
}
