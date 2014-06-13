//
//  Song.m
//  Juke
//
//  Created by User on 5/5/14.
//  Copyright (c) 2014 MakoWare. All rights reserved.
//

#import "Song.h"
#import <Parse/PFObject+Subclass.h>

@implementation Song

@dynamic artist, description, owner, pId, thumbnail, title, type;

+ (NSString*)parseClassName {
    return @"Song";
}

- (void)setPId:(NSString *)pId
{
    [self setObject:pId forKey:@"pId"];
}

@end
