package
{
   import com.utils.Mixer;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.media.Sound;
   import ninjasaga.Account;
   import ninjasaga.Central;
   import ninjasaga.base.MissionBase;
   import ninjasaga.data.DBCharacterData;
   import ninjasaga.data.GameEvents;
   import ninjasaga.data.MissionData;
   
   [SWF(width="550", height="400", backgroundColor="#ffffff", frameRate="24")]
   public class Mission_01 extends MissionBase
   {
      
      private static var data_1:Array;
      
      private static var data_2:Array;
      
      private static var data_3:Array;
      
      private static var data_4:Array;
      
      private static var Skill_List:Array;
      
      private static var Other_Dialog:Array;
      
      private static var Main_Dialog:Array;
      
      private var langFile:* = new Mission_01_Language();
      
      private var BGMMusic:Sound;
      
      private var selectedSkillType:String;
      
      private var selectedSkillName:String;
      
      public const type:String = "normal";
      
      public function Mission_01()
      {
         super();
         this._rewards.items = ["item1","item1","item2","item2","item3","item3"];
      }
      
      override protected function initData() : void
      {
         data_1 = [{
            "type":MissionData.EVT_TEXT,
            "text":""
         },{
            "type":MissionData.EVT_BATTLE,
            "enemies":[{
               "name":"Target Dummy",
               "swfName":"ene_01",
               "clsName":"Ene_01"
            }]
         }];
         data_2 = [{},{
            "type":MissionData.EVT_BATTLE,
            "enemies":[{
               "name":"Target Dummy",
               "swfName":"ene_01",
               "clsName":"Ene_01"
            }]
         }];
         if(Account.getAccountId() % 2 == 0)
         {
            data_2[0] = {
               "type":MissionData.EVT_MC,
               "name":"Mission_01_StoryMC2",
               "fn":null
            };
         }
         else
         {
            data_2[0] = {
               "type":MissionData.EVT_MC,
               "name":"Mission_01_StoryMC2",
               "fn":null
            };
         }
         data_3 = [{
            "type":MissionData.EVT_TEXT,
            "text":""
         },{
            "type":MissionData.EVT_END,
            "fn":Central.battle.startATB
         }];
         data_4 = [{
            "type":MissionData.EVT_TEXT,
            "text":""
         },{
            "type":MissionData.EVT_FINISH,
            "fn":Central.main.gotoMap
         }];
         Skill_List = [{"text":""},{"text":""},{"text":""},{"text":""},{"text":""}];
         Other_Dialog = [{"text":""}];
         Main_Dialog = [{"text":""},{"text":""}];
         data_1[0].text = this.langFile.textArr[0];
         data_1[1].text = this.langFile.textArr[1];
         data_2[1].text = this.langFile.textArr[3];
         data_3[0].text = this.langFile.textArr[4];
         data_4[0].text = this.langFile.textArr[5];
         Skill_List[0].text = this.langFile.textArr[6];
         Skill_List[1].text = this.langFile.textArr[7];
         Skill_List[2].text = this.langFile.textArr[8];
         Skill_List[3].text = this.langFile.textArr[9];
         Skill_List[4].text = this.langFile.textArr[10];
         Other_Dialog[0].text = this.langFile.textArr[11];
         Main_Dialog[0].text = this.langFile.textArr[12];
         Main_Dialog[1].text = this.langFile.textArr[13];
      }
      
      public function getData(_step:uint, _evt:String = "") : Array
      {
         Central.battle.setBattleBg(MovieClip(new BattleBG()));
         if(this.BGMMusic == null)
         {
            this.BGMMusic = Sound(Central.main.getLib("TutorialBGM"));
         }
         if(_step == 0 && _evt == null)
         {
            Central.main.getMainChar().updateData(DBCharacterData.SESSION_PLAYTIME,Central.main.getMainChar().getData(DBCharacterData.SESSION_PLAYTIME) + 1);
            return data_2;
         }
         if(_step == 1)
         {
            if(_evt == GameEvents.BATTLE_SHOW_ACTION_BAR)
            {
               if(Central.main.getMainChar().cp >= 30 && !Central.main.getMainChar().isBattleSkillCooldown(Central.main.SKILL_DATA[Central.main.getMainChar().getSkillListArr()[0]].id) && Central.main.tutorialMsnStep < 2)
               {
                  Central.battle.showTutorialTips("skill");
                  return [{
                     "type":MissionData.EVT_BATTLE_BUTTON,
                     "buttonArr":["skill_0"]
                  }];
               }
               if(Central.main.tutorialMsnStep == 2)
               {
                  Central.battle.showTutorialTips("attack");
                  return [{
                     "type":MissionData.EVT_BATTLE_BUTTON,
                     "buttonArr":["btnAttack"]
                  }];
               }
               Central.battle.showTutorialTips("charge");
               return [{
                  "type":MissionData.EVT_BATTLE_BUTTON,
                  "buttonArr":["btnCharge"]
               }];
            }
            if(_evt == GameEvents.BATTLE_FINISH)
            {
               Central.main.getMainChar().updateData(DBCharacterData.SESSION_PLAYTIME,Central.main.getMainChar().getData(DBCharacterData.SESSION_PLAYTIME) + 1);
               Central.battle.battleFinish();
               Mixer.getInstance().stopMusic();
               Central.battle.setBattleBg(null);
               return data_4;
            }
         }
         return null;
      }
      
      public function customizeCharacter(_mc:MovieClip) : void
      {
         Central.main.getMainChar().cloneStaticFullBody(_mc["mainChar"]);
         _mc["popupMc"]["testmsgTxt"].text = Main_Dialog[0].text;
      }
      
      public function initSkillSelection(_mc:MovieClip) : void
      {
         var i:uint = 0;
         var btnArr:Array = ["btnWater","btnFire","btnEarth","btnLightning","btnWind"];
         for(i = 0; i < btnArr.length; i++)
         {
            _mc[btnArr[i]].addEventListener(MouseEvent.CLICK,this.selectSkill);
            _mc[btnArr[i]].addEventListener(MouseEvent.MOUSE_OVER,this.showBtnTooltip);
            _mc[btnArr[i]].addEventListener(MouseEvent.MOUSE_OUT,this.hideBtnTooltip);
         }
         _mc["dialogueTxt"].text = Other_Dialog[0].text;
      }
      
      private function showBtnTooltip(evt:MouseEvent) : void
      {
         var Name:String = evt.currentTarget.name;
         var Mc:MovieClip = MovieClip(evt.currentTarget.parent);
         switch(Name)
         {
            case "btnWater":
               Mc["lbl_school_desc"].text = Skill_List[0].text;
               break;
            case "btnFire":
               Mc["lbl_school_desc"].text = Skill_List[1].text;
               break;
            case "btnEarth":
               Mc["lbl_school_desc"].text = Skill_List[2].text;
               break;
            case "btnLightning":
               Mc["lbl_school_desc"].text = Skill_List[3].text;
               break;
            case "btnWind":
               Mc["lbl_school_desc"].text = Skill_List[4].text;
         }
      }
      
      private function hideBtnTooltip(evt:MouseEvent) : void
      {
         var Name:String = evt.currentTarget.name;
         var Mc:MovieClip = MovieClip(evt.currentTarget.parent);
         Mc["lbl_school_desc"].text = "";
      }
      
      public function selectSkill(evt:MouseEvent) : void
      {
         var skillID:String = "skill1";
         var skillType:String = "";
         switch(evt.currentTarget.name)
         {
            case "btnWater":
               skillID = "skill9";
               skillType = "WATER";
               break;
            case "btnFire":
               skillID = "skill10";
               skillType = "FIRE";
               break;
            case "btnEarth":
               skillID = "skill12";
               skillType = "EARTH";
               break;
            case "btnLightning":
               skillID = "skill1";
               skillType = "LIGHTNING";
               break;
            case "btnWind":
               skillID = "skill13";
               skillType = "WIND";
         }
         this.selectedSkillType = Central.main.SKILL_DATA[skillID].type;
         this.selectedSkillName = Central.main.SKILL_DATA[skillID].name;
         if(Central.main.isNewAccount)
         {
            Central.main.tracking.generalTrack(Central.main.tracking.TRACK_CREATE_CHAR,skillType,"Setp5");
            Central.main.amfClient.service("Tracking.tutTracking",[Central.main.account.getAccountSessionKey(),"STEP5," + skillType],new Function());
         }
         Central.main.getMainChar().addInventory("skill",skillID);
         Central.main.getMainChar().setSkillList([skillID]);
         Central.main.getMainChar().addEventSkill(skillID);
         Central.main.amfClient.service("CharacterService.selectFreeSkill",[Central.main.account.getAccountSessionKey(),skillID],Central.main.onAmfResult);
         this.finishCinematics();
      }
      
      private function finishCinematics() : void
      {
         Central.mission.finishCinematics();
      }
   }
}

