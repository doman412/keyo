//
//  HubSettingsVC.m
//  keyo
//
//  Created by User on 1/10/14.
//  Copyright (c) 2014 MakoWare. All rights reserved.
//

#import "HubSettingsVC.h"

@interface HubSettingsVC ()

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
//    NSLog(@"saveButton: %@",self.navigationController);
//    NSLog(@"saveButton: %@",self.navigationController);
    self.parentViewController.navigationItem.rightBarButtonItem = self.saveButton;
//    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:self.saveButton, nil];
    
    self.hub = [PFObject objectWithClassName:@"Hub"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setToolbarHidden:YES];
}

-(void)viewDidAppear:(BOOL)animated
{
    self.navigationController.delegate = self;
}


- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    switch (section){
        case 1:
            if(self.publicSwitch.isOn){
                return @"Your hub will be seen locally.";
            } else {
                return @"Your hub will NOT be seen locally. (private)";
            }
        case 2:
            return @"Use a passcode to restrict access to your hub.";
        case 3:
            return @"Pick the music others can choose from.";
        case 4:
            return @"Range of visibility of you're hub.";
        case 5:
            return @"Minimum Reputation of users that can submit songs.";
        case 6:
            return @"Rate at which users can submit songs.";
        
    }
    return nil;
}

- (IBAction)onPublicSwitchChanged:(id)sender
{
    self.passcodeField.enabled = !self.publicSwitch.isOn;
    
    [self.tableView reloadData];
}

- (IBAction)onSave:(id)sender
{
    NSLog(@"save");
    
    
    self.hub[@"owner"] = [PFUser currentUser];
    self.hub[@"title"] = self.hubNameField.text;
    self.hub[@"passcode"] = self.passcodeField.text;
    self.hub[@"minRep"] = [NSNumber numberWithInteger: [self.reputationField.text integerValue]];
    self.hub[@"range"] = [NSNumber numberWithInteger: [self.visibilityField.text integerValue]];
    self.hub[@"submissions"] = [NSNumber numberWithInteger: [self.submissionRateField.text integerValue]];
    
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
        PFObject *o = [PFObject objectWithClassName:@"Song"];
        
        o[@"hub"] = self.hub;
        o[@"owner"] = [PFUser currentUser];
        o[@"title"] = [i valueForProperty:MPMediaItemPropertyTitle];
        o[@"artist"] = [i valueForProperty:MPMediaItemPropertyArtist];
        o[@"pid"] = [i valueForProperty:MPMediaItemPropertyPersistentID];
        o[@"url"] = [[i valueForProperty:MPMediaItemPropertyAssetURL] absoluteString];
        
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
    self.tableView.contentInset =  UIEdgeInsetsMake(0, 0, 360, 0);
//    [self.tableView scrollToNearestSelectedRowAtScrollPosition: UITableViewScrollPositionBottom animated:YES];
    [self.tableView scrollToRowAtIndexPath:[self.tableView indexPathForCell:(id)textField.superview.superview.superview] atScrollPosition:UITableViewScrollPositionNone animated:YES];
//    [self.tableView scrollToRowAtIndexPath:self.index atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    self.tableView.contentInset = UIEdgeInsetsZero;
}


@end
