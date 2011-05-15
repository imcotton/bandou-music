package com.imcotton.douban.music.mvcs.service
{

import com.imcotton.douban.music.mvcs.model.ChannelItem;
import com.imcotton.douban.music.mvcs.model.PlayListItem;


public interface IPlayListService
{

    function skip ():void;
    function renewChannel ():void;
    function switchChannel (item:ChannelItem):void;
    function fetchForSong (item:PlayListItem, isLike:Boolean):void;

}
}

