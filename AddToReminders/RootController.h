//
//  RootController.h
//  AddToReminders
//
//  Created by Harshad Dange on 22/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RootController : NSObject {
    NSDate *_reminderDate;
    NSDateFormatter *_dateFormatter;
    NSString *_priority;
    NSString *_reminderTitle;
}

@property (strong, nonatomic) IBOutlet NSTextField *inputField;
@property (strong, nonatomic) IBOutlet NSTextField *outputField;
@property (strong, nonatomic) IBOutlet NSMatrix *alarmMatrix;

- (IBAction)touchAdd:(id)sender;

@end
