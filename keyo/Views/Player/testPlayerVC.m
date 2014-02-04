//
//  testPlayerVC.m
//  keyo
//
//  Created by User on 1/17/14.
//  Copyright (c) 2014 MakoWare. All rights reserved.
//

#import "testPlayerVC.h"

@interface testPlayerVC ()

@end

@implementation testPlayerVC

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"embedYT"]){
        self.ytController = ((YTVC*)segue.destinationViewController).controller;
    }
}

@end
