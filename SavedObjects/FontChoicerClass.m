//
//  FontChoicerClass.m
//  Rising Fall
//
//  Created by David Villarreal on 7/22/14.
//  Copyright (c) 2014 David Villarreal. All rights reserved.
//

#import "FontChoicerClass.h"

@implementation FontChoicerClass


-(id)init{
    
    if (self = [super init]) {
        
        NSString * screenID = [[TextureLoader shareTextureLoader] screenSizeAlt];
        
        _XXS = [screenID isEqualToString:@"XXS"];
        _XS = [screenID isEqualToString:@"XS"];
        _S = [screenID isEqualToString:@"S"];
        _M = [screenID isEqualToString:@"M"];
        _H = [screenID isEqualToString:@"H"];
        _XH = [screenID isEqualToString:@"XH"];
        
    }
    return self;
    
}

//Share class throughtout the app
+(id)shareFontChoicer{
    
    static FontChoicerClass * fontC = nil;
    @synchronized(self) {
        if (fontC == nil){
            fontC= [[self alloc] init];
            
        }
    }
    return fontC;
    
}

-(float)fontPopEffect{
 
        if (_XXS) {
            return 8;
        }else if(_XS){
            return 11;
        }else if(_S){
            return 15;
        }else if(_M){
            return 19;
        }else if(_H){
            return 25;
        }else if(_XH){
            
        }
        return 14;
    
}

-(float)fontPowerTime{
    if (_XXS) {
        return 4;
    }else if(_XS){
        return 8;
    }else if(_S){
        return 11;
    }else if(_M){
        return 15;
    }else if(_H){
        return 19;
    }else if(_XH){
        
    }
    return 11;
}

-(float)fontButtonL{
    
    if (_XXS) {
        return 7;
    }else if(_XS){
        return 10;
    }else if(_S){
        return 14;
    }else if(_M){
        return 18;
    }else if(_H){
        return 24;
    }else if(_XH){
        
    }
   
    
    return 0;
}

-(float)fontButtonS{
    
    if (_XXS) {
        return 7;
    }else if(_XS){
        return 10;
    }else if(_S){
        return 14;
    }else if(_M){
        return 18;
    }else if(_H){
        return 24;
    }else if(_XH){
        
    }

   return 0;
}

-(float)fontGameOver{
    if (_XXS) {
        return 10;
    }else if(_XS){
        return 15;
    }else if(_S){
        return 20;
    }else if(_M){
        return 25;
    }else if(_H){
        return 33;
    }else if(_XH){
        
    }

    return 0;
}

-(float)fontGameplayLevelID{
    if (_XXS) {
        return 9;
    }else if(_XS){
        return 14;
    }else if(_S){
        return 18;
    }else if(_M){
        return 24;
    }else if(_H){
        return 30;
    }else if(_XH){
        
    }

    return 0;
}

-(float)fontGameWon{
    if (_XXS) {
        return 10;
    }else if(_XS){
        return 15;
    }else if(_S){
        return 20;
    }else if(_M){
        return 25;
    }else if(_H){
        return 33;
    }else if(_XH){
        
    }

    return 0;
}

-(float)fontIntroText{
    if (_XXS) {
        return 6.5;
    }else if(_XS){
        return 9.5;
    }else if(_S){
        return 13;
    }else if(_M){
        return 18;
    }else if(_H){
        return 24;
    }else if(_XH){
        
    }

    return 0;
}

-(float)fontKeepPlaying{
    if (_XXS) {
        return 10;
    }else if(_XS){
        return 15;
    }else if(_S){
        return 20;
    }else if(_M){
        return 25;
    }else if(_H){
        return 33;
    }else if(_XH){
        
    }

    return 0;
}

-(float)fontLifePanelLifes{
    if (_XXS) {
        return 9.5;
    }else if(_XS){
        return 15;
    }else if(_S){
        return 19;
    }else if(_M){
        return 24;
    }else if(_H){
        return 30;
    }else if(_XH){
        
    }

    return 0;
}

-(float)fontLifePanelTime{
    if (_XXS) {
        return 9.5;
    }else if(_XS){
        return 15;
    }else if(_S){
        return 19;
    }else if(_M){
        return 24;
    }else if(_H){
        return 30;
    }else if(_XH){
        
    }

    return 0;
}

-(float)fontLifePanelTitle{
    if (_XXS) {
        return 9.5;
    }else if(_XS){
        return 15;
    }else if(_S){
        return 19;
    }else if(_M){
        return 24;
    }else if(_H){
        return 30;
    }else if(_XH){
        
    }

    return 0;
}

-(float)fontPowerNoti{
    if (_XXS) {
        return 5.5;
    }else if(_XS){
        return 8;
    }else if(_S){
        return 11;
    }else if(_M){
        return 13.5;
    }else if(_H){
        return 20;
    }else if(_XH){
        
    }

    return 0;
}

-(float)fontScorePanel{
    if (_XXS) {
        return 8;
    }else if(_XS){
        return 12;
    }else if(_S){
        return 16;
    }else if(_M){
        return 20;
    }else if(_H){
        return 26;
    }else if(_XH){
        
    }

        return 0;
}

-(float)fontStoreInfo{
    if (_XXS) {
        return 8.5 - 3;
    }else if(_XS){
        return 13 - 3;
    }else if(_S){
        return 17- 3;
    }else if(_M){
        return 23- 3;
    }else if(_H){
        return 29- 3;
    }else if(_XH){
        
    }

    return 0;
}

-(float)fontStoreTitle{
    if (_XXS) {
        return 7.5;
    }else if(_XS){
        return 11;
    }else if(_S){
        return 15;
    }else if(_M){
        return 21;
    }else if(_H){
        return 27;
    }else if(_XH){
        
    }

    return 0;
}

-(float)fontLevelButton{
    if (_XXS) {
        return 7;
    }else if(_XS){
        return 10;
    }else if(_S){
        return 14;
    }else if(_M){
        return 18;
    }else if(_H){
        return 24;
    }else if(_XH){
        
    }

    return 0;
}

-(float)fontObjectivePanel{
    if (_XXS) {
        return 8;
    }else if(_XS){
        return 12;
    }else if(_S){
        return 16;
    }else if(_M){
        return 20;
    }else if(_H){
        return 26;
    }else if(_XH){
        
    }

    return 0;
}





@end
