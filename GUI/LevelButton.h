//
//  LevelButton.h
//  Rising Fall
//
//  Created by David Villarreal on 5/3/14.
//  Copyright (c) 2014 David Villarreal. All rights reserved.
//

#import "ButtonNode.h"

@protocol LevelButtonDelegate <NSObject>

@required
-(void)parentPressed: (int)parentNumber;
-(void)childPressed: (int)levelNumber;

@end

@interface LevelButton : ButtonNode

@property(nonatomic,weak) id<LevelButtonDelegate> subDelegate;

@property int parentNumber;
@property int levelNumber;

@property BOOL isChild;


@end
