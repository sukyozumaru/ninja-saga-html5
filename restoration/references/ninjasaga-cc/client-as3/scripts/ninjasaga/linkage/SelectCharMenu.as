package ninjasaga.linkage
{
   import bitemycode.facebook.FBUser;
   import bitemycode.http.Cookie;
   import com.adobe.utils.StringUtil;
   import com.utils.CreateFilter;
   import com.utils.Delegate;
   import com.utils.GF;
   import com.utils.NumberUtil;
   import com.utils.Out;
   import de.polygonal.ds.HashMap;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.filters.ColorMatrixFilter;
   import flash.filters.GlowFilter;
   import flash.text.TextField;
   import flash.utils.Timer;
   import flash.utils.getTimer;
   import ninjasaga.Account;
   import ninjasaga.Central;
   import ninjasaga.Item;
   import ninjasaga.data.AMFData;
   import ninjasaga.data.AppData;
   import ninjasaga.data.ButtonData;
   import ninjasaga.data.DBCharacterData;
   import ninjasaga.data.Data;
   import ninjasaga.data.HairData;
   import ninjasaga.data.TitleData;
   import ninjasaga.dbclass.DBCharacter;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol1051")]
   public class SelectCharMenu extends MovieClip
   {
      
      private static var _cooldownEndMs:Number = 0;
      
      public var lbl_gender:TextField;
      
      public var hairTxt:TextField;
      
      public var lbl_selectcharacter:TextField;
      
      public var lbl_name:TextField;
      
      public var deleteBtn:MovieClip;
      
      public var lbl_hairstyle:TextField;
      
      public var btnNextGender:SimpleButton;
      
      public var lbl_createcharacter:TextField;
      
      public var charSelect1:MovieClip;
      
      public var charSelect0:MovieClip;
      
      public var charNameInput:TextField;
      
      public var charSelect3:MovieClip;
      
      public var lbl_skincolor:TextField;
      
      public var charSelect2:MovieClip;
      
      public var accountTxt:TextField;
      
      public var btnCreate:MovieClip;
      
      public var charSelect5:MovieClip;
      
      public var hairColorMc:MovieClip;
      
      public var lbl_haircolor:TextField;
      
      public var btnPrevGender:SimpleButton;
      
      public var upgradeBtn:MovieClip;
      
      public var charSelect4:MovieClip;
      
      public var decor1:MovieClip;
      
      public var decor2:MovieClip;
      
      public var skinColorMc:MovieClip;
      
      public var genderTxt:TextField;
      
      public var btnNextHair:SimpleButton;
      
      public var maxHairNumberTxt:TextField;
      
      public var btnPrevHair:SimpleButton;
      
      public var charHolder:MovieClip;
      
      public var backBtn:MovieClip;
      
      public var trialEmblemMC:TrialEmblemPanel;
      
      public var lbl_user:TextField;
      
      public var btnRandom:MovieClip;
      
      public var playBtn:MovieClip;
      
      private var _cselKey:String = "";
      
      private var _selectInFlight:Boolean = false;
      
      private var _cdTimer:Timer;
      
      private var _playDefaultLabel:String = null;
      
      private const NUMBER_OF_CHAR_SLOT:uint = 6;
      
      private var charactersList:Array;
      
      private var dbChar:DBCharacter;
      
      private var selectedCharSelectId:uint = 0;
      
      private var hairAvailable:Array;
      
      private var character_name:String = "";
      
      private var character_gender:uint = 0;
      
      private var character_face:String = Data.DEFAULT_FACE + "_" + this.character_gender;
      
      private var character_hair:String = Data.DEFAULT_FACE + "_" + this.character_gender;
      
      private var character_hair_color:uint = 0;
      
      private var character_skin_color:uint = 13;
      
      private var yellowFilter:GlowFilter;
      
      private var cookie:Cookie;
      
      private var randomHair:Boolean = false;
      
      private var randomHairColor:Boolean = false;
      
      private var randomSkinColor:Boolean = false;
      
      private var randomHairColorIndex:int = 0;
      
      private var randomSkinColorIndex:int = 0;
      
      private var log_A:String = "0";
      
      private var log_B:String = "0";
      
      private var randomMatch:Array;
      
      private var countryAreaMatch:Array;
      
      private var dimFilter:ColorMatrixFilter;
      
      private var createStep:int = 1;
      
      private var onlyRandom:Boolean = true;
      
      private var customRandom:Boolean = false;
      
      private var _charactersListInFlight:Boolean = false;
      
      public function SelectCharMenu()
      {
         addFrameScript(0,this.frame1,5,this.frame6,10,this.frame11,15,this.frame16,20,this.frame21);
         this.charactersList = new Array();
         this.yellowFilter = CreateFilter.getGlowFilter({
            "color":16776960,
            "strength":5,
            "blurX":6,
            "blurY":6,
            "alpha":0.5
         });
         this.cookie = new Cookie("ninjasaga",2592000);
         this.randomMatch = [[0,0],[0,5],[1,2],[1,5],[2,1],[2,5],[3,4],[3,5],[4,0],[4,5],[7,2],[7,5]];
         this.countryAreaMatch = [[7,2],[7,7],[1,0],[7,6],[0,0]];
         this.dimFilter = CreateFilter.getSaturationFilter(0);
         super();
      }
      
      public function onIdle() : void
      {
         if(AppData.type != AppData.RR)
         {
            this.gotoAndStop("init");
         }
         this.stop();
      }
      
      private function showPromoteLink(param1:MouseEvent) : void
      {
         var _loc2_:String = "";
         if(AppData.lang == AppData.ZH)
         {
            _loc2_ = "http://www.ninjasaga.cc/event_lucky_draw/?lang=zh";
         }
         else
         {
            _loc2_ = "http://www.ninjasaga.cc/event_lucky_draw/?lang=en";
         }
         Central.main.gotoURL(_loc2_,"_blank");
         Central.main.amfClient.service("Tracking.clickIngameLoginBanner",[Central.main.account.getAccountSessionKey(),Central.main.promoteId],new Function());
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
         this._playDefaultLabel = null;
         if(this.selectRemaining() > 0)
         {
            this.beginPlayCountdown();
         }
         if(Central.main.paymentStatus)
         {
            Central.main.disableButton(this["deleteBtn"],this.onDeleteBtn,ButtonData.DELETE);
            this["deleteBtn"].filters = [this.dimFilter];
         }
         else
         {
            Central.main.initButton(this["deleteBtn"],this.onDeleteBtn,ButtonData.DELETE);
            this["deleteBtn"].filters = null;
         }
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
         this.stop();
         this["decor1"].visible = true;
         this["decor2"].visible = true;
         Central.main.setPreviewChar();
         var _loc1_:Array = [];
         if(Central.main.actionBase == null)
         {
            _loc1_.push("swf/actions/action_base.swf");
         }
         _loc1_.push("swf/items/" + Central.main.getPreviewChar().getFace() + ".swf");
         _loc1_.push("swf/items/" + Data.DEFAULT_FACE + "_1" + ".swf");
         _loc1_.push("swf/items/" + Central.main.getPreviewChar().getHair() + ".swf");
         var _loc2_:Object = Central.main.BODY_SET_BOY;
         _loc1_.push("swf/items/" + _loc2_[Central.main.getPreviewChar().getBodySet()].swfName + ".swf");
         _loc1_.push("swf/items/" + Central.main.BODY_SET_GIRL[Data.DEFAULT_BODY_SET].swfName + ".swf");
         Central.main.WEAPON_DATA = new HashMap();
         Central.main.WEAPON_DATA.insert("wpn1",{"swfName":"wpn_01"});
         _loc1_.push("swf/items/" + Central.main.WEAPON_DATA.find(Central.main.getPreviewChar().getWeapon()).swfName + ".swf");
         var _loc3_:Array = HairData.getCreateHairData(0);
         var _loc4_:Array = HairData.getCreateHairData(1);
         this.hairAvailable = [];
         var _loc5_:uint = 0;
         while(_loc5_ < _loc3_.length)
         {
            if(Data.HIDDEN_HAIR.indexOf(_loc3_[_loc5_]) < 0)
            {
               this.hairAvailable.push(_loc3_[_loc5_]);
               _loc1_.push("swf/items/" + _loc3_[_loc5_] + ".swf");
            }
            _loc5_++;
         }
         _loc5_ = 0;
         while(_loc5_ < _loc4_.length)
         {
            if(Data.HIDDEN_HAIR.indexOf(_loc4_[_loc5_]) < 0)
            {
               this.hairAvailable.push(_loc4_[_loc5_]);
               _loc1_.push("swf/items/" + _loc4_[_loc5_] + ".swf");
            }
            _loc5_++;
         }
         Central.main.loadSwf(_loc1_,this.completeLoading);
         Central.main.disableButton(this["backBtn"],this.backToSelect,"");
         this["backBtn"].visible = false;
         Central.main.showDynamicTooltip(this["backBtn"],String("<font size=\'16\'>" + Central.main.langLib.btnTxt(ButtonData.BACKTORECRUITMEMBER) + "</font>"));
         this["charNameInput"].maxChars = Data.MAX_NAME_CHAR;
         this["charNameInput"].text = FBUser.username;
         if(this["charNameInput"].text.length >= Data.MAX_NAME_CHAR)
         {
            this["charNameInput"].text = FBUser.username.substring(0,20);
         }
      }
      
      private function backToSelect(param1:MouseEvent) : void
      {
         this.gotoAndStop("select");
      }
      
      private function completeLoading(param1:Object) : void
      {
         var _loc2_:Item = null;
         if(Central.main.actionBase == null)
         {
            Central.main.actionBase = param1["swf/actions/action_base.swf"];
         }
         Central.main.getPreviewChar().setActionBase(GF.getAsset(Central.main.actionBase,"ActionBase"));
         var _loc3_:MovieClip = Central.main.getPreviewChar().getSwf();
         GF.removeAllChild(this["charHolder"]);
         this["charHolder"].addChild(_loc3_);
         Central.main.getPreviewChar().playStand();
         if(!Item.hasItem(Central.main.getPreviewChar().getFace()))
         {
            _loc2_ = new Item(Central.main.getPreviewChar().getFace());
            _loc2_.setSwf(param1["swf/items/" + Central.main.getPreviewChar().getFace() + ".swf"]);
            Item.setItem(_loc2_);
         }
         if(!Item.hasItem(Data.DEFAULT_FACE + "_1"))
         {
            _loc2_ = new Item(Data.DEFAULT_FACE + "_1");
            _loc2_.setSwf(param1["swf/items/" + Data.DEFAULT_FACE + "_1" + ".swf"]);
            Item.setItem(_loc2_);
         }
         if(!Item.hasItem(Central.main.getPreviewChar().getHair()))
         {
            _loc2_ = new Item(Central.main.getPreviewChar().getHair());
            _loc2_.setSwf(param1["swf/items/" + Central.main.getPreviewChar().getHair() + ".swf"]);
            Item.setItem(_loc2_);
         }
         var _loc4_:int = 0;
         while(_loc4_ < this.hairAvailable.length)
         {
            if(!Item.hasItem(this.hairAvailable[_loc4_]))
            {
               _loc2_ = new Item(this.hairAvailable[_loc4_]);
               _loc2_.setSwf(param1["swf/items/" + this.hairAvailable[_loc4_] + ".swf"]);
               Item.setItem(_loc2_);
            }
            _loc4_++;
         }
         var _loc5_:Object = Central.main.BODY_SET_BOY;
         if(!Item.hasItem(_loc5_[Central.main.getPreviewChar().getBodySet()].swfName))
         {
            _loc2_ = new Item(_loc5_[Central.main.getPreviewChar().getBodySet()].swfName);
            _loc2_.setSwf(param1["swf/items/" + _loc5_[Central.main.getPreviewChar().getBodySet()].swfName + ".swf"]);
            Item.setItem(_loc2_);
         }
         if(!Item.hasItem(Central.main.BODY_SET_GIRL[Data.DEFAULT_BODY_SET].swfName))
         {
            _loc2_ = new Item(Central.main.BODY_SET_GIRL[Data.DEFAULT_BODY_SET].swfName);
            _loc2_.setSwf(param1["swf/items/" + Central.main.BODY_SET_GIRL[Data.DEFAULT_BODY_SET].swfName + ".swf"]);
            Item.setItem(_loc2_);
         }
         if(!Item.hasItem(Central.main.getPreviewChar().getWeapon()))
         {
            _loc2_ = new Item(Central.main.getPreviewChar().getWeapon());
            _loc2_.setSwf(param1["swf/items/" + Central.main.WEAPON_DATA.find(Central.main.getPreviewChar().getWeapon()).swfName + ".swf"]);
            Item.setItem(_loc2_);
         }
         this.dbChar = new DBCharacter();
         var _loc6_:Array = Data.getHairColorArr_create();
         var _loc7_:Array = Data.getSkinColorArr_create();
         var _loc8_:Array = Data.getHairColorArr();
         var _loc9_:Array = Data.getSkinColorArr();
         if(Central.main.country_area >= 0 && Central.main.country_area < 5)
         {
            this.dbChar.character_hair_color = _loc8_[_loc6_[this.countryAreaMatch[Central.main.country_area][0]][2]];
            this.dbChar.character_skin_color = _loc9_[_loc7_[this.countryAreaMatch[Central.main.country_area][1]][1]];
            this.character_hair_color = _loc6_[this.countryAreaMatch[Central.main.country_area][0]][2];
            this.character_skin_color = _loc7_[this.countryAreaMatch[Central.main.country_area][1]][1];
         }
         else
         {
            this.dbChar.character_hair_color = _loc8_[_loc6_[this.countryAreaMatch[2][0]][2]];
            this.dbChar.character_skin_color = _loc9_[_loc7_[this.countryAreaMatch[2][1]][1]];
            this.character_hair_color = _loc6_[this.countryAreaMatch[2][0]][_loc6_.length - 1];
            this.character_skin_color = _loc7_[this.countryAreaMatch[2][1]][_loc7_.length - 1];
         }
         Central.main.getPreviewChar().updateData("character_hair_color",_loc8_[this.character_hair_color]);
         Central.main.getPreviewChar().updateData("character_skin_color",_loc9_[this.character_skin_color]);
         this.updateColorPlate(this["hairColorMc"],Data.getHairColorArr_create(),this.onHairColorChange);
         this.updateColorPlate(this["skinColorMc"],Data.getSkinColorArr_create(),this.onSkinColorChange);
         var _loc10_:Array = HairData.getCreateHairData(Central.main.getPreviewChar().getGender());
         this.hairAvailable = [];
         var _loc11_:uint = 0;
         while(_loc11_ < _loc10_.length)
         {
            if(Data.HIDDEN_HAIR.indexOf(_loc10_[_loc11_]) < 0)
            {
               this.hairAvailable.push(_loc10_[_loc11_]);
            }
            _loc11_++;
         }
         this["hairTxt"].text = "01";
         this["maxHairNumberTxt"].text = String(this.hairAvailable.length);
         this["btnNextGender"].addEventListener(MouseEvent.CLICK,this.changeGender);
         this["btnPrevGender"].addEventListener(MouseEvent.CLICK,this.changeGender);
         this["btnNextHair"].addEventListener(MouseEvent.CLICK,this.changeHair);
         this["btnPrevHair"].addEventListener(MouseEvent.CLICK,this.changeHair);
         Central.main.getPreviewChar().customizeCharacter();
         this["lbl_gender"].text = Central.main.langLib.titleTxt(TitleData.GENDER) + ":";
         this["lbl_haircolor"].text = Central.main.langLib.titleTxt(TitleData.HAIRCOLOR);
         this["lbl_hairstyle"].text = Central.main.langLib.titleTxt(TitleData.HAIRSTYLE);
         this["lbl_name"].text = Central.main.langLib.titleTxt(TitleData.NAME) + ":";
         this["lbl_skincolor"].text = Central.main.langLib.titleTxt(TitleData.SKINCOLOR);
         this["lbl_createcharacter"].text = Central.main.langLib.titleTxt(TitleData.CREATECHARACTER);
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
         _loc2_ = NumberUtil.randomInt(0,11);
         this.randomHairColorIndex = this.randomMatch[_loc2_][0];
         this.randomSkinColorIndex = this.randomMatch[_loc2_][1];
         this.onHairColorChange();
         this.onSkinColorChange();
         if(this.onlyRandom)
         {
            this.onlyRandom = false;
            this.createStep = 2;
         }
         this.customRandom = true;
      }
      
      private function updateColorPlate(param1:MovieClip, param2:Array, param3:Function) : void
      {
         var _loc4_:int = 0;
         var _loc5_:uint = 0;
         while(_loc5_ < param2.length)
         {
            _loc4_ = typeof param2[_loc5_] == "number" ? int(param2[_loc5_]) : int(param2[_loc5_][0]);
            GF.changeColor(param1["colorBox_" + _loc5_],_loc4_);
            param1["colorBox_" + _loc5_].colorIndex = param2[_loc5_][param2[_loc5_].length - 1];
            param1["colorBox_" + _loc5_].colorIndex_cre = _loc5_;
            param1["colorBox_" + _loc5_].buttonMode = true;
            param1["colorBox_" + _loc5_].addEventListener(MouseEvent.CLICK,param3);
            _loc5_++;
         }
      }
      
      private function setupSelectMenu() : void
      {
         var _loc7_:MovieClip = null;
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         this["lbl_user"].text = Central.main.langLib.titleTxt(TitleData.USER);
         this["lbl_selectcharacter"].text = Central.main.langLib.titleTxt(TitleData.SELECTCHARACTER);
         var _loc6_:int = 0;
         for(; _loc6_ < this.NUMBER_OF_CHAR_SLOT; _loc6_++)
         {
            _loc7_ = this["charSelect" + _loc6_] as MovieClip;
            if(_loc7_)
            {
               try
               {
                  _loc7_.character_id = null;
               }
               catch(e:Error)
               {
               }
               try
               {
                  _loc7_.removeEventListener(MouseEvent.CLICK,this.onSelectCharPressed);
               }
               catch(e:Error)
               {
               }
               try
               {
                  _loc7_.gotoAndStop(1);
               }
               catch(e:Error)
               {
               }
               try
               {
                  if(_loc7_["charName"])
                  {
                     _loc7_["charName"].text = "";
                  }
               }
               catch(e:Error)
               {
               }
               try
               {
                  if(_loc7_["charLevel"])
                  {
                     _loc7_["charLevel"].text = "";
                  }
               }
               catch(e:Error)
               {
               }
               try
               {
                  if(_loc7_["charGender"])
                  {
                     _loc7_["charGender"].text = "";
                  }
               }
               catch(e:Error)
               {
               }
               try
               {
                  if(_loc7_["lbl_level"])
                  {
                     _loc7_["lbl_level"].text = "";
                  }
               }
               catch(e:Error)
               {
                  continue;
               }
            }
         }
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
                  if(Central.main.isExpired)
                  {
                     this["charSelect" + _loc2_]["createBtn"].visible = false;
                  }
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
         var _loc2_:Array = Data.getHairColorArr_create();
         var _loc3_:Array = Data.getHairColorArr();
         if(param1)
         {
            this.createStep = 3;
            this.onlyRandom = false;
         }
         var _loc4_:int = 0;
         while(_loc4_ < _loc2_.length)
         {
            this["hairColorMc"]["bg_" + _loc4_].filters = null;
            _loc4_++;
         }
         if(this.randomHairColor)
         {
            Central.main.getPreviewChar().updateData("character_hair_color",_loc3_[_loc2_[this.randomHairColorIndex][2]]);
            this.dbChar.character_hair_color = _loc3_[_loc2_[this.randomHairColorIndex][2]];
            Central.main.getPreviewChar().customizeCharacter();
            this.character_hair_color = _loc2_[this.randomHairColorIndex][2];
            this.randomHairColor = false;
            this["hairColorMc"]["bg_" + this.randomHairColorIndex].filters = [this.yellowFilter];
         }
         else
         {
            Central.main.getPreviewChar().updateData("character_hair_color",_loc3_[param1.currentTarget.colorIndex]);
            this.dbChar.character_hair_color = _loc3_[param1.currentTarget.colorIndex];
            Central.main.getPreviewChar().customizeCharacter();
            this.character_hair_color = param1.currentTarget.colorIndex;
            this["hairColorMc"]["bg_" + param1.currentTarget.colorIndex_cre].filters = [this.yellowFilter];
         }
      }
      
      private function onSkinColorChange(param1:Event = null) : void
      {
         var _loc2_:Array = Data.getSkinColorArr_create();
         var _loc3_:Array = Data.getSkinColorArr();
         if(param1)
         {
            this.createStep = 3;
            this.onlyRandom = false;
         }
         var _loc4_:int = 0;
         while(_loc4_ < _loc2_.length)
         {
            this["skinColorMc"]["bg_" + _loc4_].filters = null;
            _loc4_++;
         }
         if(this.randomSkinColor)
         {
            Central.main.getPreviewChar().updateData("character_skin_color",_loc3_[_loc2_[this.randomSkinColorIndex][1]]);
            this.dbChar.character_skin_color = _loc3_[_loc2_[this.randomSkinColorIndex][1]];
            Central.main.getPreviewChar().customizeCharacter();
            this.character_skin_color = _loc2_[this.randomSkinColorIndex][1];
            this.randomSkinColor = false;
            this["skinColorMc"]["bg_" + this.randomSkinColorIndex].filters = [this.yellowFilter];
         }
         else
         {
            Central.main.getPreviewChar().updateData("character_skin_color",_loc3_[param1.currentTarget.colorIndex]);
            this.dbChar.character_skin_color = _loc3_[param1.currentTarget.colorIndex];
            Central.main.getPreviewChar().customizeCharacter();
            this.character_skin_color = param1.currentTarget.colorIndex;
            this["skinColorMc"]["bg_" + param1.currentTarget.colorIndex_cre].filters = [this.yellowFilter];
         }
      }
      
      private function changeGender(param1:MouseEvent = null) : void
      {
         var _loc2_:uint = 0;
         if(param1)
         {
            this.createStep = 3;
            this.onlyRandom = false;
         }
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
         var _loc3_:Array = HairData.getCreateHairData(_loc2_);
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
         this["hairTxt"].text = "01";
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
         var _loc2_:* = 0;
         var _loc3_:Array = this.hairAvailable;
         if(param1)
         {
            this.createStep = 3;
            this.onlyRandom = false;
         }
         if(this.randomHair)
         {
            _loc2_ = int(NumberUtil.randomInt(1,100) % _loc3_.length);
            this.randomHair = false;
         }
         else
         {
            _loc2_ = int(_loc3_.indexOf(Central.main.getPreviewChar().getHair()));
            switch(param1.currentTarget.name)
            {
               case "btnPrevHair":
                  _loc2_--;
                  if(_loc2_ < 0)
                  {
                     _loc2_ = int(_loc3_.length - 1);
                  }
                  break;
               case "btnNextHair":
                  if(++_loc2_ >= _loc3_.length)
                  {
                     _loc2_ = 0;
                  }
            }
         }
         if(_loc2_ + 1 < 10)
         {
            this["hairTxt"].text = String("0") + String(_loc2_ + 1);
         }
         else
         {
            this["hairTxt"].text = String(_loc2_ + 1);
         }
         Central.main.getPreviewChar().setHair(_loc3_[_loc2_]);
         Central.main.getPreviewChar().customizeCharacter();
         this.dbChar.character_hair = _loc3_[_loc2_];
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
         if(!Central.main.isNewAccount)
         {
         }
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
         if(Central.main.isExpired)
         {
            this.showExpired();
            return;
         }
         if(this.selectRemaining() > 0)
         {
            this.beginPlayCountdown();
            return;
         }
         if(this._selectInFlight)
         {
            return;
         }
         this._selectInFlight = true;
         Central.main.preloader_status = 1;
         Central.main.showAmfLoading();
         Central.main.amfClient.service("CharacterDAO.getCharacterById",[Account.getAccountSessionKey(),this.selectedCharSelectId],this.onAmfGetCharacterResult);
      }
      
      private function selectRemaining() : int
      {
         if(_cooldownEndMs <= 0)
         {
            return 0;
         }
         var _loc1_:int = Math.ceil((_cooldownEndMs - getTimer()) / 1000);
         return _loc1_ > 0 ? _loc1_ : 0;
      }
      
      private function beginPlayCountdown() : void
      {
         this.updatePlayLabel();
         if(this._cdTimer == null)
         {
            this._cdTimer = new Timer(1000);
            this._cdTimer.addEventListener(TimerEvent.TIMER,this.onCdTick);
         }
         if(!this._cdTimer.running)
         {
            this._cdTimer.start();
         }
      }
      
      private function onCdTick(param1:TimerEvent) : void
      {
         this.updatePlayLabel();
      }
      
      private function updatePlayLabel() : void
      {
         var _loc1_:int = 0;
         try
         {
            if(this.playBtn == null || this.playBtn["txt"] == null)
            {
               return;
            }
            if(this._playDefaultLabel == null)
            {
               this._playDefaultLabel = this.playBtn["txt"].text;
            }
            _loc1_ = this.selectRemaining();
            if(_loc1_ > 0)
            {
               this.playBtn["txt"].text = String(_loc1_);
            }
            else
            {
               if(this._cdTimer != null)
               {
                  this._cdTimer.stop();
               }
               this.playBtn["txt"].text = this._playDefaultLabel;
            }
         }
         catch(e:Error)
         {
         }
      }
      
      private function onDeleteBtn(param1:MouseEvent) : void
      {
         this.log_A = "1";
         Central.main.showDeleteConfirmation(Central.main.langLib.get(190),Delegate.create(this,this.amfDeleteCharacterPromptSecurity),new Function());
      }
      
      private function amfGetCharactersList() : void
      {
         if(this._charactersListInFlight)
         {
            Out.debug(this,"amfGetCharactersList :: skipped (already in flight)");
            return;
         }
         this._charactersListInFlight = true;
         Central.main.showAmfLoading();
         Central.main.amfClient.service("CharacterDAO.getCharactersList",[Account.getAccountSessionKey()],this.onAmfGetCharactersListResult);
      }
      
      public function refresh() : void
      {
         this.charactersList = new Array();
         this.amfGetCharactersList();
      }
      
      private function onAmfGetCharactersListResult(param1:Object) : void
      {
         this._charactersListInFlight = false;
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
         var _loc2_:Boolean = String(this.currentLabel) == "select";
         var _loc3_:Boolean = String(this.currentLabel) == "create";
         if(Central.main.isNewAccount)
         {
            if(!_loc3_)
            {
               this.gotoAndPlay("create");
            }
         }
         else if(_loc2_)
         {
            this.setupSelectMenu();
         }
         else
         {
            this.gotoAndStop("select");
         }
         if(Central.main.isExpired)
         {
            this.showExpired();
         }
      }
      
      private function onAmfGetCharacterResult(param1:Object) : void
      {
         var _loc2_:Array = null;
         var _loc3_:int = 0;
         var _loc4_:Object = null;
         var _loc5_:DBCharacter = null;
         var _loc6_:String = null;
         this._selectInFlight = false;
         if(param1 != null && param1.cooldown != null && int(param1.cooldown) > 0)
         {
            _cooldownEndMs = getTimer() + int(param1.cooldown) * 1000;
            Central.main.hideAmfLoading();
            this.beginPlayCountdown();
            return;
         }
         if(!Central.main.validateAmfResponse(param1))
         {
            return;
         }
         this._cselKey = param1.gk == null ? "" : String(param1.gk);
         if(param1.cd != null && int(param1.cd) > 0)
         {
            _cooldownEndMs = getTimer() + int(param1.cd) * 1000;
         }
         var _loc7_:DBCharacter = Central.main.dataParser.parseRawCharacter(param1.result,true,true);
         Out.debug(this,"SelectCharMenu::onAmfGetCharacterResult, [1], dbChar=" + _loc7_);
         Central.main.setMainChar(_loc7_);
         Central.main.invGetBackNum = Central.main.getMainChar().getData(DBCharacterData.INVSLOT);
         Data.INV_SPACE_WEAPON_FREE_CURNUM = Central.main.invGetBackNum.weapon;
         Data.INV_SPACE_BODYSET_FREE_CURNUM = Central.main.invGetBackNum.body_set;
         Data.INV_SPACE_FREE_CURNUM = Central.main.invGetBackNum.item;
         Data.INV_SPACE_ESSENCE_FREE_CURNUM = Central.main.invGetBackNum.essence;
         Data.INV_SPACE_MATERIAL_FREE_CURNUM = Central.main.invGetBackNum.material;
         Data.INV_SPACE_BACKITEM_FREE_CURNUM = Central.main.invGetBackNum.back;
         Data.INV_SPACE_PET_FREE_CURNUM = Central.main.invGetBackNum.pet;
         Data.INV_SPACE_WEAPON_PREMIUM_CURNUM = Central.main.invGetBackNum.weapon;
         Data.INV_SPACE_BODYSET_PREMIUM_CURNUM = Central.main.invGetBackNum.body_set;
         Data.INV_SPACE_PREMIUM_CURNUM = Central.main.invGetBackNum.item;
         Data.INV_SPACE_ESSENCE_PREMIUM_CURNUM = Central.main.invGetBackNum.essence;
         Data.INV_SPACE_MATERIAL_PREMIUM_CURNUM = Central.main.invGetBackNum.material;
         Data.INV_SPACE_BACKITEM_PREMIUM_CURNUM = Central.main.invGetBackNum.back;
         Data.INV_SPACE_PET_PREMIUM_CURNUM = Central.main.invGetBackNum.pet;
         if(Account.getAccountType() == Account.FREE)
         {
            Data.INV_SPACE_WEAPON = 200 + Data.INV_SPACE_WEAPON_FREE_CURNUM * Data.INV_SPACE_WEAPON_ADD;
            Data.INV_SPACE_BODYSET = 200 + Data.INV_SPACE_BODYSET_FREE_CURNUM * Data.INV_SPACE_BODYSET_ADD;
            Data.INV_SPACE_FREE = 40 + Data.INV_SPACE_FREE_CURNUM * Data.INV_SPACE_FREE_ADD;
            Data.INV_SPACE_ESSENCE = 200 + Data.INV_SPACE_ESSENCE_FREE_CURNUM * Data.INV_SPACE_ESSENCE_ADD;
            Data.INV_SPACE_MATERIAL_FREE = 200 + Data.INV_SPACE_MATERIAL_FREE_CURNUM * Data.INV_SPACE_MATERIAL_FREE_ADD;
            Data.INV_SPACE_BACKITEM = 200 + Data.INV_SPACE_BACKITEM_FREE_CURNUM * Data.INV_SPACE_BACKITEM_ADD;
            Data.INV_SPACE_PET_FREE = 99 + Data.INV_SPACE_PET_FREE_CURNUM * Data.INV_SPACE_PET_FREE_ADD;
         }
         else
         {
            Data.INV_SPACE_WEAPON = 300 + Data.INV_SPACE_WEAPON_PREMIUM_CURNUM * Data.INV_SPACE_WEAPON_ADD;
            Data.INV_SPACE_BODYSET = 300 + Data.INV_SPACE_BODYSET_PREMIUM_CURNUM * Data.INV_SPACE_BODYSET_ADD;
            Data.INV_SPACE_PREMIUM = 80 + Data.INV_SPACE_PREMIUM_CURNUM * Data.INV_SPACE_FREE_ADD;
            Data.INV_SPACE_ESSENCE = 300 + Data.INV_SPACE_ESSENCE_PREMIUM_CURNUM * Data.INV_SPACE_ESSENCE_ADD;
            Data.INV_SPACE_MATERIAL_PREMIUM = 400 + Data.INV_SPACE_MATERIAL_PREMIUM_CURNUM * Data.INV_SPACE_MATERIAL_PREMIUM_ADD;
            Data.INV_SPACE_BACKITEM = 300 + Data.INV_SPACE_BACKITEM_PREMIUM_CURNUM * Data.INV_SPACE_BACKITEM_ADD;
            Data.INV_SPACE_PET_PREMIUM = 149 + Data.INV_SPACE_PET_PREMIUM_CURNUM * Data.INV_SPACE_PET_PREMIUM_ADD;
         }
         this.amfGetSystemData();
         if(AppData.type == AppData.FB && Boolean(param1.result.recruit_friend_data))
         {
            if(param1.result.recruit_friend_data.length > 0)
            {
               _loc2_ = [];
               _loc3_ = 0;
               while(_loc3_ < param1.result.recruit_friend_data.length)
               {
                  _loc4_ = param1.result.recruit_friend_data[_loc3_].result;
                  _loc5_ = Central.main.dataParser.parseRawCharacter(_loc4_,true);
                  _loc2_.push(_loc5_);
                  _loc6_ = _loc4_.source_id + "_" + _loc4_.character_id;
                  Central.main.setRecruitedFriends(_loc6_);
                  _loc3_++;
               }
               Central.main.recruitFriendTmpData = _loc2_;
            }
         }
      }
      
      private function amfCreateCharacter() : void
      {
         try
         {
            this["btnCreate"].removeEventListener(MouseEvent.CLICK,this.onCreateBtn);
            this["btnCreate"].visible = false;
            this["btnRandom"].visible = false;
            this.onAmfCreateCharacterResult(null);
         }
         catch(e:Error)
         {
            Out.error(this,"amfCreateCharacter::" + e.getStackTrace());
            Central.main.submitLogDump();
         }
      }
      
      private function trackingResponse(param1:Object = null) : void
      {
      }
      
      private function onAmfCreateCharacterResult(param1:Object) : void
      {
         var result:Object = param1;
         try
         {
            if(Central.main.isNewAccount)
            {
               if(this.createStep == 1)
               {
                  Central.main.amfClient.service("Tracking.tutTracking",[Central.main.account.getAccountSessionKey(),"STEP1"],this.trackingResponse);
               }
               else if(this.createStep == 2)
               {
                  Central.main.amfClient.service("Tracking.tutTracking",[Central.main.account.getAccountSessionKey(),"STEP2"],this.trackingResponse);
               }
               else if(this.createStep == 3 && this.customRandom)
               {
                  Central.main.amfClient.service("Tracking.tutTracking",[Central.main.account.getAccountSessionKey(),"SKIP_ANI"],this.trackingResponse);
               }
               else if(this.createStep == 3)
               {
                  Central.main.amfClient.service("Tracking.tutTracking",[Central.main.account.getAccountSessionKey(),"STEP3"],this.trackingResponse);
               }
            }
            Central.main.setMainChar(this.dbChar);
            Central.main.isNewChar = true;
            Central.main.isNewCharByCreate = true;
            Data.INV_SPACE_WEAPON = Account.getAccountType() == Account.PREMIUM ? 300 : 200;
            Data.INV_SPACE_BACKITEM = Account.getAccountType() == Account.PREMIUM ? 300 : 200;
            Data.INV_SPACE_BODYSET = Account.getAccountType() == Account.PREMIUM ? 300 : 200;
            Data.INV_SPACE_ESSENCE = Account.getAccountType() == Account.PREMIUM ? 300 : 200;
            Central.main.startInit();
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
      }
      
      public function amfDeleteCharacterPromptSecurity() : void
      {
         var _loc1_:int = 0;
         if(Central.main.accRegActiveStatus == Central.main.ACC_REG_ACTIVE_STATUS_ACTIVE)
         {
            _loc1_ = int(this.selectedCharSelectId);
            Central.main.showAmfLoading();
            Central.main.amfClient.service("CharacterDAO.requestDeleteCode",[Account.getAccountSessionKey(),_loc1_,Central.main.getHash(String(_loc1_))],this.onRequestDeleteCodeResult);
         }
         else
         {
            Central.main.showSecurityPasswordSignupInvitation(Central.main.langLib.get(1812),this.amfDeleteCharacter,this.hideDeleteCharacterPanel,true,true);
         }
      }
      
      private function onRequestDeleteCodeResult(param1:Object) : void
      {
         Central.main.hideAmfLoading();
         if(param1 == null || String(param1.status) == AMFData.STATUS_ERROR)
         {
            Central.main.showInfo(param1 == null ? "Something went wrong, please try again." : String(param1.error));
            this.gotoAndStop("idle");
            return;
         }
         this.showDeleteCodePrompt();
      }
      
      private function showDeleteCodePrompt() : void
      {
         Central.main.showSecurityPasswordConfirmation("Enter the confirmation code we sent to your email to delete this character.",this.amfDeleteCharacter,this.hideDeleteCharacterPanel,true);
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
         this.log_B = "1";
         Central.main.amfClient.service("CharacterDAO.deleteCharacter",[Account.getAccountSessionKey(),param1,_loc2_,_loc3_,String(this.log_A + this.log_B),Central.main.getHash(String(this.log_A + this.log_B))],this.onAmfDeleteCharacterResult);
      }
      
      private function onAmfDeleteCharacterResult(param1:Object) : void
      {
         Central.main.hideAmfLoading();
         if(String(param1.status) == AMFData.STATUS_ERROR)
         {
            Central.main.onError(String(param1.error));
            return;
         }
         if(param1.msg)
         {
            switch(param1.msg)
            {
               case "wrong_code":
                  Central.main.showInfo(String(param1.error));
                  this.showDeleteCodePrompt();
                  return;
               case "code_expired":
                  Central.main.showInfo(String(param1.error));
                  break;
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
            Central.main.amfClient.service("CharacterDAO.getExtraData",[Account.getAccountSessionKey(),_loc2_,Central.main.ACCESS_TOKEN,this._cselKey],this.getExtraDataResult);
         }
         else
         {
            Out.error(this,"onAmfGetSystemDataResult :: parseSystemData failed");
         }
      }
      
      private function getExtraDataResult(param1:Object) : void
      {
         var extraData:Object = null;
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
         Central.main.initRank();
      }
      
      private function showExpired() : void
      {
         this["trialEmblemMC"].gotoAndPlay("show");
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
      
      internal function frame21() : *
      {
         this.onCreate();
      }
   }
}

