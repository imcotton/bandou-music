package com.imcotton.douban.music.mvcs.events
{

import com.imcotton.douban.music.mvcs.model.ChannelItem;

import flash.events.Event;


public class PlayListEvent extends Event
{

    public static const CHANGE_CHANNEL:String = "changeChannel";
    public static const CHANNEL_CHANGE:String = "channelChange";

    public static const LIST_CHANGE:String = "listChange";

    public function PlayListEvent ($type:String, $item:ChannelItem = null)
    {
        super($type);

        if ($item)
            this.channelItem = $item;
    }

    public var channelItem:ChannelItem;

}
}

