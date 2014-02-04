//
//  PlayerVC.m
//  keyo
//
//  Created by User on 1/26/14.
//  Copyright (c) 2014 MakoWare. All rights reserved.
//

#import "PlayerVC.h"

@interface PlayerVC ()

@end

@implementation PlayerVC

@synthesize hub,trashConfirm,trashButton;

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
    self.title = self.hub[@"title"];
    
    self.trashConfirm = [[UIAlertView alloc] initWithTitle:@"Delete?" message:@"Are you sure you want to delete this hub?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self loadSongs];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadSongs
{
    NSLog(@"load songs for player");
    PFQuery *q = [PFQuery queryWithClassName:@"QueuedSong"];
    
    //    [self.songQuery whereKey:@"hub" equalTo:self.hub];
    //    [self.songQuery whereKey:@"queue" equalTo:self.hub[@"queue"]];
    [q whereKey:@"hub" equalTo:self.hub];
    //    [self.songQuery whereKey:@"active" equalTo:@YES];
    [q orderByDescending:@"points"];
    [q addAscendingOrder:@"createdAt"];
    [q includeKey:@"song"];
    
    [q findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if(!error){
            self.data = [NSArray arrayWithArray:objects];
            [self.tableView reloadData];
        } else {
            NSLog(@"failed to find songs for player");
        }
    }];
}

- (IBAction)onTrashHub:(id)sender {
    [self.trashConfirm show];
}

- (IBAction)onAddSongs:(id)sender {
    MPMediaPickerController *m = [[MPMediaPickerController alloc] initWithMediaTypes: MPMediaTypeMusic];
    
    m.delegate = self;
    m.allowsPickingMultipleItems = YES;
    
    [self presentViewController:m animated:YES completion:nil];
}

- (IBAction)onSkip:(id)sender {
}

- (IBAction)onPlayToggle:(id)sender {
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(alertView==self.trashConfirm){
        if(buttonIndex==1){ // pressed yes
            NSLog(@"trash the hub");
            [self.hub deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if(succeeded){
                    [self.navigationController popViewControllerAnimated:YES];
                } else {
                    NSLog(@"failed to delete hub: %@",error);
                }
            }];
            
            
        }
    }
}

-(void)mediaPicker:(MPMediaPickerController *)mediaPicker didPickMediaItems:(MPMediaItemCollection *)mediaItemCollection
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    for(MPMediaItem *i in mediaItemCollection.items){
        PFObject *o = [PFObject objectWithClassName:@"Song"];
        
        o[@"hub"] = self.hub;
        o[@"owner"] = [PFUser currentUser];
        o[@"title"] = [i valueForProperty:MPMediaItemPropertyTitle];
        o[@"artist"] = [i valueForProperty:MPMediaItemPropertyArtist];
        o[@"pid"] = [i valueForProperty:MPMediaItemPropertyPersistentID];
        o[@"url"] = [[i valueForProperty:MPMediaItemPropertyAssetURL] absoluteString];
        
        [array addObject:o];
    }
    [PFObject saveAllInBackground:array block:^(BOOL succeeded, NSError *error) {
        if(succeeded){
            [self dismissViewControllerAnimated:YES completion:nil];
        } else {
            NSLog(@"failed to save songs after hub");
        }
    }];
    
}

-(void)mediaPickerDidCancel:(MPMediaPickerController *)mediaPicker
{
    NSLog(@"media picker: did cancel");
    [self dismissViewControllerAnimated:YES completion:nil];
}







- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"playerCell";
    UITableViewCell *cell = (id)[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    PFObject *queuedSong = [self.data objectAtIndex:indexPath.row];
    
    PFObject *obj = queuedSong[@"song"];
    
    UILabel *points = (id)[cell viewWithTag:1];
    UILabel *title  = (id)[cell viewWithTag:2];
    UILabel *artist = (id)[cell viewWithTag:3];
    

    title.text = obj[@"title"];
    artist.text = obj[@"artist"];
    points.text = [NSString stringWithFormat:@"%li", (long)[queuedSong[@"points"] integerValue]];
    
    return cell;
}















@end
