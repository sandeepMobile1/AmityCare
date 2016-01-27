//
//  DeleteTaskInvocation
//  Amity-Care
//
//  Created by Vijay kumar on 03/11/14.
//  Copyright (c) 2013 com.octalinfosolutions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SAServiceAsyncInvocation.h"

@class DeleteTaskInvocation;

@protocol DeleteTaskInvocationDelegate

-(void)deleteTaskInvocationDidFinish:(DeleteTaskInvocation*)invocation  withResults:(NSDictionary*)dict withError:(NSError*)error;

@end


@interface DeleteTaskInvocation : SAServiceAsyncInvocation{
    
}

@property(nonatomic, strong) NSString *user_id;
@property(nonatomic, strong) NSString *task_id;
@end
