//
//  DeleteBackpackPicInvocation.h
//  Amity-Care
//
//  Created by Shweta Sharma on 29/04/15.
//
//

#import <Foundation/Foundation.h>
#import "SAServiceAsyncInvocation.h"

@class DeleteBackpackPicInvocation;

@protocol DeleteBackpackPicInvocationDelegate

-(void)DeleteBackpackPicInvocationDidFinish:(DeleteBackpackPicInvocation*)invocation  withResults:(NSDictionary*)dict withError:(NSError*)error;

@end

@interface DeleteBackpackPicInvocation : SAServiceAsyncInvocation{
    
}

@property(nonatomic,strong)NSDictionary* dict;


@end
