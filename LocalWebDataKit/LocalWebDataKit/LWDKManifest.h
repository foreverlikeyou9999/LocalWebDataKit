//
//  LWDKManifest.h
//  LocalWebDataKit
//
//  Created by Donald Hays on 8/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LWDKManifestFile.h"

@interface LWDKManifest : NSObject
{
    NSArray *files;
}

@property (nonatomic, readonly) NSArray *files;

+ (LWDKManifest *)manifestWithPListData:(NSData *)data;
- (id)initWithPListData:(NSData *)data;

- (NSArray *)filesAddedSinceManifest:(LWDKManifest *)manifest;
- (NSArray *)filesModifiedSinceManifest:(LWDKManifest *)manifest;
- (NSArray *)filesRemovedSinceManifest:(LWDKManifest *)manifest;
@end
