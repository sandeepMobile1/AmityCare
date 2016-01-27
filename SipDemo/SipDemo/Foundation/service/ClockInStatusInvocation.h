//
//  ClockInStatusInvocation.h
//  Amity-Care
//
//  Created by Shweta Sharma on 13/08/14.
//
//

#import <Foundation/Foundation.h>
#import "SAServiceAsyncInvocation.h"

@class ClockInStatusInvocation;

@protocol ClockInStatusInvocationDelegate

-(void)ClockInStatusInvocationDidFinish:(ClockInStatusInvocation*)invocation  withResults:(NSDictionary*)dict withError:(NSError*)error;

@end


@interface ClockInStatusInvocation : SAServiceAsyncInvocation{
    
}

@property(nonatomic, strong) NSString *userId;
@property(nonatomic, strong) NSString *tagId;
@property(nonatomic, strong) NSString *startDate;
@property(nonatomic, strong) NSString *endDate;
@property(nonatomic, strong) NSString *index;

@end
