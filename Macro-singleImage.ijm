/*
 * This macro segments the cell of the biaflow exemple for a single open image (or stack)
 * 
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

processImage();
run("glasbey"); // After the 255th object, the cell are all of the same color because it's a 8-bit LUT
