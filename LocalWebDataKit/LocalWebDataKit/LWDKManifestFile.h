//
//  LWDKManifestFile.h
//  LocalWebDataKit
//
//  Created by Donald Hays on 8/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LWDKManifestFile : NSObject
{
    NSString *fileName;
    NSDate *modificationDate;
}

@property (nonatomic, readonly) NSString *fileName;
@property (nonatomic, readonly) NSDate *modificationDate;

+ (LWDKManifestFile *)manifestFileWithFileName:(NSString *)theFileName modificationDate:(NSDate *)theModificationDate;
- (id)initWithFileName:(NSString *)theFileName modificationDate:(NSDate *)theModificationDate;
@end
