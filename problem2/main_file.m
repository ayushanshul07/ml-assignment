% image segmentation using GMM 
% Ayush Anshul 140108052
% Abhishek Kumar 140108003

% Reading the image
clear;clc;
num_iter = 100;
disp('Total number of iterations equals 100')
image_file = 'ski_image.jpg';
data = imread(image_file);
[image_r image_c image_h] = size(data);
data = double(data);
R = data(:,:,1);G = data(:,:,2);B = data(:,:,3);
R = R(:);G =G(:);B = B(:);
features = ([R'; G'; B'])/255;
[row col] = size(features);

%image in stored in matrix 'features' where each column has 3 rows
%containing RGB value of a pixel and total number of rows equals number of
%pixels

%setting the initial conditions as given in question

mean1 = [120; 120; 120]/255; mean2 = [12; 12; 12]/255; mean3 = [180; 180; 180]/255;
sigma1 = eye(3); sigma2 = eye(3); sigma3 = eye(3);
pi1 = 1/3; pi2 = 1/3; pi3 = 1/3;

loglikelihood_val = [];
for iter = 1:num_iter
    % E Step
    %responsibility matrix 
    disp('Running iteration number :')
    disp(iter)
    determinant1 = det(sigma1);determinant2 = det(sigma2);determinant3 = det(sigma3);
    inverse1 = inv(sigma1);inverse2 = inv(sigma2);inverse3 = inv(sigma3);
  
    a1 = (pi1 * normal(features,mean1,determinant1,inverse1));
    a2 = (pi2 * normal(features,mean2,determinant2,inverse2));
    a3 = (pi3 * normal(features,mean3,determinant3,inverse3));
    sum1 = a1 + a2 + a3;
    resp = [a1./sum1; a2./sum1; a3./sum1];
        
    % M Step
    N1 = sum(resp(1,:)); N2 = sum(resp(2,:)); N3 = sum(resp(3,:));
    
    %loglikelihood value
    loglikelihood_val = [loglikelihood_val sum(log(sum1))];
    
    %calculating 3 new means
    mean1_new = features .* repmat(resp(1, :), 3, 1);
    mean1_new = sum(mean1_new, 2)/N1;
    
    mean2_new = features .* repmat(resp(2, :), 3, 1);
    mean2_new = sum(mean2_new, 2)/N2;
    
    mean3_new = features .* repmat(resp(3, :), 3, 1);
    mean3_new = sum(mean3_new, 2)/N3;

    %calculating 3 new covariances
    mean_shifted = repmat(mean1_new, 1, col);
    sigma1_new = (repmat(resp(1, :), 3, 1) .* (features - mean_shifted) ) * (features - mean_shifted)' ;
    sigma1_new = sigma1_new/N1 + eye(3) / 2550;
    
    mean_shifted = repmat(mean2_new, 1, col);
    sigma2_new = (repmat(resp(2, :), 3, 1) .* (features - mean_shifted) ) * (features - mean_shifted)' ;
    sigma2_new = sigma2_new/N2 + eye(3) / 2550;
    
    mean_shifted = repmat(mean3_new, 1, col);
    sigma3_new = (repmat(resp(3, :), 3, 1) .* (features - mean_shifted) ) * (features - mean_shifted)' ;
    sigma3_new = sigma3_new/N3 + eye(3) / 2550;


    %calculating 3 new mixing coefficients
    pi1_new = N1/col; pi2_new = N2/col; pi3_new = N3/col;

    %assigning new values to old values;
    mean1 = mean1_new; mean2 = mean2_new; mean3 = mean3_new;
    sigma1 = sigma1_new; sigma2 = sigma2_new; sigma3 = sigma3_new;
    pi1 = pi1_new; pi2 = pi2_new; pi3 = pi3_new;
    
end

%reconstructing the segmented image
R_n = zeros(1,col); G_n = zeros(1,col); B_n = zeros(1,col);

for var = 1:col
    [maximum index] = max(resp(:,var));
    if index == 1
       %R_n(var) = 255; G_n(var) = 0; B_n(var) = 0;
       R_n(var) = mean1(1); G_n(var) = mean1(2);B_n(var) = mean1(3);
    elseif index == 2
       %R_n(var) = 0; G_n(var) = 255; B_n(var) = 0;
       R_n(var) = mean2(1); G_n(var) = mean2(2);B_n(var) = mean2(3);
    else
       %R_n(var) = 0; G_n(var) = 0; B_n(var) = 255;
       R_n(var) = mean3(1); G_n(var) = mean3(2);B_n(var) = mean3(3);
    end
end

new_image = zeros(image_r,image_c, 3);
new_image(:, :, 1) = reshape(R_n,image_r,image_c);new_image(:, :, 2) = reshape(G_n,image_r,image_c);new_image(:, :, 3) = reshape(B_n,image_r,image_c);
strn1 = strcat(int2str(num_iter),image_file,'_segmented.jpg');
strn2 = strcat(int2str(num_iter),image_file,'_loglikelihood.jpg');
imwrite(new_image,strn1);
figure()
imshow(new_image);hold on;
figure()
fig = plot(loglikelihood_val);
xlabel('#iterations');ylabel('LogLikelihood values');
saveas(fig,strn2);
disp('All iterations completed. Segmented image and the graph of loglikelihood vs iterations are saved in current folder :)')
