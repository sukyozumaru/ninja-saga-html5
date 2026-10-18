package
{
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.ProgressEvent;
   import flash.external.ExternalInterface;
   import flash.system.Security;
   import flash.text.TextField;
   import ninjasaga.data.Timeline;
   import ninjasaga.linkage.ErrorDisplay;
   
   [SWF(width="960", height="780", backgroundColor="#999999", frameRate="24")]
   public class GameLoader extends MovieClip
   {
      
      public var percentIcon:TextField;
      
      public var errorMc:ErrorDisplay;
      
      public var loadingIcon:MovieClip;
      
      public var percentTxt:TextField;
      
      public var rankMc:Rank;
      
      public var statusTxt:TextField;
      
      private var isDispatched:Boolean = false;
      
      public function GameLoader()
      {
         super();
         addFrameScript(0,this.frame1,5,this.frame6);
         Security.allowDomain("static.ninjasaga.com");
         Security.allowDomain("cdn.static.ninjasaga.com");
         Security.allowDomain("cf.static.ninjasaga.com");
         Security.allowDomain("d36ck5vhy2kgkk.cloudfront.net");
         Security.allowDomain("emagist.pc.cdn.bitgravity.com");
         Security.allowDomain("tata.static.ninjasaga.com");
         this.loaderInfo.addEventListener(Event.INIT,this.selfPreloadFinish);
         this.loaderInfo.addEventListener(Event.COMPLETE,this.selfPreloadFinish);
         this.loaderInfo.addEventListener(ProgressEvent.PROGRESS,this.showLoading);
         this.loaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.ioErrorHandler);
         if(this.loaderInfo.parameters.loadingText)
         {
            this["statusTxt"].text = this.loaderInfo.parameters.loadingText;
         }
      }
      
      private function ioErrorHandler(param1:IOErrorEvent) : void
      {
         trace(this + " :: e >> " + param1);
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
         this.showLoadingProgress(_loc2_);
      }
      
      private function selfPreloadFinish(param1:Event) : void
      {
         if(param1.type == Event.INIT)
         {
            if(param1.currentTarget.bytesLoaded == param1.currentTarget.bytesTotal)
            {
               if(this.currentLabel == Timeline.IDLE)
               {
                  this.isDispatched = true;
                  this.gotoAndStop(Timeline.SHOW);
               }
            }
         }
         if(param1.type == Event.COMPLETE)
         {
            if(this.currentLabel == Timeline.IDLE)
            {
               this.isDispatched = true;
               this.gotoAndStop(Timeline.SHOW);
            }
         }
      }
      
      private function showLoadingProgress(param1:Number) : void
      {
         if(this["percentTxt"])
         {
            this["percentTxt"].text = String(Math.round(param1 * 100));
         }
      }
      
      private function onFirstFrameInit() : void
      {
         this.callJS("loadingPageUpdate");
      }
      
      private function callJS(param1:String, ... rest) : void
      {
         if(!ExternalInterface.available)
         {
            return;
         }
         ExternalInterface.call(param1,rest);
      }
      
      internal function frame1() : *
      {
         this.stop();
         this.onFirstFrameInit();
      }
      
      internal function frame6() : *
      {
         this.stop();
      }
   }
}

