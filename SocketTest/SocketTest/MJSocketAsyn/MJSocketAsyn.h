//
//  MJSocketAsyn.h
//  SocketTest
//
//  Created by 马家俊 on 17/5/10.
//  Copyright © 2017年 MJJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MJSocketAsyn : NSObject

+ (instancetype)share;

- (BOOL)connect;
- (void)disConnect;

- (void)sendMsg:(NSString *)msg;
- (void)pullTheMsg;

@end
