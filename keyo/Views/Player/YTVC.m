//
//  YTVC.m
//  keyo
//
//  Created by User on 1/17/14.
//  Copyright (c) 2014 MakoWare. All rights reserved.
//

#import "YTVC.h"


@interface YTVC ()

@end

@implementation YTVC

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
    
//    self.controller = [[LBYouTubePlayerViewController alloc] initWithYouTubeURL:[NSURL URLWithString:@"http://youtu.be/XbGs_qK2PQA"] quality:LBYouTubeVideoQualitySmall];
//    self.controller.delegate = self;
////    controller.view.frame = CGRectMake(0.0f, 0.0f, 200.0f, 200.0f);
////    controller.view.center = self.view.center;
//    [self.view addSubview: self.controller.view];
    
    self.mp = [[MPMoviePlayerController alloc] initWithContentURL:nil];
    
    LBYouTubeExtractor *ex = [[LBYouTubeExtractor alloc] initWithID:@"XbGs_qK2PQA" quality:LBYouTubeVideoQualityLarge];
    ex.delegate = self;
    [ex startExtracting];
    
    
    
//    p.p
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)youTubePlayerViewController:(LBYouTubePlayerViewController *)controller didSuccessfullyExtractYouTubeURL:(NSURL *)videoURL
{
    NSLog(@"yt player success: %@",videoURL);
}

- (void)youTubePlayerViewController:(LBYouTubePlayerViewController *)controller failedExtractingYouTubeURLWithError:(NSError *)error
{
    NSLog(@"yt player FAILED: %@",error);
}

- (void)youTubeExtractor:(LBYouTubeExtractor *)extractor didSuccessfullyExtractYouTubeURL:(NSURL *)videoURL
{
    NSLog(@"extractor success: %@",videoURL);
    self.mp.contentURL = videoURL;
    [self.mp play];
}

- (void)youTubeExtractor:(LBYouTubeExtractor *)extractor failedExtractingYouTubeURLWithError:(NSError *)error
{
    NSLog(@"extractor failed: %@",error);
}

@end
