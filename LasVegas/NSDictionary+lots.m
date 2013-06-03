//
//  NSDictionary+lots.m
//  LasVegas
//
//  Created by GORIN Franck on 16/05/13.
//  Copyright (c) 2013 Franck GORIN & Romain ARDIET. All rights reserved.
//

#import "NSDictionary+lots.h"

@implementation NSDictionary (lots)

-(NSArray *)listLots{
    return [self objectForKey:@"listLots"];
}

@end
