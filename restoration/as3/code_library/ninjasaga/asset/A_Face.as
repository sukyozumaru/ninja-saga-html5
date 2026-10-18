package ninjasaga.asset
{
   import com.utils.GF;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import ninjasaga.loader.AssetLoader;
   
   public class A_Face extends Sprite
   {
      
      public var faceId:String;
      
      private var swfPath:String;
      
      private var skinColor:Number = -1;
      
      private var displayMc:MovieClip;
      
      private var exportName:String = "face";
      
      public function A_Face(param1:String, param2:Number)
      {
         super();
         this.faceId = param1;
         this.skinColor = param2;
         this.swfPath = getSwfPath(this.faceId);
         new AssetLoader(this.swfPath,this,this.exportName,this.onLoadComplete);
      }
      
      public static function getSwfPath(param1:String) : String
      {
         var _loc2_:String = param1;
         return "swf/items/" + _loc2_ + ".swf";
      }
      
      public function setColor(param1:Number) : void
      {
         this.skinColor = param1;
         if(Boolean(this.displayMc) && this.skinColor > 0)
         {
            GF.changeColor(this.displayMc["skin_color"],this.skinColor);
         }
      }
      
      private function onLoadComplete(param1:AssetLoader) : void
      {
         this.displayMc = param1.displayObj;
         this.setColor(this.skinColor);
      }
   }
}

