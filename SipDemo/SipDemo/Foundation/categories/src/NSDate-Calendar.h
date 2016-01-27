//
//  NSDate-Calendar.h
//  Motivator
//
//  Created by Jon Maddox on 11/26/08.
//
//
//  NSCalendarDate does not exist in CocoaTouch on the iPhone. So I made this category to put 
//  a little of the support I needed from NSCalendarDate into NSDate
//
//
//  The MIT License
//  
//  Copyright (c) 2008 Mustache, Inc
//  
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//  
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//  
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

#include <UIKit/UIKit.h>

typedef NSDate NSCalendarDate;

@interface NSDate(Calendar)

  +(id)today;
  +(id)calendarDate;
  -(NSInteger)year;
  -(NSInteger)yearOfCommonEra;
  -(NSInteger)month;
  -(NSInteger)monthOfYear;
  -(NSInteger)day;
  -(NSInteger)dayOfYear;
  -(NSInteger)weekday;
  -(NSInteger)dayOfWeek;
  -(NSInteger)hourOfDay;
  -(NSInteger)minuteOfHour;
  -(NSDate *)firstDayOfCurrentMonth;
  -(NSDate *)firstDayOfCurrentWeek;
  -(NSDate *)dateByAddingYears:(NSInteger)years months:(NSInteger)months days:(NSInteger)days hours:(NSInteger)hours minutes:(NSInteger)minutes seconds:(NSInteger)seconds;

@end
