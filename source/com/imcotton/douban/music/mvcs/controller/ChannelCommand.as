package com.imcotton.douban.music.mvcs.controller
{

import com.imcotton.douban.music.events.ChannelEvent;
import com.imcotton.douban.music.mvcs.model.IPlayHistoryModel;
import com.imcotton.douban.music.mvcs.service.IPlayListService;

import org.robotlegs.mvcs.Command;

public class ChannelCommand extends Command
{

    [Inject]
    public var event:ChannelEvent;

    [Inject]
    public var playListService:IPlayListService;

    [Inject]
    public var playHistoryModel:IPlayHistoryModel;

    override public function execute ():void
    {
        switch (this.event.type)
        {
            case ChannelEvent.CHANNEL_UPDATE:
            {
                this.playHistoryModel.clean();
                this.playListService.switchChannel(this.event.channelItem);
                break;
            }
        }
    }

}
}

