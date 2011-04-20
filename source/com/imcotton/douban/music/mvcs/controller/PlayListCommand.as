package com.imcotton.douban.music.mvcs.controller
{

import com.imcotton.douban.music.mvcs.events.PlayListEvent;
import com.imcotton.douban.music.mvcs.model.ChannelModel;
import com.imcotton.douban.music.mvcs.service.IPlayListService;

import org.robotlegs.mvcs.Command;


public class PlayListCommand extends Command
{

    [Inject]
    public var channelEvent:PlayListEvent;

    [Inject]
    public var playListService:IPlayListService;

    [Inject]
    public var channelModel:ChannelModel;

    override public function execute ():void
    {
        this.channelModel.current = this.channelEvent.channelItem;

        this.playListService.switchChannel(this.channelEvent.channelItem);
    }

}
}

