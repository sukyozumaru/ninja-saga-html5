package ninjasaga.asset
{
   import com.utils.GF;
   import com.utils.Mixer;
   import flash.display.MovieClip;
   import flash.media.Sound;
   import ninjasaga.data.Data;
   import ninjasaga.loader.AssetLoader;
   
   public class A_Sound
   {
      
      private var swfName:String;
      
      private var className:String;
      
      private var callback:Function;
      
      private var swf:MovieClip;
      
      public function A_Sound(param1:String, param2:String, param3:Function)
      {
         var _loc4_:String = null;
         super();
         this.swfName = param1;
         this.className = param2;
         this.callback = param3;
         _loc4_ = Data.genSwfFilePath("sound",this.swfName);
         new AssetLoader(_loc4_,null,null,this.onLoadComplete);
      }
      
      public function play() : void
      {
         var _loc1_:Sound = GF.getAsset(this.swf,this.className);
         var _loc2_:Array = [];
         _loc2_.push(_loc1_);
         Mixer.getInstance().playMusic(_loc2_);
      }
      
      public function stop() : void
      {
         Mixer.getInstance().stopMusic();
      }
      
      private function onLoadComplete(param1:AssetLoader) : void
      {
         this.swf = param1.swf;
         this.callback(this);
      }
   }
}

