package ninjasaga.data
{
   import ninjasaga.Central;
   
   public final class EffectLangData
   {
      
      public function EffectLangData()
      {
         super();
      }
      
      public static function getEffectNameByType(param1:String) : String
      {
         var _loc3_:String = null;
         var _loc4_:Array = null;
         var _loc5_:String = null;
         var _loc6_:Array = null;
         var _loc2_:String = "";
         if(String(param1).indexOf("bl_") == 0)
         {
            if(String(param1).indexOf(".") > 0)
            {
               _loc4_ = String(param1).split(".");
               _loc3_ = _loc4_[0];
            }
            else
            {
               _loc3_ = param1;
            }
            switch(_loc3_)
            {
               case BloodlineData.EFFECT_COPY_JUTSU:
                  _loc2_ = Central.main.langLib.get(760);
                  break;
               case BloodlineData.EFFECT_RESURRECTION:
                  _loc2_ = Central.main.langLib.get(759);
                  break;
               case BloodlineData.EFFECT_REFLECT_GENJUTSU:
                  _loc2_ = Central.main.langLib.get(752);
                  break;
               case BloodlineData.EFFECT_CAPTURE:
                  _loc2_ = Central.main.langLib.get(736);
                  break;
               case BloodlineData.EFFECT_CLEAR_BUFF:
                  _loc2_ = Central.main.langLib.get(877);
                  break;
               case BloodlineData.EFFECT_CONVERT_DMG_HP:
                  _loc2_ = Central.main.langLib.get(739);
                  break;
               case BloodlineData.EFFECT_CONVERT_DMG_CP:
                  _loc2_ = Central.main.langLib.get(738);
                  break;
               case BloodlineData.EFFECT_CRITICAL:
                  _loc2_ = Central.main.langLib.get(740);
                  break;
               case BloodlineData.EFFECT_DODGE:
                  _loc2_ = Central.main.langLib.get(741);
                  break;
               case BloodlineData.EFFECT_ACCURATE:
                  _loc2_ = Central.main.langLib.get(735);
                  break;
               case BloodlineData.EFFECT_MAX_CP:
                  _loc2_ = "";
                  break;
               case BloodlineData.EFFECT_MAX_CP_RECOVER:
                  _loc2_ = Central.main.langLib.get(742);
                  break;
               case BloodlineData.EFFECT_MAX_HP:
                  _loc2_ = "";
                  break;
               case BloodlineData.EFFECT_MERIDIAN_BLOCK:
                  _loc2_ = Central.main.langLib.get(743);
                  break;
               case BloodlineData.EFFECT_MODIFY_COOLDOWN:
                  _loc2_ = Central.main.langLib.get(744);
                  break;
               case BloodlineData.EFFECT_MODIFY_DAMAGE_ALL:
                  _loc2_ = Central.main.langLib.get(745);
                  break;
               case BloodlineData.EFFECT_MODIFY_DAMAGE_BYTYPE:
                  _loc2_ = Central.main.langLib.get(746);
                  break;
               case BloodlineData.EFFECT_MODIFY_DAMAGE_CRITICAL:
                  _loc2_ = Central.main.langLib.get(747);
                  break;
               case BloodlineData.EFFECT_MODIFY_DEFENCE_ALL:
                  _loc2_ = Central.main.langLib.get(748);
                  break;
               case BloodlineData.EFFECT_MODIFY_DEFENCE_BYTYPE:
                  _loc2_ = Central.main.langLib.get(748);
                  break;
               case BloodlineData.EFFECT_REFLECT_DAMAGE:
                  _loc2_ = Central.main.langLib.get(751);
                  break;
               case BloodlineData.EFFECT_SPEED:
                  _loc2_ = "EFFECT101";
                  break;
               case BloodlineData.EFFECT_STUN:
                  _loc2_ = Central.main.langLib.get(281);
                  break;
               case BloodlineData.EFFECT_UPDATE_CP:
                  _loc2_ = "";
                  break;
               case BloodlineData.EFFECT_UPDATE_HP:
                  _loc2_ = Central.main.langLib.get(1363);
                  break;
               case BloodlineData.EFFECT_REACTIVE_DEBUFF_ATTACKER:
                  _loc2_ = Central.main.langLib.get(749);
                  break;
               case BloodlineData.EFFECT_REACTIVE_DEBUFF_DEFENDER:
                  _loc2_ = Central.main.langLib.get(750);
                  break;
               case BloodlineData.EFFECT_BUNDLE:
                  _loc2_ = Central.main.langLib.get(325);
                  break;
               case BloodlineData.EFFECT_RESTRICT_CHARGE:
                  _loc2_ = Central.main.langLib.get(754);
                  break;
               case BloodlineData.EFFECT_EXTRA_CHARGE_RECOVER:
                  _loc2_ = Central.main.langLib.get(755);
                  break;
               case BloodlineData.EFFECT_RESIST_DEBUFF:
                  _loc2_ = Central.main.langLib.get(756);
                  break;
               case BloodlineData.EFFECT_DRAIN_HP:
                  _loc2_ = Central.main.langLib.get(1363);
                  break;
               case BloodlineData.EFFECT_MODIFY_TAIJUTSU_SELFHIT:
                  _loc2_ = Central.main.langLib.get(758);
                  break;
               case BloodlineData.EFFECT_INTERNAL_INJURY:
                  _loc2_ = Central.main.langLib.get(648);
                  break;
               case BloodlineData.EFFECT_TITAN:
                  _loc2_ = Central.main.langLib.get(761);
                  break;
               case BloodlineData.EFFECT_EXTRA_CP_USE:
                  _loc2_ = Central.main.langLib.get(805);
                  break;
               case BloodlineData.EFFECT_EXTREME:
                  _loc2_ = Central.main.langLib.get(763);
                  break;
               case BloodlineData.EFFECT_HALLUCINATIONS:
                  _loc2_ = Central.main.langLib.get(734);
                  break;
               case BloodlineData.EFFECT_UPDATE_HP_CP:
                  _loc2_ = Central.main.langLib.get(1363);
                  break;
               case BloodlineData.EFFECT_PET_FREEZE:
                  _loc2_ = Central.main.langLib.get(820);
                  break;
               case BloodlineData.EFFECT_REDUCE_CP:
                  _loc2_ = Central.main.langLib.get(1657);
                  break;
               case BloodlineData.EFFECT_PASSIVE_STUN:
                  _loc2_ = Central.main.langLib.get(2062);
                  break;
               case BloodlineData.EFFECT_CPDMG_STUN:
                  _loc2_ = Central.main.langLib.get(2062);
                  break;
               case BloodlineData.EFFECT_CPDMG:
                  _loc2_ = Central.main.langLib.get(2061);
                  break;
               default:
                  _loc2_ = "";
            }
         }
         else if(String(param1).indexOf("senjutsu_") == 0)
         {
            if(String(param1).indexOf(".") > 0)
            {
               _loc6_ = String(param1).split(".");
               _loc5_ = _loc6_[0];
            }
            else
            {
               _loc5_ = param1;
            }
            switch(_loc5_)
            {
               case SenjutsuData.EFFECT_SENNIN_MODE:
                  _loc2_ = Central.main.langLib.get(1862)[0];
                  break;
               case SenjutsuData.EFFECT_SS_MAX_HP:
                  _loc2_ = "";
                  break;
               case SenjutsuData.EFFECT_SS_MAX_CP_CHANGE:
                  _loc2_ = "";
                  break;
               case SenjutsuData.EFFECT_SS_MAX_CP_CHANGE_EXTRA:
                  _loc2_ = "";
                  break;
               default:
                  _loc2_ = "";
            }
         }
         else
         {
            switch(param1)
            {
               case BattleData.EFFECT_DODGE_BONUS_ALL_FRIENDLY:
               case BattleData.EFFECT_DODGE_BONUS:
               case BattleData.EFFECT_ALL_CP_DODGE_BONUS:
               case BattleData.EFFECT_PET_DODGE_BONUS:
                  _loc2_ = Central.main.langLib.get(306);
                  break;
               case BattleData.EFFECT_CRITICAL_CHANCE_BONUS:
                  _loc2_ = Central.main.langLib.get(292);
                  break;
               case BattleData.EFFECT_REGENERATE_HP:
                  _loc2_ = Central.main.langLib.get(490);
                  break;
               case BattleData.EFFECT_SOUL_CHAINS_BUNDLE:
                  _loc2_ = Central.main.langLib.get(329);
                  break;
               case BattleData.EFFECT_STUN:
                  _loc2_ = Central.main.langLib.get(281);
                  break;
               case BattleData.EFFECT_REDUCE_AGILITY:
                  _loc2_ = Central.main.langLib.get(2001)[0];
                  break;
               case BattleData.EFFECT_SLEEP:
                  _loc2_ = Central.main.langLib.get(280);
                  break;
               case BattleData.EFFECT_INTERNAL_INJURY_FEAR_WEAKEN:
               case BattleData.EFFECT_FEAR_WEAKEN:
               case BattleData.EFFECT_PET_FEAR_WEAKEN:
                  _loc2_ = Central.main.langLib.get(305);
                  break;
               case BattleData.EFFECT_BUNDLE:
               case BattleData.SKILL_377:
                  _loc2_ = Central.main.langLib.get(325);
                  break;
               case BattleData.EFFECT_HEAL:
                  _loc2_ = "";
                  break;
               case BattleData.EFFECT_RESTORE_CP:
                  _loc2_ = Central.main.langLib.get(350);
                  break;
               case BattleData.EFFECT_COOLDOWN_REDUCTION:
                  _loc2_ = Central.main.langLib.get(598);
                  break;
               case BattleData.EFFECT_PET_BURN:
                  _loc2_ = Central.main.langLib.get(288);
                  break;
               case BattleData.EFFECT_BLIND:
               case BattleData.EFFECT_ALL_CP_BLIND:
                  _loc2_ = Central.main.langLib.get(287);
                  break;
               case BattleData.EFFECT_DODGE_REDUCTION:
                  _loc2_ = String(Central.main.langLib.get(799));
                  break;
               case BattleData.EFFECT_CRITICAL_CHANCE_BONUS:
                  _loc2_ = Central.main.langLib.get(292);
                  break;
               case BattleData.EFFECT_HAMSTRING:
                  _loc2_ = Central.main.langLib.get(688);
                  break;
               case BattleData.EFFECT_COLLIDING_WAVE:
                  _loc2_ = Central.main.langLib.get(619);
                  break;
               case BattleData.EFFECT_POISON:
                  _loc2_ = Central.main.langLib.get(321);
                  break;
               case BattleData.EFFECT_FIRE_ENERGY_EXCITATION:
               case BattleData.EFFECT_EXCITATION_CP:
               case BattleData.EFFECT_EXCITATION_CHARGE:
                  _loc2_ = Central.main.langLib.get(613);
                  break;
               case BattleData.EFFECT_INTERNAL_INJURY:
                  _loc2_ = Central.main.langLib.get(648);
                  break;
               case BattleData.EFFECT_DAMAGE_DELAY_INJURY:
                  _loc2_ = Central.main.langLib.get(648);
                  break;
               case BattleData.EFFECT_DAMAGE_REDUCTION:
                  _loc2_ = Central.main.langLib.get(322);
                  break;
               case BattleData.EFFECT_DAMAGE_BONUS:
                  _loc2_ = Central.main.langLib.get(330);
                  break;
               case BattleData.EFFECT_AGILITY_BONUS:
                  _loc2_ = Central.main.langLib.get(282);
                  break;
               case BattleData.EFFECT_DODGE_BONUS:
                  _loc2_ = Central.main.langLib.get(306);
                  break;
               case BattleData.EFFECT_REGENERATE_CHAKRA:
                  _loc2_ = Central.main.langLib.get(324);
                  break;
               case BattleData.EFFECT_COMBUSTION:
                  _loc2_ = Central.main.langLib.get(363);
                  break;
               case BattleData.EFFECT_PURIFY:
                  _loc2_ = Central.main.langLib.get(356);
                  break;
               case BattleData.EFFECT_REACTIVE_FORCE:
                  _loc2_ = Central.main.langLib.get(533);
                  break;
               case BattleData.EFFECT_BLEEDING:
                  _loc2_ = Central.main.langLib.get(286);
                  break;
               case BattleData.EFFECT_BURN:
                  _loc2_ = Central.main.langLib.get(288);
                  break;
               case BattleData.EFFECT_JUTSU_POISON:
                  _loc2_ = Central.main.langLib.get(321);
                  break;
               case BattleData.EFFECT_DRAIN_CHAKRA:
                  _loc2_ = Central.main.langLib.get(349);
                  break;
               case BattleData.EFFECT_DRAIN_HP:
                  _loc2_ = Central.main.langLib.get(757);
                  break;
               case BattleData.EFFECT_POISON:
                  _loc2_ = Central.main.langLib.get(321);
                  break;
               case BattleData.EFFECT_GATE_OPENING:
                  _loc2_ = Central.main.langLib.get(296);
                  break;
               case BattleData.EFFECT_FEAR:
                  _loc2_ = Central.main.langLib.get(304);
                  break;
               case BattleData.EFFECT_PARASITE:
                  _loc2_ = Central.main.langLib.get(319);
                  break;
               case BattleData.EFFECT_CHAKRA_SUCKER:
                  _loc2_ = Central.main.langLib.get(349);
                  break;
               case BattleData.EFFECT_BURNING:
                  _loc2_ = Central.main.langLib.get(357);
                  break;
               case BattleData.EFFECT_FEAR_WEAKEN:
                  _loc2_ = Central.main.langLib.get(305);
                  break;
               case BattleData.EFFECT_RESTORE_CP:
                  _loc2_ = "EFFECT2";
                  break;
               case BattleData.EFFECT_MERIDIANS_SEAL:
                  _loc2_ = Central.main.langLib.get(527);
                  break;
               case BattleData.EFFECT_PET_FEAR_WEAKEN:
                  _loc2_ = Central.main.langLib.get(305);
                  break;
               case BattleData.EFFECT_FRENZY:
                  _loc2_ = Central.main.langLib.get(834);
                  break;
               case BattleData.EFFECT_BURN_CP:
                  _loc2_ = "EFFECT3";
                  break;
               case BattleData.EFFECT_MANA_SHIELD:
                  _loc2_ = Central.main.langLib.get(594);
                  break;
               case BattleData.EFFECT_HEAL_OVER_TIME:
                  _loc2_ = Central.main.langLib.get(596);
                  break;
               case BattleData.EFFECT_COOLDOWN_REDUCTION:
                  _loc2_ = Central.main.langLib.get(598);
                  break;
               case BattleData.EFFECT_BERSERKER_MODE:
                  _loc2_ = Central.main.langLib.get(599);
                  break;
               case BattleData.EFFECT_THUNDERSTORM_MODE:
                  _loc2_ = Central.main.langLib.get(601);
                  break;
               case BattleData.EFFECT_WIND_PEACE_SINGLE:
                  _loc2_ = Central.main.langLib.get(611);
                  break;
               case BattleData.EFFECT_WIND_PEACE:
                  _loc2_ = Central.main.langLib.get(611);
                  break;
               case BattleData.EFFECT_WIND_PEACE_2:
                  _loc2_ = Central.main.langLib.get(611);
                  break;
               case BattleData.EFFECT_WIND_PEACE_3:
                  _loc2_ = Central.main.langLib.get(611);
                  break;
               case BattleData.EFFECT_WIND_PEACE_4:
                  _loc2_ = Central.main.langLib.get(611);
                  break;
               case BattleData.EFFECT_FIRE_ENERGY_EXCITATION:
                  _loc2_ = Central.main.langLib.get(613);
                  break;
               case BattleData.EFFECT_EXCITATION_CP:
                  _loc2_ = Central.main.langLib.get(613);
                  break;
               case BattleData.EFFECT_EXCITATION_CHARGE:
                  _loc2_ = Central.main.langLib.get(613);
                  break;
               case BattleData.EFFECT_LIGHTING_BUNDLE:
                  _loc2_ = Central.main.langLib.get(615);
                  break;
               case BattleData.EFFECT_LIGHTING_BUNDLE_2:
                  _loc2_ = Central.main.langLib.get(615);
                  break;
               case BattleData.EFFECT_LIGHTING_BUNDLE_3:
                  _loc2_ = Central.main.langLib.get(615);
                  break;
               case BattleData.EFFECT_LIGHTING_BUNDLE_4:
                  _loc2_ = Central.main.langLib.get(615);
                  break;
               case BattleData.EFFECT_AMONG_ROCKS:
                  _loc2_ = Central.main.langLib.get(617);
                  break;
               case BattleData.EFFECT_COLLIDING_WAVE:
                  _loc2_ = Central.main.langLib.get(619);
                  break;
               case BattleData.EFFECT_REDUCE_HP_CP:
                  _loc2_ = Central.main.langLib.get();
                  break;
               case BattleData.EFFECT_SERENE_MIND:
                  _loc2_ = Central.main.langLib.get(622);
                  break;
               case BattleData.EFFECT_CALM_TARGET:
                  _loc2_ = Central.main.langLib.get(737);
                  break;
               case BattleData.EFFECT_DARK_CURSE:
                  _loc2_ = Central.main.langLib.get(649);
                  break;
               case BattleData.EFFECT_GUARD:
                  _loc2_ = Central.main.langLib.get(636);
                  break;
               case BattleData.EFFECT_CUBE_ILLUSION:
                  _loc2_ = Central.main.langLib.get(673);
                  break;
               case BattleData.EFFECT_SILVER_CHAIN_BUNDLE:
                  _loc2_ = Central.main.langLib.get(676);
                  break;
               case BattleData.EFFECT_BLOOD_FEED:
                  _loc2_ = Central.main.langLib.get(638);
                  break;
               case BattleData.EFFECT_ACCURATE_WEAPON:
                  _loc2_ = Central.main.langLib.get(735);
                  break;
               case BattleData.EFFECT_CRITICAL_CHANCE_BONUS_WEAPON:
                  _loc2_ = "EFFECT4";
                  break;
               case BattleData.EFFECT_DAMAGE_BONUS_WEAPON:
                  _loc2_ = "EFFECT6";
                  break;
               case BattleData.EFFECT_CRITICAL_DAMAGE_BONUS_WEAPON:
                  _loc2_ = "EFFECT5";
                  break;
               case BattleData.EFFECT_BLOOD_DRINKER:
                  _loc2_ = Central.main.langLib.get(819);
                  break;
               case BattleData.EFFECT_REWIND:
                  _loc2_ = Central.main.langLib.get(800);
                  break;
               case BattleData.EFFECT_PET_DRAIN_HP:
                  _loc2_ = Central.main.langLib.get(878);
                  break;
               case BattleData.EFFECT_PET_DRAIN_CP:
                  _loc2_ = Central.main.langLib.get(349);
                  break;
               case BattleData.EFFECT_ADD_COOLDOWN:
                  _loc2_ = Central.main.langLib.get(744);
                  break;
               case BattleData.EFFECT_BLOODLUST_DEDICATION:
                  _loc2_ = Central.main.langLib.get(356);
                  break;
               case BattleData.EFFECT_REACTIVE_DEBUFF:
                  _loc2_ = Central.main.langLib.get(749);
                  break;
               case BattleData.EFFECT_PETRIFICATION:
                  _loc2_ = Central.main.langLib.get(954);
                  break;
               case BattleData.EFFECT_EXTRA_CP_RECOVER:
                  _loc2_ = Central.main.langLib.get(755);
                  break;
               case BattleData.EFFECT_DARKNESS:
                  _loc2_ = Central.main.langLib.get(1088);
                  break;
               case BattleData.EFFECT_PET_ATTENTION:
                  _loc2_ = Central.main.langLib.get(807);
                  break;
               case BattleData.EFFECT_PET_DAMAGE_BONUS:
                  _loc2_ = Central.main.langLib.get(330);
                  break;
               case BattleData.EFFECT_PET_WEAKEN:
                  _loc2_ = Central.main.langLib.get(801);
                  break;
               case BattleData.EFFECT_CATALYTIC_MATTER:
                  _loc2_ = Central.main.langLib.get(814);
                  break;
               case BattleData.EFFECT_DISMANTLE:
                  _loc2_ = Central.main.langLib.get(797);
                  break;
               case BattleData.EFFECT_PET_FREEZE:
                  _loc2_ = Central.main.langLib.get(820);
                  break;
               case BattleData.EFFECT_PET_DAMAGE_REDUCTION:
                  _loc2_ = Central.main.langLib.get(322);
                  break;
               case BattleData.EFFECT_PET_DAMAGE_TO_CP:
                  _loc2_ = Central.main.langLib.get(832);
                  break;
               case BattleData.EFFECT_PET_BLEEDING:
                  _loc2_ = Central.main.langLib.get(286);
                  break;
               case BattleData.EFFECT_STUN_RANDOM:
                  _loc2_ = Central.main.langLib.get(281);
                  break;
               case BattleData.EFFECT_PET_SAVE_CP:
                  _loc2_ = Central.main.langLib.get(805);
                  break;
               case BattleData.EFFECT_PET_LIGHTNING:
                  _loc2_ = Central.main.langLib.get(875);
                  break;
               case BattleData.EFFECT_PET_DRAIN_HP_KEKKAI:
                  _loc2_ = Central.main.langLib.get(878);
                  break;
               case BattleData.EFFECT_INTERNAL_INJURY_RANDOM:
                  _loc2_ = Central.main.langLib.get(648);
                  break;
               case BattleData.EFFECT_DOUBLE_BURN:
                  _loc2_ = Central.main.langLib.get(288);
                  break;
               case BattleData.EFFECT_BURN_HP:
                  _loc2_ = Central.main.langLib.get(288);
                  break;
               case BattleData.EFFECT_COMPLETE_GUARD:
                  _loc2_ = Central.main.langLib.get(636);
                  break;
               case BattleData.EFFECT_PET_BLIND:
                  _loc2_ = Central.main.langLib.get(287);
                  break;
               case BattleData.EFFECT_CHAOS:
                  _loc2_ = Central.main.langLib.get(734);
                  break;
               case BattleData.EFFECT_CHAOS_THANOS:
                  _loc2_ = Central.main.langLib.get(734);
                  break;
               case BattleData.EFFECT_PET_DEBUFF_RESIST:
                  _loc2_ = Central.main.langLib.get(822);
                  break;
               case BattleData.EFFECT_PET_HEAL:
                  _loc2_ = Central.main.langLib.get(830);
                  break;
               case BattleData.EFFECT_PET_REDUCE_CHARGE:
                  _loc2_ = Central.main.langLib.get(804);
                  break;
               case BattleData.EFFECT_BURN_CP_HP:
                  _loc2_ = Central.main.langLib.get(288);
                  break;
               case BattleData.EFFECT_FLAME_EATER:
                  _loc2_ = Central.main.langLib.get(482);
                  break;
               case BattleData.EFFECT_PET_REFLECT_ATTACK:
                  _loc2_ = Central.main.langLib.get(873);
                  break;
               case BattleData.EFFECT_CLEAR_BUFF:
                  _loc2_ = Central.main.langLib.get(737);
                  break;
               case BattleData.EFFECT_BUNNY_FRENZY:
                  _loc2_ = Central.main.langLib.get(834);
                  break;
               case BattleData.EFFECT_BATTLE_BUNNY_FRENZY:
                  _loc2_ = Central.main.langLib.get(1871);
                  break;
               case BattleData.EFFECT_ATTACK_MODE:
                  _loc2_ = Central.main.langLib.get(881);
                  break;
               case BattleData.EFFECT_DRAIN_HP_CP:
                  _loc2_ = "EFFECT7";
                  break;
               case BattleData.EFFECT_WAKE_UP:
                  _loc2_ = Central.main.langLib.get(890);
                  break;
               case BattleData.EFFECT_RANDOM_SLEEP:
                  _loc2_ = Central.main.langLib.get(280);
                  break;
               case BattleData.EFFECT_PET_DISORIENTED:
                  _loc2_ = Central.main.langLib.get(891);
                  break;
               case BattleData.EFFECT_PET_ENERGIZE:
                  _loc2_ = Central.main.langLib.get(893);
                  break;
               case BattleData.EFFECT_LIGHT_IMPLUSE:
                  _loc2_ = Central.main.langLib.get(651);
                  break;
               case BattleData.EFFECT_DODGE_REDUCTION:
                  _loc2_ = Central.main.langLib.get(799);
                  break;
               case BattleData.EFFECT_DISTRACT:
                  _loc2_ = Central.main.langLib.get(670);
                  break;
               case BattleData.EFFECT_HAMSTRING:
                  _loc2_ = Central.main.langLib.get(688);
                  break;
               case BattleData.EFFECT_ECSTATIC_SOUND:
                  _loc2_ = Central.main.langLib.get(609);
                  break;
               case BattleData.EFFECT_PROFUSION_OF_GHOSTS:
                  _loc2_ = Central.main.langLib.get(744);
                  break;
               case BattleData.EFFECT_PET_RANDOM_EFFECT_ON_DEFENDER:
                  _loc2_ = "EFFECT8";
                  break;
               case BattleData.EFFECT_PET_RANDOM_EFFECT_ON_MASTER:
                  _loc2_ = "EFFECT9";
                  break;
               case BattleData.EFFECT_ACCURATE:
                  _loc2_ = Central.main.langLib.get(735);
                  break;
               case BattleData.EFFECT_CLEAR_BUFF_NO_RANDOM:
                  _loc2_ = Central.main.langLib.get(877);
                  break;
               case BattleData.SKILL_307:
                  _loc2_ = Central.main.langLib.get(1366);
                  break;
               case BattleData.SKILL_310:
                  _loc2_ = "EFFECT10";
                  break;
               case BattleData.SKILL_311:
                  _loc2_ = "EFFECT11";
                  break;
               case BattleData.SKILL_312:
                  _loc2_ = "EFFECT12";
                  break;
               case BattleData.EFFECT_RESTRICT_CHARGE:
                  _loc2_ = Central.main.langLib.get(754);
                  break;
               case BattleData.EFFECT_CRIT_CHANCE_DMG:
                  _loc2_ = "EFFECT13";
                  break;
               case BattleData.MONSTER_HP1:
                  _loc2_ = "EFFECT14";
                  break;
               case BattleData.EFFECT_CLEARBUFF_DODGEREDUCTION:
                  _loc2_ = Central.main.langLib.get(877);
                  break;
               case BattleData.EFFECT_CLEARBUFF_DAMAGEREDUCTION:
                  _loc2_ = Central.main.langLib.get(737);
                  break;
               case BattleData.EFFECT_DECREASE_CRITICAL_CHANCE:
                  _loc2_ = Central.main.langLib.get(670);
                  break;
               case BattleData.SKILL_234:
                  _loc2_ = Central.main.langLib.get(807);
                  break;
               case BattleData.SKILL_236:
                  _loc2_ = Central.main.langLib.get(799);
                  break;
               case BattleData.SKILL_302:
                  _loc2_ = Central.main.langLib.get(1366);
                  break;
               case BattleData.SKILL_304:
                  _loc2_ = Central.main.langLib.get(1359);
                  break;
               case BattleData.SKILL_251:
                  _loc2_ = Central.main.langLib.get(1366);
                  break;
               case BattleData.SKILL_253:
                  _loc2_ = Central.main.langLib.get(1361);
                  break;
               case BattleData.SKILL_268:
                  _loc2_ = Central.main.langLib.get(1363);
                  break;
               case BattleData.SKILL_268_2:
                  _loc2_ = Central.main.langLib.get(1363);
                  break;
               case BattleData.SKILL_270:
                  _loc2_ = Central.main.langLib.get(1364);
                  break;
               case BattleData.SKILL_335:
                  _loc2_ = Central.main.langLib.get(1369);
                  break;
               case BattleData.SKILL_335_THANOS:
                  _loc2_ = Central.main.langLib.get(1369);
                  break;
               case BattleData.SKILL_2000:
                  _loc2_ = "EFFECT15";
                  break;
               case BattleData.SKILL_2001:
                  _loc2_ = "EFFECT16";
                  break;
               case BattleData.SKILL_2002:
                  _loc2_ = "EFFECT17";
                  break;
               case BattleData.SKILL_2003:
                  _loc2_ = "EFFECT18";
                  break;
               case BattleData.SKILL_2004:
                  _loc2_ = "EFFECT19";
                  break;
               case BattleData.EFFECT_HEAL_OVER_TIME_NPC:
                  _loc2_ = Central.main.langLib.get(596);
                  break;
               case BattleData.SKILL_342:
                  _loc2_ = Central.main.langLib.get(1361);
                  break;
               case BattleData.SKILL_342_THANOS:
                  _loc2_ = Central.main.langLib.get(1361);
                  break;
               case BattleData.SKILL_345:
                  _loc2_ = "EFFECT20";
                  break;
               case BattleData.SKILL_345_THANOS:
                  _loc2_ = "EFFECT20";
                  break;
               case BattleData.EFFECT_DAMAGE_BONUS_FIX_NUM:
                  _loc2_ = Central.main.langLib.get(330);
                  break;
               case BattleData.SKILL_359:
                  _loc2_ = Central.main.langLib.get(305);
                  break;
               case BattleData.SKILL_368:
                  _loc2_ = "EFFECT21";
                  break;
               case BattleData.SKILL_369:
                  _loc2_ = Central.main.langLib.get(330);
                  break;
               case BattleData.SKILL_336:
                  _loc2_ = "EFFECT22";
                  break;
               case BattleData.SKILL_501:
                  _loc2_ = Central.main.langLib.get(330);
                  break;
               case BattleData.EFFECT_PUMPKIN_POWER:
                  _loc2_ = Central.main.langLib.get(1603);
                  break;
               case BattleData.SKILL_377:
                  _loc2_ = Central.main.langLib.get(369);
                  break;
               case BattleData.EFFECT_DOT_HP:
                  _loc2_ = "EFFECT23";
                  break;
               case BattleData.SKILL_341:
                  _loc2_ = Central.main.langLib.get(817);
                  break;
               case BattleData.EFFECT_CLEARBUFF:
                  _loc2_ = Central.main.langLib.get(877);
                  break;
               case BattleData.EFFECT_CLEARBUFF_STUN:
                  _loc2_ = Central.main.langLib.get(737);
                  break;
               case BattleData.INSTANT_KILL:
                  _loc2_ = "EFFECT24";
                  break;
               case BattleData.INSTANT_CUT_HALF_HP:
                  _loc2_ = "EFFECT25";
                  break;
               case BattleData.EFFECT_ADD_PURIFY_CHANCE:
                  _loc2_ = Central.main.langLib.get(1688);
                  break;
               case BattleData.EFFECT_REDUCE_CP_REQUIRE:
                  _loc2_ = "EFFECT26";
                  break;
               case BattleData.EFFECT_PURIFY_RESTORE_HP:
                  _loc2_ = "EFFECT27";
                  break;
               case BattleData.EFFECT_ADD_CRITICAL_CHANCE:
                  _loc2_ = Central.main.langLib.get(292);
                  break;
               case BattleData.EFFECT_ADD_DODGE_BONUS:
                  _loc2_ = Central.main.langLib.get(741);
                  break;
               case BattleData.EFFECT_ADD_DAMAGE_BONUS:
                  _loc2_ = Central.main.langLib.get(330);
                  break;
               case BattleData.EFFECT_ADD_DODGE_RANDOM:
                  _loc2_ = Central.main.langLib.get(741);
                  break;
               case BattleData.EFFECT_ADD_DODGE_REDUCTION:
                  _loc2_ = Central.main.langLib.get(332);
                  break;
               case BattleData.EFFECT_ADD_DODGERE_ABOVE_HP:
                  _loc2_ = Central.main.langLib.get(735);
                  break;
               case BattleData.EFFECT_ADD_DODGERE_BELOW_HP:
                  _loc2_ = Central.main.langLib.get(735);
                  break;
               case BattleData.EFFECT_INSTANT_KILL_BELOW_HP:
                  _loc2_ = "EFFECT29";
                  break;
               case BattleData.EFFECT_REDUCE_DAMAGE_BONUS:
                  _loc2_ = "EFFECT30";
                  break;
               case BattleData.EFFECT_ATTACKER_BLIND:
                  _loc2_ = Central.main.langLib.get(287);
                  break;
               case BattleData.EFFECT_WEAPON_MANA_SHIELD:
                  _loc2_ = Central.main.langLib.get(594);
                  break;
               case BattleData.EFFECT_REDUCE_DAMAGE_BONUS_PRESENT:
                  _loc2_ = "EFFECT31";
                  break;
               case BattleData.EFFECT_REDUCE_DAMAGE_AMOUNT:
                  _loc2_ = "EFFECT32";
                  break;
               case BattleData.EFFECT_ADD_FEEDBACK_CHANCE:
                  _loc2_ = Central.main.langLib.get(533);
                  break;
               case BattleData.EFFECT_REDUCE_TARGET_CP:
                  _loc2_ = "EFFECT33";
                  break;
               case BattleData.EFFECT_GUARD_BELOW_DAMAGE:
                  _loc2_ = "EFFECT34";
                  break;
               case BattleData.EFFECT_WEAPON_FULL_GUARD:
                  _loc2_ = Central.main.langLib.get(636);
                  break;
               case BattleData.EFFECT_RECIEVE_DAMAGE_CP:
                  _loc2_ = "EFFECT35";
                  break;
               case BattleData.EFFECT_ADD_HP_AMOUNT:
                  _loc2_ = "EFFECT36";
                  break;
               case BattleData.EFFECT_ADD_HP_AMOUNT_PRESENT:
                  _loc2_ = "EFFECT37";
                  break;
               case BattleData.EFFECT_ADD_CP_AMOUNT_PRESENT:
                  _loc2_ = "EFFECT38";
                  break;
               case BattleData.EFFECT_ADD_CP_BELOW_CP:
                  _loc2_ = "EFFECT39";
                  break;
               case BattleData.EFFECT_DODGE_SUCCESS_DAMAGE_BONUS:
                  _loc2_ = "EFFECT40";
                  break;
               case BattleData.EFFECT_CP_CONSUME_TO_HP:
                  _loc2_ = "EFFECT41";
                  break;
               case BattleData.EFFECT_ATTACKER_RESTORE_HP:
                  _loc2_ = "EFFECT42";
                  break;
               case BattleData.EFFECT_ATTACKER_RESTORE_CP:
                  _loc2_ = "EFFECT43";
                  break;
               case BattleData.EFFECT_DEFENDER_DAMAGE_CP:
                  _loc2_ = "EFFECT44";
                  break;
               case BattleData.EFFECT_DEBUFF_RESTORE_HP_PRESENT:
                  _loc2_ = "EFFECT45";
                  break;
               case BattleData.EFFECT_DEBUFF_RESTORE_CP_PRESENT:
                  _loc2_ = "EFFECT46";
                  break;
               case BattleData.EFFECT_DEFENDER_BURNING:
                  _loc2_ = "EFFECT47";
                  break;
               case BattleData.EFFECT_DEFENDER_BUNDLE:
                  _loc2_ = "EFFECT48";
                  break;
               case BattleData.EFFECT_DEFENDER_POISON:
                  _loc2_ = "EFFECT49";
                  break;
               case BattleData.EFFECT_ATTACKER_DAMAGE_REDUCTION:
                  _loc2_ = "EFFECT50";
                  break;
               case BattleData.EFFECT_ATTACKER_DAMAGE_BONUS:
                  _loc2_ = "EFFECT51";
                  break;
               case BattleData.EFFECT_DEFENDER_CLEAR_BUFF:
                  _loc2_ = "EFFECT52";
                  break;
               case BattleData.EFFECT_ATTACKER_REDUCE_COOLDOWN:
                  _loc2_ = "EFFECT53";
                  break;
               case BattleData.EFFECT_DEFENDER_FREEZE:
                  _loc2_ = "EFFECT54";
                  break;
               case BattleData.EFFECT_DEFENDER_CRITICAL_CHANCE:
                  _loc2_ = "EFFECT55";
                  break;
               case BattleData.EFFECT_DEFENDER_RESTORE_HP_PRESENT:
                  _loc2_ = "EFFECT56";
                  break;
               case BattleData.EFFECT_ATTACKER_BLEEDING:
                  _loc2_ = "EFFECT57";
                  break;
               case BattleData.EFFECT_ADD_CP_AMOUNT_PRESENT:
                  _loc2_ = "EFFECT58";
                  break;
               case BattleData.EFFECT_REDUCE_DODGE_RANDOM:
                  _loc2_ = "EFFECT59";
                  break;
               case BattleData.EFFECT_ITEM_RESTORE_BONUS:
                  _loc2_ = "EFFECT60";
                  break;
               case BattleData.EFFECT_ITEM_RESTORE_BONUS_PRESENT:
                  _loc2_ = "EFFECT61";
                  break;
               case BattleData.EFFECT_ITEM_RESTORE_CP_BONUS_PRESENT:
                  _loc2_ = "EFFECT62";
                  break;
               case BattleData.EFFECT_CHARGE_CP_BONUS:
                  _loc2_ = "EFFECT63";
                  break;
               case BattleData.EFFECT_ATTACKER_FREEZE:
                  _loc2_ = "EFFECT64";
                  break;
               case BattleData.EFFECT_ABSORB_ATTACKER_HP_PRESENT:
                  _loc2_ = "EFFECT65";
                  break;
               case BattleData.EFFECT_ATTACK_BUNDLE:
                  _loc2_ = "EFFECT66";
                  break;
               case BattleData.EFFECT_ATTACKER_CRITICAL_DAMAGE_BONUS:
                  _loc2_ = "EFFECT67";
                  break;
               case BattleData.EFFECT_CONVERT_FULLDMG_TO_HP:
                  _loc2_ = "EFFECT68";
                  break;
               case BattleData.EFFECT_HEAL_OVER_TIME_FIX_NUM:
                  _loc2_ = "EFFECT69";
                  break;
               case BattleData.EFFECT_ADD_COMBUSTION_CHANCE:
                  _loc2_ = "EFFECT70";
                  break;
               case BattleData.EFFECT_ALL_CP_DODGE_BONUS:
                  _loc2_ = Central.main.langLib.get(306);
                  break;
               case BattleData.EFFECT_ALL_CP_DRAIN_HP:
                  _loc2_ = Central.main.langLib.get(878);
                  break;
               case BattleData.EFFECT_ALL_CP_BLIND:
                  _loc2_ = Central.main.langLib.get(287);
                  break;
               case BattleData.EFFECT_ALL_CP_GUARD_RESIST:
                  _loc2_ = Central.main.langLib.get(636);
                  break;
               case BattleData.EFFECT_ALL_CP_HEAL:
                  _loc2_ = Central.main.langLib.get(408);
                  break;
               case BattleData.EFFECT_HUNDRED_PERCENT_ATTACK:
                  _loc2_ = "EFFECT71";
                  break;
               case BattleData.EFFECT_REDUCE_PURIFY_CHANCE:
                  _loc2_ = Central.main.langLib.get(1361);
                  break;
               case BattleData.EFFECT_BURN_CP_FIX_NUM:
                  _loc2_ = "EFFECT72";
                  break;
               case BattleData.EFFECT_CLEARBUFF_REDUCE_HP_CP:
                  _loc2_ = Central.main.langLib.get(737);
                  break;
               case BattleData.EFFECT_CHARGE_RECOVER_HP:
                  _loc2_ = "EFFECT73";
                  break;
               case BattleData.EFFECT_ADD_ALL_COOLDOWN:
                  _loc2_ = "EFFECT74";
                  break;
               case BattleData.EFFECT_BLEEDING_FIX_NUM:
                  _loc2_ = "EFFECT75";
                  break;
               case BattleData.EFFECT_DAMAGE_BONUS_WEAPON_FIX_NUM:
                  _loc2_ = "EFFECT76";
                  break;
               case BattleData.EFFECT_CRITICAL_DAMAGE_BONUS_WEAPON_FIX_NUM:
                  _loc2_ = "EFFECT77";
                  break;
               case BattleData.EFFECT_MAX_HP:
                  _loc2_ = "EFFECT78";
                  break;
               case BattleData.EFFECT_MAX_HP_PRESENT:
                  _loc2_ = "EFFECT79";
                  break;
               case BattleData.EFFECT_MAX_CP:
                  _loc2_ = "EFFECT80";
                  break;
               case BattleData.EFFECT_MAX_CP_PRESENT:
                  _loc2_ = "EFFECT80";
                  break;
               case BattleData.EFFECT_BURN_FIX_NUM:
                  _loc2_ = "EFFECT81";
                  break;
               case BattleData.EFFECT_PET_WEAKEN_FIX_NUM:
                  _loc2_ = "EFFECT82";
                  break;
               case BattleData.EFFECT_REDUCE_HP_PRESENT:
                  _loc2_ = "EFFECT83";
                  break;
               case BattleData.EFFECT_DAMAGE_HP_FIX_NUM:
                  _loc2_ = "EFFECT84";
                  break;
               case BattleData.EFFECT_RESIST_OVERTIME:
                  _loc2_ = Central.main.langLib.get(822);
                  break;
               case BattleData.ITEM_EFFECT_SEAL_GAN:
                  _loc2_ = Central.main.langLib.get(1725)[0];
                  break;
               case BattleData.ITEM_EFFECT_SPY_CP:
                  _loc2_ = Central.main.langLib.get(1725)[1];
                  break;
               case BattleData.EFFECT_BURN_PROTECTION:
                  _loc2_ = Central.main.langLib.get(322);
                  break;
               case BattleData.EFFECT_BURN_CP_CLEAR_BUFF:
                  _loc2_ = Central.main.langLib.get(1366);
                  break;
               case BattleData.EFFECT_INTERNAL_INJURY_FEAR_WEAKEN:
                  _loc2_ = Central.main.langLib.get(305);
                  break;
               default:
                  _loc2_ = "";
            }
         }
         return _loc2_;
      }
   }
}

