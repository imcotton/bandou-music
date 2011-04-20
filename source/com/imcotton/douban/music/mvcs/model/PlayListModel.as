package com.imcotton.douban.music.mvcs.model
{

import org.robotlegs.mvcs.Actor;


public class PlayListModel extends Actor
{

    public function PlayListModel ()
    {
        this.init();
    }

    public function get current ():PlayListItem
    {
        return null;
    }

    private function init ():void
    {
        // TODO Auto Generated method stub
    }

}
}

