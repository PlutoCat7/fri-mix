//
//  LMWordViewController.m
//  SimpleWord
//
//  Created by Chenly on 16/5/13.
//  Copyright © 2016年 Little Meaning. All rights reserved.
//

#import "LMWordViewController.h"
#import "LMWordView.h"
#import "LMSegmentedControl.h"
#import "LMStyleSettingsController.h"
#import "LMTextStyle.h"
#import "LMParagraphConfig.h"
#import "FindArticleImageTextAttachment.h"
#import "UIFont+LMText.h"
#import "LMTextHTMLParser.h"

#import "HXPhotoPicker.h"
#import "TOCropViewController.h"
#import "UIViewController+YHToast.h"
#import "UIImage+Resize.h"

@interface LMWordViewController () <
UITextViewDelegate,
UITextFieldDelegate,
LMSegmentedControlDelegate,
LMStyleSettingsControllerDelegate,
HXAlbumListViewControllerDelegate,
HXCustomCameraViewControllerDelegate,
TOCropViewControllerDelegate>

@property (nonatomic, assign) CGFloat keyboardSpacingHeight;
@property (nonatomic, strong) LMSegmentedControl *contentInputAccessoryView;

@property (nonatomic, readonly) UIStoryboard *lm_storyboard;
@property (nonatomic, strong) LMStyleSettingsController *styleSettingsViewController;


@property (nonatomic, strong) LMTextStyle *currentTextStyle;
@property (nonatomic, strong) LMParagraphConfig *currentParagraphConfig;

@end

@implementation LMWordViewController
{
    NSRange _lastSelectedRange;
    BOOL _keepCurrentTextStyle;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setCurrentParagraphConfig:[[LMParagraphConfig alloc] init]];
    [self setCurrentTextStyle:[LMTextStyle textStyleWithType:LMTextStyleFormatNormal]];
    
    _contentInputAccessoryView = [[LMSegmentedControl alloc] init];
    _contentInputAccessoryView.textStyle = self.currentTextStyle;
    _contentInputAccessoryView.delegate = self;
    
    _textView = [[LMWordView alloc] init];
    _textView.font = [UIFont systemFontOfSize:13.0f];
    _textView.delegate = self;
    _textView.titleTextField.delegate = self;
    [self.view addSubview:_textView];
    
    [self updateParagraphTypingAttributes];
    [self updateTextStyleTypingAttributes];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self layoutTextView];
    
    CGRect rect = self.view.bounds;
    rect.size.height = kLMSegmentedControlHeight;
    self.contentInputAccessoryView.frame = rect;
}

- (void)layoutTextView {
    CGRect rect = self.view.bounds;
    rect.origin.y = [self.topLayoutGuide length];
    rect.size.height -= rect.origin.y;
    self.textView.frame = rect;

    UIEdgeInsets insets = self.textView.contentInset;
    insets.bottom = self.keyboardSpacingHeight;
    self.textView.contentInset = insets;
}

#pragma mark - Keyboard

- (void)keyboardWillShow:(NSNotification *)notification {
    NSDictionary *info = [notification userInfo];
    CGSize keyboardSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    if (self.keyboardSpacingHeight == keyboardSize.height) {
        return;
    }
    self.keyboardSpacingHeight = keyboardSize.height;
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        [self layoutTextView];
    } completion:nil];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    
    if (self.keyboardSpacingHeight == 0) {
        return;
    }
    [self.contentInputAccessoryView clearUI];
    
    self.keyboardSpacingHeight = 0;
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        [self layoutTextView];
    } completion:nil];
}

#pragma mark - <UITextViewDelegate>

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField.text.length == 0) {
        textField.text = textField.placeholder;
    }
    self.textView.editable = NO;
    [textField resignFirstResponder];
    self.textView.editable = YES;
    return YES;
}

#pragma mark - <UITextViewDelegate>

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    //[self.contentInputAccessoryView setSelectedSegmentIndex:0 animated:NO];
    [self.contentInputAccessoryView clearUI];
    _textView.inputAccessoryView = self.contentInputAccessoryView;
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    
    _textView.inputAccessoryView = nil;
    return YES;
}

- (void)textViewDidChangeSelection:(UITextView *)textView {

    if (_lastSelectedRange.location != textView.selectedRange.location) {
        
        if (_keepCurrentTextStyle) {
            // 如果当前行的内容为空，TextView 会自动使用上一行的 typingAttributes，所以在删除内容时，保持 typingAttributes 不变
            [self updateTextStyleTypingAttributes];
            [self updateParagraphTypingAttributes];
            _keepCurrentTextStyle = NO;
        }
        else {
            self.currentTextStyle = [self textStyleForSelection];
            self.currentParagraphConfig = [self paragraphForSelection];
            [self updateTextStyleTypingAttributes];
            [self updateParagraphTypingAttributes];
            [self reloadSettingsView];
        }
    }
    _lastSelectedRange = textView.selectedRange;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {

    if (range.location == 0 && range.length == 0 && text.length == 0) {
        // 光标在第一个位置时，按下退格键，则删除段落设置
        self.currentParagraphConfig.indentLevel = 0;
        [self updateParagraphTypingAttributes];
    }
    _lastSelectedRange = NSMakeRange(range.location + text.length - range.length, 0);
    if (text.length == 0 && range.length > 0) {
        _keepCurrentTextStyle = YES;
    }
    return YES;
}

#pragma mark - Change InputView

- (UIStoryboard *)lm_storyboard {
    static dispatch_once_t onceToken;
    static UIStoryboard *storyboard;
    dispatch_once(&onceToken, ^{
        storyboard = [UIStoryboard storyboardWithName:@"LMWord" bundle:nil];
    });
    return storyboard;
}

- (LMStyleSettingsController *)styleSettingsViewController {
    if (!_styleSettingsViewController) {
        _styleSettingsViewController = [self.lm_storyboard instantiateViewControllerWithIdentifier:@"style"];
        _styleSettingsViewController.textStyle = self.currentTextStyle;
        _styleSettingsViewController.delegate = self;
    }
    return _styleSettingsViewController;
}

#pragma mark - settings

// 刷新设置界面
- (void)reloadSettingsView {
    
    self.styleSettingsViewController.textStyle = self.currentTextStyle;
    [self.styleSettingsViewController setParagraphConfig:self.currentParagraphConfig];
    [self.styleSettingsViewController reload];
}

- (LMTextStyle *)textStyleForSelection {
    
    LMTextStyle *textStyle = [[LMTextStyle alloc] init];
    UIFont *font = self.textView.typingAttributes[NSFontAttributeName];
    textStyle.bold = font.bold;
    textStyle.italic = font.italic;
    textStyle.fontSize = font.fontSize;
    textStyle.textColor = self.textView.typingAttributes[NSForegroundColorAttributeName] ?: textStyle.textColor;
    if (self.textView.typingAttributes[NSUnderlineStyleAttributeName]) {
        textStyle.underline = [self.textView.typingAttributes[NSUnderlineStyleAttributeName] integerValue] == NSUnderlineStyleSingle;
    }
    return textStyle;
}

- (LMParagraphConfig *)paragraphForSelection {
    
    NSParagraphStyle *paragraphStyle = self.textView.typingAttributes[NSParagraphStyleAttributeName];
    LMParagraphType type = [self.textView.typingAttributes[LMParagraphTypeName] integerValue];
    LMParagraphConfig *paragraphConfig = [[LMParagraphConfig alloc] initWithParagraphStyle:paragraphStyle type:type];
    return paragraphConfig;
}

// 获取所有选中的段落，通过"\n"来判断段落。
- (NSArray *)rangesOfParagraphForCurrentSelection {
    
    NSRange selection = self.textView.selectedRange;
    NSInteger location;
    NSInteger length;
    
    NSInteger start = 0;
    NSInteger end = selection.location;
    NSRange range = [self.textView.text rangeOfString:@"\n"
                                              options:NSBackwardsSearch
                                                range:NSMakeRange(start, end - start)];
    location = (range.location != NSNotFound) ? range.location + 1 : 0;
    
    start = selection.location + selection.length;
    end = self.textView.text.length;
    range = [self.textView.text rangeOfString:@"\n"
                                      options:0
                                        range:NSMakeRange(start, end - start)];
    length = (range.location != NSNotFound) ? (range.location + 1 - location) : (self.textView.text.length - location);
    
    range = NSMakeRange(location, length);
    NSString *textInRange = [self.textView.text substringWithRange:range];
    NSArray *components = [textInRange componentsSeparatedByString:@"\n"];
    
    NSMutableArray *ranges = [NSMutableArray array];
    for (NSInteger i = 0; i < components.count; i++) {
        NSString *component = components[i];
        if (i == components.count - 1) {
            if (component.length == 0) {
                break;
            }
            else {
                [ranges addObject:[NSValue valueWithRange:NSMakeRange(location, component.length)]];
            }
        }
        else {
            [ranges addObject:[NSValue valueWithRange:NSMakeRange(location, component.length + 1)]];
            location += component.length + 1;
        }
    }
    if (ranges.count == 0) {
        return nil;
    }
    return ranges;
}

- (void)updateTextStyleTypingAttributes {
    NSMutableDictionary *typingAttributes = [self.textView.typingAttributes mutableCopy];
    typingAttributes[NSFontAttributeName] = self.currentTextStyle.font;
    typingAttributes[NSForegroundColorAttributeName] = self.currentTextStyle.textColor;
    typingAttributes[NSUnderlineStyleAttributeName] = @(self.currentTextStyle.underline ? NSUnderlineStyleSingle : NSUnderlineStyleNone);
    self.textView.typingAttributes = typingAttributes;
}

- (void)updateParagraphTypingAttributes {
    NSMutableDictionary *typingAttributes = [self.textView.typingAttributes mutableCopy];
    typingAttributes[LMParagraphTypeName] = @(self.currentParagraphConfig.type);
    typingAttributes[NSParagraphStyleAttributeName] = self.currentParagraphConfig.paragraphStyle;
    self.textView.typingAttributes = typingAttributes;
}

- (void)updateTextStyleForSelection {
    if (self.textView.selectedRange.length > 0) {
        [self.textView.textStorage addAttributes:self.textView.typingAttributes range:self.textView.selectedRange];
    }
}

- (void)updateParagraphForSelectionWithKey:(NSString *)key {
    NSRange selectedRange = self.textView.selectedRange;
    NSArray *ranges = [self rangesOfParagraphForCurrentSelection];
    if (!ranges) {
        if (self.currentParagraphConfig.type == 0) {
            NSMutableDictionary *typingAttributes = [self.textView.typingAttributes mutableCopy];
            typingAttributes[NSParagraphStyleAttributeName] = self.currentParagraphConfig.paragraphStyle;
            self.textView.typingAttributes = typingAttributes;
            return;
        }
        ranges = @[[NSValue valueWithRange:NSMakeRange(0, 0)]];
    }
    NSInteger offset = 0;
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithAttributedString:self.textView.attributedText];
    for (NSValue *rangeValue in ranges) {
        
        NSRange range = NSMakeRange(rangeValue.rangeValue.location + offset, rangeValue.rangeValue.length);
        LMParagraphType type;
        if ([key isEqualToString:LMParagraphTypeName]) {
            
            type = self.currentParagraphConfig.type;
            if (self.currentParagraphConfig.type == LMParagraphTypeNone) {
                [attributedText deleteCharactersInRange:NSMakeRange(range.location, 1)];
                offset -= 1;
            }
            else {
                FindArticleImageTextAttachment *textAttachment = [FindArticleImageTextAttachment checkBoxAttachment];
                NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithAttributedString:[NSAttributedString attributedStringWithAttachment:textAttachment]];
                [attributedString addAttributes:self.textView.typingAttributes range:NSMakeRange(0, 1)];
                [attributedText insertAttributedString:attributedString atIndex:range.location];
                offset += 1;
            }
            //            switch (self.currentParagraphConfig.type) {
            //                case LMParagraphTypeNone:
            //
            //                    break;
            //                case LMParagraphTypeNone:
            //
            //                    break;
            //                case LMParagraphTypeNone:
            //
            //                    break;
            //                case LMParagraphTypeNone:
            //
            //                    break;
            //            }
        }
        else {
            [attributedText addAttribute:NSParagraphStyleAttributeName value:self.currentParagraphConfig.paragraphStyle range:range];
        }
    }
    if (offset > 0) {
        _keepCurrentTextStyle = YES;
        selectedRange = NSMakeRange(selectedRange.location + 1, selectedRange.length + offset - 1);
    }
    self.textView.allowsEditingTextAttributes = YES;
    self.textView.attributedText = attributedText;
    self.textView.allowsEditingTextAttributes = NO;
    self.textView.selectedRange = selectedRange;
}

- (FindArticleImageTextAttachment *)insertImage:(UIImage *)image {
    // textView 默认会有一些左右边距
    CGFloat width = CGRectGetWidth(self.textView.frame) - (self.textView.textContainerInset.left + self.textView.textContainerInset.right + 12.f);
    FindArticleImageTextAttachment *textAttachment = [FindArticleImageTextAttachment attachmentWithImage:image width:width];
    NSAttributedString *attachmentString = [NSAttributedString attributedStringWithAttachment:textAttachment];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"\n"];
    [attributedString insertAttributedString:attachmentString atIndex:0];
    if (_lastSelectedRange.location != 0 &&
        ![[self.textView.text substringWithRange:NSMakeRange(_lastSelectedRange.location - 1, 1)] isEqualToString:@"\n"]) {
        // 上一个字符不为"\n"则图片前添加一个换行 且 不是第一个位置
        [attributedString insertAttributedString:[[NSAttributedString alloc] initWithString:@"\n"] atIndex:0];
    }
    [attributedString addAttributes:self.textView.typingAttributes range:NSMakeRange(0, attributedString.length)];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setParagraphStyle:[NSParagraphStyle defaultParagraphStyle]];
    paragraphStyle.paragraphSpacingBefore = 8.f;
    paragraphStyle.paragraphSpacing = 8.f;
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, attributedString.length)];
    
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithAttributedString:self.textView.attributedText];
    [attributedText replaceCharactersInRange:_lastSelectedRange withAttributedString:attributedString];
    self.textView.allowsEditingTextAttributes = YES;
    self.textView.attributedText = attributedText;
    self.textView.allowsEditingTextAttributes = NO;
    
    return textAttachment;
}

#pragma mark - LMSegmentedControlDelegate

- (void)lm_segmentedControl:(LMSegmentedControl *)control didTapAtIndex:(NSInteger)index {
    
    if (index == control.numberOfSegments - 1) {  //收起键盘
        [self.textView resignFirstResponder];
        return;
    }
    switch (index) {
        case 0:   //插入照片
         {
             [self openPhoto];
         }
            break;
        case 3:   //插入分割线
        {
            [self uploadImage:[self imageLine]];
        }
            break;
        default:
            break;
    }
}

- (void)lm_segmentedControl:(LMSegmentedControl *)control didChangedTextStyle:(LMTextStyle *)textStyle {
    
    self.currentTextStyle = textStyle;
    [self updateTextStyleTypingAttributes];
    [self updateTextStyleForSelection];
}

- (void)openPhoto {
    
    HXPhotoManager *manager = [[HXPhotoManager alloc] initWithType:HXPhotoManagerSelectedTypePhoto];
    manager.configuration.openCamera = YES;
    manager.configuration.cellSelectedBgColor = [UIColor clearColor];
    manager.configuration.themeColor = kRKBNAVBLACK;
    manager.configuration.singleSelected = YES;//是否单选
    
    WEAKSELF
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:(UIAlertControllerStyleActionSheet)];
    UIAlertAction *takePhotoAction = [UIAlertAction actionWithTitle:@"拍照" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf hx_presentCustomCameraViewControllerWithManager:manager delegate:weakSelf];
    }];
    [takePhotoAction setValue:XWColorFromHex(0x606060) forKey:@"_titleTextColor"];
    UIAlertAction *ablumAction = [UIAlertAction actionWithTitle:@"相册" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf hx_presentAlbumListViewControllerWithManager:manager delegate:weakSelf];
    }];
    [ablumAction setValue:XWColorFromHex(0x606060) forKey:@"_titleTextColor"];
    
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:nil];
    [action2 setValue:XWColorFromHex(0x5186aa) forKey:@"_titleTextColor"];
    
    [alert addAction:takePhotoAction];
    [alert addAction:ablumAction];
    [alert addAction:action2];
    [self presentViewController:alert animated:YES completion:nil];
}

//上传图片
- (void)uploadImage:(UIImage *)image {
    
    [self showLoadingToast];
    NSData *imageData = UIImageCompress(image);
    [[TiHouse_NetAPIManager sharedManager] request_uploadFilesWithData:imageData completedUsing:^(NSString *data, NSError *error) {
        if (!error) {
            NSString *imageUrl = data.length > 0 ? [NSString stringWithFormat:@"/%@",data]:@"";
            [[TiHouseNetAPIClient sharedJsonClient] POST:@"api/outer/upload/getFullpath" parameters:@{@"pathhalf":imageUrl} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                [self dismissToast];
                FindArticleImageTextAttachment *attachment = [self insertImage:image];
                attachment.attachmentType = LMTextAttachmentTypeImage;
                attachment.imageUrl = [responseObject[@"data"] objectForKey:@"fullpath"];
                //[self.textView resignFirstResponder];
                [self.textView scrollRangeToVisible:_lastSelectedRange];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                [self dismissToast];
            }];
        }else {
            [self dismissToast];
        }
    }];

}

#pragma mark - <LMStyleSettingsControllerDelegate>

- (void)lm_didChangedTextStyle:(LMTextStyle *)textStyle {
    
    self.currentTextStyle = textStyle;
    [self updateTextStyleTypingAttributes];
    [self updateTextStyleForSelection];
}

- (void)lm_didChangedParagraphIndentLevel:(NSInteger)level {
    
    self.currentParagraphConfig.indentLevel += level;
    
    NSRange selectedRange = self.textView.selectedRange;
    NSArray *ranges = [self rangesOfParagraphForCurrentSelection];
    if (ranges.count <= 1) {
        [self updateParagraphForSelectionWithKey:LMParagraphIndentName];
    }
    else {
        self.textView.allowsEditingTextAttributes = YES;
        NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithAttributedString:self.textView.attributedText];
        for (NSValue *rangeValue in ranges) {
            NSRange range = rangeValue.rangeValue;
            self.textView.selectedRange = range;
            LMParagraphConfig *paragraphConfig = [self paragraphForSelection];
            paragraphConfig.indentLevel += level;
            [attributedText addAttribute:NSParagraphStyleAttributeName value:paragraphConfig.paragraphStyle range:range];
        }
        self.textView.attributedText = attributedText;
        self.textView.allowsEditingTextAttributes = NO;
        self.textView.selectedRange = selectedRange;
    }
    [self updateParagraphTypingAttributes];
}

- (void)lm_didChangedParagraphType:(NSInteger)type {
//    self.currentParagraphConfig.type = type;
//    
//    [self updateParagraphTypingAttributes];
//    [self updateParagraphForSelectionWithKey:LMParagraphTypeName];
}

#pragma mark - HXAlbumListViewControllerDelegate

- (void)albumListViewController:(HXAlbumListViewController *)albumListViewController didDoneAllList:(NSArray<HXPhotoModel *> *)allList photos:(NSArray<HXPhotoModel *> *)photoList videos:(NSArray<HXPhotoModel *> *)videoList original:(BOOL)original {
    
    if (photoList.count > 0) {
        HXPhotoModel *model = photoList.firstObject;
        UIImage *insertImage = model.previewPhoto;
        [self uploadImage:insertImage];
    }
}

#pragma mark - HXCustomCameraViewControllerDelegate

-(void)customCameraViewController:(HXCustomCameraViewController *)viewController didDone:(HXPhotoModel *)model{
    
    TOCropViewController *_cropController = [[TOCropViewController alloc] initWithCroppingStyle:TOCropViewCroppingStyleDefault image:model.previewPhoto];
    _cropController.aspectRatioLockEnabled= YES;
    _cropController.resetAspectRatioEnabled = NO;
    _cropController.delegate = self;
    _cropController.doneButtonTitle = @"完成";
    _cropController.cancelButtonTitle = @"取消";
    
    [self.navigationController pushViewController:_cropController animated:NO];
}

#pragma mark - TOCropViewControllerDelegate

- (void)cropViewController:(TOCropViewController *)cropViewController didCropToImage:(UIImage *)image withRect:(CGRect)cropRect angle:(NSInteger)angle
{
    [self.navigationController popViewControllerAnimated:YES];
    UIImage *insertImage = image;
    [self uploadImage:insertImage];
}

#pragma mark - export

- (NSString *)exportHTML {
    
    NSString *title = [NSString stringWithFormat:@"<h1 align=\"center\">%@</h1>", self.textView.titleTextField.text];
    NSString *content = [LMTextHTMLParser HTMLFromAttributedString:self.textView.attributedText];
    return [title stringByAppendingString:content];
}

- (NSString *)exportHTMLWithAttributedString:(NSAttributedString *)attributedString {
    
    NSString *content = [LMTextHTMLParser HTMLFromAttributedString:attributedString];
    return content;
}

- (UIImage *)imageLine {
    
    CGFloat width = CGRectGetWidth(self.textView.frame) - (self.textView.textContainerInset.left + self.textView.textContainerInset.right + 12.f);
    
    CGRect rect = CGRectMake(0.0f, 0.0f, width, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [[UIColor colorWithRGBHex:0xdbdbdb] CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end
