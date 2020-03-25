package com.runs.www;

public class PriorityPromiseImp<T, E> implements IPriorityPromise {

    private String id = "PriorityPromiseImp";
    private PriorityElementImp<T, E> element;
    private DelayComponentImp delayComponentImp;

    private T input = null;
    private E output = null;

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
    public void invalidate() {
        IPriorityPromise.super.invalidate();
        if (null != delayComponentImp) {
            delayComponentImp = null;
        }
    }

    @Override
    public IDelayComponent getDelayComponent() {
        if (null != delayComponentImp) {
            return delayComponentImp;
        }
        delayComponentImp = new DelayComponentImp();
        return delayComponentImp;
    }

}
