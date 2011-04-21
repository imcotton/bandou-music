package com.imcotton.douban.music.mvcs.view
{

import com.imcotton.douban.music.mvcs.events.PlayListEvent;
import com.imcotton.douban.music.mvcs.model.ChannelItem;
import com.imcotton.douban.music.mvcs.model.ChannelModel;

import flash.events.Event;

import org.robotlegs.mvcs.Mediator;


public class DoubanMusicMediator extends Mediator
{

    [Inject]
    public var view:AppViewWrapper;

    [Inject]
    public var channelModel:ChannelModel;

    override public function onRegister ():void
    {
        this.view.channelSignal.add(onChannel);

        this.addContextListener(PlayListEvent.CHANNEL_CHANGE, onContextEvent);
    }

    private function onChannel ($item:ChannelItem):void
    {
        var event:PlayListEvent = new PlayListEvent(PlayListEvent.CHANGE_CHANNEL);
            event.channelItem = $item;

        this.dispatch(event);
    }

    private function onContextEvent (event:Event):void
    {
        switch (event.type)
        {
            case PlayListEvent.CHANNEL_CHANGE:
            {
                this.view.changeChannelItem(PlayListEvent(event).channelItem);
                break;
            }
        }
    }

}
}

