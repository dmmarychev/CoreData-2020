//
//  CoreDataManager.h
//  CoreData 2020
//
//  Created by Dmitry Marchenko on 4/26/20.
//  Copyright © 2020 Dzmitry Marchanka. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class NSPersistentContainer;

@interface CoreDataManager : NSObject

@property (readonly, strong) NSPersistentContainer *persistentContainer;

+ (CoreDataManager *)sharedManager;
- (void)saveContext;

@end

NS_ASSUME_NONNULL_END
