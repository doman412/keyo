//
//  HubView.h
//  keyo
//
//  Created by Derek Arner on 12/27/13.
//  Copyright (c) 2013 MakoWare. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface HubView : UITableViewController

@property (strong,nonatomic) NSMutableArray *data;
@property (strong,nonatomic) PFObject *hub;
@property (strong,nonatomic) PFQuery *songQuery;

-(void)loadSongs;
-(void)onSongsLoaded:(NSArray*)objects error:(NSError*)err;

@end
