disp('Welcome to the HRTF Diagnostic Tool');
disp('--------------------------------------------');
disp('Please enter the filename of your SOFA HRTF file (e.g. myHRTFDataset.sofa):');

sofaFile = input('SOFA file: ', 's');

try
    angdist = checkHRTFAngularDistance(sofaFile);
    visualizeEmitterDirections(sofaFile);
    coverage = checkGlobeCoverage(sofaFile, 15);

catch ME
    fprintf('Error processing the SOFA file: %s\n', ME.message);
end