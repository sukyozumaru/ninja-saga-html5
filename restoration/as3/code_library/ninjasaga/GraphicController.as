package ninjasaga
{
   import flash.display.MovieClip;
   import ninjasaga.battle.*;
   import ninjasaga.graphic.G_Character;
   
   public final class GraphicController
   {
      
      private static var instance:GraphicController;
      
      private var gCharacter:G_Character;
      
      public function GraphicController(param1:SingletonBlocker)
      {
         super();
         if(param1 == null)
         {
            throw new Error("Error: Instantiation failed: Use GraphicController.getInstance() instead of new.");
         }
         this.gCharacter = new G_Character();
      }
      
      public static function getInstance() : GraphicController
      {
         if(instance == null)
         {
            instance = new GraphicController(new SingletonBlocker());
         }
         return instance;
      }
      
      public function setupFace(param1:MovieClip, param2:String, param3:Number) : void
      {
         this.gCharacter.setupFace(param1,param2,param3);
      }
      
      public function setSkinColor(param1:MovieClip, param2:Number) : void
      {
         this.gCharacter.setFaceColor(param1,param2);
         this.gCharacter.setBodySetColor(param1,param2);
      }
      
      public function setupBodySet(param1:MovieClip, param2:String, param3:int, param4:Number) : void
      {
         this.gCharacter.setupBodySet(param1,param2,param3,param4);
      }
      
      public function setupWeapon(param1:MovieClip, param2:String, param3:int = 0) : void
      {
         this.gCharacter.setupWeapon(param1,param2,param3);
      }
      
      public function setupBackItem(param1:MovieClip, param2:String) : void
      {
         this.gCharacter.setupBackItem(param1,param2);
      }
      
      public function unSetupBackItem(param1:MovieClip) : void
      {
         this.gCharacter.unSetupBackitem(param1);
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
