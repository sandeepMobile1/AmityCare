//
//  AllTagsListInvocation.h
//  Amity-Care
//
//  Created by Shweta Sharma on 24/02/15.
//
//

#import <Foundation/Foundation.h>
#import "SAServiceAsyncInvocation.h"

@class AllTagsListInvocation;

@protocol AllTagsListInvocationDelegate

-(void)AllTagsListInvocationDidFinish:(AllTagsListInvocation*)invocation  withResults:(NSDictionary*)dict withError:(NSError*)error;

@end

@interface AllTagsListInvocation: SAServiceAsyncInvocation{
    
}

@property(nonatomic,strong)NSString* userId;

@end
