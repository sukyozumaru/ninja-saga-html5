package
{
   import com.tuarua.FreSharp;
   import com.tuarua.FreSwift;
   import com.tuarua.WebView;
   import flash.desktop.NativeApplication;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.Graphics;
   import flash.display.Loader;
   import flash.display.Screen;
   import flash.display.Sprite;
   import flash.display.StageAlign;
   import flash.display.StageScaleMode;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.ProgressEvent;
   import flash.events.TimerEvent;
   import flash.filesystem.File;
   import flash.filesystem.FileMode;
   import flash.filesystem.FileStream;
   import flash.geom.Rectangle;
   import flash.net.SharedObject;
   import flash.net.URLLoader;
   import flash.net.URLLoaderDataFormat;
   import flash.net.URLRequest;
   import flash.net.navigateToURL;
   import flash.system.ApplicationDomain;
   import flash.system.Capabilities;
   import flash.system.LoaderContext;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   import flash.utils.ByteArray;
   import flash.utils.Timer;
   import flash.utils.getDefinitionByName;
   import flash.utils.getQualifiedClassName;
   import flash.utils.setTimeout;
   
   [SWF(width="1920", height="1080", backgroundColor="#ffffff", frameRate="24")]
   public class Main extends Sprite
   {
      
      private var freSharpANE:FreSharp;
      
      private var freSwiftANE:FreSwift;
      
      private var isInitialized:Boolean = false;
      
      private const VIEWPORT_WIDTH:Number = 960;
      
      private const VIEWPORT_HEIGHT_MOBILE:Number = 575;
      
      private const VIEWPORT_HEIGHT_DESKTOP:Number = 780;
      
      private var viewportHeight:Number = 575;
      
      private var isDesktopMode:Boolean = false;
      
      private const DEV_MODE:Boolean = false;
      
      private const BUILD_FOR_MOBILE:Boolean = false;
      
      private const LAUNCHER_URLS:Array = this.DEV_MODE ? ["https://localhost/Ninja%20Saga/web/launcher.json"] : ["https://ninjasaga.cc/launcher.json"];
      
      private var launcherUrlIndex:int = 0;
      
      private const APP_VERSION:String = "1.8";
      
      private const DEFAULT_SWF_URL:String = this.DEV_MODE ? "https://localhost/Ninja%20Saga/web/swf/latest/ninja_saga.swf" : "https://cdn.ninjasaga.cc/cdn/swf/latest/ninja_saga.swf";
      
      private const DEFAULT_CDN_VALUE:String = this.DEV_MODE ? "https://localhost/Ninja%20Saga/web/" : "https://cdn.ninjasaga.cc/cdn/";
      
      private const DEFAULT_SERVER_VALUE:String = this.DEV_MODE ? "https://localhost/Ninja%20Saga/engine/server/php/" : "https://amf.ninjasaga.cc/";
      
      private const DEFAULT_WEBSITE_VALUE:String = this.DEV_MODE ? "https://localhost/Ninja%20Saga/web/" : "https://ninjasaga.cc/";
      
      private const CACHE_BUST_LAUNCHER:Boolean = true;
      
      private var gameSWFUrl:String;
      
      private var cdnOptions:Array;
      
      private var serverOptions:Array;
      
      private var langOptions:Array;
      
      private var selectedCDN:int = 0;
      
      private var selectedServer:int = 0;
      
      private var selectedLang:int = 0;
      
      private var activeCDN:int = 0;
      
      private var triedDefaultFallback:Boolean = false;
      
      private var configLoader:URLLoader;
      
      private var urlLoader:URLLoader;
      
      private var colorBackground:uint = 2763306;
      
      private var colorBorder:uint = 4868682;
      
      private var colorText:uint = 13421772;
      
      private var colorSelected:uint = 3815994;
      
      private var colorHeader:uint = 8947848;
      
      private var colorUpdateBg:uint = 6048306;
      
      private var colorUpdatePanel:uint = 3023640;
      
      private var colorUpdatePanelBorder:uint = 7035710;
      
      private var colorUpdateTitle:uint = 15238684;
      
      private var colorUpdateText:uint = 13417386;
      
      private var colorButtonFill:uint = 15238684;
      
      private var colorButtonText:uint = 16777215;
      
      private var colorButtonHoverFill:uint = 4008730;
      
      private var colorButtonHoverText:uint = 15238684;
      
      private var colorSkipFill:uint = 4473924;
      
      private var colorSkipText:uint = 13421772;
      
      private var colorLoadingText:uint = 16777215;
      
      private var colorRestartBg:uint = 0;
      
      private var colorRestartText:uint = 16777215;
      
      private var labelCDN:String = "CDN";
      
      private var labelServer:String = "Game Server";
      
      private var labelLanguage:String = "Language";
      
      private var labelRestart:String = "Please restart the game to apply changes.";
      
      private var labelLoading:String = "Connecting...";
      
      private var labelInitializing:String = "Initializing Game...";
      
      private var labelError:String = "Connection Error.";
      
      private var labelConfigError:String = "Failed to load server list.";
      
      private var labelUpdateAvailable:String = "A new version is available!";
      
      private var labelUpdateRequired:String = "Please update to continue playing.";
      
      private var labelUpdateButton:String = "Update";
      
      private var labelUpdateButton32:String = "Download (32-bit)";
      
      private var labelUpdateButton64:String = "Download (64-bit)";
      
      private var labelDisplayModeHeader:String = "Display Mode";
      
      private var labelDisplayModeMobile:String = "Mobile";
      
      private var labelDisplayModeDesktop:String = "Desktop";
      
      private var serverButton:Sprite;
      
      private var serverMenu:Sprite;
      
      private var menuOverlay:Sprite;
      
      private var isServerMenuOpen:Boolean = false;
      
      private var isGameLoaded:Boolean = false;
      
      private var showMenuButton:Boolean = true;
      
      private var showCDN:Boolean = false;
      
      private var showServers:Boolean = true;
      
      private var showLanguages:Boolean = true;
      
      private var showDisplayMode:Boolean = true;
      
      private var layoutSide:String = this.BUILD_FOR_MOBILE ? "right" : "left";
      
      private var layoutToggleW:Number = 70;
      
      private var layoutToggleH:Number = 80;
      
      private var layoutSettingsW:Number = 70;
      
      private var layoutSettingsH:Number = 70;
      
      private var layoutArrowThickness:Number = 5;
      
      private var layoutCogOuter:Number = 16;
      
      private var layoutCogInner:Number = 12;
      
      private var layoutCogHole:Number = 6;
      
      private var layoutMenuW:Number = 320;
      
      private var layoutMenuItemH:Number = 56;
      
      private var layoutMenuHeaderH:Number = 36;
      
      private var layoutMenuItemFont:int = 20;
      
      private var layoutMenuHeaderFont:int = 16;
      
      private var layoutDotRadius:Number = 4;
      
      private var layoutGap:Number = 10;
      
      private var latestVersion:String = "";
      
      private var updateRequired:Boolean = false;
      
      private var downloadWindows:String = "";
      
      private var downloadArm:String = "";
      
      private var downloadArm64:String = "";
      
      private var changelog:String = "";
      
      private var notificationText:TextField;
      
      private var loader:Loader;
      
      private var progressText:TextField;
      
      private var switchServerBtn:Sprite;
      
      private var gameHolder:Sprite;
      
      private var isBoxedView:Boolean = true;
      
      private var toggleButton:Sprite;
      
      private var saveData:SharedObject;
      
      private var safetyTimer:Timer;
      
      private var configTimeout:Timer;
      
      private var usingCachedConfig:Boolean = false;
      
      private var cachedConfigTried:Boolean = false;
      
      private var pendingConfigText:String = null;
      
      private var webViewWasVisibleBeforeMenu:Boolean = false;
      
      private var confirmOverlay:Sprite;
      
      private var gamePopup:Sprite;
      
      public function Main()
      {
         super();
         stage.scaleMode = StageScaleMode.NO_SCALE;
         stage.align = StageAlign.TOP_LEFT;
         stage.color = 0;
         addEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
         this.safetyTimer = new Timer(500,1);
         this.safetyTimer.addEventListener(TimerEvent.TIMER,this.onSafetyTimer);
         this.safetyTimer.start();
         this.addEventListener(Event.ACTIVATE,this.onActivated);
      }
      
      private function onAddedToStage(event:Event) : void
      {
         removeEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
         if(this.isDesktop())
         {
            this.centerWindow();
            stage.nativeWindow.visible = true;
            stage.nativeWindow.maximize();
            stage.nativeWindow.activate();
         }
      }
      
      protected function onActivated(event:Event) : void
      {
         this.runInit();
      }
      
      private function onSafetyTimer(event:TimerEvent) : void
      {
         this.runInit();
      }
      
      private function runInit() : void
      {
         var frameCount:int = 0;
         var wakeUpANE:Function = null;
         if(this.isInitialized)
         {
            return;
         }
         this.isInitialized = true;
         trace("=== runInit called ===");
         if(this.safetyTimer)
         {
            this.safetyTimer.stop();
            this.safetyTimer.removeEventListener(TimerEvent.TIMER,this.onSafetyTimer);
            this.safetyTimer = null;
         }
         removeEventListener(Event.ACTIVATE,this.onActivated);
         if(!this.isDesktop())
         {
            trace("Android detected, triggering ANE wake-up...");
            frameCount = 0;
            wakeUpANE = function(e:Event):void
            {
               ++frameCount;
               if(frameCount == 10)
               {
                  trace("Toggling display state to wake ANE...");
                  try
                  {
                     NativeApplication.nativeApplication.systemIdleMode = "normal";
                  }
                  catch(err:*)
                  {
                  }
               }
               if(frameCount % 30 == 0)
               {
                  trace("ANE wait frames: " + frameCount);
               }
               if(frameCount >= 60)
               {
                  trace("ANE wake-up complete, calling init()");
                  removeEventListener(Event.ENTER_FRAME,wakeUpANE);
                  init();
               }
            };
            addEventListener(Event.ENTER_FRAME,wakeUpANE);
         }
         else
         {
            this.init();
         }
      }
      
      private function centerWindow() : void
      {
         if(!this.isDesktop())
         {
            return;
         }
         var screenBounds:Rectangle = Screen.mainScreen.visibleBounds;
         var w:int = int(stage.nativeWindow.width);
         var h:int = int(stage.nativeWindow.height);
         stage.nativeWindow.x = screenBounds.x + (screenBounds.width - w) / 2;
         stage.nativeWindow.y = screenBounds.y + (screenBounds.height - h) / 2;
      }
      
      private function logDiag(msg:String) : void
      {
         var f:File = null;
         var fs:FileStream = null;
         trace(msg);
         try
         {
            f = File.applicationStorageDirectory.resolvePath("air_diag.log");
            fs = new FileStream();
            fs.open(f,FileMode.APPEND);
            fs.writeUTFBytes(new Date().toString() + "  " + msg + "\n");
            fs.close();
         }
         catch(e:*)
         {
         }
      }
      
      private function probeWebView() : void
      {
         var wv:Object = null;
         try
         {
            wv = WebView["shared"]();
            this.logDiag("WebView.shared() OK. instance=" + (wv != null ? "yes" : "null"));
         }
         catch(e:*)
         {
            logDiag("WebView INIT FAILED: " + e + " | " + (e is Error ? (e as Error).getStackTrace() : ""));
         }
      }
      
      private function init() : void
      {
         var os:String = null;
         trace("Initializing App Logic...");
         try
         {
            os = Capabilities.os.toLowerCase();
            if(os.indexOf("win") >= 0)
            {
               trace("Detected Windows. Loading FreSharp.");
               this.freSharpANE = new FreSharp();
            }
            else if(os.indexOf("mac") >= 0 || os.indexOf("iphone") >= 0 || os.indexOf("ipad") >= 0)
            {
               trace("Detected Apple Device. Loading FreSwift.");
               this.freSwiftANE = new FreSwift();
            }
            else if(os.indexOf("linux") >= 0 || os.indexOf("android") >= 0)
            {
               trace("Detected Android/Linux. Skipping FreSharp/FreSwift (uses FreKotlin internally).");
            }
         }
         catch(e:Error)
         {
            trace("Error initializing Platform ANEs: " + e.message);
         }
         NativeApplication.nativeApplication.addEventListener(Event.EXITING,this.onExiting);
         stage.addEventListener(Event.RESIZE,this.onResize);
         this.loadPreferences();
         this.createLoadingUI();
         this.fetchLauncherConfig();
      }
      
      private function isDesktop() : Boolean
      {
         var os:String = Capabilities.os.toLowerCase();
         return os.indexOf("win") >= 0 || os.indexOf("mac") >= 0;
      }
      
      private function onExiting(event:Event) : void
      {
         try
         {
            if(WebView)
            {
               WebView.dispose();
            }
         }
         catch(e:*)
         {
         }
         try
         {
            if(this.freSwiftANE)
            {
               this.freSwiftANE = null;
            }
         }
         catch(e:*)
         {
         }
         try
         {
            if(this.freSharpANE)
            {
               this.freSharpANE = null;
            }
         }
         catch(e:*)
         {
         }
      }
      
      private function loadPreferences() : void
      {
         try
         {
            this.saveData = SharedObject.getLocal("ninjaSagaSettings");
            if(this.saveData.data.isBoxedView !== undefined)
            {
               this.isBoxedView = this.saveData.data.isBoxedView;
            }
            if(this.saveData.data.selectedCDN !== undefined)
            {
               this.selectedCDN = this.saveData.data.selectedCDN;
            }
            if(this.saveData.data.selectedServer !== undefined)
            {
               this.selectedServer = this.saveData.data.selectedServer;
            }
            if(this.saveData.data.selectedLang !== undefined)
            {
               this.selectedLang = this.saveData.data.selectedLang;
            }
            if(this.saveData.data.isDesktopMode !== undefined)
            {
               this.isDesktopMode = this.saveData.data.isDesktopMode;
            }
            this.viewportHeight = this.isDesktopMode ? this.VIEWPORT_HEIGHT_DESKTOP : this.VIEWPORT_HEIGHT_MOBILE;
         }
         catch(e:*)
         {
         }
      }
      
      private function savePreferences() : void
      {
         try
         {
            if(this.saveData)
            {
               this.saveData.data.isBoxedView = this.isBoxedView;
               this.saveData.data.selectedCDN = this.selectedCDN;
               this.saveData.data.selectedServer = this.selectedServer;
               this.saveData.data.selectedLang = this.selectedLang;
               this.saveData.data.isDesktopMode = this.isDesktopMode;
               this.saveData.flush();
            }
         }
         catch(e:*)
         {
         }
      }
      
      private function cachedConfigFile() : File
      {
         return File.applicationStorageDirectory.resolvePath("launcher_cache.json");
      }
      
      private function saveCachedConfig(text:String) : void
      {
         var fs:FileStream = null;
         if(text == null || text.length == 0)
         {
            return;
         }
         try
         {
            fs = new FileStream();
            fs.open(this.cachedConfigFile(),FileMode.WRITE);
            fs.writeUTFBytes(text);
            fs.close();
         }
         catch(e:*)
         {
            trace("[AIR_LOADER] could not save launcher.json: " + e);
         }
      }
      
      private function readCachedConfig() : String
      {
         var f:File = null;
         var fs:FileStream = null;
         var text:String = null;
         try
         {
            f = this.cachedConfigFile();
            if(!f.exists)
            {
               return null;
            }
            fs = new FileStream();
            fs.open(f,FileMode.READ);
            text = fs.readUTFBytes(fs.bytesAvailable);
            fs.close();
            return text;
         }
         catch(e:*)
         {
            trace("[AIR_LOADER] could not read the saved launcher.json: " + e);
         }
         return null;
      }
      
      private function fetchLauncherConfig() : void
      {
         this.progressText.text = "Fetching server list...";
         this.repositionUI();
         this.loadRemoteConfig();
      }
      
      private function loadRemoteConfig() : void
      {
         this.configLoader = new URLLoader();
         this.configLoader.dataFormat = URLLoaderDataFormat.TEXT;
         this.configLoader.addEventListener(Event.COMPLETE,this.onRemoteConfigLoaded);
         this.configLoader.addEventListener(IOErrorEvent.IO_ERROR,this.onConfigError);
         this.configTimeout = new Timer(5000,1);
         this.configTimeout.addEventListener(TimerEvent.TIMER,this.onConfigTimeout);
         this.configTimeout.start();
         var url:String = this.CACHE_BUST_LAUNCHER ? this.LAUNCHER_URLS[this.launcherUrlIndex] + "?t=" + new Date().getTime() : this.LAUNCHER_URLS[this.launcherUrlIndex];
         this.configLoader.load(new URLRequest(url));
      }
      
      private function onConfigTimeout(event:TimerEvent) : void
      {
         this.configTimeout.removeEventListener(TimerEvent.TIMER,this.onConfigTimeout);
         this.configTimeout = null;
         try
         {
            this.configLoader.close();
         }
         catch(e:*)
         {
         }
         this.configLoader.removeEventListener(Event.COMPLETE,this.onRemoteConfigLoaded);
         this.configLoader.removeEventListener(IOErrorEvent.IO_ERROR,this.onConfigError);
         this.onConfigError(null);
      }
      
      private function onRemoteConfigLoaded(event:Event) : void
      {
         if(this.configTimeout)
         {
            this.configTimeout.stop();
            this.configTimeout.removeEventListener(TimerEvent.TIMER,this.onConfigTimeout);
            this.configTimeout = null;
         }
         this.configLoader.removeEventListener(Event.COMPLETE,this.onRemoteConfigLoaded);
         this.configLoader.removeEventListener(IOErrorEvent.IO_ERROR,this.onConfigError);
         this.onConfigLoaded(event);
      }
      
      private function parseColor(hex:String, defaultColor:uint) : uint
      {
         if(!hex || hex.length == 0)
         {
            return defaultColor;
         }
         return uint("0x" + hex);
      }
      
      private function onConfigLoaded(event:Event) : void
      {
         var configText:String;
         var versionInfo:Object;
         var data:Object = null;
         var colors:Object = null;
         var rawLangs:Array = null;
         var ui:Object = null;
         var layoutData:Object = null;
         var allLabels:Object = null;
         var li:int = 0;
         var L:Object = null;
         var langCode:String = null;
         var labels:Object = null;
         var dl:Object = null;
         var cl:Array = null;
         this.configLoader.removeEventListener(Event.COMPLETE,this.onConfigLoaded);
         this.configLoader.removeEventListener(IOErrorEvent.IO_ERROR,this.onConfigError);
         configText = this.pendingConfigText != null ? this.pendingConfigText : this.configLoader.data as String;
         this.pendingConfigText = null;
         try
         {
            data = JSON.parse(configText);
            this.cdnOptions = data.cdn as Array;
            this.serverOptions = data.servers as Array;
            if(!this.cdnOptions || this.cdnOptions.length == 0 || !this.serverOptions || this.serverOptions.length == 0)
            {
               throw new Error("Invalid launcher config");
            }
            if(!this.usingCachedConfig)
            {
               this.saveCachedConfig(configText);
            }
            colors = data.colors;
            if(colors)
            {
               this.colorBackground = this.parseColor(colors.menu_background,2763306);
               this.colorBorder = this.parseColor(colors.menu_border,4868682);
               this.colorText = this.parseColor(colors.menu_text,13421772);
               this.colorSelected = this.parseColor(colors.menu_selected,3815994);
               this.colorHeader = this.parseColor(colors.menu_header,8947848);
               this.colorUpdateBg = this.parseColor(colors.update_bg,6048306);
               this.colorUpdatePanel = this.parseColor(colors.update_panel,3023640);
               this.colorUpdatePanelBorder = this.parseColor(colors.update_panel_border,7035710);
               this.colorUpdateTitle = this.parseColor(colors.update_title,15238684);
               this.colorUpdateText = this.parseColor(colors.update_text,13417386);
               this.colorButtonFill = this.parseColor(colors.button_fill,15238684);
               this.colorButtonText = this.parseColor(colors.button_text,16777215);
               this.colorButtonHoverFill = this.parseColor(colors.button_hover_fill,4008730);
               this.colorButtonHoverText = this.parseColor(colors.button_hover_text,15238684);
               this.colorSkipFill = this.parseColor(colors.skip_fill,4473924);
               this.colorSkipText = this.parseColor(colors.skip_text,13421772);
               this.colorLoadingText = this.parseColor(colors.loading_text,16777215);
               this.colorRestartBg = this.parseColor(colors.restart_bg,0);
               this.colorRestartText = this.parseColor(colors.restart_text,16777215);
            }
            rawLangs = data.languages as Array;
            this.langOptions = [];
            if(rawLangs)
            {
               for(li = 0; li < rawLangs.length; li++)
               {
                  if(rawLangs[li].enabled !== false)
                  {
                     this.langOptions.push(rawLangs[li]);
                  }
               }
            }
            if(this.langOptions.length == 0)
            {
               this.langOptions.push({
                  "label":"English",
                  "value":"en"
               });
            }
            ui = data.ui;
            if(ui)
            {
               if(ui.show_menu_button === false)
               {
                  this.showMenuButton = false;
               }
               if(ui.show_cdn === false)
               {
                  this.showCDN = false;
               }
               if(ui.show_servers === false)
               {
                  this.showServers = false;
               }
               if(ui.show_languages === false)
               {
                  this.showLanguages = false;
               }
               if(ui.show_display_mode === false)
               {
                  this.showDisplayMode = false;
               }
            }
            layoutData = data.layout;
            if(layoutData)
            {
               L = this.BUILD_FOR_MOBILE ? layoutData.mobile : layoutData.desktop;
               if(L)
               {
                  if(L.side)
                  {
                     this.layoutSide = L.side;
                  }
                  if(L.toggle_w)
                  {
                     this.layoutToggleW = L.toggle_w;
                  }
                  if(L.toggle_h)
                  {
                     this.layoutToggleH = L.toggle_h;
                  }
                  if(L.settings_w)
                  {
                     this.layoutSettingsW = L.settings_w;
                  }
                  if(L.settings_h)
                  {
                     this.layoutSettingsH = L.settings_h;
                  }
                  if(L.arrow_thickness)
                  {
                     this.layoutArrowThickness = L.arrow_thickness;
                  }
                  if(L.cog_outer)
                  {
                     this.layoutCogOuter = L.cog_outer;
                  }
                  if(L.cog_inner)
                  {
                     this.layoutCogInner = L.cog_inner;
                  }
                  if(L.cog_hole)
                  {
                     this.layoutCogHole = L.cog_hole;
                  }
                  if(L.menu_w)
                  {
                     this.layoutMenuW = L.menu_w;
                  }
                  if(L.menu_item_h)
                  {
                     this.layoutMenuItemH = L.menu_item_h;
                  }
                  if(L.menu_header_h)
                  {
                     this.layoutMenuHeaderH = L.menu_header_h;
                  }
                  if(L.menu_item_font)
                  {
                     this.layoutMenuItemFont = L.menu_item_font;
                  }
                  if(L.menu_header_font)
                  {
                     this.layoutMenuHeaderFont = L.menu_header_font;
                  }
                  if(L.dot_radius)
                  {
                     this.layoutDotRadius = L.dot_radius;
                  }
                  if(L.gap)
                  {
                     this.layoutGap = L.gap;
                  }
               }
            }
            if(this.selectedCDN >= this.cdnOptions.length)
            {
               this.selectedCDN = 0;
            }
            if(this.selectedServer >= this.serverOptions.length)
            {
               this.selectedServer = 0;
            }
            if(this.cdnOptions.length > 0)
            {
               this.selectedCDN = this.selectedServer < this.cdnOptions.length ? this.selectedServer : int(this.cdnOptions.length - 1);
            }
            if(this.selectedLang >= this.langOptions.length)
            {
               this.selectedLang = 0;
            }
            allLabels = data.labels;
            if(allLabels)
            {
               langCode = this.langOptions[this.selectedLang].value;
               labels = allLabels[langCode] || allLabels["en"];
               if(labels)
               {
                  if(labels.cdn_header)
                  {
                     this.labelCDN = labels.cdn_header;
                  }
                  if(labels.server_header)
                  {
                     this.labelServer = labels.server_header;
                  }
                  if(labels.language_header)
                  {
                     this.labelLanguage = labels.language_header;
                  }
                  if(labels.restart_message)
                  {
                     this.labelRestart = labels.restart_message;
                  }
                  if(labels.loading)
                  {
                     this.labelLoading = labels.loading;
                  }
                  if(labels.initializing)
                  {
                     this.labelInitializing = labels.initializing;
                  }
                  if(labels.error)
                  {
                     this.labelError = labels.error;
                  }
                  if(labels.config_error)
                  {
                     this.labelConfigError = labels.config_error;
                  }
                  if(labels.update_available)
                  {
                     this.labelUpdateAvailable = labels.update_available;
                  }
                  if(labels.update_required)
                  {
                     this.labelUpdateRequired = labels.update_required;
                  }
                  if(labels.update_button)
                  {
                     this.labelUpdateButton = labels.update_button;
                  }
                  if(labels.update_button_32)
                  {
                     this.labelUpdateButton32 = labels.update_button_32;
                  }
                  if(labels.update_button_64)
                  {
                     this.labelUpdateButton64 = labels.update_button_64;
                  }
                  if(labels.display_mode_header)
                  {
                     this.labelDisplayModeHeader = labels.display_mode_header;
                  }
                  if(labels.display_mode_mobile)
                  {
                     this.labelDisplayModeMobile = labels.display_mode_mobile;
                  }
                  if(labels.display_mode_desktop)
                  {
                     this.labelDisplayModeDesktop = labels.display_mode_desktop;
                  }
               }
            }
         }
         catch(e:*)
         {
            trace("Failed to parse launcher.json: " + e);
            onConfigError(null);
            return;
         }
         versionInfo = data.version;
         if(versionInfo)
         {
            this.latestVersion = versionInfo.latest || "";
            this.updateRequired = versionInfo.required === true;
            dl = versionInfo.downloads;
            if(dl)
            {
               this.downloadWindows = dl.windows || "";
               this.downloadArm = dl.android_arm || "";
               this.downloadArm64 = dl.android_arm64 || "";
            }
            cl = versionInfo.changelog as Array;
            if(Boolean(cl) && cl.length > 0)
            {
               this.changelog = cl.join("\n");
            }
         }
         if(!this.usingCachedConfig && this.latestVersion != "" && this.latestVersion != this.APP_VERSION)
         {
            this.showUpdateScreen();
            return;
         }
         this.activeCDN = this.selectedCDN;
         this.gameSWFUrl = this.DEV_MODE ? this.DEFAULT_SWF_URL : this.cdnOptions[this.activeCDN].url;
         this.startLoadingGame();
      }
      
      private function onConfigError(event:*) : void
      {
         var cachedText:String = null;
         try
         {
            this.configLoader.removeEventListener(Event.COMPLETE,this.onRemoteConfigLoaded);
            this.configLoader.removeEventListener(IOErrorEvent.IO_ERROR,this.onConfigError);
         }
         catch(e:*)
         {
         }
         ++this.launcherUrlIndex;
         if(this.launcherUrlIndex < this.LAUNCHER_URLS.length)
         {
            this.loadRemoteConfig();
            return;
         }
         if(!this.cachedConfigTried)
         {
            this.cachedConfigTried = true;
            cachedText = this.readCachedConfig();
            if(cachedText != null && cachedText.length > 0)
            {
               trace("[AIR_LOADER] launcher.json unreachable, falling back to the saved copy");
               this.usingCachedConfig = true;
               this.pendingConfigText = cachedText;
               this.onConfigLoaded(null);
               return;
            }
         }
         this.gameSWFUrl = this.DEFAULT_SWF_URL;
         this.cdnOptions = [{
            "label":"Server 1",
            "url":this.DEFAULT_SWF_URL,
            "value":this.DEFAULT_CDN_VALUE
         }];
         this.serverOptions = [{
            "label":"World",
            "value":this.DEFAULT_SERVER_VALUE
         }];
         this.langOptions = [{
            "label":"English",
            "value":"en"
         }];
         this.selectedCDN = 0;
         this.selectedServer = 0;
         this.selectedLang = 0;
         this.startLoadingGame();
      }
      
      private function createLoadingUI() : void
      {
         if(Boolean(this.progressText) && contains(this.progressText))
         {
            this.ensureSwitchServerBtn();
            return;
         }
         this.progressText = new TextField();
         this.progressText.autoSize = TextFieldAutoSize.CENTER;
         this.progressText.selectable = false;
         var format:TextFormat = new TextFormat("_sans",24,this.colorLoadingText,true);
         this.progressText.defaultTextFormat = format;
         this.progressText.text = this.labelLoading;
         addChild(this.progressText);
         this.ensureSwitchServerBtn();
         this.repositionUI();
      }
      
      private function ensureSwitchServerBtn() : void
      {
         if(this.DEV_MODE)
         {
            return;
         }
         if(!this.cdnOptions || this.cdnOptions.length < 2)
         {
            return;
         }
         if(Boolean(this.switchServerBtn) && contains(this.switchServerBtn))
         {
            return;
         }
         this.switchServerBtn = this.makeConfirmButton("Switch Server",220,44,this.colorButtonFill,this.colorButtonText,this.onSwitchServerClick);
         addChild(this.switchServerBtn);
         this.repositionUI();
      }
      
      private function getServerLabelForCDN(cdnIdx:int) : String
      {
         if(Boolean(this.serverOptions && cdnIdx >= 0) && Boolean(cdnIdx < this.serverOptions.length) && Boolean(this.serverOptions[cdnIdx]) && Boolean(this.serverOptions[cdnIdx].label))
         {
            return this.serverOptions[cdnIdx].label;
         }
         if(Boolean(this.cdnOptions && cdnIdx >= 0) && Boolean(cdnIdx < this.cdnOptions.length) && Boolean(this.cdnOptions[cdnIdx]) && Boolean(this.cdnOptions[cdnIdx].label))
         {
            return this.cdnOptions[cdnIdx].label;
         }
         return "Server " + (cdnIdx + 1);
      }
      
      private function currentAmfServer() : String
      {
         if(this.DEV_MODE || !this.serverOptions || this.serverOptions.length == 0)
         {
            return this.DEFAULT_SERVER_VALUE;
         }
         var idx:int = this.activeCDN;
         if(idx >= this.serverOptions.length)
         {
            idx = this.serverOptions.length - 1;
         }
         if(idx < 0)
         {
            idx = 0;
         }
         return Boolean(this.serverOptions[idx]) && Boolean(this.serverOptions[idx].value) ? String(this.serverOptions[idx].value) : this.DEFAULT_SERVER_VALUE;
      }
      
      private function onSwitchServerClick() : void
      {
         if(!this.cdnOptions || this.cdnOptions.length == 0)
         {
            return;
         }
         this.selectedCDN = (this.selectedCDN + 1) % this.cdnOptions.length;
         if(Boolean(this.serverOptions) && this.serverOptions.length > 0)
         {
            this.selectedServer = this.selectedCDN < this.serverOptions.length ? this.selectedCDN : int(this.serverOptions.length - 1);
         }
         this.savePreferences();
         trace("[AIR_LOADER] Switch Server -> idx=" + this.selectedCDN + " label=" + this.getServerLabelForCDN(this.selectedCDN));
         try
         {
            if(this.urlLoader)
            {
               try
               {
                  this.urlLoader.close();
               }
               catch(e1:*)
               {
               }
               try
               {
                  this.urlLoader.removeEventListener(ProgressEvent.PROGRESS,this.onProgress);
               }
               catch(e2:*)
               {
               }
               try
               {
                  this.urlLoader.removeEventListener(Event.COMPLETE,this.onDownloadComplete);
               }
               catch(e3:*)
               {
               }
               try
               {
                  this.urlLoader.removeEventListener(IOErrorEvent.IO_ERROR,this.onError);
               }
               catch(e4:*)
               {
               }
               this.urlLoader = null;
            }
         }
         catch(eX:*)
         {
         }
         this.gameSWFUrl = this.cdnOptions[this.selectedCDN].url;
         this.activeCDN = this.selectedCDN;
         if(this.progressText)
         {
            this.progressText.text = "Switching to " + this.getServerLabelForCDN(this.selectedCDN) + "...";
            this.repositionUI();
         }
         this.startLoadingGame();
      }
      
      private function startLoadingGame() : void
      {
         var finalUrl:String;
         this.ensureSwitchServerBtn();
         this.loader = new Loader();
         this.urlLoader = new URLLoader();
         this.urlLoader.dataFormat = URLLoaderDataFormat.BINARY;
         this.urlLoader.addEventListener(ProgressEvent.PROGRESS,this.onProgress);
         this.urlLoader.addEventListener(Event.COMPLETE,this.onDownloadComplete);
         this.urlLoader.addEventListener(IOErrorEvent.IO_ERROR,this.onError);
         finalUrl = this.gameSWFUrl + "?t=" + new Date().getTime();
         trace("[AIR_LOADER] Loading SWF: " + finalUrl);
         trace("[AIR_LOADER] DEV_MODE=" + this.DEV_MODE + " selectedCDN=" + this.selectedCDN + " selectedServer=" + this.selectedServer);
         trace("[AIR_LOADER] cdn param=" + (this.DEV_MODE ? this.DEFAULT_CDN_VALUE : (this.cdnOptions ? this.cdnOptions[this.selectedCDN].value : "null")));
         trace("[AIR_LOADER] server param=" + (this.DEV_MODE ? this.DEFAULT_SERVER_VALUE : (this.serverOptions ? this.serverOptions[this.selectedServer].value : "null")));
         try
         {
            this.urlLoader.load(new URLRequest(finalUrl));
         }
         catch(error:Error)
         {
            trace("[AIR_LOADER] ERROR loading: " + error.message);
            progressText.text = labelError;
            repositionUI();
         }
      }
      
      private function onDownloadComplete(event:Event) : void
      {
         if(this.progressText)
         {
            this.progressText.text = this.labelInitializing;
            this.repositionUI();
         }
         this.urlLoader.removeEventListener(ProgressEvent.PROGRESS,this.onProgress);
         this.urlLoader.removeEventListener(Event.COMPLETE,this.onDownloadComplete);
         this.urlLoader.removeEventListener(IOErrorEvent.IO_ERROR,this.onError);
         var swfBytes:ByteArray = this.urlLoader.data as ByteArray;
         var context:LoaderContext = new LoaderContext(false,ApplicationDomain.currentDomain,null);
         context.allowLoadBytesCodeExecution = true;
         var gameLang:String = this.langOptions[this.selectedLang].value;
         var supportedLangs:Array = ["en","zh","es","de","cn","pt","th"];
         if(supportedLangs.indexOf(gameLang) < 0)
         {
            gameLang = "en";
         }
         var activeServer:int = this.activeCDN;
         if(Boolean(this.serverOptions) && activeServer >= this.serverOptions.length)
         {
            activeServer = this.serverOptions.length - 1;
         }
         if(activeServer < 0)
         {
            activeServer = 0;
         }
         var selectedWebsite:String = this.DEFAULT_WEBSITE_VALUE;
         if(Boolean(!this.DEV_MODE) && Boolean(this.serverOptions) && Boolean(this.serverOptions[activeServer]) && Boolean(this.serverOptions[activeServer].website))
         {
            selectedWebsite = this.serverOptions[activeServer].website;
         }
         var cacheBust:Boolean = true;
         if(Boolean(!this.DEV_MODE) && Boolean(this.cdnOptions) && Boolean(this.cdnOptions[this.activeCDN]) && this.cdnOptions[this.activeCDN].cache_bust === false)
         {
            cacheBust = false;
         }
         context.parameters = {
            "lang":gameLang,
            "cdn":(this.DEV_MODE ? this.DEFAULT_CDN_VALUE : this.cdnOptions[this.activeCDN].value),
            "server":(this.DEV_MODE ? this.DEFAULT_SERVER_VALUE : this.serverOptions[activeServer].value),
            "website":selectedWebsite,
            "cache_bust":(cacheBust ? "1" : "0")
         };
         this.loader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onParseComplete);
         this.loader.loadBytes(swfBytes,context);
      }
      
      private function onParseComplete(event:Event) : void
      {
         this.loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.onParseComplete);
         this.isGameLoaded = true;
         this.logDiag("Game SWF parsed & loaded. Probing WebView...");
         this.probeWebView();
         if(Boolean(this.progressText) && contains(this.progressText))
         {
            removeChild(this.progressText);
            this.progressText = null;
         }
         if(Boolean(this.switchServerBtn) && contains(this.switchServerBtn))
         {
            removeChild(this.switchServerBtn);
            this.switchServerBtn = null;
         }
         var gameContent:DisplayObject = this.loader.content;
         this.gameHolder = new Sprite();
         this.gameHolder.addChild(gameContent);
         this.gameHolder.scrollRect = null;
         addChild(this.gameHolder);
         this.createToggleButton();
         if(this.showMenuButton)
         {
            this.createServerButton();
         }
         this.onResize(null);
      }
      
      private function showNotification(message:String) : void
      {
         var fmt:TextFormat = null;
         if(!this.notificationText)
         {
            this.notificationText = new TextField();
            this.notificationText.autoSize = TextFieldAutoSize.CENTER;
            this.notificationText.selectable = false;
            this.notificationText.mouseEnabled = false;
            fmt = new TextFormat("_sans",13,this.colorText,true);
            this.notificationText.defaultTextFormat = fmt;
            this.notificationText.background = true;
            this.notificationText.backgroundColor = this.colorBackground;
         }
         this.notificationText.text = "  " + message + "  ";
         if(!contains(this.notificationText))
         {
            addChild(this.notificationText);
         }
         this.notificationText.x = (stage.stageWidth - this.notificationText.width) / 2;
         this.notificationText.y = stage.stageHeight - 40;
         setTimeout(function():void
         {
            if(Boolean(notificationText) && contains(notificationText))
            {
               removeChild(notificationText);
            }
         },3000);
      }
      
      private function showRestartOverlay() : void
      {
         var overlay:Sprite = new Sprite();
         overlay.graphics.beginFill(this.colorRestartBg,0.85);
         overlay.graphics.drawRect(0,0,stage.stageWidth,stage.stageHeight);
         overlay.graphics.endFill();
         overlay.mouseEnabled = true;
         overlay.mouseChildren = true;
         var tf:TextField = new TextField();
         tf.autoSize = TextFieldAutoSize.CENTER;
         tf.selectable = false;
         tf.mouseEnabled = false;
         tf.defaultTextFormat = new TextFormat("_sans",28,this.colorRestartText,true);
         tf.text = this.labelRestart;
         tf.x = (stage.stageWidth - tf.width) / 2;
         tf.y = (stage.stageHeight - tf.height) / 2 - 20;
         overlay.addChild(tf);
         addChild(overlay);
      }
      
      private function showUpdateScreen() : void
      {
         var clTf:TextField = null;
         var winBtn:Sprite = null;
         var skipBtn:Sprite = null;
         var arm32Btn:Sprite = null;
         var arm64Btn:Sprite = null;
         var skipBtn2:Sprite = null;
         if(Boolean(this.progressText) && contains(this.progressText))
         {
            removeChild(this.progressText);
            this.progressText = null;
         }
         var overlay:Sprite = new Sprite();
         overlay.graphics.beginFill(this.colorUpdateBg);
         overlay.graphics.drawRect(0,0,stage.stageWidth,stage.stageHeight);
         overlay.graphics.endFill();
         overlay.mouseEnabled = true;
         overlay.mouseChildren = true;
         var panelW:Number = this.isDesktop() ? 520 : Math.min(stage.stageWidth * 0.85,700);
         var panelH:Number = this.isDesktop() ? 280 : Math.min(stage.stageHeight * 0.5,400);
         var panelX:Number = (stage.stageWidth - panelW) / 2;
         var panelY:Number = (stage.stageHeight - panelH) / 2;
         var panel:Sprite = new Sprite();
         panel.graphics.lineStyle(2,this.colorUpdatePanelBorder);
         panel.graphics.beginFill(this.colorUpdatePanel,0.95);
         panel.graphics.drawRoundRect(0,0,panelW,panelH,10,10);
         panel.graphics.endFill();
         panel.x = panelX;
         panel.y = panelY;
         overlay.addChild(panel);
         var title:TextField = new TextField();
         title.autoSize = TextFieldAutoSize.CENTER;
         title.selectable = false;
         title.mouseEnabled = false;
         title.defaultTextFormat = new TextFormat("_sans",this.isDesktop() ? 24 : 32,this.colorUpdateTitle,true);
         title.text = this.labelUpdateAvailable;
         title.x = (panelW - title.width) / 2;
         title.y = 25;
         panel.addChild(title);
         var desc:TextField = new TextField();
         desc.autoSize = TextFieldAutoSize.CENTER;
         desc.selectable = false;
         desc.mouseEnabled = false;
         desc.defaultTextFormat = new TextFormat("_sans",this.isDesktop() ? 13 : 18,this.colorUpdateText);
         desc.text = this.updateRequired ? this.labelUpdateRequired : this.labelUpdateRequired;
         desc.x = (panelW - desc.width) / 2;
         desc.y = 75;
         panel.addChild(desc);
         var clY:Number = desc.y + desc.textHeight + 15;
         if(this.changelog.length > 0)
         {
            clTf = new TextField();
            clTf.width = panelW - 60;
            clTf.wordWrap = true;
            clTf.multiline = true;
            clTf.selectable = false;
            clTf.mouseEnabled = false;
            clTf.defaultTextFormat = new TextFormat("_sans",this.isDesktop() ? 12 : 16,this.colorUpdateText);
            clTf.text = this.changelog;
            clTf.autoSize = TextFieldAutoSize.LEFT;
            clTf.x = 30;
            clTf.y = clY;
            panel.addChild(clTf);
            clY = clTf.y + clTf.textHeight + 15;
         }
         var btnY:Number = clY + 15;
         if(this.isDesktop())
         {
            winBtn = this.makeUpdateButton(this.labelUpdateButton,this.downloadWindows);
            winBtn.x = (panelW - 200) / 2;
            winBtn.y = btnY;
            panel.addChild(winBtn);
            if(!this.updateRequired)
            {
               skipBtn = this.makeSkipButton();
               skipBtn.x = (panelW - 100) / 2;
               skipBtn.y = btnY + 50;
               panel.addChild(skipBtn);
            }
         }
         else
         {
            arm32Btn = this.makeUpdateButton(this.labelUpdateButton32,this.downloadArm);
            arm32Btn.x = panelW / 2 - 210;
            arm32Btn.y = btnY;
            panel.addChild(arm32Btn);
            arm64Btn = this.makeUpdateButton(this.labelUpdateButton64,this.downloadArm64);
            arm64Btn.x = panelW / 2 + 10;
            arm64Btn.y = btnY;
            panel.addChild(arm64Btn);
            if(!this.updateRequired)
            {
               skipBtn2 = this.makeSkipButton();
               skipBtn2.x = (panelW - 100) / 2;
               skipBtn2.y = btnY + 50;
               panel.addChild(skipBtn2);
            }
         }
         addChild(overlay);
      }
      
      private function makeUpdateButton(label:String, url:String) : Sprite
      {
         var btnW:Number = NaN;
         var btnH:Number = NaN;
         var normalFill:uint = 0;
         var hoverFill:uint = 0;
         var normalText:uint = 0;
         var hoverText:uint = 0;
         var btn:Sprite = null;
         var tf:TextField = null;
         var downloadUrl:String = null;
         btnW = this.isDesktop() ? 200 : 280;
         btnH = this.isDesktop() ? 42 : 56;
         normalFill = this.colorButtonFill;
         hoverFill = this.colorButtonHoverFill;
         normalText = this.colorButtonText;
         hoverText = this.colorButtonHoverText;
         btn = new Sprite();
         btn.graphics.beginFill(normalFill);
         btn.graphics.drawRoundRect(0,0,btnW,btnH,6,6);
         btn.graphics.endFill();
         tf = new TextField();
         tf.autoSize = TextFieldAutoSize.CENTER;
         tf.selectable = false;
         tf.mouseEnabled = false;
         tf.defaultTextFormat = new TextFormat("_sans",this.isDesktop() ? 16 : 22,normalText,true);
         tf.text = label;
         tf.x = (btnW - tf.width) / 2;
         tf.y = (btnH - tf.height) / 2;
         btn.addChild(tf);
         btn.buttonMode = true;
         btn.mouseChildren = false;
         btn.addEventListener("rollOver",function(e:*):void
         {
            btn.graphics.clear();
            btn.graphics.beginFill(hoverFill);
            btn.graphics.drawRoundRect(0,0,btnW,btnH,6,6);
            btn.graphics.endFill();
            tf.defaultTextFormat = new TextFormat("_sans",isDesktop() ? 16 : 22,hoverText,true);
            tf.text = tf.text;
         });
         btn.addEventListener("rollOut",function(e:*):void
         {
            btn.graphics.clear();
            btn.graphics.beginFill(normalFill);
            btn.graphics.drawRoundRect(0,0,btnW,btnH,6,6);
            btn.graphics.endFill();
            tf.defaultTextFormat = new TextFormat("_sans",isDesktop() ? 16 : 22,normalText,true);
            tf.text = tf.text;
         });
         downloadUrl = url;
         btn.addEventListener("click",function(e:*):void
         {
            navigateToURL(new URLRequest(downloadUrl),"_blank");
            setTimeout(function():void
            {
               NativeApplication.nativeApplication.exit();
            },500);
         });
         return btn;
      }
      
      private function makeSkipButton() : Sprite
      {
         var tf:TextField;
         var btn:Sprite = null;
         btn = new Sprite();
         btn.graphics.beginFill(this.colorSkipFill);
         btn.graphics.drawRoundRect(0,0,100,30,6,6);
         btn.graphics.endFill();
         tf = new TextField();
         tf.autoSize = TextFieldAutoSize.CENTER;
         tf.selectable = false;
         tf.mouseEnabled = false;
         tf.defaultTextFormat = new TextFormat("_sans",12,this.colorSkipText);
         tf.text = "Skip";
         tf.x = (100 - tf.width) / 2;
         tf.y = (30 - tf.height) / 2;
         btn.addChild(tf);
         btn.buttonMode = true;
         btn.mouseChildren = false;
         btn.addEventListener("click",function(e:*):void
         {
            var p:Sprite = btn.parent as Sprite;
            if(Boolean(p) && Boolean(p.parent))
            {
               p.parent.removeChild(p);
            }
            createLoadingUI();
            activeCDN = selectedCDN;
            gameSWFUrl = DEV_MODE ? DEFAULT_SWF_URL : cdnOptions[activeCDN].url;
            startLoadingGame();
         });
         return btn;
      }
      
      private function createToggleButton() : void
      {
         this.toggleButton = new Sprite();
         this.updateButtonArrow();
         this.toggleButton.buttonMode = true;
         this.toggleButton.mouseEnabled = true;
         this.toggleButton.addEventListener("click",this.onViewToggle);
         addChild(this.toggleButton);
         this.positionToggleButton();
      }
      
      private function updateButtonArrow() : void
      {
         if(!this.toggleButton)
         {
            return;
         }
         this.toggleButton.graphics.clear();
         var bw:Number = this.layoutToggleW;
         var bh:Number = this.layoutToggleH;
         var lw:Number = this.layoutArrowThickness;
         var ax1:Number = bw * 0.36;
         var ax2:Number = bw * 0.64;
         var ay1:Number = bh * 0.3;
         var ayc:Number = bh * 0.5;
         var ay2:Number = bh * 0.7;
         var drawShape:Function = this.layoutSide == "left" ? this.drawRoundedRectRightOnly : this.drawRoundedRectLeftOnly;
         var expandFrom:Number = this.layoutSide == "left" ? ax1 : ax1;
         var expandTo:Number = this.layoutSide == "left" ? ax2 : ax2;
         if(this.isBoxedView)
         {
            this.toggleButton.graphics.beginFill(4008730,0.9);
            drawShape(this.toggleButton.graphics,0,0,bw,bh,12);
            this.toggleButton.graphics.endFill();
            this.toggleButton.graphics.lineStyle(lw,15238684,1);
            if(this.layoutSide == "left")
            {
               this.toggleButton.graphics.moveTo(ax2,ay1);
               this.toggleButton.graphics.lineTo(ax1,ayc);
               this.toggleButton.graphics.lineTo(ax2,ay2);
            }
            else
            {
               this.toggleButton.graphics.moveTo(ax1,ay1);
               this.toggleButton.graphics.lineTo(ax2,ayc);
               this.toggleButton.graphics.lineTo(ax1,ay2);
            }
         }
         else
         {
            this.toggleButton.graphics.beginFill(4008730,0.9);
            drawShape(this.toggleButton.graphics,0,0,bw,bh,12);
            this.toggleButton.graphics.endFill();
            this.toggleButton.graphics.lineStyle(lw,15238684,1);
            if(this.layoutSide == "left")
            {
               this.toggleButton.graphics.moveTo(ax1,ay1);
               this.toggleButton.graphics.lineTo(ax2,ayc);
               this.toggleButton.graphics.lineTo(ax1,ay2);
            }
            else
            {
               this.toggleButton.graphics.moveTo(ax2,ay1);
               this.toggleButton.graphics.lineTo(ax1,ayc);
               this.toggleButton.graphics.lineTo(ax2,ay2);
            }
         }
      }
      
      private function drawRoundedRectRightOnly(g:Graphics, x:Number, y:Number, w:Number, h:Number, r:Number) : void
      {
         g.moveTo(x,y);
         g.lineTo(x + w - r,y);
         g.curveTo(x + w,y,x + w,y + r);
         g.lineTo(x + w,y + h - r);
         g.curveTo(x + w,y + h,x + w - r,y + h);
         g.lineTo(x,y + h);
         g.lineTo(x,y);
      }
      
      private function drawRoundedRectLeftOnly(g:Graphics, x:Number, y:Number, w:Number, h:Number, r:Number) : void
      {
         g.moveTo(x + r,y);
         g.lineTo(x + w,y);
         g.lineTo(x + w,y + h);
         g.lineTo(x + r,y + h);
         g.curveTo(x,y + h,x,y + h - r);
         g.lineTo(x,y + r);
         g.curveTo(x,y,x + r,y);
      }
      
      private function positionToggleButton() : void
      {
         if(!this.toggleButton || !stage)
         {
            return;
         }
         var totalH:Number = this.layoutToggleH + (this.serverButton ? this.layoutGap + this.layoutSettingsH : 0);
         var startY:Number = (stage.stageHeight - totalH) / 2;
         this.toggleButton.x = this.layoutSide == "left" ? 0 : stage.stageWidth - this.layoutToggleW;
         this.toggleButton.y = startY;
      }
      
      private function onViewToggle(event:*) : void
      {
         this.isBoxedView = !this.isBoxedView;
         this.savePreferences();
         this.updateButtonArrow();
         this.onResize(null);
      }
      
      private function createServerButton() : void
      {
         this.serverButton = new Sprite();
         var g:Graphics = this.serverButton.graphics;
         g.beginFill(4008730,0.9);
         if(this.layoutSide == "left")
         {
            this.drawRoundedRectRightOnly(g,0,0,this.layoutSettingsW,this.layoutSettingsH,12);
         }
         else
         {
            this.drawRoundedRectLeftOnly(g,0,0,this.layoutSettingsW,this.layoutSettingsH,12);
         }
         g.endFill();
         var cx:Number = this.layoutSettingsW / 2;
         var cy:Number = this.layoutSettingsH / 2;
         var lineW:Number = 30;
         var lineH:Number = 4;
         var lineGap:Number = 8;
         var totalH:Number = lineH * 3 + lineGap * 2;
         var lineX:Number = cx - lineW / 2;
         var lineYStart:Number = cy - totalH / 2;
         g.beginFill(15238684);
         for(var li:int = 0; li < 3; li++)
         {
            g.drawRoundRect(lineX,lineYStart + li * (lineH + lineGap),lineW,lineH,2);
         }
         g.endFill();
         this.serverButton.buttonMode = true;
         this.serverButton.mouseChildren = false;
         this.serverButton.addEventListener("click",this.onServerButtonClick);
         addChild(this.serverButton);
         this.positionServerButton();
      }
      
      private function positionServerButton() : void
      {
         if(!this.serverButton || !stage)
         {
            return;
         }
         this.serverButton.x = this.layoutSide == "left" ? 0 : stage.stageWidth - this.layoutSettingsW;
         if(this.toggleButton)
         {
            this.serverButton.y = this.toggleButton.y + this.layoutToggleH + this.layoutGap;
         }
         else
         {
            this.serverButton.y = (stage.stageHeight - this.layoutSettingsH) / 2;
         }
      }
      
      private function onServerButtonClick(event:*) : void
      {
         if(this.isServerMenuOpen)
         {
            this.closeServerMenu();
         }
         else
         {
            this.openServerMenu();
         }
      }
      
      private function setWebViewVisible(visible:Boolean) : void
      {
         var wv:Object = null;
         try
         {
            wv = WebView["shared"]();
            if(Boolean(wv) && Boolean(stage))
            {
               if(visible)
               {
                  wv.viewPort = new Rectangle(0,0,stage.stageWidth,stage.stageHeight);
               }
               else
               {
                  wv.viewPort = new Rectangle(0,-stage.stageHeight,stage.stageWidth,stage.stageHeight);
               }
            }
         }
         catch(e:*)
         {
         }
      }
      
      private function isWebViewVisible() : Boolean
      {
         var wv:Object = null;
         try
         {
            wv = WebView["shared"]();
            if(Boolean(wv) && Boolean(wv.viewPort))
            {
               return wv.viewPort.y >= 0;
            }
         }
         catch(e:*)
         {
         }
         return false;
      }
      
      private function openServerMenu() : void
      {
         var i:int = 0;
         var cdnHeader:TextField = null;
         var cdnLabel:String = null;
         var cdnItem:Sprite = null;
         var srvHeader:TextField = null;
         var srvLabel:String = null;
         var srvItem:Sprite = null;
         var langHeader:TextField = null;
         var langItem:Sprite = null;
         var modeHeader:TextField = null;
         var mobileItem:Sprite = null;
         var desktopItem:Sprite = null;
         var gameHeader:TextField = null;
         var menuItem:Sprite = null;
         var charSelectItem:Sprite = null;
         var logoutItem:Sprite = null;
         if(!this.cdnOptions || !this.serverOptions)
         {
            return;
         }
         this.webViewWasVisibleBeforeMenu = this.isWebViewVisible();
         if(this.isGameLoaded)
         {
            this.setWebViewVisible(false);
         }
         this.menuOverlay = new Sprite();
         this.menuOverlay.graphics.beginFill(0,0);
         this.menuOverlay.graphics.drawRect(0,0,stage.stageWidth,stage.stageHeight);
         this.menuOverlay.graphics.endFill();
         this.menuOverlay.addEventListener("click",this.onOverlayClick);
         addChild(this.menuOverlay);
         var menuW:Number = this.layoutMenuW;
         var itemH:Number = this.layoutMenuItemH;
         var headerH:Number = this.layoutMenuHeaderH;
         var pad:Number = 6;
         var sepH:Number = 1;
         var sections:int = (this.showCDN ? 1 : 0) + (this.showServers ? 1 : 0) + (this.showLanguages ? 1 : 0);
         var totalH:Number = pad;
         if(this.showCDN)
         {
            totalH += headerH + this.cdnOptions.length * itemH;
         }
         if(this.showCDN && (this.showServers || this.showLanguages))
         {
            totalH += pad + sepH + pad;
         }
         if(this.showServers)
         {
            totalH += headerH + this.serverOptions.length * itemH;
         }
         if(this.showServers && this.showLanguages)
         {
            totalH += pad + sepH + pad;
         }
         if(this.showLanguages)
         {
            totalH += headerH + this.langOptions.length * itemH;
         }
         if(this.showDisplayMode && (this.showCDN || this.showServers || this.showLanguages))
         {
            totalH += pad + sepH + pad;
         }
         if(this.showDisplayMode)
         {
            totalH += headerH + 2 * itemH;
         }
         if(this.isGameLoaded)
         {
            totalH += pad + sepH + pad + headerH + 3 * itemH;
         }
         totalH += pad;
         this.serverMenu = new Sprite();
         this.serverMenu.graphics.beginFill(this.colorBackground,0.95);
         this.serverMenu.graphics.lineStyle(1,this.colorBorder);
         this.serverMenu.graphics.drawRoundRect(0,0,menuW,totalH,8,8);
         this.serverMenu.graphics.endFill();
         var yPos:Number = pad;
         if(this.showCDN)
         {
            cdnHeader = this.makeMenuLabel(this.labelCDN,this.layoutMenuHeaderFont,this.colorHeader);
            cdnHeader.x = 10;
            cdnHeader.y = yPos;
            this.serverMenu.addChild(cdnHeader);
            yPos += headerH;
            for(i = 0; i < this.cdnOptions.length; i++)
            {
               cdnLabel = this.cdnOptions[i].display_label != null ? this.cdnOptions[i].display_label : this.cdnOptions[i].label;
               cdnItem = this.makeMenuItem(cdnLabel,menuW,itemH,i == this.selectedCDN);
               cdnItem.y = yPos;
               cdnItem.name = "cdn_" + String(i);
               cdnItem.addEventListener("click",this.onMenuCDNClick);
               this.serverMenu.addChild(cdnItem);
               yPos += itemH;
            }
         }
         if(this.showCDN && (this.showServers || this.showLanguages))
         {
            yPos += pad;
            this.serverMenu.graphics.lineStyle(0,this.colorBorder);
            this.serverMenu.graphics.moveTo(10,yPos);
            this.serverMenu.graphics.lineTo(menuW - 10,yPos);
            yPos += sepH + pad;
         }
         if(this.showServers)
         {
            srvHeader = this.makeMenuLabel(this.labelServer,this.layoutMenuHeaderFont,this.colorHeader);
            srvHeader.x = 10;
            srvHeader.y = yPos;
            this.serverMenu.addChild(srvHeader);
            yPos += headerH;
         }
         if(this.showServers)
         {
            for(i = 0; i < this.serverOptions.length; i++)
            {
               srvLabel = this.serverOptions[i].display_label != null ? this.serverOptions[i].display_label : this.serverOptions[i].label;
               srvItem = this.makeMenuItem(srvLabel,menuW,itemH,i == this.selectedServer);
               srvItem.y = yPos;
               srvItem.name = "srv_" + String(i);
               srvItem.addEventListener("click",this.onMenuServerClick);
               this.serverMenu.addChild(srvItem);
               yPos += itemH;
            }
         }
         if(this.showLanguages && (this.showCDN || this.showServers))
         {
            if(this.showServers)
            {
               yPos += pad;
               this.serverMenu.graphics.lineStyle(0,this.colorBorder);
               this.serverMenu.graphics.moveTo(10,yPos);
               this.serverMenu.graphics.lineTo(menuW - 10,yPos);
               yPos += sepH + pad;
            }
         }
         if(this.showLanguages)
         {
            langHeader = this.makeMenuLabel(this.labelLanguage,this.layoutMenuHeaderFont,this.colorHeader);
            langHeader.x = 10;
            langHeader.y = yPos;
            this.serverMenu.addChild(langHeader);
            yPos += headerH;
            for(i = 0; i < this.langOptions.length; i++)
            {
               langItem = this.makeMenuItem(this.langOptions[i].label,menuW,itemH,i == this.selectedLang);
               langItem.y = yPos;
               langItem.name = "lang_" + String(i);
               langItem.addEventListener("click",this.onMenuLangClick);
               this.serverMenu.addChild(langItem);
               yPos += itemH;
            }
         }
         if(this.showDisplayMode && (this.showCDN || this.showServers || this.showLanguages))
         {
            yPos += pad;
            this.serverMenu.graphics.lineStyle(0,this.colorBorder);
            this.serverMenu.graphics.moveTo(10,yPos);
            this.serverMenu.graphics.lineTo(menuW - 10,yPos);
            yPos += sepH + pad;
         }
         if(this.showDisplayMode)
         {
            modeHeader = this.makeMenuLabel(this.labelDisplayModeHeader,this.layoutMenuHeaderFont,this.colorHeader);
            modeHeader.x = 10;
            modeHeader.y = yPos;
            this.serverMenu.addChild(modeHeader);
            yPos += headerH;
            mobileItem = this.makeMenuItem(this.labelDisplayModeMobile,menuW,itemH,!this.isDesktopMode);
            mobileItem.y = yPos;
            mobileItem.name = "mode_0";
            mobileItem.addEventListener("click",this.onMenuModeClick);
            this.serverMenu.addChild(mobileItem);
            yPos += itemH;
            desktopItem = this.makeMenuItem(this.labelDisplayModeDesktop,menuW,itemH,this.isDesktopMode);
            desktopItem.y = yPos;
            desktopItem.name = "mode_1";
            desktopItem.addEventListener("click",this.onMenuModeClick);
            this.serverMenu.addChild(desktopItem);
            yPos += itemH;
         }
         if(this.isGameLoaded)
         {
            yPos += pad;
            this.serverMenu.graphics.lineStyle(0,this.colorBorder);
            this.serverMenu.graphics.moveTo(10,yPos);
            this.serverMenu.graphics.lineTo(menuW - 10,yPos);
            yPos += sepH + pad;
            gameHeader = this.makeMenuLabel("Game",this.layoutMenuHeaderFont,this.colorHeader);
            gameHeader.x = 10;
            gameHeader.y = yPos;
            this.serverMenu.addChild(gameHeader);
            yPos += headerH;
            menuItem = this.makeMenuItem("Menu",menuW,itemH,false);
            menuItem.y = yPos;
            menuItem.name = "openpopup";
            menuItem.addEventListener("click",this.onOpenGamePopup);
            this.serverMenu.addChild(menuItem);
            yPos += itemH;
            charSelectItem = this.makeMenuItem("Character Select",menuW,itemH,false);
            charSelectItem.y = yPos;
            charSelectItem.name = "game_show_char_select";
            charSelectItem.addEventListener("click",this.onMenuGameClick);
            this.serverMenu.addChild(charSelectItem);
            yPos += itemH;
            logoutItem = this.makeMenuItem("Log Out",menuW,itemH,false);
            logoutItem.y = yPos;
            logoutItem.name = "game_logout";
            logoutItem.addEventListener("click",this.onMenuGameClick);
            this.serverMenu.addChild(logoutItem);
            yPos += itemH;
         }
         if(this.layoutSide == "left")
         {
            this.serverMenu.x = this.layoutSettingsW + 10;
         }
         else
         {
            this.serverMenu.x = stage.stageWidth - this.layoutSettingsW - menuW - 10;
         }
         this.serverMenu.y = (stage.stageHeight - totalH) / 2;
         addChild(this.serverMenu);
         this.isServerMenuOpen = true;
      }
      
      private function makeMenuLabel(text:String, size:int, color:uint) : TextField
      {
         var tf:TextField = new TextField();
         tf.autoSize = TextFieldAutoSize.LEFT;
         tf.selectable = false;
         tf.mouseEnabled = false;
         tf.defaultTextFormat = new TextFormat("_sans",size,color,true);
         tf.text = text;
         return tf;
      }
      
      private function makeMenuItem(label:String, w:Number, h:Number, selected:Boolean) : Sprite
      {
         var item:Sprite = new Sprite();
         item.graphics.beginFill(0,0);
         item.graphics.drawRect(0,0,w,h);
         item.graphics.endFill();
         if(selected)
         {
            item.graphics.beginFill(this.colorSelected);
            item.graphics.drawRect(4,0,w - 8,h);
            item.graphics.endFill();
         }
         var dotR:Number = this.layoutDotRadius;
         var dotX:Number = dotR * 2 + 14;
         var textX:Number = dotX + dotR + 8;
         var fontSize:int = this.layoutMenuItemFont;
         item.graphics.beginFill(selected ? this.colorText : this.colorBorder);
         item.graphics.drawCircle(dotX,h / 2,dotR);
         item.graphics.endFill();
         var tf:TextField = new TextField();
         tf.autoSize = TextFieldAutoSize.LEFT;
         tf.selectable = false;
         tf.mouseEnabled = false;
         tf.defaultTextFormat = new TextFormat("_sans",fontSize,this.colorText);
         tf.text = label;
         tf.x = textX;
         tf.y = (h - tf.textHeight) / 2 - 2;
         item.addChild(tf);
         item.buttonMode = true;
         item.mouseChildren = false;
         return item;
      }
      
      private function onMenuCDNClick(event:*) : void
      {
         var idx:int = int(event.currentTarget.name.split("_")[1]);
         if(idx == this.selectedCDN && idx == this.selectedServer)
         {
            this.closeServerMenu();
            return;
         }
         this.selectedCDN = idx;
         if(Boolean(this.serverOptions) && this.serverOptions.length > 0)
         {
            this.selectedServer = idx < this.serverOptions.length ? idx : int(this.serverOptions.length - 1);
         }
         this.closeServerMenu();
         this.savePreferences();
         this.showRestartOverlay();
      }
      
      private function onMenuServerClick(event:*) : void
      {
         var idx:int = int(event.currentTarget.name.split("_")[1]);
         if(idx == this.selectedServer && idx == this.selectedCDN)
         {
            this.closeServerMenu();
            return;
         }
         this.selectedServer = idx;
         if(Boolean(this.cdnOptions) && this.cdnOptions.length > 0)
         {
            this.selectedCDN = idx < this.cdnOptions.length ? idx : int(this.cdnOptions.length - 1);
         }
         this.closeServerMenu();
         this.savePreferences();
         this.showRestartOverlay();
      }
      
      private function onMenuLangClick(event:*) : void
      {
         var idx:int = int(event.currentTarget.name.split("_")[1]);
         if(idx == this.selectedLang)
         {
            this.closeServerMenu();
            return;
         }
         this.selectedLang = idx;
         this.closeServerMenu();
         this.savePreferences();
         this.showRestartOverlay();
      }
      
      private function onMenuModeClick(event:*) : void
      {
         var idx:int = int(event.currentTarget.name.split("_")[1]);
         var newMode:Boolean = idx == 1;
         if(newMode == this.isDesktopMode)
         {
            this.closeServerMenu();
            return;
         }
         this.isDesktopMode = newMode;
         this.viewportHeight = this.isDesktopMode ? this.VIEWPORT_HEIGHT_DESKTOP : this.VIEWPORT_HEIGHT_MOBILE;
         this.closeServerMenu();
         this.savePreferences();
         this.showRestartOverlay();
      }
      
      private function onMenuGameClick(event:*) : void
      {
         var action:String = null;
         var nsAct:Object = null;
         action = String(event.currentTarget.name).substr(5);
         trace("[GameMenu] click action=" + action);
         this.closeServerMenu();
         if(action == "logout")
         {
            this.showConfirm("Log Out","Are you sure you want to log out?",this.doLogout);
            return;
         }
         if(action == "show_char_select")
         {
            this.showConfirm("Character Select","Return to character selection?",this.gotoSelchar);
            return;
         }
         try
         {
            if(Boolean(this.loader) && Boolean(this.loader.content))
            {
               nsAct = this.findNinjaSaga(this.loader.content as DisplayObjectContainer);
               if(nsAct)
               {
                  nsAct.showWebView({"action":action});
                  trace("[GameMenu] dispatched via ns.showWebView action=" + action);
                  return;
               }
            }
         }
         catch(e:*)
         {
            trace("[GameMenu] ns.showWebView err: " + e + " — falling back");
         }
         if(this.isGameLoaded)
         {
            this.setWebViewVisible(true);
         }
         setTimeout(function():void
         {
            var wv:Object = null;
            var msg:Object = null;
            var js:String = null;
            try
            {
               wv = WebView["shared"]();
               if(wv)
               {
                  msg = {
                     "action":action,
                     "server":currentAmfServer()
                  };
                  js = "(function(){try{var m=" + JSON.stringify(msg) + ";window.postMessage(m,\'*\');if(window.parent)window.parent.postMessage(m,\'*\');}catch(e){}})();";
                  wv.callJavascriptFunction("eval",null,js);
               }
            }
            catch(e:*)
            {
               trace("[GameMenu] ERROR: " + e);
            }
         },200);
      }
      
      private function gotoSelchar() : void
      {
         var MainCls:Class = null;
         var ns:Object = null;
         trace("[GameMenu] gotoSelchar");
         this.setWebViewVisible(false);
         try
         {
            MainCls = null;
            try
            {
               MainCls = getDefinitionByName("ninjasaga.Main") as Class;
            }
            catch(e:*)
            {
            }
            if(MainCls)
            {
               try
               {
                  MainCls["checkAmf"]();
                  trace("[GameMenu] Main.checkAmf() called");
                  return;
               }
               catch(e:*)
               {
                  trace("[GameMenu] Main.checkAmf err: " + e + " — falling back to direct gotoSelchar");
               }
            }
            if(Boolean(this.loader) && Boolean(this.loader.content))
            {
               ns = this.findNinjaSaga(this.loader.content as DisplayObjectContainer);
               if(ns)
               {
                  ns.gotoSelchar();
                  trace("[GameMenu] gotoSelchar called on " + ns);
               }
               else
               {
                  trace("[GameMenu] gotoSelchar: NinjaSaga instance not found in tree");
               }
            }
            else
            {
               trace("[GameMenu] gotoSelchar: loader.content null");
            }
         }
         catch(e:*)
         {
            trace("[GameMenu] gotoSelchar err: " + e);
         }
      }
      
      private function findNinjaSaga(container:DisplayObjectContainer) : Object
      {
         var i:int;
         var child:DisplayObject = null;
         var found:Object = null;
         if(!container)
         {
            return null;
         }
         if(this.isNinjaSaga(container))
         {
            return container;
         }
         for(i = 0; i < container.numChildren; i++)
         {
            child = null;
            try
            {
               child = container.getChildAt(i);
            }
            catch(e:*)
            {
               continue;
            }
            if(child)
            {
               if(this.isNinjaSaga(child))
               {
                  return child;
               }
               if(child is DisplayObjectContainer)
               {
                  found = this.findNinjaSaga(DisplayObjectContainer(child));
                  if(found)
                  {
                     return found;
                  }
               }
            }
         }
         return null;
      }
      
      private function isNinjaSaga(obj:Object) : Boolean
      {
         var qn:String = null;
         if(!obj)
         {
            return false;
         }
         try
         {
            qn = getQualifiedClassName(obj);
            if(qn == "NinjaSaga")
            {
               return true;
            }
         }
         catch(e:*)
         {
         }
         return false;
      }
      
      private function showConfirm(title:String, message:String, onYes:Function) : void
      {
         var panelW:Number;
         var panelH:Number;
         var panel:Sprite;
         var titleTf:TextField;
         var msgTf:TextField;
         var btnW:Number;
         var btnH:Number;
         var btnY:Number;
         var gap:Number;
         var totalBtnW:Number;
         var startX:Number;
         var yesBtn:Sprite;
         var noBtn:Sprite;
         this.closeConfirm();
         if(this.isGameLoaded)
         {
            this.setWebViewVisible(false);
         }
         this.confirmOverlay = new Sprite();
         this.confirmOverlay.graphics.beginFill(0,0.7);
         this.confirmOverlay.graphics.drawRect(0,0,stage.stageWidth,stage.stageHeight);
         this.confirmOverlay.graphics.endFill();
         this.confirmOverlay.mouseEnabled = true;
         this.confirmOverlay.mouseChildren = true;
         panelW = 540;
         panelH = 260;
         panel = new Sprite();
         panel.graphics.lineStyle(2,this.colorBorder);
         panel.graphics.beginFill(3023640,0.98);
         panel.graphics.drawRoundRect(0,0,panelW,panelH,14,14);
         panel.graphics.endFill();
         panel.x = (stage.stageWidth - panelW) / 2;
         panel.y = (stage.stageHeight - panelH) / 2;
         this.confirmOverlay.addChild(panel);
         titleTf = new TextField();
         titleTf.autoSize = TextFieldAutoSize.CENTER;
         titleTf.selectable = false;
         titleTf.mouseEnabled = false;
         titleTf.defaultTextFormat = new TextFormat("_sans",28,15238684,true);
         titleTf.text = title;
         titleTf.x = (panelW - titleTf.width) / 2;
         titleTf.y = 26;
         panel.addChild(titleTf);
         msgTf = new TextField();
         msgTf.autoSize = TextFieldAutoSize.CENTER;
         msgTf.selectable = false;
         msgTf.mouseEnabled = false;
         msgTf.defaultTextFormat = new TextFormat("_sans",20,13417386);
         msgTf.text = message;
         msgTf.x = (panelW - msgTf.width) / 2;
         msgTf.y = 90;
         panel.addChild(msgTf);
         btnW = 200;
         btnH = 70;
         btnY = panelH - btnH - 26;
         gap = 28;
         totalBtnW = btnW * 2 + gap;
         startX = (panelW - totalBtnW) / 2;
         yesBtn = this.makeConfirmButton("Yes",btnW,btnH,this.colorButtonFill,16777215,function():void
         {
            if(Boolean(confirmOverlay) && contains(confirmOverlay))
            {
               removeChild(confirmOverlay);
            }
            confirmOverlay = null;
            try
            {
               if(onYes != null)
               {
                  onYes();
               }
            }
            catch(e:*)
            {
               trace("[Confirm] onYes err: " + e);
            }
         });
         yesBtn.x = startX;
         yesBtn.y = btnY;
         panel.addChild(yesBtn);
         noBtn = this.makeConfirmButton("No",btnW,btnH,4473924,13421772,this.closeConfirm);
         noBtn.x = startX + btnW + gap;
         noBtn.y = btnY;
         panel.addChild(noBtn);
         addChild(this.confirmOverlay);
      }
      
      private function makeConfirmButton(label:String, w:Number, h:Number, fill:uint, textColor:uint, onClick:Function) : Sprite
      {
         var tf:TextField;
         var btn:Sprite = new Sprite();
         btn.graphics.beginFill(fill);
         btn.graphics.drawRoundRect(0,0,w,h,10,10);
         btn.graphics.endFill();
         tf = new TextField();
         tf.autoSize = TextFieldAutoSize.CENTER;
         tf.selectable = false;
         tf.mouseEnabled = false;
         tf.defaultTextFormat = new TextFormat("_sans",24,textColor,true);
         tf.text = label;
         tf.x = (w - tf.width) / 2;
         tf.y = (h - tf.height) / 2 - 2;
         btn.addChild(tf);
         btn.buttonMode = true;
         btn.mouseChildren = false;
         btn.addEventListener("click",function(e:*):void
         {
            if(onClick != null)
            {
               onClick();
            }
         });
         return btn;
      }
      
      private function closeConfirm(... rest) : void
      {
         if(Boolean(this.confirmOverlay) && contains(this.confirmOverlay))
         {
            removeChild(this.confirmOverlay);
         }
         this.confirmOverlay = null;
      }
      
      private function doLogout() : void
      {
         var loginWebsite:String;
         var loginUrl:String;
         var ns:Object = null;
         var nsLogout:Object = null;
         var wv:Object = null;
         var jsLoginUrl:String = null;
         var js:String = null;
         trace("[GameMenu] doLogout");
         try
         {
            if(Boolean(this.loader) && Boolean(this.loader.content))
            {
               ns = this.findNinjaSaga(this.loader.content as DisplayObjectContainer);
               if(ns)
               {
                  try
                  {
                     ns.gotoSelchar();
                     trace("[GameMenu] doLogout: ns.gotoSelchar() called");
                  }
                  catch(e:*)
                  {
                     trace("[GameMenu] doLogout gotoSelchar err: " + e);
                  }
               }
            }
         }
         catch(e:*)
         {
            trace("[GameMenu] doLogout swf reset err: " + e);
         }
         if(this.isGameLoaded)
         {
            this.setWebViewVisible(true);
         }
         loginWebsite = this.DEFAULT_WEBSITE_VALUE;
         if(Boolean(!this.DEV_MODE) && Boolean(this.serverOptions) && Boolean(this.serverOptions[this.selectedServer]) && Boolean(this.serverOptions[this.selectedServer].website))
         {
            loginWebsite = this.serverOptions[this.selectedServer].website;
         }
         loginUrl = loginWebsite + "?minimal&air&noreauth=1&server=" + encodeURIComponent(this.currentAmfServer());
         try
         {
            if(Boolean(this.loader) && Boolean(this.loader.content))
            {
               nsLogout = this.findNinjaSaga(this.loader.content as DisplayObjectContainer);
               if(nsLogout)
               {
                  nsLogout.showWebView({"action":"logout"});
                  trace("[GameMenu] doLogout: dispatched via ns.showWebView");
               }
            }
         }
         catch(e:*)
         {
            trace("[GameMenu] doLogout ns.showWebView err: " + e);
         }
         try
         {
            wv = WebView["shared"]();
            if(wv)
            {
               try
               {
                  wv.deleteCookies();
               }
               catch(e:*)
               {
               }
               jsLoginUrl = loginUrl.replace(/'/g,"\\\'");
               js = "(function(){var done=false;var go=function(){if(done)return;done=true;try{localStorage.clear();}catch(e){}try{sessionStorage.clear();}catch(e){}try{document.cookie.split(\';\').forEach(function(c){var n=c.split(\'=\')[0].trim();document.cookie=n+\'=;expires=Thu, 01 Jan 1970 00:00:00 GMT;path=/\';document.cookie=n+\'=;expires=Thu, 01 Jan 1970 00:00:00 GMT;path=/;domain=\'+location.hostname;});}catch(e){}window.location.replace(\'" + jsLoginUrl + "\');};try{var ctrl=new AbortController();setTimeout(function(){try{ctrl.abort();}catch(e){}go();},800);fetch(\'./api.php/logout\',{method:\'POST\',credentials:\'include\',signal:ctrl.signal}).then(go).catch(go);}catch(e){go();}})();";
               wv.callJavascriptFunction("eval",null,js);
            }
         }
         catch(e:*)
         {
            trace("[GameMenu] doLogout err: " + e);
         }
      }
      
      private function onOverlayClick(event:*) : void
      {
         this.closeServerMenu();
      }
      
      private function closeServerMenu() : void
      {
         if(Boolean(this.menuOverlay) && contains(this.menuOverlay))
         {
            this.menuOverlay.removeEventListener("click",this.onOverlayClick);
            removeChild(this.menuOverlay);
            this.menuOverlay = null;
         }
         if(Boolean(this.serverMenu) && contains(this.serverMenu))
         {
            removeChild(this.serverMenu);
            this.serverMenu = null;
         }
         this.isServerMenuOpen = false;
         if(this.isGameLoaded && this.webViewWasVisibleBeforeMenu)
         {
            this.setWebViewVisible(true);
         }
      }
      
      private function onOpenGamePopup(event:*) : void
      {
         trace("[GamePopup] onOpenGamePopup fired isGameLoaded=" + this.isGameLoaded + " stage=" + (stage != null));
         this.closeServerMenu();
         try
         {
            this.openGameMenuPopup();
         }
         catch(e:*)
         {
            trace("[GamePopup] open err: " + e);
         }
      }
      
      private function openGameMenuPopup() : void
      {
         var btn:Sprite = null;
         this.closeGamePopup();
         if(this.isGameLoaded)
         {
            this.setWebViewVisible(false);
         }
         var gameOptions:Array = [{
            "label":"Store",
            "action":"show_store"
         },{
            "label":"Friends",
            "action":"show_friends"
         },{
            "label":"Clans",
            "action":"show_clans"
         },{
            "label":"Referral",
            "action":"show_referrals"
         },{
            "label":"Support",
            "action":"show_support"
         },{
            "label":"Settings",
            "action":"show_settings"
         }];
         var btnH:Number = 70;
         var btnFont:int = 22;
         var titleH:Number = 50;
         var pad:Number = 24;
         var gap:Number = 10;
         var popupW:Number = 420;
         var popupH:Number = pad + titleH + gameOptions.length * btnH + gameOptions.length * gap + btnH + pad;
         this.gamePopup = new Sprite();
         this.gamePopup.mouseEnabled = true;
         this.gamePopup.mouseChildren = true;
         var overlay:Sprite = new Sprite();
         overlay.graphics.beginFill(0,0.7);
         overlay.graphics.drawRect(0,0,stage.stageWidth,stage.stageHeight);
         overlay.graphics.endFill();
         overlay.mouseEnabled = true;
         overlay.mouseChildren = false;
         overlay.addEventListener("click",this.onCloseGamePopup);
         this.gamePopup.addChild(overlay);
         var panel:Sprite = new Sprite();
         panel.graphics.lineStyle(2,this.colorBorder);
         panel.graphics.beginFill(3023640,0.98);
         panel.graphics.drawRoundRect(0,0,popupW,popupH,14,14);
         panel.graphics.endFill();
         panel.x = (stage.stageWidth - popupW) / 2;
         panel.y = (stage.stageHeight - popupH) / 2;
         panel.mouseEnabled = true;
         panel.mouseChildren = true;
         this.gamePopup.addChild(panel);
         var titleTf:TextField = new TextField();
         titleTf.autoSize = TextFieldAutoSize.CENTER;
         titleTf.selectable = false;
         titleTf.mouseEnabled = false;
         titleTf.defaultTextFormat = new TextFormat("_sans",26,15238684,true);
         titleTf.text = "Menu";
         titleTf.x = (popupW - titleTf.width) / 2;
         titleTf.y = pad - 4;
         panel.addChild(titleTf);
         var yPos:Number = pad + titleH;
         for(var i:int = 0; i < gameOptions.length; i++)
         {
            btn = this.makePopupButton(gameOptions[i].label,popupW - pad * 2,btnH,btnFont,this.colorButtonFill,16777215);
            btn.x = pad;
            btn.y = yPos;
            btn.name = "game_" + gameOptions[i].action;
            btn.addEventListener("click",this.onPopupGameClick);
            btn.mouseEnabled = true;
            panel.addChild(btn);
            trace("[GamePopup] btn \'" + gameOptions[i].label + "\' name=" + btn.name + " at " + btn.x + "," + btn.y + " size=" + (popupW - pad * 2) + "x" + btnH + " hasListener=" + btn.hasEventListener("click"));
            yPos += btnH + gap;
         }
         yPos += gap;
         var closeBtn:Sprite = this.makePopupButton("Close",popupW - pad * 2,btnH,btnFont,4473924,13421772);
         closeBtn.x = pad;
         closeBtn.y = yPos;
         closeBtn.addEventListener("click",this.onCloseGamePopup);
         panel.addChild(closeBtn);
         addChild(this.gamePopup);
         trace("[GamePopup] rendered popupW=" + popupW + " popupH=" + popupH + " stageW=" + stage.stageWidth + " stageH=" + stage.stageHeight + " panelXY=" + panel.x + "," + panel.y);
      }
      
      private function makePopupButton(label:String, w:Number, h:Number, fontSize:int, fill:uint, textColor:uint) : Sprite
      {
         var btn:Sprite = new Sprite();
         btn.graphics.beginFill(fill);
         btn.graphics.drawRoundRect(0,0,w,h,8,8);
         btn.graphics.endFill();
         var tf:TextField = new TextField();
         tf.autoSize = TextFieldAutoSize.CENTER;
         tf.selectable = false;
         tf.mouseEnabled = false;
         tf.defaultTextFormat = new TextFormat("_sans",fontSize,textColor,true);
         tf.text = label;
         tf.x = (w - tf.width) / 2;
         tf.y = (h - tf.height) / 2 - 2;
         btn.addChild(tf);
         btn.buttonMode = true;
         btn.mouseChildren = false;
         return btn;
      }
      
      private function onPopupGameClick(event:*) : void
      {
         var action:String = null;
         var ns:Object = null;
         action = String(event.currentTarget.name).substr(5);
         trace("[GamePopup] click action=" + action);
         this.closeGamePopup();
         try
         {
            if(Boolean(this.loader) && Boolean(this.loader.content))
            {
               ns = this.findNinjaSaga(this.loader.content as DisplayObjectContainer);
               if(ns)
               {
                  ns.showWebView({"action":action});
                  trace("[GamePopup] dispatched via ns.showWebView action=" + action);
                  return;
               }
            }
         }
         catch(e:*)
         {
            trace("[GamePopup] ns.showWebView err: " + e + " — falling back to ANE");
         }
         if(this.isGameLoaded)
         {
            this.setWebViewVisible(true);
         }
         setTimeout(function():void
         {
            var wv:Object = null;
            var msg:Object = null;
            var js:String = null;
            try
            {
               wv = WebView["shared"]();
               if(wv)
               {
                  msg = {
                     "action":action,
                     "server":currentAmfServer()
                  };
                  js = "(function(){try{var m=" + JSON.stringify(msg) + ";window.postMessage(m,\'*\');if(window.parent)window.parent.postMessage(m,\'*\');}catch(e){}})();";
                  wv.callJavascriptFunction("eval",null,js);
               }
            }
            catch(e:*)
            {
               trace("[GamePopup] fallback err: " + e);
            }
         },500);
      }
      
      private function onCloseGamePopup(event:* = null) : void
      {
         this.closeGamePopup();
      }
      
      private function closeGamePopup() : void
      {
         if(Boolean(this.gamePopup) && contains(this.gamePopup))
         {
            removeChild(this.gamePopup);
         }
         this.gamePopup = null;
      }
      
      private function onResize(event:Event) : void
      {
         var scale:Number = NaN;
         this.positionToggleButton();
         this.positionServerButton();
         this.repositionUI();
         if(!this.gameHolder)
         {
            return;
         }
         var scaleX:Number = stage.stageWidth / this.VIEWPORT_WIDTH;
         var scaleY:Number = stage.stageHeight / this.viewportHeight;
         if(this.isBoxedView)
         {
            scale = Math.min(scaleX,scaleY);
            this.gameHolder.scaleX = scale;
            this.gameHolder.scaleY = scale;
            this.gameHolder.x = (stage.stageWidth - this.VIEWPORT_WIDTH * scale) / 2;
            this.gameHolder.y = (stage.stageHeight - this.viewportHeight * scale) / 2;
         }
         else
         {
            this.gameHolder.scaleX = scaleX;
            this.gameHolder.scaleY = scaleY;
            this.gameHolder.x = 0;
            this.gameHolder.y = 0;
         }
      }
      
      private function onProgress(event:ProgressEvent) : void
      {
         if(!this.progressText)
         {
            return;
         }
         var percentLoaded:int = Math.round(event.bytesLoaded / event.bytesTotal * 100);
         this.progressText.text = "Loading Game: " + percentLoaded + "%";
         this.repositionUI();
      }
      
      private function onError(event:IOErrorEvent) : void
      {
         var nextCDN:int = 0;
         trace("Error loading game from CDN " + this.activeCDN + " (" + this.cdnOptions[this.activeCDN].label + "): " + event.text);
         this.loader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS,this.onProgress);
         this.loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.onParseComplete);
         this.loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,this.onError);
         if(Boolean(this.cdnOptions) && this.cdnOptions.length > 1)
         {
            if(this.progressText)
            {
               this.progressText.text = this.getServerLabelForCDN(this.activeCDN) + " is unavailable. Click Switch Server.";
               this.repositionUI();
            }
            this.ensureSwitchServerBtn();
            return;
         }
         if(Boolean(this.cdnOptions) && this.cdnOptions.length > 1)
         {
            nextCDN = (this.activeCDN + 1) % this.cdnOptions.length;
            if(nextCDN == this.selectedCDN && this.activeCDN != this.selectedCDN)
            {
               if(!this.triedDefaultFallback)
               {
                  this.triedDefaultFallback = true;
                  this.activeCDN = 0;
                  this.gameSWFUrl = this.DEFAULT_SWF_URL;
                  this.progressText.text = "Trying default server...";
                  this.repositionUI();
                  this.startLoadingGame();
                  return;
               }
               this.progressText.text = "All servers unavailable.";
               this.repositionUI();
               return;
            }
            if(nextCDN != this.activeCDN)
            {
               this.activeCDN = nextCDN;
               this.gameSWFUrl = this.DEV_MODE ? this.DEFAULT_SWF_URL : this.cdnOptions[this.activeCDN].url;
               trace("Switching to CDN " + this.activeCDN + " (" + this.cdnOptions[this.activeCDN].label + ")");
               this.progressText.text = "Trying " + this.cdnOptions[this.activeCDN].label + "...";
               this.repositionUI();
               this.startLoadingGame();
               return;
            }
         }
         this.progressText.text = "Failed to load.";
         this.repositionUI();
      }
      
      private function repositionUI() : void
      {
         if(Boolean(this.progressText) && Boolean(stage))
         {
            this.progressText.x = (stage.stageWidth - this.progressText.width) / 2;
            this.progressText.y = (stage.stageHeight - this.progressText.height) / 2;
         }
         if(Boolean(this.switchServerBtn) && Boolean(stage))
         {
            this.switchServerBtn.x = (stage.stageWidth - this.switchServerBtn.width) / 2;
            this.switchServerBtn.y = this.progressText ? this.progressText.y + this.progressText.height + 16 : stage.stageHeight / 2 + 40;
         }
      }
   }
}

