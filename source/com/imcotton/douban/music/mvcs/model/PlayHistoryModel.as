package com.imcotton.douban.music.mvcs.model
{

import flash.net.SharedObject;


public class PlayHistoryModel implements IPlayHistoryModel
{

    private static const MAX_COUNT:int = 20;

    public function PlayHistoryModel ()
    {
        this.init();

        return;
        this.so.clear();
        this.so.flush();
    }

    private var so:SharedObject;

    private function get list ():Array
    {
        return this.so.data.list ||= [];
    }

    public function get historyString ():String
    {
        return this.list.join("");
    }

    public function push ($item:PlayListItem, $type:String):void
    {
        this.list.push("|" + $item.sid + ":" + $type);

        if (this.list.length > MAX_COUNT)
            this.list.shift();

        this.so.flush();
    }
    
    public function clean ():void
    {
        this.so.data.list = null;
    }
    
    private function init ():void
    {
        this.so = SharedObject.getLocal("PlayHistoryModel");
    }

}
}

