clear; close all; clc;
I = imread('0001.jpg');
init_rect = [302, 135, 67, 81];
I = insertShape(I, 'Rectangle', init_rect, 'LineWidth', 2, 'Color', 'green');
padding = 2.0;
rect_paddding = [init_rect(1)-init_rect(3)*padding/2,...
    init_rect(2)-init_rect(4)*padding/2,...
    init_rect(3)*(1+padding),init_rect(4)*(1+padding)];
crop = imresize(imcrop(I, rect_paddding), [125, 125]);
[h, w, c] = size(crop);

[X,Y,Z] = peaks(35);
Z = 2*(rand(size(Z))-0.4).*(exp(-(X.^2+Y.^2)));

X_min = min(X(:));
X_max = max(X(:));
Y_min = min(Y(:));
Y_max = max(Y(:));
X = (X-X_min)/(X_max-X_min)*w;  % align size
Y = (Y-Y_min)/(Y_max-Y_min)*h;
surf(X,Y,(Z-min(Z(:))),'FaceAlpha',0.4);colormap(hsv);hold on

g = hgtransform('Matrix',makehgtform('translate',[0 0 0]));
image(g, crop)

axis off
view(225, 30)
set(gcf, 'position', [100 100 600 400]);
saveas(gcf,'SRDCF','pdf')
saveas(gcf,'SRDCF','png')
