package com.example.promiseprioritychain;

import android.os.Handler;
import android.os.Message;
import android.util.Log;
import androidx.annotation.NonNull;

public class PriorityPromiseImp<T, E> implements IPriorityPromise {

    private String id = "PriorityPromiseImp";

    private T input = null;
    private E output = null;
    private Handler handler = null;
    private PriorityElementImp<T, E> element = null;

    public PriorityPromiseImp(PriorityElementImp<T, E> element) {
        this.element = element;
    }

    public PriorityPromiseImp(String id, PriorityElementImp<T, E> element) {
        this.id = id;
        this.element = element;
    }

    @Override
    public String getId() {
        return id;
    }

    @Override
    public void setInput(Object i) {
        this.input = (T) i;
    }

    @Override
    public T getInput() {
        return this.input;
    }

    @Override
    public void setOutput(Object o) {
        this.output = (E) o;
    }

    @Override
    public E getOutput() {
        return this.output;
    }

    @Override
    public PriorityElementImp<T, E> getPriorityElement() {
        return this.element;
    }

    @Override
    public void notifyMainThreadByHandler(int mode, long delay) {
        if (null != handler) {
            Message msg = handler.obtainMessage();
            msg.arg1 = LOOP_VALIDATED_MODE;
            msg.obj = this;
            handler.sendMessageDelayed(msg, delay);
            return;
        }

        handler = new Handler(msg -> {
            Log.i("Priority", "1. thread name : " + Thread.currentThread().getName());
            //
            IPriorityPromise<T, E> promise = (IPriorityPromise<T, E>)msg.obj;
            if (LOOP_VALIDATED_MODE == msg.arg1) {
                promise.getPriorityElement().executeWithData(promise.getInput());
                return true;
            }
            promise.getPriorityElement().executeNextWithData(promise.getInput());
            return true;
        });

    }

    @Override
    public void invalidate() {
        handler.removeMessages(PROMISE_PROORITY_WHAT);
    }

}
