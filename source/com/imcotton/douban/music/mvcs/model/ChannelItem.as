package com.imcotton.douban.music.mvcs.model
{

public class ChannelItem
{

    public var id:String;
    public var name:String;

    public function ChannelItem ($id:String, $name:String)
    {
        this.id = $id;
        this.name = $name;
    }

    public function toString ():String
    {
        return ["id=", this.id, " ", "name=", this.name].join("");
    }

}
}

