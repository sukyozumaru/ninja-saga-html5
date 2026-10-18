package ninjasaga.objects
{
   import com.utils.GF;
   import com.utils.NumberUtil;
   import flash.display.MovieClip;
   import ninjasaga.*;
   import ninjasaga.base.CharacterBattle;
   import ninjasaga.data.BattleData;
   import ninjasaga.data.DBCharacterData;
   import ninjasaga.data.Timeline;
   
   public class Npc extends CharacterBattle
   {
      
      private static var npcList:Object = new Object();
      
      private static var npcMCList:Object = {};
      
      private var _npcObj:Object = new Object();
      
      private var _npcDataId:int = 0;
      
      private var _pet:Pet;
      
      public function Npc(param1:Object)
      {
         super();
         this.type = 6;
         this._npcObj = param1;
         this.actionBase = getNpcSwf(param1);
         this.actionBase.setActionFinishCB(this.actionFinish_CB);
         this.actionBase.setAttackHitCB(this.attackHit_CB);
         this.swf.addChild(actionBase);
         this.dbChar = this.actionBase.dbChar;
         this.dbChar.character_id = Math.round(NumberUtil.randomNumber(0,1000000));
         this.restoreOriginalStatus();
      }
      
      public static function addNpcSwf(param1:String, param2:MovieClip) : void
      {
         npcList[param1] = param2;
      }
      
      public static function getNpcSwf(param1:Object) : MovieClip
      {
         var _loc4_:MovieClip = null;
         var _loc5_:uint = 0;
         var _loc2_:MovieClip = npcList[param1.swfName];
         var _loc3_:Array = npcMCList[param1.clsName];
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
         if(_loc4_ == null)
         {
            _loc4_ = GF.getAsset(_loc2_,param1.clsName);
            npcMCList[param1.clsName] = _loc3_;
         }
         return _loc4_;
      }
      
      public static function hasNpcSwf(param1:String) : Boolean
      {
         if(npcList[param1] == null)
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
      
      override public function setBattleAction(param1:Object = null) : void
      {
         var _loc2_:Object = null;
         if(param1)
         {
            this.battleAction = param1;
         }
         else if(this.isBattleDebuffActive(BattleData.EFFECT_BUNDLE))
         {
            _loc2_ = {"action":"pass"};
            this.battleAction = _loc2_;
            this.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(325));
         }
         else if(this.isBattleDebuffActive(BattleData.SKILL_377))
         {
            _loc2_ = {"action":"pass"};
            this.battleAction = _loc2_;
            this.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(325));
         }
         else
         {
            this.battleAction = this.actionBase.getBattleAction();
         }
      }
      
      public function getStaticFullBody() : MovieClip
      {
         return GF.getAsset(npcList[this._npcObj.swfName],"StaticFullBody");
      }
      
      public function get pet() : Pet
      {
         return this._pet;
      }
      
      public function get npcObj() : Object
      {
         return _npcObj;
      }
      
      private function set npcObj(param1:Object) : void
      {
         _npcObj = param1;
      }
      
      public function get npcDataId() : int
      {
         return _npcDataId;
      }
      
      public function set npcDataId(param1:int) : void
      {
         _npcDataId = param1;
      }
   }
}

