package com.imcotton.douban.music.mvcs.service
{

import com.imcotton.douban.music.mvcs.model.ChannelItem;


public interface IPlayListService
{

    function skip ():void;
    function renewChannel ():void;
    function switchChannel (item:ChannelItem):void;

}
}

