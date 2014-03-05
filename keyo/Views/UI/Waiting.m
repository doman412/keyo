//
//  Waiting.m
//  keyo
//
//  Created by User on 2/27/14.
//  Copyright (c) 2014 MakoWare. All rights reserved.
//

#import "Waiting.h"

@interface Waiting (){
    BOOL showed;
    BOOL toDismiss;
    UIViewController *dvc;
}

@end

@implementation Waiting

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id)init{
    if (self = [super init]) {
        showed = false;
        toDismiss = false;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    showed = true;
    if(toDismiss){
        [self hideIt:dvc];
    }
    
    //    NSLog(@"waiting bg: %@",self.view.backgroundColor);
}

- (void)viewDidUnload{
    [super viewDidUnload];
    [self stopIt];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

+(id)one{
    static Waiting *wait = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //        wait = [[self alloc] init];
        wait = [[UIStoryboard storyboardWithName:@"Waiting" bundle:nil] instantiateInitialViewController];
    });
    return wait;
}

-(void)showIt:(UIViewController*)vc{
    dvc = vc;
    //    vc.modalPresentationStyle = UIModalPresentationCurrentContext;
    [vc.view.window makeKeyAndVisible];
    vc.view.window.rootViewController.modalPresentationStyle = UIModalPresentationCurrentContext;
    [vc.view.window.rootViewController presentViewController:self animated:NO completion:nil];
    
    //    vc.modalPresentationStyle = UIModalPresentationCurrentContext;
    //    [vc presentViewController:self animated:NO completion:nil];
}

+(void)show:(UIViewController*)vc{
    Waiting *w = [Waiting one];
    [w showIt:vc];
}

-(void)hideIt{
    [self hideIt:dvc];
}

+(void)hide{
    Waiting *w = [Waiting one];
    [w hideIt];
}

-(void)hideIt:(UIViewController*)vc{
    toDismiss = true;
    if(showed){
        [vc dismissViewControllerAnimated:NO completion:nil];
    }
}

+(void)hide:(UIViewController*)vc{
    Waiting *w = [Waiting one];
    [w hideIt:vc];
}

-(void)startIt{
    [self.ind startAnimating];
}

+(void)start{
    Waiting *w = [Waiting one];
    [w startIt];
}

-(void)stopIt{
    [self.ind stopAnimating];
}

+(void)stop{
    Waiting *w = [Waiting one];
    [w stopIt];
}

@end
