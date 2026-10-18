package com.utils
{
   import flash.filters.ColorMatrixFilter;
   import flash.filters.GlowFilter;
   
   public final class CreateFilter
   {
      
      public function CreateFilter()
      {
         super();
      }
      
      public static function getSaturationFilter(param1:Number) : ColorMatrixFilter
      {
         var _loc2_:Array = [1,0,0,0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,1,0];
         _loc2_[0] = (1 - param1) * 0.3086 + param1;
         _loc2_[1] = (1 - param1) * 0.6094;
         _loc2_[2] = (1 - param1) * 0.082;
         _loc2_[5] = (1 - param1) * 0.3086;
         _loc2_[6] = (1 - param1) * 0.6094 + param1;
         _loc2_[7] = (1 - param1) * 0.082;
         _loc2_[10] = (1 - param1) * 0.3086;
         _loc2_[11] = (1 - param1) * 0.6094;
         _loc2_[12] = (1 - param1) * 0.082 + param1;
         _loc2_[18] = 1;
         return new ColorMatrixFilter(_loc2_);
      }
      
      public static function getBrightnessFilter(param1:Number) : ColorMatrixFilter
      {
         var _loc2_:Array = [1,0,0,0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,1,0];
         _loc2_[0] = param1;
         _loc2_[6] = param1;
         _loc2_[12] = param1;
         _loc2_[18] = 1;
         return new ColorMatrixFilter(_loc2_);
      }
      
      public static function getGlowFilter(param1:Object = null) : GlowFilter
      {
         var _loc2_:Number = 16711680;
         var _loc3_:Number = 2;
         if(param1 != null)
         {
            if(param1.color != null)
            {
               _loc2_ = Number(param1.color);
            }
            if(param1.strength != null)
            {
               _loc3_ = Number(param1.strength);
            }
         }
         return new GlowFilter(_loc2_,1,6,6,_loc3_);
      }
   }
}

