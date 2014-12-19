//
//  KKSNotificationControllerSpec.m
//  DemoOC
//
//  Created by kukushi on 11/11/14.
//  Copyright 2014 kukushi. All rights reserved.
//

#import <Kiwi.h>
#import "KKSNotificationController.h"
#import "KKSNotificationTest.h"

NSString * const KKSTesNotification = @"TestNotification";

SPEC_BEGIN(KKSNotificationControllerSpec)

describe(@"NotificationController", ^{
    
    context(@"when observe a notification pass by selector", ^{
        
        
        __block KKSNotificationTest *tester = nil;
        
        beforeAll(^{
            tester = [KKSNotificationTest new];
            NSString *notificationName = [NSString stringWithFormat:@"%lf", [NSDate timeIntervalSinceReferenceDate]];
            [tester.notificationController observeNotification:notificationName object:nil selector:@selector(plusOne)];
            [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:nil];
        });
        
        
        it(@"should receive one time", ^{
            [[expectFutureValue(theValue(tester.count)) shouldEventually] equal:theValue(1)];
        });
    });
    
    context(@"when observe a notification pass by block", ^{
        __block KKSNotificationTest *tester = nil;
        __block NSInteger count = 0;
        
        beforeAll(^{
            tester = [KKSNotificationTest new];
            NSString *notificationName = [NSString stringWithFormat:@"%lf", [NSDate timeIntervalSinceReferenceDate]];
            [tester.notificationController observeNotification:notificationName object:nil block:^(NSNotification *notification) {
                count ++;
            }];
            [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:nil];
        });
        
        it(@"should receive one time", ^{
            [[expectFutureValue(@(count)) shouldEventually] equal:theValue(1)];
        });
    });
    
    context(@"When the observer become nil", ^{
        __block KKSNotificationTest *tester = nil;
        
        beforeAll(^{
            tester = [KKSNotificationTest new];
            NSString *notificationName = [NSString stringWithFormat:@"%lf", [NSDate timeIntervalSinceReferenceDate]];
            [tester.notificationController observeNotification:notificationName object:nil selector:@selector(plusOne)];
            tester = nil;
            [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:nil];
        });
        
        it(@"should work without error", ^{
            
        });
    });
    
    
    
    
    context(@"when observe three same notification which posted twice", ^{
        
        __block KKSNotificationTest *tester = nil;
        
        beforeAll(^{
            tester = [KKSNotificationTest new];
            NSString *notificationName = [NSString stringWithFormat:@"%lf", [NSDate timeIntervalSinceReferenceDate]];
            [tester.notificationController observeNotification:notificationName object:nil selector:@selector(plusOne)];
            [tester.notificationController observeNotification:notificationName object:nil selector:@selector(plusOne)];
            [tester.notificationController observeNotification:notificationName object:nil selector:@selector(plusOne)];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:nil];
        });
        
        it(@"should receive 6 times", ^{
            [[expectFutureValue(@(tester.count)) shouldEventually] equal:theValue(6)];
        });
    });
    
    context(@"when unobserve the notification soon after receive a notfiction", ^{
        
        __block KKSNotificationTest *tester = nil;
        
        beforeAll(^{
            tester = [KKSNotificationTest new];
            NSString *notificationName = [NSString stringWithFormat:@"%lf", [NSDate timeIntervalSinceReferenceDate]];
            [tester.notificationController observeNotification:notificationName object:nil selector:@selector(plusOne)];
            [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:nil];
            
            [tester.notificationController unobserveNotification:notificationName];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:nil];
            
        });
        
        it(@"should only received one time", ^{
            [[expectFutureValue(@(tester.count)) shouldEventually] equal:theValue(1)];
        });
    });
    
    context(@"When observe a notification pass by selector and block", ^{
        __block KKSNotificationTest *tester = nil;
        __block NSInteger count = 0;
        
        beforeAll(^{
            tester = [KKSNotificationTest new];
            NSString *notificationName = [NSString stringWithFormat:@"%lf", [NSDate timeIntervalSinceReferenceDate]];
            [tester.notificationController observeNotification:notificationName object:nil selector:@selector(plusOne)];
            [tester.notificationController observeNotification:notificationName object:nil block:^(NSNotification *notification) {
                count += 1;
            }];
            [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:nil];
            
        });
        
        it(@"should received one time separately", ^{
            [[expectFutureValue(@(tester.count)) shouldEventually] equal:theValue(1)];
            [[expectFutureValue(@(count)) shouldEventually] equal:theValue(1)];
        });
    });
    
    context(@"When observe two same notifications pass by selector and block", ^{
        __block KKSNotificationTest *tester = nil;
        __block NSInteger count = 0;
        
        beforeAll(^{
            tester = [KKSNotificationTest new];
            NSString *notificationName = [NSString stringWithFormat:@"%lf", [NSDate timeIntervalSinceReferenceDate]];
            [tester.notificationController observeNotification:notificationName object:nil selector:@selector(plusOne)];
            [tester.notificationController observeNotification:notificationName object:nil block:^(NSNotification *notification) {
                count += 1;
            }];
            [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:nil];
            
        });
        
        it(@"should received twice separately", ^{
            [[expectFutureValue(@(tester.count)) shouldEventually] equal:theValue(2)];
            [[expectFutureValue(@(count)) shouldEventually] equal:theValue(2)];
        });
    });
    
    context(@"when unobserve before notification is fired", ^{
        __block KKSNotificationTest *tester = nil;
        __block NSInteger count = 0;
        __block NSString *notificationName = nil;
        
        beforeAll(^{
            tester = [KKSNotificationTest new];
            notificationName = [NSString stringWithFormat:@"%lf", [NSDate timeIntervalSinceReferenceDate]];
            [tester.notificationController observeNotification:notificationName object:nil selector:@selector(plusOne)];
            [tester.notificationController observeNotification:notificationName object:nil block:^(NSNotification *notification) {
                count += 1;
            }];
        });
        
        it(@"should not received the notification", ^{
            [tester.notificationController unobserveNotification:notificationName];
            [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:nil];
            [[expectFutureValue(@(tester.count)) shouldEventually] equal:theValue(0)];
            [[expectFutureValue(@(count)) shouldEventually] equal:theValue(0)];
        });
    });
    
    context(@"When observe a \"nil\" notification by block", ^{
        __block KKSNotificationTest *tester = nil;
        __block NSInteger count = 0;
        
        beforeAll(^{
            tester = [KKSNotificationTest new];
            [tester.notificationController observeNotification:nil object:nil block:^(NSNotification *notification) {
                count += 1;
            }];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"1" object:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"2" object:nil];
            
        });
        
        it(@"should received all (in this case, 2) the notifications", ^{
            [[expectFutureValue(@(count)) shouldEventually] equal:theValue(2)];
        });
    });
    
    context(@"when observe a notification pass by a hidden method", ^{
        __block KKSNotificationTest *tester = nil;
        
        beforeAll(^{
            tester = [KKSNotificationTest new];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
            [tester.notificationController observeNotification:@"3900" object:nil selector:@selector(plusTwo:)];
#pragma clang diagnostic pop
            
            NSObject *uiNotification = [[NSObject alloc] init];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"3900" object:uiNotification];
            
        });
        
        it(@"should received the notifications", ^{
            [[expectFutureValue(@(tester.count)) shouldEventually] equal:theValue(-20359)];
        });
    });
    
    
});

SPEC_END