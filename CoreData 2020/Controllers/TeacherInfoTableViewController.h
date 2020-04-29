//
//  TeacherInfoTableViewController.h
//  CoreData 2020
//
//  Created by Dmitry Marchenko on 4/29/20.
//  Copyright © 2020 Dzmitry Marchanka. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class Teacher;

@interface TeacherInfoTableViewController : UITableViewController

@property (strong, nonatomic) Teacher *teacher;

@end

NS_ASSUME_NONNULL_END
