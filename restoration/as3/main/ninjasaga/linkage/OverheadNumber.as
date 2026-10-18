package ninjasaga.linkage
{
   import flash.display.MovieClip;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import ninjasaga.Central;
   import ninjasaga.data.Timeline;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol1955")]
   public class OverheadNumber extends MovieClip
   {
      
      public var wordMc:MovieClip;
      
      public var healMc:MovieClip;
      
      public var criticalMc:MovieClip;
      
      public var damageMc:MovieClip;
      
      private var displayArr:Array = [];
      
      private var displayTimer:Timer = new Timer(400);
      
      public function OverheadNumber()
      {
         super();
         addFrameScript(0,this.frame1);
         this.displayTimer.addEventListener(TimerEvent.TIMER,this.updateDisplay);
      }
      
      public function showNumber(param1:String, param2:String) : void
      {
         var _loc4_:MovieClip = null;
         var _loc3_:Object = {};
         _loc3_.type = param1;
         _loc3_.str = param2;
         this.displayArr.push(_loc3_);
         if(this.displayArr.length == 1)
         {
            switch(param1)
            {
               case Timeline.NORMAL:
                  _loc4_ = Central.main.getLib("OHDamage");
                  break;
               case Timeline.CRITICAL:
                  _loc4_ = Central.main.getLib("OHCritical");
                  _loc4_["textMc"]["lbl_criticalstrike_title"].text = Central.main.langLib.get(409);
                  break;
               case Timeline.WORD:
                  _loc4_ = Central.main.getLib("OHWord");
                  break;
               case Timeline.HEAL:
                  _loc4_ = Central.main.getLib("OHHeal");
                  _loc4_["textMc"]["lbl_heal_title"].text = Central.main.langLib.get(408);
            }
            _loc4_["textMc"]["txt"].text = param2;
            this.addChild(_loc4_);
            this.displayTimer.start();
         }
      }
      
      private function updateDisplay(param1:TimerEvent) : void
      {
         var _loc2_:Object = null;
         var _loc3_:String = null;
         var _loc4_:String = null;
         var _loc5_:MovieClip = null;
         this.displayArr.shift();
         if(this.displayArr.length > 0)
         {
            _loc2_ = this.displayArr[0];
            _loc3_ = _loc2_.type;
            _loc4_ = _loc2_.str;
            switch(_loc3_)
            {
               case Timeline.NORMAL:
                  _loc5_ = Central.main.getLib("OHDamage");
                  break;
               case Timeline.CRITICAL:
                  _loc5_ = Central.main.getLib("OHCritical");
                  _loc5_["textMc"]["lbl_criticalstrike_title"].text = Central.main.langLib.get(409);
                  break;
               case Timeline.WORD:
                  _loc5_ = Central.main.getLib("OHWord");
                  break;
               case Timeline.HEAL:
                  _loc5_ = Central.main.getLib("OHHeal");
                  _loc5_["textMc"]["lbl_heal_title"].text = Central.main.langLib.get(408);
            }
            _loc5_["textMc"]["txt"].text = _loc4_;
            this.addChild(_loc5_);
         }
         else
         {
            this.displayTimer.stop();
            this.displayTimer.reset();
         }
      }
      
      internal function frame1() : *
      {
         this.stop();
      }
   }
}

