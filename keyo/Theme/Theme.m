//
//  Theme.m
//  keyo
//
//  Created by User on 2/22/14.
//  Copyright (c) 2014 MakoWare. All rights reserved.
//

#import "Theme.h"



@implementation Theme

+(void)initTheme
{
    [[UISearchBar appearance] setBarTintColor:[Theme backgroundBlue]];
    [[UISearchBar appearance] setTintColor:[Theme wellWhite]];
    [[UISearchBar appearance] setScopeBarButtonTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                    [Theme fontWhite], NSForegroundColorAttributeName,nil ] forState:UIControlStateSelected];
    [[UISearchBar appearance] setScopeBarButtonTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                    [Theme fontBlack], NSForegroundColorAttributeName,nil ] forState:UIControlStateNormal];
    [[UITabBar appearance] setBarTintColor:[Theme backgroundBlue]];
    [[UITabBar appearance] setTintColor:[Theme wellWhite]];
    
    [[UINavigationBar appearance] setBarTintColor:[Theme backgroundBlue]];
    [[UINavigationBar appearance] setTintColor:[Theme wellWhite]];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [Theme wellWhite]}];
    
    [[UIToolbar appearance] setBarTintColor:[Theme backgroundBlue]];
    [[UIToolbar appearance] setTintColor:[Theme wellWhite]];
    
//    self.filterBar.backgroundColor = [Theme backgroundBlue];
//    self.filterBar.tintColor = [Theme lightBlue];
    [[UISegmentedControl appearance] setBackgroundColor:[Theme backgroundBlue]];
    [[UISegmentedControl appearance] setTintColor:[Theme lightBlue]];
    [[UISegmentedControl appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                             [Theme fontBlack], NSForegroundColorAttributeName,nil ] forState:UIControlStateSelected];
    [[UISegmentedControl appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                             [Theme fontBlack], NSForegroundColorAttributeName,nil ] forState:UIControlStateNormal];
}

+(UIColor *)orange
{
    // 225, 105, 0);
    return [UIColor colorWithRed:(225.0/255.0) green:(105.0/255.0) blue:(0.0/255.0) alpha:1.0];
}

+(UIColor*)fontBlack
{
    // (51, 51, 51)
    return [UIColor colorWithRed:(51.0/255.0) green:(51.0/255.0) blue:(51.0/255.0) alpha:1.0];
}

+(UIColor *)fontWhite
{
    // (235, 235, 235);
    return [UIColor colorWithRed:(235.0/255.0) green:(235.0/255.0) blue:(235.0/255.0) alpha:1.0];
}

+(UIColor*)wellWhite
{
    // (247, 247, 247)
    return [UIColor colorWithRed:(247.0/255.0) green:(247.0/255.0) blue:(247.0/255.0) alpha:1.0];
}

+(UIColor *)backgroundBlue
{
    //
    // old: (43,  62,  80)
    // new: (76, 150, 245)
    return [UIColor colorWithRed:(76.0/255.0) green:(150.0/255.0) blue:(245.0/255.0) alpha:1.0];
}

+(UIColor *)lightBlue
{
    // old: (78, 93, 108)
    // new: (76, 204, 245)
    return [UIColor colorWithRed:(76.0/255.0) green:(204.0/255.0) blue:(245.0/255.0) alpha:1.0];
}

@end
