package com.runs.www;

public interface IPriorityPromise<T, E> {

    String getId();

    void setInput(T t);
    T getInput();

    void setOutput(E o);
    E getOutput();

    IPriorityElement<T, E> getPriorityElement();

    default void next(T t) {
        getPriorityElement().executeNextWithData(t);
    }

    default void brake(Error error) {
        getPriorityElement().breakWithError(error);
    }

    default void validated(boolean isValid) {
        if (isValid) {
            getPriorityElement().executeNextWithData(getOutput());
            return;
        }
        getPriorityElement().breakWithError(new Error("validated failure"));
    }

    void loopValidated(boolean isValid, int interval);
    void condition(boolean isOk, int delay);
    void invalidate();
}
