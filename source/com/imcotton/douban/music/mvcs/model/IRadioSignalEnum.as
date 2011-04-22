package com.imcotton.douban.music.mvcs.model
{

import org.osflash.signals.ISignal;


public interface IRadioSignalEnum
{

    function get loadProgressSignal ():ISignal;
    function get playProgressSignal ():ISignal;

}
}

