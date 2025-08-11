function pass = checkHRTFAngularDistance(sofaFile)

% Load SOFA file
hrtf = SOFAload(sofaFile);

% Extract emitter directions in degrees
azimuth  = hrtf.SourcePosition(:,1); % azimuth in degrees
elevation = hrtf.SourcePosition(:,2); % elevation in degrees

% Convert spherical to Cartesian coordinates (unit vectors)
[x,y,z] = sph2cart(deg2rad(azimuth), deg2rad(elevation), 1);
vectors = [x,y,z];

% Define front hemisphere as azimuth between -90° and 90°
frontIdx = (azimuth >= -90) & (azimuth <= 90);
backIdx = ~frontIdx;

% Compute average minimum angular distance per hemisphere
avgAngleFront = averageMinAngularDistance(vectors(frontIdx,:));
avgAngleBack  = averageMinAngularDistance(vectors(backIdx,:));

fprintf('Average angular distance (Front hemisphere): %.2f°\n', avgAngleFront);
fprintf('Average angular distance (Back hemisphere): %.2f°\n', avgAngleBack);

% Check if both hemispheres pass the 8° threshold
pass = (avgAngleFront <= 8) && (avgAngleBack <= 8);

if pass
    fprintf('Pass: Average angular distance ≤ 8° in both hemispheres.\n');
else
    fprintf('Fail: Average angular distance > 8° in one or both hemispheres.\n');
end

end

function avgMinAngleDeg = averageMinAngularDistance(vectors)
% Compute minimum angular distance for each vector to its nearest neighbor
n = size(vectors,1);
minAngles = zeros(n,1);

for i = 1:n
    vi = vectors(i,:);
    % Calculate dot product with all other vectors
    dots = vectors * vi';
    dots(i) = 1; % exclude self (max dot product)
    % Clamp dots to valid range [-1,1] for acos
    dots = max(min(dots,1),-1);
    % Calculate angles in degrees
    angles = acosd(dots);
    % Find minimum angle excluding self
    minAngles(i) = min(angles(angles>0));
end

% Average minimum angular distance in degrees
avgMinAngleDeg = mean(minAngles);

end