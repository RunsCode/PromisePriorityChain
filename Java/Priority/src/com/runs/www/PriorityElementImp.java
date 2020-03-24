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
        this.promise = new PriorityPromiseImp<>("PriorityPromiseImp -> " + id, this);
        this.promise.setInput((T) data);
        callback.run(this.promise);
    }

    @Override
    public void executeNextWithData(Object data) {
        this.next().executeWithData(data);
        //
        this.promise = null;
    }

    @Override
    public void breakWithError(Error error) {
        this.promise = null;
    }

    @Override
    public void invalidate() {
        this.promise.invalidate();
        this.promise = null;
    }

    private void handleCompletedWithOutput(E o) {
        this.promise = null;

    }
}
