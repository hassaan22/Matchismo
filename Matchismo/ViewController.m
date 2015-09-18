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
        } else {
            NSLog(@"THREE CARD MATCHING GAME:");
            _game = [[ThreeCardMatchingGame alloc] initWithCardCount:[self.cardButtons count]
                                                           usingDeck:[self createDeck]];
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
    [self updateUI];
}

- (IBAction)restartGame:(UIButton *)sender {
    self.game = nil;
    [self game];
    [self updateUI];
    
}

- (void)updateUI {
    for (UIButton *cardButton in self.cardButtons) {
        NSUInteger cardButtonIndex = [self.cardButtons indexOfObject:cardButton];
        Card *card = [self.game cardAtIndex:cardButtonIndex];
        [cardButton setTitle:[self titleForCard:card]
                    forState:UIControlStateNormal];
        [cardButton setBackgroundImage:[self backgroundImageForCard:card]
                              forState:UIControlStateNormal];
        cardButton.enabled = !card.isMatched;
        self.scoreLabel.text = [NSString stringWithFormat:@"Score: %ld", (long)self.game.score];
    }
}
- (IBAction)typeOfGame:(id)sender {
    UISegmentedControl *segmentedControl = (UISegmentedControl *) sender;
    NSInteger currentGameType = segmentedControl.selectedSegmentIndex;
    // restart the game
    [self restartGame:nil];
    if (currentGameType == 0) {
        // Two Card Matching Game
        
    } else {
        // Three Card Matching Game
        
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
