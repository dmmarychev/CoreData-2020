//
//  FRCTableViewController.h
//  CoreData 2020
//
//  Created by Dmitry Marchenko on 4/29/20.
//  Copyright © 2020 Dzmitry Marchanka. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class NSFetchedResultsController;

@interface FRCTableViewController : UITableViewController 

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

@end

NS_ASSUME_NONNULL_END
