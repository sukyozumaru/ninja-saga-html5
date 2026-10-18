package com.utils
{
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   
   public final class MovieClipButton
   {
      
      private static const TIMELINE_MOUSE_OVER:String = "mover";
      
      private static const TIMELINE_ENABLE:String = "enable";
      
      private static const TIMELINE_IDLE:String = "idle";
      
      private static const TIMELINE_SHOW:String = "show";
      
      private static const HIGHLIGHT_MC_NAME:String = "highlight";
      
      public function MovieClipButton()
      {
         super();
      }
      
      public static function enableButton(_mc:MovieClip) : void
      {
         if(!_mc.hasEventListener(MouseEvent.MOUSE_OVER))
         {
            _mc.addEventListener(MouseEvent.MOUSE_OVER,mouseOverEffect);
         }
         if(!_mc.hasEventListener(MouseEvent.MOUSE_OUT))
         {
            _mc.addEventListener(MouseEvent.MOUSE_OUT,mouseOutEffect);
         }
         _mc.buttonMode = true;
      }
      
      public static function disableButton(_mc:MovieClip) : void
      {
         if(_mc.hasEventListener(MouseEvent.MOUSE_OVER))
         {
            _mc.removeEventListener(MouseEvent.MOUSE_OVER,mouseOverEffect);
         }
         if(_mc.hasEventListener(MouseEvent.MOUSE_OUT))
         {
            _mc.removeEventListener(MouseEvent.MOUSE_OUT,mouseOutEffect);
         }
         _mc.buttonMode = false;
      }
      
      public static function highlight(_mc:MovieClip, _status:Boolean = true) : void
      {
         if(_mc != null)
         {
            if(_mc[HIGHLIGHT_MC_NAME] != null)
            {
               if(_status)
               {
                  _mc[HIGHLIGHT_MC_NAME].gotoAndStop(TIMELINE_SHOW);
               }
               else
               {
                  _mc[HIGHLIGHT_MC_NAME].gotoAndStop(TIMELINE_IDLE);
               }
            }
         }
      }
      
      private static function mouseOverEffect(evt:MouseEvent) : void
      {
         evt.currentTarget.gotoAndStop(TIMELINE_MOUSE_OVER);
      }
      
      private static function mouseOutEffect(evt:MouseEvent) : void
      {
         evt.currentTarget.gotoAndStop(TIMELINE_ENABLE);
      }
   }
}

