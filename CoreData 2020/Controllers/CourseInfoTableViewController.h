//
//  CourseInfoTableViewController.h
//  CoreData 2020
//
//  Created by Dmitry Marchenko on 4/28/20.
//  Copyright © 2020 Dzmitry Marchanka. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class Course;

@interface CourseInfoTableViewController : UITableViewController

@property (strong, nonatomic) Course *course;

@end

NS_ASSUME_NONNULL_END
