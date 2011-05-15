package com.imcotton.douban.music.mvcs.model
{

import com.imcotton.douban.music.events.PlayListEvent;

import org.as3commons.lang.Assert;
import org.robotlegs.mvcs.Actor;


public class PlayListModel extends Actor
{

    public function PlayListModel ()
    {
        this.init();
    }

    private var index:int;

    private var _list:Array;

    public function get list ():Array
    {
        return this._list;
    }

    public function get current ():PlayListItem
    {
        if (this.index < 0 || this.index > this.list.length - 1)
            return null;

        return this.list[this.index];
    }

    public function update ($list:Array):void
    {
        Assert.arrayItemsOfType($list, PlayListItem);

        this.index = -1;
        this._list = $list.concat();

        this.dispatch(new PlayListEvent(PlayListEvent.LIST_CHANGE));
    }
    
    public function append ($list:Array):void
    {
        Assert.arrayItemsOfType($list, PlayListItem);

        this._list.length = this.index + 1;
        this._list = this.list.concat($list);
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
        this._list = [];
    }

}
}

