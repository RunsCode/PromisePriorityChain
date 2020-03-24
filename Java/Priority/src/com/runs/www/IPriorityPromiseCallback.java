package com.runs.www;

@FunctionalInterface
interface IPriorityPromiseCallback<T, E> {

    void run(IPriorityPromise<T, E> promise);

}
