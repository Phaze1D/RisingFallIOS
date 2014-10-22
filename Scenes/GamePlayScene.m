//
//  GamePlayScene.m
//  Rising Fall
//
//  Created by David Villarreal on 5/17/14.
//  Copyright (c) 2014 David Villarreal. All rights reserved.
//	Testing commit

#import "GamePlayScene.h"

@implementation GamePlayScene

//init method
-(void)didMoveToView:(SKView *)view{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        
        
        if (!_isCreated) {
            _textLoader = [TextureLoader shareTextureLoader];
            
            [self createScene];
            _isCreated = YES;
            
            
        }
        
    });
    
}


//Game loop
-(void)update:(NSTimeInterval)currentTime{
    [super update:currentTime];
    
    
    _currentTime = currentTime;
    
    if (_hasFinishCreated && !_didCreateTextView) {
        
        [_sPanel createIntroPanel:_levelID];
        _didCreateTextView = YES;
    }
    
    
    if (_ptPanel != nil) {
        _ptPanel.currentTime = currentTime;
    }
    
    [_movingBallList checkIfReached];
    if (_ceilingHit && !_pausedGame) {
        _didReachScore = [_scorePanel didReachScore];
        _didWin = NO;
        [self pauseGame];
    }
    
    if (_hasFinishCreated && _clickedBegin && !_pausedGame && !_ceilingHit) {
        
        
        if (currentTime >= _nextColorTime ) {
            [self changeRandomBallColor];
            _nextColorTime = _currentTime + _levelFactory.changeColorTime - _deltaTime;
        }
        
        
        if (_levelID >= 70 && _levelFactory.gameType == 1 && _objectivePanel.time <= _nextSpeedTime) {
            [_levelFactory changeSpeedAndDrop];
            _nextSpeedTime = _objectivePanel.time - _levelFactory.changeSpeedTime;
        }
        
        if (currentTime >= _nextTime && !_objectiveReached) {
            _deltaTime = currentTime - _nextTime;
            [self spawnBall];
            
            
            if (_powerTypeAt == 1) {
                _nextTime = currentTime + 1.0/.5 -_deltaTime;
            }else{
                _nextTime = currentTime + 1.0/_levelFactory.dropRate -_deltaTime;
            }
        }
        
        
        if ( ([_ptPanel updateTimer] && _powerTypeAt != 2) ) {
            _powerTypeAt = -1;
            
            if (_ptPanel != nil) {
                [self removePtPanel];
            }
            
        }
        
        _objectiveReached = [_objectivePanel updateObjective];
        if (_levelFactory.gameType == 1 && _objectivePanel.time <= 6 && !_objectiveReached) {
            [self startAlmostFinishAnimation: _objectivePanel.time];
        }
        
        if (_levelFactory.gameType == 2 && _objectivePanel.ballsLeft <= 5 && !_objectiveReached) {
            [self startAlmostFinishAnimation:_objectivePanel.ballsLeft];
        }
        if (_objectiveReached && _movingBallList.count == 0) {     //When the objective has been reached
            _stageAt = 3;
            [self removeEndAnimation];
            _didReachScore = [_scorePanel didReachScore];         //Check to see if the target score has been reached if not game lost
            [self pauseGame];
        }
        
    }
}


//Clear
-(void)willMoveFromView:(SKView *)view{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [super willMoveFromView:view];
        [self removeAllActions];
        [self removeAllChildren];
        _isCreated = NO;
        [_objectivePanel clearAll];
        [_powerPanel clearAll];
        [_scorePanel clearAll];
        [_optionPanel clearAll];
        [_sPanel clearAll];
        [_ballsArray removeAllObjects];
        _ballsArray = nil;
        [_movingBallList removeAll];
        _movingBallList.gameScene = nil;
        _movingBallList = nil;
        
        
        for (Spawner * sp in _spwaners) {
            [sp clearAll];
        }
        
        [_spwaners removeAllObjects];
        _gameSceneAtlas = nil;
        _ballAtlas = nil;
        _levelFactory = nil;
        _objectivePanel = nil;
        _powerPanel = nil;
        _scorePanel = nil;
        _ptPanel = nil;
        _optionPanel = nil;
        _sPanel = nil;
        _gameSceneAtlas = nil;
        
    });
    
}


//Creates the scene and GUI
-(void)createScene{
    @synchronized(self){
        NSLog(@"%f --- %f", self.size.width, self.size.height);
        _sizeManager = [SizeManager sharedSizeManager];
        [self initVariables];
        [self createPositions];
        [self createBackground];
        [self createPlayArea];
        [self createSideView];
        [self createLevelID];
        [self pauseGame];
        [self createInitialFill];
        _hasFinishCreated = YES;
        
    }
    
}

//Inits the scences variables
-(void)initVariables{
    _powerTypeAt = -1;
    _powerMaxAmount = 0;
    _player = ((GameData *)[GameData sharedGameData]).player;
    _levelFactory = [[LevelFactory alloc] initLevelNumber:_levelID];
    _stageAt = 1;
    _maxColumns= 8;
    
    
    switch (_levelFactory.ceilingHeight){
        case 1:
            _numRows = 13;
            _playAreaTexture = [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"playArea%d",1]];
            _levelFactory.ceilingHeight = 1;
            break;
        case 2:
        case 3:
            _numRows = 12;
            _playAreaTexture = [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"playArea%d",2]];
            _levelFactory.ceilingHeight = 2;
            break;
        case 4:
        case 5:
            _numRows = 11;
            _playAreaTexture = [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"playArea%d",3]];
            _levelFactory.ceilingHeight = 3;
            break;
        case 6:
            _numRows = 10;
            _playAreaTexture = [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"playArea%d",4]];
            _levelFactory.ceilingHeight = 4;
            
    }
    
    _xOffsetPA = ([_sizeManager getPlayAreaSize:_levelFactory.ceilingHeight].width - [_sizeManager getBallSize].width*_maxColumns)/(_maxColumns + 1);
    _yOffsetPA = ([_sizeManager getPlayAreaSize:_levelFactory.ceilingHeight].height - [_sizeManager getBallSize].height * _numRows)/(_numRows + 1);
    
    
    _ballsArray = [[NSMutableArray alloc] initWithCapacity:_numRows * _levelFactory.numOfColumns];
    _spwaners = [[NSMutableArray alloc] initWithCapacity:_levelFactory.numOfColumns];
    _movingBallList = [[LinkedListNew alloc]initWithScene:self];
    
    for (int i = 0; i < _numRows * _levelFactory.numOfColumns ; i++) {
        [_ballsArray addObject:[NSNull null]];
    }
    
    self.physicsWorld.gravity = CGVectorMake(0, 0);
    
    if (_levelFactory.gameType == 2) {
        _nextBallChange = _levelFactory.numberOfBalls - _levelFactory.changeSpeedBNum;
    }
    
}

//Creates the Positions of the still objects in the scene
-(void) createPositions{
    
    float xOffset = (self.size.width - [_sizeManager getPlayAreaSize: _levelFactory.ceilingHeight].width - [_sizeManager getPauseButtonSize].width)/3;
    float yOffset = (self.size.height - [_sizeManager getPlayAreaSize: _levelFactory.ceilingHeight].height - [_sizeManager getPowerPanelSize].height)/2;
    
    _playAreaPosition = CGPointMake(xOffset, yOffset);
    _optionAreaPosition = CGPointMake(xOffset*2 + [_sizeManager getPlayAreaSize: _levelFactory.ceilingHeight].width, (self.size.height - [_sizeManager getPlayAreaSize: 1].height - [_sizeManager getPowerPanelSize].height)/2);
    
    
    float topXOffset = (self.size.width - [_sizeManager getPowerPanelSize].width - [_sizeManager getPowerTimeSize].width - [_sizeManager getInfoPanelSize].width)/3;
    
    _powerAreaPosition = CGPointMake(topXOffset, yOffset*2 + [_sizeManager getPlayAreaSize:_levelFactory.ceilingHeight].height);
    _ptPosition = CGPointMake(topXOffset*2 + [_sizeManager getPowerPanelSize].width, yOffset*2 + [_sizeManager getPlayAreaSize:_levelFactory.ceilingHeight].height);
    _infoAreaPosition = CGPointMake(topXOffset*3 + [_sizeManager getPowerPanelSize].width + [_sizeManager getPowerTimeSize].width , yOffset*2 + [_sizeManager getPlayAreaSize:_levelFactory.ceilingHeight].height);
    
    
    _settingPosition = CGPointMake(_playAreaPosition.x + [_sizeManager getPlayAreaSize:_levelFactory.ceilingHeight].width/2 - [_sizeManager getSettingSize].width/2, _playAreaPosition.y + [_sizeManager getPlayAreaSize:_levelFactory.ceilingHeight].height/2 - [_sizeManager getSettingSize].height/2 );
    
    _objectivePosition = CGPointMake(_playAreaPosition.x, _playAreaPosition.y + [_sizeManager getPlayAreaSize:_levelFactory.ceilingHeight].height);
    
    _scorePosition = CGPointMake(_playAreaPosition.x + [_sizeManager getPlayAreaSize:_levelFactory.ceilingHeight].width , _playAreaPosition.y + [_sizeManager getPlayAreaSize:_levelFactory.ceilingHeight].height);
    
    
    
    if (_maxColumns == _levelFactory.numOfColumns) {
        _firstX = _playAreaPosition.x  + _xOffsetPA;
        _firstY = _playAreaPosition.y  +  _yOffsetPA;
    }else{
        int round = roundf(_maxColumns/_levelFactory.numOfColumns);
        _firstX = _playAreaPosition.x + _xOffsetPA + (_xOffsetPA + [_sizeManager getBallSize].width)* round;
        _firstY = _playAreaPosition.y +  _yOffsetPA;
    }
    
}

//Creates the Background
-(void)createBackground{
    
    self.backgroundColor = [UIColor colorWithRed:0 green:0.443 blue:0.737 alpha:1];
    SKSpriteNode * backboxes = [SKSpriteNode spriteNodeWithTexture:[_gameSceneAtlas textureNamed:@"backBoxes"]];
    backboxes.size = CGSizeMake(backboxes.size.width/2, backboxes.size.height/2);
    backboxes.position = CGPointMake(self.size.width/2, self.size.height/2);
    [self addChild:backboxes];
}

//Creates the level id panel that is at the top right of the screen
-(void)createLevelID{
   
    SKSpriteNode * infoArea = [SKSpriteNode spriteNodeWithTexture:[_gameSceneAtlas textureNamed:@"LevelIDArea"]];
    infoArea.size = [_sizeManager getInfoPanelSize];
    infoArea.position = _infoAreaPosition;
    infoArea.anchorPoint = CGPointMake(0, 0);
    [self addChild:infoArea];
    
    SKLabelNode * levelLa = [SKLabelNode labelNodeWithFontNamed:@"CooperBlack"];
    levelLa.text = [NSString stringWithFormat:@"%d", _levelID];
    levelLa.fontSize = 18;
    levelLa.fontColor = [UIColor colorWithRed:0.969 green:0.576 blue:0.118 alpha:1] ;
    levelLa.position = CGPointMake(infoArea.position.x + infoArea.size.width/2, infoArea.position.y + infoArea.size.height/2);
    levelLa.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
    levelLa.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
    [self addChild:levelLa];
    
    
    
}

//Creates the area were the game play will happen
-(void)createPlayArea{
    
   
    
    _playArea = [SKSpriteNode spriteNodeWithTexture: _playAreaTexture];
    _playArea.position = _playAreaPosition;
    _playArea.anchorPoint = CGPointMake(0, 0);
    _playArea.zPosition = 1;
    _playArea.size = [_sizeManager getPlayAreaSize:_levelFactory.ceilingHeight];
    [self addChild:_playArea];
    [self createSpawners];
    
    
}

//Creates the ball spawners
-(void)createSpawners{
    
    for (int i = 0; i < _levelFactory.numOfColumns; i++) {
        Spawner * spawner = [[Spawner alloc]initWithLevel:_levelID];
        spawner.column = i;
        spawner.position = CGPointMake(_firstX + (_xOffsetPA + spawner.size.width)*i, _playAreaPosition.y + [_sizeManager getPlayAreaSize:_levelFactory.ceilingHeight].height - [_sizeManager getBallSize].height/1.5);
        spawner.powerupProb = _levelFactory.powerBallDrop;
        spawner.doubleBallProb = _levelFactory.doubleBallProb;
        spawner.unMovableProb = _levelFactory.unMovableProb;
        spawner.levelAt = _levelID;
        [_spwaners addObject:spawner];
    }
    
}

//Creates the side view with all the options
-(void)createSideView{
    
    _objectivePanel = [ObjectivePanel spriteNodeWithTexture:[_gameSceneAtlas textureNamed:@"objectiveArea"]];
    _objectivePanel.position = _objectivePosition;
    _objectivePanel.anchorPoint = CGPointMake(0, 1);
    _objectivePanel.zPosition = 3;
    _objectivePanel.size = CGSizeMake(_objectivePanel.size.width/2, _objectivePanel.size.height/2);
    _objectivePanel.gameType = _levelFactory.gameType;
    
    if (_levelFactory.gameType == 1) {
        _objectivePanel.time = _levelFactory.gameTime;
        _objectivePanel.ballsLeft = -1;
    }else{
        _objectivePanel.ballsLeft = _levelFactory.numberOfBalls;
        _objectivePanel.time = -1;
    }
    
    [_objectivePanel initVariables];
    [self addChild: _objectivePanel];
    
    _optionPanel = [OptionPanel spriteNodeWithTexture:[_gameSceneAtlas textureNamed:@"optionArea"]];
    _optionPanel.position = _optionAreaPosition;
    _optionPanel.notPressedTexture = [_gameSceneAtlas textureNamed:@"optionArea"];
    _optionPanel.pressedTexture = [_gameSceneAtlas textureNamed:@"optionAreaPressed"];
    _optionPanel.zPosition = 2;
    _optionPanel.delegate = self;
    _optionPanel.userInteractionEnabled = YES;
    _optionPanel.size = [_sizeManager getPauseButtonSize];
    _optionPanel.anchorPoint = CGPointMake(0, 0);
    [self addChild:_optionPanel];
    
    _scorePanel = [ScorePanel spriteNodeWithTexture:[_gameSceneAtlas textureNamed:@"scoreArea"]];
    _scorePanel.position = _scorePosition;
    _scorePanel.zPosition = 3;
    _scorePanel.size = CGSizeMake(_scorePanel.size.width/2, _scorePanel.size.height/2);
    _scorePanel.anchorPoint = CGPointMake(1, 1);
    [_scorePanel createScorePanel:_levelFactory.targetScore];
    [self addChild:_scorePanel];
    
    _powerPanel = [PowerPanel spriteNodeWithTexture:[_gameSceneAtlas textureNamed:@"powerArea"]];
    _powerPanel.position = _powerAreaPosition;
    _powerPanel.zPosition = 2;
    _powerPanel.anchorPoint = CGPointMake(0, 0);
    _powerPanel.size = [_sizeManager getPowerPanelSize];
    [_powerPanel createPanel];
    [self addChild:_powerPanel];
    for (Ball * pball in _powerPanel.powerBalls) {
        pball.delegate = self;
    }
    
}

//Create info panel at the begin
-(void)createSettingPanel{
   
    
    _playArea.alpha = .3;
    
    if (!_isSettingPanelCreated) {
        
        for (Ball * ball in _powerPanel.powerBalls) {
            ball.userInteractionEnabled = NO;
        }
        
        _sPanel = [SettingPanel spriteNodeWithTexture:[_gameSceneAtlas textureNamed:@"gameOverArea"]];
        _sPanel.anchorPoint = CGPointMake(0, 0);
        _sPanel.position = _settingPosition;
        _sPanel.alpha = 1;
        _sPanel.size = [_sizeManager getSettingSize];
        _sPanel.zPosition = 4;
        _sPanel.gameType = _levelFactory.gameType;
        if (_levelFactory.gameType == 1) {
            _sPanel.objectiveLeft = _levelFactory.gameTime;
        }else{
            _sPanel.objectiveLeft = _levelFactory.numberOfBalls;
        }
        _sPanel.targetScore = _levelFactory.targetScore;
        _sPanel.delegate = self;
        
        if (_stageAt == 1) {
            
            [self addChild:_sPanel];
        }else if (_stageAt == 2){
            [_sPanel createPausePanel];
            [self addChild:_sPanel];
            
        }else if (_stageAt == 3){
            
            if (_ceilingHit) {
                
                SKAction * fadeIn = [SKAction fadeAlphaTo:.5 duration:.8];
                SKAction * fadeOut = [SKAction fadeAlphaTo:1 duration:.8];
                SKAction * seq = [SKAction sequence:@[fadeOut, fadeIn]];
                SKAction * repeat = [SKAction repeatAction:seq count:3];
                
                
                int hitIndex = _hitBall.column - _levelFactory.numOfColumns + (_levelFactory.numOfColumns * _hitBall.row);
                
                for (int i = hitIndex; i >= 0 ; i = i - _levelFactory.numOfColumns) {
                    Ball * ball = (Ball *)[_ballsArray objectAtIndex:i];
                    [ball runAction:repeat];
                }
                
                [_hitBall runAction:repeat completion:^{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        
                        if (!_didReachScore) {
                            //Create score not reached animation
                            [_scorePanel didNotReachAnimation];
                            _didWin = NO;
                        }
                        
                        if (_objectiveReached && _didReachScore) {
                            _didWin = YES;
                        }
                        
                        [_sPanel createGameOverPanel:_didWin];
                        
                        [self addChild:_sPanel];
                    });
                    
                }];
                
            }else{
                
                if (!_didReachScore) {
                    //Create score not reached animation
                    [_scorePanel didNotReachAnimation];
                    _didWin = NO;
                }
                
                if (_objectiveReached && _didReachScore) {
                    _didWin = YES;
                }
                
                [_sPanel createGameOverPanel:_didWin];
                
                [self addChild:_sPanel];
                
                
            }
            
            
        }
        
        _isSettingPanelCreated = YES;
        
    }
    
}

//Game paused
-(void)pauseGame{
    dispatch_async(dispatch_get_main_queue(), ^{
        _pausedGame = YES;
        [_movingBallList gamePaused];
        [self removeGameplay];
        _optionPanel.userInteractionEnabled = NO;
        [self createSettingPanel];
        _previousPauseTime = _currentTime;
    });
    
}

//Removes the setting panel when the user resumes the gameplay
-(void)removeSettingPanel{
    dispatch_async(dispatch_get_main_queue(), ^{
        [_sPanel clearAll];
        [_sPanel removeFromParent];
        _sPanel = nil;
        _optionPanel.userInteractionEnabled = YES;
        [self resumeGameplay];
    });
    
    
    _isSettingPanelCreated = NO;
}

//Called when the player pause the game. Removes balls objects
-(void)removeGameplay{
    for (int i = 0; i < _ballsArray.count; i++) {
        if ([[_ballsArray objectAtIndex:i] isKindOfClass:[Ball class]]) {
            ((Ball *)[_ballsArray objectAtIndex:i]).alpha = .5;
            ((Ball *)[_ballsArray objectAtIndex:i]).userInteractionEnabled = NO;
        }
    }
}

//Called when the player resumes the gameplay
-(void)resumeGameplay{
    _playArea.alpha = 1;
    if (_levelFactory.gameType == 1) {
        NSDate *date = [NSDate dateWithTimeIntervalSinceNow: _objectivePanel.time];
        _objectivePanel.futureTime = date.timeIntervalSince1970;
    }else{
        
    }
    _pausedGame = NO;
    _ptPanel.targetTime = _ptPanel.currentTime + _ptPanel.time;
    
    for (Ball * ball in _powerPanel.powerBalls) {
        if(ball.notificationNode != nil){
            ball.userInteractionEnabled = YES;
        }
    }
    
    [self createAllBallsArray];
    [_movingBallList gameResumed];
    _nextTime = _currentTime + _deltaTime;
    //_nextSpeedTime = _currentTime + _nextSpeedTime;
    
}

//Creates the initial fill
-(void)createInitialFill{
    int maxRow = _numRows - 2;
    
    for (int i = 0; i < _levelFactory.initFill * _numRows * _levelFactory.numOfColumns;) {
        int randC = arc4random()% (_levelFactory.numOfColumns);
        
        if ([_ballsArray objectAtIndex: (randC + (maxRow -1)*_levelFactory.numOfColumns)] == (id)[NSNull null]) {
            int row = 0;
            while ( [_ballsArray objectAtIndex:randC] != (id)[NSNull null]) {
                randC = randC + _levelFactory.numOfColumns;
                row++;
            }
            
            int randIndex = arc4random() % ([_ballAtlas textureNames].count);
            Ball * ball = [Ball spriteNodeWithTexture: [_ballAtlas textureNamed:[NSString stringWithFormat:@"ball%d", randIndex]]];
            ball.column = randC%_levelFactory.numOfColumns;
            ball.ballColor = randIndex;
            ball.size = [_sizeManager getBallSize];
            ball.row = row;
            ball.zPosition = 2;
            ball.userInteractionEnabled = YES;
            ball.delegate = self;
            ball.position = CGPointMake(_firstX + (_xOffsetPA + ball.size.width)*ball.column, _firstY + (_yOffsetPA + ball.size.height)* ball.row);
            [ball updateName];
            ball.anchorPoint = CGPointMake(0, 0);
            [_ballsArray replaceObjectAtIndex:randC withObject:ball];
            i++;
        }
    }
}

//Adds all the balls in the array to the scene
-(void)createAllBallsArray{
    for (int i = 0; i < _ballsArray.count; i++) {
        if ([[_ballsArray objectAtIndex:i] isKindOfClass:[Ball class]]) {
            if (![self childNodeWithName:((Ball *)[_ballsArray objectAtIndex:i]).name ]) {
                [self addChild:[_ballsArray objectAtIndex:i]];
            }
            ((Ball *)[_ballsArray objectAtIndex:i]).alpha = 1;
            ((Ball *)[_ballsArray objectAtIndex:i]).userInteractionEnabled = YES;
            
        }
    }
}

//Adds a single ball from the array to the scene
-(void)spawnBall{
    NSDate * d1 = [NSDate dateWithTimeIntervalSinceNow:0];
    
    
    if (_powerMaxAmount >= 2) {
        for (Spawner * sp in _spwaners) {
            sp.stopSpawningPower = YES;
        }
    }
    
    int randC = arc4random()%_levelFactory.numOfColumns;
    
    int row = 0;
    int index = randC;
    
    while ([_ballsArray objectAtIndex:index] != (id)[NSNull null] && row < _numRows ) {
        index = index + _levelFactory.numOfColumns;
        row++;
        if (row == _numRows) {
            row = 0;
            randC = arc4random()%_levelFactory.numOfColumns;
            index = randC;
        }
        
    }
    
    
    Ball * ball;
    
    if (_powerTypeAt == 2) {
        ball = [((Spawner *)[_spwaners objectAtIndex:randC])spawnSpecificBall:_power2BallNum];
        if ([_ptPanel updateBallsLeft]) {
            _powerTypeAt = -1;
            if (_ptPanel != nil) {
                [self removePtPanel];
            }
        }
    }else{
        ball = [((Spawner *)[_spwaners objectAtIndex:randC])spawnBall];
    }
    
    
    
    
    
    ball.finalPhysicY = _firstY + (_yOffsetPA + ball.size.height)*row;
    ball.row = row;
    ball.userInteractionEnabled = YES;
    ball.delegate = self;
    if (_powerTypeAt == 1) {
        ball.velocity = CGVectorMake(0, _levelFactory.velocity * (-.5));
    }else{
        ball.velocity = CGVectorMake(0, _levelFactory.velocity*(-1));
    }
    [ball updateName];
    [ball setPhysicsProperties];
    ball.zPosition = 2;
    [_ballsArray replaceObjectAtIndex:index withObject:ball];
    [_movingBallList addToEnd:ball];
    
    
    if (ball.isPowerBall) {
        _powerMaxAmount++;
    }
    
    [self addChild:ball];
    
    if (_levelFactory.gameType == 2) {
        _objectivePanel.ballsLeft--;
        if (_objectivePanel.ballsLeft == _nextBallChange) {
            [_levelFactory changeSpeedAndDrop];
            _nextBallChange = _objectivePanel.ballsLeft - _levelFactory.changeSpeedBNum;
        }
    }
    
    NSDate * d2 = [NSDate dateWithTimeIntervalSinceNow:0];
    _deltaTime = _deltaTime + d2.timeIntervalSinceNow - d1.timeIntervalSinceNow;
    
}

//Updates every ball in the ball arrays position
-(void)updateBallPositions{
    for (int i = 0; i<_ballsArray.count; i++) {
        if ([_ballsArray objectAtIndex:i] != (id)[NSNull null]) {
            [self calculateNewPosition: ((Ball *)[_ballsArray objectAtIndex:i])];
            
        }
    }
}

//Calculates a single ball's position
-(void)calculateNewPosition: (Ball *) ball{
    
    int rowBelow = ball.row -1;
    int belowIndex = ball.column + (_levelFactory.numOfColumns)*rowBelow;
    BOOL didGo = false;
    
    while ((belowIndex >= 0 && [_ballsArray objectAtIndex:belowIndex] == (id)[NSNull null])) {
        rowBelow--;
        belowIndex = ball.column + (_levelFactory.numOfColumns)*rowBelow;
        didGo = true;
    }
    if (didGo) {
        
        rowBelow++;
        belowIndex = ball.column + (_levelFactory.numOfColumns)*rowBelow;
        int oldIndex = ball.column + (_levelFactory.numOfColumns)*ball.row;
        ball.row = rowBelow;
        [ball updateName];
        ball.finalPhysicY = _firstY + (_yOffsetPA + ball.size.height)*ball.row;
        [_ballsArray replaceObjectAtIndex:oldIndex withObject:[NSNull null]];
        [_ballsArray replaceObjectAtIndex:belowIndex withObject:ball];
        
        if (!ball.isInMoveingList ) {
            [_movingBallList addToFront:ball];
            ball.velocity = CGVectorMake(0, -_levelFactory.velocity);
            [ball setPhysicsProperties];
        }
    }
    
    
}

//Called when the option panel is pressed
-(void)optionButtonPressed{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self pauseGame];
    });
}

//Called whent the player pressed the quit button in the setting panel
-(void)quitButtonPressed{
    
    
    if (_didWin) {
        if (_player.levelAt < 100 && _player.levelAt == _levelID) {
            _player.levelAt = _player.levelAt + 1;
        }
    }else{
        _player.lifesLeft--;
        if (_player.lifesLeft == 0) {
            [_player calculateNextLifeTime];
        }
    }
    
    if ( [(NSNumber *)[_player.scores objectAtIndex:_levelID] intValue] < _scorePanel.currentScore) {
        
        [_player.scores replaceObjectAtIndex:_levelID withObject:[NSNumber numberWithInt: _scorePanel.currentScore]];
    }
    
    [self.mdelegate quitGameplay];
    
}

//Called when the player presses the resumen button in the setting panel
-(void)resumenButtonPressed{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self removeSettingPanel];
    });
}

//Called when the player starts a new level after winning
-(void)startNextLevel{
    @synchronized(self){
        
        if ( [(NSNumber *)[_player.scores objectAtIndex:_levelID] intValue] < _scorePanel.currentScore) {
            [_player.scores replaceObjectAtIndex:_levelID withObject:[NSNumber numberWithInt: _scorePanel.currentScore]];
        }
        
        if (_player.levelAt < 100 && _player.levelAt == _levelID) {
            _player.levelAt = _player.levelAt + 1;
        }
        if (_levelID < 100) {
            [self.mdelegate beginNextLevel: ++_levelID];
        }
        
    }
    
    
    
}

//Called when the restart button is pressed when the player lose
-(void)restartButtonPressed{
    
    if ( [(NSNumber *)[_player.scores objectAtIndex:_levelID] intValue] < _scorePanel.currentScore) {
        [_player.scores replaceObjectAtIndex:_levelID withObject:[NSNumber numberWithInt: _scorePanel.currentScore]];
    }
    
    
    _player.lifesLeft--;
    if (_player.lifesLeft == 0) {
        [_player calculateNextLifeTime];
        [self.mdelegate quitGameplay];
    }else{
        [self.mdelegate beginNextLevel:_levelID];
    }
}

//Begins the game when the click
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesEnded:touches withEvent:event];
    if (!_clickedBegin) {
       
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (_levelFactory.gameType == 1) {
                NSDate *date = [NSDate dateWithTimeIntervalSinceNow:_levelFactory.gameTime];
                _objectivePanel.futureTime = date.timeIntervalSince1970;
            }else{
                
            }
            _clickedBegin = YES;
            _stageAt = 2;
            [self removeSettingPanel];
            
            _nextTime = _currentTime + 1.0/_levelFactory.dropRate;
            _nextColorTime = _currentTime + _levelFactory.changeColorTime;
            _nextSpeedTime = _objectivePanel.time -  _levelFactory.changeSpeedTime;
            
        });
        
    }
    
}

//Called when a ball is tap
-(void)ballTaped:(Ball *)ball{
    
    if (!_ceilingHit) {
        
        
        NSMutableArray *  connectedBalls = [[NSMutableArray alloc] init];
        [self connectionAlgo:ball Array:connectedBalls];
        
        for (Ball *cball in connectedBalls) {
            cball.hasBeenChecked = NO;
        }
        
        
        if (connectedBalls.count >= 3) {
            int score = (int)(connectedBalls.count - 2 )*3;
            
            if (_powerTypeAt == 5) {
                score = score * 2;
            }
            
            [self runBallRemoveEffect:score :ball];
            
            [_scorePanel updateScore:score];
            
            for (Ball *cball in connectedBalls) {
                
                if (cball.isDoubleBall) {
                    [cball doubleClicked];
                }else{
                    [cball removeFromParent];
                    int ballIndex = cball.column + _levelFactory.numOfColumns*cball.row;
                    [_ballsArray replaceObjectAtIndex:ballIndex withObject:[NSNull null]];
                }
            }
            [self updateBallPositions];
        }
        
        [connectedBalls removeAllObjects];
        connectedBalls = nil;
    }
    
}

//Runs a small effect when a ball is removed
-(void)runBallRemoveEffect: (int) score : (Ball * )ball{
    
    SKLabelNode * scoreLab = [SKLabelNode labelNodeWithFontNamed: @"CooperBlack"];
    scoreLab.text = [NSString stringWithFormat: @"%d", score];
    scoreLab.fontSize = 15;
    scoreLab.fontColor = [UIColor blackColor];
    scoreLab.position = CGPointMake(ball.position.x + ball.size.width/2, ball.position.y + ball.size.height/2 );
    scoreLab.zPosition = 2;
    [scoreLab setScale:0];
    
    SKAction * fadeOut = [SKAction fadeAlphaTo:0.4 duration:.5];
    SKAction * scaleUp = [SKAction scaleTo:2 duration:.5];
    SKAction * group = [SKAction group:@[fadeOut, scaleUp]];
    
    [self addChild:scoreLab];
    [scoreLab runAction:group completion:^{
        
        [scoreLab removeFromParent];
        
    }];
    
}

//Called when a ball is moved to a new location but finger has not been removed from the screen
-(void)ballMoved:(Ball *)ball direction:(int)dirc{
    
    int ballIndex = ball.column + _levelFactory.numOfColumns*ball.row;

    if (dirc == 1) {
        int upBallIndex = ballIndex + _levelFactory.numOfColumns;
        if (upBallIndex < _ballsArray.count &&
            [_ballsArray objectAtIndex:upBallIndex] != (id)[NSNull null] &&
            !((Ball *)[_ballsArray objectAtIndex:upBallIndex]).isInMoveingList &&
            !((Ball *)[_ballsArray objectAtIndex:upBallIndex]).isUnMoveable) {
            
            [self switchBalls:ball ballIndex:ballIndex tempIndex:upBallIndex];
            
            
        }
        
    }else if (dirc == -1){
        int downIndex = ballIndex - _levelFactory.numOfColumns;
        if (downIndex >= 0 && !((Ball *)[_ballsArray objectAtIndex:downIndex]).isUnMoveable) {
            [self switchBalls:ball ballIndex:ballIndex tempIndex:downIndex];
            
            
        }
        
    }else if (dirc == 2){
        int rightIndex = ballIndex + 1;
        if (rightIndex % _levelFactory.numOfColumns != 0 &&
            [_ballsArray objectAtIndex:rightIndex] != (id)[NSNull null] &&
            !((Ball *)[_ballsArray objectAtIndex:rightIndex]).isInMoveingList &&
            !((Ball *)[_ballsArray objectAtIndex:rightIndex]).isUnMoveable) {
            
            [self switchBalls:ball ballIndex:ballIndex tempIndex:rightIndex];
            
            
            
        }
        
    }else if (dirc == -2){
        int leftIndex = ballIndex - 1;
        if (ballIndex % _levelFactory.numOfColumns != 0 &&
            [_ballsArray objectAtIndex:leftIndex] != (id)[NSNull null] &&
            !((Ball *)[_ballsArray objectAtIndex:leftIndex]).isInMoveingList &&
            !((Ball *)[_ballsArray objectAtIndex:leftIndex]).isUnMoveable) {
            
            [self switchBalls:ball ballIndex:ballIndex tempIndex:leftIndex];
            
            
        }
    }
    
}

//Called when a power ball is touched
-(void)powerBallTouch:(Ball *)ball{
    
    int powerBallType = ball.powerBallType;
    
    switch (powerBallType) {
        case 1:
            [self powerBallType1];
            break;
        case 2:
            [self powerBallType2];
            break;
            
        case 3:
            [self powerBallType3];
            break;
            
        case 4:
            [self powerBallType4];
            
            if (ball.parent == _powerPanel) {
                [self updateBallPositions];
            }
            
            break;
            
        case 5:
            [self powerBallType5];
            break;
        default:
            break;
    }
    
    if (ball.parent == self) {
        int ballIndex = ball.column + _levelFactory.numOfColumns*ball.row;
        [ball removeFromParent];
        [_ballsArray replaceObjectAtIndex:ballIndex withObject:[NSNull null]];
        [self updateBallPositions];
    }
    
}


//Switchs two balls with each other
-(void)switchBalls: (Ball *)ball1 ballIndex: (int)index1 tempIndex: (int)index2{
    
    
    Ball * temp = ((Ball *)[_ballsArray objectAtIndex:index2]);
    int rowTemp = ball1.row;
    int columnTemp = ball1.column;
    ball1.row = temp.row;
    ball1.column = temp.column;
    temp.row = rowTemp;
    temp.column = columnTemp;
    [temp updateName];
    [ball1 updateName];
    [_ballsArray replaceObjectAtIndex:index1 withObject:[NSNull null]];
    [_ballsArray replaceObjectAtIndex:index2 withObject: ball1];
    [_ballsArray replaceObjectAtIndex:index1 withObject:temp];
    [temp removeAllActions];
    [ball1 removeAllActions];
    
    CGPoint tempPosition = ball1.position;
    [ball1 runAction:[SKAction moveTo:temp.position duration:.1]];
    [temp runAction:[SKAction moveTo:tempPosition duration:.1]];
    
}

//Calculates how many connections a ball has
//Recursive Algorithm
-(void)connectionAlgo: (Ball *)ball Array: (NSMutableArray * )connectedBalls {
    
    ball.hasBeenChecked = YES;
    [connectedBalls addObject:ball];
    
    //Indexes of the surronding balls
    int ballIndex = ball.column + _levelFactory.numOfColumns*ball.row;
    int rightIndex = ballIndex + 1;
    int leftIndex = ballIndex - 1;
    int upIndex = ballIndex + _levelFactory.numOfColumns;
    int downIndex = ballIndex - _levelFactory.numOfColumns;
    
    //Check right
    BOOL rightBool = rightIndex % _levelFactory.numOfColumns != 0 &&
    [_ballsArray objectAtIndex:rightIndex] != (id)[NSNull null] &&
    !((Ball *)[_ballsArray objectAtIndex:rightIndex]).isInMoveingList &&
    ((Ball *)[_ballsArray objectAtIndex:rightIndex]).ballColor == ball.ballColor &&
    !((Ball *)[_ballsArray objectAtIndex:rightIndex]).hasBeenChecked;
    
    if (rightBool) {
        [self connectionAlgo:(Ball *)[_ballsArray objectAtIndex:rightIndex] Array:connectedBalls];
    }
    
    //Check left
    BOOL leftBool = ballIndex % _levelFactory.numOfColumns != 0 &&
    [_ballsArray objectAtIndex:leftIndex] != (id)[NSNull null] &&
    !((Ball *)[_ballsArray objectAtIndex:leftIndex]).isInMoveingList &&
    !((Ball *)[_ballsArray objectAtIndex:leftIndex]).hasBeenChecked &&
    ((Ball *)[_ballsArray objectAtIndex:leftIndex]).ballColor == ball.ballColor;
    
    if (leftBool) {
        [self connectionAlgo:(Ball *)[_ballsArray objectAtIndex:leftIndex] Array:connectedBalls];
    }
    
    //Check up
    BOOL upBool = upIndex < _ballsArray.count &&
    [_ballsArray objectAtIndex:upIndex] != (id)[NSNull null] &&
    !((Ball *)[_ballsArray objectAtIndex:upIndex]).isInMoveingList &&
    !((Ball *)[_ballsArray objectAtIndex:upIndex]).hasBeenChecked &&
    ((Ball *)[_ballsArray objectAtIndex:upIndex]).ballColor == ball.ballColor;
    
    if (upBool) {
        [self connectionAlgo:(Ball *)[_ballsArray objectAtIndex:upIndex] Array:connectedBalls];
    }
    
    //Check down
    BOOL downBool = downIndex >= 0 &&
    !((Ball *)[_ballsArray objectAtIndex:downIndex]).hasBeenChecked &&
    ((Ball *)[_ballsArray objectAtIndex:downIndex]).ballColor == ball.ballColor;
    
    if (downBool) {
        [self connectionAlgo:(Ball *)[_ballsArray objectAtIndex:downIndex] Array:connectedBalls];
    }
    
}


//Disables the user interaction of all the balls in the array
-(void) disableBalls;{
    for (int i = 0; i <_ballsArray.count; i++) {
        if ([[_ballsArray objectAtIndex:i] isKindOfClass:[Ball class]]) {
            ((Ball *)[_ballsArray objectAtIndex:i]).userInteractionEnabled = NO;
        }
    }
}


//Slows down the velocity and rate of all the balls depends on timer
-(void)powerBallType1{
    
    _powerTypeAt = 1;
    if (_ptPanel != nil) {
        _ptPanel.powerType = _powerTypeAt;
        [_ptPanel resetTimer];
    }else{
        [self createPtPanel];
    }
    
}

//Spawns only one ball depends on Timer
-(void)powerBallType2{
    
    _powerTypeAt = 2;
    if (_ptPanel != nil) {
        _ptPanel.powerType = _powerTypeAt;
        [_ptPanel resetBalls];
    }else{
        [self createPtPanel];
    }
    
    
    _power2BallNum =  arc4random_uniform((unsigned)[_ballAtlas textureNames].count);
    
}

//Changes all the balls of one color to another color Does not depend on timer
-(void)powerBallType3{
    
    
    int ballFromColor = 0;
    int ballToColor = 0;
    
    for (int i = 0; i < _ballsArray.count; i++) {
        if ([_ballsArray objectAtIndex:i] != (id)[NSNull null] && !((Ball*)[_ballsArray objectAtIndex:i]).isPowerBall) {
            
            ballFromColor = ((Ball *)[_ballsArray objectAtIndex:i]).ballColor;
            break;
        }
    }
    
    for (int i = 0; i < _ballsArray.count; i++) {
        if ([_ballsArray objectAtIndex:i] != (id)[NSNull null] &&
            ((Ball *)[_ballsArray objectAtIndex:i]).ballColor != ballFromColor && !((Ball*)[_ballsArray objectAtIndex:i]).isPowerBall) {
            
            ballToColor = ((Ball *)[_ballsArray objectAtIndex:i]).ballColor;
            break;
        }
    }
    
    
    for (int i = 0; i < _ballsArray.count; i++) {
        if ([_ballsArray objectAtIndex:i] != (id)[NSNull null] && !((Ball*)[_ballsArray objectAtIndex:i]).isDoubleBall &&
            ((Ball*)[_ballsArray objectAtIndex:i]).ballColor == ballFromColor && !((Ball*)[_ballsArray objectAtIndex:i]).isPowerBall) {
            [[_ballsArray objectAtIndex:i] changeColor:ballToColor];
        }
    }
    
}

//Removes all the balls of the button 2 rows and gives the player the amount * 6
-(void)powerBallType4{
    
    
    for (int i = 0; i < _levelFactory.numOfColumns*2; i++) {
        if ([_ballsArray objectAtIndex:i] != (id)[NSNull null] &&
            !((Ball *)[_ballsArray objectAtIndex:i]).isInMoveingList &&
            !((Ball *)[_ballsArray objectAtIndex:i]).isPowerBall) {
            
            Ball * cball = [_ballsArray objectAtIndex:i];
            [cball removeFromParent];
            [_ballsArray replaceObjectAtIndex:i withObject:[NSNull null]];
        }
    }
    [_scorePanel updateScore:_levelFactory.numOfColumns*6];
}

//Double points every time you collect points Depends on Timer
-(void)powerBallType5{
    
    _powerTypeAt = 5;
    if (_ptPanel != nil) {
        _ptPanel.powerType = _powerTypeAt;
        [_ptPanel resetTimer];
    }else{
        [self createPtPanel];
    }
    
    
}

//Remove the power time panel when the power up is over
-(void)removePtPanel{
    SKAction * moveTo = [SKAction moveTo:CGPointMake(_ptPosition.x, self.size.height ) duration:.3];
    [_ptPanel runAction:moveTo completion:^{
        
        [_ptPanel removeAllChildren];
        [_ptPanel removeFromParent];
        _ptPanel = nil;
        
    }];
    
}

//Create the power time panel when a power is press
-(void)createPtPanel{
    
    _ptPanel = [PowerTimePanel spriteNodeWithTexture:[_gameSceneAtlas textureNamed:@"playerTimeArea"]];
    _ptPanel.position = CGPointMake(_ptPosition.x, self.size.height );
    _ptPanel.anchorPoint = CGPointMake(0, 0);
    _ptPanel.currentTime = _currentTime;
    _ptPanel.powerType = _powerTypeAt;
    _ptPanel.size = [_sizeManager getPowerTimeSize];
    SKAction * moveTo = [SKAction moveTo:_ptPosition duration:.3];
    [self addChild:_ptPanel];
    [_ptPanel runAction:moveTo];
    
    if (_powerTypeAt == 2) {
        [_ptPanel createPanelWithBalls];
    }else if(_powerTypeAt > 0){
        [_ptPanel createPanelWithTimer];
    }
    
}


//Changes a random ball color every specific time
-(void)changeRandomBallColor{
    
    int randIndex = arc4random_uniform((unsigned)_ballsArray.count);
    
    for (int i  = 0 ; i < 30; i++) {
        if ([_ballsArray objectAtIndex:randIndex] != (id)[NSNull null] && !((Ball *)[_ballsArray objectAtIndex:randIndex]).isInMoveingList
            && !((Ball *)[_ballsArray objectAtIndex:randIndex]).isDoubleBall && !((Ball *)[_ballsArray objectAtIndex:randIndex]).isPowerBall) {
            
            int toColor = arc4random_uniform((unsigned)[_ballAtlas textureNames].count);
            [(Ball *)[_ballsArray objectAtIndex:randIndex] changeColor:toColor];
            break;
            
        }else{
            randIndex = arc4random_uniform((unsigned)_ballsArray.count);
        }
        
    }
    
}

//Continue Playing if the player has paid or shared after a lose
-(void)continuePlaying{
    
    int midIndex = (int)_ballsArray.count/2;
    
    for (int i = midIndex - 1; i < _ballsArray.count; i++) {
        if ([_ballsArray objectAtIndex:i] != [NSNull null] ) {
            [_movingBallList findNodeAndRemove:[_ballsArray objectAtIndex:i]];
            [[_ballsArray objectAtIndex:i] removeFromParent];
            [_ballsArray replaceObjectAtIndex:i withObject:[NSNull null]];
        }
    }
    
    
    if (_objectiveReached) {
        
        if (_levelFactory.gameType == 1) {
            _objectivePanel.time = 20;
        }else{
            _objectivePanel.ballsLeft = 20;
        }
        _objectiveReached = NO;
    }
    
    
    
    
    if (_ceilingHit && _scorePanel.currentScore < _scorePanel.targetScore) {
        if (_levelFactory.gameType == 1 && _objectivePanel.time <= 10 ) {
            _objectivePanel.time = _objectivePanel.time + 10;
        }else if (_levelFactory.gameType == 2 && _objectivePanel.ballsLeft <= 10){
            _objectivePanel.ballsLeft = _objectivePanel.ballsLeft + 10;
        }
    }
    
    
    if (_ceilingHit) {
        _ceilingHit = NO;
        _hitBall = nil;
        [_crackSprite removeFromParent];
        _crackSprite = nil;
    }
    
    
    _stageAt = 2;
    
    [_scorePanel.titleLabel removeAllActions];
    [_scorePanel.titleLabel runAction:[SKAction scaleTo:1 duration:1]];
    [self removeSettingPanel];
    [self pauseGame];
    
}


-(void)startAlmostFinishAnimation:(int)amountLeft{
    
    if (amountLeft != _passEndTexture) {
        
        if (amountLeft == 5) {

            _animationNode = [SKSpriteNode spriteNodeWithTexture:[_gameSceneAtlas textureNamed:[NSString stringWithFormat:@"end%d", amountLeft]]];
            _animationNode.position = CGPointMake(_playAreaPosition.x + _playArea.size.width/2, _playAreaPosition.y + _playArea.size.height/2);
            _animationNode.size = CGSizeMake(_animationNode.size.width/2, _animationNode.size.height/2);
            [self addChild:_animationNode];
            
        }else{
            _animationNode.texture = [_gameSceneAtlas textureNamed:[NSString stringWithFormat:@"end%d", amountLeft]];
            
        }
        
        _passEndTexture = amountLeft;
    }
}

-(void)removeEndAnimation{
    [_animationNode removeFromParent];
    _animationNode = nil;
}

//Debug
-(void)printArray{
    
    for (int i = 0; i <_ballsArray.count; i++) {
        if (i%_levelFactory.numOfColumns == 0) {
            printf("\n");
        }
        if ([[_ballsArray objectAtIndex:i] isKindOfClass:[Ball class]]) {
            printf("%p  ",  ((Ball *)[_ballsArray objectAtIndex:i]));
        }else{
            printf("N  ");
        }
        
    }
    
    
    printf("\n \n");
}




@end
