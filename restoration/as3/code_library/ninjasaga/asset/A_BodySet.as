package ninjasaga.asset
{
   import br.com.stimuli.loading.BulkLoader;
   import com.utils.GF;
   import com.utils.Out;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.HTTPStatusEvent;
   import flash.events.IOErrorEvent;
   import flash.events.ProgressEvent;
   import flash.net.URLRequest;
   import ninjasaga.Central;
   import ninjasaga.loader.AssetLoader;
   
   public class A_BodySet
   {
      
      public var setId:String;
      
      private var gender:int;
      
      private var swf:MovieClip;
      
      private var displayList:Array = [];
      
      private var displayIconList:Array = [];
      
      private const iconExportName:String = "icon";
      
      public function A_BodySet(param1:String, param2:int)
      {
         super();
         this.setId = param1;
         this.gender = param2;
         var _loc3_:String = getSwfPath(param1,this.gender);
         new AssetLoader(_loc3_,null,null,this.onLoadComplete);
      }
      
      private static function getSwfPath(param1:String, param2:int) : String
      {
         var _loc5_:String = null;
         var _loc3_:Object = param2 == 0 ? Central.main.BODY_SET_BOY : Central.main.BODY_SET_GIRL;
         var _loc4_:Object = _loc3_[param1];
         if(_loc4_)
         {
            _loc5_ = _loc4_.swfName;
            return "swf/items/" + _loc5_ + ".swf";
         }
         Out.debug("A_BodySet","getSwfPath :: setId >> " + param1);
         return null;
      }
      
      private function onLoadComplete(param1:AssetLoader) : void
      {
         this.swf = param1.swf;
         this.refreshDisplay();
      }
      
      private function refreshDisplay() : void
      {
         var bodyPart:BodyPart = null;
         var iconHolder:MovieClip = null;
         if(null == this.swf)
         {
            return;
         }
         while(this.displayList.length > 0)
         {
            bodyPart = this.displayList.shift();
            bodyPart.setSwf(this.swf);
         }
         while(this.displayIconList.length > 0)
         {
            iconHolder = this.displayIconList.shift();
            try
            {
               GF.removeAllChild(iconHolder);
               iconHolder.addChild(GF.getAsset(this.swf,"icon"));
            }
            catch(err:Error)
            {
               §§push(err);
               var _temp_1:* = err;
               err = §§pop();
               Out.error(this,"refreshDisplay :: displayIconList :: " + err.getStackTrace());
            }
         }
      }
      
      public function getPart(param1:String, param2:Number = -1) : Sprite
      {
         var _loc3_:BodyPart = new BodyPart(param1,param2);
         this.displayList.push(_loc3_);
         this.refreshDisplay();
         return _loc3_;
      }
      
      public function getIcon() : MovieClip
      {
         var _loc1_:MovieClip = Central.main.getLib("LoadingMc");
         this.displayIconList.push(_loc1_);
         this.refreshDisplay();
         return _loc1_;
      }
   }
}

import com.utils.GF;
import com.utils.Out;
import flash.display.MovieClip;
import flash.display.Sprite;

class BodyPart extends Sprite
{
   
   internal var partName:String;
   
   internal var skinColor:Number = -1;
   
   internal var displayObj:MovieClip;
   
   public function BodyPart(param1:String, param2:Number)
   {
      super();
      this.partName = param1;
      this.skinColor = param2;
   }
   
   public function setSwf(param1:MovieClip) : void
   {
      var swf:MovieClip = param1;
      try
      {
         this.displayObj = GF.getAsset(swf,this.partName);
         this.setColor(this.skinColor);
         this.addChild(this.displayObj);
      }
      catch(e:Error)
      {
         Out.error(this,"BodyPart :: " + e.getStackTrace());
      }
   }
   
   public function setColor(param1:Number) : void
   {
      if(Boolean(this.displayObj) && this.skinColor > 0)
      {
         if(this.displayObj["skin_color"])
         {
            GF.changeColor(this.displayObj["skin_color"],param1);
         }
      }
   }
}
