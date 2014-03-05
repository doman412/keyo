//
//  NSString.h
//  Test4
//
//  Created by Derek Arner on 10/13/13.
//  Copyright (c) 2013 makoware. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString(ContainsAddition)

- (BOOL)containsString:(NSString *)string;
- (BOOL)containsString:(NSString *)string
               options:(NSStringCompareOptions)options;

@end
