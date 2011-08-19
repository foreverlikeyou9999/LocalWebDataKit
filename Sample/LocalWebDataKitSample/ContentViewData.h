//
//  ContentViewData.h
//  LocalWebDataKitSample
//
//  Created by Donald Hays on 8/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ContentViewData : NSObject
{
    UIImage *image;
    NSString *text;
}

@property (nonatomic, readonly) UIImage *image;
@property (nonatomic, readonly) NSString *text;
@end
