package com.imcotton.douban.music.mvcs.controller
{

import com.imcotton.douban.music.events.PlayListEvent;
import com.imcotton.douban.music.mvcs.service.IRadioService;

import org.robotlegs.mvcs.Command;


public class RadioServiceCommand extends Command
{

    [Inject]
    public var playListEvent:PlayListEvent;

    [Inject]
    public var radioService:IRadioService;

    override public function execute ():void
    {
        this.radioService.load(this.playListEvent.playListItem.songURL);
    }

}
}

