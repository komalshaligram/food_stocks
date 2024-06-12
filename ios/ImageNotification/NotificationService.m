//
//  NotificationService.m
//  ImageNotification
//
//  Created by Komal Akhani on 05/06/24.
//

#import <UserNotifications/UserNotifications.h>

@interface NotificationService : UNNotificationServiceExtension
@property (nonatomic, copy) void (^contentHandler)(UNNotificationContent *);
@property (nonatomic, strong) UNMutableNotificationContent *bestAttemptContent;
@end

@implementation NotificationService

- (void)didReceiveNotificationRequest:(UNNotificationRequest *)request withContentHandler:(void (^)(UNNotificationContent * _Nonnull))contentHandler {
    self.contentHandler = contentHandler;
    self.bestAttemptContent = [request.content mutableCopy];
    
    NSString *attachmentURLAsString = self.bestAttemptContent.userInfo[@"image"];
    NSURL *attachmentURL = [NSURL URLWithString:attachmentURLAsString];
    
    if (attachmentURL) {
        [self downloadImageFromURL:attachmentURL withCompletionHandler:^(UNNotificationAttachment *attachment) {
            if (attachment) {
                self.bestAttemptContent.attachments = @[attachment];
                self.contentHandler(self.bestAttemptContent);
            }
        }];
    }
}

- (void)serviceExtensionTimeWillExpire {
    if (self.contentHandler && self.bestAttemptContent) {
        self.contentHandler(self.bestAttemptContent);
    }
}

- (void)downloadImageFromURL:(NSURL *)url withCompletionHandler:(void (^)(UNNotificationAttachment *))completionHandler {
    NSURLSessionDownloadTask *task = [[NSURLSession sharedSession] downloadTaskWithURL:url completionHandler:^(NSURL *downloadedURL, NSURLResponse *response, NSError *error) {
        if (downloadedURL) {
            NSURL *tempDirectoryURL = [NSURL fileURLWithPath:NSTemporaryDirectory()];
            NSString *uniqueURLEnding = [[NSProcessInfo processInfo] globallyUniqueString];
            NSURL *finalURL = [tempDirectoryURL URLByAppendingPathComponent:[uniqueURLEnding stringByAppendingString:@".jpg"]];
            
            NSError *moveError = nil;
            [[NSFileManager defaultManager] moveItemAtURL:downloadedURL toURL:finalURL error:&moveError];
            
            if (!moveError) {
                UNNotificationAttachment *attachment = [UNNotificationAttachment attachmentWithIdentifier:@"picture" URL:finalURL options:nil error:nil];
                completionHandler(attachment);
            } else {
                completionHandler(nil);
            }
        } else {
            completionHandler(nil);
        }
    }];
    [task resume];
}

@end

