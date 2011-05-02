package com.imcotton.douban.music.mvcs.service
{

public interface IRadioService
{

    function load (url:String):void;

    function pause ():void;
    function play ():void;

    function get repeat ():Boolean;
    function set repeat (value:Boolean):void;

    function get volume ():Number;
    function set volume (value:Number):void;

}
}

