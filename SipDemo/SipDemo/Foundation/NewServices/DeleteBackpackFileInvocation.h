//
//  DeleteBackpackFileInvocation.h
//  Amity-Care
//
//  Created by Shweta Sharma on 29/04/15.
//
//

#import <Foundation/Foundation.h>
#import "SAServiceAsyncInvocation.h"

@class DeleteBackpackFileInvocation;

@protocol DeleteBackpackFileInvocationDelegate

-(void)DeleteBackpackFileInvocationDidFinish:(DeleteBackpackFileInvocation*)invocation  withResults:(NSDictionary*)dict withError:(NSError*)error;

@end

@interface DeleteBackpackFileInvocation : SAServiceAsyncInvocation{
    
}

@property(nonatomic,strong)NSDictionary* dict;


@end
