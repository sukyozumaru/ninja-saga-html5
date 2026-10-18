package com.utils
{
   import flash.events.Event;
   import flash.media.Sound;
   import flash.media.SoundChannel;
   import flash.media.SoundMixer;
   import flash.media.SoundTransform;
   
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
      
      public function Mixer(pKey:SingletonBlocker)
      {
         super();
         if(pKey == null)
         {
            throw new Error("Error: Instantiation failed: Use Mixer.getInstance() instead of new.");
         }
         this.initSound();
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
         this.sfx = !this.sfx;
      }
      
      public function toggleMusic() : *
      {
         try
         {
            this.music = !this.music;
            if(!this.music)
            {
               if(this.musicChannel != null)
               {
                  this.musicChannel.stop();
               }
            }
            else
            {
               this.playMusic(this.bgMusic);
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
            this.music = !this.music;
            if(!this.music)
            {
               if(this.musicChannel != null)
               {
                  this.pauseSound();
               }
            }
            else
            {
               this.resumeSound();
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
         if(this.music && this.soundTransform.volume > 0)
         {
            return true;
         }
         return false;
      }
      
      public function pauseSound() : *
      {
         this.musicChannelPosition = this.musicChannel.position;
         this.musicChannel.stop();
      }
      
      public function resumeSound() : *
      {
         if(Boolean(this.bgMusic) && this.bgMusic[0] != null)
         {
            this.soundTransform.volume = this.volume;
            if(this.bgMusic.length > 0)
            {
               this.musicChannel = this.bgMusic[0].play(this.musicChannelPosition,999999999,this.soundTransform);
            }
            else
            {
               this.playMusic(this.bgMusic);
            }
         }
      }
      
      public function getSfx() : Boolean
      {
         return this.sfx;
      }
      
      public function getMusic() : Boolean
      {
         return this.music;
      }
      
      public function setMusic(bln:Boolean) : void
      {
         this.music = bln;
      }
      
      public function playSoundOnLeft(sound:Sound) : *
      {
         try
         {
            this.soundTransform.leftToLeft = 1;
            this.soundTransform.rightToRight = 0.5;
            this.soundTransform.volume = this.volume;
            if(this.sfx)
            {
               sound.play(0,0,this.soundTransform);
            }
         }
         catch(e:Error)
         {
            Out.error(this,e.getStackTrace());
         }
      }
      
      public function playSoundOnRight(sound:Sound) : *
      {
         try
         {
            this.soundTransform.leftToLeft = 0.5;
            this.soundTransform.rightToRight = 1;
            this.soundTransform.volume = this.volume;
            if(this.sfx)
            {
               sound.play(0,0,this.soundTransform);
            }
         }
         catch(e:Error)
         {
            Out.error(this,e.getStackTrace());
         }
      }
      
      public function playSound(sound:Sound) : *
      {
         try
         {
            this.soundTransform.volume = this.volume;
            if(this.sfx)
            {
               sound.play(0,0,this.soundTransform);
            }
         }
         catch(e:Error)
         {
            Out.error(this,e.getStackTrace());
            throw new Error("Mixer::playSound error");
         }
      }
      
      public function playSfx(sound:Sound, channelId:String) : *
      {
         try
         {
            if(this.latestSfxChannel >= this.sfxChannelAmount)
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
      
      public function stopSfx(channelId:String) : *
      {
         var channelIndex:int = -1;
         for(var i:int = 0; i < this.sfxChannelAmount - 1; i++)
         {
            if(this.sfxChannels[i].channelId == channelId)
            {
               channelIndex = i;
               break;
            }
         }
         if(channelIndex < 0)
         {
            throw new Error("Mixer::sfx channel ID not found");
         }
         this.sfxChannels[channelIndex].channelId = "";
         this.sfxChannels[channelIndex].sfxChannel.stop();
      }
      
      public function playMusic(_music:Array = null) : *
      {
         try
         {
            this.stopMusic();
            this.bgMusic = _music;
            this.soundTransform.volume = this.volume;
            if(this.music)
            {
               this.currentMusic = 0;
               if(this.bgMusic.length > 1)
               {
                  this.musicChannel = this.bgMusic[0].play(0,1,this.soundTransform);
                  this.musicChannel.addEventListener(Event.SOUND_COMPLETE,this.playNextMusic);
               }
               else
               {
                  this.musicChannel = this.bgMusic[0].play(0,999999999,this.soundTransform);
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
         return this.musicChannel;
      }
      
      public function getCurrentMusic() : Sound
      {
         return this.bgMusic[this.currentMusic];
      }
      
      public function getCurrentMusicLinkageString() : String
      {
         return this.bgMusic[0];
      }
      
      public function isPlayingMusic() : Boolean
      {
         try
         {
            if(this.music)
            {
               if(this.bgMusic.length > 0)
               {
                  return true;
               }
               return false;
            }
            return false;
         }
         catch(e:Error)
         {
            Out.error(this,e.getStackTrace());
            throw new Error("Mixer::playMusic error");
         }
      }
      
      public function playNextMusic(evt:Event) : *
      {
         try
         {
            ++this.currentMusic;
            if(this.music)
            {
               this.musicChannel.removeEventListener(Event.SOUND_COMPLETE,this.playNextMusic);
               if(this.currentMusic < this.bgMusic.length)
               {
                  this.musicChannel = this.bgMusic[this.currentMusic].play(0,1,this.soundTransform);
                  this.musicChannel.addEventListener(Event.SOUND_COMPLETE,this.playNextMusic);
               }
               else
               {
                  this.musicChannel = this.bgMusic[this.currentMusic - 1].play(0,999999999,this.soundTransform);
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
            if(this.music)
            {
               if(this.musicChannel != null)
               {
                  this.musicChannel.stop();
               }
            }
            this.bgMusic = new Array();
            this.musicChannelPosition = 0;
         }
         catch(e:Error)
         {
            Out.error(this,e.getStackTrace());
            throw new Error("Mixer::stopMusic error");
         }
      }
      
      public function setVolume(vol:Number) : void
      {
         try
         {
            this.volume = vol;
            this.soundTransform.volume = this.volume;
            this.musicChannel.soundTransform = this.soundTransform;
         }
         catch(e:Error)
         {
            Out.error(this,e.getStackTrace());
         }
      }
      
      public function getVolume() : Number
      {
         return this.soundTransform.volume;
      }
      
      public function initSound() : *
      {
         var i:int = 0;
         var newSfxChannel:SoundChannel = null;
         try
         {
            this.soundTransform = new SoundTransform();
            this.volume = 1;
            this.sfx = true;
            this.music = true;
            this.bgMusic = new Array();
            this.musicChannel = new SoundChannel();
            this.setVolume(this.volume);
            this.musicChannelPosition = 0;
            this.latestSfxChannel = 0;
            for(i = 0; i < this.sfxChannelAmount; i++)
            {
               newSfxChannel = new SoundChannel();
               newSfxChannel.soundTransform = this.soundTransform;
               this.sfxChannels.push({
                  "id":"",
                  "sfxChannel":""
               });
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
