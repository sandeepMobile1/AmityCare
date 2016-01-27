//
//  TagCalenderListInvocation.h
//  Amity-Care
//
//  Created by Shweta Sharma on 11/10/14.
//
//

#import <Foundation/Foundation.h>
#import "SAServiceAsyncInvocation.h"

@class TagCalenderListInvocation;

@protocol TagCalenderListInvocationDelegate

-(void)TagCalenderListInvocationDidFinish:(TagCalenderListInvocation*)invocation  withResults:(NSDictionary*)dict withError:(NSError*)error;

@end


@interface TagCalenderListInvocation : SAServiceAsyncInvocation{
    
}

@property(nonatomic,strong)NSString* userId;
@property(nonatomic,strong)NSString* tagId;

@end