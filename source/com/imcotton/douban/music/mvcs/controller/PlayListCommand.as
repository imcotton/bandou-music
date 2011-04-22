package com.imcotton.douban.music.mvcs.controller
{

import com.imcotton.douban.music.events.PlayListEvent;
import com.imcotton.douban.music.mvcs.model.ChannelModel;
import com.imcotton.douban.music.mvcs.model.PlayListModel;
import com.imcotton.douban.music.mvcs.service.IPlayListService;

import org.robotlegs.mvcs.Command;


public class PlayListCommand extends Command
{

    [Inject]
    public var event:PlayListEvent;

    [Inject]
    public var playListService:IPlayListService;

    [Inject]
    public var playListModel:PlayListModel;

    [Inject]
    public var channelModel:ChannelModel;

    override public function execute ():void
    {
        switch (event.type)
        {
            case PlayListEvent.CHANGE_CHANNEL:
            {
                this.channelModel.current = this.event.channelItem;
                this.playListService.switchChannel(this.event.channelItem);
                break;
            }
            case PlayListEvent.RENEW_CHANNEL:
            {
                this.playListService.renewChannel();
                break;
            }
            case PlayListEvent.SKIP_NEXT:
            {
                this.playListService.skip();
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

