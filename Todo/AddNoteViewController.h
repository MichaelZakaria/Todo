//
//  AddNoteViewController.h
//  Todo
//
//  Created by Marco on 2024-07-17.
//

#import <UIKit/UIKit.h>
#import "Note.h"

NS_ASSUME_NONNULL_BEGIN

@interface AddNoteViewController : UIViewController <UITextFieldDelegate, UITextViewDelegate>

@property NSInteger noteNumber;
@property Note *note;


@end

NS_ASSUME_NONNULL_END
