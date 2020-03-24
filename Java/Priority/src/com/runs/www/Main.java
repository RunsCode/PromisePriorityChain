package com.runs.www;

public class Main {

    public static void main(String[] args) {
	// write your code here

        PriorityElementImp<Integer, Integer> element0 = testElement0();
        element0
                .then(testElement1())
                .then(testElement2())
                .then(testElement3());
        element0.executeWithData(10);

    }

    public static PriorityElementImp<Integer, Integer> testElement0() {
        return new PriorityElementImp<>( ( promise) -> {
            Integer t = promise.getInput();
            System.out.println("t = " + t.toString());
            promise.next(100);
//            promise.brake(null);
        });
    }

    public static PriorityElementImp<Integer, Integer> testElement1() {
        return new PriorityElementImp<>( ( promise) -> {
            Integer t = promise.getInput();
            System.out.println("t = " + t.toString());
            promise.next(1000);
        });
    }

    public static PriorityElementImp<Integer, Integer> testElement2() {
        return new PriorityElementImp<>((promise) -> {
            Integer t = promise.getInput();
            System.out.println("t = " + t.toString());
            promise.next(10000);
        });
    }

    public static PriorityElementImp<Integer, Integer> testElement3() {
        return new PriorityElementImp<>( ( promise) -> {
            Integer t = promise.getInput();
            System.out.println("t = " + t.toString());
            promise.brake(null);
        });
    }

    public static PriorityElementImp<Integer, Integer> testElement4() {
        return new PriorityElementImp<>( ( promise) -> {
//            Integer t = promise.getInput();
//            System.out.println("t = " + t.toString());
//            promise.brake(null);
        });
    }

}
