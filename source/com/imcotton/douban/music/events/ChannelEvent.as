package com.imcotton.douban.music.events
{

import com.imcotton.douban.music.mvcs.model.ChannelItem;

import flash.events.Event;


public class ChannelEvent extends Event
{
    
    public static const LIST_UPDATE:String = "listUpdate";
    public static const CHANNEL_UPDATE:String = "channelUpdate";
    
    public function ChannelEvent ($type:String)
    {
        super($type);
    }

    public var channelItem:ChannelItem;
    
}
}

