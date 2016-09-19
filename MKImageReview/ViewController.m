//
//  ViewController.m
//  MKImageReview
//
//  Created by Liujh on 16/3/11.
//  Copyright © 2016年 com.minstone. All rights reserved.
//

#import "ViewController.h"
#import "MKDocViewController.h"

@interface ViewController ()

@end

@implementation ViewController
- (void)viewDidLoad {
    [super viewDidLoad];

}
- (IBAction)goSandBox:(id)sender {
    [self.navigationController pushViewController: [MKDocViewController new] animated: YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
