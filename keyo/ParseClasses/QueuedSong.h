//
//  QueuedSong.h
//  Juke
//
//  Created by User on 5/5/14.
//  Copyright (c) 2014 MakoWare. All rights reserved.
//

#import <Parse/Parse.h>

@class Hub, Song;

@interface QueuedSong : PFObject<PFSubclassing>


@property BOOL active;
@property (retain) PFUser *addedBy;
@property (retain) NSArray *downs;
@property (retain) NSArray *ups;
@property (retain) Hub *hub;
@property (retain) NSNumber *position;
@property (retain) NSNumber *score;
@property (retain) Song *song;


@end
