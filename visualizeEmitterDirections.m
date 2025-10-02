% function visualizeEmitterDirections(sofaFile)
% 
% % Load SOFA file
% hrtf = SOFAload(sofaFile);
% 
% % Extract emitter directions in degrees
% azimuth  = hrtf.SourcePosition(:,1);
% elevation = hrtf.SourcePosition(:,2);
% 
% % Convert spherical to Cartesian coordinates (unit vectors)
% [x,y,z] = sph2cart(deg2rad(azimuth), deg2rad(elevation), 1);
% 
% % Separate hemispheres
% frontIdx = (azimuth >= -90) & (azimuth <= 90);
% backIdx = ~frontIdx;
% 
% figure('Name','HRTF Emitter Directions Visualization');
% hold on;
% axis equal;
% grid on;
% view(3);
% xlabel('X'); ylabel('Y'); zlabel('Z');
% title('Emitter Directions on Unit Sphere');
% 
% % Plot front hemisphere points (blue)
% scatter3(x(frontIdx), y(frontIdx), z(frontIdx), 50, 'b', 'filled');
% % Plot back hemisphere points (red)
% scatter3(x(backIdx), y(backIdx), z(backIdx), 50, 'r', 'filled');
% 
% % Draw unit sphere for context
% [sphereX,sphereY,sphereZ] = sphere(50);
% hSphere = surf(sphereX, sphereY, sphereZ);
% set(hSphere, 'FaceAlpha', 0.1, 'EdgeColor', 'none', 'FaceColor', [0.8 0.8 0.8]);
% 
% legend({'Front Hemisphere','Back Hemisphere'}, 'Location','bestoutside');
% hold off;
% end

function visualizeEmitterDirections(sofaFile)

% Load SOFA file
hrtf = SOFAload(sofaFile);

% Extract emitter directions in degrees
azimuth  = hrtf.SourcePosition(:,1);
elevation = hrtf.SourcePosition(:,2);

% Convert spherical to Cartesian coordinates (unit vectors)
[x,y,z] = sph2cart(deg2rad(azimuth), deg2rad(elevation), 1);

% Separate hemispheres using X coordinate
frontIdx = x >= 0;  % positive X = front
backIdx  = x < 0;   % negative X = back

figure('Name','HRTF Emitter Directions Visualization');
hold on;
axis equal;
grid on;
view(3);
xlabel('X'); ylabel('Y'); zlabel('Z');
title('Emitter Directions on Unit Sphere');

% Plot front hemisphere points (blue)
scatter3(x(frontIdx), y(frontIdx), z(frontIdx), 50, 'b', 'filled');
% Plot back hemisphere points (red)
scatter3(x(backIdx), y(backIdx), z(backIdx), 50, 'r', 'filled');

% Draw unit sphere for context
[sphereX,sphereY,sphereZ] = sphere(50);
hSphere = surf(sphereX, sphereY, sphereZ);
set(hSphere, 'FaceAlpha', 0.1, 'EdgeColor', 'none', 'FaceColor', [0.8 0.8 0.8]);

legend({'Front Hemisphere','Back Hemisphere'}, 'Location','bestoutside');
hold off;

end