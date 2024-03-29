package com.imcotton.douban.music.mvcs.controller
{

import com.imcotton.douban.music.data.PlayTypeEnum;
import com.imcotton.douban.music.events.PlayListEvent;
import com.imcotton.douban.music.events.RadioServiceEvent;
import com.imcotton.douban.music.mvcs.model.IPlayHistoryModel;
import com.imcotton.douban.music.mvcs.model.PlayListModel;
import com.imcotton.douban.music.mvcs.service.IRadioService;

import flash.events.Event;
import flash.utils.Dictionary;

import mx.logging.ILogger;

import org.robotlegs.mvcs.Command;


public class RadioServiceCommand extends Command
{

    [Inject]
    public var absEvent:Event;

    [Inject]
    public var radioService:IRadioService;

    [Inject]
    public var playListModel:PlayListModel;

    [Inject]
    public var playHistoryModel:IPlayHistoryModel;

    [Inject]
    public var logger:ILogger;

    private var eventDict:Dictionary = new Dictionary(true);

    public function RadioServiceCommand ()
    {
        this.eventDict[PlayListEvent] = this.onPlayListEvent;
        this.eventDict[RadioServiceEvent] = this.onRadioServiceEvent;
    }

    override public function execute ():void
    {
        this.eventDict[Object(this.absEvent).constructor](this.absEvent);
    }

    private function onPlayListEvent (event:PlayListEvent):void
    {
        switch (event.type)
        {
            case PlayListEvent.PLAY_NEXT:
            {
                this.radioService.repeat = false;
                this.radioService.load
                (
                    event.playListItem.songURL,
                    event.playListItem.songDuration
                );

                this.logger.info("{0} : {1}", event.playListItem.sid, event.playListItem.songURL);
                break;
            }
        }
    }

    private function onRadioServiceEvent (event:RadioServiceEvent):void
    {
        switch (event.type)
        {
            case RadioServiceEvent.COMPLETE:
            case RadioServiceEvent.RETRY_FAIL:
            {
                this.playHistoryModel.push(this.playListModel.current, PlayTypeEnum.END);
                this.playListModel.next();
                break;
            }
        }
    }

}
}

