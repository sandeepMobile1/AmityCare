//
//  AllBackPackFileListInvocation.h
//  Amity-Care
//
//  Created by Shweta Sharma on 28/04/15.
//
//

#import <Foundation/Foundation.h>
#import "SAServiceAsyncInvocation.h"

@class AllBackPackFileListInvocation;

@protocol AllBackPackFileListInvocationDelegate

-(void)AllBackPackFileListInvocationDidFinish:(AllBackPackFileListInvocation*)invocation  withResults:(NSDictionary*)dict withError:(NSError*)error;

@end

@interface AllBackPackFileListInvocation : SAServiceAsyncInvocation{
    
}

@property(nonatomic,strong)NSDictionary* dict;


@end
