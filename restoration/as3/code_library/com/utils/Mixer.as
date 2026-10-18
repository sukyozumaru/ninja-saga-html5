package com.utils
{
   import br.com.stimuli.loading.BulkLoader;
   import br.com.stimuli.loading.loadingtypes.*;
   import de.polygonal.ds.HashMap;
   import flash.display.*;
   import flash.events.*;
   import flash.media.Sound;
   import flash.media.SoundChannel;
   import flash.media.SoundMixer;
   import flash.media.SoundTransform;
   import flash.net.*;
   import flash.utils.*;
   import ninjasaga.*;
   import ninjasaga.base.*;
   import ninjasaga.data.AppData;
   import ninjasaga.data.BattleData;
   import ninjasaga.data.BloodlineData;
   import ninjasaga.data.DBCharacterData;
   import ninjasaga.data.Data;
   import ninjasaga.data.InventoryData;
   import ninjasaga.data.RankData;
   import ninjasaga.data.SenjutsuData;
   import ninjasaga.data.SkillData;
   import ninjasaga.data.Timeline;
   import ninjasaga.data.TitleData;
   
   public final class Mixer
   {
      
      private static var instance:Mixer;
      
      private var soundTransform:SoundTransform;
      
      private var volume:Number;
      
      private var pauseVolume:Number;
      
      private var sfx:Boolean;
      
      private var music:Boolean;
      
      private var musicChannel:SoundChannel;
      
      private var sfxChannel:*;
      
      private var bgMusic:Array;
      
      private var clickSnd:Sound;
      
      private var currentMusic:uint;
      
      private const sfxChannelAmount:uint = 10;
      
      private var sfxChannels:Array = [];
      
      private var latestSfxChannel:uint;
      
      private var musicChannelPosition:Number = 0;
      
      public function Mixer(param1:SingletonBlocker)
      {
         super();
         if(param1 == null)
         {
            throw new Error("Error: Instantiation failed: Use Mixer.getInstance() instead of new.");
         }
         initSound();
      }
      
      public static function getInstance() : Mixer
      {
         if(instance == null)
         {
            instance = new Mixer(new SingletonBlocker());
         }
         return instance;
      }
      
      public function muteAll() : *
      {
         try
         {
            SoundMixer.stopAll();
         }
         catch(e:Error)
         {
            Out.error(this,e.getStackTrace());
            throw new Error("Mixer::muteAll error");
         }
      }
      
      public function toggleSfx() : *
      {
         sfx = !sfx;
      }
      
      public function toggleMusic() : *
      {
         try
         {
            music = !music;
            if(!music)
            {
               if(musicChannel != null)
               {
                  musicChannel.stop();
               }
            }
            else
            {
               playMusic(bgMusic);
            }
         }
         catch(e:Error)
         {
            Out.error(this,e.getStackTrace());
            throw new Error("Mixer::toggleMusic error");
         }
      }
      
      public function musicPlayerToggleMusic() : *
      {
         try
         {
            music = !music;
            if(!music)
            {
               if(musicChannel != null)
               {
                  pauseSound();
               }
            }
            else
            {
               resumeSound();
            }
         }
         catch(e:Error)
         {
            Out.error(this,e.getStackTrace());
            throw new Error("Mixer::music player toggleMusic error");
         }
      }
      
      public function checkMusicByVolume() : Boolean
      {
         if(music && soundTransform.volume > 0)
         {
            return true;
         }
         return false;
      }
      
      public function pauseSound() : *
      {
         this.musicChannelPosition = musicChannel.position;
         musicChannel.stop();
      }
      
      public function resumeSound() : *
      {
         if(Boolean(bgMusic) && bgMusic[0] != null)
         {
            soundTransform.volume = volume;
            if(bgMusic.length > 0)
            {
               musicChannel = bgMusic[0].play(this.musicChannelPosition,999999999,soundTransform);
            }
            else
            {
               playMusic(bgMusic);
            }
         }
      }
      
      public function getSfx() : Boolean
      {
         return sfx;
      }
      
      public function getMusic() : Boolean
      {
         return music;
      }
      
      public function setMusic(param1:Boolean) : void
      {
         music = param1;
      }
      
      public function playSoundOnLeft(param1:Sound) : *
      {
         var sound:Sound = param1;
         try
         {
            soundTransform.leftToLeft = 1;
            soundTransform.rightToRight = 0.5;
            soundTransform.volume = volume;
            if(sfx)
            {
               sound.play(0,0,soundTransform);
            }
         }
         catch(e:Error)
         {
            Out.error(this,e.getStackTrace());
         }
      }
      
      public function playSoundOnRight(param1:Sound) : *
      {
         var sound:Sound = param1;
         try
         {
            soundTransform.leftToLeft = 0.5;
            soundTransform.rightToRight = 1;
            soundTransform.volume = volume;
            if(sfx)
            {
               sound.play(0,0,soundTransform);
            }
         }
         catch(e:Error)
         {
            Out.error(this,e.getStackTrace());
         }
      }
      
      public function playSound(param1:Sound) : *
      {
         var sound:Sound = param1;
         try
         {
            soundTransform.volume = volume;
            if(sfx)
            {
               sound.play(0,0,soundTransform);
            }
         }
         catch(e:Error)
         {
            Out.error(this,e.getStackTrace());
            throw new Error("Mixer::playSound error");
         }
      }
      
      public function playSfx(param1:Sound, param2:String) : *
      {
         var sound:Sound = param1;
         var channelId:String = param2;
         try
         {
            if(this.latestSfxChannel >= 10)
            {
               this.latestSfxChannel = 0;
            }
            if(this.sfxChannels[this.latestSfxChannel].sfxChannel != null)
            {
               this.sfxChannels[this.latestSfxChannel].sfxChannel.stop();
            }
            this.sfxChannels[this.latestSfxChannel].channelId = channelId;
            this.sfxChannels[this.latestSfxChannel].sfxChannel = sound.play(0,1,this.soundTransform);
            ++this.latestSfxChannel;
         }
         catch(e:Error)
         {
            Out.error(this,e.getStackTrace());
            throw new Error("Mixer::playSound error");
         }
      }
      
      public function stopSfx(param1:String) : *
      {
         var _loc2_:int = -1;
         var _loc3_:int = 0;
         while(_loc3_ < 10 - 1)
         {
            if(this.sfxChannels[_loc3_].channelId == param1)
            {
               _loc2_ = _loc3_;
               break;
            }
            _loc3_++;
         }
         if(_loc2_ < 0)
         {
            throw new Error("Mixer::sfx channel ID not found");
         }
         this.sfxChannels[_loc2_].channelId = "";
         this.sfxChannels[_loc2_].sfxChannel.stop();
      }
      
      public function playMusic(param1:Array = null) : *
      {
         var _music:Array = param1;
         try
         {
            stopMusic();
            bgMusic = _music;
            soundTransform.volume = volume;
            if(music)
            {
               currentMusic = 0;
               if(bgMusic.length > 1)
               {
                  musicChannel = bgMusic[0].play(0,1,soundTransform);
                  musicChannel.addEventListener(Event.SOUND_COMPLETE,playNextMusic);
               }
               else
               {
                  musicChannel = bgMusic[0].play(0,999999999,soundTransform);
               }
            }
            this.musicChannelPosition = 0;
         }
         catch(e:Error)
         {
            Out.error(this,e.getStackTrace());
            throw new Error("Mixer::playMusic error");
         }
      }
      
      public function getMusicChannel() : SoundChannel
      {
         return musicChannel;
      }
      
      public function getCurrentMusic() : Sound
      {
         return bgMusic[this.currentMusic];
      }
      
      public function getCurrentMusicLinkageString() : String
      {
         return bgMusic[0];
      }
      
      public function isPlayingMusic() : Boolean
      {
         try
         {
            if(music)
            {
               if(bgMusic.length > 0)
               {
                  return true;
               }
               return false;
            }
            return false;
         }
         catch(e:Error)
         {
            §§push(e);
            §§push(e);
            var _temp_1:* = §§pop();
            _temp_1.§§slot[1] = §§pop();
            Out.error(this,_temp_1.§§slot[1].getStackTrace());
            throw new Error("Mixer::playMusic error");
         }
      }
      
      public function playNextMusic(param1:Event) : *
      {
         var evt:Event = param1;
         try
         {
            ++currentMusic;
            if(music)
            {
               musicChannel.removeEventListener(Event.SOUND_COMPLETE,playNextMusic);
               if(currentMusic < bgMusic.length)
               {
                  musicChannel = bgMusic[currentMusic].play(0,1,soundTransform);
                  musicChannel.addEventListener(Event.SOUND_COMPLETE,playNextMusic);
               }
               else
               {
                  musicChannel = bgMusic[currentMusic - 1].play(0,999999999,soundTransform);
               }
            }
            this.musicChannelPosition = 0;
         }
         catch(e:Error)
         {
            Out.error(this,e.getStackTrace());
            throw new Error("Mixer::playNextMusic error");
         }
      }
      
      public function stopMusic() : *
      {
         try
         {
            if(music)
            {
               if(musicChannel != null)
               {
                  musicChannel.stop();
               }
            }
            bgMusic = new Array();
            this.musicChannelPosition = 0;
         }
         catch(e:Error)
         {
            Out.error(this,e.getStackTrace());
            throw new Error("Mixer::stopMusic error");
         }
      }
      
      public function setVolume(param1:Number) : void
      {
         var vol:Number = param1;
         try
         {
            volume = vol;
            soundTransform.volume = volume;
            musicChannel.soundTransform = soundTransform;
         }
         catch(e:Error)
         {
            Out.error(this,e.getStackTrace());
         }
      }
      
      public function getVolume() : Number
      {
         return soundTransform.volume;
      }
      
      public function initSound() : *
      {
         var i:int = 0;
         var newSfxChannel:SoundChannel = null;
         try
         {
            soundTransform = new SoundTransform();
            volume = 1;
            sfx = true;
            music = true;
            bgMusic = new Array();
            musicChannel = new SoundChannel();
            this.setVolume(volume);
            this.musicChannelPosition = 0;
            this.latestSfxChannel = 0;
            i = 0;
            while(i < 10)
            {
               newSfxChannel = new SoundChannel();
               newSfxChannel.soundTransform = soundTransform;
               this.sfxChannels.push({
                  "id":"",
                  "sfxChannel":""
               });
               i++;
            }
         }
         catch(e:Error)
         {
            Out.error(this,e.getStackTrace());
            throw new Error("Mixer::initSound error");
         }
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
