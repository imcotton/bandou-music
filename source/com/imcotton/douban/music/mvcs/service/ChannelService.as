package com.imcotton.douban.music.mvcs.service
{

import by.blooddy.crypto.serialization.JSON;

import com.imcotton.douban.music.mvcs.model.ChannelItem;
import com.imcotton.douban.music.mvcs.model.IChannelModel;

import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.net.URLLoader;
import flash.net.URLRequest;


public class ChannelService implements IChannelService
{
    
    [Inject]
    public var channelModel:IChannelModel;
    
    public function ChannelService ()
    {
        this.init();
    }
    
    private var url:String = "http://www.douban.com/j/app/radio/channels";

    private var loader:URLLoader;
    
    public function load ():void
    {
        this.loader.load(new URLRequest(this.url));
    }
    
    private function init ():void
    {
        this.loader = new URLLoader();
        this.loader.addEventListener(Event.COMPLETE, onComplete);
        this.loader.addEventListener(IOErrorEvent.IO_ERROR, onError);
    }
    
    private function onComplete (event:Event):void
    {
        var array:Array;
        
        try
        {
            array = Object(JSON.decode(this.loader.data)).channels;
        }
        catch (error:Error)
        {
            this.onError();
        }
        
        array.sortOn("channel_id", Array.NUMERIC);
        
        var tmp:Object;

        for (var i:String in array)
        {
            tmp = array[i];
            array[i] = new ChannelItem(tmp.channel_id, tmp.name);
        }
        
        this.channelModel.updateList(array);
    }
    
    private function onError (event:Event = null):void
    {
    }
}
}

