package
{
   import bitemycode.facebook.FBUser;
   import com.adobe.crypto.MD5;
   import com.utils.GF;
   import com.utils.Mixer;
   import com.utils.Out;
   import flash.display.MovieClip;
   import flash.display.StageQuality;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.ProgressEvent;
   import flash.events.TimerEvent;
   import flash.system.Security;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;
   import flash.ui.ContextMenu;
   import flash.ui.ContextMenuBuiltInItems;
   import flash.ui.ContextMenuItem;
   import flash.utils.Timer;
   import flash.utils.getDefinitionByName;
   import flash.utils.getTimer;
   import ninjasaga.*;
   import ninjasaga.base.*;
   import ninjasaga.battle.*;
   import ninjasaga.data.AppData;
   import ninjasaga.data.BloodlineData;
   import ninjasaga.data.ButtonData;
   import ninjasaga.data.DBCharacterData;
   import ninjasaga.data.Data;
   import ninjasaga.data.MissionData;
   import ninjasaga.data.SkillData;
   import ninjasaga.data.StaticVariables;
   import ninjasaga.data.Timeline;
   
   public class NinjaSaga extends MovieClip
   {
      
      public static var swfObj:Object = {};
      
      public static var isTestMode:Boolean = false;
      
      private var codeLibrary:MovieClip;
      
      private var networkLibrary:MovieClip;
      
      public var engageMc:MovieClip;
      
      public var mapMc:MovieClip;
      
      public var mapMenuMc:MovieClip;
      
      public var popupMc:MovieClip;
      
      private var validTimer:Timer;
      
      private var devTest:Boolean = false;
      
      private var fpsTxt:TextField;
      
      private var frames:int = 0;
      
      private var curTimer:Number = 0;
      
      private var prevTimer:Number = 0;
      
      public function NinjaSaga()
      {
         var i:uint = 0;
         var security_filename:String = null;
         fpsTxt = new TextField();
         super();
         try
         {
            i = 0;
            while(i < Data.SECURITY_FILES.length)
            {
               security_filename = Data.SECURITY_FILES[i];
               if(security_filename.indexOf("/crossdomain.xml") >= 0)
               {
                  security_filename += "?x=" + Math.floor(Math.random() * 10000);
               }
               Security.loadPolicyFile(security_filename);
               i++;
            }
         }
         catch(e:Error)
         {
            Out.error(this,"NS Constructor(load security files)::" + e.getStackTrace());
            Central.main.submitLogDump();
         }
         try
         {
            Security.allowDomain("api.msappspace.com");
         }
         catch(e:Error)
         {
            Out.error(this,"NS Constructor(Security.allowDomain)::" + e.getStackTrace());
            Central.main.submitLogDump();
         }
         try
         {
            if(this.loaderInfo.parameters.client_version)
            {
               Data.BUILD_NO = this.loaderInfo.parameters.client_version;
            }
         }
         catch(e:Error)
         {
         }
         this.setupContextMenu();
         try
         {
            if(AppData.SUPPORTED_LANGUAGE.indexOf(this.loaderInfo.parameters.lang) >= 0)
            {
               AppData.lang = String(this.loaderInfo.parameters.lang);
            }
            else
            {
               NinjaSaga.isTestMode = true;
               AppData.lang = AppData.ZH;
               stage.quality = StageQuality.LOW;
            }
         }
         catch(e:Error)
         {
            Out.error(this,"NS Constructor :: Language Error :: " + e.getStackTrace());
            Central.main.submitLogDump();
         }
         try
         {
            i = 0;
            while(i < Data.STATIC_SERVERS.length)
            {
               if(String(this.loaderInfo.loaderURL).indexOf(Data.STATIC_SERVERS[i]) >= 0)
               {
                  Data.STATIC_SERVER = Data.STATIC_SERVERS[i];
                  break;
               }
               i++;
            }
         }
         catch(e:Error)
         {
            Out.error(this,"NS Constructor::" + e.getStackTrace());
            Central.main.submitLogDump();
         }
         try
         {
            if(String(this.loaderInfo.loaderURL).indexOf("file://") >= 0)
            {
               StaticVariables.loadType = Data.LOAD_TYPE_LOCAL;
            }
            else
            {
               StaticVariables.loadType = Data.LOAD_TYPE_WEB;
            }
         }
         catch(e:Error)
         {
            Out.error(this,"NS Constructor::" + e.getStackTrace());
            Central.main.submitLogDump();
         }
         if(Data.STATIC_SERVER == null && StaticVariables.loadType == Data.LOAD_TYPE_WEB)
         {
            this.stop();
            Out.error(this,"constructor :: host not allowed :: " + this.loaderInfo.loaderURL);
            return;
         }
         try
         {
            this.selfPreloadFinish(null);
         }
         catch(e:Error)
         {
            Out.error(this,"NS Construct selfPreloadFinish::" + e.getStackTrace());
         }
         this.tabEnabled = false;
         this.tabChildren = false;
      }
      
      public function setupContextMenu() : void
      {
         var _loc3_:ContextMenuItem = null;
         var _loc4_:ContextMenuItem = null;
         var _loc5_:ContextMenuItem = null;
         var _loc1_:ContextMenu = new ContextMenu();
         var _loc2_:ContextMenuBuiltInItems = _loc1_.builtInItems;
         _loc1_.hideBuiltInItems();
         if(Data.TEST_VERSION)
         {
            _loc3_ = new ContextMenuItem("*** Test Version ***");
            _loc1_.customItems.push(_loc3_);
            _loc4_ = new ContextMenuItem("*** AMF ***");
            _loc1_.customItems.push(Data.AMF_GATEWAY);
         }
         else
         {
            _loc5_ = new ContextMenuItem("Build " + Data.BUILD_NO + "." + Data.BUILD_REVIEW);
         }
         _loc1_.customItems.push(_loc5_);
         this.contextMenu = _loc1_;
      }
      
      private function showLoading(param1:ProgressEvent) : void
      {
         var _loc2_:Number = param1.bytesLoaded / param1.bytesTotal;
         if(_loc2_ < 0)
         {
            _loc2_ = 0;
         }
         if(_loc2_ > 1)
         {
            _loc2_ = 1;
         }
         this["preloader"].showLoadingProgress(_loc2_);
      }
      
      private function selfPreloadFinish(param1:Event) : void
      {
         var _loc5_:String = null;
         var _loc2_:uint = 0;
         var _loc3_:Array = [];
         _loc3_.push("swf/library/code_library.swf");
         _loc3_.push("swf/library/client_library.swf");
         if(NinjaSaga.isTestMode)
         {
            NinjaSaga.isTestMode = true;
            _loc3_.push("swf/language/" + AppData.EN + ".swf");
            _loc3_.push("swf/language/" + AppData.ES + ".swf");
            _loc3_.push("swf/language/" + AppData.ZH + ".swf");
         }
         else
         {
            _loc3_.push("swf/language/" + AppData.lang + ".swf");
         }
         _loc3_.push("swf/library/network_library.swf");
         _loc3_.push("swf/library/popup.swf");
         if(this.loaderInfo.parameters.fb_uid != null && this.loaderInfo.parameters.fb_at != null && this.loaderInfo.parameters.fb_sig != null)
         {
            AppData.type = AppData.FB;
            _loc3_.push("swf/sns/facebook_connector.swf");
         }
         if(this.loaderInfo.parameters.orkut_id)
         {
            AppData.type = AppData.OK;
            _loc3_.push("swf/sns/orkut_connector.swf");
         }
         if(this.loaderInfo.parameters.myspace_id)
         {
            AppData.type = AppData.MP;
            _loc3_.push("swf/sns/myspace_connector.swf");
         }
         if(this.loaderInfo.parameters.source)
         {
            switch(this.loaderInfo.parameters.source)
            {
               case AppData.RR:
                  AppData.type = AppData.RR;
                  break;
               default:
                  AppData.type = AppData.YM;
            }
         }
         Out.debug(this,"AppData.type " + AppData.type);
         var _loc4_:String = AppData.connectorPath;
         if(_loc4_)
         {
            _loc3_.push(_loc4_);
         }
         switch(AppData.lang)
         {
            case AppData.CN:
               _loc5_ = "正在初始化......";
               break;
            case AppData.ZH:
               _loc5_ = "正在初始化......";
               break;
            default:
               _loc5_ = "Initializing Game Engine...";
         }
         this["preloader"].loadSwf(_loc3_,this.preloadFinish,null,_loc5_);
      }
      
      private function preloadFinish(param1:Object) : void
      {
         var _loc3_:String = null;
         this.codeLibrary = param1["swf/library/code_library.swf"];
         this.codeLibrary.setMainMc(this);
         this.networkLibrary = param1["swf/library/network_library.swf"];
         this.networkLibrary.init();
         this.popupMc = param1["swf/library/popup.swf"];
         this["popupHolder"].addChild(this.popupMc);
         Central.main.proc.clientLib = param1["swf/library/client_library.swf"];
         Central.main.langLib = param1["swf/language/" + AppData.lang + ".swf"];
         if(NinjaSaga.isTestMode)
         {
            NinjaSaga.swfObj["swf/language/" + AppData.EN + ".swf"] = param1["swf/language/" + AppData.EN + ".swf"];
            NinjaSaga.swfObj["swf/language/" + AppData.ES + ".swf"] = param1["swf/language/" + AppData.ES + ".swf"];
            NinjaSaga.swfObj["swf/language/" + AppData.ZH + ".swf"] = param1["swf/language/" + AppData.ZH + ".swf"];
         }
         if(Boolean(this.loaderInfo) && Boolean(this.loaderInfo.parameters) && Boolean(this.loaderInfo.parameters.client_debug))
         {
            _loc3_ = MD5.hash(this.loaderInfo.parameters.client_debug);
            if(_loc3_ == "33efb782948d3ef2b812ac77cf881ec7")
            {
               this.devTest = true;
            }
         }
         if(this.devTest == true)
         {
            this.createFPStextField();
            this["fpsTxt"].addEventListener(Event.ENTER_FRAME,this.performFrameTest);
         }
         if(AppData.type == AppData.FB)
         {
            Central.sns.fbConnector = param1["swf/sns/facebook_connector.swf"];
            Central.sns.fbConnector.setAccessToken(this.loaderInfo.parameters.fb_at);
         }
         if(AppData.type == AppData.OK)
         {
            Central.sns.okConnector = param1["swf/sns/orkut_connector.swf"];
            Central.sns.okConnector.conn;
         }
         if(AppData.type == AppData.MP)
         {
            Central.sns.mpConnector = param1["swf/sns/myspace_connector.swf"];
         }
         var _loc2_:String = AppData.connectorPath;
         if(_loc2_)
         {
            Central.sns.getInstance().setConnector(param1[_loc2_]);
         }
         Central.main.addJSCallBack();
         switch(AppData.type)
         {
            case AppData.FB:
            case AppData.OK:
            case AppData.MP:
            case AppData.YM:
            case AppData.RR:
               Central.main.checkFeatureControl();
               this.gotoLogin();
               break;
            default:
               Central.main.checkFeatureControl();
               this.gotoLogin();
         }
      }
      
      public function onClickChooseType(param1:MouseEvent) : void
      {
         Central.main.checkFeatureControl(param1.currentTarget.AppType);
         this["buttonMC1"].visible = false;
         this["buttonMC2"].visible = false;
         this["buttonMC3"].visible = false;
         this.gotoLogin();
      }
      
      public function gotoLogin(param1:Event = null) : void
      {
         this["preloader"].hide();
         this.initSocialPlatform();
      }
      
      private function initSocialPlatform() : void
      {
         if(AppData.type == AppData.FB)
         {
            this.onFbLogin({
               "uid":this.loaderInfo.parameters.fb_uid,
               "name":this.loaderInfo.parameters.fb_name,
               "pic_square":Central.sns.FB_GRAPH_API + this.loaderInfo.parameters.fb_uid + "/picture"
            });
            return;
         }
         if(AppData.type == AppData.OK)
         {
            this.onFbLogin({
               "uid":this.loaderInfo.parameters.orkut_id,
               "name":this.loaderInfo.parameters.orkut_name,
               "pic_square":this.loaderInfo.parameters.orkut_pic
            });
            return;
         }
         if(AppData.type == AppData.MP)
         {
            this.onFbLogin({
               "uid":this.loaderInfo.parameters.myspace_id,
               "name":this.loaderInfo.parameters.myspace_name,
               "pic_square":this.loaderInfo.parameters.orkut_pic
            });
            return;
         }
         switch(AppData.type)
         {
            case AppData.YM:
            case AppData.RR:
               if(this.loaderInfo.parameters.session_key)
               {
                  this.login(this.loaderInfo.parameters.session_key);
                  return;
               }
         }
         this.gotoAndStop(Timeline.LOGIN);
      }
      
      public function gotoSelchar() : void
      {
         this.gotoAndStop(Timeline.SELCHAR);
      }
      
      public function gotoInit(param1:MouseEvent = null) : void
      {
         this.gotoAndStop(Timeline.INIT);
      }
      
      public function gotoMap() : void
      {
         Central.main.updateMusic();
         this.gotoAndPlay(Timeline.MAP);
      }
      
      public function gotoBattle() : void
      {
         this.gotoAndStop(Timeline.BATTLE);
      }
      
      public function gotoPanel() : void
      {
         Central.main.stopMusic();
         this.gotoAndStop(Timeline.PANEL);
      }
      
      public function gotoMCPlayer() : void
      {
         this.gotoAndStop(Timeline.MC_PLAYER);
      }
      
      public function gotoEngage() : void
      {
         this.gotoAndStop(Timeline.ENGAGE);
      }
      
      public function gotoMapMission(param1:Event = null) : void
      {
         this.gotoAndStop(Timeline.MAP_MISSION);
      }
      
      private function onPreloader() : void
      {
         this.stop();
      }
      
      private function onLogin() : void
      {
      }
      
      private function onSelchar() : void
      {
         if(AppData.type != AppData.RR)
         {
            this["rr_selectCharMC"].visible = false;
         }
         else
         {
            this["selectCharMC"].visible = false;
         }
         this.stop();
      }
      
      private function onInit() : void
      {
         this.stop();
         Central.main.preloadData();
      }
      
      private function onMap() : void
      {
         Central.main.callGoogleAnalytics("Login","OnMap",Central.main.getMainChar().getDBChar().character_id);
         this.stop();
         this["mapHolder"].addChild(this.mapMc);
         this["menuHolder"].addChild(this.mapMenuMc);
         Central.main.onEnterMap();
      }
      
      public function onShowAdminMessage() : void
      {
         this["popupAdminMessage"]["text"].text = Central.main.adminMessage;
      }
      
      private function onBattle() : void
      {
         this.stop();
         this["menuHolder"].addChild(this.mapMenuMc);
         this["tutorialHintMc"].visible = false;
      }
      
      private function onPanel() : void
      {
         this.stop();
         Central.main.showPanel();
      }
      
      private function onMCPlayer() : void
      {
         this.stop();
         this["mcHolder"].addChild(Central.main.cinematicsMc);
      }
      
      private function onEngage() : void
      {
         this.stop();
         if(Central.main.MISSION_ENGAGE_RESET == true || Central.main.MISSION_ENGAGE_RESET == null)
         {
            this.engageMc = null;
            GF.removeAllChild(this["engageHolder"]);
            Central.main.MISSION_ENGAGE_RESET = false;
         }
         if(Central.main.MISSION_ENGAGE_BG == null || Central.main.MISSION_ENGAGE_BG == "")
         {
            Central.main.MISSION_ENGAGE_BG = MissionData.ENGAGE_BG;
         }
         if(this.engageMc == null)
         {
            Central.main.loadSwf(["swf/library/" + Central.main.MISSION_ENGAGE_BG + ".swf"],this.loadEngageFinish);
         }
         else
         {
            this["engageHolder"].addChild(this.engageMc);
            this.engageMc.show();
         }
      }
      
      private function onMapMission() : void
      {
         this.stop();
      }
      
      public function showError() : void
      {
         var _loc1_:String = "";
         var _loc2_:String = "";
         if(int(Central.main.errorCode) > 0)
         {
            _loc1_ = "(Error " + Central.main.errorCode + ")";
         }
         if(Central.main.errorCode == "1100")
         {
            _loc2_ = Central.main.errorMessage;
         }
         else
         {
            _loc2_ = Central.main.errorData.getErrorString(Central.main.errorCode);
         }
         if(Central.main.errorCode == "2000")
         {
            MovieClip(this.parent)["errorMc"].show2000(_loc1_,_loc2_);
         }
         else
         {
            MovieClip(this.parent)["errorMc"].show(_loc1_,_loc2_);
         }
         this.stop();
         Mixer.getInstance().muteAll();
      }
      
      private function loadEngageFinish(param1:Object) : void
      {
         if(Central.main.MISSION_ENGAGE_BG == null || Central.main.MISSION_ENGAGE_BG == "")
         {
            Central.main.MISSION_ENGAGE_BG = MissionData.ENGAGE_BG;
         }
         this.engageMc = param1["swf/library/" + Central.main.MISSION_ENGAGE_BG + ".swf"];
         this.onEngage();
      }
      
      private function onFBConnect(param1:String) : void
      {
         Out.debug(this,"sns connected, initializing login info...");
         Central.sns.fbConnector.conn.initData(this.onFbLogin);
      }
      
      private function onFbLogin(param1:Object) : void
      {
         Out.debug(this,"got login info... " + param1 + " :: loggin in...");
         if(param1)
         {
            FBUser.uid = param1.uid;
            FBUser.username = param1.name;
            if(param1.pic_square)
            {
               FBUser.pic = param1.pic_square;
            }
            Central.main.amfClient.service("SystemService.requireLogin",[this.loaderInfo.parameters.time,this.loaderInfo.parameters.hash_time,FBUser.uid],this.requireLoginResponse);
            Central.main.callJS("validateDomain");
            this.validTimer = new Timer(8000,1);
            this.validTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.onTimerComplete);
            this.validTimer.start();
         }
         else
         {
            Central.main.onError("0","Oops! Sorry, there is an error connecting to Facebook server. Please refresh this page or try again later.");
         }
      }
      
      private function onTimerComplete(param1:TimerEvent) : void
      {
         if(!Central.main.validLogin)
         {
            Central.main.onError("303","");
         }
         this.validTimer.reset();
         this.validTimer.stop();
         this.validTimer = null;
      }
      
      private function requireLoginResponse(param1:Object) : void
      {
         if(!Central.main.validateAmfResponse(param1))
         {
            return;
         }
         var _loc2_:String = param1.result;
         var _loc3_:String = _loc2_ + String(FBUser.uid) + AppData.type + String(Data.BUILD_NO) + this.codeLibrary.codec;
         var _loc4_:String = Central.main.getLoginHash(_loc2_,_loc3_);
         Central.main.ACCESS_TOKEN = this.loaderInfo.parameters.fb_at;
         Central.main.amfClient.service("SystemService.snsLogin",[FBUser.uid,AppData.type,Data.BUILD_NO,_loc2_,_loc4_,this.loaderInfo.parameters.fb_sig,this.loaderInfo.parameters.fb_at,AppData.lang],this.onAmfLoginResult);
      }
      
      private function login(param1:String) : void
      {
         var _loc2_:String = "";
         var _loc3_:String = _loc2_ + String(param1) + AppData.type + String(Data.BUILD_NO) + this.codeLibrary.codec;
         var _loc4_:String = Central.main.getLoginHash(_loc2_,_loc3_);
         switch(AppData.type)
         {
            case AppData.RR:
               Central.main.amfClient.service("SystemService.snsLogin",[param1,Data.BUILD_NO],this.onAmfLoginResult);
               break;
            default:
               Central.main.amfClient.service("SystemService.snsLogin",[param1,AppData.type,Data.BUILD_NO,_loc2_,_loc4_,AppData.lang],this.onAmfLoginResult);
         }
      }
      
      private function onAmfLoginResult(param1:Object) : void
      {
         var _loc5_:Array = null;
         if(!Central.main.validateAmfResponse(param1))
         {
            return;
         }
         var _loc2_:Array = param1.result as Array;
         var _loc3_:String = param1.signature;
         Central.main.country_area = param1.country_area;
         Central.main.isNewAccount = param1.isNewAccount;
         Central.main.promoteId = param1.promote_id;
         if(param1.isTrialEmblem == 1)
         {
            Central.main.isTrailEmblem = true;
            if(param1.isExpired == 1)
            {
               Central.main.isExpired = true;
            }
         }
         var _loc4_:Object = param1.account_lock as Object;
         if(_loc4_ != null)
         {
            Central.main.paymentStatus = _loc4_.status;
            Central.main.paymentTitle = _loc4_.title;
            Central.main.paymentText = _loc4_.reason;
            Central.main.showLearnMoreBtn = _loc4_.showLearnMoreBtn;
            switch(AppData.lang)
            {
               case AppData.ZH:
                  Central.main.showNewLockPopup = Central.main.paymentTitle == "賬單出現問題" ? true : false;
                  break;
               default:
                  Central.main.showNewLockPopup = Central.main.paymentTitle == "New Payment Cancelled" ? true : false;
            }
            if(Central.main.paymentTitle.toLocaleLowerCase().indexOf("title:") == 0)
            {
               Central.main.paymentTitle = Central.main.paymentTitle.substring(6);
            }
            else
            {
               if(String(Central.main.paymentText).length <= 0)
               {
                  Central.main.paymentText = Central.main.langLib.get(953);
               }
               if(Central.main.paymentText.toLocaleLowerCase().indexOf("hack") >= 0)
               {
                  Central.main.paymentTitle = Central.main.langLib.get(1724)[3];
               }
               else
               {
                  Central.main.paymentTitle = Central.main.langLib.get(1724)[2];
               }
            }
         }
         else
         {
            Central.main.paymentStatus = false;
         }
         if(AppData.type == AppData.RR)
         {
            Central.main.RR_SESSION_KEY = this.loaderInfo.parameters.rr_session_key;
            Central.main.ACCESS_TOKEN = Central.main.RR_SESSION_KEY;
         }
         if(Account.setupAccount(_loc2_,_loc3_))
         {
            Central.main.dataParser.parseVersionData(param1.swf_versions);
            _loc5_ = [];
            _loc5_.push({
               "path":"swf/language/data_library_" + AppData.lang + ".swf",
               "version":AppData.dataVer
            });
            this["preloader"].loadSwfByVersion(_loc5_,this.loadDataFinish,null,Central.main.langLib.get(314));
            Central.main.accRegTutStatus = param1.account_registered_tutored;
            Central.main.accRegActiveStatus = param1.account_registered_password;
         }
         else
         {
            Central.main.showInfo(Central.main.langLib.get(310));
         }
      }
      
      private function loadDataFinish(param1:Object) : void
      {
         Central.main.dataLib = param1["swf/language/data_library_" + AppData.lang + ".swf"];
         Central.main.checkAmf();
      }
      
      public function getAsset(param1:String) : *
      {
         var _loc2_:Class = Class(getDefinitionByName(param1));
         return new _loc2_();
      }
      
      private function createFPStextField() : void
      {
         this.fpsTxt.width = 76;
         this.fpsTxt.height = 32;
         this.fpsTxt.x = 960 - this.fpsTxt.width - 2;
         this.fpsTxt.y = 780 - this.fpsTxt.height - 2;
         this.fpsTxt.name = "fpsTxt";
         this.fpsTxt.text = "";
         var _loc1_:TextFormat = new TextFormat();
         _loc1_.bold = false;
         _loc1_.size = 24;
         _loc1_.color = 16711680;
         _loc1_.align = TextFormatAlign.LEFT;
         _loc1_.font = "Arial";
         this.fpsTxt.defaultTextFormat = _loc1_;
         this.addChild(this.fpsTxt);
      }
      
      private function performFrameTest(param1:Event) : void
      {
         frames += 1;
         curTimer = getTimer();
         if(curTimer - prevTimer >= 1000)
         {
            this["fpsTxt"].text = String("fps:" + frames);
            prevTimer = curTimer;
            frames = 0;
         }
      }
      
      private function _checkMouseEventTrail(param1:MouseEvent) : void
      {
         var _loc2_:* = param1.target;
         while(_loc2_)
         {
            trace(">>",_loc2_.name,": ",_loc2_);
            _loc2_ = _loc2_.parent;
         }
      }
   }
}

