# Demo Demonstration  

Follow-up: 766774831
----

1. 'ffmpeg' command line tool is required for running this demo, (in my case i installed ffmpege by ran `brew install ffmpeg`)
2. to run this demo, input a video file path as the only input parameter for this command line
>there is a ["SaMple.mkv"](./aMple.mkv) file along with the project in case you need it.
3. the "[run_from_xcode.log](./run_from_xcode.log)" file is the log ouput by running this demo with xcode. In this case, it works as expected.
4. the "[run_from_terminal.log](./run_from_terminal.log)" file is the log ouput by running this command line tool with a build product from terminal by typing `./ffdemo /Users/jiangwenbin/Desktop/videoSample/SaMple.mkv `. In this case the ffmpeg task suspending there.  (this is the very problem i need to resolve)
5. if i copy the ffmpeg line from step 4's log and paste it into the terminal, it also works.