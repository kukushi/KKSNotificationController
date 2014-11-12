//
//  KKSNotificationController.m
//  KKSNotificationController
//
//  Created by kukushi on 11/12/14.
//  Copyright (c) 2014 Xing He. All rights reserved.
//


#import "KKSNotificationController.h"
#import <objc/message.h>

@interface _KKSNotificationInfo: NSObject

@property (nonatomic, weak) id observer;
@property (nonatomic, assign) SEL selector;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) id object;

@end

@implementation _KKSNotificationInfo

- (instancetype)initWithObserver:(id)observer
                           name:(NSString *)name
                         object:(id)object
                       selector:(SEL)selector {
    self = [super init];
    if (self) {
        _observer = observer;
        _selector = selector;
        _object = object;
        _name = [name copy];
    }
    return self;
}


+ (instancetype)infoWithObserver:(id)observer
                           name:(NSString *)name
                         object:(id)object
                       selector:(SEL)selector {
    return [[_KKSNotificationInfo alloc] initWithObserver:observer name:name object:object selector:selector];
}

+ (instancetype)infoWithObserver:(id)observer
                           name:(NSString *)name
                         object:(id)object {
    return [[_KKSNotificationInfo alloc] initWithObserver:observer name:name object:object selector:nil];
}

+ (instancetype)infoWithObserver:(id)observer
                           name:(NSString *)name
                       selector:(SEL)selector {
    return [[_KKSNotificationInfo alloc] initWithObserver:observer name:name object:nil selector:selector];
}

- (NSUInteger)hash {
    return [self.name hash];
}

- (BOOL)isEqual:(id)object {
    if (nil == object) {
        return NO;
    }
    if (self == object) {
        return YES;
    }
    if (![object isKindOfClass:[self class]]) {
        return NO;
    }
    return [self.name isEqualToString:((_KKSNotificationInfo *)object)->_name];
}

@end



@interface KKSNotificationController ()

@property (nonatomic, weak) id observer;
@property (nonatomic, strong) NSMutableSet *blockInfos;
@property (nonatomic, strong) NSMutableSet *selectorInfos;

@end

@implementation KKSNotificationController

#pragma mark - Initialization

- (instancetype)initWithObserver:(id)observer {
    if (self = [super init]) {
        _observer = observer;
        _blockInfos = [NSMutableSet set];
        _selectorInfos = [NSMutableSet set];
    }
    return self;
}

+ (instancetype)controllerWithObserver:(id)observer {
    return [[KKSNotificationController alloc] initWithObserver:observer];
}

- (void)dealloc {
    [self unobserveAll];
}

#pragma mark - Observe

- (void)observeNotification:(NSString *)name
                     object:(id)object
                   selector:(SEL)selector {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receivedNotification:)
                                                 name:name
                                               object:object];
    _KKSNotificationInfo *info = [_KKSNotificationInfo infoWithObserver:self.observer
                                                                  name:name
                                                              selector:selector];
    NSAssert(self.observer != nil, @"Observer should not be nil");
    [self.selectorInfos addObject:info];
}


- (void)receivedNotification:(NSNotification *)notification {
    NSString *name = notification.name;
    for (_KKSNotificationInfo *info in self.selectorInfos){
        if ([info.name isEqualToString:name] && info.selector) {
            [info.observer performSelector:info.selector withObject:notification afterDelay:0.f];
        }
    }
}



- (void)observeNotification:(NSString *)name object:(id)object block:(KKSNotificationBlock)block {
    id observer = [[NSNotificationCenter defaultCenter] addObserverForName:name
                                                                    object:object
                                                                     queue:[NSOperationQueue mainQueue]
                                                                usingBlock:block];
    _KKSNotificationInfo *info = [_KKSNotificationInfo infoWithObserver:observer
                                                                  name:name
                                                                object:object];
    [self.blockInfos addObject:info];
}

#pragma mark - Unobserve

- (void)unobserveNotification:(NSString *)name {
    if (!name) {
        return;
    }
    [self unobserveNotification:name object:nil];
}

- (void)unobserveNotification:(NSString *)name object:(NSObject *)object {
    if (!name && !object) {
        return;
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:name object:object];
    
    for (_KKSNotificationInfo *info in self.blockInfos) {
        
        if ([info.name isEqualToString:name] && info.object == object) {
            [[NSNotificationCenter defaultCenter] removeObserver:info.observer name:info.name object:info.object];
        }
    }
}

- (void)unobserveAll {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    for (_KKSNotificationInfo *info in self.blockInfos) {
        [[NSNotificationCenter defaultCenter] removeObserver:info.observer
                                                        name:info.name
                                                      object:info.object];
    }
}


@end


#pragma mark - NSObject Category

static void *NSObjectNotificationControllerKey = &NSObjectNotificationControllerKey;

@implementation NSObject (KKSNotificationController)


- (KKSNotificationController *)notificationController {
    id controller = objc_getAssociatedObject(self, NSObjectNotificationControllerKey);
    
    // lazily create the NotificationController
    if (!controller) {
        controller = [KKSNotificationController controllerWithObserver:self];
        self.notificationController = controller;
    }
    
    return controller;
}

- (void)setNotificationController:(KKSNotificationController *)notificationController {
    objc_setAssociatedObject(self, NSObjectNotificationControllerKey, notificationController, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end