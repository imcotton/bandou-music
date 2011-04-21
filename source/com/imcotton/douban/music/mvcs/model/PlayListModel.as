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

    private var index:int = -1;

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
        this._list = $list;

        this.dispatch(new PlayListEvent(PlayListEvent.LIST_CHANGE));
    }

    public function next ():void
    {
    }

    private function init ():void
    {
    }

}
}

