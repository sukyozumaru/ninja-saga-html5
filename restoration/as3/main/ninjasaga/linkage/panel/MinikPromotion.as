package ninjasaga.linkage.panel
{
   import de.polygonal.ds.HashMap;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import ninjasaga.Central;
   import ninjasaga.Item;
   import ninjasaga.data.ButtonData;
   import ninjasaga.data.InventoryData;
   import ninjasaga.data.TitleData;
   import ninjasaga.data.TooltipData;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol2633")]
   public class MinikPromotion extends MovieClip
   {
      
      public var panel:MovieClip;
      
      private var textArr:Array;
      
      public function MinikPromotion()
      {
         super();
         addFrameScript(0,this.frame1,6,this.frame7,25,this.frame26);
         this.textArr = Central.main.langLib.get(1571);
      }
      
      public function show() : void
      {
         this.gotoAndPlay("show");
      }
      
      public function hide(param1:MouseEvent = null) : void
      {
         this.gotoAndPlay("exit");
      }
      
      private function onShow() : void
      {
         this.stop();
         var _loc1_:MovieClip = this["panel"];
         _loc1_["closeBtn"].addEventListener(MouseEvent.CLICK,this.hide);
         _loc1_["titleTxt"].text = this.textArr[0];
         _loc1_["descTxt"].text = "";
         _loc1_["code1Txt"].text = this.textArr[3];
         _loc1_["code2Txt"].text = this.textArr[4];
         Central.main.initButton(_loc1_["claimBtn"],this.claimReward,ButtonData.CONFIRM);
      }
      
      private function claimReward(param1:MouseEvent) : void
      {
         var _loc2_:MovieClip = this["panel"];
         var _loc3_:String = _loc2_["code1Input"].text;
         var _loc4_:String = _loc2_["code2Input"].text;
         if(_loc3_.length != 16 || _loc4_.length != 16)
         {
            Central.main.showOk(this.textArr[1]);
            return;
         }
         var _loc5_:String = Central.main.getHash(_loc3_ + _loc4_);
         Central.main.showAmfLoading();
         Central.main.amfClient.service("SpecialReward.minikGift",[Central.main.account.getAccountSessionKey(),_loc5_,_loc3_,_loc4_],this.claimRewardResponse);
      }
      
      private function claimRewardResponse(param1:Object) : void
      {
         var _loc2_:MovieClip = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:HashMap = null;
         var _loc6_:int = 0;
         var _loc7_:Array = null;
         var _loc8_:Array = null;
         var _loc9_:Object = null;
         if(Central.main.validateAmfResponse(param1))
         {
            Central.main.hideAmfLoading();
            _loc2_ = this["panel"];
            _loc2_["code1Input"].text = "";
            _loc2_["code2Input"].text = "";
            _loc4_ = int(param1.result);
            switch(_loc4_)
            {
               case 0:
                  Central.main.showOk(this.textArr[1]);
                  break;
               case 1:
                  _loc5_ = new HashMap();
                  _loc6_ = int(param1.gold);
                  Central.main.getMainChar().updateGold(_loc6_);
                  _loc5_.insert("gold",{
                     "type":"gold",
                     "amount":_loc6_
                  });
                  _loc7_ = param1.items;
                  if(_loc7_ != null)
                  {
                     _loc3_ = 0;
                     while(_loc3_ < _loc7_.length)
                     {
                        Central.main.getMainChar().addInventory(InventoryData.TYPE_ITEM,"item" + String(_loc7_[_loc3_]));
                        if(_loc5_.containsKey("item" + _loc7_[_loc3_]))
                        {
                           _loc9_ = _loc5_.find("item" + _loc7_[_loc3_]);
                           ++_loc9_.amount;
                           _loc5_.insert("item" + _loc7_[_loc3_],_loc9_);
                        }
                        else
                        {
                           _loc5_.insert("item" + _loc7_[_loc3_],{
                              "type":"item",
                              "id":String("item" + _loc7_[_loc3_]),
                              "amount":1
                           });
                        }
                        _loc3_++;
                     }
                  }
                  _loc8_ = param1.weapons;
                  if(_loc8_ != null)
                  {
                     _loc3_ = 0;
                     while(_loc3_ < _loc8_.length)
                     {
                        Central.main.getMainChar().addInventory(InventoryData.TYPE_WEAPON,"wpn" + String(_loc8_[_loc3_]));
                        if(_loc5_.containsKey("wpn" + _loc8_[_loc3_]))
                        {
                           _loc9_ = _loc5_.find("wpn" + _loc8_[_loc3_]);
                           ++_loc9_.amount;
                           _loc5_.insert("wpn" + _loc8_[_loc3_],_loc9_);
                        }
                        else
                        {
                           _loc5_.insert("wpn" + _loc8_[_loc3_],{
                              "type":"wpn",
                              "id":String("wpn" + _loc8_[_loc3_]),
                              "amount":1
                           });
                        }
                        _loc3_++;
                     }
                  }
                  this.showReward(_loc5_);
            }
         }
      }
      
      private function showReward(param1:HashMap) : void
      {
         var _loc2_:MovieClip = this["panel"]["claimMc"];
         _loc2_.items = param1;
         _loc2_.gotoAndPlay("show");
      }
      
      private function hideReward(param1:MouseEvent) : void
      {
         var _loc2_:MovieClip = this["panel"]["claimMc"];
         _loc2_.items = null;
         _loc2_.gotoAndPlay("exit");
      }
      
      public function onClaim() : void
      {
         var _loc2_:int = 0;
         var _loc4_:Array = null;
         var _loc6_:String = null;
         var _loc7_:MovieClip = null;
         var _loc8_:int = 0;
         var _loc9_:String = null;
         var _loc10_:Object = null;
         var _loc11_:Object = null;
         var _loc12_:MovieClip = null;
         var _loc1_:int = 4;
         var _loc3_:MovieClip = this["panel"]["claimMc"];
         _loc4_ = _loc3_.items.toArray();
         var _loc5_:int = int(_loc4_.length);
         _loc3_.stop();
         _loc3_["panel"]["okBtn"].addEventListener(MouseEvent.CLICK,this.hideReward);
         _loc3_["panel"]["titleTxt"].text = this.textArr[5];
         if(_loc5_ > _loc1_)
         {
            _loc5_ = _loc1_;
         }
         _loc2_ = 0;
         while(_loc2_ < _loc5_)
         {
            _loc6_ = _loc4_[_loc2_].type;
            _loc7_ = _loc3_["panel"]["itemMc"]["item_" + _loc2_];
            switch(_loc6_)
            {
               case "gold":
                  _loc8_ = int(_loc4_[_loc2_].amount);
                  _loc7_["quantityTxt"].text = String(_loc8_);
                  _loc7_["iconHolder"].addChild(Central.main.getLib("GoldIcon"));
                  _loc9_ = _loc8_ + " " + Central.main.langLib.titleTxt(TitleData.GOLD);
                  break;
               case "item":
                  _loc8_ = int(_loc4_[_loc2_].amount);
                  _loc7_["quantityTxt"].text = "x" + String(_loc8_);
                  _loc10_ = Central.main.ITEM_DATA.find(String(_loc4_[_loc2_].id));
                  if(String(_loc10_.effect).indexOf("cp") >= 0)
                  {
                     _loc7_["iconHolder"].addChild(Central.main.getLib("ChakraScroll"));
                  }
                  else
                  {
                     _loc7_["iconHolder"].addChild(Central.main.getLib("HealingScroll"));
                  }
                  _loc9_ = TooltipData.getItemTooltip(TooltipData.TOOLTIP_TYPE_ITEM,String(_loc4_[_loc2_].id));
                  break;
               case "wpn":
                  _loc8_ = int(_loc4_[_loc2_].amount);
                  _loc7_["quantityTxt"].text = "x" + String(_loc8_);
                  _loc11_ = Central.main.WEAPON_DATA.find(String(_loc4_[_loc2_].id));
                  _loc12_ = new MovieClip();
                  Item.getWeaponIcon(_loc11_.id,_loc12_);
                  _loc7_["iconHolder"].addChild(_loc12_);
                  _loc9_ = TooltipData.getItemTooltip(TooltipData.TOOLTIP_TYPE_WEAPON,String(_loc4_[_loc2_].id));
            }
            if(_loc9_ != null)
            {
               Central.main.showDynamicTooltip(_loc7_["clickMask"],String("<font size=\'16\'>" + _loc9_ + "</font>"));
            }
            _loc2_++;
         }
      }
      
      internal function frame1() : *
      {
         this.stop();
      }
      
      internal function frame7() : *
      {
         this.onShow();
      }
      
      internal function frame26() : *
      {
         this.gotoAndStop("idle");
      }
   }
}

