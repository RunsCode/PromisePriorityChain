package com.runs.www;

@FunctionalInterface
interface IPriorityPromiseCallback<T, E> {

    void run(PriorityPromiseImp<T, E> promise);

}
