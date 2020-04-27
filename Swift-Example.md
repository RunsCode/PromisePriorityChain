
[toc]

```swift
    private var count: Int = 0

    let head: PriorityElement<String, Int> = self.head()
    head.then(neck())
        .then(lung())
        .then(heart())
        .then(liver())
        .then(over())
    //head.execute(with: "head->")
    // nil also default value()
    head.execute()
```

#### General asynchronous operations 

    
```swift
	// This is a complete way to create element
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
  // This is a minimalist way to create element, 
  // using anonymous closure parameters and initializing default parameters
   private func neck() -> PriorityElement<Int, String> {
        return PriorityElement {
            Println("neck input : \($0.input ?? -1)")
            $0.output = "I am Neck"
            $0.validated($0.input == 1)
        }.subscribe { ... }.catch { err in ... }.dispose { ... }
    }
```

#### Loop delay check operation (e.g. polling)


```swift
	// This is a recommended way to create element, providing an ID for debugging
    private func lung() -> PriorityElement<String, String> {
        return PriorityElement(id: "Lung") { 
            Println("lung input : \($0.input ?? "-1")")
            self.count += 1
            //
            $0.output = "I am Lung"
            $0.loop(validated: self.count >= 5, t: 1)
        }.subscribe { ... }.catch { err in ... }.dispose { ... }
    }
```

#### Condition check operation 

```swift
    private func heart() -> PriorityElement<String, String> {
        return PriorityElement(id: "Heart") {
            Println("lung input : \($0.input ?? "-1")")
            self.count += 1
            //
            $0.output = "I am Lung"
            $0.condition(self.count > 5, delay: 1)
        }.subscribe { ... }.catch { err in ... }.dispose { ... }
    }
```

#### Normal operation

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
