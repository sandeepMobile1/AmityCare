//
//  DeleteEmailListInvocation.h
//  Amity-Care
//
//  Created by Shweta Sharma on 25/03/15.
//
//

#import <Foundation/Foundation.h>
#import "SAServiceAsyncInvocation.h"

@class DeleteEmailListInvocation;

@protocol DeleteEmailListInvocationDelegate

-(void)DeleteEmailListInvocationDidFinish:(DeleteEmailListInvocation*)invocation  withResults:(NSDictionary*)dict withError:(NSError*)error;

@end
@interface DeleteEmailListInvocation : SAServiceAsyncInvocation{
    
}

@property(nonatomic,strong)NSDictionary* dict;



@end
