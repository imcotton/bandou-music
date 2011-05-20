package com.imcotton.douban.music.mvcs.model
{

public interface IPlayHistoryModel
{

    function clean ():void;
    function push (item:PlayListItem, type:String):void;
    function get historyString ():String;

}
}

