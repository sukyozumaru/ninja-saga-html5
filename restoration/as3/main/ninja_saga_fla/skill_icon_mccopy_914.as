package ninja_saga_fla
{
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol2058")]
   public dynamic class skill_icon_mccopy_914 extends MovieClip
   {
      
      public var clickMask:MovieClip;
      
      public var redcross:MovieClip;
      
      public var cdTxt:TextField;
      
      public var holder:MovieClip;
      
      public function skill_icon_mccopy_914()
      {
         super();
         addFrameScript(0,this.frame1,1,this.frame2,5,this.frame6,10,this.frame11,15,this.frame16);
      }
      
      internal function frame1() : *
      {
         this.redcross.visible = false;
         this.redcross.mouseEnabled = false;
      }
      
      internal function frame2() : *
      {
         this.stop();
      }
      
      internal function frame6() : *
      {
         this.stop();
      }
      
      internal function frame11() : *
      {
         this.stop();
      }
      
      internal function frame16() : *
      {
         this.stop();
      }
   }
}

