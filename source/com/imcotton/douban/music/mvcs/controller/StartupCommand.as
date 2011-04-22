package com.imcotton.douban.music.mvcs.controller
{

import com.imcotton.douban.music.mvcs.data.PlayListJSONParser;
import com.imcotton.douban.music.mvcs.events.PlayListEvent;
import com.imcotton.douban.music.mvcs.model.ChannelModel;
import com.imcotton.douban.music.mvcs.model.PlayListModel;
import com.imcotton.douban.music.mvcs.model.RemoteModel;
import com.imcotton.douban.music.mvcs.service.IPlayListService;
import com.imcotton.douban.music.mvcs.service.PlayListService;
import com.imcotton.douban.music.mvcs.view.AppViewWrapper;
import com.imcotton.douban.music.mvcs.view.DoubanMusicMediator;

import org.robotlegs.mvcs.Command;


public class StartupCommand extends Command
{

    override public function execute ():void
    {
        this.injector.mapSingleton(PlayListJSONParser);
        this.injector.mapSingleton(ChannelModel);
        this.injector.mapSingleton(PlayListModel);
        this.injector.mapSingleton(RemoteModel);
        this.injector.mapSingletonOf(IPlayListService, PlayListService);
        this.injector.mapValue(DoubanMusic, this.contextView);


        this.commandMap.mapEvent(PlayListEvent.CHANGE_CHANNEL, PlayListCommand, PlayListEvent);
        this.commandMap.mapEvent(PlayListEvent.LIST_CHANGE, PlayListCommand, PlayListEvent);


        this.mediatorMap.mapView(AppViewWrapper, DoubanMusicMediator);
        this.mediatorMap.createMediator(this.injector.instantiate(AppViewWrapper));


        this.commandMap.execute(ChannelSwitchCommand);
    }

}
}

