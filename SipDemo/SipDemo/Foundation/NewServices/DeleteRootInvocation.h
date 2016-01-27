//
//  DeleteRootInvocation.h
//  Amity-Care
//
//  Created by Shweta Sharma on 21/04/15.
//
//

#import <Foundation/Foundation.h>
#import "SAServiceAsyncInvocation.h"

@class DeleteRootInvocation;

@protocol DeleteRootInvocationDelegate

-(void)DeleteRootInvocationDidFinish:(DeleteRootInvocation*)invocation  withResults:(NSDictionary*)dict withError:(NSError*)error;

@end

@interface DeleteRootInvocation : SAServiceAsyncInvocation{
    
}

@property(nonatomic,strong)NSDictionary* dict;


@end
