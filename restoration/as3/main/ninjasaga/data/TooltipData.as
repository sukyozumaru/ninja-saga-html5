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
      
      private static function getEffectDescription(param1:Object) : String
      {
         var _loc2_:* = param1.amount;
         var _loc3_:* = param1.chance;
         var _loc4_:* = param1.duration;
         var _loc5_:String = Central.main.langLib.effectDataTxt(param1.type);
         if(!_loc5_)
         {
            return "[" + param1 + "]";
         }
         if(_loc2_ < 0)
         {
            _loc5_ = "<font color=\'#FF0000\'>" + _loc5_ + "</font>";
            _loc2_ *= -1;
            _loc5_ = _loc5_.replace("[increase]","[decrease]");
            _loc5_ = _loc5_.replace("[decrease]","[increase]");
            _loc5_ = _loc5_.replace("[up]","[down]");
            _loc5_ = _loc5_.replace("[down]","[up]");
         }
         else
         {
            _loc5_ = "<font color=\'#0000FF\'>" + _loc5_ + "</font>";
         }
         _loc5_ = _loc5_.replace("[chance]",_loc3_);
         _loc5_ = _loc5_.replace("[amount]",_loc2_);
         _loc5_ = _loc5_.replace("[100-amount]",100 - _loc2_);
         _loc5_ = _loc5_.replace("[duration]",_loc4_ - 1);
         _loc5_ = _loc5_.replace("[increase]",AppData.lang == AppData.ZH ? "增加" : "increase");
         _loc5_ = _loc5_.replace("[decrease]",AppData.lang == AppData.ZH ? "減少" : "decrease");
         _loc5_ = _loc5_.replace("[up]",AppData.lang == AppData.ZH ? "上升" : "");
         return _loc5_.replace("[down]",AppData.lang == AppData.ZH ? "下降" : "");
      }
      
      private static function getGearsetEffectDescription(param1:Object) : *
      {
         var _loc2_:String = Central.main.langLib.getGearsetText(param1.type);
         if(!_loc2_)
         {
            return "DEBUG: gearsetText[\"" + param1.type + "\"] not found";
         }
         _loc2_ = _loc2_.replace("[chance]",param1.chance);
         _loc2_ = _loc2_.replace("[duration]",param1.duration - 1);
         return _loc2_.replace("[amount]",param1.amount);
      }
      
      private static function getExtraEffectDescription(param1:Object) : *
      {
         var _loc2_:int = 0;
         var _loc3_:String = Central.main.langLib.getExtraEffectText(param1.type);
         var _loc4_:String = "";
         _loc2_ = 0;
         while(_loc2_ < param1.enemy.length)
         {
            _loc4_ += _loc4_ == "" ? Central.main.ENEMY_DATA.find(param1.enemy[_loc2_]).name : "/" + Central.main.ENEMY_DATA.find(param1.enemy[_loc2_]).name;
            _loc2_++;
         }
         if(!_loc3_)
         {
            return "";
         }
         _loc3_ = _loc3_.replace("[amount]",param1.amount);
         return _loc3_.replace("[enemy]",_loc4_);
      }
      
      public static function getItemTooltip(param1:String, param2:String, param3:String = "", param4:Object = null) : String
      {
         var _loc6_:Object = null;
         var _loc8_:Object = null;
         var _loc11_:int = 0;
         var _loc12_:int = 0;
         var _loc13_:String = null;
         var _loc14_:String = null;
         var _loc15_:int = 0;
         var _loc16_:int = 0;
         var _loc17_:* = undefined;
         var _loc18_:Object = null;
         var _loc20_:Object = null;
         var _loc21_:Array = null;
         var _loc22_:int = 0;
         var _loc23_:Object = null;
         var _loc24_:Object = null;
         var _loc25_:String = null;
         var _loc26_:String = null;
         var _loc27_:Array = null;
         var _loc28_:Array = null;
         var _loc29_:Array = null;
         var _loc30_:Object = null;
         var _loc31_:Object = null;
         var _loc32_:int = 0;
         var _loc33_:int = 0;
         var _loc34_:int = 0;
         var _loc5_:String = "";
         var _loc7_:String = "";
         var _loc9_:String = "";
         var _loc10_:Boolean = NinjaSaga.isTestMode;
         var _loc19_:Boolean = false;
         if(String(param3).length > 0)
         {
            _loc19_ = true;
         }
         _loc17_ = Central.main.getMainChar();
         switch(param1)
         {
            case TOOLTIP_TYPE_HAIR:
               _loc6_ = Central.main.HAIR_DATA.find(param2);
               if(_loc6_)
               {
                  if(Central.main.dataFilter(_loc6_) == false)
                  {
                     return null;
                  }
                  if(String(_loc6_.description).length > 0)
                  {
                     _loc5_ = String("<b>" + _loc6_.description + "</b>");
                     _loc5_ = _loc5_ + "<br>(" + String(Central.main.langLib.titleTxt(TitleData.HAIRSTYLE)).replace(":","") + ")";
                  }
                  if(Boolean(_loc6_.relate_set) && _loc6_.relate_set != "")
                  {
                     _loc5_ += getGearsetTooltip(_loc6_);
                  }
               }
               break;
            case TOOLTIP_TYPE_CLOTHING:
               _loc20_ = {};
               _loc20_ = _loc17_.getGender() == 0 ? Central.main.BODY_SET_BOY : Central.main.BODY_SET_GIRL;
               if(_loc20_[param2])
               {
                  _loc6_ = _loc20_[param2];
               }
               if(_loc6_)
               {
                  if(Central.main.dataFilter(_loc6_) == false)
                  {
                     return null;
                  }
                  if(_loc19_)
                  {
                     _loc5_ = String("<b>" + _loc6_.name + "</b>");
                     _loc5_ = _loc5_ + "<br><br>" + String(Central.main.langLib.get(1605)[0]);
                     _loc5_ = _loc5_ + "<br>" + param3 + "</font>";
                  }
                  else
                  {
                     _loc5_ = String("<b>" + _loc6_.name + "</b>");
                     _loc5_ = _loc5_ + "<br>(" + Central.main.langLib.titleTxt(TitleData.CLOTHING_TOOLTIP) + ")";
                     _loc5_ = _loc5_ + "<br><br>" + Central.main.langLib.titleTxt(TitleData.LEVEL) + ": " + _loc6_.level;
                     if(String(_loc6_.description).length > 0)
                     {
                        _loc5_ = _loc5_ + "<br><br>" + _loc6_.description;
                     }
                  }
                  if(Boolean(_loc6_.relate_set) && _loc6_.relate_set != "")
                  {
                     _loc5_ += getGearsetTooltip(_loc6_);
                  }
               }
               break;
            case TOOLTIP_TYPE_WEAPON:
               _loc6_ = Central.main.WEAPON_DATA.find(param2);
               if(_loc6_)
               {
                  if(Central.main.dataFilter(_loc6_) == false)
                  {
                     return null;
                  }
                  _loc12_ = int(Central.main.fetchAdjustedWeaponDamage(_loc6_));
                  _loc13_ = "";
                  _loc14_ = "";
                  if(Boolean(_loc6_.id == "wpn1596" && param4) && Boolean(param4.character != null) && param4.stoneCounter != null)
                  {
                     _loc12_ = int(Central.main.fetchAdjustedWeaponDamage(_loc6_,{
                        "character":param4.character,
                        "stoneCounter":param4.stoneCounter
                     }));
                     _loc13_ = AppData.lang == AppData.ZH ? "(等級 " + param4.stoneCounter + ")" : "(Level " + param4.stoneCounter + ")";
                     if(AppData.lang == AppData.ZH)
                     {
                        _loc14_ = "鑲嵌石： <font color=\'#00AA00\'><stone_amt></font><br>受已鑲嵌石影響，命中率增加 <font color=\'#00AA00\'><val1></font>%；該回合使用過武器攻擊，可增加 <font color=\'#00AA00\'><val2></font>%攻擊傷害，直到下回合完結；減免 <font color=\'#00AA00\'><val3></font>%所受傷害。武器傷害增加 <font color=\'#00AA00\'><val4></font>。另外，受持有者等級值影響，武器傷害增加 <font color=\'#00AA00\'><val5></font>。";
                     }
                     else
                     {
                        _loc14_ = "Implanted Stones: <font color=\'#00AA00\'><stone_amt></font><br>Due to the status of stones, increases accuracy by <font color=\'#00AA00\'><val1></font>%; increases attack damage by <font color=\'#00AA00\'><val2></font>% until the end of next turn after use; reduces <font color=\'#00AA00\'><val3></font>% damage received; weapon damage increases by <font color=\'#00AA00\'><val4></font>.  Furthermore, due to character level, weapon damage increased by <font color=\'#00AA00\'><val5></font>.";
                     }
                     _loc14_ = _loc14_.replace("<stone_amt>",param4.stoneCounter);
                     _loc14_ = _loc14_.replace("<val1>",17 + param4.stoneCounter * 8);
                     _loc14_ = _loc14_.replace("<val2>",15 + param4.stoneCounter * 5);
                     _loc14_ = _loc14_.replace("<val3>",5 + param4.stoneCounter * 5);
                     _loc14_ = _loc14_.replace("<val4>",param4.stoneCounter * 75);
                     _loc14_ = _loc14_.replace("<val5>",param4.character.getData(DBCharacterData.LEVEL));
                  }
                  if(_loc19_)
                  {
                     _loc5_ = String("<b>" + _loc6_.name + (_loc13_ ? " " + _loc13_ : "") + "</b>");
                     _loc5_ = _loc5_ + "<br><br><font color=\'#00FF99\'>" + String(Central.main.langLib.get(1605)[0]);
                     _loc5_ = _loc5_ + "<br>" + param3 + "</font>";
                  }
                  else
                  {
                     _loc5_ = String("<b>" + _loc6_.name + (_loc13_ ? " " + _loc13_ : "") + "</b>");
                     _loc5_ = _loc5_ + "<br>(" + Central.main.langLib.titleTxt(TitleData.WEAPON) + ")";
                     _loc5_ = _loc5_ + "<br><br>" + Central.main.langLib.titleTxt(TitleData.LEVEL) + ": " + _loc6_.level;
                     _loc5_ = _loc5_ + "<br><font color=\'#FF0000\'>" + Central.main.langLib.titleTxt(TitleData.DAMAGE) + ": " + _loc12_ + "</font>";
                     if(String(_loc6_.description).length > 0)
                     {
                        _loc5_ = _loc5_ + "<br><br>" + (_loc14_ == "" ? _loc6_.description : _loc14_);
                     }
                     if(Boolean(_loc6_.relate_set) && _loc6_.relate_set != "")
                     {
                        _loc5_ += getGearsetTooltip(_loc6_);
                     }
                     if(Boolean(_loc6_.extra_effect) && _loc6_.extra_effect != null)
                     {
                        _loc11_ = 0;
                        while(_loc11_ < _loc6_.extra_effect.enemy.length)
                        {
                           if(Central.main.extraData.activeEnemy.indexOf(_loc6_.extra_effect.enemy[_loc11_]) >= 0)
                           {
                              _loc5_ += getExtraEffectTooltip(_loc6_);
                              break;
                           }
                           _loc11_++;
                        }
                     }
                  }
               }
               break;
            case TOOLTIP_TYPE_BACKITEM:
               _loc6_ = Central.main.BACK_ITEM_DATA.find(param2);
               if(_loc6_)
               {
                  if(Central.main.dataFilter(_loc6_) == false)
                  {
                     return null;
                  }
                  if(_loc19_)
                  {
                     _loc5_ = String("<b>" + _loc6_.name + "</b>");
                     _loc5_ = _loc5_ + "<br><br><font color=\'#00FF99\'>" + String(Central.main.langLib.get(1605)[0]);
                     _loc5_ = _loc5_ + "<br>" + param3 + "</font>";
                  }
                  else
                  {
                     _loc5_ = String("<b>" + _loc6_.name + "</b>");
                     _loc5_ = _loc5_ + "<br>(" + Central.main.langLib.btnTxt(ButtonData.BACK_ITEM) + ")";
                     _loc5_ = _loc5_ + "<br><br>" + Central.main.langLib.titleTxt(TitleData.LEVEL) + ": " + _loc6_.level;
                     if(String(_loc6_.description).length > 0)
                     {
                        _loc5_ = _loc5_ + "<br><br>" + Central.main.langLib.titleTxt(TitleData.EFFECT) + ": " + _loc6_.description;
                     }
                     else
                     {
                        _loc5_ = _loc5_ + "<br><br>" + Central.main.langLib.titleTxt(TitleData.EFFECT) + ": -";
                     }
                     if(Boolean(_loc6_.relate_set) && _loc6_.relate_set != "")
                     {
                        _loc5_ += getGearsetTooltip(_loc6_);
                     }
                     if(Boolean(_loc6_.extra_effect) && _loc6_.extra_effect != null)
                     {
                        _loc11_ = 0;
                        while(_loc11_ < _loc6_.extra_effect.enemy.length)
                        {
                           if(Central.main.extraData.activeEnemy.indexOf(_loc6_.extra_effect.enemy[_loc11_]) >= 0)
                           {
                              _loc5_ += getExtraEffectTooltip(_loc6_);
                              break;
                           }
                           _loc11_++;
                        }
                     }
                  }
               }
               break;
            case TOOLTIP_TYPE_ACCESSORY:
               _loc6_ = Central.main.ACCESSORY_DATA.find(param2);
               if(_loc6_)
               {
                  if(Central.main.dataFilter(_loc6_) == false)
                  {
                     return null;
                  }
                  if(_loc19_)
                  {
                     _loc5_ = String("<b>" + _loc6_.name + "</b>");
                     _loc5_ = _loc5_ + "<br><br><font color=\'#00FF99\'>" + String(Central.main.langLib.get(1605)[0]);
                     _loc5_ = _loc5_ + "<br>" + param3 + "</font>";
                  }
                  else
                  {
                     _loc5_ = String("<b>" + _loc6_.name + "</b>");
                     _loc5_ = _loc5_ + "<br>(" + Central.main.langLib.titleTxt(TitleData.ACCESSORY) + ")";
                     _loc5_ = _loc5_ + "<br><br>" + Central.main.langLib.titleTxt(TitleData.LEVEL) + ": " + _loc6_.level;
                     if(String(_loc6_.description).length > 0)
                     {
                        _loc5_ = _loc5_ + "<br><br>" + Central.main.langLib.titleTxt(TitleData.EFFECT) + ": " + _loc6_.description;
                     }
                     else
                     {
                        _loc5_ = _loc5_ + "<br><br>" + Central.main.langLib.titleTxt(TitleData.EFFECT) + ": -";
                     }
                  }
                  if(Boolean(_loc6_.relate_set) && _loc6_.relate_set != "")
                  {
                     _loc5_ += getGearsetTooltip(_loc6_);
                  }
                  if(Boolean(_loc6_.extra_effect) && _loc6_.extra_effect != null)
                  {
                     _loc11_ = 0;
                     while(_loc11_ < _loc6_.extra_effect.enemy.length)
                     {
                        if(Central.main.extraData.activeEnemy.indexOf(_loc6_.extra_effect.enemy[_loc11_]) >= 0)
                        {
                           _loc5_ += getExtraEffectTooltip(_loc6_);
                           break;
                        }
                        _loc11_++;
                     }
                  }
               }
               break;
            case TOOLTIP_TYPE_ITEM:
               _loc6_ = Central.main.ITEM_DATA.find(param2);
               if(_loc6_)
               {
                  if(Central.main.dataFilter(_loc6_) == false)
                  {
                     return null;
                  }
                  if(_loc19_)
                  {
                     _loc5_ = String("<b>" + _loc6_.name + "</b>");
                     _loc5_ = _loc5_ + "<br><br><font color=\'#00FF99\'>" + String(Central.main.langLib.get(1605)[0]);
                     _loc5_ = _loc5_ + "<br>" + param3 + "</font>";
                  }
                  else
                  {
                     _loc5_ = String("<b>" + _loc6_.name + "</b>");
                     _loc5_ = _loc5_ + "<br>(" + Central.main.langLib.titleTxt(TitleData.ITEM) + ")";
                     _loc5_ = _loc5_ + "<br><br>" + Central.main.langLib.titleTxt(TitleData.LEVEL) + ": " + _loc6_.level;
                     if(String(_loc6_.description).length > 0)
                     {
                        _loc5_ = _loc5_ + "<br><br>" + _loc6_.description;
                     }
                  }
                  if(Boolean(_loc6_.extra_effect) && _loc6_.extra_effect != null)
                  {
                     Out.debug(null,"hihi");
                     _loc11_ = 0;
                     while(_loc11_ < _loc6_.extra_effect.enemy.length)
                     {
                        Out.debug(null,"hihi999");
                        if(Central.main.extraData.activeEnemy.indexOf(_loc6_.extra_effect.enemy[_loc11_]) >= 0)
                        {
                           Out.debug(null,"hihi333");
                           _loc5_ += getExtraEffectTooltip(_loc6_);
                           break;
                        }
                        _loc11_++;
                     }
                  }
               }
               break;
            case TOOLTIP_TYPE_ESSENCE:
               _loc6_ = Central.main.ESSENCE_DATA.find(param2);
               if(_loc6_)
               {
                  if(Central.main.dataFilter(_loc6_) == false)
                  {
                     return null;
                  }
                  if(_loc19_)
                  {
                     _loc5_ = String("<b>" + _loc6_.name + "</b>");
                     _loc5_ = _loc5_ + "<br><br><font color=\'#00FF99\'>" + String(Central.main.langLib.get(1605)[0]);
                     _loc5_ = _loc5_ + "<br>" + param3 + "</font>";
                  }
                  else
                  {
                     _loc5_ = String("<b>" + _loc6_.name + "</b>");
                     _loc5_ = _loc5_ + "<br>(" + Central.main.langLib.titleTxt(TitleData.NINJA_ESSENCE) + ")";
                     if(String(_loc6_.description).length > 0)
                     {
                        _loc5_ = _loc5_ + "<br><br>" + _loc6_.description;
                     }
                  }
               }
               break;
            case TOOLTIP_TYPE_MATERIAL:
               _loc6_ = Central.main.MATERIAL_DATA.find(param2);
               if(_loc6_)
               {
                  if(Central.main.dataFilter(_loc6_) == false)
                  {
                     return null;
                  }
                  if(_loc19_)
                  {
                     _loc5_ = String("<b>" + _loc6_.name + "</b>");
                     _loc5_ = _loc5_ + "<br><br><font color=\'#00FF99\'>" + String(Central.main.langLib.get(1605)[0]);
                     _loc5_ = _loc5_ + "<br>" + param3 + "</font>";
                  }
                  else
                  {
                     _loc5_ = String("<b>" + _loc6_.name + "</b>");
                     _loc5_ = _loc5_ + "<br>(" + Central.main.langLib.titleTxt(TitleData.MATERIAL) + ")";
                     if(String(_loc6_.description).length > 0)
                     {
                        _loc5_ = _loc5_ + "<br><br>" + _loc6_.description;
                     }
                  }
               }
               break;
            case TOOLTIP_TYPE_CURRENCY:
               _loc6_ = Central.main.CURRENCY_DATA.find(param2);
               if(_loc6_)
               {
                  if(Central.main.dataFilter(_loc6_) == false)
                  {
                     return null;
                  }
                  if(_loc19_)
                  {
                     _loc5_ = String("<b>" + _loc6_.name + "</b>");
                     _loc5_ = _loc5_ + "<br><br><font color=\'#00FF99\'>" + String(Central.main.langLib.get(1605)[0]);
                     _loc5_ = _loc5_ + "<br>" + param3 + "</font>";
                  }
                  else
                  {
                     _loc5_ = String("<b>" + _loc6_.name + "</b>");
                     if(String(_loc6_.description).length > 0)
                     {
                        _loc5_ = _loc5_ + "<br><br>" + _loc6_.description;
                     }
                  }
               }
               break;
            case TOOLTIP_TYPE_SKILL:
               if(Central.main.SKILL_DATA[param2])
               {
                  _loc6_ = Central.main.SKILL_DATA[param2];
               }
               if(_loc6_)
               {
                  if(Central.main.dataFilter(_loc6_) == false)
                  {
                     return null;
                  }
                  if(_loc19_)
                  {
                     _loc5_ = String("<b>" + _loc6_.name + "</b>");
                     _loc5_ = _loc5_ + "<br><br><font color=\'#00FF99\'>" + String(param3);
                  }
                  else
                  {
                     _loc7_ = getSkillTypeName(_loc6_.type);
                     _loc22_ = int(_loc6_.damage);
                     if(_loc6_.skill_hit_num >= 2)
                     {
                        _loc22_ = Math.round(_loc6_.damage * _loc6_.skill_hit_num);
                     }
                     _loc5_ = String("<b>" + _loc6_.name + "</b>");
                     _loc5_ = _loc5_ + "<br>(" + _loc7_ + ")";
                     _loc5_ = _loc5_ + "<br><br>" + Central.main.langLib.titleTxt(TitleData.LEVEL) + ": " + _loc6_.level;
                     _loc16_ = int(_loc6_.id.replace(/skill/,""));
                     _loc15_ = int(_loc6_.cp);
                     if(_loc6_.effect != null)
                     {
                        if(_loc6_.effect.type == BattleData.EFFECT_CLEAR_BUFF_N_INTERNAL_INJURY_THANOS && _loc17_.getWeapon() == "wpn1596")
                        {
                           _loc15_ = 400;
                        }
                     }
                     if(_loc6_.effect != null)
                     {
                        if(_loc6_.effect.type == BattleData.EFFECT_DAMAGE_BONUS_FIX_NUM_THANOS && _loc17_.getWeapon() == "wpn1596")
                        {
                           _loc15_ = 200;
                        }
                     }
                     if(_loc17_.isBattleBuffActive(BattleData.EFFECT_EXCITATION_CP))
                     {
                        _loc15_ = 0;
                     }
                     if(_loc17_.isBattleBuffActive(BattleData.EFFECT_CP_LOCK))
                     {
                        _loc15_ = 0;
                     }
                     if(_loc17_.isBattleBuffActive(BattleData.EFFECT_REDUCE_SELF_CP_CONSUME))
                     {
                        _loc15_ = Math.round(_loc15_ * (1 - int(_loc17_.getBattleBuff()[BattleData.EFFECT_REDUCE_SELF_CP_CONSUME].amount) / 100));
                     }
                     if(_loc17_.isBattleBuffActive(BattleData.EFFECT_REDUCE_CP_REQUIRE))
                     {
                        _loc15_ = Math.round(_loc15_ * (int(_loc17_.getBattleBuff()[BattleData.EFFECT_REDUCE_CP_REQUIRE].amount) / 100));
                     }
                     if(_loc17_.isBattleBuffActive(BattleData.EFFECT_PET_SAVE_CP))
                     {
                        _loc15_ = Math.round(_loc15_ * (1 - _loc17_.getBattleBuff()[BattleData.EFFECT_PET_SAVE_CP].amount / 100));
                     }
                     if(_loc17_.getBackItem())
                     {
                        _loc23_ = Central.main.BACK_ITEM_DATA.find(_loc17_.getBackItem()).effect;
                        for each(_loc18_ in _loc23_)
                        {
                           switch(_loc18_.type)
                           {
                              case BattleData.EFFECT_REDUCE_CP_REQUIRE:
                                 if(_loc18_.chance == 100)
                                 {
                                    _loc15_ = Math.round(_loc15_ * (1 - _loc23_.amount * 0.01));
                                 }
                           }
                        }
                     }
                     if(_loc17_.getWeapon())
                     {
                        _loc24_ = Central.main.WEAPON_DATA.find(_loc17_.getWeapon()).effect;
                        for each(_loc18_ in _loc24_)
                        {
                           switch(_loc18_.type)
                           {
                              case BattleData.EFFECT_REDUCE_CP_REQUIRE:
                                 if(_loc18_.amount > 0)
                                 {
                                    _loc15_ = Math.round(_loc15_ * (_loc18_.amount / 100));
                                 }
                           }
                        }
                     }
                     if(_loc17_.isBattleDebuffActive(BattleData.SKILL_341))
                     {
                        _loc15_ = Math.round(_loc15_ * (int(_loc17_.getBattleDebuff()[BattleData.SKILL_341].amount) / 100));
                     }
                     if(_loc17_.isBattleDebuffActive(BattleData.EFFECT_CUBE_ILLUSION))
                     {
                        _loc15_ = Math.round(_loc15_ * 1.4);
                     }
                     if(_loc17_.isBattleDebuffActive(BloodlineData.EFFECT_EXTRA_CP_USE))
                     {
                        _loc15_ = Math.round(_loc15_ * 2);
                     }
                     if(_loc17_.isBattleDebuffActive(BattleData.EFFECT_TRANSFORM))
                     {
                        _loc15_ = Math.round(_loc15_ * 3);
                     }
                     if(_loc17_.isBattleDebuffActive(BattleData.EFFECT_CP_BLEEDING))
                     {
                        _loc15_ = Math.round(_loc15_ * (int(_loc17_.getBattleDebuff()[BattleData.EFFECT_CP_BLEEDING].amount) * 0.01));
                     }
                     _loc5_ = _loc5_ + "<br><font color=\'#0000FF\'>" + Central.main.langLib.titleTxt(TitleData.CHAKRA) + ": " + _loc15_ + "</font>";
                     if(Boolean(_loc6_.effect) && _loc6_.effect.type == SkillData.EFFECT_TYPE_HEAL)
                     {
                        _loc5_ = _loc5_ + "<br><font color=\'#33CC33\'>" + Central.main.langLib.titleTxt(TitleData.HEAL) + ": " + _loc22_ + "</font>";
                     }
                     else
                     {
                        _loc5_ = _loc5_ + "<br><font color=\'#FF0000\'>" + Central.main.langLib.titleTxt(TitleData.DAMAGE) + ": " + _loc22_ + "</font>";
                     }
                     _loc5_ = _loc5_ + "<br>" + Central.main.langLib.titleTxt(TitleData.COOLDOWN) + ": " + _loc6_.cooldown;
                     if(String(_loc6_.description).length > 0)
                     {
                        _loc5_ = _loc5_ + "<br><br>" + _loc6_.description;
                     }
                     if(Boolean(_loc6_.extra_effect) && _loc6_.extra_effect != null)
                     {
                        _loc11_ = 0;
                        while(_loc11_ < _loc6_.extra_effect.enemy.length)
                        {
                           if(Central.main.extraData.activeEnemy.indexOf(_loc6_.extra_effect.enemy[_loc11_]) >= 0)
                           {
                              _loc5_ += getExtraEffectTooltip(_loc6_);
                              break;
                           }
                           _loc11_++;
                        }
                     }
                  }
               }
               break;
            case TOOLTIP_TYPE_SENJUTSU:
               if(Central.main.SENJUTSU_SKILL_DATA[param2])
               {
                  _loc6_ = Central.main.SENJUTSU_SKILL_DATA[param2];
               }
               if(_loc6_)
               {
                  if(Central.main.dataFilter(_loc6_) == false)
                  {
                     return null;
                  }
                  if(_loc19_)
                  {
                     _loc5_ = String("<b>" + _loc6_.name + "</b>");
                     _loc5_ = _loc5_ + "<br><br><font color=\'#00FF99\'>" + String(param3);
                  }
                  else
                  {
                     _loc25_ = "";
                     _loc26_ = "";
                     _loc27_ = [];
                     _loc28_ = [];
                     _loc29_ = [];
                     _loc30_ = _loc6_;
                     _loc31_ = _loc6_.effect[0];
                     if(param2 == "senjutsu_skill3000")
                     {
                        _loc31_.skill_sp = _loc17_.maxSP;
                     }
                     _loc5_ = String("<b>" + _loc30_.name + "</b>");
                     if(_loc30_.senjutsu_type == SenjutsuData.SKILL_TYPE_PASSIVE)
                     {
                        _loc5_ = _loc5_ + "<br><font color=\'#CC9900\'>(" + Central.main.langLib.titleTxt(TitleData.PASSIVE) + " " + Central.main.langLib.titleTxt(TitleData.SKILL) + ")</font>";
                        _loc5_ = _loc5_ + "<br><br><font color=\'#FF0000\'>" + Central.main.langLib.titleTxt(TitleData.DAMAGE) + ": -</font>";
                        _loc5_ = _loc5_ + "<br><font color=\'#FF5300\'>" + Central.main.langLib.titleTxt(TitleData.SP) + ": -</font>";
                        _loc5_ = _loc5_ + "<br><font color=\'#CC9900\'>" + Central.main.langLib.titleTxt(TitleData.COOLDOWN) + ": -</font>";
                     }
                     else
                     {
                        if(_loc31_.skill_damage == 0)
                        {
                           _loc5_ = _loc5_ + "<br><br><font color=\'#FF0000\'>" + Central.main.langLib.titleTxt(TitleData.DAMAGE) + ": -</font>";
                        }
                        else
                        {
                           _loc5_ = _loc5_ + "<br><br><font color=\'#FF0000\'>" + Central.main.langLib.titleTxt(TitleData.DAMAGE) + ": " + String(_loc31_.skill_damage) + "</font>";
                        }
                        if(_loc31_.skill_sp == 0)
                        {
                           _loc5_ = _loc5_ + "<br><font color=\'#FF5300\'>" + Central.main.langLib.titleTxt(TitleData.SP) + ": -</font>";
                        }
                        else
                        {
                           _loc5_ = _loc5_ + "<br><font color=\'#FF5300\'>" + Central.main.langLib.titleTxt(TitleData.SP) + ": " + String(_loc31_.skill_sp) + "</font>";
                        }
                        _loc5_ = _loc5_ + "<br><font color=\'#CC9900\'>" + Central.main.langLib.titleTxt(TitleData.COOLDOWN) + ": " + String(_loc30_.cooldown) + "</font>";
                     }
                     _loc25_ = _loc30_.tooltip;
                     if(String(_loc31_.effect_requirement_1).length > 0)
                     {
                        _loc27_ = _loc31_.effect_requirement_1.split("|");
                     }
                     if(String(_loc31_.effect_requirement_2).length > 0)
                     {
                        _loc28_ = _loc31_.effect_requirement_2.split("|");
                     }
                     if(String(_loc31_.effect_requirement_3).length > 0)
                     {
                        _loc29_ = _loc31_.effect_requirement_3.split("|");
                     }
                     _loc25_ = String(_loc25_).replace(/\[valCHANCETOEFFECT_1\]/g,Math.abs(_loc31_.effect_chancetoeffect_1));
                     _loc25_ = String(_loc25_).replace(/\[valCHANCETOEFFECT_2\]/g,Math.abs(_loc31_.effect_chancetoeffect_2));
                     _loc25_ = String(_loc25_).replace(/\[valCHANCETOEFFECT_3\]/g,Math.abs(_loc31_.effect_chancetoeffect_3));
                     _loc25_ = String(_loc25_).replace(/\[valCHANCETOHIT_1\]/g,Math.abs(_loc31_.effect_chancetohit_1));
                     _loc25_ = String(_loc25_).replace(/\[valCHANCETOHIT_2\]/g,Math.abs(_loc31_.effect_chancetohit_2));
                     _loc25_ = String(_loc25_).replace(/\[valCHANCETOHIT_3\]/g,Math.abs(_loc31_.effect_chancetohit_3));
                     _loc25_ = String(_loc25_).replace(/\[valAMOUNT_1\]/g,Math.abs(_loc31_.effect_amount_1));
                     _loc25_ = String(_loc25_).replace(/\[valAMOUNT_2\]/g,Math.abs(_loc31_.effect_amount_2));
                     _loc25_ = String(_loc25_).replace(/\[valAMOUNT_3\]/g,Math.abs(_loc31_.effect_amount_3));
                     _loc25_ = String(_loc25_).replace(/\[val100minusAMOUNT_1\]/g,String(100 - Number(_loc31_.effect_amount_1)));
                     _loc25_ = String(_loc25_).replace(/\[val100minusAMOUNT_2\]/g,String(100 - Number(_loc31_.effect_amount_2)));
                     _loc25_ = String(_loc25_).replace(/\[val100minusAMOUNT_3\]/g,String(100 - Number(_loc31_.effect_amount_3)));
                     _loc25_ = String(_loc25_).replace(/\[val100plusAMOUNT_1\]/g,String(100 + Number(_loc31_.effect_amount_1)));
                     _loc25_ = String(_loc25_).replace(/\[val100plusAMOUNT_2\]/g,String(100 + Number(_loc31_.effect_amount_2)));
                     _loc25_ = String(_loc25_).replace(/\[val100plusAMOUNT_3\]/g,String(100 + Number(_loc31_.effect_amount_3)));
                     _loc25_ = String(_loc25_).replace(/\[valTURN_1\]/g,Math.abs(int(_loc31_.duration_1) - 1));
                     _loc25_ = String(_loc25_).replace(/\[valTURN_2\]/g,Math.abs(int(_loc31_.duration_2) - 1));
                     _loc25_ = String(_loc25_).replace(/\[valTURN_3\]/g,Math.abs(int(_loc31_.duration_3) - 1));
                     _loc25_ = String(_loc25_).replace(/\[valDAMAGE\]/g,Math.abs(_loc31_.skill_damage));
                     _loc25_ = String(_loc25_).replace(/\[valLEVEL\]/g,Math.abs(_loc31_.skill_level));
                     if(_loc27_.length > 0)
                     {
                        _loc25_ = String(_loc25_).replace(/\[valreqAMOUNT_1\]/g,Math.abs(_loc27_[3]));
                     }
                     if(_loc28_.length > 0)
                     {
                        _loc25_ = String(_loc25_).replace(/\[valreqAMOUNT_2\]/g,Math.abs(_loc28_[3]));
                     }
                     if(_loc29_.length > 0)
                     {
                        _loc25_ = String(_loc25_).replace(/\[valreqAMOUNT_3\]/g,Math.abs(_loc29_[3]));
                     }
                     if(_loc25_ == "")
                     {
                        _loc5_ = String("<font size=\'13\'>" + _loc5_ + "</font>");
                     }
                     else
                     {
                        _loc5_ = String("<font size=\'13\'>" + _loc5_ + "<br>" + _loc25_ + "</font>");
                     }
                  }
               }
               break;
            case TOOLTIP_TYPE_SKILL_CLASS:
               if(Central.main.SKILL_DATA[param2])
               {
                  _loc6_ = Central.main.SKILL_DATA[param2];
               }
               if(_loc6_)
               {
                  if(Central.main.dataFilter(_loc6_) == false)
                  {
                     return null;
                  }
                  if(_loc19_)
                  {
                     _loc5_ = String("<b>" + _loc6_.name + "</b>");
                     _loc5_ = _loc5_ + "<br><br><font color=\'#00FF99\'>" + String(Central.main.langLib.get(1605)[0]);
                     _loc5_ = _loc5_ + "<br>" + param3 + "</font>";
                  }
                  else
                  {
                     _loc34_ = int(_loc6_.special_class);
                     _loc7_ = String(Central.main.langLib.get(1580)[_loc34_ - 1]);
                     switch(param2)
                     {
                        case "skill2004":
                           _loc32_ = int(_loc17_.getLevel()) - 60;
                           if(_loc32_ < 0)
                           {
                              _loc32_ = 0;
                           }
                           _loc33_ = 700 + _loc32_ * 64;
                           break;
                        case "skill2000":
                           _loc32_ = int(_loc17_.getLevel()) - 60;
                           if(_loc32_ < 0)
                           {
                              _loc32_ = 0;
                           }
                           _loc33_ = 1000 + _loc32_ * 70;
                     }
                     _loc5_ = String("<b>" + _loc6_.name + "</b>");
                     _loc5_ = _loc5_ + "<br>(" + _loc7_ + ")";
                     if(String(_loc6_.description).length > 0)
                     {
                        _loc5_ = _loc5_ + "<br><br>" + String(_loc6_.description).replace("[valamount]",_loc33_.toString()).replace("[valamount]",_loc33_.toString());
                     }
                  }
               }
               break;
            case TOOLTIP_TYPE_PET:
               _loc21_ = Central.main.PET_DATA.toArray();
               if(_loc21_)
               {
                  if(_loc21_.length > 0)
                  {
                     _loc11_ = 0;
                     while(_loc11_ < _loc21_.length)
                     {
                        if(Central.main.dataFilter(_loc21_[_loc11_]) == false)
                        {
                           return null;
                        }
                        if(_loc21_[_loc11_].id == param2)
                        {
                           if(_loc19_)
                           {
                              _loc5_ = String("<b>" + _loc21_[_loc11_].name + "</b>");
                              _loc5_ = _loc5_ + "<br><br><font color=\'#00FF99\'>" + String(Central.main.langLib.get(1605)[5]);
                              break;
                           }
                           _loc5_ = String("<b>" + _loc21_[_loc11_].name + "</b>");
                           _loc5_ = _loc5_ + "<br>(" + Central.main.langLib.titleTxt(TitleData.PET) + ")";
                           if(String(_loc21_[_loc11_].description).length > 0)
                           {
                              _loc5_ = _loc5_ + "<br><br>" + String(_loc21_[_loc11_].description);
                           }
                           break;
                        }
                        _loc11_++;
                     }
                  }
               }
         }
         return _loc5_;
      }
      
      private static function getGearsetTooltip(param1:Object) : String
      {
         var _loc2_:int = 0;
         var _loc10_:Object = null;
         var _loc11_:String = null;
         var _loc12_:String = null;
         var _loc3_:int = 0;
         var _loc4_:String = "";
         var _loc5_:Object = Central.main.getMainChar().getGearset();
         var _loc6_:String = "gearset" + param1.relate_set;
         var _loc7_:Object = Central.main.GEAR_SET_DATA.find(_loc6_);
         var _loc8_:int = _loc5_[_loc6_] ? int(_loc5_[_loc6_]) : 0;
         var _loc9_:Array = _loc7_.member_list;
         _loc4_ += "<br><br><b>" + _loc7_.name + "(" + _loc8_ + "/" + (_loc7_.effect.length + 1) + ")</b></br></br>";
         _loc2_ = 0;
         while(_loc2_ < _loc9_.length)
         {
            _loc10_ = Central.main.toolkit.getItemDataByID(_loc9_[_loc2_]);
            if(_loc10_ !== null)
            {
               if(!(_loc10_.gender != null && _loc10_.gender != Central.main.getMainChar().getGender()))
               {
                  _loc11_ = Central.main.toolkit.getItemType(_loc9_[_loc2_]);
                  _loc12_ = "";
                  switch(_loc11_)
                  {
                     case InventoryData.TYPE_WEAPON:
                        _loc12_ = Central.main.getMainChar().getWeapon();
                        break;
                     case InventoryData.TYPE_BACK_ITEM:
                        _loc12_ = Central.main.getMainChar().getBackItem();
                        break;
                     case InventoryData.TYPE_HAIR:
                        _loc12_ = Central.main.HAIR_DATA ? Central.main.toolkit.getIDBySubData("swfName",Central.main.getMainChar().getHair().replace("hair_",""),Central.main.HAIR_DATA) : "";
                        break;
                     case InventoryData.TYPE_BODY_SET:
                        _loc12_ = Central.main.getMainChar().getBodySet();
                        break;
                     case InventoryData.TYPE_ACCESSORY:
                        _loc12_ = Central.main.getMainChar().getAccessory();
                  }
                  if(_loc12_ == _loc9_[_loc2_])
                  {
                     _loc3_++;
                     _loc4_ += "<br><font color=\'#33CC33\'><b>" + _loc10_.name + "</b></font></br>";
                  }
                  else
                  {
                     _loc4_ += "<br><font color=\'#999999\'><b>" + _loc10_.name + "</b></font></br>";
                  }
               }
            }
            _loc2_++;
         }
         _loc4_ += "<br><br><b>" + (AppData.lang == AppData.ZH ? "套裝效果(" : "Set Effect(s)(") + (_loc3_ > 0 ? _loc3_ - 1 : 0) + "/" + _loc7_.effect.length + ")</b></br></br>";
         _loc2_ = 0;
         while(_loc2_ < _loc7_.effect.length)
         {
            if(_loc3_ - 1 > _loc2_)
            {
               _loc4_ += "<br><font color=\'#33CC33\'><b>" + getGearsetEffectDescription(_loc7_.effect[_loc2_]) + "</b></font></br>";
            }
            else
            {
               _loc4_ += "<br><font color=\'#999999\'><b>" + getGearsetEffectDescription(_loc7_.effect[_loc2_]) + "</b></font></br>";
            }
            _loc2_++;
         }
         return _loc4_;
      }
      
      private static function getExtraEffectTooltip(param1:Object) : String
      {
         var _loc2_:int = 0;
         var _loc3_:String = "";
         var _loc4_:String = "";
         _loc3_ += "<br><br><b>" + (AppData.lang == AppData.ZH ? "額外效果" : "Extra Effect") + "</b></br></br>";
         _loc3_ += "<br>" + (AppData.lang == AppData.ZH ? "有效目標:" : "Target Enemy:") + "</br>";
         _loc2_ = 0;
         while(_loc2_ < param1.extra_effect.enemy.length)
         {
            _loc4_ += _loc4_ == "" ? Central.main.ENEMY_DATA.find(param1.extra_effect.enemy[_loc2_]).name : "/" + Central.main.ENEMY_DATA.find(param1.extra_effect.enemy[_loc2_]).name;
            _loc2_++;
         }
         _loc3_ += "<br>" + _loc4_ + "</br>";
         _loc3_ += "<br><font color=\'#33CC33\'>" + getExtraEffectDescription(param1.extra_effect) + "</font></br>";
         return _loc3_ + ("<br><br>**" + (AppData.lang == AppData.ZH ? "以上額外效果只在 " + param1.extra_effect.event_name + " 期間生效**" : "Above extra effect only active during " + param1.extra_effect.event_name + " **") + "</br></br>");
      }
      
      private static function getSkillTypeName(param1:String) : String
      {
         var _loc2_:int = 0;
         _loc2_ = 0;
         while(_loc2_ < ALL_NINJUTSU_TYPES.length)
         {
            if(ALL_NINJUTSU_TYPES[_loc2_] == param1)
            {
               return Central.main.langLib.btnTxt(SKILL_TYPE_BUTTON_NAME_ARR[_loc2_]);
            }
            _loc2_++;
         }
         return null;
      }
   }
}

