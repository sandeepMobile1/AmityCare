//
//  DeletePostInvocation.h
//  Amity-Care
//
//  Created by Shweta Sharma on 25/03/15.
//
//

#import <Foundation/Foundation.h>
#import "SAServiceAsyncInvocation.h"

@class DeletePostInvocation;

@protocol DeletePostInvocationDelegate

-(void)DeletePostInvocationDidFinish:(DeletePostInvocation*)invocation  withResults:(NSDictionary*)dict withError:(NSError*)error;

@end
@interface DeletePostInvocation : SAServiceAsyncInvocation{
    
}

@property(nonatomic,strong)NSDictionary* dict;

@end
