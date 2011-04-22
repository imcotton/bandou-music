package com.imcotton.douban.music.mvcs.model
{

import com.imcotton.douban.music.mvcs.events.PlayListEvent;

import org.robotlegs.mvcs.Actor;


public class PlayListModel extends Actor
{

    public function PlayListModel ()
    {
        this.init();
    }

    private var index:int;

    private var _list:Vector.<PlayListItem>;

    public function get list ():Vector.<PlayListItem>
    {
        return this._list;
    }

    public function get current ():PlayListItem
    {
        if (this.index < 0 || this.index > this.list.length - 1)
            return null;

        return this.list[this.index];
    }

    public function update ($list:Vector.<PlayListItem>):void
    {
        this.index = 0;
        this._list = $list;

        this.dispatch(new PlayListEvent(PlayListEvent.LIST_CHANGE));
    }

    public function next ():void
    {
        var event:PlayListEvent;

        if (this.index + 1 >= this.list.length)
        {
            event = new PlayListEvent(PlayListEvent.RENEW_CHANNEL);
        }
        else
        {
            this.index++;
            event = new PlayListEvent(PlayListEvent.PLAY_NEXT);
            event.playListItem = this.current;
        }

        this.dispatch(event);
    }

    public function skip ():void
    {
        this.dispatch(new PlayListEvent(PlayListEvent.SKIP_NEXT));
    }

    private function init ():void
    {
        this.index = -1;
        this._list = new Vector.<PlayListItem>();
    }

}
}

