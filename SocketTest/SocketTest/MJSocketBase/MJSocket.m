//
//  MJSocket.m
//  SocketTest
//
//  Created by 马家俊 on 17/5/9.
//  Copyright © 2017年 MJJ. All rights reserved.
//

#import "MJSocket.h"
#import <sys/socket.h>
#import <sys/types.h>
#import <netinet/in.h>
#import <arpa/inet.h>

@interface MJSocket()
@property(nonatomic,assign) int clientSocket;
@end
@implementation MJSocket

+(instancetype)shareInstance
{
    static MJSocket* instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc]init];
        [instance initSocket];
        [instance pullMsg];
    });
    return instance;
}

-(void)initSocket
{
    if (_clientSocket != 0) {
        [self closeSocket];
        _clientSocket = 0;
    }
    //创建一个socket,返回值为Int。（注scoket其实就是Int类型）
    //第一个参数addressFamily IPv4(AF_INET) 或 IPv6(AF_INET6)。
    //第二个参数 type 表示 socket 的类型，通常是流stream(SOCK_STREAM) 或数据报文datagram(SOCK_DGRAM)
    //第三个参数 protocol 参数通常设置为0，以便让系统自动为选择我们合适的协议，对于 stream socket 来说会是 TCP 协议(IPPROTO_TCP)，而对于 datagram来说会是 UDP 协议(IPPROTO_UDP)。
    _clientSocket = socket(AF_INET, SOCK_STREAM, 0);
    
    const char* server_ip = "127.0.0.1";
    short server_port = 6969;
    if (ConnectToServer(_clientSocket, server_ip, server_port) == 0) {
        NSLog(@"Connect To Server Fail!");
        return;
    }
    
    NSLog(@"Connect To Server Success!");
    
    
    
}

static int ConnectToServer(int client_socket,const char* server_ip,unsigned short port)
{
    struct sockaddr_in sAddr = {0};
    sAddr.sin_len = sizeof(sAddr);
    //ipv4
    sAddr.sin_family = AF_INET;
    
    //inet_aton是一个改进的方法来将一个字符串IP地址转换为一个32位的网络序列IP地址
    //如果这个函数成功，函数的返回值非零，如果输入地址不正确则会返回零。
    inet_aton(server_ip,&sAddr.sin_addr);
    
    //htons是将整型变量从主机字节顺序转变成网络字节顺序，赋值端口号
    sAddr.sin_port=htons(port);
    
    //用scoket和服务端地址，发起连接。
    //客户端向特定网络地址的服务器发送连接请求，连接成功返回0，失败返回 -1。
    //注意：该接口调用会阻塞当前线程，直到服务器返回。
    if (connect(client_socket, (struct sockaddr*)&sAddr, sizeof(sAddr)) == 0) {
        return client_socket;
    }
    return 0;
    
}

#pragma mark - 新线程来接收消息

- (void)pullMsg
{
    NSThread *thread = [[NSThread alloc]initWithTarget:self selector:@selector(recieveAction) object:nil];
    [thread start];
}

#pragma mark - 对外逻辑

- (void)connectSocket
{
    [self initSocket];
}
- (void)closeSocket
{
    //关闭连接
    close(self.clientSocket);
}

//发送消息
- (void)sendMessage:(NSString *)msg
{
    
    const char *send_Message = [msg UTF8String];
    send(self.clientSocket,send_Message,strlen(send_Message)+1,0);
    
}

//收取服务端发送的消息
- (void)recieveAction{
    while (1) {
        char recv_Message[1024] = {0};
        recv(self.clientSocket, recv_Message, sizeof(recv_Message), 0);
        printf("%s\n",recv_Message);
    }
}

@end
