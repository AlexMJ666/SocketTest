//
//  MJSocketAsyn.m
//  SocketTest
//
//  Created by 马家俊 on 17/5/10.
//  Copyright © 2017年 MJJ. All rights reserved.
//

#import "MJSocketAsyn.h"
#import <GCDAsyncSocket.h>

static  NSString * Khost = @"127.0.0.1";
static const uint16_t Kport = 6969;

@interface MJSocketAsyn()<GCDAsyncSocketDelegate>
{
    GCDAsyncSocket *gcdSocket;
}

@end

@implementation MJSocketAsyn

@end
