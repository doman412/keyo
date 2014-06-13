//
//  HubSettingsVC.m
//  keyo
//
//  Created by User on 1/10/14.
//  Copyright (c) 2014 MakoWare. All rights reserved.
//

#import "HubSettingsVC.h"

#import "Theme.h"
#import "Hub.h"
#import "Song.h"
#import "QueuedSong.h"

#import "PFFactory.h"

#import "RootMediaPickerTBC.h"

@interface HubSettingsVC (){
    NSMutableDictionary *hubNameSection;
    NSMutableDictionary *publicToggleSection;
    NSMutableDictionary *passcodeCell;
    
    NSMutableDictionary *musicSourcesSection;
    NSMutableDictionary *localMusicCell;
    
    NSString *hubName;
    NSString *passcode;
    
    BOOL public;
    
    UITextField *activeField;
}

@property (strong, nonatomic) NSMutableDictionary *songs;

@end

@implementation HubSettingsVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.songs = [[NSMutableDictionary alloc] init];
    
    
    [self registerForKeyboardNotifications];
    
    self.parentViewController.navigationItem.rightBarButtonItem = self.saveButton;
//    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:self.saveButton, nil];
    
    public = YES;
    
    self.hub = [PFFactory Hub];
    
    self.view.backgroundColor = [Theme wellWhite];
    
    // create what the settings list looks like
    self.data = [[NSMutableArray alloc] init];
    // ugly way to create cell objects on the fly
    hubNameSection = [@{@"header": @"Hub Name",
                   @"cells": @[@{@"type": @"HubName"
                                 }
                               ]
                   } mutableCopy];
    
    publicToggleSection = [@{@"footer": @"Your hub will be publicly accessable.",
                        @"cells": [@[@{@"type": @"PublicToggle"
                                      }
                                    ] mutableCopy]
                        } mutableCopy];
    
    passcodeCell = [@{@"type": @"PasscodeCell"
                     } mutableCopy];
    
    localMusicCell = [@{@"type": @"LocalMusicCell"
                        } mutableCopy];
    
    musicSourcesSection = [@{@"header": @"Music Sources",
                             @"cells": [@[@{@"type": @"LocalToggleCell"
                                            },
                                          localMusicCell
                                          ] mutableCopy]
                             } mutableCopy];
    
    
    [self.data addObject:hubNameSection];
    [self.data addObject:publicToggleSection];
    [self.data addObject:musicSourcesSection];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setToolbarHidden:YES];
    NSIndexPath *selectedIndexPath = [self.tableView indexPathForSelectedRow];
    [self.tableView deselectRowAtIndexPath:selectedIndexPath animated:YES];
}

-(void)viewDidAppear:(BOOL)animated
{
    self.navigationController.delegate = self;
}

#pragma mark - keyboard methods

- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}

- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGRect kbFrame = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    kbFrame = [self.view convertRect:kbFrame fromView:self.view.window];
    CGSize kbSize = kbFrame.size;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    self.tableView.contentInset = contentInsets;
    self.tableView.scrollIndicatorInsets = contentInsets;
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your app might not need or want this behavior.
    CGRect aRect = self.view.frame;
    NSLog(@"view.frame: %@",NSStringFromCGRect(aRect));
    aRect.size.height -= kbSize.height;
    
    NSLog(@"rect: %@; size: %@",NSStringFromCGRect(aRect), NSStringFromCGSize(kbSize));
    
    if (!CGRectContainsPoint(aRect, activeField.frame.origin) ) {
        NSLog(@"scroll to visible");
        [self.tableView scrollRectToVisible:activeField.frame animated:YES];
    }
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.tableView.contentInset = contentInsets;
    self.tableView.scrollIndicatorInsets = contentInsets;
}

#pragma mark - tableview methods

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    id sec = [self.data objectAtIndex:section];
    
    return [sec objectForKey:@"header"];
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    id sec = [self.data objectAtIndex:section];
    
    
//    switch (section){
//        case 1:
//            if(self.publicSwitch.isOn){
//                return @"Your hub will be publicly accessable.";
//            } else {
//                return @"Your hub will require a passcode. (below)";
//            }
//        case 2:
//            return @"Use a passcode to restrict access to your hub.";
//        case 3:
//            return @"Pick the music others can choose from.";
//        case 4:
//            return @"Range of visibility of you're hub.";
//        case 5:
//            return @"Minimum Reputation of users that can submit songs.";
//        case 6:
//            return @"Rate at which users can submit songs.";
//        
//    }
    return [sec objectForKey:@"footer"];
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    UITableViewHeaderFooterView *hfView = (id)view;
    hfView.textLabel.textColor = [Theme fontBlack];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//    NSLog(@"number of sections: %lu",(unsigned long)self.data.count);
    return self.data.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    NSLog(@"number of rows--");
//    NSLog(@"number of rows-- : %@",[self.data objectAtIndex:section]);
//    NSLog(@"number of rows: %lu",(unsigned long)[[self.data objectAtIndex:section] count]);
    return [[[self.data objectAtIndex:section] objectForKey:@"cells"] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id section = [self.data objectAtIndex:indexPath.section];
    NSArray *cells = [section objectForKey:@"cells"];
    id cellObj = [cells objectAtIndex:indexPath.row];
    NSString *cellId = [cellObj objectForKey:@"type"];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    id section = [self.data objectAtIndex:indexPath.section];
    NSArray *cells = [section objectForKey:@"cells"];
    id cellObj = [cells objectAtIndex:indexPath.row];
    
    if(cellObj == localMusicCell){
        NSLog(@"tapped my music");
        RootMediaPickerTBC *vc = [[UIStoryboard storyboardWithName:@"MediaPickerSB" bundle:nil] instantiateInitialViewController];
        
        vc.songs = self.songs;
        
        [self presentViewController:vc animated:YES completion:nil];
        
    } else {
        NSLog(@"tapped any other cell");
    }
}

#pragma mark - other methods

- (IBAction)onPublicSwitchChanged:(UISwitch*)sender
{
    if(sender.isOn){
//        self.passcodeField.enabled = NO;
//        self.passcodeField.placeholder = @"(disabled)";
        [publicToggleSection setObject:@"Your hub will be publicly accessable." forKey:@"footer"];
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:[self.data indexOfObjectIdenticalTo:publicToggleSection]];
        NSMutableArray *cells = [publicToggleSection objectForKey:@"cells"];
        [cells removeObjectAtIndex:1];
        
        [CATransaction begin];
        [CATransaction setCompletionBlock:^{
            [self.tableView reloadData];
        }];
        
        [self.tableView beginUpdates];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView endUpdates];
        
        [CATransaction commit];
        
    } else {
//        self.passcodeField.enabled = YES;
//        self.passcodeField.placeholder = @"enter a passcode";
        [publicToggleSection setObject:@"Your hub will require a passcode." forKey:@"footer"];
        
        NSIndexPath *newPath = [NSIndexPath indexPathForRow:1 inSection:[self.data indexOfObjectIdenticalTo:publicToggleSection]];
        NSMutableArray *cells = [publicToggleSection objectForKey:@"cells"];
        [cells addObject:passcodeCell];
        
        [CATransaction begin];
        [CATransaction setCompletionBlock:^{
            [self.tableView reloadData];
        }];
        
        [self.tableView beginUpdates];
        [self.tableView insertRowsAtIndexPaths:@[newPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.tableView endUpdates];
        
        
        [CATransaction commit];
        
    }
    
    public = sender.isOn;
//    [self.tableView reloadData];
}

- (IBAction)onSave:(id)sender
{
    [self.view endEditing:YES];
    NSLog(@"save");
    
    
    self.hub.owner = [PFUser currentUser];
    if(hubName && ![hubName isEqualToString:@""]){
        self.hub.title = hubName;
    } else {
        [[[UIAlertView alloc] initWithTitle:@"Hub Name Needed" message:@"The name of your hub is blank! Please enter a hub name." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
        return;
    }
    
    if(!public){
        if(passcode && ![passcode isEqualToString:@""]){
            self.hub.passcode = passcode;
        } else {
            [[[UIAlertView alloc] initWithTitle:@"Passcode Needed" message:@"The passcode has been enabled but the field was left blank! Please enter a passcode." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
            return;
        }
    } else {
        self.hub.passcode = @"";
    }
    
    [self.hub.allowedUsers addObject:[PFUser currentUser]];
//    self.hub[@"minRep"] = [NSNumber numberWithInteger: [self.reputationField.text integerValue]];
//    self.hub[@"range"] = [NSNumber numberWithInteger: [self.visibilityField.text integerValue]];
//    self.hub[@"submissions"] = [NSNumber numberWithInteger: [self.submissionRateField.text integerValue]];
    
    /*
    [PFGeoPoint geoPointForCurrentLocationInBackground:^(PFGeoPoint *geoPoint, NSError *error) {
        if(!error){
            self.hub[@"location"] = geoPoint;
            
            [self.hub saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if(succeeded){
                    [PFObject saveAllInBackground:self.selectedSongs block:^(BOOL succeeded, NSError *error) {
                        if(succeeded){
                            [self.navigationController popViewControllerAnimated:YES];
                        } else {
                            NSLog(@"failed to save songs for hub");
                        }
                    }];
                } else {
                    NSLog(@"failed to save hub");
                }
            }];
        } else {
            NSLog(@"failed to obtain gps for saving hub");
        }
    }];
    
    */
    
}

-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if([identifier isEqualToString:@"mediaPicker"]){
        MPMediaPickerController *m = [[MPMediaPickerController alloc] initWithMediaTypes: MPMediaTypeMusic];
        
        m.delegate = self;
        m.allowsPickingMultipleItems = YES;
        
        [self presentViewController:m animated:YES completion:nil];
        
        return NO;
    }
    
    
    return YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"prepare for segue: %@",segue);
}

//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    NSLog(@"did select row at index path: %@",indexPath);
//}

-(void)mediaPicker:(MPMediaPickerController *)mediaPicker didPickMediaItems:(MPMediaItemCollection *)mediaItemCollection
{
    NSLog(@"media picker: did pick items: %@",mediaItemCollection);
    if(self.selectedSongs==Nil){
        self.selectedSongs = [[NSMutableArray alloc] init];
    }
    for(MPMediaItem *i in mediaItemCollection.items){
        Song *o = [Song object];
        
//        o.hub = self.hub;
        o.owner = [PFUser currentUser];
        o.title = [i valueForProperty:MPMediaItemPropertyTitle];
        o.artist = [i valueForProperty:MPMediaItemPropertyArtist];
        o.pId = [NSString stringWithFormat:@"%@", [i valueForProperty:MPMediaItemPropertyPersistentID]];
//        o.u = [[i valueForProperty:MPMediaItemPropertyAssetURL] absoluteString];
        
        [self.selectedSongs addObject:o];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)mediaPickerDidCancel:(MPMediaPickerController *)mediaPicker
{
    NSLog(@"media picker: did cancel");
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
//    NSLog(@"text field: %@",textField.superview.superview.superview);
//    self.tableView.contentInset =  UIEdgeInsetsMake(0, 0, 360, 0);
////    [self.tableView scrollToNearestSelectedRowAtScrollPosition: UITableViewScrollPositionBottom animated:YES];
//    [self.tableView scrollToRowAtIndexPath:[self.tableView indexPathForCell:(id)textField.superview.superview.superview] atScrollPosition:UITableViewScrollPositionNone animated:YES];
//    [self.tableView scrollToRowAtIndexPath:self.index atScrollPosition:UITableViewScrollPositionTop animated:YES];
    
    activeField = textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
//    self.tableView.contentInset = UIEdgeInsetsZero;
    activeField = nil;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - field ending methods

- (IBAction)hubNameFieldDidEndEditing:(UITextField*)sender
{
//    NSLog(@"hub name field end: %@", sender.text);
    NSString *trimmedString = [sender.text stringByTrimmingCharactersInSet:
                               [NSCharacterSet whitespaceCharacterSet]];
    sender.text = trimmedString;
    
    hubName = sender.text;
}

- (IBAction)passcodeFieldDidEndEditing:(UITextField *)sender
{
    passcode = sender.text;
}

#pragma mark - music sources methods

- (IBAction)localMusicToggle:(UISwitch *)sender
{
    if(sender.isOn){
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:[self.data indexOfObjectIdenticalTo:musicSourcesSection]];
        NSMutableArray *cells = [musicSourcesSection objectForKey:@"cells"];
        
        [cells addObject:localMusicCell];
        
        [CATransaction begin];
        [CATransaction setCompletionBlock:^{
            [self.tableView reloadData];
        }];
        
        [self.tableView beginUpdates];
        [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.tableView endUpdates];
        
        [CATransaction commit];
    } else {
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:[self.data indexOfObjectIdenticalTo:musicSourcesSection]];
        NSMutableArray *cells = [musicSourcesSection objectForKey:@"cells"];
        
        
        [cells removeObjectAtIndex:1];
        
        [CATransaction begin];
        [CATransaction setCompletionBlock:^{
            [self.tableView reloadData];
        }];
        
        [self.tableView beginUpdates];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView endUpdates];
        
        [CATransaction commit];
        
    }
}
@end
