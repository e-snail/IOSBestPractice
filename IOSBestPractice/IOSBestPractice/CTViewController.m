//
//  CTViewController.m
//  IOSBestPractice
//
//  Created by 吴永波 on 16/1/3.
//  Copyright © 2016年 Wilbur.Wu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CTViewController.h"
#import "CTDisplayView.h"
#import "CTFrameParser.h"
#import "CTFrameParserConfig.h"
#import "CoreTextImageData.h"
#import "ImageViewController.h"

@interface CTViewController ()

@property (weak, nonatomic) IBOutlet CTDisplayView *ctView;

@end

@implementation CTViewController

- (void) viewDidLoad
{
    [super viewDidLoad];
    [self setupUserInterface];
    [self setupNotifications];
}

- (void) setupUserInterface {
    CTFrameParserConfig *configure = [[CTFrameParserConfig alloc] init];
    configure.width = self.ctView.width;
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"content" ofType:@"json"];
    CoreTextData *data = [CTFrameParser parseTemplateFile:path config:configure];
    
    self.ctView.backgroundColor = [UIColor whiteColor];
    self.ctView.data = data;
    self.ctView.height = data.height;
}

- (void) setupNotifications {
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void) imagePressed:(NSNotification *)notification {
    NSDictionary *userInfo = [notification userInfo];
    CoreTextImageData *imageData = userInfo[@"userInfo"];
    
    ImageViewController *vc = [[ImageViewController alloc] init];
    vc.image = [UIImage imageNamed:imageData.name];
    [self presentViewController:vc animated:YES completion:nil];
}

- (void) imageLinked:(NSNotification *)notification {
    
}

@end