package com.imcotton.douban.music.mvcs.model
{

import com.imcotton.douban.music.events.ChannelEvent;

import org.as3commons.lang.Assert;
import org.robotlegs.mvcs.Actor;


public class ChannelModel extends Actor implements IChannelModel
{

    private var personal:ChannelItem;

    private var _list:Array;

    public function get list ():Array
    {
        return this._list;
    }

    private var _index:int = -1;

    public function get index ():int
    {
        return this._index;
    }

    public function set index ($value:int):void
    {
        if ($value == this.index)
            return;

        this._index = $value;

        var event:ChannelEvent = new ChannelEvent(ChannelEvent.CHANNEL_UPDATE);
            event.channelItem = this.current;

        this.dispatch(event);
    }

    public function get current ():ChannelItem
    {
        return this.getItemByIndex(this.index);
    }

    public function set current ($item:ChannelItem):void
    {
        var index:int = this.list.indexOf($item);

        if (index == -1 || index == this.index)
            return;

        this.index = index;
    }

    public function get isPersonalChannel ():Boolean
    {
        return this.current == this.personal;
    }
    
    public function getItemByIndex ($index:int):ChannelItem
    {
        return this.list[$index];
    }

    public function updateList ($list:Array):void
    {
        Assert.arrayItemsOfType($list, ChannelItem);

        this._index = -1;
        this._list = $list.concat();
        this.personal = this.list.shift();

        this.dispatch(new ChannelEvent(ChannelEvent.LIST_UPDATE));
        
        this.index = 0;
    }
    
    public function showPresonalChannel ():void
    {
        this._index = -1;
        this._list.unshift(this.personal);

        this.dispatch(new ChannelEvent(ChannelEvent.LIST_UPDATE));
        
        this.current = this.personal;
    }

    public function hidePresonalChannel ():void
    {
        this._index = -1;
        this._list.shift();

        this.dispatch(new ChannelEvent(ChannelEvent.LIST_UPDATE));

        this.index = 0;
    }

}
}

