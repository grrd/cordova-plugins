//  Created by Jesse MacFadyen on 10-05-29.
//  Copyright 2010 Nitobi. All rights reserved.
//  Copyright 2012, Randy McMillan

#import "ChildBrowserCommand.h"
#import "Cordova/CDVViewController.h"



@implementation ChildBrowserCommand

@synthesize childBrowser;

- (void) showWebPage:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options // args: url, auth
{
    if(childBrowser == NULL)
    {
        childBrowser = [[ ChildBrowserViewController alloc ] initWithScale:FALSE ];
        childBrowser.delegate = self;
    }
    
    
    CDVViewController* cont = (CDVViewController*)[ super viewController ];
 
   [ cont presentModalViewController:childBrowser animated:YES ];
    
    NSMutableArray *arr = (NSMutableArray*) [arguments objectAtIndex:0];

    
    NSString *url = (NSString*) [arr objectAtIndex:0];
    NSString *auth = (NSString*) [arr objectAtIndex:1];
    
    [childBrowser loadURL:url withAuth:auth];
    
}

- (void) getPage:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options {
    NSString *url = (NSString*) [arguments objectAtIndex:0];
    [childBrowser loadURL:url  ];
}

-(void) close:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options // args: url
{
    [ childBrowser closeBrowser];

}

-(void) onClose
{
    NSString* jsCallback = [NSString stringWithFormat:@"window.plugins.childBrowser.onClose();",@""];
    [self.webView stringByEvaluatingJavaScriptFromString:jsCallback];
}

-(void) onOpenInSafari
{
    NSString* jsCallback = [NSString stringWithFormat:@"window.plugins.childBrowser.onOpenExternal();",@""];
    [self.webView stringByEvaluatingJavaScriptFromString:jsCallback];
}


-(void) onChildLocationChange:(NSString*)newLoc
{

    NSString* tempLoc = [NSString stringWithFormat:@"%@",newLoc];
    NSString* encUrl = [tempLoc stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    NSString* jsCallback = [NSString stringWithFormat:@"window.plugins.childBrowser.onLocationChange('%@');",encUrl];
    [self.webView stringByEvaluatingJavaScriptFromString:jsCallback];

}
@end
