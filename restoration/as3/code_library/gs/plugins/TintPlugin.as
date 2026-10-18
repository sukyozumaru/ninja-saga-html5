package gs.plugins
{
   import flash.display.*;
   import flash.geom.ColorTransform;
   import gs.*;
   import gs.utils.tween.TweenInfo;
   
   public class TintPlugin extends TweenPlugin
   {
      
      public static const VERSION:Number = 1.01;
      
      public static const API:Number = 1;
      
      protected static var _props:Array = ["redMultiplier","greenMultiplier","blueMultiplier","alphaMultiplier","redOffset","greenOffset","blueOffset","alphaOffset"];
      
      protected var _target:DisplayObject;
      
      protected var _ct:ColorTransform;
      
      public function TintPlugin()
      {
         super();
         this.propName = "tint";
         this.overwriteProps = ["tint"];
      }
      
      override public function onInitTween(param1:Object, param2:*, param3:TweenLite) : Boolean
      {
         if(!(param1 is DisplayObject))
         {
            return false;
         }
         var _loc4_:ColorTransform = new ColorTransform();
         if(param2 != null && param3.exposedVars.removeTint != true)
         {
            _loc4_.color = uint(param2);
         }
         if(param3.exposedVars.alpha != undefined || param3.exposedVars.autoAlpha != undefined)
         {
            _loc4_.alphaMultiplier = param3.exposedVars.alpha != undefined ? Number(param3.exposedVars.alpha) : Number(param3.exposedVars.autoAlpha);
            param3.killVars({
               "alpha":1,
               "autoAlpha":1
            });
         }
         else
         {
            _loc4_.alphaMultiplier = param1.alpha;
         }
         init(param1 as DisplayObject,_loc4_);
         return true;
      }
      
      public function init(param1:DisplayObject, param2:ColorTransform) : void
      {
         var _loc3_:* = 0;
         var _loc4_:String = null;
         _target = param1;
         _ct = _target.transform.colorTransform;
         _loc3_ = int(_props.length - 1);
         while(_loc3_ > -1)
         {
            _loc4_ = _props[_loc3_];
            if(_ct[_loc4_] != param2[_loc4_])
            {
               _tweens[_tweens.length] = new TweenInfo(_ct,_loc4_,_ct[_loc4_],param2[_loc4_] - _ct[_loc4_],"tint",false);
            }
            _loc3_--;
         }
      }
      
      override public function set changeFactor(param1:Number) : void
      {
         updateTweens(param1);
         _target.transform.colorTransform = _ct;
      }
   }
}

