//
//  SongCell.h
//  keyo
//
//  Created by User on 1/17/14.
//  Copyright (c) 2014 MakoWare. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import <Parse/Parse.h>

@class SongCellObject;

@interface SongCell : UITableViewCell

@property (strong,nonatomic) SongCellObject *object;
@property (strong,nonatomic) MPMediaItem *song;


- (void)setSongObject:(SongCellObject*)obj;

- (void)choose;

@end
