function pass = checkGlobeCoverage(sofaFile, maxAllowedGapDeg)
% Verifies coverage over the upper hemisphere (azimuth 0°-360°, elevation 
% 0°-90°) by emitter directions within maxAllowedGapDeg.

if nargin < 2
    maxAllowedGapDeg = 15; % Default threshold in degrees
end

% Load SOFA file
hrtf = SOFAload(sofaFile);

% Extract emitter directions in degrees
azimuth  = hrtf.SourcePosition(:,1);
elevation = hrtf.SourcePosition(:,2);

% Convert emitter directions to Cartesian unit vectors
[x, y, z] = sph2cart(deg2rad(azimuth), deg2rad(elevation), 1);
emitters = [x,y,z];

% Generate reference grid points over hemisphere
N_az = 72;    % azimuth divisions (5° steps)
N_el = 19;    % elevation divisions (5° steps from 0 to 90)

azimuths = linspace(0, 360, N_az);
elevations = linspace(0, 90, N_el);

% Create meshgrid and convert to Cartesian coordinates
[AzGrid, ElGrid] = meshgrid(azimuths, elevations);
AzGrid = AzGrid(:);
ElGrid = ElGrid(:);

[refX, refY, refZ] = sph2cart(deg2rad(AzGrid), deg2rad(ElGrid), 1);
refPoints = [refX, refY, refZ];

% Check coverage gaps
maxGapFound = 0;
for i = 1:length(refPoints)
    refVec = refPoints(i,:);
    dots = emitters * refVec';
    dots = max(min(dots,1),-1);
    angles = acosd(dots);
    minAngle = min(angles);
    if minAngle > maxGapFound
        maxGapFound = minAngle;
    end
    if minAngle > maxAllowedGapDeg
        fprintf('Fail: Coverage gap %.2f° exceeds threshold at ref point %d.\n', minAngle, i);
        pass = false;
        return
    end
end

fprintf('Pass: Maximum coverage gap = %.2f°, within threshold %.2f°.\n', maxGapFound, maxAllowedGapDeg);
pass = true;

end