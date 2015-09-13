//
//  Card.h
//  Matchismo
//
//  Created by Muhammad Shakeel on 5/20/15.
//  Copyright (c) 2015 Shola Project. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Card : NSObject

@property (strong, nonatomic) NSString *contents;

@property (nonatomic, getter=isChosen) BOOL chosen;
@property (nonatomic, getter=isMatched) BOOL matched;

- (NSInteger)match:(NSArray *)otherCards;

@end
