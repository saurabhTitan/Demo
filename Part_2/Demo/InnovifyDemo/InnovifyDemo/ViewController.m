//
//  ViewController.m
//  InnovifyDemo
//
//  Created by Saurabh Vaza on 21/11/17.
//  Copyright © 2017 Saurabh. All rights reserved.
//

#import "ViewController.h"
#import "MainVCViewController.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)loadView{
    NSLog(@"%s",__FUNCTION__);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSLog(@"%s",__FUNCTION__);

}

- (void)viewWillAppear:(BOOL)animated{
    NSLog(@"%s",__FUNCTION__);
    

    @try {
        <#Code that can potentially throw an exception#>
    } @catch (NSException *exception) {
        NSLog(@"Class:: %s Exception :: %@",__func__,exception.description);
    } @finally {
        
    }
    
}

- (void)viewDidAppear:(BOOL)animated{
    NSLog(@"%s",__FUNCTION__);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
