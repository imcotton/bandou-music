package com.imcotton.douban.music.mvcs.controller
{

import com.imcotton.douban.music.mvcs.view.DoubanMusicMediator;

import org.robotlegs.mvcs.Command;


public class StartupCommand extends Command
{

    override public function execute ():void
    {
        this.mediatorMap.mapView(DoubanMusic, DoubanMusicMediator);
        this.mediatorMap.createMediator(this.contextView);
    }

}
}

