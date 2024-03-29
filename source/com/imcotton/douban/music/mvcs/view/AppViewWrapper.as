package com.imcotton.douban.music.mvcs.view
{

import com.imcotton.douban.music.mvcs.model.ChannelItem;
import com.imcotton.douban.music.mvcs.model.IChannelModel;
import com.imcotton.douban.music.mvcs.model.PlayListItem;

import flash.events.Event;
import flash.events.MouseEvent;

import mx.collections.ArrayList;

import org.osflash.signals.Signal;
import org.osflash.signals.natives.NativeMappedSignal;

import spark.components.DropDownList;
import spark.components.ToggleButton;
import spark.events.IndexChangeEvent;


public class AppViewWrapper
{

    [Inject]
    public var channelModel:IChannelModel;

    [Inject]
    public var appView:DoubanMusic;

    public var channelSignal:Signal;
    public var skipSignal:Signal;
    public var nextSignal:Signal;
    public var volumeSignal:Signal;
    public var repeatSignal:Signal;
    public var triggerSignal:Signal;
    public var backSiteSignal:Signal;
    public var likeUnlikeSignal:NativeMappedSignal;
    public var deleteSignal:NativeMappedSignal;
    public var signSignal:Signal;

    [PostConstruct]
    public function postConstruct ():void
    {
        this.appView.signBtn.addEventListener(MouseEvent.CLICK, signBtn_onClick);

        this.appView.image.addEventListener(MouseEvent.CLICK, image_onClick);

        this.appView.volumeBar.addEventListener(Event.CHANGE, volumeBar_onChange);

        this.appView.triggerBtn.addEventListener(Event.CHANGE, triggerBtn_onChange);
        this.appView.repeatBtn.addEventListener(Event.CHANGE, repeatBtn_onChange);

        this.appView.skipBtn.addEventListener(MouseEvent.CLICK, skipBtn_onButtonDown);
        this.appView.nextBtn.addEventListener(MouseEvent.CLICK, nextBtn_onButtonDown);

        this.likeUnlikeSignal = new NativeMappedSignal(this.appView.likeBtn, Event.CHANGE, Event, Boolean);
        this.likeUnlikeSignal.mapTo(function (event:Event):Boolean
        {
            return ToggleButton(event.target).selected;
        });

        this.deleteSignal = new NativeMappedSignal(this.appView.delBtn, MouseEvent.CLICK, MouseEvent);
    }

    private function signBtn_onClick (event:MouseEvent):void
    {
        this.signSignal.dispatch();
    }

    public function AppViewWrapper ()
    {
        this.init();
    }

    public function updateChannelList ():void
    {
        var channelList:DropDownList = this.appView.channelList;
            channelList.addEventListener(IndexChangeEvent.CHANGE, channelList_onChange);
            channelList.dataProvider = new ArrayList(this.channelModel.list);
            channelList.labelField = "name";
    }

    public function changeSignBtnLabel ($name:String):void
    {
        if ($name)
            this.appView.signBtn.label = $name + " (Sign out)";
        else
            this.appView.signBtn.label = "Sign in";
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
        this.appView.likeBtn.selected = $item.liked;

        this.appView.triggerBtn.selected
            = this.appView.repeatBtn.selected
            = false;
    }

    public function updateTimer ($current:Number, $duration:Number):void
    {
        var arr:Array = [$current, $duration];

        for (var i:String in arr)
            arr[i] = NumberFormat.s2m(int(arr[i] + 0.50));

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
        this.backSiteSignal = new Signal();
        this.signSignal = new Signal();
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

    private function image_onClick (event:MouseEvent):void
    {
        this.backSiteSignal.dispatch();
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

