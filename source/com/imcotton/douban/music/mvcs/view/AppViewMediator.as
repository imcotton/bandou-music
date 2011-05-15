package com.imcotton.douban.music.mvcs.view
{

import com.imcotton.douban.music.events.ChannelEvent;
import com.imcotton.douban.music.events.LoginEvent;
import com.imcotton.douban.music.events.PlayListEvent;
import com.imcotton.douban.music.mvcs.model.ChannelItem;
import com.imcotton.douban.music.mvcs.model.IChannelModel;
import com.imcotton.douban.music.mvcs.model.IRadioSignalEnum;
import com.imcotton.douban.music.mvcs.model.LoginModel;
import com.imcotton.douban.music.mvcs.model.PlayListModel;
import com.imcotton.douban.music.mvcs.model.RemoteModel;
import com.imcotton.douban.music.mvcs.service.IRadioService;

import flash.events.Event;
import flash.net.navigateToURL;

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

    [Inject]
    public var remoteModel:RemoteModel;

    [Inject]
    public var channelMode:IChannelModel;

    [Inject]
    public var loginModel:LoginModel;

    override public function onRegister ():void
    {
        this.view.channelSignal.add(onChannel);
        this.view.skipSignal.add(onSkip);
        this.view.nextSignal.add(onNext);
        this.view.volumeSignal.add(onVolume);
        this.view.triggerSignal.add(onTrigger);
        this.view.repeatSignal.add(onRepeat);
        this.view.backSiteSignal.add(onBackSite);
        this.view.likeUnlikeSignal.add(onLikeUnlike);
        this.view.deleteSignal.add(onDelete);
        this.view.signSignal.add(onSign);

        this.radioSignalEnum.playProgressSignal.add(onPlaying);

        this.addContextListener(ChannelEvent.LIST_UPDATE, onContextEvent, ChannelEvent);
        this.addContextListener(ChannelEvent.CHANNEL_UPDATE, onContextEvent, ChannelEvent);
        this.addContextListener(PlayListEvent.PLAY_NEXT, onContextEvent, PlayListEvent);
        this.addContextListener(LoginEvent.ON_LOGIN, onContextEvent, LoginEvent);
        this.addContextListener(LoginEvent.ON_LOGOUT, onContextEvent, LoginEvent);
    }
    
    private function onDelete ():void
    {
        if (!this.loginModel.hasLogin)
        {
            this.onSkip();
            return;
        }
        
        var event:PlayListEvent = new PlayListEvent(PlayListEvent.BLANK);
            event.playListItem = this.playListModel.current;
        
        this.dispatch(event);
    }
    
    private function onLikeUnlike ($isLike:Boolean):void
    {
        var event:PlayListEvent = new PlayListEvent
            (
                $isLike ? PlayListEvent.LIKE : PlayListEvent.UNLIKE
            );
            event.playListItem = this.playListModel.current;
        
        this.dispatch(event);
    }

    private function onSign ():void
    {
        this.dispatch
        (
            new LoginEvent
            (
                this.loginModel.hasLogin ? LoginEvent.LOGOUT : LoginEvent.LOGIN
            )
        );
    }
    
    private function onBackSite ():void
    {
        navigateToURL(this.remoteModel.createAlbumSiteRequest());
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
        this.channelMode.current = $item;
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
        switch (event.type)
        {
            case ChannelEvent.LIST_UPDATE:
            {
                this.view.updateChannelList();
                break;
            }
            case ChannelEvent.CHANNEL_UPDATE:
            {
                this.view.changeChannelItem(this.channelMode.current);
                break;
            }
            case PlayListEvent.PLAY_NEXT:
            {
                this.view.changeItem(this.playListModel.current);
                break;
            }
            case LoginEvent.ON_LOGIN:
            case LoginEvent.ON_LOGOUT:
            {
                this.view.changeSignBtnLabel(this.loginModel.hasLogin ? this.loginModel.name : null)
                break;
            }
        }
    }

}
}

