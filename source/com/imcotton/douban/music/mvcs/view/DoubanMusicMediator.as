package com.imcotton.douban.music.mvcs.view
{

import org.robotlegs.mvcs.Mediator;


public class DoubanMusicMediator extends Mediator
{

    [Inject]
    public var view:AppViewAdapter;

    override public function onRegister ():void
    {
        trace(this.view);
    }

}
}

