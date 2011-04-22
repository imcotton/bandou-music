package com.imcotton.douban.music.mvcs.model
{

import by.blooddy.crypto.serialization.JSON;

import com.imcotton.douban.music.events.PlayListEvent;

import flash.net.URLVariables;

import org.robotlegs.mvcs.Actor;


public class ChannelModel extends Actor
{

    private static const SOURCE:String = "channels=%5B%7B%22channel_id%22%3A0%2C%22name%22%3A%22%E7%A7%81%E4%BA%BA%E9%A2%91%E9%81%93%22%7D%2C%7B%22channel_id%22%3A1%2C%22name%22%3A%22%E5%8D%8E%E8%AF%AD%22%7D%2C%7B%22channel_id%22%3A6%2C%22name%22%3A%22%E7%B2%A4%E8%AF%AD%22%7D%2C%7B%22channel_id%22%3A27%2C%22name%22%3A%22%E5%8F%A4%E5%85%B8%22%7D%2C%7B%22channel_id%22%3A2%2C%22name%22%3A%22%E6%AC%A7%E7%BE%8E%22%7D%2C%7B%22channel_id%22%3A26%2C%22name%22%3A%22%E8%B1%86%E7%93%A3%E9%9F%B3%E4%B9%90%E4%BA%BA%22%7D%2C%7B%22channel_id%22%3A22%2C%22name%22%3A%22%E6%B3%95%E8%AF%AD%22%7D%2C%7B%22channel_id%22%3A17%2C%22name%22%3A%22%E6%97%A5%E8%AF%AD%22%7D%2C%7B%22channel_id%22%3A18%2C%22name%22%3A%22%E9%9F%A9%E8%AF%AD%22%7D%2C%7B%22channel_id%22%3A13%2C%22name%22%3A%22%E7%88%B5%E5%A3%AB%22%7D%2C%7B%22channel_id%22%3A14%2C%22name%22%3A%22%E7%94%B5%E5%AD%90%22%7D%2C%7B%22channel_id%22%3A16%2C%22name%22%3A%22R%26B%22%7D%2C%7B%22channel_id%22%3A15%2C%22name%22%3A%22%E8%AF%B4%E5%94%B1%22%7D%2C%7B%22channel_id%22%3A7%2C%22name%22%3A%22%E6%91%87%E6%BB%9A%22%7D%2C%7B%22channel_id%22%3A8%2C%22name%22%3A%22%E6%B0%91%E8%B0%A3%22%7D%2C%7B%22channel_id%22%3A10%2C%22name%22%3A%22%E7%94%B5%E5%BD%B1%E5%8E%9F%E5%A3%B0%22%7D%2C%7B%22channel_id%22%3A9%2C%22name%22%3A%22%E8%BD%BB%E9%9F%B3%E4%B9%90%22%7D%2C%7B%22channel_id%22%3A20%2C%22name%22%3A%22%E5%A5%B3%E5%A3%B0%22%7D%2C%7B%22channel_id%22%3A3%2C%22name%22%3A%22%E4%B8%83%E9%9B%B6%22%7D%2C%7B%22channel_id%22%3A4%2C%22name%22%3A%22%E5%85%AB%E9%9B%B6%22%7D%2C%7B%22channel_id%22%3A5%2C%22name%22%3A%22%E4%B9%9D%E9%9B%B6%22%7D%2C%7B%22channel_id%22%3A19%2C%22name%22%3A%22Puma+Social%22%7D%5D";

    public function ChannelModel ()
    {
        this.init();
    }

    public var list:Array;

    private var presonal:ChannelItem;

    private var _current:ChannelItem;

    public function get current ():ChannelItem
    {
        return this._current;
    }

    public function set current ($item:ChannelItem):void
    {
        this._current = $item;

        var event:PlayListEvent = new PlayListEvent(PlayListEvent.CHANNEL_CHANGE);
            event.channelItem = $item;

        this.dispatch(event);
    }

    public function getItemByIndex ($index:int):ChannelItem
    {
        return this.list[$index];
    }

    private function init ():void
    {
        this.list = JSON.decode(new URLVariables(SOURCE).channels);
        this.list.sortOn("channel_id", Array.NUMERIC);

        var tmp:Object;

        for (var i:String in this.list)
        {
            tmp = this.list[i];
            this.list[i] = new ChannelItem(tmp.channel_id, tmp.name);
        }

        this.presonal = this.list.shift();
    }

}
}

