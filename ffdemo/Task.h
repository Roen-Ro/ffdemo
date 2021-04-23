//
//  Task.h
//  llfstr
//
//  Created by 罗亮富 on 2021/4/14.
//  Copyright © 2021 roen. All rights reserved.
//

#ifndef Task_h
#define Task_h
#include <stdio.h>
#import <Foundation/Foundation.h>


//return the full path from a relative path
extern NSString * resolvePath(NSString * _Nonnull path);

/**
 调用命令行执行任务
 @param launchPath 命令路径,可以用which指令查询
 @param arguments 命令参数
 @param logPath nullable 执行命令的日志文件输出路径
 @param log 是否在控制台打印执行日志
 @return 执行成功返回nil，失败返回错误信息
 */
extern NSError * _Nullable taskExc1(NSString * _Nonnull launchPath, NSArray <NSString *>* _Nullable arguments, NSString  * _Nullable logPath, BOOL log);

/**
 执行ffmpeg命令
 @param cmd ffmpeg命令 例如 @"ffmpeg -i sample.mp4 -a:copy .... sample.mp3"
 @param logPath 输出值，用于接收执行命令过程中生成的日志文件路径
 */
extern NSError * _Nullable ffmpegExc(NSString * _Nonnull cmd, NSString * _Nullable logPath);

/**
 //从输入的命令行中解析出命令参数
 */
extern NSArray<NSString *>* _Nonnull argumentsFromCoommandInput(NSString * _Nonnull input);

#endif /* Task_h */
