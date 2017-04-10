% Face Recognition Using PCA
% Ayush Anshul 140108052
% Abhishek Kumar 140108003

% Reading all the images into matrix DATA(number of pixels in image X total images)
warning('off');
clear;clc;
DATA = [];tmp = [];
parameter = 200;
row = 112; col = 92;
for i = 1:40
    cd(strcat('./gallery/s', num2str(i)))
    for j = 1:5
        tmp = imread(strcat(num2str(j), '.pgm'));
        tmp = tmp(:);
        tmp = double(tmp);
        DATA = [DATA tmp];
    end
    cd('../..');
end

% Mean of all images
mean = sum(DATA,2)/200;

% Mean shifting all the images
X = DATA;
X = bsxfun(@minus, X, mean);

% Calculating the eigen values in descending order of magnitude for X'X/200
% as it as same eigen values as XX'/200
[V, D] = eigs( (X'*X)./200,parameter);

% eigenvectors of original covariance matrix XX'/200
U = X * V ;

% normalising the principal vectors
for i = 1:parameter
    U(:,i) = U(:,i)/norm(U(:,i));
end

% PART A > EigenFace corresponding to top 5 eigenvalues
if (exist('TOP5_eigenface_PartA','dir') == 7) %If exists than remove and remake
    rmdir('TOP5_eigenface_PartA','s');mkdir('TOP5_eigenface_PartA');
else
    mkdir('TOP5_eigenface_PartA');
end

for i = 1:5
    tmp = U(:,i);
    tmp = reshape(tmp,row,col);
    eigenfaces = mat2gray(tmp);
    string = strcat(num2str(i), '.pgm');
    path = strcat('./TOP5_eigenface_PartA/',string);
    imwrite(eigenfaces,path,'pgm');
    figure()
    imshow(eigenfaces)
    title(['Eigen Face: ' num2str(i)])
end


% PART B > Graph of Percentage of TotalVariance vs Number of eigenvectors
traceD = trace(D);
strength = [];
count = 0;
for i = 1:parameter
    count = count + D(i,i);
    tmp = count/traceD;
    tmp = 100 * tmp;
    strength = [strength tmp];
end;

xaxis = 1:parameter; yaxis = strength;
figure()
plot(xaxis',yaxis'); refline(0,95);xlabel('#dimensions');ylabel('Percentage variance caputered');
hold on;

% PART C > Reconstruction of Images

%for 'face_input_1.pgm'    
    new = imread('./face_input_1.pgm');
    new = double(new);
    new = new(:);
    image_1v = new;
    new = new - mean;
    w = [];
    mse = [];
    w = new' * U;
    
    %calculating MSE after each iteration and reconstructing image using 1, 15 and 200 eigenvectors
    reconstructed = zeros(length(U),1);reconstructed_t = zeros(length(U),1);   
    for i = 1:200
        reconstructed = reconstructed + w(i)*U(:,i);
        reconstructed = reconstructed + mean;
        mse_t = (reconstructed(:) - image_1v)'*(reconstructed(:) - image_1v)/(row*col);
        mse = [mse mse_t];       
        if (i == 1 || i == 15 || i == 200)
            reconstructed_t = reconstructed;
            reconstructed_t = reshape(reconstructed_t,row,col);
            reconstructed_t = mat2gray(reconstructed_t);
            str = strcat('face_input_1r_',num2str(i),'.pgm');
            imwrite(reconstructed_t,str);
            figure()
            imshow(reconstructed_t);
            title(['Test Image 1 with ' num2str(i) ' eig vec, MSE: ' num2str(mse_t) ])
            reconstructed_t = zeros(length(U),1); 
        end
       reconstructed = reconstructed - mean; 
    end
    
    xaxis = 1:parameter; yaxis = mse;
    figure()
    plot(xaxis',yaxis'); xlabel('#dimensions');ylabel('Mean Squared error, test image 1');
    hold on;
    
     

%for 'face_input_2.pgm'    
    new = imread('./face_input_2.pgm');
    new = double(new);
    new = new(:);
    image_2v = new;
    new = new - mean;
    w = [];
    mse = [];
    
    w = new' * U;
    
    %calculating MSE after each iteration and reconstructing image using 1, 15 and 200 eigenvectors
    reconstructed = zeros(length(U),1);reconstructed_t = zeros(length(U),1);   
    for i = 1:200
        reconstructed = reconstructed + w(i)*U(:,i);
        reconstructed = reconstructed + mean;
        mse_t = (reconstructed(:) - image_2v)'*(reconstructed(:) - image_2v)/(row*col);
        mse = [mse mse_t];       
        if (i == 1 || i == 15 || i == 200)
            reconstructed_t = reconstructed;
            reconstructed_t = reshape(reconstructed_t,row,col);
            reconstructed_t = mat2gray(reconstructed_t);
            str = strcat('face_input_2r_',num2str(i),'.pgm');
            imwrite(reconstructed_t,str);
            figure()
            imshow(reconstructed_t);
            title(['Test Image 2 with ' num2str(i) ' eig vec, MSE: ' num2str(mse_t) ])
            reconstructed_t = zeros(length(U),1); 
        end
       reconstructed = reconstructed - mean; 
    end
    
    xaxis = 1:parameter; yaxis = mse;
    figure()
    plot(xaxis',yaxis'); xlabel('#dimensions');ylabel('Mean Squared error, test image 2');
    hold on;
