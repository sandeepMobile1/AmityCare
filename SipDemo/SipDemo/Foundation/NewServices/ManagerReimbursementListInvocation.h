//
//  ManagerReimbursementListInvocation.h
//  Amity-Care
//
//  Created by Shweta Sharma on 24/03/15.
//
//

#import <Foundation/Foundation.h>
#import "SAServiceAsyncInvocation.h"

@class ManagerReimbursementListInvocation;

@protocol ManagerReimbursementListInvocationDelegate

-(void)ManagerReimbursementListInvocationDidFinish:(ManagerReimbursementListInvocation*)invocation  withResults:(NSDictionary*)dict withError:(NSError*)error;

@end
@interface ManagerReimbursementListInvocation : SAServiceAsyncInvocation{
    
}

@property(nonatomic,strong)NSDictionary* dict;


@end
