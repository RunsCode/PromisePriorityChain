package com.runs.www;

public class PriorityElementImp<T, E> implements IPriorityElement {

    private String id = "PriorityElementImp";

    private PriorityPromiseImp<T, E> promise;

    private IPriorityPromiseCallback<T, E> callback;

    private PriorityElementImp<?, ?> next;


    public PriorityElementImp() {}

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
        releasePromise();
    }

    @Override
    public void breakWithError(Error error) {
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
        releasePromise();

    }

    private void releasePromise() {
        if (null != promise) {
            promise = null;
        }
    }
}
