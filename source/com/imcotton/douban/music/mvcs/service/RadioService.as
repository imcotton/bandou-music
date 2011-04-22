package com.imcotton.douban.music.mvcs.service
{

import com.imcotton.douban.music.mvcs.model.IRadioSignalEnum;

import flash.media.Sound;

import org.osflash.signals.Signal;
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





