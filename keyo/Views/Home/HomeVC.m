//
//  HomeVC.m
//  keyo
//
//  Created by Derek Arner on 12/26/13.
//  Copyright (c) 2013 MakoWare. All rights reserved.
//

#import "HomeVC.h"
#import "LoginVC.h"
#import "SiteObject.h"
#import "HubView.h"
#import "SongListView.h"
#import "PlayerVC.h"
#import "YouTubeVC.h"
#import "Theme.h"
#import "UIImage+Color.h"
#import "Reachability.h"
#import "OptionsVC.h"
#import <DejalActivityView/DejalActivityView.h>

@interface HomeVC ()

@end

@implementation HomeVC


static AVPlayer *player;

@synthesize refreshButton,data;

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}

+(AVPlayer *)myPlayer
{
    if(player){
        return player;
    } else {
        player = [[AVPlayer alloc] init];
        return player;
    }
}

+(AVPlayer *)myPlayerWithURL:(NSURL*)url
{
    if(player){
        return player;
    } else {
        player = [[AVPlayer alloc] initWithURL:url];
        return player;
    }
}

+(AVPlayer *)newPlayer
{

    player = [[AVPlayer alloc] init];
    return player;
    
}

+(AVPlayer *)newPlayerWithURL:(NSURL*)url
{
    
    player = [[AVPlayer alloc] initWithURL:url];
    return player;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

//    self.tableView.delegate = self;
//    self.tableView.dataSource = self;
    
    self.data = [[NSMutableArray alloc] init];
    
    self.navigationController.navigationBar.barTintColor = [Theme backgroundBlue];
    self.navigationController.navigationBar.tintColor = [Theme wellWhite];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [Theme wellWhite]}];
    
    self.navigationController.toolbar.barTintColor = [Theme backgroundBlue];
    self.navigationController.toolbar.tintColor = [Theme wellWhite];
    
    self.view.backgroundColor = [Theme wellWhite];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    self.reach = [Reachability reachabilityForInternetConnection];
    [self.reach startNotifier];
    
    
    self.filterBar.layer.cornerRadius = 2.0;
    
}

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationItem.rightBarButtonItem = nil;
    
    
    
    [self.navigationController setToolbarHidden:NO];
    
    
}

-(void)viewDidAppear:(BOOL)animated
{
//    NSLog(@"view did appear");
    if(![PFUser currentUser]){
        LoginVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginVC"];
        [self presentViewController:vc animated:YES completion:nil];
    } else {
        if(self.reach.currentReachabilityStatus!=NotReachable){
            [self onRefreshSites:nil];
            PFQuery *q = [PFQuery queryWithClassName:@"Hub"];
            [q whereKey:@"owner" equalTo:[PFUser currentUser]];
            
            [q findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                if(!error){
                    if(objects.count>0){
                        self.myHub = [objects firstObject];
                    } else {
                        self.myHub = nil;
                    }
                    [self evalHub];
                }
            }];
        }
        
    }
    self.navigationController.delegate = self;
    NSLog(@"contraint: %@", self.filterBarY);
}

- (void) reachabilityChanged:(NSNotification *)note
{
	Reachability* curReach = [note object];
    if(curReach.currentReachabilityStatus==NotReachable){
        [[[UIAlertView alloc] initWithTitle:@"No Connection" message:@"Lost Internet Connection." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
    }
    
}

- (void)evalHub
{
    if(self.myHub){
        self.navigationItem.rightBarButtonItem = self.myHubButton;
    } else {
        self.navigationItem.rightBarButtonItem = self.startButton;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onAddSite:(id)sender
{
    NSLog(@"onAddSite");
    [PFGeoPoint geoPointForCurrentLocationInBackground:^(PFGeoPoint *geoPoint, NSError *error) {
        if (!error) {
            // do something with the new geoPoint
            PFObject *h = [PFObject objectWithClassName:@"Hub"];
            h[@"title"] = @"home";
            h[@"location"] = geoPoint;
            h[@"owner"] = [PFUser currentUser];
            
            PFObject *o1 = [PFObject objectWithClassName:@"Song"];
            o1[@"title"] = @"song 1";
            
            PFObject *o2 = [PFObject objectWithClassName:@"Song"];
            o2[@"title"] = @"song 2";
            
            PFObject *o3 = [PFObject objectWithClassName:@"Song"];
            o3[@"title"] = @"song 3";
            
            PFObject *o4 = [PFObject objectWithClassName:@"Song"];
            o4[@"title"] = @"song 4";
            
            PFObject *o5 = [PFObject objectWithClassName:@"Song"];
            o5[@"title"] = @"song 5";
            
            PFObject *o6 = [PFObject objectWithClassName:@"Song"];
            o6[@"title"] = @"song 6";
            
            PFObject *q = [PFObject objectWithClassName:@"Queue"];
            
            h[@"queue"] = q;
            
            
            NSMutableArray *a = [NSMutableArray arrayWithObjects:o1, o2, o3, o4, o5, o6, nil];
            
            for(PFObject *obj in a){
                obj[@"points"] = @0;
                obj[@"hub"] = h;
                obj[@"owner"] = [PFUser currentUser];
                [obj saveInBackground];
            }
            
            
//            [o saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
//                if(succeeded){
//                    NSLog(@"saved site");
//                } else {
//                    NSLog(@"failed to save site");
//                }
//            }];
        } else {
            NSLog(@"failed to get gps");
        }
    }];
}

- (IBAction)onRefreshSites:(id)sender
{
    [DejalBezelActivityView activityViewForView:self.navigationController.view withLabel:@"Finding Hubs"];
    if(self.reach.currentReachabilityStatus==NotReachable){
        [[[UIAlertView alloc] initWithTitle:@"No Connection" message:@"Need a connection to the internet in order to use this app." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
        [DejalBezelActivityView removeViewAnimated:YES];
        return;
    }
    [PFGeoPoint geoPointForCurrentLocationInBackground:^(PFGeoPoint *geoPoint, NSError *error) {
        if (!error) {
            // do something with the new geoPoint
            PFQuery *q = [PFQuery queryWithClassName:@"Hub"];
//            [q whereKey:@"location" nearGeoPoint:geoPoint withinKilometers:0.3];
            
            [q findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                if(!error){
                    [self.data removeAllObjects];
                    //                [self.data addObjectsFromArray:objects];
//                    NSLog(@"got sites %lu",(unsigned long)objects.count);
                    for(PFObject *o in objects){
                        SiteObject *so = [[SiteObject alloc] init];
                        so.title = o[@"title"];
                        so.hub = o;
//                        NSLog(@"site title: %@",so.title);
                        [self.data addObject:so];
                    }
                    [self evalHub];
                    [self.tableView reloadData];
                    [DejalBezelActivityView removeViewAnimated:YES];
                } else {
                    NSLog(@"failed refresh");
                }
                
            }];
        } else {
            NSLog(@"failed to get gps");
            [DejalBezelActivityView removeViewAnimated:YES];
            [[[UIAlertView alloc] initWithTitle:@"GPS Failed" message:@"Failed to get a point of origin to search." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
        }
    }];
    
}

- (IBAction)onOptions:(id)sender
{
    NSString *actionSheetTitle = @"Options"; //Action Sheet Title
    NSString *logout = @"Logout"; //Action Sheet Button Titles
    NSString *settings = @"Settings";
    NSString *cancelTitle = @"Cancel Button";
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:actionSheetTitle
                                  delegate:self
                                  cancelButtonTitle:cancelTitle
                                  destructiveButtonTitle:logout
                                  otherButtonTitles:settings, nil];
    
    [actionSheet showFromToolbar:self.navigationController.toolbar];
}

- (IBAction)onMyHub:(id)sender
{
    NSLog(@"on my hub");
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"gotoMyHub"]) {
        PlayerVC *pvc = segue.destinationViewController;
        
        pvc.hub = self.myHub;
    }
    
}

#pragma mark - Action sheet delegate

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
//    NSLog(@"action sheet clicked: %lu",buttonIndex);
    if(buttonIndex==0){ // logout
        [PFUser logOut];
        LoginVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginVC"];
        [self presentViewController:vc animated:YES completion:nil];
    } else if(buttonIndex==1){ // settings
        NSLog(@"goto settings");
        OptionsVC *vc = [[UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil] instantiateViewControllerWithIdentifier:@"OptionsNavVC"];
        [self presentViewController:vc animated:YES completion:nil];
    }
}

#pragma mark - Table view data source

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
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    SiteObject *obj = [self.data objectAtIndex:indexPath.row];
    
    // Configure the cell...
    cell.textLabel.text = obj.title;
    cell.textLabel.textColor = [Theme fontBlack];
    
    cell.backgroundColor = [Theme wellWhite];
    
    
    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor = [Theme lightBlue];
//    bgColorView.layer.cornerRadius = 7;
    bgColorView.layer.masksToBounds = YES;
    [cell setSelectedBackgroundView:bgColorView];
    
//    helo
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    PFObject *obj = ((SiteObject*)[self.data objectAtIndex:indexPath.row]).hub;
    //        NSLog(@"hub:: %@",obj);
    //        hubv.hub = obj;
    //        slv.hub = obj;
    //        ytvc.hub = obj;
    
    HubView *hubv = [[UIStoryboard storyboardWithName:@"HubViewSB" bundle:nil] instantiateInitialViewController];
    hubv.hub = obj;
    
    [self.navigationController pushViewController:hubv animated:YES];
}

#pragma mark - filter methods

- (IBAction)onFilterButtonPressed:(id)sender
{
    if(self.filterBar.hidden){
        [self showFilterBar];
    } else {
        [self hideFilterBar];
    }
}

- (void)hideFilterBar
{
    self.filterBarY.constant = -35;
    self.tableViewToBottom.constant = 0;
    [UIView animateWithDuration:0.3 animations:^{
        self.filterBar.alpha = 0.0;
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        self.filterBar.hidden = YES;
    }];
}

- (void)showFilterBar
{
    self.filterBar.hidden = NO;
    self.filterBarY.constant = 0;
    self.tableViewToBottom.constant = 35;
    [UIView animateWithDuration:0.3 animations:^{
        self.filterBar.alpha = 1.0;
        [self.view layoutIfNeeded];
    }];
    
}

- (IBAction)onFilterSelect:(id)sender
{
    NSLog(@"current rect for filterbar: %@", NSStringFromCGRect(self.filterBar.frame));
}

#pragma mark - Navigation

-(void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    
}


@end
