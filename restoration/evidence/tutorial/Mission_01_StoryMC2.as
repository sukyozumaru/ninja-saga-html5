package
{
   import com.utils.CreateFilter;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.filters.ColorMatrixFilter;
   import ninjasaga.Central;
   import ninjasaga.base.MissionBase;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol250")]
   public class Mission_01_StoryMC2 extends MissionBase
   {
      
      public var selectMc:MovieClip;
      
      private var selectedBtnName:String;
      
      private var langArr:Array = [];
      
      private var _track:Boolean = true;
      
      private var btnArr:Array = ["btnWind","btnFire","btnEarth","btnWater","btnLightning"];
      
      private var dimFilter:ColorMatrixFilter = CreateFilter.getSaturationFilter(0);
      
      private var skill_id:String = "";
      
      private var skill_swf:String = "";
      
      public function Mission_01_StoryMC2()
      {
         super();
         addFrameScript(0,this.frame1);
         this.langArr = Central.main.langLib.get(1754);
      }
      
      public function initSkipBtn(_mc:MovieClip) : void
      {
         this["selectMc"].gotoAndPlay("ready");
         this["selectMc"]["bgMouseOver"].addEventListener(MouseEvent.MOUSE_OVER,this.resetMouseEvent);
      }
      
      private function resetMouseEvent(evt:MouseEvent) : void
      {
         for(var i:int = 0; i < this.btnArr.length; i++)
         {
            this["selectMc"][this.btnArr[i]].gotoAndStop(1);
         }
      }
      
      private function skipAnimation(evt:MouseEvent) : void
      {
         this["selectMc"].gotoAndPlay("ready");
      }
      
      public function initTxt(_mc:MovieClip) : void
      {
         _mc["elementWindTxt"].text = this.langArr[1];
         _mc["displayWindTxt"].text = this.langArr[2];
         _mc["elementFireTxt"].text = this.langArr[3];
         _mc["displayFireTxt"].text = this.langArr[4];
         _mc["elementEarthTxt"].text = this.langArr[5];
         _mc["displayEarthTxt"].text = this.langArr[6];
         _mc["elementWaterTxt"].text = this.langArr[7];
         _mc["displayWaterTxt"].text = this.langArr[8];
         _mc["elementLightningTxt"].text = this.langArr[9];
         _mc["displayLightningTxt"].text = this.langArr[10];
      }
      
      public function initSkillSelection(_mc:MovieClip) : void
      {
         var i:int = 0;
         for(i = 0; i < this.btnArr.length; i++)
         {
            _mc[this.btnArr[i]].visible = true;
            _mc[this.btnArr[i]].addEventListener(MouseEvent.MOUSE_OVER,this.playAnimation);
            _mc[this.btnArr[i]].addEventListener(MouseEvent.CLICK,this.onClickSkill);
            _mc[this.btnArr[i]].buttonMode = true;
            _mc[this.btnArr[i]].gotoAndStop(1);
            _mc[this.btnArr[i]]["selectedMc"].visible = false;
         }
         Central.main.disableButton(_mc["skipBtn"],this.skipAnimation,this.langArr[0]);
         _mc["skipBtn"].visible = false;
         Central.main.disableButton(_mc["okBtn"],this.selectSkill,this.langArr[12]);
         _mc["okBtn"].visible = false;
         _mc["titleTxt"].text = this.langArr[11];
         this.initTxt(_mc);
      }
      
      private function onMouseOverEffect(evt:MouseEvent) : void
      {
         var Name:String = evt.currentTarget.name;
         for(var i:int = 0; i < this.btnArr.length; i++)
         {
            this["selectMc"][Name].gotoAndStop(2);
         }
      }
      
      private function playAnimation(evt:MouseEvent) : void
      {
         var Name:String = evt.currentTarget.name;
         var Mc:MovieClip = MovieClip(evt.currentTarget.parent);
         var i:int = 0;
         for(i = 0; i < this.btnArr.length; i++)
         {
            if(this.btnArr[i] == Name)
            {
               this["selectMc"][Name].removeEventListener(MouseEvent.MOUSE_OVER,this.playAnimation);
               this["selectMc"][Name].addEventListener(MouseEvent.MOUSE_OVER,this.onMouseOverEffect);
               this["selectMc"][Name].gotoAndStop(2);
            }
            else
            {
               this["selectMc"][this.btnArr[i]].removeEventListener(MouseEvent.MOUSE_OVER,this.onMouseOverEffect);
               this["selectMc"][this.btnArr[i]].addEventListener(MouseEvent.MOUSE_OVER,this.playAnimation);
               this["selectMc"][this.btnArr[i]].gotoAndStop(1);
            }
         }
         Central.main.disableButton(this["selectMc"]["skipBtn"],this.skipAnimation,this.langArr[0]);
         this["selectMc"]["skipBtn"].visible = false;
      }
      
      public function onClickSkill(evt:MouseEvent) : void
      {
         if(!this._track)
         {
            return;
         }
         this._track = false;
         var Name:String = evt.currentTarget.name;
         this.selectedBtnName = Name;
         for(var i:* = 0; i < this.btnArr.length; i++)
         {
            if(this.btnArr[i] == Name)
            {
               this["selectMc"][Name]["selectedMc"].visible = true;
            }
            else
            {
               this["selectMc"][this.btnArr[i]]["selectedMc"].visible = false;
            }
         }
         if(Central.main.isNewAccount)
         {
            Central.main.tracking.generalTrack(Central.main.tracking.TRACK_CREATE_CHAR,"Select Element","Setp4");
            Central.main.amfClient.service("Tracking.tutTracking",[Central.main.account.getAccountSessionKey(),"STEP4"],this.trackingResponse);
         }
         this.selectSkill();
      }
      
      public function onOkBtnEffect(evt:MouseEvent) : void
      {
         for(var i:int = 0; i < this.btnArr.length; i++)
         {
            this["selectMc"][this.btnArr[i]].removeEventListener(MouseEvent.MOUSE_OVER,this.playAnimation);
            this["selectMc"][this.btnArr[i]].addEventListener(MouseEvent.MOUSE_OVER,this.playAnimation);
         }
         switch(this.selectedBtnName)
         {
            case "btnWind":
               this["selectMc"].gotoAndStop("wind");
               this["selectMc"]["elementTxt"].text = this.langArr[1];
               this["selectMc"]["displayTxt"].text = this.langArr[2];
               break;
            case "btnFire":
               this["selectMc"].gotoAndStop("fire");
               this["selectMc"]["elementTxt"].text = this.langArr[3];
               this["selectMc"]["displayTxt"].text = this.langArr[4];
               break;
            case "btnEarth":
               this["selectMc"].gotoAndStop("earth");
               this["selectMc"]["elementTxt"].text = this.langArr[5];
               this["selectMc"]["displayTxt"].text = this.langArr[6];
               break;
            case "btnWater":
               this["selectMc"].gotoAndStop("water");
               this["selectMc"]["elementTxt"].text = this.langArr[7];
               this["selectMc"]["displayTxt"].text = this.langArr[8];
               break;
            case "btnLightning":
               this["selectMc"].gotoAndStop("lightning");
               this["selectMc"]["elementTxt"].text = this.langArr[9];
               this["selectMc"]["displayTxt"].text = this.langArr[10];
         }
      }
      
      public function selectSkill(evt:MouseEvent = null) : void
      {
         var skillID:String = "skill1";
         var skillType:String = "";
         switch(this.selectedBtnName)
         {
            case "btnWater":
               skillID = "skill9";
               this.skill_swf = "skill_09";
               skillType = "WATER";
               break;
            case "btnFire":
               skillID = "skill10";
               this.skill_swf = "skill_10";
               skillType = "FIRE";
               break;
            case "btnEarth":
               skillID = "skill12";
               this.skill_swf = "skill_12";
               skillType = "EARTH";
               break;
            case "btnLightning":
               skillID = "skill1";
               this.skill_swf = "skill_01";
               skillType = "LIGHTNING";
               break;
            case "btnWind":
               skillID = "skill13";
               this.skill_swf = "skill_13";
               skillType = "WIND";
         }
         if(Central.main.isNewAccount)
         {
            Central.main.tracking.generalTrack(Central.main.tracking.TRACK_CREATE_CHAR,skillType,"Setp5");
            Central.main.amfClient.service("Tracking.tutTracking",[Central.main.account.getAccountSessionKey(),"STEP5," + skillType],this.trackingResponse);
         }
         Central.main.SKILL_DATA = Central.main.dataLib.getSkill();
         Central.main.amfSeq = 0;
         if(Boolean(Central.main.isNewChar) && Boolean(Central.main.isNewCharByCreate))
         {
            Central.main.amfSeq = 1;
         }
         this.skill_id = skillID;
         Central.main.getMainChar().addInventory("skill",skillID);
         Central.main.getDBChar().character_skills = [skillID];
         Central.main.loadSwf(["swf/skills/" + this.skill_swf + ".swf"],this.updateSkillSwf);
         Central.main.getMainChar().addEventSkill(skillID);
      }
      
      public function updateSkillSwf(_swfObj:Object) : void
      {
         Central.skill.setSkill(this.skill_id,_swfObj["swf/skills/" + this.skill_swf + ".swf"]);
         var skillMc:MovieClip = Central.skill.getSkill(this.skill_id);
         Central.main.getMainChar().setSkillSwf(skillMc);
         Central.main.getMainChar().updateSkillSwf();
         this["selectMc"]["popupElementMc"].gotoAndPlay("show");
      }
      
      private function trackingResponse(obj:Object = null) : void
      {
      }
      
      public function onShowElement(mc:MovieClip) : void
      {
         mc["elementMc"].gotoAndStop(this.selectedBtnName);
      }
      
      public function callFinish() : void
      {
         this.finishCinematics();
      }
      
      private function finishCinematics() : void
      {
         Central.mission.finishCinematics();
      }
      
      internal function frame1() : *
      {
         this.stop();
      }
   }
}

