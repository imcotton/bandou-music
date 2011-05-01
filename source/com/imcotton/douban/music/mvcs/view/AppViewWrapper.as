package com.imcotton.douban.music.mvcs.view
{

import com.imcotton.douban.music.mvcs.model.ChannelItem;
import com.imcotton.douban.music.mvcs.model.ChannelModel;
import com.imcotton.douban.music.mvcs.model.PlayListItem;

import flash.events.Event;

import mx.collections.ArrayList;
import mx.events.FlexEvent;

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
    public var skipSignal:Signal;
    public var nextSignal:Signal;
    public var volumeSignal:Signal;

    [PostConstruct]
    public function postConstruct ():void
    {
        var channelList:DropDownList = this.appView.channelList;
            channelList.addEventListener(IndexChangeEvent.CHANGE, channelList_onChange);
            channelList.dataProvider = new ArrayList(this.channelModel.list);
            channelList.labelField = "name";

        this.appView.volumeBar.addEventListener(Event.CHANGE, volumeBar_onChange);
            
        this.appView.skipBtn.addEventListener(FlexEvent.BUTTON_DOWN, skipBtn_onButtonDown);
        this.appView.nextBtn.addEventListener(FlexEvent.BUTTON_DOWN, nextBtn_onButtonDown);
    }

    public function AppViewWrapper ()
    {
        this.init();
    }

    public function changeChannelItem ($item:ChannelItem):void
    {
        this.appView.channelList.selectedItem = $item;
    }

    public function changeItem ($item:PlayListItem):void
    {
        this.appView.image.source = $item.albumCoverURL;
        this.appView.titleText.text = $item.songName + " - " + $item.albumName;
        this.appView.authorText.text = $item.artistName;
    }

    private function init ():void
    {
        this.channelSignal = new Signal(ChannelItem);
        this.skipSignal = new Signal();
        this.nextSignal = new Signal();
        this.volumeSignal = new Signal(Number);
    }

    private function channelList_onChange (event:Event):void
    {
        this.channelSignal.dispatch(this.appView.channelList.selectedItem);
    }

    private function skipBtn_onButtonDown (event:Event):void
    {
        this.skipSignal.dispatch();
    }

    private function nextBtn_onButtonDown (event:Event):void
    {
        this.nextSignal.dispatch();
    }
    
    private function volumeBar_onChange (event:Event):void
    {
        this.volumeSignal.dispatch(this.appView.volumeBar.value / 100);
    }
    
}
}

