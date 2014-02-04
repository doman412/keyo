//
//  SongCellObject.h
//  keyo
//
//  Created by User on 1/17/14.
//  Copyright (c) 2014 MakoWare. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface SongCellObject : NSObject

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *artist;
@property (strong, nonatomic) PFObject *song;


@end
