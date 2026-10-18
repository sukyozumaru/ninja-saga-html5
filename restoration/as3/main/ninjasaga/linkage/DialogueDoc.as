package ninjasaga.linkage
{
   import com.utils.GF;
   import com.utils.Out;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import ninjasaga.Central;
   import ninjasaga.data.Timeline;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol1371")]
   public class DialogueDoc extends MovieClip
   {
      
      public var npcHolderMc:MovieClip;
      
      public var BtnContinue:MovieClip;
      
      public var clickableMask:MovieClip;
      
      public var clickMc:MovieClip;
      
      public var dialogueTxt:TextField;
      
      private var curDialogueStep:uint;
      
      private var dialogueFlow:Array;
      
      private var dialogueFinish_CB:Function;
      
      private var curNPC:String;
      
      public function DialogueDoc()
      {
         super();
         addFrameScript(0,this.frame1,17,this.frame18);
      }
      
      public function show(param1:Array, param2:uint) : void
      {
         this.dialogueFlow = param1;
         this.curDialogueStep = param2;
         this.gotoAndPlay(Timeline.SHOW);
      }
      
      public function hide() : void
      {
         this.gotoAndStop(Timeline.IDLE);
      }
      
      private function onShow() : void
      {
         this.stop();
         this.setupDialogue();
      }
      
      public function setDialogueCB(param1:Function) : void
      {
         this.dialogueFinish_CB = param1;
      }
      
      public function setupDialogue() : void
      {
         var _loc1_:Object = this.dialogueFlow[this.curDialogueStep];
         this.setDialogueText(this.dialogueFlow[this.curDialogueStep].text);
         this["clickableMask"].addEventListener(MouseEvent.CLICK,this.nextDialogue);
         this["clickMc"]["txtMc"]["txt"].text = Central.main.langLib.get(1574);
         if(Central.main.getMainChar().xp == 0 && Central.main.getMainChar().getLevel() == 1)
         {
            this["BtnContinue"].visible = true;
            Central.main.initButton(this["BtnContinue"],this.nextDialogue,Central.main.langLib.get(1662)[9]);
         }
         else
         {
            this["BtnContinue"].visible = false;
            Central.main.disableButton(this["BtnContinue"],this.nextDialogue,Central.main.langLib.get(1662)[9]);
         }
         if(this.dialogueFlow[this.curDialogueStep].npc)
         {
            this.curNPC = this.dialogueFlow[this.curDialogueStep].npc;
            this["npcHolderMc"].addChild(Central.mission.getMovieClip(this.curNPC));
         }
         else
         {
            this["npcHolderMc"].addChild(Central.mission.getMovieClip("closeup"));
         }
      }
      
      private function nextDialogue(param1:Event) : void
      {
         ++this.curDialogueStep;
         var _loc2_:Object = this.dialogueFlow[this.curDialogueStep];
         switch(_loc2_.type)
         {
            case Central.mission.EVT_TEXT:
               if(this.dialogueFlow[this.curDialogueStep].npc != null && this.curNPC != this.dialogueFlow[this.curDialogueStep].npc)
               {
                  this.curNPC = this.dialogueFlow[this.curDialogueStep].npc;
                  GF.removeAllChild(this["npcHolderMc"]);
                  this["npcHolderMc"].addChild(Central.mission.getMovieClip(this.curNPC));
               }
               this.setDialogueText(_loc2_.text);
               break;
            default:
               this.addInfoPlayTrack();
               this.hide();
               Central.mission.dialogueFinish(this.curDialogueStep - 1);
         }
      }
      
      private function setDialogueText(param1:String) : void
      {
         param1 = param1.replace("[playername]",Central.main.getMainChar().getCharacterName());
         this["dialogueTxt"].text = param1;
      }
      
      private function addInfoPlayTrack() : void
      {
         if(Central.mission.curMissionID == "msn0")
         {
            try
            {
               switch(Central.mission.curMissionStep)
               {
                  case 1:
                     break;
                  case 2:
                     if(this.curDialogueStep == 1)
                     {
                        if(Central.main.isNewAccount)
                        {
                           Central.main.tracking.generalTrack(Central.main.tracking.TRACK_CREATE_CHAR,"CLICK_DIALOG_2","Step10");
                           Central.main.amfClient.service("Tracking.tutTracking",[Central.main.account.getAccountSessionKey(),"STEP10"],this.trackingResponse);
                        }
                        Central.main.exitFromTutorial = true;
                     }
                     else if(this.curDialogueStep == 3)
                     {
                        break;
                     }
                  case 3:
                  case 4:
               }
            }
            catch(err:Error)
            {
               Out.error(this,"TRACKING :: TRACK2_TUTORIAL >> TRACK2_CLICK_DIALOG1/2/3" + err.message);
            }
         }
      }
      
      private function trackingResponse(param1:Object = null) : void
      {
      }
      
      internal function frame1() : *
      {
         this.stop();
      }
      
      internal function frame18() : *
      {
         this.onShow();
      }
   }
}

