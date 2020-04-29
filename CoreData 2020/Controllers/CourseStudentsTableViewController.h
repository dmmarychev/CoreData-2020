//
//  CourseStudentsTableViewController.h
//  CoreData 2020
//
//  Created by Dmitry Marchenko on 4/28/20.
//  Copyright © 2020 Dzmitry Marchanka. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class CourseInfoTableViewController;
@class NSFetchedResultsController;
@class Course;


@interface CourseStudentsTableViewController : UITableViewController

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (weak, nonatomic) CourseInfoTableViewController *sourceController;
@property (strong, nonatomic) Course *course;

@end

NS_ASSUME_NONNULL_END
