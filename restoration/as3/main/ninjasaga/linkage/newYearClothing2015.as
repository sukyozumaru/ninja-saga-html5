package ninjasaga.linkage
{
   import com.utils.CreateFilter;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.filters.ColorMatrixFilter;
   import ninjasaga.Central;
   import ninjasaga.data.ButtonData;
   import ninjasaga.data.Data;
   import ninjasaga.data.InventoryData;
   import ninjasaga.data.Timeline;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol3042")]
   public class newYearClothing2015 extends MovieClip
   {
      
      public var panel:MovieClip;
      
      private var langArr:Array = new Array();
      
      internal var session_key:String = Central.main.account.getAccountSessionKey();
      
      private var dimFilter:ColorMatrixFilter = CreateFilter.getSaturationFilter(0);
      
      private var TestMode:Boolean = false;
      
      private var canClaimClothing:Boolean = true;
      
      private var tokenNum:int = 10000;
      
      private var rewardSet:String;
      
      private var rewardItem:String;
      
      private const CHAR_GENDER:int = int(Central.main.getMainChar().getGender());
      
      public function newYearClothing2015()
      {
         super();
         addFrameScript(0,this.frame1,9,this.frame10,14,this.frame15,30,this.frame31);
         this.langArr = Central.main.langLib.get(1894);
         var _loc1_:int = int(Central.main.getMainChar().getLevel());
         this.rewardItem = "";
         if(this.CHAR_GENDER == 0)
         {
            this.rewardSet = "set1884";
         }
         else
         {
            this.rewardSet = "set1885";
         }
         if(!Central.main.getMainChar().hasItem(InventoryData.TYPE_BODY_SET,"set1884",true) && !Central.main.getMainChar().hasItem(InventoryData.TYPE_BODY_SET,"set1885",true))
         {
            this.canClaimClothing = true;
         }
         else
         {
            this.canClaimClothing = false;
         }
      }
      
      public function show() : void
      {
         this.gotoAndPlay(Timeline.SHOW);
      }
      
      public function onShow() : void
      {
         var _loc2_:Object = null;
         var _loc1_:MovieClip = this["panel"];
         _loc2_ = Central.main.toolkit.getDisplayData(this.rewardSet);
         _loc1_["btnClose"].addEventListener(MouseEvent.CLICK,this.hide);
         _loc1_["descTxt0"].text = this.langArr[0];
         _loc1_["descTxt1"].text = this.langArr[1];
         _loc1_["descTxt2"].text = this.langArr[2];
         Central.main.showDynamicTooltip(_loc1_["clothesMc"],String("<font size=\'16\'>" + _loc2_.tooltip + "</font>"));
         this.updatePanel();
      }
      
      public function updatePanel() : void
      {
         var _loc1_:MovieClip = this["panel"];
         if(this.canClaimClothing)
         {
            Central.main.initButton(_loc1_["claimBtn"],this.claimClothCallAmf,ButtonData.CLAIM);
            _loc1_["claimBtn"].filters = null;
         }
         else
         {
            Central.main.disableButton(_loc1_["claimBtn"],this.claimClothCallAmf,this.langArr[7]);
            _loc1_["claimBtn"].filters = [this.dimFilter];
            _loc1_["claimBtn"]["btn"].gotoAndStop(1);
         }
      }
      
      public function claimClothCallAmf(param1:MouseEvent) : void
      {
         if(Central.main.getMainChar().getInventory(InventoryData.TYPE_BODY_SET).length + 1 >= Data.INV_SPACE_BODYSET)
         {
            Central.main.showOk(this.langArr[5],new Function());
            return;
         }
         this.rewardItem = String(this.rewardSet);
         Central.main.showAmfLoading();
         Central.main.amfClient.service("ChristmasEvent2014.claimNewYear2015SpecialReward",[this.session_key],this.claimClothGetAmf);
      }
      
      public function claimClothGetAmf(param1:Object) : void
      {
         Central.main.hideAmfLoading();
         if(Central.main.validateAmfResponse(param1))
         {
            this["panel"]["popUpGetReward"].gotoAndPlay(Timeline.SHOW);
            this.canClaimClothing = false;
            Central.main.toolkit.DisplayDataAddInventory(Central.main.toolkit.getDisplayData(this.rewardSet));
         }
      }
      
      public function onShowGetReward(param1:MovieClip) : void
      {
         var _loc2_:MovieClip = null;
         var _loc3_:String = null;
         var _loc4_:Object = null;
         param1.stop();
         param1["panelMC"]["titleTxt"].text = this.langArr[3];
         param1["panelMC"]["subTitleTxt"].text = this.langArr[4];
         _loc4_ = Central.main.toolkit.getDisplayData(this.rewardItem);
         param1["panelMC"]["rewardIcon"]["iconHolder"].addChild(_loc4_.mc);
         Central.main.showDynamicTooltip(param1["panelMC"]["rewardIcon"],String("<font size=\'16\'>" + _loc4_.tooltip + "</font>"));
         Central.main.toolkit.DisplayDataAddInventory(_loc4_);
         Central.main.initButton(param1["panelMC"]["btnOk"],this.hideRewardPop,ButtonData.OK);
         this.updatePanel();
      }
      
      public function hideRewardPop(param1:MouseEvent) : void
      {
         this["panel"]["popUpGetReward"].gotoAndPlay(Timeline.EXIT);
      }
      
      public function hide(param1:MouseEvent = null) : void
      {
         Central.main.updateMenu();
         this.gotoAndPlay(Timeline.EXIT);
         Central.main.removeEventPopupPanel();
         Central.main.proc.streamStartEvents();
      }
      
      private function showPaymentGateway(param1:MouseEvent) : void
      {
         Central.main.gotoPaymentGateway();
      }
      
      internal function frame1() : *
      {
         this.stop();
      }
      
      internal function frame10() : *
      {
         this.onShow();
      }
      
      internal function frame15() : *
      {
         this.stop();
      }
      
      internal function frame31() : *
      {
         this.gotoAndStop("idle");
      }
   }
}

