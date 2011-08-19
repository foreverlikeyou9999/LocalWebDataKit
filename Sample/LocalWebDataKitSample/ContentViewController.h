//
//  ContentViewController.h
//  LocalWebDataKitSample
//
//  Created by Donald Hays on 8/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ContentViewData.h"

@interface ContentViewController : UIViewController
{
    ContentViewData *data;
    
    UIImageView *imageView;
    UILabel *label;
}

@property (nonatomic, retain) IBOutlet UIImageView *imageView;
@property (nonatomic, retain) IBOutlet UILabel *label;
@end
