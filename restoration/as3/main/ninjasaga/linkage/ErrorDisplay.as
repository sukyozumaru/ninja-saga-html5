package ninjasaga.linkage
{
   import com.utils.CreateFilter;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.filters.ColorMatrixFilter;
   import flash.text.TextField;
   import ninjasaga.Central;
   import ninjasaga.data.AppData;
   import ninjasaga.data.ButtonData;
   import ninjasaga.data.TitleData;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol2516")]
   public class ErrorDisplay extends MovieClip
   {
      
      public var btnRefresh:MovieClip;
      
      public var popup2000:MovieClip;
      
      public var errorCode:TextField;
      
      public var errorMsg:TextField;
      
      public var logoMC:MovieClip;
      
      public var recoverMc:MovieClip;
      
      public var btnSupport:MovieClip;
      
      public var errorTitle:TextField;
      
      private var dimFilter:ColorMatrixFilter = CreateFilter.getSaturationFilter(0);
      
      private var errCode:String;
      
      private var errMsg:String;
      
      private var langArr:Array;
      
      public function ErrorDisplay()
      {
         super();
         addFrameScript(0,this.frame1,5,this.frame6,10,this.frame11,15,this.frame16,20,this.frame21);
      }
      
      public function show(param1:String, param2:String) : void
      {
         this.langArr = Central.main.langLib.get(1572);
         this.errCode = param1;
         this.errMsg = param2;
         if(AppData.type != AppData.RR)
         {
            this.gotoAndStop("show");
         }
         else
         {
            this.gotoAndStop("rr_show");
         }
      }
      
      public function show2000(param1:String, param2:String) : void
      {
         trace("show2000");
         this.langArr = Central.main.langLib.get(1572);
         this.errCode = param1;
         this.errMsg = param2;
         this.gotoAndStop("show2000");
      }
      
      private function onShow() : void
      {
         trace("this.errCode " + this.errCode);
         if(this.errCode == "(Error 2000)")
         {
            this["popup2000"].gotoAndPlay("show");
         }
         if(Central.main._errorRecover)
         {
            Central.main.initButton(this["btnRefresh"],this.gotoDetail,ButtonData.NEXT);
            this["errorTitle"].text = this.langArr[6];
         }
         else
         {
            Central.main.initButton(this["btnRefresh"],this.onClickRefresh,ButtonData.RELOAD);
            this["errorTitle"].text = "";
         }
         Central.main.initButton(this["btnSupport"],this.onClickSupport,ButtonData.SUPPORT_FORM);
         this["errorMsg"].htmlText = this.errMsg;
         this["errorCode"].htmlText = this.errCode.replace("Error","Error Code :");
      }
      
      private function onClickGoToClearCacheTut(param1:MouseEvent) : void
      {
         Central.main.gotoURL("https://apps.facebook.com/ninjasaga/clear_cache_tutorial.php","_blank");
      }
      
      public function initOnShowpopup(param1:MovieClip) : void
      {
         this["popup2000"]["panel"]["errorMsg2000"].htmlText = AppData.lang == AppData.ZH ? "請到瀏覽器設定中<font color=\'#00FFFF\'><u>清除快取資料</u></font>以解決error 2000的問題。" : "<font color=\'#00FFFF\'><u>Clear the browser\'s cache</u></font> to fix the problem of error 2000.";
         Central.main.initButton(this["popup2000"]["panel"]["btnTut"],this.onClickGoToClearCacheTut,AppData.lang == AppData.ZH ? "如何清除快取資料?" : "How to clear cache?");
      }
      
      private function onClickSupport(param1:MouseEvent) : void
      {
         switch(AppData.lang)
         {
            case AppData.EN:
               Central.main.gotoURL("http://apps.facebook.com/ninjasaga/support_form/","_blank");
               break;
            case AppData.ZH:
               Central.main.gotoURL("http://apps.facebook.com/ninjasaga_zh/support_form/","_blank");
               break;
            case AppData.ES:
               Central.main.gotoURL("http://apps.facebook.com/ninjasaga_es/support_form/","_blank");
               break;
            default:
               Central.main.gotoURL("http://apps.facebook.com/ninjasaga/support_form/","_blank");
         }
      }
      
      private function onClickRefresh(param1:MouseEvent) : void
      {
         switch(AppData.type)
         {
            case AppData.FB:
               switch(AppData.lang)
               {
                  case AppData.ZH:
                     Central.main.gotoURL("http://apps.facebook.com/ninjasaga_zh/");
                     break;
                  case AppData.ES:
                     Central.main.gotoURL("http://apps.facebook.com/ninjasaga_es/");
                     break;
                  default:
                     Central.main.gotoURL("http://apps.facebook.com/ninjasaga/");
               }
               break;
            case AppData.YM:
               Central.main.gotoURL("http://tw.socialgame.yahoo.net/userapp/userapp.php?appid=622");
               break;
            case AppData.RR:
               Central.main.gotoURL("http://apps.renren.com/ninjasaga");
               break;
            default:
               Central.main.gotoURL("http://www.ninjasaga.com");
         }
      }
      
      private function gotoDetail(param1:MouseEvent) : void
      {
         this.gotoAndStop("recover");
      }
      
      public function onDetail(param1:MovieClip) : void
      {
         param1["recoverMc"].gotoAndPlay("show");
      }
      
      public function onShowDetail(param1:MovieClip) : void
      {
         param1 = param1["panel"];
         if(int(Central.main.account.getAccountBalance()) < 1000)
         {
            this.disableButton(param1["confirmBtn"],this.confirmRecover,ButtonData.RECOVER);
         }
         else
         {
            Central.main.initButton(param1["confirmBtn"],this.confirmRecover,ButtonData.RECOVER);
         }
         param1["charName"].text = Central.main._errorRecoverObj.character_name;
         param1["charID"].text = Central.main._errorRecoverObj.character_id;
         param1["charLv"].text = Central.main._errorRecoverObj.character_level;
         param1["own_tokenMc"]["txt_token"].text = Central.main.account.getAccountBalance();
         param1["titleTxt"].text = this.langArr[1];
         param1["descTxt"].htmlText = this.langArr[2];
         param1["lbl_charName"].text = Central.main.langLib.titleTxt(TitleData.CHARACTERNAME);
         param1["lbl_charId"].text = Central.main.langLib.titleTxt(TitleData.CHARACTERID);
         param1["lbl_charLv"].text = Central.main.langLib.titleTxt(TitleData.LEVEL);
         param1["lbl_tokenRequire"].text = Central.main.langLib.titleTxt(TitleData.TOKENREQUIRED) + ":";
         param1["lbl_ownToken"].text = this.langArr[3] + ":";
         param1["req_tokenMc"]["txt_token"].text = this.langArr[5];
      }
      
      private function confirmRecover(param1:MouseEvent) : void
      {
         this.disableButton(MovieClip(param1.currentTarget),this.confirmRecover,ButtonData.RECOVER);
         Central.main.amfClient.service("CharacterManagement.recoverCharacter",[Central.main.account.getAccountSessionKey(),Central.main._errorRecoverObj.character_id],this.recoverResponse);
      }
      
      private function recoverResponse(param1:Object) : void
      {
         if(Central.main.validateAmfResponse(param1))
         {
            this["recoverMc"]["panel"]["reloadMc"].gotoAndStop("show");
         }
      }
      
      public function onReload(param1:MovieClip) : void
      {
         param1.stop();
         param1["titleTxt"].text = this.langArr[7];
         param1["displayTxt"].text = this.langArr[4];
         Central.main.initButton(param1["reloadBtn"],this.onClickRefresh,ButtonData.RELOAD);
      }
      
      private function disableButton(param1:*, param2:Function, param3:String = null) : void
      {
         var btnTxt:String = null;
         var btn:* = param1;
         var fn:Function = param2;
         var txt:String = param3;
         btn.stop();
         btn["clickMask"].buttonMode = false;
         btn.gotoAndStop(1);
         btn.removeEventListener(MouseEvent.CLICK,fn);
         btn.removeEventListener(MouseEvent.MOUSE_OUT,function(param1:MouseEvent):*
         {
            param1.currentTarget.gotoAndStop(1);
         });
         btn.removeEventListener(MouseEvent.MOUSE_OVER,function(param1:MouseEvent):*
         {
            param1.currentTarget.gotoAndStop(2);
         });
         if(txt != null)
         {
            btnTxt = Central.main.langLib.btnTxt(txt);
            if(btnTxt != null)
            {
               btn["txt"].text = btnTxt;
            }
            else
            {
               btn["txt"].text = txt;
            }
         }
         btn.filters = [this.dimFilter];
      }
      
      internal function frame1() : *
      {
         stop();
      }
      
      internal function frame6() : *
      {
         stop();
         this.onShow();
      }
      
      internal function frame11() : *
      {
         stop();
         this.onShow();
      }
      
      internal function frame16() : *
      {
         stop();
         this.onDetail(this);
      }
      
      internal function frame21() : *
      {
         stop();
         this.onShow();
      }
   }
}

