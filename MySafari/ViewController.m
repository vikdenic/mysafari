//
//  ViewController.m
//  MySafari
//
//  Created by Vik Denic on 5/14/14.
//  Copyright (c) 2014 Mobile Makers. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UIWebViewDelegate, UIAlertViewDelegate, UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *myWebView;
@property (weak, nonatomic) IBOutlet UITextField *myURLTextField;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIButton *forwardButton;
@property (weak, nonatomic) IBOutlet UIView *buttonView;
@property (assign,nonatomic) CGFloat locationSnapshot;
@property (weak, nonatomic) IBOutlet UINavigationItem *navTitle;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.myWebView.scrollView.delegate = self;
//    NSString *urlString = @"http://www.mobilemakers.co";
//    NSURL *url = [NSURL URLWithString:urlString];
//    NSURLRequest *requestHome = [NSURLRequest requestWithURL:url];
//    [self.myWebView loadRequest:requestHome];

    [self.backButton setEnabled:NO];
    [self.forwardButton setEnabled:NO];

    self.navTitle.title = @"Hello";

}

-(BOOL)textFieldShouldReturn:(UITextField *)textField

{
    NSURL *url = [NSURL URLWithString:self.myURLTextField.text];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
//    [self.myWebView loadRequest:request];

    NSString *inputString = self.myURLTextField.text;
    NSString *outputString = [NSString stringWithFormat:@"http://%@",inputString];
    NSURL *url2 = [NSURL URLWithString:outputString];
    NSURLRequest *request2 = [NSURLRequest requestWithURL:url2];

    if([inputString hasPrefix:@"http://"]){
        [self.myWebView loadRequest:request];

    }

    else {
        [self.myWebView loadRequest:request2];
    }




    //dismisses keyboard
    [textField restorationIdentifier];

    return YES;
}

- (IBAction)onBackButtonPressed:(id)sender {

    [self.myWebView goBack];

}

- (IBAction)onForwardButtonPressed:(id)sender {

    [self.myWebView goForward];

}
- (IBAction)onStopLoadingButtonPressed:(id)sender {
    [self.myWebView stopLoading];

}
- (IBAction)onReloadButtonPressed:(id)sender {
    [self.myWebView reload];
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    self.backButton.enabled = self.myWebView.canGoBack;
    self.forwardButton.enabled = self.myWebView.canGoForward;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {

     NSString *currentURL = webView.request.URL.absoluteString;

    self.myURLTextField.text = currentURL;

    if ([self.myWebView canGoBack])
    {
        [self.backButton setEnabled:YES];
    }
    else{
        [self.backButton setEnabled:NO];
    }

    if ([self.myWebView canGoForward])
    {
        [self.forwardButton setEnabled:YES];
    }
    else{
        [self.forwardButton setEnabled:NO];
    }

    NSString *theTitle = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    self.navTitle.title = theTitle;


}
- (IBAction)onFeatureButtonPressed:(id)sender {
    UIAlertView *alert =[[UIAlertView alloc] init];
    alert.title = @"Coming Soon!";
    [alert addButtonWithTitle:@"Okay"];
    alert.delegate = self;
    [alert show];

}



-(void)scrollViewDidScroll:(UIScrollView *)scrollView{

    NSLog(@"%f LOCATIONSNAPSHOT",self.locationSnapshot);
    NSLog(@"%f CURRENTLOCATION",self.myWebView.scrollView.contentOffset.y);



    if (self.locationSnapshot < self.myWebView.scrollView.contentOffset.y)
    {
        self.myURLTextField.hidden = YES;

    }

    else if(self.locationSnapshot > self.myWebView.scrollView.contentOffset.y){
        self.myURLTextField.hidden = NO;

    }

}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    self.locationSnapshot = self.myWebView.scrollView.contentOffset.y;
    NSLog(@"%f WHAT AM I",self.locationSnapshot);
}

@end
