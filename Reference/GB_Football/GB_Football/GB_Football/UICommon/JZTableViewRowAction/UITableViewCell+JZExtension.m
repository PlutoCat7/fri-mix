//
//  UITableViewCell+JZTableViewRowAction.m
//  tableView
//
//  Created by Jazys on 10/23/15.
//  Copyright © 2015 Jazys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <objc/runtime.h>
#import "UITableViewRowAction+JZExtension.h"

@implementation UITableViewCell (JZExtension)

+ (void)load {
    [super load];
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Method willTransitionToState = class_getInstanceMethod(self, @selector(willTransitionToState:));
        Method __willTransitionToState = class_getInstanceMethod(self, @selector(__willTransitionToState:));
        method_exchangeImplementations(willTransitionToState, __willTransitionToState);
    });
}

- (void)__willTransitionToState:(UITableViewCellStateMask)state {
    
    [self __willTransitionToState:state];

    if (state == UITableViewCellStateShowingDeleteConfirmationMask) {
        
        UITableView *tableView = [self valueForKey:@"_tableView"];
        if (![tableView.delegate respondsToSelector:@selector(tableView:editActionsForRowAtIndexPath:)]) {
            return;
        }

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.001 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

            UIView *swipeToDeleteConfirmationView = [self valueForKey:@"_swipeToDeleteConfirmationView"];
            if ([[[UIDevice currentDevice] systemVersion] compare:@"8.0" options:NSNumericSearch] != NSOrderedAscending) {
                for (UIButton *deleteButton in swipeToDeleteConfirmationView.subviews) {
                    
                    UITableViewRowAction *rowAction = [deleteButton valueForKey:@"_action"];
                    if (rowAction.backgroundColor) {
                        deleteButton.backgroundColor = rowAction.backgroundColor;
                        deleteButton.titleLabel.font = [UIFont systemFontOfSize:([UIScreen mainScreen].bounds.size.width*1.0/375)*15.f];
//                        deleteButton.transform = CGAffineTransformMakeTranslation(0, -2);
                    }
                    deleteButton.enabled = rowAction.enabled;

                    if (rowAction.image) {
                        NSTextAttachment *imageAtt = [[NSTextAttachment alloc] init];
                        imageAtt.image = rowAction.image;
                        [deleteButton setAttributedTitle:[NSAttributedString attributedStringWithAttachment:imageAtt] forState:UIControlStateNormal];
                    }
                }
                return;
            }
            
            NSIndexPath *indexPath = [tableView indexPathForCell:self];
            
            NSArray *rowActions = [tableView.delegate tableView:tableView editActionsForRowAtIndexPath:indexPath];
            self.rowActions = rowActions;
            
            UIButton *deleteConfirmButton = swipeToDeleteConfirmationView.subviews.firstObject;
            deleteConfirmButton.titleLabel.textColor = deleteConfirmButton.backgroundColor;
            CGFloat buttonWidth = deleteConfirmButton.bounds.size.width / rowActions.count;
            CGFloat buttonHeight = deleteConfirmButton.bounds.size.height;
            for (NSInteger index = 0; index < rowActions.count; index++) {
                
                UITableViewRowAction *rowAction = rowActions[index];
                
                [rowAction setValue:indexPath forKey:@"indexPath"];
                
                UIButton *rowActionButton = [UIButton buttonWithType:UIButtonTypeCustom];
                
                if (rowAction.backgroundColor) {
                    rowActionButton.backgroundColor = rowAction.backgroundColor;
                } else {
                    rowActionButton.backgroundColor = rowAction.style == UITableViewRowActionStyleDestructive ? deleteConfirmButton.backgroundColor : [UIColor colorWithRed:187.0/255.0 green:187.0/255.0 blue:193.0/255.0 alpha:1.0];
                }
                
                if (rowAction.enabled) {
                    [rowActionButton addTarget:rowAction action:NSSelectorFromString(@"actionTriggered:") forControlEvents:UIControlEventTouchUpInside];
                }
                
                rowActionButton.frame = CGRectMake((rowActions.count - 1 - index) * buttonWidth, 0, buttonWidth, buttonHeight);
                if(rowAction.image)
                {
                    rowActionButton.backgroundColor =  [UIColor colorWithRed:0x90/255.0 green:0./255.0 blue:0./255.0 alpha:1.0];
                }
                rowAction.image ? [rowActionButton setBackgroundImage:rowAction.image forState:UIControlStateNormal]
                                : [rowActionButton setTitle:rowAction.title forState:UIControlStateNormal];
                
                [deleteConfirmButton addSubview:rowActionButton];
            }
        });
    }
}

- (void)setRowActions:(NSArray *)rowActions {
    objc_setAssociatedObject(self, @selector(rowActions), rowActions, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSArray *)rowActions {
    return objc_getAssociatedObject(self, _cmd);
}

@end
