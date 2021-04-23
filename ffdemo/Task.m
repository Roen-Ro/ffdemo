//
//  ffmpegTask.c
//  tingleetool
//
//  Created by 罗亮富 on 2021/4/12.
//  Copyright © 2021 roen. All rights reserved.
//

#include <stdio.h>
#import "Task.h"
/**
 调用命令行执行任务
 @param launchPath 命令路径,可以用which指令查询
 @param arguments 命令参数
 @param logPath nullable 执行命令的日志文件输出路径
 @param log 是否在控制台打印执行日志
 @return 执行成功返回nil，失败返回错误信息
 */
NSError * taskExc1(NSString *launchPath, NSArray <NSString *>*arguments, NSString  * _Nullable logPath, BOOL log) {
    
    
    NSTask *task = [NSTask new];
    if (@available(macOS 10.13, *)) {
        task.executableURL = [NSURL fileURLWithPath:launchPath];
    } else {
        task.launchPath = launchPath;
    }

    //将命令名称本身从参数中移除
    if([arguments.firstObject.lowercaseString isEqualToString:[launchPath lastPathComponent].lowercaseString]) {
        task.arguments = [arguments subarrayWithRange:NSMakeRange(1, arguments.count-1)];
    }
    else
        task.arguments = arguments;
   
//    task.terminationHandler = ^(NSTask *tsk) {
//        printf("Task terminatted with reason %ld\n",(long)tsk.terminationReason);
//    };
    
    
    NSPipe *outputPipe = [NSPipe pipe];
    task.standardOutput = outputPipe;
    task.standardError = outputPipe;
    
    NSFileHandle *readHandle = [outputPipe fileHandleForReading];
    //定义log输出文件
    NSFileHandle *wh = nil;
    if(logPath) {
        //如果文件不存在则创建文件
        [NSFileManager.defaultManager createFileAtPath:logPath contents:nil attributes:nil];
        wh = [NSFileHandle fileHandleForWritingAtPath:logPath];
        [wh truncateFileAtOffset:0];
    }
    
    //日志实时数据
    readHandle.readabilityHandler = ^(NSFileHandle * _Nonnull fh) {
        NSData *data = [fh availableData];
        if(data.length > 0) {
            
            if(log) {
               // NSLog(@"%@\n",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
                NSString *str0 = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                printf("%s",[str0 cStringUsingEncoding:NSUTF8StringEncoding]);
            }
            else
                printf(">");
            
            if(wh) {
                [wh writeData:data];
            //    [wh synchronizeFile];
            }
        }
    };
    
    NSError *exError;
    //启动task
    if (@available(macOS 10.13, *))
    {
        [task launchAndReturnError:&exError];
        
        if(exError)
            NSLog(@"lanuch error %@",exError);
        
    } else {
        // Fallback on earlier versions
        [task launch];
    }
    
  //  NSLog(@"task.standardInput:%@",task.standardInput); //NSStdIOFileHandle class
    
    [task waitUntilExit];//直到程序运行结束，相应程序才会往下执
    
    printf("taskExc1 finish\n");
    

    [wh closeFile];
    
    return exError;
}

/**
 执行ffmpeg命令
 @param cmd ffmpeg命令 例如 @"ffmpeg -i sample.mp4 -a:copy .... sample.mp3"
 @param logPath 输出值，用于接收执行命令过程中生成的日志文件路径
 */
extern NSError * _Nullable ffmpegExc(NSString * _Nonnull cmd, NSString * _Nullable logPath) {
    
    NSArray<NSString *> *args = argumentsFromCoommandInput(cmd);
    
    NSLog(@"ffmpeg command start:\n%@",cmd);
    
    NSError *e = taskExc1(@"/usr/local/bin/ffmpeg", args, logPath, YES);
    
    NSLog(@"ffmpeg command finished");
    
    return e;;
}



//从输入的命令行中解析出命令参数
NSArray<NSString *>* _Nonnull argumentsFromCoommandInput(NSString * _Nonnull input) {
    
    //处理空格等特殊字符
    NSCharacterSet *whitespaceAndNewlineCharacterSet = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSArray *segs = [input componentsSeparatedByString:@" "];
    NSMutableArray <NSString *>*argsFilt = [NSMutableArray arrayWithCapacity:segs.count];
    
    BOOL jointNext = NO;//有转义字符，需要和下一组字符合并
    for(NSString *c in segs) {
        
        NSString *s = [c stringByTrimmingCharactersInSet:whitespaceAndNewlineCharacterSet];
        if(s.length == 0)
            continue;
        
        if(jointNext) {
            NSString *p0 = argsFilt.lastObject;
            [argsFilt removeLastObject];
            NSString *mergedPara = [NSString stringWithFormat:@"%@ %@",[p0 substringWithRange:NSMakeRange(0, p0.length-1)],s];
            [argsFilt addObject:mergedPara];
        }
        else
            [argsFilt addObject:c];
        
        jointNext = [s hasSuffix:@"\\"];//转义空格
    }
    
    return argsFilt.copy;
}


extern NSString * resolvePath(NSString * _Nonnull path)
{
    if([path hasPrefix:@"~/"])
        return [path stringByResolvingSymlinksInPath];
    
    if([path hasPrefix:@"/"])
        return path;
    
    
    NSString *curDir = [[NSFileManager defaultManager] currentDirectoryPath];
    NSArray *inCmps = [path componentsSeparatedByString:@"/"];
    NSMutableArray *curCmps = [[curDir componentsSeparatedByString:@"/"] mutableCopy];
    

    for(NSString *s in inCmps) {
        if([s isEqualToString:@".."]) {
            [curCmps removeLastObject];
        }
        else if([s isEqualToString:@"."]) {
            //do nothing
        }
        else {
            [curCmps addObject:s];
        }
    }
    
    NSMutableString *mStr = [NSMutableString string];
    for(NSString *s in curCmps) {
        [mStr appendFormat:@"%@/",s];
    }
    
    [mStr deleteCharactersInRange:NSMakeRange(mStr.length-1, 1)];
    return mStr;
}
