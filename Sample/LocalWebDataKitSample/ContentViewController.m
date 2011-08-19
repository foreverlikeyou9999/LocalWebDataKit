//
//  ContentViewController.m
//  LocalWebDataKitSample
//
//  Created by Donald Hays on 8/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ContentViewController.h"

@interface ContentViewController (Private)
- (void)reloadImage;
- (void)reloadText;

- (void)reloadData;
@end

@implementation ContentViewController

@synthesize imageView;
@synthesize label;

- (id)init
{
    self = [super initWithNibName:@"ContentViewController" bundle:nil];
    if(self) {
        data = [[ContentViewData alloc] init];
        
        [data addObserver:self forKeyPath:@"image" options:0 context:0];
        [data addObserver:self forKeyPath:@"text" options:0 context:0];
    }
    
    return self;
}

- (void)dealloc
{
    [data removeObserver:self forKeyPath:@"image"];
    [data removeObserver:self forKeyPath:@"text"];
    
    [data release];
    self.imageView = nil;
    self.label = nil;
    
    [super dealloc];
}

- (void)viewDidLoad
{
    [self reloadData];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if([keyPath isEqualToString:@"image"]) {
        [self reloadImage];
    } else if([keyPath isEqualToString:@"text"]) {
        [self reloadText];
    }
}

#pragma mark -
#pragma mark Private
- (void)reloadImage
{
    imageView.image = data.image;
}

- (void)reloadText
{
    label.text = data.text;
}

- (void)reloadData
{
    [self reloadImage];
    [self reloadText];
}

@end
