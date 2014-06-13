//
//  HubView.h
//  keyo
//
//  Created by Derek Arner on 12/27/13.
//  Copyright (c) 2013 MakoWare. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@class Hub, Song, QueuedSong;

@interface HubView : UITableViewController

@property (strong,nonatomic) NSMutableArray *data;
@property (strong,nonatomic) Hub *hub;
@property (strong,nonatomic) PFQuery *songQuery;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UIButton *infoButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *fixedSpace;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *addButton;
@property (strong, nonatomic) UIBarButtonItem *infoBarButton;



-(void)loadSongs;
-(void)onSongsLoaded:(NSArray*)objects error:(NSError*)err;

- (IBAction)onInfo:(UIButton *)sender;
@end
