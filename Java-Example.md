```java
    public static int mCount = 0;

    public static void main(String[] args) {

        PriorityElementImp<Integer, Integer> element0 = testElement0();
        PriorityElementImp<String, String> testElement5 = testElement5();

        testElement5.subscribe(s -> {
            System.out.println("testElement5 subscribe : " + s);
        }).exception(error -> {
            System.out.println("testElement5 exception : " + error.getMessage());
        }).dispose(() -> {
            System.out.println("testElement5 dispose");
        });

        element0
                .then(testElement1())
                .then(testElement2())
                .then(testElement3())
                .then(testElement4())
                .then(testElement5);
        element0.executeWithData(10);

    }
```

#### Normal operation


```java

    public static PriorityElementImp testElement0() {
        return new PriorityElementImp<Integer, Integer>( promise -> {

            Integer t = promise.getInput();
            System.out.println("t = " + t.toString());
            System.out.println("100ms查询一次，一共查询5次， 轮询 ");
            promise.next(100);

        }).subscribe(integer -> {
            System.out.println("element0 subscribe : " + integer);
        }).exception(error -> {
            System.out.println("element0 exception : " + error.getMessage());
        }).dispose(() -> {
            System.out.println("element0 dispose");
        });
    }
```

#### Loop delay check operation (e.g. polling)


```java

    public static PriorityElementImp testElement1() {
        return new PriorityElementImp<Integer, Integer>( promise -> {

            mCount++;
            System.out.println(System.currentTimeMillis() + "  mCount = " + mCount);
            promise.setOutput(mCount);
            promise.loopValidated(mCount >= 5, 100);

        }).subscribe(integer -> {
            System.out.println("testElement1 subscribe : " + integer);
        }).exception(error -> {
            System.out.println("testElement1 exception : " + error.getMessage());
        }).dispose(() -> {
            System.out.println("testElement1 dispose");
        });
    }
```

#### General asynchronous operations 


```java

    public static PriorityElementImp testElement2() {
        return new PriorityElementImp<Integer, Integer>( promise -> {

            Integer t = promise.getInput();
            System.out.println("t = " + t.toString());
            promise.next(10000);

        }).subscribe(integer -> {
            System.out.println("testElement2 subscribe : " + integer);
        }).exception(error -> {
            System.out.println("testElement2 exception : " + error.getMessage());
        }).dispose(() -> {
            System.out.println("testElement2 dispose");
        });
    }
```

#### General check operation (if else nesting)



```java

    public static PriorityElementImp testElement3() {
        return new PriorityElementImp<Integer, String>( promise -> {

            Integer t = promise.getInput();
            System.out.println("t = " + t.toString());
            promise.setOutput("即将延迟校验结束");
            promise.validated(t > 100);

        }).subscribe(s -> {
            System.out.println("testElement3 subscribe : " + s);
        }).exception(error -> {
            System.out.println("testElement3 exception : " + error.getMessage());
        }).dispose(() -> {
            System.out.println("testElement3 dispose");
        });
    }
```

#### Condition check operation 


```java

    public static PriorityElementImp testElement4() {
        return new PriorityElementImp<String, String>(promise -> {

            String s = promise.getInput();
            System.out.println(s);
            System.out.println(System.currentTimeMillis() + "  begin 延迟1000ms校验结束");
            promise.setOutput("结束了");
            promise.condition(mCount >= 5, 1000);

        }).subscribe(s -> {
            System.out.println("testElement4 subscribe : " + s);
        }).exception(error -> {
            System.out.println("testElement4 exception : " + error.getMessage());
        }).dispose(() -> {
            System.out.println("testElement4 dispose");
        });
    }
```
```java

    public static PriorityElementImp<String, String> testElement5() {
        return new PriorityElementImp<>(promise -> {
            System.out.println(System.currentTimeMillis() + "  end 延迟1000ms校验结束");
            String s = promise.getInput();
            System.out.println(s);
//            promise.next("game over");
            promise.brake(null);
        });
    }

```
