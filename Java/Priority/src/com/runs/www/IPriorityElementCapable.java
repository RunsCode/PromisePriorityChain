package com.runs.www;

public interface IPriorityElementCapable<T> {
}

@FunctionalInterface
interface IPriorityElementSubscribeCallback<T> {
    void subscribe(T t);
}

@FunctionalInterface
interface IPriorityElementErrorCallback {
    void exception(Error error);
}

@FunctionalInterface
interface IPriorityElementDisposeCallback {
    void dispose();
}

interface IPriorityElement<T, E> {

    <T1, E1>IPriorityElement<T1, E1> then(IPriorityElement<T1, E1> element);
    <T1, E1>IPriorityElement<T1, E1> next();

    void executeWithData(T input);
    void executeNextWithData(Object object);
    void breakWithError(Error error);

    void invalidate();
}
