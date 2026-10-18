package ninjasaga.linkage
{
   import com.utils.GF;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import ninjasaga.Central;
   import ninjasaga.data.MissionData;
   import ninjasaga.data.Timeline;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol2434")]
   public class MapMissionDoc extends MovieClip
   {
      
      public var contentMc:MovieClip;
      
      public var mapHolder:MovieClip;
      
      public var exitMc:MovieClip;
      
      public var bgMc:MovieClip;
      
      public var walkAreaHolderMc:MovieClip;
      
      private var enemies:Array;
      
      private var missionSetting:Object;
      
      private var currentCharPos:Point;
      
      private var currentScaleX:Number;
      
      private var charMc:MovieClip;
      
      public function MapMissionDoc()
      {
         super();
         addFrameScript(0,this.frame1,5,this.frame6);
         this.tabEnabled = false;
         this.tabChildren = false;
         this.gotoMap();
         Central.mission.setMapMission(this);
      }
      
      private function onIdle() : void
      {
         this.stop();
      }
      
      private function onMap() : void
      {
         var _loc1_:* = undefined;
         var _loc2_:MovieClip = null;
         this.stop();
         this.missionSetting = Central.mission.getSetting();
         if(Central.mission.getMapMissionType() == MissionData.MAP_TYPE_SINGLE)
         {
            this.enemies = Central.mission.getMapMissionEnemies();
            this["bgMc"].addChild(Central.mission.getMovieClip("mission_bg"));
            this["exitMc"].addChild(Central.mission.getMovieClip("exit_area"));
            this.charMc = Central.main.getMainChar().getSwf();
            this.charMc.x = this.missionSetting.charPos.x;
            this.charMc.y = this.missionSetting.charPos.y;
            this.currentCharPos = new Point(this.missionSetting.charPos.x,this.missionSetting.charPos.y);
            this.charMc.scaleX = this.missionSetting.scale * this.missionSetting.charDir;
            this.charMc.scaleY = this.missionSetting.scale;
            Central.main.getMainChar().playStand();
            this["contentMc"].addChild(this.charMc);
            if(this.isMissionComplete())
            {
               Central.mission.mapMissionFinish();
               return;
            }
            this["walkAreaHolderMc"].addChild(Central.mission.getMovieClip("walk_area"));
            _loc1_ = 0;
            while(_loc1_ < this.enemies.length)
            {
               if(this.enemies[_loc1_].died == null || this.enemies[_loc1_].died == false)
               {
                  _loc2_ = this.enemies[_loc1_].enemy.getSwf();
                  _loc2_.x = this.enemies[_loc1_].x;
                  _loc2_.y = this.enemies[_loc1_].y;
                  _loc2_.scaleX = this.missionSetting.scale;
                  _loc2_.scaleY = this.missionSetting.scale;
                  this.enemies[_loc1_].enemy.playStandby();
                  this["contentMc"].addChild(_loc2_);
               }
               _loc1_++;
            }
            this["walkAreaHolderMc"].addEventListener(MouseEvent.CLICK,this.walk);
         }
         if(Central.mission.getMapMissionType() == MissionData.MAP_TYPE_MULTIPLE)
         {
            Central.mission.curMission.clearCurrentMap();
            this.reshow();
         }
      }
      
      public function reshow() : void
      {
         var _loc3_:MovieClip = null;
         var _loc1_:MovieClip = Central.mission.getCurrentMap();
         GF.removeAllChild(this["mapHolder"]);
         GF.removeAllChild(this["contentMc"]);
         this["mapHolder"].addChild(_loc1_);
         this.enemies = Central.mission.getMapMissionEnemies();
         var _loc2_:* = 0;
         while(_loc2_ < this.enemies.length)
         {
            if(this.enemies[_loc2_].died == null || this.enemies[_loc2_].died == false)
            {
               _loc3_ = this.enemies[_loc2_].enemy.getSwf();
               _loc3_.x = this.enemies[_loc2_].x;
               _loc3_.y = this.enemies[_loc2_].y;
               _loc3_.scaleX = this.missionSetting.scale;
               _loc3_.scaleY = this.missionSetting.scale;
               this.enemies[_loc2_].enemy.playStandby();
               this["contentMc"].addChild(_loc3_);
            }
            _loc2_++;
         }
         this.charMc = Central.main.getMainChar().getSwf();
         this.charMc.x = this.missionSetting.charPos.x;
         this.charMc.y = this.missionSetting.charPos.y;
         this.currentCharPos = new Point(this.missionSetting.charPos.x,this.missionSetting.charPos.y);
         this.charMc.scaleX = this.missionSetting.scale * this.missionSetting.charDir;
         this.charMc.scaleY = this.missionSetting.scale;
         Central.main.getMainChar().playStand();
         _loc1_.addChild(this.charMc);
         _loc1_["walkAreaMc"].addEventListener(MouseEvent.CLICK,this.walk);
      }
      
      public function gotoIdle() : void
      {
         this.gotoAndStop(Timeline.IDLE);
      }
      
      public function gotoMap() : void
      {
         this.gotoAndStop(Timeline.MAP);
      }
      
      public function restoreMainChar() : void
      {
         this.charMc = Central.main.getMainChar().getSwf();
         this.charMc.x = this.currentCharPos.x;
         this.charMc.y = this.currentCharPos.y;
         this.charMc.scaleX = this.missionSetting.scale * this.missionSetting.charDir;
         this.charMc.scaleY = this.missionSetting.scale;
         Central.main.getMainChar().playStand();
         this["contentMc"].addChild(this.charMc);
      }
      
      public function removeAllChild() : void
      {
         var _loc1_:* = 0;
         while(_loc1_ < this.enemies.length)
         {
            this.enemies[_loc1_].enemy.removeParent();
            _loc1_++;
         }
         Central.main.getMainChar().removeParent();
      }
      
      private function walk(param1:MouseEvent) : void
      {
         Central.main.getMainChar().walkTo(new Point(param1.stageX,param1.stageY));
         this.currentCharPos = new Point(param1.stageX,param1.stageY);
         this.currentScaleX = this.charMc.scaleX;
      }
      
      private function isMissionComplete() : Boolean
      {
         var _loc1_:* = 0;
         while(_loc1_ < this.enemies.length)
         {
            if(this.enemies[_loc1_].died == null)
            {
               return false;
            }
            _loc1_++;
         }
         return true;
      }
      
      internal function frame1() : *
      {
         this.onIdle();
      }
      
      internal function frame6() : *
      {
         this.onMap();
      }
   }
}

