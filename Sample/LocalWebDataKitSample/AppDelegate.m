//
//  LocalWebDataKitSampleAppDelegate.m
//  LocalWebDataKitSample
//
//  Created by Donald Hays on 8/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import "LocalWebDataKit.h"

@implementation AppDelegate

@synthesize window = _window;

- (NSString *)storedContentPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
    return [paths objectAtIndex:0];
}

- (NSString *)resourceContentPath
{
    NSString *resourcePath = [[NSBundle mainBundle] resourcePath];
    NSString *contentPath = [resourcePath stringByAppendingPathComponent:@"Content"];
    return contentPath;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[LWDKLocalWebDataSyncManager sharedLocalWebDataSyncManager] beginSyncingWithSeedDataPath:[self resourceContentPath]
                                                                               storedDataPath:[self storedContentPath]
                                                                            remoteManifestURL:nil
                                                                              refreshInterval:60 * 60];
    
    contentViewController = [[ContentViewController alloc] init];
    
    [self.window addSubview:contentViewController.view];
    
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{

}

- (void)applicationDidEnterBackground:(UIApplication *)application
{

}

- (void)applicationWillEnterForeground:(UIApplication *)application
{

}

- (void)applicationDidBecomeActive:(UIApplication *)application
{

}

- (void)applicationWillTerminate:(UIApplication *)application
{

}

- (void)dealloc
{
    [_window release];
    [super dealloc];
}

@end
