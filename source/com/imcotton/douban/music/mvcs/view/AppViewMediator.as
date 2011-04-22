package com.imcotton.douban.music.mvcs.view
{

import com.imcotton.douban.music.events.PlayListEvent;
import com.imcotton.douban.music.mvcs.model.ChannelItem;
import com.imcotton.douban.music.mvcs.model.PlayListModel;

import flash.events.Event;

import org.robotlegs.mvcs.Mediator;


public class AppViewMediator extends Mediator
{

    [Inject]
    public var view:AppViewWrapper;

    [Inject]
    public var playListModel:PlayListModel;

    override public function onRegister ():void
    {
        this.view.channelSignal.add(onChannel);
        this.view.skipSignal.add(onSkip);

        this.addContextListener(PlayListEvent.CHANNEL_CHANGE, onContextEvent);
        this.addContextListener(PlayListEvent.PLAY_NEXT, onContextEvent);
    }

    private function onChannel ($item:ChannelItem):void
    {
        var event:PlayListEvent = new PlayListEvent(PlayListEvent.CHANGE_CHANNEL);
            event.channelItem = $item;

        this.dispatch(event);
    }

    private function onSkip ():void
    {
        this.playListModel.skip();
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

