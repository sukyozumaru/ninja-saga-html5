package fl.controls
{
   import flash.display.DisplayObject;
   import flash.display.Shape;
   import flash.events.FocusEvent;
   import flash.geom.ColorTransform;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol2106")]
   public class EnhancedTextArea extends TextArea
   {
      
      private var _showBackground:Boolean = true;
      
      private var _alpha:Number = 1;
      
      private var _useFocusRectangle:Boolean = true;
      
      private var _bgOpaqueColor:uint = 0;
      
      private var _useBgOpaqueColor:Boolean = false;
      
      public function EnhancedTextArea()
      {
         super();
      }
      
      private static function setColor(param1:DisplayObject, param2:uint, param3:Number = 1) : void
      {
         var _loc4_:ColorTransform = param1.transform.colorTransform;
         _loc4_.color = param2;
         _loc4_.alphaMultiplier = param3;
         param1.transform.colorTransform = _loc4_;
      }
      
      public function get showBackground() : Boolean
      {
         return this._showBackground;
      }
      
      public function set showBackground(param1:Boolean) : void
      {
         this._showBackground = param1;
      }
      
      public function get useFocusRectangle() : Boolean
      {
         return this._useFocusRectangle;
      }
      
      public function set useFocusRectangle(param1:Boolean) : void
      {
         this._useFocusRectangle = param1;
      }
      
      public function get bgOpaqueColor() : uint
      {
         return this._bgOpaqueColor;
      }
      
      public function set bgOpaqueColor(param1:uint) : void
      {
         this._bgOpaqueColor = param1;
         this._useBgOpaqueColor = true;
      }
      
      public function set bgAlpha(param1:Number) : void
      {
         this._alpha = param1;
      }
      
      override protected function drawBackground() : void
      {
         if(this.showBackground)
         {
            super.drawBackground();
            if(this._useBgOpaqueColor)
            {
               setColor(this.background,this.bgOpaqueColor,this._alpha);
            }
         }
         else
         {
            this.background = new Shape();
         }
      }
      
      override protected function focusInHandler(param1:FocusEvent) : void
      {
         if(this.useFocusRectangle)
         {
            super.focusInHandler(param1);
         }
      }
      
      override protected function focusOutHandler(param1:FocusEvent) : void
      {
         if(this.useFocusRectangle)
         {
            super.focusOutHandler(param1);
         }
      }
   }
}

