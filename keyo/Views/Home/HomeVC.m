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

@interface HomeVC ()

@end

@implementation HomeVC

@synthesize refreshButton,data;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

//    self.tableView.delegate = self;
//    self.tableView.dataSource = self;
    
    self.data = [[NSMutableArray alloc] init];
    
    self.title = @"Local Hubs";
}

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationItem.rightBarButtonItem = nil;
    
    [self onRefreshSites:nil];
    
    [self.navigationController setToolbarHidden:NO];
    
    
    
    
}

-(void)viewDidAppear:(BOOL)animated
{
//    NSLog(@"view did appear");
    if(![PFUser currentUser]){
        LoginVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginVC"];
        [self presentViewController:vc animated:YES completion:nil];
    } else {
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
    self.navigationController.delegate = self;
//    [self.navigationController setToolbarHidden:NO];
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
    
    [PFGeoPoint geoPointForCurrentLocationInBackground:^(PFGeoPoint *geoPoint, NSError *error) {
        if (!error) {
            // do something with the new geoPoint
            PFQuery *q = [PFQuery queryWithClassName:@"Hub"];
            [q whereKey:@"location" nearGeoPoint:geoPoint withinKilometers:0.3];
            
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
                } else {
                    NSLog(@"failed refresh");
                }
                
            }];
        } else {
            NSLog(@"failed to get gps");
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
    if([segue.identifier isEqualToString:@"gotoSite"]){
//        NSLog(@"prepare for segue");
        UITabBarController *tbc = segue.destinationViewController;
        HubView *hubv = tbc.viewControllers.firstObject;
        SongListView *slv = tbc.viewControllers.lastObject;
        PFObject *obj = ((SiteObject*)[self.data objectAtIndex:[self.tableView indexPathForSelectedRow].row]).hub;
        NSLog(@"hub:: %@",obj);
        hubv.hub = obj;
        slv.hub = obj;
    } else if([segue.identifier isEqualToString:@"gotoMyHub"]) {
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
//    NSLog(@"cell for row: %@",cell.textLabel.text);
    return cell;
}

//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
////    NSLog(@"did select row");
//}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

-(void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    
}


@end
