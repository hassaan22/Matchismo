//
//  PlayingCard.h
//  Matchismo
//
//  Created by Muhammad Shakeel on 5/20/15.
//  Copyright (c) 2015 Shola Project. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Card.h"

@interface PlayingCard : Card

@property (strong, nonatomic) NSString *suit;
@property (nonatomic) NSUInteger rank;

+ (NSArray *)validSuits;
+ (NSUInteger)maxRank;
@end
