package com.imcotton.douban.music.mvcs.model
{

import mx.utils.ObjectUtil;


public class PlayListItem
{

    public var aid:String;
    public var sid:String;

    public var liked:Boolean;

    public var artistName:String;

    public var albumName:String;
    public var albumCoverURL:String;

    public var songURL:String;
    public var songName:String;
    public var songDuration:int;  //  in second

    public function toString ():String
    {
        return ObjectUtil.toString(this);
    }

}
}

