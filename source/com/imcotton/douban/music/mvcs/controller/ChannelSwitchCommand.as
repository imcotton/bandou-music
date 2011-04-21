package com.imcotton.douban.music.mvcs.controller
{

import com.imcotton.douban.music.mvcs.events.PlayListEvent;
import com.imcotton.douban.music.mvcs.model.ChannelModel;

import org.robotlegs.mvcs.Command;


public class ChannelSwitchCommand extends Command
{

    [Inject]
    public var channelModel:ChannelModel;
    
    override public function execute ():void
    {
        var event:PlayListEvent = new PlayListEvent(PlayListEvent.CHANGE_CHANNEL);
            event.channelItem = this.channelModel.getItemByIndex(0);
        
        this.dispatch(event);
    }
    
}
}

