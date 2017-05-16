//
//  ViewController.m
//  SocketTest
//
//  Created by 马家俊 on 17/5/9.
//  Copyright © 2017年 MJJ. All rights reserved.
//

#import "ViewController.h"
#import "MJSocket.h"
#import "MJSocketAsyn.h"
@interface ViewController ()
@property(nonatomic,strong) IBOutlet UITextField* textfield;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   // [MJSocket shareInstance];
    [MJSocketAsyn share];
    [[MJSocketAsyn share]connect];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)send:(id)sender
{
   // [[MJSocket shareInstance] sendMessage:_textfield.text];
    [[MJSocketAsyn share]sendMsg:_textfield.text];
}
@end
