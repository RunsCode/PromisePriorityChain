package com.runs.www;

public interface IPriorityElement<T, E> {

    <T1, E1>IPriorityElement<T1, E1> then(IPriorityElement<T1, E1> element);
    <T1, E1>IPriorityElement<T1, E1> next();

    void executeWithData(T input);
    void executeNextWithData(Object object);
    void breakWithError(Error error);

    void invalidate();

    IPriorityElement subscribe(IPriorityElementSubscribeCallback<T> subscribeCallback);
    IPriorityElement error(IPriorityElementErrorCallback errorCallback);
    IPriorityElement dispose(IPriorityElementDisposeCallback disposeCallback);

}
