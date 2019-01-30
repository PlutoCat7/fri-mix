//
//  UIActionSheet+Blocks.m
//  Shibui
//
//  Created by Jiva DeVoe on 1/5/11.
//  Copyright 2011 Random Ideas, LLC. All rights reserved.
//

#import "UIActionSheet+Blocks.h"
#import <objc/runtime.h>


static NSString *RI_BUTTON_ASS_KEY = @"com.random-ideas.BUTTONS";


static DismissBlock _dismissBlock;
static CancelBlock _cancelBlock;


@implementation UIActionSheet (Blocks)


+(void) actionSheetWithTitle:(NSString*) title
                     buttons:(NSArray*) buttonTitles
                  showInView:(UIView*) view
                   onDismiss:(DismissBlock) dismissed                   
                    onCancel:(CancelBlock) cancelled
{    
    [UIActionSheet actionSheetWithTitle:title
                 destructiveButtonTitle:nil 
                                buttons:buttonTitles 
                             showInView:view 
                              onDismiss:dismissed 
                               onCancel:cancelled];
}

+ (void) actionSheetWithTitle:(NSString*) title
       destructiveButtonTitle:(NSString*) destructiveButtonTitle
                      buttons:(NSArray*) buttonTitles
                   showInView:(UIView*) view
                    onDismiss:(DismissBlock) dismissed                   
                     onCancel:(CancelBlock) cancelled
{
	[UIActionSheet actionSheetWithTitle:title
                 destructiveButtonTitle:destructiveButtonTitle
                                buttons:buttonTitles
                             showInView:view
                              onDismiss:dismissed
                               onCancel:cancelled
								  style:UIActionSheetStyleAutomatic
	 ];   
    
}

+ (void) actionSheetWithTitle:(NSString*) title
       destructiveButtonTitle:(NSString*) destructiveButtonTitle
                      buttons:(NSArray*) buttonTitles
                   showInView:(UIView*) view
                    onDismiss:(DismissBlock) dismissed
                     onCancel:(CancelBlock) cancelled
						style:(UIActionSheetStyle) style
{

    _cancelBlock  = [cancelled copy];
    
    _dismissBlock  = [dismissed copy];
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:title
                                                             delegate:(id)[self class]
                                                    cancelButtonTitle:nil
                                               destructiveButtonTitle:destructiveButtonTitle
                                                    otherButtonTitles:nil];
	
	actionSheet.actionSheetStyle = style;
    
    for(NSString* thisButtonTitle in buttonTitles)
        [actionSheet addButtonWithTitle:thisButtonTitle];
    
    [actionSheet addButtonWithTitle:LS(@"common.btn.cancel")];
    actionSheet.cancelButtonIndex = [buttonTitles count];
    
    if(destructiveButtonTitle)
        actionSheet.cancelButtonIndex ++;
    
	if (view)
	{
		if([view isKindOfClass:[UIView class]])
			[actionSheet showInView:view];
		
		if([view isKindOfClass:[UITabBar class]])
			[actionSheet showFromTabBar:(UITabBar*) view];
		
		if([view isKindOfClass:[UIBarButtonItem class]])
			[actionSheet showFromBarButtonItem:(UIBarButtonItem*) view animated:YES];
	}
	else
	{
		UIWindow* keyWnd = [UIApplication sharedApplication].keyWindow;
		if (!keyWnd)
		{
			keyWnd = [[UIApplication sharedApplication].windows objectAtIndex:0];
		}
		[actionSheet showInView:keyWnd];
	}
    
}

+(void)actionSheet:(UIActionSheet*) actionSheet didDismissWithButtonIndex:(NSInteger) buttonIndex
{
	if(buttonIndex == [actionSheet cancelButtonIndex]) {
        if (_cancelBlock) {
            _cancelBlock();
        }
	} else {
        if (_dismissBlock) {
            _dismissBlock(buttonIndex);
        }
    }
    

    _cancelBlock = nil;
    _dismissBlock = nil;
}


@end
