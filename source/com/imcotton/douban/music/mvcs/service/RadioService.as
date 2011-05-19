package com.imcotton.douban.music.mvcs.service
{

import com.imcotton.douban.music.events.RadioServiceEvent;
import com.imcotton.douban.music.mvcs.model.IRadioSignalEnum;
import com.imcotton.douban.music.mvcs.model.PlayListModel;

import flash.media.Sound;
import flash.net.URLRequest;
import flash.net.URLRequestHeader;

import org.osflash.signals.Signal;
import org.osmf.elements.AudioElement;
import org.osmf.elements.SoundLoader;
import org.osmf.events.LoadEvent;
import org.osmf.events.MediaErrorEvent;
import org.osmf.events.TimeEvent;
import org.osmf.media.MediaPlayer;
import org.osmf.media.URLResource;
import org.osmf.traits.LoadTrait;
import org.osmf.traits.MediaTraitType;
import org.robotlegs.core.IInjector;
import org.robotlegs.mvcs.Actor;
import org.swiftsuspenders.Injector;


public class RadioService extends Actor implements IRadioService
{

    [Inject]
    public var contextInjector:IInjector;

    [Inject]
    public var playListModel:PlayListModel;

    public function RadioService ()
    {
        this.init();
    }

    [PostConstruct]
    public function postConstruct ():void
    {
        this.contextInjector.mapValue(IRadioSignalEnum, this.radioSignalEmun);
    }

    private var sound:Sound;

    private var radioSignalEmun:RadioSignalEnum;

    private var loader:SoundLoader;
    private var element:AudioElement;

    private var player:MediaPlayer;

    private var retry:RetryClock;

    public function get repeat ():Boolean
    {
        return this.player.loop;
    }

    public function set repeat ($value:Boolean):void
    {
        this.player.loop = $value;
    }

    public function get volume ():Number
    {
        return this.player.volume;
    }

    public function set volume ($value:Number):void
    {
        this.player.volume = $value;
    }

    public function load ($url:String, $duration:Number = NaN):void
    {
        if (!$url)
            return;

        if (!this.retry.isRetryCall)
            this.retry.reset();

        var loadable:LoadTrait = this.element.getTrait(MediaTraitType.LOAD) as LoadTrait;

        if (this.element.resource && loadable)
        {
            try { this.loader.unload(loadable); }
            catch (error:Error) { /* never mind */ }
        }

        this.element.resource = new URLResource($url);

        if ($duration)
            this.element.defaultDuration = $duration;
    }

    public function pause ():void
    {
        try { this.player.pause() }
        catch (error:Error) { }
    }

    public function play ():void
    {
        this.player.play();
    }

    private function init ():void
    {
        this.retry = new RetryClock();

        var inject:Injector = new Injector();
            inject.mapValue(Signal, new Signal(Number, int, int), "load");
            inject.mapValue(Signal, new Signal(Number, Number, Number), "play");

        this.radioSignalEmun = inject.instantiate(RadioSignalEnum);

        var request:URLRequest = new URLRequest();
            request.requestHeaders = [new URLRequestHeader("Referer", "http://www.douban.com")];

        this.loader = new SoundLoader();
        this.loader.urlRequest = request;

        this.element = new AudioElement(null, this.loader);

        this.player = new MediaPlayer(this.element);
        this.player.volume = 0.8;
        this.player.bufferTime = 2;
        this.player.autoRewind = true;
        this.player.loop = false;

        this.player.addEventListener(LoadEvent.BYTES_LOADED_CHANGE, player_onLoading);
        this.player.addEventListener(TimeEvent.CURRENT_TIME_CHANGE, player_onTimeChange);
        this.player.addEventListener(TimeEvent.COMPLETE, player_onComplete);
        this.player.addEventListener(MediaErrorEvent.MEDIA_ERROR, player_onError);
    }

    private function player_onError (event:MediaErrorEvent):void
    {
        if (!this.retry.next(fun))
            this.dispatch(new RadioServiceEvent(RadioServiceEvent.RETRY_FAIL));

        function fun ($step:int, $length:int):void
        {
            dispatch(new RadioServiceEvent(RadioServiceEvent.RETRYING));
            load(loader.urlRequest.url, element.defaultDuration);
        }
    }

    private function player_onTimeChange (event:TimeEvent):void
    {
        this.radioSignalEmun._playProgressSignal.dispatch
        (
            this.player.currentTime / this.player.duration,
            this.player.currentTime,
            this.element.defaultDuration || this.player.duration
        );
    }

    private function player_onLoading (event:LoadEvent):void
    {
        this.radioSignalEmun._loadProgressSignal.dispatch
        (
            this.player.bytesLoaded / this.player.bytesTotal,
            this.player.bytesLoaded,
            this.player.bytesTotal
        );
    }

    private function player_onComplete (event:TimeEvent):void
    {
        if (!this.player.loop)
            this.dispatch(new RadioServiceEvent(RadioServiceEvent.COMPLETE));
    }

}
}



import com.imcotton.douban.music.mvcs.model.IRadioSignalEnum;

import flash.utils.clearTimeout;
import flash.utils.setTimeout;

import org.osflash.signals.ISignal;
import org.osflash.signals.Signal;


class RadioSignalEnum implements IRadioSignalEnum
{

    [Inject(name="load")]
    public var _loadProgressSignal:Signal;

    public function get loadProgressSignal ():ISignal
    {
        return this._loadProgressSignal;
    }

    [Inject(name="play")]
    public var _playProgressSignal:Signal;

    public function get playProgressSignal ():ISignal
    {
        return this._playProgressSignal;
    }

}



class RetryClock
{

    public function RetryClock ()
    {
        this.init();
    }

    private var index:int;
    private var list:Array;

    private var handel:uint;

    public function get hasNext ():Boolean
    {
        return this.index < this.list.length - 1;
    }

    public function get isOnGoing ():Boolean
    {
        return this.index > -1;
    }

    public var isRetryCall:Boolean = false;

    private function get interval ():Number
    {
        return this.list[this.index];
    }

    public function reset ():void
    {
        this.index = -1;
        clearTimeout(this.handel);
    }

    public function next ($fun:Function):Boolean
    {
        if (!this.hasNext)
        {
            this.reset();
            return false;
        }

        this.index++;

        this.handel = setTimeout
        (
            function ():void
            {
                isRetryCall = true;
                $fun.apply(null, arguments);
                isRetryCall = false;
            },
            this.interval, this.index + 1, this.list.length
        );

        return true;
    }

    private function init ():void
    {
        this.index = -1;
        this.list = [500, 1000, 1500];
    }

}

