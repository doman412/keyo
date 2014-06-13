//
//  Hub.h
//  Juke
//
//  Created by User on 4/30/14.
//  Copyright (c) 2014 MakoWare. All rights reserved.
//

#import <Parse/Parse.h>

@interface Hub : PFObject<PFSubclassing>

@property (retain) NSDictionary *capabilities;
@property (retain) PFGeoPoint *location;
@property (retain) PFUser *owner;
@property (retain) NSString *passcode;
@property (retain) NSString *permission;
@property (retain) NSString *range;
@property (retain) NSString *title;
@property (retain) NSString *type;
@property (retain) NSMutableArray *allowedUsers;
@property (retain) NSMutableArray *blockedUsers;


- (BOOL)hasPasscode;
- (BOOL)userIsAllowed:(PFUser*)user;
- (BOOL)currentUserIsAllowed;

@end
