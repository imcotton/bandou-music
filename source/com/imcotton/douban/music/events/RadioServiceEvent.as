package com.imcotton.douban.music.events
{

import com.imcotton.douban.music.mvcs.model.PlayListItem;

import flash.events.Event;


public class RadioServiceEvent extends Event
{

    public static const START:String = "start";
    public static const PAUSE:String = "pause";
    public static const PLAY:String = "play";

    public function RadioServiceEvent ($type:String, $item:PlayListItem = null)
    {
        super($type);

        if ($item)
            this.playListItem = $item;
    }

    public var playListItem:PlayListItem;

}
}

