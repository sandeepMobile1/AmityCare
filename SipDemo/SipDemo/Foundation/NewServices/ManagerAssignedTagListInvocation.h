//
//  ManagerAssignedTagListInvocation.h
//  Amity-Care
//
//  Created by Shweta Sharma on 24/03/15.
//
//

#import <Foundation/Foundation.h>
#import "SAServiceAsyncInvocation.h"

@class ManagerAssignedTagListInvocation;

@protocol ManagerAssignedTagListInvocationDelegate

-(void)ManagerAssignedTagListInvocationDidFinish:(ManagerAssignedTagListInvocation*)invocation  withResults:(NSDictionary*)dict withError:(NSError*)error;

@end
@interface ManagerAssignedTagListInvocation : SAServiceAsyncInvocation{
    
}

@property(nonatomic,strong)NSDictionary* dict;

@end
