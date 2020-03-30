package com.example.promiseprioritychain;

public class PriorityElementImp<T, E> implements IPriorityElement {

    private String id = "PriorityElementImp";

    private PriorityPromiseImp<T, E> promise;

    private IPriorityPromiseCallback<T, E> callback;

    private PriorityElementImp<?, ?> next;

    private IPriorityElementSubscribeCallback<E> subscribeCallback;

    private IPriorityElementErrorCallback errorCallback;

    private IPriorityElementDisposeCallback disposeCallback;


    public PriorityElementImp(IPriorityPromiseCallback<T, E> callback) {
        this.callback = callback;
    }

    public PriorityElementImp(String id, IPriorityPromiseCallback<T, E> callback) {
        this.id = id;
        this.callback = callback;
    }

    @Override
    public IPriorityElement then(IPriorityElement element) {
        this.next = (PriorityElementImp<?, ?>) element;
        return element;
    }

    @Override
    public PriorityElementImp<?, ?> next() {
        return this.next;
    }

    @Override
    public void executeWithData(Object data) {
        promise = new PriorityPromiseImp<>("PriorityPromiseImp -> " + id, this);
        promise.setInput((T) data);
        callback.run(promise);
    }

    @Override
    public void executeNextWithData(Object data) {
        IPriorityElement nextElement = this.next();
        if (null != nextElement) {
            nextElement.executeWithData(data);
        }
        //
        handleCompletedWithOutput((E) data);
    }

    @Override
    public void breakWithError(Error error) {
        if (null != errorCallback) {
            errorCallback.exception(error);
        }
        releasePromise();
    }

    @Override
    public void invalidate() {
        if (null != promise) {
            promise.invalidate();
        }
        releasePromise();
    }

    private void handleCompletedWithOutput(E o) {
        if (null != subscribeCallback) {
            subscribeCallback.subscribe(o);
        }
        releasePromise();
    }

    private void releasePromise() {
        if (null != promise) {
            promise = null;
        }
        if (null != disposeCallback) {
            disposeCallback.dispose();
        }
    }

    public PriorityElementImp<T, E> subscribe(IPriorityElementSubscribeCallback<E> subscribeCallback) {
        this.subscribeCallback = subscribeCallback;
        return this;
    }

    public PriorityElementImp<T, E> exception(IPriorityElementErrorCallback errorCallback) {
        this.errorCallback = errorCallback;
        return this;
    }

    public PriorityElementImp<T, E> dispose(IPriorityElementDisposeCallback disposeCallback) {
        this.disposeCallback = disposeCallback;
        return this;
    }

}
