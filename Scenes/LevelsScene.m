//
//  LevelsScene.m
//  Rising Fall
//
//  Created by David Villarreal on 5/2/14.
//  Copyright (c) 2014 David Villarreal. All rights reserved.
//

#import "LevelsScene.h"

@implementation LevelsScene

-(void)didMoveToView:(SKView *)view{
    
    if (!_isCreated) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
           
            
            [self createScene];
            _isCreated = YES;
            
        });
        
        
    }
    
    
}

//Called when about to be removen
-(void)willMoveFromView:(SKView *)view{
    dispatch_async(dispatch_get_main_queue(), ^{
       
        [super willMoveFromView:view];
        _isCreated = NO;
        [_parentLevelButtons removeAllObjects];
        [_levelBPostions removeAllObjects];
        [_childLevelButtons removeAllObjects];
        [_subLevelBPosition removeAllObjects];
        _levelBPostions = nil;
        _sceneAtlas = nil;
        _parentLevelButtons = nil;
        [_lifeP clearAll];
    });
}

//Updates 60 fps
-(void)update:(NSTimeInterval)currentTime{
    
    if (_hasCreatedScene && _player.lifesLeft == 0) {
        [_lifeP updateTime];
    }
    
    
}

//Creates the level scene
-(void)createScene{
    @synchronized(self){
        _player = ((GameData *)[GameData sharedGameData]).player;
        [self createPosition];
        [self createNavigationButton];
        [self createLevelButtons];
        [self createLifePanel];
        
        _hasCreatedScene = YES;
    }
    
}

//Creates the Naviagtion Button
-(void)createNavigationButton{
    
    SKTexture * naviTexture = [_sceneAtlas textureNamed:@"naviB"];
    SKTexture * naviPressT = [_sceneAtlas textureNamed:@"naviBPressed"];
    
    _navigationB = [ButtonNode spriteNodeWithTexture:naviTexture];
    [_navigationB setImages:naviTexture pressedImage:naviPressT];
    _navigationB.position = _naviBPostion;
    _navigationB.zPosition = 2;
    _navigationB.userInteractionEnabled = YES;
    _navigationB.delegate = self;
    _navigationB.size = CGSizeMake(naviTexture.size.width/1.62, naviTexture.size.height/1.62);
    _navigationB.buttontype = NaviagtionButton;
    [self addChild:_navigationB];
    
}

//Creates the level buttons
-(void)createLevelButtons{
    
    SKSpriteNode  * background = [SKSpriteNode spriteNodeWithTexture:[_sceneAtlas textureNamed:@"background"]];
    background.zPosition = 0;
    background.position = CGPointMake(self.size.width/2, self.size.height/2);
    [self addChild:background];
    
    SKSpriteNode * backui = [SKSpriteNode spriteNodeWithTexture:[_sceneAtlas textureNamed:@"backgroundui"]];
    backui.zPosition = 1;
    backui.position = CGPointMake(self.size.width/2, self.size.height/2);
    backui.size = self.view.bounds.size;
    [self addChild:backui];
    
    
    int fontSize = 14;
    
    _parentLevelButtons = [NSMutableArray new];
    
    self.backgroundColor = [UIColor colorWithRed:0 green:0.443 blue:0.737 alpha:1];
    int max = -1;
    
    for (int i = 0 ; i < 10; i++) {
        LevelButton * levelB = [LevelButton spriteNodeWithTexture:[_buttonAtlas textureNamed:@"levelButton"]];
        levelB.position = [[_levelBPostions objectAtIndex:i] CGPointValue];
        levelB.zPosition = 2;
        levelB.size = CGSizeMake(levelB.size.width/1.62, levelB.size.height/1.62);
        levelB.parentNumber = i;
        [levelB setText:[NSString stringWithFormat:@"%d",i*10] Size:fontSize];
        levelB.label.fontColor = [UIColor colorWithRed:0.016 green:0.4 blue:0 alpha:1];
        
        if (levelB.parentNumber * 10 > _player.levelAt) {
            levelB.userInteractionEnabled = NO;
            levelB.alpha = .4;
        }else{
            max = i;
            levelB.userInteractionEnabled = YES;
            levelB.subDelegate = self;
        }
        
        [_parentLevelButtons addObject:levelB];
        [self addChild:levelB];
    }
    
    [[_parentLevelButtons objectAtIndex:max] currentLevelAnimation];
    
}

//Called when navigation button is pressed
-(void)buttonPressed: (ButtonType ) type{
   
    [self.mdelegate navigationPressed];
}

//Called when the parent level button is pressed
-(void)parentPressed:(int)parentNumber{
    
   
    
    @synchronized(self){
        if (_isSubCreated) {
            [self removeChildLevels: parentNumber];
            
            _isSubCreated = NO;
            
        }else{
            if (_player.lifesLeft > 0) {
                _lifeP.alpha = 0;
                [self createChildLevels: parentNumber];
                _isSubCreated = YES;
            }else{
                [_lifeP runActionWarning];
            }
            
        }
    }
}

//Called when the child level button is pressed
-(void)childPressed:(int)levelNumber{
    
    
    [self.mdelegate beginGamePlay:levelNumber];
}

//Creates the child levels
-(void)createChildLevels: (int) parentNumber{
    
    _navigationB.alpha = 0;
    _navigationB.userInteractionEnabled = NO;
    int fontSize = 14;
    
    //Deactivate parent buttons
    for (LevelButton * button in _parentLevelButtons) {
        button.userInteractionEnabled = NO;
        button.alpha = .4;
    }
    
    
    _childLevelButtons = [NSMutableArray new];
    
    float duration = .2;
    int childNumber = parentNumber*10;
    
    for (int i = 0; i< 10; i++) {
        LevelButton * childB = [LevelButton spriteNodeWithTexture:[_buttonAtlas textureNamed:@"levelButton"]];
        childB.levelNumber = childNumber++;
        childB.position = [[_levelBPostions objectAtIndex:parentNumber] CGPointValue];
        childB.alpha = 0;
        childB.size = CGSizeMake( childB.size.width/1.62, childB.size.height/1.62);
        childB.zPosition = 2;
        childB.subDelegate = self;
        childB.parentNumber = parentNumber*(-1);
        childB.isChild = YES;
        childB.userInteractionEnabled = NO;
        [childB setText:[NSString stringWithFormat:@"%d", childB.levelNumber] Size:fontSize];
        childB.label.fontColor = [UIColor colorWithRed:0.016 green:0.4 blue:0 alpha:1];
        SKAction * moveTo = [SKAction moveTo:[[_subLevelBPosition objectAtIndex:i] CGPointValue] duration: duration];
        
        SKAction * group;
        
        if (childB.levelNumber > _player.levelAt) {
            SKAction * fadeInLock = [SKAction fadeAlphaTo:.5 duration:duration];
            group = [SKAction group:@[moveTo, fadeInLock]];
        }else{
            SKAction * fadeIn = [SKAction fadeAlphaTo:1 duration:duration];
            group = [SKAction group:@[moveTo, fadeIn]];
            
        }
        
        [_childLevelButtons addObject:childB];
        
        if (i == 9) {
            [childB runAction:group completion:^{
                
                ButtonNode * parent = [_parentLevelButtons objectAtIndex:parentNumber];
                parent.userInteractionEnabled = YES;
                parent.alpha = 1;
                
                
                for (LevelButton * cB in _childLevelButtons) {
                    if (cB.levelNumber > _player.levelAt) {
                        cB.userInteractionEnabled = NO;
                    }else{
                        cB.userInteractionEnabled = YES;
                    }
                    
                    if (cB.levelNumber == _player.levelAt) {
                        [cB currentLevelAnimation];
                    }
                }
                
            }];
        }else{
            [childB runAction:group];
        }
        
        [self addChild:childB];
    }
    
   
    
}


//Removes the child levels
-(void)removeChildLevels: (int) parentNumber{
    float duration = .2;
    int count = 0;
    
    ((LevelButton *)[_parentLevelButtons objectAtIndex:parentNumber]).userInteractionEnabled = NO;
    
    for (LevelButton * childB in _childLevelButtons) {
        [childB removeAllActions];
        SKAction * moveTo = [SKAction moveTo:[[_levelBPostions objectAtIndex:parentNumber] CGPointValue] duration: duration];
        SKAction * fadeOut = [SKAction fadeAlphaTo:0 duration:duration];
        SKAction * group = [SKAction group:@[moveTo,fadeOut]];
        
        if (count == 9) {
            [childB runAction:group completion:^{
                
                [self removeChildrenInArray:_childLevelButtons];
                [_childLevelButtons removeAllObjects];
                _childLevelButtons = nil;
                _navigationB.alpha = 1;
                _navigationB.userInteractionEnabled = YES;
                _lifeP.alpha = 1;
                
                for (LevelButton * parentBut in _parentLevelButtons) {
                    if (parentBut.parentNumber*10 <= _player.levelAt) {
                        parentBut.userInteractionEnabled = YES;
                        parentBut.alpha =1;
                    }
                    
                }
                
            }];
        }else{
            [childB runAction:group];
        }
        count++;
    }
    
}

//Creates the life panel
-(void)createLifePanel{
    _lifeP = [LifePanel spriteNodeWithTexture:[_sceneAtlas textureNamed:@"lifePanel"]];
    _lifeP.position = CGPointMake(self.size.width/2, self.size.height/2);
    _lifeP.zPosition = 2;
    
    
    if (_player.lifesLeft > 0) {
        [_lifeP createLifePanel];
    }else{
        [_lifeP createTimePanel];
    }
    
    [self addChild:_lifeP];
    
}

//Creates all the position for each sprite in the scene
-(void)createPosition{
    
    _naviBPostion = CGPointMake(self.size.width/2, [_sceneAtlas textureNamed:@"naviB"].size.height/1.62);
    
    _levelBPostions = [NSMutableArray new];
    _subLevelBPosition = [NSMutableArray new];
    
    //Creates postion for level buttons
    float height = [_buttonAtlas textureNamed:@"levelButton"].size.height/1.62;
    float yOffset = (self.size.height - height * 5)/6.0;
    float xOffset = (self.size.width - 4*height)/5.0;
    
    //Parent level position
    for (int i = 0 ; i < 2; i++) {
        for (int j = 0; j < 5; j++) {
            
            float y = self.size.height - yOffset - (height + yOffset)*j - height;
            float x = xOffset + (3*height + 3*xOffset)*i + [_buttonAtlas textureNamed:@"levelButton"].size.width/1.62/2;
            CGPoint point = CGPointMake(x, y);
            
            [_levelBPostions addObject:[NSValue valueWithCGPoint:point]];
            
            
        }
    }
    
    //Sub level position
    for (int i = 0 ; i < 2; i++) {
        for (int j = 0; j < 5; j++) {
            
            float y = self.size.height - yOffset - (height + yOffset)*j - height;
            float x = 2*xOffset + height + (height + xOffset) *i + [_buttonAtlas textureNamed:@"levelButton"].size.width/1.62/2;
            CGPoint point = CGPointMake(x, y);
            
            [_subLevelBPosition addObject:[NSValue valueWithCGPoint:point]];
            
            
        }
    }
    
}







@end
