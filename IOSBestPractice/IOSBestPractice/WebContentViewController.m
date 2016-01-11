//
//  WebContentViewController.m
//  IOSBestPractice
//
//  Created by 吴永波 on 16/1/8.
//  Copyright © 2016年 Wilbur.Wu. All rights reserved.
//

#import "WebContentViewController.h"

@interface WebContentViewController () <UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIWebView *contentWebview;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingIdicator;

@end

@implementation WebContentViewController

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _titleLabel.text = self.urlTitle;
    _contentWebview.delegate = self;
    
    NSURLRequest *request = [NSURLRequest requestWithURL: [NSURL URLWithString:self.url ]];
    [_contentWebview loadRequest:request];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)closeButtonClicked:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

# pragma mark - UIWebView Delegate
- (void)webViewDidStartLoad:(UIWebView *)webView {
    [_loadingIdicator startAnimating];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [_loadingIdicator stopAnimating];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [_loadingIdicator stopAnimating];
}

@end
