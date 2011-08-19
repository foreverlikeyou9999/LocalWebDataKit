//
//  LWDKSyncSession.h
//  LocalWebDataKit
//
//  Created by Donald Hays on 8/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LWDKSyncSession : NSObject
{
    NSString *dataPath;
    NSURL *remoteManifestURL;
    id delegate;
}

+ (LWDKSyncSession *)syncSessionWithDataPath:(NSString *)theDataPath
                           remoteManifestURL:(NSURL *)theRemoteManifestURL
                                    delegate:(id)theDelegate;
- (id)initWithDataPath:(NSString *)theDataPath
     remoteManifestURL:(NSURL *)theRemoteManifestURL
              delegate:(id)theDelegate;

- (void)cancelSyncSession;
@end
