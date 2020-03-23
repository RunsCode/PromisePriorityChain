
[toc]

```swift
    private var count: Int = 0

    let head: PriorityElement<String, Int> = self.head()
    head.then(neck())
        .then(lung())
        .then(heart())
        .then(liver())
        .then(over())
    head.execute(with: "head->")
```

#### General asynchronous operations 

    
```swift
    private func head() -> PriorityElement<String, Int> {
        return PriorityElement(id: "Head") {  (promise: PriorityPromise<String, Int>) in
            Println("head input : \(promise.input ?? "")")
            self.delay(1) {
                promise.next(1)
            }
        }.subscribe { i in
            Println("head subscribe : \(i ?? -1)")
        }.catch { err in
            Println("head catch : \(String(describing: err))")
        }.dispose {
            Println("head dispose")
        }
    }
```

#### General check operation (if else nesting)


```swift
    private func neck() -> PriorityElement<Int, String> {
        return PriorityElement(id: "Neck") { (promise: PriorityPromise<Int, String>) in
            Println("neck input : \(promise.input ?? -1)")
            self.delay(0.5) {
                promise.output = "I am Neck"
                promise.validated(promise.input == 1)
            }
        }.subscribe { ... }.catch { err in ... }.dispose { ... }
    }
```

#### Loop delay check operation (e.g. polling)


```swift

    private func lung() -> PriorityElement<String, String> {
        return PriorityElement(id: "Lung") { (promise: PriorityPromise<String, String>) in
            Println("lung input : \(promise.input ?? "-1")")
            self.count += 1
            //
            promise.output = "I am Lung"
            promise.loop(validated: self.count >= 5, t: 1)
        }.subscribe { ... }.catch { err in ... }.dispose { ... }
    }
```

#### Loop delay check operation (e.g. polling)

```swift
    private func heart() -> PriorityElement<String, String> {
        return PriorityElement(id: "Heart") { (promise: PriorityPromise<String, String>) in
            Println("heart input : \(promise.input ?? "-1")")
            //
            promise.output = "I am Heart"
            promise.condition(self.count > 5, delay: 2)

        }.subscribe { ... }.catch { err in ... }.dispose { ... }
    }
```

#### State delay check operation

```swift
    private func liver() -> PriorityElement<String, String> {
        return PriorityElement(id: "Liver") { (promise: PriorityPromise<String, String>) in
            Println("liver input : \(promise.input ?? "-1")")
            //
            self.delay(1) {
                promise.break(nil)
            }
        }.subscribe { ... }.catch { err in ... }.dispose { ... }
    }
```

```swift
    private func over() -> PriorityElement<String, String> {
        return PriorityElement(id: "Over") { (promise: PriorityPromise<String, String>) in
            Println("over input : \(promise.input ?? "-1")")
            //
            self.delay(1) {
                promise.next("Finished Release")
            }
        }.subscribe { ... }.catch { err in ... }.dispose { ... }
    }
```

```swift
    func delay(_ interval: TimeInterval, _ block: @escaping () -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + interval) {
            block()
        }
    }
```
