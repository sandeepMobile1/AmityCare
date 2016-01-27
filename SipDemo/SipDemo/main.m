//
//  main.m
//  SipDemo
//
//  Created by Shweta Sharma on 09/06/15.
//  Copyright (c) 2015 Shweta Sharma. All rights reserved.
//

/*#import <UIKit/UIKit.h>
#import "AppDelegate.h"

int main(int argc, char * argv[]) {
    @autoreleasepool {

        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
   
    }
}
*/

#import <UIKit/UIKit.h>

int main(int argc, char **argv)
{
    int returnCode = 0;
        
    returnCode = UIApplicationMain( argc, argv, @"AppDelegate", @"AppDelegate" );
    
    return returnCode;
}