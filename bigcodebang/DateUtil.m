//
//  DateUtil.m
//  bigcodebang
//
//  Created by nelson on 14-8-6.
//  Copyright (c) 2014年 bigcodebang. All rights reserved.
//

#import "DateUtil.h"

@implementation DateUtil
+(long) getCurrentDateTime{
    return [[NSDate date] timeIntervalSince1970];
}
+(long) getCurrentHour
{
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:now];
    return [dateComponent hour];
}
@end
