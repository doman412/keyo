//
//  Hub.m
//  Juke
//
//  Created by User on 4/30/14.
//  Copyright (c) 2014 MakoWare. All rights reserved.
//

#import "Hub.h"
#import <Parse/PFObject+Subclass.h>

@implementation Hub

@dynamic capabilities, location, owner, passcode, permission, range, title, type, allowedUsers, blockedUsers;

//- (id)init
//{
//    self = [super init];
//    if(self){
//        NSLog(@"hub init");
//        self.accessUsers = [[NSMutableArray alloc] init];
//        self.blockedUsers = [[NSMutableArray alloc] init];
//    }
//    return self;
//}

+ (NSString*)parseClassName {
    return @"Hub";
}

-(BOOL)hasPasscode
{
    return self.passcode && ![self.passcode isEqualToString:@""];
}

- (BOOL)userIsAllowed:(PFUser*)user
{
//    NSLog(@"allowed users: %@", self.allowedUsers);
    return [self.allowedUsers filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"objectId = %@", user.objectId]].count > 0;
}

- (BOOL)currentUserIsAllowed
{
    return [self userIsAllowed:[PFUser currentUser]];
}

@end
