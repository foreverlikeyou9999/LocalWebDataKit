//
//  LWDKLocalWebDataSyncManager.h
//  LocalWebDataKit
//
//  Created by Donald Hays on 8/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

@interface LWDKLocalWebDataSyncManager : NSObject
+ (LWDKLocalWebDataSyncManager *)sharedLocalWebDataSyncManager;

- (void)beginSyncingWithSeedDataPath:(NSString *)theSeedDataPath
                      storedDataPath:(NSString *)theStoredDataPath
                   remoteManifestURL:(NSURL *)theRemoteManifestURL
                     refreshInterval:(NSTimeInterval)theRefreshInterval;

- (void)stopSyncing;
@end
