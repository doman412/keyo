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

@interface HubSettingsVC : UITableViewController<UINavigationControllerDelegate,MPMediaPickerControllerDelegate,UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITextField *hubNameField;
@property (strong, nonatomic) IBOutlet UISwitch *publicSwitch;
@property (strong, nonatomic) IBOutlet UITextField *passcodeField;
@property (strong, nonatomic) IBOutlet UITextField *visibilityField;
@property (strong, nonatomic) IBOutlet UITextField *submissionRateField;
@property (strong, nonatomic) IBOutlet UITextField *reputationField;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *saveButton;

@property (strong, nonatomic) NSMutableArray *selectedSongs;
@property (strong, nonatomic) PFObject *hub;

- (IBAction)onPublicSwitchChanged:(id)sender;
- (IBAction)onSave:(id)sender;

@end
