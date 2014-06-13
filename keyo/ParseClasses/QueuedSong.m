//
//  QueuedSong.m
//  Juke
//
//  Created by User on 5/5/14.
//  Copyright (c) 2014 MakoWare. All rights reserved.
//

#import "QueuedSong.h"
#import <Parse/PFObject+Subclass.h>

@implementation QueuedSong

@dynamic active, addedBy, downs, ups, hub, position, score, song;

+ (NSString*)parseClassName {
    return @"QueuedSong";
}
@end
