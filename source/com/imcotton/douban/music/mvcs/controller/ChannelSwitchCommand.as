package com.imcotton.douban.music.mvcs.controller
{

import com.imcotton.douban.music.mvcs.service.IChannelService;

import org.robotlegs.mvcs.Command;


public class ChannelSwitchCommand extends Command
{

    [Inject]
    public var channelService:IChannelService;

    override public function execute ():void
    {
        this.channelService.load();
    }

}
}

