//
//  Course+CoreDataClass.h
//  CoreData 2020
//
//  Created by Dmitry Marchenko on 4/29/20.
//  Copyright © 2020 Dzmitry Marchanka. All rights reserved.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Student, Teacher;

NS_ASSUME_NONNULL_BEGIN

@interface Course : NSManagedObject

@end

NS_ASSUME_NONNULL_END

#import "Course+CoreDataProperties.h"
