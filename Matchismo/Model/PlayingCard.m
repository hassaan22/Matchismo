//
//  PlayingCard.m
//  Matchismo
//
//  Created by Muhammad Shakeel on 5/20/15.
//  Copyright (c) 2015 Shola Project. All rights reserved.
//

#import "PlayingCard.h"

@implementation PlayingCard

- (NSInteger)match:(NSArray *)otherCards {
    NSInteger score = 0;
    
    if ([otherCards count] == 1) {
        PlayingCard *otherCard = [otherCards firstObject];
        if (otherCard.rank == self.rank) {
            score = 4;
        } else if ([otherCard.suit isEqualToString:self.suit]) {
            score = 2;
        }
    } else if ([otherCards count] == 2) {
        PlayingCard *firstCard = [otherCards firstObject];
        PlayingCard *secondCard = [otherCards objectAtIndex:1];
        if (firstCard.rank == self.rank && secondCard.rank == self.rank) {
            // Three matching ranks
            score = 10;
        } else if (firstCard.suit == self.suit && secondCard.suit == self.suit) {
            // Three matching suit
            score = 6;
        } else if (firstCard.rank == self.rank || secondCard.rank == self.rank || firstCard.rank == secondCard.rank) {
            // Two matching ranks
            score = 4;
        } else if (firstCard.suit == self.suit || secondCard.suit == self.suit || firstCard.suit == secondCard.suit) {
            // Two matching suits
            score = 2;
        }
    }
    return score;
}

- (NSString *)contents {
    NSArray *rankStrings1 = [PlayingCard rankStrings];
    return [rankStrings1[self.rank] stringByAppendingString:self.suit];
}

@synthesize suit = _suit;  // because we provide setter AND getter

+ (NSArray *)validSuits {
    return @[@"👶🏿",@"💩",@"🐥",@"🐨"];
    //return @[@"♠",@"♣",@"♥",@"♦"];
}

- (void)setSuit:(NSString *)suit {
    if ([[PlayingCard validSuits] containsObject:suit]) {
        _suit = suit;
    }
}

- (NSString *)suit {
    return _suit ? _suit : @"?";
}

+ (NSArray *)rankStrings {
    return @[@"?",@"A",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"J",@"Q",@"K"];

    
}

+ (NSUInteger)maxRank {
    return [[self rankStrings] count] - 1;
}

- (void)setRank:(NSUInteger)rank {
    if (rank <= [PlayingCard maxRank]) {
        _rank = rank;
    }
}



@end
