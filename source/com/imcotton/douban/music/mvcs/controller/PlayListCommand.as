package com.imcotton.douban.music.mvcs.controller
{

import com.imcotton.douban.music.mvcs.events.PlayListEvent;
import com.imcotton.douban.music.mvcs.model.ChannelModel;
import com.imcotton.douban.music.mvcs.model.PlayListModel;
import com.imcotton.douban.music.mvcs.service.IPlayListService;

import org.robotlegs.mvcs.Command;


public class PlayListCommand extends Command
{

    [Inject]
    public var channelEvent:PlayListEvent;

    [Inject]
    public var playListService:IPlayListService;

    [Inject]
    public var playListModel:PlayListModel;

    [Inject]
    public var channelModel:ChannelModel;

    override public function execute ():void
    {
        switch (this.channelEvent.type)
        {
            case PlayListEvent.CHANGE_CHANNEL:
            {
                this.channelModel.current = this.channelEvent.channelItem;
                this.playListService.switchChannel(this.channelEvent.channelItem);
                break;
            }
            case PlayListEvent.LIST_CHANGE:
            {
                this.playListModel.next();
                break;
            }
        }
    }

}
}

