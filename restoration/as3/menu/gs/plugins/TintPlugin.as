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
      
      override public function onInitTween($target:Object, $value:*, $tween:TweenLite) : Boolean
      {
         if(!($target is DisplayObject))
         {
            return false;
         }
         var end:ColorTransform = new ColorTransform();
         if($value != null && $tween.exposedVars.removeTint != true)
         {
            end.color = uint($value);
         }
         if($tween.exposedVars.alpha != undefined || $tween.exposedVars.autoAlpha != undefined)
         {
            end.alphaMultiplier = $tween.exposedVars.alpha != undefined ? Number($tween.exposedVars.alpha) : Number($tween.exposedVars.autoAlpha);
            $tween.killVars({
               "alpha":1,
               "autoAlpha":1
            });
         }
         else
         {
            end.alphaMultiplier = $target.alpha;
         }
         this.init($target as DisplayObject,end);
         return true;
      }
      
      public function init($target:DisplayObject, $end:ColorTransform) : void
      {
         var i:* = 0;
         var p:String = null;
         this._target = $target;
         this._ct = this._target.transform.colorTransform;
         for(i = int(_props.length - 1); i > -1; i--)
         {
            p = _props[i];
            if(this._ct[p] != $end[p])
            {
               _tweens[_tweens.length] = new TweenInfo(this._ct,p,this._ct[p],$end[p] - this._ct[p],"tint",false);
            }
         }
      }
      
      override public function set changeFactor($n:Number) : void
      {
         updateTweens($n);
         this._target.transform.colorTransform = this._ct;
      }
   }
}

