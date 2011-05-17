package com.imcotton.douban.music.mvcs.controller
{

import com.imcotton.douban.music.data.IPlayListJSONParser;
import com.imcotton.douban.music.data.PlayListJSONParser;
import com.imcotton.douban.music.events.ChannelEvent;
import com.imcotton.douban.music.events.LoginEvent;
import com.imcotton.douban.music.events.PlayListEvent;
import com.imcotton.douban.music.events.RadioServiceEvent;
import com.imcotton.douban.music.mvcs.model.ChannelModel;
import com.imcotton.douban.music.mvcs.model.IChannelModel;
import com.imcotton.douban.music.mvcs.model.LoginModel;
import com.imcotton.douban.music.mvcs.model.PlayListModel;
import com.imcotton.douban.music.mvcs.model.RemoteModel;
import com.imcotton.douban.music.mvcs.service.ChannelService;
import com.imcotton.douban.music.mvcs.service.IChannelService;
import com.imcotton.douban.music.mvcs.service.ILoginService;
import com.imcotton.douban.music.mvcs.service.IPlayListService;
import com.imcotton.douban.music.mvcs.service.IRadioService;
import com.imcotton.douban.music.mvcs.service.LoginService;
import com.imcotton.douban.music.mvcs.service.PlayListService;
import com.imcotton.douban.music.mvcs.service.RadioService;
import com.imcotton.douban.music.mvcs.view.AppViewMediator;
import com.imcotton.douban.music.mvcs.view.AppViewWrapper;
import com.imcotton.douban.music.mvcs.view.LoginViewMediator;
import com.imcotton.douban.music.mvcs.view.components.LoginView;

import org.robotlegs.mvcs.Command;


public class StartupCommand extends Command
{

    override public function execute ():void
    {
        this.injector.mapSingletonOf(IPlayListJSONParser, PlayListJSONParser);
        this.injector.mapSingletonOf(IChannelModel, ChannelModel);
        this.injector.mapSingleton(PlayListModel);
        this.injector.mapSingleton(RemoteModel);
        this.injector.mapSingleton(LoginModel);
        this.injector.mapSingletonOf(IPlayListService, PlayListService);
        this.injector.mapSingletonOf(IChannelService, ChannelService);
        this.injector.mapSingletonOf(IRadioService, RadioService);
        this.injector.mapSingletonOf(ILoginService, LoginService);
        this.injector.mapValue(DoubanMusic, this.contextView);

        //  only to make sure the IRadioSignalEnum get mapped
        this.injector.getInstance(IRadioService);


        this.commandMap.mapEvent(ChannelEvent.LIST_UPDATE, ChannelCommand, ChannelEvent);
        this.commandMap.mapEvent(ChannelEvent.CHANNEL_UPDATE, ChannelCommand, ChannelEvent);

        this.commandMap.mapEvent(PlayListEvent.RENEW_CHANNEL, PlayListCommand, PlayListEvent);
        this.commandMap.mapEvent(PlayListEvent.LIST_CHANGE, PlayListCommand, PlayListEvent);
        this.commandMap.mapEvent(PlayListEvent.SKIP_NEXT, PlayListCommand, PlayListEvent);
        this.commandMap.mapEvent(PlayListEvent.LIKE, PlayListCommand, PlayListEvent);
        this.commandMap.mapEvent(PlayListEvent.UNLIKE, PlayListCommand, PlayListEvent);
        this.commandMap.mapEvent(PlayListEvent.BAN, PlayListCommand, PlayListEvent);

        this.commandMap.mapEvent(PlayListEvent.PLAY_NEXT, RadioServiceCommand, PlayListEvent);
        this.commandMap.mapEvent(RadioServiceEvent.RETRY_FAIL, RadioServiceCommand, RadioServiceEvent);

        this.commandMap.mapEvent(LoginEvent.LOGIN, LoginCommand, LoginEvent);
        this.commandMap.mapEvent(LoginEvent.LOGOUT, LoginCommand, LoginEvent);
        this.commandMap.mapEvent(LoginEvent.ON_LOGIN, LoginCommand, LoginEvent);
        this.commandMap.mapEvent(LoginEvent.ON_LOGOUT, LoginCommand, LoginEvent);


        this.mediatorMap.mapView(AppViewWrapper, AppViewMediator);
        this.mediatorMap.createMediator(this.injector.instantiate(AppViewWrapper));

        this.mediatorMap.mapView(LoginView, LoginViewMediator, null, false, false);


        this.commandMap.execute(ChannelSwitchCommand);
    }

}
}

