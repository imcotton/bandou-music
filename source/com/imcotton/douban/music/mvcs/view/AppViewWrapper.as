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
    public var repeatSignal:Signal;
    public var triggerSignal:Signal;

    [PostConstruct]
    public function postConstruct ():void
    {
        var channelList:DropDownList = this.appView.channelList;
            channelList.addEventListener(IndexChangeEvent.CHANGE, channelList_onChange);
            channelList.dataProvider = new ArrayList(this.channelModel.list);
            channelList.labelField = "name";

        this.appView.volumeBar.addEventListener(Event.CHANGE, volumeBar_onChange);

        this.appView.triggerBtn.addEventListener(Event.CHANGE, triggerBtn_onChange);
        this.appView.repeatBtn.addEventListener(Event.CHANGE, repeatBtn_onChange);

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

    public function updateTimer ($current:Number, $duration:Number):void
    {
        var arr:Array = [$current, $duration];

        for (var i:String in arr)
            arr[i] = NumberFormat.s2m(arr[i]);

        this.appView.timeText.text = arr.join(" / ");
    }

    private function init ():void
    {
        this.channelSignal = new Signal(ChannelItem);
        this.skipSignal = new Signal();
        this.nextSignal = new Signal();
        this.volumeSignal = new Signal(Number);
        this.triggerSignal = new Signal(Boolean);
        this.repeatSignal = new Signal(Boolean);
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

    private function triggerBtn_onChange (event:Event):void
    {
        this.triggerSignal.dispatch(this.appView.triggerBtn.selected);
    }

    private function repeatBtn_onChange (event:Event):void
    {
        this.repeatSignal.dispatch(this.appView.repeatBtn.selected);
    }

}
}



class NumberFormat
{
    public static function s2m ($s:Number):String
    {
        return addLeadingZero(int($s / 60), 2) + ":" + addLeadingZero(($s % 60), 2);
    }
    
    public static function addLeadingZero ($n:Number, $d:Number):String
    {
        var t:String = "";
        var i:Number = int(Math.log($n) * Math.LOG10E) + 1;
        
        if ((i = ($d - i)) > 0)
            while (i--)
                t += '0';
        
        return t + $n;
    }
}

