package com.runs.www;

import java.util.Timer;
import java.util.TimerTask;
import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;

import static java.util.concurrent.TimeUnit.*;

public class Main {

    public static int mCount = 0;

    public static void main(String[] args) {

        PriorityElementImp<Integer, Integer> element0 = testElement0();
        element0
                .then(testElement1())
                .then(testElement2())
                .then(testElement3())
                .then(testElement4())
                .then(testElement5());
        element0
                .subscribe(o -> System.out.println(o.toString()))
                .error(error -> System.out.println(error.toString()))
                .dispose(() -> System.out.println("dispose"));

        element0.executeWithData(10);

//        element0.subscribe(new IPriorityElementSubscribeCallback<Integer>() {
//            @Override
//            public void subscribe(Integer integer) {
//
//            }
//        });

//        element0.subscribe(new IPriorityElementSubscribeCallback() {
//            @Override
//            public void subscribe(Object o) {
//
//            }
//        });
//        .subscribe(new IPriorityElementSubscribeCallback() {
//            @Override
//            public void subscribe(Object o) {
//
//            }
//        });

    }

    public static PriorityElementImp<Integer, Integer> testElement0() {
        return new PriorityElementImp<>( promise -> {
            Integer t = promise.getInput();
            System.out.println("t = " + t.toString());
            System.out.println("100ms查询一次，一共查询5次， 轮询 ");
            promise.next(100);
        });
    }

    public static PriorityElementImp<Integer, Integer> testElement1() {
        return new PriorityElementImp<>( promise -> {
            mCount++;
            System.out.println(System.currentTimeMillis() + "  mCount = " + mCount);
            promise.setOutput(mCount);
            promise.loopValidated(mCount >= 5, 100);
        });
    }

    public static PriorityElementImp<Integer, Integer> testElement2() {
        return new PriorityElementImp<>( promise -> {
            Integer t = promise.getInput();
            System.out.println("t = " + t.toString());
            promise.next(10000);
        });
    }

    public static PriorityElementImp<Integer, String> testElement3() {
        return new PriorityElementImp<>( promise -> {
            Integer t = promise.getInput();
            System.out.println("t = " + t.toString());
            promise.setOutput("即将延迟校验结束");
            promise.validated(t > 100);
        });
    }

    public static PriorityElementImp<String, String> testElement4() {
        return new PriorityElementImp<>(promise -> {
            String s = promise.getInput();
            System.out.println(s);
            System.out.println(System.currentTimeMillis() + "  begin 延迟1000ms校验结束");
            promise.setOutput("结束了");
            promise.condition(mCount >= 5, 1000);
        });
    }

    public static PriorityElementImp<String, String> testElement5() {
        return new PriorityElementImp<>(promise -> {
            System.out.println(System.currentTimeMillis() + "  end 延迟1000ms校验结束");
            String s = promise.getInput();
            System.out.println(s);
//            promise.next("game over");
            promise.brake(null);
        });
    }


}
