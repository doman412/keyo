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

@interface PlayerVC : UIViewController<UIAlertViewDelegate,MPMediaPickerControllerDelegate,UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UIBarButtonItem *trashButton;
@property (strong, nonatomic) UIAlertView *trashConfirm;
@property (strong, nonatomic) PFObject *hub;


@property (strong, nonatomic) NSArray *data;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

// player control properties
@property (strong, nonatomic) IBOutlet UILabel *songTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *artistTitleLabel;
@property (strong, nonatomic) IBOutlet UIButton *playPauseButton;
@property (strong, nonatomic) IBOutlet UIButton *skipButton;
@property (strong, nonatomic) IBOutlet UIProgressView *progressBar;


- (void)loadSongs;



- (IBAction)onTrashHub:(id)sender;
- (IBAction)onAddSongs:(id)sender;

- (IBAction)onSkip:(id)sender;
- (IBAction)onPlayToggle:(id)sender;


@end
