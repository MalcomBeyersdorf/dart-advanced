import 'dart:io';

main(List<String> arguments) {
    print('OS $Platform.operatingSystem $Platform.version');

    if(Platform.isLinux){
        print('Linux');
    }
    if(Platform.isMacOS){
        print('MacOS');
    }

    //List files from directory - Unix specfic
    Process.run('ls', ['-l']).then(( ProcessResult result) {
        print(result.stdout); // 0 is no error 
        print('Exit code $result.exitCode');
    });

    Process.start('cat', []).then((Process process) {
        // Tranform the output
        process.stdout.transform(UTF8.decoder).listen((event) {print(event)});
        
        // Send data to the process
        process.stdin.writeln('Hi');

        // stop the process
        Process.killPid(process.pid);

        // Get the exit code
        process.exitCode.then((int code) {
            print('Exit code $code');
            exit(0);
        });

    });
}
