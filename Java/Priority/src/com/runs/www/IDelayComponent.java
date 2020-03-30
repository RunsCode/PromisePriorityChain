package com.example.promiseprioritychain;

public interface IDelayComponent {

    void delay(long delay, IDelayComponentCallback callback);

    void cancel();

}

@FunctionalInterface
interface IDelayComponentCallback {
    void onFinish();
}
