package com.imcotton.douban.music.mvcs.events
{

import com.imcotton.douban.music.mvcs.model.ChannelItem;
import com.imcotton.douban.music.mvcs.model.PlayListItem;

import flash.events.Event;


public class PlayListEvent extends Event
{

    public static const CHANGE_CHANNEL:String = "changeChannel";
    public static const CHANNEL_CHANGE:String = "channelChange";

    public static const RENEW_CHANNEL:String = "renewChannel";

    public static const SKIP_NEXT:String = "skipNext";
    public static const PLAY_NEXT:String = "playNext";

    public static const LIST_CHANGE:String = "listChange";

    public function PlayListEvent ($type:String)
    {
        super($type);
    }

    public var channelItem:ChannelItem;
    public var playListItem:PlayListItem;

}
}

