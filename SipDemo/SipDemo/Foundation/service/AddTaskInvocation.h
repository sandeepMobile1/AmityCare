//
//  AddTaskInvocation
//  Amity-Care
//
//  Created by Vijay kumar on 02/05/14.
//  Copyright (c) 2013 com.octalinfosolutions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SAServiceAsyncInvocation.h"

@class AddTaskInvocation;

@protocol AddTaskInvocationDelegate

-(void)addTaskInvocationDidFinish:(AddTaskInvocation*)invocation  withResults:(NSDictionary*)dict withError:(NSError*)error;

@end


@interface AddTaskInvocation : SAServiceAsyncInvocation{
    
}

@property(nonatomic, strong) NSMutableDictionary *taskDict;

@end
