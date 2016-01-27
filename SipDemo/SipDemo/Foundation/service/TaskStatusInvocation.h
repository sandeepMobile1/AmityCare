//
//  GetTaskListInvocation
//  Amity-Care
//
//  Created by Vijay kumar on 02/05/14.
//  Copyright (c) 2013 com.octalinfosolutions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SAServiceAsyncInvocation.h"

@class TaskStatusInvocation;

@protocol TaskStatusInvocationDelegate

-(void)taskStatusInvocationDidFinish:(TaskStatusInvocation*)invocation  withResults:(NSDictionary*)dict withError:(NSError*)error;

@end


@interface TaskStatusInvocation : SAServiceAsyncInvocation{
    
}
@property (nonatomic,strong) NSString *user_id;
@property (nonatomic,strong) NSString *task_id;
@end
