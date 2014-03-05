//
//  NSString.m
//  Test4
//
//  Created by Derek Arner on 10/13/13.
//  Copyright (c) 2013 makoware. All rights reserved.
//

#import "NSString+ContainsAddition.h"

@implementation NSString(ContainsAddition)

- (BOOL)containsString:(NSString *)string
               options:(NSStringCompareOptions)options {
    NSRange rng = [self rangeOfString:string options:options];
    return rng.location != NSNotFound;
}

- (BOOL)containsString:(NSString *)string {
    return [self containsString:string options:0];
}

@end
