//
//  EditTaskInvocation
//  Amity-Care
//
//  Created by Vijay kumar on 03/11/14.
//  Copyright (c) 2013 com.octalinfosolutions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SAServiceAsyncInvocation.h"

@class EditTaskInvocation;

@protocol EditTaskInvocationDelegate

-(void)editTaskInvocationDidFinish:(EditTaskInvocation*)invocation  withResults:(NSDictionary*)dict withError:(NSError*)error;

@end


@interface EditTaskInvocation : SAServiceAsyncInvocation{
    
}

@property(nonatomic, strong) NSMutableDictionary *taskDict;

@end
