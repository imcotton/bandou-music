package com.imcotton.douban.music.mvcs.controller
{

import com.imcotton.douban.music.mvcs.view.AppViewWrapper;
import com.imcotton.douban.music.mvcs.view.DoubanMusicMediator;

import org.robotlegs.mvcs.Command;


public class StartupCommand extends Command
{

    override public function execute ():void
    {
        this.mediatorMap.mapView(AppViewWrapper, DoubanMusicMediator);
        this.mediatorMap.createMediator(new AppViewWrapper(this.contextView as DoubanMusic));
    }

}
}

