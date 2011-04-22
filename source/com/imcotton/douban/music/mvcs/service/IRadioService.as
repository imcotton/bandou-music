package com.imcotton.douban.music.mvcs.service
{

public interface IRadioService
{

    function load (url:String):void;

    function pause ():Boolean;
    function play ():Boolean;

    function get repeat ():Boolean;
    function set repeat (value:Boolean):void;

    function get volume ():Number;
    function set volume (value:Number):void;

}
}

