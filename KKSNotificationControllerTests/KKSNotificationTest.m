//
//  MUPNotificationTest.m
//  DemoOC
//
//  Created by kukushi on 11/11/14.
//  Copyright (c) 2014 kukushi. All rights reserved.
//

#import "KKSNotificationTest.h"

@implementation KKSNotificationTest

- (void)plusOne {
    self.count += 1;
}

- (void)plusTwo:(NSNotification *)notification {
    self.count = -20359;
}


@end
