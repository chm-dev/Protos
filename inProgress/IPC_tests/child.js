var spawn = require('child_process').spawn;
var cp = spawn("C:/Dev/AHK/AHK_portable/AutoHotkey.exe", ["./ahkprocess.ahk"]);


cp.stdout.on("data", function (data) {
    console.log(data.toString());
    cp.stdin.write(Buffer.from('you wrote: ') + data + '\n')
});

cp.stderr.on("data", function (data) {
    console.error(data.toString());
});



