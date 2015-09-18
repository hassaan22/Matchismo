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

@end

@implementation ThreeCardMatchingGame

@synthesize score;

@dynamic cards;  // THIS MADE IT ALL WORK!!!!




static const int MISMATCH_PENALTY = 2;
static const int MATCH_BONUS = 4;
static const int COST_TO_CHOOSE = 1;

// The heart of the game
- (void)chooseCardAtIndex:(NSUInteger)index {
    Card *card = [self cardAtIndex:index];
    
    NSMutableArray *selectedCards = [[NSMutableArray alloc] init];
    
    if (!card.isMatched) {
        // card is already chosen, so unselect it
        if (card.isChosen) {
            card.chosen = NO;
        } else {
            // match against other chosen card
            for (Card *otherCard in self.cards) {
                if (otherCard.isChosen && !otherCard.isMatched) {
                    [selectedCards addObject:otherCard];
                }
            }
            if ([selectedCards count] < 2) {  // Less than 3 cards picked
                NSLog(@"CARD IS CHOSEN!");
                // card.chosen = YES;
            } else {
                NSInteger matchScore = [card match:selectedCards];
                if (matchScore) {  // There was a match
                    self.score += matchScore * MATCH_BONUS;
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
                    self.score -= MISMATCH_PENALTY;
                }
            }
            self.score -= COST_TO_CHOOSE;
            card.chosen = YES;
            NSLog(@"Am i chosen?: %d", card.chosen);
            
        }
    }
}


@end
