//
//  SongListView.h
//  keyo
//
//  Created by Derek Arner on 12/29/13.
//  Copyright (c) 2013 MakoWare. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface SongListView : UITableViewController<UIAlertViewDelegate>

@property (strong,nonatomic) NSMutableArray *data;
@property (strong,nonatomic) PFQuery *query;
@property (strong,nonatomic) PFObject *hub;

-(void)loadSongs;

@end
