//
//  MKUserPerferenceTableViewController.m
//  MKImageReview
//
//  Created by DONLINKS on 16/9/23.
//  Copyright © 2016年 com.minstone. All rights reserved.
//

#import "MKUserPerferenceTableViewController.h"
#import "MKUserPerference.h"

@interface MKUserPerferenceTableViewController ()

@end

@implementation MKUserPerferenceTableViewController
{
    MKUserPerference *userPerference;
    
    __weak IBOutlet UISwitch *userPerferenceSwitch;
    __weak IBOutlet UISwitch *askBeforeDeleteSwitch;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    userPerference = [MKUserPerference instance];
    
    userPerferenceSwitch.on = userPerference.isSecrectModel;
    askBeforeDeleteSwitch.on = userPerference.isAskBeforeDelete;
}

- (IBAction)switchSecrectMode:(UISwitch *)sender {
    userPerference.isSecrectModel = sender.on;
}

- (IBAction)switchAskBeforDelete:(UISwitch *)sender {
    userPerference.isAskBeforeDelete = sender.on;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
