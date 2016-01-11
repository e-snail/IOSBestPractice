//
//  ImageViewController.m
//  IOSBestPractice
//
//  Created by 吴永波 on 16/1/8.
//  Copyright © 2016年 Wilbur.Wu. All rights reserved.
//

#import "ImageViewController.h"

@interface ImageViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation ImageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _imageView.image = self.image;
    [self adjustImageView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)adjustImageView {
    CGPoint center = self.imageView.center;
    CGFloat height = self.image.size.height * self.image.size.width / self.imageView.width;
    self.imageView.height = height;
    self.imageView.center = center;
}

- (IBAction)closeButtonClicked:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
