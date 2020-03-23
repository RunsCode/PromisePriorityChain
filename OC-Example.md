

```objectivec

	无需强引用 自引用内存管理 只要保证每一个element 链路完整向下传递或打断即可 promise.xxx()

    PrioritySessionElement<NSNumber *, NSString *> *headElement = [self customSession];
    PrioritySessionElement *normalAsyncElement = [self normalAsyncElement];
    PrioritySessionElement *testElement = [[PromisePriority(NSString *, id) {
        promise.next(@"11000");// promise.brake(error);
    } identifier:@"testElement"] dispose:^{ ... }];

    headElement
    .then(normalAsyncElement)
    .then(testElement)
    .then(self.loopValidatedElement)
    .then(self.conditionDelayElement)
    .then(self.validatedElement);
    [headElement executeWithData:@(-2)];
}
```

* 常规校验操作 Element （if else 嵌套）

``` objectivec
- (PrioritySessionElement *)validatedElement {
    return [[[[PromisePriority(NSString *, NSNumber *){
        promise.output = @10086;
        promise.validated(isValid);
    } identifier:@"validatedElement"] subscribe:^(NSNumber * _Nullable value) {
        NSLog(@"validatedElement subscribe data = %@", value);
    }] catch:^(NSError * _Nullable error) { ... }] dispose:^{ ...}];
``` 

* 状态延迟校验Element


``` objectivec
- (PrioritySessionElement *)conditionDelayElement {
    return [[[[PromisePriority(NSNumber *, NSString *) {
        promise.output = @"10098";
        promise.conditionDelay(conditionIsOK, 3.f);
    } identifier:@"conditionDelayElement"]];
}
``` 

* 循环延迟校验Element（轮询）


``` objectivec
- (PrioritySessionElement *)loopValidatedElement {
    return [PromisePriority(NSString *, NSNumber *) {
        promise.output = @(1);
        promise.loopValidated(isValid, 1.f);
    }];
}
``` 

* 常规异步Element


``` objectivec

- (PrioritySessionElement *)normalAsyncElement {
    return [PromisePriority(NSNumber *, NSString *) {...}];
}
``` 

* 自定义实现Element
 
``` objectivec

- (PrioritySessionElement *)customSession {
    return [PrioritySessionCustomElement new];
}

```