//
//  LWDKLocalWebDataSyncManager.m
//  LocalWebDataKit
//
//  Created by Donald Hays on 8/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "LWDKLocalWebDataSyncManager.h"

@implementation LWDKLocalWebDataSyncManager

+ (LWDKLocalWebDataSyncManager *)sharedLocalWebDataSyncManager
{
    static LWDKLocalWebDataSyncManager *sharedLocalWebDataSyncManagerInstance = nil;
    
    if(!sharedLocalWebDataSyncManagerInstance) {
        sharedLocalWebDataSyncManagerInstance = [[LWDKLocalWebDataSyncManager alloc] init];
    }
    
    return sharedLocalWebDataSyncManagerInstance;
}

- (void)beginSyncingWithSeedDataPath:(NSString *)theSeedDataPath
                      storedDataPath:(NSString *)theStoredDataPath
                   remoteManifestURL:(NSURL *)theRemoteManifestURL
                     refreshInterval:(NSTimeInterval)theRefreshInterval
{
    
}

- (void)stopSyncing
{
    
}

@end
