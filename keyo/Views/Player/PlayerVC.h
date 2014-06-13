//
//  PlayerVC.h
//  keyo
//
//  Created by User on 1/26/14.
//  Copyright (c) 2014 MakoWare. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>


@class Reachability, Hub, Song, QueuedSong;



@interface PlayerVC : UIViewController<UIAlertViewDelegate,MPMediaPickerControllerDelegate,UITableViewDataSource,UITableViewDelegate>


extern const NSInteger Native;
extern const NSInteger YouTube;
extern const NSInteger Spotify;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *trashButton;
@property (strong, nonatomic) UIAlertView *trashConfirm;
@property (strong, nonatomic) Hub *hub;
@property (strong, nonatomic) MPMusicPlayerController *player;
@property (strong, nonatomic) AVPlayer *ytPlayer;
//@property (strong, nonatomic) PFQuery *queue;
@property (strong, nonatomic) NSTimer *barTimer;
@property (strong, nonatomic) QueuedSong *nowPlayingObject;
@property (assign, nonatomic) NSInteger playerType;

@property (strong, nonatomic) NSMutableArray *data;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

// player control properties
@property (strong, nonatomic) IBOutlet UIView *nowPlayingView;
@property (strong, nonatomic) IBOutlet UILabel *songTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *artistTitleLabel;
@property (strong, nonatomic) IBOutlet UIButton *playPauseButton;
@property (strong, nonatomic) IBOutlet UILabel *userLabel;
@property (strong, nonatomic) IBOutlet UIButton *skipButton;
@property (strong, nonatomic) IBOutlet UIProgressView *progressBar;
// dummy view for the movie player
@property (strong, nonatomic) IBOutlet UIView *ytView;

@property (strong, nonatomic) Reachability *reach;


- (void)loadSongsAndNext:(BOOL)next;



- (IBAction)onTrashHub:(id)sender;
- (IBAction)onAddSongs:(id)sender;
- (IBAction)onRefresh:(id)sender;

- (IBAction)onSkip:(id)sender;
- (IBAction)onPlayToggle:(id)sender;

- (void)onYoutubePlaybackStateChanged:(NSNotification*)noti;
- (void)onPlaybackStateChanged:(NSNotification*)noti;
- (void)onNowPlayingItemChanged:(NSNotification*)noti;

- (void)onTimer:(NSTimer*)timer;

- (void)setNowPlaying;

@end
