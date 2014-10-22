//
//  StartScene.m
//  Rising Fall
//
//  Created by David Villarreal on 4/27/14.
//  Copyright (c) 2014 David Villarreal. All rights reserved.
//

#import "StartScene.h"

@implementation StartScene

-(void)didMoveToView:(SKView *)view{
    if (!_isCreated) {
        
        _textLoad = [TextureLoader shareTextureLoader];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
           
            
            [self createScene];
            _isCreated = YES;
            
        });
        
        
        
    }
}

//Cleaning up
-(void)willMoveFromView:(SKView *)view{
    
    dispatch_async(dispatch_get_main_queue(), ^{
       
        [super willMoveFromView:view];
        _isCreated = NO;
        [self removeAllChildren];
        _socialAtlas = nil;
        _startAtlas = nil;
        _ballAtlas = nil;
        [_socialSubPositions removeAllObjects];
        [_socialSubNodes removeAllObjects];
        [_spawners removeAllObjects];
        [_ballQuene removeAllObjects];
        _socialSubPositions = nil;
        _socialSubNodes = nil;
        _spawners = nil;
        _ballQuene = nil;
        _playButton = nil;
        _socialMediaB = nil;
    });
    
}

//Loop
-(void)update:(NSTimeInterval)currentTime{
    
    
    if (_hasFinishCreated) {
        
        if (_deltaTime >= _spawnRate) {
            _deltaTime = _deltaTime - _spawnRate;
            _passTime = currentTime - _deltaTime;
            [self spawnRandomBall];
        }
        
        _deltaTime = currentTime - _passTime;
        
    }
}


//spawns a random ball from a random spawner
-(void)spawnRandomBall{
    
    if (_spawners != nil) {
        int randIndex = arc4random() % (_spawners.count);
        Ball * ballSp = [[_spawners objectAtIndex:randIndex] spawnBall];
        ballSp.velocity = _velocity;
        //ballSp.alpha
        [ballSp setPhysicsProperties];
        [_ballQuene addObject:ballSp];
        if (!_testB) {
            _sBall = ballSp;
            _testB = YES;
        }
        
        //NSLog(@"IN Main Spawn Random ball %d ", [NSThread isMainThread]);
        [self addChild: ballSp];
        
    }
    
    //Remove ball that is off the screen
    if (_ballQuene.count > 0) {
        Ball * ballF = [_ballQuene objectAtIndex:0];
        if (ballF.position.y + ballF.size.height < 0) {
            [_ballQuene removeObjectAtIndex:0];
            [ballF removeFromParent];
            ballF = nil;
        }
    }
    
}


//Creates the Scenes content
-(void)createScene{
    
    
    @synchronized(self){
        
        [self initVariables];
        
        [self stillObjectPositions];
        
        [self createTitle];
        [self createPlayButton];
        [self createStoreButton];
        //[self createSocialMediaButton];
        [self createBackground];
        
        _hasFinishCreated = YES;
        
    }

}

//Inits the variables that are use through out this scene
-(void)initVariables{
    
    _playImage = [[_textLoad buttonAtlas] textureNamed:@"buttonL1"];
    _playPressedImage = [[_textLoad buttonAtlas] textureNamed:@"buttonL2"];
    _storeImage = [[_textLoad buttonAtlas] textureNamed:@"buttonL1"];
    _storeImagePressed = [[_textLoad buttonAtlas] textureNamed:@"buttonL2"];
    
    _spawnRate = 1/1;
    _socialSubAnimationDuration = .3;
    _deltaTime = _spawnRate;
    _ballQuene = [NSMutableArray new];
    _velocity = CGVectorMake(0, -100.0);
    self.physicsWorld.gravity = CGVectorMake(0, 0);
    
    
}

//Inits the Points for all the still objects in this scene
-(void)stillObjectPositions{
    _titlePosition = CGPointMake(self.size.width/2, self.size.height - self.size.height/5);
    _playButtonPosition = CGPointMake(self.size.width/2, self.size.height/2.25);
    _socialButtonPosition = CGPointMake(self.size.width*.9, self.size.height*.1);
    _storeButtonPosition = CGPointMake(self.size.width/2, _playButtonPosition.y - _playImage.size.height);
    
    _socialSubPositions = [NSMutableArray new];
    
    float xOffset = [_socialAtlas textureNamed:@"facebook"].size.width + [_socialAtlas textureNamed:@"facebook"].size.width*.3;
    float yOffset = [_socialAtlas textureNamed:@"facebook"].size.height + [_socialAtlas textureNamed:@"facebook"].size.height*.3;
    
    for (int row = -1; row < 2  ; row++) {
        
        for (int column = 0; column < 2; column++) {
            
            CGPoint point = CGPointMake(_playButtonPosition.x + xOffset*row, _playButtonPosition.y + yOffset*column);
            
            [_socialSubPositions addObject: [NSValue valueWithCGPoint:point] ];
        }
        
    }
    
}

//Creates the Title
-(void)createTitle{
    
    SKTexture * titleText = [_startAtlas textureNamed:@"Title"];
    SKSpriteNode * title = [SKSpriteNode spriteNodeWithTexture: titleText];
    title.size = CGSizeMake(titleText.size.width/1.96, titleText.size.height/1.96);
    title.position = _titlePosition;
    title.zPosition = 3;
    
//    SKAction * up = [SKAction scaleBy:1.05 duration:.9];
//    SKAction * down = [SKAction scaleBy:.95 duration:.9];
//    [title runAction:[SKAction repeatActionForever:[SKAction sequence:@[up, down]]]];
    
    [self addChild:title];
    
}

//Creates Play button
-(void)createPlayButton{
    
    
    _playButton = [ButtonNode spriteNodeWithTexture: _playImage];
    [_playButton setImages:_playImage pressedImage:_playPressedImage];
    [_playButton setText:NSLocalizedString(@"Play", nil)];
    _playButton.userInteractionEnabled = YES;
    _playButton.position = _playButtonPosition;
    _playButton.delegate = self;
    _playButton.zPosition = 4;
    _playButton.size = CGSizeMake(_playButton.size.width/2, _playButton.size.height/2);
    _playButton.buttontype = NaviagtionButton;
    [self addChild:_playButton];
    
    
}

//Creates the Store button
-(void)createStoreButton{
    
    _storeButton = [ButtonNode spriteNodeWithTexture: _storeImage];
    [_storeButton setImages:_storeImage pressedImage:_storeImagePressed];
    [_storeButton setText:NSLocalizedString(@"Store", nil)];
    _storeButton.userInteractionEnabled = YES;
    _storeButton.position = _storeButtonPosition;
    _storeButton.delegate = self;
    _storeButton.buttontype = StoreButton;
    _storeButton.zPosition = 4;
    _storeButton.size = CGSizeMake(_storeButton.size.width/2, _storeButton.size.height/2);
    [self addChild:_storeButton];
    
    
}

//Creates the Social Media Button
-(void)createSocialMediaButton{
    SKTexture * defaultSocialText = [_socialAtlas textureNamed:@"facebook"];
    
    _socialMediaB = [SocialMediaButton spriteNodeWithTexture:defaultSocialText];
    _socialMediaB.position = _socialButtonPosition;
    _socialMediaB.type = SOCIAL_BUTTON;
    _socialMediaB.userInteractionEnabled = YES;
    _socialMediaB.socialDelegate = self;
    _socialMediaB.zPosition = 2;
    [_socialMediaB beginAnimation];
    [self addChild:_socialMediaB];
    
}

//Creates the Background
-(void)createBackground{
    [self createSpawners];
    self.backgroundColor = [UIColor colorWithRed:0 green:0.443 blue:0.737 alpha:1];
    SKSpriteNode * backgroundUI = [SKSpriteNode spriteNodeWithTexture:[_startAtlas textureNamed:@"background.png"]];
    backgroundUI.position = CGPointMake(self.size.width/2, self.size.height/2);
    backgroundUI.size = self.view.bounds.size;
    backgroundUI.zPosition = 3;
    backgroundUI.userInteractionEnabled = NO;
    [self addChild:backgroundUI];
    
    SKSpriteNode * backbo = [SKSpriteNode spriteNodeWithTexture:[_startAtlas textureNamed:@"background0.png"]];
    backbo.position = CGPointMake(self.size.width/2, self.size.height/2);
    backbo.zPosition = 0;
    [self addChild:backbo];
    
    
}

//Creates the Background animation
-(void)createSpawners{
    
    _spawners = [NSMutableArray new];
    for (int i = 0; i < 10; i++) {
        Spawner * spawnerO = [[Spawner alloc] initWithLevel:0];
        
        float offsetX = (self.size.width - (spawnerO.size.width * 10))/11;
        float x = offsetX + ( spawnerO.size.width + offsetX )*i;
        
        spawnerO.position = CGPointMake(x, self.size.height);
        spawnerO.powerupProb = -1;
        [_spawners addObject:spawnerO];
    }
    
}


//Called when the play button is pressed
-(void)buttonPressed: (ButtonType)type{

    if (type == StoreButton) {
        [self.mdelegate storeButtonPressed];
    }else{
        [self.mdelegate playButtonPressed];
    }
    
}

//Called when the social button is pressed
-(void)socialButtonPressed{
    
  
    
    @synchronized(self){
        if (_isSocialSubCreated) {
            [self removeSocialMediaNodes];
            _isSocialSubCreated = NO;
            _socialMediaB.isOpen = NO;
        }else{
            [self createSocialMediaNodes];
            _isSocialSubCreated = YES;
            _socialMediaB.isOpen = YES;
        }
    }
}

//Creates all the social sub media nodes/buttons
-(void)createSocialMediaNodes{
    _playButton.alpha = 0;
    _storeButton.alpha = 0;
    _storeButton.userInteractionEnabled = NO;
    _playButton.userInteractionEnabled = NO;
    _socialMediaB.userInteractionEnabled = NO;
    
    
    NSArray * textures = [_socialAtlas textureNames];
    _socialSubNodes = [NSMutableArray new];
    
    SKAction * fadeIn = [SKAction fadeAlphaTo:1 duration: _socialSubAnimationDuration];
    
    
    for (int i = 0; i < textures.count; i++) {
        SocialMediaButton * socialSubB = [SocialMediaButton spriteNodeWithTexture: [_socialAtlas textureNamed:[textures objectAtIndex:i]]];
        socialSubB.position = _socialButtonPosition;
        socialSubB.alpha = 0;
        socialSubB.name = [textures objectAtIndex:i];
        socialSubB.zPosition = 2;
        socialSubB.indexInSubArray = i;
        socialSubB.socialDelegate = self;
        [_socialSubNodes addObject: socialSubB];
        SKAction * moveTo = [SKAction moveTo:[[_socialSubPositions objectAtIndex:i] CGPointValue] duration: _socialSubAnimationDuration];
        [socialSubB runAction:[SKAction group:@[fadeIn, moveTo]] completion:^{
            socialSubB.userInteractionEnabled = YES;
            _socialMediaB.userInteractionEnabled = YES;
        }];
        [self addChild:socialSubB];
        
    }
}

//Removes all the social sub media nodes/buttons
-(void)removeSocialMediaNodes{
    _socialMediaB.userInteractionEnabled = NO;
    
    SKAction * fadeOut = [SKAction fadeAlphaTo:0 duration: _socialSubAnimationDuration];
    int count = 0;
    
    for (SocialMediaButton * node in _socialSubNodes) {
        count++;
        node.userInteractionEnabled = NO;
        SKAction * moveTo = [SKAction moveTo: _socialButtonPosition duration: _socialSubAnimationDuration];
        if (count == _socialSubNodes.count) {
            [node runAction:[SKAction group:@[fadeOut, moveTo]] completion:^{
                
                _playButton.alpha = 1;
                _storeButton.alpha = 1;
                _storeButton.userInteractionEnabled = YES;
                _playButton.userInteractionEnabled = YES;
                _socialMediaB.userInteractionEnabled = YES;
                [self removeChildrenInArray: _socialSubNodes];
                [_socialSubNodes removeAllObjects];
                _socialSubNodes = nil;
            }];
        }else{
            [node runAction:[SKAction group:@[fadeOut, moveTo]]];
        }
        
    }
}

//Called when a sub social media button is clicked
-(void)subSocialButtonPressed:(BOOL)didShare{
    @synchronized(self){
        if (didShare) {
            [self socialButtonPressed];
        }
    }
    
}


-(void)disableChild{
    @synchronized(self){
        for (SocialMediaButton * sub in _socialSubNodes) {
            sub.userInteractionEnabled = NO;
        }
    }
}

-(void)enbableChild{
    @synchronized(self){
        for (SocialMediaButton * sub in _socialSubNodes) {
            sub.userInteractionEnabled = YES;
        }
    }
}



@end
