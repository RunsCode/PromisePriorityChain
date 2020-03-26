package com.runs.www;

public interface IPriorityElementCapable<T, E> {

//    IPriorityElementCapable<T, E> subscribe(IPriorityElementSubscribeCallback<T> subscribeCallback);
//    IPriorityElementCapable<T, E> exception(IPriorityElementErrorCallback errorCallback);
//    IPriorityElementCapable<T, E> dispose(IPriorityElementDisposeCallback disposeCallback);
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
