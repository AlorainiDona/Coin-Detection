clc;
clear all;
close all;

% Read the image
img = imread('coins.png');

% Convert to grayscale if the image is RGB
if size(img, 3) == 3
    grayImg = rgb2gray(img);
else
    grayImg = img;
end

% Convert to binary image
binaryImage = imbinarize(grayImg);

% Fill holes in the binary image
filledImage = imfill(binaryImage, 'holes');

% Label connected components
[labeledImage, numObjects] = bwlabel(filledImage);
props = regionprops(labeledImage, 'Area', 'Centroid');

% Initialize counters for different coin types
countNickel = 0;
countDime = 0;

% Classify and mark coins based on their area
figure;
imshow(img);
title('Image with Marked Coins');
hold on;

for n = 1:numObjects
    centroid = props(n).Centroid;
    X = centroid(1);
    Y = centroid(2);
    area = props(n).Area;
    
    % Define thresholds for classification
    if area > 2500 % Adjust threshold for Nickels
        text(X - 10, Y, 'N', 'Color', 'blue', 'FontWeight', 'bold'); % Marks Nickels with blue N
        rectangle('Position', [X - 20, Y - 20, 40, 40], 'EdgeColor', 'b', 'LineWidth', 2);
        countNickel = countNickel + 1;
    else % Adjust threshold for Dimes
        text(X - 10, Y, 'D', 'Color', 'cyan', 'FontWeight', 'bold'); % Marks Dimes with cyan D
        rectangle('Position', [X - 20, Y - 20, 40, 40], 'EdgeColor', 'c', 'LineWidth', 2);
        countDime = countDime + 1;
    end
end

% Display the total number of coins and breakdown
totalCoins = countNickel + countDime;
title(['Total Coins: ', num2str(totalCoins), ' | Nickels: ', num2str(countNickel), ' | Dimes: ', num2str(countDime)]);

% Calculate total amount
totalAmount = countNickel * 0.05 + countDime * 0.10;
disp(['Total Amount: $', num2str(totalAmount)]);
