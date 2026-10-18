package ninjasaga.data
{
   import com.utils.NumberUtil;
   import com.utils.Out;
   import de.polygonal.ds.HashMap;
   import flash.display.*;
   import flash.net.NetConnection;
   import flash.utils.Timer;
   import gs.*;
   import gs.plugins.*;
   import ninjasaga.Central;
   
   public final class Formula
   {
      
      public function Formula()
      {
         super();
      }
      
      public static function calcDamage(param1:Object, param2:Object = null) : int
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         _loc7_ = 0;
         if(Boolean(param1.id == "wpn1596") && Boolean(param2) && Boolean(param2.character))
         {
            _loc4_ = int(Central.main.stateInventory.getStateOnCount(param2.character.getCharacterId(),"wpn","wpn1596"));
            if(_loc4_ >= 0)
            {
               _loc3_ = _loc4_;
            }
            _loc7_ += _loc3_ * 75;
            _loc7_ = _loc7_ + param2.character.getData(DBCharacterData.LEVEL);
         }
         _loc6_ = param1.damage + _loc7_;
         return randomizeValue(_loc6_);
      }
      
      public static function randomizeValue(param1:int) : int
      {
         var _loc2_:Number = 0.2;
         var _loc3_:Number = param1 - param1 * _loc2_;
         var _loc4_:Number = param1 + param1 * _loc2_;
         return Math.round(NumberUtil.randomNumber(_loc3_,_loc4_));
      }
      
      public static function calcAgility(param1:*, param2:Array = null, param3:Array = null) : int
      {
         var _loc8_:Object = null;
         var _loc9_:Object = null;
         var _loc10_:Object = null;
         var _loc11_:Object = null;
         var _loc12_:Object = null;
         var _loc13_:String = null;
         var _loc14_:Object = null;
         var _loc15_:Object = null;
         var _loc16_:Array = null;
         var _loc17_:int = 0;
         var _loc18_:int = 0;
         var _loc19_:int = 0;
         var _loc20_:int = 0;
         var _loc21_:Array = null;
         var _loc22_:int = 0;
         var _loc23_:Array = null;
         var _loc4_:int = int(param1.getData(DBCharacterData.AGILITY)) + int((param1.getData(DBCharacterData.LEVEL) - 1) * Data.LEVEL_INC_AGILITY) + int(param1.getData(DBCharacterData.WIND));
         var _loc5_:Object = param1.getBattleBuff();
         if(_loc5_[BattleData.EFFECT_AGILITY_BONUS])
         {
            if(_loc5_[BattleData.EFFECT_AGILITY_BONUS].duration > 0)
            {
               _loc4_ += int(_loc5_[BattleData.EFFECT_AGILITY_BONUS].amount);
            }
         }
         if(param1.isBattleDebuffActive(BattleData.EFFECT_AGI_REDUCTION))
         {
            _loc4_ -= Math.round(_loc4_ * int(param1.getBattleDebuff()[BattleData.EFFECT_AGI_REDUCTION].amount));
         }
         if(param1.getBackItem())
         {
            _loc9_ = Central.main.BACK_ITEM_DATA.find(param1.getBackItem());
            if(_loc9_)
            {
               for each(_loc8_ in _loc9_.effect)
               {
                  switch(_loc8_.type)
                  {
                     case "effect_agility":
                        _loc4_ += _loc8_.amount;
                  }
               }
            }
         }
         if(param1.getWeapon())
         {
            _loc10_ = Central.main.WEAPON_DATA.find(param1.getWeapon());
            if(_loc10_)
            {
               for each(_loc8_ in _loc10_.effect)
               {
                  switch(_loc8_.type)
                  {
                     case "effect_agility":
                        _loc4_ += _loc8_.amount;
                  }
               }
            }
         }
         if(param1.getAccessory())
         {
            _loc11_ = Central.main.ACCESSORY_DATA.find(param1.getAccessory());
            if(_loc11_)
            {
               for each(_loc8_ in _loc11_.effect)
               {
                  switch(_loc8_.type)
                  {
                     case "effect_agility":
                        _loc4_ += _loc8_.amount;
                  }
               }
            }
         }
         if(param1.getGearset())
         {
            _loc12_ = param1.getGearset();
            for(_loc13_ in _loc12_)
            {
               _loc14_ = Central.main.GEAR_SET_DATA.find(_loc13_);
               _loc17_ = 0;
               while(_loc17_ < _loc12_[_loc13_] - 1)
               {
                  _loc15_ = _loc14_.effect[_loc17_];
                  switch(_loc15_.type)
                  {
                     case "effect_agility":
                        _loc4_ += _loc15_.amount;
                  }
                  _loc17_++;
               }
            }
         }
         var _loc6_:int = 0;
         if(Boolean(param2) && (String(param1.constructor) == "[class Character]" || String(param1.constructor) == "[class PvPCharacter]" || String(param1.constructor) == "[class AICharacter]"))
         {
            _loc16_ = param1.getData(DBCharacterData.BLOODLINE_SKILL);
            if(_loc16_)
            {
               _loc17_ = 0;
               for(; _loc17_ < _loc16_.length; _loc17_++)
               {
                  _loc18_ = int(_loc16_[_loc17_].skill_id);
                  _loc19_ = int(_loc16_[_loc17_].level);
                  _loc20_ = 0;
                  while(_loc20_ < param2.length)
                  {
                     if(param2[_loc20_].skill_id == String("skill" + _loc18_) && param2[_loc20_].bloodline_type == BloodlineData.SKILL_TYPE_PASSIVE)
                     {
                        _loc21_ = param2[_loc20_].effect;
                        _loc22_ = 0;
                        while(_loc22_ < _loc21_.length)
                        {
                           if(_loc21_[_loc22_].skill_level == _loc19_)
                           {
                              if(_loc21_[_loc22_].effect_type_1 == BloodlineData.EFFECT_SPEED)
                              {
                                 _loc6_ += Math.round(_loc21_[_loc22_].effect_amount_1 / 100 * _loc4_);
                              }
                              if(_loc21_[_loc22_].effect_type_2 == BloodlineData.EFFECT_SPEED)
                              {
                                 _loc6_ += Math.round(_loc21_[_loc22_].effect_amount_2 / 100 * _loc4_);
                              }
                              if(_loc21_[_loc22_].effect_type_3 == BloodlineData.EFFECT_SPEED)
                              {
                                 _loc6_ += Math.round(_loc21_[_loc22_].effect_amount_3 / 100 * _loc4_);
                              }
                           }
                           _loc22_++;
                        }
                        break;
                     }
                     _loc20_++;
                  }
               }
            }
         }
         var _loc7_:int = 0;
         if(Boolean(param3) && (String(param1.constructor) == "[class Character]" || String(param1.constructor) == "[class PvPCharacter]" || String(param1.constructor) == "[class AICharacter]"))
         {
            _loc23_ = param1.getData(DBCharacterData.SENJUTSU_SKILL);
            if(_loc23_)
            {
               _loc17_ = 0;
               for(; _loc17_ < _loc23_.length; _loc17_++)
               {
                  _loc18_ = int(_loc23_[_loc17_].skill_id);
                  _loc19_ = int(_loc23_[_loc17_].level);
                  _loc20_ = 0;
                  while(_loc20_ < param3.length)
                  {
                     if(param3[_loc20_].skill_id == String("skill" + _loc18_) && param3[_loc20_].senjutsu_type == SenjutsuData.SKILL_TYPE_PASSIVE)
                     {
                        _loc21_ = param3[_loc20_].effect;
                        _loc22_ = 0;
                        while(_loc22_ < _loc21_.length)
                        {
                           if(_loc21_[_loc22_].skill_level == _loc19_)
                           {
                           }
                           _loc22_++;
                        }
                        break;
                     }
                     _loc20_++;
                  }
               }
            }
         }
         return int(_loc4_ + _loc6_ + _loc7_);
      }
      
      public static function calcCritical(param1:*, param2:Array = null, param3:Array = null) : Number
      {
         var _loc9_:String = null;
         var _loc12_:Number = NaN;
         var _loc13_:int = 0;
         var _loc14_:Array = null;
         var _loc15_:int = 0;
         var _loc16_:int = 0;
         var _loc17_:int = 0;
         var _loc18_:int = 0;
         var _loc19_:Array = null;
         var _loc20_:int = 0;
         var _loc21_:Array = null;
         var _loc4_:Number = Central.main.coreData.BASE_CRITICAL_CHANCE + Number(int(param1.getData(DBCharacterData.LIGHTNING)) * 4 / 1000);
         var _loc5_:Object = param1.getBattleBuff();
         if(_loc5_[BattleData.EFFECT_CRITICAL_CHANCE_BONUS])
         {
            if(_loc5_[BattleData.EFFECT_CRITICAL_CHANCE_BONUS].duration > 0)
            {
               _loc4_ += Number(int(_loc5_[BattleData.EFFECT_CRITICAL_CHANCE_BONUS].amount) / 100);
            }
         }
         if(_loc5_[BattleData.EFFECT_CRITICAL_CHANCE_BONUS_WEAPON])
         {
            if(_loc5_[BattleData.EFFECT_CRITICAL_CHANCE_BONUS_WEAPON].duration > 0)
            {
               _loc4_ += int(_loc5_[BattleData.EFFECT_CRITICAL_CHANCE_BONUS_WEAPON].amount) / 100;
            }
         }
         if(_loc5_[BattleData.EFFECT_FRENZY])
         {
            if(_loc5_[BattleData.EFFECT_FRENZY].duration > 0)
            {
               _loc4_ += 0.2;
            }
         }
         if(_loc5_[BattleData.EFFECT_BUNNY_FRENZY])
         {
            if(_loc5_[BattleData.EFFECT_BUNNY_FRENZY].duration > 0)
            {
               _loc4_ += 0.25;
            }
         }
         if(_loc5_[BattleData.EFFECT_BATTLE_BUNNY_FRENZY])
         {
            if(_loc5_[BattleData.EFFECT_BATTLE_BUNNY_FRENZY].duration > 0)
            {
               _loc4_ += 0.25;
            }
         }
         if(_loc5_[BattleData.EFFECT_THUNDERSTORM_MODE])
         {
            if(_loc5_[BattleData.EFFECT_THUNDERSTORM_MODE].duration > 0)
            {
               _loc4_ += Number(int(_loc5_[BattleData.EFFECT_THUNDERSTORM_MODE].amount) / 100);
            }
         }
         var _loc6_:Object = param1.getBattleDebuff();
         if(_loc6_[BattleData.EFFECT_DARK_CURSE])
         {
            if(_loc6_[BattleData.EFFECT_DARK_CURSE].duration > 0)
            {
               _loc4_ -= 0.1;
            }
         }
         if(Boolean(_loc5_[BattleData.EFFECT_PET_ENERGIZE]) && _loc5_[BattleData.EFFECT_PET_ENERGIZE].duration > 0)
         {
            _loc4_ += _loc5_[BattleData.EFFECT_PET_ENERGIZE].amount / 100;
         }
         if(Boolean(_loc6_[BattleData.EFFECT_PET_DISORIENTED]) && _loc6_[BattleData.EFFECT_PET_DISORIENTED].duration > 0)
         {
            _loc4_ -= _loc6_[BattleData.EFFECT_PET_DISORIENTED].amount / 100;
         }
         if(Boolean(_loc6_[BattleData.EFFECT_DECREASE_CRITICAL_CHANCE]) && _loc6_[BattleData.EFFECT_DECREASE_CRITICAL_CHANCE].duration > 0)
         {
            _loc4_ -= _loc6_[BattleData.EFFECT_DECREASE_CRITICAL_CHANCE].amount / 100;
         }
         var _loc7_:Number = 0;
         if(Boolean(param2) && (String(param1.constructor) == "[class Character]" || String(param1.constructor) == "[class PvPCharacter]" || String(param1.constructor) == "[class AICharacter]"))
         {
            _loc14_ = param1.getData(DBCharacterData.BLOODLINE_SKILL);
            if(_loc14_)
            {
               _loc15_ = 0;
               for(; _loc15_ < _loc14_.length; _loc15_++)
               {
                  _loc16_ = int(_loc14_[_loc15_].skill_id);
                  _loc17_ = int(_loc14_[_loc15_].level);
                  _loc18_ = 0;
                  while(_loc18_ < param2.length)
                  {
                     if(param2[_loc18_].skill_id == String("skill" + _loc16_) && param2[_loc18_].bloodline_type == BloodlineData.SKILL_TYPE_PASSIVE)
                     {
                        _loc19_ = param2[_loc18_].effect;
                        _loc20_ = 0;
                        while(_loc20_ < _loc19_.length)
                        {
                           if(_loc19_[_loc20_].skill_level == _loc17_)
                           {
                              if(_loc19_[_loc20_].effect_type_1 == BloodlineData.EFFECT_CRITICAL)
                              {
                                 _loc7_ += Number(_loc19_[_loc20_].effect_amount_1) / 100;
                              }
                              if(_loc19_[_loc20_].effect_type_2 == BloodlineData.EFFECT_CRITICAL)
                              {
                                 _loc7_ += Number(_loc19_[_loc20_].effect_amount_2) / 100;
                              }
                              if(_loc19_[_loc20_].effect_type_3 == BloodlineData.EFFECT_CRITICAL)
                              {
                                 _loc7_ += Number(_loc19_[_loc20_].effect_amount_3) / 100;
                              }
                           }
                           _loc20_++;
                        }
                        break;
                     }
                     _loc18_++;
                  }
               }
            }
         }
         var _loc8_:Number = 0;
         var _loc10_:String = "";
         var _loc11_:Array = [];
         for(_loc9_ in _loc5_)
         {
            _loc11_ = [];
            _loc10_ = "";
            if(!_loc5_[_loc9_])
            {
               continue;
            }
            if(!(_loc5_[_loc9_].duration > 0 && _loc5_[_loc9_].duration < BloodlineData.PASSIVE_BUFF_IDENTIFIER))
            {
               continue;
            }
            _loc11_ = _loc9_.split(".");
            if(_loc11_)
            {
               _loc10_ = _loc11_[0];
            }
            if(!(Boolean(_loc10_) && Boolean(_loc5_[_loc9_].chancetoeffect) && _loc5_[_loc9_].chancetoeffect > 0))
            {
               continue;
            }
            _loc12_ = NumberUtil.getRandom();
            if(_loc12_ > _loc5_[_loc9_].chancetoeffect / 100)
            {
               continue;
            }
            switch(_loc10_)
            {
               case BloodlineData.EFFECT_CRITICAL:
                  _loc8_ += Number(_loc5_[_loc9_].amount) / 100;
            }
         }
         for(_loc9_ in _loc6_)
         {
            _loc11_ = [];
            _loc10_ = "";
            if(!_loc6_[_loc9_])
            {
               continue;
            }
            if(!(_loc6_[_loc9_].duration > 0 && _loc6_[_loc9_].duration < BloodlineData.PASSIVE_DEBUFF_IDENTIFIER))
            {
               continue;
            }
            _loc11_ = _loc9_.split(".");
            if(_loc11_)
            {
               _loc10_ = _loc11_[0];
            }
            if(!(Boolean(_loc10_) && Boolean(_loc6_[_loc9_].chancetoeffect) && _loc6_[_loc9_].chancetoeffect > 0))
            {
               continue;
            }
            _loc12_ = NumberUtil.getRandom();
            if(_loc12_ > _loc6_[_loc9_].chancetoeffect / 100)
            {
               continue;
            }
            switch(_loc10_)
            {
               case BloodlineData.EFFECT_CRITICAL:
                  _loc8_ += Number(_loc6_[_loc9_].amount) / 100;
            }
         }
         _loc13_ = 0;
         if(Boolean(param3) && (String(param1.constructor) == "[class Character]" || String(param1.constructor) == "[class PvPCharacter]" || String(param1.constructor) == "[class AICharacter]"))
         {
            _loc21_ = param1.getData(DBCharacterData.SENJUTSU_SKILL);
            if(_loc21_)
            {
               _loc15_ = 0;
               for(; _loc15_ < _loc21_.length; _loc15_++)
               {
                  _loc16_ = int(_loc21_[_loc15_].skill_id);
                  _loc17_ = int(_loc21_[_loc15_].level);
                  _loc18_ = 0;
                  while(_loc18_ < param3.length)
                  {
                     if(param3[_loc18_].skill_id == String("skill" + _loc16_) && param3[_loc18_].senjutsu_type == SenjutsuData.SKILL_TYPE_PASSIVE)
                     {
                        _loc19_ = param3[_loc18_].effect;
                        _loc20_ = 0;
                        while(_loc20_ < _loc19_.length)
                        {
                           if(_loc19_[_loc20_].skill_level == _loc17_)
                           {
                           }
                           _loc20_++;
                        }
                        break;
                     }
                     _loc18_++;
                  }
               }
            }
         }
         _loc4_ = _loc4_ + _loc7_ + _loc8_ + _loc13_;
         _loc4_ = Number(_loc4_.toFixed(3));
         if(_loc4_ < 0)
         {
            _loc4_ = 0;
         }
         return _loc4_;
      }
      
      public static function calcDodge(param1:*, param2:Array = null, param3:Array = null) : Number
      {
         var _loc10_:String = null;
         var _loc13_:Number = NaN;
         var _loc14_:int = 0;
         var _loc15_:Array = null;
         var _loc16_:int = 0;
         var _loc17_:int = 0;
         var _loc18_:int = 0;
         var _loc19_:int = 0;
         var _loc20_:Array = null;
         var _loc21_:int = 0;
         var _loc22_:Array = null;
         var _loc4_:Number = Central.main.coreData.BASE_DODGE_CHANCE + Number(int(param1.getData(DBCharacterData.WIND)) * 4 / 1000);
         var _loc5_:Object = param1.getBattleBuff();
         if(_loc5_[BattleData.EFFECT_DODGE_BONUS])
         {
            if(_loc5_[BattleData.EFFECT_DODGE_BONUS].duration > 0)
            {
               _loc4_ += Number(int(_loc5_[BattleData.EFFECT_DODGE_BONUS].amount) / 100);
            }
         }
         if(_loc5_[BattleData.EFFECT_PET_DODGE_BONUS])
         {
            if(_loc5_[BattleData.EFFECT_PET_DODGE_BONUS].duration > 0)
            {
               _loc4_ += Number(int(_loc5_[BattleData.EFFECT_PET_DODGE_BONUS].amount) / 100);
            }
         }
         var _loc6_:int = 0;
         while(_loc6_ < BattleData.WIND_PEACE_ARR.length)
         {
            if(_loc5_[BattleData.WIND_PEACE_ARR[_loc6_]])
            {
               if(_loc5_[BattleData.WIND_PEACE_ARR[_loc6_]].duration > 0)
               {
                  _loc4_ += Number(int(_loc5_[BattleData.WIND_PEACE_ARR[_loc6_]].amount) / 100);
               }
            }
            _loc6_++;
         }
         var _loc7_:Object = param1.getBattleDebuff();
         if(_loc7_[BattleData.EFFECT_DARK_CURSE])
         {
            if(_loc7_[BattleData.EFFECT_DARK_CURSE].duration > 0)
            {
               _loc4_ -= 0.1;
            }
         }
         if(_loc7_[BattleData.SKILL_236])
         {
            if(_loc7_[BattleData.SKILL_236].duration > 0)
            {
               _loc4_ -= Number(int(_loc7_[BattleData.SKILL_236].amount) / 100);
            }
         }
         if(Boolean(_loc5_[BattleData.EFFECT_PET_ENERGIZE]) && _loc5_[BattleData.EFFECT_PET_ENERGIZE].duration > 0)
         {
            _loc4_ += _loc5_[BattleData.EFFECT_PET_ENERGIZE].amount / 100;
         }
         if(Boolean(_loc7_[BattleData.EFFECT_PET_DISORIENTED]) && _loc7_[BattleData.EFFECT_PET_DISORIENTED].duration > 0)
         {
            _loc4_ -= _loc7_[BattleData.EFFECT_PET_DISORIENTED].amount / 100;
         }
         var _loc8_:Number = 0;
         if(Boolean(param2) && (String(param1.constructor) == "[class Character]" || String(param1.constructor) == "[class PvPCharacter]" || String(param1.constructor) == "[class AICharacter]"))
         {
            _loc15_ = param1.getData(DBCharacterData.BLOODLINE_SKILL);
            if(_loc15_)
            {
               _loc16_ = 0;
               for(; _loc16_ < _loc15_.length; _loc16_++)
               {
                  _loc17_ = int(_loc15_[_loc16_].skill_id);
                  _loc18_ = int(_loc15_[_loc16_].level);
                  _loc19_ = 0;
                  while(_loc19_ < param2.length)
                  {
                     if(param2[_loc19_].skill_id == String("skill" + _loc17_) && param2[_loc19_].bloodline_type == BloodlineData.SKILL_TYPE_PASSIVE)
                     {
                        _loc20_ = param2[_loc19_].effect;
                        _loc21_ = 0;
                        while(_loc21_ < _loc20_.length)
                        {
                           if(_loc20_[_loc21_].skill_level == _loc18_)
                           {
                              if(_loc20_[_loc21_].effect_type_1 == BloodlineData.EFFECT_DODGE)
                              {
                                 _loc8_ += Number(_loc20_[_loc21_].effect_amount_1) / 100;
                              }
                              if(_loc20_[_loc21_].effect_type_2 == BloodlineData.EFFECT_DODGE)
                              {
                                 _loc8_ += Number(_loc20_[_loc21_].effect_amount_2) / 100;
                              }
                              if(_loc20_[_loc21_].effect_type_3 == BloodlineData.EFFECT_DODGE)
                              {
                                 _loc8_ += Number(_loc20_[_loc21_].effect_amount_3) / 100;
                              }
                           }
                           _loc21_++;
                        }
                        break;
                     }
                     _loc19_++;
                  }
               }
            }
         }
         var _loc9_:Number = 0;
         var _loc11_:String = "";
         var _loc12_:Array = [];
         for(_loc10_ in _loc5_)
         {
            _loc12_ = [];
            _loc11_ = "";
            if(!_loc5_[_loc10_])
            {
               continue;
            }
            if(!(_loc5_[_loc10_].duration > 0 && _loc5_[_loc10_].duration < BloodlineData.PASSIVE_BUFF_IDENTIFIER))
            {
               continue;
            }
            _loc12_ = _loc10_.split(".");
            if(_loc12_)
            {
               _loc11_ = _loc12_[0];
            }
            if(!(Boolean(_loc11_) && Boolean(_loc5_[_loc10_].chancetoeffect) && _loc5_[_loc10_].chancetoeffect > 0))
            {
               continue;
            }
            _loc13_ = NumberUtil.getRandom();
            if(_loc13_ > _loc5_[_loc10_].chancetoeffect / 100)
            {
               continue;
            }
            switch(_loc11_)
            {
               case BloodlineData.EFFECT_DODGE:
                  _loc9_ += Number(_loc5_[_loc10_].amount) / 100;
                  break;
               case BloodlineData.EFFECT_CAPTURE:
                  _loc9_ += Number(_loc5_[_loc10_].amount) / 100;
            }
         }
         for(_loc10_ in _loc7_)
         {
            _loc12_ = [];
            _loc11_ = "";
            if(!_loc7_[_loc10_])
            {
               continue;
            }
            if(!(_loc7_[_loc10_].duration > 0 && _loc7_[_loc10_].duration < BloodlineData.PASSIVE_DEBUFF_IDENTIFIER))
            {
               continue;
            }
            _loc12_ = _loc10_.split(".");
            if(_loc12_)
            {
               _loc11_ = _loc12_[0];
            }
            if(!(Boolean(_loc11_) && Boolean(_loc7_[_loc10_].chancetoeffect) && _loc7_[_loc10_].chancetoeffect > 0))
            {
               continue;
            }
            _loc13_ = NumberUtil.getRandom();
            if(_loc13_ > _loc7_[_loc10_].chancetoeffect / 100)
            {
               continue;
            }
            switch(_loc11_)
            {
               case BloodlineData.EFFECT_DODGE:
                  _loc9_ += Number(_loc7_[_loc10_].amount) / 100;
                  break;
               case BloodlineData.EFFECT_CAPTURE:
                  _loc9_ += Number(_loc7_[_loc10_].amount) / 100;
            }
         }
         _loc14_ = 0;
         if(Boolean(param3) && (String(param1.constructor) == "[class Character]" || String(param1.constructor) == "[class PvPCharacter]" || String(param1.constructor) == "[class AICharacter]"))
         {
            _loc22_ = param1.getData(DBCharacterData.SENJUTSU_SKILL);
            if(_loc22_)
            {
               _loc16_ = 0;
               for(; _loc16_ < _loc22_.length; _loc16_++)
               {
                  _loc17_ = int(_loc22_[_loc16_].skill_id);
                  _loc18_ = int(_loc22_[_loc16_].level);
                  _loc19_ = 0;
                  while(_loc19_ < param3.length)
                  {
                     if(param3[_loc19_].skill_id == String("skill" + _loc17_) && param3[_loc19_].senjutsu_type == SenjutsuData.SKILL_TYPE_PASSIVE)
                     {
                        _loc20_ = param3[_loc19_].effect;
                        _loc21_ = 0;
                        while(_loc21_ < _loc20_.length)
                        {
                           if(_loc20_[_loc21_].skill_level == _loc18_)
                           {
                           }
                           _loc21_++;
                        }
                        break;
                     }
                     _loc19_++;
                  }
               }
            }
         }
         _loc4_ = _loc4_ + _loc8_ + _loc9_ + _loc14_;
         _loc4_ = Number(_loc4_.toFixed(3));
         if(_loc4_ < 0)
         {
            _loc4_ = 0;
         }
         return _loc4_;
      }
      
      public static function calcHP(param1:*, param2:Array = null, param3:Array = null) : uint
      {
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:Object = null;
         var _loc13_:Object = null;
         var _loc14_:int = 0;
         var _loc15_:Number = NaN;
         var _loc18_:Number = NaN;
         var _loc19_:Object = null;
         var _loc20_:Object = null;
         var _loc21_:Object = null;
         var _loc22_:Object = null;
         var _loc23_:String = null;
         var _loc24_:Object = null;
         var _loc25_:Object = null;
         var _loc26_:Array = null;
         var _loc27_:int = 0;
         var _loc28_:int = 0;
         var _loc29_:Array = null;
         var _loc4_:Object = param1.getBattleBuff();
         var _loc5_:Object = param1.getBattleAction();
         var _loc6_:uint = 30;
         var _loc10_:int = Math.round(param1.getData(DBCharacterData.MAX_HP)) + Math.round((param1.getData(DBCharacterData.LEVEL) - 1) * Data.LEVEL_INC_HP) + Math.round(param1.getData(DBCharacterData.EARTH) * _loc6_);
         var _loc11_:Object = param1.getClanEffect();
         var _loc12_:int = 0;
         if(_loc11_)
         {
            if(_loc11_[ClanData.CLAN_HP_BONUS])
            {
               _loc18_ = int(_loc11_[ClanData.CLAN_HP_BONUS].amount) / 100;
               _loc12_ += Math.round(_loc10_ * _loc18_);
            }
         }
         if(param1.getWeapon())
         {
            _loc19_ = Central.main.WEAPON_DATA.find(param1.getWeapon());
            if(_loc19_)
            {
               for each(_loc13_ in _loc19_.effect)
               {
                  switch(_loc13_.type)
                  {
                     case BattleData.EFFECT_MAX_HP:
                        if(NumberUtil.getRandom() <= _loc13_.chance / 100)
                        {
                           _loc12_ += _loc13_.amount;
                        }
                  }
               }
            }
         }
         if(param1.getBackItem())
         {
            _loc20_ = Central.main.BACK_ITEM_DATA.find(param1.getBackItem());
            if(_loc20_)
            {
               for each(_loc13_ in _loc20_.effect)
               {
                  switch(_loc13_.type)
                  {
                     case BattleData.EFFECT_MAX_HP_PRESENT:
                        if(NumberUtil.getRandom() <= _loc13_.chance / 100)
                        {
                           _loc12_ += Math.round(_loc10_ * _loc13_.amount / 100);
                        }
                        break;
                     case BattleData.EFFECT_MAX_HP_FIX_NUM:
                        if(NumberUtil.getRandom() <= _loc13_.chance / 100)
                        {
                           _loc12_ += _loc13_.amount;
                        }
                  }
               }
            }
         }
         if(param1.getAccessory())
         {
            _loc21_ = Central.main.ACCESSORY_DATA.find(param1.getAccessory());
            if(_loc21_)
            {
               for each(_loc13_ in _loc21_.effect)
               {
                  switch(_loc13_.type)
                  {
                     case BattleData.EFFECT_MAX_HP_PRESENT:
                        if(NumberUtil.getRandom() <= _loc13_.chance / 100)
                        {
                           _loc12_ += Math.round(_loc10_ * _loc13_.amount / 100);
                        }
                        Out.debug("","accessory EFFECT_MAX_HP_PRESENT");
                  }
               }
            }
         }
         if(param1.getGearset())
         {
            _loc22_ = param1.getGearset();
            for(_loc23_ in _loc22_)
            {
               _loc24_ = Central.main.GEAR_SET_DATA.find(_loc23_);
               _loc14_ = 0;
               while(_loc14_ < _loc22_[_loc23_] - 1)
               {
                  _loc25_ = _loc24_.effect[_loc14_];
                  switch(_loc25_.type)
                  {
                     case BattleData.EFFECT_MAX_HP_PRESENT:
                        _loc12_ += Math.round(_loc10_ * _loc25_.amount / 100);
                  }
                  _loc14_++;
               }
            }
         }
         if(param1.getBloodlineEffect())
         {
            for each(_loc13_ in param1.getBloodlineEffect())
            {
               switch(_loc13_.type)
               {
                  case BloodlineData.EFFECT_MAX_HP_FIX_NUM:
                     _loc12_ += _loc13_.amount;
                     break;
                  case BloodlineData.EFFECT_MAX_HP:
                     _loc12_ += Math.round(_loc13_.amount * 0.01 * _loc10_);
                     break;
                  case BloodlineData.EFFECT_HP_BONUS_RELATE_CP_PERCENT:
                     _loc12_ += Math.round(param1.maxCP * _loc13_.amount * 0.01);
               }
            }
         }
         var _loc16_:int = 0;
         var _loc17_:int = 0;
         if(Boolean(param3) && (String(param1.constructor) == "[class Character]" || String(param1.constructor) == "[class PvPCharacter]" || String(param1.constructor) == "[class AICharacter]"))
         {
            _loc26_ = param1.getData(DBCharacterData.SENJUTSU_SKILL);
            if(_loc26_)
            {
               _loc14_ = 0;
               for(; _loc14_ < _loc26_.length; _loc14_++)
               {
                  _loc27_ = int(_loc26_[_loc14_].skill_id);
                  _loc28_ = int(_loc26_[_loc14_].level);
                  _loc7_ = 0;
                  while(_loc7_ < param3.length)
                  {
                     if(param3[_loc7_].skill_id == String("skill" + _loc27_) && param3[_loc7_].senjutsu_type == SenjutsuData.SKILL_TYPE_PASSIVE)
                     {
                        _loc29_ = param3[_loc7_].effect;
                        _loc8_ = 0;
                        while(_loc8_ < _loc29_.length)
                        {
                           if(_loc29_[_loc8_].skill_level == _loc28_)
                           {
                              if(_loc29_[_loc8_].effect_type_1 == SenjutsuData.EFFECT_SS_MAX_HP)
                              {
                                 _loc17_ += Math.round(_loc29_[_loc8_].effect_amount_1 / 100 * _loc10_);
                              }
                              if(_loc29_[_loc8_].effect_type_2 == SenjutsuData.EFFECT_SS_MAX_HP)
                              {
                                 _loc17_ += Math.round(_loc29_[_loc8_].effect_amount_2 / 100 * _loc10_);
                              }
                              if(_loc29_[_loc8_].effect_type_3 == SenjutsuData.EFFECT_SS_MAX_HP)
                              {
                                 _loc17_ += Math.round(_loc29_[_loc8_].effect_amount_3 / 100 * _loc10_);
                              }
                           }
                           _loc8_++;
                        }
                        break;
                     }
                     _loc7_++;
                  }
               }
            }
         }
         _loc12_ += _loc17_;
         _loc10_ += _loc12_;
         if(_loc4_[BattleData.EFFECT_ADD_MAX_HP_LIMIT])
         {
            if(_loc4_[BattleData.EFFECT_ADD_MAX_HP_LIMIT].duration > 0)
            {
               _loc10_ *= 1 + param1.getBattleBuff()[BattleData.EFFECT_ADD_MAX_HP_LIMIT].amount / 100;
            }
         }
         else if(_loc5_ != null)
         {
            if(_loc5_.addmaxhp == true)
            {
               _loc10_ = int(_loc5_.HPP);
            }
         }
         return _loc10_;
      }
      
      public static function calcCP(param1:*, param2:Array = null, param3:Array = null) : uint
      {
         var _loc8_:Object = null;
         var _loc9_:int = 0;
         var _loc10_:Number = NaN;
         var _loc14_:Number = NaN;
         var _loc15_:Object = null;
         var _loc16_:Object = null;
         var _loc17_:Object = null;
         var _loc18_:Object = null;
         var _loc19_:String = null;
         var _loc20_:Object = null;
         var _loc21_:Object = null;
         var _loc22_:Array = null;
         var _loc23_:int = 0;
         var _loc24_:int = 0;
         var _loc25_:int = 0;
         var _loc26_:Array = null;
         var _loc27_:int = 0;
         var _loc28_:Array = null;
         var _loc4_:uint = 30;
         var _loc5_:int = Math.round(param1.getData(DBCharacterData.MAX_CP)) + Math.round((param1.getData(DBCharacterData.LEVEL) - 1) * Data.LEVEL_INC_CP) + Math.round(param1.getData(DBCharacterData.WATER) * _loc4_);
         var _loc6_:Object = param1.getClanEffect();
         var _loc7_:int = 0;
         if(_loc6_)
         {
            if(_loc6_[ClanData.CLAN_CP_BONUS])
            {
               _loc14_ = int(_loc6_[ClanData.CLAN_CP_BONUS].amount) / 100;
               _loc7_ += Math.round(_loc5_ * _loc14_);
            }
         }
         if(param1.getWeapon())
         {
            _loc15_ = Central.main.WEAPON_DATA.find(param1.getWeapon());
            if(_loc15_)
            {
               for each(_loc8_ in _loc15_.effect)
               {
                  switch(_loc8_.type)
                  {
                     case BattleData.EFFECT_MAX_CP:
                        if(NumberUtil.getRandom() <= _loc8_.chance / 100)
                        {
                           _loc7_ += _loc8_.amount;
                        }
                  }
               }
            }
         }
         if(param1.getBackItem())
         {
            _loc16_ = Central.main.BACK_ITEM_DATA.find(param1.getBackItem());
            if(_loc16_)
            {
               for each(_loc8_ in _loc16_.effect)
               {
                  switch(_loc8_.type)
                  {
                     case BattleData.EFFECT_MAX_CP_PRESENT:
                        if(NumberUtil.getRandom() <= _loc8_.chance / 100)
                        {
                           _loc7_ += Math.round(_loc5_ * _loc8_.amount / 100);
                        }
                        break;
                     case BattleData.EFFECT_MAX_CP:
                        if(NumberUtil.getRandom() <= _loc8_.chance / 100)
                        {
                           _loc7_ += _loc8_.amount;
                        }
                  }
               }
            }
         }
         if(param1.getAccessory())
         {
            _loc17_ = Central.main.ACCESSORY_DATA.find(param1.getAccessory());
            if(_loc17_)
            {
               for each(_loc8_ in _loc17_.effect)
               {
                  switch(_loc8_.type)
                  {
                     case BattleData.EFFECT_MAX_CP_PRESENT:
                        if(NumberUtil.getRandom() <= _loc8_.chance / 100)
                        {
                           _loc7_ += Math.round(_loc5_ * _loc8_.amount / 100);
                        }
                  }
               }
            }
         }
         if(param1.getGearset())
         {
            _loc18_ = param1.getGearset();
            for(_loc19_ in _loc18_)
            {
               _loc20_ = Central.main.GEAR_SET_DATA.find(_loc19_);
               _loc9_ = 0;
               while(_loc9_ < _loc18_[_loc19_] - 1)
               {
                  _loc21_ = _loc20_.effect[_loc9_];
                  switch(_loc21_.type)
                  {
                     case BattleData.EFFECT_MAX_CP_PRESENT:
                        _loc7_ += Math.round(_loc5_ * _loc21_.amount / 100);
                  }
                  _loc9_++;
               }
            }
         }
         var _loc11_:int = 0;
         if(Boolean(param2) && (String(param1.constructor) == "[class Character]" || String(param1.constructor) == "[class PvPCharacter]" || String(param1.constructor) == "[class AICharacter]"))
         {
            _loc22_ = param1.getData(DBCharacterData.BLOODLINE_SKILL);
            if(_loc22_)
            {
               _loc9_ = 0;
               for(; _loc9_ < _loc22_.length; _loc9_++)
               {
                  _loc23_ = int(_loc22_[_loc9_].skill_id);
                  _loc24_ = int(_loc22_[_loc9_].level);
                  _loc25_ = 0;
                  while(_loc25_ < param2.length)
                  {
                     if(param2[_loc25_].skill_id == String("skill" + _loc23_) && param2[_loc25_].bloodline_type == BloodlineData.SKILL_TYPE_PASSIVE)
                     {
                        _loc26_ = param2[_loc25_].effect;
                        _loc27_ = 0;
                        while(_loc27_ < _loc26_.length)
                        {
                           if(_loc26_[_loc27_].skill_level == _loc24_)
                           {
                              if(_loc26_[_loc27_].effect_type_1 == BloodlineData.EFFECT_MAX_CP)
                              {
                                 _loc11_ += Math.round(_loc26_[_loc27_].effect_amount_1 / 100 * _loc5_);
                              }
                              if(_loc26_[_loc27_].effect_type_2 == BloodlineData.EFFECT_MAX_CP)
                              {
                                 _loc11_ += Math.round(_loc26_[_loc27_].effect_amount_2 / 100 * _loc5_);
                              }
                              if(_loc26_[_loc27_].effect_type_3 == BloodlineData.EFFECT_MAX_CP)
                              {
                                 _loc11_ += Math.round(_loc26_[_loc27_].effect_amount_3 / 100 * _loc5_);
                              }
                           }
                           _loc27_++;
                        }
                        break;
                     }
                     _loc25_++;
                  }
               }
            }
         }
         _loc7_ += _loc11_;
         var _loc12_:int = 0;
         if(Boolean(param3) && (String(param1.constructor) == "[class Character]" || String(param1.constructor) == "[class PvPCharacter]" || String(param1.constructor) == "[class AICharacter]"))
         {
            _loc28_ = param1.getData(DBCharacterData.SENJUTSU_SKILL);
            if(_loc28_)
            {
               _loc9_ = 0;
               for(; _loc9_ < _loc28_.length; _loc9_++)
               {
                  _loc23_ = int(_loc28_[_loc9_].skill_id);
                  _loc24_ = int(_loc28_[_loc9_].level);
                  _loc25_ = 0;
                  while(_loc25_ < param3.length)
                  {
                     if(param3[_loc25_].skill_id == String("skill" + _loc23_) && param3[_loc25_].senjutsu_type == SenjutsuData.SKILL_TYPE_PASSIVE)
                     {
                        _loc26_ = param3[_loc25_].effect;
                        _loc27_ = 0;
                        while(_loc27_ < _loc26_.length)
                        {
                           if(_loc26_[_loc27_].skill_level == _loc24_)
                           {
                           }
                           _loc27_++;
                        }
                        break;
                     }
                     _loc25_++;
                  }
               }
            }
         }
         _loc7_ += _loc12_;
         var _loc13_:int = _loc5_ += _loc7_;
         if(param1.isBattleDebuffActive(SenjutsuData.EFFECT_SS_MAX_CP_CHANGE))
         {
            _loc5_ *= 1 - param1.getBattleDebuff()[SenjutsuData.EFFECT_SS_MAX_CP_CHANGE].amount / 100;
         }
         if(param1.isBattleDebuffActive(SenjutsuData.EFFECT_SS_MAX_CP_CHANGE_EXTRA))
         {
            _loc5_ *= 1 - param1.getBattleDebuff()[SenjutsuData.EFFECT_SS_MAX_CP_CHANGE_EXTRA].amount / 100;
         }
         if(param1.isBattleDebuffActive(BattleData.EFFECT_REDUCE_CP_MAX))
         {
            _loc5_ *= 1 - param1.getBattleDebuff()[BattleData.EFFECT_REDUCE_CP_MAX].amount / 100;
         }
         if(param1.isBattleBuffActive(BattleData.EFFECT_CP_LOCK))
         {
            _loc5_ = _loc13_;
         }
         return _loc5_;
      }
      
      public static function calcSP(param1:*, param2:Array = null) : uint
      {
         return int(SenjutsuData.SENJUTSU_MAX_SP + (param1.getData(DBCharacterData.LEVEL) - SenjutsuData.SENJUTSU_LEVEL) * SenjutsuData.SENJUTSU_MAX_SP_INCREMENT);
      }
      
      public static function getSenjutsuSlot(param1:uint) : int
      {
         var _loc2_:int = 8;
         var _loc3_:int = 4;
         var _loc4_:uint = 0;
         if(param1 - SenjutsuData.SENJUTSU_LEVEL >= 0)
         {
            _loc4_ = _loc3_ + int(Math.floor((param1 - SenjutsuData.SENJUTSU_LEVEL) * 0.1));
         }
         if(_loc4_ <= _loc2_)
         {
            return _loc4_;
         }
         return _loc2_;
      }
      
      public static function getXpByLv(param1:uint) : uint
      {
         var _loc2_:uint = 130;
         var _loc3_:uint = 50;
         var _loc4_:uint = 50;
         var _loc5_:uint = 0;
         var _loc6_:uint = 1;
         while(_loc6_ < param1)
         {
            _loc5_ += Math.round(_loc6_ * _loc2_ * Math.pow(_loc3_,_loc6_ / _loc4_));
            _loc6_++;
         }
         if(_loc5_ < 0)
         {
            _loc5_ = 0;
         }
         return _loc5_;
      }
      
      public static function getLvByXp(param1:uint) : uint
      {
         var _loc2_:uint = 130;
         var _loc3_:uint = 50;
         var _loc4_:uint = 50;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         while(_loc5_ <= param1)
         {
            _loc6_++;
            _loc5_ += Math.round(_loc6_ * _loc2_ * Math.pow(_loc3_,_loc6_ / _loc4_));
         }
         return _loc6_;
      }
      
      public static function getPetXpByLv(param1:uint) : uint
      {
         var _loc2_:uint = 130;
         var _loc3_:uint = 50;
         var _loc4_:uint = 50;
         var _loc5_:uint = 0;
         var _loc6_:uint = 1;
         while(_loc6_ < param1)
         {
            _loc5_ += Math.round(_loc6_ * _loc2_ * Math.pow(_loc3_,_loc6_ / _loc4_) * 0.2);
            _loc6_++;
         }
         if(_loc5_ < 0)
         {
            _loc5_ = 0;
         }
         return _loc5_;
      }
      
      public static function getPetLvByXp(param1:uint) : uint
      {
         var _loc2_:uint = 130;
         var _loc3_:uint = 50;
         var _loc4_:uint = 50;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         while(_loc5_ <= param1)
         {
            _loc6_++;
            _loc5_ += Math.round(_loc6_ * _loc2_ * Math.pow(_loc3_,_loc6_ / _loc4_) * 0.2);
         }
         return _loc6_;
      }
      
      public static function calcXpPenalty(param1:int, param2:int) : int
      {
         var _loc3_:int = 0;
         return param2;
      }
   }
}

