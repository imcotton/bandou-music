package com.imcotton.douban.music.events
{

import com.imcotton.douban.music.mvcs.model.PlayListItem;

import flash.events.Event;


public class RadioServiceEvent extends Event
{

    public static const START:String = "start";
    public static const PAUSE:String = "pause";
    public static const PLAY:String = "play";

    public static const RETRYING:String = "retrying";
    public static const RETRY_FAIL:String = "retryFail";

    public function RadioServiceEvent ($type:String, $item:PlayListItem = null)
    {
        super($type);

        if ($item)
            this.playListItem = $item;
    }

    public var playListItem:PlayListItem;

}
}

