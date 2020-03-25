package com.runs.www;

public interface IDelayComponent {

    void delay(long delay, IDelayComponentCallback callback);

    void cancel();

}
