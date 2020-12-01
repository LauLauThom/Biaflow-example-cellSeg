// Check https://github.com/Neubias-WG5/W_NucleiSegmentation-ImageJ/blob/1.12.3/macro.ijm
/*
 * Command
 * java -Xmx1000m -cp .\jars\ij-1.53c.jar ij.ImageJ --headless --console -macro "C:\Users\Laurent Thomas\Documents\github\Biaflow-example\Macro-headless.ijm" "input=C:\Users\Laurent Thomas\OneDrive\BiaflowExample\images, output=C:\Users\Laurent Thomas\OneDrive\BiaflowExample\output“

 */

function processImage(){
	// MAIN MACRO
	run("Subtract Background...", "rolling=50 stack");
	
	setAutoThreshold("Default dark");
	//run("Threshold...");
	run("Convert to Mask", "method=Default background=Dark calculate");
	run("Watershed", "stack");
	
	// Make labeling image (1 pixel value per object)
	run("Analyze Particles...", "  show=[Count Masks] include stack");
}

// Batch process 

setBatchMode(true);

// Path to input image and output image (label mask)
inputDir = "/dockershare/666/in/";
outputDir = "/dockershare/666/out/";

// Split command arguments
args = getArgument();
listArgs = split(args, ",");

for(i=0; i<listArgs.length; i++) {
	nameAndValue = split(listArgs[i], "="); // split the key value pair
	if (indexOf(nameAndValue[0], "input")>-1) inputDir=nameAndValue[1];
	if (indexOf(nameAndValue[0], "output")>-1) outputDir=nameAndValue[1];
}

listImages = getFileList(inputDir);

for(i=0; i<listImages.length; i++) {
	
	image = listImages[i];
	
	if (endsWith(image, ".tif")) {
		
		// Open image
		open(inputDir + "/" + image);
		wait(100);
		
		processImage();

		// close input image
		selectImage(image);
		close();

        // rename output to input
		outputImage = "Count Masks of " + image; // not the in-situ option anymore
		selectImage(outputImage);
		rename(image);
		
		// Export results
		save(outputDir + "/" + image);
		
		// Cleanup
		run("Close All");
	}
}

run("Quit");