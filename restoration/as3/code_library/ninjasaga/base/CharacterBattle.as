package ninjasaga.base
{
   import com.utils.GF;
   import com.utils.NumberUtil;
   import com.utils.Out;
   import ninjasaga.*;
   import ninjasaga.data.AppData;
   import ninjasaga.data.BattleData;
   import ninjasaga.data.BloodlineData;
   import ninjasaga.data.ButtonData;
   import ninjasaga.data.SenjutsuData;
   import ninjasaga.data.Timeline;
   import ninjasaga.data.TitleData;
   
   public class CharacterBattle extends CharacterDisplay
   {
      
      public function CharacterBattle()
      {
         super();
      }
      
      public function nextRound(param1:Object) : void
      {
         var _loc2_:int = 0;
         var _loc3_:String = null;
         var _loc5_:Array = null;
         var _loc6_:Array = null;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:String = null;
         var _loc10_:Array = null;
         var _loc11_:Object = null;
         var _loc12_:String = null;
         if(param1 == null)
         {
            Out.error(this,"nextRound :: roundObj is null");
            return;
         }
         if(param1.purify != null)
         {
            if(Battle.type == Battle.TYPE_NETWORK)
            {
               this.clearAllDebuff();
            }
            this.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(356));
            if(param1.purify.restoreHp != null)
            {
               if(param1.purify.restoreHp > 0)
               {
                  if(Battle.type == Battle.TYPE_NETWORK)
                  {
                     this.updateHP(param1.purify.restoreHp);
                  }
                  this.showOverheadNumber(Timeline.WORD,String(Central.main.langLib.get(483) + " " + param1.purify.restoreHp));
               }
               this.updateBattleFrame();
               Main.updateMenu();
            }
         }
         if(Battle.type == Battle.TYPE_NETWORK)
         {
            this.reduceSkillCooldown(1);
         }
         if(param1.buff != null)
         {
            _loc5_ = param1.buff;
            _loc2_ = 0;
            while(_loc2_ < _loc5_.length)
            {
               if(Battle.type == Battle.TYPE_NETWORK)
               {
                  this.setBattleBuff(_loc5_[_loc2_]);
               }
               _loc2_++;
            }
         }
         if(param1.debuff != null)
         {
            _loc6_ = param1.debuff;
            _loc2_ = 0;
            while(_loc2_ < _loc6_.length)
            {
               if(Battle.type == Battle.TYPE_NETWORK)
               {
                  this.setBattleDebuff(_loc6_[_loc2_]);
               }
               _loc2_++;
            }
         }
         this.nextBattleRound();
         var _loc4_:Boolean = true;
         if(param1.skillID != null)
         {
            this.reducenetRandomSkillCooldown(param1.skillID,param1.cd);
         }
         if(param1.restore != null)
         {
            _loc7_ = int(param1.restore.hp);
            _loc8_ = int(param1.restore.cp);
            if(_loc7_ != 0)
            {
               if(_loc7_ > 0)
               {
                  _loc9_ = "+";
               }
               if(_loc7_ < 0)
               {
                  _loc9_ = "-";
               }
               this.showOverheadNumber(Timeline.WORD,_loc9_ + Math.abs(_loc7_) + " " + String(Central.main.langLib.get(483)).replace("+",""));
               if(Battle.type == Battle.TYPE_NETWORK)
               {
                  this.updateHP(_loc7_);
               }
            }
            if(_loc8_ != 0)
            {
               if(_loc8_ > 0)
               {
                  _loc9_ = "+";
               }
               if(_loc8_ < 0)
               {
                  _loc9_ = "-";
               }
               this.showOverheadNumber(Timeline.WORD,_loc9_ + Math.abs(_loc8_) + " " + String(Central.main.langLib.get(350)).replace("+",""));
               if(Battle.type == Battle.TYPE_NETWORK)
               {
                  this.updateCP(_loc8_);
               }
            }
            if(param1.restore.arr != null)
            {
               _loc10_ = param1.restore.arr;
               _loc7_ = 0;
               _loc8_ = 0;
               _loc2_ = 0;
               while(_loc2_ < _loc10_.length)
               {
                  _loc11_ = _loc10_[_loc2_];
                  if(!_loc4_ && _loc11_.hp < 0)
                  {
                     _loc11_.hp = 0;
                  }
                  switch(_loc11_.type)
                  {
                     case BattleData.EFFECT_JUTSU_POISON:
                        this.showOverheadNumber(Timeline.WORD,String(Central.main.langLib.get(376)).replace("[valamount]",String(_loc11_.hp)));
                        _loc7_ += Math.round(_loc11_.hp);
                        break;
                     case BattleData.EFFECT_BURN_CNNT_PURIFY:
                     case BattleData.EFFECT_DOUBLE_BURN:
                     case BattleData.EFFECT_BURN:
                     case BattleData.EFFECT_BURN_FIX_NUM:
                     case BattleData.EFFECT_BLAZING:
                        this.showOverheadNumber(Timeline.WORD,String(Central.main.langLib.get(375)).replace("[valamount]",String(_loc11_.hp)));
                        _loc7_ += Math.round(_loc11_.hp);
                        break;
                     case BattleData.EFFECT_FLAME:
                        this.showOverheadNumber(Timeline.WORD,_loc11_.hp + "" + String(Central.main.langLib.get(483).replace("+","")));
                        this.showOverheadNumber(Timeline.WORD,_loc11_.cp + "" + String(Central.main.langLib.get(295).replace("+","")));
                        _loc7_ += Math.round(_loc11_.hp);
                        _loc8_ += Math.round(_loc11_.cp);
                        break;
                     case BattleData.EFFECT_DAMAGE_HP_FIX_NUM:
                        this.showOverheadNumber(Timeline.WORD,String(String(_loc11_.hp) + Central.main.langLib.titleTxt(TitleData.HP)));
                        _loc7_ += Math.round(_loc11_.hp);
                        break;
                     case BattleData.EFFECT_POISON:
                        this.showOverheadNumber(Timeline.WORD,String(Central.main.langLib.get(376)).replace("[valamount]",String(_loc11_.hp)));
                        _loc7_ += Math.round(_loc11_.hp);
                        break;
                     case BattleData.EFFECT_SOUL_CHAINS_BUNDLE:
                        this.showOverheadNumber(Timeline.WORD,String(Central.main.langLib.get(377)).replace("[valamount]",String(_loc11_.hp)));
                        _loc7_ += Math.round(_loc11_.hp);
                        break;
                     case BattleData.EFFECT_PARASITE:
                        this.showOverheadNumber(Timeline.WORD,String(Central.main.langLib.get(378)).replace("[valamount]",String(_loc11_.hp)));
                        _loc7_ += Math.round(_loc11_.hp);
                        break;
                     case BattleData.EFFECT_BURNING:
                        this.showOverheadNumber(Timeline.WORD,String(Central.main.langLib.get(379)).replace("[valamount]",String(_loc11_.hp)));
                        _loc7_ += Math.round(_loc11_.hp);
                        break;
                     case BattleData.EFFECT_TEARING:
                        trace("restoreObj.hp is " + _loc11_.hp);
                        this.showOverheadNumber(Timeline.WORD,String(Central.main.langLib.get(2055)).replace("[valamount]",String(_loc11_.hp)));
                        _loc7_ += Math.round(_loc11_.hp);
                        break;
                     case BattleData.EFFECT_PET_BURN:
                        this.showOverheadNumber(Timeline.WORD,String(Central.main.langLib.get(379)).replace("[valamount]",String(_loc11_.hp)));
                        _loc7_ += Math.round(_loc11_.hp);
                        break;
                     case BattleData.EFFECT_COLLIDING_WAVE:
                     case BattleData.EFFECT_CLEARBUFF_REDUCE_HP_CP:
                     case BattleData.EFFECT_REDUCE_HP_CP:
                        this.showOverheadNumber(Timeline.WORD,String(_loc11_.hp.toString() + Central.main.langLib.titleTxt(TitleData.HP) + ", " + _loc11_.cp.toString() + Central.main.langLib.titleTxt(TitleData.CP)));
                        _loc7_ += Math.round(_loc11_.hp);
                        _loc8_ += Math.round(_loc11_.cp);
                        break;
                     case BattleData.EFFECT_CATALYTIC_MATTER:
                     case BattleData.EFFECT_CLEARBUFF_REDUCE_HP:
                        this.showOverheadNumber(Timeline.WORD,String(_loc11_.hp.toString() + Central.main.langLib.titleTxt(TitleData.HP)));
                        _loc7_ += Math.round(_loc11_.hp);
                        break;
                     case BattleData.EFFECT_CLEARBUFF_REDUCE_CP:
                        this.showOverheadNumber(Timeline.WORD,String(_loc11_.cp.toString() + Central.main.langLib.titleTxt(TitleData.CP)));
                        _loc8_ += Math.round(_loc11_.cp);
                        break;
                     case BloodlineData.EFFECT_UPDATE_HP:
                        if(int(_loc11_.hp) > 0)
                        {
                           _loc3_ = "+" + _loc11_.hp + " " + String(Central.main.langLib.get(483)).replace("+","");
                        }
                        else
                        {
                           _loc3_ = _loc11_.hp + " " + String(Central.main.langLib.get(483)).replace("+","");
                        }
                        if(_loc11_.skill == "skill1019")
                        {
                           _loc3_ = Central.main.langLib.get(753) + " " + _loc3_;
                        }
                        this.showOverheadNumber(Timeline.WORD,_loc3_);
                        _loc7_ += Math.round(_loc11_.hp);
                        break;
                     case BloodlineData.EFFECT_UPDATE_CP:
                        if(int(_loc11_.cp) > 0)
                        {
                           _loc3_ = "+" + _loc11_.cp + " " + Central.main.langLib.get(295);
                        }
                        else
                        {
                           _loc3_ = _loc11_.cp + " " + Central.main.langLib.get(295);
                        }
                        trace("overheadString = " + _loc3_);
                        this.showOverheadNumber(Timeline.WORD,_loc3_);
                        break;
                     case BattleData.EFFECT_HEAL_OVER_TIME:
                        this.showOverheadNumber(Timeline.WORD,String(Central.main.langLib.get(596)));
                     case BattleData.EFFECT_PET_HEAL:
                     case BattleData.EFFECT_DODGE_BONUS_N_HEAL:
                     case BattleData.EFFECT_DAMAGE_REDUCE_N_HEAL:
                     case BattleData.EFFECT_HEAL_OVER_TIME_NPC:
                     case BattleData.EFFECT_HEAL_OVER_TIME_FIX_NUM:
                     case BattleData.EFFECT_HEAL_OVER_TIME_FIX_NUM_DARKNESS:
                        _loc7_ += _loc11_.hp;
                        this.showOverheadNumber(Timeline.HEAL,_loc11_.hp);
                        break;
                     case BattleData.SKILL_377:
                        this.showOverheadNumber(Timeline.WORD,String(_loc11_.hp.toString() + Central.main.langLib.titleTxt(TitleData.HP)));
                        _loc7_ += Math.round(_loc11_.hp);
                        break;
                     case BattleData.EFFECT_DOT_HP:
                        this.showOverheadNumber(Timeline.WORD,String(_loc11_.hp.toString() + Central.main.langLib.titleTxt(TitleData.HP)));
                        _loc7_ += Math.round(_loc11_.hp);
                        break;
                     case BattleData.EFFECT_DODGE_BONUS_ALL_FRIENDLY:
                        this.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(306));
                        break;
                     case BattleData.EFFECT_WIND_PEACE_SINGLE:
                     case BattleData.EFFECT_WIND_PEACE:
                     case BattleData.EFFECT_WIND_PEACE_2:
                     case BattleData.EFFECT_WIND_PEACE_3:
                     case BattleData.EFFECT_WIND_PEACE_4:
                        this.showOverheadNumber(Timeline.WORD,"+" + String(_loc11_.cp.toString() + Central.main.langLib.titleTxt(TitleData.CP)));
                        _loc8_ += Math.round(_loc11_.cp);
                        break;
                     case BattleData.EFFECT_TURKEY_FEAST:
                        this.showOverheadNumber(Timeline.WORD,"+" + String(_loc11_.hp.toString() + Central.main.langLib.titleTxt(TitleData.HP)));
                        _loc7_ += Math.round(_loc11_.hp);
                        break;
                     case BattleData.EFFECT_REGENERATE_HP:
                        this.showOverheadNumber(Timeline.WORD,"+" + String(_loc11_.hp.toString() + Central.main.langLib.titleTxt(TitleData.HP)));
                        _loc7_ += Math.round(_loc11_.hp);
                        break;
                     case BattleData.EFFECT_REGENERATE_CHAKRA:
                        this.showOverheadNumber(Timeline.WORD,"+" + String(_loc11_.cp.toString() + Central.main.langLib.titleTxt(TitleData.CP)));
                        _loc8_ += Math.round(_loc11_.cp);
                        break;
                     case BattleData.SKILL_335:
                        this.showOverheadNumber(Timeline.WORD,"+" + String(_loc11_.hp.toString() + Central.main.langLib.titleTxt(TitleData.HP)));
                        _loc7_ += Math.round(_loc11_.hp);
                        break;
                     case BattleData.EFFECT_DAMAGE_DELAY:
                        if(Boolean(_loc11_.hp) && _loc11_.hp != 0)
                        {
                           this.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(1807)[3] + "(" + String(_loc11_.hp.toString()) + Central.main.langLib.titleTxt(TitleData.HP) + ")");
                           _loc7_ += Math.round(_loc11_.hp);
                        }
                        break;
                     case BattleData.EFFECT_HEAL_HP_N_DMG_BONUS_GASHADOKURO:
                     case BattleData.EFFECT_HEAL_HP_N_DMG_BONUS:
                        this.showOverheadNumber(Timeline.WORD,"+" + String(_loc11_.hp.toString() + Central.main.langLib.titleTxt(TitleData.HP)));
                        _loc7_ += 250;
                        break;
                     case BattleData.EFFECT_HEAL_HP_N_DMG_BONUS_UPGRADE:
                        this.showOverheadNumber(Timeline.WORD,"+" + String(_loc11_.hp.toString() + Central.main.langLib.titleTxt(TitleData.HP)));
                        _loc7_ += 550;
                        break;
                     case BloodlineData.EFFECT_BL_UPDATE_HP_FIX_NUM:
                        this.showOverheadNumber(Timeline.WORD,"+" + String(_loc11_.hp.toString() + Central.main.langLib.titleTxt(TitleData.HP)));
                        _loc7_ += Math.round(_loc11_.hp);
                        break;
                     case BattleData.EFFECT_ULTRA_BURNING:
                        this.showOverheadNumber(Timeline.WORD,"(" + String(Central.main.langLib.get(2018) + String(_loc11_.hp)) + "HP)");
                        _loc7_ += Math.round(_loc11_.hp);
                  }
                  _loc2_++;
               }
            }
         }
         if(this.battleBuff)
         {
            for(_loc12_ in this.battleBuff)
            {
               if(!this.battleBuff[_loc12_])
               {
                  continue;
               }
               if(this.battleBuff[_loc12_].duration <= 0)
               {
                  continue;
               }
               switch(_loc12_)
               {
                  case BattleData.EFFECT_DAMAGE_DELAY:
                     this.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(1844) + Number(-this.battleBuff[_loc12_].intmem1).toString() + "/" + Number(this.battleBuff[_loc12_].intmem2).toString());
                     _loc7_ = int(this.battleBuff[_loc12_].intmem1);
               }
            }
         }
         if(Battle.type == Battle.TYPE_NETWORK)
         {
            if(_loc7_ != 0)
            {
               this.updateHP(_loc7_);
            }
            if(_loc8_ != 0)
            {
               this.updateCP(_loc8_);
            }
            Central.battle.syncHpCpCommandAction();
         }
         this.updateBattleFrame();
         Main.updateMenu();
      }
      
      public function nextBattleRound() : void
      {
         var _loc1_:String = null;
         var _loc2_:Number = NaN;
         var _loc3_:int = 0;
         var _loc9_:Object = null;
         var _loc18_:int = 0;
         var _loc19_:int = 0;
         var _loc4_:String = "";
         var _loc5_:Array = [];
         var _loc6_:String = "";
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc10_:String = "";
         var _loc11_:String = "";
         var _loc12_:Number = 0;
         var _loc13_:String = "";
         var _loc14_:Number = 0;
         var _loc15_:Array = null;
         var _loc16_:int = 0;
         var _loc17_:Number = 0;
         var _loc20_:Array = [];
         if(Central.main.senjutsuFeature)
         {
            showCharacterSenjutsuBuffAndDebuff();
         }
         trace("hank :: battle buff = " + GF.printObject(this.battleBuff));
         for(_loc1_ in this.battleBuff)
         {
            if(this.battleBuff[_loc1_])
            {
               if(Battle.type == Battle.TYPE_NETWORK)
               {
                  if(this.battleBuff[_loc1_].duration <= BloodlineData.PASSIVE_BUFF_IDENTIFIER)
                  {
                  }
               }
               if(this.battleBuff[_loc1_].duration > 0)
               {
                  trace("Hank :: key >> " + _loc1_);
                  switch(_loc1_)
                  {
                     case BattleData.EFFECT_CRITICAL_DMG_BONUS:
                        this.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(747) + "(" + this.battleBuff[_loc1_].duration + ")");
                        break;
                     case BattleData.EFFECT_REWIND:
                        if(Battle.type == Battle.TYPE_NETWORK)
                        {
                           this.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(800));
                           this.reduceSkillCooldown(this.battleBuff[_loc1_].amount,BattleData.REDUCETYPE_SKILL);
                        }
                        break;
                     case BattleData.EFFECT_PET_LIGHTNING:
                        this.showOverheadNumber(Timeline.WORD,String(Central.main.langLib.get(875) + Central.main.langLib.get(880).replace("[valturn]",String(this.battleBuff[_loc1_].duration))));
                        break;
                     case SenjutsuData.EFFECT_SS_BURN_HP_CP_SP:
                        this.showOverheadNumber(Timeline.WORD,String(Central.main.langLib.get(2008) + "(" + String(this.battleBuff[_loc1_].duration) + ")"));
                        break;
                     case BattleData.EFFECT_DAMAGE_BONUS_FIX_NUM:
                        this.showOverheadNumber(Timeline.WORD,String(Central.main.langLib.get(330)));
                        break;
                     case BattleData.EFFECT_CRITICAL_CHANCE_BONUS_WEAPON:
                        this.showOverheadNumber(Timeline.WORD,String(Central.main.langLib.get(686)).replace("[valamt]",String(this.battleBuff[_loc1_].amount)));
                        break;
                     case BattleData.EFFECT_HANAMI_EXTRA_ATTACK:
                        this.showOverheadNumber(Timeline.WORD,String(Central.main.langLib.get(2066) + "(" + this.battleBuff[_loc1_].duration + ")"));
                        break;
                     case BattleData.EFFECT_GIANT_TOAD:
                        this.showOverheadNumber(Timeline.WORD,String(Central.main.langLib.get(2058) + "(" + this.battleBuff[_loc1_].duration + ")"));
                        break;
                     case BattleData.EFFECT_GIANT_TOAD_BIG:
                        this.showOverheadNumber(Timeline.WORD,String(Central.main.langLib.get(2058) + "(" + this.battleBuff[_loc1_].duration + ")"));
                        break;
                     case BattleData.EFFECT_SUSANOOA:
                        this.showOverheadNumber(Timeline.WORD,String(Central.main.langLib.get(2044) + "(" + this.battleBuff[_loc1_].duration + ")"));
                        break;
                     case BattleData.EFFECT_RECV_DMG_BLEEDING_DMG_REDUCTION:
                        this.showOverheadNumber(Timeline.WORD,String(Central.main.langLib.get(2062) + "(" + this.battleBuff[_loc1_].duration + ")"));
                        break;
                     case BattleData.EFFECT_SUSANOO:
                        this.showOverheadNumber(Timeline.WORD,String(Central.main.langLib.get(2044) + "(" + this.battleBuff[_loc1_].duration + ")"));
                        break;
                     case BattleData.EFFECT_SUSANOOB:
                        this.showOverheadNumber(Timeline.WORD,String(Central.main.langLib.get(2044) + "(" + this.battleBuff[_loc1_].duration + ")"));
                        break;
                     case BattleData.EFFECT_AGILITY_BONUS_FIX:
                        this.showOverheadNumber(Timeline.WORD,String(Central.main.langLib.get(2001)[10] + "(" + this.battleBuff[_loc1_].duration + ")"));
                        break;
                     case BattleData.EFFECT_ADD_MAX_HP_LIMIT:
                        this.showOverheadNumber(Timeline.WORD,String(Central.main.langLib.get(2045) + "(" + this.battleBuff[_loc1_].duration + ")"));
                        break;
                     case BattleData.EFFECT_DAMAGE_BONUSA:
                     case BattleData.EFFECT_DAMAGE_BONUS:
                     case BattleData.EFFECT_PET_DAMAGE_BONUS:
                     case BattleData.SKILL_369:
                     case BattleData.SKILL_501:
                        this.showOverheadNumber(Timeline.WORD,String(Central.main.langLib.get(330) + "(" + this.battleBuff[_loc1_].duration + ")"));
                        break;
                     case BattleData.EFFECT_PET_SAVE_CP:
                        this.showOverheadNumber(Timeline.WORD,String(Central.main.langLib.get(805) + Central.main.langLib.get(880).replace("[valturn]",String(this.battleBuff[_loc1_].duration))));
                        break;
                     case BattleData.EFFECT_PET_ATTENTION:
                        this.showOverheadNumber(Timeline.WORD,String(Central.main.langLib.get(807) + Central.main.langLib.get(880).replace("[valturn]",String(this.battleBuff[_loc1_].duration))));
                        break;
                     case BattleData.EFFECT_PET_DAMAGE_REDUCTION:
                        this.showOverheadNumber(Timeline.WORD,String(Central.main.langLib.get(322) + Central.main.langLib.get(880).replace("[valturn]",String(this.battleBuff[_loc1_].duration))));
                        break;
                     case BattleData.EFFECT_PET_DRAIN_HP_KEKKAI:
                     case BattleData.EFFECT_ALL_CP_DRAIN_HP:
                        this.showOverheadNumber(Timeline.WORD,String(Central.main.langLib.get(878)));
                        break;
                     case BattleData.EFFECT_PET_DAMAGE_TO_CP:
                        this.showOverheadNumber(Timeline.WORD,String(Central.main.langLib.get(832) + Central.main.langLib.get(880).replace("[valturn]",String(this.battleBuff[_loc1_].duration))));
                        break;
                     case BattleData.EFFECT_DAMAGE_REDUCTIONA:
                     case BattleData.EFFECT_DAMAGE_REDUCTION:
                        this.showOverheadNumber(Timeline.WORD,String(Central.main.langLib.get(322) + Central.main.langLib.get(880).replace("[valturn]",String(this.battleBuff[_loc1_].duration))));
                        break;
                     case BattleData.EFFECT_BURN_HP_CP_FIX_NUM_N_IMMUNITY_BLEEDING:
                        this.showOverheadNumber(Timeline.WORD,String(Central.main.langLib.get(2056) + " (" + String(this.battleBuff[_loc1_].duration) + ")"));
                        break;
                     case BattleData.EFFECT_ATTACK_MODE:
                        this.showOverheadNumber(Timeline.WORD,String(Central.main.langLib.get(881) + Central.main.langLib.get(880).replace("[valturn]",String(this.battleBuff[_loc1_].duration))));
                        break;
                     case BattleData.EFFECT_DEFENCE_MODE:
                        this.showOverheadNumber(Timeline.WORD,String(Central.main.langLib.get(883) + Central.main.langLib.get(880).replace("[valturn]",String(this.battleBuff[_loc1_].duration))));
                        break;
                     case BattleData.EFFECT_SERENE_MIND_DMGBONUS:
                     case BattleData.EFFECT_SERENE_MIND:
                        this.showOverheadNumber(Timeline.WORD,String(Central.main.langLib.get(622) + Central.main.langLib.get(880).replace("[valturn]",String(this.battleBuff[_loc1_].duration))));
                        break;
                     case BattleData.EFFECT_UNHOLY_POISON:
                        this.showOverheadNumber(Timeline.WORD,String(Central.main.langLib.get(2048) + Central.main.langLib.get(880).replace("[valturn]",String(this.battleBuff[_loc1_].duration))));
                        break;
                     case BattleData.EFFECT_EXPANSION:
                        this.showOverheadNumber(Timeline.WORD,String(Central.main.langLib.get(2053) + Central.main.langLib.get(880).replace("[valturn]",String(this.battleBuff[_loc1_].duration))));
                        break;
                     case BattleData.EFFECT_DISORIENTED_BURN_HP:
                        this.showOverheadNumber(Timeline.WORD,String(Central.main.langLib.get(2052) + Central.main.langLib.get(880).replace("[valturn]",String(this.battleBuff[_loc1_].duration))));
                        break;
                     case BattleData.EFFECT_PET_ENERGIZE:
                        this.showOverheadNumber(Timeline.WORD,String(Central.main.langLib.get(893) + Central.main.langLib.get(880).replace("[valturn]",String(this.battleBuff[_loc1_].duration))));
                        break;
                     case BattleData.EFFECT_PET_DEBUFF_RESIST:
                        this.showOverheadNumber(Timeline.WORD,String(Central.main.langLib.get(822) + Central.main.langLib.get(880).replace("[valturn]",String(this.battleBuff[_loc1_].duration))));
                        break;
                     case BattleData.EFFECT_GUARD:
                     case BattleData.EFFECT_ALL_CP_GUARD_RESIST:
                        this.showOverheadNumber(Timeline.WORD,String(Central.main.langLib.get(636)));
                        break;
                     case BattleData.EFFECT_BUNNY_FRENZY:
                        this.showOverheadNumber(Timeline.WORD,String(Central.main.langLib.get(834) + Central.main.langLib.get(880).replace("[valturn]",String(this.battleBuff[_loc1_].duration))));
                        break;
                     case BattleData.EFFECT_BATTLE_BUNNY_FRENZY:
                        this.showOverheadNumber(Timeline.WORD,String(Central.main.langLib.get(1871) + Central.main.langLib.get(880).replace("[valturn]",String(this.battleBuff[_loc1_].duration))));
                        break;
                     case BattleData.EFFECT_PET_REFLECT_ATTACK:
                        this.showOverheadNumber(Timeline.WORD,String(Central.main.langLib.get(873) + Central.main.langLib.get(880).replace("[valturn]",String(this.battleBuff[_loc1_].duration))));
                        break;
                     case BattleData.EFFECT_BLOOD_FEED:
                        this.showOverheadNumber(Timeline.WORD,String(Central.main.langLib.get(683) + Central.main.langLib.get(880).replace("[valturn]",String(this.battleBuff[_loc1_].duration))));
                        break;
                     case BattleData.EFFECT_LOW_HP_CRITICAL_BONUS:
                        this.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(2001)[4] + "(" + String(this.battleBuff[_loc1_].duration) + ")");
                        break;
                     case BattleData.EFFECT_CRIT_CHANCE_DMG:
                        this.showOverheadNumber(Timeline.WORD,String(Central.main.langLib.get(292) + Central.main.langLib.get(880).replace("[valturn]",String(this.battleBuff[_loc1_].duration))));
                        this.showOverheadNumber(Timeline.WORD,String(Central.main.langLib.get(747) + Central.main.langLib.get(880).replace("[valturn]",String(this.battleBuff[_loc1_].duration))));
                        break;
                     case BattleData.EFFECT_CERBERUS:
                        this.showOverheadNumber(Timeline.WORD,String(Central.main.langLib.get(2068) + "(" + battleBuff[_loc1_].duration + ")"));
                        break;
                     case BattleData.SKILL_302:
                        this.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(1358) + "(" + battleBuff[_loc1_].duration + ")");
                        break;
                     case BattleData.SKILL_234:
                        this.showOverheadNumber(Timeline.WORD,String(Central.main.langLib.get(807) + "(" + battleBuff[_loc1_].duration + ")"));
                        break;
                     case BattleData.EFFECT_CATALYTIC_MATTER:
                        this.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(814) + "(" + battleBuff[_loc1_].duration + ")");
                        break;
                     case BattleData.SKILL_307:
                        this.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(322) + "(" + battleBuff[_loc1_].duration + ")");
                        break;
                     case BattleData.EFFECT_CRITICAL_CHANCE_BONUS:
                        this.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(292) + "(" + battleBuff[_loc1_].duration + ")");
                        break;
                     case BattleData.SKILL_268:
                     case BattleData.SKILL_268_2:
                        this.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(1363) + "(" + battleBuff[_loc1_].duration + ")");
                        break;
                     case BattleData.EFFECT_MANA_SHIELD:
                        this.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(594) + "(" + battleBuff[_loc1_].duration + ")");
                        break;
                     case BattleData.EFFECT_BERSERKER_BUFF:
                        this.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(2051) + "(" + battleBuff[_loc1_].amount + "%)" + "(" + battleBuff[_loc1_].duration + ")");
                        break;
                     case BattleData.EFFECT_REGENERATE_CHAKRA:
                        this.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(324) + "(" + battleBuff[_loc1_].duration + ")");
                        break;
                     case BattleData.EFFECT_WIND_PEACE_SINGLE:
                     case BattleData.EFFECT_WIND_PEACE:
                     case BattleData.EFFECT_WIND_PEACE_2:
                     case BattleData.EFFECT_WIND_PEACE_3:
                     case BattleData.EFFECT_WIND_PEACE_4:
                        this.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(324));
                        break;
                     case BattleData.EFFECT_TURKEY_FEAST:
                        this.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(2057));
                        break;
                     case BattleData.EFFECT_DODGE_BONUS:
                     case BattleData.EFFECT_ALL_CP_DODGE_BONUS:
                     case BattleData.EFFECT_PET_DODGE_BONUS:
                        this.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(306));
                        break;
                     case BattleData.EFFECT_FIRE_ENERGY_EXCITATION:
                        this.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(613));
                        break;
                     case BattleData.EFFECT_SKILL_899:
                        this.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(2001)[10]);
                        this.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(1609));
                        break;
                     case BattleData.EFFECT_BERSERKER_MODE:
                        this.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(599));
                        break;
                     case BattleData.EFFECT_THUNDERSTORM_MODE:
                        this.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(601));
                        break;
                     case BattleData.SKILL_251:
                        this.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(748));
                        break;
                     case BattleData.SKILL_285:
                        this.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(1355));
                        this.syncCoolDown();
                     case BattleData.EFFECT_ADD_PURIFY_CHANCE:
                        this.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(1688));
                        break;
                     case BattleData.EFFECT_ACCURATE:
                        this.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(735));
                        break;
                     case BattleData.EFFECT_ADD_CRITICAL_CHANCE:
                        this.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(292));
                        break;
                     case BattleData.EFFECT_HALFHP_DAMAGE_REDUCTION:
                        this.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(748));
                        break;
                     case BattleData.EFFECT_HEAL_HP_N_DMG_BONUS_GASHADOKURO:
                     case BattleData.EFFECT_HEAL_HP_N_DMG_BONUS:
                        this.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(2007) + "(" + this.battleBuff[_loc1_].duration + ")");
                        break;
                     case BattleData.EFFECT_HEAL_HP_N_DMG_BONUS_UPGRADE:
                        this.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(2007) + "(" + this.battleBuff[_loc1_].duration + ")");
                        break;
                     case SenjutsuData.EFFECT_SS_CRITICAL_N_DODGE_REDUCTION:
                        if(this.hp / this.maxHP <= this.getBattleBuff()[SenjutsuData.EFFECT_SS_SPIRIT_MODE].amount * 0.01)
                        {
                           trace("this.getBattleBuff()[SenjutsuData.EFFECT_SS_SPIRIT_MODE].amount = " + this.getBattleBuff()[SenjutsuData.EFFECT_SS_SPIRIT_MODE].amount);
                           this.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(292));
                        }
                        break;
                     case SenjutsuData.EFFECT_SS_DIVIDE_CHAOS:
                        this.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(2008) + "(" + this.battleBuff[_loc1_].duration + ")");
                        break;
                     case BattleData.EFFECT_DAMAGE_BONUS_WEAPON:
                        this.showOverheadNumber(Timeline.WORD,String(Central.main.langLib.get(687)).replace("[valamt]",String(battleBuff[_loc1_].amount)) + "(" + this.battleBuff[_loc1_].duration + ")");
                        break;
                     case BattleData.EFFECT_CP_LOCK:
                        this.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(2013) + "(" + this.battleBuff[_loc1_].duration + ")");
                        break;
                     case BattleData.EFFECT_COMPLETE_GUARD:
                        this.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(636) + "(" + this.battleBuff[_loc1_].duration + ")");
                        break;
                     case BattleData.EFFECT_RECEIVED_DMG_BLEEDING:
                        this.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(2016) + "(" + this.battleBuff[_loc1_].duration + ")");
                        break;
                     case BattleData.EFFECT_RECEIVED_BURNING:
                        this.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(2064) + "(" + this.battleBuff[_loc1_].duration + ")");
                        break;
                     case BattleData.EFFECT_DMG_BONUS_N_RECEIVED_BURNING:
                        this.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(2019) + "(" + this.battleBuff[_loc1_].duration + ")");
                        break;
                     case BattleData.EFFECT_CRITICAL_BUFF_N_RECEIVED_STUN:
                        this.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(2020) + "(" + this.battleBuff[_loc1_].duration + ")");
                        break;
                     case BattleData.EFFECT_REDUCE_DMG_N_AGI:
                        this.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(2021) + "(" + this.battleBuff[_loc1_].duration + ")");
                        break;
                     case BattleData.EFFECT_MANA_SHILED_N_PURIFY_BELOW_CP:
                        this.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(2023) + "(" + this.battleBuff[_loc1_].duration + ")");
                        break;
                     case BattleData.EFFECT_SAND_GUARD:
                        this.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(2025) + "(" + this.battleBuff[_loc1_].duration + ")");
                        break;
                     case BattleData.EFFECT_DMG_BONUS_N_REDUCTION_FIX:
                        this.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(2026) + "(" + this.battleBuff[_loc1_].duration + ")");
                        break;
                     case BattleData.EFFECT_DMG_BONUS_N_REDUCTION:
                        this.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(2027) + "(" + this.battleBuff[_loc1_].duration + ")");
                        break;
                     case BattleData.EFFECT_ALL_BUFF:
                        this.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(2029) + "(" + this.battleBuff[_loc1_].duration + ")");
                        break;
                     case BattleData.EFFECT_DEBUFF_RESIST_EX:
                        this.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(2028));
                        this.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(2032));
                        this.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(2033));
                        break;
                     case BattleData.EFFECT_PROTECT_BY_DUMMY:
                     case BattleData.EFFECT_PROTECT_BY_DUMMY_RECEIVED_BURN:
                     case BattleData.EFFECT_PROTECT_BY_DUMMY_RECEIVED_STUN:
                        this.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(2030) + "(" + this.battleBuff[_loc1_].duration + (AppData.lang == AppData.ZH ? " 回合" : " turns") + ")");
                        break;
                     case BattleData.EFFECT_PROTECT_BY_DUMMY_BURN_PROTECTION:
                        this.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(2065) + "(" + this.battleBuff[_loc1_].duration + (AppData.lang == AppData.ZH ? " 回合" : " turns") + ")");
                        break;
                     case BattleData.EFFECT_THEFT_HP:
                        this.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(2034) + "(" + battleDebuff[_loc1_].amount + "%)(" + String(battleDebuff[_loc1_].duration - 1) + (AppData.lang == AppData.ZH ? " 回合" : " turns") + ")");
                  }
                  _loc5_ = [];
                  _loc4_ = "";
                  _loc5_ = _loc1_.split(".");
                  if((Boolean(_loc5_)) && _loc5_.length > 0)
                  {
                     _loc4_ = _loc5_[0];
                  }
                  if(Battle.type == Battle.TYPE_NETWORK)
                  {
                     if(_loc5_.indexOf("skill1005") >= 0)
                     {
                        _loc4_ = "";
                     }
                  }
                  if(Boolean(_loc4_) && Boolean(this.battleBuff[_loc1_].chancetoeffect) && this.battleBuff[_loc1_].chancetoeffect > 0)
                  {
                     _loc2_ = NumberUtil.getRandom();
                     if(_loc2_ <= this.battleBuff[_loc1_].chancetoeffect / 100)
                     {
                        switch(_loc4_)
                        {
                           case BloodlineData.EFFECT_UPDATE_HP:
                              _loc7_ = 0;
                              _loc7_ = Math.round(this.maxHP * (this.battleBuff[_loc1_].amount / 100));
                              this.updateHP(_loc7_);
                              _loc6_ = "";
                              if(_loc7_ > 0)
                              {
                                 _loc6_ = "+" + _loc7_ + " " + String(Central.main.langLib.get(483)).replace("+","");
                              }
                              else
                              {
                                 _loc6_ = _loc7_ + " " + String(Central.main.langLib.get(483)).replace("+","");
                              }
                              if(_loc5_[1] == "skill1019")
                              {
                                 _loc6_ = Central.main.langLib.get(753) + " " + _loc6_;
                              }
                              this.showOverheadNumber(Timeline.WORD,_loc6_);
                              this.updateBattleFrame();
                              Main.updateMenu();
                              break;
                           case BloodlineData.EFFECT_UPDATE_CP:
                              _loc8_ = 0;
                              _loc8_ = Math.round(this.maxCP * (this.battleBuff[_loc1_].amount / 100));
                              this.updateCP(_loc8_);
                              _loc6_ = "";
                              if(_loc8_ > 0)
                              {
                                 _loc6_ = "+" + _loc8_ + " " + Central.main.langLib.get(295);
                              }
                              else
                              {
                                 _loc6_ = _loc8_ + " " + Central.main.langLib.get(295);
                              }
                              this.showOverheadNumber(Timeline.WORD,_loc6_);
                              this.updateBattleFrame();
                              Main.updateMenu();
                              break;
                           case BloodlineData.EFFECT_MAX_CP_RECOVER:
                              this.updateCP(0);
                              this.updateBattleFrame();
                              Main.updateMenu();
                              break;
                           case BloodlineData.EFFECT_SKIP_DEAD_CLEAR_DEBUFF:
                        }
                     }
                  }
               }
               _loc12_ = 0;
               _loc13_ = "";
               if(this.battleBuff[_loc1_].duration <= 0)
               {
                  if(this.battleBuff[_loc1_].amount)
                  {
                     _loc12_ = Number(this.battleBuff[_loc1_].amount);
                  }
                  if(this.battleBuff[_loc1_].requirement)
                  {
                     _loc13_ = this.battleBuff[_loc1_].requirement;
                  }
                  this.battleBuff[_loc1_] = null;
                  switch(_loc1_)
                  {
                     case BattleData.SKILL_285:
                        this.syncCoolDown();
                        break;
                     case BattleData.EFFECT_DAMAGE_REDUCTIONA:
                     case BattleData.EFFECT_DAMAGE_REDUCTION:
                     case BattleData.EFFECT_DAMAGE_BONUSA:
                     case BattleData.EFFECT_DAMAGE_BONUS:
                     case BattleData.EFFECT_DAMAGE_BONUS_FIX_NUM:
                     case BattleData.EFFECT_PET_DAMAGE_BONUS:
                     case BattleData.EFFECT_DODGE_BONUS:
                     case BattleData.EFFECT_PET_DODGE_BONUS:
                     case BattleData.EFFECT_CRITICAL_CHANCE_BONUS:
                     case BattleData.EFFECT_CRITICAL_CHANCE_BONUS:
                     case BattleData.EFFECT_COMBUSTION:
                     case BattleData.EFFECT_GATE_OPENING:
                     case BattleData.EFFECT_REACTIVE_FORCE:
                     case BattleData.EFFECT_MANA_SHIELD:
                     case BattleData.EFFECT_HEAL_OVER_TIME:
                     case BattleData.EFFECT_BERSERKER_MODE:
                     case BattleData.EFFECT_THUNDERSTORM_MODE:
                     case BattleData.EFFECT_PET_ATTENTION:
                     case BattleData.EFFECT_COMPLETE_GUARD:
                     case BattleData.EFFECT_CATALYTIC_MATTER:
                     case BattleData.EFFECT_PET_DEBUFF_RESIST:
                     case BattleData.EFFECT_PET_DAMAGE_REDUCTION:
                     case BattleData.EFFECT_PET_HEAL:
                     case BattleData.EFFECT_PET_DAMAGE_TO_CP:
                     case BattleData.EFFECT_PET_SAVE_CP:
                     case BattleData.EFFECT_PET_REFLECT_ATTACK:
                     case BattleData.EFFECT_PET_LIGHTNING:
                     case BattleData.EFFECT_PET_DRAIN_HP_KEKKAI:
                     case BattleData.EFFECT_FRENZY:
                     case BattleData.EFFECT_SERENE_MIND:
                     case BattleData.EFFECT_HIT_SELF:
                     case BattleData.EFFECT_ATTACK_MODE:
                     case BattleData.EFFECT_DEFENCE_MODE:
                     case BattleData.EFFECT_PET_ENERGIZE:
                     case BattleData.EFFECT_GUARD:
                     case BattleData.EFFECT_BUNNY_FRENZY:
                     case BattleData.EFFECT_BATTLE_BUNNY_FRENZY:
                     case BattleData.EFFECT_EXTRA_CP_RECOVER:
                     case BattleData.EFFECT_BLOOD_FEED:
                     case BattleData.EFFECT_CRIT_CHANCE_DMG:
                     case BattleData.SKILL_307:
                  }
                  _loc10_ = "";
                  _loc11_ = "";
                  _loc4_ = "";
                  _loc5_ = [];
                  _loc5_ = _loc1_.split(".");
                  if((Boolean(_loc5_)) && _loc5_.length > 0)
                  {
                     _loc4_ = _loc5_[0];
                  }
                  if(Battle.type == Battle.TYPE_NETWORK)
                  {
                     if(_loc5_.indexOf("skill1005") >= 0)
                     {
                        _loc4_ = "";
                     }
                  }
                  if(Boolean(_loc4_) && _loc4_ != "")
                  {
                     if(_loc12_ > 0)
                     {
                        _loc11_ = "+";
                     }
                     switch(_loc4_)
                     {
                        case BloodlineData.EFFECT_ACCURATE:
                           if(_loc12_ > 0)
                           {
                              _loc10_ = Central.main.langLib.get(735);
                           }
                           else
                           {
                              _loc10_ = Central.main.langLib.get(287);
                           }
                           break;
                        case BloodlineData.EFFECT_CAPTURE:
                           _loc10_ = Central.main.langLib.get(736);
                           break;
                        case BloodlineData.EFFECT_CLEAR_BUFF:
                           _loc10_ = Central.main.langLib.get(737);
                           break;
                        case BloodlineData.EFFECT_CONVERT_DMG_CP:
                           _loc10_ = Central.main.langLib.get(738);
                           break;
                        case BloodlineData.EFFECT_CONVERT_DMG_HP:
                           _loc10_ = Central.main.langLib.get(739);
                           break;
                        case BloodlineData.EFFECT_CRITICAL:
                           if(_loc12_ > 0)
                           {
                              _loc10_ = Central.main.langLib.get(740);
                           }
                           else
                           {
                              _loc10_ = Central.main.langLib.get(670);
                           }
                           break;
                        case BloodlineData.EFFECT_DODGE:
                           if(_loc12_ > 0)
                           {
                              _loc10_ = Central.main.langLib.get(741);
                           }
                           else
                           {
                              _loc10_ = Central.main.langLib.get(799);
                           }
                           break;
                        case BloodlineData.EFFECT_MAX_CP:
                           _loc10_ = "";
                           break;
                        case BloodlineData.EFFECT_MAX_CP_RECOVER:
                           _loc10_ = Central.main.langLib.get(742);
                           break;
                        case BloodlineData.EFFECT_MAX_HP:
                           _loc10_ = "";
                           break;
                        case BloodlineData.EFFECT_MERIDIAN_BLOCK:
                           break;
                        case BloodlineData.EFFECT_MODIFY_COOLDOWN:
                           if(_loc12_ > 0)
                           {
                              _loc10_ = Central.main.langLib.get(744);
                           }
                           else
                           {
                              _loc10_ = Central.main.langLib.get(800);
                           }
                           break;
                        case BloodlineData.EFFECT_MODIFY_DAMAGE_ALL:
                           if(_loc12_ > 0)
                           {
                              _loc10_ = Central.main.langLib.get(745);
                           }
                           else
                           {
                              _loc10_ = Central.main.langLib.get(801);
                           }
                           break;
                        case BloodlineData.EFFECT_MODIFY_DAMAGE_BYTYPE:
                           _loc13_ = String(_loc13_).replace("fire",Central.main.langLib.titleTxt(TitleData.FIRE));
                           _loc13_ = String(_loc13_).replace("wind",Central.main.langLib.titleTxt(TitleData.WIND));
                           _loc13_ = String(_loc13_).replace("lightning",Central.main.langLib.titleTxt(TitleData.THUNDER));
                           _loc13_ = String(_loc13_).replace("water",Central.main.langLib.titleTxt(TitleData.WATER));
                           _loc13_ = String(_loc13_).replace("earth",Central.main.langLib.titleTxt(TitleData.EARTH));
                           _loc13_ = String(_loc13_).replace("taijutsu",Central.main.langLib.btnTxt(ButtonData.TAIJUTSU));
                           _loc13_ = String(_loc13_).replace("genjutsu",Central.main.langLib.btnTxt(ButtonData.GENJUTSU));
                           _loc15_ = null;
                           _loc15_ = _loc13_.split(",");
                           if(_loc12_ > 0)
                           {
                              _loc10_ = Central.main.langLib.get(746);
                           }
                           else
                           {
                              _loc10_ = Central.main.langLib.get(801);
                           }
                           break;
                        case BloodlineData.EFFECT_MODIFY_DAMAGE_CRITICAL:
                           if(_loc12_ > 0)
                           {
                              _loc10_ = Central.main.langLib.get(747);
                           }
                           else
                           {
                              _loc10_ = Central.main.langLib.get(688);
                           }
                           break;
                        case BloodlineData.EFFECT_MODIFY_DEFENCE_ALL:
                           if(_loc12_ > 0)
                           {
                              _loc10_ = Central.main.langLib.get(748);
                           }
                           else
                           {
                              _loc10_ = Central.main.langLib.get(802);
                           }
                           break;
                        case BloodlineData.EFFECT_MODIFY_DEFENCE_BYTYPE:
                           _loc13_ = String(_loc13_).replace("fire",Central.main.langLib.titleTxt(TitleData.FIRE));
                           _loc13_ = String(_loc13_).replace("wind",Central.main.langLib.titleTxt(TitleData.WIND));
                           _loc13_ = String(_loc13_).replace("lightning",Central.main.langLib.titleTxt(TitleData.THUNDER));
                           _loc13_ = String(_loc13_).replace("water",Central.main.langLib.titleTxt(TitleData.WATER));
                           _loc13_ = String(_loc13_).replace("earth",Central.main.langLib.titleTxt(TitleData.EARTH));
                           _loc13_ = String(_loc13_).replace("taijutsu",Central.main.langLib.btnTxt(ButtonData.TAIJUTSU));
                           _loc13_ = String(_loc13_).replace("genjutsu",Central.main.langLib.btnTxt(ButtonData.GENJUTSU));
                           _loc15_ = null;
                           _loc15_ = _loc13_.split(",");
                           if(_loc12_ > 0)
                           {
                              _loc10_ = Central.main.langLib.get(748);
                           }
                           else
                           {
                              _loc10_ = Central.main.langLib.get(803);
                           }
                           break;
                        case BloodlineData.EFFECT_REACTIVE_DEBUFF_ATTACKER:
                           _loc10_ = Central.main.langLib.get(749);
                           break;
                        case BloodlineData.EFFECT_REACTIVE_DEBUFF_DEFENDER:
                           _loc10_ = Central.main.langLib.get(750);
                           break;
                        case BloodlineData.EFFECT_REFLECT_DAMAGE:
                           _loc10_ = Central.main.langLib.get(751);
                           break;
                        case BloodlineData.EFFECT_REFLECT_GENJUTSU:
                           _loc10_ = Central.main.langLib.get(752);
                           break;
                        case BloodlineData.EFFECT_STUN:
                           _loc10_ = Central.main.langLib.get(281);
                           break;
                        case BloodlineData.EFFECT_UPDATE_CP:
                           _loc10_ = "";
                           break;
                        case BloodlineData.EFFECT_UPDATE_HP:
                           _loc10_ = "";
                           if(_loc5_[1] == "skill1019")
                           {
                              _loc10_ = Central.main.langLib.get(753);
                           }
                           break;
                        case BloodlineData.EFFECT_RESTRICT_CHARGE:
                           _loc10_ = Central.main.langLib.get(754);
                           break;
                        case BloodlineData.EFFECT_EXTRA_CHARGE_RECOVER:
                           if(_loc12_ > 0)
                           {
                              _loc10_ = Central.main.langLib.get(755);
                           }
                           else
                           {
                              _loc10_ = Central.main.langLib.get(804);
                           }
                           break;
                        case BloodlineData.EFFECT_RESIST_DEBUFF:
                           _loc10_ = Central.main.langLib.get(756);
                           break;
                        case BloodlineData.EFFECT_DRAIN_HP:
                           _loc10_ = Central.main.langLib.get(757);
                           break;
                        case BloodlineData.EFFECT_MODIFY_TAIJUTSU_SELFHIT:
                           if(_loc12_ > 0)
                           {
                              _loc10_ = Central.main.langLib.get(758);
                           }
                           else
                           {
                              _loc10_ = Central.main.langLib.get(806);
                           }
                           break;
                        case BloodlineData.EFFECT_INTERNAL_INJURY:
                           _loc10_ = Central.main.langLib.get(648);
                           break;
                        case BloodlineData.EFFECT_RESURRECTION:
                           _loc10_ = Central.main.langLib.get(759);
                           break;
                        case BloodlineData.EFFECT_COPY_JUTSU:
                           _loc10_ = Central.main.langLib.get(760);
                           break;
                        case BloodlineData.EFFECT_TITAN:
                           _loc10_ = Central.main.langLib.get(761);
                           break;
                        case BloodlineData.EFFECT_EXTRA_CP_USE:
                           if(_loc12_ > 0)
                           {
                              _loc10_ = Central.main.langLib.get(805);
                           }
                           else
                           {
                              _loc10_ = Central.main.langLib.get(762);
                           }
                           break;
                        case BloodlineData.EFFECT_EXTREME:
                           _loc10_ = Central.main.langLib.get(763);
                           break;
                        case BloodlineData.EFFECT_HALLUCINATIONS:
                           _loc10_ = Central.main.langLib.get(734);
                           break;
                        case BloodlineData.EFFECT_SKIP_DEAD_CLEAR_DEBUFF:
                           _loc10_ = Central.main.langLib.get(2005) + "(" + this.battleBuff[_loc1_].duration + ")";
                           break;
                        case BloodlineData.EFFECT_BL_UPDATE_HP_FIX_NUM:
                           _loc10_ = Central.main.langLib.get(2011) + "(" + this.battleBuff[_loc1_].duration + ")";
                     }
                     if(_loc10_ != "")
                     {
                        _loc10_ = _loc10_ + " " + Central.main.langLib.get(647);
                        if(_loc15_)
                        {
                           _loc16_ = 0;
                           while(_loc16_ < _loc15_.length)
                           {
                              _loc16_++;
                           }
                        }
                     }
                  }
               }
               else
               {
                  _loc12_ = 0;
                  _loc13_ = "";
                  _loc14_ = 0;
                  if(this.battleBuff[_loc1_].amount)
                  {
                     _loc12_ = Number(this.battleBuff[_loc1_].amount);
                  }
                  if(this.battleBuff[_loc1_].requirement)
                  {
                     _loc13_ = this.battleBuff[_loc1_].requirement;
                  }
                  if(this.battleBuff[_loc1_].duration)
                  {
                     _loc14_ = Number(this.battleBuff[_loc1_].duration);
                  }
                  _loc10_ = "";
                  _loc11_ = "";
                  _loc4_ = "";
                  _loc5_ = [];
                  _loc5_ = _loc1_.split(".");
                  if((Boolean(_loc5_)) && _loc5_.length > 0)
                  {
                     _loc4_ = _loc5_[0];
                  }
                  if(Battle.type == Battle.TYPE_NETWORK)
                  {
                     if(_loc5_.indexOf("skill1005") >= 0)
                     {
                        _loc4_ = "";
                     }
                  }
                  if(Boolean(_loc4_) && Boolean(_loc4_ != "") && _loc14_ <= BloodlineData.PASSIVE_BUFF_IDENTIFIER)
                  {
                     if(_loc12_ > 0)
                     {
                        _loc11_ = "+";
                     }
                     switch(_loc4_)
                     {
                        case BloodlineData.EFFECT_ACCURATE:
                           if(_loc12_ > 0)
                           {
                              _loc10_ = Central.main.langLib.get(735);
                           }
                           else
                           {
                              _loc10_ = Central.main.langLib.get(287);
                           }
                           break;
                        case BloodlineData.EFFECT_CAPTURE:
                           _loc10_ = Central.main.langLib.get(736);
                           break;
                        case BloodlineData.EFFECT_CLEAR_BUFF:
                           _loc10_ = Central.main.langLib.get(737);
                           break;
                        case BloodlineData.EFFECT_CONVERT_DMG_CP:
                           _loc10_ = Central.main.langLib.get(738);
                           break;
                        case BloodlineData.EFFECT_CONVERT_DMG_HP:
                           _loc10_ = Central.main.langLib.get(739);
                           break;
                        case BloodlineData.EFFECT_CRITICAL:
                           if(_loc12_ > 0)
                           {
                              _loc10_ = Central.main.langLib.get(740);
                           }
                           else
                           {
                              _loc10_ = Central.main.langLib.get(670);
                           }
                           break;
                        case BloodlineData.EFFECT_DODGE:
                           if(_loc12_ > 0)
                           {
                              _loc10_ = Central.main.langLib.get(741);
                           }
                           else
                           {
                              _loc10_ = Central.main.langLib.get(799);
                           }
                           break;
                        case BloodlineData.EFFECT_MAX_CP:
                           _loc10_ = "";
                           break;
                        case BloodlineData.EFFECT_MAX_CP_RECOVER:
                           _loc10_ = Central.main.langLib.get(742);
                           break;
                        case BloodlineData.EFFECT_MAX_HP:
                           _loc10_ = "";
                           break;
                        case BloodlineData.EFFECT_MODIFY_COOLDOWN:
                           if(_loc12_ > 0)
                           {
                              _loc10_ = Central.main.langLib.get(744);
                           }
                           else
                           {
                              _loc10_ = Central.main.langLib.get(800);
                           }
                           break;
                        case BloodlineData.EFFECT_MODIFY_DAMAGE_ALL:
                           if(_loc12_ > 0)
                           {
                              _loc10_ = Central.main.langLib.get(745);
                           }
                           else
                           {
                              _loc10_ = Central.main.langLib.get(801);
                           }
                           break;
                        case BloodlineData.EFFECT_MODIFY_DAMAGE_BYTYPE:
                           _loc13_ = String(_loc13_).replace("fire",Central.main.langLib.titleTxt(TitleData.FIRE));
                           _loc13_ = String(_loc13_).replace("wind",Central.main.langLib.titleTxt(TitleData.WIND));
                           _loc13_ = String(_loc13_).replace("lightning",Central.main.langLib.titleTxt(TitleData.THUNDER));
                           _loc13_ = String(_loc13_).replace("water",Central.main.langLib.titleTxt(TitleData.WATER));
                           _loc13_ = String(_loc13_).replace("earth",Central.main.langLib.titleTxt(TitleData.EARTH));
                           _loc13_ = String(_loc13_).replace("taijutsu",Central.main.langLib.btnTxt(ButtonData.TAIJUTSU));
                           _loc13_ = String(_loc13_).replace("genjutsu",Central.main.langLib.btnTxt(ButtonData.GENJUTSU));
                           _loc15_ = null;
                           _loc15_ = _loc13_.split(",");
                           if(_loc12_ > 0)
                           {
                              _loc10_ = Central.main.langLib.get(746);
                           }
                           else
                           {
                              _loc10_ = Central.main.langLib.get(801);
                           }
                           break;
                        case BloodlineData.EFFECT_MODIFY_DAMAGE_CRITICAL:
                           if(_loc12_ > 0)
                           {
                              _loc10_ = Central.main.langLib.get(747);
                           }
                           else
                           {
                              _loc10_ = Central.main.langLib.get(688);
                           }
                           break;
                        case BloodlineData.EFFECT_MODIFY_DEFENCE_ALL:
                           if(_loc12_ > 0)
                           {
                              _loc10_ = Central.main.langLib.get(748);
                           }
                           else
                           {
                              _loc10_ = Central.main.langLib.get(802);
                           }
                           break;
                        case BloodlineData.EFFECT_MODIFY_DEFENCE_BYTYPE:
                           _loc13_ = String(_loc13_).replace("fire",Central.main.langLib.titleTxt(TitleData.FIRE));
                           _loc13_ = String(_loc13_).replace("wind",Central.main.langLib.titleTxt(TitleData.WIND));
                           _loc13_ = String(_loc13_).replace("lightning",Central.main.langLib.titleTxt(TitleData.THUNDER));
                           _loc13_ = String(_loc13_).replace("water",Central.main.langLib.titleTxt(TitleData.WATER));
                           _loc13_ = String(_loc13_).replace("earth",Central.main.langLib.titleTxt(TitleData.EARTH));
                           _loc13_ = String(_loc13_).replace("taijutsu",Central.main.langLib.btnTxt(ButtonData.TAIJUTSU));
                           _loc13_ = String(_loc13_).replace("genjutsu",Central.main.langLib.btnTxt(ButtonData.GENJUTSU));
                           _loc15_ = null;
                           _loc15_ = _loc13_.split(",");
                           if(_loc12_ > 0)
                           {
                              _loc10_ = Central.main.langLib.get(748);
                           }
                           else
                           {
                              _loc10_ = Central.main.langLib.get(803);
                           }
                           break;
                        case BloodlineData.EFFECT_REACTIVE_DEBUFF_ATTACKER:
                        case BloodlineData.EFFECT_REACTIVE_DEBUFF_DEFENDER:
                           break;
                        case BloodlineData.EFFECT_REFLECT_DAMAGE:
                           _loc10_ = Central.main.langLib.get(751);
                           break;
                        case BloodlineData.EFFECT_REFLECT_GENJUTSU:
                           _loc10_ = Central.main.langLib.get(752);
                           break;
                        case BloodlineData.EFFECT_STUN:
                           _loc10_ = "";
                           break;
                        case BloodlineData.EFFECT_UPDATE_CP:
                           _loc10_ = "";
                           break;
                        case BloodlineData.EFFECT_UPDATE_HP:
                           _loc10_ = "";
                           if(_loc5_[1] == "skill1019")
                           {
                              _loc10_ = "";
                           }
                           break;
                        case BloodlineData.EFFECT_RESTRICT_CHARGE:
                           _loc10_ = Central.main.langLib.get(754);
                           break;
                        case BloodlineData.EFFECT_EXTRA_CHARGE_RECOVER:
                           if(_loc12_ > 0)
                           {
                              _loc10_ = Central.main.langLib.get(755);
                           }
                           else
                           {
                              _loc10_ = Central.main.langLib.get(804);
                           }
                           break;
                        case BloodlineData.EFFECT_RESIST_DEBUFF:
                           _loc10_ = Central.main.langLib.get(756);
                           break;
                        case BloodlineData.EFFECT_DRAIN_HP:
                           _loc10_ = Central.main.langLib.get(757);
                           break;
                        case BloodlineData.EFFECT_MODIFY_TAIJUTSU_SELFHIT:
                           if(_loc12_ > 0)
                           {
                              _loc10_ = Central.main.langLib.get(758);
                           }
                           else
                           {
                              _loc10_ = Central.main.langLib.get(806);
                           }
                           break;
                        case BloodlineData.EFFECT_INTERNAL_INJURY:
                           _loc10_ = Central.main.langLib.get(648);
                           break;
                        case BloodlineData.EFFECT_RESURRECTION:
                           _loc10_ = Central.main.langLib.get(759);
                           break;
                        case BloodlineData.EFFECT_COPY_JUTSU:
                           _loc10_ = Central.main.langLib.get(760);
                           break;
                        case BloodlineData.EFFECT_TITAN:
                           _loc10_ = Central.main.langLib.get(761);
                           break;
                        case BloodlineData.EFFECT_EXTRA_CP_USE:
                           if(_loc12_ > 0)
                           {
                              _loc10_ = Central.main.langLib.get(805);
                           }
                           else
                           {
                              _loc10_ = Central.main.langLib.get(762);
                           }
                           break;
                        case BloodlineData.EFFECT_EXTREME:
                           _loc10_ = Central.main.langLib.get(763);
                           break;
                        case BloodlineData.EFFECT_HALLUCINATIONS:
                           _loc10_ = Central.main.langLib.get(734);
                           break;
                        case BloodlineData.EFFECT_SKIP_DEAD_CLEAR_DEBUFF:
                           _loc10_ = Central.main.langLib.get(2005);
                           break;
                        case BloodlineData.EFFECT_BL_UPDATE_HP_FIX_NUM:
                           _loc10_ = Central.main.langLib.get(2011);
                     }
                     if(_loc10_ != "")
                     {
                        _loc10_ = _loc10_ + "(" + String(_loc14_) + ")";
                        if(_loc15_)
                        {
                           _loc16_ = 0;
                           while(_loc16_ < _loc15_.length)
                           {
                              this.showOverheadNumber(Timeline.WORD,_loc15_[_loc16_] + " " + _loc10_);
                              _loc16_++;
                           }
                        }
                        else
                        {
                           this.showOverheadNumber(Timeline.WORD,_loc10_);
                        }
                     }
                  }
               }
            }
         }
         trace("hank :: battle debuff = " + GF.printObject(this.battleDebuff));
         for(_loc1_ in this.battleDebuff)
         {
            if(this.battleDebuff[_loc1_])
            {
               if(Battle.type == Battle.TYPE_NETWORK)
               {
                  if(this.battleDebuff[_loc1_].duration <= BloodlineData.PASSIVE_DEBUFF_IDENTIFIER)
                  {
                  }
               }
               if(this.battleDebuff[_loc1_].duration > 0)
               {
                  trace("Hank :: key >> " + _loc1_);
                  switch(_loc1_)
                  {
                     case SenjutsuData.EFFECT_SS_BUNDLE_TALENT:
                        this.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(2001)[6] + "(" + this.battleDebuff[_loc1_].duration + ")");
                        Out.debug("characterbattle hank","EFFECT_SS_BUNDLE_TALENT");
                  }
               }
               if(this.battleDebuff[_loc1_].duration <= 0)
               {
                  _loc12_ = 0;
                  _loc13_ = "";
                  if(this.battleDebuff[_loc1_].amount)
                  {
                     _loc12_ = Number(this.battleDebuff[_loc1_].amount);
                  }
                  if(this.battleDebuff[_loc1_].requirement)
                  {
                     _loc13_ = this.battleDebuff[_loc1_].requirement;
                  }
                  this.battleDebuff[_loc1_] = null;
                  switch(_loc1_)
                  {
                     case BattleData.EFFECT_BLEEDING:
                     case BattleData.EFFECT_BLEEDING_FIX_NUM:
                     case BattleData.EFFECT_PET_BLEEDING:
                     case BattleData.EFFECT_DOUBLE_BURN:
                     case BattleData.EFFECT_BURN:
                     case BattleData.EFFECT_BLIND:
                     case BattleData.EFFECT_BUNDLE:
                     case BattleData.SKILL_377:
                     case BattleData.EFFECT_POISON:
                     case BattleData.EFFECT_FEAR:
                     case BattleData.EFFECT_FEAR_WEAKEN:
                     case BattleData.EFFECT_SOUL_CHAINS_BUNDLE:
                     case BattleData.EFFECT_PARASITE:
                     case BattleData.EFFECT_BURNING:
                     case BattleData.EFFECT_JUTSU_POISON:
                     case BattleData.EFFECT_PET_BURN:
                     case BattleData.EFFECT_DODGE_REDUCTION:
                     case BattleData.EFFECT_DISTRACT:
                     case BattleData.EFFECT_HAMSTRING:
                     case BattleData.EFFECT_CUBE_ILLUSION:
                        break;
                     case BattleData.EFFECT_SILVER_CHAIN_BUNDLE:
                        if(_loc12_ == 2)
                        {
                        }
                        break;
                     case BattleData.EFFECT_INTERNAL_INJURY:
                     case BattleData.EFFECT_DARK_CURSE:
                     case BattleData.EFFECT_LIGHT_IMPLUSE:
                     case BattleData.EFFECT_BLOOD_DRINKER:
                     case BattleData.EFFECT_BLOOD_DRINKER_N_RESTORE_HP:
                     case BattleData.EFFECT_PET_BLIND:
                     case BattleData.EFFECT_PET_WEAKEN:
                     case BattleData.EFFECT_DISMANTLE:
                     case BattleData.EFFECT_CHAOS:
                     case BattleData.EFFECT_PET_FREEZE:
                     case BattleData.EFFECT_PETRIFICATION:
                     case BattleData.EFFECT_ECSTATIC_SOUND:
                     case BattleData.EFFECT_PET_REDUCE_CHARGE:
                     case BattleData.EFFECT_PET_DISORIENTED:
                     case BattleData.EFFECT_SLEEP:
                     case BattleData.EFFECT_DARKNESS:
                     case BattleData.SKILL_342:
                     case BattleData.EFFECT_MERIDIANS_SEAL:
                     case BattleData.EFFECT_RESTRICT_CHARGE:
                     case BattleData.SKILL_359:
                  }
                  _loc10_ = "";
                  _loc11_ = "";
                  _loc4_ = "";
                  _loc5_ = [];
                  _loc5_ = _loc1_.split(".");
                  if((Boolean(_loc5_)) && _loc5_.length > 0)
                  {
                     _loc4_ = _loc5_[0];
                  }
                  if(Battle.type == Battle.TYPE_NETWORK)
                  {
                     if(_loc5_.indexOf("skill1005") >= 0)
                     {
                        _loc4_ = "";
                     }
                  }
                  if(Boolean(_loc4_) && _loc4_ != "")
                  {
                     if(_loc12_ > 0)
                     {
                        _loc11_ = "+";
                     }
                     switch(_loc4_)
                     {
                        case BloodlineData.EFFECT_ACCURATE:
                           if(_loc12_ > 0)
                           {
                              _loc10_ = Central.main.langLib.get(735);
                           }
                           else
                           {
                              _loc10_ = Central.main.langLib.get(287);
                           }
                           break;
                        case BloodlineData.EFFECT_CAPTURE:
                           _loc10_ = Central.main.langLib.get(736);
                           break;
                        case BloodlineData.EFFECT_CLEAR_BUFF:
                           _loc10_ = Central.main.langLib.get(737);
                           break;
                        case BloodlineData.EFFECT_CONVERT_DMG_CP:
                           _loc10_ = Central.main.langLib.get(738);
                           break;
                        case BloodlineData.EFFECT_CONVERT_DMG_HP:
                           _loc10_ = Central.main.langLib.get(739);
                           break;
                        case BloodlineData.EFFECT_CRITICAL:
                           if(_loc12_ > 0)
                           {
                              _loc10_ = Central.main.langLib.get(740);
                           }
                           else
                           {
                              _loc10_ = Central.main.langLib.get(670);
                           }
                           break;
                        case BloodlineData.EFFECT_DODGE:
                           if(_loc12_ > 0)
                           {
                              _loc10_ = Central.main.langLib.get(741);
                           }
                           else
                           {
                              _loc10_ = Central.main.langLib.get(799);
                           }
                           break;
                        case BloodlineData.EFFECT_MAX_CP:
                           _loc10_ = "";
                           break;
                        case BloodlineData.EFFECT_MAX_CP_RECOVER:
                           break;
                        case BloodlineData.EFFECT_MAX_HP:
                           _loc10_ = "";
                           break;
                        case BloodlineData.EFFECT_MODIFY_COOLDOWN:
                           if(_loc12_ > 0)
                           {
                              _loc10_ = Central.main.langLib.get(744);
                           }
                           else
                           {
                              _loc10_ = Central.main.langLib.get(800);
                           }
                           break;
                        case BloodlineData.EFFECT_MODIFY_DAMAGE_ALL:
                           if(_loc12_ > 0)
                           {
                              _loc10_ = Central.main.langLib.get(745);
                           }
                           else
                           {
                              _loc10_ = Central.main.langLib.get(801);
                           }
                           break;
                        case BloodlineData.EFFECT_MODIFY_DAMAGE_BYTYPE:
                           _loc13_ = String(_loc13_).replace("fire",Central.main.langLib.titleTxt(TitleData.FIRE));
                           _loc13_ = String(_loc13_).replace("wind",Central.main.langLib.titleTxt(TitleData.WIND));
                           _loc13_ = String(_loc13_).replace("lightning",Central.main.langLib.titleTxt(TitleData.THUNDER));
                           _loc13_ = String(_loc13_).replace("water",Central.main.langLib.titleTxt(TitleData.WATER));
                           _loc13_ = String(_loc13_).replace("earth",Central.main.langLib.titleTxt(TitleData.EARTH));
                           _loc13_ = String(_loc13_).replace("taijutsu",Central.main.langLib.btnTxt(ButtonData.TAIJUTSU));
                           _loc13_ = String(_loc13_).replace("genjutsu",Central.main.langLib.btnTxt(ButtonData.GENJUTSU));
                           _loc15_ = null;
                           _loc15_ = _loc13_.split(",");
                           if(_loc12_ > 0)
                           {
                              _loc10_ = Central.main.langLib.get(746);
                           }
                           else
                           {
                              _loc10_ = Central.main.langLib.get(801);
                           }
                           break;
                        case BloodlineData.EFFECT_MODIFY_DAMAGE_CRITICAL:
                           if(_loc12_ > 0)
                           {
                              _loc10_ = Central.main.langLib.get(747);
                           }
                           else
                           {
                              _loc10_ = Central.main.langLib.get(688);
                           }
                           break;
                        case BloodlineData.EFFECT_MODIFY_DEFENCE_ALL:
                           if(_loc12_ > 0)
                           {
                              _loc10_ = Central.main.langLib.get(748);
                           }
                           else
                           {
                              _loc10_ = Central.main.langLib.get(802);
                           }
                           break;
                        case BloodlineData.EFFECT_MODIFY_DEFENCE_BYTYPE:
                           _loc13_ = String(_loc13_).replace("fire",Central.main.langLib.titleTxt(TitleData.FIRE));
                           _loc13_ = String(_loc13_).replace("wind",Central.main.langLib.titleTxt(TitleData.WIND));
                           _loc13_ = String(_loc13_).replace("lightning",Central.main.langLib.titleTxt(TitleData.THUNDER));
                           _loc13_ = String(_loc13_).replace("water",Central.main.langLib.titleTxt(TitleData.WATER));
                           _loc13_ = String(_loc13_).replace("earth",Central.main.langLib.titleTxt(TitleData.EARTH));
                           _loc13_ = String(_loc13_).replace("taijutsu",Central.main.langLib.btnTxt(ButtonData.TAIJUTSU));
                           _loc13_ = String(_loc13_).replace("genjutsu",Central.main.langLib.btnTxt(ButtonData.GENJUTSU));
                           _loc15_ = null;
                           _loc15_ = _loc13_.split(",");
                           if(_loc12_ > 0)
                           {
                              _loc10_ = Central.main.langLib.get(748);
                           }
                           else
                           {
                              _loc10_ = Central.main.langLib.get(803);
                           }
                           break;
                        case BloodlineData.EFFECT_REACTIVE_DEBUFF_ATTACKER:
                           _loc10_ = Central.main.langLib.get(749);
                           break;
                        case BloodlineData.EFFECT_REACTIVE_DEBUFF_DEFENDER:
                           _loc10_ = Central.main.langLib.get(750);
                           break;
                        case BloodlineData.EFFECT_REFLECT_DAMAGE:
                           _loc10_ = Central.main.langLib.get(751);
                           break;
                        case BloodlineData.EFFECT_REFLECT_GENJUTSU:
                           _loc10_ = Central.main.langLib.get(752);
                           break;
                        case BloodlineData.EFFECT_STUN:
                           _loc10_ = Central.main.langLib.get(281);
                           break;
                        case BloodlineData.EFFECT_UPDATE_CP:
                           _loc10_ = "";
                           break;
                        case BloodlineData.EFFECT_UPDATE_HP:
                           _loc10_ = "";
                           if(_loc5_[1] == "skill1019")
                           {
                              _loc10_ = Central.main.langLib.get(753);
                           }
                           break;
                        case BloodlineData.EFFECT_RESTRICT_CHARGE:
                           _loc10_ = Central.main.langLib.get(754);
                           break;
                        case BloodlineData.EFFECT_EXTRA_CHARGE_RECOVER:
                           if(_loc12_ > 0)
                           {
                              _loc10_ = Central.main.langLib.get(755);
                           }
                           else
                           {
                              _loc10_ = Central.main.langLib.get(804);
                           }
                           break;
                        case BloodlineData.EFFECT_RESIST_DEBUFF:
                           _loc10_ = Central.main.langLib.get(756);
                           break;
                        case BloodlineData.EFFECT_DRAIN_HP:
                           _loc10_ = Central.main.langLib.get(757);
                           break;
                        case BloodlineData.EFFECT_MODIFY_TAIJUTSU_SELFHIT:
                           if(_loc12_ > 0)
                           {
                              _loc10_ = Central.main.langLib.get(758);
                           }
                           else
                           {
                              _loc10_ = Central.main.langLib.get(806);
                           }
                           break;
                        case BloodlineData.EFFECT_INTERNAL_INJURY:
                           _loc10_ = Central.main.langLib.get(648);
                           break;
                        case BloodlineData.EFFECT_RESURRECTION:
                           _loc10_ = Central.main.langLib.get(759);
                           break;
                        case BloodlineData.EFFECT_COPY_JUTSU:
                           _loc10_ = Central.main.langLib.get(760);
                           break;
                        case BloodlineData.EFFECT_TITAN:
                           _loc10_ = Central.main.langLib.get(761);
                           break;
                        case BloodlineData.EFFECT_EXTRA_CP_USE:
                           if(_loc12_ > 0)
                           {
                              _loc10_ = Central.main.langLib.get(805);
                           }
                           else
                           {
                              _loc10_ = Central.main.langLib.get(762);
                           }
                           break;
                        case BloodlineData.EFFECT_EXTREME:
                           _loc10_ = Central.main.langLib.get(763);
                           break;
                        case BloodlineData.EFFECT_HALLUCINATIONS:
                           _loc10_ = Central.main.langLib.get(734);
                     }
                     if(_loc10_ != "")
                     {
                        _loc10_ = _loc10_ + " " + Central.main.langLib.get(647);
                        if(_loc15_)
                        {
                           _loc16_ = 0;
                           while(_loc16_ < _loc15_.length)
                           {
                              _loc16_++;
                           }
                        }
                     }
                  }
               }
               else
               {
                  switch(_loc1_)
                  {
                     case BattleData.EFFECT_BLEEDING:
                     case BattleData.EFFECT_BLEEDING_FIX_NUM:
                     case BattleData.EFFECT_PET_BLEEDING:
                        this.showOverheadNumber(Timeline.WORD,String(Central.main.langLib.get(286) + "(" + this.battleDebuff[_loc1_].duration + ")"));
                        break;
                     case BattleData.EFFECT_DECREASE_CRITICAL_CHANCE:
                        this.showOverheadNumber(Timeline.WORD,String(Central.main.langLib.get(670) + "(" + this.battleDebuff[_loc1_].duration + ")"));
                        break;
                     case BattleData.EFFECT_BLIND:
                     case BattleData.EFFECT_ALL_CP_BLIND:
                        this.showOverheadNumber(Timeline.WORD,String(Central.main.langLib.get(287) + "(" + this.battleDebuff[_loc1_].duration + ")"));
                        break;
                     case BattleData.EFFECT_DODGE_REDUCTION:
                        this.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(799));
                        break;
                     case BattleData.EFFECT_DISTRACT:
                        this.showOverheadNumber(Timeline.WORD,String(Central.main.langLib.get(671)).replace("[valamt]",(this.battleDebuff[_loc1_].amount * 100).toString()));
                        break;
                     case BattleData.EFFECT_HAMSTRING:
                        this.showOverheadNumber(Timeline.WORD,String(Central.main.langLib.get(688)));
                        break;
                     case BattleData.EFFECT_INTERNAL_INJURY:
                        this.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(648));
                        break;
                     case BattleData.EFFECT_DARK_CURSE:
                        this.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(649));
                        break;
                     case BattleData.EFFECT_BLOOD_DRINKER:
                        this.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(819));
                        break;
                     case BattleData.EFFECT_BLOOD_DRINKER_N_RESTORE_HP:
                        this.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(819));
                        break;
                     case BattleData.EFFECT_THEFT_HP:
                        this.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(2034));
                        break;
                     case BattleData.EFFECT_PET_BLIND:
                        this.showOverheadNumber(Timeline.WORD,String(Central.main.langLib.get(287) + Central.main.langLib.get(880).replace("[valturn]",String(this.battleDebuff[_loc1_].duration))));
                        break;
                     case BattleData.EFFECT_DISMANTLE:
                        this.showOverheadNumber(Timeline.WORD,String(Central.main.langLib.get(816).replace("[valturn]",String(this.battleDebuff[_loc1_].duration))));
                        break;
                     case BattleData.SKILL_341:
                        this.showOverheadNumber(Timeline.WORD,String(Central.main.langLib.get(817)));
                        this.showOverheadNumber(Timeline.WORD,String(Central.main.langLib.get(762)));
                        break;
                     case BattleData.EFFECT_CHAOS:
                        this.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(734));
                        break;
                     case BattleData.EFFECT_PET_REDUCE_CHARGE:
                        this.showOverheadNumber(Timeline.WORD,String(Central.main.langLib.get(804) + Central.main.langLib.get(880).replace("[valturn]",String(this.battleDebuff[_loc1_].duration))));
                        break;
                     case BattleData.EFFECT_PET_WEAKEN:
                     case BattleData.EFFECT_PET_WEAKEN_FIX_NUM:
                        this.showOverheadNumber(Timeline.WORD,String(Central.main.langLib.get(801)));
                        break;
                     case BattleData.EFFECT_PET_FREEZE:
                        this.showOverheadNumber(Timeline.WORD,String(Central.main.langLib.get(820) + Central.main.langLib.get(880).replace("[valturn]",String(this.battleDebuff[_loc1_].duration))));
                        break;
                     case BattleData.EFFECT_HIT_SELF:
                        this.showOverheadNumber(Timeline.WORD,String(Central.main.langLib.get(2041) + Central.main.langLib.get(880).replace("[valturn]",String(this.battleDebuff[_loc1_].duration))));
                        break;
                     case BattleData.EFFECT_STUN:
                        this.showOverheadNumber(Timeline.WORD,String(Central.main.langLib.get(281) + Central.main.langLib.get(880).replace("[valturn]",String(this.battleDebuff[_loc1_].duration))));
                        break;
                     case BattleData.EFFECT_PETRIFICATION:
                        this.showOverheadNumber(Timeline.WORD,String(Central.main.langLib.get(954) + Central.main.langLib.get(880).replace("[valturn]",String(this.battleDebuff[_loc1_].duration))));
                        break;
                     case BattleData.EFFECT_SILVER_CHAIN_BUNDLE:
                        if(this.battleDebuff[BattleData.EFFECT_SILVER_CHAIN_BUNDLE].amount == 1)
                        {
                           this.showOverheadNumber(Timeline.WORD,String(Central.main.langLib.get(801) + Central.main.langLib.get(880).replace("[valturn]",String(this.battleDebuff[_loc1_].duration))));
                        }
                        break;
                     case BattleData.EFFECT_PET_DISORIENTED:
                        this.showOverheadNumber(Timeline.WORD,String(Central.main.langLib.get(891) + Central.main.langLib.get(880).replace("[valturn]",String(this.battleDebuff[_loc1_].duration))));
                        break;
                     case BattleData.EFFECT_LIGHT_IMPLUSE:
                        this.showOverheadNumber(Timeline.WORD,String(Central.main.langLib.get(651) + Central.main.langLib.get(880).replace("[valturn]",String(this.battleDebuff[_loc1_].duration))));
                        break;
                     case BattleData.EFFECT_ECSTATIC_SOUND:
                        this.showOverheadNumber(Timeline.WORD,String(Central.main.langLib.get(609) + Central.main.langLib.get(880).replace("[valturn]",String(this.battleDebuff[_loc1_].duration))));
                        break;
                     case BattleData.EFFECT_HIDDEN_MIST:
                        this.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(2049) + " (" + String(this.battleDebuff[_loc1_].duration) + ")");
                        break;
                     case BattleData.EFFECT_DARKNESS:
                        this.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(1088) + " (" + String(this.battleDebuff[_loc1_].duration) + ")");
                        break;
                     case BattleData.SKILL_236:
                        this.showOverheadNumber(Timeline.WORD,String(Central.main.langLib.get(799) + "(" + battleDebuff[_loc1_].duration + ")"));
                        break;
                     case BattleData.SKILL_304:
                        this.showOverheadNumber(Timeline.WORD,String(Central.main.langLib.get(1359) + "(" + battleDebuff[_loc1_].duration + ")"));
                        break;
                     case BattleData.EFFECT_REDUCE_PURIFY_CHANCE:
                        this.showOverheadNumber(Timeline.WORD,String(Central.main.langLib.get(1361) + "(" + battleDebuff[_loc1_].duration + ")"));
                        break;
                     case BattleData.EFFECT_BUFF_NEGATE:
                        this.showOverheadNumber(Timeline.WORD,String(Central.main.langLib.get(2035) + "(" + battleDebuff[_loc1_].duration + ")"));
                        break;
                     case BattleData.SKILL_253:
                        this.showOverheadNumber(Timeline.WORD,String(Central.main.langLib.get(1361) + "(" + battleDebuff[_loc1_].duration + ")"));
                        break;
                     case BattleData.SKILL_270:
                        this.showOverheadNumber(Timeline.WORD,String(Central.main.langLib.get(1364) + "(" + battleDebuff[_loc1_].duration + ")"));
                        break;
                     case BattleData.SKILL_342:
                        this.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(1361) + "(" + battleDebuff[_loc1_].duration + ")");
                        this.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(670) + "(" + battleDebuff[_loc1_].duration + ")");
                        this.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(305) + "(" + battleDebuff[_loc1_].duration + ")");
                        break;
                     case BattleData.EFFECT_SLEEP:
                        this.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(280) + "(" + battleDebuff[_loc1_].duration + ")");
                        break;
                     case BattleData.EFFECT_REDUCE_AGILITY:
                        this.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(2001)[0] + "(" + battleDebuff[_loc1_].duration + ")");
                        break;
                     case BattleData.EFFECT_WPNEFT_DISABLE:
                        this.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(2047) + "(" + battleDebuff[_loc1_].duration + ")");
                        break;
                     case SenjutsuData.EFFECT_SS_MAX_CP_CHANGE:
                        this.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(2001)[1] + "(" + battleDebuff[_loc1_].duration + ")");
                        break;
                     case SenjutsuData.EFFECT_SS_MAX_CP_CHANGE_EXTRA:
                        this.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(2001)[1] + "Extra " + "(" + battleDebuff[_loc1_].duration + ")");
                        break;
                     case BattleData.EFFECT_FEAR:
                        this.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(304) + "(" + battleDebuff[_loc1_].duration + ")");
                        break;
                     case BattleData.EFFECT_INTERNAL_INJURY_FEAR_WEAKEN:
                     case BattleData.EFFECT_FEAR_WEAKEN:
                     case BattleData.EFFECT_PET_FEAR_WEAKEN:
                        this.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(305) + "(" + battleDebuff[_loc1_].duration + ")");
                        break;
                     case BattleData.EFFECT_MERIDIANS_SEAL:
                        this.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(527) + "(" + battleDebuff[_loc1_].duration + ")");
                        break;
                     case BattleData.EFFECT_PARALYZE:
                        this.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(2050) + "(" + battleDebuff[_loc1_].duration + ")");
                        break;
                     case BattleData.EFFECT_BUNDLE:
                     case BattleData.SKILL_377:
                        this.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(325) + "(" + battleDebuff[_loc1_].duration + ")");
                        break;
                     case BattleData.EFFECT_RESTRICT_CHARGE:
                        this.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(754) + "(" + battleDebuff[_loc1_].duration + ")");
                        break;
                     case BattleData.EFFECT_REDUCE_CP_DAMAGE:
                     case BattleData.SKILL_359:
                        this.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(305) + "(" + battleDebuff[_loc1_].duration + ")");
                        break;
                     case BattleData.EFFECT_CLEARBUFF_DAMAGEREDUCTION:
                        this.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(801));
                        break;
                     case BattleData.EFFECT_LIGHTING_BUNDLE:
                     case BattleData.EFFECT_LIGHTING_BUNDLE_2:
                     case BattleData.EFFECT_LIGHTING_BUNDLE_3:
                     case BattleData.EFFECT_LIGHTING_BUNDLE_4:
                        this.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(615) + "(" + battleDebuff[_loc1_].duration + ")");
                        break;
                     case BattleData.SKILL_285:
                        this.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(1355));
                        this.syncCoolDown();
                        break;
                     case BattleData.EFFECT_CUBE_ILLUSION:
                        this.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(673));
                        break;
                     case BattleData.EFFECT_CLEARBUFF_DODGEREDUCTION:
                        this.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(799));
                        break;
                     case BattleData.EFFECT_DAMAGE_DELAY_INJURY:
                        this.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(648));
                        break;
                     case BattleData.EFFECT_TRANSFORM:
                        this.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(2003) + "(" + battleDebuff[_loc1_].duration + ")");
                        break;
                     case SenjutsuData.EFFECT_SS_WEAPON_ONLY:
                        this.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(2010) + "(" + battleDebuff[_loc1_].duration + ")");
                        break;
                     case BattleData.EFFECT_REDUCE_CP_MAX:
                        this.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(2012) + "(" + battleDebuff[_loc1_].duration + ")");
                        break;
                     case BattleData.EFFECT_ACCUM_BLEEDING:
                        this.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(2017) + "(" + battleDebuff[_loc1_].amount + "%)");
                        break;
                     case BattleData.EFFECT_CP_BLEEDING:
                        this.showOverheadNumber(Timeline.WORD,"CP流失" + "(" + battleDebuff[_loc1_].duration + ")");
                        break;
                     case BattleData.EFFECT_AGI_REDUCTION:
                        this.showOverheadNumber(Timeline.WORD,"AGI減少" + "(" + battleDebuff[_loc1_].duration + ")");
                        break;
                     case BattleData.EFFECT_CP_RESTORE_LOCK:
                        this.showOverheadNumber(Timeline.WORD,"CP回復鎖定" + "(" + battleDebuff[_loc1_].duration + ")");
                        break;
                     case BattleData.EFFECT_FLAME:
                        this.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(2024) + "(" + battleDebuff[_loc1_].duration + ")");
                  }
                  _loc5_ = [];
                  _loc4_ = "";
                  _loc5_ = _loc1_.split(".");
                  if(_loc5_)
                  {
                     _loc4_ = _loc5_[0];
                  }
                  if(Battle.type == Battle.TYPE_NETWORK)
                  {
                     if(_loc5_.indexOf("skill1005") >= 0)
                     {
                        _loc4_ = "";
                     }
                  }
                  _loc12_ = 0;
                  _loc13_ = "";
                  _loc14_ = 0;
                  if(this.battleDebuff[_loc1_].amount)
                  {
                     _loc12_ = Number(this.battleDebuff[_loc1_].amount);
                  }
                  if(this.battleDebuff[_loc1_].requirement)
                  {
                     _loc13_ = this.battleDebuff[_loc1_].requirement;
                  }
                  if(this.battleDebuff[_loc1_].duration)
                  {
                     _loc14_ = Number(this.battleDebuff[_loc1_].duration);
                  }
                  _loc10_ = "";
                  _loc11_ = "";
                  _loc4_ = "";
                  _loc5_ = [];
                  _loc5_ = _loc1_.split(".");
                  if((Boolean(_loc5_)) && _loc5_.length > 0)
                  {
                     _loc4_ = _loc5_[0];
                  }
                  if(Battle.type == Battle.TYPE_NETWORK)
                  {
                     if(_loc5_.indexOf("skill1005") >= 0)
                     {
                        _loc4_ = "";
                     }
                  }
                  if(Boolean(_loc4_) && Boolean(_loc4_ != "") && _loc14_ <= BloodlineData.PASSIVE_DEBUFF_IDENTIFIER)
                  {
                     if(_loc12_ > 0)
                     {
                        _loc11_ = "+";
                     }
                     switch(_loc4_)
                     {
                        case BloodlineData.EFFECT_ACCURATE:
                           if(_loc12_ > 0)
                           {
                              _loc10_ = Central.main.langLib.get(735);
                           }
                           else
                           {
                              _loc10_ = Central.main.langLib.get(287);
                           }
                           break;
                        case BloodlineData.EFFECT_CAPTURE:
                           _loc10_ = Central.main.langLib.get(736);
                           break;
                        case BloodlineData.EFFECT_CLEAR_BUFF:
                           _loc10_ = Central.main.langLib.get(737);
                           break;
                        case BloodlineData.EFFECT_CONVERT_DMG_CP:
                           _loc10_ = Central.main.langLib.get(738);
                           break;
                        case BloodlineData.EFFECT_CONVERT_DMG_HP:
                           _loc10_ = Central.main.langLib.get(739);
                           break;
                        case BloodlineData.EFFECT_CRITICAL:
                           if(_loc12_ > 0)
                           {
                              _loc10_ = Central.main.langLib.get(740);
                           }
                           else
                           {
                              _loc10_ = Central.main.langLib.get(670);
                           }
                           break;
                        case BloodlineData.EFFECT_DODGE:
                           if(_loc12_ > 0)
                           {
                              _loc10_ = Central.main.langLib.get(741);
                           }
                           else
                           {
                              _loc10_ = Central.main.langLib.get(799);
                           }
                           break;
                        case BloodlineData.EFFECT_MAX_CP:
                           _loc10_ = "";
                           break;
                        case BloodlineData.EFFECT_MAX_CP_RECOVER:
                           break;
                        case BloodlineData.EFFECT_MAX_HP:
                           _loc10_ = "";
                           break;
                        case BloodlineData.EFFECT_MERIDIAN_BLOCK:
                           _loc10_ = Central.main.langLib.get(743);
                           break;
                        case BloodlineData.EFFECT_MODIFY_COOLDOWN:
                           if(_loc12_ > 0)
                           {
                              _loc10_ = Central.main.langLib.get(744);
                           }
                           else
                           {
                              _loc10_ = Central.main.langLib.get(800);
                           }
                           break;
                        case BloodlineData.EFFECT_MODIFY_DAMAGE_ALL:
                           if(_loc12_ > 0)
                           {
                              _loc10_ = Central.main.langLib.get(745);
                           }
                           else
                           {
                              _loc10_ = Central.main.langLib.get(801);
                           }
                           break;
                        case BloodlineData.EFFECT_MODIFY_DAMAGE_BYTYPE:
                           _loc13_ = String(_loc13_).replace("fire",Central.main.langLib.titleTxt(TitleData.FIRE));
                           _loc13_ = String(_loc13_).replace("wind",Central.main.langLib.titleTxt(TitleData.WIND));
                           _loc13_ = String(_loc13_).replace("lightning",Central.main.langLib.titleTxt(TitleData.THUNDER));
                           _loc13_ = String(_loc13_).replace("water",Central.main.langLib.titleTxt(TitleData.WATER));
                           _loc13_ = String(_loc13_).replace("earth",Central.main.langLib.titleTxt(TitleData.EARTH));
                           _loc13_ = String(_loc13_).replace("taijutsu",Central.main.langLib.btnTxt(ButtonData.TAIJUTSU));
                           _loc13_ = String(_loc13_).replace("genjutsu",Central.main.langLib.btnTxt(ButtonData.GENJUTSU));
                           _loc15_ = null;
                           _loc15_ = _loc13_.split(",");
                           if(_loc12_ > 0)
                           {
                              _loc10_ = Central.main.langLib.get(746);
                           }
                           else
                           {
                              _loc10_ = Central.main.langLib.get(801);
                           }
                           break;
                        case BloodlineData.EFFECT_MODIFY_DAMAGE_CRITICAL:
                           if(_loc12_ > 0)
                           {
                              _loc10_ = Central.main.langLib.get(747);
                           }
                           else
                           {
                              _loc10_ = Central.main.langLib.get(688);
                           }
                           break;
                        case BloodlineData.EFFECT_MODIFY_DEFENCE_ALL:
                           if(_loc12_ > 0)
                           {
                              _loc10_ = Central.main.langLib.get(748);
                           }
                           else
                           {
                              _loc10_ = Central.main.langLib.get(802);
                           }
                           break;
                        case BloodlineData.EFFECT_MODIFY_DEFENCE_BYTYPE:
                           _loc13_ = String(_loc13_).replace("fire",Central.main.langLib.titleTxt(TitleData.FIRE));
                           _loc13_ = String(_loc13_).replace("wind",Central.main.langLib.titleTxt(TitleData.WIND));
                           _loc13_ = String(_loc13_).replace("lightning",Central.main.langLib.titleTxt(TitleData.THUNDER));
                           _loc13_ = String(_loc13_).replace("water",Central.main.langLib.titleTxt(TitleData.WATER));
                           _loc13_ = String(_loc13_).replace("earth",Central.main.langLib.titleTxt(TitleData.EARTH));
                           _loc13_ = String(_loc13_).replace("taijutsu",Central.main.langLib.btnTxt(ButtonData.TAIJUTSU));
                           _loc13_ = String(_loc13_).replace("genjutsu",Central.main.langLib.btnTxt(ButtonData.GENJUTSU));
                           _loc15_ = null;
                           _loc15_ = _loc13_.split(",");
                           if(_loc12_ > 0)
                           {
                              _loc10_ = Central.main.langLib.get(748);
                           }
                           else
                           {
                              _loc10_ = Central.main.langLib.get(803);
                           }
                           break;
                        case BloodlineData.EFFECT_REACTIVE_DEBUFF_ATTACKER:
                           _loc10_ = Central.main.langLib.get(749);
                           break;
                        case BloodlineData.EFFECT_REACTIVE_DEBUFF_DEFENDER:
                           _loc10_ = Central.main.langLib.get(750);
                           break;
                        case BloodlineData.EFFECT_REFLECT_DAMAGE:
                           _loc10_ = Central.main.langLib.get(751);
                           break;
                        case BloodlineData.EFFECT_REFLECT_GENJUTSU:
                           _loc10_ = Central.main.langLib.get(752);
                           break;
                        case BloodlineData.EFFECT_STUN:
                           _loc10_ = "";
                           break;
                        case BloodlineData.EFFECT_UPDATE_CP:
                           _loc10_ = "";
                           break;
                        case BloodlineData.EFFECT_UPDATE_HP:
                           _loc10_ = "";
                           if(_loc5_[1] == "skill1019")
                           {
                              _loc10_ = "";
                           }
                           break;
                        case BloodlineData.EFFECT_RESTRICT_CHARGE:
                           _loc10_ = Central.main.langLib.get(754);
                           break;
                        case BloodlineData.EFFECT_EXTRA_CHARGE_RECOVER:
                           if(_loc12_ > 0)
                           {
                              _loc10_ = Central.main.langLib.get(755);
                           }
                           else
                           {
                              _loc10_ = Central.main.langLib.get(804);
                           }
                           break;
                        case BloodlineData.EFFECT_RESIST_DEBUFF:
                           _loc10_ = Central.main.langLib.get(756);
                           break;
                        case BloodlineData.EFFECT_DRAIN_HP:
                           _loc10_ = Central.main.langLib.get(757);
                           break;
                        case BloodlineData.EFFECT_MODIFY_TAIJUTSU_SELFHIT:
                           if(_loc12_ > 0)
                           {
                              _loc10_ = Central.main.langLib.get(758);
                           }
                           else
                           {
                              _loc10_ = Central.main.langLib.get(806);
                           }
                           break;
                        case BloodlineData.EFFECT_INTERNAL_INJURY:
                           _loc10_ = Central.main.langLib.get(648);
                           break;
                        case BloodlineData.EFFECT_RESURRECTION:
                           _loc10_ = Central.main.langLib.get(759);
                           break;
                        case BloodlineData.EFFECT_COPY_JUTSU:
                           _loc10_ = Central.main.langLib.get(760);
                           break;
                        case BloodlineData.EFFECT_TITAN:
                           _loc10_ = Central.main.langLib.get(761);
                           break;
                        case BloodlineData.EFFECT_EXTRA_CP_USE:
                           if(_loc12_ > 0)
                           {
                              _loc10_ = Central.main.langLib.get(805);
                           }
                           else
                           {
                              _loc10_ = Central.main.langLib.get(762);
                           }
                           break;
                        case BloodlineData.EFFECT_EXTREME:
                           _loc10_ = Central.main.langLib.get(763);
                           break;
                        case BloodlineData.EFFECT_HALLUCINATIONS:
                           _loc10_ = Central.main.langLib.get(734);
                     }
                     if(_loc10_ != "")
                     {
                        _loc10_ = _loc10_ + "(" + String(_loc14_) + ")";
                        if(_loc15_)
                        {
                           _loc16_ = 0;
                           while(_loc16_ < _loc15_.length)
                           {
                              this.showOverheadNumber(Timeline.WORD,_loc15_[_loc16_] + " " + _loc10_);
                              _loc16_++;
                           }
                           _loc15_ = null;
                        }
                        else
                        {
                           this.showOverheadNumber(Timeline.WORD,_loc10_);
                        }
                     }
                  }
               }
            }
         }
      }
      
      override public function setBattleBuff(param1:Object) : Boolean
      {
         var _loc2_:Boolean = false;
         if(this.isBattleBuffActive(param1.type) && !param1.duration >= this.getBattleBuff()[param1.type].duration)
         {
            return Boolean(super.setBattleBuff(param1));
         }
         switch(param1.type)
         {
            case BattleData.EFFECT_CRITICAL_DAMAGE_BONUS_WEAPON:
               this.showOverheadNumber(Timeline.WORD,String(Central.main.langLib.get(691)).replace("[valamt]",String(param1.amount)));
               break;
            case BattleData.EFFECT_ACCURATE_WEAPON:
            case BattleData.EFFECT_ADD_DODGERE_ABOVE_HP:
            case BattleData.EFFECT_ADD_DODGERE_BELOW_HP:
               this.showOverheadNumber(Timeline.WORD,String(Central.main.langLib.get(685)).replace("[valamt]",String(param1.amount)));
               break;
            case BattleData.EFFECT_EXPANSION:
               this.showOverheadNumber(Timeline.WORD,String(Central.main.langLib.get(2053)).replace("[valamt]",String(param1.amount)));
               break;
            case BattleData.EFFECT_CRITICAL_CHANCE_BONUS_WEAPON:
               this.showOverheadNumber(Timeline.WORD,String(Central.main.langLib.get(686)).replace("[valamt]",String(param1.amount)));
               break;
            case BattleData.EFFECT_DAMAGE_BONUS_WEAPON_FIX_NUM:
               this.showOverheadNumber(Timeline.WORD,String(Central.main.langLib.get(294)) + String(param1.amount));
               break;
            case BattleData.EFFECT_DAMAGE_REDUCTIONA:
            case BattleData.EFFECT_DAMAGE_REDUCTION:
               this.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(322));
               break;
            case BattleData.EFFECT_COMBUSTION:
               this.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(357));
               break;
            case BattleData.EFFECT_POISON:
               this.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(321));
               break;
            case BattleData.EFFECT_STUN:
               this.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(281));
               break;
            case BattleData.EFFECT_REDUCE_AGILITY:
               this.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(2001)[0]);
               break;
            case SenjutsuData.EFFECT_SS_MAX_CP_CHANGE:
               this.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(2001)[1]);
               break;
            case SenjutsuData.EFFECT_SS_MAX_CP_CHANGE_EXTRA:
               this.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(2001)[1] + "Extra");
               Out.debug("CBattle","rex show word < CharacterBattle - setBattleRound()");
               break;
            case BattleData.EFFECT_PET_BURN:
               this.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(288) + " (" + String(param1.amount) + "%)");
               break;
            case BattleData.EFFECT_PET_FEAR_WEAKEN:
               this.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(305));
               break;
            case BattleData.EFFECT_PET_FREEZE:
               this.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(820));
               break;
            case BattleData.EFFECT_PET_WEAKEN:
               this.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(801));
               break;
            case BattleData.EFFECT_DISMANTLE:
               this.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(816).replace("[valturn]",String(param1.duration - 1)));
               break;
            case BattleData.EFFECT_CUBE_ILLUSION:
               this.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(673));
               break;
            case BattleData.EFFECT_SILVER_CHAIN_BUNDLE:
               if(int(param1.amount) == 1)
               {
                  this.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(801));
               }
               if(int(param1.amount) == 2)
               {
                  this.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(676));
               }
               break;
            case BattleData.EFFECT_PUMPKIN_POWER:
               this.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(1603) + " " + param1.amount + "%");
               break;
            case BattleData.EFFECT_RECEIVED_DMG_PARRY:
               this.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(2006));
               break;
            case BattleData.EFFECT_SUSANOOA:
               this.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(2044));
               break;
            case BattleData.EFFECT_SUSANOOB:
               this.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(2044));
               break;
            case BattleData.EFFECT_SUSANOO:
               this.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(2044));
               break;
            case BattleData.EFFECT_DAMAGE_BONUSA:
            case BattleData.EFFECT_DAMAGE_BONUS:
               this.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(330));
               break;
            case BattleData.EFFECT_CRITICAL_DMG_BONUS:
               this.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(747));
               break;
            case BattleData.EFFECT_COMPLETE_GUARD:
               this.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(636));
               break;
            case BattleData.EFFECT_PET_ATTENTION:
               this.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(807));
               break;
            case BattleData.EFFECT_PET_DAMAGE_BONUS:
               this.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(330));
               break;
            case BattleData.EFFECT_PET_DEBUFF_RESIST:
               this.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(822));
               break;
            case BattleData.EFFECT_MANA_SHIELD:
               this.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(594));
         }
         return Boolean(super.setBattleBuff(param1));
      }
      
      override public function setBattleDebuff(param1:Object) : Boolean
      {
         var _loc2_:Boolean = false;
         if(this.isBattleDebuffActive(param1.type) && !param1.duration >= this.getBattleDebuff()[param1.type].duration)
         {
            return Boolean(super.setBattleDebuff(param1));
         }
         switch(param1.type)
         {
            case BattleData.EFFECT_CHAOS:
               if(param1.duration > 0)
               {
                  if(Battle.getShowChaos())
                  {
                     Battle.reverseShowChaosChecking();
                     this.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(734));
                  }
               }
               break;
            case BattleData.EFFECT_RESTRICT_CHARGE:
               if(param1.duration > 0)
               {
                  this.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(754));
               }
               break;
            case BattleData.EFFECT_SLEEP:
               if(param1.duration > 0)
               {
                  this.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(280));
               }
               break;
            case BattleData.EFFECT_TRANSFORM:
               if(param1.duration > 0)
               {
                  this.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(2003));
               }
               break;
            case BattleData.EFFECT_BLEEDING:
               break;
            case BattleData.EFFECT_ACCUM_BLEEDING:
               this.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(2017));
               break;
            case BattleData.EFFECT_BURNING:
               break;
            case BattleData.EFFECT_CP_BLEEDING:
               this.showOverheadNumber(Timeline.WORD,"CP流失(" + param1.amount + "%)");
               break;
            case BattleData.EFFECT_AGI_REDUCTION:
               this.showOverheadNumber(Timeline.WORD,"AGI減少");
               break;
            case BattleData.EFFECT_CP_RESTORE_LOCK:
               this.showOverheadNumber(Timeline.WORD,"CP回復鎖定");
         }
         return Boolean(super.setBattleDebuff(param1));
      }
      
      private function showWord_nextBattleRound(param1:String, param2:String) : *
      {
         var _loc6_:* = undefined;
         if(param2 == "")
         {
            return;
         }
         var _loc3_:Object = Central.main.WEAPON_DATA.find(this.getWeapon());
         var _loc4_:* = _loc3_.effect;
         var _loc5_:int = 0;
         for(_loc6_ in _loc4_)
         {
            if(_loc4_[_loc6_].type == param1)
            {
               _loc5_ = int(_loc4_[_loc6_].duration);
               break;
            }
         }
         if(_loc5_ >= 999)
         {
            this.showOverheadNumber(Timeline.WORD,param2);
         }
         else
         {
            this.showOverheadNumber(Timeline.WORD,param2 + " (" + _loc5_ + ")");
         }
      }
      
      private function showWord_setBuff(param1:String, param2:String) : *
      {
         if(param2 == "")
         {
            return;
         }
         this.showOverheadNumber(Timeline.WORD,param2);
      }
      
      private function showWord_setDeuff(param1:String, param2:String) : *
      {
         if(param2 == "")
         {
            return;
         }
         this.showOverheadNumber(Timeline.WORD,param2);
      }
   }
}

