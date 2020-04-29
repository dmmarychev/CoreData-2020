//
//  CourseTeacherTableViewController.h
//  CoreData 2020
//
//  Created by Dmitry Marchenko on 4/29/20.
//  Copyright © 2020 Dzmitry Marchanka. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FRCTableViewController.h"

NS_ASSUME_NONNULL_BEGIN

@class TeacherInfoTableViewController;
@class Course;

@interface CourseTeacherTableViewController : FRCTableViewController

@property (weak, nonatomic) TeacherInfoTableViewController *sourceController;
@property (strong, nonatomic) Course *course;

@end

NS_ASSUME_NONNULL_END
