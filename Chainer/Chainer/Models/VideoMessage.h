//
//  VideoMessage.h
//  Chainer
//
//  Created by Apprentice on 11/11/14.
//  Copyright (c) 2014 DBC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface VideoMessage : NSManagedObject

@property (nonatomic, retain) NSDate * createdAt;
@property (nonatomic, retain) NSString * videoID;
@property (nonatomic, retain) NSNumber * senderID;
@property (nonatomic, retain) NSNumber * recipientID;
@property (nonatomic, retain) NSNumber * messageID;
@property (nonatomic, retain) NSNumber * replyToID;

@end
