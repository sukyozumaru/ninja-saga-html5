package ninjasaga.data
{
   import com.utils.Out;
   import ninjasaga.Central;
   
   public final class TooltipData
   {
      
      public static const TOOLTIP_TYPE_HAIR:String = "hair";
      
      public static const TOOLTIP_TYPE_CLOTHING:String = "set";
      
      public static const TOOLTIP_TYPE_WEAPON:String = "wpn";
      
      public static const TOOLTIP_TYPE_BACKITEM:String = "backitem";
      
      public static const TOOLTIP_TYPE_ACCESSORY:String = "accessory";
      
      public static const TOOLTIP_TYPE_ITEM:String = "item";
      
      public static const TOOLTIP_TYPE_ESSENCE:String = "essence";
      
      public static const TOOLTIP_TYPE_MATERIAL:String = "material";
      
      public static const TOOLTIP_TYPE_CURRENCY:String = "currency";
      
      public static const TOOLTIP_TYPE_SKILL:String = "skill";
      
      public static const TOOLTIP_TYPE_SENJUTSU:String = "senjutsu";
      
      public static const TOOLTIP_TYPE_SKILL_CLASS:String = "skill_class";
      
      public static const TOOLTIP_TYPE_PET:String = "pet";
      
      private static const ALL_NINJUTSU_TYPES:Array = [SkillData.TYPE_WIND,SkillData.TYPE_FIRE,SkillData.TYPE_LIGHTNING,SkillData.TYPE_EARTH,SkillData.TYPE_WATER,SkillData.TYPE_TAIJUTSU,SkillData.TYPE_GENJUTSU];
      
      private static const SKILL_TYPE_BUTTON_NAME_ARR:Array = [ButtonData.WIND,ButtonData.FIRE,ButtonData.THUNDER,ButtonData.EARTH,ButtonData.WATER,ButtonData.TAIJUTSU,ButtonData.GENJUTSU];
      
      public function TooltipData()
      {
         super();
      }
      
      private static function getEffectDescription(effect:Object) : String
      {
         var amount:* = effect.amount;
         var chance:* = effect.chance;
         var duration:* = effect.duration;
         var tmpStr:String = Central.main.langLib.effectDataTxt(effect.type);
         if(!tmpStr)
         {
            return "[" + effect + "]";
         }
         if(amount < 0)
         {
            tmpStr = "<font color=\'#FF0000\'>" + tmpStr + "</font>";
            amount *= -1;
            tmpStr = tmpStr.replace("[increase]","[decrease]");
            tmpStr = tmpStr.replace("[decrease]","[increase]");
            tmpStr = tmpStr.replace("[up]","[down]");
            tmpStr = tmpStr.replace("[down]","[up]");
         }
         else
         {
            tmpStr = "<font color=\'#0000FF\'>" + tmpStr + "</font>";
         }
         tmpStr = tmpStr.replace("[chance]",chance);
         tmpStr = tmpStr.replace("[amount]",amount);
         tmpStr = tmpStr.replace("[100-amount]",100 - amount);
         tmpStr = tmpStr.replace("[duration]",duration - 1);
         tmpStr = tmpStr.replace("[increase]",AppData.lang == AppData.ZH ? "增加" : "increase");
         tmpStr = tmpStr.replace("[decrease]",AppData.lang == AppData.ZH ? "減少" : "decrease");
         tmpStr = tmpStr.replace("[up]",AppData.lang == AppData.ZH ? "上升" : "");
         return tmpStr.replace("[down]",AppData.lang == AppData.ZH ? "下降" : "");
      }
      
      private static function getGearsetEffectDescription(effect:Object) : *
      {
         var effectStr:String = Central.main.langLib.getGearsetText(effect.type);
         if(!effectStr)
         {
            return "DEBUG: gearsetText[\"" + effect.type + "\"] not found";
         }
         effectStr = effectStr.replace("[chance]",effect.chance);
         effectStr = effectStr.replace("[duration]",effect.duration - 1);
         return effectStr.replace("[amount]",effect.amount);
      }
      
      private static function getExtraEffectDescription(effect:Object) : *
      {
         var i:int = 0;
         var effectStr:String = Central.main.langLib.getExtraEffectText(effect.type);
         var enemyName:String = "";
         for(i = 0; i < effect.enemy.length; i++)
         {
            enemyName += enemyName == "" ? Central.main.ENEMY_DATA.find(effect.enemy[i]).name : "/" + Central.main.ENEMY_DATA.find(effect.enemy[i]).name;
         }
         if(!effectStr)
         {
            return "";
         }
         effectStr = effectStr.replace("[amount]",effect.amount);
         return effectStr.replace("[enemy]",enemyName);
      }
      
      public static function getItemTooltip(type:String, id:String, _limitedMsg:String = "", miscData:Object = null) : String
      {
         var obj:Object = null;
         var effect:Object = null;
         var i:int = 0;
         var wpnAdjDamage:int = 0;
         var nameSuffix:String = null;
         var descReplace:String = null;
         var adjustedCPRequired:int = 0;
         var invId:int = 0;
         var mainChar:* = undefined;
         var tmpEffect:Object = null;
         var body_set_obj:Object = null;
         var petArr:Array = null;
         var finalDmg:int = 0;
         var charBackItemEffect:Object = null;
         var charWeaponEffect:Object = null;
         var ToolTip_curlv:String = null;
         var ToolTip_Final:String = null;
         var ToolTip_Requirement_curlv_arr1:Array = null;
         var ToolTip_Requirement_curlv_arr2:Array = null;
         var ToolTip_Requirement_curlv_arr3:Array = null;
         var SenjutsuskillData:Object = null;
         var SenjutsuskillData_effect:Object = null;
         var levelBouns:int = 0;
         var amount:int = 0;
         var special_class:int = 0;
         var tooltipStr:String = "";
         var skillTypeStr:String = "";
         var effectStr:String = "";
         var isLoginMode:Boolean = NinjaSaga.isTestMode;
         var isLimited:Boolean = false;
         if(String(_limitedMsg).length > 0)
         {
            isLimited = true;
         }
         mainChar = Central.main.getMainChar();
         switch(type)
         {
            case TOOLTIP_TYPE_HAIR:
               obj = Central.main.HAIR_DATA.find(id);
               if(obj)
               {
                  if(Central.main.dataFilter(obj) == false)
                  {
                     return null;
                  }
                  if(String(obj.description).length > 0)
                  {
                     tooltipStr = String("<b>" + obj.description + "</b>");
                     tooltipStr = tooltipStr + "<br>(" + String(Central.main.langLib.titleTxt(TitleData.HAIRSTYLE)).replace(":","") + ")";
                  }
                  if(Boolean(obj.relate_set) && obj.relate_set != "")
                  {
                     tooltipStr += getGearsetTooltip(obj);
                  }
               }
               break;
            case TOOLTIP_TYPE_CLOTHING:
               body_set_obj = {};
               body_set_obj = mainChar.getGender() == 0 ? Central.main.BODY_SET_BOY : Central.main.BODY_SET_GIRL;
               if(body_set_obj[id])
               {
                  obj = body_set_obj[id];
               }
               if(obj)
               {
                  if(Central.main.dataFilter(obj) == false)
                  {
                     return null;
                  }
                  if(isLimited)
                  {
                     tooltipStr = String("<b>" + obj.name + "</b>");
                     tooltipStr = tooltipStr + "<br><br>" + String(Central.main.langLib.get(1605)[0]);
                     tooltipStr = tooltipStr + "<br>" + _limitedMsg + "</font>";
                  }
                  else
                  {
                     tooltipStr = String("<b>" + obj.name + "</b>");
                     tooltipStr = tooltipStr + "<br>(" + Central.main.langLib.titleTxt(TitleData.CLOTHING_TOOLTIP) + ")";
                     tooltipStr = tooltipStr + "<br><br>" + Central.main.langLib.titleTxt(TitleData.LEVEL) + ": " + obj.level;
                     if(String(obj.description).length > 0)
                     {
                        tooltipStr = tooltipStr + "<br><br>" + obj.description;
                     }
                  }
                  if(Boolean(obj.relate_set) && obj.relate_set != "")
                  {
                     tooltipStr += getGearsetTooltip(obj);
                  }
               }
               break;
            case TOOLTIP_TYPE_WEAPON:
               obj = Central.main.WEAPON_DATA.find(id);
               if(obj)
               {
                  if(Central.main.dataFilter(obj) == false)
                  {
                     return null;
                  }
                  wpnAdjDamage = int(Central.main.fetchAdjustedWeaponDamage(obj));
                  nameSuffix = "";
                  descReplace = "";
                  if(Boolean(obj.id == "wpn1596" && miscData) && Boolean(miscData.character != null) && miscData.stoneCounter != null)
                  {
                     wpnAdjDamage = int(Central.main.fetchAdjustedWeaponDamage(obj,{
                        "character":miscData.character,
                        "stoneCounter":miscData.stoneCounter
                     }));
                     nameSuffix = AppData.lang == AppData.ZH ? "(等級 " + miscData.stoneCounter + ")" : "(Level " + miscData.stoneCounter + ")";
                     if(AppData.lang == AppData.ZH)
                     {
                        descReplace = "鑲嵌石： <font color=\'#00AA00\'><stone_amt></font><br>受已鑲嵌石影響，命中率增加 <font color=\'#00AA00\'><val1></font>%；該回合使用過武器攻擊，可增加 <font color=\'#00AA00\'><val2></font>%攻擊傷害，直到下回合完結；減免 <font color=\'#00AA00\'><val3></font>%所受傷害。武器傷害增加 <font color=\'#00AA00\'><val4></font>。另外，受持有者等級值影響，武器傷害增加 <font color=\'#00AA00\'><val5></font>。";
                     }
                     else
                     {
                        descReplace = "Implanted Stones: <font color=\'#00AA00\'><stone_amt></font><br>Due to the status of stones, increases accuracy by <font color=\'#00AA00\'><val1></font>%; increases attack damage by <font color=\'#00AA00\'><val2></font>% until the end of next turn after use; reduces <font color=\'#00AA00\'><val3></font>% damage received; weapon damage increases by <font color=\'#00AA00\'><val4></font>.  Furthermore, due to character level, weapon damage increased by <font color=\'#00AA00\'><val5></font>.";
                     }
                     descReplace = descReplace.replace("<stone_amt>",miscData.stoneCounter);
                     descReplace = descReplace.replace("<val1>",17 + miscData.stoneCounter * 8);
                     descReplace = descReplace.replace("<val2>",15 + miscData.stoneCounter * 5);
                     descReplace = descReplace.replace("<val3>",5 + miscData.stoneCounter * 5);
                     descReplace = descReplace.replace("<val4>",miscData.stoneCounter * 75);
                     descReplace = descReplace.replace("<val5>",miscData.character.getData(DBCharacterData.LEVEL));
                  }
                  if(isLimited)
                  {
                     tooltipStr = String("<b>" + obj.name + (nameSuffix ? " " + nameSuffix : "") + "</b>");
                     tooltipStr = tooltipStr + "<br><br><font color=\'#00FF99\'>" + String(Central.main.langLib.get(1605)[0]);
                     tooltipStr = tooltipStr + "<br>" + _limitedMsg + "</font>";
                  }
                  else
                  {
                     tooltipStr = String("<b>" + obj.name + (nameSuffix ? " " + nameSuffix : "") + "</b>");
                     tooltipStr = tooltipStr + "<br>(" + Central.main.langLib.titleTxt(TitleData.WEAPON) + ")";
                     tooltipStr = tooltipStr + "<br><br>" + Central.main.langLib.titleTxt(TitleData.LEVEL) + ": " + obj.level;
                     tooltipStr = tooltipStr + "<br><font color=\'#FF0000\'>" + Central.main.langLib.titleTxt(TitleData.DAMAGE) + ": " + wpnAdjDamage + "</font>";
                     if(String(obj.description).length > 0)
                     {
                        tooltipStr = tooltipStr + "<br><br>" + (descReplace == "" ? obj.description : descReplace);
                     }
                     if(Boolean(obj.relate_set) && obj.relate_set != "")
                     {
                        tooltipStr += getGearsetTooltip(obj);
                     }
                     if(Boolean(obj.extra_effect) && obj.extra_effect != null)
                     {
                        for(i = 0; i < obj.extra_effect.enemy.length; i++)
                        {
                           if(Central.main.extraData.activeEnemy.indexOf(obj.extra_effect.enemy[i]) >= 0)
                           {
                              tooltipStr += getExtraEffectTooltip(obj);
                              break;
                           }
                        }
                     }
                  }
               }
               break;
            case TOOLTIP_TYPE_BACKITEM:
               obj = Central.main.BACK_ITEM_DATA.find(id);
               if(obj)
               {
                  if(Central.main.dataFilter(obj) == false)
                  {
                     return null;
                  }
                  if(isLimited)
                  {
                     tooltipStr = String("<b>" + obj.name + "</b>");
                     tooltipStr = tooltipStr + "<br><br><font color=\'#00FF99\'>" + String(Central.main.langLib.get(1605)[0]);
                     tooltipStr = tooltipStr + "<br>" + _limitedMsg + "</font>";
                  }
                  else
                  {
                     tooltipStr = String("<b>" + obj.name + "</b>");
                     tooltipStr = tooltipStr + "<br>(" + Central.main.langLib.btnTxt(ButtonData.BACK_ITEM) + ")";
                     tooltipStr = tooltipStr + "<br><br>" + Central.main.langLib.titleTxt(TitleData.LEVEL) + ": " + obj.level;
                     if(String(obj.description).length > 0)
                     {
                        tooltipStr = tooltipStr + "<br><br>" + Central.main.langLib.titleTxt(TitleData.EFFECT) + ": " + obj.description;
                     }
                     else
                     {
                        tooltipStr = tooltipStr + "<br><br>" + Central.main.langLib.titleTxt(TitleData.EFFECT) + ": -";
                     }
                     if(Boolean(obj.relate_set) && obj.relate_set != "")
                     {
                        tooltipStr += getGearsetTooltip(obj);
                     }
                     if(Boolean(obj.extra_effect) && obj.extra_effect != null)
                     {
                        for(i = 0; i < obj.extra_effect.enemy.length; i++)
                        {
                           if(Central.main.extraData.activeEnemy.indexOf(obj.extra_effect.enemy[i]) >= 0)
                           {
                              tooltipStr += getExtraEffectTooltip(obj);
                              break;
                           }
                        }
                     }
                  }
               }
               break;
            case TOOLTIP_TYPE_ACCESSORY:
               obj = Central.main.ACCESSORY_DATA.find(id);
               if(obj)
               {
                  if(Central.main.dataFilter(obj) == false)
                  {
                     return null;
                  }
                  if(isLimited)
                  {
                     tooltipStr = String("<b>" + obj.name + "</b>");
                     tooltipStr = tooltipStr + "<br><br><font color=\'#00FF99\'>" + String(Central.main.langLib.get(1605)[0]);
                     tooltipStr = tooltipStr + "<br>" + _limitedMsg + "</font>";
                  }
                  else
                  {
                     tooltipStr = String("<b>" + obj.name + "</b>");
                     tooltipStr = tooltipStr + "<br>(" + Central.main.langLib.titleTxt(TitleData.ACCESSORY) + ")";
                     tooltipStr = tooltipStr + "<br><br>" + Central.main.langLib.titleTxt(TitleData.LEVEL) + ": " + obj.level;
                     if(String(obj.description).length > 0)
                     {
                        tooltipStr = tooltipStr + "<br><br>" + Central.main.langLib.titleTxt(TitleData.EFFECT) + ": " + obj.description;
                     }
                     else
                     {
                        tooltipStr = tooltipStr + "<br><br>" + Central.main.langLib.titleTxt(TitleData.EFFECT) + ": -";
                     }
                  }
                  if(Boolean(obj.relate_set) && obj.relate_set != "")
                  {
                     tooltipStr += getGearsetTooltip(obj);
                  }
                  if(Boolean(obj.extra_effect) && obj.extra_effect != null)
                  {
                     for(i = 0; i < obj.extra_effect.enemy.length; i++)
                     {
                        if(Central.main.extraData.activeEnemy.indexOf(obj.extra_effect.enemy[i]) >= 0)
                        {
                           tooltipStr += getExtraEffectTooltip(obj);
                           break;
                        }
                     }
                  }
               }
               break;
            case TOOLTIP_TYPE_ITEM:
               obj = Central.main.ITEM_DATA.find(id);
               if(obj)
               {
                  if(Central.main.dataFilter(obj) == false)
                  {
                     return null;
                  }
                  if(isLimited)
                  {
                     tooltipStr = String("<b>" + obj.name + "</b>");
                     tooltipStr = tooltipStr + "<br><br><font color=\'#00FF99\'>" + String(Central.main.langLib.get(1605)[0]);
                     tooltipStr = tooltipStr + "<br>" + _limitedMsg + "</font>";
                  }
                  else
                  {
                     tooltipStr = String("<b>" + obj.name + "</b>");
                     tooltipStr = tooltipStr + "<br>(" + Central.main.langLib.titleTxt(TitleData.ITEM) + ")";
                     tooltipStr = tooltipStr + "<br><br>" + Central.main.langLib.titleTxt(TitleData.LEVEL) + ": " + obj.level;
                     if(String(obj.description).length > 0)
                     {
                        tooltipStr = tooltipStr + "<br><br>" + obj.description;
                     }
                  }
                  if(Boolean(obj.extra_effect) && obj.extra_effect != null)
                  {
                     Out.debug(null,"hihi");
                     for(i = 0; i < obj.extra_effect.enemy.length; i++)
                     {
                        Out.debug(null,"hihi999");
                        if(Central.main.extraData.activeEnemy.indexOf(obj.extra_effect.enemy[i]) >= 0)
                        {
                           Out.debug(null,"hihi333");
                           tooltipStr += getExtraEffectTooltip(obj);
                           break;
                        }
                     }
                  }
               }
               break;
            case TOOLTIP_TYPE_ESSENCE:
               obj = Central.main.ESSENCE_DATA.find(id);
               if(obj)
               {
                  if(Central.main.dataFilter(obj) == false)
                  {
                     return null;
                  }
                  if(isLimited)
                  {
                     tooltipStr = String("<b>" + obj.name + "</b>");
                     tooltipStr = tooltipStr + "<br><br><font color=\'#00FF99\'>" + String(Central.main.langLib.get(1605)[0]);
                     tooltipStr = tooltipStr + "<br>" + _limitedMsg + "</font>";
                  }
                  else
                  {
                     tooltipStr = String("<b>" + obj.name + "</b>");
                     tooltipStr = tooltipStr + "<br>(" + Central.main.langLib.titleTxt(TitleData.NINJA_ESSENCE) + ")";
                     if(String(obj.description).length > 0)
                     {
                        tooltipStr = tooltipStr + "<br><br>" + obj.description;
                     }
                  }
               }
               break;
            case TOOLTIP_TYPE_MATERIAL:
               obj = Central.main.MATERIAL_DATA.find(id);
               if(obj)
               {
                  if(Central.main.dataFilter(obj) == false)
                  {
                     return null;
                  }
                  if(isLimited)
                  {
                     tooltipStr = String("<b>" + obj.name + "</b>");
                     tooltipStr = tooltipStr + "<br><br><font color=\'#00FF99\'>" + String(Central.main.langLib.get(1605)[0]);
                     tooltipStr = tooltipStr + "<br>" + _limitedMsg + "</font>";
                  }
                  else
                  {
                     tooltipStr = String("<b>" + obj.name + "</b>");
                     tooltipStr = tooltipStr + "<br>(" + Central.main.langLib.titleTxt(TitleData.MATERIAL) + ")";
                     if(String(obj.description).length > 0)
                     {
                        tooltipStr = tooltipStr + "<br><br>" + obj.description;
                     }
                  }
               }
               break;
            case TOOLTIP_TYPE_CURRENCY:
               obj = Central.main.CURRENCY_DATA.find(id);
               if(obj)
               {
                  if(Central.main.dataFilter(obj) == false)
                  {
                     return null;
                  }
                  if(isLimited)
                  {
                     tooltipStr = String("<b>" + obj.name + "</b>");
                     tooltipStr = tooltipStr + "<br><br><font color=\'#00FF99\'>" + String(Central.main.langLib.get(1605)[0]);
                     tooltipStr = tooltipStr + "<br>" + _limitedMsg + "</font>";
                  }
                  else
                  {
                     tooltipStr = String("<b>" + obj.name + "</b>");
                     if(String(obj.description).length > 0)
                     {
                        tooltipStr = tooltipStr + "<br><br>" + obj.description;
                     }
                  }
               }
               break;
            case TOOLTIP_TYPE_SKILL:
               if(Central.main.SKILL_DATA[id])
               {
                  obj = Central.main.SKILL_DATA[id];
               }
               if(obj)
               {
                  if(Central.main.dataFilter(obj) == false)
                  {
                     return null;
                  }
                  if(isLimited)
                  {
                     tooltipStr = String("<b>" + obj.name + "</b>");
                     tooltipStr = tooltipStr + "<br><br><font color=\'#00FF99\'>" + String(_limitedMsg);
                  }
                  else
                  {
                     skillTypeStr = getSkillTypeName(obj.type);
                     finalDmg = int(obj.damage);
                     if(obj.skill_hit_num >= 2)
                     {
                        finalDmg = Math.round(obj.damage * obj.skill_hit_num);
                     }
                     tooltipStr = String("<b>" + obj.name + "</b>");
                     tooltipStr = tooltipStr + "<br>(" + skillTypeStr + ")";
                     tooltipStr = tooltipStr + "<br><br>" + Central.main.langLib.titleTxt(TitleData.LEVEL) + ": " + obj.level;
                     invId = int(obj.id.replace(/skill/,""));
                     adjustedCPRequired = int(obj.cp);
                     if(obj.effect != null)
                     {
                        if(obj.effect.type == BattleData.EFFECT_CLEAR_BUFF_N_INTERNAL_INJURY_THANOS && mainChar.getWeapon() == "wpn1596")
                        {
                           adjustedCPRequired = 400;
                        }
                     }
                     if(obj.effect != null)
                     {
                        if(obj.effect.type == BattleData.EFFECT_DAMAGE_BONUS_FIX_NUM_THANOS && mainChar.getWeapon() == "wpn1596")
                        {
                           adjustedCPRequired = 200;
                        }
                     }
                     if(mainChar.isBattleBuffActive(BattleData.EFFECT_EXCITATION_CP))
                     {
                        adjustedCPRequired = 0;
                     }
                     if(mainChar.isBattleBuffActive(BattleData.EFFECT_CP_LOCK))
                     {
                        adjustedCPRequired = 0;
                     }
                     if(mainChar.isBattleBuffActive(BattleData.EFFECT_REDUCE_SELF_CP_CONSUME))
                     {
                        adjustedCPRequired = Math.round(adjustedCPRequired * (1 - int(mainChar.getBattleBuff()[BattleData.EFFECT_REDUCE_SELF_CP_CONSUME].amount) / 100));
                     }
                     if(mainChar.isBattleBuffActive(BattleData.EFFECT_REDUCE_CP_REQUIRE))
                     {
                        adjustedCPRequired = Math.round(adjustedCPRequired * (int(mainChar.getBattleBuff()[BattleData.EFFECT_REDUCE_CP_REQUIRE].amount) / 100));
                     }
                     if(mainChar.isBattleBuffActive(BattleData.EFFECT_PET_SAVE_CP))
                     {
                        adjustedCPRequired = Math.round(adjustedCPRequired * (1 - mainChar.getBattleBuff()[BattleData.EFFECT_PET_SAVE_CP].amount / 100));
                     }
                     if(mainChar.getBackItem())
                     {
                        charBackItemEffect = Central.main.BACK_ITEM_DATA.find(mainChar.getBackItem()).effect;
                        for each(tmpEffect in charBackItemEffect)
                        {
                           switch(tmpEffect.type)
                           {
                              case BattleData.EFFECT_REDUCE_CP_REQUIRE:
                                 if(tmpEffect.chance == 100)
                                 {
                                    adjustedCPRequired = Math.round(adjustedCPRequired * (1 - charBackItemEffect.amount * 0.01));
                                 }
                           }
                        }
                     }
                     if(mainChar.getWeapon())
                     {
                        charWeaponEffect = Central.main.WEAPON_DATA.find(mainChar.getWeapon()).effect;
                        for each(tmpEffect in charWeaponEffect)
                        {
                           switch(tmpEffect.type)
                           {
                              case BattleData.EFFECT_REDUCE_CP_REQUIRE:
                                 if(tmpEffect.amount > 0)
                                 {
                                    adjustedCPRequired = Math.round(adjustedCPRequired * (tmpEffect.amount / 100));
                                 }
                           }
                        }
                     }
                     if(mainChar.isBattleDebuffActive(BattleData.SKILL_341))
                     {
                        adjustedCPRequired = Math.round(adjustedCPRequired * (int(mainChar.getBattleDebuff()[BattleData.SKILL_341].amount) / 100));
                     }
                     if(mainChar.isBattleDebuffActive(BattleData.EFFECT_CUBE_ILLUSION))
                     {
                        adjustedCPRequired = Math.round(adjustedCPRequired * 1.4);
                     }
                     if(mainChar.isBattleDebuffActive(BloodlineData.EFFECT_EXTRA_CP_USE))
                     {
                        adjustedCPRequired = Math.round(adjustedCPRequired * 2);
                     }
                     if(mainChar.isBattleDebuffActive(BattleData.EFFECT_TRANSFORM))
                     {
                        adjustedCPRequired = Math.round(adjustedCPRequired * 3);
                     }
                     if(mainChar.isBattleDebuffActive(BattleData.EFFECT_CP_BLEEDING))
                     {
                        adjustedCPRequired = Math.round(adjustedCPRequired * (int(mainChar.getBattleDebuff()[BattleData.EFFECT_CP_BLEEDING].amount) * 0.01));
                     }
                     tooltipStr = tooltipStr + "<br><font color=\'#0000FF\'>" + Central.main.langLib.titleTxt(TitleData.CHAKRA) + ": " + adjustedCPRequired + "</font>";
                     if(Boolean(obj.effect) && obj.effect.type == SkillData.EFFECT_TYPE_HEAL)
                     {
                        tooltipStr = tooltipStr + "<br><font color=\'#33CC33\'>" + Central.main.langLib.titleTxt(TitleData.HEAL) + ": " + finalDmg + "</font>";
                     }
                     else
                     {
                        tooltipStr = tooltipStr + "<br><font color=\'#FF0000\'>" + Central.main.langLib.titleTxt(TitleData.DAMAGE) + ": " + finalDmg + "</font>";
                     }
                     tooltipStr = tooltipStr + "<br>" + Central.main.langLib.titleTxt(TitleData.COOLDOWN) + ": " + obj.cooldown;
                     if(String(obj.description).length > 0)
                     {
                        tooltipStr = tooltipStr + "<br><br>" + obj.description;
                     }
                     if(Boolean(obj.extra_effect) && obj.extra_effect != null)
                     {
                        for(i = 0; i < obj.extra_effect.enemy.length; i++)
                        {
                           if(Central.main.extraData.activeEnemy.indexOf(obj.extra_effect.enemy[i]) >= 0)
                           {
                              tooltipStr += getExtraEffectTooltip(obj);
                              break;
                           }
                        }
                     }
                  }
               }
               break;
            case TOOLTIP_TYPE_SENJUTSU:
               if(Central.main.SENJUTSU_SKILL_DATA[id])
               {
                  obj = Central.main.SENJUTSU_SKILL_DATA[id];
               }
               if(obj)
               {
                  if(Central.main.dataFilter(obj) == false)
                  {
                     return null;
                  }
                  if(isLimited)
                  {
                     tooltipStr = String("<b>" + obj.name + "</b>");
                     tooltipStr = tooltipStr + "<br><br><font color=\'#00FF99\'>" + String(_limitedMsg);
                  }
                  else
                  {
                     ToolTip_curlv = "";
                     ToolTip_Final = "";
                     ToolTip_Requirement_curlv_arr1 = [];
                     ToolTip_Requirement_curlv_arr2 = [];
                     ToolTip_Requirement_curlv_arr3 = [];
                     SenjutsuskillData = obj;
                     SenjutsuskillData_effect = obj.effect[0];
                     if(id == "senjutsu_skill3000")
                     {
                        SenjutsuskillData_effect.skill_sp = mainChar.maxSP;
                     }
                     tooltipStr = String("<b>" + SenjutsuskillData.name + "</b>");
                     if(SenjutsuskillData.senjutsu_type == SenjutsuData.SKILL_TYPE_PASSIVE)
                     {
                        tooltipStr = tooltipStr + "<br><font color=\'#CC9900\'>(" + Central.main.langLib.titleTxt(TitleData.PASSIVE) + " " + Central.main.langLib.titleTxt(TitleData.SKILL) + ")</font>";
                        tooltipStr = tooltipStr + "<br><br><font color=\'#FF0000\'>" + Central.main.langLib.titleTxt(TitleData.DAMAGE) + ": -</font>";
                        tooltipStr = tooltipStr + "<br><font color=\'#FF5300\'>" + Central.main.langLib.titleTxt(TitleData.SP) + ": -</font>";
                        tooltipStr = tooltipStr + "<br><font color=\'#CC9900\'>" + Central.main.langLib.titleTxt(TitleData.COOLDOWN) + ": -</font>";
                     }
                     else
                     {
                        if(SenjutsuskillData_effect.skill_damage == 0)
                        {
                           tooltipStr = tooltipStr + "<br><br><font color=\'#FF0000\'>" + Central.main.langLib.titleTxt(TitleData.DAMAGE) + ": -</font>";
                        }
                        else
                        {
                           tooltipStr = tooltipStr + "<br><br><font color=\'#FF0000\'>" + Central.main.langLib.titleTxt(TitleData.DAMAGE) + ": " + String(SenjutsuskillData_effect.skill_damage) + "</font>";
                        }
                        if(SenjutsuskillData_effect.skill_sp == 0)
                        {
                           tooltipStr = tooltipStr + "<br><font color=\'#FF5300\'>" + Central.main.langLib.titleTxt(TitleData.SP) + ": -</font>";
                        }
                        else
                        {
                           tooltipStr = tooltipStr + "<br><font color=\'#FF5300\'>" + Central.main.langLib.titleTxt(TitleData.SP) + ": " + String(SenjutsuskillData_effect.skill_sp) + "</font>";
                        }
                        tooltipStr = tooltipStr + "<br><font color=\'#CC9900\'>" + Central.main.langLib.titleTxt(TitleData.COOLDOWN) + ": " + String(SenjutsuskillData.cooldown) + "</font>";
                     }
                     ToolTip_curlv = SenjutsuskillData.tooltip;
                     if(String(SenjutsuskillData_effect.effect_requirement_1).length > 0)
                     {
                        ToolTip_Requirement_curlv_arr1 = SenjutsuskillData_effect.effect_requirement_1.split("|");
                     }
                     if(String(SenjutsuskillData_effect.effect_requirement_2).length > 0)
                     {
                        ToolTip_Requirement_curlv_arr2 = SenjutsuskillData_effect.effect_requirement_2.split("|");
                     }
                     if(String(SenjutsuskillData_effect.effect_requirement_3).length > 0)
                     {
                        ToolTip_Requirement_curlv_arr3 = SenjutsuskillData_effect.effect_requirement_3.split("|");
                     }
                     ToolTip_curlv = String(ToolTip_curlv).replace(/\[valCHANCETOEFFECT_1\]/g,Math.abs(SenjutsuskillData_effect.effect_chancetoeffect_1));
                     ToolTip_curlv = String(ToolTip_curlv).replace(/\[valCHANCETOEFFECT_2\]/g,Math.abs(SenjutsuskillData_effect.effect_chancetoeffect_2));
                     ToolTip_curlv = String(ToolTip_curlv).replace(/\[valCHANCETOEFFECT_3\]/g,Math.abs(SenjutsuskillData_effect.effect_chancetoeffect_3));
                     ToolTip_curlv = String(ToolTip_curlv).replace(/\[valCHANCETOHIT_1\]/g,Math.abs(SenjutsuskillData_effect.effect_chancetohit_1));
                     ToolTip_curlv = String(ToolTip_curlv).replace(/\[valCHANCETOHIT_2\]/g,Math.abs(SenjutsuskillData_effect.effect_chancetohit_2));
                     ToolTip_curlv = String(ToolTip_curlv).replace(/\[valCHANCETOHIT_3\]/g,Math.abs(SenjutsuskillData_effect.effect_chancetohit_3));
                     ToolTip_curlv = String(ToolTip_curlv).replace(/\[valAMOUNT_1\]/g,Math.abs(SenjutsuskillData_effect.effect_amount_1));
                     ToolTip_curlv = String(ToolTip_curlv).replace(/\[valAMOUNT_2\]/g,Math.abs(SenjutsuskillData_effect.effect_amount_2));
                     ToolTip_curlv = String(ToolTip_curlv).replace(/\[valAMOUNT_3\]/g,Math.abs(SenjutsuskillData_effect.effect_amount_3));
                     ToolTip_curlv = String(ToolTip_curlv).replace(/\[val100minusAMOUNT_1\]/g,String(100 - Number(SenjutsuskillData_effect.effect_amount_1)));
                     ToolTip_curlv = String(ToolTip_curlv).replace(/\[val100minusAMOUNT_2\]/g,String(100 - Number(SenjutsuskillData_effect.effect_amount_2)));
                     ToolTip_curlv = String(ToolTip_curlv).replace(/\[val100minusAMOUNT_3\]/g,String(100 - Number(SenjutsuskillData_effect.effect_amount_3)));
                     ToolTip_curlv = String(ToolTip_curlv).replace(/\[val100plusAMOUNT_1\]/g,String(100 + Number(SenjutsuskillData_effect.effect_amount_1)));
                     ToolTip_curlv = String(ToolTip_curlv).replace(/\[val100plusAMOUNT_2\]/g,String(100 + Number(SenjutsuskillData_effect.effect_amount_2)));
                     ToolTip_curlv = String(ToolTip_curlv).replace(/\[val100plusAMOUNT_3\]/g,String(100 + Number(SenjutsuskillData_effect.effect_amount_3)));
                     ToolTip_curlv = String(ToolTip_curlv).replace(/\[valTURN_1\]/g,Math.abs(int(SenjutsuskillData_effect.duration_1) - 1));
                     ToolTip_curlv = String(ToolTip_curlv).replace(/\[valTURN_2\]/g,Math.abs(int(SenjutsuskillData_effect.duration_2) - 1));
                     ToolTip_curlv = String(ToolTip_curlv).replace(/\[valTURN_3\]/g,Math.abs(int(SenjutsuskillData_effect.duration_3) - 1));
                     ToolTip_curlv = String(ToolTip_curlv).replace(/\[valDAMAGE\]/g,Math.abs(SenjutsuskillData_effect.skill_damage));
                     ToolTip_curlv = String(ToolTip_curlv).replace(/\[valLEVEL\]/g,Math.abs(SenjutsuskillData_effect.skill_level));
                     if(ToolTip_Requirement_curlv_arr1.length > 0)
                     {
                        ToolTip_curlv = String(ToolTip_curlv).replace(/\[valreqAMOUNT_1\]/g,Math.abs(ToolTip_Requirement_curlv_arr1[3]));
                     }
                     if(ToolTip_Requirement_curlv_arr2.length > 0)
                     {
                        ToolTip_curlv = String(ToolTip_curlv).replace(/\[valreqAMOUNT_2\]/g,Math.abs(ToolTip_Requirement_curlv_arr2[3]));
                     }
                     if(ToolTip_Requirement_curlv_arr3.length > 0)
                     {
                        ToolTip_curlv = String(ToolTip_curlv).replace(/\[valreqAMOUNT_3\]/g,Math.abs(ToolTip_Requirement_curlv_arr3[3]));
                     }
                     if(ToolTip_curlv == "")
                     {
                        tooltipStr = String("<font size=\'13\'>" + tooltipStr + "</font>");
                     }
                     else
                     {
                        tooltipStr = String("<font size=\'13\'>" + tooltipStr + "<br>" + ToolTip_curlv + "</font>");
                     }
                  }
               }
               break;
            case TOOLTIP_TYPE_SKILL_CLASS:
               if(Central.main.SKILL_DATA[id])
               {
                  obj = Central.main.SKILL_DATA[id];
               }
               if(obj)
               {
                  if(Central.main.dataFilter(obj) == false)
                  {
                     return null;
                  }
                  if(isLimited)
                  {
                     tooltipStr = String("<b>" + obj.name + "</b>");
                     tooltipStr = tooltipStr + "<br><br><font color=\'#00FF99\'>" + String(Central.main.langLib.get(1605)[0]);
                     tooltipStr = tooltipStr + "<br>" + _limitedMsg + "</font>";
                  }
                  else
                  {
                     special_class = int(obj.special_class);
                     skillTypeStr = String(Central.main.langLib.get(1580)[special_class - 1]);
                     switch(id)
                     {
                        case "skill2004":
                           levelBouns = int(mainChar.getLevel()) - 60;
                           if(levelBouns < 0)
                           {
                              levelBouns = 0;
                           }
                           amount = 700 + levelBouns * 64;
                           break;
                        case "skill2000":
                           levelBouns = int(mainChar.getLevel()) - 60;
                           if(levelBouns < 0)
                           {
                              levelBouns = 0;
                           }
                           amount = 1000 + levelBouns * 70;
                     }
                     tooltipStr = String("<b>" + obj.name + "</b>");
                     tooltipStr = tooltipStr + "<br>(" + skillTypeStr + ")";
                     if(String(obj.description).length > 0)
                     {
                        tooltipStr = tooltipStr + "<br><br>" + String(obj.description).replace("[valamount]",amount.toString()).replace("[valamount]",amount.toString());
                     }
                  }
               }
               break;
            case TOOLTIP_TYPE_PET:
               petArr = Central.main.PET_DATA.toArray();
               if(petArr)
               {
                  if(petArr.length > 0)
                  {
                     for(i = 0; i < petArr.length; i++)
                     {
                        if(Central.main.dataFilter(petArr[i]) == false)
                        {
                           return null;
                        }
                        if(petArr[i].id == id)
                        {
                           if(isLimited)
                           {
                              tooltipStr = String("<b>" + petArr[i].name + "</b>");
                              tooltipStr = tooltipStr + "<br><br><font color=\'#00FF99\'>" + String(Central.main.langLib.get(1605)[5]);
                              break;
                           }
                           tooltipStr = String("<b>" + petArr[i].name + "</b>");
                           tooltipStr = tooltipStr + "<br>(" + Central.main.langLib.titleTxt(TitleData.PET) + ")";
                           if(String(petArr[i].description).length > 0)
                           {
                              tooltipStr = tooltipStr + "<br><br>" + String(petArr[i].description);
                           }
                           break;
                        }
                     }
                  }
               }
         }
         return tooltipStr;
      }
      
      private static function getGearsetTooltip(itemObj:Object) : String
      {
         var i:int = 0;
         var tmpItemData:Object = null;
         var itemType:String = null;
         var equipedItem:String = null;
         var equipedCount:int = 0;
         var tooltipStr:String = "";
         var setObj:Object = Central.main.getMainChar().getGearset();
         var currGearset:String = "gearset" + itemObj.relate_set;
         var setData:Object = Central.main.GEAR_SET_DATA.find(currGearset);
         var totalGearSetNum:int = setObj[currGearset] ? int(setObj[currGearset]) : 0;
         var memberList:Array = setData.member_list;
         tooltipStr += "<br><br><b>" + setData.name + "(" + totalGearSetNum + "/" + (setData.effect.length + 1) + ")</b></br></br>";
         for(i = 0; i < memberList.length; i++)
         {
            tmpItemData = Central.main.toolkit.getItemDataByID(memberList[i]);
            if(tmpItemData !== null)
            {
               if(!(tmpItemData.gender != null && tmpItemData.gender != Central.main.getMainChar().getGender()))
               {
                  itemType = Central.main.toolkit.getItemType(memberList[i]);
                  equipedItem = "";
                  switch(itemType)
                  {
                     case InventoryData.TYPE_WEAPON:
                        equipedItem = Central.main.getMainChar().getWeapon();
                        break;
                     case InventoryData.TYPE_BACK_ITEM:
                        equipedItem = Central.main.getMainChar().getBackItem();
                        break;
                     case InventoryData.TYPE_HAIR:
                        equipedItem = Central.main.HAIR_DATA ? Central.main.toolkit.getIDBySubData("swfName",Central.main.getMainChar().getHair().replace("hair_",""),Central.main.HAIR_DATA) : "";
                        break;
                     case InventoryData.TYPE_BODY_SET:
                        equipedItem = Central.main.getMainChar().getBodySet();
                        break;
                     case InventoryData.TYPE_ACCESSORY:
                        equipedItem = Central.main.getMainChar().getAccessory();
                  }
                  if(equipedItem == memberList[i])
                  {
                     equipedCount++;
                     tooltipStr += "<br><font color=\'#33CC33\'><b>" + tmpItemData.name + "</b></font></br>";
                  }
                  else
                  {
                     tooltipStr += "<br><font color=\'#999999\'><b>" + tmpItemData.name + "</b></font></br>";
                  }
               }
            }
         }
         tooltipStr += "<br><br><b>" + (AppData.lang == AppData.ZH ? "套裝效果(" : "Set Effect(s)(") + (equipedCount > 0 ? equipedCount - 1 : 0) + "/" + setData.effect.length + ")</b></br></br>";
         for(i = 0; i < setData.effect.length; i++)
         {
            if(equipedCount - 1 > i)
            {
               tooltipStr += "<br><font color=\'#33CC33\'><b>" + getGearsetEffectDescription(setData.effect[i]) + "</b></font></br>";
            }
            else
            {
               tooltipStr += "<br><font color=\'#999999\'><b>" + getGearsetEffectDescription(setData.effect[i]) + "</b></font></br>";
            }
         }
         return tooltipStr;
      }
      
      private static function getExtraEffectTooltip(itemObj:Object) : String
      {
         var i:int = 0;
         var tooltipStr:String = "";
         var enemyName:String = "";
         tooltipStr += "<br><br><b>" + (AppData.lang == AppData.ZH ? "額外效果" : "Extra Effect") + "</b></br></br>";
         tooltipStr += "<br>" + (AppData.lang == AppData.ZH ? "有效目標:" : "Target Enemy:") + "</br>";
         for(i = 0; i < itemObj.extra_effect.enemy.length; i++)
         {
            enemyName += enemyName == "" ? Central.main.ENEMY_DATA.find(itemObj.extra_effect.enemy[i]).name : "/" + Central.main.ENEMY_DATA.find(itemObj.extra_effect.enemy[i]).name;
         }
         tooltipStr += "<br>" + enemyName + "</br>";
         tooltipStr += "<br><font color=\'#33CC33\'>" + getExtraEffectDescription(itemObj.extra_effect) + "</font></br>";
         return tooltipStr + ("<br><br>**" + (AppData.lang == AppData.ZH ? "以上額外效果只在 " + itemObj.extra_effect.event_name + " 期間生效**" : "Above extra effect only active during " + itemObj.extra_effect.event_name + " **") + "</br></br>");
      }
      
      private static function getSkillTypeName(skillType:String) : String
      {
         var i:int = 0;
         for(i = 0; i < ALL_NINJUTSU_TYPES.length; i++)
         {
            if(ALL_NINJUTSU_TYPES[i] == skillType)
            {
               return Central.main.langLib.btnTxt(SKILL_TYPE_BUTTON_NAME_ARR[i]);
            }
         }
         return null;
      }
   }
}

