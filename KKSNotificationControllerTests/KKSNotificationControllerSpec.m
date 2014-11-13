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

describe(@"KKSNotificationController", ^{
    
    context(@"When received notification observed by selector", ^{
        
        
        __block KKSNotificationTest *tester = nil;
        
        beforeAll(^{
            tester = [KKSNotificationTest new];
            NSString *notificationName = [NSString stringWithFormat:@"%lf", [NSDate timeIntervalSinceReferenceDate]];
            [tester.notificationController observeNotification:notificationName object:nil selector:@selector(plusOne)];
            [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:nil];
        });
        

        it(@"should received", ^{
            [[expectFutureValue(theValue(tester.count)) shouldEventually] equal:theValue(1)];
        });
    });
    
    context(@"When observer become nil", ^{
        __block KKSNotificationTest *tester = nil;
        
        beforeAll(^{
            tester = [KKSNotificationTest new];
            NSString *notificationName = [NSString stringWithFormat:@"%lf", [NSDate timeIntervalSinceReferenceDate]];
            [tester.notificationController observeNotification:notificationName object:nil selector:@selector(plusOne)];
            tester = nil;
            [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:nil];
        });
        
        it(@"should not have error", ^{
            
        });
    });
    
    
    context(@"When received notification observe by block", ^{
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
        
        it(@"should received", ^{
            [[expectFutureValue(@(count)) shouldEventually] equal:theValue(1)];
        });
    });
    
    context(@"When received 2 same notification which observe twice by selector", ^{
        
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
        
        it(@"should received", ^{
            [[expectFutureValue(@(tester.count)) shouldEventually] equal:theValue(6)];
        });
    });
    
    context(@"When received notification and remove observer", ^{
        
        __block KKSNotificationTest *tester = nil;
        
        beforeAll(^{
            tester = [KKSNotificationTest new];
            NSString *notificationName = [NSString stringWithFormat:@"%lf", [NSDate timeIntervalSinceReferenceDate]];
            [tester.notificationController observeNotification:notificationName object:nil selector:@selector(plusOne)];
            [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:nil];
            
            [tester.notificationController unobserveNotification:notificationName];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:nil];
            
        });
    
        it(@"should received", ^{
            [[expectFutureValue(@(tester.count)) shouldEventually] equal:theValue(1)];
        });
    });
    
    context(@"When observe a notification by selector and block", ^{
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
        
        it(@"should received", ^{
            [[expectFutureValue(@(tester.count)) shouldEventually] equal:theValue(1)];
            [[expectFutureValue(@(count)) shouldEventually] equal:theValue(1)];
        });
    });
    
    context(@"When observe 2 notifications by selector and block", ^{
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
        
        it(@"should received", ^{
            [[expectFutureValue(@(tester.count)) shouldEventually] equal:theValue(2)];
            [[expectFutureValue(@(count)) shouldEventually] equal:theValue(2)];
        });
    });
    
    context(@"When observe and remove observer", ^{
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
    
    context(@"When observe a nil notification by block", ^{
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
        
        it(@"should received all the notifications", ^{
            [[expectFutureValue(@(count)) shouldEventually] equal:theValue(2)];
        });
    });
    
});

SPEC_END
