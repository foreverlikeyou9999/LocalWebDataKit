//
//  LWDKManifestFile.m
//  LocalWebDataKit
//
//  Created by Donald Hays on 8/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "LWDKManifestFile.h"

@implementation LWDKManifestFile

@synthesize fileName;
@synthesize modificationDate;

+ (LWDKManifestFile *)manifestFileWithFileName:(NSString *)theFileName modificationDate:(NSDate *)theModificationDate
{
    return [[[LWDKManifestFile alloc] initWithFileName:theFileName modificationDate:theModificationDate] autorelease];
}

- (id)initWithFileName:(NSString *)theFileName modificationDate:(NSDate *)theModificationDate
{
    self = [super init];
    if(self) {
        fileName = [theFileName copy];
        modificationDate = [theModificationDate copy];
    }
    
    return self;
}

- (void)dealloc
{
    [fileName release];
    [modificationDate release];
    
    [super dealloc];
}

@end
