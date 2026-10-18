package ninjasaga.linkage
{
   import bitemycode.http.Cookie;
   import bitemycode.http.Util;
   import com.adobe.utils.StringUtil;
   import fl.controls.CheckBox;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import flash.ui.Keyboard;
   import ninjasaga.Account;
   import ninjasaga.Central;
   import ninjasaga.data.AMFData;
   import ninjasaga.data.AppData;
   import ninjasaga.data.ButtonData;
   import ninjasaga.data.Data;
   import ninjasaga.data.TitleData;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol96")]
   public class LoginMenu extends MovieClip
   {
      
      public var btnForgotPassword:MovieClip;
      
      public var lbl_save1:TextField;
      
      public var langBtn:MovieClip;
      
      public var passwordInput:TextField;
      
      public var btnCreateAccount:MovieClip;
      
      public var savePwdCB:CheckBox;
      
      public var lbl_password:TextField;
      
      public var lbl_save2:TextField;
      
      public var rememberUsernameCB:CheckBox;
      
      public var loginBtn:MovieClip;
      
      public var lbl_username:TextField;
      
      public var usernameInput:TextField;
      
      public function LoginMenu()
      {
         super();
         addFrameScript(0,this.frame1);
         stage.stageFocusRect = false;
         this.__setProp_rememberUsernameCB_login_mc_content_0();
         this.__setProp_savePwdCB_login_mc_content_0();
      }
      
      private function onLogin() : void
      {
         this.stop();
         stage.focus = this["usernameInput"];
         this["usernameInput"].tabIndex = 1;
         this["passwordInput"].tabIndex = 2;
         this["loginBtn"].tabIndex = 3;
         this["rememberUsernameCB"].tabEnabled = false;
         this["savePwdCB"].tabEnabled = false;
         this["usernameInput"].restrict = "A-Za-z0-9_.";
         var _loc1_:Cookie = new Cookie();
         if(_loc1_.isExist("_username"))
         {
            this["usernameInput"].text = _loc1_.get("_username");
            this["rememberUsernameCB"].selected = true;
         }
         if(_loc1_.isExist("_pwd"))
         {
            this["passwordInput"].text = _loc1_.get("_pwd");
            this["savePwdCB"].selected = true;
         }
         Central.main.initButton(this["loginBtn"],this.onLoginBtn,ButtonData.LOGIN);
         this.addEventListener(KeyboardEvent.KEY_UP,this.onLoginBtn);
         Central.main.initButton(this["btnCreateAccount"],this.onCreateAccountBtn,ButtonData.CREATEACCOUNT);
         Central.main.initButton(this["btnForgotPassword"],this.onForgotPwd,ButtonData.FORGOTPASSWORD);
         this["lbl_password"].text = Central.main.langLib.titleTxt(TitleData.PASSWORD) + ":";
         this["lbl_save1"].text = Central.main.langLib.titleTxt(TitleData.SAVE);
         this["lbl_save2"].text = Central.main.langLib.titleTxt(TitleData.SAVE);
         this["lbl_username"].text = Central.main.langLib.titleTxt(TitleData.USERNAME) + ":";
         Central.main.initButton(this["langBtn"],this.changeLang,AppData.lang);
      }
      
      private function changeLang(param1:MouseEvent) : void
      {
         var _loc2_:Array = [AppData.ZH,AppData.EN,AppData.ES];
         var _loc3_:int = _loc2_.indexOf(AppData.lang);
         AppData.lang = _loc2_[_loc3_ + 1] ? _loc2_[_loc3_ + 1] : _loc2_[0];
         Central.main.langLib = NinjaSaga.swfObj["swf/language/" + AppData.lang + ".swf"];
         this.onLogin();
      }
      
      private function onLoginBtn(param1:Event) : void
      {
         if(param1.type != KeyboardEvent.KEY_UP && param1.type != MouseEvent.CLICK)
         {
            return;
         }
         if(param1.type == KeyboardEvent.KEY_UP)
         {
            if(KeyboardEvent(param1).keyCode != Keyboard.ENTER)
            {
               return;
            }
         }
         if(StringUtil.trim(this["usernameInput"].text).length < 3 || this["passwordInput"].text.length == 0)
         {
            Central.main.showInfo(Central.main.langLib.get(191));
            return;
         }
         Central.main.showAmfLoading();
         this.amfLogin(this["usernameInput"].text,this["passwordInput"].text);
      }
      
      private function onCreateAccountBtn(param1:MouseEvent) : void
      {
         Util.gotoUrlBlank("registration.html");
      }
      
      private function onForgotPwd(param1:MouseEvent) : void
      {
         Util.gotoUrlBlank("html/forgot_password.html");
      }
      
      private function amfLogin(param1:String, param2:String) : void
      {
         Central.main.amfClient.service("SystemService.login",[param1,param2,Data.BUILD_NO],this.onAmfLoginResult);
      }
      
      private function onAmfLoginResult(param1:Object) : void
      {
         var _loc5_:Cookie = null;
         var _loc6_:Array = null;
         Central.main.hideAmfLoading();
         if(String(param1.status) == AMFData.STATUS_ERROR)
         {
            Central.main.showOk("Error " + param1.error,new Function());
            return;
         }
         var _loc2_:Array = param1.result as Array;
         var _loc3_:String = param1.signature;
         var _loc4_:Object = param1.account_lock as Object;
         if(_loc4_ != null)
         {
            Central.main.paymentStatus = _loc4_.status;
            Central.main.paymentTitle = _loc4_.title;
            Central.main.paymentText = _loc4_.reason;
            if(String(Central.main.paymentTitle).length <= 0)
            {
               Central.main.paymentTitle = Central.main.langLib.get(952);
            }
            if(String(Central.main.paymentText).length <= 0)
            {
               Central.main.paymentText = Central.main.langLib.get(953);
            }
         }
         else
         {
            Central.main.paymentStatus = false;
         }
         if(Account.setupAccount(_loc2_,_loc3_))
         {
            _loc5_ = new Cookie();
            if(this["rememberUsernameCB"].selected == true)
            {
               _loc5_.put("_username",this["usernameInput"].text);
            }
            if(this["savePwdCB"].selected == true)
            {
               _loc5_.put("_pwd",this["passwordInput"].text);
            }
            this["loginBtn"].removeEventListener(MouseEvent.CLICK,this.onLoginBtn);
            this.removeEventListener(KeyboardEvent.KEY_UP,this.onLoginBtn);
            this["btnCreateAccount"].removeEventListener(MouseEvent.CLICK,this.onCreateAccountBtn);
            this["btnForgotPassword"].removeEventListener(MouseEvent.CLICK,this.onForgotPwd);
            Central.main.dataParser.parseVersionData(param1.swf_versions);
            _loc6_ = [];
            _loc6_.push({
               "path":"swf/language/data_library_" + AppData.lang + ".swf",
               "version":AppData.dataVer
            });
            Central.main.loadSwfByVersion(_loc6_,this.loadDataFinish,null,Central.main.langLib.get(189));
            Central.main.accRegTutStatus = param1.account_registered_tutored;
            Central.main.accRegActiveStatus = param1.account_registered_password;
         }
         else
         {
            Central.main.showInfo(Central.main.langLib.get(191));
         }
      }
      
      private function loadDataFinish(param1:Object) : void
      {
         Central.main.dataLib = param1["swf/language/data_library_" + AppData.lang + ".swf"];
         Central.main.selectChar();
      }
      
      internal function __setProp_rememberUsernameCB_login_mc_content_0() : *
      {
         try
         {
            this.rememberUsernameCB["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         this.rememberUsernameCB.enabled = true;
         this.rememberUsernameCB.label = "";
         this.rememberUsernameCB.labelPlacement = "right";
         this.rememberUsernameCB.selected = false;
         this.rememberUsernameCB.visible = true;
         try
         {
            this.rememberUsernameCB["componentInspectorSetting"] = false;
         }
         catch(e:Error)
         {
         }
      }
      
      internal function __setProp_savePwdCB_login_mc_content_0() : *
      {
         try
         {
            this.savePwdCB["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         this.savePwdCB.enabled = true;
         this.savePwdCB.label = "";
         this.savePwdCB.labelPlacement = "right";
         this.savePwdCB.selected = false;
         this.savePwdCB.visible = true;
         try
         {
            this.savePwdCB["componentInspectorSetting"] = false;
         }
         catch(e:Error)
         {
         }
      }
      
      internal function frame1() : *
      {
         this.onLogin();
      }
   }
}

