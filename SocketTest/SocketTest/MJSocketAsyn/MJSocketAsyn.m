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

+(instancetype)share
{
    static MJSocketAsyn* socketAsyn = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        socketAsyn = [[self alloc]init];
        [socketAsyn initSocket];
    });
    return socketAsyn;
}

-(void)initSocket
{
    gcdSocket = [[GCDAsyncSocket alloc]initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
}

-(BOOL)connect
{
    return [gcdSocket connectToHost:Khost onPort:Kport error:nil];
}

-(void)disConnect
{
    [gcdSocket disconnect];
}

-(void)sendMsg:(NSString *)msg
{
    NSData* data = [msg dataUsingEncoding:NSUTF8StringEncoding];
    [gcdSocket writeData:data withTimeout:-1 tag:110];
}

-(void)pullTheMsg
{
    //只会接受一次，需要不停调用
    [gcdSocket readDataWithTimeout:-1 tag:110];
}

-(void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port
{
     NSLog(@"连接成功,host:%@,port:%d",host,port);
    [self pullTheMsg];
    
    //心跳
}

//断开连接的时候调用
- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(nullable NSError *)err
{
    NSLog(@"断开连接,host:%@,port:%d",sock.localHost,sock.localPort);
    
    //断线重连
    
}

//写成功的回调
- (void)socket:(GCDAsyncSocket*)sock didWriteDataWithTag:(long)tag
{
    //    NSLog(@"写的回调,tag:%ld",tag);
}

//收到消息的回调
- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    
    NSString *msg = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"收到消息：%@",msg);
    
    [self pullTheMsg];
}

@end
