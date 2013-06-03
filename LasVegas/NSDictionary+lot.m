//
//  NSDictionary+lot.m
//  LasVegas
//
//  Created by GORIN Franck on 16/05/13.
//  Copyright (c) 2013 Franck GORIN & Romain ARDIET. All rights reserved.
//

#import "NSDictionary+lot.h"

@implementation NSDictionary (lot)

-(NSString *)lotName{
    return [self objectForKey:@"name"];
}

-(NSString *)lotDescription{
    return [self objectForKey:@"description"];
}

-(NSString *)lotLargeDescription{
    return [self objectForKey:@"largeDescription"];
}

-(NSString *)lotSmallImage{
    return [self objectForKey:@"smallImage"];
}

-(NSString *)lotLargeImage{
    return [self objectForKey:@"largeImage"];
}


@end