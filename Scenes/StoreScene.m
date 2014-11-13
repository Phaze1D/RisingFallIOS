//
//  StoreScene.m
//  Rising Fall
//
//  Created by David Villarreal on 7/22/14.
//  Copyright (c) 2014 David Villarreal. All rights reserved.
//

#import "StoreScene.h"

@implementation StoreScene


-(void)didMoveToView:(SKView *)view{
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if (!_isCreated) {
            
            [self createScene];
            _isCreated = YES;
        }
        
    });
    
}


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

-(void)willMoveFromView:(SKView *)view{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self removeAllChildren];
        [self removeAllActions];
        
    });
    
}


-(void)createScene{
    
    @synchronized(self){
     
        self.backgroundColor = [UIColor whiteColor];
        [self initVariables];
        [self createBackground];
        [self createPosition];
        [self createSideView];
        [self createBackButton];
        
        _hasFinishCreated = YES;
    }
}

-(void)initVariables{
    
    
    _spawnRate = 1/1.0;
    _deltaTime = _spawnRate;
    _ballQuene = [NSMutableArray new];
    _velocity = CGVectorMake(0, -100.0);
    self.physicsWorld.gravity = CGVectorMake(0, 0);
    
    
}

//Creates the Positions
-(void)createPosition{
    float yOffset = (self.size.height - ([_sceneAtlas textureNamed:@"itemsArea"].size.height/2) - ([_sceneAtlas textureNamed:@"backButton"].size.height/2))/3;
    
    _backButtonPosition = CGPointMake([_sceneAtlas textureNamed:@"itemsArea"].size.width/4, yOffset);
    _sidePositions = CGPointMake(0, yOffset * 2 + [_sceneAtlas textureNamed:@"backButton"].size.height/2 );
    
}

//spawns a random ball from a random spawner
-(void)spawnRandomBall{
    
    if (_spawners != nil) {
        int randIndex = arc4random() % (_spawners.count);
        Ball * ballSp = [[_spawners objectAtIndex:randIndex] spawnBall];
        ballSp.velocity = _velocity;
        ballSp.zPosition = 1;
        [ballSp setPhysicsProperties];
        [_ballQuene addObject:ballSp];
        [self addChild: ballSp];
        
    }
    
    //Remove ball that is off the screen
    if (_ballQuene.count > 0) {
        Ball * ballF = [_ballQuene objectAtIndex:0];
        if (ballF.position.y < 0) {
            [_ballQuene removeObjectAtIndex:0];
            [ballF removeFromParent];
            ballF = nil;
        }
    }
    
}


//Creates the background
-(void)createBackground{
    [self createSpawners];
    
    self.backgroundColor = [UIColor colorWithRed:0 green:0.443 blue:0.737 alpha:1];
    SKSpriteNode * backui = [SKSpriteNode spriteNodeWithTexture:[_sceneAtlas textureNamed:@"background"]];
    backui.size = self.view.bounds.size;
    backui.position = CGPointMake(self.size.width/2, self.size.height/2);
    backui.zPosition = 2;
    [self addChild:backui];
    
    SKSpriteNode * box = [SKSpriteNode spriteNodeWithTexture:[_sceneAtlas textureNamed:@"backbox"]];
    box.size = CGSizeMake(box.size.width/2, box.size.height/2);
    box.position = CGPointMake(self.size.width/2, self.size.height/2);
    box.zPosition = 0;
    [self addChild:box];
}

//Creates thes spawners
-(void)createSpawners{
    
    _spawners = [NSMutableArray new];
    for (int i = 0; i < 10; i++) {
        Spawner * spawnerO = [[Spawner alloc] initWithLevel:0];
        
        float offsetX = (self.size.width - (spawnerO.size.width * 10))/11;
        float x = offsetX + ( spawnerO.size.width + offsetX )*i;
        
        spawnerO.position = CGPointMake(x, self.size.height);
        spawnerO.powerupProb = .5;
        [_spawners addObject:spawnerO];
    }
    
    
}

//Creates the side view with the
-(void)createSideView{
    _buyPanel = [StoreBuyPanel spriteNodeWithTexture:[_sceneAtlas textureNamed:@"itemsArea"]];
    _buyPanel.position = _sidePositions;
    _buyPanel.size = CGSizeMake(_buyPanel.size.width/2, _buyPanel.size.height/2);
    _buyPanel.zPosition = 3;
    _buyPanel.anchorPoint = CGPointMake(0, 0);
    _buyPanel.delegate = self;
    [_buyPanel createPanel];
    [self addChild:_buyPanel];
    
}

//Creates the back button
-(void)createBackButton{
    _backB = [ButtonNode spriteNodeWithTexture:[[[TextureLoader shareTextureLoader] buttonAtlas] textureNamed:@"backButton"]];
    _backB.position = _backButtonPosition;
    _backB.delegate = self;
    _backB.size = CGSizeMake(_backB.size.width/2, _backB.size.height/2);
    _backB.zPosition = 3;
    _backB.anchorPoint = CGPointMake(0.5, 0);
    _backB.userInteractionEnabled = YES;
    [_backB setImages:[[[TextureLoader shareTextureLoader] buttonAtlas] textureNamed:@"backButton"] pressedImage:[[[TextureLoader shareTextureLoader] buttonAtlas] textureNamed:@"backButton2"]];
    [self addChild:_backB];
}

//Creates the sell panel
-(void)createSellPanel:(int)powerType{
    
    [_buyPanel disableButtons];
    float xoffset = (self.size.width - _buyPanel.size.width - [_sceneAtlas textureNamed:@"sellItemArea"].size.width/2)/6;
    
    _initPointSellPanel = CGPointMake(self.size.width/2, 0);
    
    _sellItemP = [SellItemPanel spriteNodeWithTexture:[_sceneAtlas textureNamed:@"sellItemArea"]];
    _sellItemP.anchorPoint = CGPointMake(0, 0);
    _sellItemP.zPosition = 2;
    _sellItemP.size = CGSizeMake(_sellItemP.size.width/2, _sellItemP.size.height/2);
    _sellItemP.powerID = [self getPowerID: powerType];
    _sellItemP.position = _initPointSellPanel;
    [_sellItemP createPanel:powerType Validate:YES];
    _sellItemP.alpha = 0;
    
    
    SKAction * scaleDown = [SKAction scaleTo:0 duration:.1];
    
    SKAction * moveTo = [SKAction moveTo:CGPointMake(xoffset + _buyPanel.size.width, self.size.height/2 - [_sceneAtlas textureNamed:@"sellItemArea"].size.height/4) duration:.25];
    SKAction * scaleUp = [SKAction scaleTo:1 duration:.25];
    SKAction * fadin = [SKAction fadeAlphaTo:1 duration:.3];
    
    SKAction *group = [SKAction group:@[moveTo, scaleUp, fadin]];
    
    [_sellItemP runAction:scaleDown completion:^{
        
        [_sellItemP runAction:group completion:^{
            
            [_sellItemP createTextView: powerType];
            [_buyPanel enableButtons];
            
        }];
    }];
    
    [self addChild: _sellItemP];
    
}

-(NSString *)getPowerID: (int)powerType{
    switch (powerType) {
        case 1:
            return POWER_TYPE_1;
        case 2:
            return POWER_TYPE_2;
        case 3:
            return POWER_TYPE_3;
        case 4:
            return POWER_TYPE_4;
        case 5:
            return POWER_TYPE_5;
    }
    return @"null";
}

//Removes the sell panel
-(void)removeSellPanel{
    
    [_buyPanel disableButtons];
    [_sellItemP.textView removeFromSuperview];
    _sellItemP.textView = nil;
    
    SKAction * moveTo = [SKAction moveTo:_initPointSellPanel duration:.25];
    SKAction * scaleDown = [SKAction scaleTo:0 duration:.25];
    SKAction * fadeOut = [SKAction fadeAlphaTo:0 duration:.3];
    SKAction * group = [SKAction group:@[moveTo, scaleDown, fadeOut]];
    
    
    [_sellItemP runAction:group completion:^{
        
        [_sellItemP removeAllChildren];
        [_sellItemP removeAllActions];
        [_sellItemP removeFromParent];
        _sellItemP = nil;
        [_buyPanel enableButtons];
        
    }];
}

//Replaces the sell panel
-(void)replaceSellPanel: (int) powerType{
    if (powerType != _sellItemP.powerType) {
        [_buyPanel disableButtons];
        [_sellItemP.textView removeFromSuperview];
        _sellItemP.textView = nil;
        
        SKAction * moveTo = [SKAction moveTo:_initPointSellPanel duration:.25];
        SKAction * scaleDown = [SKAction scaleTo:0 duration:.25];
        SKAction * group = [SKAction group:@[moveTo, scaleDown]];
        
        
        [_sellItemP runAction:group completion:^{
            
            [_sellItemP removeAllChildren];
            [_sellItemP removeAllActions];
            [_sellItemP removeFromParent];
            _sellItemP = nil;
            [self createSellPanel:powerType];
            
        }];
        
    }else{
        [self removeSellPanel];
        _isSellCreated = NO;
    }
    
}

//Back button is pressed
-(void)buttonPressed:(ButtonType)type{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if (_isSellCreated) {
            [self removeSellPanel];
            _isSellCreated = NO;
        }else{
            [self.mdelegate storeBackPressed];
        }
    });
}

//Called when pbutton is pressed
-(void)pButtonPressed:(int)powerType{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if (!_isSellCreated) {
            
            [self createSellPanel:powerType];
            _isSellCreated = YES;
        }else{
            [self replaceSellPanel:powerType];
        }
    });
}

-(void)disableBack{
    _backB.userInteractionEnabled = NO;
    [_buyPanel disableButtons];
}

-(void)enableBack{
    _backB.userInteractionEnabled = YES;
    [_buyPanel enableButtons];
}

@end
