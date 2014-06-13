//
//  PFFactory.m
//  Juke
//
//  Created by Derek Arner on 6/1/14.
//  Copyright (c) 2014 MakoWare. All rights reserved.
//

#import "PFFactory.h"
#import "Hub.h"
#import "Song.h"
#import "QueuedSong.h"

@implementation PFFactory

+(Hub *)Hub
{
    Hub *hub = [Hub object];
    hub.type = @"ios";
    hub.allowedUsers = [[NSMutableArray alloc] init];
    hub.blockedUsers = [[NSMutableArray alloc] init];
    
    return hub;
}

+(Song *)Song
{
    Song *song = [Song object];
    
    
    return song;
}

+(QueuedSong *)QueuedSong
{
    QueuedSong *qs = [QueuedSong object];
    
    
    return qs;
}

@end
