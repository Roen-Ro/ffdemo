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
        
#warning before run this code, we should have ffmpeg installed. in my case I simply by ran 'brew install ffmpeg' in terminal
        
        const char *cmd = argv[0];//command self
        NSString *cmdStr = [NSString stringWithCString:cmd encoding:NSUTF8StringEncoding].lastPathComponent;
        NSLog(@"start %@ ---->>",cmdStr);
        
        //get the input video file path
        const char *fpath = argv[1];//full path from command line input parameter
        NSString *inputPath = [NSString stringWithCString:fpath encoding:NSUTF8StringEncoding];
        NSString *fullPath = resolvePath(inputPath);
        fullPath = [fullPath stringByReplacingOccurrencesOfString:@" " withString:@"\\ "];
        
        //define the ffmpeg output path
        NSString *outputPath = [[fullPath stringByDeletingLastPathComponent] stringByAppendingPathComponent:@"output.mp4"];
        outputPath = [outputPath stringByReplacingOccurrencesOfString:@" " withString:@"\\ "];
        
        //define the ffmpeg log output path
        NSString *logPath = [[fullPath stringByDeletingLastPathComponent] stringByAppendingPathComponent:@"output.log"];
        logPath = [logPath stringByReplacingOccurrencesOfString:@" " withString:@"\\ "];
        
        //compose a ffmpeg command
        NSString *command = [NSString stringWithFormat:@"ffmpeg -y -ss 00:00:15 -t 00:00:20 -i %@ -vcodec copy -acodec copy %@",fullPath,outputPath];
        
        ffmpegExc(command,logPath);
        
        NSLog(@"Finished %@ --------->",cmdStr);
        
    }
    return 0;
}



