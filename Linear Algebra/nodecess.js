//Utilizes the "stat" unix command, meaning this program experiences
//Limitations running on non-unix operating systems


var exec = require('child_process').exec;

var callString = "stat -c %X ";
var args = process.argv.slice(2); //Get rid of node and this filename

args.forEach(function( arg ){
	callString += arg+" ";
});



exec(callString, function (error, stdout, stderr) {

	  // output is in stdout
	if(error){
		console.log("Error: "+error);
	}
	else if(stderr){
		console.log("STDErr "+stderr);
	}	
	else{
		//Parse the timestamps returned by execution of the
		//stat command and run simple max algorithm, storing
		//it in a list called max
		var timeStamps = stdout.split("\n");
		max = [args[0], parseInt( timeStamps[0])];
		for(var i=0; i<args.length; i++){
			var intStamp = parseInt( timeStamps[i] );
			if(intStamp > max[1]){
				max = [args[i], intStamp];
			}	
		}
		console.log( max[0] );	//max[0] is the filename
	}
});


