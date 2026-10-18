package menu_fla
{
   import adobe.utils.*;
   import flash.accessibility.*;
   import flash.desktop.*;
   import flash.display.*;
   import flash.errors.*;
   import flash.events.*;
   import flash.external.*;
   import flash.filters.*;
   import flash.geom.*;
   import flash.globalization.*;
   import flash.media.*;
   import flash.net.*;
   import flash.net.drm.*;
   import flash.printing.*;
   import flash.profiler.*;
   import flash.sampler.*;
   import flash.sensors.*;
   import flash.system.*;
   import flash.text.*;
   import flash.text.engine.*;
   import flash.text.ime.*;
   import flash.ui.*;
   import flash.utils.*;
   import flash.xml.*;
   import ninjasaga.linkage.UIModule_TrainTimer;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol1848")]
   public dynamic class skill_panel_mc_589 extends MovieClip
   {
      
      public var btnClear:MovieClip;
      
      public var btnTab5:MovieClip;
      
      public var btnPreview:MovieClip;
      
      public var cooldownTxt:TextField;
      
      public var descriptionTxt:TextField;
      
      public var lbl_genjutsu:TextField;
      
      public var pageTxt:TextField;
      
      public var btnPrevPage:SimpleButton;
      
      public var btnReturnProfile:MovieClip;
      
      public var skillTypeIcon:MovieClip;
      
      public var cpTxt:TextField;
      
      public var iconChakra:MovieClip;
      
      public var btnNextPage:SimpleButton;
      
      public var skill_0:MovieClip;
      
      public var lbl_taijutsu:TextField;
      
      public var btnClose:SimpleButton;
      
      public var btnSkillClear0:SimpleButton;
      
      public var skill_1:MovieClip;
      
      public var item_1:ItemDisplay;
      
      public var btnSkillClear1:SimpleButton;
      
      public var skill_2:MovieClip;
      
      public var item_2:ItemDisplay;
      
      public var charMc:MovieClip;
      
      public var btnSkillClear2:SimpleButton;
      
      public var skill_3:MovieClip;
      
      public var item_3:ItemDisplay;
      
      public var btnUpgradeTab:MovieClip;
      
      public var btnSkillClear3:SimpleButton;
      
      public var skill_4:MovieClip;
      
      public var item_4:ItemDisplay;
      
      public var iconMC:MovieClip;
      
      public var btnSkillClear4:SimpleButton;
      
      public var skill_5:MovieClip;
      
      public var item_5:ItemDisplay;
      
      public var iconLv:MovieClip;
      
      public var btnSkillClear5:SimpleButton;
      
      public var skill_6:MovieClip;
      
      public var item_6:ItemDisplay;
      
      public var btnSkillClear6:SimpleButton;
      
      public var skill_7:MovieClip;
      
      public var item_10:ItemDisplay;
      
      public var item_7:ItemDisplay;
      
      public var lbl_jutsu_title:TextField;
      
      public var btnEquip:MovieClip;
      
      public var btnSkillClear7:SimpleButton;
      
      public var item_11:ItemDisplay;
      
      public var item_8:ItemDisplay;
      
      public var healTxt:TextField;
      
      public var lvlTxt:TextField;
      
      public var btnTab0:MovieClip;
      
      public var item_12:ItemDisplay;
      
      public var item_9:ItemDisplay;
      
      public var iconCooldown:MovieClip;
      
      public var healIcon:MovieClip;
      
      public var btnTab1:MovieClip;
      
      public var lbl_ninjutsu:TextField;
      
      public var progressMc:UIModule_TrainTimer;
      
      public var btnTab2:MovieClip;
      
      public var btnReply:MovieClip;
      
      public var academyBtn:MovieClip;
      
      public var damageTxt:TextField;
      
      public var nameTxt:TextField;
      
      public var btnTab3:MovieClip;
      
      public var btnUpgrade:MovieClip;
      
      public var btnResetSkill:MovieClip;
      
      public var damageIcon:MovieClip;
      
      public var btnTab4:MovieClip;
      
      public function skill_panel_mc_589()
      {
         super();
         addFrameScript(0,this.frame1,5,this.frame6);
      }
      
      internal function frame1() : *
      {
         this.stop();
      }
      
      internal function frame6() : *
      {
         this.stop();
         MovieClip(this.parent).onSkillPreview();
      }
   }
}

