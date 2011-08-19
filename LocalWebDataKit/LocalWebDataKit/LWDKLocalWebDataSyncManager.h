//
//  LWDKLocalWebDataSyncManager.h
//  LocalWebDataKit
//
//  Created by Donald Hays on 8/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LWDKSyncSession.h"

@interface LWDKLocalWebDataSyncManager : NSObject
{
    NSString *seedDataPath;
    NSString *storedDataPath;
    NSURL *remoteManifestURL;
    NSTimeInterval refreshInterval;
    
    LWDKSyncSession *syncSession;
    
    NSTimer *refreshTimer;
}

+ (LWDKLocalWebDataSyncManager *)sharedLocalWebDataSyncManager;

- (void)beginSyncingWithSeedDataPath:(NSString *)theSeedDataPath
                      storedDataPath:(NSString *)theStoredDataPath
                   remoteManifestURL:(NSURL *)theRemoteManifestURL
                     refreshInterval:(NSTimeInterval)theRefreshInterval;

- (void)stopSyncing;
@end
