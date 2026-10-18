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
      
      public static function enableButton(param1:MovieClip) : void
      {
         if(!param1.hasEventListener(MouseEvent.MOUSE_OVER))
         {
            param1.addEventListener(MouseEvent.MOUSE_OVER,mouseOverEffect);
         }
         if(!param1.hasEventListener(MouseEvent.MOUSE_OUT))
         {
            param1.addEventListener(MouseEvent.MOUSE_OUT,mouseOutEffect);
         }
         param1.buttonMode = true;
      }
      
      public static function disableButton(param1:MovieClip) : void
      {
         if(param1.hasEventListener(MouseEvent.MOUSE_OVER))
         {
            param1.removeEventListener(MouseEvent.MOUSE_OVER,mouseOverEffect);
         }
         if(param1.hasEventListener(MouseEvent.MOUSE_OUT))
         {
            param1.removeEventListener(MouseEvent.MOUSE_OUT,mouseOutEffect);
         }
         param1.buttonMode = false;
      }
      
      public static function highlight(param1:MovieClip, param2:Boolean = true) : void
      {
         if(param1 != null)
         {
            if(param1[HIGHLIGHT_MC_NAME] != null)
            {
               if(param2)
               {
                  param1[HIGHLIGHT_MC_NAME].gotoAndStop(TIMELINE_SHOW);
               }
               else
               {
                  param1[HIGHLIGHT_MC_NAME].gotoAndStop(TIMELINE_IDLE);
               }
            }
         }
      }
      
      private static function mouseOverEffect(param1:MouseEvent) : void
      {
         param1.currentTarget.gotoAndStop(TIMELINE_MOUSE_OVER);
      }
      
      private static function mouseOutEffect(param1:MouseEvent) : void
      {
         param1.currentTarget.gotoAndStop(TIMELINE_ENABLE);
      }
   }
}

