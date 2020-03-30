package com.example.promiseprioritychain;


import android.os.Handler;
import android.os.Message;
import android.util.Log;
import androidx.annotation.NonNull;

@FunctionalInterface
interface IPriorityPromiseCallback<T, E> {

    void run(IPriorityPromise<T, E> promise);

}

public interface IPriorityPromise<T, E> {

    static final int PROMISE_PROORITY_WHAT = 1 << 4;
    static final int LOOP_VALIDATED_MODE = 1 << 8;
    static final int CONDITION_DELAY_MODE = 1 << 16;


    String getId();

    void setInput(T t);
    T getInput();

    void setOutput(E o);
    E getOutput();

    IPriorityElement<T, E> getPriorityElement();
    void notifyMainThreadByHandler(int mode, long delay);

    default void next(E o) {
        IPriorityElement e = getPriorityElement();
        if (null != e) {
            e.executeNextWithData(o);
        }
    }

    default void brake(Error error) {
        if (null == error) {
            error = new Error("NO Error Description");
        }
        getPriorityElement().breakWithError(error);
    }

    default void validated(boolean isValid) {
        if (isValid) {
            getPriorityElement().executeNextWithData(getOutput());
            return;
        }
        getPriorityElement().breakWithError(new Error("validated failure"));
    }

    default void loopValidated(boolean isValid, long interval) {
        Log.i("Priority",  "0. thread name : " + Thread.currentThread().getName());
        if (isValid || 0 == interval) {
            getPriorityElement().executeNextWithData(getOutput());
            return;
        }

        if (0 >= interval) {
            Error error = new Error("interval must bigger than 0");
            getPriorityElement().breakWithError(error);
            return;
        }
        //
        notifyMainThreadByHandler(LOOP_VALIDATED_MODE, interval);
    }

    default void condition(boolean isOk, long delay) {
        if (!isOk || 0 >= delay) {
            getPriorityElement().executeNextWithData(getInput());
            return;
        }
        //
        notifyMainThreadByHandler(CONDITION_DELAY_MODE, delay);
    }

    void invalidate();

}
