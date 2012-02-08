package junlas.music
{
import flash.events.EventDispatcher;
import flash.events.Event;
import flash.events.TimerEvent;
import flash.media.Sound;
import flash.media.SoundChannel;
import flash.media.SoundTransform;
import flash.utils.Timer;
import flash.utils.getDefinitionByName;

//	import flash.utils.getDefinitionByName;	
	
/**
 * maoliang更新
 * 
 * @author lvjun
 * 
 * 标识music代表背景声音,特点是：同时只能播放一个&&循环播放
 * 标识sound代表事件声音，特点是：同时可播放N个&&播放完指定循环次数后会清除
 * 
 * 功能实现:music声音开关,music音量控制,music声音淡入淡出,music声音暂停,
 * 单一sound音量控制,sound音量控制&&控制sound循环次数,可以播放同一个sound且可覆盖||不覆盖||无效
 * 
 */
public class SoundsManager
{
    private static var currentInstance : SoundsManager;
    private var curMusic_rp : int;

    //单例模式实现静态工具类
    public static function get instance() : SoundsManager 
    {
        if(currentInstance == null)
        {
            currentInstance = new SoundsManager();
        }
        return currentInstance;
    }

    //声音每次淡入淡出大小
    private const VALUE_FADE : Number = 0.02;
    //声音淡入淡出前后所占用时间,单们毫秒
    private var fadeTimes : int;
    //背景声音音量
    private var valueMusic : Number;
    //事件声音音量
    private var valueSound : Number;
    //组声音音量
    private var valueGroupSound : Number;
    //当前背景声音标识
    private var curMusic_st : String;
    //当前背景声音
    private var curMusic_so : Sound;
    //当前背景声音控制
    private var curMusic_sc : SoundChannel;
    private var pauseMusic_st : String;
    //存储所有当前正在播放's事件声音
    private var soundArr : Array;
    //组声音
    private var groupSoundArr : Array;
    private var currGroupSoundId : int;
    //记录声音暂停位置
    private var pausePos : Number;
    //记录淡入标识
    private var fadeInLabel : String;
    //声音开关控制
    private var enabled : Boolean;
    private var fadeInTimer : Timer;
    private var musicEnabled : Boolean;
    private var fadeOutTimer : Timer;
    private var _currLengthTimer : Timer;
    public function SoundsManager() 
    {
        init();
    }

    //返回淡入淡出时间
    public function get FadeTimes() : int 
    {
        return fadeTimes;
    }

    //设置声音从0淡入至目标音量所占用时间
    public function set FadeTimes(v : int) : void 
    {
        fadeTimes = v;
    }

    //返回声音开关
    public function get Enabled() : Boolean 
    {
        return enabled;
    }

    //声音开关
    public function set Enabled(b : Boolean) : void 
    {
        enabled = b;
        if(b)
			{
				//restartMusic();
			}
        else 
        {
            //pauseMusic();
            stopAllSound();
        }
    }

    //返回音乐开关
    public function get MusicEnable() : Boolean 
    {
        return musicEnabled;
    }

    //音乐开关
    public function set MusicEnable(b : Boolean) : void 
    {
        musicEnabled = b;
        if(curMusic_st != null) 
        {
            if(b) 
            {
                restartMusic();
            }
            else 
            {
                pauseMusic();
            }
        }
    }

    //返回背景声音音量
    public function get ValueMusic() : Number 
    {
        return valueMusic;
    }

    //背景声音音量控制
    public function set ValueMusic(n : Number) : void 
    {
        valueMusic = n;
			
        if(curMusic_sc != null) 
        {
            //curMusic_sc.soundTransform.volume = n;
            var transform : SoundTransform = curMusic_sc.soundTransform;
            transform.volume = n;
            curMusic_sc.soundTransform = transform;
        }
    }

    //返回事件声音音量控制
    public function get ValueSound() : Number 
    {
        return valueSound;
    }

    //事件音量控制
    public function set ValueSound(n : Number) : void 
    {
        valueSound = n;
			
        if(soundArr != null) 
        {
            for(var i : int = 0;i < soundArr.length;i++) 
            {
                //soundArr[i]["soundChannel"].soundTransform.volume = n;
                var transform : SoundTransform = soundArr[i]["soundChannel"].soundTransform;
                transform.volume = n;
                soundArr[i]["soundChannel"].soundTransform = transform;
            }
        }
    }

    public function get ValueGroupSound() : Number 
    {
        return valueGroupSound;
    }

    public function set ValueGroupSound(n : Number) : void 
    {
        valueGroupSound = n;
        if(groupSoundArr != null) 
        {
            //groupSoundArr[currGroupSoundId]["soundChannel"].soundTransform.volume = n;
            var transform : SoundTransform = groupSoundArr[currGroupSoundId]["soundChannel"].soundTransform;
            transform.volume = n;
            groupSoundArr[currGroupSoundId]["soundChannel"].soundTransform = transform;
        }
    }

    public function get currentMusic_sc() : String 
    {
        if(curMusic_sc == null)
			return null;
        return curMusic_st;
    }

    //设置单一正在播放事件声音's音量
    public function setOneValueSound(s : String,n : Number) : void 
    {
        for(var i : int = 0;i < soundArr.length;i++) 
        {
            if(s == soundArr[i]["label"])
				//soundArr[i]["soundChannel"].soundTransform.volume = n;
				var transform : SoundTransform = soundArr[i]["soundChannel"].soundTransform;
            transform.volume = n;
            soundArr[i]["soundChannel"].soundTransform = transform;
        }
    }

    //播放事件声音:s声音标识；v音量默认为设定音量;loops为播放循环次数,如出现同名声音播放则相互无影响
    public function playSound(s : String,v : Number,loops : int = 0) : void 
    {
        //trace(s);
        if(enabled) 
        {
            initSound(s, v, loops);
        }	
    }

    //播放事件声音:s声音标识；v音量默认为设定音量;loops为播放循环次数,如出现同名声音播放则覆盖原声音(原声音停止,重新播放该标识声音)
    public function overOldSound(s : String,v : Number,loops : int = 0) : void 
    {
        if(enabled) 
        {
            var same : Boolean = false;
            var obj : Object;
            for(var i : int = 0;i < soundArr.length;i++) 
            {
                obj = soundArr[i];
                if(obj["label"] == s) 
                {
                    same = true;
                    break;
                }
            }
            //如果出现同名,原声音停止
            if(same) 
            {
                delSound(obj["soundChannel"]);
            }
            playSound(s, v, loops);
        }
    }

    //播放事件声音:s声音标识；v音量默认为设定音量;loops为播放循环次数,如出现同名声音播放则不作任何动作(原声音继续)
    public function overNewSound(s : String,v : Number,loops : int = 0) : void 
    {
        if(enabled) 
        {
            var same : Boolean = false;
            var obj : Object;
            for(var i : int = 0;i < soundArr.length;i++) 
            {
                obj = soundArr[i];
                if(obj["label"] == s) 
                {
                    same = true;
                    break;
                }
            }
            //如果未出现同名,正常播放sound
            if(!same) 
            {
                playSound(s, v, loops);
            }
        }
    }

    //停止某一事件声音
    public function stopSound(s : String) : void 
    {
        var obj : Object;
        for(var i : int = 0;i < soundArr.length;i++) 
        {
            obj = soundArr[i];
            if(obj["label"] == s) 
            {
                delSound(obj["soundChannel"]);
                break;
            }
        }
    }	

    //停止所有正在播放‘s事件声音
    public function stopAllSound() : void 
    {
        for(var i : int = 0;i < soundArr.length;i++) 
        {
			//我后来修改了
			if(soundArr[i]["label"] == "menu_press.wav")
			{
				continue;
			}
            delSound(soundArr[i]["soundChannel"]);
        }
    }

    //播放背景声音:s声音标识；v音量默认为设定音量
    public function playMusic(s : String,v : Number,t : int = int.MAX_VALUE) : void 
    {
        curMusic_st = s;
        curMusic_rp = t;
        if(musicEnabled) 
        {
            if(curMusic_sc != null)
            {
                stopMusic();
            }
            initMusic(s, v, t);
        }			
    }

    //如出现同名声音播放则不作任何动作(原声音继续)
    public function overNewMusic(s : String,v : Number) : void 
    {
        if(curMusic_st != s && musicEnabled) 
        {
            playMusic(s, v);
        }
    }

    //停止背景声音
    public function stopMusic() : void 
    {
        if(curMusic_sc != null)
        {
            delMusic();
        }
    }

    //淡入背景声音
    public function fadeInMusic(s : String,t : int = int.MAX_VALUE) : void 
    {
        curMusic_st = s;
        curMusic_rp = t;
        if(musicEnabled) 
        {
            if(curMusic_sc != null) 
            {
                fadeInLabel = s;
                startFadeOut();
            }
            else 
            {
                startFadeIn(s, t);
            }
        }	
    }

    //淡出背景声音
    public function fadeOutMusic() : void 
    {
        if(curMusic_sc != null) 
        {
            startFadeOut();
        }
    }

    //暂停背景声音
    public function pauseMusic() : void 
    {
        if(curMusic_sc != null) 
        {
            pausePos = curMusic_sc.position;
            curMusic_sc.stop();
            curMusic_sc = null;
            pauseMusic_st = curMusic_st;
        }
    }

    //当前的背景声音。sound
    public function get curMusic_sound() : Sound 
    {
        return curMusic_so;
    }

    //暂停后继续
    public function restartMusic() : void 
    {
        if(pauseMusic_st == curMusic_st)
        {
            var musicChannel : SoundChannel = curMusic_so.play(pausePos, 1, new SoundTransform(valueMusic));
            initMusicSoundChannel(musicChannel);
            pausePos = NaN;
        }
        else
        {
            initMusic(curMusic_st, ValueMusic);
        }
    }	

    //播放一组声音,a 存放声音(str标识),v该组声音音量,startId为开始播放位置
    //		public function playGroupSound(a : Array,v : Number ,startId : int) : void
    //		{
    //			if(enabled)
    //			{
    //				currGroupSoundId = startId;
    //				valueGroupSound = v;
    //				 
    //				for(var i : int = 0;i < a.length;i ++)
    //				{
    //					var obj : Object = new Object();
    //					obj["label"] = a[i];
    //					obj["sound"] = Attach.getSound(a[i]);		
    //					groupSoundArr.push(obj);
    //				}
    //				initGroupSound();
    //			}
    //		}
		
    //停止播放一组声音
    public function stopGroupSound() : void 
    {
        if(groupSoundArr != null) 
        {
            var obj : Object = groupSoundArr[currGroupSoundId];
            if(obj != null) 
            {
                delGroupSoundChannelEvent(obj["soundChannel"]);
                delGroupSound();
            }
				
            groupSoundArr = new Array();
            currGroupSoundId = NaN;
        }
    }

    //循环播放组内声音
    private function initGroupSound() : void 
    {
        var obj : Object = groupSoundArr[currGroupSoundId];
        obj["soundChannel"] = obj["sound"].play(0, 0, new SoundTransform(valueGroupSound));
        initGroupSoundChannelEvent(obj["soundChannel"]);
    }

    private function delGroupSound() : void 
    {
        var obj : Object = groupSoundArr[currGroupSoundId];
        obj["soundChannel"].stop();
        obj["soundChannel"] = null;
    }

    private function initGroupSoundChannelEvent(sc : SoundChannel) : void 
    {
        sc.addEventListener(Event.SOUND_COMPLETE, groupSoundCompleteHandler);
    }

    private function delGroupSoundChannelEvent(sc : SoundChannel) : void 
    {
        sc.removeEventListener(Event.SOUND_COMPLETE, groupSoundCompleteHandler);
    }	

    private function groupSoundCompleteHandler(e : Event) : void 
    {
        delGroupSound();
        currGroupSoundId++;
        if(currGroupSoundId == groupSoundArr.length) 
        {
            currGroupSoundId = 0;
        }
        initGroupSound();
    }

    //设置默认值
    private function init() : void 
    {
        FadeTimes = 300;
        Enabled = true;
        MusicEnable = true;
        ValueMusic = 1;
        ValueSound = 1;
        valueGroupSound = 1;
			
        soundArr = new Array();
        groupSoundArr = new Array();
        
        _currLengthTimer = new Timer(1/30);
        _currLengthTimer.addEventListener(TimerEvent.TIMER, currLengthTimerHandle);
    }

    private function currLengthTimerHandle(event : TimerEvent) : void
    {
        if(curMusic_so && curMusic_sc)
        {
        	//trace("=====>",curMusic_sc.position / curMusic_so.length);
            if(curMusic_sc.position / curMusic_so.length >= 0.999)
            {
                curMusic_sc.dispatchEvent(new Event(Event.SOUND_COMPLETE));
            }
        }
    }

    private function initMusic(s : String,v : Number,t : int = int.MAX_VALUE) : void 
    {
        curMusic_st = s;
        curMusic_so = getSound(s);
        curMusic_rp = t;
        curMusic_sc = curMusic_so.play(0, 1, new SoundTransform(v));
        initMusicSoundChannel(curMusic_sc);
        _currLengthTimer.start();
    }

    private function initMusicSoundChannel(musicChannel : SoundChannel) : void 
    {
        if(!musicChannel)
        {
            return;
        }
        if(curMusic_sc)
        {
            curMusic_sc.removeEventListener(Event.SOUND_COMPLETE, musicCompleteHandler);
            curMusic_sc = null;
        }
        curMusic_sc = musicChannel;
        curMusic_sc.addEventListener(Event.SOUND_COMPLETE, musicCompleteHandler);
    }

    private function musicCompleteHandler(event : Event) : void 
    {
        curMusic_rp--;
        if(curMusic_rp > 0)
        {
            var musicChannel : SoundChannel = curMusic_so.play(0, 1, new SoundTransform(valueMusic));
            initMusicSoundChannel(musicChannel);
        }
    }

    private function delMusic() : void 
    {
        if(curMusic_sc)
        {
            curMusic_sc.stop();
            curMusic_sc.removeEventListener(Event.SOUND_COMPLETE, musicCompleteHandler);
            curMusic_sc = null;
        }
        curMusic_st = null;
        curMusic_so = null;
    }

    private function initSound(s : String,v : Number,loops : int) : void 
    {
			
        var obj : Object = new Object();
        obj["label"] = s;
        obj["sound"] = getSound(s);
        obj["soundChannel"] = obj["sound"].play(0, loops, new SoundTransform(v));
			
        initSoundChannelEvent(obj["soundChannel"]);	
        addSoundArr(obj);
    }

    private function delSound(sc : SoundChannel) : void 
    {
        delSoundChannelEvent(sc);
        remSoundArr(sc);
    }

    private function initSoundChannelEvent(sc : SoundChannel) : void 
    {
        if(sc)
        {
            sc.addEventListener(Event.SOUND_COMPLETE, soundCompleteHandler);
        }
    }

    private function delSoundChannelEvent(sc : SoundChannel) : void 
    {
        if(sc)
        {
            sc.removeEventListener(Event.SOUND_COMPLETE, soundCompleteHandler);
        }
    }	

    private function soundCompleteHandler(e : Event) : void 
    {
        delSound(e.target as SoundChannel);
    }

    private function addSoundArr(obj : Object) : void 
    {
        soundArr.push(obj);
    }

    private function remSoundArr(sc : SoundChannel) : void 
    {
        var obj : Object;
        for(var i : int = 0;i < soundArr.length;i++) 
        {
            obj = soundArr[i];
            if(obj["soundChannel"] && obj["soundChannel"] == sc) 
            {
                obj["soundChannel"].stop();
                obj["label"] = null;
                obj["sound"] = null;
                obj["soundChannel"] = null;
                soundArr.splice(i, 1);
            }
        }
    }

    private function startFadeOut() : void 
    {
        initFadeOutTimer();
    }

    //完成淡出后(背景声音音量淡出到无声后)所执行动作
    private function stopFadeOut() : void 
    {
        //删除Timer事件
        delFadeOutTimer();
        //删除背景声音
        delMusic();
        //如果淡出后需接着淡入
        if(fadeInLabel != null) 
        {
            initMusic(fadeInLabel, 0, curMusic_rp);
            initFadeInTimer();
            fadeInLabel = null;
        }
    }

    private function initFadeOutTimer() : void 
    {
        if(fadeOutTimer)
        {
            return;
        }
        if(fadeInTimer)
        {
            delFadeInTimer();
        }
        fadeOutTimer = new Timer(fadeTimes / (valueMusic / VALUE_FADE));
        fadeOutTimer.addEventListener(TimerEvent.TIMER, fadeOut);
        fadeOutTimer.start();
    }

    private function delFadeOutTimer() : void 
    {
        fadeOutTimer.stop();
        fadeOutTimer.removeEventListener(TimerEvent.TIMER, fadeOut);
        fadeOutTimer = null;
    }

    private function fadeOut(e : TimerEvent) : void 
    {
        if(curMusic_sc)
        {
            var transform : SoundTransform = curMusic_sc.soundTransform;
            transform.volume -= VALUE_FADE;
            curMusic_sc.soundTransform = transform;
            //curMusic_sc.soundTransform.volume -= VALUE_FADE;
            if(curMusic_sc.soundTransform.volume <= 0) 
            {
                stopFadeOut();
            }
        }
    }

    private function startFadeIn(s : String,t : int) : void 
    {
        //TODO:淡入时要从30%到100%的音量
        initMusic(s, 0.3, t);
        //initMusic(s, 0);
        initFadeInTimer();
    }

    //完成淡入后(背景声音音量淡入到目标音量后)所执行动作
    private function stopFadeIn() : void 
    {
        //完成谈入后,音量有可能超出,作一次矫正
        //curMusic_sc.soundTransform.volume = valueMusic;
        if(curMusic_sc && curMusic_sc.soundTransform)
        {
            var transform : SoundTransform = curMusic_sc.soundTransform;
		
            transform.volume = valueMusic;
            curMusic_sc.soundTransform = transform;
            //完成谈入后,Timer事件
            delFadeInTimer();
        }
    }

    private function initFadeInTimer() : void 
    {
        if(fadeInTimer)
        {
            return;
        }
        if(fadeOutTimer)
        {
            delFadeOutTimer();
        }
        fadeInTimer = new Timer(fadeTimes / (valueMusic / VALUE_FADE));
        fadeInTimer.addEventListener(TimerEvent.TIMER, fadeIn);
        fadeInTimer.start();
    }

    private function delFadeInTimer() : void 
    {
        fadeInTimer.stop();
        fadeInTimer.removeEventListener(TimerEvent.TIMER, fadeIn);
        fadeInTimer = null;
    }

    //TODO:在淡出和淡入之间进行操作时，会报timer的空指针，要在将enable或musicEnable设为false时，将其置为空
    public function delAllTimer() : void 
    {
        if(fadeInTimer != null) 
        {
            fadeInTimer.removeEventListener(TimerEvent.TIMER, fadeIn);
            fadeInTimer = null;
        }
        if(fadeOutTimer != null) 
        {
            fadeOutTimer.removeEventListener(TimerEvent.TIMER, fadeOut);
            fadeOutTimer = null;
        }
    }

    public function addAllTimer() : void 
    {
        if(fadeInTimer == null) 
        {
            fadeInTimer = new Timer(fadeTimes / (valueMusic / VALUE_FADE));
            fadeInTimer.addEventListener(TimerEvent.TIMER, fadeIn);
            fadeInTimer.start();
        }
        if(fadeOutTimer == null) 
        {
            fadeOutTimer = new Timer(fadeTimes / (valueMusic / VALUE_FADE));
            fadeOutTimer.addEventListener(TimerEvent.TIMER, fadeOut);
            fadeOutTimer.start();
        }
    }

    private function fadeIn(e : TimerEvent) : void 
    {
        if(curMusic_sc)
        {
            var transform : SoundTransform = curMusic_sc.soundTransform;
            transform.volume += VALUE_FADE;
            curMusic_sc.soundTransform = transform;
            if(curMusic_sc.soundTransform.volume >= valueMusic) 
            {
                stopFadeIn();
            }
        }
			//curMusic_sc.soundTransform.volume += VALUE_FADE;
    }

    private function getSound(s : String) : Sound 
    {
        var temp : Class = getDefinitionByName(s) as Class;
        var returnObj : Sound = new temp();
        return returnObj; 
    }
		
			
		//从库里得到某一sound子类
//		private function getSound(s : String) : Sound
//		{
//			var temp : Class = getDefinitionByName(s) as Class;
//			var ro : Sound = new temp();
//			return ro; 
//		}
}
}
