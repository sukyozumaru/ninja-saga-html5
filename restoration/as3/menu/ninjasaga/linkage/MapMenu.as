package ninjasaga.linkage
{
   import com.adobe.images.PNGEncoder;
   import com.adobe.utils.ArrayUtil;
   import com.utils.CreateFilter;
   import com.utils.Delegate;
   import com.utils.GF;
   import com.utils.MovieClipButton;
   import com.utils.NumberUtil;
   import com.utils.Out;
   import de.polygonal.ds.HashMap;
   import flash.display.BitmapData;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.display.StageQuality;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.filters.ColorMatrixFilter;
   import flash.filters.GlowFilter;
   import flash.geom.Rectangle;
   import flash.media.SoundMixer;
   import flash.media.SoundTransform;
   import flash.text.TextField;
   import flash.ui.Keyboard;
   import flash.utils.ByteArray;
   import flash.utils.Timer;
   import ninjasaga.Account;
   import ninjasaga.Central;
   import ninjasaga.Item;
   import ninjasaga.Skill;
   import ninjasaga.data.AMFData;
   import ninjasaga.data.AppData;
   import ninjasaga.data.BattleData;
   import ninjasaga.data.BloodlineData;
   import ninjasaga.data.ButtonData;
   import ninjasaga.data.DBCharacterData;
   import ninjasaga.data.Data;
   import ninjasaga.data.EnemyAttributeData;
   import ninjasaga.data.Formula;
   import ninjasaga.data.InventoryData;
   import ninjasaga.data.RankData;
   import ninjasaga.data.SkillData;
   import ninjasaga.data.Timeline;
   import ninjasaga.data.TitleData;
   import ninjasaga.data.TokenData;
   import ninjasaga.data.TooltipData;
   import ninjasaga.data.TrainingData;
   
   [SWF(width="960", height="550", backgroundColor="#333333", frameRate="24")]
   public class MapMenu extends MovieClip
   {
      
      public var btnSenjutsu:MovieClip;
      
      public var btnPet:MovieClip;
      
      public var rouletteBtn:MovieClip;
      
      public var pet:MovieClip;
      
      public var getMoreBtn:MovieClip;
      
      public var btnEquipment:MovieClip;
      
      public var characterStatus:MovieClip;
      
      public var popupPetUpgradeWithMat:MovieClip;
      
      public var inv_capacity:MovieClip;
      
      public var convertBtn:MovieClip;
      
      public var kunaiTxt:TextField;
      
      public var btnProfile:MovieClip;
      
      public var requestPopupBtn:MovieClip;
      
      public var dailyRouletteBtn:MovieClip;
      
      public var btnSoundOff:MovieClip;
      
      public var MtokenTxt:TextField;
      
      public var goldTxt:TextField;
      
      public var gold_tooltip:MovieClip;
      
      public var popupFeedPet:MovieClip;
      
      public var btnSoundOn:MovieClip;
      
      public var equipmentPanel:MovieClip;
      
      public var btnClose:SimpleButton;
      
      public var token_tooltip:MovieClip;
      
      public var emblemDailygiftBtn:MovieClip;
      
      public var btnphoto2:MovieClip;
      
      public var photo:MovieClip;
      
      public var optionPanel:MovieClip;
      
      public var lbl_recruited:TextField;
      
      public var mailboxBtn:MovieClip;
      
      public var skillPanel:MovieClip;
      
      public var statusTxt:TextField;
      
      public var dailyLoginBtn:MovieClip;
      
      public var MusicPanel:MovieClip;
      
      public var btnPhoto:MovieClip;
      
      public var btnTalent:MovieClip;
      
      public var btnSkill:MovieClip;
      
      public var tokenTxt:TextField;
      
      public var petUpgrade:MovieClip;
      
      public var btnInGameNotice:MovieClip;
      
      public var dailyTaskMc:MovieClip;
      
      public var dailyScartchBtn:MovieClip;
      
      public var inviteFriendBtn:MovieClip;
      
      public var dailyWallfeedMc:MovieClip;
      
      public var getMoreMBtn:MovieClip;
      
      public var chatInputMc:MovieClip;
      
      public var profile:MovieClip;
      
      public var TokenTooltip:MovieClip;
      
      public var MCoin_Icon:MovieClip;
      
      public var lvStatusBar:MovieClip;
      
      public var recruitedTxt:TextField;
      
      public var giftBtn:MovieClip;
      
      public var MCoin_bg:MovieClip;
      
      public var kunai_tooltip:MovieClip;
      
      public var btnOption:MovieClip;
      
      private const CHARACTER_SCALE:Number = 1;
      
      private var learn_Type:String = "";
      
      private var isSave:Boolean = false;
      
      private var isAPChange:Boolean = false;
      
      private var charHead:MovieClip;
      
      private var tradtradid:String;
      
      private var invTxtArr:Array = Central.main.langLib.get(1804);
      
      private var glowFilter:GlowFilter = CreateFilter.getGlowFilter({"strength":12});
      
      private var dimFilter:ColorMatrixFilter = CreateFilter.getSaturationFilter(0);
      
      private var goFromProfile:Boolean = false;
      
      private const INC_BUTTONS:Array = ["WIND","FIRE","LIGHTNING","EARTH","WATER"];
      
      private const accessoryChanged:Array = ["acsy1"];
      
      private const accessoryCriticalDodgeChanged:Array = ["acsy1","acsy2"];
      
      private const INC_TOOLTIPS:Object = {
         "FIRE":Central.main.langLib.get(245),
         "WATER":Central.main.langLib.get(246),
         "WIND":Central.main.langLib.get(247),
         "LIGHTNING":Central.main.langLib.get(248),
         "EARTH":Central.main.langLib.get(249)
      };
      
      private const TOOLTIP_BUTTONS:Array = ["wind","fire","lightning","earth","water","agility","critical","dodge","ap"];
      
      private const ATTRIBUTE_TOOLTIPS:Object = {
         "fire":Central.main.langLib.get(245),
         "water":Central.main.langLib.get(246),
         "wind":Central.main.langLib.get(247),
         "lightning":Central.main.langLib.get(248),
         "earth":Central.main.langLib.get(249),
         "agility":Central.main.langLib.get(250),
         "critical":Central.main.langLib.get(251),
         "dodge":Central.main.langLib.get(252),
         "ap":Central.main.langLib.get(253)
      };
      
      private var tempNameSpace:String = "";
      
      private const skillProfileBtn:Array = ["idle","nextElement","wind","fire","lightning","earth","water"];
      
      private const telentBtn:Array = ["learnExTalent","learnSecretTalent","extremeTalent","secretTalent","mirrorEye","eight","darkEye","deadBone","demonSound","lava","shadow","forest","ice","bl10","bl11"];
      
      private const upgradeArr:Array = ["hp","cp","ap"];
      
      private var upgradeTrainingTimer:Timer = new Timer(1000);
      
      private const SKILL_PER_PAGE:uint = 12;
      
      private const SKILL_TYPE_BUTTONS:Array = ["btnWind","btnFire","btnLightning","btnEarth","btnWater","btnTaijutsu","btnGenjutsu"];
      
      private const ALL_NINJUTSU_TYPES:Array = ["wind","fire","lightning","earth","water","taijutsu","genjutsu"];
      
      private const SKILL_TYPE_BUTTONS_NAME:Array = [ButtonData.WIND,ButtonData.FIRE,ButtonData.THUNDER,ButtonData.EARTH,ButtonData.WATER,ButtonData.TAIJUTSU,ButtonData.GENJUTSU];
      
      private var isSelectBtn:Boolean;
      
      private var isSelectBtnPress:Boolean;
      
      private var selectedSkillButton:MovieClip;
      
      private var selectedSkill:Object;
      
      private var selectedSkillType:String;
      
      private var selectedSkillTypeButton:MovieClip;
      
      private var loadedSwf:MovieClip;
      
      private var totalPage:int = 0;
      
      private var curPage:int = 1;
      
      private var trainingTimer:Timer;
      
      private var learnFromFriendSkill:Object;
      
      private var firstUpdateProgress:Boolean = true;
      
      private const CHAR_GENDER:int = int(Central.main.getMainChar().getGender());
      
      private const EQUIPMENT_PER_PAGE:int = 10;
      
      private const TEXT_BACKITEM_UNEQUIP:String = "back0";
      
      private const TEXT_ACCESSORY_UNEQUIP:String = "acsy0";
      
      private const BTN_TRADING:String = "btnTrading";
      
      private const BTN_WEAPON:String = "btnWeapon";
      
      private const BTN_CLOTHING:String = "btnBodySet";
      
      private const BTN_BACKITEM:String = "btnBackitem";
      
      private const BTN_ACCESSORY:String = "btnAccessory";
      
      private const BTN_ITEM:String = "btnItem";
      
      private const BTN_ESSENCE:String = "btnEssence";
      
      private const BTN_MATERIAL:String = "btnMaterial";
      
      private const BTN_PET:String = "btnPet";
      
      private var menuTabArr:Array = [];
      
      private var curEquipmentType:String = "";
      
      private var curDataList:Object = {};
      
      private var charInvArr:Array = [];
      
      private var charEquipArr:Array = [];
      
      private var selectedEquipment:Object = {};
      
      private var totalEquipmentPage:int = 0;
      
      private var curEquipmentPage:int = 1;
      
      private var specialItemArr:Array = [];
      
      private var checkShowSpecialPopup:Boolean = false;
      
      private const QUALITY_ARR:Array = [StageQuality.LOW,StageQuality.MEDIUM,StageQuality.HIGH,StageQuality.BEST];
      
      private var petStorage:HashMap = new HashMap();
      
      private var PetTraingold:String = "";
      
      private var PetTrainToken:int;
      
      private var PetTrainmagatamaData:Object = {};
      
      private var PetTrainmaterialData:Object = {};
      
      private var PetTrainmaterial634:int = 0;
      
      private var PetTrainmaterial635:int = 0;
      
      private var PetTrainmaterialDataArr:Array = [];
      
      public var Public_petSkillData:Array;
      
      private var handlingSkillId:int;
      
      private var selectedPetSlot:int;
      
      private var selectedPetID:uint;
      
      private var currentPet:*;
      
      private var petArray:Array = [];
      
      public var trainSuccess:Boolean = false;
      
      private var connectingAmf:Boolean = false;
      
      private var disableFilter:ColorMatrixFilter = CreateFilter.getSaturationFilter(0);
      
      private var disableFilter2:ColorMatrixFilter = CreateFilter.getBrightnessFilter(0.4);
      
      private const allButtonArr:Array = ["btnProfile","btnPet","btnEquipment","btnSkill","btnTalent","btnSenjutsu","btnOption","btnSoundOn","btnSoundOff","btnInGameNotice"];
      
      private const buttonNameArr:Array = [ButtonData.CHARACTERPROFILE,ButtonData.PETS,ButtonData.GEAR,ButtonData.JUTSU,ButtonData.TALENT,ButtonData.SENJUTSU,ButtonData.OPTION,"",""];
      
      private var buttonArr:Array = ["btnProfile","btnPet","btnEquipment","btnSkill","btnTalent","btnSenjutsu","btnOption","btnSoundOn","btnSoundOff","btnInGameNotice"];
      
      private const MENU_BUTTON_OFFSET:int = 10;
      
      private var isAllSoundOn:Boolean = true;
      
      private var petDataArr:Array;
      
      private var petObj:Object;
      
      private var upgradeGrounp:Array = [];
      
      private var petLineId:Array = [];
      
      private var petLineLv:Array = [];
      
      private var petLineObj:Array = [];
      
      private var petLineSwfObj:Object;
      
      private var curPetDataId:String = "";
      
      private var curUpgradePetIndex:int;
      
      private var isShowPetLinePromote:Boolean = false;
      
      public var preSelectClsName:String = "";
      
      internal var changedPetName:Boolean = false;
      
      internal var canUpgradePet:Boolean = true;
      
      private var invBtnName:String = "";
      
      private var inv_token:int = 100;
      
      private var inv_addTime:int = 1;
      
      private var invNameCapAdd:uint = 0;
      
      private var invNameCapMax:uint = 0;
      
      private var invName:String = "Weapon";
      
      private var invNameCap:int = Data.INV_SPACE_WEAPON;
      
      private var invNameCapNum:uint = 0;
      
      private var invNameCapMaxNum:uint = 0;
      
      private var invDisplayName:String = "";
      
      private var tmpCharInvArr:Array = [];
      
      private var tmp_invBtnName:String = "";
      
      private var invFirstTime:Boolean = false;
      
      private var feedPet:Boolean = false;
      
      private var combineMaturity:int = 0;
      
      private var petMaxEP:int = 0;
      
      private const THISCHAR_LV:int = int(Central.main.getMainChar().getLevel());
      
      private var log_A:String = "0";
      
      private var log_B:String = "0";
      
      private var musicNameList:Array = Central.main.langLib.get(1838);
      
      private var topMusicIndex:int = 0;
      
      private const SLOT_IN_MUSIC_PLAYER:int = 3;
      
      private var mouseEnterPoint:int = 0;
      
      private var volumeBarCurrentWidth:int = 0;
      
      private var updateMusicBarTimer:Timer;
      
      private var uploadSoundDataTimer:Timer;
      
      private var soundDataArr:Array = new Array(3);
      
      private var SkipSkillArr:Array = [392];
      
      private var trainingLV:Array = new Array(0,0,0);
      
      private var potion:Array = new Array(0,5,8);
      
      private var currentUpgrade:int = 0;
      
      private var timeRemain:int = 35220;
      
      private var timeRemainMin:int = 0;
      
      private var isTraining:Boolean = false;
      
      private var nowDisplay:int = 0;
      
      private var barPosition:Array = new Array();
      
      public function MapMenu()
      {
         super();
         addFrameScript(0,this.frame1,6,this.frame7,10,this.frame11,15,this.frame16,20,this.frame21,26,this.frame27,31,this.frame32,36,this.frame37,39,this.frame40);
         Out.debug(this,"MapMenu::MapMenu");
         this.tabEnabled = false;
         this.tabChildren = false;
         var soundTransform:SoundTransform = SoundMixer.soundTransform;
         this.isAllSoundOn = soundTransform.volume == 0 ? false : true;
         this.soundDataArr[0] = Central.main.currentMusicIndex;
         this.soundDataArr[1] = Central.main.mixer.getVolume();
         this.soundDataArr[2] = SoundMixer.soundTransform.volume;
      }
      
      public function init() : void
      {
         Out.debug(this,"MapMenu::init");
         if(Central.main.getMainChar().getData(DBCharacterData.RANK) >= RankData.TUTOR)
         {
            Central.main.senjutsuFeature = true;
            this["characterStatus"].gotoAndStop("status2");
         }
         else
         {
            this["characterStatus"].gotoAndStop("status1");
         }
      }
      
      public function initHead() : void
      {
         Out.debug(this,"MapMenu::initHead");
         this.charHead = Central.main.getMainChar().getHead();
         this["characterStatus"]["frame_1"]["headHolder"].addChild(this.charHead);
         this["characterStatus"]["frame_1"]["nameTxt"].text = Central.main.getMainChar().getCharacterName();
         if(Central.main.senjutsuFeature)
         {
            Central.main.senninModeBtn = this["characterStatus"]["senninModeBtn"];
            this["characterStatus"]["senninModeBtn"]["magatamaBtn"].stop();
            this["characterStatus"]["senninModeBtn"]["magatamaBtn"]["clickMask"].buttonMode = true;
            this["characterStatus"]["senninModeBtn"]["magatamaBtn"].addEventListener(MouseEvent.MOUSE_OUT,function(e:MouseEvent):*
            {
               e.currentTarget.gotoAndStop(1);
            });
            this["characterStatus"]["senninModeBtn"]["magatamaBtn"].addEventListener(MouseEvent.MOUSE_OVER,function(e:MouseEvent):*
            {
               e.currentTarget.gotoAndStop(2);
            });
            this["characterStatus"]["senninModeBtn"]["magatamaBtn"].gotoAndStop(1);
            if(Central.main.checkGameStatus() == Timeline.BATTLE)
            {
               Central.main.senninModeBtn.visible = true;
               Central.main.senninModeBtn.mouseEnabled = true;
            }
            else
            {
               Central.main.senninModeBtn.visible = false;
               Central.main.senninModeBtn.mouseEnabled = false;
            }
         }
      }
      
      public function show(name:String) : void
      {
         Out.debug(this,"MapMenu::show");
         if(name != Timeline.SKILL)
         {
            this.stopTrainingTimer();
         }
         this.gotoAndStop(name);
      }
      
      public function enable() : void
      {
         var i:uint = 0;
         Out.debug(this,"MapMenu::enable");
         this.visibleMenuButton();
         for(i = 0; i < this.buttonArr.length; i++)
         {
            if(this.buttonArr[i] == "")
            {
               this[this.allButtonArr[i]].visible = false;
            }
            else
            {
               this[this.allButtonArr[i]].visible = true;
               if(this.buttonArr[i] == "btnPet" && Central.main.getMainChar().pets.length == 0)
               {
                  if(Central.main.checkGameStatus() == Timeline.BATTLE)
                  {
                     this[this.buttonArr[i]].enabled = false;
                     this[this.buttonArr[i]].filters = [this.disableFilter];
                  }
                  else
                  {
                     this[this.buttonArr[i]].enabled = true;
                     this[this.buttonArr[i]].filters = null;
                     Central.main.disableButton(this[this.buttonArr[i]],this.onMenuBtn,this.buttonNameArr[i]);
                     Central.main.initButton(this[this.buttonArr[i]],this.onMenuBtnSpecial,this.buttonNameArr[i]);
                     Central.main.showDynamicTooltip(this[this.buttonArr[i]],String("<font size=\'16\'>" + String(Central.main.langLib.get(1649)[50]) + "</font>"));
                  }
               }
               else if(this.buttonArr[i] == "btnTalent" && (int(Central.main.getMainChar().getData(DBCharacterData.RANK)) < RankData.JOUNIN || Central.main.getMainChar().getLevel() < 40 || !Central.main.Features.FEATURE_TALENT))
               {
                  this[this.buttonArr[i]].enabled = false;
                  this[this.buttonArr[i]].filters = [this.disableFilter];
                  Central.main.disableButton(this[this.buttonArr[i]],this.onMenuBtn,this.buttonNameArr[i]);
                  Central.main.disableButton(this[this.buttonArr[i]],this.onMenuBtnSpecial,this.buttonNameArr[i]);
                  Central.main.showDynamicTooltip(this[this.buttonArr[i]],String("<font size=\'16\'>" + Central.main.langLib.get(1528) + "</font>"));
               }
               else if(this.buttonArr[i] == "btnSoundOn")
               {
                  this[this.buttonArr[i]].enabled = false;
                  this[this.buttonArr[i]].filters = null;
                  if(this.isAllSoundOn)
                  {
                     this[this.buttonArr[i]].visible = true;
                     Central.main.initButton(this[this.buttonArr[i]],this.onMenuBtn,this.buttonNameArr[i]);
                  }
                  else
                  {
                     this[this.buttonArr[i]].visible = false;
                     Central.main.disableButton(this[this.buttonArr[i]],this.onMenuBtn,this.buttonNameArr[i]);
                  }
               }
               else if(this.buttonArr[i] == "btnSoundOff")
               {
                  this[this.buttonArr[i]].enabled = false;
                  this[this.buttonArr[i]].filters = null;
                  if(this.isAllSoundOn)
                  {
                     this[this.buttonArr[i]].visible = false;
                     Central.main.disableButton(this[this.buttonArr[i]],this.onMenuBtn,this.buttonNameArr[i]);
                  }
                  else
                  {
                     this[this.buttonArr[i]].visible = true;
                     Central.main.initButton(this[this.buttonArr[i]],this.onMenuBtn,this.buttonNameArr[i]);
                  }
               }
               else
               {
                  this[this.buttonArr[i]].enabled = true;
                  this[this.buttonArr[i]].filters = null;
                  Central.main.disableButton(this[this.buttonArr[i]],this.onMenuBtnSpecial,this.buttonNameArr[i]);
                  if(Central.main.checkGameStatus() == Timeline.BATTLE)
                  {
                     if(this.buttonArr[i] == "btnEquipment" || this.buttonArr[i] == "btnOption")
                     {
                        Central.main.initButton(this[this.buttonArr[i]],this.onMenuBtn,this.buttonNameArr[i]);
                     }
                     else
                     {
                        this[this.buttonArr[i]].enabled = false;
                        this[this.buttonArr[i]].filters = [this.disableFilter];
                     }
                  }
                  else
                  {
                     Central.main.initButton(this[this.buttonArr[i]],this.onMenuBtn,this.buttonNameArr[i]);
                  }
                  Central.main.hideDynamicTooltip(this[this.buttonArr[i]]);
               }
            }
         }
         Central.main.proc.displayRouletteButton();
         this["lbl_recruited"].text = Central.main.langLib.titleTxt(TitleData.TEAM);
      }
      
      public function visibleMenuButton() : void
      {
         var i:int = 0;
         Out.debug(this,"MapMenu::visibleMenuButton");
         var tmpButtonArr:Array = new Array();
         for(i = 0; i < this.allButtonArr.length; i++)
         {
            switch(this.allButtonArr[i])
            {
               case "btnPet":
                  if((Central.main.getMainChar().getLevel() < Central.main.DISPLAY_LEVEL_LIMIT_BUTTON_PET || Central.main.getMainChar().getData(DBCharacterData.RANK) <= RankData.GENIN) && Central.main.getMainChar().pets.length == 0)
                  {
                     this.buttonArr[i] = "";
                  }
                  else
                  {
                     this.buttonArr[i] = this.allButtonArr[i];
                     tmpButtonArr.push(this.allButtonArr[i]);
                  }
                  break;
               case "btnTalent":
                  if(Central.main.getMainChar().getLevel() < Central.main.DISPLAY_LEVEL_LIMIT_BUTTON_TALENT || Central.main.getMainChar().getData(DBCharacterData.RANK) <= RankData.GENIN)
                  {
                     this.buttonArr[i] = "";
                  }
                  else
                  {
                     this.buttonArr[i] = this.allButtonArr[i];
                     tmpButtonArr.push(this.allButtonArr[i]);
                  }
                  break;
               case "btnClass":
                  if(Central.main.getMainChar().getLevel() < Central.main.DISPLAY_LEVEL_LIMIT_BUTTON_CLASS || Central.main.getMainChar().getData(DBCharacterData.RANK) <= RankData.GENIN)
                  {
                     this.buttonArr[i] = "";
                  }
                  else
                  {
                     this.buttonArr[i] = this.allButtonArr[i];
                     tmpButtonArr.push(this.allButtonArr[i]);
                  }
                  break;
               case "btnSenjutsu":
                  if(Central.main.getMainChar().getLevel() < Central.main.DISPLAY_LEVEL_LIMIT_BUILDING_SNEJUTSU_HILL || Central.main.getMainChar().getData(DBCharacterData.RANK) < RankData.TUTOR)
                  {
                     this.buttonArr[i] = "";
                  }
                  else
                  {
                     this.buttonArr[i] = this.allButtonArr[i];
                     tmpButtonArr.push(this.allButtonArr[i]);
                  }
                  break;
               case "btnSoundOn":
                  break;
               case "btnSoundOff":
                  break;
               case "btnInGameNotice":
                  if(Central.main.getMainChar().getLevel() < 5)
                  {
                     this.buttonArr[i] = "";
                  }
                  else
                  {
                     this.buttonArr[i] = this.allButtonArr[i];
                     tmpButtonArr.push(this.allButtonArr[i]);
                  }
                  break;
               default:
                  tmpButtonArr.push(this.allButtonArr[i]);
            }
         }
         Central.main.shiftBtnPos(this,tmpButtonArr,Central.main.SHIFT_X_RIGHT_TO_LEFT,this.MENU_BUTTON_OFFSET);
      }
      
      private function disableButton(btn:*, fn:Function, txt:String = null) : void
      {
         Out.debug(this,"MapMenu::disableButton");
         btn.stop();
         btn["clickMask"].buttonMode = false;
         btn.gotoAndStop(1);
         if(btn.hasEventListener(MouseEvent.MOUSE_OUT))
         {
            btn.removeEventListener(MouseEvent.MOUSE_OUT,function(e:MouseEvent):*
            {
               e.currentTarget.gotoAndStop(1);
            });
         }
         btn.addEventListener(MouseEvent.MOUSE_OUT,function(e:MouseEvent):*
         {
            e.currentTarget.gotoAndStop(1);
         });
         if(btn.hasEventListener(MouseEvent.MOUSE_OVER))
         {
            btn.removeEventListener(MouseEvent.MOUSE_OVER,function(e:MouseEvent):*
            {
               e.currentTarget.gotoAndStop(2);
            });
         }
         btn.addEventListener(MouseEvent.MOUSE_OVER,function(e:MouseEvent):*
         {
            e.currentTarget.gotoAndStop(1);
         });
         if(btn.hasEventListener(MouseEvent.CLICK))
         {
            btn.removeEventListener(MouseEvent.CLICK,fn);
         }
         if(txt != null && txt != "")
         {
            btn["txt"].text = Central.main.langLib.btnTxt(txt);
         }
      }
      
      public function hide(evt:MouseEvent = null) : void
      {
         var tmpEffect:Object = null;
         var rNum:Number = NaN;
         var i:int = 0;
         var mainCharBackItem:Object = null;
         var mainCharAccessory:Object = null;
         Out.debug(this,"MapMenu::hide");
         if(Central.main.isPopupType == "gear")
         {
            Central.main.isPopupType = "";
         }
         if(this.trainSuccess)
         {
            Central.main.updateMapSideBtn();
         }
         if(this.goFromProfile)
         {
            this.goFromProfile = false;
            this.gotoAndPlay(Timeline.PROFILE);
            return;
         }
         Central.main.getMainChar().customizeCharacter();
         switch(Central.main.checkGameStatus())
         {
            case Timeline.BATTLE:
               Central.battle.restoreMainChar();
               break;
            case Timeline.MAP_MISSION:
               Central.main.restoreMapMissionChar();
               break;
            case Timeline.ENGAGE:
               Central.main.restoreEngageChar();
         }
         if(this.isSave)
         {
            Central.main.updateMenu();
            Central.main.getMainChar().equipCharacter();
            if(Central.main.getMainChar().getBackItem())
            {
               mainCharBackItem = Central.main.BACK_ITEM_DATA.find(Central.main.getMainChar().getBackItem());
               if(mainCharBackItem)
               {
                  for each(tmpEffect in mainCharBackItem.effect)
                  {
                     switch(tmpEffect.type)
                     {
                        case BattleData.EFFECT_MAX_HP_PRESENT:
                           if(NumberUtil.getRandom() <= tmpEffect.chance / 100)
                           {
                              if(Central.main.checkGameStatus() != Timeline.BATTLE)
                              {
                                 Central.main.getMainChar().updateHP(Central.main.getMainChar().hp * (tmpEffect.amount / 100));
                              }
                           }
                           break;
                        case BattleData.EFFECT_MAX_HP_FIX_NUM:
                           if(NumberUtil.getRandom() <= tmpEffect.chance / 100)
                           {
                              if(Central.main.checkGameStatus() != Timeline.BATTLE)
                              {
                                 Central.main.getMainChar().updateHP(tmpEffect.amount);
                              }
                           }
                           break;
                        case BattleData.EFFECT_MAX_CP_PRESENT:
                           if(NumberUtil.getRandom() <= tmpEffect.chance / 100)
                           {
                              if(Central.main.checkGameStatus() != Timeline.BATTLE)
                              {
                                 Central.main.getMainChar().updateCP(Central.main.getMainChar().cp * (tmpEffect.amount / 100));
                              }
                           }
                     }
                  }
               }
            }
            if(Central.main.getMainChar().getAccessory())
            {
               mainCharAccessory = Central.main.ACCESSORY_DATA.find(Central.main.getMainChar().getAccessory());
               if(mainCharAccessory)
               {
                  for each(tmpEffect in mainCharAccessory.effect)
                  {
                     switch(tmpEffect.type)
                     {
                        case BattleData.EFFECT_MAX_HP_PRESENT:
                           if(NumberUtil.getRandom() <= tmpEffect.chance / 100)
                           {
                              if(Central.main.checkGameStatus() != Timeline.BATTLE)
                              {
                                 Central.main.getMainChar().updateHP(Central.main.getMainChar().hp * (tmpEffect.amount / 100));
                              }
                           }
                           break;
                        case BattleData.EFFECT_MAX_CP_PRESENT:
                           if(NumberUtil.getRandom() <= tmpEffect.chance / 100)
                           {
                              if(Central.main.checkGameStatus() != Timeline.BATTLE)
                              {
                                 Central.main.getMainChar().updateCP(Central.main.getMainChar().cp * (tmpEffect.amount / 100));
                              }
                           }
                     }
                  }
               }
            }
            this.isSave = false;
         }
         if(this.isAPChange)
         {
            Central.main.updateMenu();
            Central.main.getMainChar().updateAP();
            this.isAPChange = false;
         }
         this.stopTrainingTimer();
         this.gotoAndStop(Timeline.IDLE);
         if(Boolean(this.checkShowSpecialPopup == true) && Boolean(Central.main.battleModeSpecial) && Central.main.battleModeSpecial == true)
         {
            this.checkShowSpecialPopup = false;
            Central.main.showPopupSpecialHpBar(Central.battle.specialHpData);
         }
         if(Central.mission.curMissionID == null)
         {
            if(Central.main.challengeFriendUID == null)
            {
               Central.main.getMainChar().checkLvUpReward();
            }
         }
      }
      
      public function disable() : void
      {
         Out.debug(this,"MapMenu::disable");
         for(var i:uint = 0; i < this.buttonArr.length; i++)
         {
            if(this.buttonArr[i] == "")
            {
               this[this.allButtonArr[i]].visible = false;
            }
            else
            {
               this[this.allButtonArr[i]].visible = true;
               this[this.buttonArr[i]].enabled = false;
               this[this.buttonArr[i]].filters = [this.disableFilter];
               this.disableButton(this[this.buttonArr[i]],this.onMenuBtn,this.buttonNameArr[i]);
            }
         }
         this["dailyRouletteBtn"].visible = false;
      }
      
      public function hideLvStatusBar() : void
      {
         Out.debug(this,"hideLvStatusBar");
         if(this["lvStatusBar"])
         {
            this["lvStatusBar"].visible = false;
         }
      }
      
      public function updateLvStatusBar() : void
      {
         var barMc:MovieClip = null;
         var char_lv:int = 0;
         var frameId:int = 0;
         var displayLv:int = 0;
         var str:String = null;
         Out.debug(this,"updateLvStatusBar");
         if(this["lvStatusBar"])
         {
            barMc = this["lvStatusBar"]["bar"];
            char_lv = int(Central.main.getMainChar().getLevel());
            str = "";
            barMc["txt"].text = "";
            this["lvStatusBar"].visible = false;
            if(char_lv >= 1 && char_lv <= 20 && Central.main.getMainChar().getData(DBCharacterData.RANK) == 1)
            {
               this["lvStatusBar"].visible = true;
               displayLv = 20 - char_lv;
               barMc.gotoAndStop("lv" + char_lv);
               barMc["iconBase"].gotoAndStop("rank" + Central.main.getMainChar().getData(DBCharacterData.RANK));
               barMc["icon"].gotoAndStop("rank2");
               if(displayLv == 0)
               {
                  if(Central.main.Features.EXAM_CHUNIN)
                  {
                     str = Central.main.langLib.get(1459);
                  }
                  else
                  {
                     str = "";
                  }
               }
               else
               {
                  str = String(Central.main.langLib.get(1460)).replace("[valprogress]",displayLv.toString()).replace("[valrank]","");
               }
               barMc["txt"].text = str;
               barMc["rankbasetxt"].text = Central.main.langLib.titleTxt(TitleData.RANK_GENIN);
               barMc["ranktxt"].text = Central.main.langLib.titleTxt(TitleData.RANK_CHUNIN);
               if(Central.main.Features.EXAM_CHUNIN)
               {
                  Central.main.showDynamicTooltip(this["lvStatusBar"],String("<font size=\'16\'>" + Central.main.langLib.get(1461) + "</font>"));
               }
            }
            else if(char_lv >= 20 && char_lv <= 40 && (Central.main.getMainChar().getData(DBCharacterData.RANK) == 2 || Central.main.getMainChar().getData(DBCharacterData.RANK) == 3))
            {
               this["lvStatusBar"].visible = true;
               frameId = 20 - char_lv;
               frameId = Math.abs(frameId);
               displayLv = 40 - char_lv;
               barMc.gotoAndStop("lv" + frameId);
               barMc["iconBase"].gotoAndStop("rank" + Central.main.getMainChar().getData(DBCharacterData.RANK));
               barMc["icon"].gotoAndStop("rank4");
               if(displayLv == 0)
               {
                  if(Central.main.Features.EXAM_JOUNIN)
                  {
                     str = Central.main.langLib.get(1459);
                  }
                  else
                  {
                     str = "";
                  }
               }
               else
               {
                  str = String(Central.main.langLib.get(1460)).replace("[valprogress]",displayLv.toString()).replace("[valrank]","");
               }
               barMc["txt"].text = str;
               barMc["rankbasetxt"].text = Central.main.langLib.titleTxt(TitleData.RANK_CHUNIN);
               barMc["ranktxt"].text = Central.main.langLib.titleTxt(TitleData.RANK_JOUNIN);
               if(Central.main.Features.EXAM_JOUNIN)
               {
                  Central.main.showDynamicTooltip(this["lvStatusBar"],String("<font size=\'16\'>" + Central.main.langLib.get(1462) + "</font>"));
               }
            }
            else if(char_lv >= 40 && char_lv <= 60 && (Central.main.getMainChar().getData(DBCharacterData.RANK) == 4 || Central.main.getMainChar().getData(DBCharacterData.RANK) == 5))
            {
               this["lvStatusBar"].visible = true;
               frameId = 40 - char_lv;
               frameId = Math.abs(frameId);
               displayLv = 60 - char_lv;
               barMc.gotoAndStop("lv" + frameId);
               barMc["iconBase"].gotoAndStop("rank" + Central.main.getMainChar().getData(DBCharacterData.RANK));
               if(Central.main.dayleft > 0)
               {
                  barMc["icon"].gotoAndStop("rank7");
               }
               else
               {
                  barMc["icon"].gotoAndStop("rank6");
               }
               if(displayLv == 0)
               {
                  if(Central.main.Features.EXAM_S_JOUNIN)
                  {
                     str = Central.main.langLib.get(1459);
                  }
                  else
                  {
                     str = "";
                  }
               }
               else
               {
                  str = String(Central.main.langLib.get(1460)).replace("[valprogress]",displayLv.toString()).replace("[valrank]","");
               }
               barMc["rankbasetxt"].text = Central.main.langLib.titleTxt(TitleData.RANK_JOUNIN);
               if(Central.main.dayleft > 0)
               {
                  barMc["ranktxt"].text = Central.main.langLib.titleTxt(TitleData.RANK_TENSAI_SPECIAL_JOUNIN);
               }
               else
               {
                  barMc["ranktxt"].text = Central.main.langLib.titleTxt(TitleData.RANK_SPECIAL_JOUNIN);
               }
               barMc["txt"].text = str;
               if(Central.main.Features.EXAM_S_JOUNIN)
               {
                  Central.main.showDynamicTooltip(this["lvStatusBar"],String("<font size=\'16\'>" + Central.main.langLib.get(1463) + "</font>"));
               }
            }
            else if(char_lv >= 60 && char_lv <= 80 && (Central.main.getMainChar().getData(DBCharacterData.RANK) == 6 || Central.main.getMainChar().getData(DBCharacterData.RANK) == 7))
            {
               this["lvStatusBar"].visible = true;
               frameId = 60 - char_lv;
               frameId = Math.abs(frameId);
               displayLv = 80 - char_lv;
               barMc.gotoAndStop("lv" + frameId);
               barMc["iconBase"].gotoAndStop("rank" + Central.main.getMainChar().getData(DBCharacterData.RANK));
               if(Central.main.dayleft > 0)
               {
                  barMc["icon"].gotoAndStop("rank9");
               }
               else
               {
                  barMc["icon"].gotoAndStop("rank8");
               }
               if(displayLv == 0)
               {
                  if(Central.main.Features.EXAM_S_JOUNIN)
                  {
                     str = Central.main.langLib.get(1459);
                  }
                  else
                  {
                     str = "";
                  }
               }
               else
               {
                  str = String(Central.main.langLib.get(1460)).replace("[valprogress]",displayLv.toString()).replace("[valrank]","");
               }
               if(Central.main.getMainChar().getData(DBCharacterData.RANK) == 7)
               {
                  barMc["rankbasetxt"].text = Central.main.langLib.titleTxt(TitleData.RANK_TENSAI_SPECIAL_JOUNIN);
               }
               else
               {
                  barMc["rankbasetxt"].text = Central.main.langLib.titleTxt(TitleData.RANK_SPECIAL_JOUNIN);
               }
               if(Central.main.senninDayLeft > 0)
               {
                  barMc["ranktxt"].text = Central.main.langLib.titleTxt(TitleData.RANK_TUTOR_SENIOR);
               }
               else
               {
                  barMc["ranktxt"].text = Central.main.langLib.titleTxt(TitleData.RANK_TUTOR);
               }
               barMc["txt"].text = str;
               Central.main.showDynamicTooltip(this["lvStatusBar"],String("<font size=\'16\'>" + Central.main.langLib.get(1854) + "</font>"));
            }
            this["lvStatusBar"].addEventListener(MouseEvent.CLICK,this.onClickExam);
         }
      }
      
      private function onClickExam(evt:MouseEvent) : void
      {
         Out.debug(this,"MapMenu::onClickExam");
         var char_lv:int = int(Central.main.getMainChar().getData(DBCharacterData.LEVEL));
         if(char_lv == 20 && Central.main.getMainChar().getData(DBCharacterData.RANK) == 1)
         {
            Central.panel.getInstance().show("chuninPanel_exam");
         }
         else if(char_lv == 40 && (Central.main.getMainChar().getData(DBCharacterData.RANK) == 2 || Central.main.getMainChar().getData(DBCharacterData.RANK) == 3))
         {
            Central.panel.getInstance().show("jouninPanel_exam");
         }
         else if(char_lv == 60 && (Central.main.getMainChar().getData(DBCharacterData.RANK) == 4 || Central.main.getMainChar().getData(DBCharacterData.RANK) == 5))
         {
            Central.panel.getInstance().show("special_exam");
         }
         else if(char_lv <= 80 && (Central.main.getMainChar().getData(DBCharacterData.RANK) == 6 || Central.main.getMainChar().getData(DBCharacterData.RANK) == 7))
         {
            Central.panel.getInstance().show("Panel_lv80exam_battle");
         }
      }
      
      private function showLevelBar(evt:MouseEvent) : void
      {
         Out.debug(this,"MapMenu::showLevelBar");
      }
      
      public function update(updateDisplay:Boolean = true) : void
      {
         var isZh:Boolean = false;
         Out.debug(this,"update()");
         var mainChar:* = Central.main.getMainChar();
         var curFrame:MovieClip = this["characterStatus"]["frame_1"];
         mainChar.syncHp(mainChar.hp);
         mainChar.syncCp(mainChar.cp);
         curFrame["hpTxt"].text = mainChar.hp + " / " + mainChar.maxHP;
         curFrame["hpBar"].scaleX = mainChar.hp / mainChar.maxHP;
         curFrame["cpTxt"].text = mainChar.cp + " / " + mainChar.maxCP;
         curFrame["cpBar"].scaleX = mainChar.cp / mainChar.maxCP;
         if(Central.main.senjutsuFeature)
         {
            mainChar.syncSp(mainChar.sp);
            curFrame["spTxt"].text = mainChar.sp + " / " + mainChar.maxSP;
            curFrame["spBar"].scaleX = mainChar.sp / mainChar.maxSP;
         }
         curFrame["levelMc"]["txt"].text = mainChar.getLevel();
         if(updateDisplay)
         {
            this["goldTxt"].text = mainChar.getGold();
            curFrame["xpTxt"].text = mainChar.getData(DBCharacterData.XP) - Formula.getXpByLv(mainChar.getLevel()) + " / " + (Formula.getXpByLv(mainChar.getLevel() + 1) - Formula.getXpByLv(mainChar.getLevel()));
            curFrame["xpBar"].scaleX = (mainChar.getData(DBCharacterData.XP) - Formula.getXpByLv(mainChar.getLevel())) / (Formula.getXpByLv(mainChar.getLevel() + 1) - Formula.getXpByLv(mainChar.getLevel()));
         }
         if(!Central.main.isNewChar)
         {
            this["MtokenTxt"].text = String(Central.main.extraData.MCoin);
         }
         if(Central.main.getMainChar().getLevel() < 10)
         {
            this["MtokenTxt"].visible = false;
            this["MCoin_Icon"].visible = false;
            this["getMoreMBtn"].visible = false;
            this["MCoin_bg"].visible = false;
            this["token_tooltip"].visible = false;
         }
         if(!Central.main.isNewChar)
         {
            this["tokenTxt"].text = Central.main.extraData.totalToken + "(" + Account.getAccountBalance() + ")";
            Central.main.showDynamicTooltip(this["TokenTooltip"],"<font size=\'16\'>" + (isZh ? "總藍幣 \'" + Central.main.extraData.totalToken + "\' \n可用藍幣 \'" + Account.getAccountBalance() + "\'" : "Total Token \'" + Central.main.extraData.totalToken + "\' \nAvailable Token \'" + Account.getAccountBalance() + "\'") + "</font>");
         }
         else
         {
            this["tokenTxt"].text = Account.getAccountBalance();
         }
         isZh = AppData.lang == AppData.ZH;
         if(!this["convertBtn"].hasEventListener(MouseEvent.CLICK))
         {
            Central.main.initButton(this["convertBtn"],this.showConvertGold,null);
         }
         if(!this["getMoreBtn"].hasEventListener(MouseEvent.CLICK))
         {
            Central.main.initButton(this["getMoreBtn"],this.showPaymentGateway,null);
         }
         if(!this["getMoreMBtn"].hasEventListener(MouseEvent.CLICK))
         {
            Central.main.initButton(this["getMoreMBtn"],this.showBank,null);
         }
         var partyNpc:Array = Central.main.getPartyNpc();
         var partyMember:Array = Central.main.partyMembers;
         if(Boolean(partyNpc) && Boolean(partyMember))
         {
            this["recruitedTxt"].text = partyNpc.length + partyMember.length + "/2";
         }
         else if(partyNpc)
         {
            this["recruitedTxt"].text = partyNpc.length + "/2";
         }
         else if(partyMember)
         {
            this["recruitedTxt"].text = partyMember.length + "/2";
         }
         else
         {
            this["recruitedTxt"].text = "0/2";
         }
         mainChar.cloneHead(this.charHead);
      }
      
      private function showConvertGold(evt:MouseEvent) : *
      {
         Out.debug(this,"MapMenu::showConvertGold");
         Central.main.gotoTokenExGold();
      }
      
      private function showPaymentGateway(evt:MouseEvent) : void
      {
         Out.debug(this,"MapMenu::showPaymentGateway");
         Central.main.gotoPaymentGateway();
      }
      
      private function showBank(evt:MouseEvent) : void
      {
         Out.debug(this,"MapMenu::showBank");
         Central.panel.getInstance().show("Panel_tokenBank");
      }
      
      public function showDailyTask() : void
      {
         var mainChar:* = Central.main.getMainChar();
         var dailyTask:Object = mainChar.getInventory(InventoryData.TYPE_DAILY_TASK);
         if(Central.mission.checkDailyTaskStatus() > 0 && Central.main.checkGameStatus() == Timeline.MAP)
         {
            this["dailyTaskMc"].visible = true;
            this["dailyTaskMc"].buttonMode = true;
            this["dailyTaskMc"].addEventListener(MouseEvent.CLICK,Central.main.showDailyTask);
            if(Central.mission.checkDailyTaskStatus() == 1)
            {
               this["dailyTaskMc"]["giftMc"].gotoAndStop(1);
            }
            if(Central.mission.checkDailyTaskStatus() == 2)
            {
               this["dailyTaskMc"]["giftMc"].gotoAndStop(2);
            }
         }
         else
         {
            this["dailyTaskMc"].visible = false;
         }
      }
      
      public function hideDailyTask() : void
      {
         this["dailyTaskMc"].visible = false;
      }
      
      private function onMenuBtn(evt:MouseEvent) : void
      {
         var hasnotClassSkill:Boolean = false;
         this.goFromProfile = false;
         if(this.currentLabel != Timeline.SKILL)
         {
            this.stopTrainingTimer();
         }
         if(this.uploadSoundDataTimer == null)
         {
            this.resetUploadSoundDataTimer();
         }
         if(Boolean((evt.currentTarget.name == "btnOption" || evt.currentTarget.name == "btnEquipment") && this["btnEquipment"].enabled == true && Central.main.battleModeSpecial) && Boolean(Central.main.battleModeSpecial == true) && this.checkShowSpecialPopup == false)
         {
            this.checkShowSpecialPopup = true;
            Central.main.hidePopupSpecialHpBar();
         }
         switch(evt.currentTarget.name)
         {
            case "btnPhoto":
               if(this.currentLabel == Timeline.PHOTO)
               {
                  this.hide();
               }
               else
               {
                  this.gotoAndPlay(Timeline.PHOTO);
               }
               break;
            case "btnProfile":
               if(this.currentLabel == Timeline.PROFILE)
               {
                  this.hide();
               }
               else
               {
                  this.gotoAndPlay(Timeline.PROFILE);
               }
               break;
            case "btnPet":
               if(Central.main.checkGameStatus() == Timeline.BATTLE)
               {
                  Central.main.showInfo(Central.main.langLib.get(254));
                  return;
               }
               if(this.currentLabel == Timeline.PET)
               {
                  this.hide();
               }
               else
               {
                  this.gotoAndStop(Timeline.PET);
               }
               break;
            case "btnEquipment":
               if(this.currentLabel == Timeline.EQUIPMENT)
               {
                  this.hide();
               }
               else if(Central.battle.consumablesUsed < BattleData.CONSUMABLE_LIMIT || Central.battle.type == Central.battle.TYPE_LOCAL)
               {
                  this.gotoAndStop(Timeline.EQUIPMENT);
               }
               else
               {
                  Central.main.showInfo(String(Central.main.langLib.get(255)).replace("[valconsumablelimit]",BattleData.CONSUMABLE_LIMIT.toString()));
               }
               break;
            case "btnSkill":
               if(Central.main.checkGameStatus() == Timeline.BATTLE)
               {
                  Central.main.showInfo(Central.main.langLib.get(256));
                  return;
               }
               if(this.currentLabel == Timeline.SKILL)
               {
                  this.hide();
               }
               else
               {
                  this.gotoAndPlay(Timeline.SKILL);
               }
               break;
            case "btnOption":
               if(this.currentLabel == Timeline.OPTION)
               {
                  this.hide();
               }
               else
               {
                  this.gotoAndPlay(Timeline.OPTION);
               }
               break;
            case "btnTalent":
               if(Central.main.paymentStatus)
               {
                  Central.main.proc.showPaymentStatus();
               }
               else
               {
                  Central.panel.getInstance().show("bloodline_profile");
               }
               break;
            case "btnSoundOn":
            case "btnSoundOff":
               if(this.currentLabel == "music")
               {
                  this.hide();
               }
               else
               {
                  this.gotoAndPlay("music");
               }
               break;
            case "iconMC":
               if(Central.main.getMainChar().getData(DBCharacterData.CONTROL) == 0)
               {
                  hasnotClassSkill = true;
               }
               else
               {
                  hasnotClassSkill = false;
               }
               if(Central.main.getMainChar().getLevel() < 60 || Central.main.getMainChar().getData(DBCharacterData.RANK) < 6 || hasnotClassSkill)
               {
                  Central.main.showOk(Central.main.langLib.get(1770)[16]);
                  return;
               }
               Central.main.loadPopupPanel("Popup_Class_Change","ninjasaga.linkage.changeSPClassPanel");
               break;
            case "btnSenjutsu":
               Central.panel.getInstance().show("Panel_2014_Sage_Profile","install_toad_snake");
               break;
            case "btnInGameNotice":
               Central.main.loadPopupPanel("Popup_IngameNotice_Menu_2014","ninjasaga.linkage.IngameNoticeMenu2014");
         }
      }
      
      private function onMenuBtnSpecial(evt:MouseEvent) : void
      {
         switch(evt.currentTarget.name)
         {
            case "btnPet":
               if(Central.main.checkGameStatus() == Timeline.BATTLE)
               {
                  Central.main.showInfo(Central.main.langLib.get(254));
                  return;
               }
               Central.panel.getInstance().show("pet_shop");
         }
      }
      
      private function initCloseBtn() : void
      {
         if(!this["btnClose"].hasEventListener(MouseEvent.CLICK))
         {
            this["btnClose"].addEventListener(MouseEvent.CLICK,this.hide);
         }
         this.invFirstTime = true;
         this.invBtnName = this.BTN_WEAPON;
      }
      
      private function initProfileBtn() : void
      {
         var mc:MovieClip = this["profile"];
         mc["profileBtn"].removeEventListener(MouseEvent.CLICK,this.goProfile);
         mc["profileBtn"].removeEventListener(MouseEvent.ROLL_OVER,this.goProfile);
         mc["profileBtn"].removeEventListener(MouseEvent.ROLL_OUT,this.goProfile);
         mc["profileBtn"]["btn"].gotoAndStop(1);
         mc["profileBtn"].gotoAndStop("select");
         mc["profileBtn"].buttonMode = false;
         Central.main.showDynamicTooltip(mc["profileBtn"],String("<font size=\'16\'>" + Central.main.langLib.titleTxt(TitleData.PROFILE) + "</font>"));
         mc["upgradeBtn"].addEventListener(MouseEvent.CLICK,this.goUpgrade);
         mc["upgradeBtn"].addEventListener(MouseEvent.ROLL_OVER,this.goUpgrade);
         mc["upgradeBtn"].addEventListener(MouseEvent.ROLL_OUT,this.goUpgrade);
         mc["upgradeBtn"].gotoAndStop("unselect");
         mc["upgradeBtn"]["btn"].gotoAndStop(1);
         mc["upgradeBtn"].buttonMode = true;
         Central.main.showDynamicTooltip(mc["upgradeBtn"],String("<font size=\'16\'>" + Central.main.langLib.titleTxt(TitleData.PERSONAL_TRAINING) + "</font>"));
      }
      
      private function initUpgradeBtn() : void
      {
         var mc:MovieClip = this["profile"];
         mc["profileBtn"].addEventListener(MouseEvent.CLICK,this.goProfile);
         mc["profileBtn"].addEventListener(MouseEvent.ROLL_OVER,this.goProfile);
         mc["profileBtn"].addEventListener(MouseEvent.ROLL_OUT,this.goProfile);
         mc["profileBtn"]["btn"].gotoAndStop(1);
         mc["profileBtn"].gotoAndStop("unselect");
         mc["profileBtn"].buttonMode = true;
         Central.main.showDynamicTooltip(mc["profileBtn"],String("<font size=\'16\'>" + Central.main.langLib.titleTxt(TitleData.PROFILE) + "</font>"));
         mc["upgradeBtn"].removeEventListener(MouseEvent.CLICK,this.goUpgrade);
         mc["upgradeBtn"].removeEventListener(MouseEvent.ROLL_OVER,this.goUpgrade);
         mc["upgradeBtn"].removeEventListener(MouseEvent.ROLL_OUT,this.goUpgrade);
         mc["upgradeBtn"].gotoAndStop("select");
         mc["upgradeBtn"]["btn"].gotoAndStop(1);
         mc["upgradeBtn"].buttonMode = false;
         Central.main.showDynamicTooltip(mc["upgradeBtn"],String("<font size=\'16\'>" + Central.main.langLib.titleTxt(TitleData.PERSONAL_TRAINING) + "</font>"));
      }
      
      private function goUpgrade(e:MouseEvent) : void
      {
         var mc:MovieClip = this["profile"];
         switch(e.type)
         {
            case MouseEvent.CLICK:
               mc.gotoAndStop("upgrade");
               break;
            case MouseEvent.ROLL_OVER:
               e.currentTarget.btn.gotoAndStop(2);
               break;
            case MouseEvent.ROLL_OUT:
               e.currentTarget.btn.gotoAndStop(1);
         }
      }
      
      private function goProfile(e:MouseEvent) : void
      {
         var mc:MovieClip = this["profile"];
         switch(e.type)
         {
            case MouseEvent.CLICK:
               mc.gotoAndPlay("profile");
               break;
            case MouseEvent.ROLL_OVER:
               e.currentTarget.btn.gotoAndStop(2);
               break;
            case MouseEvent.ROLL_OUT:
               e.currentTarget.btn.gotoAndStop(1);
         }
      }
      
      private function closeProfile(evt:MouseEvent) : void
      {
         this.goFromProfile = false;
         this.hide();
      }
      
      private function closephoto(evt:MouseEvent) : void
      {
         this.hide();
      }
      
      public function onIdle() : void
      {
      }
      
      public function onProfile() : void
      {
         var i:uint = 0;
         this.stop();
         this["btnClose"].addEventListener(MouseEvent.CLICK,this.closeProfile);
         var mc:MovieClip = this["profile"];
         var mainChar:* = Central.main.getMainChar();
         if(AppData.type != AppData.RR)
         {
            mc["btnHelp"].visible = false;
         }
         this.goFromProfile = true;
         mc["rankIcon"].gotoAndStop(mainChar.getData(DBCharacterData.RANK));
         switch(mainChar.getData(DBCharacterData.RANK))
         {
            case 1:
               Central.main.showDynamicTooltip(mc["rankIcon"],String("<font size=\'16\'>" + Central.main.langLib.titleTxt(TitleData.RANK_GENIN) + "</font>"));
               break;
            case 2:
               Central.main.showDynamicTooltip(mc["rankIcon"],String("<font size=\'16\'>" + Central.main.langLib.titleTxt(TitleData.RANK_CHUNIN) + "</font>"));
               break;
            case 3:
               Central.main.showDynamicTooltip(mc["rankIcon"],String("<font size=\'16\'>" + Central.main.langLib.titleTxt(TitleData.RANK_TENSAI_CHUNIN) + "</font>"));
               break;
            case 4:
               Central.main.showDynamicTooltip(mc["rankIcon"],String("<font size=\'16\'>" + Central.main.langLib.titleTxt(TitleData.RANK_JOUNIN) + "</font>"));
               break;
            case 5:
               Central.main.showDynamicTooltip(mc["rankIcon"],String("<font size=\'16\'>" + Central.main.langLib.titleTxt(TitleData.RANK_TENSAI_JOUNIN) + "</font>"));
               break;
            case 6:
               Central.main.showDynamicTooltip(mc["rankIcon"],String("<font size=\'16\'>" + Central.main.langLib.titleTxt(TitleData.RANK_SPECIAL_JOUNIN) + "</font>"));
               break;
            case 7:
               Central.main.showDynamicTooltip(mc["rankIcon"],String("<font size=\'16\'>" + Central.main.langLib.titleTxt(TitleData.RANK_TENSAI_SPECIAL_JOUNIN) + "</font>"));
               break;
            case 8:
               Central.main.showDynamicTooltip(mc["rankIcon"],String("<font size=\'16\'>" + Central.main.langLib.titleTxt(TitleData.RANK_TUTOR) + "</font>"));
               break;
            case 9:
               Central.main.showDynamicTooltip(mc["rankIcon"],String("<font size=\'16\'>" + Central.main.langLib.titleTxt(TitleData.RANK_TUTOR_SENIOR) + "</font>"));
         }
         i = uint(Central.main.getMainChar().getData(DBCharacterData.CONTROL));
         switch(i)
         {
            case 0:
               if(Central.main.getMainChar().getLevel() < Central.main.DISPLAY_LEVEL_LIMIT_BUTTON_CLASS || Central.main.getMainChar().getData(DBCharacterData.RANK) <= RankData.GENIN)
               {
                  mc["iconMC"].gotoAndStop("idle");
               }
               else
               {
                  mc["iconMC"].gotoAndStop("classNull");
               }
               break;
            case 1:
               mc["iconMC"].gotoAndStop("class1");
               break;
            case 2:
               mc["iconMC"].gotoAndStop("class2");
               break;
            case 3:
               mc["iconMC"].gotoAndStop("class3");
               break;
            case 4:
               mc["iconMC"].gotoAndStop("class4");
               break;
            case 5:
               mc["iconMC"].gotoAndStop("class5");
         }
         Central.main.initButton(mc["iconMC"]["changeClassBtn"],new Function(),ButtonData.CHANGE);
         if(mc["iconMC"].currentFrameLabel != "idle")
         {
            mc["iconMC"].addEventListener(MouseEvent.CLICK,this.onMenuBtn);
            mc["iconMC"].buttonMode = true;
         }
         if(i > 0)
         {
            Central.main.showDynamicTooltip(mc["iconMC"],String("<font size=\'16\'>" + Central.main.langLib.get(1580)[i - 1] + "</font>"));
         }
         mc["nameTxt"].text = mainChar.getCharacterName();
         mc["lvTxt"].text = mainChar.getData("character_level");
         mc["idTxt"].text = mainChar.getData(DBCharacterData.ID);
         Central.main.showDynamicTooltip(mc["hpMask"],String("<font size=\'16\'>" + Central.main.langLib.get(1585)[0] + "</font>"));
         Central.main.showDynamicTooltip(mc["cpMask"],String("<font size=\'16\'>" + Central.main.langLib.get(1585)[1] + "</font>"));
         Central.main.showDynamicTooltip(mc["xpMask"],String("<font size=\'16\'>" + Central.main.langLib.get(1585)[2] + "</font>"));
         mc["xpTxt"].text = mainChar.getData(DBCharacterData.XP) - Formula.getXpByLv(mainChar.getLevel()) + " / " + (Formula.getXpByLv(mainChar.getLevel() + 1) - Formula.getXpByLv(mainChar.getLevel()));
         mc["xpBar"].scaleX = (mainChar.getData(DBCharacterData.XP) - Formula.getXpByLv(mainChar.getLevel())) / (Formula.getXpByLv(mainChar.getLevel() + 1) - Formula.getXpByLv(mainChar.getLevel()));
         mainChar.playStand();
         var swf:MovieClip = mainChar.getSwf();
         swf.scaleX *= this.CHARACTER_SCALE;
         swf.scaleY *= this.CHARACTER_SCALE;
         mc["charMc"].addChild(swf);
         for(i = 0; i < this.TOOLTIP_BUTTONS.length; i++)
         {
            Central.main.showDynamicTooltip(mc[this.TOOLTIP_BUTTONS[i] + "Tooltip"],String("<font size=\'16\'>" + this.ATTRIBUTE_TOOLTIPS[this.TOOLTIP_BUTTONS[i]] + "</font>"));
         }
         Central.main.initButton(mc["resetBtn"],this.confirmReset,null);
         Central.main.showDynamicTooltip(mc["resetBtn"],String("<font size=\'16\'>" + Central.main.langLib.btnTxt(ButtonData.RESETPOINTS) + "</font>"));
         Central.main.initButton(mc["btnRename"],this.CharacterRename,Central.main.langLib.get(1315));
         mc["lbl_profile_title"].text = Central.main.langLib.titleTxt(TitleData.PROFILE);
         mc["lbl_id"].text = Central.main.langLib.titleTxt(TitleData.ID);
         mc["lbl_lv"].text = Central.main.langLib.titleTxt(TitleData.LV) + ".";
         mc["lbl_agility"].text = Central.main.langLib.titleTxt(TitleData.AGILITY) + " :";
         mc["lbl_critical"].text = Central.main.langLib.titleTxt(TitleData.CRITICAL) + " :";
         mc["lbl_dodge"].text = Central.main.langLib.titleTxt(TitleData.DODGE) + " :";
         mc["lbl_wind"].text = Central.main.langLib.titleTxt(TitleData.WIND);
         mc["lbl_fire"].text = Central.main.langLib.titleTxt(TitleData.FIRE);
         mc["lbl_thunder"].text = Central.main.langLib.titleTxt(TitleData.THUNDER);
         mc["lbl_water"].text = Central.main.langLib.titleTxt(TitleData.WATER);
         mc["lbl_earth"].text = Central.main.langLib.titleTxt(TitleData.EARTH);
         mc["lbl_pointleft"].text = Central.main.langLib.titleTxt(TitleData.POINTLEFT);
         mc["profileBtn"].visible = false;
         mc["upgradeBtn"].visible = false;
         if(Account.getAccountType() == Account.PREMIUM)
         {
            mc["emblemMC"].gotoAndStop("premium");
            this.disableButton(mc["emblemMC"]["emble"],this.gotoEmblem,null);
            mc["emblemMC"].removeEventListener(MouseEvent.CLICK,this.gotoEmblem);
            Central.main.showDynamicTooltip(mc["emblemMC"],String("<font size=\'16\'>" + Central.main.langLib.get(1582) + "</font>"));
         }
         else
         {
            mc["emblemMC"].gotoAndStop(Timeline.IDLE);
            Central.main.initButton(mc["emblemMC"]["emble"],this.gotoEmblem,null);
            Central.main.showDynamicTooltip(mc["emblemMC"],String("<font size=\'16\'>" + Central.main.langLib.get(1581) + "</font>"));
         }
         this.refreshAP();
      }
      
      public function onPhoto() : void
      {
         var i:uint = 0;
         var value:Object = null;
         var value3:Object = null;
         var changeToNum:int = 0;
         var skillType:String = null;
         this.stop();
         this["btnClose"].addEventListener(MouseEvent.CLICK,this.closephoto);
         var mc:MovieClip = this["photo"];
         var mainChar:* = Central.main.getMainChar();
         var counter:int = 1;
         for(i = 0; i < 6; i++)
         {
            skillType = String(this.SKILL_TYPE_BUTTONS[i]).substr(3,String(this.SKILL_TYPE_BUTTONS[i]).length).toLowerCase();
            if(Boolean(Central.main.getMainChar().hasSkillType(skillType)) && skillType != "taijutsu")
            {
               mc["skillBtn" + counter].gotoAndStop(skillType);
               switch(skillType)
               {
                  case "wind":
                     Central.main.showDynamicTooltip(mc["skillBtn" + counter],String("<font size=\'16\'>" + Central.main.langLib.get(1578)[0] + "</font>"));
                     break;
                  case "fire":
                     Central.main.showDynamicTooltip(mc["skillBtn" + counter],String("<font size=\'16\'>" + Central.main.langLib.get(1578)[1] + "</font>"));
                     break;
                  case "lightning":
                     Central.main.showDynamicTooltip(mc["skillBtn" + counter],String("<font size=\'16\'>" + Central.main.langLib.get(1578)[2] + "</font>"));
                     break;
                  case "water":
                     Central.main.showDynamicTooltip(mc["skillBtn" + counter],String("<font size=\'16\'>" + Central.main.langLib.get(1578)[3] + "</font>"));
                     break;
                  case "earth":
                     Central.main.showDynamicTooltip(mc["skillBtn" + counter],String("<font size=\'16\'>" + Central.main.langLib.get(1578)[4] + "</font>"));
               }
               counter++;
            }
         }
         if(counter <= 3)
         {
            if(Account.getAccountType() == Account.PREMIUM)
            {
               mc["skillBtn" + counter].gotoAndStop(this.skillProfileBtn[1]);
               mc["skillBtn" + counter]["learn"]["learnIcon"].text = Central.main.langLib.get(1584);
               Central.main.showDynamicTooltip(mc["skillBtn" + counter],String("<font size=\'16\'>" + Central.main.langLib.get(1578)[6] + "</font>"));
               mc["skillBtn" + counter].visible = false;
               counter++;
            }
            else if(counter == 3)
            {
               mc["skillBtn" + counter].gotoAndStop(this.skillProfileBtn[1]);
               mc["skillBtn" + counter]["learn"]["learnIcon"].text = Central.main.langLib.get(1584);
               Central.main.showDynamicTooltip(mc["skillBtn" + counter],String("<font size=\'16\'>" + Central.main.langLib.get(1578)[6] + "</font>"));
               mc["skillBtn" + counter].visible = false;
               counter++;
            }
            else
            {
               mc["skillBtn" + counter].gotoAndStop(this.skillProfileBtn[1]);
               mc["skillBtn" + counter]["learn"]["learnIcon"].text = Central.main.langLib.get(1584);
               Central.main.showDynamicTooltip(mc["skillBtn" + counter],String("<font size=\'16\'>" + Central.main.langLib.get(1578)[6] + "</font>"));
               mc["skillBtn" + counter].visible = false;
               counter++;
            }
         }
         for(i = uint(counter); i <= 3; i++)
         {
            mc["skillBtn" + i].gotoAndStop(1);
         }
         mc["telent1"].gotoAndStop(this.telentBtn[2]);
         mc["telent2"].gotoAndStop(this.telentBtn[3]);
         mc["telent3"].gotoAndStop(this.telentBtn[3]);
         var BloodlineData_Arr:Array = [];
         var j:uint = 0;
         var blArr:Array = [];
         var seArr:Array = [];
         for each(value in Central.main.BLOODLINE_DATA)
         {
            BloodlineData_Arr.push(value);
         }
         for each(value3 in Central.main.getMainChar().bloodline)
         {
            if(value3.bloodline_id >= 1 && (value3.bloodline_id <= 4 || value3.bloodline_id > 9))
            {
               if(blArr.indexOf(value3.bloodline_id) == -1)
               {
                  blArr.push(value3.bloodline_id);
               }
            }
            else if(value3.bloodline_id >= 5 && value3.bloodline_id <= 9)
            {
               if(seArr.indexOf(value3.bloodline_id) == -1)
               {
                  seArr.push(value3.bloodline_id);
               }
            }
         }
         changeToNum = 0;
         if(blArr.length > 0)
         {
            changeToNum = int(blArr[0]);
            mc["telent1"].gotoAndStop(this.telentBtn[changeToNum + 3]);
            mc["telent1"].addEventListener(MouseEvent.CLICK,this.goOwnTelent);
            for(j = 0; j < BloodlineData_Arr.length; j++)
            {
               if(BloodlineData_Arr[j].id == "bloodline" + changeToNum)
               {
                  Central.main.showDynamicTooltip(mc["telent1"],String("<font size=\'16\'>" + BloodlineData_Arr[j].name + "</font>"));
               }
            }
         }
         else if(Central.main.getMainChar().getData(DBCharacterData.RANK) >= 4 && Central.main.getMainChar().getLevel() >= 40)
         {
            mc["telent1"].gotoAndStop(this.telentBtn[0]);
            mc["telent1"]["learn"]["learnIcon"].text = Central.main.langLib.get(1584);
            Central.main.showDynamicTooltip(mc["telent1"],String("<font size=\'16\'>" + Central.main.langLib.get(1579)[9] + "</font>"));
            mc["telent1"].visible = false;
         }
         else
         {
            mc["telent1"].gotoAndStop(this.telentBtn[2]);
            Central.main.showDynamicTooltip(mc["telent1"],String("<font size=\'16\'>" + Central.main.langLib.get(1579)[10] + "</font>"));
            mc["telent1"].visible = false;
         }
         if(seArr.length == 0)
         {
            if(Central.main.getMainChar().getData(DBCharacterData.RANK) >= 6 && Central.main.getMainChar().getLevel() >= 60)
            {
               mc["telent2"].gotoAndStop(this.telentBtn[1]);
               mc["telent2"]["learn"]["learnIcon"].text = Central.main.langLib.get(1584);
               Central.main.showDynamicTooltip(mc["telent2"],String("<font size=\'16\'>" + Central.main.langLib.get(1579)[9] + "</font>"));
               mc["telent3"].gotoAndStop(this.telentBtn[1]);
               mc["telent3"]["learn"]["learnIcon"].text = Central.main.langLib.get(1584);
               Central.main.showDynamicTooltip(mc["telent3"],String("<font size=\'16\'>" + Central.main.langLib.get(1579)[9] + "</font>"));
               mc["telent2"].visible = false;
               mc["telent3"].visible = false;
            }
            else if(Central.main.getMainChar().getData(DBCharacterData.RANK) >= 4 && Central.main.getMainChar().getLevel() >= 50)
            {
               mc["telent2"].gotoAndStop(this.telentBtn[1]);
               mc["telent2"]["learn"]["learnIcon"].text = Central.main.langLib.get(1584);
               Central.main.showDynamicTooltip(mc["telent2"],String("<font size=\'16\'>" + Central.main.langLib.get(1579)[9] + "</font>"));
               mc["telent3"].gotoAndStop(this.telentBtn[3]);
               Central.main.showDynamicTooltip(mc["telent3"],String("<font size=\'16\'>" + Central.main.langLib.get(1579)[12] + "</font>"));
               mc["telent2"].visible = false;
            }
            else
            {
               mc["telent2"].gotoAndStop(this.telentBtn[3]);
               Central.main.showDynamicTooltip(mc["telent2"],String("<font size=\'16\'>" + Central.main.langLib.get(1579)[11] + "</font>"));
               mc["telent3"].gotoAndStop(this.telentBtn[3]);
               Central.main.showDynamicTooltip(mc["telent3"],String("<font size=\'16\'>" + Central.main.langLib.get(1579)[12] + "</font>"));
               mc["telent2"].visible = false;
               mc["telent3"].visible = false;
            }
         }
         else if(seArr.length == 1)
         {
            if(Central.main.getMainChar().getData(DBCharacterData.RANK) >= 6 && Central.main.getMainChar().getLevel() >= 60)
            {
               changeToNum = int(seArr[0]);
               mc["telent2"].gotoAndStop(this.telentBtn[changeToNum + 3]);
               for(j = 0; j < BloodlineData_Arr.length; j++)
               {
                  if(BloodlineData_Arr[j].id == "bloodline" + changeToNum)
                  {
                     Central.main.showDynamicTooltip(mc["telent2"],String("<font size=\'16\'>" + BloodlineData_Arr[j].name + "</font>"));
                  }
               }
               mc["telent3"].gotoAndStop(this.telentBtn[1]);
               Central.main.initButton(mc["telent3"]["learn"],this.goTelent,null);
               mc["telent3"]["learn"]["learnIcon"].text = Central.main.langLib.get(1584);
               Central.main.showDynamicTooltip(mc["telent3"],String("<font size=\'16\'>" + Central.main.langLib.get(1579)[9] + "</font>"));
               mc["telent3"].visible = false;
            }
            else if(Central.main.getMainChar().getData(DBCharacterData.RANK) >= 4 && Central.main.getMainChar().getLevel() >= 50)
            {
               changeToNum = int(seArr[0]);
               mc["telent2"].gotoAndStop(this.telentBtn[changeToNum + 3]);
               Central.main.showDynamicTooltip(mc["telent2"],String("<font size=\'16\'>" + Central.main.langLib.get(1579)[changeToNum - 1] + "</font>"));
               mc["telent3"].gotoAndStop(this.telentBtn[3]);
               Central.main.showDynamicTooltip(mc["telent3"],String("<font size=\'16\'>" + Central.main.langLib.get(1579)[12] + "</font>"));
            }
         }
         else if(seArr.length == 2)
         {
            changeToNum = int(seArr[0]);
            mc["telent2"].gotoAndStop(this.telentBtn[changeToNum + 3]);
            for(j = 0; j < BloodlineData_Arr.length; j++)
            {
               if(BloodlineData_Arr[j].id == "bloodline" + changeToNum)
               {
                  Central.main.showDynamicTooltip(mc["telent2"],String("<font size=\'16\'>" + BloodlineData_Arr[j].name + "</font>"));
               }
            }
            changeToNum = int(seArr[1]);
            mc["telent3"].gotoAndStop(this.telentBtn[changeToNum + 3]);
            for(j = 0; j < BloodlineData_Arr.length; j++)
            {
               if(BloodlineData_Arr[j].id == "bloodline" + changeToNum)
               {
                  Central.main.showDynamicTooltip(mc["telent3"],String("<font size=\'16\'>" + BloodlineData_Arr[j].name + "</font>"));
               }
            }
         }
         else
         {
            mc["telent2"].gotoAndStop(this.telentBtn[3]);
            Central.main.showDynamicTooltip(mc["telent2"],String("<font size=\'16\'>" + Central.main.langLib.get(1579)[11] + "</font>"));
            mc["telent3"].gotoAndStop(this.telentBtn[3]);
            Central.main.showDynamicTooltip(mc["telent3"],String("<font size=\'16\'>" + Central.main.langLib.get(1579)[12] + "</font>"));
            mc["telent2"].visible = false;
            mc["telent3"].visible = false;
         }
         mc["rankIcon"].gotoAndStop(mainChar.getData(DBCharacterData.RANK));
         switch(mainChar.getData(DBCharacterData.RANK))
         {
            case 1:
               Central.main.showDynamicTooltip(mc["rankIcon"],String("<font size=\'16\'>" + Central.main.langLib.titleTxt(TitleData.RANK_GENIN) + "</font>"));
               break;
            case 2:
               Central.main.showDynamicTooltip(mc["rankIcon"],String("<font size=\'16\'>" + Central.main.langLib.titleTxt(TitleData.RANK_CHUNIN) + "</font>"));
               break;
            case 3:
               Central.main.showDynamicTooltip(mc["rankIcon"],String("<font size=\'16\'>" + Central.main.langLib.titleTxt(TitleData.RANK_TENSAI_CHUNIN) + "</font>"));
               break;
            case 4:
               Central.main.showDynamicTooltip(mc["rankIcon"],String("<font size=\'16\'>" + Central.main.langLib.titleTxt(TitleData.RANK_JOUNIN) + "</font>"));
               break;
            case 5:
               Central.main.showDynamicTooltip(mc["rankIcon"],String("<font size=\'16\'>" + Central.main.langLib.titleTxt(TitleData.RANK_TENSAI_JOUNIN) + "</font>"));
               break;
            case 6:
               Central.main.showDynamicTooltip(mc["rankIcon"],String("<font size=\'16\'>" + Central.main.langLib.titleTxt(TitleData.RANK_SPECIAL_JOUNIN) + "</font>"));
               break;
            case 7:
               Central.main.showDynamicTooltip(mc["rankIcon"],String("<font size=\'16\'>" + Central.main.langLib.titleTxt(TitleData.RANK_TENSAI_SPECIAL_JOUNIN) + "</font>"));
               break;
            case 8:
               Central.main.showDynamicTooltip(mc["rankIcon"],String("<font size=\'16\'>" + Central.main.langLib.titleTxt(TitleData.RANK_TUTOR) + "</font>"));
               break;
            case 9:
               Central.main.showDynamicTooltip(mc["rankIcon"],String("<font size=\'16\'>" + Central.main.langLib.titleTxt(TitleData.RANK_TUTOR_SENIOR) + "</font>"));
         }
         i = uint(Central.main.getMainChar().getData(DBCharacterData.CONTROL));
         switch(i)
         {
            case 0:
               if(Central.main.getMainChar().getLevel() < Central.main.DISPLAY_LEVEL_LIMIT_BUTTON_CLASS || Central.main.getMainChar().getData(DBCharacterData.RANK) <= RankData.GENIN)
               {
                  mc["iconMC"].gotoAndStop("idle");
               }
               else
               {
                  mc["iconMC"].gotoAndStop("classNull");
               }
               break;
            case 1:
               mc["iconMC"].gotoAndStop("class1");
               break;
            case 2:
               mc["iconMC"].gotoAndStop("class2");
               break;
            case 3:
               mc["iconMC"].gotoAndStop("class3");
               break;
            case 4:
               mc["iconMC"].gotoAndStop("class4");
               break;
            case 5:
               mc["iconMC"].gotoAndStop("class5");
         }
         if(mc["iconMC"].currentFrameLabel != "idle")
         {
         }
         if(i > 0)
         {
            Central.main.showDynamicTooltip(mc["iconMC"],String("<font size=\'16\'>" + Central.main.langLib.get(1580)[i - 1] + "</font>"));
         }
         mc["nameTxt"].text = mainChar.getCharacterName();
         mc["lvTxt"].text = mainChar.getData("character_level");
         mc["idTxt"].text = "(" + mainChar.getData(DBCharacterData.ID) + ")";
         mainChar.playStand();
         var swf:MovieClip = mainChar.getSwf();
         swf.scaleX *= this.CHARACTER_SCALE;
         swf.scaleY *= this.CHARACTER_SCALE;
         mc["charMc"].addChild(swf);
         Central.main.initButton(this["btnphoto2"],this.previewPic,"photo");
         mc["lbl_lv"].text = Central.main.langLib.titleTxt(TitleData.LV) + ".";
         if(Account.getAccountType() == Account.PREMIUM)
         {
            mc["emblemMC"].gotoAndStop("premium");
            this.disableButton(mc["emblemMC"]["emble"],this.gotoEmblem,null);
            mc["emblemMC"].removeEventListener(MouseEvent.CLICK,this.gotoEmblem);
            Central.main.showDynamicTooltip(mc["emblemMC"],String("<font size=\'16\'>" + Central.main.langLib.get(1582) + "</font>"));
         }
         else
         {
            mc["emblemMC"].gotoAndStop(Timeline.IDLE);
            Central.main.showDynamicTooltip(mc["emblemMC"],String("<font size=\'16\'>" + Central.main.langLib.get(1581) + "</font>"));
            mc["emblemMC"].visible = false;
         }
      }
      
      private function gotoEmblem(e:MouseEvent) : *
      {
         Central.main.showUpgradeAccount(Central.main.langLib.get(1452),"CreateChar");
      }
      
      public function onUpgrade() : void
      {
         this.stop();
         this.initUpgradeBtn();
         var mc:MovieClip = this["profile"];
         for(var i:int = 1; i <= 3; i++)
         {
            mc["upgradeBtn" + i]["icon"].gotoAndStop(this.upgradeArr[i - 1]);
            mc["upgradeBtn" + i]["lbl_lv"].text = Central.main.langLib.titleTxt(TitleData.LEVEL) + " :";
         }
         mc["lbl_profile_title"].text = Central.main.langLib.titleTxt(TitleData.PERSONAL_TRAINING);
         mc["lbl_lv"].text = Central.main.langLib.titleTxt(TitleData.LV) + " :";
         mc["lbl_goldNeed"].text = Central.main.langLib.get(1332);
         mc["lbl_notice"].text = Central.main.langLib.get(1338);
         mc["warningTxt"].text = Central.main.langLib.get(1339);
         mc["processTxt"].text = Central.main.langLib.get(1333);
         mc["emblemTxt"].text = Central.main.langLib.get(1334);
         this.barPosition[0] = mc["percentBar"].x;
         this.barPosition[1] = mc["percentBar"].width;
         this.initTrainingPanel();
         Central.main.showAmfLoading();
         Central.main.amfClient.service("CharacterDAO.verify_hp_cp_ap",[Central.main.account.getAccountSessionKey()],this.personalTrainingGetStatusResponse);
      }
      
      public function setTimeRemain(_time:int) : *
      {
         this.timeRemain = _time;
      }
      
      public function setPotion(_potion:Array) : *
      {
         this.potion = _potion.concat();
      }
      
      private function personalTrainingGetStatusResponse(response:Object) : *
      {
         var temp:Object = null;
         var temp2:int = 0;
         var mainChar:* = undefined;
         var i:int = 0;
         var tempString:String = null;
         if(Central.main.validateAmfResponse(response))
         {
            Central.main.hideAmfLoading();
            if(response.learning != null)
            {
               temp = response.learning as Object;
               this.trainingLV[0] = int(temp.hp_lv);
               this.trainingLV[1] = int(temp.cp_lv);
               this.trainingLV[2] = int(temp.ap_lv);
               temp2 = int(temp.status);
               switch(temp2)
               {
                  case 0:
                     this.currentUpgrade = 0;
                     break;
                  case 1:
                     this.currentUpgrade = 2;
                     break;
                  case 2:
                     this.currentUpgrade = 3;
                     break;
                  case 3:
                     this.currentUpgrade = 1;
               }
               mainChar = Central.main.getMainChar();
               for(i = 0; i < this.upgradeArr.length; i++)
               {
                  tempString = this.upgradeArr[i] + "_lv";
                  mainChar.updateData(tempString,this.trainingLV[i]);
               }
               mainChar.updateData("character_" + this.upgradeArr[0],mainChar.maxHP);
               mainChar.updateData("character_" + this.upgradeArr[1],mainChar.maxCP);
               Central.main.updateMenu();
               this.timeRemain = int(temp.remaining_time);
               if(this.timeRemain < 0)
               {
                  this.timeRemain = 0;
                  this.currentUpgrade = 0;
               }
            }
            if(response.currentUpgrade != null)
            {
            }
            if(response.timeRemain != null)
            {
               this.timeRemain = int(response.timeRemain);
            }
            if(!(this.trainingLV[0] == 0 && this.trainingLV[1] == 0 && this.trainingLV[2] == 0 && this.currentUpgrade == 0))
            {
               if(!(this.trainingLV[0] == 0 && this.trainingLV[1] == 0 && this.trainingLV[2] == 0 && this.currentUpgrade != 1))
               {
                  this.initTrainingPanel();
               }
            }
         }
      }
      
      private function initTrainingPanel() : *
      {
         var mc:MovieClip = this["profile"];
         var mainChar:* = Central.main.getMainChar();
         for(var i:int = 1; i <= 3; i++)
         {
            mc["upgradeBtn" + i]["lvTxt"].text = String(this.trainingLV[i - 1]);
            if(this.trainingLV[i - 1] == TrainingData.upgradeLevelArray.length)
            {
               mc["upgradeBtn" + i]["upgradeTxt"].visible = false;
               mc["upgradeBtn" + i]["updatingTxt"].visible = false;
               mc["upgradeBtn" + i]["requiredTxt"].visible = false;
               mc["upgradeBtn" + i]["bg"].visible = false;
            }
            else
            {
               mc["upgradeBtn" + i]["bg"].visible = true;
               if(this.currentUpgrade > 0)
               {
                  mc["upgradeBtn" + i]["upgradeTxt"].text = Central.main.langLib.get(1331);
               }
               else
               {
                  mc["upgradeBtn" + i]["upgradeTxt"].text = Central.main.langLib.get(1336);
               }
               mc["upgradeBtn" + i]["updatingTxt"].text = Central.main.langLib.get(1337) + Central.main.langLib.titleTxt(TitleData.LV) + String(this.trainingLV[i - 1] + 1);
               if(mainChar.getData("character_level") < 9)
               {
                  mc["upgradeBtn" + i]["requiredTxt"].text = Central.main.langLib.get(1335) + "9";
               }
               else
               {
                  mc["upgradeBtn" + i]["requiredTxt"].text = Central.main.langLib.get(1335) + String(int(mainChar.getData("character_level")) + 1);
               }
               if(this.currentUpgrade == i && mainChar.getData("character_level") > 9)
               {
                  mc["upgradeBtn" + i]["upgradeTxt"].visible = false;
                  mc["upgradeBtn" + i]["updatingTxt"].visible = true;
                  mc["upgradeBtn" + i]["requiredTxt"].visible = false;
                  mc["upgradeBtn" + i]["bg"].visible = true;
               }
               else if(this.trainingLV[i - 1] < int(mainChar.getData("character_level")) && mainChar.getData("character_level") > 9)
               {
                  mc["upgradeBtn" + i]["upgradeTxt"].visible = true;
                  mc["upgradeBtn" + i]["updatingTxt"].visible = false;
                  mc["upgradeBtn" + i]["requiredTxt"].visible = false;
                  mc["upgradeBtn" + i]["bg"].visible = false;
               }
               else if(this.trainingLV[i - 1] == int(mainChar.getData("character_level")) || mainChar.getData("character_level") < 9)
               {
                  mc["upgradeBtn" + i]["upgradeTxt"].visible = false;
                  mc["upgradeBtn" + i]["updatingTxt"].visible = false;
                  mc["upgradeBtn" + i]["requiredTxt"].visible = true;
                  mc["upgradeBtn" + i]["bg"].visible = false;
               }
            }
            mc["upgradeBtn" + i].addEventListener(MouseEvent.CLICK,this.upgradeBtnFunction);
            mc["upgradeBtn" + i].addEventListener(MouseEvent.ROLL_OVER,this.upgradeBtnFunction);
            mc["upgradeBtn" + i].addEventListener(MouseEvent.ROLL_OUT,this.upgradeBtnFunction);
            mc["upgradeBtn" + i].id = i - 1;
         }
         if(this.currentUpgrade != 0)
         {
            this.initTrainPreview(this.currentUpgrade - 1);
         }
         else if(this.trainingLV[0] < mainChar.getData("character_level"))
         {
            this.initTrainPreview(0);
         }
         else if(this.trainingLV[1] < mainChar.getData("character_level"))
         {
            this.initTrainPreview(1);
         }
         else if(this.trainingLV[2] < mainChar.getData("character_level"))
         {
            this.initTrainPreview(2);
         }
      }
      
      private function upgradeBtnFunction(e:MouseEvent) : *
      {
         switch(e.type)
         {
            case MouseEvent.CLICK:
               e.currentTarget.highlight.gotoAndStop(1);
               this.initTrainPreview(e.currentTarget.id);
               break;
            case MouseEvent.ROLL_OVER:
               if(this.nowDisplay != e.currentTarget.id)
               {
                  e.currentTarget.highlight.gotoAndStop(2);
               }
               else
               {
                  e.currentTarget.highlight.gotoAndStop(1);
               }
               break;
            case MouseEvent.ROLL_OUT:
               e.currentTarget.highlight.gotoAndStop(1);
         }
      }
      
      private function initTrainPreview(currentDisplay:int) : *
      {
         var minutes:int = 0;
         var hours:int = 0;
         var day:int = 0;
         var earthBonus:uint = 0;
         var hp:int = 0;
         var hp2:int = 0;
         var waterBonus:uint = 0;
         var cp:int = 0;
         var cp2:int = 0;
         var ap:int = 0;
         var tempTimeString:String = null;
         this.nowDisplay = currentDisplay;
         var mc:MovieClip = this["profile"];
         var mainChar:* = Central.main.getMainChar();
         for(var i:int = 1; i <= 3; i++)
         {
            if(currentDisplay + 1 == i)
            {
               mc["upgradeBtn" + i].gotoAndStop(Timeline.SHOW);
            }
            else
            {
               mc["upgradeBtn" + i].gotoAndStop(Timeline.IDLE);
            }
         }
         mc["bg"].gotoAndStop(this.upgradeArr[currentDisplay]);
         if(this.trainingLV[currentDisplay] == TrainingData.upgradeLevelArray.length)
         {
            mc["warningTxt"].visible = true;
            this.invisibleAllTrainingPanel(0);
         }
         else
         {
            this.visibleAllTrainingPanel();
            mc["warningTxt"].visible = false;
            mc["upgradeTitleTxt"].text = Central.main.langLib.get(1328 + currentDisplay);
            mc["currentLvTxt"].text = this.trainingLV[currentDisplay];
            mc["nextLvTxt"].text = String(this.trainingLV[currentDisplay] + 1);
            mc["lbl_value"].text = Central.main.langLib.titleTxt(this.upgradeArr[currentDisplay]) + " :";
            minutes = TrainingData.upgradeLevelArray[this.trainingLV[currentDisplay]][0] % 60;
            hours = Math.floor(TrainingData.upgradeLevelArray[this.trainingLV[currentDisplay]][0] / 60) % 24;
            day = Math.floor(TrainingData.upgradeLevelArray[this.trainingLV[currentDisplay]][0] / 60 / 24);
            mc["gold"]["txt_gold"].text = TrainingData.upgradeLevelArray[this.trainingLV[currentDisplay]][1];
            switch(currentDisplay)
            {
               case 0:
                  earthBonus = 30;
                  hp = 0;
                  mc["currentValue"].text = hp;
                  hp2 = 0;
                  mc["nextValue"].text = hp2;
                  break;
               case 1:
                  waterBonus = 30;
                  cp = 0;
                  mc["currentValue"].text = cp;
                  cp2 = 0;
                  mc["nextValue"].text = cp2;
                  break;
               case 2:
                  ap = 0;
                  mc["currentValue"].text = ap;
                  mc["nextValue"].text = ap + 1;
            }
            if(this.currentUpgrade != currentDisplay + 1)
            {
               this.alphaProcess();
               mc["percentBar"].x = this.barPosition[0];
               mc["processTimeTxt"].text = "";
            }
            else
            {
               this.normalProcess();
               if(!this.upgradeTrainingTimer.running)
               {
                  this.upgradeTrainingTimer.addEventListener(TimerEvent.TIMER,this.updateTrainingTime);
                  this.upgradeTrainingTimer.start();
                  this.timeRemainMin = Math.ceil(this.timeRemain / 60);
               }
               minutes = this.timeRemainMin % 60;
               hours = Math.floor(this.timeRemainMin / 60) % 24;
               day = Math.floor(this.timeRemainMin / 60 / 24);
               tempTimeString = "";
               if(day != 0)
               {
                  tempTimeString += day + "D ";
               }
               if(hours != 0)
               {
                  tempTimeString += hours + "H ";
               }
               tempTimeString += minutes + "M";
               mc["processTimeTxt"].text = tempTimeString;
               mc["percentBar"].x = this.barPosition[0] - this.timeRemain / 60 / TrainingData.upgradeLevelArray[this.trainingLV[currentDisplay]][0] * this.barPosition[1];
            }
            if(this.trainingLV[currentDisplay] >= mainChar.getData(DBCharacterData.LEVEL))
            {
               mc["noticeTxt"].visible = true;
               mc["trainingBtn"].visible = false;
               mc["noticeTxt"].text = Central.main.langLib.get(1335) + Central.main.langLib.titleTxt(TitleData.LV) + String(this.trainingLV[currentDisplay] + 1);
            }
            else
            {
               mc["noticeTxt"].visible = false;
               if(this.currentUpgrade != 0 || mainChar.getData("character_level") < 9)
               {
                  if(currentDisplay == this.currentUpgrade - 1)
                  {
                     Central.main.initButton(mc["potionBtn"],this.goPotion,Central.main.langLib.get(1340));
                     mc["potionBtn"].filters = null;
                  }
                  else
                  {
                     this.disableButton2(mc["potionBtn"],this.goPotion,Central.main.langLib.get(1340));
                  }
                  this.disableButton2(mc["trainingBtn"],this.startTraining,Central.main.langLib.get(1342));
               }
               else
               {
                  this.disableButton2(mc["potionBtn"],this.goPotion,Central.main.langLib.get(1340));
                  mc["trainingBtn"].filters = null;
                  Central.main.initButton(mc["trainingBtn"],this.startTraining,Central.main.langLib.get(1341));
               }
            }
         }
      }
      
      private function goPotion(e:MouseEvent) : *
      {
         this["profile"]["popUpMC"].setData(this.nowDisplay,this.timeRemain,this.trainingLV,this.potion);
         this["profile"]["popUpMC"].show();
      }
      
      private function startTraining(e:MouseEvent) : *
      {
         Central.main.showAmfLoading();
         Central.main.amfClient.service("CharacterDAO.train_hp_cp_ap",[Central.main.account.getAccountSessionKey(),this.upgradeArr[this.nowDisplay]],this.startTrainingResponse);
      }
      
      private function startTrainingResponse(response:Object) : *
      {
         if(Central.main.validateAmfResponse(response))
         {
            Central.main.hideAmfLoading();
            Central.main.getMainChar().updateGold(-TrainingData.upgradeLevelArray[this.trainingLV[this.nowDisplay]][1]);
            Central.main.updateMenu();
            this.startTrainingNow();
         }
      }
      
      private function startTrainingNow() : *
      {
         this.currentUpgrade = this.nowDisplay + 1;
         if(Account.getAccountType() == Account.PREMIUM)
         {
            this.timeRemain = TrainingData.upgradeLevelArray[this.trainingLV[this.nowDisplay]][0] * 60 * 0.8;
         }
         else
         {
            this.timeRemain = TrainingData.upgradeLevelArray[this.trainingLV[this.nowDisplay]][0] * 60;
         }
         this.initTrainingPanel();
      }
      
      public function updateTrainingTime(e:TimerEvent = null) : *
      {
         var minutes:int = 0;
         var hours:int = 0;
         var day:int = 0;
         var tempTimeString:String = null;
         var percent:Number = NaN;
         var tempX:Number = NaN;
         var mc:MovieClip = this["profile"];
         --this.timeRemain;
         this.timeRemainMin = Math.ceil(this.timeRemain / 60);
         if(this.nowDisplay == this.currentUpgrade - 1)
         {
            minutes = this.timeRemainMin % 60;
            hours = Math.floor(this.timeRemainMin / 60) % 24;
            day = Math.floor(this.timeRemainMin / 60 / 24);
            if(minutes < 0)
            {
               minutes = 0;
            }
            if(hours < 0)
            {
               hours = 0;
            }
            if(day < 0)
            {
               day = 0;
            }
            tempTimeString = "";
            if(day != 0)
            {
               tempTimeString += day + "D ";
            }
            if(hours != 0)
            {
               tempTimeString += hours + "H ";
            }
            tempTimeString += minutes + "M";
            mc["processTimeTxt"].text = tempTimeString;
            percent = this.timeRemain / 60 / TrainingData.upgradeLevelArray[this.trainingLV[this.nowDisplay]][0];
            tempX = this.barPosition[0] - percent * this.barPosition[1];
            if(tempX <= this.barPosition[0])
            {
               mc["percentBar"].x = tempX;
            }
            else
            {
               mc["percentBar"].x = this.barPosition[0];
            }
         }
         if(this.timeRemainMin <= 0)
         {
            this.upgradeTrainingTimer.stop();
            Central.main.showAmfLoading();
            Central.main.amfClient.service("CharacterDAO.verify_hp_cp_ap",[Central.main.account.getAccountSessionKey()],this.personalTrainingGetStatusResponse);
         }
      }
      
      private function demoFinishFunction() : *
      {
         ++this.trainingLV[this.currentUpgrade - 1];
         var mainChar:* = Central.main.getMainChar();
         var tempString:String = this.upgradeArr[this.currentUpgrade - 1] + "_lv";
         mainChar.updateData(tempString,this.trainingLV[this.currentUpgrade - 1]);
         mainChar.updateData("character_" + this.upgradeArr[0],mainChar.maxHP);
         mainChar.updateData("character_" + this.upgradeArr[1],mainChar.maxCP);
         Central.main.updateMenu();
         this.currentUpgrade = 0;
         this.timeRemain = 0;
         this.timeRemainMin = 0;
         this.initTrainingPanel();
      }
      
      private function disableButton2(btn:*, fn:Function, txt:String = null) : void
      {
         btn.stop();
         btn["clickMask"].buttonMode = false;
         btn.gotoAndStop(1);
         if(btn.hasEventListener(MouseEvent.MOUSE_OUT))
         {
            btn.removeEventListener(MouseEvent.MOUSE_OUT,function(e:MouseEvent):*
            {
               e.currentTarget.gotoAndStop(1);
            });
         }
         btn.addEventListener(MouseEvent.MOUSE_OUT,function(e:MouseEvent):*
         {
            e.currentTarget.gotoAndStop(1);
         });
         if(btn.hasEventListener(MouseEvent.MOUSE_OVER))
         {
            btn.removeEventListener(MouseEvent.MOUSE_OVER,function(e:MouseEvent):*
            {
               e.currentTarget.gotoAndStop(2);
            });
         }
         btn.addEventListener(MouseEvent.MOUSE_OVER,function(e:MouseEvent):*
         {
            e.currentTarget.gotoAndStop(1);
         });
         if(btn.hasEventListener(MouseEvent.CLICK))
         {
            btn.removeEventListener(MouseEvent.CLICK,fn);
         }
         if(txt != null)
         {
            btn["txt"].text = txt;
         }
         btn.enabled = false;
         btn.filters = [this.disableFilter];
      }
      
      private function alphaProcess() : *
      {
         var mc:MovieClip = this["profile"];
         mc["percentBar"].filters = [this.disableFilter];
         mc["timeBg"].filters = [this.disableFilter];
      }
      
      private function normalProcess() : *
      {
         var mc:MovieClip = this["profile"];
         mc["percentBar"].filters = null;
         mc["timeBg"].filters = null;
      }
      
      private function invisibleAllTrainingPanel(mode:int) : *
      {
         var mc:MovieClip = this["profile"];
         switch(mode)
         {
            case 0:
               mc["upgradeTxtIcon"].visible = false;
               mc["upgradeTitleTxt"].visible = false;
               mc["lbl_lv"].visible = false;
               mc["currentLvTxt"].visible = false;
               mc["arrow1"].visible = false;
               mc["nextLvTxt"].visible = false;
               mc["lbl_value"].visible = false;
               mc["currentValue"].visible = false;
               mc["arrow2"].visible = false;
               mc["nextValue"].visible = false;
               mc["lbl_goldNeed"].visible = false;
               mc["gold"].visible = false;
               mc["potionBtn"].visible = false;
               mc["trainingBtn"].visible = false;
               mc["noticeTxt"].visible = false;
               mc["goldIcon"].visible = false;
            case 1:
               mc["processIcon"].visible = false;
               mc["processTxt"].visible = false;
               mc["processTimeTxt"].visible = false;
               mc["percentBar"].visible = false;
               mc["timeBg"].visible = false;
               mc["arrowStart"].visible = false;
               mc["emblemBtn"].visible = false;
               mc["emblemTxt"].visible = false;
         }
      }
      
      private function visibleAllTrainingPanel() : *
      {
         var mc:MovieClip = this["profile"];
         mc["upgradeTxtIcon"].visible = true;
         mc["upgradeTitleTxt"].visible = true;
         mc["lbl_lv"].visible = true;
         mc["currentLvTxt"].visible = true;
         mc["arrow1"].visible = true;
         mc["nextLvTxt"].visible = true;
         mc["lbl_value"].visible = true;
         mc["currentValue"].visible = true;
         mc["arrow2"].visible = true;
         mc["nextValue"].visible = true;
         mc["lbl_goldNeed"].visible = true;
         mc["gold"].visible = true;
         mc["goldIcon"].visible = true;
         mc["processIcon"].visible = true;
         mc["processTxt"].visible = true;
         mc["processTimeTxt"].visible = true;
         mc["percentBar"].visible = true;
         mc["timeBg"].visible = true;
         mc["arrowStart"].visible = true;
         mc["emblemBtn"].visible = true;
         mc["emblemTxt"].visible = true;
         mc["potionBtn"].visible = true;
         mc["trainingBtn"].visible = true;
         mc["noticeTxt"].visible = true;
      }
      
      public function onPet() : void
      {
         var _pet:* = undefined;
         Out.debug(this,"MapMenu::onPet");
         var i:uint = 0;
         this.stop();
         this.petDataArr = Central.main.PET_DATA.toArray();
         var panel:MovieClip = this["pet"];
         this.initCloseBtn();
         this.selectedPetSlot = 1;
         this.selectedPetID = 0;
         Central.main.initButton(panel["petHotelBtn"],this.goPetHotel,Central.main.langLib.get(1649)[49]);
         this.petArray = Central.main.getMainChar().pets;
         if(this.preSelectClsName != "")
         {
            for(i = 0; i < this.petArray.length; i++)
            {
               _pet = this.petArray[i];
               if(this.preSelectClsName == _pet.clsName)
               {
                  this.selectedPetID = _pet.petId;
                  this.curPage = Math.ceil((i + 1) / 4);
                  break;
               }
            }
            this.preSelectClsName = "";
         }
         else
         {
            for(i = 0; i < this.petArray.length; i++)
            {
               _pet = this.petArray[i];
               if(_pet.isEquipped())
               {
                  this.selectedPetID = _pet.petId;
                  this.curPage = Math.ceil((i + 1) / 4);
                  break;
               }
            }
         }
         if(this.selectedPetID == 0)
         {
            this.selectedPetID = this.petArray[0].petId;
            this.curPage = 1;
         }
         panel["btnRename"].visible = false;
         this.loadingSelectedPetById();
      }
      
      private function goPetHotel(evt:MouseEvent) : void
      {
         Central.panel.getInstance().show("pet_hotel");
         this.hide();
      }
      
      private function loadingSelectedPetById() : void
      {
         var i:uint = 0;
         var swfToLoad:Array = new Array();
         var petArray:Array = Central.main.getMainChar().pets;
         if(this.petStorage.containsKey(this.selectedPetID) || Boolean(Central.main.getMainChar().getPetById(this.selectedPetID).isEquipped()))
         {
            this.loadingPetFinish();
         }
         else
         {
            for(i = 0; i < petArray.length; i++)
            {
               if(petArray[i].getPetId() == this.selectedPetID)
               {
                  swfToLoad.push("swf/pets/" + petArray[i].swfName + ".swf");
                  Out.debug(this,"swfToLoad=" + swfToLoad[i]);
               }
            }
            Central.main.loadSwf(swfToLoad,this.loadingPetFinish);
         }
      }
      
      private function loadingPetFinish(_swfObj:Object = null) : void
      {
         var i:uint = 0;
         var swfPath:String = null;
         var petArray:Array = Central.main.getMainChar().pets;
         if(_swfObj)
         {
            for(i = 0; i < petArray.length; i++)
            {
               if(petArray[i].getPetId() == this.selectedPetID)
               {
                  swfPath = "swf/pets/" + petArray[i].swfName + ".swf";
                  Out.debug(this,"swfPath=" + swfPath);
                  petArray[i].loadedSwf = _swfObj[swfPath];
                  this.petStorage.insert(this.selectedPetID,_swfObj[swfPath]);
               }
            }
         }
         this.showPetDetails();
      }
      
      private function onSelectPet(evt:MouseEvent) : void
      {
         this.selectedPetSlot = evt.currentTarget.slot;
         this.selectedPetID = evt.currentTarget.id;
         this.loadingSelectedPetById();
      }
      
      public function showPetDetails() : void
      {
         var i:uint = 0;
         var finalItemNumber:uint = 0;
         var max_bar1:* = undefined;
         var max_bar2:* = undefined;
         var _pet:* = undefined;
         var k:int = 0;
         var filterArr:Array = null;
         var current_expiry_arr:Array = null;
         var j:int = 0;
         var panel:MovieClip = this["pet"];
         GF.removeAllChild(panel["displayHolder"]);
         var ITEM_PER_PAGE:uint = 4;
         var isExpiryPet:Boolean = false;
         var btnSeq:uint = 0;
         var totalItem:uint = 0;
         this.petArray = Central.main.getMainChar().pets;
         totalItem = this.petArray.length;
         this.totalPage = Math.ceil(totalItem / ITEM_PER_PAGE);
         if(this.totalPage <= 0)
         {
            this.totalPage = 1;
         }
         if(this.totalPage < this.curPage)
         {
            this.curPage = this.totalPage;
         }
         finalItemNumber = this.curPage * ITEM_PER_PAGE;
         if(totalItem < finalItemNumber)
         {
            finalItemNumber = totalItem;
         }
         btnSeq = 1;
         i = 0;
         for(i = 1; i <= 4; i++)
         {
            panel["slot_" + i]["id"] = "";
            panel["slot_" + i]["slot"] = "";
            panel["slot_" + i].removeEventListener(MouseEvent.CLICK,this.onSelectPet);
            panel["slot_" + i]["nameTxt"].text = "";
            panel["slot_" + i]["levelTxt"].text = "";
            panel["slot_" + i]["lbl_lv_top"].text = "";
            panel["slot_" + i].buttonMode = false;
            panel["slot_" + i].gotoAndStop("blank");
            panel["slot_" + i]["iconActive"].gotoAndStop(1);
            panel["slot_" + i]["lbl_emptySlot"].text = Central.main.langLib.titleTxt(TitleData.PETSEMPTYSLOT);
         }
         i = 0;
         var pet:* = Central.main.getMainChar().getPetById(this.selectedPetID);
         this.currentPet = pet;
         if(Account.getAccountType() == Account.PREMIUM)
         {
            max_bar1 = Data.INV_SPACE_PET_PREMIUM / 3;
            max_bar2 = Data.INV_SPACE_PET_PREMIUM - max_bar1;
            panel["invBarMc"]["invMax"].text = "";
            panel["invBarMc"]["timebarMC"].visible = false;
            panel["invBarMc"]["timebarMC2"].visible = false;
            panel["invBarMc"]["timebarMC3"].visible = false;
            panel["invBarMc"]["gearIcon"].gotoAndStop("btnPet");
            panel["invBarMc"]["invTitle"].text = Central.main.langLib.get(1576) + ":";
            panel["invBarMc"]["invTxt"].text = this.petArray.length + "/" + Data.INV_SPACE_PET_PREMIUM;
            if(this.petArray.length >= Data.INV_SPACE_PET_PREMIUM)
            {
               panel["invBarMc"]["invMax"].text = Central.main.langLib.get(1577);
            }
            if(this.petArray.length <= max_bar1)
            {
               panel["invBarMc"]["timebarMC"].visible = true;
               panel["invBarMc"]["timebarMC"].scaleX = this.petArray.length / Data.INV_SPACE_PET_PREMIUM;
            }
            else if(this.petArray.length <= max_bar2)
            {
               panel["invBarMc"]["timebarMC2"].visible = true;
               panel["invBarMc"]["timebarMC2"].scaleX = this.petArray.length / Data.INV_SPACE_PET_PREMIUM;
            }
            else
            {
               panel["invBarMc"]["timebarMC3"].visible = true;
               panel["invBarMc"]["timebarMC3"].scaleX = this.petArray.length / Data.INV_SPACE_PET_PREMIUM;
            }
         }
         else
         {
            max_bar1 = Data.INV_SPACE_PET_FREE / 3;
            max_bar2 = Data.INV_SPACE_PET_FREE - max_bar1;
            panel["invBarMc"]["invMax"].text = "";
            panel["invBarMc"]["timebarMC"].visible = false;
            panel["invBarMc"]["timebarMC2"].visible = false;
            panel["invBarMc"]["timebarMC3"].visible = false;
            panel["invBarMc"]["gearIcon"].gotoAndStop("btnPet");
            panel["invBarMc"]["invTitle"].text = Central.main.langLib.get(1576) + ":";
            panel["invBarMc"]["invTxt"].text = this.petArray.length + "/" + Data.INV_SPACE_PET_FREE;
            if(this.petArray.length >= Data.INV_SPACE_PET_FREE)
            {
               panel["invBarMc"]["invMax"].text = Central.main.langLib.get(1577);
            }
            if(this.petArray.length <= max_bar1)
            {
               panel["invBarMc"]["timebarMC"].visible = true;
               panel["invBarMc"]["timebarMC"].scaleX = this.petArray.length / Data.INV_SPACE_PET_FREE;
            }
            else if(this.petArray.length <= max_bar2)
            {
               panel["invBarMc"]["timebarMC2"].visible = true;
               panel["invBarMc"]["timebarMC2"].scaleX = this.petArray.length / Data.INV_SPACE_PET_FREE;
            }
            else
            {
               panel["invBarMc"]["timebarMC3"].visible = true;
               panel["invBarMc"]["timebarMC3"].scaleX = this.petArray.length / Data.INV_SPACE_PET_FREE;
            }
         }
         for(i = (this.curPage - 1) * ITEM_PER_PAGE; i < finalItemNumber; i++)
         {
            _pet = this.petArray[i];
            panel["slot_" + btnSeq]["lbl_emptySlot"].text = "";
            if(this.selectedPetID == _pet.getPetId())
            {
               this.selectedPetSlot = btnSeq;
               panel["slot_" + btnSeq].gotoAndStop("selected");
               for(k = 0; k < this.petDataArr.length; k++)
               {
                  if(this.petDataArr[k].swfName == pet.swfName)
                  {
                     this.curPetDataId = this.petDataArr[k].id;
                     break;
                  }
               }
               this.petObj = Central.main.PET_DATA.find("pet" + this.curPetDataId);
               this.combineMaturity = this.petObj.combine_maturity;
               this.petMaxEP = this.petObj.ep_max;
               if(this.petObj.combine_maturity)
               {
                  this.combineMaturity = this.petObj.combine_maturity;
               }
               else
               {
                  this.combineMaturity = 0;
               }
               if(this.combineMaturity <= 0)
               {
                  panel["feedPetBtn"].visible = false;
                  panel["combinableMc"].visible = false;
               }
               else
               {
                  panel["feedPetBtn"].visible = true;
                  panel["combinableMc"].visible = true;
               }
               if(this.petObj.update_group == "")
               {
                  Central.main.disableButton(panel["upgradeBtn"],this.showPetLineDetails);
                  panel["upgradeBtn"].visible = false;
               }
               else
               {
                  Central.main.initButton(panel["upgradeBtn"],this.showPetLineDetails,ButtonData.UPGRADE);
                  panel["upgradeBtn"].visible = true;
               }
            }
            else
            {
               panel["slot_" + btnSeq].gotoAndStop("normal");
            }
            panel["slot_" + btnSeq]["id"] = _pet.getPetId();
            panel["slot_" + btnSeq]["slot"] = btnSeq;
            panel["slot_" + btnSeq].addEventListener(MouseEvent.CLICK,this.onSelectPet);
            panel["slot_" + btnSeq]["nameTxt"].text = _pet.getCharacterName();
            panel["slot_" + btnSeq]["levelTxt"].text = _pet.getLevel();
            panel["slot_" + btnSeq]["lbl_lv_top"].text = Central.main.langLib.titleTxt(TitleData.LV) + ".";
            panel["slot_" + btnSeq]["nameTxt"].mouseEnabled = false;
            panel["slot_" + btnSeq]["levelTxt"].mouseEnabled = false;
            panel["slot_" + btnSeq]["lbl_lv_top"].mouseEnabled = false;
            panel["slot_" + btnSeq]["lbl_emptySlot"].mouseEnabled = false;
            panel["slot_" + btnSeq].buttonMode = true;
            if(_pet.isEquipped())
            {
               panel["slot_" + btnSeq]["iconActive"].gotoAndStop(2);
            }
            else
            {
               panel["slot_" + btnSeq]["iconActive"].gotoAndStop(1);
            }
            btnSeq++;
         }
         Central.main.initButton(panel["feedPetBtn"],this.feedPetpopup,Central.main.langLib.get(1837));
         panel["feedPetBtn"].filters = null;
         panel["feedPetBtn"].enabled = true;
         if(this.currentPet.maturity >= 100)
         {
            Central.main.disableButton(panel["feedPetBtn"],this.feedPetpopup,Central.main.langLib.get(1837));
            panel["feedPetBtn"].filters = [this.disableFilter];
            panel["feedPetBtn"].enabled = false;
         }
         panel["pageTxt"].text = this.curPage + " / " + this.totalPage;
         panel["btnPrevPage"].addEventListener(MouseEvent.CLICK,this.changePetPage);
         panel["btnNextPage"].addEventListener(MouseEvent.CLICK,this.changePetPage);
         Central.main.initButton(panel["AddPetInvBtn"],this.invPopupCapacity,this.invTxtArr[11]);
         this.invBtnName = this.BTN_PET;
         panel["AddPetInvBtn"].filters = null;
         panel["AddPetInvBtn"].enabled = true;
         panel["AddPetInvBtn"].visible = true;
         panel["newMc1"].visible = true;
         panel["nameTxt"].text = pet.getCharacterName();
         panel["lvTxt"].text = pet.getLevel();
         panel["hpTxt"].text = String(pet.hp) + " / " + String(pet.maxHP);
         if(this.combineMaturity <= 0)
         {
            panel["mpTxt"].text = String(pet.maturity) + " / " + this.combineMaturity;
         }
         else
         {
            panel["mpTxt"].text = String(pet.maturity) + " / " + this.combineMaturity;
         }
         panel["xpTxt"].text = String(pet.xp - Formula.getPetXpByLv(pet.getLevel())) + " / " + String(Formula.getPetXpByLv(pet.getLevel() + 1) - Formula.getPetXpByLv(pet.getLevel()));
         if(this.combineMaturity <= 0)
         {
            filterArr = [this.disableFilter,this.disableFilter2];
            panel["mpBar"].filters = filterArr;
            panel["mpBar"].scaleX = 0.91;
         }
         else
         {
            panel["mpBar"].filters = null;
            panel["mpBar"].scaleX = pet.maturity / this.combineMaturity * 0.91;
         }
         panel["xpBar"].scaleX = (pet.xp - Formula.getPetXpByLv(pet.getLevel())) / (Formula.getPetXpByLv(pet.getLevel() + 1) - Formula.getPetXpByLv(pet.getLevel())) * 0.91;
         panel["damageTxt"].text = String(pet.getDamage());
         panel["agilityTxt"].text = String(pet.agility);
         panel["criticalTxt"].text = "5%";
         panel["dodgeTxt"].text = "5%";
         if(pet.isEquipped())
         {
            panel["activateBtn"].enabled = false;
            panel["activateBtn"].filters = [this.disableFilter];
            this.disableButton(panel["activateBtn"],this.activatePet,ButtonData.ACTIVATE);
            panel["deactivateBtn"].enabled = true;
            panel["deactivateBtn"].filters = null;
            Central.main.hideDynamicTooltip(panel["activateBtn"]);
            Central.main.initButton(panel["deactivateBtn"],this.deactivatePet,ButtonData.DEACTIVATE);
            panel["activateBtn"].visible = false;
            panel["deactivateBtn"].visible = true;
         }
         else
         {
            panel["activateBtn"].enabled = true;
            panel["activateBtn"].filters = null;
            Central.main.initButton(panel["activateBtn"],this.activatePet,ButtonData.ACTIVATE);
            Central.main.hideDynamicTooltip(panel["activateBtn"]);
            panel["deactivateBtn"].enabled = false;
            panel["deactivateBtn"].filters = [this.disableFilter];
            this.disableButton(panel["deactivateBtn"],this.deactivatePet,ButtonData.DEACTIVATE);
            panel["activateBtn"].visible = true;
            panel["deactivateBtn"].visible = false;
         }
         panel["displayHolder"].addChild(pet.getStaticFullBody());
         Central.main.initButton(panel["trashBtn"],this.deletePet,ButtonData.DISMISS);
         this.refreshPetSkill();
         Central.main.showDynamicTooltip(panel["Tooltip_Pet_Damage"],String("<font size=\'16\'>" + Central.main.langLib.get(260) + "</font>"));
         Central.main.showDynamicTooltip(panel["Tooltip_Pet_Critical"],String("<font size=\'16\'>" + Central.main.langLib.get(261) + "</font>"));
         Central.main.showDynamicTooltip(panel["Tooltip_Pet_Agility"],String("<font size=\'16\'>" + Central.main.langLib.get(262) + "</font>"));
         Central.main.showDynamicTooltip(panel["Tooltip_Pet_Dodge"],String("<font size=\'16\'>" + Central.main.langLib.get(263) + "</font>"));
         panel["lbl_pets_title"].text = Central.main.langLib.titleTxt(TitleData.PETS);
         panel["lbl_hp"].text = Central.main.langLib.titleTxt(TitleData.HP) + ":";
         if(this.combineMaturity <= 0)
         {
            panel["lbl_mp"].text = "MP" + ":";
         }
         else
         {
            panel["lbl_mp"].text = "MP" + ":";
         }
         panel["lbl_xp"].text = Central.main.langLib.titleTxt(TitleData.XP) + ":";
         panel["lbl_lv"].text = Central.main.langLib.titleTxt(TitleData.LV) + ".";
         panel["lbl_damage"].text = Central.main.langLib.titleTxt(TitleData.DAMAGE) + ":";
         panel["lbl_critical"].text = Central.main.langLib.titleTxt(TitleData.CRITICAL) + ":";
         panel["lbl_agility"].text = Central.main.langLib.titleTxt(TitleData.AGILITY) + ":";
         panel["lbl_dodge"].text = Central.main.langLib.titleTxt(TitleData.DODGE) + ":";
         if(Central.main.Features.FEATURE_EXPIRY_ITEM)
         {
            current_expiry_arr = Central.main.getMainChar().getData(DBCharacterData.EXPIRY_ITEM_CURRENT_EXPIRY_ARR);
            isExpiryPet = false;
            for(j = 0; j < current_expiry_arr.length; j++)
            {
               if(String(current_expiry_arr[j]).indexOf("pet_" + String(this.selectedPetID)) >= 0)
               {
                  isExpiryPet = true;
                  break;
               }
            }
            if(isExpiryPet)
            {
               panel["btnRename"].visible = false;
               Central.main.disableButton(panel["btnRename"],this.PetRename,Central.main.langLib.get(1315));
            }
            else
            {
               panel["btnRename"].visible = true;
               Central.main.initButton(panel["btnRename"],this.PetRename,Central.main.langLib.get(1315));
            }
         }
         else
         {
            panel["btnRename"].visible = true;
            Central.main.initButton(panel["btnRename"],this.PetRename,Central.main.langLib.get(1315));
         }
      }
      
      private function showPetLineDetails(evt:MouseEvent) : void
      {
         var i:int = 0;
         var pet:* = undefined;
         var upgradeData:Array = null;
         if(Central.main.getMainChar().getPetById(this.selectedPetID).training != null)
         {
            pet = Central.main.getMainChar().getPetById(this.selectedPetID);
            Central.main.showOk(String(Central.main.langLib.get(1756)[6]).replace("[valname]",pet.getCharacterName()));
            return;
         }
         this.isShowPetLinePromote = false;
         this.upgradeGrounp = this.petObj.update_group.split(",");
         this.petLineId = [];
         this.petLineLv = [];
         this.petLineObj = [];
         for(i = 0; i < this.upgradeGrounp.length; i++)
         {
            upgradeData = this.upgradeGrounp[i].split(":");
            this.petLineId.push(upgradeData[0]);
            this.petLineObj.push(Central.main.PET_DATA.find("pet" + upgradeData[0]));
            this.petLineLv.push(int(upgradeData[1]));
         }
         this.loadPetLineSwf();
      }
      
      public function onShowPetUpgradeWithMaterial(_mc:MovieClip) : void
      {
         if(this.isShowPetLinePromote)
         {
            this.showPetUpgradeInfoWithMat(_mc);
         }
         else
         {
            this.checkPetName();
         }
      }
      
      public function onShowPetLineDetails(_mc:MovieClip) : void
      {
         if(this.isShowPetLinePromote)
         {
            this.showPetUpgradeInfo(_mc);
         }
         else
         {
            this.checkPetName();
         }
      }
      
      public function showPetLinePromote(basePetId:String) : void
      {
         var i:int = 0;
         var upgradeData:Array = null;
         this.isShowPetLinePromote = true;
         this.curPetDataId = basePetId;
         this.petObj = Central.main.PET_DATA.find("pet" + this.curPetDataId);
         this.upgradeGrounp = this.petObj.update_group.split(",");
         this.petLineId = [];
         this.petLineLv = [];
         this.petLineObj = [];
         for(i = 0; i < this.upgradeGrounp.length; i++)
         {
            upgradeData = this.upgradeGrounp[i].split(":");
            this.petLineId.push(upgradeData[0]);
            this.petLineObj.push(Central.main.PET_DATA.find("pet" + upgradeData[0]));
            this.petLineLv.push(int(upgradeData[1]));
         }
         this.loadPetLineSwf();
      }
      
      private function loadDataFinish(swfObj:Object) : void
      {
         var dataTmp:MovieClip = null;
         var petDataTmp:Object = null;
         var key:String = null;
         var curStage:int = 0;
         var petLineObjTmp:Object = null;
         var upgradeDataTmp:Array = null;
         if(AppData.lang == AppData.ZH)
         {
            dataTmp = swfObj["swf/language/data_library_" + AppData.EN + ".swf"];
         }
         else
         {
            dataTmp = swfObj["swf/language/data_library_" + AppData.ZH + ".swf"];
         }
         var petObjTmp:Object = Central.main.getMainChar().getPetById(this.selectedPetID);
         petDataTmp = dataTmp.getPet();
         var petDataTmpHash:HashMap = new HashMap();
         for(key in petDataTmp)
         {
            petDataTmpHash.insert(key,petDataTmp[key]);
         }
         curStage = this.petLineId.indexOf(this.curPetDataId);
         upgradeDataTmp = this.upgradeGrounp[curStage].split(":");
         petLineObjTmp = petDataTmpHash.find("pet" + upgradeDataTmp[0]);
         if(petObjTmp.getCharacterName() != this.petLineObj[curStage].name && petObjTmp.getCharacterName() != petLineObjTmp.name)
         {
            this.changedPetName = true;
         }
         else
         {
            this.changedPetName = false;
         }
         this.showPetUpgradePanel();
      }
      
      private function checkPetName() : void
      {
         var swfToLoad:Array = [];
         if(AppData.lang == AppData.ZH)
         {
            swfToLoad.push({
               "path":"swf/language/data_library_" + AppData.EN + ".swf",
               "version":AppData.dataVer
            });
            Central.main.loadSwfByVersion(swfToLoad,this.loadDataFinish,null,null);
         }
         else
         {
            swfToLoad.push({
               "path":"swf/language/data_library_" + AppData.ZH + ".swf",
               "version":AppData.dataVer
            });
            Central.main.loadSwfByVersion(swfToLoad,this.loadDataFinish,null,null);
         }
      }
      
      private function showPetUpgradePanel() : void
      {
         var mc:MovieClip = null;
         var i:* = undefined;
         var petObjTmp:Object = null;
         var itemArr:Array = null;
         var eachItemArr:Array = null;
         var eachItemId:String = null;
         var eachItemAmount:int = 0;
         var petDisplay:MovieClip = null;
         var actionBase:* = undefined;
         var petSkillData:Array = null;
         var skillMc:MovieClip = null;
         var Description:String = null;
         var k:int = 0;
         if(this.petLineObj[1].update_material.material == "")
         {
            mc = this["petUpgrade"]["panelMC"];
         }
         else
         {
            mc = this["popupPetUpgradeWithMat"]["panelMC"];
         }
         var j:int = 0;
         var changedPetName:Boolean = false;
         this.canUpgradePet = true;
         petObjTmp = Central.main.getMainChar().getPetById(this.selectedPetID);
         if(this.petLineObj[1].update_material.material == "")
         {
            mc["btnClose"].addEventListener(MouseEvent.CLICK,this.hidePetLineDetails);
         }
         else
         {
            mc["btnClose"].addEventListener(MouseEvent.CLICK,this.hidePetUpgradeDetailsWithMat);
         }
         var curStage:int = this.petLineId.indexOf(this.curPetDataId);
         for(i = 0; i < 3; i++)
         {
            if(i < this.upgradeGrounp.length)
            {
               mc["stage_" + i].visible = true;
               mc["stage_" + i]["verTxt"].visible = true;
               mc["stage_" + i]["verTxt"].text = String(Central.main.langLib.get(1751)[3]);
               mc["stage_" + i]["currentLvTxt"].visible = true;
               mc["stage_" + i]["currentLvTxt"].text = Central.main.langLib.get(1751)[4].replace("[currentlv]",petObjTmp.getLevel());
               if(this.changedPetName)
               {
                  mc["stage_" + i]["petName"].text = petObjTmp.getCharacterName();
               }
               else
               {
                  mc["stage_" + i]["petName"].text = this.petLineObj[i].name;
               }
               if(this.petLineObj[1].update_material.material == "")
               {
                  mc["stage_" + i]["board"].visible = true;
               }
               mc["title"].visible = false;
               if(i == 0)
               {
                  mc["stage_" + i]["upgrade_requirement"].text = "";
               }
               else
               {
                  mc["stage_" + i]["upgrade_requirement"].text = String(Central.main.langLib.get(1751)[1]).replace("[lv]",String(this.petLineLv[i - 1]));
               }
               mc["stage_" + i]["Tooltip_Pet_Upgrade"].visible = true;
               Central.main.showDynamicTooltip(mc["stage_" + i]["Tooltip_Pet_Upgrade"],String("<font size=\'16\'>" + Central.main.langLib.get(1751)[2] + "</font>"));
               GF.removeAllChild(mc["stage_" + i]["displayHolder"]);
               petDisplay = this.petLineSwfObj["swf/pets/" + this.petLineObj[i].swfName + ".swf"];
               mc["stage_" + i]["displayHolder"].addChild(GF.getAsset(petDisplay,"StaticFullBody"));
               actionBase = GF.getAsset(petDisplay,this.petLineObj[i].clsName);
               petSkillData = actionBase.skillData;
               for(j = 1; j <= 6; j++)
               {
                  skillMc = mc["stage_" + i]["skill_" + String(j)];
                  GF.removeAllChild(skillMc["holder"]);
                  skillMc.gotoAndStop(1);
                  skillMc.buttonMode = false;
                  skillMc["trainTxt"].text = "";
                  Central.main.hideDynamicTooltip(skillMc);
               }
               for(j = 0; j < petSkillData.length; j++)
               {
                  skillMc = mc["stage_" + i]["skill_" + String(j + 1)];
                  skillMc["holder"].addChild(GF.getAsset(petDisplay,petSkillData[j].cls));
                  skillMc.gotoAndStop("enable");
                  skillMc.filters = null;
                  Description = String("<font size=\'16\'>" + petSkillData[j].description + "</font>");
                  Central.main.showDynamicTooltip(skillMc,Description);
               }
               if(i <= curStage)
               {
                  if(this.petLineObj[1].update_material.material == "")
                  {
                     mc["stage_" + i]["price"].visible = false;
                  }
                  else
                  {
                     for(k = 0; k < 3; k++)
                     {
                        mc["stage_" + i]["item_" + k].visible = false;
                     }
                  }
                  mc["stage_" + i]["buyBtn"].visible = false;
                  Central.main.disableButton(mc["stage_" + i]["buyBtn"],this.upgradePet,ButtonData.UPGRADE);
                  mc["stage_" + i]["tick"].visible = true;
               }
               else if(i == curStage + 1)
               {
                  if(this.petLineObj[1].update_material.material == "")
                  {
                     mc["stage_" + i]["price"].visible = true;
                     mc["stage_" + i]["price"]["priceTxt"].text = this.petLineObj[i].update_token;
                  }
                  else
                  {
                     for(k = 0; k < 3; k++)
                     {
                        mc["stage_" + i]["item_" + k].visible = false;
                     }
                     itemArr = this.petLineObj[1].update_material.material.split(",");
                     for(k = 0; k < itemArr.length; k++)
                     {
                        mc["stage_" + i]["item_" + k].visible = true;
                        eachItemArr = itemArr[k].split(":");
                        eachItemId = eachItemArr[0];
                        eachItemAmount = int(eachItemArr[1]);
                        this.updateCanUpgradePetMC("item" + eachItemId,eachItemAmount,mc["stage_" + i]["item_" + k]);
                     }
                  }
                  mc["stage_" + i]["buyBtn"].visible = true;
                  mc["stage_" + i]["buyBtn"].id = i;
                  if(this.canUpgradePet)
                  {
                     Central.main.initButton(mc["stage_" + i]["buyBtn"],this.upgradePet,ButtonData.UPGRADE);
                     mc["stage_" + i]["buyBtn"].filters = null;
                  }
                  else
                  {
                     Central.main.disableButton(mc["stage_" + i]["buyBtn"],this.upgradePet,ButtonData.UPGRADE);
                     mc["stage_" + i]["buyBtn"].filters = [this.dimFilter];
                  }
                  mc["stage_" + i]["tick"].visible = false;
               }
               else
               {
                  if(this.petLineObj[1].update_material.material == "")
                  {
                     mc["stage_" + i]["price"].visible = true;
                     mc["stage_" + i]["price"]["priceTxt"].text = this.petLineObj[i].update_token;
                  }
                  else
                  {
                     for(k = 0; k < 3; k++)
                     {
                        mc["stage_" + i]["item_" + k].visible = false;
                     }
                     itemArr = this.petLineObj[1].update_material.material.split(",");
                     for(k = 0; k < itemArr.length; k++)
                     {
                        mc["stage_" + i]["item_" + k].visible = true;
                        eachItemArr = itemArr[k].split(":");
                        eachItemId = eachItemArr[0];
                        eachItemAmount = int(eachItemArr[1]);
                        this.updateCanUpgradePetMC("item" + eachItemId,eachItemAmount,mc["stage_" + i]["item_" + k]);
                     }
                  }
                  mc["stage_" + i]["buyBtn"].visible = true;
                  mc["stage_" + i]["buyBtn"].id = i;
                  Central.main.disableButton(mc["stage_" + i]["buyBtn"],this.upgradePet,ButtonData.UPGRADE);
                  mc["stage_" + i]["buyBtn"].filters = [this.dimFilter];
                  mc["stage_" + i]["tick"].visible = false;
               }
               switch(i)
               {
                  case 0:
                     mc["stage_" + i]["level"].text = i + 1 + "st";
                     break;
                  case 1:
                     mc["stage_" + i]["level"].text = i + 1 + "nd";
                     mc["arrow_" + i].visible = true;
                     break;
                  case 2:
                     mc["stage_" + i]["level"].text = i + 1 + "rd";
                     mc["arrow_" + i].visible = true;
               }
            }
            else
            {
               mc["stage_" + i].visible = false;
               mc["arrow_" + i].visible = false;
            }
         }
      }
      
      private function updateCanUpgradePetMC(itemId:String, needQua:uint, mc:MovieClip) : Boolean
      {
         var obj:Object = null;
         var enough:Boolean = true;
         var itemData:Object = new Object();
         var InvInStr:String = "";
         var InvCountArr:Array = [];
         var objArr:Array = [];
         var InvQua:uint = 0;
         var txt1:String = "";
         var txt2:String = "";
         InvInStr = Central.main.getMainChar().getInventory(InventoryData.TYPE_MATERIAL).toString();
         InvInStr += ",";
         InvCountArr = InvInStr.split(String(itemId) + ",");
         if(int(InvCountArr.length - 1) >= 1)
         {
            InvQua = InvCountArr.length - 1;
         }
         itemData = Central.main.toolkit.getDisplayData(itemId);
         GF.removeAllChild(mc["iconMC"]["iconHolder"]);
         mc["iconMC"]["iconHolder"].addChild(itemData.mc);
         Central.main.hideDynamicTooltip(mc["iconMC"]);
         Central.main.showDynamicTooltip(mc["iconMC"],String("<font size=\'16\'>" + itemData.tooltip + "</font>"));
         if(InvQua >= needQua)
         {
            InvQua = needQua;
         }
         txt1 = String(InvQua);
         txt2 = String(needQua);
         if(InvQua >= needQua)
         {
            mc["txt1"].htmlText = "<font color=\'#00FF00\'>" + txt1 + "</font>";
            mc["txt2"].htmlText = "<font color=\'#00FF00\'>" + txt2 + "</font>";
         }
         else
         {
            mc["txt1"].htmlText = "<font color=\'#FF0000\'>" + txt1 + "</font>";
            mc["txt2"].htmlText = "<font color=\'#FF0000\'>" + txt2 + "</font>";
            enough = false;
            this.canUpgradePet = enough;
         }
         return enough;
      }
      
      private function onClickGoGashapon(evt:MouseEvent) : *
      {
         this.hidePetLineDetails();
         Central.panel.getInstance().show("Panel_Christmas_2013_Gashapon");
      }
      
      private function showPetUpgradeInfoWithMat(_mc:MovieClip) : void
      {
         var i:* = undefined;
         var petDataObj:Object = null;
         var petDisplay:MovieClip = null;
         var actionBase:* = undefined;
         var petSkillData:Array = null;
         var skillMc:MovieClip = null;
         var Description:String = null;
         var mc:MovieClip = _mc["panelMC"];
         var j:int = 0;
         var isLast:Boolean = false;
         var promoteLangArr:Array = Central.main.langLib.get(1756);
         mc["btnClose"].addEventListener(MouseEvent.CLICK,this.hidePetUpgradeDetailsWithMat);
         for(i = 0; i < 3; i++)
         {
            if(i < this.upgradeGrounp.length && !isLast)
            {
               if(int(this.petLineLv[i]) >= 9999)
               {
                  isLast = true;
               }
               mc["stage_" + i]["currentLvTxt"].visible = false;
               mc["stage_" + i]["verTxt"].visible = true;
               mc["stage_" + i]["verTxt"].text = String(Central.main.langLib.get(1751)[3]);
               mc["stage_" + i].visible = true;
               mc["stage_" + i]["petName"].text = this.petLineObj[i].name;
               if(this.petLineObj[1].update_material.material == "")
               {
                  mc["stage_" + i]["board"].visible = false;
               }
               mc["stage_" + i]["tick"].visible = false;
               mc["stage_" + i]["Tooltip_Pet_Upgrade"].visible = false;
               mc["title"].visible = true;
               mc["title"]["titleTxt"].text = promoteLangArr[0];
               if(i == 0)
               {
                  petDataObj = Central.main.PET_DATA.find("pet" + this.petLineId[i]);
                  if(Central.main.getMainChar().hasPet(petDataObj.clsName))
                  {
                     mc["stage_" + i]["upgrade_requirement"].text = promoteLangArr[2];
                     mc["stage_" + i]["buyBtn"].filters = [this.dimFilter];
                     Central.main.disableButton(mc["stage_" + i]["buyBtn"],this.onClickGoToBuyPet,ButtonData.PETSHOP);
                     mc["stage_" + i]["buyBtn"]["btn"].gotoAndStop(1);
                  }
                  else
                  {
                     mc["stage_" + i]["upgrade_requirement"].text = promoteLangArr[1];
                     mc["stage_" + i]["buyBtn"].filters = null;
                     Central.main.initButton(mc["stage_" + i]["buyBtn"],this.onClickGoToBuyPet,ButtonData.PETSHOP);
                  }
               }
               else
               {
                  petDataObj = Central.main.PET_DATA.find("pet" + this.petLineId[i - 1]);
                  if(Central.main.getMainChar().hasPet(petDataObj.clsName))
                  {
                     mc["stage_" + i]["upgrade_requirement"].text = promoteLangArr[3];
                     mc["stage_" + i]["buyBtn"].filters = null;
                     mc["stage_" + i]["buyBtn"].petClsName = petDataObj.clsName;
                     Central.main.initButton(mc["stage_" + i]["buyBtn"],this.onClickGoToUpgradePet,ButtonData.UPGRADE);
                  }
                  else
                  {
                     mc["stage_" + i]["upgrade_requirement"].text = promoteLangArr[i + 3];
                     mc["stage_" + i]["buyBtn"].filters = [this.dimFilter];
                     Central.main.disableButton(mc["stage_" + i]["buyBtn"],this.onClickGoToUpgradePet,ButtonData.UPGRADE);
                     mc["stage_" + i]["buyBtn"]["btn"].gotoAndStop(1);
                  }
               }
               GF.removeAllChild(mc["stage_" + i]["displayHolder"]);
               petDisplay = this.petLineSwfObj["swf/pets/" + this.petLineObj[i].swfName + ".swf"];
               mc["stage_" + i]["displayHolder"].addChild(GF.getAsset(petDisplay,"StaticFullBody"));
               actionBase = GF.getAsset(petDisplay,this.petLineObj[i].clsName);
               petSkillData = actionBase.skillData;
               for(j = 1; j <= 6; j++)
               {
                  skillMc = mc["stage_" + i]["skill_" + String(j)];
                  GF.removeAllChild(skillMc["holder"]);
                  skillMc.gotoAndStop(1);
                  skillMc.buttonMode = false;
                  skillMc["trainTxt"].text = "";
                  Central.main.hideDynamicTooltip(skillMc);
               }
               for(j = 0; j < petSkillData.length; j++)
               {
                  skillMc = mc["stage_" + i]["skill_" + String(j + 1)];
                  skillMc["holder"].addChild(GF.getAsset(petDisplay,petSkillData[j].cls));
                  skillMc.gotoAndStop("enable");
                  skillMc.filters = null;
                  Description = String("<font size=\'16\'>" + petSkillData[j].description + "</font>");
                  Central.main.showDynamicTooltip(skillMc,Description);
               }
               switch(i)
               {
                  case 0:
                     mc["stage_" + i]["level"].text = i + 1 + "st";
                     break;
                  case 1:
                     mc["stage_" + i]["level"].text = i + 1 + "nd";
                     mc["arrow_" + i].visible = true;
                     break;
                  case 2:
                     mc["stage_" + i]["level"].text = i + 1 + "rd";
                     mc["arrow_" + i].visible = true;
               }
            }
            else
            {
               mc["stage_" + i].visible = false;
               mc["arrow_" + i].visible = false;
            }
         }
      }
      
      private function showPetUpgradeInfo(_mc:MovieClip) : void
      {
         var i:* = undefined;
         var petDataObj:Object = null;
         var petDisplay:MovieClip = null;
         var actionBase:* = undefined;
         var petSkillData:Array = null;
         var skillMc:MovieClip = null;
         var Description:String = null;
         var mc:MovieClip = _mc["panelMC"];
         var j:int = 0;
         var isLast:Boolean = false;
         var promoteLangArr:Array = Central.main.langLib.get(1756);
         mc["btnClose"].addEventListener(MouseEvent.CLICK,this.hidePetLineDetails);
         for(i = 0; i < 3; i++)
         {
            if(i < this.upgradeGrounp.length && !isLast)
            {
               if(int(this.petLineLv[i]) >= 9999)
               {
                  isLast = true;
               }
               mc["stage_" + i]["currentLvTxt"].visible = false;
               mc["stage_" + i]["verTxt"].visible = true;
               mc["stage_" + i]["verTxt"].text = String(Central.main.langLib.get(1751)[3]);
               mc["stage_" + i].visible = true;
               mc["stage_" + i]["petName"].text = this.petLineObj[i].name;
               if(this.petLineObj[1].update_material.material == "")
               {
                  mc["stage_" + i]["board"].visible = false;
                  mc["stage_" + i]["price"].visible = false;
               }
               mc["stage_" + i]["tick"].visible = false;
               mc["stage_" + i]["Tooltip_Pet_Upgrade"].visible = false;
               mc["title"].visible = true;
               mc["title"]["titleTxt"].text = promoteLangArr[0];
               if(i == 0)
               {
                  petDataObj = Central.main.PET_DATA.find("pet" + this.petLineId[i]);
                  if(Central.main.getMainChar().hasPet(petDataObj.clsName))
                  {
                     mc["stage_" + i]["upgrade_requirement"].text = promoteLangArr[2];
                     mc["stage_" + i]["buyBtn"].filters = [this.dimFilter];
                     Central.main.disableButton(mc["stage_" + i]["buyBtn"],this.onClickGoToBuyPet,ButtonData.PETSHOP);
                     mc["stage_" + i]["buyBtn"]["btn"].gotoAndStop(1);
                  }
                  else
                  {
                     mc["stage_" + i]["upgrade_requirement"].text = promoteLangArr[1];
                     mc["stage_" + i]["buyBtn"].filters = null;
                     Central.main.initButton(mc["stage_" + i]["buyBtn"],this.onClickGoToBuyPet,ButtonData.PETSHOP);
                  }
               }
               else
               {
                  petDataObj = Central.main.PET_DATA.find("pet" + this.petLineId[i - 1]);
                  if(Central.main.getMainChar().hasPet(petDataObj.clsName))
                  {
                     mc["stage_" + i]["upgrade_requirement"].text = promoteLangArr[3];
                     mc["stage_" + i]["buyBtn"].filters = null;
                     mc["stage_" + i]["buyBtn"].petClsName = petDataObj.clsName;
                     Central.main.initButton(mc["stage_" + i]["buyBtn"],this.onClickGoToUpgradePet,ButtonData.UPGRADE);
                  }
                  else
                  {
                     mc["stage_" + i]["upgrade_requirement"].text = promoteLangArr[i + 3];
                     mc["stage_" + i]["buyBtn"].filters = [this.dimFilter];
                     Central.main.disableButton(mc["stage_" + i]["buyBtn"],this.onClickGoToUpgradePet,ButtonData.UPGRADE);
                     mc["stage_" + i]["buyBtn"]["btn"].gotoAndStop(1);
                  }
               }
               GF.removeAllChild(mc["stage_" + i]["displayHolder"]);
               petDisplay = this.petLineSwfObj["swf/pets/" + this.petLineObj[i].swfName + ".swf"];
               mc["stage_" + i]["displayHolder"].addChild(GF.getAsset(petDisplay,"StaticFullBody"));
               actionBase = GF.getAsset(petDisplay,this.petLineObj[i].clsName);
               petSkillData = actionBase.skillData;
               for(j = 1; j <= 6; j++)
               {
                  skillMc = mc["stage_" + i]["skill_" + String(j)];
                  GF.removeAllChild(skillMc["holder"]);
                  skillMc.gotoAndStop(1);
                  skillMc.buttonMode = false;
                  skillMc["trainTxt"].text = "";
                  Central.main.hideDynamicTooltip(skillMc);
               }
               for(j = 0; j < petSkillData.length; j++)
               {
                  skillMc = mc["stage_" + i]["skill_" + String(j + 1)];
                  skillMc["holder"].addChild(GF.getAsset(petDisplay,petSkillData[j].cls));
                  skillMc.gotoAndStop("enable");
                  skillMc.filters = null;
                  Description = String("<font size=\'16\'>" + petSkillData[j].description + "</font>");
                  Central.main.showDynamicTooltip(skillMc,Description);
               }
               switch(i)
               {
                  case 0:
                     mc["stage_" + i]["level"].text = i + 1 + "st";
                     break;
                  case 1:
                     mc["stage_" + i]["level"].text = i + 1 + "nd";
                     mc["arrow_" + i].visible = true;
                     break;
                  case 2:
                     mc["stage_" + i]["level"].text = i + 1 + "rd";
                     mc["arrow_" + i].visible = true;
               }
            }
            else
            {
               mc["stage_" + i].visible = false;
               mc["arrow_" + i].visible = false;
            }
         }
      }
      
      private function onClickGoToBuyPet(evt:MouseEvent) : void
      {
         this.hidePetLineDetails();
         Central.panel.getInstance().show("pet_shop");
      }
      
      private function onClickGoToUpgradePet(evt:MouseEvent) : void
      {
         this.hidePetLineDetails();
         Central.main.showUpgradePet(evt.currentTarget.petClsName);
      }
      
      private function loadPetLineSwf() : *
      {
         var i:int = 0;
         var swfArr:Array = [];
         try
         {
            for(i = 0; i < this.petLineObj.length; i++)
            {
               swfArr.push("swf/pets/" + this.petLineObj[i].swfName + ".swf");
            }
            if(swfArr.length > 0)
            {
               Central.main.loadSwf(swfArr,this.loadDisplayPetLineFinish);
            }
         }
         catch(err:Error)
         {
            Out.error(this,"Can not loadSwf :: " + err.message);
         }
      }
      
      private function loadDisplayPetLineFinish(swfObj:Object) : void
      {
         this.petLineSwfObj = swfObj;
         if(this.petLineObj[1].update_material.material != "")
         {
            this["popupPetUpgradeWithMat"].gotoAndPlay(Timeline.SHOW);
         }
         else
         {
            this["petUpgrade"].gotoAndPlay(Timeline.SHOW);
         }
      }
      
      public function hidePetLineDetails(evt:MouseEvent = null) : void
      {
         this["petUpgrade"].gotoAndPlay(Timeline.EXIT);
      }
      
      public function hidePetUpgradeDetailsWithMat(evt:MouseEvent = null) : void
      {
         this["popupPetUpgradeWithMat"].gotoAndPlay(Timeline.EXIT);
      }
      
      private function upgradePet(evt:MouseEvent) : void
      {
         var warningTxt:String = null;
         var btn:MovieClip = MovieClip(evt.currentTarget);
         this.curUpgradePetIndex = btn.id;
         var curPetLv:* = Central.main.getMainChar().getPetById(this.selectedPetID).getLevel();
         var requireLv:* = int(this.petLineLv[this.curUpgradePetIndex - 1]);
         if(curPetLv < requireLv)
         {
            warningTxt = String(Central.main.langLib.get(1751)[0]).replace("[lv]",requireLv);
            Central.main.showOk(warningTxt,new Function());
            return;
         }
         if(Account.getAccountBalance() < this.petLineObj[this.curUpgradePetIndex].update_token)
         {
            Central.main.getGoldToken(Central.main.langLib.get(1405),Central.main.gotoPaymentGateway,"token");
            return;
         }
         Central.main.showAmfLoading();
         Central.main.amfClient.service("CharacterDAO.upgradePet",[Central.main.account.getAccountSessionKey(),this.selectedPetID,this.petLineId[btn.id - 1],AppData.lang],this.upgradePetResponse);
      }
      
      private function upgradePetResponse(response:Object) : void
      {
         var iconData:Object = null;
         var isPetEquipped:Boolean = false;
         var petArray:Array = null;
         var i:uint = 0;
         var curStage:int = 0;
         var itemArr:Array = null;
         var eachItemArr:Array = null;
         var eachItemId:String = null;
         var eachItemAmount:int = 0;
         var j:int = 0;
         if(Central.main.validateAmfResponse(response))
         {
            petArray = Central.main.getMainChar().pets;
            for(i = 0; i < petArray.length; i++)
            {
               if(petArray[i].getPetId() == this.selectedPetID)
               {
                  isPetEquipped = Boolean(petArray[i].isEquipped());
                  break;
               }
            }
            if(isPetEquipped)
            {
               Central.main.getMainChar().deactivatePet();
            }
            Central.main.getMainChar().removePet(this.selectedPetID);
            iconData = Central.main.toolkit.getDisplayData("pet" + this.petLineId[this.curUpgradePetIndex],response.result);
            Central.main.toolkit.DisplayDataAddInventory(iconData);
            if(this.petLineObj[1].update_material.material != "")
            {
               itemArr = this.petLineObj[1].update_material.material.split(",");
               for(i = 0; i < itemArr.length; i++)
               {
                  eachItemArr = itemArr[i].split(":");
                  eachItemId = "item" + eachItemArr[0];
                  eachItemAmount = int(eachItemArr[1]);
                  for(j = 0; j < eachItemAmount; j++)
                  {
                     Central.main.getMainChar().removeInventory(InventoryData.TYPE_MATERIAL,eachItemId);
                  }
               }
            }
            Central.main.account.balance = Central.main.account.getAccountBalance() - int(this.petLineObj[this.curUpgradePetIndex].update_token);
            Central.main.updateMenu();
            curStage = this.petLineId.indexOf(this.curPetDataId);
            this.curPetDataId = this.petLineId[curStage + 1];
            this.showPetUpgradePanel();
            this.petStorage.remove(this.selectedPetID);
            this.loadingSelectedPetById();
            Central.main.hideAmfLoading();
            if(isPetEquipped)
            {
               Central.main.getMainChar().activatePet(this.selectedPetID);
            }
         }
      }
      
      private function changePetPage(evt:MouseEvent) : void
      {
         switch(evt.currentTarget.name)
         {
            case "btnPrevPage":
               --this.curPage;
               if(this.curPage < 1)
               {
                  this.curPage = 1;
                  Central.main.showInfo(Central.main.langLib.get(57));
                  return;
               }
               break;
            case "btnNextPage":
               ++this.curPage;
               if(this.curPage > this.totalPage)
               {
                  this.curPage = this.totalPage;
                  Central.main.showInfo(Central.main.langLib.get(58));
                  return;
               }
         }
         this.showPetDetails();
      }
      
      private function onEquipment() : void
      {
         this.stop();
         this.initCloseBtn();
         var equPanel:MovieClip = this["equipmentPanel"];
         equPanel["char_lv"].text = "Lv. " + this.THISCHAR_LV;
         equPanel["lbl_gear_title"].text = Central.main.langLib.titleTxt(TitleData.GEAR);
         Central.main.initButton(equPanel["clearBtn"],this.resetPreviewEquipment,ButtonData.CLEAR);
         GF.removeAllChild(equPanel["charMc"]);
         var char_swf:MovieClip = Central.main.getMainChar().getSwf();
         char_swf.scaleX *= this.CHARACTER_SCALE;
         char_swf.scaleY *= this.CHARACTER_SCALE;
         Central.main.getMainChar().customizeCharacter();
         equPanel["charMc"].addChild(char_swf);
         Central.main.getMainChar().playStand();
         this.initEquipmentBtn();
         this.updateEquipmentList();
      }
      
      private function initEquipmentBtn() : void
      {
         var i:int = 0;
         var tabStr:String = null;
         var equPanel:MovieClip = this["equipmentPanel"];
         if(Central.main.Features.FEATURE_ESSENCE)
         {
            if(Central.main.Features.FEATURE_MATERIAL)
            {
               this.menuTabArr = [this.BTN_WEAPON,this.BTN_CLOTHING,this.BTN_BACKITEM,this.BTN_ACCESSORY,this.BTN_ITEM,this.BTN_ESSENCE,this.BTN_MATERIAL,this.BTN_TRADING];
            }
            else
            {
               this.menuTabArr = [this.BTN_WEAPON,this.BTN_CLOTHING,this.BTN_BACKITEM,this.BTN_ACCESSORY,this.BTN_ITEM,this.BTN_ESSENCE,this.BTN_TRADING];
               equPanel[this.BTN_MATERIAL].visible = false;
            }
         }
         else
         {
            if(Central.main.Features.FEATURE_MATERIAL)
            {
               this.menuTabArr = [this.BTN_WEAPON,this.BTN_CLOTHING,this.BTN_BACKITEM,this.BTN_ACCESSORY,this.BTN_ITEM,this.BTN_MATERIAL,this.BTN_TRADING];
            }
            else
            {
               this.menuTabArr = [this.BTN_WEAPON,this.BTN_CLOTHING,this.BTN_BACKITEM,this.BTN_ACCESSORY,this.BTN_ITEM,this.BTN_TRADING];
               equPanel[this.BTN_MATERIAL].visible = false;
            }
            equPanel[this.BTN_ESSENCE].visible = false;
         }
         Central.main.shiftBtnPos(equPanel,this.menuTabArr,Central.main.SHIFT_X_LEFT);
         if(Central.main.checkGameStatus() == Timeline.BATTLE)
         {
            this.curEquipmentType = this.BTN_ITEM;
            this.curDataList = Central.main.ITEM_DATA;
            this.charInvArr = ArrayUtil.copyArray(Central.main.getMainChar().getInventory(InventoryData.TYPE_ITEM));
         }
         else if(Central.main.tradeitem == true)
         {
            Central.main.tradeitem = false;
            this.curEquipmentType = this.BTN_TRADING;
            this.charInvArr = ArrayUtil.copyArray(Central.main.getMainChar().getInventory(InventoryData.TYPE_TRADING));
         }
         else
         {
            this.curEquipmentType = this.BTN_WEAPON;
            this.curDataList = Central.main.WEAPON_DATA;
            this.charInvArr = ArrayUtil.copyArray(Central.main.getMainChar().getInventory(InventoryData.TYPE_WEAPON));
            if(Central.main.getMainChar().getrealWeapon())
            {
               this.charInvArr.push(Central.main.getMainChar().getrealWeapon());
            }
         }
         for(i = 0; i < this.menuTabArr.length; i++)
         {
            tabStr = "";
            Central.main.hideDynamicTooltip(equPanel[this.menuTabArr[i]]);
            switch(this.menuTabArr[i])
            {
               case this.BTN_TRADING:
                  if(Central.battle.type == Central.battle.TYPE_NETWORK || Central.main.HitAi == true)
                  {
                     tabStr = String("<b><font size=\'16\' color=\'#990000\'>" + String(Central.main.langLib.get(1089)).replace("[valtype]",Central.main.langLib.titleTxt(TitleData.TRADING)) + "</font></b>");
                  }
                  else
                  {
                     tabStr = String("<font size=\'16\'>" + Central.main.langLib.titleTxt(TitleData.TRADING) + "</font>");
                  }
                  break;
               case this.BTN_WEAPON:
                  if(Central.battle.type == Central.battle.TYPE_NETWORK || Central.main.HitAi == true)
                  {
                     tabStr = String("<b><font size=\'16\' color=\'#990000\'>" + String(Central.main.langLib.get(1089)).replace("[valtype]",Central.main.langLib.titleTxt(TitleData.WEAPON)) + "</font></b>");
                  }
                  else
                  {
                     tabStr = String("<font size=\'16\'>" + Central.main.langLib.titleTxt(TitleData.WEAPON) + "</font>");
                  }
                  break;
               case this.BTN_CLOTHING:
                  if(Central.battle.type == Central.battle.TYPE_NETWORK || Central.main.HitAi == true)
                  {
                     tabStr = String("<b><font size=\'16\' color=\'#990000\'>" + String(Central.main.langLib.get(1089)).replace("[valtype]",Central.main.langLib.titleTxt(TitleData.CLOTHING_TOOLTIP)) + "</font></b>");
                  }
                  else
                  {
                     tabStr = String("<font size=\'16\'>" + Central.main.langLib.titleTxt(TitleData.CLOTHING_TOOLTIP) + "</font>");
                  }
                  break;
               case this.BTN_BACKITEM:
                  if(Central.battle.type == Central.battle.TYPE_NETWORK || Central.main.HitAi == true)
                  {
                     tabStr = String("<b><font size=\'16\' color=\'#990000\'>" + String(Central.main.langLib.get(1089)).replace("[valtype]",Central.main.langLib.btnTxt(ButtonData.BACK_ITEM)) + "</font></b>");
                  }
                  else
                  {
                     tabStr = String("<font size=\'16\'>" + Central.main.langLib.btnTxt(ButtonData.BACK_ITEM) + "</font>");
                  }
                  break;
               case this.BTN_ACCESSORY:
                  if(Central.battle.type == Central.battle.TYPE_NETWORK || Central.main.HitAi == true)
                  {
                     tabStr = String("<b><font size=\'16\' color=\'#990000\'>" + String(Central.main.langLib.get(1089)).replace("[valtype]",Central.main.langLib.titleTxt(TitleData.ACCESSORY)) + "</font></b>");
                  }
                  else
                  {
                     tabStr = String("<font size=\'16\'>" + Central.main.langLib.titleTxt(TitleData.ACCESSORY) + "</font>");
                  }
                  break;
               case this.BTN_ITEM:
                  tabStr = String("<font size=\'16\'>" + Central.main.langLib.titleTxt(TitleData.ITEM) + "</font>");
                  break;
               case this.BTN_ESSENCE:
                  if(Central.main.checkGameStatus() == Timeline.BATTLE || Central.battle.type == Central.battle.TYPE_NETWORK || Central.main.HitAi == true)
                  {
                     tabStr = String("<b><font size=\'16\' color=\'#990000\'>" + Central.main.langLib.get(257) + "</font></b>");
                  }
                  else
                  {
                     tabStr = String("<font size=\'16\'>" + Central.main.langLib.titleTxt(TitleData.NINJA_ESSENCE) + "</font>");
                  }
                  break;
               case this.BTN_MATERIAL:
                  if(Central.main.checkGameStatus() == Timeline.BATTLE || Central.battle.type == Central.battle.TYPE_NETWORK || Central.main.HitAi == true)
                  {
                     tabStr = String("<b><font size=\'16\' color=\'#990000\'>" + Central.main.langLib.get(257) + "</font></b>");
                  }
                  else
                  {
                     tabStr = String("<font size=\'16\'>" + Central.main.langLib.titleTxt(TitleData.MATERIAL) + "</font>");
                  }
            }
            Central.main.showDynamicTooltip(equPanel[this.menuTabArr[i]],tabStr);
         }
         for(i = 0; i < this.menuTabArr.length; i++)
         {
            if(this.menuTabArr[i] == this.curEquipmentType)
            {
               equPanel[this.menuTabArr[i]].gotoAndStop("select");
            }
            else
            {
               equPanel[this.menuTabArr[i]].gotoAndPlay("unselect");
            }
         }
      }
      
      public function onRemoveTab(btn:MovieClip) : void
      {
         this.stop();
         btn["clickMask"].buttonMode = false;
         btn["clickMask"].removeEventListener(MouseEvent.CLICK,this.btnClickEffect);
         btn["clickMask"].removeEventListener(MouseEvent.MOUSE_OVER,this.btnOverEffect);
         btn["clickMask"].removeEventListener(MouseEvent.MOUSE_OUT,this.btnOutEffect);
      }
      
      public function onTab(btn:MovieClip) : void
      {
         this.stop();
         btn["btn"].gotoAndStop(1);
         if(Central.main.checkGameStatus() == Timeline.BATTLE && (Central.battle.type == Central.battle.TYPE_NETWORK || btn.name == this.BTN_ESSENCE || btn.name == this.BTN_MATERIAL || Central.main.HitAi == true))
         {
            btn["clickMask"].buttonMode = false;
            btn["clickMask"].removeEventListener(MouseEvent.CLICK,this.btnClickEffect);
            btn["clickMask"].removeEventListener(MouseEvent.MOUSE_OVER,this.btnOverEffect);
            btn["clickMask"].removeEventListener(MouseEvent.MOUSE_OUT,this.btnOutEffect);
         }
         else
         {
            btn["clickMask"].buttonMode = true;
            btn["clickMask"].addEventListener(MouseEvent.CLICK,this.btnClickEffect);
            btn["clickMask"].addEventListener(MouseEvent.MOUSE_OVER,this.btnOverEffect);
            btn["clickMask"].addEventListener(MouseEvent.MOUSE_OUT,this.btnOutEffect);
         }
      }
      
      private function btnOverEffect(evt:MouseEvent) : *
      {
         var btn:MovieClip = MovieClip(evt.currentTarget.parent);
         btn["btn"].gotoAndStop(2);
      }
      
      private function btnOutEffect(evt:MouseEvent) : *
      {
         var btn:MovieClip = MovieClip(evt.currentTarget.parent);
         btn["btn"].gotoAndStop(1);
      }
      
      private function btnClickEffect(evt:MouseEvent) : void
      {
         var i:int = 0;
         var btnName:String = String(evt.currentTarget.parent.name);
         var equPanel:MovieClip = this["equipmentPanel"];
         this.invBtnName = btnName;
         this.inv_addTime = 1;
         this.curDataList = {};
         this.charEquipArr = [];
         this.charInvArr = [];
         this.curEquipmentPage = 1;
         this.curEquipmentType = btnName;
         switch(btnName)
         {
            case this.BTN_TRADING:
               this.charInvArr = ArrayUtil.copyArray(Central.main.getMainChar().getInventory(InventoryData.TYPE_TRADING));
               trace("test charInvArr = " + this.charInvArr);
               if(Boolean(Central.main.getMainChar().getWeapon()) && Central.main.getMainChar().tradeweapon == true)
               {
               }
               if(Boolean(Central.main.getMainChar().getBackItem()) && Central.main.getMainChar().tradeback == true)
               {
               }
               if(Boolean(Central.main.getMainChar().getBodySet()) && Central.main.getMainChar().tradebody == true)
               {
               }
               break;
            case this.BTN_WEAPON:
               this.curDataList = Central.main.WEAPON_DATA;
               this.charInvArr = ArrayUtil.copyArray(Central.main.getMainChar().getInventory(InventoryData.TYPE_WEAPON));
               if(Central.main.getMainChar().getrealWeapon())
               {
                  this.charInvArr.push(Central.main.getMainChar().getrealWeapon());
               }
               break;
            case this.BTN_CLOTHING:
               this.curDataList = this.CHAR_GENDER == 0 ? Central.main.BODY_SET_BOY : Central.main.BODY_SET_GIRL;
               this.charInvArr = ArrayUtil.copyArray(Central.main.getMainChar().getInventory(InventoryData.TYPE_BODY_SET));
               if(Central.main.getMainChar().getrealBodySet())
               {
                  this.charInvArr.push(Central.main.getMainChar().getrealBodySet());
               }
               break;
            case this.BTN_BACKITEM:
               this.curDataList = Central.main.BACK_ITEM_DATA;
               this.charInvArr = ArrayUtil.copyArray(Central.main.getMainChar().getInventory(InventoryData.TYPE_BACK_ITEM));
               this.charInvArr.push(this.TEXT_BACKITEM_UNEQUIP);
               if(Central.main.getMainChar().getrealBackItem())
               {
                  this.charInvArr.push(Central.main.getMainChar().getrealBackItem());
               }
               break;
            case this.BTN_ACCESSORY:
               this.curDataList = Central.main.ACCESSORY_DATA;
               this.charInvArr = ArrayUtil.copyArray(Central.main.getMainChar().getInventory(InventoryData.TYPE_ACCESSORY));
               this.charInvArr.push(this.TEXT_ACCESSORY_UNEQUIP);
               if(Central.main.getMainChar().getAccessory())
               {
                  this.charInvArr.push(Central.main.getMainChar().getAccessory());
               }
               break;
            case this.BTN_TRADING:
               this.charInvArr = ArrayUtil.copyArray(Central.main.getMainChar().getInventory(InventoryData.TYPE_TRADING));
               trace("test charInvArr = " + this.charInvArr);
               break;
            case this.BTN_ITEM:
               this.curDataList = Central.main.ITEM_DATA;
               this.charInvArr = ArrayUtil.copyArray(Central.main.getMainChar().getInventory(InventoryData.TYPE_ITEM));
               break;
            case this.BTN_ESSENCE:
               this.curDataList = Central.main.ESSENCE_DATA;
               this.charInvArr = ArrayUtil.copyArray(Central.main.getMainChar().getInventory(InventoryData.TYPE_ESSENCE));
               break;
            case this.BTN_MATERIAL:
               this.curDataList = Central.main.MATERIAL_DATA;
               this.charInvArr = ArrayUtil.copyArray(Central.main.getMainChar().getInventory(InventoryData.TYPE_MATERIAL));
         }
         for(i = 0; i < this.menuTabArr.length; i++)
         {
            if(this.menuTabArr[i] == this.curEquipmentType)
            {
               equPanel[this.menuTabArr[i]].gotoAndStop("select");
            }
            else
            {
               equPanel[this.menuTabArr[i]].gotoAndPlay("unselect");
            }
         }
         this.updateEquipmentList();
      }
      
      private function clearEquipmentList() : void
      {
         var i:int = 0;
         var itemMc:MovieClip = null;
         for(i = 1; i <= this.EQUIPMENT_PER_PAGE; i++)
         {
            itemMc = this["equipmentPanel"]["item_" + i];
            itemMc.visible = false;
            MovieClipButton.highlight(itemMc,false);
            MovieClipButton.disableButton(itemMc);
            itemMc.gotoAndStop("enable");
            itemMc["emblemMc"].gotoAndStop(Timeline.IDLE);
            itemMc["clickMask"].itemid = null;
            itemMc["clickMask"].buttonMode = false;
            itemMc["clickMask"].removeEventListener(MouseEvent.CLICK,this.previewEquipment);
            itemMc["btnEquip"].filters = null;
            itemMc["btnEquip"].itemdata = null;
            itemMc["btnEquip"].visible = false;
            itemMc["btnEquip"].removeEventListener(MouseEvent.CLICK,this.onEquipItem);
            itemMc["btnUnEquip"].filters = null;
            itemMc["btnUnEquip"].itemdata = null;
            itemMc["btnUnEquip"].visible = false;
            itemMc["btnUnEquip"].removeEventListener(MouseEvent.CLICK,this.onEquipItem);
            itemMc["newMc"].visible = false;
            itemMc["lvTxt"].text = "";
            itemMc["expiryTxt"].text = "";
            itemMc["watchMc"].visible = false;
            itemMc["ownTxt"].text = "";
            itemMc["equTxt"].text = "";
            itemMc["lockMc"].visible = false;
            itemMc["EmptyBackItemIcon"].visible = false;
            itemMc["EmptyAccessoryIcon"].visible = false;
            GF.removeAllChild(itemMc["iconMc"]["iconHolder"]);
            Central.main.hideDynamicTooltip(itemMc["clickMask"]);
            Central.main.hideDynamicTooltip(itemMc["btnEquip"]);
            Central.main.hideDynamicTooltip(itemMc["btnUnEquip"]);
         }
      }
      
      private function updateEquipmentList() : void
      {
         var equPanel:MovieClip = null;
         var i:int = 0;
         var btnSeq:int = 0;
         var finalItemNumber:int = 0;
         var displayMc:MovieClip = null;
         var itemMc:MovieClip = null;
         var ItemId:String = null;
         var ItemData:Object = null;
         var tooltipStr:String = null;
         var itemArr:Array = null;
         var traditemid:int = 0;
         var tradeitem:Array = null;
         var tradeItemData:Object = null;
         var invArr:Array = null;
         var trdd:Array = null;
         var isZh:Boolean = false;
         var miscData:Object = null;
         var tempInt:int = 0;
         var stateDictionaryCounter:int = 0;
         var obj:Object = null;
         equPanel = this["equipmentPanel"];
         if(equPanel == null)
         {
            return;
         }
         var totalItem:int = 0;
         itemArr = [];
         var traditem:Array = [];
         tradeitem = [];
         this.clearEquipmentList();
         this.curEquipmentType;
         switch(this.curEquipmentType)
         {
            case this.BTN_TRADING:
               invArr = Central.main.getMainChar().getInventory(InventoryData.TYPE_TRADING);
               break;
            case this.BTN_WEAPON:
               invArr = Central.main.getMainChar().getInventory(InventoryData.TYPE_WEAPON);
               break;
            case this.BTN_CLOTHING:
               invArr = Central.main.getMainChar().getInventory(InventoryData.TYPE_BODY_SET);
               break;
            case this.BTN_BACKITEM:
               invArr = Central.main.getMainChar().getInventory(InventoryData.TYPE_BACK_ITEM);
               break;
            case this.BTN_ACCESSORY:
               invArr = Central.main.getMainChar().getInventory(InventoryData.TYPE_ACCESSORY);
               break;
            case this.BTN_TRADING:
               invArr = Central.main.getMainChar().getInventory(InventoryData.TYPE_TRADING);
               break;
            case this.BTN_ITEM:
               invArr = Central.main.getMainChar().getInventory(InventoryData.TYPE_ITEM);
               break;
            case this.BTN_ESSENCE:
               invArr = Central.main.getMainChar().getInventory(InventoryData.TYPE_ESSENCE);
               break;
            case this.BTN_MATERIAL:
               invArr = Central.main.getMainChar().getInventory(InventoryData.TYPE_MATERIAL);
         }
         this.updateInvBar(equPanel,this.curEquipmentType,invArr.length);
         this.charEquipArr = this.countArrItems(this.charInvArr);
         tradeitem = this.countArrtradeItems(this.charInvArr);
         Out.debug(null,"charEquipArr" + this.charEquipArr);
         itemArr = this.charEquipArr;
         tradeitem.sortOn(["isEquip","level"],[Array.NUMERIC,Array.NUMERIC | Array.DESCENDING]);
         itemArr.sortOn(["isEquip","level"],[Array.NUMERIC,Array.NUMERIC | Array.DESCENDING]);
         this.totalEquipmentPage = Math.ceil(itemArr.length / this.EQUIPMENT_PER_PAGE);
         if(this.totalEquipmentPage <= 0)
         {
            this.totalEquipmentPage = 1;
         }
         if(this.totalEquipmentPage < this.curEquipmentPage)
         {
            this.curEquipmentPage = this.totalEquipmentPage;
         }
         finalItemNumber = this.curEquipmentPage * this.EQUIPMENT_PER_PAGE;
         if(itemArr.length < finalItemNumber)
         {
            finalItemNumber = int(itemArr.length);
         }
         btnSeq = 1;
         i = 0;
         for(i = (this.curEquipmentPage - 1) * this.EQUIPMENT_PER_PAGE; i < finalItemNumber; i++)
         {
            itemMc = equPanel["item_" + btnSeq];
            itemMc.visible = true;
            itemMc["clickMask"].buttonMode = true;
            displayMc = Central.main.getLib("LoadingMc");
            if(this.curEquipmentType == this.BTN_BACKITEM && itemArr[i].id == this.TEXT_BACKITEM_UNEQUIP)
            {
               ItemId = this.TEXT_BACKITEM_UNEQUIP;
               ItemData = {
                  "id":this.TEXT_BACKITEM_UNEQUIP,
                  "name":"",
                  "swfName":"back_00",
                  "description":"",
                  "level":99,
                  "premium":false,
                  "animation":""
               };
            }
            else if(this.curEquipmentType == this.BTN_ACCESSORY && itemArr[i].id == this.TEXT_ACCESSORY_UNEQUIP)
            {
               ItemId = this.TEXT_ACCESSORY_UNEQUIP;
               ItemData = {
                  "id":this.TEXT_ACCESSORY_UNEQUIP,
                  "name":"",
                  "swfName":"acsy_00",
                  "description":"",
                  "level":99,
                  "premium":false,
                  "animation":""
               };
            }
            else
            {
               ItemId = itemArr[i].id;
               if(this.curEquipmentType == this.BTN_TRADING)
               {
                  if(ItemId.indexOf("wpn") >= 0)
                  {
                     this.curDataList = Central.main.WEAPON_DATA;
                  }
                  else if(ItemId.indexOf("back") >= 0)
                  {
                     this.curDataList = Central.main.BACK_ITEM_DATA;
                  }
                  else if(ItemId.indexOf("set") >= 0)
                  {
                     this.curDataList = this.CHAR_GENDER == 0 ? Central.main.BODY_SET_BOY : Central.main.BODY_SET_GIRL;
                  }
               }
               if(this.curDataList.find)
               {
                  ItemData = this.curDataList.find(itemArr[i].id);
               }
               else
               {
                  ItemData = this.curDataList[itemArr[i].id];
               }
               if(ItemData == null)
               {
                  Out.error(this,"Item not exist :: ID-" + itemArr[i].id + "-");
                  continue;
               }
            }
            switch(this.curEquipmentType)
            {
               case this.BTN_TRADING:
                  trace("ItemData.id = " + ItemData.id);
                  trace("itemArr[i].id = " + itemArr[i].id);
                  trace("invArr[i] = " + invArr[i]);
                  trace("tradeitem[i].id = " + tradeitem[i].id);
                  isZh = AppData.lang == AppData.ZH;
                  itemMc["btnEquip"].tradeid = tradeitem[i].id;
                  trdd = tradeitem[i].id.split(":");
                  if(ItemData.id.indexOf("wpn") >= 0)
                  {
                     Item.getWeaponIcon(String(ItemData.id),displayMc,Central.main.getMainChar().getCharacterId());
                     tooltipStr = TooltipData.getItemTooltip(TooltipData.TOOLTIP_TYPE_WEAPON,String(ItemData.id));
                     tooltipStr += "\n\n\n";
                     if(isZh == true)
                     {
                        tooltipStr = tooltipStr + "<br><font color=\'#FF0000\'>" + "剩餘" + trdd[2] + "日領取" + "</font>";
                     }
                     else
                     {
                        tooltipStr = tooltipStr + "<br><font color=\'#FF0000\'>" + trdd[2] + " days remaining to claim" + "</font>";
                     }
                     itemMc["iconMc"]["iconHolder"].addChild(displayMc);
                  }
                  else if(ItemData.id.indexOf("back") >= 0)
                  {
                     Item.getBackItemIcon(String(ItemData.id),displayMc);
                     tooltipStr = TooltipData.getItemTooltip(TooltipData.TOOLTIP_TYPE_BACKITEM,String(ItemData.id));
                     tooltipStr += "\n\n\n";
                     if(isZh == true)
                     {
                        tooltipStr = tooltipStr + "<br><font color=\'#FF0000\'>" + "剩餘" + trdd[2] + "日領取" + "</font>";
                     }
                     else
                     {
                        tooltipStr = tooltipStr + "<br><font color=\'#FF0000\'>" + trdd[2] + " days remaining to claim" + "</font>";
                     }
                     itemMc["iconMc"]["iconHolder"].addChild(displayMc);
                  }
                  else if(ItemData.id.indexOf("set") >= 0)
                  {
                     itemMc["iconMc"]["iconHolder"].addChild(Central.main.asset.getClothingIcon(ItemData.id));
                     tooltipStr = TooltipData.getItemTooltip(TooltipData.TOOLTIP_TYPE_CLOTHING,String(ItemData.id));
                     tooltipStr += "\n\n\n";
                     if(isZh == true)
                     {
                        tooltipStr = tooltipStr + "<br><font color=\'#FF0000\'>" + "剩餘" + trdd[2] + "日領取" + "</font>";
                     }
                     else
                     {
                        tooltipStr = tooltipStr + "<br><font color=\'#FF0000\'>" + trdd[2] + " days remaining to claim" + "</font>";
                     }
                  }
                  if(int(itemArr[i].count) > 1)
                  {
                     itemMc["ownTxt"].text = "x" + itemArr[i].count;
                  }
                  if(ItemData.level > Central.main.getMainChar().getLevel())
                  {
                     itemMc["btnEquip"].visible = true;
                     itemMc["btnEquip"].filters = [this.dimFilter];
                     this.disableButton(itemMc["btnEquip"],this.onEquipItem,ButtonData.EQUIP);
                     Central.main.showDynamicTooltip(itemMc["btnEquip"],String("<b><font size=\'16\' color=\'#990000\'>" + String(Central.main.langLib.get(1085)).replace("[vallevel]",String(ItemData.level)) + "</font></b>"));
                  }
                  else if(Central.main.getMainChar().getAccessory() == itemArr[i].id)
                  {
                     itemMc["equTxt"].text = Central.main.langLib.titleTxt(TitleData.EQUIPPED);
                     this.disableButton(itemMc["btnEquip"],this.onEquipItem,ButtonData.EQUIP);
                  }
                  else
                  {
                     itemMc["btnEquip"].visible = true;
                     Central.main.initButton(itemMc["btnEquip"],this.onEquipItem,ButtonData.EQUIP);
                  }
                  if(Central.main.getMainChar().getWeapon())
                  {
                     Out.debug(null,"Central.main.getMainChar().tradenum" + Central.main.getMainChar().tradenum);
                     if(Central.main.getMainChar().tradenum == tradeitem[i].id)
                     {
                        this.tradtradid = tradeitem[i].id;
                        itemMc["equTxt"].text = Central.main.langLib.titleTxt(TitleData.EQUIPPED);
                        itemMc["btnEquip"].visible = false;
                     }
                  }
                  if(Central.main.getMainChar().getBodySet())
                  {
                     if(Central.main.getMainChar().tradenum == tradeitem[i].id)
                     {
                        this.tradtradid = tradeitem[i].id;
                        itemMc["equTxt"].text = Central.main.langLib.titleTxt(TitleData.EQUIPPED);
                        itemMc["btnEquip"].visible = false;
                     }
                  }
                  if(Central.main.getMainChar().getBackItem())
                  {
                     if(Central.main.getMainChar().tradenum == tradeitem[i].id)
                     {
                        this.tradtradid = tradeitem[i].id;
                        itemMc["equTxt"].text = Central.main.langLib.titleTxt(TitleData.EQUIPPED);
                        itemMc["btnEquip"].visible = false;
                     }
                  }
                  break;
               case this.BTN_WEAPON:
                  Item.getWeaponIcon(String(ItemData.id),displayMc);
                  itemMc["iconMc"]["iconHolder"].addChild(displayMc);
                  if(int(itemArr[i].count) > 1)
                  {
                     itemMc["ownTxt"].text = "x" + itemArr[i].count;
                  }
                  miscData = {};
                  tempInt = 0;
                  stateDictionaryCounter = 0;
                  miscData["character"] = Central.main.getMainChar();
                  if(ItemData.id == "wpn1596")
                  {
                     stateDictionaryCounter = int(Central.main.stateInventory.getStateOnCount(Central.main.getMainChar().getCharacterId(),"wpn","wpn1596"));
                     if(stateDictionaryCounter >= 0)
                     {
                        tempInt = stateDictionaryCounter;
                     }
                     miscData["stoneCounter"] = tempInt;
                  }
                  tooltipStr = TooltipData.getItemTooltip(TooltipData.TOOLTIP_TYPE_WEAPON,String(ItemData.id),"",miscData);
                  if(ItemData.level > Central.main.getMainChar().getLevel())
                  {
                     itemMc["btnEquip"].visible = true;
                     itemMc["btnEquip"].filters = [this.dimFilter];
                     this.disableButton(itemMc["btnEquip"],this.onEquipItem,ButtonData.EQUIP);
                     Central.main.showDynamicTooltip(itemMc["btnEquip"],String("<b><font size=\'16\' color=\'#990000\'>" + String(Central.main.langLib.get(1085)).replace("[vallevel]",String(ItemData.level)) + "</font></b>"));
                  }
                  else if(Central.main.getMainChar().getWeapon() == itemArr[i].id)
                  {
                     if(Central.main.getMainChar().tradeweapon == false)
                     {
                        itemMc["equTxt"].text = Central.main.langLib.titleTxt(TitleData.EQUIPPED);
                        this.disableButton(itemMc["btnEquip"],this.onEquipItem,ButtonData.EQUIP);
                     }
                     else
                     {
                        itemMc["btnEquip"].visible = true;
                        Central.main.initButton(itemMc["btnEquip"],this.onEquipItem,ButtonData.EQUIP);
                     }
                  }
                  else
                  {
                     itemMc["btnEquip"].visible = true;
                     Central.main.initButton(itemMc["btnEquip"],this.onEquipItem,ButtonData.EQUIP);
                  }
                  break;
               case this.BTN_CLOTHING:
                  itemMc["iconMc"]["iconHolder"].addChild(Central.main.asset.getClothingIcon(ItemData.id));
                  itemMc["ownTxt"].text = "";
                  tooltipStr = TooltipData.getItemTooltip(TooltipData.TOOLTIP_TYPE_CLOTHING,String(ItemData.id));
                  if(ItemData.level > Central.main.getMainChar().getLevel())
                  {
                     itemMc["btnEquip"].visible = true;
                     itemMc["btnEquip"].filters = [this.dimFilter];
                     this.disableButton(itemMc["btnEquip"],this.onEquipItem,ButtonData.EQUIP);
                     Central.main.showDynamicTooltip(itemMc["btnEquip"],String("<b><font size=\'16\' color=\'#990000\'>" + String(Central.main.langLib.get(1085)).replace("[vallevel]",String(ItemData.level)) + "</font></b>"));
                  }
                  else if(Central.main.getMainChar().getBodySet() == itemArr[i].id)
                  {
                     itemMc["equTxt"].text = Central.main.langLib.titleTxt(TitleData.EQUIPPED);
                     this.disableButton(itemMc["btnEquip"],this.onEquipItem,ButtonData.EQUIP);
                  }
                  else
                  {
                     itemMc["btnEquip"].visible = true;
                     Central.main.initButton(itemMc["btnEquip"],this.onEquipItem,ButtonData.EQUIP);
                  }
                  break;
               case this.BTN_BACKITEM:
                  if(itemArr[i].id == this.TEXT_BACKITEM_UNEQUIP)
                  {
                     itemMc["EmptyBackItemIcon"].visible = true;
                     tooltipStr = Central.main.langLib.get(1090);
                     if(Boolean(Central.main.getMainChar().getBackItem()) && Central.main.getMainChar().getBackItem() != "")
                     {
                        obj = Central.main.BACK_ITEM_DATA.find(Central.main.getMainChar().getBackItem());
                        tooltipStr = tooltipStr + "<br><br>" + String(Central.main.langLib.get(1091)).replace("[valname]",":<b>" + String(obj.name) + "</b>");
                        tooltipStr = tooltipStr + "<br>(" + Central.main.langLib.btnTxt(ButtonData.BACK_ITEM) + ")";
                        tooltipStr = tooltipStr + "<br><br>" + Central.main.langLib.titleTxt(TitleData.LEVEL) + ": " + obj.level;
                        if(String(obj.description).length > 0)
                        {
                           tooltipStr = tooltipStr + "<br><br>" + Central.main.langLib.titleTxt(TitleData.EFFECT) + ": " + obj.description;
                        }
                        else
                        {
                           tooltipStr = tooltipStr + "<br><br>" + Central.main.langLib.titleTxt(TitleData.EFFECT) + ": -";
                        }
                     }
                     if(Central.main.getMainChar().getBackItem() == "")
                     {
                        itemMc["equTxt"].text = Central.main.langLib.titleTxt(TitleData.EQUIPPED);
                        itemMc["btnUnEquip"].visible = false;
                        itemMc["btnEquip"].visible = false;
                        this.disableButton(itemMc["btnEquip"],this.onEquipItem,ButtonData.EQUIP);
                     }
                     else
                     {
                        itemMc["btnEquip"].visible = false;
                        itemMc["btnUnEquip"].visible = true;
                        Central.main.initButton(itemMc["btnUnEquip"],this.onEquipItem,ButtonData.UNEQUIP);
                     }
                  }
                  else
                  {
                     Item.getBackItemIcon(String(ItemData.id),displayMc);
                     itemMc["iconMc"]["iconHolder"].addChild(displayMc);
                     if(int(itemArr[i].count) > 1)
                     {
                        itemMc["ownTxt"].text = "x" + itemArr[i].count;
                     }
                     tooltipStr = TooltipData.getItemTooltip(TooltipData.TOOLTIP_TYPE_BACKITEM,String(ItemData.id));
                     if(ItemData.level > Central.main.getMainChar().getLevel())
                     {
                        itemMc["btnEquip"].visible = true;
                        itemMc["btnEquip"].filters = [this.dimFilter];
                        this.disableButton(itemMc["btnEquip"],this.onEquipItem,ButtonData.EQUIP);
                        Central.main.showDynamicTooltip(itemMc["btnEquip"],String("<b><font size=\'16\' color=\'#990000\'>" + String(Central.main.langLib.get(1085)).replace("[vallevel]",String(ItemData.level)) + "</font></b>"));
                     }
                     else if(Central.main.getMainChar().getBackItem() == itemArr[i].id)
                     {
                        if(Central.main.getMainChar().tradeback == false)
                        {
                           itemMc["equTxt"].text = Central.main.langLib.titleTxt(TitleData.EQUIPPED);
                           this.disableButton(itemMc["btnEquip"],this.onEquipItem,ButtonData.EQUIP);
                        }
                        else
                        {
                           itemMc["btnEquip"].visible = true;
                           Central.main.initButton(itemMc["btnEquip"],this.onEquipItem,ButtonData.EQUIP);
                        }
                     }
                     else
                     {
                        itemMc["btnEquip"].visible = true;
                        Central.main.initButton(itemMc["btnEquip"],this.onEquipItem,ButtonData.EQUIP);
                     }
                  }
                  break;
               case this.BTN_ACCESSORY:
                  if(itemArr[i].id == this.TEXT_ACCESSORY_UNEQUIP)
                  {
                     itemMc["EmptyAccessoryIcon"].visible = true;
                     tooltipStr = AppData.lang == AppData.ZH ? "卸除飾品" : "Don\'t want to equip any accessory? Click this.";
                     if(Boolean(Central.main.getMainChar().getAccessory()) && Central.main.getMainChar().getAccessory() != "")
                     {
                        obj = Central.main.ACCESSORY_DATA.find(Central.main.getMainChar().getAccessory());
                        tooltipStr = tooltipStr + "<br><br>" + String(Central.main.langLib.get(1091)).replace("[valname]",":<b>" + String(obj.name) + "</b>");
                        tooltipStr = tooltipStr + "<br>(" + Central.main.langLib.titleTxt(TitleData.ACCESSORY) + ")";
                        tooltipStr = tooltipStr + "<br><br>" + Central.main.langLib.titleTxt(TitleData.LEVEL) + ": " + obj.level;
                        if(String(obj.description).length > 0)
                        {
                           tooltipStr = tooltipStr + "<br><br>" + Central.main.langLib.titleTxt(TitleData.EFFECT) + ": " + obj.description;
                        }
                        else
                        {
                           tooltipStr = tooltipStr + "<br><br>" + Central.main.langLib.titleTxt(TitleData.EFFECT) + ": -";
                        }
                     }
                     if(Central.main.getMainChar().getAccessory() == "")
                     {
                        itemMc["equTxt"].text = Central.main.langLib.titleTxt(TitleData.EQUIPPED);
                        itemMc["btnUnEquip"].visible = false;
                        itemMc["btnEquip"].visible = false;
                        this.disableButton(itemMc["btnEquip"],this.onEquipItem,ButtonData.EQUIP);
                     }
                     else
                     {
                        itemMc["btnEquip"].visible = false;
                        itemMc["btnUnEquip"].visible = true;
                        Central.main.initButton(itemMc["btnUnEquip"],this.onEquipItem,ButtonData.UNEQUIP);
                     }
                  }
                  else
                  {
                     Item.getAccessoryIcon(String(ItemData.id),displayMc);
                     itemMc["iconMc"]["iconHolder"].addChild(displayMc);
                     if(int(itemArr[i].count) > 1)
                     {
                        itemMc["ownTxt"].text = "x" + itemArr[i].count;
                     }
                     tooltipStr = TooltipData.getItemTooltip(TooltipData.TOOLTIP_TYPE_ACCESSORY,String(ItemData.id));
                     if(ItemData.level > Central.main.getMainChar().getLevel())
                     {
                        itemMc["btnEquip"].visible = true;
                        itemMc["btnEquip"].filters = [this.dimFilter];
                        this.disableButton(itemMc["btnEquip"],this.onEquipItem,ButtonData.EQUIP);
                        Central.main.showDynamicTooltip(itemMc["btnEquip"],String("<b><font size=\'16\' color=\'#990000\'>" + String(Central.main.langLib.get(1085)).replace("[vallevel]",String(ItemData.level)) + "</font></b>"));
                     }
                     else if(Central.main.getMainChar().getAccessory() == itemArr[i].id)
                     {
                        itemMc["equTxt"].text = Central.main.langLib.titleTxt(TitleData.EQUIPPED);
                        this.disableButton(itemMc["btnEquip"],this.onEquipItem,ButtonData.EQUIP);
                     }
                     else
                     {
                        itemMc["btnEquip"].visible = true;
                        Central.main.initButton(itemMc["btnEquip"],this.onEquipItem,ButtonData.EQUIP);
                     }
                  }
                  break;
               case this.BTN_ITEM:
                  itemMc["clickMask"].buttonMode = false;
                  Item.getItemIcon(ItemData.id,displayMc);
                  itemMc["iconMc"]["iconHolder"].addChild(displayMc);
                  if(int(itemArr[i].count) > 1)
                  {
                     itemMc["ownTxt"].text = "x" + itemArr[i].count;
                  }
                  tooltipStr = TooltipData.getItemTooltip(TooltipData.TOOLTIP_TYPE_ITEM,String(ItemData.id));
                  if(Central.main.checkGameStatus() == Timeline.BATTLE)
                  {
                     itemMc["btnEquip"].visible = true;
                     Central.main.initButton(itemMc["btnEquip"],this.onEquipItem,ButtonData.USE);
                  }
                  break;
               case this.BTN_ESSENCE:
                  itemMc["clickMask"].buttonMode = false;
                  GF.removeAllChild(displayMc);
                  if(ItemData.animation == Data.TEXT_ESSENCE)
                  {
                     Item.getEssenceIcon(ItemData.id,displayMc);
                     Out.debug("ItemData.swfName"," >> " + ItemData.swfName);
                     Out.debug("displayMc"," >> " + displayMc);
                  }
                  itemMc["iconMc"]["iconHolder"].addChild(displayMc);
                  if(int(itemArr[i].count) > 1)
                  {
                     itemMc["ownTxt"].text = "x" + itemArr[i].count;
                  }
                  tooltipStr = TooltipData.getItemTooltip(TooltipData.TOOLTIP_TYPE_ESSENCE,String(ItemData.id));
                  itemMc["btnEquip"].visible = true;
                  Central.main.initButton(itemMc["btnEquip"],this.onEquipItem,ButtonData.USE);
                  if(ItemData.swfName == "ResetPillSkill" || ItemData.swfName == "item_519" || ItemData.swfName == "item_549" || ItemData.swfName == "item_711" || ItemData.swfName == "item_200" || ItemData.swfName == "item_201" || ItemData.swfName == "item_202" || ItemData.swfName == "item_203" || ItemData.swfName == "item_204" || ItemData.swfName == "item_827" || ItemData.swfName == "item_1000")
                  {
                     itemMc["btnEquip"].visible = false;
                     Central.main.disableButton(itemMc["btnEquip"],this.onEquipItem,ButtonData.USE);
                  }
                  break;
               case this.BTN_MATERIAL:
                  itemMc["clickMask"].buttonMode = false;
                  GF.removeAllChild(displayMc);
                  if(ItemData.animation == Data.TEXT_MATERIAL)
                  {
                     Item.getMaterialIcon(ItemData.id,displayMc);
                     Out.debug("ItemData.swfName"," >> " + ItemData.swfName);
                     Out.debug("displayMc"," >> " + displayMc);
                  }
                  itemMc["iconMc"]["iconHolder"].addChild(displayMc);
                  if(int(itemArr[i].count) > 1)
                  {
                     itemMc["ownTxt"].text = "x" + itemArr[i].count;
                  }
                  tooltipStr = TooltipData.getItemTooltip(TooltipData.TOOLTIP_TYPE_MATERIAL,String(ItemData.id));
                  itemMc["btnEquip"].visible = false;
                  Central.main.disableButton(itemMc["btnEquip"],this.onEquipItem,ButtonData.USE);
            }
            itemMc["btnEquip"].itemdata = ItemData;
            itemMc["btnUnEquip"].itemdata = ItemData;
            Central.main.showDynamicTooltip(itemMc["clickMask"],String("<font size=\'16\'>" + tooltipStr + "</font>"));
            itemMc["clickMask"].addEventListener(MouseEvent.CLICK,this.previewEquipment);
            itemMc["clickMask"].itemid = ItemId;
            if(this.curEquipmentType == this.BTN_BACKITEM && itemArr[i].id == this.TEXT_BACKITEM_UNEQUIP || this.curEquipmentType == this.BTN_ACCESSORY && itemArr[i].id == this.TEXT_ACCESSORY_UNEQUIP || this.curEquipmentType == this.BTN_ESSENCE || this.curEquipmentType == this.BTN_MATERIAL)
            {
               itemMc["lvTxt"].text = "-";
            }
            else
            {
               itemMc["lvTxt"].text = String(ItemData.level);
            }
            if(ItemData.level > Central.main.getMainChar().getLevel())
            {
               if(this.curEquipmentType == this.BTN_BACKITEM && itemArr[i].id == this.TEXT_BACKITEM_UNEQUIP || this.curEquipmentType == this.BTN_ACCESSORY && itemArr[i].id == this.TEXT_ACCESSORY_UNEQUIP || this.curEquipmentType == this.BTN_ESSENCE || this.curEquipmentType == this.BTN_MATERIAL)
               {
                  MovieClipButton.enableButton(itemMc);
               }
               else
               {
                  itemMc["lockMc"].visible = true;
               }
            }
            else
            {
               MovieClipButton.enableButton(itemMc);
            }
            if(ItemData.premium)
            {
               itemMc["emblemMc"].gotoAndStop(Timeline.SHOW);
            }
            if(this.specialItemArr.indexOf(ItemData.id) >= 0)
            {
            }
            btnSeq++;
         }
         equPanel["pageTxt"].text = this.curEquipmentPage + " / " + this.totalEquipmentPage;
         equPanel["btnPrevPage"].addEventListener(MouseEvent.CLICK,this.changeEquipmentPage);
         equPanel["btnNextPage"].addEventListener(MouseEvent.CLICK,this.changeEquipmentPage);
      }
      
      private function onEquipItem(evt:MouseEvent) : void
      {
         var equPanel:MovieClip;
         var btn:MovieClip = null;
         var i:int = 0;
         var backitemEffect:Object = null;
         var backitemEffectChance:Number = NaN;
         var tmpEffect:Object = null;
         var rNum:Number = NaN;
         var traded:Array = null;
         var tradeitem:String = null;
         var mainCharBackItem:Object = null;
         var AccessoryEffect:* = undefined;
         var accessoryEffectChance:* = undefined;
         btn = MovieClip(evt.currentTarget);
         var btnName:String = String(evt.currentTarget.name);
         if(btn.itemdata == null)
         {
            Central.main.showInfo(Central.main.langLib.get(1038));
            return;
         }
         if(Boolean(Central.main.battleModeSpecial) && Central.main.battleModeSpecial == true)
         {
            this.checkShowSpecialPopup = false;
            Central.main.hidePopupSpecialHpBar();
         }
         this.selectedEquipment = null;
         this.selectedEquipment = btn.itemdata;
         if(Boolean(this.selectedEquipment.premium) && Account.getAccountType() == Account.FREE)
         {
            Central.main.showUpgradeAccount(Central.main.langLib.get(1447),"Shop");
            return;
         }
         equPanel = this["equipmentPanel"];
         switch(this.curEquipmentType)
         {
            case this.BTN_TRADING:
               tradeitem = btn.tradeid;
               traded = Central.main.getMainChar().getInventory(InventoryData.TYPE_TRADING);
               Out.debug(null,"this.selectedEquipment.id" + this.selectedEquipment.id);
               Out.debug(null,"tradeitem" + tradeitem);
               if(tradeitem.indexOf("wpn") >= 0)
               {
                  Central.main.getMainChar().setTradingWeapon(tradeitem);
                  Central.main.getMainChar().customizeCharacter();
               }
               else if(tradeitem.indexOf("back") >= 0)
               {
                  Central.main.getMainChar().setTradingBackItem(tradeitem);
                  Central.main.getMainChar().customizeCharacter();
               }
               else if(tradeitem.indexOf("set") >= 0)
               {
                  Central.main.getMainChar().setTradingBodySet(tradeitem);
                  Central.main.getMainChar().customizeCharacter();
               }
               this.isSave = true;
               break;
            case this.BTN_WEAPON:
               if(Central.main.getMainChar().setWeapon(this.selectedEquipment.id))
               {
                  Central.main.getMainChar().removeInventory(InventoryData.TYPE_WEAPON,this.selectedEquipment.id);
                  Central.main.getMainChar().customizeCharacter();
               }
               this.isSave = true;
               break;
            case this.BTN_CLOTHING:
               Central.main.getMainChar().addInventory(InventoryData.TYPE_BODY_SET,Central.main.getMainChar().getrealBodySet());
               Central.main.getMainChar().removeInventory(InventoryData.TYPE_BODY_SET,this.selectedEquipment.id);
               Central.main.getMainChar().setBodySet(this.selectedEquipment.id);
               Central.main.getMainChar().customizeCharacter();
               this.isSave = true;
               break;
            case this.BTN_BACKITEM:
               if(Central.main.getMainChar().getrealBackItem())
               {
                  mainCharBackItem = Central.main.BACK_ITEM_DATA.find(Central.main.getMainChar().getrealBackItem());
                  if(mainCharBackItem)
                  {
                     for each(tmpEffect in mainCharBackItem.effect)
                     {
                        switch(tmpEffect.type)
                        {
                           case BattleData.EFFECT_MAX_HP_PRESENT:
                              if(NumberUtil.getRandom() <= tmpEffect.chance / 100)
                              {
                                 if(Central.main.checkGameStatus() != Timeline.BATTLE)
                                 {
                                    Central.main.getMainChar().updateHP(Central.main.getMainChar().hp * (-tmpEffect.amount / 100) / (1 + tmpEffect.amount / 100));
                                 }
                              }
                              break;
                           case BattleData.EFFECT_MAX_HP_FIX_NUM:
                              if(NumberUtil.getRandom() <= tmpEffect.chance / 100)
                              {
                                 if(Central.main.checkGameStatus() != Timeline.BATTLE)
                                 {
                                    Central.main.getMainChar().updateHP(tmpEffect.amount);
                                 }
                              }
                              break;
                           case BattleData.EFFECT_MAX_CP_PRESENT:
                              if(NumberUtil.getRandom() <= tmpEffect.chance / 100)
                              {
                                 if(Central.main.checkGameStatus() != Timeline.BATTLE)
                                 {
                                    Central.main.getMainChar().updateCP(Central.main.getMainChar().cp * (-tmpEffect.amount / 100) / (1 + tmpEffect.amount / 100));
                                 }
                              }
                        }
                     }
                  }
               }
               if(this.selectedEquipment.id == this.TEXT_BACKITEM_UNEQUIP)
               {
                  Central.main.getMainChar().setBackItem("");
                  Out.debug(null,"this is ok");
                  Central.main.getMainChar().customizeCharacter();
               }
               else if(Central.main.getMainChar().setBackItem(this.selectedEquipment.id))
               {
                  Central.main.getMainChar().removeInventory(InventoryData.TYPE_BACK_ITEM,this.selectedEquipment.id);
                  Central.main.getMainChar().customizeCharacter();
               }
               this.isSave = true;
               break;
            case this.BTN_ACCESSORY:
               if(this.accessoryChanged.indexOf(Central.main.getMainChar().getAccessory()) >= 0)
               {
                  AccessoryEffect = Central.main.ACCESSORY_DATA.find(Central.main.getMainChar().getAccessory());
                  tmpEffect = {};
                  if(AccessoryEffect != null)
                  {
                     if(AccessoryEffect.effect.length > 0)
                     {
                        for(i = 0; i < AccessoryEffect.effect.length; i++)
                        {
                           tmpEffect = AccessoryEffect.effect[i];
                           accessoryEffectChance = tmpEffect.chance / 100;
                           rNum = NumberUtil.getRandom();
                           if(rNum > accessoryEffectChance)
                           {
                              continue;
                           }
                           switch(tmpEffect.type)
                           {
                              case BattleData.EFFECT_MAX_HP_PRESENT:
                                 if(Central.main.checkGameStatus() != Timeline.BATTLE)
                                 {
                                    Central.main.getMainChar().updateHP(Central.main.getMainChar().hp * (-tmpEffect.amount / 100) / (1 + tmpEffect.amount / 100));
                                 }
                                 break;
                              case BattleData.EFFECT_MAX_CP_PRESENT:
                                 if(Central.main.checkGameStatus() != Timeline.BATTLE)
                                 {
                                    Central.main.getMainChar().updateCP(Central.main.getMainChar().cp * (-tmpEffect.amount / 100) / (1 + tmpEffect.amount / 100));
                                 }
                           }
                        }
                     }
                  }
               }
               if(this.selectedEquipment.id == this.TEXT_ACCESSORY_UNEQUIP)
               {
                  Central.main.getMainChar().setAccessory("");
               }
               else if(Central.main.getMainChar().setAccessory(this.selectedEquipment.id))
               {
                  Central.main.getMainChar().removeInventory(InventoryData.TYPE_ACCESSORY,this.selectedEquipment.id);
               }
               this.isSave = true;
               break;
            case this.BTN_ITEM:
               if(Central.mission.curMissionID == "msn0")
               {
                  Central.main.showInfo(Central.main.langLib.get(270));
                  return;
               }
               if(Central.main.checkGameStatus() == Timeline.BATTLE)
               {
                  if(this.selectedEquipment.id == "item1" && (Central.battle.type == Central.battle.TYPE_NETWORK || Central.main.HitAi == true))
                  {
                     Central.main.showInfo(Central.main.langLib.get(271));
                     return;
                  }
                  if(this.selectedEquipment.id == "item91")
                  {
                     if(!(Central.battle.bossId != "" && EnemyAttributeData.SEAL_BOSS_LIST.indexOf(Central.battle.bossId) >= 0))
                     {
                        Central.main.showInfo(Central.main.langLib.get(1719)[56]);
                        return;
                     }
                  }
                  if(this.selectedEquipment.id == "item774")
                  {
                     if(!(Central.battle.bossId != "" && EnemyAttributeData.SEAL_BOSS_LIST_EASTER.indexOf(Central.battle.bossId) >= 0))
                     {
                        Central.main.showInfo(Central.main.langLib.get(1805)[45]);
                        return;
                     }
                     Central.main.amfClient.service("EasterFestival.sendBattleEvent",[Central.main.account.getAccountSessionKey(),"774",Central.main.getHash(String(Central.main.account.getAccountSessionKey() + ",774"))],new Function());
                     Central.main.checkUseTokenInsteadItem = true;
                  }
                  if(this.selectedEquipment.id == "item711")
                  {
                     if(!(Central.battle.bossId != "" && EnemyAttributeData.SEAL_BOSS_LIST.indexOf(Central.battle.bossId) >= 0))
                     {
                        Central.main.showInfo(Central.main.langLib.get(1719)[60]);
                        return;
                     }
                  }
                  Central.main.tracking.trackConsumableUsed(this.selectedEquipment.id);
                  Central.main.getMainChar().removeInventory(InventoryData.TYPE_ITEM,this.selectedEquipment.id);
                  Central.battle.useItem(this.selectedEquipment.id);
                  if(Data.NEW_CONSUMABLE_ARR.indexOf(this.selectedEquipment.id) >= 0)
                  {
                     if(Central.mission.curMissionID == null)
                     {
                        Central.main.tracking.generalTrack(Central.main.tracking.TRACK_TOKEN_CONSUMABLE_USED,this.selectedEquipment.id,Central.main.tracking.TRACK_HUNTING_HOUSE);
                     }
                     else
                     {
                        Central.main.tracking.generalTrack(Central.main.tracking.TRACK_TOKEN_CONSUMABLE_USED,this.selectedEquipment.id,Central.main.tracking.TRACK_CONSUMABLE_USE_MISSION);
                     }
                  }
               }
               break;
            case this.BTN_ESSENCE:
               switch(this.selectedEquipment.group_id)
               {
                  case 1:
                     if(Central.main.getMainChar().trainingSkill == null)
                     {
                        Central.main.showInfo(Central.main.langLib.get(1615)[14]);
                     }
                     else
                     {
                        Central.main.getMainChar().verifyTrainingSkill(this.instantTrain);
                     }
                     break;
                  case 2:
                     break;
                  case 3:
                     Central.main.isPopupType = "gear";
                     Central.main.loadPopupPanel("popup_claimSkill","ninjasaga.linkage.EmblemUserSkillSet");
                     break;
                  case 4:
                     if(!Item.hasItem("popup_reset_skill"))
                     {
                        Central.main.loadPopupPanel("popup_reset_skill","ninjasaga.linkage.ResetTalent_Skill",this.popupGearTalentReset);
                     }
                     else
                     {
                        this.popupGearTalentReset();
                     }
                     break;
                  case 5:
                     if(!Item.hasItem("popup_reset_skill"))
                     {
                        Central.main.loadPopupPanel("popup_reset_skill","ninjasaga.linkage.ResetTalent_Skill",this.popupGearSkillReset);
                     }
                     else
                     {
                        this.popupGearSkillReset();
                     }
                     break;
                  case 6:
                     if(Central.main.getMainChar().getLevel() < 5)
                     {
                        Central.main.showInfo(Central.main.langLib.get(1526));
                     }
                     else
                     {
                        this.hide();
                        Central.panel.getInstance().show("hunting_house2");
                     }
                     break;
                  case 7:
                  case 8:
                     break;
                  case 9:
                     if(Central.main.getMainChar().getLevel() >= BloodlineData.BLOODLINE_LEVEL && Central.main.getMainChar().getData(DBCharacterData.RANK) >= 4)
                     {
                        Central.main.showAmfLoading();
                        Central.main.amfClient.service("BloodlineService.useTalentPill",[Central.main.account.getAccountSessionKey(),this.selectedEquipment.id,Central.main.getHash(String(this.selectedEquipment.id))],this.useTalentPillResponse);
                        break;
                     }
                     Central.main.showInfo(Central.main.langLib.get(1687));
                     return;
                     break;
                  case 10:
                     break;
                  case 11:
                     if(!Central.main.toolkit.checkInventory("wpn,set,back,item,material,essence,pet",1))
                     {
                        if(AppData.lang == AppData.ZH)
                        {
                           Central.main.showOk("你的背包空間不足。",function():*
                           {
                           });
                           return;
                        }
                        Central.main.showOk("Not enough available inventory.",function():*
                        {
                        });
                        return;
                     }
                     Central.main.showAmfLoading();
                     Central.main.amfClient.service("CharacterService.useFriendshipBox",[Central.main.account.getAccountSessionKey(),this.selectedEquipment.id,Central.main.getHash(String(this.selectedEquipment.id))],this.usefriendshipbox);
                     break;
                  default:
                     Out.error(this,"use Essence, No group_id found -" + this.selectedEquipment.group_id + "-");
               }
               break;
            case this.BTN_MATERIAL:
         }
         this.updateEquipmentList();
      }
      
      private function usefriendshipbox(response:Object) : *
      {
         if(Central.main.validateAmfResponse(response))
         {
            Central.main.hideAmfLoading();
            Central.main.getMainChar().removeInventory(InventoryData.TYPE_ESSENCE,this.selectedEquipment.id);
            this.updateEquipmentListEssence();
         }
      }
      
      private function useTalentPillResponse(response:Object) : *
      {
         Central.main.hideAmfLoading();
         if(Central.main.validateAmfResponse(response))
         {
            Central.main.getMainChar().updateData(DBCharacterData.BLOODLINE,int(this.selectedEquipment.amount) + int(Central.main.getMainChar().getData(DBCharacterData.BLOODLINE)));
            Central.main.getMainChar().removeInventory(InventoryData.TYPE_ESSENCE,this.selectedEquipment.id);
            Central.main.showInfo(String(Central.main.langLib.get(1689)).replace("[valAmt]",this.selectedEquipment.amount.toString()));
            this.updateEquipmentListEssence();
         }
      }
      
      public function popupGearTalentReset() : void
      {
         var panel:Item = null;
         var _mainMc:MovieClip = null;
         var packageMC:MovieClip = null;
         _mainMc = Central.main.getMainMc();
         panel = Item.getItem("popup_reset_skill");
         packageMC = panel.getAsset("ninjasaga.linkage.ResetTalent_Skill");
         GF.removeAllChild(_mainMc["resetSkillHolder"]);
         _mainMc["resetSkillHolder"].addChild(packageMC);
         packageMC.show("MapmenuTalent");
      }
      
      public function popupGearSkillReset() : void
      {
         var panel:Item = null;
         var _mainMc:MovieClip = null;
         var packageMC:MovieClip = null;
         _mainMc = Central.main.getMainMc();
         panel = Item.getItem("popup_reset_skill");
         packageMC = panel.getAsset("ninjasaga.linkage.ResetTalent_Skill");
         GF.removeAllChild(_mainMc["resetSkillHolder"]);
         _mainMc["resetSkillHolder"].addChild(packageMC);
         packageMC.show("MapmenuSkill");
      }
      
      private function PetRename(evt:MouseEvent) : void
      {
         if(!Item.hasItem("popup_rename"))
         {
            Central.main.loadPopupPanel("popup_rename","ninjasaga.linkage.ResetNamePanel",this.popupPetRename);
         }
         else
         {
            this.popupPetRename();
         }
      }
      
      public function previewPic(evt:MouseEvent) : void
      {
         var showpl:MovieClip = null;
         var jpgSource:BitmapData = null;
         var jpgStream:ByteArray = null;
         Central.main.showAmfLoading();
         showpl = this["photo"];
         jpgSource = new BitmapData(554.2,345.3);
         jpgSource.draw(showpl);
         jpgStream = PNGEncoder.encode(jpgSource);
         Central.main.amfClient.service("ReportService.reportBug2",[Central.main.account.getAccountSessionKey(),jpgStream],this.onBugReportResult);
      }
      
      private function onBugReportResult(result:Object) : void
      {
         Central.main.hideAmfLoading();
         Central.main.showInfo("Submission Completed. Thank you.");
      }
      
      public function popupPetRename() : void
      {
         var panel:Item = null;
         var _mainMc:MovieClip = null;
         var packageMC:MovieClip = null;
         _mainMc = Central.main.getMainMc();
         panel = Item.getItem("popup_rename");
         packageMC = panel.getAsset("ninjasaga.linkage.ResetNamePanel");
         GF.removeAllChild(_mainMc["resetNameHolder"]);
         _mainMc["resetNameHolder"].addChild(packageMC);
         packageMC.show("Pet_" + String(this.selectedPetID));
      }
      
      private function CharacterRename(evt:MouseEvent) : void
      {
         if(!Item.hasItem("popup_rename"))
         {
            Central.main.loadPopupPanel("popup_rename","ninjasaga.linkage.ResetNamePanel",this.popupCharacterRename);
         }
         else
         {
            this.popupCharacterRename();
         }
      }
      
      public function popupCharacterRename() : void
      {
         var panel:Item = null;
         var _mainMc:MovieClip = null;
         var packageMC:MovieClip = null;
         _mainMc = Central.main.getMainMc();
         panel = Item.getItem("popup_rename");
         packageMC = panel.getAsset("ninjasaga.linkage.ResetNamePanel");
         GF.removeAllChild(_mainMc["resetNameHolder"]);
         _mainMc["resetNameHolder"].addChild(packageMC);
         packageMC.show("Character");
      }
      
      public function updateEquipmentListEssence() : void
      {
         this.curDataList = Central.main.ESSENCE_DATA;
         this.charInvArr = ArrayUtil.copyArray(Central.main.getMainChar().getInventory(InventoryData.TYPE_ESSENCE));
         this.updateEquipmentList();
      }
      
      private function instantTrain() : void
      {
         if(!Item.hasItem("popup_skill_progress"))
         {
            Central.main.loadPopupPanel("popup_skill_progress","ninjasaga.linkage.SkillReduceProgress",this.popupProgress);
         }
         else
         {
            this.popupProgress();
         }
      }
      
      public function popupProgress() : void
      {
         var panel:Item = null;
         var packageMC:MovieClip = null;
         panel = Item.getItem("popup_skill_progress");
         packageMC = panel.getAsset("ninjasaga.linkage.SkillReduceProgress");
         GF.removeAllChild(this["equipmentPanel"]["progressHolder"]);
         this["equipmentPanel"]["progressHolder"].addChild(packageMC);
         packageMC.show("gear");
      }
      
      private function resetPreviewEquipment(evt:MouseEvent) : void
      {
         var i:int = 0;
         var itemMc:MovieClip = null;
         for(i = 1; i <= this.EQUIPMENT_PER_PAGE; i++)
         {
            itemMc = this["equipmentPanel"]["item_" + i];
            MovieClipButton.highlight(itemMc,false);
         }
         Central.main.getMainChar().customizeCharacter();
      }
      
      private function previewEquipment(evt:MouseEvent) : void
      {
         var selectMc:MovieClip = null;
         var clickMask:MovieClip = null;
         var selectId:String = null;
         var i:int = 0;
         var itemMc:MovieClip = null;
         if(this.curEquipmentType == this.BTN_ITEM || this.curEquipmentType == this.BTN_ESSENCE || this.curEquipmentType == this.BTN_MATERIAL)
         {
            return;
         }
         selectMc = MovieClip(evt.currentTarget.parent);
         clickMask = MovieClip(evt.currentTarget);
         selectId = clickMask.itemid;
         for(i = 1; i <= this.EQUIPMENT_PER_PAGE; i++)
         {
            itemMc = this["equipmentPanel"]["item_" + i];
            MovieClipButton.highlight(itemMc,false);
         }
         MovieClipButton.highlight(selectMc);
         switch(this.curEquipmentType)
         {
            case this.BTN_TRADING:
               if(selectId.indexOf("wpn") >= 0)
               {
                  Central.main.getMainChar().changeWeapon(selectId);
               }
               else if(selectId.indexOf("back") >= 0)
               {
                  Central.main.getMainChar().changeBackItem(selectId);
               }
               else if(selectId.indexOf("set") >= 0)
               {
                  Central.main.getMainChar().changeBodySet(selectId);
               }
               break;
            case this.BTN_WEAPON:
               Central.main.getMainChar().changeWeapon(selectId);
               break;
            case this.BTN_CLOTHING:
               Central.main.getMainChar().changeBodySet(selectId);
               break;
            case this.BTN_BACKITEM:
               if(selectId == this.TEXT_BACKITEM_UNEQUIP)
               {
                  Central.main.getMainChar().changeBackItem("");
               }
               else
               {
                  Central.main.getMainChar().changeBackItem(selectId);
               }
            case this.BTN_ACCESSORY:
         }
      }
      
      private function changeEquipmentPage(evt:MouseEvent) : void
      {
         switch(evt.currentTarget.name)
         {
            case "btnNextPage":
               ++this.curEquipmentPage;
               if(this.curEquipmentPage > this.totalEquipmentPage)
               {
                  this.curEquipmentPage = this.totalEquipmentPage;
                  Central.main.showInfo(Central.main.langLib.get(58));
                  return;
               }
               break;
            case "btnPrevPage":
               --this.curEquipmentPage;
               if(this.curEquipmentPage <= 0)
               {
                  this.curEquipmentPage = 1;
                  Central.main.showInfo(Central.main.langLib.get(57));
                  return;
               }
         }
         this.updateEquipmentList();
      }
      
      private function countArrItems(originalArray:Array) : Array
      {
         var lookup:Array = null;
         var uniqueArr:Array = null;
         var num:String = null;
         var obj:Object = null;
         var idx:int = 0;
         var i:int = 0;
         var checkObj:Object = null;
         var tmp:Array = null;
         var j:int = 0;
         lookup = new Array();
         uniqueArr = new Array();
         for(idx = 0; idx < originalArray.length; idx++)
         {
            num = originalArray[idx];
            if(this.curDataList != null && num != this.TEXT_BACKITEM_UNEQUIP && num != this.TEXT_ACCESSORY_UNEQUIP && this.curEquipmentType != this.BTN_TRADING)
            {
               checkObj = null;
               if(this.curDataList.find)
               {
                  checkObj = this.curDataList.find(num);
               }
               else
               {
                  checkObj = this.curDataList[num];
               }
               if(checkObj == null)
               {
                  Out.error(this,"(count) Item not exist :: ID-" + num + "-");
                  continue;
               }
            }
            if(this.curEquipmentType == this.BTN_BACKITEM && num == this.TEXT_BACKITEM_UNEQUIP)
            {
               obj = new Object();
               obj.id = num;
               obj.count = 1;
               obj.level = 99;
               if(Central.main.getMainChar().getBackItem() == "")
               {
                  obj.isEquip = 1;
               }
               uniqueArr.push(obj);
            }
            else if(this.curEquipmentType == this.BTN_ACCESSORY && num == this.TEXT_ACCESSORY_UNEQUIP)
            {
               obj = new Object();
               obj.id = num;
               obj.count = 1;
               obj.level = 99;
               if(Central.main.getMainChar().getAccessory() == "")
               {
                  obj.isEquip = 1;
               }
               uniqueArr.push(obj);
            }
            else if(!lookup[num])
            {
               obj = new Object();
               if(this.curEquipmentType == this.BTN_TRADING)
               {
                  tmp = num.split(":");
                  obj.id = tmp[0];
                  num = tmp[0];
               }
               else
               {
                  obj.id = num;
               }
               obj.count = 0;
               if(this.curEquipmentType == this.BTN_TRADING)
               {
                  if(num.indexOf("wpn") >= 0)
                  {
                     this.curDataList = Central.main.WEAPON_DATA;
                  }
                  else if(num.indexOf("back") >= 0)
                  {
                     this.curDataList = Central.main.BACK_ITEM_DATA;
                  }
                  else if(num.indexOf("set") >= 0)
                  {
                     this.curDataList = this.CHAR_GENDER == 0 ? Central.main.BODY_SET_BOY : Central.main.BODY_SET_GIRL;
                  }
               }
               if(this.curDataList != null)
               {
                  if(this.curDataList.find)
                  {
                     obj.level = this.curDataList.find(num).level;
                  }
                  else
                  {
                     obj.level = this.curDataList[num].level;
                  }
               }
               switch(this.curEquipmentType)
               {
                  case this.BTN_WEAPON:
                     if(num == Central.main.getMainChar().getWeapon())
                     {
                        obj.isEquip = 1;
                     }
                     break;
                  case this.BTN_CLOTHING:
                     if(num == Central.main.getMainChar().getrealBodySet())
                     {
                        obj.isEquip = 1;
                     }
                     break;
                  case this.BTN_BACKITEM:
                     if(num == Central.main.getMainChar().getBackItem())
                     {
                        obj.isEquip = 1;
                     }
                     break;
                  case this.BTN_ACCESSORY:
                     if(num == Central.main.getMainChar().getAccessory())
                     {
                        obj.isEquip = 1;
                     }
                     break;
                  case this.BTN_ITEM:
                  case this.BTN_ESSENCE:
                  case this.BTN_MATERIAL:
                  case this.BTN_TRADING:
               }
               uniqueArr.push(obj);
               lookup[num] = true;
            }
         }
         for(i = 0; i < uniqueArr.length; i++)
         {
            for(j = 0; j < originalArray.length; j++)
            {
               if(originalArray[j] == uniqueArr[i].id)
               {
                  ++uniqueArr[i].count;
               }
            }
         }
         return uniqueArr;
      }
      
      private function countArrtradeItems(originalArray:Array) : Array
      {
         var lookup:Array = null;
         var uniqueArr:Array = null;
         var num:String = null;
         var obj:Object = null;
         var idx:int = 0;
         var i:int = 0;
         var checkObj:Object = null;
         var tmp:Array = null;
         var j:int = 0;
         lookup = new Array();
         uniqueArr = new Array();
         for(idx = 0; idx < originalArray.length; idx++)
         {
            num = originalArray[idx];
            if(this.curDataList != null && num != this.TEXT_BACKITEM_UNEQUIP && num != this.TEXT_ACCESSORY_UNEQUIP && this.curEquipmentType != this.BTN_TRADING)
            {
               checkObj = null;
               if(this.curDataList.find)
               {
                  checkObj = this.curDataList.find(num);
               }
               else
               {
                  checkObj = this.curDataList[num];
               }
               if(checkObj == null)
               {
                  Out.error(this,"(count) Item not exist :: ID-" + num + "-");
                  continue;
               }
            }
            if(this.curEquipmentType == this.BTN_BACKITEM && num == this.TEXT_BACKITEM_UNEQUIP)
            {
               obj = new Object();
               obj.id = num;
               obj.count = 1;
               obj.level = 99;
               if(Central.main.getMainChar().getBackItem() == "")
               {
                  obj.isEquip = 1;
               }
               uniqueArr.push(obj);
            }
            else if(this.curEquipmentType == this.BTN_ACCESSORY && num == this.TEXT_ACCESSORY_UNEQUIP)
            {
               obj = new Object();
               obj.id = num;
               obj.count = 1;
               obj.level = 99;
               if(Central.main.getMainChar().getAccessory() == "")
               {
                  obj.isEquip = 1;
               }
               uniqueArr.push(obj);
            }
            else if(!lookup[num])
            {
               obj = new Object();
               trace("test menu");
               if(this.curEquipmentType == this.BTN_TRADING)
               {
                  tmp = num.split(":");
                  obj.id = num;
                  num = tmp[0];
               }
               else
               {
                  obj.id = num;
               }
               trace("obj.id = " + obj.id);
               trace("num = " + obj.id);
               obj.count = 0;
               if(this.curEquipmentType == this.BTN_TRADING)
               {
                  if(num.indexOf("wpn") >= 0)
                  {
                     this.curDataList = Central.main.WEAPON_DATA;
                  }
                  else if(num.indexOf("back") >= 0)
                  {
                     this.curDataList = Central.main.BACK_ITEM_DATA;
                  }
                  else if(num.indexOf("set") >= 0)
                  {
                     this.curDataList = this.CHAR_GENDER == 0 ? Central.main.BODY_SET_BOY : Central.main.BODY_SET_GIRL;
                  }
               }
               if(this.curDataList != null)
               {
                  if(this.curDataList.find)
                  {
                     obj.level = this.curDataList.find(num).level;
                  }
                  else
                  {
                     obj.level = this.curDataList[num].level;
                  }
               }
               switch(this.curEquipmentType)
               {
                  case this.BTN_WEAPON:
                     if(num == Central.main.getMainChar().getWeapon())
                     {
                        obj.isEquip = 1;
                     }
                     break;
                  case this.BTN_CLOTHING:
                     if(num == Central.main.getMainChar().getrealBodySet())
                     {
                        obj.isEquip = 1;
                     }
                     break;
                  case this.BTN_BACKITEM:
                     if(num == Central.main.getMainChar().getBackItem())
                     {
                        obj.isEquip = 1;
                     }
                     break;
                  case this.BTN_ACCESSORY:
                     if(num == Central.main.getMainChar().getAccessory())
                     {
                        obj.isEquip = 1;
                     }
                     break;
                  case this.BTN_ITEM:
                  case this.BTN_ESSENCE:
                  case this.BTN_MATERIAL:
                  case this.BTN_TRADING:
               }
               uniqueArr.push(obj);
               lookup[num] = true;
            }
         }
         for(i = 0; i < uniqueArr.length; i++)
         {
            for(j = 0; j < originalArray.length; j++)
            {
               if(originalArray[j] == uniqueArr[i].id)
               {
                  ++uniqueArr[i].count;
               }
            }
         }
         return uniqueArr;
      }
      
      private function onItem() : void
      {
         this.stop();
         this.initCloseBtn();
      }
      
      private function refreshSkillPanel() : void
      {
         this.updateSkillList();
         this.updateEquippedSkill();
      }
      
      private function onSkill() : void
      {
         var i:uint = 0;
         var skillPanel:MovieClip = null;
         var seq:uint = 0;
         var skillTypes:HashMap = null;
         var skillType:String = null;
         var btnTab:MovieClip = null;
         var mc:MovieClip = null;
         var itemMc:MovieClip = null;
         this.stop();
         this["skillPanel"]["progressMc"].startTrainSkillModule(this.refreshSkillPanel);
         this.stop();
         this.clearSkillList();
         this.clearSkillTypeTab();
         this.selectedSkillType = null;
         skillPanel = this["skillPanel"];
         skillPanel["btnClose"].addEventListener(MouseEvent.CLICK,this.hide);
         Central.main.initButton(skillPanel["academyBtn"],this.goToLearnJustu,ButtonData.ACADEMY);
         Central.main.initButton(skillPanel["btnUpgradeTab"],this.goToUpgradeSkill,ButtonData.UPGRADE);
         skillPanel["lbl_jutsu_title"].text = Central.main.langLib.btnTxt(ButtonData.JUTSU);
         skillPanel["lbl_ninjutsu"].text = Central.main.langLib.titleTxt(TitleData.NINJUTSU);
         skillPanel["lbl_taijutsu"].text = Central.main.langLib.btnTxt(ButtonData.TAIJUTSU);
         skillPanel["lbl_genjutsu"].text = Central.main.langLib.btnTxt(ButtonData.GENJUTSU);
         skillPanel["iconMC"].visible = false;
         skillPanel["skillTypeIcon"].gotoAndStop(Timeline.IDLE);
         skillPanel["healTxt"].text = "";
         Central.main.initButton(skillPanel["btnResetSkill"],this.resetSkill,ButtonData.RESET_JUTSU);
         skillPanel["nameTxt"].text = "";
         skillPanel["lvlTxt"].text = "";
         skillPanel["damageTxt"].text = "";
         skillPanel["cpTxt"].text = "";
         skillPanel["cooldownTxt"].text = "";
         skillPanel["descriptionTxt"].text = "";
         skillPanel["btnEquip"].visible = false;
         skillPanel["btnPreview"].visible = false;
         skillPanel["btnUpgrade"].visible = false;
         Central.main.initButton(skillPanel["btnClear"],this.clearCharSkill,ButtonData.CLEAR);
         skillPanel["iconLv"].visible = false;
         skillPanel["iconChakra"].visible = false;
         skillPanel["healIcon"].visible = false;
         skillPanel["damageIcon"].visible = false;
         skillPanel["iconCooldown"].visible = false;
         for(i = 0; i < 8; i++)
         {
            skillPanel["btnSkillClear" + i].addEventListener(MouseEvent.CLICK,this.clearCharSingleSkill);
         }
         seq = 1;
         this.isSelectBtn = true;
         this.isSelectBtnPress = false;
         for(i = 0; i < this.SKILL_TYPE_BUTTONS.length; i++)
         {
            skillType = String(this.SKILL_TYPE_BUTTONS[i]).substr(3,String(this.SKILL_TYPE_BUTTONS[i]).length).toLowerCase();
            if(Central.main.getMainChar().hasSkillType(skillType))
            {
               if(this.isSelectBtn)
               {
                  this.selectedSkillType = skillType;
                  this.isSelectBtn = false;
               }
               if(skillType == "taijutsu")
               {
                  seq = 4;
               }
               else if(skillType == "genjutsu")
               {
                  seq = 5;
               }
               btnTab = skillPanel["btnTab" + seq];
               seq++;
               switch(skillType)
               {
                  case "fire":
                     mc = new fire();
                     break;
                  case "earth":
                     mc = new earth();
                     break;
                  case "lightning":
                     mc = new lightning();
                     break;
                  case "water":
                     mc = new water();
                     break;
                  case "wind":
                     mc = new wind();
                     break;
                  case "taijutsu":
                     mc = new taijutsu();
                     break;
                  case "genjutsu":
                     mc = new genjutsu();
               }
               btnTab.addChild(mc);
               btnTab.visible = true;
               btnTab.skillType = skillType;
               MovieClip(btnTab.getChildAt(0)).skillType = skillType;
               MovieClip(btnTab.getChildAt(0)).gotoAndStop("unselect");
               continue;
            }
            switch(skillType)
            {
               case "taijutsu":
                  btnTab = skillPanel["btnTab4"];
                  mc = new taijutsu_dim();
                  this.onDimTaiTab(mc);
                  mc.stop();
                  btnTab.addChild(mc);
                  btnTab.visible = true;
                  MovieClip(btnTab.getChildAt(0)).skillType = null;
                  break;
               case "genjutsu":
                  btnTab = skillPanel["btnTab5"];
                  mc = new genjutsu_dim();
                  this.onDimGenTab(mc);
                  mc.stop();
                  btnTab.addChild(mc);
                  btnTab.visible = true;
                  MovieClip(btnTab.getChildAt(0)).skillType = null;
            }
         }
         skillTypes = Central.main.getMainChar().getSkillTypes(true);
         for(i = skillTypes.toArray().length + 1; i <= 3; i++)
         {
            btnTab = skillPanel["btnTab" + i];
            switch(i)
            {
               case 1:
                  mc = new element_1();
                  this.onElement1Tab(mc);
                  break;
               case 2:
                  mc = new element_2();
                  this.onElement2Tab(mc);
                  break;
               case 3:
                  mc = new element_3();
                  this.onElement3Tab(mc);
            }
            mc.stop();
            btnTab.addChild(mc);
            btnTab.visible = true;
            MovieClip(btnTab.getChildAt(0)).skillType = null;
         }
         for(i = 1; i <= this.SKILL_PER_PAGE; i++)
         {
            itemMc = this["skillPanel"]["item_" + i];
            MovieClipButton.highlight(itemMc,false);
            Central.main.initButton(itemMc["btnEquip"],this.equipSkillQuick,ButtonData.EQUIP);
         }
         this.updateSkillList();
      }
      
      public function onSkillTab(btn:MovieClip) : void
      {
         var skillTypeName:String = null;
         btn.stop();
         btn["btn"].gotoAndStop(1);
         btn["clickMask"].buttonMode = true;
         if(!btn["clickMask"].hasEventListener(MouseEvent.CLICK))
         {
            btn["clickMask"].addEventListener(MouseEvent.CLICK,this.changeSkillType);
            btn["clickMask"].addEventListener(MouseEvent.MOUSE_OVER,this.btnOverEffect);
            btn["clickMask"].addEventListener(MouseEvent.MOUSE_OUT,this.btnOutEffect);
            skillTypeName = Central.main.langLib.btnTxt(this.SKILL_TYPE_BUTTONS_NAME[this.ALL_NINJUTSU_TYPES.indexOf(btn.skillType)]);
            Central.main.showDynamicTooltip(btn,String("<font size=\'16\'>" + skillTypeName + "</font>"));
         }
         if(!this.isSelectBtnPress)
         {
            this.isSelectBtnPress = true;
            btn["clickMask"].dispatchEvent(new MouseEvent(MouseEvent.CLICK));
         }
      }
      
      public function onElement1Tab(btn:MovieClip) : void
      {
         if(!btn.hasEventListener(MouseEvent.CLICK))
         {
            btn.stop();
            btn.addEventListener(MouseEvent.CLICK,this.goToLearnJustu);
            btn.addEventListener(MouseEvent.MOUSE_OVER,function fn():void
            {
               btn.gotoAndStop(2);
            });
            btn.addEventListener(MouseEvent.MOUSE_OUT,function fn():void
            {
               btn.gotoAndStop(1);
            });
            Central.main.showDynamicTooltip(btn,String("<font size=\'16\'>" + Central.main.langLib.get(1399) + "</font>"));
         }
      }
      
      public function onElement2Tab(btn:MovieClip) : void
      {
         var skillTypes:HashMap = null;
         if(!btn.hasEventListener(MouseEvent.CLICK))
         {
            btn.stop();
            skillTypes = Central.main.getMainChar().getSkillTypes(true);
            switch(skillTypes.toArray().length)
            {
               case 0:
                  Central.main.showDynamicTooltip(btn,String("<font size=\'16\'>" + Central.main.langLib.get(1399) + "</font>"));
                  break;
               case 1:
                  Central.main.showDynamicTooltip(btn,String("<font size=\'16\'>" + Central.main.langLib.get(1400) + "</font>"));
            }
            btn.addEventListener(MouseEvent.CLICK,this.goToLearnJustu);
            btn.addEventListener(MouseEvent.MOUSE_OVER,function fn():void
            {
               btn.gotoAndStop(2);
            });
            btn.addEventListener(MouseEvent.MOUSE_OUT,function fn():void
            {
               btn.gotoAndStop(1);
            });
         }
      }
      
      public function onElement3Tab(btn:MovieClip) : void
      {
         var skillTypes:HashMap = null;
         if(!btn.hasEventListener(MouseEvent.CLICK))
         {
            btn.stop();
            btn.addEventListener(MouseEvent.MOUSE_OVER,function fn():void
            {
               btn.gotoAndStop(2);
            });
            btn.addEventListener(MouseEvent.MOUSE_OUT,function fn():void
            {
               btn.gotoAndStop(1);
            });
            skillTypes = Central.main.getMainChar().getSkillTypes(true);
            switch(skillTypes.toArray().length)
            {
               case 0:
                  Central.main.showDynamicTooltip(btn,String("<font size=\'16\'>" + Central.main.langLib.get(1399) + "</font>"));
                  btn.addEventListener(MouseEvent.CLICK,this.goToLearnJustu);
                  break;
               case 1:
                  Central.main.showDynamicTooltip(btn,String("<font size=\'16\'>" + Central.main.langLib.get(1400) + "</font>"));
                  btn.addEventListener(MouseEvent.CLICK,this.goToLearnJustu);
                  break;
               case 2:
                  Central.main.showDynamicTooltip(btn,String("<font size=\'16\'>" + Central.main.langLib.get(1401) + "</font>"));
                  if(Account.getAccountType() == Account.FREE)
                  {
                     btn.addEventListener(MouseEvent.CLICK,this.showUpgradePage);
                  }
                  else
                  {
                     btn.addEventListener(MouseEvent.CLICK,this.goToLearnJustu);
                  }
            }
         }
      }
      
      public function onDimGenTab(btn:MovieClip) : void
      {
         if(!btn.hasEventListener(MouseEvent.CLICK))
         {
            btn.stop();
            btn.addEventListener(MouseEvent.CLICK,this.goToLearnGen);
            btn.addEventListener(MouseEvent.MOUSE_OVER,function fn():void
            {
               btn.gotoAndStop(2);
            });
            btn.addEventListener(MouseEvent.MOUSE_OUT,function fn():void
            {
               btn.gotoAndStop(1);
            });
            Central.main.showDynamicTooltip(btn,String("<font size=\'16\'>" + Central.main.langLib.get(1402) + "</font>"));
         }
      }
      
      public function onDimTaiTab(btn:MovieClip) : void
      {
         if(!btn.hasEventListener(MouseEvent.CLICK))
         {
            btn.stop();
            btn.addEventListener(MouseEvent.CLICK,this.goToLearnTai);
            btn.addEventListener(MouseEvent.MOUSE_OVER,function fn():void
            {
               btn.gotoAndStop(2);
            });
            btn.addEventListener(MouseEvent.MOUSE_OUT,function fn():void
            {
               btn.gotoAndStop(1);
            });
            Central.main.showDynamicTooltip(btn,String("<font size=\'16\'>" + Central.main.langLib.get(1403) + "</font>"));
         }
      }
      
      public function goToLearnTai(evt:MouseEvent) : void
      {
         Central.panel.getInstance().show("academy","taijutsu");
         this.hide();
      }
      
      public function goToLearnGen(evt:MouseEvent) : void
      {
         Central.panel.getInstance().show("academy","genjutsu");
         this.hide();
      }
      
      public function goToLearnJustu(evt:MouseEvent) : void
      {
         Central.panel.getInstance().show("academy");
         this.hide();
      }
      
      public function goToUpgradeSkill(evt:MouseEvent) : void
      {
         Central.panel.getInstance().show("upgrade_skill");
         this.hide();
      }
      
      private function skillTabOverEffect(evt:MouseEvent) : void
      {
         var btn:MovieClip = null;
         btn = MovieClip(evt.currentTarget.parent);
         btn["btn"].gotoAndStop(2);
      }
      
      private function skillTabOutEffect(evt:MouseEvent) : void
      {
         var btn:MovieClip = null;
         btn = MovieClip(evt.currentTarget.parent);
         btn["btn"].gotoAndStop(1);
      }
      
      private function showUpgradePage(evt:MouseEvent) : void
      {
         Central.main.showUpgradeAccount(Central.main.langLib.get(1450),"Academy");
      }
      
      private function getSkillTypeName(skillType:String) : String
      {
         var i:* = undefined;
         for(i = 0; i < this.ALL_NINJUTSU_TYPES.length; i++)
         {
            if(this.ALL_NINJUTSU_TYPES[i] == skillType)
            {
               return Central.main.langLib.btnTxt(this.SKILL_TYPE_BUTTONS_NAME[i]);
            }
         }
         return null;
      }
      
      private function onOption() : void
      {
         var mc:MovieClip = null;
         var desc:String = null;
         this.stop();
         this.initCloseBtn();
         mc = this["optionPanel"];
         Central.main.initButton(mc["upgradeBtn"],this.upgradeOption,ButtonData.UPGRADE);
         switch(stage.quality)
         {
            case "HIGH":
               desc = Central.main.langLib.titleTxt(TitleData.QUALITYHIGH);
               break;
            case "BEST":
               desc = Central.main.langLib.titleTxt(TitleData.QUALITYBEST);
               break;
            case "LOW":
               desc = Central.main.langLib.titleTxt(TitleData.QUALITYLOW);
               break;
            case "MEDIUM":
               desc = Central.main.langLib.titleTxt(TitleData.QUALITYMEDIUM);
         }
         mc["qualityTxt"].text = desc;
         mc["btnQualityPrev"].addEventListener(MouseEvent.CLICK,this.changeQuality);
         mc["btnQualityNext"].addEventListener(MouseEvent.CLICK,this.changeQuality);
         this.toggleMusicControl(this.isAllSoundOn);
         mc["versionTxt"].text = Data.BUILD_NO;
         if(Account.getAccountType() == Account.FREE)
         {
            mc["accountTypeTxt"].text = Central.main.langLib.titleTxt(TitleData.FREE);
            mc["upgradeBtn"].visible = true;
         }
         else
         {
            mc["accountTypeTxt"].text = Central.main.langLib.titleTxt(TitleData.PREMIUM);
            mc["upgradeBtn"].visible = false;
         }
         mc["lbl_option_title"].text = Central.main.langLib.titleTxt(TitleData.OPTION);
         mc["musicControl"]["lbl_min"].text = Central.main.langLib.titleTxt(TitleData.MIN);
         mc["musicControl"]["lbl_max"].text = Central.main.langLib.titleTxt(TitleData.MAX);
         mc["musicControl"]["lbl_sound"].text = Central.main.langLib.titleTxt(TitleData.SOUND) + ":";
         mc["musicControl"]["btnToggleSound"]["txt"].text = Central.main.langLib.titleTxt(TitleData.ON);
         mc["lbl_graphicquality"].text = Central.main.langLib.titleTxt(TitleData.GRAPHICQUALITY) + ":";
         mc["lbl_accountstatus"].text = Central.main.langLib.titleTxt(TitleData.ACCOUNTSTATUS) + ":";
         mc["lbl_versionnumber"].text = Central.main.langLib.titleTxt(TitleData.VERSIONNUMBER) + ":";
         mc["lbl_allSound"].text = Central.main.langLib.titleTxt(TitleData.ALLSOUND) + ":";
         mc["lbl_on"].text = Central.main.langLib.titleTxt(TitleData.ON);
         mc["lbl_off"].text = Central.main.langLib.titleTxt(TitleData.OFF);
         Central.main.initButton(mc["allSoundOnBtn"],this.turnAllSoundOn);
         Central.main.initButton(mc["allSoundOffBtn"],this.turnAllSoundOff);
         this.toggleAllSound(this.isAllSoundOn);
      }
      
      private function upgradeOption(evt:MouseEvent) : void
      {
         Central.main.showUpgradeAccount(Central.main.langLib.get(1452),"CreateChar");
      }
      
      private function turnAllSoundOn(evt:MouseEvent) : void
      {
         this.toggleAllSound(true);
      }
      
      private function turnAllSoundOff(evt:MouseEvent) : void
      {
         this.toggleAllSound(false);
      }
      
      private function toggleAllSound(state:Boolean) : *
      {
         var mc:MovieClip = null;
         var soundTransform:SoundTransform = null;
         mc = this["optionPanel"];
         soundTransform = SoundMixer.soundTransform;
         this.isAllSoundOn = state;
         if(this.isAllSoundOn)
         {
            soundTransform.volume = 1;
            mc["allSoundOnBtn"]["btn"].gotoAndStop("check");
            mc["allSoundOffBtn"]["btn"].gotoAndStop("uncheck");
            this["btnSoundOn"].visible = true;
            Central.main.initButton(this["btnSoundOn"],this.onMenuBtn,"");
            this["btnSoundOff"].visible = false;
            Central.main.disableButton(this["btnSoundOff"],this.onMenuBtn,"");
         }
         else
         {
            soundTransform.volume = 0;
            mc["allSoundOnBtn"]["btn"].gotoAndStop("uncheck");
            mc["allSoundOffBtn"]["btn"].gotoAndStop("check");
            this["btnSoundOn"].visible = false;
            Central.main.disableButton(this["btnSoundOn"],this.onMenuBtn,"");
            this["btnSoundOff"].visible = true;
            Central.main.initButton(this["btnSoundOff"],this.onMenuBtn,"");
         }
         SoundMixer.soundTransform = soundTransform;
         this.toggleMusicControl(this.isAllSoundOn);
      }
      
      private function toggleMusicControl(state:Boolean) : void
      {
         var mc:MovieClip = null;
         mc = this["optionPanel"]["musicControl"];
         if(state)
         {
            mc.filters = [];
            mc["volume"]["slider"].buttonMode = true;
            mc["volume"]["slider"].x = Central.main.mixer.getVolume() * (mc["volume"].width - mc["volume"]["slider"].width);
            mc["volume"]["slider"].addEventListener(MouseEvent.MOUSE_DOWN,this.startDragVolume);
            mc["volume"]["slider"].addEventListener(MouseEvent.MOUSE_UP,this.stopDragVolume);
            mc["btnMinus"].addEventListener(MouseEvent.CLICK,this.onChangeVolume);
            mc["btnAdd"].addEventListener(MouseEvent.CLICK,this.onChangeVolume);
            mc["btnToggleSound"].addEventListener(MouseEvent.CLICK,this.toggleSound);
         }
         else
         {
            mc.filters = [this.dimFilter];
            mc["volume"]["slider"].buttonMode = false;
            mc["volume"]["slider"].x = Central.main.mixer.getVolume() * (mc["volume"].width - mc["volume"]["slider"].width);
            mc["volume"]["slider"].removeEventListener(MouseEvent.MOUSE_DOWN,this.startDragVolume);
            mc["volume"]["slider"].removeEventListener(MouseEvent.MOUSE_UP,this.stopDragVolume);
            mc["btnMinus"].removeEventListener(MouseEvent.CLICK,this.onChangeVolume);
            mc["btnAdd"].removeEventListener(MouseEvent.CLICK,this.onChangeVolume);
            mc["btnToggleSound"].removeEventListener(MouseEvent.CLICK,this.toggleSound);
         }
      }
      
      public function refreshAP() : void
      {
         var mc:MovieClip = null;
         var mainChar:* = undefined;
         var i:uint = 0;
         var critical:Number = NaN;
         var dodge:Number = NaN;
         var counter:int = 0;
         var BloodlineData_Arr:Array = null;
         var j:uint = 0;
         var blArr:Array = null;
         var seArr:Array = null;
         var value:Object = null;
         var value3:Object = null;
         var changeToNum:int = 0;
         var skillType:String = null;
         if(this["profile"] == null)
         {
            return;
         }
         mc = this["profile"];
         mainChar = Central.main.getMainChar();
         mc["hpTxt"].text = mainChar.hp + " / " + mainChar.maxHP;
         mc["hpBar"].scaleX *= mainChar.hp / mainChar.maxHP;
         mc["cpTxt"].text = mainChar.cp + " / " + mainChar.maxCP;
         mc["cpBar"].scaleX *= mainChar.cp / mainChar.maxCP;
         mc["agilityTxt"].text = mainChar.agility;
         critical = mainChar.critical * 100 + this.ActiveWeaponBonus("CRITICAL");
         mc["criticalTxt"].text = critical.toFixed(1) + "%";
         dodge = mainChar.dodge * 100 + this.ActiveWeaponBonus("DODGE");
         mc["dodgeTxt"].text = dodge.toFixed(1) + "%";
         mc["windTxt"].text = mainChar.getData(DBCharacterData.WIND);
         mc["fireTxt"].text = mainChar.getData(DBCharacterData.FIRE);
         mc["lightningTxt"].text = mainChar.getData(DBCharacterData.LIGHTNING);
         mc["waterTxt"].text = mainChar.getData(DBCharacterData.WATER);
         mc["earthTxt"].text = mainChar.getData(DBCharacterData.EARTH);
         for(i = 0; i < this.INC_BUTTONS.length; i++)
         {
            if(mainChar.getLevel() - mainChar.apInvested <= 0)
            {
               mc[this.INC_BUTTONS[i]].removeEventListener(MouseEvent.CLICK,this.incAP);
               mc[this.INC_BUTTONS[i]].visible = false;
               mc["apTxt"].text = "0";
            }
            else
            {
               mc[this.INC_BUTTONS[i]].addEventListener(MouseEvent.CLICK,this.incAP);
               mc[this.INC_BUTTONS[i]].visible = true;
               mc["apTxt"].text = mainChar.getLevel() - mainChar.apInvested;
            }
         }
         Central.main.showDynamicTooltip(mc["ninjutsuIcon"],String("<font size=\'16\'>" + Central.main.langLib.get(1578)[5] + "</font>"));
         Central.main.showDynamicTooltip(mc["talentIcon"],String("<font size=\'16\'>" + Central.main.langLib.get(1579)[8] + "</font>"));
         counter = 1;
         for(i = 0; i < 6; i++)
         {
            skillType = String(this.SKILL_TYPE_BUTTONS[i]).substr(3,String(this.SKILL_TYPE_BUTTONS[i]).length).toLowerCase();
            if(Boolean(Central.main.getMainChar().hasSkillType(skillType)) && skillType != "taijutsu")
            {
               mc["skillBtn" + counter].gotoAndStop(skillType);
               switch(skillType)
               {
                  case "wind":
                     Central.main.showDynamicTooltip(mc["skillBtn" + counter],String("<font size=\'16\'>" + Central.main.langLib.get(1578)[0] + "</font>"));
                     break;
                  case "fire":
                     Central.main.showDynamicTooltip(mc["skillBtn" + counter],String("<font size=\'16\'>" + Central.main.langLib.get(1578)[1] + "</font>"));
                     break;
                  case "lightning":
                     Central.main.showDynamicTooltip(mc["skillBtn" + counter],String("<font size=\'16\'>" + Central.main.langLib.get(1578)[2] + "</font>"));
                     break;
                  case "water":
                     Central.main.showDynamicTooltip(mc["skillBtn" + counter],String("<font size=\'16\'>" + Central.main.langLib.get(1578)[3] + "</font>"));
                     break;
                  case "earth":
                     Central.main.showDynamicTooltip(mc["skillBtn" + counter],String("<font size=\'16\'>" + Central.main.langLib.get(1578)[4] + "</font>"));
               }
               mc["skillBtn" + counter].addEventListener(MouseEvent.CLICK,this.goOwnSkill);
               counter++;
            }
         }
         if(counter <= 3)
         {
            if(Account.getAccountType() == Account.PREMIUM)
            {
               mc["skillBtn" + counter].gotoAndStop(this.skillProfileBtn[1]);
               Central.main.initButton(mc["skillBtn" + counter]["learn"],this.goSkill,null);
               mc["skillBtn" + counter]["learn"]["learnIcon"].text = Central.main.langLib.get(1584);
               Central.main.showDynamicTooltip(mc["skillBtn" + counter],String("<font size=\'16\'>" + Central.main.langLib.get(1578)[6] + "</font>"));
               counter++;
            }
            else if(counter == 3)
            {
               mc["skillBtn" + counter].gotoAndStop(this.skillProfileBtn[1]);
               Central.main.initButton(mc["skillBtn" + counter]["learn"],this.gotoEmblem_learn,null);
               mc["skillBtn" + counter]["learn"]["learnIcon"].text = Central.main.langLib.get(1584);
               Central.main.showDynamicTooltip(mc["skillBtn" + counter],String("<font size=\'16\'>" + Central.main.langLib.get(1578)[6] + "</font>"));
               counter++;
            }
            else
            {
               mc["skillBtn" + counter].gotoAndStop(this.skillProfileBtn[1]);
               Central.main.initButton(mc["skillBtn" + counter]["learn"],this.goSkill,null);
               mc["skillBtn" + counter]["learn"]["learnIcon"].text = Central.main.langLib.get(1584);
               Central.main.showDynamicTooltip(mc["skillBtn" + counter],String("<font size=\'16\'>" + Central.main.langLib.get(1578)[6] + "</font>"));
               counter++;
            }
         }
         for(i = uint(counter); i <= 3; i++)
         {
            mc["skillBtn" + i].gotoAndStop(1);
         }
         mc["telent1"].gotoAndStop(this.telentBtn[2]);
         mc["telent2"].gotoAndStop(this.telentBtn[3]);
         mc["telent3"].gotoAndStop(this.telentBtn[3]);
         BloodlineData_Arr = [];
         j = 0;
         blArr = [];
         seArr = [];
         for each(value in Central.main.BLOODLINE_DATA)
         {
            BloodlineData_Arr.push(value);
         }
         for each(value3 in Central.main.getMainChar().bloodline)
         {
            if(value3.bloodline_id >= 1 && (value3.bloodline_id <= 4 || value3.bloodline_id > 9))
            {
               if(blArr.indexOf(value3.bloodline_id) == -1)
               {
                  blArr.push(value3.bloodline_id);
               }
            }
            else if(value3.bloodline_id >= 5 && value3.bloodline_id <= 9)
            {
               if(seArr.indexOf(value3.bloodline_id) == -1)
               {
                  seArr.push(value3.bloodline_id);
               }
            }
         }
         changeToNum = 0;
         if(blArr.length > 0)
         {
            changeToNum = int(blArr[0]);
            mc["telent1"].gotoAndStop(this.telentBtn[changeToNum + 3]);
            mc["telent1"].addEventListener(MouseEvent.CLICK,this.goOwnTelent);
            for(j = 0; j < BloodlineData_Arr.length; j++)
            {
               if(BloodlineData_Arr[j].id == "bloodline" + changeToNum)
               {
                  Central.main.showDynamicTooltip(mc["telent1"],String("<font size=\'16\'>" + BloodlineData_Arr[j].name + "</font>"));
               }
            }
         }
         else if(Central.main.getMainChar().getData(DBCharacterData.RANK) >= 4 && Central.main.getMainChar().getLevel() >= 40)
         {
            mc["telent1"].gotoAndStop(this.telentBtn[0]);
            Central.main.initButton(mc["telent1"]["learn"],this.goTelent,null);
            mc["telent1"]["learn"]["learnIcon"].text = Central.main.langLib.get(1584);
            Central.main.showDynamicTooltip(mc["telent1"],String("<font size=\'16\'>" + Central.main.langLib.get(1579)[9] + "</font>"));
         }
         else
         {
            mc["telent1"].gotoAndStop(this.telentBtn[2]);
            Central.main.showDynamicTooltip(mc["telent1"],String("<font size=\'16\'>" + Central.main.langLib.get(1579)[10] + "</font>"));
         }
         if(seArr.length == 0)
         {
            if(Central.main.getMainChar().getData(DBCharacterData.RANK) >= 6 && Central.main.getMainChar().getLevel() >= 60)
            {
               mc["telent2"].gotoAndStop(this.telentBtn[1]);
               Central.main.initButton(mc["telent2"]["learn"],this.goTelent,null);
               mc["telent2"]["learn"]["learnIcon"].text = Central.main.langLib.get(1584);
               Central.main.showDynamicTooltip(mc["telent2"],String("<font size=\'16\'>" + Central.main.langLib.get(1579)[9] + "</font>"));
               mc["telent3"].gotoAndStop(this.telentBtn[1]);
               Central.main.initButton(mc["telent3"]["learn"],this.goTelent,null);
               mc["telent3"]["learn"]["learnIcon"].text = Central.main.langLib.get(1584);
               Central.main.showDynamicTooltip(mc["telent3"],String("<font size=\'16\'>" + Central.main.langLib.get(1579)[9] + "</font>"));
            }
            else if(Central.main.getMainChar().getData(DBCharacterData.RANK) >= 4 && Central.main.getMainChar().getLevel() >= 50)
            {
               mc["telent2"].gotoAndStop(this.telentBtn[1]);
               Central.main.initButton(mc["telent2"]["learn"],this.goTelent,null);
               mc["telent2"]["learn"]["learnIcon"].text = Central.main.langLib.get(1584);
               Central.main.showDynamicTooltip(mc["telent2"],String("<font size=\'16\'>" + Central.main.langLib.get(1579)[9] + "</font>"));
               mc["telent3"].gotoAndStop(this.telentBtn[3]);
               Central.main.showDynamicTooltip(mc["telent3"],String("<font size=\'16\'>" + Central.main.langLib.get(1579)[12] + "</font>"));
            }
            else
            {
               mc["telent2"].gotoAndStop(this.telentBtn[3]);
               Central.main.showDynamicTooltip(mc["telent2"],String("<font size=\'16\'>" + Central.main.langLib.get(1579)[11] + "</font>"));
               mc["telent3"].gotoAndStop(this.telentBtn[3]);
               Central.main.showDynamicTooltip(mc["telent3"],String("<font size=\'16\'>" + Central.main.langLib.get(1579)[12] + "</font>"));
            }
         }
         else if(seArr.length == 1)
         {
            if(Central.main.getMainChar().getData(DBCharacterData.RANK) >= 6 && Central.main.getMainChar().getLevel() >= 60)
            {
               changeToNum = int(seArr[0]);
               mc["telent2"].gotoAndStop(this.telentBtn[changeToNum + 3]);
               mc["telent2"].addEventListener(MouseEvent.CLICK,this.goOwnTelent);
               for(j = 0; j < BloodlineData_Arr.length; j++)
               {
                  if(BloodlineData_Arr[j].id == "bloodline" + changeToNum)
                  {
                     Central.main.showDynamicTooltip(mc["telent2"],String("<font size=\'16\'>" + BloodlineData_Arr[j].name + "</font>"));
                  }
               }
               mc["telent3"].gotoAndStop(this.telentBtn[1]);
               Central.main.initButton(mc["telent3"]["learn"],this.goTelent,null);
               mc["telent3"]["learn"]["learnIcon"].text = Central.main.langLib.get(1584);
               Central.main.showDynamicTooltip(mc["telent3"],String("<font size=\'16\'>" + Central.main.langLib.get(1579)[9] + "</font>"));
            }
            else if(Central.main.getMainChar().getData(DBCharacterData.RANK) >= 4 && Central.main.getMainChar().getLevel() >= 50)
            {
               changeToNum = int(seArr[0]);
               mc["telent2"].gotoAndStop(this.telentBtn[changeToNum + 3]);
               mc["telent2"].addEventListener(MouseEvent.CLICK,this.goOwnTelent);
               Central.main.showDynamicTooltip(mc["telent2"],String("<font size=\'16\'>" + Central.main.langLib.get(1579)[changeToNum - 1] + "</font>"));
               mc["telent3"].gotoAndStop(this.telentBtn[3]);
               Central.main.showDynamicTooltip(mc["telent3"],String("<font size=\'16\'>" + Central.main.langLib.get(1579)[12] + "</font>"));
            }
         }
         else if(seArr.length == 2)
         {
            changeToNum = int(seArr[0]);
            mc["telent2"].gotoAndStop(this.telentBtn[changeToNum + 3]);
            mc["telent2"].addEventListener(MouseEvent.CLICK,this.goOwnTelent);
            for(j = 0; j < BloodlineData_Arr.length; j++)
            {
               if(BloodlineData_Arr[j].id == "bloodline" + changeToNum)
               {
                  Central.main.showDynamicTooltip(mc["telent2"],String("<font size=\'16\'>" + BloodlineData_Arr[j].name + "</font>"));
               }
            }
            changeToNum = int(seArr[1]);
            mc["telent3"].gotoAndStop(this.telentBtn[changeToNum + 3]);
            mc["telent3"].addEventListener(MouseEvent.CLICK,this.goOwnTelent);
            for(j = 0; j < BloodlineData_Arr.length; j++)
            {
               if(BloodlineData_Arr[j].id == "bloodline" + changeToNum)
               {
                  Central.main.showDynamicTooltip(mc["telent3"],String("<font size=\'16\'>" + BloodlineData_Arr[j].name + "</font>"));
               }
            }
         }
         else
         {
            mc["telent2"].gotoAndStop(this.telentBtn[3]);
            Central.main.showDynamicTooltip(mc["telent2"],String("<font size=\'16\'>" + Central.main.langLib.get(1579)[11] + "</font>"));
            mc["telent3"].gotoAndStop(this.telentBtn[3]);
            Central.main.showDynamicTooltip(mc["telent3"],String("<font size=\'16\'>" + Central.main.langLib.get(1579)[12] + "</font>"));
         }
         mc["btnDiscover"].visible = false;
      }
      
      private function goTelent(e:MouseEvent) : *
      {
         if(Central.main.checkGameStatus() == Timeline.BATTLE)
         {
            Central.main.showInfo(Central.main.langLib.get(607));
            return;
         }
         this.gotoAndStop(Timeline.IDLE);
         Central.panel.getInstance().show("bloodline_shop");
      }
      
      private function goOwnTelent(e:MouseEvent) : *
      {
         if(Central.main.checkGameStatus() == Timeline.BATTLE)
         {
            Central.main.showInfo(Central.main.langLib.get(607));
            return;
         }
         Central.panel.getInstance().show("bloodline_profile");
      }
      
      private function gotoEmblem_learn(e:MouseEvent) : *
      {
         Central.main.showUpgradeAccount(Central.main.langLib.get(1450),"Academy");
      }
      
      private function goOwnSkill(e:MouseEvent) : *
      {
         if(Central.main.checkGameStatus() == Timeline.BATTLE)
         {
            Central.main.showInfo(Central.main.langLib.get(256));
            return;
         }
         this.gotoAndPlay(Timeline.SKILL);
      }
      
      private function goSkill(e:MouseEvent) : *
      {
         if(Central.main.checkGameStatus() == Timeline.BATTLE)
         {
            Central.main.showInfo(Central.main.langLib.get(256));
            return;
         }
         this.gotoAndStop(Timeline.IDLE);
         Central.panel.getInstance().show("academy");
      }
      
      private function incAP(evt:MouseEvent) : void
      {
         var btnName:String = null;
         var tranBtnname:String = null;
         if(Central.main.checkGameStatus() == Timeline.BATTLE)
         {
            Central.main.showInfo(Central.main.langLib.get(257));
            return;
         }
         btnName = evt.currentTarget.name;
         if(Account.getAccountType() == Account.PREMIUM)
         {
            this.confirmIncAP(btnName);
         }
         else
         {
            switch(btnName)
            {
               case "WIND":
                  tranBtnname = Central.main.langLib.titleTxt(TitleData.WIND);
                  break;
               case "FIRE":
                  tranBtnname = Central.main.langLib.titleTxt(TitleData.FIRE);
                  break;
               case "LIGHTNING":
                  tranBtnname = Central.main.langLib.titleTxt(TitleData.THUNDER);
                  break;
               case "EARTH":
                  tranBtnname = Central.main.langLib.titleTxt(TitleData.EARTH);
                  break;
               case "WATER":
                  tranBtnname = Central.main.langLib.titleTxt(TitleData.WATER);
            }
            Central.main.showConfirmation(String(Central.main.langLib.get(258)).replace("[valbtnname]",tranBtnname),Delegate.create(this,this.confirmIncAP,btnName),new Function());
         }
      }
      
      private function confirmIncAP(btnName:String) : void
      {
         Central.main.getMainChar().updateData(DBCharacterData[btnName],Central.main.getMainChar().getData(DBCharacterData[btnName]) + 1);
         if(Central.main.checkGameStatus() == Timeline.MAP)
         {
            Central.main.getMainChar().restoreOriginalStatus();
         }
         this.isAPChange = true;
         this.refreshAP();
      }
      
      private function confirmRename(evt:MouseEvent) : void
      {
         if(Central.main.checkGameStatus() == Timeline.BATTLE)
         {
            Central.main.showInfo(Central.main.langLib.get(257));
            return;
         }
         Central.main.showRenameConfirmation(Central.main.langLib.get(1316),this.resetName,new Function(),1000,600,Central.main.langLib.get(1317));
      }
      
      private function resetName(returnTxt:String) : void
      {
         Central.main.showAmfLoading();
         Central.main.amfClient.service("CharacterService.changeName",[Central.main.account.getAccountSessionKey(),returnTxt],this.renameResponse);
         this.tempNameSpace = returnTxt;
      }
      
      private function renameResponse(response:Object) : *
      {
         var mainChar:* = undefined;
         var tokenRequired:int = 0;
         Central.main.hideAmfLoading();
         if(Central.main.validateAmfResponse(response))
         {
            mainChar = Central.main.getMainChar();
            mainChar.setCharacterName(this.tempNameSpace);
            this["profile"]["nameTxt"].text = mainChar.getCharacterName();
            this[" "]["nameTxt"].text = mainChar.getCharacterName();
            tokenRequired = 0;
            if(Account.getAccountType() == Account.FREE)
            {
               Central.main.account.balance = Central.main.account.getAccountBalance() - 1000;
               tokenRequired = 1000;
            }
            else if(Account.getAccountType() == Account.PREMIUM)
            {
               Central.main.account.balance = Central.main.account.getAccountBalance() - 600;
               tokenRequired = 600;
            }
            Central.main.tracking.trackSale("ChangeName",tokenRequired,"0");
            this["tokenTxt"].text = Account.getAccountBalance();
         }
      }
      
      public function renameReloadPanel() : *
      {
         this["profile"]["nameTxt"].text = Central.main.getMainChar().getCharacterName();
         this["characterStatus"]["frame_1"]["nameTxt"].text = Central.main.getMainChar().getCharacterName();
      }
      
      private function confirmPetRename(evt:MouseEvent) : void
      {
         if(Central.main.checkGameStatus() == Timeline.BATTLE)
         {
            Central.main.showInfo(Central.main.langLib.get(257));
            return;
         }
         Central.main.showRenameConfirmation(Central.main.langLib.get(1316),this.resetPetName,new Function(),1000,600,Central.main.langLib.get(1317));
      }
      
      private function resetPetName(returnTxt:String) : void
      {
         Central.main.showAmfLoading();
         Central.main.amfClient.service("CharacterService.changePetName",[Central.main.account.getAccountSessionKey(),this.selectedPetID,returnTxt],this.renamePetResponse);
         this.tempNameSpace = returnTxt;
      }
      
      private function renamePetResponse(response:Object) : *
      {
         var _pet:* = undefined;
         var panel:MovieClip = null;
         if(Central.main.validateAmfResponse(response))
         {
            _pet = this.petArray[(this.curPage - 1) * 4 + (this.selectedPetSlot - 1)];
            _pet.setCharacterName(this.tempNameSpace);
            panel = this["pet"];
            panel["slot_" + this.selectedPetSlot]["nameTxt"].text = _pet.getCharacterName();
            panel["nameTxt"].text = _pet.getCharacterName();
            if(Account.getAccountType() == Account.FREE)
            {
               Central.main.account.balance = Central.main.account.getAccountBalance() - 1000;
            }
            else if(Account.getAccountType() == Account.PREMIUM)
            {
               Central.main.account.balance = Central.main.account.getAccountBalance() - 600;
            }
            this["tokenTxt"].text = Account.getAccountBalance();
         }
         Central.main.hideAmfLoading();
      }
      
      private function confirmReset(evt:MouseEvent) : void
      {
         if(Central.main.checkGameStatus() == Timeline.BATTLE)
         {
            Central.main.showInfo(Central.main.langLib.get(257));
            return;
         }
         Central.main.showConfirmation(Central.main.langLib.get(264),this.resetAP,new Function());
      }
      
      private function resetAP() : void
      {
         if(Account.getAccountType() == Account.PREMIUM)
         {
            Central.main.provision();
            Central.main.getMainChar().resetAP(2);
            if(Central.main.checkGameStatus() == Timeline.MAP)
            {
               Central.main.getMainChar().restoreOriginalStatus();
            }
            Central.main.saveCharacter();
            this.refreshAP();
            Central.main.updateMenu();
         }
         else
         {
            Central.main.showTokenEmblemSelection(TokenData.TYPE_RESET_AP);
         }
      }
      
      private function updateEquippedSkill() : void
      {
         var skillPanel:MovieClip = null;
         var skillList:Array = null;
         var i:uint = 0;
         var holder:MovieClip = null;
         var skillData:Object = null;
         var tooltipStr:String = null;
         skillPanel = this["skillPanel"];
         skillList = Central.main.getMainChar().getSkillListArr();
         for(i = 0; i < Data.MAX_SKILL_NUMBER; i++)
         {
            GF.removeAllChild(skillPanel["skill_" + i]["holder"]);
            Central.main.hideDynamicTooltip(skillPanel["skill_" + i]);
            skillPanel["btnSkillClear" + i].visible = false;
         }
         for(i = 0; i < skillList.length; i++)
         {
            holder = skillPanel["skill_" + i]["holder"];
            skillData = Central.main.SKILL_DATA[skillList[i]];
            if(skillData)
            {
               holder.addChild(Central.main.getLib(skillData.swfName));
            }
            tooltipStr = TooltipData.getItemTooltip(TooltipData.TOOLTIP_TYPE_SKILL,Central.main.SKILL_DATA[skillList[i]].id);
            Central.main.showDynamicTooltip(skillPanel["skill_" + i],String("<font size=\'16\'>" + tooltipStr + "</font>"));
            skillPanel["btnSkillClear" + i].visible = true;
         }
      }
      
      private function clearSkillList() : void
      {
         var i:uint = 0;
         var itemMc:MovieClip = null;
         i = 0;
         for(i = 1; i <= this.SKILL_PER_PAGE; i++)
         {
            itemMc = this["skillPanel"]["item_" + i];
            MovieClipButton.highlight(itemMc,false);
            itemMc["nameTxt"].text = "";
            itemMc["levelTxt"].text = "";
            itemMc["msgTxt"].text = Central.main.langLib.titleTxt(TitleData.EQUIPPED);
            itemMc["msgTxt"].visible = false;
            GF.removeAllChild(itemMc["iconMC"]["iconHolder"]);
            itemMc["btnEquip"].visible = false;
         }
      }
      
      private function clearSkillTypeTab() : void
      {
         var i:uint = 0;
         var mcTab:MovieClip = null;
         var skillPanel:MovieClip = null;
         skillPanel = this["skillPanel"];
         for(i = 1; i <= 5; i++)
         {
            mcTab = skillPanel["btnTab" + i];
            mcTab.skillType = null;
            GF.removeAllChild(mcTab);
         }
      }
      
      public function updateSkillList() : void
      {
         var skillList:Array = null;
         var invSkill:Array = null;
         var skillArr:Array = null;
         var skillDataArr:Array = null;
         var finalItemNumber:int = 0;
         var i:* = undefined;
         var j:uint = 0;
         var seq:uint = 0;
         var skillTypes:HashMap = null;
         var itemMc:MovieClip = null;
         var icon:MovieClip = null;
         var tooltipStr:String = null;
         this.clearSkillList();
         skillList = Central.main.getMainChar().getSkillListArr();
         invSkill = Central.main.getMainChar().getInventory(InventoryData.TYPE_SKILL);
         skillArr = [];
         skillDataArr = [];
         seq = 1;
         var invSenjutsu:Array = Central.main.getMainChar().getData(DBCharacterData.SENJUTSU);
         var invSenjutsu1:Array = Central.main.getMainChar().getInventory(DBCharacterData.SENJUTSU_SKILL);
         if(this.selectedSkillType == "all")
         {
            skillArr = invSkill;
         }
         else
         {
            for(i = 0; i < invSkill.length; i++)
            {
               if(this.selectedSkillType == Central.main.SKILL_DATA[invSkill[i]].type)
               {
                  skillArr.push(invSkill[i]);
               }
            }
         }
         for(i = 0; i < skillArr.length; i++)
         {
            skillDataArr.push(Central.main.SKILL_DATA[skillArr[i]]);
         }
         skillDataArr.sortOn("level",Array.NUMERIC);
         skillDataArr.reverse();
         this.totalPage = Math.ceil(skillArr.length / this.SKILL_PER_PAGE);
         finalItemNumber = this.curPage * this.SKILL_PER_PAGE;
         if(skillArr.length < finalItemNumber)
         {
            finalItemNumber = int(skillArr.length);
         }
         for(i = (this.curPage - 1) * this.SKILL_PER_PAGE; i < finalItemNumber; i++)
         {
            itemMc = this["skillPanel"]["item_" + seq];
            itemMc.visible = true;
            itemMc.skillData = skillDataArr[i];
            itemMc.skillData.id = skillDataArr[i].id;
            itemMc["nameTxt"].text = skillDataArr[i].name;
            itemMc["levelTxt"].text = skillDataArr[i].level;
            itemMc["msgTxt"].visible = true;
            icon = Central.main.getLib(skillDataArr[i].swfName);
            icon.scaleX = 1;
            icon.scaleY = 1;
            itemMc["iconMC"]["iconHolder"].addChild(icon);
            tooltipStr = TooltipData.getItemTooltip(TooltipData.TOOLTIP_TYPE_SKILL,skillDataArr[i].id);
            Central.main.showDynamicTooltip(itemMc,String("<font size=\'16\'>" + tooltipStr + "</font>"));
            if(skillList.indexOf(skillDataArr[i].id) >= 0)
            {
               itemMc["msgTxt"].visible = true;
            }
            else
            {
               itemMc["msgTxt"].visible = false;
               itemMc["btnEquip"].skillID = skillDataArr[i].id;
            }
            if(skillDataArr[i].upgrade_group > 0 && this.hasUpgradedSkill(skillDataArr[i].upgrade_group))
            {
               itemMc["upgradeIcon"].visible = true;
            }
            else
            {
               itemMc["upgradeIcon"].visible = false;
            }
            MovieClipButton.enableButton(itemMc);
            if(!itemMc.hasEventListener(MouseEvent.CLICK))
            {
               itemMc.addEventListener(MouseEvent.CLICK,this.onSelectSkill);
            }
            itemMc.addEventListener(MouseEvent.MOUSE_OVER,this.overSkillBtnEffect);
            itemMc.addEventListener(MouseEvent.MOUSE_OUT,this.outSkillBtnEffect);
            seq++;
         }
         for(i = seq; i < this.SKILL_PER_PAGE + 1; i++)
         {
            itemMc = this["skillPanel"]["item_" + seq];
            itemMc.visible = false;
            seq++;
         }
         if(this.totalPage == 0)
         {
            this["skillPanel"]["pageTxt"].text = "";
         }
         else
         {
            this["skillPanel"]["pageTxt"].text = this.curPage + "/" + this.totalPage;
         }
         this["skillPanel"]["btnPrevPage"].addEventListener(MouseEvent.CLICK,this.changePage);
         this["skillPanel"]["btnNextPage"].addEventListener(MouseEvent.CLICK,this.changePage);
         skillTypes = Central.main.getMainChar().getSkillTypes(true);
         if(this.selectedSkillType != SkillData.TYPE_TAIJUTSU && this.selectedSkillType != SkillData.TYPE_GENJUTSU && skillTypes.toArray().length >= 1)
         {
            this["skillPanel"]["btnResetSkill"].visible = true;
         }
         else
         {
            this["skillPanel"]["btnResetSkill"].visible = false;
         }
      }
      
      private function overSkillBtnEffect(evt:MouseEvent) : void
      {
         var mc:MovieClip = null;
         mc = MovieClip(evt.currentTarget);
         if(mc["msgTxt"].visible == false)
         {
            mc["btnEquip"].visible = true;
         }
      }
      
      private function outSkillBtnEffect(evt:MouseEvent) : void
      {
         var mc:MovieClip = null;
         mc = MovieClip(evt.currentTarget);
         mc["btnEquip"].visible = false;
      }
      
      private function changePage(evt:MouseEvent) : void
      {
         switch(evt.currentTarget.name)
         {
            case "btnNextPage":
               ++this.curPage;
               if(this.curPage > this.totalPage)
               {
                  this.curPage = this.totalPage;
                  Central.main.showInfo(Central.main.langLib.get(58));
                  return;
               }
               this.updateSkillList();
               break;
            case "btnPrevPage":
               --this.curPage;
               if(this.curPage <= 0)
               {
                  this.curPage = 1;
                  Central.main.showInfo(Central.main.langLib.get(57));
                  return;
               }
               this.updateSkillList();
         }
      }
      
      private function onSelectSkill(evt:MouseEvent = null) : void
      {
         var skillPanel:MovieClip = null;
         var skillData:Object = null;
         var finalDmg:int = 0;
         var skillList:Array = null;
         skillPanel = this["skillPanel"];
         skillData = evt.currentTarget.skillData;
         if(this.selectedSkillButton != null)
         {
            MovieClipButton.highlight(this.selectedSkillButton,false);
         }
         this.selectedSkillButton = MovieClip(evt.currentTarget);
         MovieClipButton.highlight(this.selectedSkillButton);
         this.selectedSkill = skillData;
         skillPanel["iconMC"].visible = true;
         GF.removeAllChild(skillPanel["iconMC"]["iconHolder"]);
         skillPanel["iconMC"]["iconHolder"].addChild(Central.main.getLib(skillData.swfName));
         skillPanel["skillTypeIcon"].gotoAndStop(skillData.type);
         skillPanel["nameTxt"].text = skillData.name;
         skillPanel["iconLv"].visible = true;
         Central.main.showDynamicTooltip(skillPanel["iconLv"],String("<font size=\'16\'>" + Central.main.langLib.titleTxt(TitleData.LEVEL) + "</font>"));
         skillPanel["lvlTxt"].text = skillData.level;
         skillPanel["descriptionTxt"].htmlText = skillData.description;
         skillPanel["iconCooldown"].visible = true;
         Central.main.showDynamicTooltip(skillPanel["iconCooldown"],String("<font size=\'16\'>" + Central.main.langLib.titleTxt(TitleData.COOLDOWN) + "</font>"));
         skillPanel["cooldownTxt"].text = skillData.cooldown;
         skillPanel["iconChakra"].visible = true;
         Central.main.showDynamicTooltip(skillPanel["iconChakra"],String("<font size=\'16\'>" + Central.main.langLib.titleTxt(TitleData.CHAKRA) + "</font>"));
         skillPanel["cpTxt"].text = skillData.cp;
         skillPanel["damageTxt"].text = Central.main.langLib.titleTxt(TitleData.DAMAGE) + ": -";
         finalDmg = int(skillData.damage);
         if(skillData.skill_hit_num >= 2)
         {
            finalDmg = Math.round(skillData.damage * skillData.skill_hit_num);
         }
         if(skillData.effect)
         {
            if(skillData.effect.type == SkillData.EFFECT_TYPE_HEAL)
            {
               skillPanel["damageTxt"].text = "";
               skillPanel["damageIcon"].visible = false;
               skillPanel["healIcon"].visible = true;
               Central.main.showDynamicTooltip(skillPanel["healIcon"],String("<font size=\'16\'>" + Central.main.langLib.titleTxt(TitleData.HEAL) + "</font>"));
               skillPanel["healTxt"].text = finalDmg;
            }
            else
            {
               skillPanel["damageTxt"].text = finalDmg;
               skillPanel["damageIcon"].visible = true;
               Central.main.showDynamicTooltip(skillPanel["damageIcon"],String("<font size=\'16\'>" + Central.main.langLib.titleTxt(TitleData.DAMAGE) + "</font>"));
               skillPanel["healIcon"].visible = false;
               skillPanel["healTxt"].text = "";
            }
         }
         else
         {
            skillPanel["damageTxt"].text = finalDmg;
            skillPanel["healIcon"].visible = false;
            skillPanel["healTxt"].text = "";
            skillPanel["damageIcon"].visible = true;
            Central.main.showDynamicTooltip(skillPanel["damageIcon"],String("<font size=\'16\'>" + Central.main.langLib.titleTxt(TitleData.DAMAGE) + "</font>"));
         }
         skillList = Central.main.getMainChar().getSkillListArr();
         if(skillList.indexOf(this.selectedSkill.id) >= 0)
         {
            skillPanel["btnEquip"].visible = false;
         }
         else
         {
            skillPanel["btnEquip"].visible = true;
         }
         Central.main.initButton(skillPanel["btnEquip"],this.equipSkill,ButtonData.EQUIP);
         skillPanel["btnPreview"].visible = true;
         Central.main.initButton(skillPanel["btnPreview"],this.previewSkill,ButtonData.PREVIEW);
         if(this.selectedSkill.upgrade_group > 0 && this.hasUpgradedSkill(this.selectedSkill.upgrade_group))
         {
            skillPanel["btnUpgrade"].visible = true;
            skillPanel["btnUpgrade"].groupID = this.selectedSkill.upgrade_group;
            if(!skillPanel["btnUpgrade"].hasEventListener(MouseEvent.CLICK))
            {
               Central.main.initButton(skillPanel["btnUpgrade"],this.upgradeSkill,ButtonData.UPGRADE);
               skillPanel["btnUpgrade"].filters = null;
            }
            if(this.SkipSkillArr.indexOf(this.selectedSkill.upgrade_group) >= 0)
            {
               skillPanel["btnUpgrade"].visible = false;
               Central.main.disableButton(skillPanel["btnUpgrade"],this.upgradeSkill,ButtonData.UPGRADE);
            }
         }
         else
         {
            skillPanel["btnUpgrade"].visible = false;
            Central.main.disableButton(skillPanel["btnUpgrade"],this.upgradeSkill,ButtonData.UPGRADE);
         }
      }
      
      private function upgradeSkill(evt:MouseEvent) : void
      {
         var mc:MovieClip = null;
         mc = MovieClip(evt.currentTarget);
         Central.main.upgradeGroupID = mc.groupID;
         this.hide();
         Central.panel.getInstance().show("upgrade_skill");
      }
      
      private function hasUpgradedSkill(Group_id:String) : Boolean
      {
         var upgradeSkillDataArr:Array = null;
         var upgradeSkillArr:Array = null;
         var i:int = 0;
         upgradeSkillDataArr = Central.main.SKILL_DATA_ARR;
         upgradeSkillArr = [];
         i = 0;
         for(i = 0; i < upgradeSkillDataArr.length; i++)
         {
            if(upgradeSkillDataArr[i].upgrade_group == Group_id)
            {
               upgradeSkillArr.push(upgradeSkillDataArr[i]);
            }
         }
         upgradeSkillArr.sortOn(["level","crystal"],[Array.NUMERIC,Array.CASEINSENSITIVE]);
         for(i = 0; i < upgradeSkillArr.length; i++)
         {
            if(Central.main.getMainChar().hasSkill(upgradeSkillArr[i].id))
            {
               if(i == upgradeSkillArr.length - 1)
               {
                  return false;
               }
               return true;
            }
         }
         return false;
      }
      
      private function equipSkillQuick(evt:MouseEvent) : void
      {
         var t_skillID:String = null;
         var skillList:Array = null;
         t_skillID = evt.currentTarget.skillID;
         skillList = Central.main.getMainChar().getSkillListArr();
         if(Account.getAccountType() == Account.PREMIUM)
         {
            Central.main.provision();
         }
         if(Account.getAccountType() == Account.FREE && Boolean(Central.main.SKILL_DATA[t_skillID].premium))
         {
            Central.main.showUpgradeAccount(Central.main.langLib.get(1450),"Academy");
            return;
         }
         if(Central.main.getMainChar().getData(DBCharacterData.LEVEL) < Central.main.SKILL_DATA[t_skillID].level)
         {
            Central.main.showInfo(Central.main.langLib.get(266));
            return;
         }
         if(skillList.length >= Data.MAX_SKILL_NUMBER)
         {
            Central.main.showInfo(Central.main.langLib.get(267));
            return;
         }
         if(skillList.indexOf(t_skillID) >= 0)
         {
            Central.main.showInfo(Central.main.langLib.get(268));
            return;
         }
         skillList.push(t_skillID);
         Central.main.getMainChar().setSkillList(skillList,this.updateEquippedSkill);
         this.isSave = true;
         this.updateSkillList();
      }
      
      private function equipSkill(evt:MouseEvent) : void
      {
         var skillList:Array = null;
         if(Account.getAccountType() == Account.PREMIUM)
         {
            Central.main.provision();
         }
         if(Account.getAccountType() == Account.FREE && Boolean(Central.main.SKILL_DATA[this.selectedSkill.id].premium))
         {
            Central.main.showUpgradeAccount(Central.main.langLib.get(1450),"Academy");
            return;
         }
         if(Central.main.getMainChar().getData(DBCharacterData.LEVEL) < Central.main.SKILL_DATA[this.selectedSkill.id].level)
         {
            Central.main.showInfo(Central.main.langLib.get(266));
            return;
         }
         skillList = Central.main.getMainChar().getSkillListArr();
         if(skillList.length >= Data.MAX_SKILL_NUMBER)
         {
            Central.main.showInfo(Central.main.langLib.get(267));
            return;
         }
         if(skillList.indexOf(this.selectedSkill.id) >= 0)
         {
            Central.main.showInfo(Central.main.langLib.get(268));
            return;
         }
         skillList.push(this.selectedSkill.id);
         Central.main.getMainChar().setSkillList(skillList,this.updateEquippedSkill);
         this.isSave = true;
         this.updateSkillList();
      }
      
      private function clearCharSkill(evt:MouseEvent) : void
      {
         Central.main.getMainChar().setSkillList(new Array());
         this.isSave = true;
         this.updateEquippedSkill();
         this.updateSkillList();
      }
      
      private function resetSkill(evt:MouseEvent) : void
      {
         if(!Item.hasItem("popup_reset_skill"))
         {
            Central.main.loadPopupPanel("popup_reset_skill","ninjasaga.linkage.ResetTalent_Skill",this.popupSkillReset);
         }
         else
         {
            this.popupSkillReset();
         }
      }
      
      public function popupSkillReset() : void
      {
         var panel:Item = null;
         var _mainMc:MovieClip = null;
         var packageMC:MovieClip = null;
         _mainMc = Central.main.getMainMc();
         panel = Item.getItem("popup_reset_skill");
         packageMC = panel.getAsset("ninjasaga.linkage.ResetTalent_Skill");
         GF.removeAllChild(_mainMc["resetSkillHolder"]);
         _mainMc["resetSkillHolder"].addChild(packageMC);
         packageMC.show("SkillProfile");
      }
      
      public function reset_cb(resetSkillType:String) : void
      {
         var i:uint = 0;
         var skillDataArr:Array = null;
         i = 0;
         skillDataArr = Central.main.SKILL_DATA_ARR;
         var trainingSkill:Object = Central.main.getMainChar().trainingSkill;
         for(i = 0; i < skillDataArr.length; i++)
         {
            if(skillDataArr[i].type == resetSkillType && Boolean(Central.main.getMainChar().hasSkill(skillDataArr[i].id)))
            {
               Central.main.getMainChar().resetSkill(skillDataArr[i].id,this.updateSkillList);
            }
         }
      }
      
      private function clearCharSingleSkill(e:MouseEvent) : void
      {
         var skillArray:Array = null;
         var updatedSkillArray:Array = null;
         var btnName:String = null;
         var i:uint = 0;
         skillArray = Central.main.getMainChar().getSkillListArr();
         updatedSkillArray = new Array();
         btnName = e.currentTarget.name;
         for(i = 0; i < skillArray.length; i++)
         {
            if(parseInt(btnName.charAt(btnName.length - 1)) != i)
            {
               updatedSkillArray.push(skillArray[i]);
            }
         }
         Central.main.getMainChar().setSkillList(updatedSkillArray);
         this.isSave = true;
         this.updateEquippedSkill();
         this.updateSkillList();
      }
      
      private function previewSkill(evt:MouseEvent) : void
      {
         var swfObj:Object = null;
         if(!Skill.hasSkill(this.selectedSkill.id))
         {
            Central.main.loadSwf(["swf/skills/" + this.selectedSkill.swfName + ".swf"],this.gotoPreview);
         }
         else
         {
            swfObj = new Object();
            swfObj["swf/skills/" + this.selectedSkill.swfName + ".swf"] = Skill.getSkill(this.selectedSkill.id);
            this.gotoPreview(swfObj);
         }
      }
      
      private function gotoPreview(_swfObj:Object) : void
      {
         if(!Skill.hasSkill(this.selectedSkill.id))
         {
            Skill.setSkill(this.selectedSkill.id,_swfObj["swf/skills/" + this.selectedSkill.swfName + ".swf"]);
         }
         this.loadedSwf = Skill.getSkill(this.selectedSkill.id);
         Central.main.getMainChar().cloneCustomization(this.loadedSwf);
         this["skillPanel"].gotoAndStop(Timeline.PREVIEW);
      }
      
      public function onSkillPreview() : void
      {
         this["skillPanel"]["charMc"].addChild(this.loadedSwf);
         Central.main.initButton(this["skillPanel"]["btnReply"],this.playSkill,ButtonData.REPLAY);
         this.playSkill();
      }
      
      public function playSkill(evt:MouseEvent = null) : void
      {
         if(this["skillPanel"]["btnClose"].hasEventListener(MouseEvent.CLICK))
         {
            this["skillPanel"]["btnClose"].removeEventListener(MouseEvent.CLICK,this.hideSkillPreview);
         }
         this["skillPanel"]["btnClose"].visible = false;
         this.loadedSwf.gotoAndPlay(2);
         this.loadedSwf.setActionFinishCB(this.enableHideSkillPreview);
      }
      
      public function enableHideSkillPreview() : void
      {
         if(Boolean(this.getChildByName("skillPanel")) && Boolean(this["skillPanel"].getChildByName("btnClose")))
         {
            this["skillPanel"]["btnClose"].addEventListener(MouseEvent.CLICK,this.hideSkillPreview);
            this["skillPanel"]["btnClose"].visible = true;
         }
      }
      
      private function hideSkillPreview(evt:MouseEvent) : void
      {
         GF.removeParent(this.loadedSwf);
         this["skillPanel"].gotoAndStop(Timeline.IDLE);
      }
      
      private function changeSkillType(evt:MouseEvent) : void
      {
         var i:uint = 0;
         var skillPanel:MovieClip = null;
         var mc:MovieClip = null;
         skillPanel = this["skillPanel"];
         this.selectedSkillType = evt.currentTarget.parent.skillType;
         for(i = 0; i < 5; i++)
         {
            mc = skillPanel["btnTab" + (i + 1)];
            if(mc.skillType != null)
            {
               if(mc.skillType != this.selectedSkillType)
               {
                  MovieClip(mc.getChildAt(0)).gotoAndStop("unselect");
               }
            }
         }
         evt.currentTarget.parent.gotoAndStop("select");
         this.selectedSkillTypeButton = MovieClip(evt.currentTarget.parent);
         this.curPage = 1;
         skillPanel["iconMC"].visible = false;
         skillPanel["skillTypeIcon"].gotoAndStop(Timeline.IDLE);
         skillPanel["nameTxt"].text = "";
         skillPanel["lvlTxt"].text = "";
         skillPanel["healTxt"].text = "";
         skillPanel["damageTxt"].text = "";
         skillPanel["cpTxt"].text = "";
         skillPanel["cooldownTxt"].text = "";
         skillPanel["descriptionTxt"].text = "";
         skillPanel["btnEquip"].visible = false;
         skillPanel["btnPreview"].visible = false;
         skillPanel["btnUpgrade"].visible = false;
         skillPanel["iconLv"].visible = false;
         skillPanel["iconChakra"].visible = false;
         skillPanel["healIcon"].visible = false;
         skillPanel["damageIcon"].visible = false;
         skillPanel["iconCooldown"].visible = false;
         this.updateSkillList();
      }
      
      public function finalizeInstantTrain() : void
      {
         var mc:MovieClip = null;
         mc = this["skillPanel"]["progressMc"]["skillTimerMC"]["barMC"];
         mc["timeTxt"].text = "00:00:00";
         mc["percentBar"].scaleX = 1;
         Central.main.getMainChar().setUpdateTrainingSkill(0);
         this["skillPanel"]["progressMc"].updateProgress();
      }
      
      public function stopTrainingTimer() : void
      {
         if(this["skillPanel"])
         {
            if(this["skillPanel"]["progressMc"])
            {
               this["skillPanel"]["progressMc"].stopTrainSkillModule();
            }
         }
      }
      
      private function changeQuality(evt:MouseEvent) : void
      {
         var curQuality:* = 0;
         var desc:String = null;
         curQuality = this.QUALITY_ARR.indexOf(stage.quality.toLowerCase());
         switch(evt.currentTarget.name)
         {
            case "btnQualityPrev":
               curQuality--;
               if(curQuality < 0)
               {
                  curQuality = int(this.QUALITY_ARR.length - 1);
               }
               break;
            case "btnQualityNext":
               if(++curQuality >= this.QUALITY_ARR.length)
               {
                  curQuality = 0;
               }
         }
         stage.quality = this.QUALITY_ARR[curQuality];
         switch(stage.quality)
         {
            case "HIGH":
               desc = Central.main.langLib.titleTxt(TitleData.QUALITYHIGH);
               break;
            case "BEST":
               desc = Central.main.langLib.titleTxt(TitleData.QUALITYBEST);
               break;
            case "LOW":
               desc = Central.main.langLib.titleTxt(TitleData.QUALITYLOW);
               break;
            case "MEDIUM":
               desc = Central.main.langLib.titleTxt(TitleData.QUALITYMEDIUM);
         }
         this["optionPanel"]["qualityTxt"].text = desc;
      }
      
      private function startDragVolume(evt:MouseEvent) : void
      {
         var bounds:Rectangle = null;
         bounds = new Rectangle(0,4,150 - this["optionPanel"]["musicControl"]["volume"]["slider"].width,0);
         this["optionPanel"]["musicControl"]["volume"]["slider"].startDrag(false,bounds);
         stage.addEventListener(MouseEvent.MOUSE_UP,this.mouseUp);
         this.addEventListener(Event.ENTER_FRAME,this.onChangeVolume);
      }
      
      private function stopDragVolume(evt:MouseEvent) : void
      {
         this["optionPanel"]["musicControl"]["volume"]["slider"].stopDrag();
         stage.removeEventListener(MouseEvent.MOUSE_UP,this.mouseUp);
         this.removeEventListener(Event.ENTER_FRAME,this.onChangeVolume);
      }
      
      public function mouseUp(evt:MouseEvent) : void
      {
         this["optionPanel"]["musicControl"]["volume"]["slider"].stopDrag();
         if(stage.hasEventListener(MouseEvent.MOUSE_UP))
         {
            stage.removeEventListener(MouseEvent.MOUSE_UP,this.mouseUp);
         }
         this.removeEventListener(Event.ENTER_FRAME,this.onChangeVolume);
      }
      
      private function onChangeVolume(evt:Event) : void
      {
         var slider:MovieClip = null;
         slider = this["optionPanel"]["musicControl"]["volume"]["slider"];
         switch(evt.currentTarget.name)
         {
            case "slider":
               break;
            case "btnMinus":
               slider.x -= 5;
               if(slider.x < 0)
               {
                  slider.x = 0;
               }
               break;
            case "btnAdd":
               slider.x += 5;
               if(slider.x > 150 - slider.width)
               {
                  slider.x = 150 - slider.width;
               }
         }
         this.changeVolume(slider.x / (this["optionPanel"]["musicControl"]["volume"].width - slider.width),evt);
      }
      
      private function changeVolume(_volume:Number, evt:Event) : void
      {
         Central.main.mixer.setVolume(_volume);
         if(evt.currentTarget.name == "btnMinus" || evt.currentTarget.name == "btnAdd" || evt.currentTarget.name == "btnToggleSound")
         {
            this["optionPanel"]["musicControl"]["volume"]["slider"].x = Central.main.mixer.getVolume() * (150 - this["optionPanel"]["musicControl"]["volume"]["slider"].width);
         }
         if(Central.main.mixer.getVolume() <= 0)
         {
            this["optionPanel"]["musicControl"]["btnToggleSound"]["txt"].text = Central.main.langLib.titleTxt(TitleData.OFF);
         }
         else
         {
            this["optionPanel"]["musicControl"]["btnToggleSound"]["txt"].text = Central.main.langLib.titleTxt(TitleData.ON);
         }
      }
      
      private function toggleSound(evt:MouseEvent) : void
      {
         if(Central.main.mixer.getVolume() > 0)
         {
            this.changeVolume(0,evt);
         }
         else
         {
            this.changeVolume(1,evt);
         }
      }
      
      private function toggleVolume(state:Boolean) : void
      {
         var soundTransform:SoundTransform = null;
         if(this["optionPanel"] != null)
         {
            if(state)
            {
               this["btnSoundOn"].visible = true;
               this["btnSoundOff"].visible = false;
               Central.main.initButton(this["btnSoundOn"],this.onMenuBtn,"");
               Central.main.disableButton(this["btnSoundOff"],this.onMenuBtn,"");
            }
            else
            {
               this["btnSoundOn"].visible = false;
               Central.main.disableButton(this["btnSoundOn"],this.onMenuBtn,"");
               this["btnSoundOff"].visible = true;
               Central.main.initButton(this["btnSoundOff"],this.onMenuBtn,"");
            }
            this.toggleAllSound(state);
         }
         else
         {
            soundTransform = SoundMixer.soundTransform;
            if(state)
            {
               soundTransform.volume = 1;
               this.isAllSoundOn = true;
               this["btnSoundOn"].visible = true;
               Central.main.initButton(this["btnSoundOn"],this.onMenuBtn,"");
               this["btnSoundOff"].visible = false;
               Central.main.disableButton(this["btnSoundOff"],this.onMenuBtn,"");
            }
            else
            {
               soundTransform.volume = 0;
               this.isAllSoundOn = false;
               this["btnSoundOn"].visible = false;
               Central.main.disableButton(this["btnSoundOn"],this.onMenuBtn,"");
               this["btnSoundOff"].visible = true;
               Central.main.initButton(this["btnSoundOff"],this.onMenuBtn,"");
            }
            SoundMixer.soundTransform = soundTransform;
         }
      }
      
      public function onMusic() : void
      {
         var mc:MovieClip = null;
         this.stop();
         mc = this["MusicPanel"];
         mc.gotoAndPlay("small");
      }
      
      public function initSmallMusicPanel() : void
      {
         var mc:MovieClip = null;
         mc = this["MusicPanel"]["smallMc"];
         mc["txtCurrentMusicName"].text = this.musicNameList[Central.main.currentMusicIndex];
         mc["barMusicVolumeBaseMask"].addEventListener(MouseEvent.MOUSE_DOWN,this.beginDragMusicVolume);
         mc["btnLoudest"].addEventListener(MouseEvent.CLICK,this.loudestSound);
         mc["btnMute"].addEventListener(MouseEvent.CLICK,this.muteSound);
         mc["btnNextMusic"].addEventListener(MouseEvent.CLICK,this.updateCurrentMusic);
         mc["btnPrevMusic"].addEventListener(MouseEvent.CLICK,this.updateCurrentMusic);
         mc["btnGotoLarge"].addEventListener(MouseEvent.CLICK,this.musicPlayerGotoHuge);
         mc["btnPlay"].addEventListener(MouseEvent.CLICK,this.stopAndPlayMusic);
         mc["btnPause"].addEventListener(MouseEvent.CLICK,this.stopAndPlayMusic);
         if(!Central.main.mixer.getMusic())
         {
            mc["btnPlay"].visible = true;
            mc["btnPause"].visible = false;
         }
         else
         {
            mc["btnPlay"].visible = false;
            mc["btnPause"].visible = true;
         }
         this.initMusicVolumeBar(mc);
      }
      
      public function initLargeMusicPanel() : void
      {
         var mc:MovieClip = null;
         mc = this["MusicPanel"]["largeMc"];
         mc["txtCurrentMusicName"].text = this.musicNameList[Central.main.currentMusicIndex];
         mc["barMusicVolumeBaseMask"].addEventListener(MouseEvent.MOUSE_DOWN,this.beginDragMusicVolume);
         mc["btnLoudest"].addEventListener(MouseEvent.CLICK,this.loudestSound);
         mc["btnMute"].addEventListener(MouseEvent.CLICK,this.muteSound);
         mc["btnNextMusic"].addEventListener(MouseEvent.CLICK,this.updateCurrentMusic);
         mc["btnPrevMusic"].addEventListener(MouseEvent.CLICK,this.updateCurrentMusic);
         mc["btnGotoSmall"].addEventListener(MouseEvent.CLICK,this.musicPlayerGotoMimi);
         mc["btnMainPause"].addEventListener(MouseEvent.CLICK,this.stopAndPlayMusic);
         mc["btnMainPlay"].addEventListener(MouseEvent.CLICK,this.stopAndPlayMusic);
         mc["btnPageUp"].addEventListener(MouseEvent.CLICK,this.onPageUp);
         mc["btnPageDown"].addEventListener(MouseEvent.CLICK,this.onPageDown);
         if(!Central.main.mixer.getMusic())
         {
            mc["btnMainPlay"].visible = true;
            mc["btnMainPause"].visible = false;
         }
         else
         {
            mc["btnMainPlay"].visible = false;
            mc["btnMainPause"].visible = true;
         }
         this.initMPClickMask(mc);
         this.initMusicVolumeBar(mc);
      }
      
      private function initMusicVolumeBar(_mc:MovieClip) : void
      {
         var mc:MovieClip = null;
         mc = _mc;
         mc["barMusicVolume"].width = mc["barMusicVolumeBase"].width * Central.main.mixer.getVolume();
      }
      
      private function muteSound(evt:MouseEvent) : void
      {
         Central.main.mixer.setVolume(0);
         switch(evt.currentTarget.parent.name)
         {
            case "smallMc":
               this.initSmallMusicPanel();
               break;
            case "largeMc":
               this.initLargeMusicPanel();
         }
      }
      
      private function loudestSound(evt:MouseEvent) : void
      {
         Central.main.mixer.setVolume(1);
         switch(evt.currentTarget.parent.name)
         {
            case "smallMc":
               this.initSmallMusicPanel();
               break;
            case "largeMc":
               this.initLargeMusicPanel();
         }
      }
      
      private function onPageDown(evt:MouseEvent) : void
      {
         if(this.topMusicIndex + this.SLOT_IN_MUSIC_PLAYER < Central.main.MUSIC_PLAY_LIST.length)
         {
            this.topMusicIndex += 1;
         }
         this.initMPClickMask(evt.currentTarget.parent);
      }
      
      private function onPageUp(evt:MouseEvent) : void
      {
         if(this.topMusicIndex > 0)
         {
            --this.topMusicIndex;
         }
         this.initMPClickMask(evt.currentTarget.parent);
      }
      
      private function initMPClickMask(_mc:MovieClip) : void
      {
         var i:int = 0;
         var time:Number = NaN;
         var min:* = undefined;
         var sec:String = null;
         var mc:MovieClip = null;
         mc = _mc;
         if(this.topMusicIndex + this.SLOT_IN_MUSIC_PLAYER < Central.main.MUSIC_PLAY_LIST.length)
         {
            mc["btnPageDown"].visible = true;
         }
         else
         {
            mc["btnPageDown"].visible = false;
         }
         if(this.topMusicIndex > 0)
         {
            mc["btnPageUp"].visible = true;
         }
         else
         {
            mc["btnPageUp"].visible = false;
         }
         for(i = 0; i < this.SLOT_IN_MUSIC_PLAYER; i++)
         {
            mc = _mc["musicSlot" + i];
            mc["selectMusicMc"].visible = false;
            mc.musicIndex = this.topMusicIndex + i;
            time = Math.round(Central.main.getMusicLength(Central.main.MUSIC_PLAY_LIST[mc.musicIndex]) * 0.001);
            min = String(Math.floor(time / 60));
            sec = String(Math.round(time % 60));
            if(sec.length < 2)
            {
               sec = "0" + sec;
            }
            mc["txtMusicTime"].text = min + ":" + sec;
            mc["txtMusicName"].text = this.musicNameList[this.topMusicIndex + i];
            mc["glowSelectedMusic"].visible = this.topMusicIndex + i == Central.main.currentMusicIndex ? true : false;
            mc.addEventListener(MouseEvent.MOUSE_OVER,this.musicSlotMouseOver);
            mc.addEventListener(MouseEvent.MOUSE_OUT,this.musicSlotMouseOut);
         }
      }
      
      private function musicSlotMouseOver(evt:MouseEvent) : void
      {
         var mc:MovieClip = null;
         mc = MovieClip(evt.currentTarget);
         mc["selectMusicMc"].visible = true;
         if(mc["glowSelectedMusic"].visible == true && Boolean(Central.main.mixer.getMusic()))
         {
            mc["selectMusicMc"]["btnPlay"].visible = false;
            mc["selectMusicMc"]["btnPause"].visible = true;
            mc["selectMusicMc"]["btnPlayNew"].visible = false;
            if(!mc["selectMusicMc"]["btnPause"].hasEventListener(MouseEvent.CLICK))
            {
               mc["selectMusicMc"]["btnPause"].addEventListener(MouseEvent.CLICK,this.stopAndPlayMusic);
            }
         }
         else if(mc["glowSelectedMusic"].visible == true)
         {
            mc["selectMusicMc"]["btnPlay"].visible = true;
            mc["selectMusicMc"]["btnPause"].visible = false;
            mc["selectMusicMc"]["btnPlayNew"].visible = false;
            if(!mc["selectMusicMc"]["btnPlay"].hasEventListener(MouseEvent.CLICK))
            {
               mc["selectMusicMc"]["btnPlay"].addEventListener(MouseEvent.CLICK,this.stopAndPlayMusic);
            }
         }
         else
         {
            mc["selectMusicMc"]["btnPlay"].visible = false;
            mc["selectMusicMc"]["btnPause"].visible = false;
            mc["selectMusicMc"]["btnPlayNew"].visible = true;
            if(!mc["selectMusicMc"]["btnPlayNew"].hasEventListener(MouseEvent.CLICK))
            {
               mc["selectMusicMc"]["btnPlayNew"].addEventListener(MouseEvent.CLICK,this.playNewMusicByMusicSlot);
            }
         }
      }
      
      private function musicSlotMouseOut(evt:MouseEvent) : void
      {
         var mc:MovieClip = null;
         mc = MovieClip(evt.currentTarget);
         mc["selectMusicMc"].visible = false;
      }
      
      private function playNewMusicByMusicSlot(evt:MouseEvent) : void
      {
         var currentSlotMusicIndex:int = 0;
         currentSlotMusicIndex = int(evt.currentTarget.parent.parent.musicIndex);
         Central.main.currentMusicIndex = currentSlotMusicIndex;
         if(!Central.main.mixer.getMusic())
         {
            Central.main.mixer.setMusic(true);
         }
         Central.main.updateMusic();
         this.initLargeMusicPanel();
      }
      
      private function resetSoundLoudness(evt:MouseEvent) : void
      {
         switch(evt.currentTarget.name)
         {
            case "btnLoudest":
               Central.main.mixer.setVolume(1);
               this.updateMusicVolumeBarBybuttonClick(evt.currentTarget.parent,1);
               break;
            case "btnMute":
               Central.main.mixer.setVolume(0);
               this.updateMusicVolumeBarBybuttonClick(evt.currentTarget.parent,0);
         }
      }
      
      private function stopAndPlayMusic(evt:MouseEvent = null) : void
      {
         Central.main.mixer.musicPlayerToggleMusic();
         if(evt)
         {
            switch(evt.currentTarget.parent.name)
            {
               case "smallMc":
                  this.initSmallMusicPanel();
                  break;
               case "largeMc":
               case "selectMusicMc":
                  this.initLargeMusicPanel();
            }
         }
      }
      
      private function updateCurrentMusic(evt:MouseEvent) : void
      {
         switch(evt.currentTarget.name)
         {
            case "btnNextMusic":
               if(Central.main.currentMusicIndex + 1 < Central.main.MUSIC_PLAY_LIST.length)
               {
                  Central.main.currentMusicIndex += 1;
                  Central.main.updateMusic();
                  this.updateMusicName(evt.currentTarget.parent);
               }
               break;
            case "btnPrevMusic":
               if(Central.main.currentMusicIndex - 1 >= 0)
               {
                  --Central.main.currentMusicIndex;
                  Central.main.updateMusic();
                  this.updateMusicName(evt.currentTarget.parent);
               }
         }
         switch(evt.currentTarget.parent.name)
         {
            case "smallMc":
               this.initSmallMusicPanel();
               break;
            case "largeMc":
               this.initLargeMusicPanel();
         }
      }
      
      private function updateMusicName(_mc:MovieClip = null) : void
      {
         if(_mc)
         {
            _mc["txtCurrentMusicName"].text = this.musicNameList[Central.main.currentMusicIndex];
         }
         else
         {
            this["txtCurrentMusicName"].text = this.musicNameList[Central.main.currentMusicIndex];
         }
      }
      
      private function updateMusicVolumeBarBybuttonClick(_mc:MovieClip, _volume:Number) : void
      {
         if(_volume == 0)
         {
            _mc["barMusicVolume"].width = 1;
         }
         else
         {
            _mc["barMusicVolume"].width = _mc["barMusicVolumeBase"].width;
         }
      }
      
      private function beginDragMusicVolume(evt:MouseEvent) : void
      {
         var mc:MovieClip = null;
         mc = MovieClip(evt.currentTarget.parent);
         this.updateMusicVolumeByDragVolumeBar(evt);
         stage.addEventListener(MouseEvent.MOUSE_UP,this.endDragMusicVolume);
         mc["barMusicVolumeBaseMask"].addEventListener(MouseEvent.MOUSE_MOVE,this.updateMusicVolumeByDragVolumeBar);
      }
      
      private function endDragMusicVolume(evt:MouseEvent) : void
      {
         var mc:MovieClip = MovieClip(evt.currentTarget.parent);
         if(stage.hasEventListener(MouseEvent.MOUSE_UP))
         {
            stage.removeEventListener(MouseEvent.MOUSE_UP,this.endDragMusicVolume);
         }
         if(this["MusicPanel"]["smallMc"])
         {
            if(this["MusicPanel"]["smallMc"]["barMusicVolumeBaseMask"].hasEventListener(MouseEvent.MOUSE_MOVE))
            {
               this["MusicPanel"]["smallMc"]["barMusicVolumeBaseMask"].removeEventListener(MouseEvent.MOUSE_MOVE,this.updateMusicVolumeByDragVolumeBar);
            }
         }
         else if(this["MusicPanel"]["largeMc"]["barMusicVolumeBaseMask"].hasEventListener(MouseEvent.MOUSE_MOVE))
         {
            this["MusicPanel"]["largeMc"]["barMusicVolumeBaseMask"].removeEventListener(MouseEvent.MOUSE_MOVE,this.updateMusicVolumeByDragVolumeBar);
         }
      }
      
      private function updateMusicVolumeByDragVolumeBar(evt:MouseEvent) : void
      {
         var mc:MovieClip = null;
         var volume:Number = NaN;
         var localx:int = 0;
         mc = MovieClip(evt.currentTarget.parent);
         localx = evt.localX;
         if(localx < 0)
         {
            localx = 0;
         }
         else if(localx > mc["barMusicVolumeBaseMask"].width)
         {
            localx = int(mc["barMusicVolumeBaseMask"].width);
         }
         mc["barMusicVolume"].width = localx;
         volume = mc["barMusicVolume"].width / mc["barMusicVolumeBaseMask"].width;
         if(volume < 0)
         {
            volume = 0;
         }
         else if(volume > 1)
         {
            volume = 1;
         }
         Central.main.mixer.setVolume(volume);
      }
      
      private function musicPlayerGotoHuge(evt:MouseEvent) : void
      {
         this.topMusicIndex = 0;
         this["MusicPanel"].gotoAndPlay("large");
      }
      
      private function musicPlayerGotoMimi(evt:MouseEvent) : void
      {
         this.topMusicIndex = 0;
         this["MusicPanel"].gotoAndPlay("small");
      }
      
      private function resetUploadSoundDataTimer() : void
      {
         if(this.uploadSoundDataTimer == null)
         {
            this.uploadSoundDataTimer = new Timer(5000);
            this.uploadSoundDataTimer.addEventListener(TimerEvent.TIMER,this.checkChangeOfSoundData);
            this.uploadSoundDataTimer.start();
         }
         else
         {
            this.uploadSoundDataTimer.reset();
            this.uploadSoundDataTimer.start();
         }
      }
      
      private function uploadSoundData(evt:TimerEvent = null) : void
      {
         Central.main.amfClient.service("OptionData.setOption",[Account.getAccountSessionKey(),Central.main.currentMusicIndex,Central.main.mixer.getVolume(),SoundMixer.soundTransform.volume],new Function());
      }
      
      private function checkChangeOfSoundData(evt:TimerEvent) : void
      {
         if(this.soundDataArr[0] != Central.main.currentMusicIndex || this.soundDataArr[1] != Central.main.mixer.getVolume() || this.soundDataArr[2] != SoundMixer.soundTransform.volume)
         {
            this.soundDataArr[0] = Central.main.currentMusicIndex;
            this.soundDataArr[1] = Central.main.mixer.getVolume();
            this.soundDataArr[2] = SoundMixer.soundTransform.volume;
            this.uploadSoundData();
         }
         if(!(this.currentLabel == "option" || this.currentLabel == "music"))
         {
            this.uploadSoundDataTimer.stop();
            this.uploadSoundDataTimer.removeEventListener(TimerEvent.TIMER,this.checkChangeOfSoundData);
            this.uploadSoundDataTimer = null;
         }
      }
      
      public function showChatInput() : void
      {
         if(this["chatInputMc"])
         {
            this["chatInputMc"].gotoAndStop(Timeline.SHOW);
         }
      }
      
      public function hideChatInput() : void
      {
         if(this["chatInputMc"]["inputTxt"])
         {
            this["chatInputMc"]["inputTxt"].removeEventListener(KeyboardEvent.KEY_UP,this.chatInputHandler);
            this["chatInputMc"].gotoAndStop(Timeline.IDLE);
         }
      }
      
      public function initChatInput() : void
      {
         if(this["chatInputMc"]["inputTxt"])
         {
            this["chatInputMc"]["inputTxt"].addEventListener(KeyboardEvent.KEY_UP,this.chatInputHandler);
         }
      }
      
      private function chatInputHandler(evt:KeyboardEvent) : void
      {
         var input:String = null;
         var command:Array = null;
         var i:uint = 0;
         var commandData:Object = null;
         var enemyArr:Array = null;
         var enemyIDs:String = null;
         var str:String = null;
         var mainChar:* = undefined;
         var buff:Object = null;
         var enemy:* = undefined;
         if(KeyboardEvent(evt).keyCode == Keyboard.ENTER)
         {
            input = this["chatInputMc"]["inputTxt"].text;
            if(input.substr(0,1) == "#")
            {
               command = input.split("#");
               commandData = {};
               if(command.length == 4)
               {
                  switch(command[1])
                  {
                     case "show":
                        if(command[2] == "ids")
                        {
                           enemyArr = Central.battle.getEnemyArr();
                           if(enemyArr == null)
                           {
                              return;
                           }
                           enemyIDs = "";
                           for(i = 0; i < enemyArr.length; i++)
                           {
                              enemyIDs += ">> " + String(enemyArr[i].getData(DBCharacterData.NAME)) + " :: " + String(enemyArr[i].getData(DBCharacterData.ID)) + "<br>";
                           }
                           commandData = {};
                           commandData.user_message = ">> " + String(Central.main.getMainChar().getData(DBCharacterData.NAME)) + " :: " + Central.main.getMainChar().getData(DBCharacterData.ID) + "<br>" + enemyIDs;
                           Central.battle.onIncomingRoomMessage(commandData.user_message);
                        }
                        break;
                     case "debug":
                        if(command[2] == "data")
                        {
                           str = "";
                           mainChar = Central.main.getMainChar();
                           str += "My Character >> " + mainChar.getCharacterName() + " :: ID >> " + mainChar.getCharacterId() + " :: HP >> " + mainChar.hp + "<br>";
                           buff = mainChar.getBattleBuff();
                           if(buff)
                           {
                              str += GF.objectToString(buff) + "<br>";
                           }
                           enemy = Central.battle.getEnemyArr()[0];
                           str += "Enemy >> " + enemy.getCharacterName() + " :: ID >> " + enemy.getCharacterId() + " :: HP >> " + enemy.hp + "<br>";
                           buff = enemy.getBattleBuff();
                           if(buff)
                           {
                              str += GF.objectToString(buff) + "<br>";
                           }
                           commandData = {};
                           commandData.user_message = str;
                           Central.battle.onIncomingRoomMessage(commandData.user_message);
                        }
                  }
               }
               this["chatInputMc"]["inputTxt"].text = "";
               return;
            }
            input = Central.main.verifyChatInput(input);
            if(input.length > 0)
            {
               Central.main.socket.sendBattleMessage(input);
               this["chatInputMc"]["inputTxt"].text = "";
            }
         }
      }
      
      public function displayStatus(str:String) : void
      {
         this["statusTxt"].text = str;
      }
      
      private function refreshPetSkill() : void
      {
         var panel:MovieClip = null;
         var pet:* = undefined;
         var petSkillData:Array = null;
         var petSkills:Array = null;
         var i:uint = 0;
         var skillMc:MovieClip = null;
         panel = this["pet"];
         pet = Central.main.getMainChar().getPetById(this.selectedPetID);
         if(pet)
         {
            petSkillData = pet.skillData;
            petSkills = pet.getData(DBCharacterData.SKILLS);
            this.Public_petSkillData = petSkillData;
            for(i = 1; i <= 6; i++)
            {
               skillMc = panel["skill_" + String(i)];
               GF.removeAllChild(skillMc["holder"]);
               skillMc.gotoAndStop(1);
               panel["skill_" + String(i)].filters = null;
               skillMc.removeEventListener(MouseEvent.CLICK,this.trainPetSkill);
               Central.main.hideDynamicTooltip(skillMc);
               skillMc.buttonMode = false;
               skillMc["trainTxt"].text = "";
               panel["skill_" + String(i) + "_lvTxt"].text = "";
            }
            for(i = 0; i < petSkillData.length; i++)
            {
               skillMc = panel["skill_" + String(i + 1)];
               panel["skill_" + String(i + 1) + "_lvTxt"].text = Central.main.langLib.titleTxt(TitleData.LV) + " " + String(petSkillData[i].level);
               if(pet.getLevel() >= int(petSkillData[i].level))
               {
                  skillMc["holder"].addChild(pet.getSkillIcon(i));
                  skillMc.gotoAndStop("enable");
                  if(petSkills.indexOf(petSkillData[i].id) >= 0)
                  {
                     panel["skill_" + String(i + 1)].filters = null;
                     Central.main.showDynamicTooltip(skillMc,String("<font size=\'16\'>" + this.Public_petSkillData[i].description.replace("undefined") + "</font>"));
                  }
                  else
                  {
                     panel["skill_" + String(i + 1)].filters = [this.disableFilter];
                     panel["skill_" + String(i + 1)]["trainTxt"].text = Central.main.langLib.get(273);
                     panel["skill_" + String(i + 1)].skillId = petSkillData[i].id;
                     panel["skill_" + String(i + 1)].addEventListener(MouseEvent.CLICK,this.trainPetSkill);
                     panel["skill_" + String(i + 1)].buttonMode = true;
                     Central.main.showDynamicTooltip(skillMc,String("<font size=\'16\'>" + this.Public_petSkillData[i].description.replace("undefined") + "</font>"));
                  }
               }
               else
               {
                  panel["skill_" + String(i + 1)].gotoAndStop("unknown");
               }
            }
         }
      }
      
      private function trainPetSkill(evt:MouseEvent) : void
      {
         var Name:String = null;
         var no:int = 0;
         var pet:* = undefined;
         var petObj:Object = null;
         var panel:MovieClip = null;
         if(this.connectingAmf)
         {
            return;
         }
         this.handlingSkillId = MovieClip(evt.currentTarget).skillId as int;
         Name = evt.currentTarget.name;
         Name = Name.replace("skill_","");
         no = int(Name) - 1;
         pet = Central.main.getMainChar().getPetById(this.selectedPetID);
         petObj = Central.main.PET_DATA.find("pet" + String(pet.id));
         this.PetTraingold = petObj.trainskill_gold[no];
         this.PetTrainToken = petObj.trainskill_token[no];
         this.PetTrainmagatamaData = petObj.trainskill_magatama[no];
         this.PetTrainmaterialData = petObj.trainskill_material[no];
         panel = this["pet"];
         panel["confirmTrainPetSkillMc"].gotoAndPlay("show");
      }
      
      public function onShowConfirmation() : void
      {
         var panel:MovieClip = null;
         var invMaterial:Object = null;
         panel = this["pet"]["confirmTrainPetSkillMc"];
         panel["lbl_confirmation"].text = Central.main.langLib.get(860);
         panel["noBtn"].addEventListener(MouseEvent.CLICK,this.hideConfirmationBox);
         this.updateMaterialCount();
         invMaterial = {
            "item634":this.PetTrainmaterial634,
            "item635":this.PetTrainmaterial635
         };
         panel["yourMaterialMc"]["level_1"].text = invMaterial.item634;
         panel["yourMaterialMc"]["level_2"].text = invMaterial.item635;
         if(Central.main.Features.FEATURE_PET_LEARN_SKILL_BY_TOKEN)
         {
            panel["trainMethodMC"].gotoAndStop("noMagatama");
         }
         else
         {
            panel["trainMethodMC"].gotoAndStop("noToken");
         }
      }
      
      private function updateMaterialCount() : void
      {
         var arr:Array = null;
         var i:int = 0;
         arr = Central.main.getMainChar().getInventory(InventoryData.TYPE_MATERIAL);
         this.PetTrainmaterial634 = 0;
         this.PetTrainmaterial635 = 0;
         for(i = 0; i < arr.length; i++)
         {
            if(arr[i] == "item634")
            {
               ++this.PetTrainmaterial634;
            }
            if(arr[i] == "item635")
            {
               ++this.PetTrainmaterial635;
            }
         }
      }
      
      public function onShowTokenGoldPay() : void
      {
         var panel:MovieClip = null;
         panel = this["pet"]["confirmTrainPetSkillMc"]["trainMethodMC"];
         panel["lbl_cost"].text = Central.main.langLib.titleTxt(TitleData.COST);
         panel["lbl_or1"].text = Central.main.langLib.get(1650)[26];
         panel["materialMc"]["goldTxt"].text = this.PetTraingold;
         Central.main.initButton(panel["materialMc"]["okBtn"],this.confirmTrainPetSkill,ButtonData.LEARN);
         panel["materialMc"]["okBtn"].learnType = "material";
         if(this.PetTrainmaterialData)
         {
            panel["materialMc"]["materialMc"]["level_1"].text = this.PetTrainmaterialData.item634;
            panel["materialMc"]["materialMc"]["level_2"].text = this.PetTrainmaterialData.item635;
         }
         if(Central.main.Features.FEATURE_PET_LEARN_SKILL_BY_TOKEN)
         {
            panel["tokenMc"]["tokenTxt"].text = this.PetTrainToken;
            Central.main.initButton(panel["tokenMc"]["okBtn"],this.confirmTrainPetSkill,ButtonData.LEARN);
            panel["tokenMc"]["okBtn"].learnType = "token";
         }
      }
      
      private function hideConfirmationBox(evt:MouseEvent) : void
      {
         var panel:MovieClip = null;
         panel = this["pet"]["confirmTrainPetSkillMc"];
         panel.gotoAndStop("idle");
      }
      
      private function confirmTrainPetSkill(evt:MouseEvent) : void
      {
         var mc:MovieClip = null;
         var count:int = 0;
         var petGold:int = 0;
         var magatamaData:Object = null;
         var invMgt:Object = null;
         var key2:String = null;
         var key:String = null;
         var materialData:Object = null;
         var invMaterial:Object = null;
         var key4:String = null;
         mc = MovieClip(evt.currentTarget);
         if(this.connectingAmf)
         {
            return;
         }
         count = 0;
         if(mc.learnType == "gold")
         {
            this.learn_Type = "mgt";
            petGold = int(this.PetTraingold);
            if(!Central.main.getMainChar().hasEnoughGold(petGold))
            {
               Central.main.showInfo(String(Central.main.langLib.get(275)).replace("[valpetgold]",petGold.toString()));
               return;
            }
            magatamaData = this.PetTrainmagatamaData;
            invMgt = Central.main.getMainChar().getInventory(InventoryData.TYPE_MAGATAMA);
            count = 0;
            for(key2 in magatamaData)
            {
               if(magatamaData[int(key2)] > 0)
               {
                  count++;
               }
            }
            if(invMgt)
            {
               for(key in magatamaData)
               {
                  if(magatamaData[key] > 0)
                  {
                     if(!invMgt[int(key)])
                     {
                        Central.main.showOk(Central.main.langLib.get(861),new Function());
                        return;
                     }
                     if(invMgt[int(key)] < magatamaData[int(key)])
                     {
                        Central.main.showOk(Central.main.langLib.get(861),new Function());
                        return;
                     }
                  }
               }
            }
            else if(count > 0)
            {
               Central.main.showOk(Central.main.langLib.get(861),new Function());
               return;
            }
         }
         else if(mc.learnType == "token")
         {
            this.learn_Type = "token";
            if(Central.main.account.getAccountBalance() < this.PetTrainToken)
            {
               Central.main.getGoldToken(Central.main.langLib.get(1405),Central.main.gotoPaymentGateway,"token");
               return;
            }
         }
         else if(mc.learnType == "material")
         {
            this.learn_Type = "material";
            if(!Central.main.getMainChar().hasEnoughGold(int(this.PetTraingold)))
            {
               Central.main.showInfo(String(Central.main.langLib.get(275)).replace("[valpetgold]",this.PetTraingold.toString()));
               return;
            }
            materialData = this.PetTrainmaterialData;
            invMaterial = {
               "item634":this.PetTrainmaterial634,
               "item635":this.PetTrainmaterial635
            };
            if(invMaterial)
            {
               for(key4 in materialData)
               {
                  if(materialData[key4] > invMaterial[key4])
                  {
                     Central.main.showOk(Central.main.langLib.get(1667)[0],new Function());
                     return;
                  }
               }
            }
         }
         this.connectingAmf = true;
         Central.main.showAmfLoading();
         Central.main.amfClient.service("CharacterDAO.trainPetSkill",[Account.getAccountSessionKey(),this.selectedPetID,this.handlingSkillId,this.learn_Type],this.trainPetSkillResult);
      }
      
      private function trainPetSkillResult(result:Object) : void
      {
         var petSkills:Array = null;
         var pet:* = undefined;
         var i:* = undefined;
         var j:int = 0;
         var panel:MovieClip = null;
         var mgtStr:String = null;
         var magatamaData:Object = null;
         var magatamaArr:Array = null;
         var magatamaTemp:Array = null;
         var materialData:Object = null;
         var key:String = null;
         if(Central.main.validateAmfResponse(result))
         {
            petSkills = result.result as Array;
            pet = Central.main.getMainChar().getPetById(this.selectedPetID);
            pet.updateData(DBCharacterData.SKILLS,petSkills);
            pet.setupAvailableSkills();
            this.refreshPetSkill();
            if(this.learn_Type == "mgt")
            {
               Central.main.getMainChar().updateGold(0 - int(this.PetTraingold));
               mgtStr = result.mgt_str;
               magatamaData = {};
               magatamaArr = String(mgtStr).split(",");
               for(i = 0; i < magatamaArr.length; i++)
               {
                  magatamaTemp = String(magatamaArr[i]).split(":");
                  magatamaData[int(magatamaTemp[0])] = int(magatamaTemp[1]);
               }
               Central.main.getMainChar().setInventory(InventoryData.TYPE_MAGATAMA,magatamaData);
            }
            else if(this.learn_Type == "token")
            {
               Central.main.account.balance = Central.main.account.getAccountBalance() - this.PetTrainToken;
            }
            else if(this.learn_Type == "material")
            {
               Central.main.getMainChar().updateGold(0 - int(this.PetTraingold));
               materialData = this.PetTrainmaterialData;
               for(key in materialData)
               {
                  for(j = 0; j < int(materialData[key]); j++)
                  {
                     Central.main.getMainChar().removeInventory(InventoryData.TYPE_MATERIAL,key);
                  }
               }
            }
            Central.main.updateMenu();
            Central.main.hideAmfLoading();
            this.connectingAmf = false;
            Central.main.showInfo(pet.getCharacterName() + " " + Central.main.langLib.get(276));
            panel = this["pet"]["confirmTrainPetSkillMc"];
            panel.gotoAndStop("idle");
         }
      }
      
      private function deletePet(evt:MouseEvent) : void
      {
         var lockPetArr:Array = null;
         var pet:* = undefined;
         var petObj:Object = null;
         if(this.connectingAmf)
         {
            return;
         }
         lockPetArr = [];
         pet = Central.main.getMainChar().getPetById(this.selectedPetID);
         petObj = Central.main.PET_DATA.find("pet" + String(pet.id));
         if(lockPetArr.indexOf(pet.id) >= 0)
         {
            Central.main.showOk(String(Central.main.langLib.get(1649)[66]).replace("[valname]",petObj.name));
            return;
         }
         if(Central.main.getMainChar().getPetById(this.selectedPetID).training != null)
         {
            Central.main.showOk(String(Central.main.langLib.get(1649)[67]).replace("[valname]",petObj.name));
            return;
         }
         this.log_A = "1";
         Central.main.showDeleteConfirmation(Central.main.langLib.get(277),Delegate.create(this,this.confirmDeletePetPromptSecurity),new Function());
      }
      
      private function confirmDeletePetPromptSecurity() : void
      {
         if(Central.main.accRegActiveStatus == Central.main.ACC_REG_ACTIVE_STATUS_ACTIVE)
         {
            Central.main.showSecurityPasswordConfirmation(Central.main.langLib.get(1814),this.confirmDeletePet,this.hideDeletePetPanel,true);
         }
         else
         {
            Central.main.showSecurityPasswordSignupInvitation(Central.main.langLib.get(1812),this.confirmDeletePet,this.hideDeletePetPanel,true,true);
         }
      }
      
      private function hideDeletePetPanel() : void
      {
         this.hide();
         this.disable();
         this.enable();
      }
      
      private function confirmDeletePet(hashedPassword:String = "") : void
      {
         if(this.connectingAmf)
         {
            return;
         }
         this.connectingAmf = true;
         this.log_B = "1";
         Central.main.showAmfLoading();
         Central.main.amfClient.service("CharacterDAO.deletePet",[Account.getAccountSessionKey(),hashedPassword,this.selectedPetID,String(this.log_A + this.log_B),Central.main.getHash(String(this.log_A + this.log_B))],this.deletePetResult);
      }
      
      private function deletePetResult(result:Object) : void
      {
         if(String(result.status) == AMFData.STATUS_ERROR)
         {
            Central.main.onError(String(result.error));
            return;
         }
         if(result.msg)
         {
            switch(result.msg)
            {
               case "wrong_password":
                  Central.main.showInfo(Central.main.langLib.get(1823));
                  this.hide();
                  this.disable();
                  this.enable();
                  Central.main.hideAmfLoading();
                  this.connectingAmf = false;
                  return;
               case "not_registered":
                  Central.main.showInfo("Not Registered");
                  this.hide();
                  this.disable();
                  this.enable();
                  Central.main.hideAmfLoading();
                  this.connectingAmf = false;
                  return;
            }
         }
         Central.main.getMainChar().removePet(this.selectedPetID);
         this.hide();
         this.disable();
         this.enable();
         Central.main.hideAmfLoading();
         this.connectingAmf = false;
      }
      
      private function activatePet(evt:MouseEvent) : void
      {
         var pet:* = undefined;
         if(this.connectingAmf)
         {
            return;
         }
         if(Central.main.getMainChar().getPetById(this.selectedPetID).training != null)
         {
            pet = Central.main.getMainChar().getPetById(this.selectedPetID);
            Central.main.showOk(String(Central.main.langLib.get(1649)[68]).replace("[valname]",pet.getCharacterName()));
            return;
         }
         this.connectingAmf = true;
         Central.main.showAmfLoading();
         Central.main.amfClient.service("CharacterDAO.activatePet",[Account.getAccountSessionKey(),this.selectedPetID],this.activatePetResult);
      }
      
      private function activatePetResult(result:Object) : void
      {
         if(String(result.status) == AMFData.STATUS_ERROR)
         {
            Central.main.onError(String(result.error));
            return;
         }
         Central.main.getMainChar().activatePet(this.selectedPetID);
         this.petArray = Central.main.getMainChar().pets;
         this.showPetDetails();
         Central.main.hideAmfLoading();
         this.connectingAmf = false;
      }
      
      private function deactivatePet(evt:MouseEvent) : void
      {
         if(this.connectingAmf)
         {
            return;
         }
         this.connectingAmf = true;
         Central.main.showAmfLoading();
         Central.main.amfClient.service("CharacterDAO.deactivatePet",[Account.getAccountSessionKey(),this.selectedPetID],this.deactivatePetResult);
      }
      
      private function deactivatePetResult(result:Object) : void
      {
         if(String(result.status) == AMFData.STATUS_ERROR)
         {
            Central.main.onError(String(result.error));
            return;
         }
         Central.main.getMainChar().deactivatePet();
         this.petArray = Central.main.getMainChar().pets;
         this.showPetDetails();
         Central.main.hideAmfLoading();
         this.connectingAmf = false;
      }
      
      private function ActiveWeaponBonus(type:String) : Number
      {
         var i:int = 0;
         var criticalBonus:Number = NaN;
         var dodgeBonus:Number = NaN;
         var tmpEffect:Object = null;
         var equipedWeapon:Object = null;
         var equipedAccessory:Object = null;
         var gearObj:Object = null;
         var equipedGearSet:Object = null;
         var setEffect:Object = null;
         var equipedBackItem:Object = null;
         if(type == "" || type == null)
         {
            return 0;
         }
         criticalBonus = 0;
         dodgeBonus = 0;
         if(Central.main.getMainChar().getWeapon())
         {
            equipedWeapon = Central.main.WEAPON_DATA.find(Central.main.getMainChar().getWeapon());
            if(equipedWeapon)
            {
               for each(tmpEffect in equipedWeapon.effect)
               {
                  switch(tmpEffect.type)
                  {
                     case BattleData.EFFECT_ADD_CRITICAL_CHANCE:
                        criticalBonus += tmpEffect.amount;
                        break;
                     case BattleData.EFFECT_ADD_DODGE_BONUS:
                     case BattleData.EFFECT_ADD_DODGE_RANDOM:
                        dodgeBonus += tmpEffect.amount;
                  }
               }
            }
         }
         if(Central.main.getMainChar().getAccessory())
         {
            equipedAccessory = Central.main.ACCESSORY_DATA.find(Central.main.getMainChar().getAccessory());
            if(equipedAccessory)
            {
               for each(tmpEffect in equipedAccessory.effect)
               {
                  trace(tmpEffect.type);
                  switch(tmpEffect.type)
                  {
                     case BattleData.EFFECT_ADD_CRITICAL_CHANCE:
                        criticalBonus += tmpEffect.amount;
                        break;
                     case BattleData.EFFECT_ADD_DODGE_BONUS:
                     case BattleData.EFFECT_ADD_DODGE_RANDOM:
                        dodgeBonus += tmpEffect.amount;
                  }
               }
            }
         }
         if(Central.main.getMainChar().getGearset())
         {
            gearObj = Central.main.getMainChar().getGearset();
            for(tmpEffect in gearObj)
            {
               trace("tmpEffect " + tmpEffect);
               if(gearObj[tmpEffect])
               {
                  equipedGearSet = Central.main.GEAR_SET_DATA.find(tmpEffect);
               }
               trace("equipedGearSet " + GF.printObject(equipedGearSet));
               for(i = 0; i < gearObj[tmpEffect] - 1; i++)
               {
                  trace("i = " + i);
                  setEffect = equipedGearSet.effect[i];
                  trace("setEffect = " + GF.printObject(setEffect));
                  if(!setEffect)
                  {
                     continue;
                  }
                  switch(setEffect.type)
                  {
                     case BattleData.EFFECT_ADD_CRITICAL_CHANCE:
                        criticalBonus += setEffect.amount;
                        break;
                     case BattleData.EFFECT_ADD_DODGE_RANDOM:
                        dodgeBonus += setEffect.amount;
                  }
               }
            }
         }
         if(Central.main.getMainChar().getBackItem())
         {
            equipedBackItem = Central.main.BACK_ITEM_DATA.find(Central.main.getMainChar().getBackItem());
            if(equipedBackItem)
            {
               for each(tmpEffect in equipedBackItem.effect)
               {
                  switch(tmpEffect.type)
                  {
                     case BattleData.EFFECT_ADD_CRITICAL_CHANCE:
                        criticalBonus += tmpEffect.amount;
                        break;
                     case BattleData.EFFECT_ADD_DODGE_BONUS:
                     case BattleData.EFFECT_ADD_DODGE_RANDOM:
                        dodgeBonus += tmpEffect.amount;
                  }
               }
            }
         }
         if(type == "CRITICAL")
         {
            return criticalBonus;
         }
         if(type == "DODGE")
         {
            return dodgeBonus;
         }
         return 0;
      }
      
      public function disableGearBtn() : void
      {
         this["btnEquipment"].enabled = false;
         this["btnEquipment"].filters = [this.disableFilter];
         this.disableButton(this["btnEquipment"],this.onMenuBtn,ButtonData.GEAR);
      }
      
      public function enableGearBtn() : void
      {
         this["btnEquipment"].enabled = true;
         this["btnEquipment"].filters = null;
         Central.main.initButton(this["btnEquipment"],this.onMenuBtn,ButtonData.GEAR);
      }
      
      public function enableMRelate() : void
      {
         this["MCoin_Icon"].visible = true;
         this["MtokenTxt"].visible = true;
         this["getMoreMBtn"].visible = true;
         this["MCoin_bg"].visible = true;
      }
      
      public function disableMRelate() : void
      {
         this["MCoin_Icon"].visible = false;
         this["MtokenTxt"].visible = false;
         this["getMoreMBtn"].visible = false;
         this["MCoin_bg"].visible = false;
      }
      
      private function buyInvAmount(response:Object) : void
      {
         var invArrCapital:Array = null;
         var petPanel:MovieClip = null;
         var invPanel:MovieClip = null;
         if(this.invName == "pet")
         {
            petPanel = this["pet"];
            if(Central.main.validateAmfResponse(response))
            {
               if(petPanel == null)
               {
                  return;
               }
               if(this.invBtnName == "")
               {
                  this.invBtnName = this.BTN_PET;
               }
               this.curEquipmentType = this.invBtnName;
               invArrCapital = Central.main.getMainChar().getInventory(InventoryData.TYPE_PET);
               if(Account.getAccountType() == Account.PREMIUM)
               {
                  Data.INV_SPACE_PET_PREMIUM += this.inv_addTime * Data.INV_SPACE_PET_PREMIUM_ADD;
                  Data.INV_SPACE_PET_PREMIUM_CURNUM += this.inv_addTime;
               }
               else
               {
                  Data.INV_SPACE_PET_FREE += this.inv_addTime * Data.INV_SPACE_PET_FREE_ADD;
                  Data.INV_SPACE_PET_FREE_CURNUM += this.inv_addTime;
               }
               Central.main.hideAmfLoading();
            }
            if(Account.getAccountType() == Account.PREMIUM)
            {
               Account.balance = Account.getAccountBalance() - this.inv_addTime * 75;
            }
            else
            {
               Account.balance = Account.getAccountBalance() - this.inv_addTime * 100;
            }
            this.updateInvBar(petPanel,this.curEquipmentType,invArrCapital.length);
            this.updateTokenDisplay();
            petPanel.parent["inv_capacity"].gotoAndStop(Timeline.IDLE);
         }
         else
         {
            invPanel = this["equipmentPanel"];
            if(Central.main.validateAmfResponse(response))
            {
               if(invPanel == null)
               {
                  return;
               }
               if(this.invBtnName == "")
               {
                  this.invBtnName = this.BTN_WEAPON;
               }
               this.curEquipmentType = this.invBtnName;
               switch(this.curEquipmentType)
               {
                  case this.BTN_WEAPON:
                     invArrCapital = Central.main.getMainChar().getInventory(InventoryData.TYPE_WEAPON);
                     Data.INV_SPACE_WEAPON += this.inv_addTime * Data.INV_SPACE_WEAPON_ADD;
                     if(Account.getAccountType() == Account.PREMIUM)
                     {
                        Data.INV_SPACE_WEAPON_PREMIUM_CURNUM += this.inv_addTime;
                     }
                     else
                     {
                        Data.INV_SPACE_WEAPON_FREE_CURNUM += this.inv_addTime;
                     }
                     break;
                  case this.BTN_CLOTHING:
                     invArrCapital = Central.main.getMainChar().getInventory(InventoryData.TYPE_BODY_SET);
                     Data.INV_SPACE_BODYSET += this.inv_addTime * Data.INV_SPACE_BODYSET_ADD;
                     if(Account.getAccountType() == Account.PREMIUM)
                     {
                        Data.INV_SPACE_BODYSET_PREMIUM_CURNUM += this.inv_addTime;
                     }
                     else
                     {
                        Data.INV_SPACE_BODYSET_FREE_CURNUM += this.inv_addTime;
                     }
                     break;
                  case this.BTN_BACKITEM:
                     invArrCapital = Central.main.getMainChar().getInventory(InventoryData.TYPE_BACK_ITEM);
                     Data.INV_SPACE_BACKITEM += this.inv_addTime * Data.INV_SPACE_BACKITEM_ADD;
                     if(Account.getAccountType() == Account.PREMIUM)
                     {
                        Data.INV_SPACE_BACKITEM_PREMIUM_CURNUM += this.inv_addTime;
                     }
                     else
                     {
                        Data.INV_SPACE_BACKITEM_FREE_CURNUM += this.inv_addTime;
                     }
                     break;
                  case this.BTN_ACCESSORY:
                     invArrCapital = Central.main.getMainChar().getInventory(InventoryData.TYPE_ACCESSORY);
                     Data.INV_SPACE_ACCESSORY += this.inv_addTime * Data.INV_SPACE_ACCESSORY_ADD;
                     if(Account.getAccountType() == Account.PREMIUM)
                     {
                        Data.INV_SPACE_ACCESSORY_PREMIUM_CURNUM += this.inv_addTime;
                     }
                     else
                     {
                        Data.INV_SPACE_ACCESSORY_FREE_CURNUM += this.inv_addTime;
                     }
                     break;
                  case this.BTN_ITEM:
                     invArrCapital = Central.main.getMainChar().getInventory(InventoryData.TYPE_ITEM);
                     if(Account.getAccountType() == Account.PREMIUM)
                     {
                        Data.INV_SPACE_PREMIUM += this.inv_addTime * Data.INV_SPACE_PREMIUM_ADD;
                        Data.INV_SPACE_PREMIUM_CURNUM += this.inv_addTime;
                     }
                     else
                     {
                        Data.INV_SPACE_FREE += this.inv_addTime * Data.INV_SPACE_FREE_ADD;
                        Data.INV_SPACE_FREE_CURNUM += this.inv_addTime;
                     }
                     break;
                  case this.BTN_ESSENCE:
                     invArrCapital = Central.main.getMainChar().getInventory(InventoryData.TYPE_ESSENCE);
                     Data.INV_SPACE_ESSENCE += this.inv_addTime * Data.INV_SPACE_ESSENCE_ADD;
                     if(Account.getAccountType() == Account.PREMIUM)
                     {
                        Data.INV_SPACE_ESSENCE_PREMIUM_CURNUM += this.inv_addTime;
                     }
                     else
                     {
                        Data.INV_SPACE_ESSENCE_PREMIUM_CURNUM += this.inv_addTime;
                     }
                     break;
                  case this.BTN_MATERIAL:
                     invArrCapital = Central.main.getMainChar().getInventory(InventoryData.TYPE_MATERIAL);
                     if(Account.getAccountType() == Account.PREMIUM)
                     {
                        Data.INV_SPACE_MATERIAL_PREMIUM += this.inv_addTime * Data.INV_SPACE_MATERIAL_PREMIUM_ADD;
                        Data.INV_SPACE_MATERIAL_PREMIUM_CURNUM += this.inv_addTime;
                     }
                     else
                     {
                        Data.INV_SPACE_MATERIAL_FREE += this.inv_addTime * Data.INV_SPACE_MATERIAL_FREE_ADD;
                        Data.INV_SPACE_MATERIAL_FREE_CURNUM += this.inv_addTime;
                     }
               }
               Central.main.hideAmfLoading();
            }
            if(Account.getAccountType() == Account.PREMIUM)
            {
               Account.balance = Account.getAccountBalance() - this.inv_addTime * 75;
            }
            else
            {
               Account.balance = Account.getAccountBalance() - this.inv_addTime * 100;
            }
            this.updateInvBar(invPanel,this.curEquipmentType,invArrCapital.length);
            this.updateTokenDisplay();
            invPanel.parent["inv_capacity"].gotoAndStop(Timeline.IDLE);
         }
      }
      
      private function updateInvBar(mc:MovieClip, curItemType:String, charInv:int) : void
      {
         var _inv:int = 0;
         var max_inv:int = 0;
         var max_bar1:int = 0;
         var max_bar2:int = 0;
         _inv = charInv;
         mc["invBarMc"]["invMax"].text = "";
         mc["invBarMc"]["timebarMC"].visible = false;
         mc["invBarMc"]["timebarMC2"].visible = false;
         mc["invBarMc"]["timebarMC3"].visible = false;
         mc["invBarMc"]["invTitle"].text = Central.main.langLib.get(1576) + ":";
         mc["invBarMc"]["gearIcon"].gotoAndStop(curItemType);
         if(curItemType == this.BTN_PET)
         {
            if(Account.getAccountType() == Account.PREMIUM)
            {
               max_inv = int(Data.INV_SPACE_PET_PREMIUM);
               max_bar1 = max_inv / 3;
               max_bar2 = max_inv - max_bar1;
            }
            else
            {
               max_inv = int(Data.INV_SPACE_PET_FREE);
               max_bar1 = max_inv / 3;
               max_bar2 = max_inv - max_bar1;
            }
            mc["invBarMc"]["invTxt"].text = _inv + "/" + max_inv;
            if(_inv <= max_bar1)
            {
               mc["invBarMc"]["timebarMC"].visible = true;
               mc["invBarMc"]["timebarMC"].scaleX = _inv / max_inv;
            }
            else if(_inv <= max_bar2)
            {
               mc["invBarMc"]["timebarMC2"].visible = true;
               mc["invBarMc"]["timebarMC2"].scaleX = _inv / max_inv;
            }
            else
            {
               mc["invBarMc"]["timebarMC3"].visible = true;
               mc["invBarMc"]["timebarMC3"].scaleX = _inv / max_inv;
            }
            if(_inv >= max_inv)
            {
               mc["invBarMc"]["invMax"].text = Central.main.langLib.get(1577);
            }
            mc["AddPetInvBtn"].filters = null;
            mc["AddPetInvBtn"].visible = true;
            Central.main.initButton(mc["AddPetInvBtn"],this.invPopupCapacity,this.invTxtArr[11]);
         }
         else
         {
            max_inv = 200;
            switch(curItemType)
            {
               case this.BTN_WEAPON:
                  _inv += 1;
                  max_inv = int(Data.INV_SPACE_WEAPON);
                  max_bar1 = max_inv / 3;
                  max_bar2 = max_inv - max_bar1;
                  break;
               case this.BTN_CLOTHING:
                  _inv += 1;
                  max_inv = int(Data.INV_SPACE_BODYSET);
                  max_bar1 = max_inv / 3;
                  max_bar2 = max_inv - max_bar1;
                  break;
               case this.BTN_BACKITEM:
                  if(Central.main.getMainChar().getBackItem() != "")
                  {
                     _inv += 1;
                  }
                  max_inv = int(Data.INV_SPACE_BACKITEM);
                  max_bar1 = max_inv / 3;
                  max_bar2 = max_inv - max_bar1;
                  break;
               case this.BTN_ACCESSORY:
                  if(Central.main.getMainChar().getAccessory() != "")
                  {
                     _inv += 1;
                  }
                  max_inv = int(Data.INV_SPACE_ACCESSORY);
                  max_bar1 = max_inv / 3;
                  max_bar2 = max_inv - max_bar1;
                  break;
               case this.BTN_ITEM:
                  if(Account.getAccountType() == Account.PREMIUM)
                  {
                     max_inv = int(Data.INV_SPACE_PREMIUM);
                     max_bar1 = max_inv / 3;
                     max_bar2 = max_inv - max_bar1;
                  }
                  else
                  {
                     max_inv = int(Data.INV_SPACE_FREE);
                     max_bar1 = max_inv / 3;
                     max_bar2 = max_inv - max_bar1;
                  }
                  break;
               case this.BTN_ESSENCE:
                  max_inv = int(Data.INV_SPACE_ESSENCE);
                  max_bar1 = max_inv / 3;
                  max_bar2 = max_inv - max_bar1;
                  break;
               case this.BTN_MATERIAL:
                  if(Account.getAccountType() == Account.PREMIUM)
                  {
                     max_inv = int(Data.INV_SPACE_MATERIAL_PREMIUM);
                     max_bar1 = max_inv / 3;
                     max_bar2 = max_inv - max_bar1;
                  }
                  else
                  {
                     max_inv = int(Data.INV_SPACE_MATERIAL_FREE);
                     max_bar1 = max_inv / 3;
                     max_bar2 = max_inv - max_bar1;
                  }
            }
            mc["invBarMc"]["invTxt"].text = _inv + "/" + max_inv;
            if(_inv <= max_bar1)
            {
               mc["invBarMc"]["timebarMC"].visible = true;
               mc["invBarMc"]["timebarMC"].scaleX = _inv / max_inv;
            }
            else if(_inv <= max_bar2)
            {
               mc["invBarMc"]["timebarMC2"].visible = true;
               mc["invBarMc"]["timebarMC2"].scaleX = _inv / max_inv;
            }
            else
            {
               mc["invBarMc"]["timebarMC3"].visible = true;
               mc["invBarMc"]["timebarMC3"].scaleX = _inv / max_inv;
            }
            if(_inv >= max_inv)
            {
               mc["invBarMc"]["invMax"].text = Central.main.langLib.get(1577);
            }
            if(Central.main.checkGameStatus() == Timeline.BATTLE)
            {
               mc["invBarMc"]["AddInvBtn"].filters = [this.dimFilter];
               mc["invBarMc"]["AddInvBtn"].visible = false;
               Central.main.disableButton(mc["invBarMc"]["AddInvBtn"],new Function(),"");
            }
            else
            {
               mc["invBarMc"].visible = true;
               mc["invBarMc"]["AddInvBtn"].filters = null;
               mc["invBarMc"]["AddInvBtn"].visible = true;
               Central.main.initButton(mc["invBarMc"]["AddInvBtn"],this.invPopupCapacity,this.invTxtArr[11]);
            }
            if(curItemType == this.BTN_ACCESSORY)
            {
               mc["invBarMc"]["AddInvBtn"].visible = false;
            }
            else if(curItemType == this.BTN_TRADING)
            {
               mc["invBarMc"].visible = false;
            }
         }
      }
      
      private function updateTokenDisplay() : void
      {
         this["MtokenTxt"].text = String(Central.main.extraData.MCoin);
         this["tokenTxt"].text = String(Account.getAccountBalance());
         Central.main.updateMenu();
      }
      
      private function invPopupCapacity(evt:MouseEvent) : void
      {
         if(this.invBtnName == this.BTN_PET)
         {
            this.invName = "pet";
            this.tmpCharInvArr = Central.main.getMainChar().getInventory(InventoryData.TYPE_PET);
            if(Account.getAccountType() == Account.PREMIUM)
            {
               this.invNameCap = Data.INV_SPACE_PET_PREMIUM;
               this.invNameCapAdd = Data.INV_SPACE_PET_PREMIUM_ADD;
               this.invNameCapNum = Data.INV_SPACE_PET_PREMIUM_CURNUM;
               this.invNameCapMaxNum = Data.INV_SPACE_PET_PREMIUM_MAXNUM;
               this.invNameCapMax = Data.INV_SPACE_PET_PREMIUM_MAX;
            }
            else
            {
               this.invNameCap = Data.INV_SPACE_PET_FREE;
               this.invNameCapAdd = Data.INV_SPACE_PET_FREE_ADD;
               this.invNameCapNum = Data.INV_SPACE_PET_FREE_CURNUM;
               this.invNameCapMaxNum = Data.INV_SPACE_PET_FREE_MAXNUM;
               this.invNameCapMax = Data.INV_SPACE_PET_FREE_MAX;
            }
         }
         else
         {
            if(this.invFirstTime == true && this.invBtnName != "")
            {
               this.tmp_invBtnName = this.BTN_WEAPON;
               this.invFirstTime = false;
            }
            this.invName = "weapon";
            this.invNameCap = Data.INV_SPACE_WEAPON;
            this.invNameCapAdd = Data.INV_SPACE_WEAPON_ADD;
            this.invNameCapMax = Data.INV_SPACE_WEAPON_FREE_MAX;
            this.invNameCapNum = Data.INV_SPACE_WEAPON_FREE_CURNUM;
            this.invNameCapMaxNum = Data.INV_SPACE_WEAPON_FREE_MAXNUM;
            this.tmpCharInvArr = Central.main.getMainChar().getInventory(InventoryData.TYPE_WEAPON);
            if(Account.getAccountType() == Account.PREMIUM)
            {
               this.invNameCapMax = Data.INV_SPACE_WEAPON_PREMIUM_MAX;
               this.invNameCapNum = Data.INV_SPACE_WEAPON_PREMIUM_CURNUM;
               this.invNameCapMaxNum = Data.INV_SPACE_WEAPON_PREMIUM_MAXNUM;
            }
         }
         if(Account.getAccountType() == Account.FREE)
         {
            this["inv_capacity"].gotoAndPlay("free");
         }
         else
         {
            this["inv_capacity"].gotoAndPlay("emblem");
         }
      }
      
      private function feedPetpopup(evt:MouseEvent) : void
      {
         this["popupFeedPet"].gotoAndPlay("show");
      }
      
      public function onShowFeedPetPopup(mc:MovieClip) : void
      {
         var ItemData:Object = null;
         var ItemId:String = null;
         var tooltipStr:String = null;
         var displayMc:MovieClip = null;
         var seq:uint = 0;
         var foodItemArr:Array = null;
         var petFoodArr:Array = null;
         var i:* = undefined;
         var foodMc:MovieClip = null;
         seq = 1;
         petFoodArr = ArrayUtil.copyArray(Central.main.getMainChar().getInventory(InventoryData.TYPE_ESSENCE));
         this.initFeedPetItem(mc);
         mc["panel"]["btnClose"].addEventListener(MouseEvent.CLICK,this.hideFeedPet);
         mc["panel"]["pageTxt"].text = "1 / 1";
         displayMc = Central.main.getLib("LoadingMc");
         this.curDataList = Central.main.ESSENCE_DATA;
         foodItemArr = this.PetFoodArrFilter(petFoodArr);
         Central.main.initButton(mc["panel"]["btnhowtogetfood"],this.showpopupHowtoGetPetFood,AppData.lang == AppData.ZH ? "如何獲得寵物食物?" : "How to get pet food?");
         GF.removeAllChild(displayMc);
         for(i = 0; i < foodItemArr.length; i++)
         {
            foodMc = mc["panel"]["food_" + seq];
            foodMc.visible = true;
            foodMc["iconMc"].visible = true;
            foodMc["ItemIconMc"].visible = false;
            foodMc["lockMc"].visible = false;
            foodMc["ownTxt"].text = "";
            foodMc["expiryTxt"].text = "";
            foodMc["watchMc"].visible = false;
            foodMc["lvTxt"].text = "-";
            foodMc["newMc"].visible = false;
            foodMc["btnEquip"].visible = true;
            foodMc["clickMask"].visible = true;
            ItemId = foodItemArr[i].id;
            if(this.curDataList.find)
            {
               ItemData = this.curDataList.find(foodItemArr[i].id);
            }
            else
            {
               ItemData = this.curDataList[foodItemArr[i].id];
            }
            if(ItemData == null)
            {
               Out.error(this,"Item not exist :: ID-" + foodItemArr[i].id + "-");
            }
            else
            {
               Central.main.initButton(foodMc["btnEquip"],this.feedPetConfirm,ButtonData.USE);
               foodMc["btnEquip"].itemdata = ItemData;
               if(ItemData.animation == Data.TEXT_ESSENCE)
               {
                  displayMc = Central.main.getLib(ItemData.swfName);
               }
               foodMc["iconMc"]["iconHolder"].addChild(displayMc);
               if(int(foodItemArr[i].count) > 1)
               {
                  foodMc["ownTxt"].text = "x" + foodItemArr[i].count;
               }
               tooltipStr = TooltipData.getItemTooltip(TooltipData.TOOLTIP_TYPE_ESSENCE,String(ItemData.id));
               Central.main.showDynamicTooltip(foodMc["clickMask"],String("<font size=\'16\'>" + tooltipStr + "</font>"));
               seq++;
            }
         }
         seq = 1;
         mc["panel"]["btnNextPage"].visible = false;
         mc["panel"]["btnPrevPage"].visible = false;
      }
      
      private function showpopupHowtoGetPetFood(evt:MouseEvent) : void
      {
         this["popupFeedPet"]["panel"]["popupPetFoodTut"].gotoAndPlay("show");
      }
      
      public function onshowHowtoGetPetFood(mc:MovieClip) : void
      {
         mc = this["popupFeedPet"]["panel"]["popupPetFoodTut"]["panel"];
         mc["titleTxt"].text = Central.main.langLib.get(1826);
         mc["subTitleTxt"].text = Central.main.langLib.get(1827)[5];
         mc["detailPage"]["detailPage"]["PageDetailTxt"].text = Central.main.langLib.get(1828)[5];
         mc["btnClose"].addEventListener(MouseEvent.CLICK,this.hidePopup);
      }
      
      private function hidePopup(evt:MouseEvent = null) : *
      {
         if(evt)
         {
            evt.currentTarget.parent.parent.gotoAndPlay(Timeline.EXIT);
         }
      }
      
      private function feedPetConfirm(evt:MouseEvent) : void
      {
         var select:Object = null;
         select = evt.currentTarget;
         this.selectedEquipment = null;
         this.selectedEquipment = select.itemdata;
         Central.main.showAmfLoading();
         Central.main.amfClient.service("PetDAO.addPetMaturityByItem",[Central.main.account.getAccountSessionKey(),this.currentPet.getData(DBCharacterData.ID),this.selectedEquipment.id],this.usePetFoodResponse);
      }
      
      private function usePetFoodResponse(response:Object) : *
      {
         if(Central.main.validateAmfResponse(response))
         {
            this.currentPet.maturity = response.pet_maturity;
            this["popupFeedPet"].gotoAndStop(Timeline.IDLE);
            Central.main.getMainChar().removeInventory(InventoryData.TYPE_ESSENCE,this.selectedEquipment.id);
            Central.main.hideAmfLoading();
            this.showPetDetails();
         }
      }
      
      private function initFeedPetItem(mc:MovieClip) : void
      {
         var maxFood:uint = 0;
         var seq:uint = 0;
         var i:* = undefined;
         var foodMc:MovieClip = null;
         maxFood = 10;
         seq = 1;
         for(i = 0; i < maxFood; i++)
         {
            foodMc = mc["panel"]["food_" + seq];
            foodMc.visible = false;
            foodMc["iconMc"].visible = false;
            foodMc["ItemIconMc"].visible = false;
            foodMc["lockMc"].visible = false;
            foodMc["ownTxt"].text = "";
            foodMc["expiryTxt"].text = "";
            foodMc["watchMc"].visible = false;
            foodMc["lvTxt"].text = "";
            foodMc["newMc"].visible = false;
            foodMc["btnEquip"].visible = false;
            foodMc["clickMask"].visible = false;
            Central.main.disableButton(foodMc["btnEquip"],new Function(),ButtonData.USE);
            seq++;
         }
         seq = 1;
      }
      
      private function hideFeedPet(evt:MouseEvent) : void
      {
         this["popupFeedPet"].gotoAndStop(Timeline.IDLE);
         this.showPetDetails();
      }
      
      private function PetFoodArrFilter(originalArray:Array) : Array
      {
         var lookup:Array = null;
         var uniqueArr:Array = null;
         var num:String = null;
         var obj:Object = null;
         var idx:int = 0;
         var i:int = 0;
         var checkObj:Object = null;
         var j:int = 0;
         lookup = new Array();
         uniqueArr = new Array();
         for(idx = 0; idx < originalArray.length; idx++)
         {
            num = originalArray[idx];
            if(this.curDataList != null && num != this.TEXT_BACKITEM_UNEQUIP && num != this.TEXT_ACCESSORY_UNEQUIP)
            {
               checkObj = null;
               if(this.curDataList.find)
               {
                  checkObj = this.curDataList.find(num);
               }
               else
               {
                  checkObj = this.curDataList[num];
               }
               if(checkObj == null)
               {
                  Out.error(this,"(count) Item not exist :: ID-" + num + "-");
                  continue;
               }
            }
            if(num == "item200" || num == "item201" || num == "item202" || num == "item203" || num == "item204" || num == "item1000")
            {
               if(!lookup[num])
               {
                  obj = new Object();
                  obj.id = num;
                  obj.count = 0;
                  if(this.curDataList != null)
                  {
                     if(this.curDataList.find)
                     {
                        obj.level = this.curDataList.find(num).level;
                     }
                     else
                     {
                        obj.level = this.curDataList[num].level;
                     }
                  }
                  uniqueArr.push(obj);
                  lookup[num] = true;
               }
            }
         }
         for(i = 0; i < uniqueArr.length; i++)
         {
            for(j = 0; j < originalArray.length; j++)
            {
               if(originalArray[j] == uniqueArr[i].id)
               {
                  ++uniqueArr[i].count;
               }
            }
         }
         return uniqueArr;
      }
      
      private function invConfirmBuy(evt:MouseEvent) : void
      {
         var token:String = null;
         token = String(evt.currentTarget.parent["txt_token"].text);
         if(Account.getAccountBalance() < int(token))
         {
            Central.main.getGoldToken(Central.main.langLib.get(1405),Central.main.gotoPaymentGateway,"token");
            return;
         }
         Central.main.showConfirmation(this.invTxtArr[12].replace("[token]",token),this.updateServerInv,new Function());
      }
      
      private function updateServerInv() : *
      {
         Central.main.showAmfLoading();
         Central.main.amfClient.service("CharacterDAO.upgradeInvSlot",[Central.main.account.getAccountSessionKey(),this.invName,this.inv_addTime],this.buyInvAmount);
      }
      
      public function onShowInvBuyPopup(mc:MovieClip) : void
      {
         var tmp_persent:Number = NaN;
         var tmp_current_inv:int = 0;
         tmp_persent = 0;
         tmp_current_inv = 0;
         mc.stop();
         mc["quantityTxt"].text = 1;
         mc["emBaseTxt"].text = 100 + Data.INV_SPACE_WEAPON + this.invTxtArr[8];
         if(Account.getAccountType() == Account.PREMIUM)
         {
            mc["txt_token"].text = 75;
         }
         else
         {
            mc["txt_token"].text = 100;
         }
         mc["emMaxNoticeTxt"].text = this.invTxtArr[7] + Data.INV_SPACE_WEAPON_PREMIUM_MAX + this.invTxtArr[8];
         this.tmp_invBtnName = this.invBtnName;
         switch(this.tmp_invBtnName)
         {
            case this.BTN_WEAPON:
               this.invName = "weapon";
               this.invNameCap = Data.INV_SPACE_WEAPON;
               this.invNameCapAdd = Data.INV_SPACE_WEAPON_ADD;
               this.tmpCharInvArr = Central.main.getMainChar().getInventory(InventoryData.TYPE_WEAPON);
               this.invNameCapNum = Data.INV_SPACE_WEAPON_FREE_CURNUM;
               this.invNameCapMaxNum = Data.INV_SPACE_WEAPON_FREE_MAXNUM;
               mc["emBaseTxt"].text = 100 + Data.INV_SPACE_WEAPON + this.invTxtArr[8];
               mc["emMaxNoticeTxt"].text = this.invTxtArr[7] + Data.INV_SPACE_WEAPON_PREMIUM_MAX + this.invTxtArr[8];
               this.invNameCapMax = Data.INV_SPACE_WEAPON_FREE_MAX;
               if(Account.getAccountType() == Account.PREMIUM)
               {
                  this.invNameCapMax = Data.INV_SPACE_WEAPON_PREMIUM_MAX;
                  this.invNameCapNum = Data.INV_SPACE_WEAPON_PREMIUM_CURNUM;
                  this.invNameCapMaxNum = Data.INV_SPACE_WEAPON_PREMIUM_MAXNUM;
               }
               break;
            case this.BTN_CLOTHING:
               this.invName = "body_set";
               this.invNameCap = Data.INV_SPACE_BODYSET;
               this.invNameCapAdd = Data.INV_SPACE_BODYSET_ADD;
               this.tmpCharInvArr = Central.main.getMainChar().getInventory(InventoryData.TYPE_BODY_SET);
               this.invNameCapNum = Data.INV_SPACE_BODYSET_FREE_CURNUM;
               this.invNameCapMaxNum = Data.INV_SPACE_BODYSET_FREE_MAXNUM;
               mc["emBaseTxt"].text = 100 + Data.INV_SPACE_BODYSET + this.invTxtArr[8];
               mc["emMaxNoticeTxt"].text = this.invTxtArr[7] + Data.INV_SPACE_BODYSET_PREMIUM_MAX + this.invTxtArr[8];
               this.invNameCapMax = Data.INV_SPACE_BODYSET_FREE_MAX;
               if(Account.getAccountType() == Account.PREMIUM)
               {
                  this.invNameCapMax = Data.INV_SPACE_BODYSET_PREMIUM_MAX;
                  this.invNameCapNum = Data.INV_SPACE_BODYSET_PREMIUM_CURNUM;
                  this.invNameCapMaxNum = Data.INV_SPACE_BODYSET_PREMIUM_MAXNUM;
               }
               break;
            case this.BTN_BACKITEM:
               this.invName = "back";
               this.invNameCap = Data.INV_SPACE_BACKITEM;
               this.invNameCapAdd = Data.INV_SPACE_BACKITEM_ADD;
               this.tmpCharInvArr = Central.main.getMainChar().getInventory(InventoryData.TYPE_BACK_ITEM);
               this.invNameCapNum = Data.INV_SPACE_BACKITEM_FREE_CURNUM;
               this.invNameCapMaxNum = Data.INV_SPACE_BACKITEM_FREE_MAXNUM;
               mc["emBaseTxt"].text = 100 + Data.INV_SPACE_BACKITEM + this.invTxtArr[8];
               mc["emMaxNoticeTxt"].text = this.invTxtArr[7] + Data.INV_SPACE_BACKITEM_PREMIUM_MAX + this.invTxtArr[8];
               this.invNameCapMax = Data.INV_SPACE_BACKITEM_FREE_MAX;
               if(Account.getAccountType() == Account.PREMIUM)
               {
                  this.invNameCapMax = Data.INV_SPACE_BACKITEM_PREMIUM_MAX;
                  this.invNameCapNum = Data.INV_SPACE_BACKITEM_PREMIUM_CURNUM;
                  this.invNameCapMaxNum = Data.INV_SPACE_BACKITEM_PREMIUM_MAXNUM;
               }
               break;
            case this.BTN_ITEM:
               this.invName = "item";
               this.tmpCharInvArr = Central.main.getMainChar().getInventory(InventoryData.TYPE_ITEM);
               if(Account.getAccountType() == Account.PREMIUM)
               {
                  this.invNameCap = Data.INV_SPACE_PREMIUM;
                  this.invNameCapAdd = Data.INV_SPACE_PREMIUM_ADD;
                  this.invNameCapNum = Data.INV_SPACE_PREMIUM_CURNUM;
                  this.invNameCapMaxNum = Data.INV_SPACE_PREMIUM_MAXNUM;
                  this.invNameCapMax = Data.INV_SPACE_PREMIUM_MAX;
               }
               else
               {
                  this.invNameCap = Data.INV_SPACE_FREE;
                  this.invNameCapAdd = Data.INV_SPACE_FREE_ADD;
                  this.invNameCapNum = Data.INV_SPACE_FREE_CURNUM;
                  this.invNameCapMaxNum = Data.INV_SPACE_FREE_MAXNUM;
                  mc["emMaxNoticeTxt"].text = this.invTxtArr[7] + Data.INV_SPACE_PREMIUM_MAX + this.invTxtArr[8];
                  this.invNameCapMax = Data.INV_SPACE_FREE_MAX;
                  mc["emBaseTxt"].text = 40 + Data.INV_SPACE_FREE + this.invTxtArr[8];
               }
               break;
            case this.BTN_ESSENCE:
               this.invName = "essence";
               this.invNameCap = Data.INV_SPACE_ESSENCE;
               this.invNameCapAdd = Data.INV_SPACE_ESSENCE_ADD;
               this.tmpCharInvArr = Central.main.getMainChar().getInventory(InventoryData.TYPE_ESSENCE);
               this.invNameCapNum = Data.INV_SPACE_ESSENCE_FREE_CURNUM;
               this.invNameCapMaxNum = Data.INV_SPACE_ESSENCE_FREE_MAXNUM;
               mc["emBaseTxt"].text = 100 + Data.INV_SPACE_ESSENCE + this.invTxtArr[8];
               mc["emMaxNoticeTxt"].text = this.invTxtArr[7] + Data.INV_SPACE_ESSENCE_PREMIUM_MAX + this.invTxtArr[8];
               this.invNameCapMax = Data.INV_SPACE_ESSENCE_FREE_MAX;
               if(Account.getAccountType() == Account.PREMIUM)
               {
                  this.invNameCapMax = Data.INV_SPACE_ESSENCE_PREMIUM_MAX;
                  this.invNameCapNum = Data.INV_SPACE_ESSENCE_PREMIUM_CURNUM;
                  this.invNameCapMaxNum = Data.INV_SPACE_ESSENCE_PREMIUM_MAXNUM;
               }
               break;
            case this.BTN_MATERIAL:
               this.invName = "material";
               this.tmpCharInvArr = Central.main.getMainChar().getInventory(InventoryData.TYPE_MATERIAL);
               if(Account.getAccountType() == Account.PREMIUM)
               {
                  this.invNameCap = Data.INV_SPACE_MATERIAL_PREMIUM;
                  this.invNameCapAdd = Data.INV_SPACE_MATERIAL_PREMIUM_ADD;
                  this.invNameCapNum = Data.INV_SPACE_MATERIAL_PREMIUM_CURNUM;
                  this.invNameCapMaxNum = Data.INV_SPACE_MATERIAL_PREMIUM_MAXNUM;
                  this.invNameCapMax = Data.INV_SPACE_MATERIAL_PREMIUM_MAX;
               }
               else
               {
                  this.invNameCap = Data.INV_SPACE_MATERIAL_FREE;
                  this.invNameCapAdd = Data.INV_SPACE_MATERIAL_FREE_ADD;
                  this.invNameCapNum = Data.INV_SPACE_MATERIAL_FREE_CURNUM;
                  this.invNameCapMaxNum = Data.INV_SPACE_MATERIAL_FREE_MAXNUM;
                  mc["emMaxNoticeTxt"].text = this.invTxtArr[7] + Data.INV_SPACE_MATERIAL_PREMIUM_MAX + this.invTxtArr[8];
                  this.invNameCapMax = Data.INV_SPACE_MATERIAL_FREE_MAX;
                  mc["emBaseTxt"].text = 200 + Data.INV_SPACE_MATERIAL_FREE + this.invTxtArr[8];
               }
               break;
            case this.BTN_ACCESSORY:
               this.invName = "accessory";
               this.invNameCap = Data.INV_SPACE_ACCESSORY;
               this.invNameCapAdd = Data.INV_SPACE_ACCESSORY_ADD;
               this.tmpCharInvArr = Central.main.getMainChar().getInventory(InventoryData.TYPE_ACCESSORY);
               this.invNameCapNum = Data.INV_SPACE_ACCESSORY_FREE_CURNUM;
               this.invNameCapMaxNum = Data.INV_SPACE_ACCESSORY_FREE_MAXNUM;
               mc["emBaseTxt"].text = 100 + Data.INV_SPACE_ACCESSORY + this.invTxtArr[8];
               mc["emMaxNoticeTxt"].text = this.invTxtArr[7] + Data.INV_SPACE_ACCESSORY_PREMIUM_MAX + this.invTxtArr[8];
               this.invNameCapMax = Data.INV_SPACE_ACCESSORY_FREE_MAX;
               if(Account.getAccountType() == Account.PREMIUM)
               {
                  this.invNameCapMax = Data.INV_SPACE_ACCESSORY_PREMIUM_MAX;
                  this.invNameCapNum = Data.INV_SPACE_ACCESSORY_PREMIUM_CURNUM;
                  this.invNameCapMaxNum = Data.INV_SPACE_ACCESSORY_PREMIUM_MAXNUM;
               }
               break;
            case this.BTN_PET:
               this.invName = "pet";
               this.tmpCharInvArr = Central.main.getMainChar().getInventory(InventoryData.TYPE_PET);
               if(Account.getAccountType() == Account.PREMIUM)
               {
                  this.invNameCap = Data.INV_SPACE_PET_PREMIUM;
                  this.invNameCapAdd = Data.INV_SPACE_PET_PREMIUM_ADD;
                  this.invNameCapNum = Data.INV_SPACE_PET_PREMIUM_CURNUM;
                  this.invNameCapMaxNum = Data.INV_SPACE_PET_PREMIUM_MAXNUM;
                  mc["emMaxNoticeTxt"].text = this.invTxtArr[7] + Data.INV_SPACE_PET_PREMIUM_MAX + this.invTxtArr[8];
                  this.invNameCapMax = Data.INV_SPACE_PET_PREMIUM_MAX;
                  mc["emBaseTxt"].text = 50 + Data.INV_SPACE_PET_PREMIUM + this.invTxtArr[8];
               }
               else
               {
                  this.invNameCap = Data.INV_SPACE_PET_FREE;
                  this.invNameCapAdd = Data.INV_SPACE_PET_FREE_ADD;
                  this.invNameCapNum = Data.INV_SPACE_PET_FREE_CURNUM;
                  this.invNameCapMaxNum = Data.INV_SPACE_PET_FREE_MAXNUM;
                  mc["emMaxNoticeTxt"].text = this.invTxtArr[7] + Data.INV_SPACE_PET_PREMIUM_MAX + this.invTxtArr[8];
                  this.invNameCapMax = Data.INV_SPACE_PET_FREE_MAX;
                  mc["emBaseTxt"].text = 50 + Data.INV_SPACE_PET_FREE + this.invTxtArr[8];
               }
         }
         if(!mc["noBtn"].hasEventListener(MouseEvent.CLICK))
         {
            this.inv_addTime = 1;
            this.tmp_invBtnName = this.invBtnName;
            mc["noBtn"].addEventListener(MouseEvent.CLICK,this.closeInvCapacity);
         }
         if(Account.getAccountType() == Account.FREE)
         {
            mc["getEmTxt"].text = this.invTxtArr[10];
            Central.main.initButton(mc["emFreeBtn"],this.showUpgradePage);
            mc["getEmFreeTxt"].text = this.invTxtArr[10];
         }
         if(this.invNameCapNum < this.invNameCapMaxNum)
         {
            Central.main.initButton(mc["btnSub"],this.onSubBtn,null);
            Central.main.initButton(mc["btnAdd"],this.onAddBtn,null);
         }
         else
         {
            Central.main.disableButton(mc["btnSub"],this.onSubBtn,null);
            Central.main.disableButton(mc["btnAdd"],this.onAddBtn,null);
         }
         tmp_current_inv = int(this.tmpCharInvArr.length);
         if(this.invName == "weapon" || this.invName == "body_set")
         {
            tmp_current_inv += 1;
         }
         if(this.invName == "back" && Central.main.getMainChar().getBackItem() != "")
         {
            tmp_current_inv += 1;
         }
         mc["titleTxt"].text = this.invTxtArr[0];
         tmp_persent = this.tmpCharInvArr.length / this.invNameCap * 100;
         mc["totalNoticeTxt"].text = this.invTxtArr[3];
         mc["currentTxt"].text = this.invNameCap + this.invTxtArr[8];
         mc["currentOwnTxt"].text = this.invNameCap + this.invTxtArr[8];
         mc["currentInvTxt"].text = tmp_current_inv + this.invTxtArr[8];
         mc["ownedTxt"].text = this.invTxtArr[9];
         mc["ownedFreeTxt"].text = this.invTxtArr[9];
         mc["emFreeNoticeTxt"].text = this.invTxtArr[6];
         mc["emNoticeTxt"].text = this.invTxtArr[4];
         mc["upgradeInvTxt"].text = this.invTxtArr[9];
         mc["freeNoticeTxt"].text = this.invTxtArr[5];
         mc["freeCurrentTxt"].text = this.invTxtArr[3];
         mc["emCurrentTxt"].text = this.invTxtArr[3];
         mc["emblemTxt_0"].text = this.invTxtArr[6];
         mc["emblemTxt_1"].text = this.invTxtArr[13];
         if(tmp_persent < 1 && tmp_current_inv >= 1)
         {
            tmp_persent = 1;
            mc["pieAnimation"].gotoAndStop(2);
         }
         else if(tmp_current_inv == this.invNameCap)
         {
            tmp_persent = 100;
            mc["pieAnimation"].gotoAndStop(101);
         }
         else
         {
            mc["pieAnimation"].gotoAndStop(int(tmp_persent) + 1);
         }
         mc["persentUseTxt"].text = this.invTxtArr[2] + int(tmp_persent) + "%" + this.invTxtArr[1];
         if(int(this.tmpCharInvArr.length / this.invNameCap * 100) >= 80)
         {
            mc["fullSoon"].text = "!";
         }
         else
         {
            mc["fullSoon"].text = "";
         }
         mc["totalTxt"].text = this.invTxtArr[7] + this.invNameCapMax + this.invTxtArr[8];
         mc["totalFreeTxt"].text = this.invTxtArr[7] + this.invNameCapMax + this.invTxtArr[8];
         if(this.invNameCapNum < this.invNameCapMaxNum)
         {
            mc["willOwnTxt"].text = "+ " + this.inv_addTime * this.invNameCapAdd;
            Central.main.initButton(mc["tokenBtn"],this.invConfirmBuy,ButtonData.CONFIRM);
         }
         else
         {
            mc["willOwnTxt"].text = "+ 0";
            Central.main.disableButton(mc["tokenBtn"],new Function(),"MAX");
            mc["tokenBtn"].filters = [this.dimFilter];
         }
      }
      
      private function onMinBtn(evt:MouseEvent) : void
      {
         var mc:MovieClip = null;
         mc = MovieClip(evt.currentTarget);
         mc.parent["quantityTxt"].text = 1;
         this.inv_addTime = int(mc.parent["quantityTxt"].text);
         this.updateInvCapacityPrice(mc,this.invNameCap);
      }
      
      private function onSubBtn(evt:MouseEvent) : void
      {
         var mc:MovieClip = null;
         mc = MovieClip(evt.currentTarget);
         if(mc.parent["quantityTxt"].text > 1)
         {
            mc.parent["quantityTxt"].text = int(mc.parent["quantityTxt"].text) - 1;
            this.inv_addTime = int(mc.parent["quantityTxt"].text);
            this.updateInvCapacityPrice(mc,this.invNameCap);
         }
      }
      
      private function onMaxBtn(evt:MouseEvent) : void
      {
         var mc:MovieClip = null;
         mc = MovieClip(evt.currentTarget);
         mc["quantityTxt"].text = this.invNameCapMaxNum - this.invNameCapNum;
         this.inv_addTime = int(mc["quantityTxt"].text);
         this.updateInvCapacityPrice(mc,this.invNameCap);
      }
      
      private function onAddBtn(evt:MouseEvent) : void
      {
         var mc:MovieClip = null;
         var value:int = 0;
         mc = MovieClip(evt.currentTarget);
         if(this.invNameCapNum < this.invNameCapMaxNum && mc.parent["quantityTxt"].text < this.invNameCapMaxNum - this.invNameCapNum)
         {
            value = parseInt(String(mc.parent["quantityTxt"].text)) + 1;
            mc.parent["quantityTxt"].text = String(value);
            this.inv_addTime = value;
            this.updateInvCapacityPrice(mc,this.invNameCap);
         }
      }
      
      private function updateInvCapacityPrice(mc:MovieClip, iNC:int) : void
      {
         if(Account.getAccountType() == Account.PREMIUM)
         {
            mc.parent["txt_token"].text = this.inv_addTime * 75;
         }
         else
         {
            mc.parent["txt_token"].text = this.inv_addTime * 100;
         }
         mc.parent["willOwnTxt"].text = "+ " + this.inv_addTime * this.invNameCapAdd;
      }
      
      private function closeInvCapacity(evt:MouseEvent) : void
      {
         this["inv_capacity"].gotoAndStop(Timeline.IDLE);
      }
      
      public function dailyRoulettePlayAni(_mc:MovieClip) : void
      {
         Central.main.proc.dailyRouletteRotation(_mc);
      }
      
      internal function frame1() : *
      {
         this.onIdle();
         this.stop();
      }
      
      internal function frame7() : *
      {
         stop();
      }
      
      internal function frame11() : *
      {
         this.onPet();
      }
      
      internal function frame16() : *
      {
         this.onEquipment();
      }
      
      internal function frame21() : *
      {
         this.onItem();
      }
      
      internal function frame27() : *
      {
         this.onSkill();
      }
      
      internal function frame32() : *
      {
         this.onOption();
      }
      
      internal function frame37() : *
      {
         this.onMusic();
      }
      
      internal function frame40() : *
      {
         stop();
      }
   }
}

