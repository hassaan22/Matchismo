//
//  CardMatchingGame.m
//  Matchismo
//
//  Created by Muhammad Shakeel on 5/21/15.
//  Copyright (c) 2015 Shola Project. All rights reserved.
//

#import "CardMatchingGame.h"

@interface CardMatchingGame()
@property (nonatomic, readwrite) NSInteger score;
@property (nonatomic, strong) NSMutableArray *cards;  // of Card
@property (nonatomic, strong, readwrite) NSMutableArray *chosenCards;  // of Card
@property (nonatomic, readwrite) NSInteger previousScore;

@end

@implementation CardMatchingGame

- (NSMutableArray *)cards {
    if (!_cards) _cards = [[NSMutableArray alloc] init];
    return _cards;
}

- (NSMutableArray *)chosenCards {
    if (!_chosenCards) {
        _chosenCards = [[NSMutableArray alloc] init];
    }
    return _chosenCards;
}

- (instancetype)initWithCardCount:(NSUInteger)count
                        usingDeck:(Deck *)deck {
    self = [super init];  // super's designated initializer
    
    if (self) {
        for (int i = 0; i < count; i += 1) {
            Card *card = [deck drawRandomCard];
            if (card) {
                [self.cards addObject:card];
            } else {
                self = nil;
                break;
            }
        }
    }
    return self;
}

- (Card *)cardAtIndex:(NSUInteger)index {
    return (index<[self.cards count]) ? self.cards[index] : nil;
}

static const int MISMATCH_PENALTY = 2;
static const int MATCH_BONUS = 4;
static const int COST_TO_CHOOSE = 1;

// The heart of the game
- (void)chooseCardAtIndex:(NSUInteger)index {
    self.chosenCards = nil;  // Needs to be new every time
    self.previousScore = 0;
    
    Card *card = [self cardAtIndex:index];
    
    if (!card.isMatched) {
        // card is already chosen, so unselect it
        if (card.isChosen) {
            card.chosen = NO;
            [self.chosenCards removeObject:card];
        } else {
            // match against other chosen card
            for (Card *otherCard in self.cards) {
                if (otherCard.isChosen && !otherCard.isMatched) {
                    NSInteger matchScore = [card match:@[otherCard]];
                    if (matchScore) {
                        self.previousScore = matchScore * MATCH_BONUS;
                        otherCard.matched = YES;
                        card.matched = YES;
                    } else {
                        self.previousScore = -MISMATCH_PENALTY;
                        otherCard.chosen = NO;
                    }
                    self.score += self.previousScore;
                    [self.chosenCards addObject:otherCard];
                    break; // because can only select two cards
                }
            }
            [self.chosenCards addObject:card];
            self.score -= COST_TO_CHOOSE;
            card.chosen = YES;
        }
        
    }
    
}

@end
