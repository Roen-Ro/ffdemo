//
//  main.m
//  ffdemo
//
//  Created by 罗亮富 on 2021/4/20.
//

#import <Foundation/Foundation.h>
#import "Task.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        

        NSArray <NSString *>* arguments = NSProcessInfo.processInfo.arguments;
        NSString *cmdStr = arguments.firstObject.lastPathComponent;
        NSLog(@"start %@ ---->>",cmdStr);
        
        //get the input video file path
        const char *fpath = argv[1];//full path from command line input parameter
        NSString *inputPath = [NSString stringWithCString:fpath encoding:NSUTF8StringEncoding];
        
#warning the resolvePath is necessary, or there might be a file not found error.
        NSString *fullPath = resolvePath(inputPath);
        fullPath = [fullPath stringByReplacingOccurrencesOfString:@" " withString:@"\\ "];
        
#warning  also you can assign a constant string value to fullPath for debug, the result will be no difference.
    //    fullPath = @"/Users/jiangwenbin/Desktop/videoSample/SaMple.mkv";
        
        
        //-------------additional ffprobe, you will find it works by running with the build product
        
        //the ffprobe log output file path
        NSString *ffprobeOutput = [[fullPath stringByDeletingLastPathComponent] stringByAppendingPathComponent:@"ffprobe.json"];
        NSString *ffprobeCmd = [NSString stringWithFormat:@"ffprobe -v quiet -print_format json -show_format -show_streams %@",fullPath];
        NSArray *ffprobeArgs = argumentsFromCoommandInput(ffprobeCmd);
        NSLog(@"start ffprobe");
        taskExc1(@"/usr/local/bin/ffprobe", ffprobeArgs, ffprobeOutput, NO);
        NSLog(@"finished ffprobe");
        
        //------------- end of ffprobe
        
        
        //define the ffmpeg output path
        NSString *outputPath = [[fullPath stringByDeletingLastPathComponent] stringByAppendingPathComponent:@"output.mp4"];
        outputPath = [outputPath stringByReplacingOccurrencesOfString:@" " withString:@"\\ "];
        
        //define the ffmpeg log output path
        NSString *logPath = [[fullPath stringByDeletingLastPathComponent] stringByAppendingPathComponent:@"output.log"];
        logPath = [logPath stringByReplacingOccurrencesOfString:@" " withString:@"\\ "];
        
      
#warning   the ffmpeg command works fine by running from xcode. \
         BUT neither of the following code works by running from terminal with a build product
        
#if 1 //it doesn't work by running from a build product
        NSArray *ffmpegArgs = @[
        @"-y",
        @"-ss",
        @"00:00:15",
        @"-t",
        @"00:00:20",
        @"-i",
        fullPath,
        @"-vcodec",
        @"copy",
        @"-acodec",
        @"copy",
        outputPath
        ];
        taskExc1(@"/usr/local/bin/ffmpeg", ffmpegArgs, logPath, YES);
        
#else //it doesn't work by running from a build product
        
        //compose a ffmpeg command
        NSString *command = [NSString stringWithFormat:@"-y -ss 00:00:15 -t 00:00:20 -i %@ -vcodec copy -acodec copy %@",fullPath,outputPath];
        ffmpegExc(command,logPath);
        
#endif
        
        NSLog(@"Finished %@ --------->",cmdStr);
        
    }
    return 0;
}



