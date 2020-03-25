package com.runs.www;

import java.util.TimerTask;

public interface IDelayComponent {

    void delay(long delay, IDelayComponentCallback callback);

    void cancel();

}
