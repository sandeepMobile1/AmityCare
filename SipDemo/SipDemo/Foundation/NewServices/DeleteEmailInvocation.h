//
//  DeleteEmailInvocation.h
//  Amity-Care
//
//  Created by Shweta Sharma on 25/03/15.
//
//

#import <Foundation/Foundation.h>
#import "SAServiceAsyncInvocation.h"

@class DeleteEmailInvocation;

@protocol DeleteEmailInvocationDelegate

-(void)DeleteEmailInvocationDidFinish:(DeleteEmailInvocation*)invocation withResults:(NSDictionary*)dict withError:(NSError*)error;

@end

@interface DeleteEmailInvocation : SAServiceAsyncInvocation{
    
}

@property(nonatomic,strong)NSDictionary* dict;

@end
