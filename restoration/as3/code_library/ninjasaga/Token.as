package ninjasaga
{
   import com.utils.Out;
   import ninjasaga.data.AMFData;
   import ninjasaga.data.DBCharacterData;
   import ninjasaga.data.InventoryData;
   import ninjasaga.data.Timeline;
   import ninjasaga.data.TokenData;
   
   public final class Token
   {
      
      private static var instance:Token;
      
      private static var buyHairId:String;
      
      public function Token(param1:SingletonBlocker)
      {
         super();
         if(param1 == null)
         {
            throw new Error("Error: Instantiation failed: Use Token.getInstance() instead of new.");
         }
      }
      
      public static function getInstance() : Token
      {
         if(instance == null)
         {
            instance = new Token(new SingletonBlocker());
         }
         return instance;
      }
      
      public function resetAP() : void
      {
         Main.showAmfLoading();
         Main.amfClient.service("CharacterDAO.resetAPbyToken",[Account.getAccountSessionKey(),Account.getAccountBalance()],this.resetAPResult);
      }
      
      private function resetAPResult(param1:Object) : void
      {
         if(String(param1.status) == AMFData.STATUS_ERROR)
         {
            Main.onError(String(param1.error));
            return;
         }
         Account.balance = Account.getAccountBalance() - TokenData.TOKEN_FOR_RESET_AP;
         var _loc2_:int = 0;
         while(_loc2_ < DBCharacterData.ALL_ATTRIBUTE_POINTS.length)
         {
            Main.getMainChar().updateData(DBCharacterData.ALL_ATTRIBUTE_POINTS[_loc2_],0);
            _loc2_++;
         }
         if(Main.checkGameStatus() == Timeline.MAP)
         {
            Main.getMainChar().restoreOriginalStatus();
         }
         Main.mapMenu.refreshAP();
         Main.updateMenu();
         Main.hideAmfLoading();
      }
      
      public function recustomization() : void
      {
         Account.balance = Account.getAccountBalance() - TokenData.TOKEN_FOR_RECUSTOMIZATION;
         Panel.getInstance().curPanel.finalizeCustomization();
         Panel.getInstance().curPanel.saveAppearance();
      }
      
      public function instantTrain() : void
      {
         if(Main.checkGameStatus() == Timeline.PANEL)
         {
            Out.debug("token","Token.as >> stopTrainingTimer :: PANEL");
            Panel.getInstance().curPanel.stopTrainingTimer();
         }
         else
         {
            Out.debug("token","Token.as >> stopTrainingTimer :: mapMenu");
            Main.mapMenu.stopTrainingTimer();
         }
         Main.showAmfLoading();
         Main.amfClient.service("CharacterDAO.instantTrainByToken",[Account.getAccountSessionKey(),Account.getAccountBalance(),Main.getMainChar().trainingSkill.id],this.instantTrainResult);
      }
      
      private function instantTrainResult(param1:Object) : void
      {
         if(String(param1.status) == AMFData.STATUS_ERROR)
         {
            Main.onError(String(param1.error));
            return;
         }
         Account.balance = Account.getAccountBalance() - TokenData.TOKEN_FOR_INSTANT_TRAINING;
         if(Central.main.Features.FEATURE_ESSENCE)
         {
            if(Main.isPopupType == "village")
            {
               Main.hideAmfLoading();
               Main.getMainChar().verifyTrainingSkill(this.callback);
            }
            else if(Main.isPopupType == "gear")
            {
               Main.hideAmfLoading();
               Main.getMainChar().verifyTrainingSkill(this.callback);
            }
            else if(Main.checkGameStatus() == Timeline.PANEL)
            {
               Panel.getInstance().curPanel.finalizeInstantTrain();
            }
            else
            {
               Main.mapMenu.finalizeInstantTrain();
               Main.updateMenu();
            }
         }
         else if(Main.checkGameStatus() == Timeline.PANEL)
         {
            Panel.getInstance().curPanel.finalizeInstantTrain();
         }
         else
         {
            Main.mapMenu.finalizeInstantTrain();
            Main.updateMenu();
         }
      }
      
      private function callback() : void
      {
         Main.updateMapSideBtn();
      }
      
      public function buyHair(param1:String) : void
      {
         Main.showAmfLoading();
         buyHairId = param1;
         var _loc2_:String = Central.main.getHash(buyHairId);
         Main.amfClient.service("CharacterManagement.buyHair",[Account.getAccountSessionKey(),Central.main.updateSequence(),_loc2_,buyHairId],this.buyHairResponse);
      }
      
      private function buyHairResponse(param1:Object) : void
      {
         var _loc2_:Object = null;
         Main.hideAmfLoading();
         if(Main.validateAmfResponse(param1))
         {
            Central.main.showInfo(Central.main.langLib.get(26));
            _loc2_ = Central.main.HAIR_DATA.find(buyHairId);
            Account.balance = Account.getAccountBalance() - _loc2_.token;
            Main.getMainChar().setHair("hair_" + _loc2_.swfName);
            Main.getMainChar().changeHair(Main.getMainChar().getHair());
            Main.getMainChar().addInventory(InventoryData.TYPE_HAIR,buyHairId);
            Panel.getInstance().curPanel.invHair.push(buyHairId);
            Panel.getInstance().curPanel.updateHairDisplay();
            Panel.getInstance().curPanel.updateGoldDisplay();
            Central.main.tracking.trackSale(Central.main.tracking.SALE_HAIR_STYLE,_loc2_.token,buyHairId);
         }
      }
      
      public function saveHairChange(param1:String) : void
      {
         var _loc2_:String = Central.main.getHash(param1);
         Main.amfClient.service("CharacterManagement.changeHair",[Central.main.account.getAccountSessionKey(),Main.updateSequence(),_loc2_,param1],this.saveHairChangeResponse);
      }
      
      private function saveHairChangeResponse(param1:Object) : void
      {
         if(!Central.main.validateAmfResponse(param1))
         {
         }
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
