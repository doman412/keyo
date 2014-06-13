//
//  PFFactory.h
//  Juke
//
//  Created by Derek Arner on 6/1/14.
//  Copyright (c) 2014 MakoWare. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Hub, Song, QueuedSong;

@interface PFFactory : NSObject

+(Hub*)Hub;
+(Song*)Song;
+(QueuedSong*)QueuedSong;

@end
