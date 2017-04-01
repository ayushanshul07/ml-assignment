% Face Recognition Using PCA
% Ayush Anshul 140108052
% Abhishek Kumar 140108003

% Reading all the images into matrix DATA(number of pixels in image X total images)
warning('off');
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

figure;
xaxis = 1:parameter; yaxis = strength;
plot(xaxis',yaxis'); refline(0,95);
hold on;

% PART C > Reconstruction of Images

%for 'face_input_1.pgm'    
    new = imread('./face_input_1.pgm');
    new = double(new);
    new = new(:);
    image_1v = new;
    new = new - mean;
    w = [];

    w = new' * U;
    
    reconstructed = zeros(length(U),1);
    % using only 1 eigenface(largest)
    for i = 1:1
        reconstructed = reconstructed + w(i)*U(:,i);
    end
    reconstructed = reconstructed + mean;
    reconstructed = reshape(reconstructed,row,col);
    mse = (reconstructed(:) - image_1v)'*(reconstructed(:) - image_1v)/10304
    reconstructed = mat2gray(reconstructed);
    imwrite(reconstructed,'face_input_1r_top1.pgm');
    reconstructed = zeros(length(U),1);
   
    
    % using 15 eigenface(largest)
    for i = 1:15
        reconstructed = reconstructed + w(i)*U(:,i);
    end
    reconstructed = reconstructed + mean;
    reconstructed = reshape(reconstructed,row,col);
    mse = (reconstructed(:) - image_1v)'*(reconstructed(:) - image_1v)/10304
    reconstructed = mat2gray(reconstructed); 
    imwrite(reconstructed,'face_input_1r_top15.pgm');
    reconstructed = zeros(length(U),1);

    % using all eigenface
    for i = 1:200
        reconstructed = reconstructed + w(i)*U(:,i);
    end
    reconstructed = reconstructed + mean;
    reconstructed = reshape(reconstructed,row,col);
    mse = (reconstructed(:) - image_1v)'*(reconstructed(:) - image_1v)/10304
    reconstructed = mat2gray(reconstructed);
    imwrite(reconstructed,'face_input_1r_all.pgm');
    reconstructed = zeros(length(U),1);

%for 'face_input_2.pgm'    
    new = imread('./face_input_2.pgm');
    new = double(new);
    new = new(:);
    image_2v = new;
    new = new - mean;
    w = [];
    
    w = new' * U;
    
    reconstructed = zeros(length(U),1);
    % using only 1 eigenface(largest)
    for i = 1:1
        reconstructed = reconstructed + w(i)*U(:,i);
    end
    reconstructed = reconstructed + mean;
    reconstructed = reshape(reconstructed,row,col);
    mse = (reconstructed(:) - image_2v)'*(reconstructed(:) - image_2v)/10304
    reconstructed = mat2gray(reconstructed);
    imwrite(reconstructed,'face_input_2r_top1.pgm');
    reconstructed = zeros(length(U),1);

    % using 15 eigenface(largest)
    for i = 1:15
        reconstructed = reconstructed + w(i)*U(:,i);
    end
    reconstructed = reconstructed + mean;
    reconstructed = reshape(reconstructed,row,col);
    mse = (reconstructed(:) - image_2v)'*(reconstructed(:) - image_2v)/10304
    reconstructed = mat2gray(reconstructed);
    imwrite(reconstructed,'face_input_2r_top15.pgm');
    reconstructed = zeros(length(U),1);

    % using all eigenface
    for i = 1:200
        reconstructed = reconstructed + w(i)*U(:,i);
    end
    reconstructed = reconstructed + mean;
    reconstructed = reshape(reconstructed,row,col);
    mse = (reconstructed(:) - image_2v)'*(reconstructed(:) - image_2v)/10304
    reconstructed = mat2gray(reconstructed);
    imwrite(reconstructed,'face_input_2r_all.pgm');
    reconstructed = zeros(length(U),1);

