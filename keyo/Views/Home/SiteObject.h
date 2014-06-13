//
//  SiteObject.h
//  keyo
//
//  Created by Derek Arner on 12/26/13.
//  Copyright (c) 2013 MakoWare. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@class Hub;

@interface SiteObject : NSObject

@property (strong,nonatomic) NSString *title;
@property (strong,nonatomic) Hub *hub;

@end
