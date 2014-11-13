//
//  KKSNotificationController.h
//  KKSNotificationController
//
//  Created by kukushi on 11/12/14.
//  Copyright (c) 2014 Xing He. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^KKSNotificationBlock)(NSNotification *notification);

@interface KKSNotificationController : NSObject

- (instancetype)initWithObserver:(id)obervser;

+ (instancetype)controllerWithObserver:(id)observer;

- (void)observeNotification:(NSString *)name object:(id)object selector:(SEL)selector;

- (void)observeNotification:(NSString *)name object:(id)object block:(KKSNotificationBlock)block;

- (void)observeNotification:(NSString *)name object:(id)object block:(KKSNotificationBlock)block queue:(NSOperationQueue *)queue;

- (void)unobserveNotification:(NSString *)name;

- (void)unobserveNotification:(NSString *)name object:(NSObject *)object;

- (void)unobserveAll;

@end

@interface NSObject (KKSNotificationController)

@property (nonatomic, strong) KKSNotificationController *notificationController;

@end

