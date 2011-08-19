//
//  LocalWebDataKitSampleAppDelegate.h
//  LocalWebDataKitSample
//
//  Created by Donald Hays on 8/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContentViewController.h"

@interface AppDelegate : NSObject <UIApplicationDelegate>
{
    ContentViewController *contentViewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@end
