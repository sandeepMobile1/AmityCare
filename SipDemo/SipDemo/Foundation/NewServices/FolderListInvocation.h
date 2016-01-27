//
//  FolderListInvocation.h
//  Amity-Care
//
//  Created by Shweta Sharma on 14/05/15.
//
//

#import <Foundation/Foundation.h>
#import "SAServiceAsyncInvocation.h"

@class FolderListInvocation;

@protocol FolderListInvocationDelegate

-(void)FolderListInvocationDidFinish:(FolderListInvocation*)invocation  withResults:(NSDictionary*)dict withError:(NSError*)error;

@end

@interface FolderListInvocation : SAServiceAsyncInvocation{
    
}

@property(nonatomic,strong)NSDictionary* dict;


@end
