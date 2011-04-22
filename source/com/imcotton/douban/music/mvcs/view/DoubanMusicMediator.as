package com.imcotton.douban.music.mvcs.view
{

import com.imcotton.douban.music.mvcs.events.PlayListEvent;
import com.imcotton.douban.music.mvcs.model.ChannelItem;

import flash.events.Event;

import org.robotlegs.mvcs.Mediator;


public class DoubanMusicMediator extends Mediator
{

    [Inject]
    public var view:AppViewWrapper;

    override public function onRegister ():void
    {
        this.view.channelSignal.add(onChannel);

        this.addContextListener(PlayListEvent.CHANNEL_CHANGE, onContextEvent);
        this.addContextListener(PlayListEvent.PLAY_NEXT, onContextEvent);
    }

    private function onChannel ($item:ChannelItem):void
    {
        var event:PlayListEvent = new PlayListEvent(PlayListEvent.CHANGE_CHANNEL);
            event.channelItem = $item;

        this.dispatch(event);
    }

    private function onContextEvent (event:Event):void
    {
        var playListEvent:PlayListEvent = event as PlayListEvent;

        switch (event.type)
        {
            case PlayListEvent.CHANNEL_CHANGE:
            {
                this.view.changeChannelItem(playListEvent.channelItem);
                break;
            }
            case PlayListEvent.PLAY_NEXT:
            {
                this.view.changeItem(playListEvent.playListItem);
                break;
            }
        }
    }

}
}

