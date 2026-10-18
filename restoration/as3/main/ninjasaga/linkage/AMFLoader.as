package ninjasaga.linkage
{
   import com.utils.GF;
   import flash.display.MovieClip;
   import flash.events.Event;
   import ninjasaga.data.Data;
   import ninjasaga.data.Timeline;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol1082")]
   public class AMFLoader extends MovieClip
   {
      
      private var numOfCircles:uint = 35;
      
      private var centerX:uint = 910;
      
      private var centerY:uint = 730;
      
      private var radius:Number = 20;
      
      private var angle:Number = this.numOfCircles / 180;
      
      private var radians:Number = 360 / this.numOfCircles * Math.PI / 180;
      
      private var circles:Array = new Array();
      
      public function AMFLoader()
      {
         super();
         addFrameScript(0,this.frame1,5,this.frame6);
      }
      
      public function show() : void
      {
         this.gotoAndStop(Timeline.SHOW);
      }
      
      public function hide() : void
      {
         this.gotoAndStop(Timeline.IDLE);
      }
      
      private function onShow() : void
      {
         var _loc1_:* = undefined;
         var _loc2_:MovieClip = null;
         this.stop();
         if(this.numChildren == 0)
         {
            _loc1_ = 0;
            while(_loc1_ < this.numOfCircles)
            {
               _loc2_ = new MovieClip();
               this.addChild(_loc2_);
               this.circles.push(_loc2_);
               this.drawLoadingCircle(this.circles[_loc1_],4,16777215,100);
               this.circles[_loc1_].x = this.centerX + Math.sin(this.radians * _loc1_) * this.radius;
               this.circles[_loc1_].y = this.centerY + Math.cos(this.radians * _loc1_) * this.radius;
               this.circles[_loc1_].alpha = _loc1_ * (100 / this.numOfCircles) / 100;
               _loc1_++;
            }
            this.addMask();
            this.addEventListener(Event.ENTER_FRAME,this.onEnterFrame);
         }
      }
      
      private function onIdle() : void
      {
         this.stop();
         GF.removeAllChild(this);
         this.circles = new Array();
         if(this.hasEventListener(Event.ENTER_FRAME))
         {
            this.removeEventListener(Event.ENTER_FRAME,this.onEnterFrame);
         }
      }
      
      private function addMask() : void
      {
         var _loc1_:MovieClip = new MovieClip();
         _loc1_.graphics.beginFill(0,0.5);
         _loc1_.graphics.drawRoundRect(0,0,Data.GAME_WIDTH,Data.GAME_HEIGTH_FULL,0);
         this.addChildAt(_loc1_,0);
      }
      
      private function onEnterFrame(param1:Event) : void
      {
         var _loc2_:* = 0;
         while(_loc2_ < this.numOfCircles)
         {
            if(this.circles[_loc2_].alpha <= 0)
            {
               this.circles[_loc2_].alpha = 1;
            }
            this.circles[_loc2_].alpha -= 0.03;
            _loc2_++;
         }
      }
      
      private function drawLoadingCircle(param1:MovieClip, param2:Number, param3:Number, param4:Number) : void
      {
         var _loc5_:Number = param2;
         var _loc6_:Number = param2;
         param1.graphics.beginFill(param3,param4);
         param1.graphics.moveTo(_loc5_ + param2,_loc6_);
         param1.graphics.curveTo(param2 + _loc5_,Math.tan(Math.PI / 8) * param2 + _loc6_,Math.sin(Math.PI / 4) * param2 + _loc5_,Math.sin(Math.PI / 4) * param2 + _loc6_);
         param1.graphics.curveTo(Math.tan(Math.PI / 8) * param2 + _loc5_,param2 + _loc6_,_loc5_,param2 + _loc6_);
         param1.graphics.curveTo(-Math.tan(Math.PI / 8) * param2 + _loc5_,param2 + _loc6_,-Math.sin(Math.PI / 4) * param2 + _loc5_,Math.sin(Math.PI / 4) * param2 + _loc6_);
         param1.graphics.curveTo(-param2 + _loc5_,Math.tan(Math.PI / 8) * param2 + _loc6_,-param2 + _loc5_,_loc6_);
         param1.graphics.curveTo(-param2 + _loc5_,-Math.tan(Math.PI / 8) * param2 + _loc6_,-Math.sin(Math.PI / 4) * param2 + _loc5_,-Math.sin(Math.PI / 4) * param2 + _loc6_);
         param1.graphics.curveTo(-Math.tan(Math.PI / 8) * param2 + _loc5_,-param2 + _loc6_,_loc5_,-param2 + _loc6_);
         param1.graphics.curveTo(Math.tan(Math.PI / 8) * param2 + _loc5_,-param2 + _loc6_,Math.sin(Math.PI / 4) * param2 + _loc5_,-Math.sin(Math.PI / 4) * param2 + _loc6_);
         param1.graphics.curveTo(param2 + _loc5_,-Math.tan(Math.PI / 8) * param2 + _loc6_,param2 + _loc5_,_loc6_);
         param1.graphics.endFill();
      }
      
      internal function frame1() : *
      {
         this.onIdle();
      }
      
      internal function frame6() : *
      {
         this.onShow();
      }
   }
}

