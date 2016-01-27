//
//  EmailPermissionInvocation.h
//  Amity-Care
//
//  Created by Shweta Sharma on 09/03/15.
//
//

#import <Foundation/Foundation.h>
#import "SAServiceAsyncInvocation.h"

@class EmailPermissionInvocation;

@protocol EmailPermissionInvocationDelegate

-(void)EmailPermissionInvocationDidFinish:(EmailPermissionInvocation*)invocation  withResults:(NSDictionary*)dict withError:(NSError*)error;

@end
@interface EmailPermissionInvocation :SAServiceAsyncInvocation{
    
}

@property(nonatomic,strong)NSDictionary* dict;


@end
