KKSNotificationController
=========================

An simple  wrapper of NSNotification operations inspired by FBKVOController. Fetures include:

* Clarity method name
* Implicit observer removal on controller dealloc.

### USage
```
// create Notification controller with observer
MUPNotificationController *notificationController = [MUPNotificationController controllerWithObserver:self];
self.notificationController = notificationController;

// use Selector
[self.notificationController observeNotification:notificationName object:nil selector:@selector(NotificationSelector)];

// use Block
[self.notificationController observeNotification:notificationName object:nil block:^(NSNotification *notification) {
                // Do something
}];
```
This is the complete example. The removal of observer will be done when controller is deallocated.

### NSObject Category

A `NSObject` Category is provided to give you direct access of controller.

```
[self.notificationController observeNotification:notificationName object:nil block:^(NSNotification *notification) {
              // Do something
}];
```

### Prerequisites
NotificationController using ARC and weak Collections. it requires:
* iOS 6 or later.
* OS X 10.7 or later.

