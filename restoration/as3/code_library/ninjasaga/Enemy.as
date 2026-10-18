package ninjasaga
{
   import com.utils.GF;
   import com.utils.NumberUtil;
   import com.utils.Out;
   import flash.display.MovieClip;
   import flash.events.*;
   import flash.utils.*;
   import gs.*;
   import ninjasaga.base.CharacterBattle;
   import ninjasaga.battle.*;
   import ninjasaga.data.BattleData;
   import ninjasaga.data.BloodlineData;
   import ninjasaga.data.SenjutsuData;
   import ninjasaga.data.Timeline;
   
   public class Enemy extends CharacterBattle
   {
      
      private static var enemyList:Object = new Object();
      
      private static var enemyMCList:Object = {};
      
      private var _enemyObj:Object = new Object();
      
      public function Enemy(param1:Object)
      {
         super();
         this.type = 4;
         this.battleAction = null;
         this._enemyObj = param1;
         this.actionBase = getEnemySwf(param1);
         if(this.actionBase == null)
         {
            Out.debug(this,"actionBase >>  null");
         }
         Out.debug(this,"actionBase >> " + this.actionBase);
         this.actionBase.setActionFinishCB(this.actionFinish_CB);
         this.actionBase.setAttackHitCB(this.attackHit_CB);
         this.effectResistance = this.actionBase.getEffectResistance();
         this.swf.addChild(actionBase);
         if(param1.limb)
         {
            this.limb = param1.limb;
         }
         this.dbChar = this.actionBase.dbChar;
         if(param1.PvEID)
         {
            this.dbChar.character_id = param1.PvEID;
         }
         else
         {
            this.dbChar.character_id = Math.round(NumberUtil.randomNumber(0,1000000));
         }
         this.restoreOriginalStatus();
      }
      
      public static function addEnemySwf(param1:String, param2:MovieClip) : void
      {
         enemyList[param1] = param2;
      }
      
      public static function getEnemySwf(param1:Object) : MovieClip
      {
         var _loc4_:MovieClip = null;
         var _loc5_:uint = 0;
         var _loc6_:int = 0;
         var _loc2_:MovieClip = enemyList[param1.swfName];
         var _loc3_:Array = enemyMCList[param1.clsName];
         if(_loc3_ == null)
         {
            _loc3_ = [];
         }
         else
         {
            _loc5_ = 0;
            while(_loc5_ < _loc3_.length)
            {
               if(_loc3_[_loc5_].parent == null)
               {
                  _loc4_ = _loc3_[_loc5_];
                  break;
               }
               _loc5_++;
            }
         }
         while(_loc4_ == null)
         {
            _loc4_ = GF.getAsset(_loc2_,param1.clsName);
            enemyMCList[param1.clsName] = _loc3_;
            if(_loc4_ == null)
            {
               _loc6_ = getTimer();
               while(getTimer() - _loc6_ < 1000)
               {
               }
            }
         }
         return _loc4_;
      }
      
      public static function hasEnemySwf(param1:String) : Boolean
      {
         if(enemyList[param1] == null)
         {
            return false;
         }
         return true;
      }
      
      override public function get maxHP() : uint
      {
         return this.dbChar.character_max_hp;
      }
      
      override public function get maxCP() : uint
      {
         return this.dbChar.character_max_cp;
      }
      
      override public function get maxSP() : uint
      {
         return 0;
      }
      
      public function get rewardGold() : uint
      {
         return this.actionBase.rewardGold;
      }
      
      public function get rewardXP() : uint
      {
         return this.actionBase.rewardXP;
      }
      
      public function get rewardConsumable() : Object
      {
         return this.actionBase.rewardConsumable;
      }
      
      public function get rewardItem() : Object
      {
         return this.actionBase.rewardItem;
      }
      
      override public function setBattleAction(param1:Object = null) : void
      {
         var _loc2_:Object = null;
         if(param1)
         {
            this.battleAction = param1;
            if(this.battleAction.effect != null && this.battleAction.effect == "healing")
            {
               this.updateHP(this.battleAction.dmg);
               this.updateBattleFrame();
            }
         }
         else
         {
            if(this.isBattleDebuffActive(BattleData.EFFECT_BUNDLE))
            {
               _loc2_ = {"action":"pass"};
               this.battleAction = _loc2_;
            }
            else if(this.isBattleDebuffActive(BattleData.SKILL_377))
            {
               _loc2_ = {"action":"pass"};
               this.battleAction = _loc2_;
            }
            else if(this.isBattleDebuffActive(BattleData.EFFECT_MERIDIANS_SEAL))
            {
               _loc2_ = {"action":"pass"};
               this.battleAction = _loc2_;
            }
            else if(this.isBattleDebuffActive(BattleData.EFFECT_PARALYZE))
            {
               _loc2_ = {"action":"pass"};
               this.battleAction = _loc2_;
            }
            else if(this.isBattleDebuffActive(BattleData.EFFECT_BUBBLE_PRISON))
            {
               _loc2_ = {"action":"pass"};
               this.battleAction = _loc2_;
            }
            else if(this.isBattleDebuffActive(BattleData.EFFECT_ECSTATIC_SOUND))
            {
               _loc2_ = {"action":"pass"};
               this.battleAction = _loc2_;
            }
            else if(this.isBattleDebuffActive(BloodlineData.EFFECT_MERIDIAN_BLOCK))
            {
               _loc2_ = {"action":"pass"};
               this.battleAction = _loc2_;
               this.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(743));
            }
            else
            {
               this.battleAction = this.actionBase.getBattleAction();
            }
            switch(this.battleAction.target)
            {
               case "self":
                  Battle.setDefender(this);
            }
         }
      }
      
      public function getStaticFullBody() : MovieClip
      {
         return GF.getAsset(enemyList[this._enemyObj.swfName],"StaticFullBody");
      }
      
      public function getActionBase() : MovieClip
      {
         return this.actionBase;
      }
      
      public function get enemyObj() : Object
      {
         return this._enemyObj;
      }
      
      private function set enemyObj(param1:Object) : void
      {
         this._enemyObj = param1;
      }
   }
}

