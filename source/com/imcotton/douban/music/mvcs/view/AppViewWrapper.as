package com.imcotton.douban.music.mvcs.view
{

import com.imcotton.douban.music.mvcs.model.ChannelItem;
import com.imcotton.douban.music.mvcs.model.ChannelModel;

import flash.events.Event;

import mx.collections.ArrayList;

import org.osflash.signals.Signal;

import spark.components.DropDownList;
import spark.events.IndexChangeEvent;


public class AppViewWrapper
{

    [Inject]
    public var channelModel:ChannelModel;

    [Inject]
    public var appView:DoubanMusic;

    public var channelSignal:Signal;

    [PostConstruct]
    public function postConstruct ():void
    {
        var channelList:DropDownList = this.appView.channelList;
            channelList.addEventListener(IndexChangeEvent.CHANGE, channelList_onChange);
            channelList.dataProvider = new ArrayList(this.channelModel.list);
            channelList.labelField = "name";
    }

    public function AppViewWrapper ()
    {
        this.init();
    }

    public function changeChannelItem ($item:ChannelItem):void
    {
        this.appView.channelList.selectedItem = $item;
    }

    private function channelList_onChange (event:Event):void
    {
        this.channelSignal.dispatch(this.appView.channelList.selectedItem);
    }

    private function init ():void
    {
        this.channelSignal = new Signal(ChannelItem);
    }

}
}

