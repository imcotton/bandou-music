package com.imcotton.douban.music.mvcs.service
{

import com.imcotton.douban.music.mvcs.model.IRadioSignalEnum;

import flash.media.Sound;
import flash.net.URLRequest;
import flash.net.URLRequestHeader;
import flash.utils.setInterval;

import org.osflash.signals.Signal;
import org.osmf.audio.AudioElement;
import org.osmf.audio.SoundLoader;
import org.osmf.display.MediaElementSprite;
import org.osmf.media.MediaPlayer;
import org.osmf.media.URLResource;
import org.osmf.traits.ILoadable;
import org.osmf.traits.MediaTraitType;
import org.osmf.utils.URL;
import org.robotlegs.core.IInjector;
import org.robotlegs.mvcs.Actor;
import org.swiftsuspenders.Injector;


public class RadioService extends Actor implements IRadioService
{

    [Inject]
    public var contextInjector:IInjector;

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

    private var mediaElementSprite:MediaElementSprite;

    public function get repeat ():Boolean
    {
        return false;
    }

    public function set repeat ($value:Boolean):void
    {

    }

    public function get volume ():Number
    {
        return 0;
    }

    public function set volume ($value:Number):void
    {
    }

    public function load ($url:String):void
    {
        if (!$url)
            return;
        
        trace($url);
        
        var loadable:ILoadable = this.element.getTrait(MediaTraitType.LOADABLE) as ILoadable;
            
        if (this.element.resource && loadable)
            this.loader.unload(loadable);

        this.element.resource = new URLResource(new URL($url));
    }

    public function pause ():Boolean
    {
        return false;
    }

    public function play ():Boolean
    {
        return false;
    }

    private function init ():void
    {
        var inject:Injector = new Injector();
            inject.mapValue(Signal, new Signal(Number, int, int), "load");
            inject.mapValue(Signal, new Signal(Number, int, int), "play");

        this.radioSignalEmun = inject.instantiate(RadioSignalEnum);
        
        var request:URLRequest = new URLRequest();
            request.requestHeaders = [new URLRequestHeader("Referer", "http://www.douban.com")];
            
        this.loader = new SoundLoader(request);
        this.element = new AudioElement(this.loader);
        
        this.player = new MediaPlayer(this.element);
        this.player.volume = 0.8;
        this.player.bufferTime = 2;
        
        setInterval(function ():void
        {
            trace(int(player.currentTime / player.duration * 100));
        }, 1000);
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

