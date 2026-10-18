package ninjasaga.linkage.popup
{
   import com.utils.Mixer;
   import com.utils.Out;
   import flash.display.MovieClip;
   import flash.media.Sound;
   import ninjasaga.Central;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol2810")]
   public class Achievement extends MovieClip
   {
      
      public var animationMc:MovieClip;
      
      public var iconHolder:MovieClip;
      
      private var achievementId:int = 0;
      
      public function Achievement()
      {
         super();
         addFrameScript(0,this.frame1,5,this.frame6,17,this.frame18,33,this.frame34,128,this.frame129);
      }
      
      public function show() : void
      {
         this.proc();
      }
      
      private function proc() : void
      {
         if(Central.main.achievement.gotAchievement.length == 0)
         {
            this.gotoAndStop("idle");
            return;
         }
         if(Central.main.achievement.gotAchievement.length > 0 && this.achievementId == 0)
         {
            this.achievementId = Central.main.achievement.gotAchievement.shift();
            if(this.achievementId > 0)
            {
               this.gotoAndPlay("show");
               return;
            }
         }
      }
      
      private function onShow() : void
      {
         var _loc2_:MovieClip = null;
         var _loc3_:String = null;
         var _loc1_:Object = Central.main.ACHIEVEMENT_DATA.find(this.achievementId);
         if(_loc1_)
         {
            _loc2_ = Central.main.getLib("LoadingMc");
            _loc3_ = "ach_" + _loc1_.id;
            Central.main.proc.loadIcon(_loc3_,_loc2_,_loc3_,null);
            this["iconHolder"].addChild(_loc2_);
            this.playSoundFile(1);
         }
      }
      
      private function showText() : void
      {
         var _loc1_:Object = Central.main.ACHIEVEMENT_DATA.find(this.achievementId);
         if(_loc1_)
         {
            this["animationMc"]["nameTxt"].htmlText = _loc1_.name;
         }
      }
      
      private function onFinish() : void
      {
         Out.debug(this,"onFinish");
         this.achievementId = 0;
         this.proc();
      }
      
      private function playSoundFile(param1:int) : void
      {
         switch(param1)
         {
            case 1:
               Mixer.getInstance().playSound(Sound(Central.main.getLib("OpenScroll")));
               break;
            case 2:
               Mixer.getInstance().playSound(Sound(Central.main.getLib("okami_1_56")));
         }
      }
      
      internal function frame1() : *
      {
         stop();
      }
      
      internal function frame6() : *
      {
         this.onShow();
      }
      
      internal function frame18() : *
      {
         this.showText();
      }
      
      internal function frame34() : *
      {
         this.playSoundFile(2);
      }
      
      internal function frame129() : *
      {
         this.onFinish();
      }
   }
}

