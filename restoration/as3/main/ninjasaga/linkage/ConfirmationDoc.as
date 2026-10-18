package ninjasaga.linkage
{
   import com.utils.CreateFilter;
   import com.utils.GF;
   import com.utils.NumberUtil;
   import com.utils.Out;
   import com.utils.TextFilter;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.filters.ColorMatrixFilter;
   import flash.geom.Point;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   import ninjasaga.Account;
   import ninjasaga.Central;
   import ninjasaga.Item;
   import ninjasaga.data.AppData;
   import ninjasaga.data.ButtonData;
   import ninjasaga.data.DailyLoginEventData;
   import ninjasaga.data.Data;
   import ninjasaga.data.InventoryData;
   import ninjasaga.data.PvPData;
   import ninjasaga.data.Timeline;
   import ninjasaga.data.TitleData;
   import ninjasaga.data.TooltipData;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol1081")]
   public class ConfirmationDoc extends MovieClip
   {
      
      private static const TL_SHARE_BOX:String = "share_box";
      
      private static const TL_DELETE_CONFIRMATION:String = "deleteConfirmation";
      
      private static const TL_RENAME_CONFIRMATION:String = "renameConfirmation";
      
      private static const TL_RESET_SKILL_CONFIRMATION:String = "reset_skill";
      
      private static const TL_GET_GOLD_TOKEN:String = "noToken";
      
      private static const TL_NOTICE_BOARD:String = "noticeBoard";
      
      private static const TL_REFRESH_CONFIRMATION:String = "emblemReload";
      
      private static const TL_RR_PROMOTE_EVENT:String = "rr_event";
      
      private static const PAY_CONFIRM_TOKEN:String = "payToken";
      
      private static const PAY_CONFIRM_GOLD:String = "payGold";
      
      public var txtbox7:TextField;
      
      public var dragonIconMc:MovieClip;
      
      public var displayTxt:TextField;
      
      public var captureBtn:MovieClip;
      
      public var btnRefresh:MovieClip;
      
      public var priceMC:MovieClip;
      
      public var goBtn:MovieClip;
      
      public var shareBtn:MovieClip;
      
      public var txtbox9:TextField;
      
      public var txtbox12:TextField;
      
      public var txt8:TextField;
      
      public var maskMc:MovieClip;
      
      public var costTxt:TextField;
      
      public var txtbox11:TextField;
      
      public var rangeTxt:TextField;
      
      public var payConfirmMc:MovieClip;
      
      public var yesBtn:SimpleButton;
      
      public var txtbox10:TextField;
      
      public var btnClose:SimpleButton;
      
      public var okBtn:SimpleButton;
      
      public var catchableTxt:TextField;
      
      public var paymentConfirmMC:ConfirmationPayment;
      
      public var iconMc:MovieClip;
      
      public var confDeleteMc:MovieClip;
      
      public var displayTxt_2:TextField;
      
      public var errorTxt:TextField;
      
      public var greenHpBarMc:MovieClip;
      
      public var line_0:MovieClip;
      
      public var HuntingTicketTxt:TextField;
      
      public var lbl_loginnotice:TextField;
      
      public var iconMC:MovieClip;
      
      public var otherPanel:MovieClip;
      
      public var renameInput:TextField;
      
      public var goMc:MovieClip;
      
      public var att_subTitle3:TextField;
      
      public var noBtn:SimpleButton;
      
      public var shareBoxMc:MovieClip;
      
      public var normalBgMc:MovieClip;
      
      public var displayTxt_0:TextField;
      
      public var dailyLoginPopup:MovieClip;
      
      public var panel:MovieClip;
      
      public var att_subTitle2:TextField;
      
      public var displayTxt_1:TextField;
      
      public var refuseBtn:MovieClip;
      
      public var dailyLoginGiftMc:MovieClip;
      
      public var att_subTitle1:TextField;
      
      public var txtbox1:TextField;
      
      public var subTitleTxt:TextField;
      
      public var trainBtn:MovieClip;
      
      public var enterBtn:MovieClip;
      
      public var titleTxt:TextField;
      
      public var txtbox2:TextField;
      
      public var redHpBarMc:MovieClip;
      
      public var att_contents2:TextField;
      
      public var att_titleTxt:TextField;
      
      public var closeBtn:SimpleButton;
      
      public var skipBtn:SimpleButton;
      
      public var dynamicTip:MovieClip;
      
      public var txtbox3:TextField;
      
      public var confirmUseScrollMc:MovieClip;
      
      public var hpTxt:TextField;
      
      public var goMc1:MovieClip;
      
      public var iconHolder:MovieClip;
      
      public var typeIcon:MovieClip;
      
      public var att_contents3:TextField;
      
      public var feedCaptionTxt:TextField;
      
      public var txtbox4:TextField;
      
      public var glowBgMc:MovieClip;
      
      public var medalMc:MovieClip;
      
      public var info:MovieClip;
      
      public var txtbox5:TextField;
      
      public var heartMc:MovieClip;
      
      public var claimBtn:MovieClip;
      
      public var att_contents1:TextField;
      
      public var feedTitleTxt:TextField;
      
      public var txtbox6:TextField;
      
      public var hpShadowMc:MovieClip;
      
      public var detailTxt:TextField;
      
      public var btnConfirmv:MovieClip;
      
      public var yesBtn2:MovieClip;
      
      public var popupPillFullMc:MovieClip;
      
      private var dimFilter:ColorMatrixFilter = CreateFilter.getSaturationFilter(0);
      
      private var feedTitle:String = "";
      
      private var confirmationTxt:String = "";
      
      private var popupTitleTxt:String = "";
      
      private var popupMsgTxt:String = "";
      
      private var icon:String = "";
      
      private var btnTxt:String = "";
      
      private var yesCallback:Function;
      
      private var noCallback:Function;
      
      private var okCallback:Function;
      
      private var okCallback1:Function;
      
      private var okCallback2:Function;
      
      private var extraInfo:Object;
      
      private var txt2:String = "";
      
      private var txt3:String = "";
      
      private var title:String = "";
      
      private var subTitle1:String = "";
      
      private var contents1:String = "";
      
      private var subTitle2:String = "";
      
      private var contents2:String = "";
      
      private var subTitle3:String = "";
      
      private var contents3:String = "";
      
      private var messsage:String;
      
      private var tooltipPoint:Point;
      
      private var fullHeight:Boolean = false;
      
      private var xOffset:Number = 15;
      
      private var yOffset:Number = 15;
      
      private var eventTitle:String = "";
      
      private var eventSubTitle:String = "";
      
      private var eventDisplayTxt:String = "";
      
      private var tokenPrice:int;
      
      private var tokenPrice2:int;
      
      private var goldPrice:int;
      
      private var infoMessage:String = "";
      
      private var skillType:String = "";
      
      private var typeGoldToken:String = "";
      
      private var fromPanel:String = "";
      
      private var valueObj:Object = null;
      
      private var islvup:Boolean = true;
      
      private var iconFrame:String;
      
      private var btnName:String;
      
      private var reward_arr:Array = [];
      
      private var lvupreward_Obj:Object = {
         2:{
            "msg":Central.main.langLib.get(1066),
            "frame":"gold",
            "txt":ButtonData.GO_TO_ACADEMY,
            "reward":500
         },
         3:{
            "msg":Central.main.langLib.get(1067),
            "frame":"skill",
            "txt":ButtonData.GO_TO_SKILL,
            "reward":"skill3"
         },
         4:{
            "msg":Central.main.langLib.get(1068),
            "frame":"weapon",
            "txt":ButtonData.GO_TO_GEAR,
            "reward":"wpn3"
         },
         5:{
            "msg":Central.main.langLib.get(1069),
            "frame":"skill",
            "txt":ButtonData.GO_TO_SKILL,
            "reward":"skill306"
         },
         6:{
            "msg":Central.main.langLib.get(1070),
            "frame":"gold",
            "txt":ButtonData.GO_TO_ACADEMY,
            "reward":2500
         },
         7:{
            "msg":Central.main.langLib.get(1071),
            "frame":"cloth",
            "txt":ButtonData.GO_TO_GEAR,
            "reward_boy":"set7",
            "reward_girl":"set5"
         },
         8:{
            "msg":Central.main.langLib.get(1072) + "<br>" + Central.main.langLib.get(1464),
            "frame":"token",
            "txt":ButtonData.GO_TO_ACADEMY,
            "reward":50
         }
      };
      
      private var deadPopupArr:Array = [{
         "msg":Central.main.langLib.get(1275),
         "frame":"item_0",
         "txt":ButtonData.GO_TO_SHOP
      },{
         "msg":Central.main.langLib.get(1276),
         "frame":"item_1",
         "txt":ButtonData.GO_TO_SHOP
      },{
         "msg":Central.main.langLib.get(1278),
         "frame":"item_3",
         "txt":ButtonData.GO_TO_SHOP
      },{
         "msg":Central.main.langLib.get(1279),
         "frame":"item_4",
         "txt":ButtonData.GO_TO_ACADEMY
      }];
      
      private var rNum:int;
      
      private var generalTxt:String;
      
      private var skill_id:String = "";
      
      private var DailyLoginDescription:Array = [];
      
      private var DailyLoginWarmingDescription:String = "";
      
      private var DailyLoginGift:Array = [];
      
      private var ShowHideDailyLogin:Boolean = true;
      
      private var LocationTxt:String = "";
      
      private var DailyLoginLoadPanelPath:String = "";
      
      private var GiftBagDescription:Array = [];
      
      private var GiftBagWarmingDescription:String = "";
      
      private var GiftBagGift:Array = [];
      
      private var ShowHideGiftBag:Boolean = true;
      
      private var ServerFunction:String = "";
      
      private var EventTap:Object = "";
      
      private var isPvpOver:Boolean = true;
      
      private var payConfirmType:String = "";
      
      private var useHtml:Boolean = true;
      
      private var passwordConfirmationTxt:String;
      
      private var passwordOkCallback:Function;
      
      private var passwordNoCallback:Function;
      
      private var passwordContinueCallback:Function;
      
      private var passwordUseHtml:Boolean = true;
      
      private var passwordLeaveEnabled:Boolean = false;
      
      private var specialHpData:Object = {};
      
      private var getRewardArr:Array = [];
      
      public function ConfirmationDoc()
      {
         super();
         addFrameScript(0,this.frame1,6,this.frame7,11,this.frame12,21,this.frame22,26,this.frame27,31,this.frame32,38,this.frame39,42,this.frame43,46,this.frame47,50,this.frame51,58,this.frame59,66,this.frame67,69,this.frame70,73,this.frame74,77,this.frame78,81,this.frame82,86,this.frame87,91,this.frame92,97,this.frame98,101,this.frame102,106,this.frame107,111,this.frame112,116,this.frame117,121,this.frame122,126,this.frame127,131,this.frame132,136,this.frame137,144,this.frame145);
         this.addEventListener(Event.ENTER_FRAME,this.checkDynamicTooltip);
      }
      
      private function onIdle() : void
      {
         this.stop();
      }
      
      private function onShow() : void
      {
         this.stop();
         if(this.useHtml)
         {
            this["displayTxt"].htmlText = this.confirmationTxt;
         }
         else
         {
            this["displayTxt"].text = this.confirmationTxt;
            this.useHtml = true;
         }
         if(this.okCallback != null)
         {
            this["okBtn"].visible = true;
            this["okBtn"].addEventListener(MouseEvent.CLICK,function():*
            {
               gotoAndStop(Timeline.IDLE);
               okCallback();
            });
            this["yesBtn"].visible = false;
            this["noBtn"].visible = false;
         }
         else
         {
            this["okBtn"].visible = false;
            this["yesBtn"].visible = true;
            this["yesBtn"].addEventListener(MouseEvent.CLICK,function():*
            {
               gotoAndStop(Timeline.IDLE);
               yesCallback();
            });
            this["noBtn"].visible = true;
            this["noBtn"].addEventListener(MouseEvent.CLICK,function():*
            {
               gotoAndStop(Timeline.IDLE);
               noCallback();
            });
         }
      }
      
      private function onShowInvFull(param1:MovieClip) : void
      {
         var myArr:Array;
         var numi:int;
         var stra:String;
         var strb:String;
         var myPattern:RegExp;
         var mc:MovieClip = param1;
         this.stop();
         myArr = new Array();
         numi = 0;
         stra = "";
         this["displayTxt"].text = AppData.lang == AppData.ZH ? "注意 !" : "Caution !";
         this["txtbox10"].text = AppData.lang == AppData.ZH ? "圖例：" : "Note:";
         this["txtbox11"].htmlText = AppData.lang == AppData.ZH ? "<font color=\'#FF0000\'>" + "紅色" + "</font>" + " : 存儲空間不足" : "<font color=\'#FF0000\'>" + "Red" + "</font>" + " : Insufficient Storage";
         this["txtbox12"].htmlText = AppData.lang == AppData.ZH ? "白色" + " : 正常" : "White" + " : Normal";
         strb = "xxx";
         if(Central.main.getMainChar().getInventory(InventoryData.TYPE_WEAPON).length + this.extraInfo["w_req"] > Data.INV_SPACE_WEAPON)
         {
            this["txtbox1"].htmlText = AppData.lang == AppData.ZH ? "武器 : " + "<font color=\'#FF0000\'>" + Central.main.getMainChar().getInventory(InventoryData.TYPE_WEAPON).length + "</font>" + "/" + Data.INV_SPACE_WEAPON : "Weapon :" + "<font color=\'#FF0000\'>" + Central.main.getMainChar().getInventory(InventoryData.TYPE_WEAPON).length + "</font>" + "/" + Data.INV_SPACE_WEAPON;
            if(AppData.lang == AppData.ZH)
            {
               myArr[numi] = "武器";
               numi++;
            }
            else
            {
               myArr[numi] = "Weapon";
               numi++;
            }
         }
         else
         {
            this["txtbox1"].text = AppData.lang == AppData.ZH ? "武器 : " + Central.main.getMainChar().getInventory(InventoryData.TYPE_WEAPON).length + "/" + Data.INV_SPACE_WEAPON : "Weapon :" + Central.main.getMainChar().getInventory(InventoryData.TYPE_WEAPON).length + "/" + Data.INV_SPACE_WEAPON;
         }
         if(Central.main.getMainChar().getInventory(InventoryData.TYPE_BODY_SET).length + this.extraInfo["b_req"] > Data.INV_SPACE_BODYSET)
         {
            this["txtbox2"].htmlText = AppData.lang == AppData.ZH ? "服裝 : " + "<font color=\'#FF0000\'>" + Central.main.getMainChar().getInventory(InventoryData.TYPE_BODY_SET).length + "</font>" + "/" + Data.INV_SPACE_BODYSET : "Clothing :" + "<font color=\'#FF0000\'>" + Central.main.getMainChar().getInventory(InventoryData.TYPE_BODY_SET).length + "</font>" + "/" + Data.INV_SPACE_BODYSET;
            if(AppData.lang == AppData.ZH)
            {
               myArr[numi] = "服裝";
               numi++;
            }
            else
            {
               myArr[numi] = "Clothing";
               numi++;
            }
         }
         else
         {
            this["txtbox2"].text = AppData.lang == AppData.ZH ? "服裝 : " + Central.main.getMainChar().getInventory(InventoryData.TYPE_BODY_SET).length + "/" + Data.INV_SPACE_BODYSET : "Clothing :" + Central.main.getMainChar().getInventory(InventoryData.TYPE_BODY_SET).length + "/" + Data.INV_SPACE_BODYSET;
         }
         if(Central.main.getMainChar().getInventory(InventoryData.TYPE_ACCESSORY).length + this.extraInfo["a_req"] > Data.INV_SPACE_ACCESSORY)
         {
            this["txtbox3"].htmlText = AppData.lang == AppData.ZH ? "飾品 : " + "<font color=\'#FF0000\'>" + Central.main.getMainChar().getInventory(InventoryData.TYPE_ACCESSORY).length + "</font>" + "/" + Data.INV_SPACE_ACCESSORY : "Accessories :" + "<font color=\'#FF0000\'>" + Central.main.getMainChar().getInventory(InventoryData.TYPE_ACCESSORY).length + "</font>" + "/" + Data.INV_SPACE_ACCESSORY;
            if(AppData.lang == AppData.ZH)
            {
               myArr[numi] = "飾品";
               numi++;
            }
            else
            {
               myArr[numi] = "Accessories";
               numi++;
            }
         }
         else
         {
            this["txtbox3"].text = AppData.lang == AppData.ZH ? "飾品 : " + Central.main.getMainChar().getInventory(InventoryData.TYPE_ACCESSORY).length + "/" + Data.INV_SPACE_ACCESSORY : "Accessories :" + Central.main.getMainChar().getInventory(InventoryData.TYPE_ACCESSORY).length + "/" + Data.INV_SPACE_ACCESSORY;
         }
         if(Central.main.getMainChar().getInventory(InventoryData.TYPE_BACK_ITEM).length + this.extraInfo["b_req"] > Data.INV_SPACE_BACKITEM)
         {
            this["txtbox4"].htmlText = AppData.lang == AppData.ZH ? "背部裝飾 : " + "<font color=\'#FF0000\'>" + Central.main.getMainChar().getInventory(InventoryData.TYPE_BACK_ITEM).length + "</font>" + "/" + Data.INV_SPACE_BACKITEM : "Back Item :" + "<font color=\'#FF0000\'>" + Central.main.getMainChar().getInventory(InventoryData.TYPE_BACK_ITEM).length + "</font>" + "/" + Data.INV_SPACE_BACKITEM;
            if(AppData.lang == AppData.ZH)
            {
               myArr[numi] = "背部裝飾";
               numi++;
            }
            else
            {
               myArr[numi] = "Back Item";
               numi++;
            }
         }
         else
         {
            this["txtbox4"].text = AppData.lang == AppData.ZH ? "背部裝飾 : " + Central.main.getMainChar().getInventory(InventoryData.TYPE_BACK_ITEM).length + "/" + Data.INV_SPACE_BACKITEM : "Back Item :" + Central.main.getMainChar().getInventory(InventoryData.TYPE_BACK_ITEM).length + "/" + Data.INV_SPACE_BACKITEM;
         }
         if(Account.getAccountType() == Account.FREE)
         {
            if(Central.main.getMainChar().getInventory(InventoryData.TYPE_MATERIAL).length + 10 > Data.INV_SPACE_MATERIAL_FREE)
            {
               this["txtbox5"].htmlText = AppData.lang == AppData.ZH ? "素材 : " + "<font color=\'#FF0000\'>" + Central.main.getMainChar().getInventory(InventoryData.TYPE_MATERIAL).length + "</font>" + "/" + Data.INV_SPACE_MATERIAL_FREE : "Material :" + "<font color=\'#FF0000\'>" + Central.main.getMainChar().getInventory(InventoryData.TYPE_MATERIAL).length + "</font>" + "/" + Data.INV_SPACE_MATERIAL_FREE;
               if(AppData.lang == AppData.ZH)
               {
                  myArr[numi] = "素材";
                  numi++;
               }
               else
               {
                  myArr[numi] = "Material";
                  numi++;
               }
            }
            else
            {
               this["txtbox5"].text = AppData.lang == AppData.ZH ? "素材 : " + Central.main.getMainChar().getInventory(InventoryData.TYPE_MATERIAL).length + "/" + Data.INV_SPACE_MATERIAL_FREE : "Material :" + Central.main.getMainChar().getInventory(InventoryData.TYPE_MATERIAL).length + "/" + Data.INV_SPACE_MATERIAL_FREE;
            }
         }
         else if(Central.main.getMainChar().getInventory(InventoryData.TYPE_MATERIAL).length + this.extraInfo["m_req"] > Data.INV_SPACE_MATERIAL_PREMIUM)
         {
            this["txtbox5"].htmlText = AppData.lang == AppData.ZH ? "素材 : " + "<font color=\'#FF0000\'>" + Central.main.getMainChar().getInventory(InventoryData.TYPE_MATERIAL).length + "</font>" + "/" + Data.INV_SPACE_MATERIAL_PREMIUM : "Material :" + "<font color=\'#FF0000\'>" + Central.main.getMainChar().getInventory(InventoryData.TYPE_MATERIAL).length + "</font>" + "/" + Data.INV_SPACE_MATERIAL_PREMIUM;
            if(AppData.lang == AppData.ZH)
            {
               myArr[numi] = "素材";
               numi++;
            }
            else
            {
               myArr[numi] = "Material";
               numi++;
            }
         }
         else
         {
            this["txtbox5"].text = AppData.lang == AppData.ZH ? "素材 : " + Central.main.getMainChar().getInventory(InventoryData.TYPE_MATERIAL).length + "/" + Data.INV_SPACE_MATERIAL_PREMIUM : "Material :" + Central.main.getMainChar().getInventory(InventoryData.TYPE_MATERIAL).length + "/" + Data.INV_SPACE_MATERIAL_PREMIUM;
         }
         if(Account.getAccountType() == Account.FREE)
         {
            if(Central.main.getMainChar().getInventory(InventoryData.TYPE_ITEM).length + this.extraInfo["i_req"] > Data.INV_SPACE_FREE)
            {
               this["txtbox6"].htmlText = AppData.lang == AppData.ZH ? "消耗物品 : " + "<font color=\'#FF0000\'>" + Central.main.getMainChar().getInventory(InventoryData.TYPE_ITEM).length + "</font>" + "/" + Data.INV_SPACE_FREE : "Consumable Item :" + "<font color=\'#FF0000\'>" + Central.main.getMainChar().getInventory(InventoryData.TYPE_ITEM).length + "</font>" + "/" + Data.INV_SPACE_FREE;
               if(AppData.lang == AppData.ZH)
               {
                  myArr[numi] = "消耗物品";
                  numi++;
               }
               else
               {
                  myArr[numi] = "Consumable Item";
                  numi++;
               }
            }
            else
            {
               this["txtbox6"].text = AppData.lang == AppData.ZH ? "消耗物品 : " + Central.main.getMainChar().getInventory(InventoryData.TYPE_ITEM).length + "/" + Data.INV_SPACE_FREE : "Consumable Item :" + Central.main.getMainChar().getInventory(InventoryData.TYPE_ITEM).length + "/" + Data.INV_SPACE_FREE;
            }
         }
         else if(Central.main.getMainChar().getInventory(InventoryData.TYPE_ITEM).length + this.extraInfo["i_req"] > Data.INV_SPACE_PREMIUM)
         {
            this["txtbox6"].htmlText = AppData.lang == AppData.ZH ? "消耗物品 : " + "<font color=\'#FF0000\'>" + Central.main.getMainChar().getInventory(InventoryData.TYPE_ITEM).length + "</font>" + "/" + Data.INV_SPACE_PREMIUM : "Consumable Item :" + "<font color=\'#FF0000\'>" + Central.main.getMainChar().getInventory(InventoryData.TYPE_ITEM).length + "</font>" + "/" + Data.INV_SPACE_PREMIUM;
            if(AppData.lang == AppData.ZH)
            {
               myArr[numi] = "消耗物品";
               numi++;
            }
            else
            {
               myArr[numi] = "Consumable Item";
               numi++;
            }
         }
         else
         {
            this["txtbox6"].text = AppData.lang == AppData.ZH ? "消耗物品 : " + Central.main.getMainChar().getInventory(InventoryData.TYPE_ITEM).length + "/" + Data.INV_SPACE_PREMIUM : "Consumable Item :" + Central.main.getMainChar().getInventory(InventoryData.TYPE_ITEM).length + "/" + Data.INV_SPACE_PREMIUM;
         }
         if(Central.main.getMainChar().getInventory(InventoryData.TYPE_ESSENCE).length + this.extraInfo["e_req"] > Data.INV_SPACE_ESSENCE)
         {
            this["txtbox7"].htmlText = AppData.lang == AppData.ZH ? "忍者精華 : " + "<font color=\'#FF0000\'>" + Central.main.getMainChar().getInventory(InventoryData.TYPE_ESSENCE).length + "</font>" + "/" + Data.INV_SPACE_ESSENCE : "Essence :" + "<font color=\'#FF0000\'>" + Central.main.getMainChar().getInventory(InventoryData.TYPE_ESSENCE).length + "</font>" + "/" + Data.INV_SPACE_ESSENCE;
            if(AppData.lang == AppData.ZH)
            {
               myArr[numi] = "忍者精華";
               numi++;
            }
            else
            {
               myArr[numi] = "Essence";
               numi++;
            }
         }
         else
         {
            this["txtbox7"].text = AppData.lang == AppData.ZH ? "忍者精華 : " + Central.main.getMainChar().getInventory(InventoryData.TYPE_ESSENCE).length + "/" + Data.INV_SPACE_ESSENCE : "Essence :" + Central.main.getMainChar().getInventory(InventoryData.TYPE_ESSENCE).length + "/" + Data.INV_SPACE_ESSENCE;
         }
         if(Account.getAccountType() == Account.FREE)
         {
            if(Central.main.getMainChar().pets.length + this.extraInfo["p_req"] > Data.INV_SPACE_PET_FREE)
            {
               this["txtbox9"].htmlText = AppData.lang == AppData.ZH ? "寵物 : " + "<font color=\'#FF0000\'>" + Central.main.getMainChar().pets.length + "</font>" + "/" + Data.INV_SPACE_PET_FREE : "Pet :" + "<font color=\'#FF0000\'>" + Central.main.getMainChar().pets.length + "</font>" + "/" + Data.INV_SPACE_PET_FREE;
               if(AppData.lang == AppData.ZH)
               {
                  myArr[numi] = "寵物";
               }
               else
               {
                  myArr[numi] = "Pet";
               }
            }
            else
            {
               this["txtbox9"].text = AppData.lang == AppData.ZH ? "寵物 : " + Central.main.getMainChar().pets.length + "/" + Data.INV_SPACE_PET_FREE : "Pet :" + Central.main.getMainChar().pets.length + "/" + Data.INV_SPACE_PET_FREE;
            }
         }
         else if(Central.main.getMainChar().pets.length + this.extraInfo["p_req"] > Data.INV_SPACE_PET_PREMIUM)
         {
            this["txtbox9"].htmlText = AppData.lang == AppData.ZH ? "寵物 : " + "<font color=\'#FF0000\'>" + Central.main.getMainChar().pets.length + "</font>" + "/" + Data.INV_SPACE_PET_PREMIUM : "Pet :" + "<font color=\'#FF0000\'>" + Central.main.getMainChar().pets.length + "</font>" + "/" + Data.INV_SPACE_PET_PREMIUM;
            if(AppData.lang == AppData.ZH)
            {
               myArr[numi] = "寵物";
            }
            else
            {
               myArr[numi] = "Pet";
            }
         }
         else
         {
            this["txtbox9"].text = AppData.lang == AppData.ZH ? "寵物 : " + Central.main.getMainChar().pets.length + "/" + Data.INV_SPACE_PET_PREMIUM : "Pet :" + Central.main.getMainChar().pets.length + "/" + Data.INV_SPACE_PET_PREMIUM;
         }
         if(AppData.lang == AppData.ZH)
         {
            stra = myArr.join("，");
         }
         else
         {
            stra = myArr.join(", ");
         }
         myPattern = /xxx/gi;
         strb = strb.replace(myPattern,stra);
         this["txt8"].htmlText = AppData.lang == AppData.ZH ? "背包的部份類型(" + "<font color=\'#FF0000\'>" + strb + "</font>" + ")空間不足以讓動作繼續。\n請先清出儲存空間。(建議你可在商店售出某些道具)" : "The category (" + "<font color=\'#FF0000\'>" + strb + "</font>" + ") of the Gear Bag are not sufficient to continue. \nPlease free up some storage space first. (Try selling some items to the shop)";
         this["noBtn"].visible = true;
         this["noBtn"].addEventListener(MouseEvent.CLICK,function():*
         {
            gotoAndStop(Timeline.IDLE);
            noCallback();
         });
      }
      
      private function onShowPvpInfoBox() : void
      {
         this.stop();
         this["displayTxt"].htmlText = this.confirmationTxt;
         if(this.okCallback != null)
         {
            this["okBtn"].visible = true;
            this["okBtn"].addEventListener(MouseEvent.CLICK,function():*
            {
               gotoAndStop(Timeline.IDLE);
               okCallback();
            });
            this["yesBtn"].visible = false;
            this["noBtn"].visible = false;
         }
         else if(this.yesCallback != null)
         {
            this["okBtn"].visible = false;
            this["yesBtn"].visible = true;
            this["yesBtn"].addEventListener(MouseEvent.CLICK,function():*
            {
               gotoAndStop(Timeline.IDLE);
               yesCallback();
            });
            this["noBtn"].visible = true;
            this["noBtn"].addEventListener(MouseEvent.CLICK,function():*
            {
               gotoAndStop(Timeline.IDLE);
               noCallback();
            });
         }
         else
         {
            this["okBtn"].visible = true;
            this["okBtn"].addEventListener(MouseEvent.CLICK,function():*
            {
               gotoAndStop(Timeline.IDLE);
            });
            this["yesBtn"].visible = false;
            this["noBtn"].visible = false;
         }
      }
      
      private function onShowPvpScheduleBox() : void
      {
         var i:int = 0;
         var schedule:String = "";
         this.stop();
         switch(AppData.lang)
         {
            case AppData.EN:
               schedule = Central.main.pvpSchedule[0];
               break;
            case AppData.ZH:
               schedule = Central.main.pvpSchedule[1];
               break;
            default:
               schedule = Central.main.pvpSchedule[0];
         }
         i = 0;
         while(i < 2)
         {
            this["displayTxt_" + i].text = Central.main.langLib.get(1730)[i];
            i++;
         }
         this["displayTxt_2"].text = schedule;
         this["line_0"].visible = this.isPvpOver;
         if(this.okCallback != null)
         {
            this["okBtn"].visible = true;
            this["okBtn"].addEventListener(MouseEvent.CLICK,function():*
            {
               gotoAndStop(Timeline.IDLE);
               okCallback();
            });
         }
      }
      
      public function onDeleteConfirmation() : void
      {
         var mc:MovieClip = null;
         Out.debug(this,"onDeleteConfirmation");
         mc = this["confDeleteMc"];
         mc.stop();
         mc["displayTxt"].htmlText = this.confirmationTxt;
         mc["deleteInput"].addEventListener(KeyboardEvent.KEY_UP,this.onDeleteInput);
         mc["yesBtn"].visible = false;
         mc["yesBtn"].addEventListener(MouseEvent.CLICK,function():*
         {
            mc.gotoAndStop(Timeline.EXIT);
            yesCallback();
         });
         mc["noBtn"].visible = true;
         mc["noBtn"].addEventListener(MouseEvent.CLICK,function():*
         {
            mc.gotoAndStop(Timeline.EXIT);
            noCallback();
         });
      }
      
      private function onDeleteInput(param1:KeyboardEvent) : void
      {
         if(this["confDeleteMc"])
         {
            if(this.fromPanel == "resetSkill")
            {
               if(this["confDeleteMc"]["deleteInput"].text.toLowerCase() == "reset")
               {
                  this["confDeleteMc"]["yesBtn"].visible = true;
               }
               else
               {
                  this["confDeleteMc"]["yesBtn"].visible = false;
               }
            }
            else if(this["confDeleteMc"]["deleteInput"].text.toLowerCase() == "delete")
            {
               this["confDeleteMc"]["yesBtn"].visible = true;
            }
            else
            {
               this["confDeleteMc"]["yesBtn"].visible = false;
            }
         }
      }
      
      private function onGetGoldToken() : void
      {
         var btnString:String = null;
         this.stop();
         this["titleTxt"].text = "";
         this["displayTxt"].text = this.confirmationTxt;
         if(this.typeGoldToken == "gold")
         {
            this["typeIcon"].gotoAndStop("gold");
            btnString = Central.main.langLib.get(1408);
         }
         else
         {
            this["typeIcon"].gotoAndStop("token");
            btnString = Central.main.langLib.get(1407);
         }
         this["noBtn"].visible = true;
         this["noBtn"].addEventListener(MouseEvent.CLICK,function():*
         {
            gotoAndStop(Timeline.IDLE);
         });
         Central.main.initButton(this["goMc"],function():*
         {
            gotoAndStop(Timeline.IDLE);
            yesCallback();
         },btnString);
      }
      
      private function onResetSkillConfirmation() : void
      {
         this.stop();
         this["displayTxt"].text = this.confirmationTxt;
         this["iconMC"].gotoAndStop(this.skillType);
         this["costTxt"].text = Central.main.langLib.btnTxt(ButtonData.COST2);
         this["priceMC"]["txt_token"].text = this.tokenPrice;
         this["noBtn"].visible = true;
         this["noBtn"].addEventListener(MouseEvent.CLICK,function():*
         {
            gotoAndStop(Timeline.IDLE);
            noCallback();
         });
         Central.main.initButton(this["btnConfirm"],function():*
         {
            gotoAndStop(Timeline.IDLE);
            yesCallback();
         },ButtonData.CONFIRM);
      }
      
      private function onRefreshConfitmation() : void
      {
         this.stop();
         this["titleTxt"].text = this.title;
         this["lbl_loginnotice"].text = this.confirmationTxt;
         Central.main.initButton(this["btnRefresh"],function():*
         {
            gotoAndStop(Timeline.IDLE);
            yesCallback();
         },this.btnTxt);
      }
      
      private function onNoticeBoard() : void
      {
         this.stop();
         this["titleTxt"].text = this.title;
         this["displayTxt"].text = this.confirmationTxt;
         this["typeIcon"]["ownTxt"].text = "";
         Central.main.initButton(this["goMc"],function():*
         {
            gotoAndStop(Timeline.IDLE);
            yesCallback();
         },ButtonData.CONFIRM);
      }
      
      public function onShowIcon(param1:MovieClip) : void
      {
         var _loc4_:Object = null;
         var _loc5_:String = null;
         var _loc2_:MovieClip = param1["iconMc"];
         if(this.valueObj.type == "skill")
         {
            _loc2_ = param1["skillIconMc"];
            param1["iconMc"].visible = false;
         }
         else if(param1["skillIconMc"])
         {
            param1["skillIconMc"].visible = false;
         }
         var _loc3_:MovieClip = new LoadingMc();
         GF.removeAllChild(_loc2_["iconHolder"]);
         if(this.valueObj.amount)
         {
            param1["ownTxt"].text = "X" + this.valueObj.amount;
         }
         else
         {
            param1["ownTxt"].text = "";
         }
         if(this.valueObj != null)
         {
            _loc5_ = "";
            switch(this.valueObj.type)
            {
               case "gold":
                  _loc4_ = Item.getDisplayData(this.valueObj.id);
                  _loc3_.addChild(_loc4_.mc);
                  _loc5_ = _loc4_.tooltip;
                  break;
               case "token":
                  _loc4_ = Item.getDisplayData(this.valueObj.id);
                  _loc3_.addChild(_loc4_.mc);
                  _loc5_ = _loc4_.tooltip;
                  break;
               case "back":
                  Item.getBackItemIcon(this.valueObj.id,_loc3_);
                  _loc5_ = TooltipData.getItemTooltip(TooltipData.TOOLTIP_TYPE_BACKITEM,this.valueObj.id);
                  break;
               case "set":
                  Item.getClothIcon(this.valueObj.id,_loc3_);
                  _loc5_ = TooltipData.getItemTooltip(TooltipData.TOOLTIP_TYPE_CLOTHING,this.valueObj.id);
                  break;
               case "wpn":
                  Item.getWeaponIcon(this.valueObj.id,_loc3_);
                  _loc5_ = TooltipData.getItemTooltip(TooltipData.TOOLTIP_TYPE_WEAPON,this.valueObj.id);
                  break;
               case "skill":
                  _loc3_ = Central.main.getLib(Central.main.SKILL_DATA[this.valueObj.id].swfName);
                  _loc5_ = TooltipData.getItemTooltip(TooltipData.TOOLTIP_TYPE_SKILL,this.valueObj.id);
                  break;
               case "cny_cake":
                  _loc3_ = Central.main.getLib("CnyCakeIcon");
                  _loc5_ = Central.main.langLib.get(1635)[1];
            }
         }
         _loc2_["iconHolder"].addChild(_loc3_);
      }
      
      private function onRRPromoteEvent() : void
      {
         this["titleTxt"].text = Central.main.langLib.get(1655)[10];
         this["subTitle"].text = "";
         this["displayTxt"].text = "";
         Central.main.initButton(this["goMc"],function():*
         {
            gotoAndStop(Timeline.IDLE);
            yesCallback();
         },ButtonData.CONFIRM);
         this["noBtn"].addEventListener(MouseEvent.CLICK,function():*
         {
            gotoAndStop(Timeline.IDLE);
            noCallback();
         });
      }
      
      private function onRenameConfirmation() : void
      {
         this.stop();
         this["displayTxt"].htmlText = this.confirmationTxt;
         if(Account.getAccountType() == Account.FREE)
         {
            this["otherPanel"].gotoAndPlay(Timeline.FREE_USER);
         }
         else if(Account.getAccountType() == Account.PREMIUM)
         {
            this["otherPanel"].gotoAndPlay(Timeline.PREMIUM_USER);
         }
         this["errorTxt"].text = Central.main.langLib.get(1322);
         this["renameInput"].addEventListener(KeyboardEvent.KEY_UP,this.onRenameInput);
         this["errorTxt"].visible = false;
         this["yesBtn2"].visible = true;
         Central.main.initButton(this["yesBtn2"],this.onRenameClickYes,this.btnTxt);
         this.disableButton(this["yesBtn2"],this.onRenameClickYes);
         this["noBtn"].visible = true;
         this["noBtn"].addEventListener(MouseEvent.CLICK,function():*
         {
            gotoAndStop(Timeline.IDLE);
            noCallback();
         });
      }
      
      public function onFreeUser() : *
      {
         this["otherPanel"]["requireTxt"].text = Central.main.langLib.titleTxt(TitleData.REQUIRE) + ":";
         this["otherPanel"]["emblemBtn"].addEventListener(MouseEvent.CLICK,this.upgradeAccount);
         Central.main.initButton(this["otherPanel"]["emblemBtn2"],this.upgradeAccount,ButtonData.GET_EMBLEM);
         this["otherPanel"]["requireTxt2"].text = Central.main.langLib.get(1323);
         this["otherPanel"]["requireTxt3"].text = Central.main.langLib.get(1324);
         this["otherPanel"]["priceMc1"]["txt_token"].text = this.tokenPrice;
         this["otherPanel"]["priceMc2"]["txt_token"].text = this.tokenPrice2;
      }
      
      public function onPremiumUser() : *
      {
         this["otherPanel"].gotoAndStop(Timeline.PREMIUM_USER);
         this["otherPanel"]["requireTxt"].text = Central.main.langLib.titleTxt(TitleData.REQUIRE) + ":";
         this["otherPanel"]["priceMc1"]["txt_token"].text = this.tokenPrice;
         this["otherPanel"]["priceMc2"]["txt_token"].text = this.tokenPrice2;
      }
      
      private function upgradeAccount(param1:MouseEvent) : void
      {
         gotoAndStop(Timeline.IDLE);
         Central.main.showUpgradeAccount(Central.main.langLib.get(1451),"Profile");
      }
      
      private function onRenameClickYes(param1:MouseEvent) : void
      {
         var _loc2_:String = this["renameInput"].text;
         if(TextFilter.isNotException(_loc2_) && _loc2_ != "")
         {
            if(Account.getAccountType() == Account.FREE && Account.getAccountBalance() >= 1000 || Account.getAccountType() == Account.PREMIUM && Account.getAccountBalance() >= 600)
            {
               gotoAndStop(Timeline.IDLE);
               this.yesCallback(_loc2_);
            }
            else
            {
               this.showInfo(Central.main.langLib.get(91));
            }
         }
         else
         {
            this.onRenameInput();
         }
      }
      
      private function showInfo(param1:String) : void
      {
         this.infoMessage = param1;
         this["info"].gotoAndPlay(Timeline.SHOW);
      }
      
      public function onInfo() : void
      {
         var _loc1_:MovieClip = this["info"];
         if(this.infoMessage != null)
         {
            _loc1_["msgTxt"].text = this.infoMessage;
            this.infoMessage = null;
         }
         else
         {
            _loc1_.gotoAndStop(Timeline.IDLE);
         }
      }
      
      private function onRenameInput(param1:KeyboardEvent = null) : void
      {
         var _loc2_:String = this["renameInput"].text;
         if(TextFilter.isNotException(_loc2_) && _loc2_ != "")
         {
            Central.main.initButton(this["yesBtn2"],this.onRenameClickYes);
            this["yesBtn2"].filters = null;
            this["errorTxt"].visible = false;
         }
         else
         {
            this.disableButton(this["yesBtn2"],this.onRenameClickYes);
            this["errorTxt"].visible = true;
         }
      }
      
      private function onShareBox() : void
      {
         this.stop();
         Central.main.initButton(this["shareBtn"],function():*
         {
            gotoAndStop(Timeline.IDLE);
            yesCallback();
         },ButtonData.SHARE);
         this["skipBtn"].addEventListener(MouseEvent.CLICK,function():*
         {
            gotoAndStop(Timeline.IDLE);
            noCallback();
         });
         this["iconMc"].gotoAndStop(Central.sns.fbFeedIcon);
         this["titleTxt"].text = Central.main.langLib.titleTxt(TitleData.SHARE);
         this["feedTitleTxt"].text = Central.main.langLib.titleTxt(TitleData.SHARETOFRIEND);
         this["feedCaptionTxt"].htmlText = this.confirmationTxt;
      }
      
      public function onShareBoxNew() : void
      {
         var emptyMc:MovieClip;
         var mc:MovieClip = null;
         var displayMc:MovieClip = null;
         mc = this["shareBoxMc"];
         mc.stop();
         displayMc = new LoadingMc();
         mc["iconHolder"].addChild(displayMc);
         Central.main.initButton(mc["shareBtn"],function():*
         {
            mc.gotoAndStop(Timeline.IDLE);
            yesCallback();
         },this.btnTxt);
         mc["skipBtn"].addEventListener(MouseEvent.CLICK,function():*
         {
            mc.gotoAndStop(Timeline.IDLE);
            noCallback();
         });
         mc["titleTxt"].text = Central.main.langLib.titleTxt(TitleData.SHARE);
         mc["feedTitleTxt"].text = this.feedTitle;
         mc["feedCaptionTxt"].htmlText = this.confirmationTxt;
         emptyMc = new MovieClip();
         if(this.icon.indexOf("ach_") >= 0)
         {
            emptyMc.scaleX = 2;
            emptyMc.scaleY = 2;
         }
         mc["iconHolder"].addChild(emptyMc);
         Central.main.proc.loadIcon(this.icon,emptyMc,this.icon,null);
      }
      
      private function onShowFAQ() : void
      {
         this.stop();
         this["btnClose"].addEventListener(MouseEvent.CLICK,function():*
         {
            gotoAndStop(Timeline.IDLE);
         });
         this["att_titleTxt"].text = this.title;
         this["att_subTitle1"].text = this.subTitle1;
         this["att_contents1"].htmlText = this.contents1;
         this["att_subTitle2"].text = this.subTitle2;
         this["att_contents2"].htmlText = this.contents2;
         this["att_subTitle3"].text = this.subTitle3;
         this["att_contents3"].htmlText = this.contents3;
      }
      
      private function onShowPayConfirm() : void
      {
         this.stop();
         var _loc1_:MovieClip = this["payConfirmMc"];
         switch(this.payConfirmType)
         {
            case ConfirmationDoc.PAY_CONFIRM_TOKEN:
               _loc1_.gotoAndStop("token");
               break;
            case ConfirmationDoc.PAY_CONFIRM_GOLD:
               _loc1_.gotoAndStop("gold");
         }
      }
      
      public function onShowPayTokenConfirm() : void
      {
         var buttonTxt:String;
         var mc:MovieClip = null;
         mc = this["payConfirmMc"];
         mc["noBtn"].addEventListener(MouseEvent.CLICK,function():*
         {
            mc.gotoAndStop(Timeline.IDLE);
            gotoAndStop(Timeline.IDLE);
         });
         mc["displayTxt"].text = this.confirmationTxt;
         mc["requireTxt"].text = Central.main.langLib.titleTxt(TitleData.REQUIRE) + ":";
         mc["priceMc"]["txt_token"].text = this.tokenPrice;
         buttonTxt = "";
         switch(this.txt2)
         {
            case "recruit_friends_2":
            case "mission_2":
               buttonTxt = Central.main.langLib.get(1598)[19];
               break;
            case "SoccerFever_2012":
               buttonTxt = ButtonData.CONFIRM;
               break;
            default:
               buttonTxt = ButtonData.GETNOW;
         }
         Central.main.initButton(mc["payBtn"],function():*
         {
            mc.gotoAndStop(Timeline.IDLE);
            gotoAndStop(Timeline.IDLE);
            yesCallback();
         },buttonTxt);
      }
      
      public function onShowPayGoldConfirm() : void
      {
         var buttonTxt:String;
         var mc:MovieClip = null;
         mc = this["payConfirmMc"];
         mc["noBtn"].addEventListener(MouseEvent.CLICK,function():*
         {
            mc.gotoAndStop(Timeline.IDLE);
            gotoAndStop(Timeline.IDLE);
         });
         mc["displayTxt"].text = this.confirmationTxt;
         mc["requireTxt"].text = Central.main.langLib.titleTxt(TitleData.REQUIRE) + ":";
         mc["priceMc"]["txt_gold"].text = this.goldPrice;
         buttonTxt = "";
         switch(this.txt2)
         {
            case "recruit_friends_2":
               buttonTxt = Central.main.langLib.get(1598)[19];
               break;
            default:
               buttonTxt = ButtonData.GETNOW;
         }
         Central.main.initButton(mc["payBtn"],function():*
         {
            mc.gotoAndStop(Timeline.IDLE);
            gotoAndStop(Timeline.IDLE);
            yesCallback();
         },buttonTxt);
      }
      
      private function onShowDead(param1:MovieClip) : void
      {
         if(this.deadPopupArr.length <= 0)
         {
            this.deadClose();
            return;
         }
         this.stop();
         param1["noBtn"].addEventListener(MouseEvent.CLICK,this.deadClose);
         this.rNum = NumberUtil.randomInt(0,this.deadPopupArr.length - 1);
         param1["typeIcon"].gotoAndStop(this.deadPopupArr[this.rNum].frame);
         Central.main.initButton(param1["goBtn"],this.deadGoTo,this.deadPopupArr[this.rNum].txt);
         param1["displayTxt"].text = this.deadPopupArr[this.rNum].msg;
      }
      
      private function deadGoTo(param1:MouseEvent) : void
      {
         if(String(param1.currentTarget.name) == "goBtn")
         {
         }
         this.deadClose();
         switch(this.deadPopupArr[this.rNum].txt)
         {
            case ButtonData.GO_TO_SHOP:
               Central.panel.getInstance().show("shop_new");
               break;
            case ButtonData.GO_TO_ACADEMY:
               Central.panel.getInstance().show("academy");
         }
      }
      
      private function deadClose(param1:MouseEvent = null) : void
      {
         if(param1 != null)
         {
         }
         this.gotoAndStop(Timeline.IDLE);
         if(param1 != null && Central.main.battleToPage != "" && Central.panel.getInstance().getCurPanelName() == Central.main.battleToPage)
         {
            Central.panel.getInstance().show(Central.main.battleToPage);
         }
      }
      
      private function onShowGuide(param1:MovieClip) : void
      {
         var _loc2_:Object = null;
         var _loc4_:int = 0;
         var _loc5_:Object = null;
         var _loc6_:String = null;
         this.stop();
         var _loc3_:String = "";
         if(this.islvup)
         {
            this.reward_arr = [];
            this.reward_arr.push(this.lvupreward_Obj[int(Central.main.lvUpRewardType)]);
            if(int(Central.main.lvUpRewardType) == 8 && Boolean(Central.main.lvUpTokenClaimed))
            {
               this.reward_arr = [];
               this.reward_arr.push({
                  "msg":Central.main.langLib.get(1073) + "<br>" + Central.main.langLib.get(1464),
                  "frame":"gold",
                  "txt":ButtonData.GO_TO_ACADEMY,
                  "reward":2000
               });
            }
            switch(this.reward_arr[0].frame)
            {
               case "weapon":
                  _loc2_ = Central.main.WEAPON_DATA.find(this.reward_arr[0].reward);
                  _loc3_ = String(this.reward_arr[0].msg).replace("[valwpn]",String(_loc2_.name));
                  break;
               case "cloth":
                  _loc5_ = {};
                  _loc6_ = "";
                  if(Central.main.getMainChar().getGender() == 0)
                  {
                     _loc5_ = Central.main.BODY_SET_BOY;
                     _loc6_ = this.reward_arr[0].reward_boy;
                  }
                  else
                  {
                     _loc5_ = Central.main.BODY_SET_GIRL;
                     _loc6_ = this.reward_arr[0].reward_girl;
                  }
                  if(_loc5_[_loc6_])
                  {
                     _loc2_ = _loc5_[_loc6_];
                  }
                  _loc3_ = String(this.reward_arr[0].msg).replace("[valclo]",String(_loc2_.name));
                  break;
               case "skill":
                  if(Central.main.SKILL_DATA[this.reward_arr[0].reward])
                  {
                     _loc2_ = Central.main.SKILL_DATA[this.reward_arr[0].reward];
                  }
                  _loc3_ = String(this.reward_arr[0].msg).replace("[valski]",String(_loc2_.name));
                  break;
               case "gold":
                  _loc3_ = String(this.reward_arr[0].msg).replace("[valgold]",this.reward_arr[0].reward.toString());
                  break;
               case "token":
                  _loc3_ = String(this.reward_arr[0].msg).replace("[valtoken]",this.reward_arr[0].reward.toString());
                  break;
               default:
                  _loc3_ = this.reward_arr[0].msg;
            }
            param1["displayTxt"].htmlText = _loc3_;
            param1["typeIcon"].gotoAndStop(this.reward_arr[0].frame);
            param1["noBtn"].addEventListener(MouseEvent.CLICK,this.claimLvUpReward);
            Central.main.initButton(param1["goMc"],this.claimLvUpReward,this.reward_arr[0].txt);
         }
         else
         {
            param1["displayTxt"].htmlText = this.confirmationTxt;
            param1["typeIcon"].gotoAndStop(this.iconFrame);
            Central.main.initButton(param1["goMc"],this.okShowGuide,this.btnName);
            param1["noBtn"].addEventListener(MouseEvent.CLICK,this.closeShowGuide);
            this.gotoAndStop("guide");
         }
      }
      
      public function okShowGuide(param1:MouseEvent = null) : void
      {
         this.yesCallback();
         this.gotoAndStop(Timeline.IDLE);
      }
      
      public function closeShowGuide(param1:MouseEvent = null) : void
      {
         this.noCallback();
         this.gotoAndStop(Timeline.IDLE);
      }
      
      public function claimLvUpReward(param1:MouseEvent = null) : void
      {
         this.btnName = String(param1.currentTarget.name);
         this.gotoAndStop(Timeline.IDLE);
         if(this.islvup)
         {
            Central.main.showAmfLoading();
            Central.main.amfClient.service("SpecialReward.claimLvUpReward",[Central.main.account.getAccountSessionKey()],this.claimLvUpRewardResponse);
         }
      }
      
      private function claimLvUpRewardResponse(param1:Object) : void
      {
         Central.main.hideAmfLoading();
         if(Central.main.validateAmfResponse(param1))
         {
            this.addReward(this.reward_arr);
            this.closeToPage();
         }
      }
      
      private function addReward(param1:Array) : void
      {
         var _loc2_:* = undefined;
         var _loc3_:int = 0;
         var _loc4_:String = null;
         _loc2_ = 0;
         while(_loc2_ < param1.length)
         {
            switch(String(param1[_loc2_].frame))
            {
               case "token":
                  Central.main.account.balance = Central.main.account.getAccountBalance() + int(param1[_loc2_].reward);
                  Central.main.lvUpTokenClaimed = true;
                  break;
               case "gold":
                  Central.main.getMainChar().updateGold(int(param1[_loc2_].reward));
                  break;
               case "weapon":
                  Central.main.getMainChar().addInventory(InventoryData.TYPE_WEAPON,String(param1[_loc2_].reward));
                  break;
               case "cloth":
                  _loc4_ = "";
                  if(int(Central.main.getMainChar().getGender() == 0))
                  {
                     _loc4_ = String(param1[_loc2_].reward_boy);
                  }
                  else
                  {
                     _loc4_ = String(param1[_loc2_].reward_girl);
                  }
                  if(!Central.main.getMainChar().hasItem(InventoryData.TYPE_BODY_SET,_loc4_))
                  {
                     Central.main.getMainChar().addInventory(InventoryData.TYPE_BODY_SET,_loc4_);
                  }
                  break;
               case "backitem":
                  Central.main.getMainChar().addInventory(InventoryData.TYPE_BACK_ITEM,String(param1[_loc2_].reward));
                  break;
               case "item":
                  Central.main.getMainChar().addInventory(InventoryData.TYPE_ITEM,String(param1[_loc2_].reward));
                  break;
               case "skill":
                  if(!Central.main.getMainChar().hasSkill(String(param1[_loc2_].reward)))
                  {
                     Central.main.getMainChar().addInventory(InventoryData.TYPE_SKILL,String(param1[_loc2_].reward));
                  }
                  break;
               case "magatama":
                  _loc3_ = 0;
                  while(_loc3_ < int(param1[_loc2_].reward))
                  {
                     Central.main.getMainChar().addMagatama(int(param1[_loc2_].mgt_lv));
                     _loc3_++;
                  }
            }
            _loc2_++;
         }
         Central.main.updateMenu();
      }
      
      public function closeToPage() : void
      {
         if(this.btnName == "goMc")
         {
            switch(String(this.reward_arr[0].txt))
            {
               case ButtonData.GO_TO_ACADEMY:
                  Central.panel.getInstance().show("academy");
                  break;
               case ButtonData.GO_TO_SKILL:
                  Central.main.mapMenu.gotoAndPlay(Timeline.SKILL);
                  break;
               case ButtonData.GO_TO_GEAR:
                  Central.main.mapMenu.gotoAndPlay(Timeline.EQUIPMENT);
                  break;
               case ButtonData.GO_TO_BLACKSMITH:
                  Central.panel.getInstance().show("blacksmith");
            }
         }
         if(this.btnName == "noBtn")
         {
            if(Central.mission.curMissionID == null)
            {
               Central.main.getMainChar().checkLvUpReward();
            }
         }
      }
      
      public function gotoInviteFrd(param1:MouseEvent = null) : void
      {
         this.gotoAndStop(Timeline.IDLE);
         Central.main.showInviteFriend();
      }
      
      private function onShowTrainSkillConfirm() : void
      {
         var skillIcon:MovieClip;
         var skillStr:String;
         this.stop();
         this["noBtn"].addEventListener(MouseEvent.CLICK,function():*
         {
            gotoAndStop(Timeline.IDLE);
         });
         Central.main.initButton(this["trainBtn"],function():*
         {
            gotoAndStop(Timeline.IDLE);
            yesCallback();
         },ButtonData.GO);
         this["displayTxt"].text = this.confirmationTxt;
         GF.removeAllChild(this["skillIcon"]["holder"]);
         skillIcon = null;
         skillIcon = Central.main.getLib(this.skill_id);
         this["skillIcon"]["holder"].addChild(skillIcon);
         skillStr = TooltipData.getItemTooltip(TooltipData.TOOLTIP_TYPE_SKILL,this.skill_id);
         Central.main.showDynamicTooltip(this["skillIcon"],String("<font size=\'16\'>" + skillStr + "</font>"));
      }
      
      private function onGeneralNotice() : void
      {
         this.stop();
         Central.main.initButton(this["enterBtn"],function():*
         {
            gotoAndStop(Timeline.IDLE);
            okCallback();
         },this.btnTxt);
         this["closeBtn"].addEventListener(MouseEvent.CLICK,function():*
         {
            gotoAndStop(Timeline.IDLE);
         });
         this["titleTxt"].text = this.title;
         this["displayTxt"].text = this.confirmationTxt;
      }
      
      private function gotoEventPage(param1:MouseEvent) : void
      {
         this.okCallback();
         this.gotoAndStop(Timeline.IDLE);
         Central.panel.getInstance().show("4thann_battle");
      }
      
      public function showDeleteConfirmation(param1:String, param2:Function, param3:Function, param4:String = null) : void
      {
         this.confirmationTxt = param1;
         this.yesCallback = param2;
         this.noCallback = param3;
         this.okCallback = null;
         this.fromPanel = param4;
         this["confDeleteMc"].gotoAndPlay(Timeline.SHOW);
      }
      
      public function showRenameConfirmation(param1:String, param2:Function, param3:Function, param4:int, param5:int, param6:String) : void
      {
         this.confirmationTxt = param1;
         this.yesCallback = param2;
         this.noCallback = param3;
         this.okCallback = null;
         this.tokenPrice = param4;
         this.tokenPrice2 = param5;
         this.btnTxt = param6;
         this.gotoAndPlay(TL_RENAME_CONFIRMATION);
      }
      
      public function showRefreshConfirmation(param1:String, param2:String, param3:Function, param4:String) : void
      {
         this.title = param1;
         this.confirmationTxt = param2;
         this.yesCallback = param3;
         this.btnTxt = param4;
         this.gotoAndPlay(TL_REFRESH_CONFIRMATION);
      }
      
      public function showResetSkillConfirmation(param1:String, param2:Function, param3:Function, param4:String, param5:int) : void
      {
         this.confirmationTxt = param1;
         this.yesCallback = param2;
         this.noCallback = param3;
         this.okCallback = null;
         this.skillType = param4;
         this.tokenPrice = param5;
         this.gotoAndStop(TL_RESET_SKILL_CONFIRMATION);
      }
      
      public function showNoticeBoard(param1:String, param2:String, param3:Function, param4:Function, param5:String, param6:Object = null) : void
      {
         this.title = param1;
         this.confirmationTxt = param2;
         this.yesCallback = param3;
         this.noCallback = param4;
         this.okCallback = null;
         this.skillType = param5;
         this.valueObj = param6;
         this.gotoAndStop(TL_NOTICE_BOARD);
      }
      
      public function showConfirmation(param1:String, param2:Function, param3:Function, param4:*) : void
      {
         this.confirmationTxt = param1;
         this.yesCallback = param2;
         this.noCallback = param3;
         this.okCallback = null;
         this.useHtml = param4;
         this.gotoAndPlay(Timeline.SHOW);
      }
      
      public function showInvFullConfirmation(param1:Function, param2:*, param3:*) : void
      {
         this.noCallback = param1;
         this.okCallback = null;
         this.useHtml = param3;
         this.extraInfo = param2;
         this.gotoAndPlay("invFull");
      }
      
      public function showPvpInfoBox(param1:String, param2:Function, param3:Function, param4:Function) : void
      {
         this.confirmationTxt = param1;
         this.yesCallback = param3;
         this.noCallback = param4;
         this.okCallback = param2;
         this.gotoAndPlay("showPvpInfo");
      }
      
      public function showPvpScheduleBox(param1:Function, param2:Boolean) : void
      {
         this.okCallback = param1;
         this.yesCallback = null;
         this.noCallback = null;
         this.isPvpOver = param2;
         this.gotoAndPlay("showPvpSchedule");
      }
      
      public function showEnemyHP(param1:Function) : void
      {
         this.confirmationTxt = "";
         this.yesCallback = null;
         this.noCallback = null;
         this.okCallback = param1;
         this.gotoAndPlay("get_enemy_hp");
      }
      
      public function getGoldToken(param1:String, param2:Function, param3:String) : void
      {
         this.confirmationTxt = param1;
         this.yesCallback = param2;
         this.noCallback = null;
         this.okCallback = null;
         this.typeGoldToken = param3;
         this.gotoAndStop(TL_GET_GOLD_TOKEN);
      }
      
      public function showOk(param1:String, param2:Function, param3:*) : void
      {
         this.confirmationTxt = param1;
         this.okCallback = param2;
         this.yesCallback = null;
         this.noCallback = null;
         this.useHtml = param3;
         this.gotoAndPlay(Timeline.SHOW);
      }
      
      public function showPopup(param1:String, param2:String, param3:Function, param4:Function) : void
      {
         this.popupTitleTxt = param1;
         this.popupMsgTxt = param2;
         this.okCallback1 = param3;
         this.okCallback2 = param4;
         this.yesCallback = null;
         this.noCallback = null;
         this.gotoAndPlay("popup_info");
      }
      
      public function showPopupSealFail(param1:String, param2:String, param3:Function) : void
      {
         this.popupTitleTxt = param1;
         this.popupMsgTxt = param2;
         this.okCallback1 = param3;
         this.noCallback = null;
         this.gotoAndPlay("seal_fail");
      }
      
      public function showPopupSpecialHpBar(param1:Object) : void
      {
         this.specialHpData = param1;
         this.gotoAndPlay("seal_hp");
      }
      
      public function showShareBox(param1:String, param2:Function, param3:Function) : void
      {
         this.confirmationTxt = param1;
         this.yesCallback = param2;
         this.noCallback = param3;
         this.okCallback = null;
         this.gotoAndPlay(TL_SHARE_BOX);
      }
      
      public function showShareBoxNew(param1:String, param2:String, param3:String, param4:String, param5:Function, param6:Function) : void
      {
         if(this.currentLabel == "share_box_new")
         {
            return;
         }
         this.feedTitle = param1;
         this.confirmationTxt = param2;
         this.icon = param3;
         this.btnTxt = param4;
         this.yesCallback = param5;
         this.noCallback = param6;
         this.okCallback = null;
         this["shareBoxMc"].gotoAndPlay(Timeline.SHOW);
      }
      
      public function showFAQ(param1:String, param2:String, param3:String, param4:String, param5:String, param6:String, param7:String) : void
      {
         this.title = param1;
         this.subTitle1 = param2;
         this.contents1 = param3;
         this.subTitle2 = param4;
         this.contents2 = param5;
         this.subTitle3 = param6;
         this.contents3 = param7;
         this.okCallback = null;
         this.yesCallback = null;
         this.noCallback = null;
         this.gotoAndStop("faq");
      }
      
      public function showPayTokenConfirm(param1:String, param2:int, param3:Function, param4:String = "") : void
      {
         this.confirmationTxt = param1;
         this.tokenPrice = param2;
         this.yesCallback = param3;
         this.txt2 = param4;
         this.payConfirmType = ConfirmationDoc.PAY_CONFIRM_TOKEN;
         this.gotoAndPlay("payconfirm");
      }
      
      public function showPayGoldConfirm(param1:String, param2:int, param3:Function, param4:String = "") : void
      {
         this.goldPrice = param2;
         this.confirmationTxt = param1;
         this.yesCallback = param3;
         this.txt2 = param4;
         this.payConfirmType = ConfirmationDoc.PAY_CONFIRM_GOLD;
         this.gotoAndPlay("payconfirm");
      }
      
      public function showGuide(param1:Boolean, param2:String = null, param3:String = null, param4:String = null, param5:Function = null, param6:Function = null) : void
      {
         if(param1 && int(Central.main.getMainChar().getLevel()) <= 9)
         {
            this.islvup = param1;
            this.gotoAndStop("guide");
         }
         else
         {
            this.islvup = param1;
            this.confirmationTxt = param2;
            this.iconFrame = param3;
            this.btnName = param4;
            this.yesCallback = param5;
            this.noCallback = param6;
            this.gotoAndStop("guide");
         }
      }
      
      public function showTrainSkillConfirm(param1:String, param2:String, param3:Function, param4:Function) : void
      {
         this.confirmationTxt = param1;
         this.skill_id = param2;
         this.yesCallback = param3;
         this.noCallback = param4;
         this.gotoAndPlay("trainskillconfirm");
      }
      
      public function showGeneralNotice(param1:String, param2:String, param3:String, param4:Function) : void
      {
         this.title = param1;
         this.confirmationTxt = param2;
         this.btnTxt = param3;
         this.okCallback = param4;
         this.gotoAndPlay("generalNotice");
      }
      
      public function showMedal(param1:String) : void
      {
         this.generalTxt = param1;
         this.gotoAndStop("getMedal");
      }
      
      public function onGetMedal(param1:MovieClip) : void
      {
         this.stop();
         if(this.generalTxt == "village")
         {
            param1["noBtn"].visible = true;
            param1["noBtn"].addEventListener(MouseEvent.CLICK,this.hideMedal);
         }
         if(this.generalTxt == "panel")
         {
            param1["noBtn"].visible = false;
            param1["noBtn"].removeEventListener(MouseEvent.CLICK,this.hideMedal);
         }
         param1["titleTxt"].text = Central.main.langLib.get(1690)[0];
         param1["displayTxt"].text = Central.main.langLib.get(1690)[1];
         Central.main.initButton(this["goMc"],this.hideMedal,Central.main.langLib.get(1690)[2]);
         var _loc2_:int = int(Central.main.medalReward.length);
         param1["medalMc"].gotoAndStop("r" + _loc2_);
      }
      
      public function updateMedalMc(param1:MovieClip) : void
      {
         var _loc5_:String = null;
         var _loc7_:String = null;
         var _loc2_:MovieClip = new MovieClip();
         var _loc3_:MovieClip = new MovieClip();
         var _loc4_:MovieClip = new MovieClip();
         var _loc6_:Array = [];
         var _loc8_:int = 0;
         switch(param1.currentLabel)
         {
            case "r3":
               GF.removeAllChild(param1["rewardIcon3"]["iconHolder"]);
               _loc5_ = Central.main.medalReward[2];
               _loc6_ = _loc5_.split("_");
               _loc7_ = _loc6_[0] + _loc6_[1];
               Item.getMaterialIcon(_loc7_,_loc4_);
               param1["rewardIcon3"]["iconHolder"].addChild(_loc4_);
               if(int(_loc6_[2]) > 1)
               {
                  param1["ownTxt3"].text = "x" + _loc6_[2];
               }
               else
               {
                  param1["ownTxt3"].text = "";
               }
               _loc8_ += int(_loc6_[2]);
            case "r2":
               GF.removeAllChild(param1["rewardIcon2"]["iconHolder"]);
               _loc5_ = Central.main.medalReward[1];
               _loc6_ = _loc5_.split("_");
               _loc7_ = _loc6_[0] + _loc6_[1];
               Item.getMaterialIcon(_loc7_,_loc3_);
               param1["rewardIcon2"]["iconHolder"].addChild(_loc3_);
               if(int(_loc6_[2]) > 1)
               {
                  param1["ownTxt2"].text = "x" + _loc6_[2];
               }
               else
               {
                  param1["ownTxt2"].text = "";
               }
               _loc8_ += int(_loc6_[2]);
            case "r1":
               GF.removeAllChild(param1["rewardIcon1"]["iconHolder"]);
               _loc5_ = Central.main.medalReward[0];
               _loc6_ = _loc5_.split("_");
               _loc7_ = _loc6_[0] + _loc6_[1];
               Item.getMaterialIcon(_loc7_,_loc2_);
               param1["rewardIcon1"]["iconHolder"].addChild(_loc2_);
               if(int(_loc6_[2]) > 1)
               {
                  param1["ownTxt1"].text = "x" + _loc6_[2];
               }
               else
               {
                  param1["ownTxt1"].text = "";
               }
               _loc8_ += int(_loc6_[2]);
         }
         MovieClip(param1.parent)["goMc"].rewardAmt = _loc8_;
      }
      
      public function hideMedal(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         switch(param1.currentTarget.name)
         {
            case "goMc":
               Central.main.disableButton(MovieClip(param1.currentTarget),this.hideMedal,Central.main.langLib.get(1690)[2]);
               _loc2_ = 6;
               if(param1.currentTarget.rewardAmt)
               {
                  _loc2_ = int(param1.currentTarget.rewardAmt);
               }
               if(Central.main.account.getAccountType() == Central.main.account.PREMIUM)
               {
                  if(Central.main.getMainChar().getInventory(InventoryData.TYPE_MATERIAL).length + _loc2_ > Data.INV_SPACE_MATERIAL_PREMIUM)
                  {
                     Central.main.showInfo(String(Central.main.langLib.get(696)).replace("[valn]",_loc2_.toString()));
                     MovieClip(param1.currentTarget.parent)["noBtn"].visible = true;
                     MovieClip(param1.currentTarget.parent)["noBtn"].addEventListener(MouseEvent.CLICK,this.hideMedal);
                     return;
                  }
               }
               else if(Central.main.getMainChar().getInventory(InventoryData.TYPE_MATERIAL).length + _loc2_ > Data.INV_SPACE_MATERIAL_FREE)
               {
                  Central.main.showOk(String(Central.main.langLib.get(696)).replace("[valn]",_loc2_.toString()));
                  MovieClip(param1.currentTarget.parent)["noBtn"].visible = true;
                  MovieClip(param1.currentTarget.parent)["noBtn"].addEventListener(MouseEvent.CLICK,this.hideMedal);
                  return;
               }
               Central.main.showAmfLoading();
               Central.main.amfClient.service("AnniReward.claimOlympusDailyLogin",[Central.main.account.getAccountSessionKey()],this.addMedal);
               break;
            default:
               Central.main.proc.streamStartEvents();
               this.gotoAndStop(Timeline.IDLE);
         }
      }
      
      private function addMedal(param1:Object) : void
      {
         var _loc2_:int = 0;
         var _loc3_:String = null;
         var _loc4_:Array = null;
         var _loc5_:String = null;
         var _loc6_:int = 0;
         var _loc7_:MovieClip = null;
         Central.main.hideAmfLoading();
         if(Central.main.validateAmfResponse(param1))
         {
            Central.main.isShowMedal = false;
            _loc2_ = 0;
            while(_loc2_ < Central.main.medalReward.length)
            {
               _loc3_ = Central.main.medalReward[_loc2_];
               _loc4_ = _loc3_.split("_");
               _loc5_ = _loc4_[0] + _loc4_[1];
               _loc6_ = 0;
               while(_loc6_ < _loc4_[2])
               {
                  Central.main.getMainChar().addInventory(InventoryData.TYPE_MATERIAL,_loc5_);
                  _loc6_++;
               }
               _loc2_++;
            }
            Central.main.showInfo(Central.main.langLib.get(1690)[3]);
            this.gotoAndStop(Timeline.IDLE);
            if(this.generalTxt == "village")
            {
               Central.main.proc.streamStartEvents();
            }
            if(this.generalTxt == "panel")
            {
               _loc7_ = Central.main.getMainMc()["eventPopupHolder"].getChildAt(0);
               _loc7_.updateMedal();
            }
            Central.main.updateMenu();
         }
      }
      
      public function showHuntingPassport() : void
      {
         this.gotoAndStop("getHuntingPassport");
      }
      
      public function onGetHuntingPassport() : void
      {
         this.stop();
         this["noBtn"].addEventListener(MouseEvent.CLICK,this.hideGetHuntingPassport);
         this["titleTxt"].text = Central.main.langLib.get(1658)[12];
         if(Account.getAccountType() == Account.PREMIUM)
         {
            this["HuntingTicketTxt"].text = "x10";
            if(Central.main.getMainChar().getInventory(InventoryData.TYPE_ESSENCE).length + 10 >= Data.INV_SPACE_ESSENCE)
            {
               this["displayTxt"].text = Central.main.langLib.get(1658)[34];
               this["displayTxt"].visible = true;
               this["goMc1"].visible = true;
               this["goMc"].visible = false;
               Central.main.initButton(this["goMc1"],this.hideGetHuntingPassport,ButtonData.CLAIM);
            }
            else
            {
               this["displayTxt"].visible = false;
               this["goMc"].visible = true;
               this["goMc1"].visible = false;
               Central.main.initButton(this["goMc"],this.hideGetHuntingPassport,ButtonData.CLAIM);
            }
         }
         else
         {
            this["HuntingTicketTxt"].text = "x5";
            if(Central.main.getMainChar().getInventory(InventoryData.TYPE_ESSENCE).length + 5 >= Data.INV_SPACE_ESSENCE)
            {
               this["displayTxt"].text = Central.main.langLib.get(1658)[34];
               this["displayTxt"].visible = true;
               this["goMc1"].visible = true;
               this["goMc"].visible = false;
               Central.main.initButton(this["goMc1"],this.hideGetHuntingPassport,ButtonData.CLAIM);
            }
            else
            {
               this["displayTxt"].visible = false;
               this["goMc"].visible = true;
               this["goMc1"].visible = false;
               Central.main.initButton(this["goMc"],this.hideGetHuntingPassport,ButtonData.CLAIM);
            }
         }
      }
      
      private function hideGetHuntingPassport(param1:MouseEvent) : void
      {
         switch(param1.currentTarget.name)
         {
            case "goMc":
            case "goMc1":
               Central.main.showAmfLoading();
               Central.main.amfClient.service("ItemDAO.getDailyHuntingPassport",[Central.main.account.getAccountSessionKey()],this.getHuntingPassport);
               break;
            default:
               this.gotoAndStop(Timeline.IDLE);
         }
      }
      
      private function getHuntingPassport(param1:Object) : void
      {
         var _loc2_:MovieClip = null;
         var _loc3_:int = 0;
         Central.main.hideAmfLoading();
         if(Central.main.validateAmfResponse(param1))
         {
            this.gotoAndStop(Timeline.IDLE);
            _loc2_ = Central.panel.getInstance().curPanel;
            _loc3_ = 0;
            while(_loc3_ < param1.reward)
            {
               Central.main.getMainChar().addInventory(InventoryData.TYPE_ESSENCE,"item509");
               _loc3_++;
            }
            Central.main.GetHuntingPassport = false;
            _loc2_.updateGoldDisplay();
         }
      }
      
      private function disableButton(param1:*, param2:Function, param3:String = null) : void
      {
         var btn:* = param1;
         var fn:Function = param2;
         var txt:String = param3;
         btn.stop();
         btn["clickMask"].buttonMode = false;
         btn.gotoAndStop(1);
         if(btn.hasEventListener(MouseEvent.MOUSE_OUT))
         {
            btn.removeEventListener(MouseEvent.MOUSE_OUT,function(param1:MouseEvent):*
            {
               param1.currentTarget.gotoAndStop(1);
            });
         }
         btn.addEventListener(MouseEvent.MOUSE_OUT,function(param1:MouseEvent):*
         {
            param1.currentTarget.gotoAndStop(1);
         });
         if(btn.hasEventListener(MouseEvent.MOUSE_OVER))
         {
            btn.removeEventListener(MouseEvent.MOUSE_OVER,function(param1:MouseEvent):*
            {
               param1.currentTarget.gotoAndStop(2);
            });
         }
         btn.addEventListener(MouseEvent.MOUSE_OVER,function(param1:MouseEvent):*
         {
            param1.currentTarget.gotoAndStop(1);
         });
         if(btn.hasEventListener(MouseEvent.CLICK))
         {
            btn.removeEventListener(MouseEvent.CLICK,fn);
         }
         if(txt != null && txt != "")
         {
            btn["txt"].text = Central.main.langLib.btnTxt(txt);
         }
         btn.filters = [this.dimFilter];
      }
      
      public function showEventDailyLoginGift(param1:String, param2:DailyLoginEventData) : void
      {
         this.LocationTxt = param1;
         this.DailyLoginDescription = param2.dailyLoginLang;
         this.DailyLoginGift = param2.dailyLoginGift;
         this.ShowHideDailyLogin = param2.dailyLoginHideBtn;
         this.ServerFunction = param2.dailyLoginServerFunction;
         this.DailyLoginLoadPanelPath = param2.dailyLoginLoadPanelPath;
         this.gotoAndStop(param2.dailyLoginPanelLabel);
      }
      
      public function onShowAnni4DailyLoginGift(param1:MovieClip) : void
      {
         this.stop();
         if(this.ShowHideDailyLogin)
         {
            param1["closeBtn"].visible = true;
            param1["closeBtn"].addEventListener(MouseEvent.CLICK,this.hideEventDailyLoginGift);
         }
         else
         {
            param1["closeBtn"].visible = false;
            param1["closeBtn"].removeEventListener(MouseEvent.CLICK,this.hideEventDailyLoginGift);
         }
         param1["titleTxt"].text = this.DailyLoginDescription[10];
         param1["subTitleTxt"].text = this.DailyLoginDescription[1];
         this["claimBtn"].visible = true;
         Central.main.initButton(this["claimBtn"],this.hideEventDailyLoginGift,ButtonData.CLAIM);
         var _loc2_:int = int(Central.main.getMainChar().getGender());
         param1["hairIcon"].gotoAndStop(_loc2_ + 1);
      }
      
      public function onShowEventDailyLoginGift(param1:MovieClip) : void
      {
         this.stop();
         if(this.ShowHideDailyLogin)
         {
            param1["closeBtn"].visible = true;
            param1["closeBtn"].addEventListener(MouseEvent.CLICK,this.hideEventGiftBag);
         }
         else
         {
            param1["closeBtn"].visible = false;
            param1["closeBtn"].removeEventListener(MouseEvent.CLICK,this.hideEventGiftBag);
         }
         param1["titleTxt"].text = this.DailyLoginDescription[0];
         this["claimBtn"].visible = true;
         this["refuseBtn"].visible = false;
         Central.main.initButton(this["claimBtn"],this.hideEventDailyLoginGift,ButtonData.CLAIM);
         var _loc2_:int = int(this.DailyLoginGift.length);
         param1["dailyLoginGiftMc"].gotoAndStop("num_" + _loc2_);
      }
      
      public function hideEventDailyLoginGift(param1:MouseEvent) : void
      {
         switch(param1.currentTarget.name)
         {
            case "claimBtn":
               Central.main.disableButton(MovieClip(param1.currentTarget),this.hideEventDailyLoginGift,ButtonData.CLAIM);
               Central.main.showAmfLoading();
               Central.main.amfClient.service(this.ServerFunction,[Central.main.account.getAccountSessionKey()],this.eventDailyLoginGiftResponse);
               break;
            default:
               this.gotoAndStop(Timeline.IDLE);
         }
      }
      
      private function checkItemFull() : Boolean
      {
         var _loc8_:Object = null;
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc9_:Array = [];
         _loc1_ = 0;
         while(_loc1_ < this.DailyLoginGift.length)
         {
            _loc9_ = String(this.DailyLoginGift[_loc1_]).split("_");
            if(String(this.DailyLoginGift[_loc1_]).indexOf("wpn") >= 0)
            {
               if(_loc9_.length > 2)
               {
                  _loc2_ += Number(_loc9_[2]);
               }
               else
               {
                  _loc2_++;
               }
            }
            if(String(this.DailyLoginGift[_loc1_]).indexOf("back") >= 0)
            {
               if(_loc9_.length > 2)
               {
                  _loc3_ += Number(_loc9_[2]);
               }
               else
               {
                  _loc3_++;
               }
            }
            if(String(this.DailyLoginGift[_loc1_]).indexOf("set") >= 0)
            {
               _loc4_++;
            }
            if(String(this.DailyLoginGift[_loc1_]).indexOf("item") >= 0)
            {
               if(Central.main.ITEM_DATA.find(Central.main.itemPrototype(String(this.DailyLoginGift[_loc1_]))))
               {
                  if(_loc9_.length > 2)
                  {
                     _loc7_ += Number(_loc9_[2]);
                  }
                  else
                  {
                     _loc7_++;
                  }
               }
               else if(Central.main.ESSENCE_DATA.find(Central.main.itemPrototype(String(this.DailyLoginGift[_loc1_]))))
               {
                  if(_loc9_.length > 2)
                  {
                     _loc5_ += Number(_loc9_[2]);
                  }
                  else
                  {
                     _loc5_++;
                  }
               }
               else if(Central.main.MATERIAL_DATA.find(Central.main.itemPrototype(String(this.DailyLoginGift[_loc1_]))))
               {
                  if(_loc9_.length > 2)
                  {
                     _loc6_ += Number(_loc9_[2]);
                  }
                  else
                  {
                     _loc6_++;
                  }
               }
            }
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < this.DailyLoginGift.length)
         {
            if(String(this.DailyLoginGift[_loc1_]).indexOf("wpn") >= 0)
            {
               if(Central.main.getMainChar().getInventory(InventoryData.TYPE_WEAPON).length + _loc2_ > Data.INV_SPACE_WEAPON)
               {
                  this.DailyLoginWarmingDescription = this.DailyLoginDescription[5];
                  return true;
               }
            }
            if(String(this.DailyLoginGift[_loc1_]).indexOf("back") >= 0)
            {
               if(Central.main.getMainChar().getBackItem() != "")
               {
                  if(Central.main.getMainChar().getInventory(InventoryData.TYPE_BACK_ITEM).length + _loc3_ > Data.INV_SPACE_BACKITEM)
                  {
                     this.DailyLoginWarmingDescription = this.DailyLoginDescription[7];
                     return true;
                  }
               }
               else if(Central.main.getMainChar().getInventory(InventoryData.TYPE_BACK_ITEM).length + _loc3_ + 1 > Data.INV_SPACE_BACKITEM)
               {
                  this.DailyLoginWarmingDescription = this.DailyLoginDescription[7];
                  return true;
               }
            }
            if(String(this.DailyLoginGift[_loc1_]).indexOf("set") >= 0)
            {
               if(Central.main.getMainChar().getInventory(InventoryData.TYPE_BODY_SET).length + _loc4_ > Data.INV_SPACE_BODYSET)
               {
                  this.DailyLoginWarmingDescription = this.DailyLoginDescription[6];
                  return true;
               }
            }
            if(String(this.DailyLoginGift[_loc1_]).indexOf("item") >= 0)
            {
               if(Central.main.ITEM_DATA.find(Central.main.itemPrototype(String(this.DailyLoginGift[_loc1_]))))
               {
                  if(Account.getAccountType() == Account.FREE)
                  {
                     if(Central.main.getMainChar().getInventory(InventoryData.TYPE_ITEM).length + _loc7_ > Data.INV_SPACE_FREE)
                     {
                        this.DailyLoginWarmingDescription = this.DailyLoginDescription[8];
                        return true;
                     }
                  }
                  else if(Central.main.getMainChar().getInventory(InventoryData.TYPE_ITEM).length + _loc7_ > Data.INV_SPACE_PREMIUM)
                  {
                     this.DailyLoginWarmingDescription = this.DailyLoginDescription[8];
                     return true;
                  }
               }
               else if(Central.main.ESSENCE_DATA.find(Central.main.itemPrototype(String(this.DailyLoginGift[_loc1_]))))
               {
                  if(Central.main.getMainChar().getInventory(InventoryData.TYPE_ESSENCE).length + _loc5_ > Data.INV_SPACE_ESSENCE)
                  {
                     this.DailyLoginWarmingDescription = this.DailyLoginDescription[9];
                     return true;
                  }
               }
               else if(Central.main.MATERIAL_DATA.find(Central.main.itemPrototype(String(this.DailyLoginGift[_loc1_]))))
               {
                  if(Account.getAccountType() == Account.FREE)
                  {
                     if(Central.main.getMainChar().getInventory(InventoryData.TYPE_MATERIAL).length + _loc6_ > Data.INV_SPACE_MATERIAL_FREE)
                     {
                        this.DailyLoginWarmingDescription = this.DailyLoginDescription[4];
                        return true;
                     }
                  }
                  else if(Central.main.getMainChar().getInventory(InventoryData.TYPE_MATERIAL).length + _loc6_ > Data.INV_SPACE_MATERIAL_PREMIUM)
                  {
                     this.DailyLoginWarmingDescription = this.DailyLoginDescription[4];
                     return true;
                  }
               }
            }
            _loc1_++;
         }
         return false;
      }
      
      public function updateDailyLoginGiftMc(param1:MovieClip) : void
      {
         var _loc4_:Object = null;
         var _loc2_:int = 0;
         var _loc3_:Array = [];
         _loc2_ = 0;
         while(_loc2_ < this.DailyLoginGift.length)
         {
            GF.removeAllChild(param1["IconMC" + _loc2_]["skillIcon"]["iconHolder"]);
            GF.removeAllChild(param1["IconMC" + _loc2_]["rewardIcon"]["iconHolder"]);
            _loc3_ = this.DailyLoginGift[_loc2_].split("_");
            _loc4_ = Central.main.toolkit.getDisplayData(String(_loc3_[0] + _loc3_[1]));
            if(String(_loc3_[0]).indexOf("skill") >= 0)
            {
               param1["IconMC" + _loc2_]["skillIcon"].visible = true;
               param1["IconMC" + _loc2_]["rewardIcon"].visible = false;
               param1["IconMC" + _loc2_]["amountTxt"].visible = false;
               param1["IconMC" + _loc2_]["skillIcon"]["iconHolder"].addChild(_loc4_.mc);
            }
            else
            {
               param1["IconMC" + _loc2_]["rewardIcon"].visible = true;
               param1["IconMC" + _loc2_]["skillIcon"].visible = false;
               param1["IconMC" + _loc2_]["amountTxt"].visible = false;
               param1["IconMC" + _loc2_]["rewardIcon"]["iconHolder"].addChild(_loc4_.mc);
               if(_loc3_.length > 2 && int(_loc3_[2]) > 1)
               {
                  _loc4_.amount = Number(_loc3_[2]);
                  param1["IconMC" + _loc2_]["amountTxt"].visible = true;
                  param1["IconMC" + _loc2_]["amountTxt"].text = "x" + _loc4_.amount;
               }
            }
            Central.main.showDynamicTooltip(param1["IconMC" + _loc2_],String("<font size=\'16\'>" + _loc4_.tooltip + "</font>"));
            _loc2_++;
         }
      }
      
      private function eventDailyLoginGiftResponse(param1:Object) : void
      {
         var _loc4_:Object = null;
         var _loc2_:int = 0;
         var _loc3_:Array = [];
         Central.main.hideAmfLoading();
         if(Central.main.validateAmfResponse(param1))
         {
            Central.main.DailyLoginEvent = false;
            _loc2_ = 0;
            while(_loc2_ < this.DailyLoginGift.length)
            {
               _loc3_ = this.DailyLoginGift[_loc2_].split("_");
               _loc4_ = Central.main.toolkit.getDisplayData(String(_loc3_[0] + _loc3_[1]));
               if(_loc3_.length > 2 && int(_loc3_[2]) > 1)
               {
                  _loc4_.amount = Number(_loc3_[2]);
               }
               Central.main.toolkit.DisplayDataAddInventory(_loc4_);
               _loc2_++;
            }
            this.gotoAndStop(Timeline.IDLE);
            Central.main.updateMenu();
            if(this.LocationTxt == "panel" && this.DailyLoginLoadPanelPath != "")
            {
               Central.panel.getInstance().show(this.DailyLoginLoadPanelPath);
            }
            else
            {
               Central.main.proc.streamStartEvents();
            }
         }
      }
      
      private function onShowGetEnemyHp(param1:MovieClip) : void
      {
         var i:int;
         var j:int;
         var hp:String = null;
         var dotPos:int = 0;
         var mc:MovieClip = param1;
         mc = mc["panel"];
         this.stop();
         i = 0;
         while(i < Central.battle.enemyArr.length)
         {
            mc["enemyMc_" + i].visible = true;
            mc["enemy_arrow_" + i].visible = true;
            mc["enemyMc_" + i]["detail_box"]["txt_hp_detail"].text = Central.battle.enemyArr[i].hp + " / " + Central.battle.enemyArr[i].maxHP;
            hp = String(Central.battle.enemyArr[i].hp * 100 / Central.battle.enemyArr[i].maxHP);
            dotPos = hp.indexOf(".");
            if(dotPos > 0)
            {
               hp = hp.substr(0,dotPos + 2);
            }
            mc["enemyMc_" + i]["detail_box"]["txt_hp_percent"].text = hp + " %";
            mc["enemyMc_" + i]["detail_box"]["btnClose"].addEventListener(MouseEvent.CLICK,function():*
            {
               gotoAndStop(Timeline.IDLE);
               if(okCallback != null)
               {
                  okCallback();
               }
            });
            i++;
         }
         j = int(Central.battle.enemyArr.length);
         while(j < 3)
         {
            mc["enemyMc_" + j].visible = false;
            mc["enemy_arrow_" + j].visible = false;
            j++;
         }
      }
      
      private function onShowPopup(param1:MovieClip) : *
      {
         this.stop();
         if(this.popupTitleTxt != null)
         {
            param1["titleTxt"].text = this.popupTitleTxt;
         }
         else
         {
            param1["titleTxt"].visible = false;
         }
         if(this.popupMsgTxt != null)
         {
            param1["detailTxt"].text = this.popupMsgTxt;
         }
         else
         {
            param1["detailTxt"].visible = false;
         }
         if(this.okCallback1 != null && this.okCallback2 != null)
         {
            param1["confirmBtn"].visible = false;
            Central.main.initButton(param1["joinBtn"],this.okCallback1,Central.main.langLib.get(1776)[3]);
            Central.main.initButton(param1["shareBtn"],this.okCallback2,Central.main.langLib.get(1776)[4]);
            Central.main.disableButton(param1["confirmBtn"],this.okCallback1,Central.main.langLib.get(1776)[2]);
         }
         else
         {
            param1["joinBtn"].visible = false;
            param1["joinBtn"].visible = false;
            Central.main.disableButton(param1["joinBtn"],this.okCallback1,Central.main.langLib.get(1776)[3]);
            Central.main.disableButton(param1["shareBtn"],this.okCallback1,Central.main.langLib.get(1776)[4]);
            if(this.okCallback1 != null)
            {
               Central.main.initButton(param1["confirmBtn"],this.okCallback1,Central.main.langLib.get(1776)[2]);
            }
            else
            {
               Central.main.initButton(param1["confirmBtn"],this.okCallback2,Central.main.langLib.get(1776)[2]);
            }
         }
         param1["closeBtn"].addEventListener(MouseEvent.CLICK,this.hideFanPagePopup);
      }
      
      public function onShowPopupSpecialHpBar(param1:MovieClip = null) : void
      {
         var _loc2_:Array = null;
         var _loc3_:MovieClip = null;
         var _loc4_:Object = null;
         this.stop();
         if(this.specialHpData.display == true)
         {
            this["catchableTxt"].text = this.specialHpData.textCatch;
            this["rangeTxt"].text = "";
            this["hpTxt"].text = "";
            _loc2_ = this.specialHpData.textButton.split("_");
            switch(Central.main.battleModeSelected)
            {
               case "difficult":
                  this["captureBtn"].visible = false;
                  this["redHpBarMc"].visible = false;
                  this["greenHpBarMc"].visible = false;
                  this["glowBgMc"].visible = false;
                  this["normalBgMc"].visible = false;
                  this["heartMc"].visible = false;
                  this["hpShadowMc"].visible = false;
                  this["dragonIconMc"].visible = false;
                  break;
               case "normal":
                  this["captureBtn"].visible = true;
                  this["redHpBarMc"].visible = true;
                  this["greenHpBarMc"].visible = true;
                  this["heartMc"].visible = true;
                  this["hpShadowMc"].visible = true;
                  this["dragonIconMc"].visible = true;
                  this["dragonIconMc"].gotoAndStop(Central.battle.bossId);
                  this["captureBtn"].btnName = "catch";
                  if(this.specialHpData.canClick)
                  {
                     this["captureBtn"].filters = null;
                     Central.main.initButton(this["captureBtn"],this.updatePopupSpecialHpBar,_loc2_[0]);
                  }
                  else
                  {
                     this["captureBtn"].filters = [this.dimFilter];
                     Central.main.disableButton(this["captureBtn"],this.updatePopupSpecialHpBar,_loc2_[0]);
                  }
                  this["redHpBarMc"].x = this["greenHpBarMc"].x + this["greenHpBarMc"].width * (Central.main.battleRuleArr[0].amount_over * 0.01);
                  this["redHpBarMc"].scaleX = (Central.main.battleRuleArr[0].amount_less - Central.main.battleRuleArr[0].amount_over) * 0.01;
                  this["glowBgMc"].visible = false;
                  this["normalBgMc"].visible = true;
                  break;
               case "easy":
                  this["captureBtn"].visible = true;
                  this["redHpBarMc"].visible = true;
                  this["greenHpBarMc"].visible = true;
                  this["heartMc"].visible = true;
                  this["hpShadowMc"].visible = true;
                  this["dragonIconMc"].visible = true;
                  this["dragonIconMc"].gotoAndStop(Central.battle.bossId);
                  this["captureBtn"].btnName = "catch";
                  if(this.specialHpData.canClick)
                  {
                     this["captureBtn"].filters = null;
                     if(this.specialHpData.showGlowBackground == true)
                     {
                        Central.main.initButton(this["captureBtn"],this.updatePopupSpecialHpBar,_loc2_[1]);
                        this["normalBgMc"].visible = false;
                        this["glowBgMc"].visible = true;
                     }
                     else
                     {
                        Central.main.initButton(this["captureBtn"],this.updatePopupSpecialHpBar,_loc2_[0]);
                        this["glowBgMc"].visible = false;
                        this["normalBgMc"].visible = true;
                     }
                  }
                  else
                  {
                     this["captureBtn"].filters = [this.dimFilter];
                     if(this.specialHpData.showGlowBackground == true)
                     {
                        Central.main.initButton(this["captureBtn"],this.updatePopupSpecialHpBar,_loc2_[1]);
                        this["normalBgMc"].visible = false;
                        this["glowBgMc"].visible = true;
                     }
                     else
                     {
                        Central.main.initButton(this["captureBtn"],this.updatePopupSpecialHpBar,_loc2_[0]);
                        this["glowBgMc"].visible = false;
                        this["normalBgMc"].visible = true;
                     }
                  }
                  this["redHpBarMc"].x = this["greenHpBarMc"].x + this["greenHpBarMc"].width * (Central.main.battleRuleArr[0].amount_over * 0.01);
                  this["redHpBarMc"].scaleX = (Central.main.battleRuleArr[0].amount_less - Central.main.battleRuleArr[0].amount_over) * 0.01;
            }
            this["maskMc"].visible = this.specialHpData.showConfirm;
            this["confirmUseScrollMc"].visible = this.specialHpData.showConfirm;
            if(this.specialHpData.showConfirm)
            {
               _loc3_ = this["confirmUseScrollMc"];
               _loc4_ = Central.main.toolkit.getDisplayData(this.specialHpData.itemId);
               _loc3_["btnClose"].addEventListener(MouseEvent.CLICK,this.updatePopupSpecialHpBar);
               if(Central.main.getItemAmount(this.specialHpData.itemId) > 0)
               {
                  _loc3_["titleTxt"].text = this.specialHpData.textShowConfirmDetailUse;
                  _loc3_["useBtn"].visible = true;
                  _loc3_["buybtn"].visible = false;
                  _loc3_["useBtn"].btnName = "use";
                  Central.main.initButton(_loc3_["useBtn"],this.updatePopupSpecialHpBar,this.specialHpData.textShowConfirm);
               }
               else
               {
                  _loc3_["titleTxt"].text = this.specialHpData.textShowConfirmDetailBuy;
                  _loc3_["useBtn"].visible = false;
                  _loc3_["buybtn"].visible = true;
                  _loc3_["buybtn"].btnName = "buy";
                  if(Account.getAccountBalance() < _loc4_.itemData.crystal * this.specialHpData.specialRate)
                  {
                     _loc3_["buybtn"].filters = [this.dimFilter];
                     Central.main.disableButton(_loc3_["buybtn"],this.updatePopupSpecialHpBar,String(_loc4_.itemData.crystal * this.specialHpData.specialRate));
                  }
                  else
                  {
                     _loc3_["buybtn"].filters = null;
                     Central.main.initButton(_loc3_["buybtn"],this.updatePopupSpecialHpBar,String(_loc4_.itemData.crystal * this.specialHpData.specialRate));
                  }
               }
               GF.removeAllChild(_loc3_["iconMc"]["rewardIcon"]["iconHolder"]);
               _loc3_["iconMc"]["skillIcon"].visible = false;
               _loc3_["iconMc"]["rewardIcon"]["iconHolder"].addChild(_loc4_.mc);
               Central.main.showDynamicTooltip(_loc3_["iconMc"],String("<font size=\'16\'>" + _loc4_.tooltip + "</font>"));
            }
         }
      }
      
      private function updatePopupSpecialHpBar(param1:MouseEvent = null) : void
      {
         var _loc2_:Object = null;
         var _loc3_:uint = 0;
         if(param1)
         {
            if(param1.currentTarget.name == "btnClose")
            {
               this.specialHpData.showConfirm = false;
               this.onShowPopupSpecialHpBar();
            }
            else
            {
               switch(param1.currentTarget.btnName)
               {
                  case "use":
                     this.specialHpData.showConfirm = false;
                     Central.main.getMainMc()["battleMc"]["actionBar"].hide();
                     this.hidePopupSpecialHpBar();
                     Central.main.getMainChar().removeInventory(InventoryData.TYPE_ITEM,this.specialHpData.itemId);
                     Central.main.amfClient.service("EasterFestival.sendBattleEvent",[Central.main.account.getAccountSessionKey(),"774",Central.main.getHash(String(Central.main.account.getAccountSessionKey() + ",774"))],this.confirmBuySealReel);
                     break;
                  case "buy":
                     this.specialHpData.showConfirm = false;
                     _loc2_ = Central.main.toolkit.getDisplayData(this.specialHpData.itemId);
                     _loc3_ = _loc2_.itemData.crystal * this.specialHpData.specialRate;
                     Out.debug("rockman","use token");
                     if(Central.main.account.getAccountBalance() < _loc3_)
                     {
                        Central.main.showInfo(Central.main.langLib.get(166));
                        return;
                     }
                     Central.main.getMainMc()["battleMc"]["actionBar"].hide();
                     Central.main.checkUseTokenInsteadItem = true;
                     Central.main.account.balance = Central.main.account.getAccountBalance() - _loc3_;
                     Central.main.updateMenu();
                     this.hidePopupSpecialHpBar();
                     Central.main.amfClient.service("CharacterDAO.payMinigame",[Central.main.account.getAccountSessionKey(),774],this.confirmBuySealReel);
                     break;
                  case "catch":
                     this.specialHpData.showConfirm = true;
                     this.onShowPopupSpecialHpBar();
               }
            }
            return;
         }
         this.onShowPopupSpecialHpBar();
      }
      
      private function confirmBuySealReel(param1:Object) : void
      {
         if(Central.main.validateAmfResponse(param1))
         {
            Central.main.checkUseTokenInsteadItem = true;
            Central.battle.useItem(this.specialHpData.itemId);
         }
         else
         {
            Central.main.onError("1","");
         }
      }
      
      public function hidePopupSpecialHpBar(param1:MovieClip = null) : void
      {
         gotoAndStop(Timeline.IDLE);
      }
      
      private function onShowPopupSealFail(param1:MovieClip) : *
      {
         this.stop();
         if(this.popupTitleTxt != null)
         {
            param1["titleTxt"].text = this.popupTitleTxt;
         }
         else
         {
            param1["titleTxt"].visible = false;
         }
         if(this.popupMsgTxt != null)
         {
            param1["detailTxt"].text = this.popupMsgTxt;
         }
         else
         {
            param1["detailTxt"].visible = false;
         }
         param1["btnClose"].addEventListener(MouseEvent.CLICK,this.hidePopupSealFail);
      }
      
      private function hidePopupSealFail(param1:MouseEvent) : void
      {
         gotoAndStop(Timeline.IDLE);
         if(this.okCallback1 != null)
         {
            this.okCallback1();
         }
      }
      
      private function hideFanPagePopup(param1:MouseEvent) : void
      {
         this.gotoAndStop(Timeline.IDLE);
         Central.main.proc.streamStartEvents();
      }
      
      private function gotoFanPage(param1:MouseEvent) : void
      {
         this.gotoAndStop(Timeline.IDLE);
         var _loc2_:String = "";
         switch(AppData.lang)
         {
            case AppData.ZH:
               _loc2_ = "http://www.ninjasaga.com/event_lucky_draw/?lang=zh";
               break;
            default:
               _loc2_ = "http://www.ninjasaga.com/event_lucky_draw/?lang=en";
         }
         Central.main.gotoURL(_loc2_,"_blank");
         Central.main.proc.streamStartEvents();
      }
      
      private function checkDynamicTooltip(param1:Event) : void
      {
         var _loc2_:Array = null;
         var _loc3_:Boolean = false;
         var _loc4_:* = undefined;
         if(this["dynamicTip"]["dynamicTxt"].visible)
         {
            _loc2_ = stage.getObjectsUnderPoint(new Point(this.mouseX,this.mouseY));
            _loc3_ = true;
            loop0:
            for each(_loc4_ in _loc2_)
            {
               do
               {
                  if(!_loc4_.parent)
                  {
                     continue loop0;
                  }
               }
               while(_loc4_ = _loc4_.parent, !(Boolean(_loc4_.hasEventListener) && Boolean(_loc4_.hasEventListener(MouseEvent.ROLL_OVER))));
               _loc3_ = false;
            }
            if(_loc3_)
            {
               this.hideTooltip();
            }
         }
      }
      
      public function showDynamicTooltip(param1:MovieClip, param2:String, param3:Boolean = false) : void
      {
         this.fullHeight = param3;
         this["dynamicTip"]["dynamicTxt"].autoSize = TextFieldAutoSize.LEFT;
         this["dynamicTip"]["dynamicTxt"].selectable = false;
         this["dynamicTip"]["dynamicTxt"].multiline = true;
         this["dynamicTip"]["dynamicTxt"].wordWrap = true;
         this["dynamicTip"]["dynamicTxt"].defaultTextFormat = new TextFormat("Tahoma",18,6710886);
         this["dynamicTip"]["dynamicTxt"].width = 300;
         this["dynamicTip"]["dynamicTxt"].visible = false;
         param1.customMsg = param2;
         this["dynamicTip"]["dynamicTxt"].htmlText = param1.customMsg;
         param1.addEventListener(MouseEvent.ROLL_OVER,this.handler);
         param1.addEventListener(MouseEvent.MOUSE_MOVE,this.handler);
         param1.addEventListener(MouseEvent.ROLL_OUT,this.handler);
         param1.addEventListener(MouseEvent.MOUSE_DOWN,this.handler);
         param1.addEventListener(MouseEvent.MOUSE_UP,this.handler);
      }
      
      public function hideDynamicTooltip(param1:MovieClip) : void
      {
         this.hideTooltip();
         this["dynamicTip"]["dynamicTxt"].htmlText = "";
         param1.customMsg = null;
         if(param1.hasEventListener(MouseEvent.ROLL_OVER))
         {
            param1.removeEventListener(MouseEvent.MOUSE_OVER,this.handler);
            param1.removeEventListener(MouseEvent.ROLL_OVER,this.handler);
         }
         if(param1.hasEventListener(MouseEvent.MOUSE_MOVE))
         {
            param1.removeEventListener(MouseEvent.MOUSE_MOVE,this.handler);
         }
         if(param1.hasEventListener(MouseEvent.ROLL_OUT))
         {
            param1.removeEventListener(MouseEvent.MOUSE_OUT,this.handler);
            param1.removeEventListener(MouseEvent.ROLL_OUT,this.handler);
         }
         if(param1.hasEventListener(MouseEvent.MOUSE_DOWN))
         {
            param1.removeEventListener(MouseEvent.MOUSE_DOWN,this.handler);
         }
         if(param1.hasEventListener(MouseEvent.MOUSE_UP))
         {
            param1.removeEventListener(MouseEvent.MOUSE_UP,this.handler);
         }
      }
      
      private function handler(param1:MouseEvent) : void
      {
         var _loc2_:Array = stage.getObjectsUnderPoint(new Point(stage.mouseX,stage.mouseY));
         var _loc3_:Array = [];
         var _loc4_:int = 0;
         while(_loc4_ < _loc2_.length)
         {
            if(_loc2_[_loc4_].name)
            {
               _loc3_.push(_loc2_[_loc4_].name);
            }
            else
            {
               _loc3_.push(_loc2_[_loc4_]);
            }
            _loc4_++;
         }
         this["dynamicTip"]["dynamicTxt"].width = 300;
         this["dynamicTip"]["dynamicTxt"].htmlText = param1.currentTarget.customMsg;
         switch(param1.type)
         {
            case MouseEvent.ROLL_OUT:
               this.hideTooltip();
               break;
            case MouseEvent.MOUSE_MOVE:
               this.show(param1.currentTarget,this.movePoint(new Point(this.mouseX,this.mouseY)));
               break;
            case MouseEvent.ROLL_OVER:
               this.show(param1.currentTarget,this.movePoint(new Point(this.mouseX,this.mouseY)));
               break;
            case MouseEvent.MOUSE_DOWN:
               this.hideTooltip();
               break;
            case MouseEvent.MOUSE_UP:
               this.hideTooltip();
         }
      }
      
      private function movePoint(param1:Point) : Point
      {
         var _loc2_:Number = 15 + this["dynamicTip"]["dynamicTxt"].textWidth;
         var _loc3_:Number = 6 + this["dynamicTip"]["dynamicTxt"].height;
         var _loc4_:Number = (this.fullHeight ? Data.GAME_HEIGTH_FULL : Data.GAME_HEIGTH) - this.yOffset - _loc3_ / 2;
         if(param1.x > Data.GAME_WIDTH - this.xOffset - _loc2_)
         {
            param1.x = param1.x - Math.abs(this.xOffset) * 2 - _loc2_;
         }
         if(param1.x < 0)
         {
            param1.x = 0;
         }
         param1.y -= _loc3_ * 0.5;
         if(param1.y > _loc4_)
         {
            param1.y = _loc4_;
         }
         if(param1.y < 0)
         {
            param1.y = 0;
         }
         return param1;
      }
      
      public function show(param1:*, param2:Point) : void
      {
         if(this["dynamicTip"]["dynamicTxt"].text.length > 20)
         {
            this["dynamicTip"]["dynamicTxt"].width = this["dynamicTip"]["dynamicTxt"].textWidth;
         }
         this["dynamicTip"]["dynamicTxt"].x = param2.x + this.xOffset + 4;
         this["dynamicTip"]["dynamicTxt"].y = param2.y + this.yOffset + 3;
         this["dynamicTip"]["dynamicTxt"].visible = true;
         this.redraw(param2);
      }
      
      public function hideTooltip() : void
      {
         this["dynamicTip"]["dynamicTxt"].visible = false;
         this["dynamicTip"].graphics.clear();
      }
      
      private function redraw(param1:Point) : *
      {
         var _loc2_:Number = 15 + this["dynamicTip"]["dynamicTxt"].textWidth;
         var _loc3_:Number = 6 + this["dynamicTip"]["dynamicTxt"].height;
         this["dynamicTip"].graphics.clear();
         this["dynamicTip"].graphics.beginFill(0,0.4);
         this["dynamicTip"].graphics.drawRoundRect(param1.x + this.xOffset + 3,param1.y + this.yOffset + 3,_loc2_,_loc3_,5,5);
         this["dynamicTip"].graphics.moveTo(6 + this.xOffset,3 + this.yOffset + _loc3_);
         this["dynamicTip"].graphics.endFill();
         this["dynamicTip"].graphics.beginFill(16777215);
         this["dynamicTip"].graphics.drawRoundRect(param1.x + this.xOffset,param1.y + this.yOffset,_loc2_,_loc3_,5,5);
         this["dynamicTip"].graphics.moveTo(3 + this.xOffset,this.yOffset + _loc3_);
         this["dynamicTip"].graphics.endFill();
      }
      
      public function showGetReward(param1:Array) : void
      {
         this.getRewardArr = param1;
         this.gotoAndStop("Get_Reward");
      }
      
      public function onShowGetReward(param1:MovieClip) : void
      {
         var _loc2_:Array = null;
         var _loc5_:Array = null;
         this["titleTxt"].text = AppData.lang == AppData.ZH ? "獲得物品" : (AppData.lang == AppData.EN ? "Rewards Get" : "Rewards Get");
         Central.main.initButton(this["claimBtn"],this.hideGetReward,ButtonData.OK);
         var _loc3_:int = 6;
         if(this.getRewardArr.length > _loc3_)
         {
            _loc2_ = this.getRewardArr.splice(0,_loc3_);
         }
         else
         {
            _loc2_ = this.getRewardArr.splice(0,this.getRewardArr.length);
         }
         this["dailyLoginGiftMc"].gotoAndStop("num_" + _loc2_.length);
         var _loc4_:int = 0;
         while(_loc4_ < _loc2_.length)
         {
            _loc5_ = _loc2_[_loc4_].split("_");
            Central.main.showIconData(this["dailyLoginGiftMc"]["IconMC" + _loc4_],_loc5_[0],_loc5_[1] ? _loc5_[1] : "1");
            _loc4_++;
         }
      }
      
      public function hideGetReward(param1:MouseEvent) : void
      {
         if(this.getRewardArr.length > 0)
         {
            this.onShowGetReward(this);
            return;
         }
         this.gotoAndStop(Timeline.IDLE);
      }
      
      public function showEventGiftBag(param1:Object) : void
      {
         this.GiftBagDescription = Central.main.langLib.get(param1.lang_index);
         this.GiftBagGift = param1.reward;
         this.ShowHideGiftBag = param1.canClose;
         this.ServerFunction = param1.server_func;
         this.EventTap = param1;
         this.gotoAndStop(param1.panel_label);
      }
      
      public function onShowEventGiftBag(param1:MovieClip) : void
      {
         this.stop();
         if(this.ShowHideGiftBag)
         {
            param1["closeBtn"].visible = true;
            param1["closeBtn"].addEventListener(MouseEvent.CLICK,this.hideEventGiftBag);
         }
         else
         {
            param1["closeBtn"].visible = false;
            param1["closeBtn"].removeEventListener(MouseEvent.CLICK,this.hideEventGiftBag);
         }
         param1["titleTxt"].text = this.GiftBagDescription[0];
         if(this.checkEventGiftBagItemFull())
         {
            this["closeBtn"].visible = true;
            this["closeBtn"].addEventListener(MouseEvent.CLICK,this.hideEventGiftBag);
            this["displayTxt"].text = this.GiftBagWarmingDescription;
            this["claimBtn"].visible = false;
            Central.main.disableButton(this["claimBtn"],this.hideEventGiftBag,ButtonData.CLAIM);
         }
         else
         {
            this["displayTxt"].text = this.GiftBagDescription[1];
            this["claimBtn"].visible = true;
            Central.main.initButton(this["claimBtn"],this.hideEventGiftBag,ButtonData.CLAIM);
         }
         var _loc2_:int = int(this.GiftBagGift.length);
         param1["dailyLoginGiftMc"].gotoAndStop("num_" + _loc2_);
         this.updateEventGiftBagMc(param1["dailyLoginGiftMc"]);
      }
      
      public function hideEventGiftBag(param1:MouseEvent) : void
      {
         switch(param1.currentTarget.name)
         {
            case "claimBtn":
               Central.main.disableButton(MovieClip(param1.currentTarget),this.hideEventGiftBag,ButtonData.CLAIM);
               Central.main.showAmfLoading();
               Central.main.amfClient.service(this.ServerFunction,[Central.main.account.getAccountSessionKey()],this.eventGiftBagResponse);
               break;
            default:
               this.gotoAndStop(Timeline.IDLE);
               Central.main.proc.streamStartEvents();
         }
      }
      
      private function checkEventGiftBagItemFull() : Boolean
      {
         var _loc8_:Object = null;
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc9_:Array = [];
         _loc1_ = 0;
         while(_loc1_ < this.GiftBagGift.length)
         {
            _loc9_ = String(this.GiftBagGift[_loc1_]).split("_");
            if(String(this.GiftBagGift[_loc1_]).indexOf("wpn") >= 0)
            {
               if(_loc9_.length > 2)
               {
                  _loc2_ += Number(_loc9_[2]);
               }
               else
               {
                  _loc2_++;
               }
            }
            if(String(this.GiftBagGift[_loc1_]).indexOf("back") >= 0)
            {
               if(_loc9_.length > 2)
               {
                  _loc3_ += Number(_loc9_[2]);
               }
               else
               {
                  _loc3_++;
               }
            }
            if(String(this.GiftBagGift[_loc1_]).indexOf("set") >= 0)
            {
               _loc4_++;
            }
            if(String(this.GiftBagGift[_loc1_]).indexOf("item") >= 0)
            {
               if(Central.main.ITEM_DATA.find(Central.main.itemPrototype(String(this.GiftBagGift[_loc1_]))))
               {
                  if(_loc9_.length > 2)
                  {
                     _loc7_ += Number(_loc9_[2]);
                  }
                  else
                  {
                     _loc7_++;
                  }
               }
               else if(Central.main.ESSENCE_DATA.find(Central.main.itemPrototype(String(this.GiftBagGift[_loc1_]))))
               {
                  if(_loc9_.length > 2)
                  {
                     _loc5_ += Number(_loc9_[2]);
                  }
                  else
                  {
                     _loc5_++;
                  }
               }
               else if(Central.main.MATERIAL_DATA.find(Central.main.itemPrototype(String(this.GiftBagGift[_loc1_]))))
               {
                  if(_loc9_.length > 2)
                  {
                     _loc6_ += Number(_loc9_[2]);
                  }
                  else
                  {
                     _loc6_++;
                  }
               }
            }
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < this.GiftBagGift.length)
         {
            if(String(this.GiftBagGift[_loc1_]).indexOf("wpn") >= 0)
            {
               if(Central.main.getMainChar().getInventory(InventoryData.TYPE_WEAPON).length + _loc2_ > Data.INV_SPACE_WEAPON)
               {
                  this.GiftBagWarmingDescription = this.GiftBagDescription[5];
                  return true;
               }
            }
            if(String(this.GiftBagGift[_loc1_]).indexOf("back") >= 0)
            {
               if(Central.main.getMainChar().getBackItem() != "")
               {
                  if(Central.main.getMainChar().getInventory(InventoryData.TYPE_BACK_ITEM).length + _loc3_ > Data.INV_SPACE_BACKITEM)
                  {
                     this.GiftBagWarmingDescription = this.GiftBagDescription[7];
                     return true;
                  }
               }
               else if(Central.main.getMainChar().getInventory(InventoryData.TYPE_BACK_ITEM).length + _loc3_ + 1 > Data.INV_SPACE_BACKITEM)
               {
                  this.GiftBagWarmingDescription = this.GiftBagDescription[7];
                  return true;
               }
            }
            if(String(this.GiftBagGift[_loc1_]).indexOf("set") >= 0)
            {
               if(Central.main.getMainChar().getInventory(InventoryData.TYPE_BODY_SET).length + _loc4_ > Data.INV_SPACE_BODYSET)
               {
                  this.GiftBagWarmingDescription = this.GiftBagDescription[6];
                  return true;
               }
            }
            if(String(this.GiftBagGift[_loc1_]).indexOf("item") >= 0)
            {
               if(Central.main.ITEM_DATA.find(Central.main.itemPrototype(String(this.GiftBagGift[_loc1_]))))
               {
                  if(Account.getAccountType() == Account.FREE)
                  {
                     if(Central.main.getMainChar().getInventory(InventoryData.TYPE_ITEM).length + _loc7_ > Data.INV_SPACE_FREE)
                     {
                        this.GiftBagWarmingDescription = this.GiftBagDescription[8];
                        return true;
                     }
                  }
                  else if(Central.main.getMainChar().getInventory(InventoryData.TYPE_ITEM).length + _loc7_ > Data.INV_SPACE_PREMIUM)
                  {
                     this.GiftBagWarmingDescription = this.GiftBagDescription[8];
                     return true;
                  }
               }
               else if(Central.main.ESSENCE_DATA.find(Central.main.itemPrototype(String(this.GiftBagGift[_loc1_]))))
               {
                  if(Central.main.getMainChar().getInventory(InventoryData.TYPE_ESSENCE).length + _loc5_ > Data.INV_SPACE_ESSENCE)
                  {
                     this.GiftBagWarmingDescription = this.GiftBagDescription[9];
                     return true;
                  }
               }
               else if(Central.main.MATERIAL_DATA.find(Central.main.itemPrototype(String(this.GiftBagGift[_loc1_]))))
               {
                  if(Account.getAccountType() == Account.FREE)
                  {
                     if(Central.main.getMainChar().getInventory(InventoryData.TYPE_MATERIAL).length + _loc6_ > Data.INV_SPACE_MATERIAL_FREE)
                     {
                        this.GiftBagWarmingDescription = this.GiftBagDescription[4];
                        return true;
                     }
                  }
                  else if(Central.main.getMainChar().getInventory(InventoryData.TYPE_MATERIAL).length + _loc6_ > Data.INV_SPACE_MATERIAL_PREMIUM)
                  {
                     this.GiftBagWarmingDescription = this.GiftBagDescription[4];
                     return true;
                  }
               }
            }
            _loc1_++;
         }
         return false;
      }
      
      public function updateEventGiftBagMc(param1:MovieClip) : void
      {
         var _loc4_:Object = null;
         var _loc2_:int = 0;
         var _loc3_:Array = [];
         _loc2_ = 0;
         while(_loc2_ < this.GiftBagGift.length)
         {
            _loc3_ = this.GiftBagGift[_loc2_].split("_");
            Central.main.showIconData(param1["IconMC" + _loc2_],_loc3_[0] + _loc3_[1],_loc3_[2] ? _loc3_[2] : "1");
            _loc2_++;
         }
      }
      
      private function eventGiftBagResponse(param1:Object) : void
      {
         var _loc4_:Object = null;
         var _loc5_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:Array = [];
         Central.main.hideAmfLoading();
         if(Central.main.validateAmfResponse(param1))
         {
            if(Central.main.dailyDragonHuntObject.pvp_tournament)
            {
               _loc3_ = this.GiftBagGift[_loc2_].split("_");
               _loc5_ = Number(_loc3_[2]);
               Central.main.getMainChar().pvpRecord[PvPData.PVP_TOURNAMENT_TICKET] = Central.main.getMainChar().pvpRecord[PvPData.PVP_TOURNAMENT_TICKET] + int(_loc5_);
               Out.debug("","pvp reward , ticket = " + Central.main.getMainChar().pvpRecord[PvPData.PVP_TOURNAMENT_TICKET]);
               Out.debug("","pvp reward , panel = " + Central.panel.getInstance().curPanel);
               if(Central.panel.getInstance().getCurPanelName() == "arena")
               {
                  Central.panel.getInstance().curPanel.updateTournamentDisplayNum();
               }
               delete Central.main.dailyDragonHuntObject["pvp_tournament"];
            }
            _loc2_ = 0;
            while(_loc2_ < this.GiftBagGift.length)
            {
               _loc3_ = this.GiftBagGift[_loc2_].split("_");
               _loc4_ = Central.main.toolkit.getDisplayData(String(_loc3_[0] + _loc3_[1]));
               if(_loc3_.length > 2 && int(_loc3_[2]) > 1)
               {
                  _loc4_.amount = Number(_loc3_[2]);
               }
               if(_loc4_.type == "currency")
               {
                  Central.main.addCurrency(String(_loc3_[0] + _loc3_[1]));
               }
               else
               {
                  Central.main.toolkit.DisplayDataAddInventory(_loc4_);
               }
               _loc2_++;
            }
            Central.main.showInfo(this.GiftBagDescription[3]);
            Central.main.updateMenu();
            this.gotoAndStop(Timeline.IDLE);
            Central.main.proc.streamStartEvents();
         }
      }
      
      public function showPasswordPopup(param1:String, param2:Function, param3:Function, param4:*) : void
      {
         var _loc5_:MovieClip = this["popupPillFullMc"];
         this.passwordConfirmationTxt = param1;
         this.passwordOkCallback = param2;
         this.passwordNoCallback = param3;
         this.passwordUseHtml = param4;
         _loc5_.gotoAndPlay(Timeline.SHOW);
         this.passwordLeaveEnabled = false;
      }
      
      public function showPasswordSignupInvitationPopup(param1:String, param2:Function, param3:Function, param4:*, param5:Boolean = true) : void
      {
         var _loc6_:MovieClip = this["popupPillFullMc"];
         this.passwordConfirmationTxt = param1;
         this.passwordOkCallback = param2;
         this.passwordNoCallback = param3;
         this.passwordUseHtml = param4;
         this.passwordLeaveEnabled = param5;
         _loc6_.gotoAndPlay(Timeline.SHOW);
      }
      
      public function onShowPasswordPopup(param1:MovieClip) : void
      {
         var _loc2_:MovieClip = this["popupPillFullMc"]["panel"];
         if(Central.main.accRegActiveStatus == Central.main.ACC_REG_ACTIVE_STATUS_NOT_REGISTERED)
         {
            _loc2_.gotoAndStop("inactive");
         }
         else
         {
            _loc2_.gotoAndStop("active");
         }
      }
      
      public function onShowPasswordActive(param1:MovieClip) : void
      {
         if(Central.main.accRegActiveStatus == Central.main.ACC_REG_ACTIVE_STATUS_NOT_REGISTERED)
         {
            return;
         }
         var _loc2_:MovieClip = this["popupPillFullMc"]["panel"]["mcActivePanel"];
         var _loc3_:TextField = _loc2_["lbl_warning"];
         _loc3_.text = this.passwordConfirmationTxt;
         var _loc4_:TextField = _loc2_["txtPasswordHint"];
         _loc4_.text = Central.main.langLib.get(1822);
         Central.main.initButton(_loc2_["btnContinue"],this.hidePasswordPopupWithContinue,Central.main.langLib.get(1820));
         Central.main.initButton(_loc2_["btnOk"],this.hidePasswordPopupWithOk,ButtonData.OK);
         _loc2_["btnClose"].addEventListener(MouseEvent.CLICK,this.hidePasswordPopupWithNo);
      }
      
      public function onShowPasswordInactive(param1:MovieClip) : void
      {
         if(Central.main.accRegActiveStatus != Central.main.ACC_REG_ACTIVE_STATUS_NOT_REGISTERED)
         {
            return;
         }
         var _loc2_:MovieClip = this["popupPillFullMc"]["panel"]["mcInactivePanel"];
         var _loc3_:TextField = _loc2_["lbl_createcharacter"];
         _loc3_.text = this.passwordConfirmationTxt;
         Central.main.initButton(_loc2_["btnContinue"],this.hideAccRegNoticeWithContinue,Central.main.langLib.get(1818));
         Central.main.initButton(_loc2_["btnContinueWithoutSignUp"],this.hideAccRegNoticeWithContinueWithoutSignUp,Central.main.langLib.get(1819));
         Central.main.initButton(_loc2_["btnLeave"],this.hideAccRegNoticeWithLeave,Central.main.langLib.get(1821));
         _loc2_["btnLeave"].visible = this.passwordLeaveEnabled;
         _loc2_["btnClose"].addEventListener(MouseEvent.CLICK,this.hideAccRegNoticeWithClose);
      }
      
      private function hidePasswordPopup() : void
      {
         var _loc1_:MovieClip = this["popupPillFullMc"];
         _loc1_.gotoAndPlay(Timeline.EXIT);
      }
      
      private function hidePasswordPopupWithNo(param1:MouseEvent) : void
      {
         this.hidePasswordPopup();
         if(this.passwordNoCallback != null)
         {
            this.passwordNoCallback();
         }
      }
      
      private function hidePasswordPopupWithOk(param1:MouseEvent) : void
      {
         var _loc2_:MovieClip = null;
         var _loc3_:String = null;
         this.hidePasswordPopup();
         if(this.passwordOkCallback != null)
         {
            _loc2_ = this["popupPillFullMc"]["panel"]["mcActivePanel"];
            _loc3_ = Central.main.getHash(_loc2_["txtPassword"].text);
            _loc2_["txtPassword"].text = "";
            this.passwordOkCallback(_loc3_);
         }
      }
      
      private function hidePasswordPopupWithContinue(param1:MouseEvent) : void
      {
         Central.main.callJS("PopupRegistration");
         this.hidePasswordPopup();
      }
      
      private function hideAccRegNoticeWithContinue(param1:MouseEvent) : void
      {
         this.hidePasswordPopup();
         Central.main.callJS("PopupRegistration");
         if(this.passwordNoCallback != null)
         {
            this.passwordNoCallback();
         }
      }
      
      private function hideAccRegNoticeWithContinueWithoutSignUp(param1:MouseEvent) : void
      {
         this.hidePasswordPopup();
         if(this.passwordOkCallback != null)
         {
            this.passwordOkCallback();
         }
      }
      
      private function hideAccRegNoticeWithLeave(param1:MouseEvent) : void
      {
         this.hidePasswordPopup();
         if(this.passwordNoCallback != null)
         {
            this.passwordNoCallback();
         }
      }
      
      private function hideAccRegNoticeWithClose(param1:MouseEvent) : void
      {
         this.hidePasswordPopup();
         if(this.passwordNoCallback != null)
         {
            this.passwordNoCallback();
         }
      }
      
      internal function frame1() : *
      {
         this.onIdle();
      }
      
      internal function frame7() : *
      {
         this.onShow();
      }
      
      internal function frame12() : *
      {
         this.onShareBox();
      }
      
      internal function frame22() : *
      {
         this.onGeneralNotice();
      }
      
      internal function frame27() : *
      {
         stop();
      }
      
      internal function frame32() : *
      {
         this.onShowTrainSkillConfirm();
      }
      
      internal function frame39() : *
      {
         this.onShowPayConfirm();
      }
      
      internal function frame43() : *
      {
         this.onShowFAQ();
      }
      
      internal function frame47() : *
      {
         this.onShowGuide(this);
      }
      
      internal function frame51() : *
      {
         this.onNoticeBoard();
      }
      
      internal function frame59() : *
      {
         this.onShowDead(this);
      }
      
      internal function frame67() : *
      {
         this.onRenameConfirmation();
      }
      
      internal function frame70() : *
      {
         this.onResetSkillConfirmation();
      }
      
      internal function frame74() : *
      {
         this.onGetGoldToken();
      }
      
      internal function frame78() : *
      {
         this.onRefreshConfitmation();
      }
      
      internal function frame82() : *
      {
         this.onGetHuntingPassport();
      }
      
      internal function frame87() : *
      {
         this.onGetMedal(this);
      }
      
      internal function frame92() : *
      {
         this.onShowEventDailyLoginGift(this);
      }
      
      internal function frame98() : *
      {
         this.onShowGetEnemyHp(this);
      }
      
      internal function frame102() : *
      {
         this.onShowPopup(this);
      }
      
      internal function frame107() : *
      {
         this.onShowPvpInfoBox();
      }
      
      internal function frame112() : *
      {
         this.onShowPvpScheduleBox();
      }
      
      internal function frame117() : *
      {
         this.onShowEventGiftBag(this);
         this.stop();
      }
      
      internal function frame122() : *
      {
         this.onShowPopup(this);
      }
      
      internal function frame127() : *
      {
         this.onShowPopupSealFail(this);
      }
      
      internal function frame132() : *
      {
         this.onShowPopupSpecialHpBar(this);
      }
      
      internal function frame137() : *
      {
         this.onShowGetReward(this);
         this.stop();
      }
      
      internal function frame145() : *
      {
         this.onShowInvFull(this);
      }
   }
}

