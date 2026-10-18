package ninjasaga.linkage
{
   import br.com.stimuli.loading.BulkErrorEvent;
   import com.utils.AssociateArray;
   import com.utils.GF;
   import com.utils.Out;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.TimerEvent;
   import flash.geom.Point;
   import flash.utils.Timer;
   import gs.TweenLite;
   import ninjasaga.*;
   import ninjasaga.data.BattleData;
   import ninjasaga.data.DBCharacterData;
   import ninjasaga.data.Data;
   import ninjasaga.data.PositionType;
   import ninjasaga.data.RankData;
   import ninjasaga.data.Timeline;
   import ninjasaga.loader.AssetLoader;
   
   public class BattleDoc extends MovieClip
   {
      
      private const DEBUG_GOD_MODE_AP_ALLOWED:Boolean = false;
      
      public var PvpCloseUpObj:Object = {};
      
      private var rematchTimeLimit:int = 0;
      
      private var rematchTimer:Timer;
      
      private var rematchRepeat:int = 0;
      
      public function BattleDoc()
      {
         super();
      }
      
      public function gotoIdle() : void
      {
         stage.focus = null;
         this.gotoAndStop(Timeline.IDLE);
      }
      
      public function gotoBattleStart() : void
      {
         this.gotoAndPlay(Timeline.START);
      }
      
      public function gotoBattle() : void
      {
         this.gotoAndStop(Timeline.BATTLE);
      }
      
      public function gotoWin() : void
      {
         this.resetCharacterDepth();
         this.gotoAndPlay(Timeline.WIN);
      }
      
      public function gotoPvPWin() : void
      {
         this.resetCharacterDepth();
         this.gotoAndStop("pvp_win");
      }
      
      public function gotoPvPWinQuick() : void
      {
         this.resetCharacterDepth();
         this.gotoAndStop("pvp_win_2015a");
      }
      
      public function gotoPvPaiWin() : void
      {
         this.resetCharacterDepth();
         this.gotoAndStop("pvp_win_ai");
      }
      
      public function gotoPvPailose() : void
      {
         this.resetCharacterDepth();
         this.gotoAndStop("pvp_lose_ai");
      }
      
      public function gotoPveWin() : void
      {
         this.resetCharacterDepth();
         this.gotoAndStop("pve_win");
      }
      
      public function gotoPvPWinTournament() : void
      {
         this.resetCharacterDepth();
         this.gotoAndStop("pvp_win_2015a");
      }
      
      public function gotoPvPLose() : void
      {
         this.resetCharacterDepth();
         this.gotoAndStop("pvp_lose");
      }
      
      public function gotoPvPLoseQuick() : void
      {
         this.resetCharacterDepth();
         this.gotoAndStop("pvp_lose_2015a");
      }
      
      public function gotoPvPLoseTournament() : void
      {
         this.resetCharacterDepth();
         this.gotoAndStop("pvp_lose_2015a");
      }
      
      public function gotoClanResult() : void
      {
         this.resetCharacterDepth();
         this.gotoAndStop("clan_result");
      }
      
      private function onClanResult() : void
      {
         Central.battle.onClanResult();
      }
      
      public function resetCharacterDepth() : void
      {
         var _loc1_:int = 0;
         this.setChildIndex(this["bgHolder"],_loc1_);
         this.setChildIndex(this["partyMc_2"],_loc1_ + 6);
         this.setChildIndex(this["playerMc_1"],_loc1_ + 4);
         this.setChildIndex(this["partyMc_1"],_loc1_ + 2);
         this.setChildIndex(this["partyPetMc2"],_loc1_ + 5);
         this.setChildIndex(this["playerPetMc"],_loc1_ + 3);
         this.setChildIndex(this["partyPetMc1"],_loc1_ + 1);
         this.setChildIndex(this["enemyMc_3"],_loc1_ + 12);
         this.setChildIndex(this["enemyMc_1"],_loc1_ + 10);
         this.setChildIndex(this["enemyMc_2"],_loc1_ + 8);
         this.setChildIndex(this["enemyPetMc_3"],_loc1_ + 11);
         this.setChildIndex(this["enemyPetMc_1"],_loc1_ + 9);
         this.setChildIndex(this["enemyPetMc_2"],_loc1_ + 7);
      }
      
      private function onInit() : void
      {
         var j:int;
         var mainChar:*;
         var petSwf:MovieClip = null;
         var swf:MovieClip = null;
         var i:uint = 0;
         var enemyArr:Array = null;
         var partyNpc:Array = null;
         var partyMembers:Array = null;
         var singleBattle:Boolean = false;
         var member:* = undefined;
         var enemy:* = undefined;
         var aiChars:Array = null;
         var char:* = undefined;
         var charId:String = null;
         var teamA:Array = null;
         var teamB:Array = null;
         var selfTeam:Array = null;
         var opponentsTeam:Array = null;
         var teamAPost:int = 0;
         var teamBPost:int = 0;
         var opponents:Array = null;
         var opponent:* = undefined;
         var opponentId:String = null;
         var MAX_PARTY_MENBER:int = 0;
         var tmpInt:int = 0;
         var tmpMC:MovieClip = null;
         var clickMask:Sprite = null;
         var team:String = null;
         var post:String = null;
         var setMainCharMc:String = null;
         var setMainPetMc:String = null;
         var teamPostMc:String = null;
         var teamPetPostMc:String = null;
         var charTeam:String = null;
         var havePlayer:Boolean = false;
         this.stop();
         Central.battle.initBattle(this);
         i = 0;
         j = 0;
         mainChar = Central.main.getMainChar();
         mainChar.isDead = false;
         mainChar.playStandby();
         if(this.onInitIsMainCharacterHack(mainChar) && !DEBUG_GOD_MODE_AP_ALLOWED)
         {
            Central.main.onError("297","");
            return;
         }
         this["detail_box_" + 1].visible = false;
         this["detail_box_" + 2].visible = false;
         this["detail_box_" + 3].visible = false;
         if(Central.battle.type == Central.battle.TYPE_LOCAL)
         {
            swf = mainChar.getSwf();
            swf.scaleX *= -Data.BATTLE_CHAR_SCALE;
            swf.scaleY *= Data.BATTLE_CHAR_SCALE;
            this["playerMc_1"]["charMc"].addChild(swf);
            mainChar.setCharMc(this["playerMc_1"]["charMc"]);
            mainChar.updateBattleFrame();
            if(mainChar.pet)
            {
               trace(">>>>>>>>>>>>>>>>>>>>>>>>>>>mainChar.pet is not null");
               petSwf = mainChar.pet.getSwf();
               petSwf.scaleX *= -Data.BATTLE_CHAR_SCALE;
               petSwf.scaleY *= Data.BATTLE_CHAR_SCALE;
               this["playerPetMc"]["charMc"].addChild(petSwf);
               mainChar.pet.playStandby();
               mainChar.pet.setCharMc(this["playerPetMc"]["charMc"]);
               mainChar.pet.updateBattleFrame();
               Central.battle.addPet(mainChar.pet);
            }
            else
            {
               this["playerPetMc"].visible = false;
            }
            i = 1;
            while(i <= 2)
            {
               this["partyMc_" + i].visible = false;
               this["partyPetMc" + i].visible = false;
               i++;
            }
            i = 1;
            while(i <= 3)
            {
               this["enemyPetMc_" + String(i)].visible = false;
               i++;
            }
         }
         if(Central.battle.type == Central.battle.TYPE_LOCAL)
         {
            partyNpc = Central.main.getPartyNpc();
            partyMembers = Central.main.partyMembers;
            singleBattle = false;
            if(Central.mission.curMission)
            {
               if(Central.mission.curMission.singleBattle == true)
               {
                  singleBattle = true;
               }
            }
            if(partyNpc)
            {
               i = 0;
               while(i < partyNpc.length)
               {
                  if(!partyNpc[i].isDead)
                  {
                     member = partyNpc[i];
                     if(this.onInitIsPartyCharacterHack(member) && !DEBUG_GOD_MODE_AP_ALLOWED)
                     {
                        Central.main.onError("2979","");
                        return;
                     }
                  }
                  i++;
               }
            }
            j = 0;
            if(Boolean(partyNpc) && Boolean(Central.battle.subType != BattleData.SUBTYPE_CLAN) && singleBattle == false)
            {
               i = 0;
               while(i < partyNpc.length)
               {
                  if(!partyNpc[i].isDead)
                  {
                     member = partyNpc[i];
                     if(Central.mission.curMission == null)
                     {
                        member.restoreOriginalStatus();
                        member.isDead = false;
                     }
                     member.playStandby();
                     swf = member.getSwf();
                     swf.scaleX *= -Data.BATTLE_CHAR_SCALE;
                     swf.scaleY *= Data.BATTLE_CHAR_SCALE;
                     this["partyMc_" + (j + 1)]["charMc"].addChild(swf);
                     this["partyMc_" + (j + 1)].visible = true;
                     this["partyMc_" + (j + 1)].char = member;
                     member.setCharMc(this["partyMc_" + (j + 1)]["charMc"]);
                     Central.battle.addParty(member);
                     if(member.pet)
                     {
                        petSwf = member.pet.getSwf();
                        petSwf.scaleX *= Data.BATTLE_CHAR_SCALE;
                        petSwf.scaleY *= Data.BATTLE_CHAR_SCALE;
                        this["partyPetMc" + String(j + 1)]["charMc"].addChild(petSwf);
                        this["partyPetMc" + String(j + 1)].visible = true;
                        member.pet.playStandby();
                        member.pet.restoreOriginalStatus();
                        member.pet.setCharMc(this["partyPetMc" + String(j + 1)]["charMc"]);
                        member.pet.updateBattleFrame();
                        Central.battle.addPet(member.pet);
                     }
                     else
                     {
                        this["partyPetMc" + String(j + 1)].visible = false;
                     }
                     j++;
                  }
                  i++;
               }
            }
            if(partyMembers != null)
            {
               i = 0;
               while(i < partyMembers.length)
               {
                  if(!partyMembers[i].isDead)
                  {
                     member = partyMembers[i];
                     if(Data.LEVEL_HACK_SKIP.indexOf(Central.mission.curMissionID) < 0)
                     {
                        if(this.isLevelHack(member))
                        {
                           Central.main.onError("2978","");
                           return;
                        }
                     }
                     if(Central.mission.curMission == null)
                     {
                        member.restoreOriginalStatus();
                        member.isDead = false;
                     }
                     member.playStandby();
                     swf = member.getSwf();
                     swf.scaleX *= -Data.BATTLE_CHAR_SCALE;
                     swf.scaleY *= Data.BATTLE_CHAR_SCALE;
                     this["partyMc_" + (j + 1)]["charMc"].addChild(swf);
                     this["partyMc_" + (j + 1)].visible = true;
                     this["partyMc_" + (j + 1)].char = member;
                     member.setCharMc(this["partyMc_" + (j + 1)]["charMc"]);
                     Central.battle.addParty(member);
                     if(member.pet)
                     {
                        petSwf = member.pet.getSwf();
                        petSwf.scaleX *= Data.BATTLE_CHAR_SCALE;
                        petSwf.scaleY *= Data.BATTLE_CHAR_SCALE;
                        this["partyPetMc" + String(j + 1)]["charMc"].addChild(petSwf);
                        this["partyPetMc" + String(j + 1)].visible = true;
                        member.pet.playStandby();
                        member.pet.restoreOriginalStatus();
                        member.pet.setCharMc(this["partyPetMc" + String(j + 1)]["charMc"]);
                        member.pet.updateBattleFrame();
                        Central.battle.addPet(member.pet);
                     }
                     else
                     {
                        this["partyPetMc" + String(j + 1)].visible = false;
                     }
                     j++;
                  }
                  i++;
               }
            }
            enemyArr = Central.main.getEnemy();
            if(enemyArr == null)
            {
               aiChars = Central.main.getAIChars();
               i = 0;
               while(i < aiChars.length)
               {
                  char = aiChars[i];
                  char.restoreOriginalStatus();
                  char.isDead = false;
                  char.playStandby();
                  swf = char.getSwf();
                  swf.scaleX *= Data.BATTLE_CHAR_SCALE;
                  swf.scaleY *= Data.BATTLE_CHAR_SCALE;
                  this["enemyMc_" + (i + 1)]["charMc"].addChild(swf);
                  this["enemyMc_" + (i + 1)].visible = true;
                  this["enemyMc_" + (i + 1)].char = char;
                  char.setCharMc(this["enemyMc_" + (i + 1)]["charMc"]);
                  Central.battle.addEnemy(char);
                  if(char.pet)
                  {
                     petSwf = char.pet.getSwf();
                     petSwf.scaleX *= Data.BATTLE_CHAR_SCALE;
                     petSwf.scaleY *= Data.BATTLE_CHAR_SCALE;
                     this["enemyPetMc_" + String(i + 1)]["charMc"].addChild(petSwf);
                     this["enemyPetMc_" + String(i + 1)].visible = true;
                     char.pet.playStandby();
                     char.pet.restoreOriginalStatus();
                     char.pet.setCharMc(this["enemyPetMc_" + String(i + 1)]["charMc"]);
                     char.pet.updateBattleFrame();
                     char.pet.side = BattleData.SIDE_HOSTILE;
                     Central.battle.addPet(char.pet);
                  }
                  else
                  {
                     this["enemyPetMc_" + String(i + 1)].visible = false;
                  }
                  i++;
               }
               i = 3;
               while(i > aiChars.length)
               {
                  this["enemyMc_" + i].visible = false;
                  i--;
               }
            }
            else
            {
               i = 0;
               while(i < enemyArr.length)
               {
                  enemy = Central.main.createEnemy(enemyArr[i]);
                  enemy.isDead = false;
                  enemy.playStandby();
                  swf = enemy.getSwf();
                  swf.scaleX *= Data.BATTLE_CHAR_SCALE;
                  swf.scaleY *= Data.BATTLE_CHAR_SCALE;
                  this["enemyMc_" + (i + 1)]["charMc"].addChild(swf);
                  this["enemyMc_" + (i + 1)].visible = true;
                  this["enemyMc_" + (i + 1)].char = enemy;
                  enemy.setCharMc(this["enemyMc_" + (i + 1)]["charMc"]);
                  Central.battle.addEnemy(enemy);
                  i++;
               }
               i = 3;
               while(i > enemyArr.length)
               {
                  this["enemyMc_" + i].visible = false;
                  i--;
               }
            }
         }
         if(Central.battle.type == Central.battle.TYPE_NETWORK)
         {
            charId = Central.main.getMainChar().getData(DBCharacterData.ID);
            teamA = Central.main.PvpTeamA;
            teamB = Central.main.PvpTeamB;
            teamAPost = 0;
            teamBPost = 0;
            opponents = Central.main.battleChars;
            if(Central.main.PvpPlayerPlace == "quick")
            {
               i = 1;
               while(i <= 2)
               {
                  this["partyMc_" + i].charID = null;
                  this["partyMc_" + i].visible = false;
                  this["partyPetMc" + i].visible = false;
                  i++;
               }
               i = 1;
               while(i <= 3)
               {
                  this["enemyPetMc_" + String(i)].visible = false;
                  i++;
               }
               i = 1;
               while(i <= 3)
               {
                  try
                  {
                     this["enemyMc_" + i].charID = null;
                     this["enemyMc_" + i].visible = false;
                  }
                  catch(err:Error)
                  {
                     Out.error("BattleDoc.as >> "," no >> enemyMc_ " + i);
                  }
                  i++;
               }
            }
            else if(Central.main.PvpPlayerPlace == "tournament")
            {
               i = 1;
               while(i <= 2)
               {
                  this["partyMc_" + i].charID = null;
                  this["partyMc_" + i].visible = false;
                  this["partyPetMc" + i].visible = false;
                  i++;
               }
               i = 1;
               while(i <= 3)
               {
                  this["enemyPetMc_" + String(i)].visible = false;
                  i++;
               }
               i = 1;
               while(i <= 3)
               {
                  try
                  {
                     this["enemyMc_" + i].charID = null;
                     this["enemyMc_" + i].visible = false;
                  }
                  catch(err:Error)
                  {
                     Out.error("BattleDoc.as >> "," no >> enemyMc_ " + i);
                  }
                  i++;
               }
            }
            else if(Central.main.PvpPlayerPlace == "private")
            {
               this["playerPetMc"].visible = false;
               this["partyPetMc1"].visible = false;
               this["partyPetMc2"].visible = false;
               this["enemyPetMc_1"].visible = false;
               this["enemyPetMc_2"].visible = false;
               this["enemyPetMc_3"].visible = false;
               this["partyMc_1"].charID = null;
               this["partyMc_2"].charID = null;
               this["enemyMc_2"].charID = null;
               this["enemyMc_3"].charID = null;
               switch(Central.main.PvpPVMode)
               {
                  case 1:
                     this["partyMc_1"].visible = false;
                     this["partyMc_2"].visible = false;
                     this["enemyMc_2"].visible = false;
                     this["enemyMc_3"].visible = false;
                     break;
                  case 2:
                     this["partyMc_2"].visible = false;
                     this["enemyMc_3"].visible = false;
                     break;
                  case 3:
               }
            }
            else if(Central.main.PvpPlayerPlace == "PVE")
            {
               this["playerPetMc"].visible = false;
               this["partyPetMc1"].visible = false;
               this["partyPetMc2"].visible = false;
               this["enemyPetMc_1"].visible = false;
               this["enemyPetMc_2"].visible = false;
               this["enemyPetMc_3"].visible = false;
               this["partyMc_1"].charID = null;
               this["partyMc_2"].charID = null;
               this["enemyMc_2"].charID = null;
               this["enemyMc_3"].charID = null;
               enemyArr = Central.main.getEnemy();
               i = 0;
               while(i < enemyArr.length)
               {
                  if(Boolean(enemyArr[i].limb) && enemyArr[i].limb > 1)
                  {
                     switch(i)
                     {
                        case 0:
                           tmpInt = 1;
                           break;
                        case 1:
                           tmpInt = 0;
                           break;
                        default:
                           tmpInt = int(i);
                     }
                  }
                  else
                  {
                     tmpInt = int(i);
                  }
                  enemyArr[i].PvEID = enemyArr[i].id.replace("enemy","") + tmpInt;
                  enemy = Central.main.createEnemy(enemyArr[i]);
                  trace("enemy.getCharacterId()" + enemy.getCharacterId());
                  trace("enemy.PvEID()" + enemyArr[i].name);
                  enemy.isDead = false;
                  enemy.playStandby();
                  swf = enemy.getSwf();
                  swf.scaleX *= Data.BATTLE_CHAR_SCALE;
                  swf.scaleY *= Data.BATTLE_CHAR_SCALE;
                  if(Boolean(enemyArr[i].limb) && enemyArr[i].limb > 1)
                  {
                     if(i == 0)
                     {
                        this["enemyMc_" + (i + 1)]["charMc"].addChild(swf);
                     }
                     else
                     {
                        tmpMC = new MovieClip();
                        clickMask = new Sprite();
                        tmpMC.addChild(clickMask);
                        clickMask.graphics.beginFill(255);
                        clickMask.graphics.drawRect(-140,-80,200,100);
                        clickMask.graphics.endFill();
                        clickMask.alpha = 0;
                        this["enemyMc_" + (i + 1)]["charMc"].addChild(tmpMC);
                        this.setChildIndex(this["enemyMc_" + (i + 1)],13);
                     }
                  }
                  else
                  {
                     this["enemyMc_" + (i + 1)]["charMc"].addChild(swf);
                  }
                  this["enemyMc_" + (i + 1)].visible = true;
                  this["enemyMc_" + (i + 1)].char = enemy;
                  enemy.setCharMc(this["enemyMc_" + (i + 1)]["charMc"]);
                  Central.battle.addEnemy(enemy);
                  i++;
               }
               i = 3;
               while(i > enemyArr.length)
               {
                  this["enemyMc_" + i].visible = false;
                  i--;
               }
               MAX_PARTY_MENBER = 2;
               i = 0;
               while(i < MAX_PARTY_MENBER)
               {
                  if(i >= Central.main.PvpTeamA.length - 1)
                  {
                     this["partyMc_" + (i + 1)].visible = false;
                  }
                  i++;
               }
            }
            if(Central.main.PvpPlayerPost == "quick")
            {
               Central.main.PvpMainCharMc = "playerMc_1";
               swf = mainChar.getSwf();
               swf.scaleX *= -Data.BATTLE_CHAR_SCALE;
               swf.scaleY *= Data.BATTLE_CHAR_SCALE;
               if(this["playerMc_1"]["charMc"].numChildren == 0)
               {
                  this["playerMc_1"]["charMc"].addChild(swf);
               }
               mainChar.setCharMc(this["playerMc_1"]["charMc"]);
               mainChar.updateBattleFrame();
               if(mainChar.pet)
               {
                  trace(">>>>>>>>>>>>>>>>>>>>>>>>>>>mainChar.pet is not null");
                  petSwf = mainChar.pet.getSwf();
                  petSwf.scaleX *= -Data.BATTLE_CHAR_SCALE;
                  petSwf.scaleY *= Data.BATTLE_CHAR_SCALE;
                  if(this["playerPetMc"]["charMc"].numChildren == 0)
                  {
                     this["playerPetMc"]["charMc"].addChild(petSwf);
                     this["playerPetMc"]["charMc"].char = mainChar.pet;
                  }
                  mainChar.pet.playStandby();
                  mainChar.pet.setCharMc(this["playerPetMc"]["charMc"]);
                  mainChar.pet.updateBattleFrame();
                  Central.battle.addPet(mainChar.pet);
               }
               else
               {
                  this["playerPetMc"].visible = false;
               }
               if(teamA.indexOf(charId) >= 0)
               {
                  selfTeam = teamA;
                  opponentsTeam = teamB;
               }
               else if(teamB.indexOf(charId) >= 0)
               {
                  selfTeam = teamB;
                  opponentsTeam = teamA;
               }
               i = 0;
               while(i < opponents.length)
               {
                  opponent = opponents[i];
                  opponentId = opponent.getData(DBCharacterData.ID);
                  opponent.restoreOriginalStatus();
                  opponent.isDead = false;
                  opponent.playStandby();
                  swf = opponent.getSwf();
                  if(selfTeam.indexOf(opponentId) >= 0)
                  {
                     teamAPost++;
                     swf.scaleX *= -Data.BATTLE_CHAR_SCALE;
                     swf.scaleY *= Data.BATTLE_CHAR_SCALE;
                     if(this["partyMc_" + teamAPost]["charMc"].numChildren == 0)
                     {
                        this["partyMc_" + teamAPost]["charMc"].addChild(swf);
                     }
                     this["partyMc_" + teamAPost].charID = opponentId;
                     this["partyMc_" + teamAPost].visible = true;
                     this["partyMc_" + teamAPost].char = opponent;
                     opponent.setCharMc(this["partyMc_" + teamAPost]["charMc"]);
                     Central.battle.addParty(opponent);
                     if(opponent.pet)
                     {
                        petSwf = opponent.pet.getSwf();
                        petSwf.scaleX *= -Data.BATTLE_CHAR_SCALE;
                        petSwf.scaleY *= Data.BATTLE_CHAR_SCALE;
                        if(this["partyPetMc" + teamAPost]["charMc"].numChildren == 0)
                        {
                           this["partyPetMc" + teamAPost]["charMc"].addChild(petSwf);
                           this["partyPetMc" + teamAPost]["charMc"].char = opponent.pet;
                        }
                        this["partyPetMc" + teamAPost].visible = true;
                        opponent.pet.playStandby();
                        opponent.pet.restoreOriginalStatus();
                        opponent.pet.setCharMc(this["partyPetMc" + teamAPost]["charMc"]);
                        opponent.pet.updateBattleFrame();
                        opponent.pet.side = BattleData.SIDE_HOSTILE;
                        Central.battle.addPet(opponent.pet);
                     }
                  }
                  else if(opponentsTeam.indexOf(opponentId) >= 0)
                  {
                     teamBPost++;
                     swf.scaleX *= Data.BATTLE_CHAR_SCALE;
                     swf.scaleY *= Data.BATTLE_CHAR_SCALE;
                     if(this["enemyMc_" + teamBPost]["charMc"].numChildren == 0)
                     {
                        this["enemyMc_" + teamBPost]["charMc"].addChild(swf);
                     }
                     this["enemyMc_" + teamBPost].charID = opponentId;
                     this["enemyMc_" + teamBPost].visible = true;
                     this["enemyMc_" + teamBPost].char = opponent;
                     opponent.setCharMc(this["enemyMc_" + teamBPost]["charMc"]);
                     Central.battle.addEnemy(opponent);
                     if(opponent.pet)
                     {
                        petSwf = opponent.pet.getSwf();
                        petSwf.scaleX *= Data.BATTLE_CHAR_SCALE;
                        petSwf.scaleY *= Data.BATTLE_CHAR_SCALE;
                        if(this["enemyPetMc_" + teamBPost]["charMc"].numChildren == 0)
                        {
                           this["enemyPetMc_" + teamBPost]["charMc"].addChild(petSwf);
                        }
                        this["enemyPetMc_" + teamBPost].visible = true;
                        opponent.pet.playStandby();
                        opponent.pet.restoreOriginalStatus();
                        opponent.pet.setCharMc(this["enemyPetMc_" + teamBPost]["charMc"]);
                        opponent.pet.updateBattleFrame();
                        opponent.pet.side = BattleData.SIDE_HOSTILE;
                        Central.battle.addPet(opponent.pet);
                     }
                  }
                  i++;
               }
            }
            else if(Central.main.PvpPlayerPost == "tournament")
            {
               Central.main.PvpMainCharMc = "playerMc_1";
               swf = mainChar.getSwf();
               swf.scaleX *= -Data.BATTLE_CHAR_SCALE;
               swf.scaleY *= Data.BATTLE_CHAR_SCALE;
               if(this["playerMc_1"]["charMc"].numChildren == 0)
               {
                  this["playerMc_1"]["charMc"].addChild(swf);
               }
               mainChar.setCharMc(this["playerMc_1"]["charMc"]);
               mainChar.updateBattleFrame();
               if(mainChar.pet)
               {
                  trace(">>>>>>>>>>>>>>>>>>>>>>>>>>>mainChar.pet is not null");
                  petSwf = mainChar.pet.getSwf();
                  petSwf.scaleX *= -Data.BATTLE_CHAR_SCALE;
                  petSwf.scaleY *= Data.BATTLE_CHAR_SCALE;
                  if(this["playerPetMc"]["charMc"].numChildren == 0)
                  {
                     this["playerPetMc"]["charMc"].addChild(petSwf);
                     this["playerPetMc"]["charMc"].char = mainChar.pet;
                  }
                  mainChar.pet.playStandby();
                  mainChar.pet.setCharMc(this["playerPetMc"]["charMc"]);
                  mainChar.pet.updateBattleFrame();
                  Central.battle.addPet(mainChar.pet);
               }
               else
               {
                  this["playerPetMc"].visible = false;
               }
               if(teamA.indexOf(charId) >= 0)
               {
                  selfTeam = teamA;
                  opponentsTeam = teamB;
               }
               else if(teamB.indexOf(charId) >= 0)
               {
                  selfTeam = teamB;
                  opponentsTeam = teamA;
               }
               i = 0;
               while(i < opponents.length)
               {
                  opponent = opponents[i];
                  opponentId = opponent.getData(DBCharacterData.ID);
                  opponent.restoreOriginalStatus();
                  opponent.isDead = false;
                  opponent.playStandby();
                  swf = opponent.getSwf();
                  if(selfTeam.indexOf(opponentId) >= 0)
                  {
                     teamAPost++;
                     swf.scaleX *= -Data.BATTLE_CHAR_SCALE;
                     swf.scaleY *= Data.BATTLE_CHAR_SCALE;
                     if(this["partyMc_" + teamAPost]["charMc"].numChildren == 0)
                     {
                        this["partyMc_" + teamAPost]["charMc"].addChild(swf);
                     }
                     this["partyMc_" + teamAPost].charID = opponentId;
                     this["partyMc_" + teamAPost].visible = true;
                     this["partyMc_" + teamAPost].char = opponent;
                     opponent.setCharMc(this["partyMc_" + teamAPost]["charMc"]);
                     Central.battle.addParty(opponent);
                     if(opponent.pet)
                     {
                        petSwf = opponent.pet.getSwf();
                        petSwf.scaleX *= -Data.BATTLE_CHAR_SCALE;
                        petSwf.scaleY *= Data.BATTLE_CHAR_SCALE;
                        if(this["partyPetMc" + teamAPost]["charMc"].numChildren == 0)
                        {
                           this["partyPetMc" + teamAPost]["charMc"].addChild(petSwf);
                           this["partyPetMc" + teamAPost]["charMc"].char = opponent.pet;
                        }
                        this["partyPetMc" + teamAPost].visible = true;
                        opponent.pet.playStandby();
                        opponent.pet.restoreOriginalStatus();
                        opponent.pet.setCharMc(this["partyPetMc" + teamAPost]["charMc"]);
                        opponent.pet.updateBattleFrame();
                        opponent.pet.side = BattleData.SIDE_HOSTILE;
                        Central.battle.addPet(opponent.pet);
                     }
                  }
                  else if(opponentsTeam.indexOf(opponentId) >= 0)
                  {
                     teamBPost++;
                     swf.scaleX *= Data.BATTLE_CHAR_SCALE;
                     swf.scaleY *= Data.BATTLE_CHAR_SCALE;
                     if(this["enemyMc_" + teamBPost]["charMc"].numChildren == 0)
                     {
                        this["enemyMc_" + teamBPost]["charMc"].addChild(swf);
                     }
                     this["enemyMc_" + teamBPost].charID = opponentId;
                     this["enemyMc_" + teamBPost].visible = true;
                     this["enemyMc_" + teamBPost].char = opponent;
                     opponent.setCharMc(this["enemyMc_" + teamBPost]["charMc"]);
                     Central.battle.addEnemy(opponent);
                     if(opponent.pet)
                     {
                        petSwf = opponent.pet.getSwf();
                        petSwf.scaleX *= Data.BATTLE_CHAR_SCALE;
                        petSwf.scaleY *= Data.BATTLE_CHAR_SCALE;
                        if(this["enemyPetMc_" + teamBPost]["charMc"].numChildren == 0)
                        {
                           this["enemyPetMc_" + teamBPost]["charMc"].addChild(petSwf);
                        }
                        this["enemyPetMc_" + teamBPost].visible = true;
                        opponent.pet.playStandby();
                        opponent.pet.restoreOriginalStatus();
                        opponent.pet.setCharMc(this["enemyPetMc_" + teamBPost]["charMc"]);
                        opponent.pet.updateBattleFrame();
                        opponent.pet.side = BattleData.SIDE_HOSTILE;
                        Central.battle.addPet(opponent.pet);
                     }
                  }
                  i++;
               }
            }
            else if(Central.main.PvpPlayerPlace == "private" || Central.main.PvpPlayerPlace == "PVE")
            {
               if(teamA.indexOf(charId) >= 0)
               {
                  selfTeam = teamA;
                  opponentsTeam = teamB;
               }
               else if(teamB.indexOf(charId) >= 0)
               {
                  selfTeam = teamB;
                  opponentsTeam = teamA;
               }
               swf = mainChar.getSwf();
               j = 0;
               for(; j < Central.main.PvpPVMode; j++)
               {
                  if(selfTeam[j] == charId)
                  {
                     team = "A";
                     post = String(j);
                     swf.scaleX *= -Data.BATTLE_CHAR_SCALE;
                     swf.scaleY *= Data.BATTLE_CHAR_SCALE;
                     if(mainChar.pet)
                     {
                        petSwf = mainChar.pet.getSwf();
                        petSwf.scaleX *= -Data.BATTLE_CHAR_SCALE;
                        petSwf.scaleY *= Data.BATTLE_CHAR_SCALE;
                     }
                     switch(post)
                     {
                        case "0":
                           setMainCharMc = "playerMc_1";
                           setMainPetMc = "playerPetMc";
                           break;
                        case "1":
                           setMainCharMc = "partyMc_1";
                           setMainPetMc = "partyPetMc1";
                           break;
                        case "2":
                           setMainCharMc = "partyMc_2";
                           setMainPetMc = "partyPetMc2";
                     }
                  }
                  if(opponentsTeam[j] != charId)
                  {
                     continue;
                  }
                  team = "B";
                  post = String(j);
                  swf.scaleX *= Data.BATTLE_CHAR_SCALE;
                  swf.scaleY *= Data.BATTLE_CHAR_SCALE;
                  if(mainChar.pet)
                  {
                     petSwf = mainChar.pet.getSwf();
                     petSwf.scaleX *= Data.BATTLE_CHAR_SCALE;
                     petSwf.scaleY *= Data.BATTLE_CHAR_SCALE;
                  }
                  switch(post)
                  {
                     case "0":
                        setMainCharMc = "enemyMc_1";
                        setMainPetMc = "enemyPetMc_1";
                        break;
                     case "1":
                        setMainCharMc = "enemyMc_2";
                        setMainPetMc = "enemyPetMc_2";
                        break;
                     case "2":
                        setMainCharMc = "enemyMc_3";
                        setMainPetMc = "enemyPetMc_3";
                  }
               }
               this[setMainCharMc].visible = true;
               this[setMainCharMc]["charMc"].addChild(swf);
               this.PvpCloseUpObj[setMainCharMc] = mainChar;
               mainChar.setCharMc(this[setMainCharMc]["charMc"]);
               Central.main.PvpMainCharMc = setMainCharMc;
               mainChar.updateBattleFrame();
               if(mainChar.pet)
               {
                  this[setMainPetMc].visible = true;
                  this[setMainPetMc]["charMc"].addChild(petSwf);
                  mainChar.pet.playStandby();
                  mainChar.pet.setCharMc(this[setMainPetMc]["charMc"]);
                  mainChar.pet.updateBattleFrame();
                  Central.battle.addPet(mainChar.pet);
               }
               else
               {
                  Out.debug("mainChar.pet :: ","oHHHHn oooo >> ");
                  this[setMainPetMc].visible = false;
               }
               i = 0;
               while(i < opponents.length)
               {
                  opponent = opponents[i];
                  opponentId = opponent.getData(DBCharacterData.ID);
                  opponent.restoreOriginalStatus();
                  opponent.isDead = false;
                  opponent.playStandby();
                  swf = new MovieClip();
                  swf = opponent.getSwf();
                  if(opponent.pet)
                  {
                     petSwf = opponent.pet.getSwf();
                  }
                  j = 0;
                  while(j < Central.main.PvpPVMode)
                  {
                     havePlayer = false;
                     if(selfTeam[j] == opponentId)
                     {
                        teamAPost = j;
                        swf.scaleX *= -Data.BATTLE_CHAR_SCALE;
                        swf.scaleY *= Data.BATTLE_CHAR_SCALE;
                        charTeam = "A";
                        if(opponent.pet)
                        {
                           petSwf.scaleX *= -Data.BATTLE_CHAR_SCALE;
                           petSwf.scaleY *= Data.BATTLE_CHAR_SCALE;
                        }
                        switch(teamAPost)
                        {
                           case 0:
                              teamPostMc = "playerMc_1";
                              teamPetPostMc = "playerPetMc";
                              havePlayer = true;
                              break;
                           case 1:
                              teamPostMc = "partyMc_1";
                              teamPetPostMc = "partyPetMc1";
                              havePlayer = true;
                              break;
                           case 2:
                              teamPostMc = "partyMc_2";
                              teamPetPostMc = "partyPetMc2";
                              havePlayer = true;
                        }
                     }
                     if(opponentsTeam[j] == opponentId)
                     {
                        teamBPost = j;
                        swf.scaleX *= Data.BATTLE_CHAR_SCALE;
                        swf.scaleY *= Data.BATTLE_CHAR_SCALE;
                        charTeam = "B";
                        if(opponent.pet)
                        {
                           petSwf.scaleX *= Data.BATTLE_CHAR_SCALE;
                           petSwf.scaleY *= Data.BATTLE_CHAR_SCALE;
                        }
                        switch(teamBPost)
                        {
                           case 0:
                              teamPostMc = "enemyMc_1";
                              teamPetPostMc = "enemyPetMc_1";
                              havePlayer = true;
                              break;
                           case 1:
                              teamPostMc = "enemyMc_2";
                              teamPetPostMc = "enemyPetMc_2";
                              havePlayer = true;
                              break;
                           case 2:
                              teamPostMc = "enemyMc_3";
                              teamPetPostMc = "enemyPetMc_3";
                              havePlayer = true;
                        }
                     }
                     if(havePlayer == true)
                     {
                        Out.debug("set teamBPost :: ","teamPostMc >> " + teamPostMc);
                        Out.debug("set teamBPost :: ","teamPetPostMc >> " + teamPetPostMc);
                        this[teamPostMc]["charMc"].addChild(swf);
                        this[teamPostMc].charID = opponentId;
                        this[teamPostMc].visible = true;
                        this[teamPostMc].char = opponent;
                        opponent.setCharMc(this[teamPostMc]["charMc"]);
                        this.PvpCloseUpObj[teamPostMc] = opponent;
                        if(charTeam == "A")
                        {
                           Central.battle.addParty(opponent);
                        }
                        else if(charTeam == "B")
                        {
                           Central.battle.addEnemy(opponent);
                        }
                        if(opponent.pet)
                        {
                           this[teamPetPostMc]["charMc"].addChild(petSwf);
                           this[teamPetPostMc].visible = true;
                           opponent.pet.playStandby();
                           opponent.pet.restoreOriginalStatus();
                           opponent.pet.setCharMc(this[teamPetPostMc]["charMc"]);
                           opponent.pet.updateBattleFrame();
                           opponent.pet.side = BattleData.SIDE_HOSTILE;
                           Central.battle.addPet(opponent.pet);
                        }
                     }
                     j++;
                  }
                  i++;
               }
            }
         }
         this.gotoBattleStart();
      }
      
      private function onBattleStart() : void
      {
         var _loc1_:int = 0;
         this["chatDisplayMc"].visible = false;
         this["scrollDisplayMc_1"].gotoAndStop(Timeline.IDLE);
         this["scrollDisplayMc_2"].gotoAndStop(Timeline.IDLE);
         this["scrollDisplayMc_3"].gotoAndStop(Timeline.IDLE);
         if(Central.battle.type == Central.battle.TYPE_NETWORK || Central.main.HitAi == true)
         {
            if(Central.main.PvpBattleType == "quickMatch")
            {
               this["scrollDisplayMc_1"].gotoAndStop(Timeline.SHOW);
            }
            else if(Central.main.PvpBattleType == "tournament")
            {
               this["scrollDisplayMc_1"].gotoAndStop(Timeline.SHOW);
            }
            else if(Central.main.PvpBattleType == "private")
            {
               _loc1_ = 1;
               while(_loc1_ <= Central.main.PvpPVMode)
               {
                  if(Central.main.PvpPRTeamA[_loc1_] == Central.main.getMainChar().getData(DBCharacterData.ID))
                  {
                     this["scrollDisplayMc_" + _loc1_].gotoAndStop(Timeline.SHOW);
                  }
                  if(Central.main.PvpPRTeamB[_loc1_] == Central.main.getMainChar().getData(DBCharacterData.ID))
                  {
                     this["scrollDisplayMc_" + _loc1_].gotoAndStop(Timeline.SHOW);
                  }
                  _loc1_++;
               }
            }
         }
         this["battleStartMc"].gotoAndPlay(2);
         Central.battle.onBattleStart();
      }
      
      private function onBattle() : void
      {
         this.stop();
         Central.battle.startBattle();
      }
      
      private function onWin() : void
      {
         this.stop();
         Central.battle.onShowBattleWin();
      }
      
      private function onPvPWin() : void
      {
         this.stop();
         Central.battle.onShowPvPBattleWin();
      }
      
      private function onPvPaiWin() : void
      {
         this.stop();
         Central.battle.onShowPvPaiBattleWin();
      }
      
      private function onPvPaiLose() : void
      {
         this.stop();
         Central.battle.onShowPvPaiBattleLose();
      }
      
      private function onPvPLose() : void
      {
         this.stop();
         Central.battle.onShowPvPBattleLose();
      }
      
      private function onPveWin() : void
      {
         this.stop();
         Central.battle.onShowPvEBattleWin();
      }
      
      public function addCloseup() : void
      {
         var _loc1_:MovieClip = null;
         var _loc2_:Array = null;
         var _loc3_:Array = null;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:* = undefined;
         var _loc7_:MovieClip = null;
         var _loc8_:* = undefined;
         var _loc9_:* = undefined;
         var _loc10_:MovieClip = null;
         var _loc11_:int = 0;
         if(Central.battle.type == Central.battle.TYPE_LOCAL || Central.battle.type == Central.battle.TYPE_NETWORK && (Central.main.PvpPlayerPost == "PVE" || Central.main.PvpPlayerPost == "quick" || Central.main.PvpPlayerPost == "tournament"))
         {
            this["battleStartMc"]["nameTxt"].text = Central.main.getMainChar().getCharacterName();
            GF.removeAllChild(this["battleStartMc"]["playerMc"]);
            _loc1_ = Central.main.getMainChar().getStaticFullBody();
            _loc1_.scaleX *= -1;
            _loc1_.x += _loc1_.width;
            this["battleStartMc"]["playerMc"].addChild(_loc1_);
            _loc2_ = Central.battle.enemyArr;
            _loc3_ = Central.battle.partyArr;
            _loc4_ = 0;
            while(_loc4_ < _loc3_.length)
            {
               _loc6_ = _loc3_[_loc4_];
               _loc7_ = _loc6_.getStaticFullBody();
               _loc7_.scaleX *= -1;
               this["battleStartMc"]["partyMc" + (_loc4_ + 1)].addChild(_loc7_);
               _loc4_++;
            }
            _loc5_ = 0;
            while(_loc5_ < _loc2_.length)
            {
               _loc8_ = _loc2_[_loc5_];
               if(Boolean(_loc2_[_loc5_].limb) && _loc2_[_loc5_].limb > 1)
               {
                  if(_loc5_ == 0)
                  {
                     this["battleStartMc"]["enemyMc" + (_loc5_ + 1)].addChild(_loc8_.getStaticFullBody());
                  }
               }
               else
               {
                  this["battleStartMc"]["enemyMc" + (_loc5_ + 1)].addChild(_loc8_.getStaticFullBody());
               }
               _loc5_++;
            }
         }
         else if(Central.battle.type == Central.battle.TYPE_NETWORK)
         {
            if(Central.main.PvpPlayerPlace == "private")
            {
               this["battleStartMc"]["nameTxt"].text = Central.main.getMainChar().getCharacterName();
               GF.removeAllChild(this["battleStartMc"]["playerMc_pvp"]);
               if(Central.main.PvpPlayerPlace == "private")
               {
                  _loc11_ = int(Central.main.PvpPVMode);
               }
               switch(_loc11_)
               {
                  case 3:
                     _loc9_ = this.PvpCloseUpObj["partyMc_2"];
                     _loc10_ = new MovieClip();
                     _loc10_ = _loc9_.getStaticFullBody();
                     _loc10_.scaleX *= -1;
                     _loc10_.x += _loc10_.width;
                     this["battleStartMc"]["partyMc2_pvp"].addChild(_loc10_);
                     _loc9_ = this.PvpCloseUpObj["enemyMc_3"];
                     _loc10_ = new MovieClip();
                     _loc10_ = _loc9_.getStaticFullBody();
                     _loc10_.scaleX *= 1;
                     _loc10_.x += _loc10_.width;
                     this["battleStartMc"]["enemyMc3"].addChild(_loc10_);
                  case 2:
                     _loc9_ = this.PvpCloseUpObj["partyMc_1"];
                     _loc10_ = new MovieClip();
                     _loc10_ = _loc9_.getStaticFullBody();
                     _loc10_.scaleX *= -1;
                     _loc10_.x += _loc10_.width;
                     this["battleStartMc"]["partyMc1_pvp"].addChild(_loc10_);
                     _loc9_ = this.PvpCloseUpObj["enemyMc_2"];
                     _loc10_ = new MovieClip();
                     _loc10_ = _loc9_.getStaticFullBody();
                     _loc10_.scaleX *= 1;
                     _loc10_.x += _loc10_.width;
                     this["battleStartMc"]["enemyMc2"].addChild(_loc10_);
                  case 1:
                     _loc9_ = this.PvpCloseUpObj["playerMc_1"];
                     _loc10_ = new MovieClip();
                     _loc10_ = _loc9_.getStaticFullBody();
                     _loc10_.scaleX *= -1;
                     _loc10_.x += _loc10_.width;
                     this["battleStartMc"]["playerMc_pvp"].addChild(_loc10_);
                     _loc9_ = this.PvpCloseUpObj["enemyMc_1"];
                     _loc10_ = new MovieClip();
                     _loc10_ = _loc9_.getStaticFullBody();
                     _loc10_.scaleX *= 1;
                     _loc10_.x += _loc10_.width;
                     this["battleStartMc"]["enemyMc1"].addChild(_loc10_);
               }
            }
            if(Central.main.PvpPlayerPlace == "tournament")
            {
               this["battleStartMc"]["nameTxt"].text = Central.main.getMainChar().getCharacterName();
               GF.removeAllChild(this["battleStartMc"]["playerMc_pvp"]);
               if(Central.main.PvpPlayerPlace == "private")
               {
                  _loc11_ = int(Central.main.PvpPVMode);
               }
               switch(_loc11_)
               {
                  case 3:
                     _loc9_ = this.PvpCloseUpObj["partyMc_2"];
                     _loc10_ = new MovieClip();
                     _loc10_ = _loc9_.getStaticFullBody();
                     _loc10_.scaleX *= -1;
                     _loc10_.x += _loc10_.width;
                     this["battleStartMc"]["partyMc2_pvp"].addChild(_loc10_);
                     _loc9_ = this.PvpCloseUpObj["enemyMc_3"];
                     _loc10_ = new MovieClip();
                     _loc10_ = _loc9_.getStaticFullBody();
                     _loc10_.scaleX *= 1;
                     _loc10_.x += _loc10_.width;
                     this["battleStartMc"]["enemyMc3"].addChild(_loc10_);
                  case 2:
                     _loc9_ = this.PvpCloseUpObj["partyMc_1"];
                     _loc10_ = new MovieClip();
                     _loc10_ = _loc9_.getStaticFullBody();
                     _loc10_.scaleX *= -1;
                     _loc10_.x += _loc10_.width;
                     this["battleStartMc"]["partyMc1_pvp"].addChild(_loc10_);
                     _loc9_ = this.PvpCloseUpObj["enemyMc_2"];
                     _loc10_ = new MovieClip();
                     _loc10_ = _loc9_.getStaticFullBody();
                     _loc10_.scaleX *= 1;
                     _loc10_.x += _loc10_.width;
                     this["battleStartMc"]["enemyMc2"].addChild(_loc10_);
                  case 1:
                     _loc9_ = this.PvpCloseUpObj["playerMc_1"];
                     _loc10_ = new MovieClip();
                     _loc10_ = _loc9_.getStaticFullBody();
                     _loc10_.scaleX *= -1;
                     _loc10_.x += _loc10_.width;
                     this["battleStartMc"]["playerMc_pvp"].addChild(_loc10_);
                     _loc9_ = this.PvpCloseUpObj["enemyMc_1"];
                     _loc10_ = new MovieClip();
                     _loc10_ = _loc9_.getStaticFullBody();
                     _loc10_.scaleX *= 1;
                     _loc10_.x += _loc10_.width;
                     this["battleStartMc"]["enemyMc1"].addChild(_loc10_);
               }
            }
         }
      }
      
      public function addMainChar() : void
      {
         var _loc1_:* = Central.main.getMainChar();
         _loc1_.playStandby();
         var _loc2_:MovieClip = _loc1_.getSwf();
         _loc2_.scaleX *= -Data.BATTLE_CHAR_SCALE;
         _loc2_.scaleY *= Data.BATTLE_CHAR_SCALE;
         if(Central.battle.type == Central.battle.TYPE_LOCAL)
         {
            this["playerMc_1"]["charMc"].addChild(_loc2_);
         }
         else if(Central.battle.type == Central.battle.TYPE_NETWORK)
         {
            this[Central.main.PvpMainCharMc]["charMc"].addChild(_loc2_);
         }
      }
      
      public function isLevelHack(param1:*) : Boolean
      {
         Out.debug(this,"isLevelHack :: rank >> " + param1.getData(DBCharacterData.RANK));
         Out.debug(this,"isLevelHack :: level >> " + param1.getData(DBCharacterData.LEVEL));
         switch(param1.getData(DBCharacterData.RANK))
         {
            case RankData.STUDENT:
            case RankData.GENIN:
               if(param1.getData(DBCharacterData.LEVEL) > RankData.GENIN_LEVEL_CAP)
               {
                  return true;
               }
               break;
            case RankData.CHUNIN:
            case RankData.CHUNIN_TALENTED:
               if(param1.getData(DBCharacterData.LEVEL) > RankData.CHUNIN_LEVEL_CAP)
               {
                  return true;
               }
               break;
            case RankData.JOUNIN:
            case RankData.JOUNIN_TALENTED:
               if(param1.getData(DBCharacterData.LEVEL) > RankData.JOUNIN_LEVEL_CAP)
               {
                  return true;
               }
               break;
            case RankData.SPECIAL_JOUNIN:
            case RankData.SPECIAL_JOUNIN_TALENTED:
               if(param1.getData(DBCharacterData.LEVEL) > RankData.SPECIAL_JOUNIN_LEVEL_CAP)
               {
                  return true;
               }
               break;
            case RankData.TUTOR:
            case RankData.TUTOR_SENIOR:
               if(param1.getData(DBCharacterData.LEVEL) > RankData.TUTOR_LEVEL_CAP)
               {
                  return true;
               }
               break;
            default:
               return true;
         }
         return false;
      }
      
      private function onInitIsPartyCharacterHack(param1:*) : Boolean
      {
         if(this.isLevelHack(param1) || param1.getData(DBCharacterData.MAX_HP) > RankData.HP_LIMIT || param1.getData(DBCharacterData.MAX_CP) > RankData.CP_LIMIT || param1.getData("character_speed") > RankData.SPEED_LIMIT || param1.getData("character_wind") > RankData.WIND_LIMIT || param1.getData("character_lightning") > RankData.LIGHTNING_LIMIT || param1.getData("character_fire") > RankData.FIRE_LIMIT || param1.getData("character_water") > RankData.WATER_LIMIT || param1.getData("character_earth") > RankData.EARTH_LIMIT)
         {
            return true;
         }
         return false;
      }
      
      private function onInitIsMainCharacterHack(param1:*) : Boolean
      {
         if(this.isLevelHack(param1))
         {
            return true;
         }
         var _loc2_:int = param1.getData("character_wind") + param1.getData("character_lightning") + param1.getData("character_fire") + param1.getData("character_water") + param1.getData("character_earth");
         if(_loc2_ > param1.getData(DBCharacterData.LEVEL))
         {
            return true;
         }
         return false;
      }
      
      public function cancelRematchCountdown() : void
      {
         if(this["defeatBarTxt"] != null)
         {
            this["defeatBarTxt"].text = "0:00";
         }
         removeEventListener(TimerEvent.TIMER,onRematchTimer);
         if(rematchTimer != null)
         {
            rematchTimer.stop();
         }
         rematchTimer = null;
      }
      
      public function startRematchCountdown(param1:int) : void
      {
         rematchTimeLimit = param1;
         rematchRepeat = rematchTimeLimit;
         rematchTimer = new Timer(1000,rematchTimeLimit);
         this["defeatBarTxt"].text = "0:" + zeroPad(Math.max(rematchTimeLimit - 1,0),2);
         rematchTimer.addEventListener(TimerEvent.TIMER,onRematchTimer);
         rematchTimer.start();
      }
      
      public function onRematchTimer(param1:TimerEvent) : void
      {
         --rematchRepeat;
         switch(currentLabel)
         {
            case "pvp_win":
            case "pvp_win_2015a":
            case "pvp_lose":
            case "pvp_lose_2015a":
               if(rematchRepeat <= 0)
               {
                  this["defeatBarTxt"].text = "0:00";
                  Central.battle.pvpWinLossPanelTimedOut();
                  this["lbl_rematch_title"].text = Central.battle.getPvpWinLossPanelMessage();
                  Central.battle.disableButtonsOnRematchTimerCompleted();
               }
               else
               {
                  this["defeatBarTxt"].text = "0:" + zeroPad(Math.max(rematchRepeat - 1,0),2);
               }
         }
      }
      
      public function zeroPad(param1:int, param2:int) : String
      {
         var _loc3_:String = "" + param1;
         while(_loc3_.length < param2)
         {
            _loc3_ = "0" + _loc3_;
         }
         return _loc3_;
      }
   }
}

