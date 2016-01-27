//
//  CreateFolderInvocation.h
//  Amity-Care
//
//  Created by Shweta Sharma on 14/05/15.
//
//

#import <Foundation/Foundation.h>
#import "SAServiceAsyncInvocation.h"

@class CreateFolderInvocation;

@protocol CreateFolderInvocationDelegate

-(void)CreateFolderInvocationDidFinish:(CreateFolderInvocation*)invocation  withResults:(NSDictionary*)dict withError:(NSError*)error;

@end
@interface CreateFolderInvocation : SAServiceAsyncInvocation{
    
}

@property(nonatomic,strong)NSDictionary* dict;



@end
