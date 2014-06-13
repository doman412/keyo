//
//  Song.h
//  Juke
//
//  Created by User on 5/5/14.
//  Copyright (c) 2014 MakoWare. All rights reserved.
//

#import <Parse/Parse.h>

@interface Song : PFObject<PFSubclassing>

@property (retain) NSString *artist;
@property (retain) NSString *description;
@property (retain) PFUser *owner;
@property (retain) NSString *pId;
@property (retain) NSString *thumbnail;
@property (retain) NSString *title;
@property (retain) NSString *type;

@end
