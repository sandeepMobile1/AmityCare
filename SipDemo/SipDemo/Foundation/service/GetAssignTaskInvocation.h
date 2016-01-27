//
//  GetTaskListInvocation
//  Amity-Care
//
//  Created by Vijay kumar on 02/05/14.
//  Copyright (c) 2013 com.octalinfosolutions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SAServiceAsyncInvocation.h"

@class GetAssignTaskInvocation;

@protocol GetAssignTaskInvocationDelegate

-(void)getAssignTaskInvocationDidFinish:(GetAssignTaskInvocation*)invocation  withResults:(NSDictionary*)dict withError:(NSError*)error;

@end


@interface GetAssignTaskInvocation : SAServiceAsyncInvocation{
    
}
@property (nonatomic,strong) NSString *user_id;
@property (nonatomic,strong) NSString *role; //emp / manager (2/3)
@end
