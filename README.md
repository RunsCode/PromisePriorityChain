# PromisePriorityChian

```objectivec

- (void)testExample {

    PrioritySessionElement<NSNumber *, NSString *> *headElement = [[self customSession] dispose:^{
        NSLog(@"❤️headElement dispose❤️");
    }];
    PrioritySessionElement *normalAsyncElement = [[self normalAsyncElement] dispose:^{
        NSLog(@"❤️normalAsyncElement dispose❤️");
    }];
    PrioritySessionElement *testElement = [[PromisePriority(NSString *, id) {
        NSLog(@"testElement promise data = %@", promise.input);
        promise.next(@"11000");
    } identifier:@"testElement"] dispose:^{
        NSLog(@"❤️testElement dispose❤️");
    }];


    headElement
    .then(normalAsyncElement)
    .then(testElement)
    .then(self.loopValidatedElement)
    .then(self.conditionDelayElement)
    .then(self.validatedElement);

    [headElement executeWithData:@(-2)];
}

- (PrioritySessionElement *)validatedElement {
    return [[[[PromisePriority(NSString *, NSNumber *){

        promise.output = @10086;
        promise.validated(self.testCount >= 5);
        NSLog(@"validatedElement promise data = %@", promise.input);

    } identifier:@"validatedElement"] subscribe:^(NSNumber * _Nullable value) {
        NSLog(@"validatedElement subscribe data = %@", value);
    }] catch:^(NSError * _Nullable error) {

    }] dispose:^{
        NSLog(@"❤️validatedElement dispose❤️");
    }];
}

- (PrioritySessionElement *)conditionDelayElement {
    return [[[[PromisePriority(NSNumber *, NSString *) {

        promise.output = @"10098";
        promise.conditionDelay(self.testCount >= 5, 3.f);

    } identifier:@"conditionDelayElement"] subscribe:^(NSString * _Nullable value) {

        NSLog(@"conditionDelayElement subscribe value = %@", value);

    }] catch:^(NSError * _Nullable error) {
        NSLog(@"💥 conditionDelayElement catch error = %@", error.domain);
    }] dispose:^{
        NSLog(@"❤️conditionDelayElement dispose❤️");
    }];
}

- (PrioritySessionElement *)loopValidatedElement {
    return [[[[PromisePriority(NSString *, NSNumber *) {

        self.testCount++;
        promise.output = @(1);
        NSLog(@"testCount = %lu", (unsigned long)self.testCount);
        promise.loopValidated(self.testCount > 5, 1);

    } identifier:@"loopValidatedElement"] subscribe:^(NSNumber * _Nullable value) {
        NSLog(@"loopValidatedElement subscribe value = %@", value.stringValue);
    }] catch:^(NSError * _Nullable error) {
        NSLog(@"💥 loopValidatedElement catch error = %@", error.domain);
    }] dispose:^{
        NSLog(@"❤️loopValidatedElement dispose❤️");
    }];
}

- (PrioritySessionElement *)normalAsyncElement {
    return [[[PromisePriority(NSNumber *, NSString *) {
        [self dealy:0.2 completed:^{
            NSLog(@"normalAsyncElement promise data = %@", promise.input.stringValue);
            promise.next(@"session1");
//            promise.brake(nil);
        }];
    } identifier:@"normalAsyncElement"] subscribe:^(NSString * _Nullable value) {
        NSLog(@"normalAsyncElement subscribe value = %@", value);
    }] catch:^(NSError * _Nullable error) {
        NSLog(@"💥 normalAsyncElement catch error = %@", error.domain);
    }];
}

- (PrioritySessionElement *)customSession {
    PrioritySessionElement<NSNumber *, NSString *> *element = [PrioritySessionCustomElement new];
    return [[element subscribe:^(NSString * _Nullable value) {

        NSLog(@"customSession subscribe value = %@", value);

    }] catch:^(NSError * _Nullable error) {
        NSLog(@"💥 customSession catch error = %@", error.domain);
    }];
}


- (void)dealy:(CGFloat)second completed:(dispatch_block_t)completed {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(second * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        completed();
    });
}

```