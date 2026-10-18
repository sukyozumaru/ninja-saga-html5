package ninjasaga.linkage.panel
{
   import bitemycode.facebook.FBUser;
   import bitemycode.http.Cookie;
   import com.adobe.utils.StringUtil;
   import com.utils.CreateFilter;
   import com.utils.Delegate;
   import com.utils.Environment;
   import com.utils.GF;
   import com.utils.NumberUtil;
   import com.utils.Out;
   import de.polygonal.ds.HashMap;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.filters.GlowFilter;
   import flash.text.TextField;
   import ninjasaga.Account;
   import ninjasaga.Central;
   import ninjasaga.Item;
   import ninjasaga.data.AMFData;
   import ninjasaga.data.AppData;
   import ninjasaga.data.ButtonData;
   import ninjasaga.data.Data;
   import ninjasaga.data.TitleData;
   import ninjasaga.dbclass.DBCharacter;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol1150")]
   public class RRSelectCharMenu extends MovieClip
   {
      
      public var hairTxt:TextField;
      
      public var deleteBtn:MovieClip;
      
      public var btnNextGender:SimpleButton;
      
      public var charSelect1:MovieClip;
      
      public var charSelect0:MovieClip;
      
      public var charNameInput:TextField;
      
      public var charSelect3:MovieClip;
      
      public var charSelect2:MovieClip;
      
      public var accountTxt:TextField;
      
      public var btnCreate:MovieClip;
      
      public var charSelect5:MovieClip;
      
      public var hairColorMc:MovieClip;
      
      public var btnPrevGender:SimpleButton;
      
      public var upgradeBtn:MovieClip;
      
      public var charSelect4:MovieClip;
      
      public var logoMC:MovieClip;
      
      public var skinColorMc:MovieClip;
      
      public var genderTxt:TextField;
      
      public var btnNextHair:SimpleButton;
      
      public var maxHairNumberTxt:TextField;
      
      public var btnPrevHair:SimpleButton;
      
      public var charHolder:MovieClip;
      
      public var backBtn:MovieClip;
      
      public var lbl_user:TextField;
      
      public var btnRandom:MovieClip;
      
      public var playBtn:MovieClip;
      
      private var glowFilter:GlowFilter = CreateFilter.getGlowFilter({"strength":12});
      
      private const NUMBER_OF_CHAR_SLOT:uint = 6;
      
      private var charactersList:Array = new Array();
      
      private var dbChar:DBCharacter;
      
      private var selectedCharSelectId:uint = 0;
      
      private var hairAvailable:Array;
      
      private var character_name:String = "";
      
      private var character_gender:uint = 0;
      
      private var character_face:String = "01_0";
      
      private var character_hair:String = "01_0";
      
      private var character_hair_color:uint = 0;
      
      private var character_skin_color:uint = 13;
      
      private var cookie:Cookie = new Cookie("ninjasaga",2592000);
      
      private var randomHair:Boolean = false;
      
      private var randomHairColor:Boolean = false;
      
      private var randomSkinColor:Boolean = false;
      
      private var randomHairColorIndex:int = 0;
      
      private var randomSkinColorIndex:int = 0;
      
      private var randomMatch:Array = [[0,12],[1,8],[2,18],[3,19],[4,10],[6,0],[6,10],[8,17],[9,13],[10,0],[11,2],[11,18],[13,13],[14,15],[15,11],[16,10],[17,8],[17,18],[19,13],[19,17]];
      
      public function RRSelectCharMenu()
      {
         super();
         addFrameScript(0,this.frame1,5,this.frame6,10,this.frame11,15,this.frame16,22,this.frame23);
      }
      
      private function onIdle() : void
      {
         if(AppData.type == AppData.RR)
         {
            this.gotoAndStop("init");
         }
         this.stop();
      }
      
      private function onInit() : void
      {
         this.stop();
         var _loc1_:* = Central.main.getMainMc();
         _loc1_["attentionBtn"].visible = false;
         Central.main.initButton(_loc1_["attentionBtn"],Central.main.proc.showPaymentStatus,null);
         Central.main.showAmfLoading();
         this.amfGetCharactersList();
      }
      
      private function onSelect() : void
      {
         this.stop();
         this.setupSelectMenu();
         var _loc1_:* = Central.main.getMainMc();
         if(Central.main.paymentStatus)
         {
            _loc1_["attentionBtn"].visible = true;
            Central.main.showDynamicTooltip(_loc1_["attentionBtn"],String("<font size=\'12\'>" + Central.main.langLib.get(953) + "</font>"));
            Central.main.proc.showPaymentStatus();
         }
      }
      
      private function onSelected() : void
      {
         this.stop();
         Central.main.initButton(this["playBtn"],this.onPlayBtn,ButtonData.PLAY);
         Central.main.initButton(this["deleteBtn"],this.onDeleteBtn,ButtonData.DELETE);
         if(Account.getAccountType() == Account.FREE)
         {
            this["upgradeBtn"].visible = true;
            Central.main.initButton(this["upgradeBtn"],this.onUpgradeBtn,ButtonData.UPGRADE);
         }
         else
         {
            this["upgradeBtn"].visible = false;
         }
      }
      
      private function onCreate() : void
      {
         var swfToLoad:Array;
         var bodySetData:Object;
         this.stop();
         Central.main.setPreviewChar();
         swfToLoad = [];
         if(Central.main.actionBase == null)
         {
            swfToLoad.push("swf/actions/action_base.swf");
         }
         swfToLoad.push("swf/items/" + Central.main.getPreviewChar().getFace() + ".swf");
         swfToLoad.push("swf/items/" + Data.DEFAULT_FACE + "_1" + ".swf");
         swfToLoad.push("swf/items/" + Central.main.getPreviewChar().getHair() + ".swf");
         bodySetData = Central.main.BODY_SET_BOY;
         swfToLoad.push("swf/items/" + bodySetData[Central.main.getPreviewChar().getBodySet()].swfName + ".swf");
         swfToLoad.push("swf/items/" + Central.main.BODY_SET_GIRL[Data.DEFAULT_BODY_SET].swfName + ".swf");
         Central.main.WEAPON_DATA = new HashMap();
         Central.main.WEAPON_DATA.insert("wpn1",{"swfName":"wpn_01"});
         swfToLoad.push("swf/items/" + Central.main.WEAPON_DATA.find(Central.main.getPreviewChar().getWeapon()).swfName + ".swf");
         Central.main.loadSwf(swfToLoad,this.completeLoading);
         this["backBtn"].addEventListener(MouseEvent.CLICK,function():*
         {
            gotoAndStop("select");
         });
         this["charNameInput"].maxChars = Data.MAX_NAME_CHAR;
         this["charNameInput"].text = FBUser.username;
         if(this["charNameInput"].text.length >= Data.MAX_NAME_CHAR)
         {
            this["charNameInput"].text = FBUser.username.substring(0,20);
         }
      }
      
      private function completeLoading(param1:Object) : void
      {
         var _loc3_:Item = null;
         if(Central.main.actionBase == null)
         {
            Central.main.actionBase = param1["swf/actions/action_base.swf"];
         }
         Central.main.getPreviewChar().setActionBase(GF.getAsset(Central.main.actionBase,"ActionBase"));
         var _loc2_:MovieClip = Central.main.getPreviewChar().getSwf();
         this["charHolder"].addChild(_loc2_);
         Central.main.getPreviewChar().playStand();
         if(!Item.hasItem(Central.main.getPreviewChar().getFace()))
         {
            _loc3_ = new Item(Central.main.getPreviewChar().getFace());
            _loc3_.setSwf(param1["swf/items/" + Central.main.getPreviewChar().getFace() + ".swf"]);
            Item.setItem(_loc3_);
         }
         if(!Item.hasItem(Data.DEFAULT_FACE + "_1"))
         {
            _loc3_ = new Item(Data.DEFAULT_FACE + "_1");
            _loc3_.setSwf(param1["swf/items/" + Data.DEFAULT_FACE + "_1" + ".swf"]);
            Item.setItem(_loc3_);
         }
         if(!Item.hasItem(Central.main.getPreviewChar().getHair()))
         {
            _loc3_ = new Item(Central.main.getPreviewChar().getHair());
            _loc3_.setSwf(param1["swf/items/" + Central.main.getPreviewChar().getHair() + ".swf"]);
            Item.setItem(_loc3_);
         }
         var _loc4_:Object = Central.main.BODY_SET_BOY;
         if(!Item.hasItem(_loc4_[Central.main.getPreviewChar().getBodySet()].swfName))
         {
            _loc3_ = new Item(_loc4_[Central.main.getPreviewChar().getBodySet()].swfName);
            _loc3_.setSwf(param1["swf/items/" + _loc4_[Central.main.getPreviewChar().getBodySet()].swfName + ".swf"]);
            Item.setItem(_loc3_);
         }
         if(!Item.hasItem(Central.main.BODY_SET_GIRL[Data.DEFAULT_BODY_SET].swfName))
         {
            _loc3_ = new Item(Central.main.BODY_SET_GIRL[Data.DEFAULT_BODY_SET].swfName);
            _loc3_.setSwf(param1["swf/items/" + Central.main.BODY_SET_GIRL[Data.DEFAULT_BODY_SET].swfName + ".swf"]);
            Item.setItem(_loc3_);
         }
         if(!Item.hasItem(Central.main.getPreviewChar().getWeapon()))
         {
            _loc3_ = new Item(Central.main.getPreviewChar().getWeapon());
            _loc3_.setSwf(param1["swf/items/" + Central.main.WEAPON_DATA.find(Central.main.getPreviewChar().getWeapon()).swfName + ".swf"]);
            Item.setItem(_loc3_);
         }
         this.dbChar = new DBCharacter();
         this.updateColorPlate(this["hairColorMc"],Data.getHairColorArr(),this.onHairColorChange);
         this.updateColorPlate(this["skinColorMc"],Data.getSkinColorArr(),this.onSkinColorChange);
         GF.changeColor(this["hairColorMc"]["selectedColor"],Data.getHairColorArr()[0]);
         GF.changeColor(this["skinColorMc"]["selectedColor"],Data.getSkinColorArr()[0]);
         var _loc5_:Array = Central.main.dataLib.getHairData(Central.main.getPreviewChar().getGender());
         this.hairAvailable = [];
         var _loc6_:uint = 0;
         while(_loc6_ < _loc5_.length)
         {
            if(Data.HIDDEN_HAIR.indexOf(_loc5_[_loc6_]) < 0)
            {
               this.hairAvailable.push(_loc5_[_loc6_]);
            }
            _loc6_++;
         }
         this["hairTxt"].text = "1";
         this["maxHairNumberTxt"].text = String(this.hairAvailable.length);
         this["btnNextGender"].addEventListener(MouseEvent.CLICK,this.changeGender);
         this["btnPrevGender"].addEventListener(MouseEvent.CLICK,this.changeGender);
         this["btnNextHair"].addEventListener(MouseEvent.CLICK,this.changeHair);
         this["btnPrevHair"].addEventListener(MouseEvent.CLICK,this.changeHair);
         Central.main.getPreviewChar().customizeCharacter();
         this["genderTxt"].text = Central.main.langLib.titleTxt(TitleData.MALE);
         Central.main.initButton(this["btnCreate"],this.onCreateBtn,ButtonData.CREATE);
         Central.main.initButton(this["btnRandom"],this.onRandomBtn,ButtonData.RANDOM);
         Central.main.showDynamicTooltip(this["btnRandom"],String("<font size=\'16\'>" + Central.main.langLib.get(1586) + "</font>"));
      }
      
      private function onRandomBtn(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         this.randomHair = true;
         this.randomHairColor = true;
         this.randomSkinColor = true;
         this.changeHair();
         _loc2_ = NumberUtil.randomInt(0,19);
         this.randomHairColorIndex = this.randomMatch[_loc2_][0];
         this.randomSkinColorIndex = this.randomMatch[_loc2_][1];
         this.onHairColorChange();
         this.onSkinColorChange();
      }
      
      private function updateColorPlate(param1:MovieClip, param2:Array, param3:Function) : void
      {
         var _loc5_:int = 0;
         var _loc4_:uint = 0;
         while(_loc4_ < param2.length)
         {
            _loc5_ = typeof param2[_loc4_] == "number" ? int(param2[_loc4_]) : int(param2[_loc4_][0]);
            GF.changeColor(param1["colorBox_" + _loc4_],_loc5_);
            param1["colorBox_" + _loc4_].colorIndex = _loc4_;
            param1["colorBox_" + _loc4_].buttonMode = true;
            param1["colorBox_" + _loc4_].addEventListener(MouseEvent.CLICK,param3);
            _loc4_++;
         }
      }
      
      private function setupSelectMenu() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         this["lbl_user"].text = Central.main.langLib.titleTxt(TitleData.USER);
         if(Account.getAccountType() == Account.PREMIUM)
         {
            Central.main.provision();
            this["accountTxt"].text = Central.main.langLib.titleTxt(TitleData.PREMIUM);
            _loc1_ = 0;
            while(_loc1_ < this.charactersList.length)
            {
               this["charSelect" + _loc1_].character_id = this.charactersList[_loc1_][0];
               this["charSelect" + _loc1_]["charName"].text = this.charactersList[_loc1_][1];
               this["charSelect" + _loc1_]["charLevel"].text = this.charactersList[_loc1_][2];
               this["charSelect" + _loc1_]["charGender"].text = this.charactersList[_loc1_][3] == 0 ? Central.main.langLib.titleTxt(TitleData.MALE) : Central.main.langLib.titleTxt(TitleData.FEMALE);
               this["charSelect" + _loc1_].gotoAndStop("normal");
               this["charSelect" + _loc1_]["lbl_level"].text = Central.main.langLib.titleTxt(TitleData.LEVEL);
               _loc1_++;
            }
            _loc2_ = 0;
            while(_loc2_ < this.NUMBER_OF_CHAR_SLOT)
            {
               this["charSelect" + _loc2_].id = _loc2_;
               if(this["charSelect" + _loc2_].character_id != null)
               {
                  this["charSelect" + _loc2_].addEventListener(MouseEvent.CLICK,this.onSelectCharPressed);
                  this["charSelect" + _loc2_].buttonMode = true;
               }
               else
               {
                  Central.main.initButton(this["charSelect" + _loc2_]["createBtn"],this.onCreateCharPressed,ButtonData.CREATE);
                  this["charSelect" + _loc2_]["lbl_emptyslot"].text = Central.main.langLib.titleTxt(TitleData.EMPTYSLOT);
               }
               _loc2_++;
            }
         }
         else
         {
            this["accountTxt"].text = Central.main.langLib.titleTxt(TitleData.FREE);
            if(this.charactersList.length > 0)
            {
               _loc3_ = 0;
               while(_loc3_ < 1)
               {
                  this["charSelect" + _loc3_].character_id = this.charactersList[_loc3_][0];
                  this["charSelect" + _loc3_]["charName"].text = this.charactersList[_loc3_][1];
                  this["charSelect" + _loc3_]["charLevel"].text = this.charactersList[_loc3_][2];
                  this["charSelect" + _loc3_]["charGender"].text = this.charactersList[_loc3_][3] == 0 ? Central.main.langLib.titleTxt(TitleData.MALE) : Central.main.langLib.titleTxt(TitleData.FEMALE);
                  this["charSelect" + _loc3_].gotoAndStop("normal");
                  this["charSelect" + _loc3_]["lbl_level"].text = Central.main.langLib.titleTxt(TitleData.LEVEL);
                  _loc3_++;
               }
               _loc4_ = 0;
               while(_loc4_ < this.NUMBER_OF_CHAR_SLOT)
               {
                  this["charSelect" + _loc4_].id = _loc4_;
                  if(this["charSelect" + _loc4_].character_id != null)
                  {
                     this["charSelect" + _loc4_].addEventListener(MouseEvent.CLICK,this.onSelectCharPressed);
                     this["charSelect" + _loc4_].buttonMode = true;
                  }
                  else
                  {
                     Central.main.initButton(this["charSelect" + _loc4_]["createBtn"],this.onFreeCreateCharPressed,ButtonData.CREATE);
                     this["charSelect" + _loc4_]["lbl_emptyslot"].text = Central.main.langLib.titleTxt(TitleData.EMPTYSLOT);
                  }
                  _loc4_++;
               }
            }
            else
            {
               _loc5_ = 0;
               while(_loc5_ < this.NUMBER_OF_CHAR_SLOT)
               {
                  this["charSelect" + _loc5_].id = _loc5_;
                  if(this["charSelect" + _loc5_].character_id != null)
                  {
                     this["charSelect" + _loc5_].addEventListener(MouseEvent.CLICK,this.onSelectCharPressed);
                     this["charSelect" + _loc5_].buttonMode = true;
                  }
                  else
                  {
                     Central.main.initButton(this["charSelect" + _loc5_]["createBtn"],this.onCreateCharPressed,ButtonData.CREATE);
                     this["charSelect" + _loc5_]["lbl_emptyslot"].text = Central.main.langLib.titleTxt(TitleData.EMPTYSLOT);
                  }
                  _loc5_++;
               }
            }
         }
      }
      
      private function onHairColorChange(param1:Event = null) : void
      {
         var _loc2_:Array = Data.getHairColorArr();
         if(this.randomHairColor)
         {
            Central.main.getPreviewChar().updateData("character_hair_color",_loc2_[this.randomHairColorIndex]);
            this.dbChar.character_hair_color = _loc2_[this.randomHairColorIndex];
            GF.changeColor(this["hairColorMc"]["selectedColor"],_loc2_[this.randomHairColorIndex][0]);
            Central.main.getPreviewChar().customizeCharacter();
            this.character_hair_color = this.randomHairColorIndex;
            this.randomHairColor = false;
         }
         else
         {
            Central.main.getPreviewChar().updateData("character_hair_color",_loc2_[param1.currentTarget.colorIndex]);
            this.dbChar.character_hair_color = _loc2_[param1.currentTarget.colorIndex];
            GF.changeColor(this["hairColorMc"]["selectedColor"],_loc2_[param1.currentTarget.colorIndex][0]);
            Central.main.getPreviewChar().customizeCharacter();
            this.character_hair_color = param1.currentTarget.colorIndex;
         }
      }
      
      private function onSkinColorChange(param1:Event = null) : void
      {
         var _loc2_:Array = Data.getSkinColorArr();
         if(this.randomSkinColor)
         {
            Central.main.getPreviewChar().updateData("character_skin_color",_loc2_[this.randomSkinColorIndex]);
            this.dbChar.character_skin_color = _loc2_[this.randomSkinColorIndex];
            GF.changeColor(this["skinColorMc"]["selectedColor"],_loc2_[this.randomSkinColorIndex]);
            Central.main.getPreviewChar().customizeCharacter();
            this.character_skin_color = this.randomSkinColorIndex;
            this.randomSkinColor = false;
         }
         else
         {
            Central.main.getPreviewChar().updateData("character_skin_color",_loc2_[param1.currentTarget.colorIndex]);
            this.dbChar.character_skin_color = _loc2_[param1.currentTarget.colorIndex];
            GF.changeColor(this["skinColorMc"]["selectedColor"],_loc2_[param1.currentTarget.colorIndex]);
            Central.main.getPreviewChar().customizeCharacter();
            this.character_skin_color = param1.currentTarget.colorIndex;
         }
      }
      
      private function changeGender(param1:MouseEvent = null) : void
      {
         var _loc2_:uint = 0;
         _loc2_ = uint(Central.main.getPreviewChar().getGender());
         if(_loc2_ == 0)
         {
            _loc2_ = 1;
         }
         else
         {
            _loc2_ = 0;
         }
         switch(_loc2_)
         {
            case 0:
               this["genderTxt"].text = Central.main.langLib.titleTxt(TitleData.MALE);
               break;
            case 1:
               this["genderTxt"].text = Central.main.langLib.titleTxt(TitleData.FEMALE);
         }
         var _loc3_:Array = Central.main.dataLib.getHairData(_loc2_);
         this.hairAvailable = [];
         var _loc4_:uint = 0;
         while(_loc4_ < _loc3_.length)
         {
            if(Data.HIDDEN_HAIR.indexOf(_loc3_[_loc4_]) < 0)
            {
               this.hairAvailable.push(_loc3_[_loc4_]);
            }
            _loc4_++;
         }
         Central.main.getPreviewChar().setGender(_loc2_);
         Central.main.getPreviewChar().setFace(Data.DEFAULT_FACE + "_" + _loc2_);
         Central.main.getPreviewChar().setHair(Data.DEFAULT_HAIR + "_" + _loc2_);
         this["hairTxt"].text = "1";
         this.dbChar.character_gender = _loc2_;
         this.dbChar.character_face = Central.main.getPreviewChar().getFace();
         this.dbChar.character_hair = Central.main.getPreviewChar().getHair();
         Central.main.getPreviewChar().customizeCharacter();
         this.character_gender = _loc2_;
         var _loc5_:RegExp = /face_/;
         this.character_face = this.dbChar.character_face.replace(_loc5_,"");
         var _loc6_:RegExp = /hair_/;
         this.character_hair = this.dbChar.character_hair.replace(_loc6_,"");
      }
      
      private function changeHair(param1:MouseEvent = null) : void
      {
         var _loc3_:* = 0;
         var _loc2_:Array = this.hairAvailable;
         if(this.randomHair)
         {
            _loc3_ = int(NumberUtil.randomInt(1,100) % _loc2_.length);
            this.randomHair = false;
         }
         else
         {
            _loc3_ = _loc2_.indexOf(Central.main.getPreviewChar().getHair());
            switch(param1.currentTarget.name)
            {
               case "btnPrevHair":
                  _loc3_--;
                  if(_loc3_ < 0)
                  {
                     _loc3_ = int(_loc2_.length - 1);
                  }
                  break;
               case "btnNextHair":
                  if(++_loc3_ >= _loc2_.length)
                  {
                     _loc3_ = 0;
                  }
            }
         }
         this["hairTxt"].text = String(_loc3_ + 1);
         Central.main.getPreviewChar().setHair(_loc2_[_loc3_]);
         Central.main.getPreviewChar().customizeCharacter();
         this.dbChar.character_hair = _loc2_[_loc3_];
         var _loc4_:RegExp = /hair_/;
         this.character_hair = this.dbChar.character_hair.replace(_loc4_,"");
      }
      
      private function onSelectCharPressed(param1:MouseEvent) : void
      {
         this.setupSelectMenu();
         this["charSelect" + param1.currentTarget.id].gotoAndStop("selected");
         this.selectedCharSelectId = param1.currentTarget.character_id;
         this.gotoAndStop("selected");
      }
      
      private function onFreeCreateCharPressed(param1:MouseEvent) : void
      {
         Central.main.showUpgradeAccount(Central.main.langLib.get(1452),"CreateChar");
      }
      
      private function onCreateCharPressed(param1:MouseEvent) : void
      {
         Central.main.tracking.generalTrack(Central.main.tracking.TRACK_CREATE_CHAR,"Setp1","","",0,false);
         this.gotoAndPlay("create");
      }
      
      private function onCreateBtn(param1:MouseEvent) : void
      {
         var name:String = null;
         var evt:MouseEvent = param1;
         try
         {
            name = this["charNameInput"].text;
            if(name == null)
            {
               Central.main.showInfo(Central.main.langLib.get(192));
               return;
            }
            if(StringUtil.trim(name) == "")
            {
               Central.main.showInfo(Central.main.langLib.get(192));
               return;
            }
            this.dbChar.character_name = this["charNameInput"].text;
            this.character_name = this["charNameInput"].text;
            this.amfCreateCharacter();
         }
         catch(e:Error)
         {
            Out.error(this,"onCreateCharPressed::" + e.getStackTrace());
            Central.main.submitLogDump();
         }
      }
      
      private function onUpgradeBtn(param1:MouseEvent) : void
      {
         Central.main.showUpgradeAccount(Central.main.langLib.get(1452),"CreateChar");
      }
      
      private function onPlayBtn(param1:MouseEvent) : void
      {
         Central.main.showAmfLoading();
         Central.main.amfClient.service("CharacterDAO.getCharacterById",[Account.getAccountSessionKey(),this.selectedCharSelectId],this.onAmfGetCharacterResult);
      }
      
      private function onDeleteBtn(param1:MouseEvent) : void
      {
         Central.main.showDeleteConfirmation(Central.main.langLib.get(190),Delegate.create(this,this.amfDeleteCharacterPromptSecurity),new Function());
      }
      
      private function amfGetCharactersList() : void
      {
         Central.main.showAmfLoading();
         Central.main.amfClient.service("CharacterDAO.getCharactersList",[Account.getAccountSessionKey()],this.onAmfGetCharactersListResult);
      }
      
      private function onAmfGetCharactersListResult(param1:Object) : void
      {
         Central.main.hideAmfLoading();
         if(String(param1.status) == AMFData.STATUS_ERROR)
         {
            Central.main.onError(String(param1.error));
            return;
         }
         this.charactersList = param1.result as Array;
         if(param1.login_per_day == 0)
         {
            if(Account.getAccountType() == Account.PREMIUM)
            {
               Central.main.tracking.trackClick(Central.main.tracking.TRACK_LOGIN,Central.main.tracking.TRACK_PREMIUM);
            }
         }
         this.gotoAndStop("select");
      }
      
      private function onAmfGetCharacterResult(param1:Object) : void
      {
         if(!Central.main.validateAmfResponse(param1))
         {
            return;
         }
         var _loc2_:DBCharacter = Central.main.dataParser.parseRawCharacter(param1.result);
         Central.main.setMainChar(_loc2_);
         this.amfGetSystemData();
         if(Environment.IS_IN_BROWSER)
         {
            Central.main.initRank();
         }
      }
      
      private function amfCreateCharacter() : void
      {
         try
         {
            this["btnCreate"].removeEventListener(MouseEvent.CLICK,this.onCreateBtn);
            this["btnCreate"].visible = false;
            this["btnRandom"].visible = false;
            Central.main.showAmfLoading();
            Central.main.amfClient.service("CharacterDAO.createCharacter",[Account.getAccountSessionKey(),this.character_name,this.character_gender,this.character_hair_color,this.character_skin_color,this.character_hair,this.character_face],this.onAmfCreateCharacterResult);
         }
         catch(e:Error)
         {
            Out.error(this,"amfCreateCharacter::" + e.getStackTrace());
            Central.main.submitLogDump();
         }
      }
      
      private function onAmfCreateCharacterResult(param1:Object) : void
      {
         var result:Object = param1;
         try
         {
            if(String(result.status) == AMFData.STATUS_ERROR)
            {
               Central.main.onError(String(result.error));
               return;
            }
            if(String(result.status) == AMFData.STATUS_SUCCESS)
            {
               if(String(result.result) == "2")
               {
                  this["charNameInput"].text = "";
                  this["btnCreate"].addEventListener(MouseEvent.CLICK,this.onCreateBtn);
                  this["btnCreate"].visible = true;
                  this["btnRandom"].visible = true;
                  Central.main.hideAmfLoading();
                  Central.main.showOk(Central.main.langLib.get(1626)[6]);
               }
               else
               {
                  Central.main.tracking.generalTrack(Central.main.tracking.TRACK_CREATE_CHAR,"Setp2","","",0,false);
                  this.dbChar.character_id = result.character_id;
                  Central.main.setMainChar(this.dbChar);
                  Central.main.isNewChar = true;
                  Central.main.hideAmfLoading();
                  this.getSystemData();
               }
            }
         }
         catch(e:Error)
         {
            Out.error(this,"onAmfCreateCharacterResult::" + e.getStackTrace());
            Central.main.submitLogDump();
         }
      }
      
      private function getSystemData() : void
      {
         this.amfGetSystemData();
         if(Environment.IS_IN_BROWSER)
         {
            Central.main.initRank();
         }
      }
      
      public function amfDeleteCharacterPromptSecurity() : void
      {
         if(Central.main.accRegActiveStatus == Central.main.ACC_REG_ACTIVE_STATUS_ACTIVE)
         {
            Central.main.showSecurityPasswordConfirmation(Central.main.langLib.get(1813),this.amfDeleteCharacter,this.hideDeleteCharacterPanel);
         }
         else
         {
            Central.main.showSecurityPasswordSignupInvitation(Central.main.langLib.get(1812),this.amfDeleteCharacter,this.hideDeleteCharacterPanel,true,true);
         }
      }
      
      private function hideDeleteCharacterPanel() : void
      {
         this.gotoAndStop("idle");
      }
      
      private function amfDeleteCharacter(param1:String = "") : void
      {
         var _loc2_:int = int(this.selectedCharSelectId);
         Central.main.showAmfLoading();
         var _loc3_:String = Central.main.getHash(String(_loc2_));
         Central.main.amfClient.service("CharacterDAO.deleteCharacter",[Account.getAccountSessionKey(),_loc2_,_loc3_],this.onAmfDeleteCharacterResult);
      }
      
      private function onAmfDeleteCharacterResult(param1:Object) : void
      {
         if(String(param1.status) == AMFData.STATUS_ERROR)
         {
            Central.main.onError(String(param1.error));
            return;
         }
         if(param1.msg)
         {
            switch(param1.msg)
            {
               case "wrong_password":
                  Central.main.showInfo(Central.main.langLib.get(1823));
                  break;
               case "not_registered":
                  Central.main.showInfo("Not Registered");
            }
         }
         this.gotoAndStop("idle");
      }
      
      private function amfGetSystemData() : void
      {
         Central.main.showAmfLoading();
         Central.main.amfClient.service("SystemData.get",[Account.getAccountSessionKey(),Data.TEST_VERSION],this.onAmfGetSystemDataResult);
      }
      
      private function onAmfGetSystemDataResult(param1:Object) : void
      {
         var _loc2_:String = null;
         if(param1 == null)
         {
            Out.error(this,"onAmfGetSystemDataResult :: result is null");
         }
         if(String(param1.status) == AMFData.STATUS_ERROR)
         {
            Central.main.onError(String(param1.error));
            return;
         }
         param1 = param1.result;
         if(Central.main.dataParser.parseSystemData(param1))
         {
            _loc2_ = Central.main.getHash(String(Central.main.getMainChar().xp));
            Central.main.amfClient.service("CharacterDAO.getExtraData",[Account.getAccountSessionKey(),_loc2_],this.getExtraDataResult);
         }
         else
         {
            Out.error(this,"onAmfGetSystemDataResult :: parseSystemData failed");
         }
      }
      
      private function getExtraDataResult(param1:Object) : void
      {
         var extraData:Object;
         var tempPetArr:Array = null;
         var result:Object = param1;
         if(result == null)
         {
            Out.error(this,"getExtraDataResult :: result is null");
         }
         if(String(result.status) == AMFData.STATUS_ERROR)
         {
            Central.main.onError(String(result.error));
            return;
         }
         extraData = result.result as Object;
         if(Central.main.dataParser.parseCharacterData(extraData))
         {
            if(extraData.char_login_per_day == 0)
            {
               Central.main.tracking.trackAppLang(Central.main.tracking.TRACK_APP_LANG);
               Central.main.tracking.trackACBalance(Central.main.tracking.TRACK_GOLD);
               if(Account.getAccountType() == Account.FREE)
               {
                  Central.main.tracking.trackClick2(Central.main.tracking.TRACK_LOGIN,Central.main.tracking.TRACK_FREE + Central.main.tracking.TRACK_UNIQUE);
                  Central.main.tracking.generalTrack(Central.main.tracking.TRACK_LONGIN_LV,Central.main.getMainChar().getLevel());
               }
            }
            try
            {
               if(Central.main.getMainChar().getLevel() == 20)
               {
                  tempPetArr = [];
                  tempPetArr = extraData.player_pet as Array;
                  if(tempPetArr.length > 0)
                  {
                     Central.main.tracking.generalTrack("Level20WithPet","1","Login");
                  }
               }
            }
            catch(err:Error)
            {
               Out.error(this,"TRACK_PET :: " + err.message);
            }
            Central.main.hideAmfLoading();
            Central.main.startInit();
         }
         else
         {
            Out.error(this,"getExtraDataResult :: parseCharacterData failed");
         }
      }
      
      internal function frame1() : *
      {
         this.onIdle();
      }
      
      internal function frame6() : *
      {
         this.onInit();
      }
      
      internal function frame11() : *
      {
         this.onSelect();
      }
      
      internal function frame16() : *
      {
         this.onSelected();
      }
      
      internal function frame23() : *
      {
         this.onCreate();
      }
   }
}

