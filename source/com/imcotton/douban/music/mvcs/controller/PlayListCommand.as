package com.imcotton.douban.music.mvcs.controller
{

import com.imcotton.douban.music.data.PlayTypeEnum;
import com.imcotton.douban.music.events.PlayListEvent;
import com.imcotton.douban.music.mvcs.model.IChannelModel;
import com.imcotton.douban.music.mvcs.model.IPlayHistoryModel;
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
    public var channelModel:IChannelModel;

    [Inject]
    public var playHistoryModel:IPlayHistoryModel;

    override public function execute ():void
    {
        switch (event.type)
        {
            case PlayListEvent.RENEW_CHANNEL:
            {
                this.playListService.renewChannel();
                break;
            }
            case PlayListEvent.SKIP_NEXT:
            {
                this.playHistoryModel.push(this.playListModel.current, PlayTypeEnum.SKIP_NEXT);
                this.playListService.skip();
                break;
            }
            case PlayListEvent.LIST_CHANGE:
            {
                this.playListModel.next();
                break;
            }
            case PlayListEvent.LIKE:
            {
                this.playListService.fetchForSong(event.playListItem, true);
                break;
            }
            case PlayListEvent.UNLIKE:
            {
                this.playListService.fetchForSong(event.playListItem, false);
                break;
            }
            case PlayListEvent.BAN:
            {
                this.playListService.fetchForBlank(event.playListItem);
                break;
            }
        }
    }

}
}

