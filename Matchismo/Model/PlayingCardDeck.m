//
//  PlayingCardDeck.m
//  Matchismo
//
//  Created by Muhammad Shakeel on 5/20/15.
//  Copyright (c) 2015 Shola Project. All rights reserved.
//

#import "PlayingCardDeck.h"
#import "PlayingCard.h"

@implementation PlayingCardDeck

- (instancetype)init {
    self = [super init];
    
    if (self) {
        for (NSString *suit in [PlayingCard validSuits]) {
            for (NSUInteger rank = 1; rank <= [PlayingCard maxRank]; rank++) {
                PlayingCard *card = [[PlayingCard alloc] init];
                card.rank = rank;
                card.suit = suit;
                card.matched = NO;
                card.chosen = NO;
                [self addCard:card];
            }
        }
    }
    return self;
}

@end
