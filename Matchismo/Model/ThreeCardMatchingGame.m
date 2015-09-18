//
//  ThreeCardMatchingGame.m
//  Matchismo
//
//  Created by Muhammad Shakeel on 9/18/15.
//  Copyright © 2015 Shola Project. All rights reserved.
//

#import "ThreeCardMatchingGame.h"


@interface ThreeCardMatchingGame()

@property (nonatomic, readwrite) NSInteger score;
@property (nonatomic, strong) NSMutableArray *cards;

@property (nonatomic, strong, readwrite) NSMutableArray *chosenCards;  // of Card
@property (nonatomic, readwrite) NSInteger previousScore;


@end

@implementation ThreeCardMatchingGame

@synthesize score;

@dynamic cards;  // THIS MADE IT ALL WORK!!!!





static const int MISMATCH_PENALTY = 2;
static const int MATCH_BONUS = 4;
static const int COST_TO_CHOOSE = 1;

// The heart of the game
- (void)chooseCardAtIndex:(NSUInteger)index {
    self.chosenCards = nil;  // Needs to be new every time
    self.previousScore = 0;
    
    Card *card = [self cardAtIndex:index];
    
    NSMutableArray *selectedCards = [[NSMutableArray alloc] init];
    
    if (!card.isMatched) {
        // card is already chosen, so unselect it
        if (card.isChosen) {
            card.chosen = NO;
            [self.chosenCards removeObject:card];
        } else {
            // match against other chosen card
            for (Card *otherCard in self.cards) {
                if (otherCard.isChosen && !otherCard.isMatched) {
                    [selectedCards addObject:otherCard];
                    [self.chosenCards addObject:otherCard];
                }
            }
            if ([selectedCards count] == 2) {  // 3 cards picked (current card is "notChosen)
                NSInteger matchScore = [card match:selectedCards];
                if (matchScore) {  // There was a match
                    self.previousScore = matchScore * MATCH_BONUS;
                    for (Card *otherCard in selectedCards) {
                        NSInteger indexOfCard = [self.cards indexOfObject:otherCard];
                        Card *chosenCard = [self.cards objectAtIndex:indexOfCard];
                        chosenCard.matched = YES;
                    }
                    card.matched = YES;
                } else {
                    for (Card *otherCard in selectedCards) {
                        NSInteger indexOfCard = [self.cards indexOfObject:otherCard];
                        Card *chosenCard = [self.cards objectAtIndex:indexOfCard];
                        chosenCard.chosen = NO;
                    }
                    self.previousScore = -MISMATCH_PENALTY;
                }
                self.score += self.previousScore;
            }
            [self.chosenCards addObject:card];
            self.score -= COST_TO_CHOOSE;
            card.chosen = YES;
            
        }
    }
}


@end
