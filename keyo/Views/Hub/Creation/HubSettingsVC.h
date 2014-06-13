//
//  HubSettingsVC.h
//  keyo
//
//  Created by User on 1/10/14.
//  Copyright (c) 2014 MakoWare. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import <Parse/Parse.h>

@class Hub, Song, QueuedSong;

@interface HubSettingsVC : UITableViewController<UINavigationControllerDelegate,MPMediaPickerControllerDelegate,UITextFieldDelegate>

@property (strong, nonatomic) NSMutableArray *data;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *saveButton;

@property (strong, nonatomic) NSMutableArray *selectedSongs;
@property (strong, nonatomic) Hub *hub;

- (IBAction)onPublicSwitchChanged:(id)sender;
- (IBAction)onSave:(id)sender;
// hub name change
- (IBAction)hubNameFieldDidEndEditing:(UITextField*)sender;
// passcode change
- (IBAction)passcodeFieldDidEndEditing:(UITextField*)sender;

// music sources
// local music
- (IBAction)localMusicToggle:(UISwitch *)sender;


@end
