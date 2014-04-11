//
//  SoundCloudVC.m
//  Juke
//
//  Created by User on 4/7/14.
//  Copyright (c) 2014 MakoWare. All rights reserved.
//

#import "SoundCloudVC.h"

@interface SoundCloudVC ()

@end

@implementation SoundCloudVC


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.parentViewController.navigationItem.rightBarButtonItem = self.navigationItem.rightBarButtonItem;
    self.parentViewController.navigationItem.title = self.navigationItem.title;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SCCell" forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}


#pragma mark - search bar delegate

-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    searchBar.showsCancelButton = YES;
    
    for (UIView *subView in searchBar.subviews){
        if([subView isKindOfClass:[UIButton class]]){
            NSLog(@"this is button type");
            
            [(UIButton *)subView setTintColor:[Theme fontBlack]];
            //            [(UIButton *)subView setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
    }
}


- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSLog(@"search for: %@", searchBar.text);
    [self hideSearchBar];
    [DejalBezelActivityView activityViewForView:self.navigationController.view withLabel:@"Searching..."];
    
    searchBar.showsCancelButton = NO;
    [searchBar resignFirstResponder];
    
    //https://api.soundcloud.com/tracks.json?consumer_key=1b2adbaac77a0cf4178cd3598b9859a6&q=childish%20gambino&filter=streamable&order=hotness
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    
    //        [params setObject:@"snippet" forKey:@"part"];
    [params setObject:searchBar.text forKey:@"q"];
    [params setObject:@"streamable" forKey:@"filter"];
    [params setObject:@"hotness" forKey:@"order"];
    //    [params setObject:@"true" forKey:@"videoSyndicated"];
    [params setObject:@"1b2adbaac77a0cf4178cd3598b9859a6" forKey:@"consumer_key"];
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:@"https://api.soundcloud.com/tracks.json" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //        NSLog(@"JSON: %@", [responseObject objectForKey:@"items"]);
        
        
        
        self.data = [NSMutableArray arrayWithArray:responseObject];
        [self.tableView reloadData];
        
        
        [DejalBezelActivityView removeViewAnimated:YES];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [DejalBezelActivityView removeViewAnimated:YES];
    }];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    //    searchBar.showsCancelButton = NO;
    //    [searchBar resignFirstResponder];
    [self hideSearchBar];
}

- (IBAction)onSearch:(id)sender
{
    if(self.searchBar.hidden){
        [self showSearchBar];
    } else {
        [self hideSearchBar];
    }
}

- (void)hideSearchBar
{
    
    
    if(self.searchBar.hidden==NO){
        CGRect newFrameSize = CGRectMake(0, self.tableView.frame.origin.y-44, self.tableView.frame.size.width, self.tableView.frame.size.height+44);
        
        [self.searchBar resignFirstResponder];
        [UIView animateWithDuration:0.4 animations:^{
            self.tableView.frame = newFrameSize;
            self.searchBar.alpha = 0.0;
        } completion:^(BOOL finished) {
            self.searchBar.hidden = YES;
        }];
    }
    
}

- (void)showSearchBar
{
    
    if(self.searchBar.hidden==YES){
        CGRect newFrameSize = CGRectMake(0, self.tableView.frame.origin.y+44, self.tableView.frame.size.width, self.tableView.frame.size.height-44);
        
        self.searchBar.hidden = NO;
        [UIView animateWithDuration:0.4 animations:^{
            self.tableView.frame = newFrameSize;
            self.searchBar.alpha = 1.0;
        } completion:^(BOOL finished) {
            [self.searchBar becomeFirstResponder];
        }];
    }
    
    
}


@end
