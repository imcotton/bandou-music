package com.imcotton.douban.music.mvcs
{

import com.imcotton.douban.music.mvcs.controller.StartupCommand;

import org.robotlegs.base.ContextEvent;
import org.robotlegs.mvcs.Context;


public class AppContext extends Context
{

    override public function startup ():void
    {
        this.commandMap.mapEvent(ContextEvent.STARTUP_COMPLETE, StartupCommand, ContextEvent, true);

        super.startup();
    }

}
}

