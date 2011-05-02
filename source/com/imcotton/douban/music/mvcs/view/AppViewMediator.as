package com.imcotton.douban.music.mvcs.view
{

import com.imcotton.douban.music.events.PlayListEvent;
import com.imcotton.douban.music.mvcs.model.ChannelItem;
import com.imcotton.douban.music.mvcs.model.IRadioSignalEnum;
import com.imcotton.douban.music.mvcs.model.PlayListModel;
import com.imcotton.douban.music.mvcs.service.IRadioService;

import flash.events.Event;

import org.robotlegs.mvcs.Mediator;


public class AppViewMediator extends Mediator
{

    [Inject]
    public var view:AppViewWrapper;

    [Inject]
    public var playListModel:PlayListModel;

    [Inject]
    public var radioService:IRadioService;

    [Inject]
    public var radioSignalEnum:IRadioSignalEnum;

    override public function onRegister ():void
    {
        this.view.channelSignal.add(onChannel);
        this.view.skipSignal.add(onSkip);
        this.view.nextSignal.add(onNext);
        this.view.volumeSignal.add(onVolume);
        this.view.triggerSignal.add(onTrigger);
        this.view.repeatSignal.add(onRepeat);

        this.radioSignalEnum.playProgressSignal.add(onPlaying);

        this.addContextListener(PlayListEvent.CHANNEL_CHANGE, onContextEvent);
        this.addContextListener(PlayListEvent.PLAY_NEXT, onContextEvent);
    }

    private function onPlaying ($rate:Number, $current:Number, $duration:Number):void
    {
        this.view.updateTimer($current, $duration);
    }

    private function onRepeat ($isRepeat:Boolean):void
    {
        this.radioService.repeat = $isRepeat;
    }

    private function onTrigger ($isPause:Boolean):void
    {
        if ($isPause)
            this.radioService.pause();
        else
            this.radioService.play();
    }

    private function onVolume ($value:Number):void
    {
        this.radioService.volume = $value;
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

    private function onNext ():void
    {
        this.playListModel.next();
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

