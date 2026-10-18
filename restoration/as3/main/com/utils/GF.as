package com.utils
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.events.TimerEvent;
   import flash.geom.ColorTransform;
   import flash.geom.Matrix;
   import flash.geom.Rectangle;
   import flash.utils.Timer;
   
   public final class GF
   {
      
      public function GF()
      {
         super();
      }
      
      public static function removeAllChild(param1:MovieClip) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         if(param1 != null)
         {
            _loc2_ = uint(param1.numChildren);
            _loc3_ = 0;
            while(_loc3_ < _loc2_)
            {
               param1.removeChildAt(0);
               _loc3_++;
            }
         }
      }
      
      public static function getClassName(param1:*) : String
      {
         return param1.toString().substring(8,param1.toString().length - 1);
      }
      
      public static function changeColor(param1:MovieClip, param2:Number) : void
      {
         var ct:ColorTransform = null;
         var _mc:MovieClip = param1;
         var _color:Number = param2;
         try
         {
            if(_mc != null)
            {
               ct = _mc.transform.colorTransform;
               ct.color = _color;
               _mc.transform.colorTransform = ct;
            }
            else
            {
               trace("Error :: GF :: changeColor :: _color >> " + _color);
            }
         }
         catch(e:Error)
         {
            trace("Error :: GF :: changeColor :: e >> " + e);
         }
      }
      
      public static function cloneAsBitmap(param1:MovieClip, param2:Number, param3:Number, param4:Number, param5:Object = null) : MovieClip
      {
         var _loc6_:Boolean = true;
         var _loc7_:int = 0;
         var _loc8_:Number = param1.width * param2;
         var _loc9_:Number = param1.height * param2;
         if(param5 != null)
         {
            if(param5.width != null)
            {
               _loc8_ = param5.width * param2;
            }
            if(param5.height != null)
            {
               _loc9_ = param5.height * param2;
            }
            if(param5.transparent != null)
            {
               _loc6_ = Boolean(param5.transparent);
            }
            if(param5.background != null)
            {
               _loc7_ = int(param5.background);
            }
         }
         var _loc10_:MovieClip = new MovieClip();
         var _loc11_:BitmapData = new BitmapData(_loc8_,_loc9_,_loc6_,_loc7_);
         var _loc12_:Matrix = new Matrix(param2,0,0,param2,param3,param4);
         _loc11_.draw(param1,_loc12_,null,"normal",null,true);
         var _loc13_:Bitmap = new Bitmap(_loc11_);
         _loc10_.addChild(_loc13_);
         return _loc10_;
      }
      
      public static function duplicateDisplayObject(param1:DisplayObject, param2:Boolean = false) : DisplayObject
      {
         var _loc5_:Rectangle = null;
         var _loc3_:Class = param1["constructor"];
         var _loc4_:DisplayObject = new _loc3_();
         _loc4_.transform = param1.transform;
         _loc4_.filters = param1.filters;
         _loc4_.cacheAsBitmap = param1.cacheAsBitmap;
         _loc4_.opaqueBackground = param1.opaqueBackground;
         if(param1.scale9Grid)
         {
            _loc5_ = param1.scale9Grid;
            _loc4_.scale9Grid = _loc5_;
         }
         if(param2 && Boolean(param1.parent))
         {
            param1.parent.addChild(_loc4_);
         }
         _loc4_.x = 0;
         _loc4_.y = 0;
         trace("GF :: " + _loc4_.width + " :: " + _loc4_.height);
         return _loc4_;
      }
      
      public static function moveToFront(param1:MovieClip) : void
      {
         var _loc2_:MovieClip = null;
         if(param1 != null)
         {
            _loc2_ = MovieClip(param1.parent);
            _loc2_.setChildIndex(param1,13);
         }
      }
      
      public static function removeParent(param1:MovieClip) : void
      {
         if(param1 != null)
         {
            if(param1.parent)
            {
               MovieClip(param1.parent).removeChild(param1);
            }
         }
      }
      
      public static function getAsset(param1:MovieClip, param2:String) : *
      {
         var cls:Class = null;
         var _swf:MovieClip = param1;
         var _cls:String = param2;
         try
         {
            cls = Class(_swf.loaderInfo.applicationDomain.getDefinition(_cls));
            return new cls();
         }
         catch(e:Error)
         {
            trace("ERROR :: getAsset :: " + _cls + " ::" + e.message);
         }
         return null;
      }
      
      public static function startTimer(param1:Number, param2:int, param3:Function) : Timer
      {
         var _loc4_:Timer = new Timer(param1,param2);
         _loc4_.addEventListener(TimerEvent.TIMER_COMPLETE,param3);
         _loc4_.start();
         return _loc4_;
      }
      
      public static function stopTimer(param1:Timer, param2:Function = null) : void
      {
         if(param1)
         {
            param1.stop();
            param1.reset();
            if(param1.hasEventListener(TimerEvent.TIMER_COMPLETE) && param2 != null)
            {
               param1.removeEventListener(TimerEvent.TIMER_COMPLETE,param2);
            }
            param1 = null;
         }
      }
      
      public static function printObject(param1:*, param2:int = 0, param3:String = "") : *
      {
         var tabs:String;
         var i:int = 0;
         var child:* = undefined;
         var childOutput:String = null;
         var obj:* = param1;
         var level:int = param2;
         var outputStr:String = param3;
         if(obj == null)
         {
            return "null";
         }
         tabs = "";
         try
         {
            i = 0;
            while(i < level)
            {
               tabs += "\t";
               i++;
            }
            for(child in obj)
            {
               outputStr += tabs + "[" + child + "] => " + obj[child];
               childOutput = printObject(obj[child],level + 1);
               if(childOutput != "")
               {
                  outputStr += " {\n" + childOutput + tabs + "}";
               }
               outputStr += "\n";
            }
         }
         catch(err:Error)
         {
            trace("General Fucntion Error :: printObject :: " + err.getStackTrace());
            outputStr = "";
         }
         return outputStr;
      }
      
      public static function objectToString(param1:Object) : String
      {
         var str:String = null;
         var key:* = undefined;
         var obj:Object = param1;
         if(obj == null)
         {
            return "null";
         }
         try
         {
            for(key in obj)
            {
               if(str == null)
               {
                  str = key + "::" + obj[key];
               }
               else
               {
                  str += ", " + key + "::" + obj[key];
               }
            }
         }
         catch(e:Error)
         {
            trace("General Fucntion Error :: objectToString :: " + e.getStackTrace());
            str = "";
         }
         return str;
      }
      
      public static function objectToArray(param1:Object) : Array
      {
         var arr:Array;
         var key:* = undefined;
         var obj:Object = param1;
         if(obj == null)
         {
            return null;
         }
         arr = [];
         try
         {
            for(key in obj)
            {
               arr.push(obj[key]);
            }
         }
         catch(e:Error)
         {
            trace("General Fucntion Error :: objectToArray :: " + e.getStackTrace());
         }
         return arr;
      }
   }
}

