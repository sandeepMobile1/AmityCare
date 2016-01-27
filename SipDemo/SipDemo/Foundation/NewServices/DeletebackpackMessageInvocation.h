//
//  DeletebackpackMessageInvocation.h
//  Amity-Care
//
//  Created by Shweta Sharma on 29/04/15.
//
//

#import <Foundation/Foundation.h>
#import "SAServiceAsyncInvocation.h"

@class DeletebackpackMessageInvocation;

@protocol DeletebackpackMessageInvocationDelegate

-(void)DeletebackpackMessageInvocationDidFinish:(DeletebackpackMessageInvocation*)invocation  withResults:(NSDictionary*)dict withError:(NSError*)error;

@end
@interface DeletebackpackMessageInvocation : SAServiceAsyncInvocation{
    
}

@property(nonatomic,strong)NSDictionary* dict;

@end
