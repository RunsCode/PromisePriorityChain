package com.runs.www;

@FunctionalInterface
interface IPriorityPromiseCallback<T, E> {

    void run(IPriorityPromise<T, E> promise);

}

public interface IPriorityPromise<T, E> {

    String getId();

    void setInput(T t);
    T getInput();

    void setOutput(E o);
    E getOutput();

    IPriorityElement<T, E> getPriorityElement();
    IDelayComponent getDelayComponent();

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

    //TODO:There is a pain point here:
    // the action performed by the current thread is switched to another thread,
    // and this API is not recommended if it is a UI operation
    default void loopValidated(boolean isValid, long interval) {
        if (isValid) {
            getPriorityElement().executeNextWithData(getOutput());
            return;
        }

        if (0 > interval) {
            Error error = new Error("interval must bigger than 0");
            getPriorityElement().breakWithError(error);
            return;
        }

        getDelayComponent().delay(interval,() -> getPriorityElement().executeWithData(getInput()));
    }

    //TODO:There is a pain point here:
    // the action performed by the current thread is switched to another thread,
    // and this API is not recommended if it is a UI operation
    default void condition(boolean isOk, long delay) {
        if (!isOk || 0 >= delay) {
            getPriorityElement().executeNextWithData(getInput());
            return;
        }

        getDelayComponent().delay(delay, () -> getPriorityElement().executeNextWithData(getOutput()));
    }

    default void invalidate() {
        getDelayComponent().cancel();
    }

}
