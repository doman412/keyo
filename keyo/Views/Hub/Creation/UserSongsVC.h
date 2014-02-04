//
//  UserSongsVC.h
//  keyo
//
//  Created by User on 1/10/14.
//  Copyright (c) 2014 MakoWare. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import "SongCellObject.h"
#import "SongCell.h"

@interface UserSongsVC : UITableViewController<UINavigationControllerDelegate>

@property (strong, nonatomic) NSMutableArray *data;
@property (strong, nonatomic) PFQuery *songQuery;

@property (strong, nonatomic) NSMutableArray *songsList;
@property (strong, nonatomic) AVPlayer *audioPlayer;

-(void)loadSongs;

-(void)reloadData:(NSNotification*)noti;

@end
