package com.imcotton.douban.music.mvcs.model
{

public interface IChannelModel
{

    function get current ():ChannelItem;
    function set current (item:ChannelItem):void;

    function get index ():int;
    function set index (value:int):void;

    function get list ():Array;

    function getItemByIndex (index:int):ChannelItem;

    function updateList (list:Array):void;
    
    function showPresonalChannel ():void;

}
}