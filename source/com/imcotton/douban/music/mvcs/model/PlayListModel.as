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
        this.index++;
        
        var event:PlayListEvent;
        
        if (this.index >= this.list.length)
        {
            this.index = -1;
            event = new PlayListEvent(PlayListEvent.RENEW_CHANNEL);
        }
        else
        {
            event = new PlayListEvent(PlayListEvent.PLAY_NEXT);
            event.playListItem = this.current;
        }
        
        this.dispatch(event);
    }

    private function init ():void
    {
        this.index = -1;
        this._list = new Vector.<PlayListItem>();
    }

}
}

