//
//  BFSTimerextension.m
//  Rebate
//
//  Created by GCCHEN on 2017/5/16.
//  Copyright © 2017年 Rebate. All rights reserved.
//

#import "BFSTimerextension.h"

@interface BFSTimerextension()
  @property (nonatomic, strong) NSTimer                   *timer;
@end

@implementation BFSTimerextension

-(void)dealloc
{
    HenLog(@"它被释放了");
}
-(void)startTimer:(NSTimeInterval)timeInterval repeats:(BOOL)repeats
{
   if(!_timer)
   {
       _timer = [NSTimer scheduledTimerWithTimeInterval:timeInterval target:self selector:@selector(timerSelectCall) userInfo:nil repeats:repeats];
   }
}

-(void)timerSelectCall
{
   if(self.delegate && [self.delegate respondsToSelector:@selector(timerfucntionCall)])
   {
       [self.delegate timerfucntionCall];
   }else{
       [self.timer invalidate];
       self.timer = nil;
   }
}

-(void)stopTimer
{
   if(self.timer)
   {
       [self.timer invalidate];
       self.timer = nil;
   }
}
@end
