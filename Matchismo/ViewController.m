//
//  ViewController.m
//  Matchismo
//
//  Created by Muhammad Shakeel on 5/20/15.
//  Copyright (c) 2015 Shola Project. All rights reserved.
//

#import "ViewController.h"
#import "PlayingCardDeck.h"
#import "CardMatchingGame.h"
#import "ThreeCardMatchingGame.h"

@interface ViewController ()
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (strong, nonatomic) CardMatchingGame *game;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UIButton *restartGame;
@property (weak, nonatomic) IBOutlet UISegmentedControl *typeOfGame;
@property (weak, nonatomic) IBOutlet UILabel *lastMoveDescriptionLabel;
@property (nonatomic) NSInteger numberOfCardsNeededPerMatch;

@end

@implementation ViewController

// I added a Git remote!

- (CardMatchingGame *)game {
    if (!_game) {
        NSInteger selectedSegment = [self.typeOfGame selectedSegmentIndex];
        if (selectedSegment == 0) {  // Two card matching
            NSLog(@"TWO CARD MATCHING GAME:");
            _game = [[CardMatchingGame alloc] initWithCardCount:[self.cardButtons count]
                                                      usingDeck:[self createDeck]];
            self.numberOfCardsNeededPerMatch = 2;
        } else {
            NSLog(@"THREE CARD MATCHING GAME:");
            _game = [[ThreeCardMatchingGame alloc] initWithCardCount:[self.cardButtons count]
                                                           usingDeck:[self createDeck]];
            self.numberOfCardsNeededPerMatch = 3;
        }
    }
    return _game;
}

- (Deck *)createDeck {
    return [[PlayingCardDeck alloc] init];
}


- (IBAction)touchCardButton:(UIButton *)sender {
    NSUInteger chosenButtonIndex = [self.cardButtons indexOfObject:sender];
    [self.game chooseCardAtIndex:chosenButtonIndex];
    // Disabling the UISegmentControl
    self.typeOfGame.userInteractionEnabled = NO;
    [self.typeOfGame setTintColor:[UIColor grayColor]];
    
    [self updateUI];
}

- (IBAction)restartGame:(UIButton *)sender {
    self.game = nil;
    [self game];
    [self updateUI];
    
    // Enabling the UISegmentControl
    self.typeOfGame.userInteractionEnabled = YES;
    [self.typeOfGame setTintColor:[UIColor blueColor]];
}


- (void)updateUI {
    NSInteger numberOfCurrentChosenCards = 0;
    NSInteger numberOfMatchedCards = 0;
    
    for (UIButton *cardButton in self.cardButtons) {
        NSUInteger cardButtonIndex = [self.cardButtons indexOfObject:cardButton];
        Card *card = [self.game cardAtIndex:cardButtonIndex];
        [cardButton setTitle:[self titleForCard:card]
                    forState:UIControlStateNormal];
        [cardButton setBackgroundImage:[self backgroundImageForCard:card]
                              forState:UIControlStateNormal];
        cardButton.enabled = !card.isMatched;
        if (card.isChosen) numberOfCurrentChosenCards += 1;
        if (card.isMatched) numberOfMatchedCards += 1;
    }
    
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %ld", (long)self.game.score];
    
    NSString *description = @"Select a Card!";
    NSMutableArray *chosenCardContents = [[NSMutableArray alloc] init];  // of Card Contents
    for (Card *card in self.game.chosenCards) {
        [chosenCardContents addObject:card.contents];
    }
    
    if ([chosenCardContents count] == self.numberOfCardsNeededPerMatch) {
        description = [chosenCardContents componentsJoinedByString:@" "];
        if (self.game.previousScore > 0) {
            description = [NSString stringWithFormat:@"Congrats! Matched %@ for %zd points", description, self.game.previousScore];
        } else {
            description = [NSString stringWithFormat:@"Silly, can't match %@. %zd points lost", description, -self.game.previousScore];
        }
    }
    
    
    
    
    self.lastMoveDescriptionLabel.text = description;
    
}

- (IBAction)typeOfGame:(id)sender {
    UISegmentedControl *segmentedControl = (UISegmentedControl *) sender;
    NSInteger currentGameType = segmentedControl.selectedSegmentIndex;
    // restart the game
    [self restartGame:nil];

    if (currentGameType == 0) {
        // Two Card Matching Game
        //self.numberOfCardsNeededPerMatch = 2;
    } else {
        // Three Card Matching Game
        //self.numberOfCardsNeededPerMatch = 3;
    }
    
}

- (NSString *)titleForCard:(Card *)card {
    NSLog(@"Is chosen? %d", card.isChosen);
    return card.isChosen ? card.contents : @"";
}

- (UIImage *)backgroundImageForCard:(Card *)card {
    return [UIImage imageNamed:card.isChosen ? @"cardfront" : @"cardback"];
}
@end
