package ninjasaga
{
   import com.utils.Out;
   import de.polygonal.ds.HashMap;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import ninjasaga.battle.*;
   import ninjasaga.data.Timeline;
   import ninjasaga.data.TitleData;
   
   public class Panel
   {
      
      private static var instance:Panel;
      
      private static var panelObj:Object = {};
      
      private var curPanelName:String = "";
      
      private var panelFrame:String;
      
      private var _recruitCharCache:HashMap = new HashMap();
      
      private var _recruitedCharacters:Array = [];
      
      private var _challengeCharCache:HashMap = new HashMap();
      
      private var _challengedCharacters:Array = [];
      
      private var _visitCharacterId:uint = 0;
      
      private var _visitFacebookId:String = "";
      
      public function Panel(param1:SingletonBlocker)
      {
         super();
         if(param1 == null)
         {
            throw new Error("Error: Instantiation failed: Use Panel.getInstance() instead of new.");
         }
         this.curPanelName = "";
      }
      
      public static function getInstance() : Panel
      {
         if(instance == null)
         {
            instance = new Panel(new SingletonBlocker());
         }
         return instance;
      }
      
      public static function hasPanel(param1:String) : Boolean
      {
         var _loc2_:MovieClip = panelObj[param1];
         if(_loc2_ != null)
         {
            return true;
         }
         return false;
      }
      
      public function show(param1:String, param2:String = null) : void
      {
         if(Main.checkGameStatus() == Timeline.BATTLE)
         {
            Main.showInfo(Main.langLib.get(607));
            return;
         }
         if(Mission.onMission() != null)
         {
            Main.showInfo(Main.langLib.get(608));
            return;
         }
         var _loc3_:String = this.curPanelName;
         this.curPanelName = param1;
         this.panelFrame = param2;
         if(Main.checkGameStatus() == Timeline.PANEL)
         {
            if(_loc3_ == "academy")
            {
               Main.getPanel().stopTrainingTimer();
            }
            Main.removePanel(Main.getPanel());
            this.onShowPanel();
         }
         else
         {
            Main.gotoPanel();
         }
      }
      
      public function onShowPanel() : void
      {
         if(!Panel.hasPanel(this.curPanelName))
         {
            Main.loadSwf(["swf/panels/" + this.curPanelName + ".swf"],this.onInitFinish);
         }
      }
      
      private function onInitFinish(param1:Object) : void
      {
         var _loc2_:MovieClip = param1["swf/panels/" + this.curPanelName + ".swf"];
         Main.addPanel(_loc2_);
         if(this.panelFrame == null)
         {
            if("show" in _loc2_)
            {
               _loc2_.show();
            }
            else
            {
               Out.debug("Panel","onInitFinish, hank show not a function");
               Main.onError("302");
            }
         }
         else
         {
            _loc2_.show(this.panelFrame);
         }
      }
      
      public function hide(param1:MovieClip) : void
      {
         param1.gotoAndStop(Timeline.IDLE);
         Main.removePanel(param1);
         Main.gotoMap();
      }
      
      public function reshow() : void
      {
         this.onShowPanel();
      }
      
      public function get curPanel() : MovieClip
      {
         return Main.getPanel();
      }
      
      public function getCurPanelName() : String
      {
         return this.curPanelName;
      }
      
      public function emptyRecruitCharCache() : void
      {
         Out.debug(this,"emptyRecruitCharCache");
         this._recruitCharCache = null;
         this._recruitCharCache = new HashMap();
      }
      
      public function get recruitCharCache() : HashMap
      {
         return this._recruitCharCache;
      }
      
      public function get challengeCharCache() : HashMap
      {
         return this._challengeCharCache;
      }
      
      public function addRecruitCharCache(param1:HashMap) : void
      {
         var _loc3_:uint = 0;
         var _loc2_:Array = param1.getKeySet();
         _loc3_ = 0;
         while(_loc3_ < _loc2_.length)
         {
            Out.debug(this,"addRecruitCharCache :: caching keys[" + _loc3_ + "] " + _loc2_[_loc3_]);
            this._recruitCharCache.insert(String(_loc2_[_loc3_]),param1.find(_loc2_[_loc3_]));
            _loc3_++;
         }
      }
      
      public function addChallengeCharCache(param1:HashMap) : void
      {
         var _loc3_:uint = 0;
         var _loc2_:Array = param1.getKeySet();
         _loc3_ = 0;
         while(_loc3_ < _loc2_.length)
         {
            Out.debug(this,"addChallengeCharCache :: caching keys[" + _loc3_ + "] " + _loc2_[_loc3_]);
            this._challengeCharCache.insert(String(_loc2_[_loc3_]),param1.find(_loc2_[_loc3_]));
            _loc3_++;
         }
      }
      
      public function updateRecruitCharCache(param1:String, param2:Array) : void
      {
         this._recruitCharCache.insert(param1,param2);
      }
      
      public function updateChallengeCharCache(param1:String, param2:Array) : void
      {
         this._challengeCharCache.insert(param1,param2);
      }
      
      public function get recruitedCharacters() : Array
      {
         return this._recruitedCharacters;
      }
      
      public function setRecruited(param1:uint) : void
      {
         this._recruitedCharacters.push(param1);
      }
      
      public function get challengedCharacters() : Array
      {
         return this._challengedCharacters;
      }
      
      public function setChallenged(param1:uint) : void
      {
         this._challengedCharacters.push(param1);
      }
      
      public function set visitCharacterId(param1:uint) : void
      {
         this._visitCharacterId = param1;
      }
      
      public function get visitCharacterId() : uint
      {
         return this._visitCharacterId;
      }
      
      public function set visitFacebookId(param1:String) : void
      {
         this._visitFacebookId = param1;
      }
      
      public function get visitFacebookId() : String
      {
         return this._visitFacebookId;
      }
   }
}

class SingletonBlocker
{
   
   public function SingletonBlocker()
   {
      super();
   }
}
