//
//  TextureLoader.m
//  Rising Fall
//
//  Created by David Villarreal on 4/28/14.
//  Copyright (c) 2014 David Villarreal. All rights reserved.
//

#import "TextureLoader.h"




@implementation TextureLoader

-(id)init{
    
    if (self = [super init]) {
        
    }
    return self;
    
}

+(id)shareTextureLoader{
    
    static TextureLoader * textLoader = nil;
    @synchronized(self) {
        if (textLoader == nil){
            textLoader = [[self alloc] init];
        }
    }
    return textLoader;
    
}

-(void)selectScreenSize:(float) screenWidth Height: (float)screenHeight{

     NSLog(@"%f, %f",screenWidth, screenHeight);
    
    if(screenWidth >= 320 && screenHeight >= 480){
        _screenSizeAlt = @"XXS";
    }
    
    if(screenWidth >= 480 && screenHeight >= 800){
        _screenSizeAlt = @"XS";
    }

    if(screenWidth >= 640 && screenHeight >= 960){
        _screenSizeAlt = @"S";
    }

    if(screenWidth >= 750 && screenHeight >= 1200){
        _screenSizeAlt = @"M";
    }

    if(screenWidth >= 1080 && screenHeight >= 1700){
        _screenSizeAlt = @"H";
    }

//    if(screenWidth >= 1440 && screenHeight >= 2200){
//        _screenSizeAlt = @"XH";
//    }

    
    NSLog(@"%@",_screenSizeAlt);
   
    

    
}

-(SKTexture *)infoTexture:(int)level{
    return [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"Intro50%@", _screenSizeAlt]];
}

//Returns the atlas with all the social media art
-(SKTextureAtlas *)socialMediaAtlas{
    
  
    NSMutableString * path = [[NSMutableString alloc] initWithString:@"SocialMediaArt"];
    [path appendString:_screenSizeAlt];
    return [SKTextureAtlas atlasNamed:path];
}

//Returns the atlas with all the Start menu art
-(SKTextureAtlas *)startMenuAtlas{
    
    NSMutableString * path = [[NSMutableString alloc] initWithString:@"StartMenuArt"];
    [path appendString:_screenSizeAlt];
    return [SKTextureAtlas atlasNamed:path];

}

//Returns the atlas with all the level scene art
-(SKTextureAtlas *)levelSceneAtlas{
    
    NSMutableString * path = [[NSMutableString alloc] initWithString:@"LevelSceneArt"];
    [path appendString:_screenSizeAlt];
    return [SKTextureAtlas atlasNamed:path];
}

//Returns the atlas with all the gameplay art
-(SKTextureAtlas *)gameplayAtlas{
    NSMutableString * path = [[NSMutableString alloc] initWithString:@"GameplayArt"];
    [path appendString:_screenSizeAlt];
    return [SKTextureAtlas atlasNamed:path];

}

//Returns the atlas with all the balls ;)
-(SKTextureAtlas *)ballsAtlas{
    
    NSMutableString * path = [[NSMutableString alloc] initWithString:@"BallsArt"];
    [path appendString:_screenSizeAlt];
    return [SKTextureAtlas atlasNamed:path];

}


//Returns the power ball art atlas
-(SKTextureAtlas * )powerBallAtlas{
    NSMutableString * path = [[NSMutableString alloc] initWithString:@"PowerBallArt"];
    [path appendString:_screenSizeAlt];
    return [SKTextureAtlas atlasNamed:path];

}

//Bad ball art
-(SKTextureAtlas * )badBallAtlas{
    
    NSMutableString * path = [[NSMutableString alloc] initWithString:@"BadBallArt"];
    [path appendString:_screenSizeAlt];
    return [SKTextureAtlas atlasNamed:path];

}



//Returns the button atlas
-(SKTextureAtlas *)buttonAtlas{
    NSMutableString * path = [[NSMutableString alloc] initWithString:@"Buttons"];
    [path appendString:_screenSizeAlt];
    return [SKTextureAtlas atlasNamed:path];

}

//Returns the unmovable ball atlas
-(SKTextureAtlas *)unmovableBallAtlas{
    
    NSMutableString * path = [[NSMutableString alloc] initWithString:@"UnmovableBallArt"];
    [path appendString:_screenSizeAlt];
    return [SKTextureAtlas atlasNamed:path];
   

}

//Stores atlas
-(SKTextureAtlas *)storeAtlas{
    
    NSMutableString * path = [[NSMutableString alloc] initWithString:@"StoreArt"];
    [path appendString:_screenSizeAlt];
    return [SKTextureAtlas atlasNamed:path];

}

-(SKTextureAtlas *)itemsAtlas{
    
    
    NSMutableString * path = [[NSMutableString alloc] initWithString:@"StoreItems"];
    [path appendString:_screenSizeAlt];
    return [SKTextureAtlas atlasNamed:path];
 

}

-(SKTexture *)playAreaTexture:(int)height{
    NSMutableString * path = [[NSMutableString alloc] initWithFormat:@"playArea%d",height];
    [path appendString:_screenSizeAlt];
    return [SKTexture textureWithImageNamed:path];
}


-(SKTextureAtlas *)infoAtlas: (int)levelAt{
    return [SKTextureAtlas atlasNamed:[NSString stringWithFormat:@"Intro%d%@",levelAt,_screenSizeAlt]];
}


@end
