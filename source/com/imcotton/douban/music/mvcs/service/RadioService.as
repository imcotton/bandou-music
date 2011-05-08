package com.imcotton.douban.music.mvcs.service
{

import com.imcotton.douban.music.mvcs.model.IRadioSignalEnum;
import com.imcotton.douban.music.mvcs.model.PlayListModel;

import flash.media.Sound;
import flash.net.URLRequest;
import flash.net.URLRequestHeader;

import org.osflash.signals.Signal;
import org.osmf.elements.AudioElement;
import org.osmf.elements.SoundLoader;
import org.osmf.events.LoadEvent;
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

        var loadable:LoadTrait = this.element.getTrait(MediaTraitType.LOAD) as LoadTrait;

        if (this.element.resource && loadable)
            this.loader.unload(loadable);

        this.element.resource = new URLResource($url);

        if ($duration)
            this.element.defaultDuration = $duration;
    }

    public function pause ():void
    {
        this.player.pause();
    }

    public function play ():void
    {
        this.player.play();
    }

    private function init ():void
    {
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
    }

    private function player_onTimeChange (event:TimeEvent):void
    {
        this.radioSignalEmun._playProgressSignal.dispatch
        (
            this.player.currentTime / this.player.duration,
            this.player.currentTime,
            this.element.defaultDuration
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
            this.playListModel.next();
    }

}
}



import com.imcotton.douban.music.mvcs.model.IRadioSignalEnum;

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

