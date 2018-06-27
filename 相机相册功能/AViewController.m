//
//  AViewController.m
//  相机相册功能
//
//  Created by majianjie on 2018/6/26.
//  Copyright © 2018年 majianjie. All rights reserved.
//

#import "AViewController.h"
#import "MainVC.h"

@interface AViewController ()

@end

@implementation AViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];

    self.navigationController.navigationBar.hidden = YES;

}

- (IBAction)jump:(id)sender {

//    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:[ViewController new]];
//    [nav setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
//    [self presentViewController:nav animated:YES completion:nil];


//    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:[ViewController new]];
//    CATransition *animation = [CATransition animation];
//    animation.duration = 0.5;
//    animation.type = @"rippleEffect";
//    //可以改变subtype的类型
//    animation.subtype = kCATransitionFromLeft;
//    [self.view.window.layer addAnimation:animation forKey:nil];
//
//    [self presentViewController:nav animated:YES completion:nil];


    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:[MainVC new]];
    CATransition *animation = [CATransition animation];
    animation.duration = 1.0;
    // `linear', `easeIn', `easeOut' `easeInEaseOut' and `default'
    animation.timingFunction = [CAMediaTimingFunction functionWithName:@"linear"];
    animation.type = kCATransitionFade;
    //可以改变subtype的类型
    animation.subtype = kCATransitionFromLeft;
    [self.view.window.layer addAnimation:animation forKey:nil];
    [self presentViewController:nav animated:YES completion:nil];


//    [self presentViewController:[ViewController new] animated:YES completion:nil];

}



@end
