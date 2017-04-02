% Character Recognistion using Bayesian Classifier
% Ayush Anshul 140108052
% Abhishek Kumar 140108003

clear;clc;
images_num = 200;image_size = 32*32;
folder = ['1','2','3'];
CLASS1 = []; CLASS2 = []; CLASS3 = [];
TEST = [];
% Loading training images from the folder TrainCharacters into three
% different matrices
cd('./TrainCharacters');
cd('./1');
for i = 1:images_num
    tmp = imread(strcat(num2str(i), '.jpg'));
    tmp = imresize(tmp,0.25);
    tmp = tmp(:);
    tmp = double(tmp)/255;
    CLASS1 = [CLASS1 tmp];
end
cd('..');
cd('./2');
for i = 1:images_num
    tmp = imread(strcat(num2str(i), '.jpg'));
    tmp = imresize(tmp,0.25);
    tmp = tmp(:);
    tmp = double(tmp)/255;
    CLASS2 = [CLASS2 tmp];
end
cd('..');
cd('./3');
for i = 1:images_num
    tmp = imread(strcat(num2str(i), '.jpg'));
    tmp = imresize(tmp,0.25);
    tmp = tmp(:);
    tmp = double(tmp)/255;
    CLASS3 = [CLASS3 tmp];
end
cd('..');
cd('..');

cd('./TestCharacters/');
for i = 1:3
    cd(folder(i));
    for j = 201:300
        tmp = imread(strcat(num2str(j), '.jpg'));
        tmp = imresize(tmp,0.25);
        tmp = tmp(:);
        tmp = double(tmp)/255;
        TEST = [TEST tmp];     
    end
    cd('..');
end
cd('..');

%these are the means of different classes
mean1 = sum(CLASS1,2)/images_num; mean2 = sum(CLASS2,2)/images_num; mean3 = sum(CLASS3,2)/images_num;

% For PART <a> : samples modelled by separate covariace matrix
% calculating separate covariance matrix for each class
lambda1 = 0.5;

CLASS1_s = bsxfun(@minus,CLASS1,mean1);
sigma1 = (CLASS1_s * CLASS1_s')/images_num + lambda1 * eye(image_size);
sigma1_inv = inv(sigma1); sigma1_det = det(sigma1);

CLASS2_s = bsxfun(@minus,CLASS2,mean2);
sigma2 = (CLASS2_s * CLASS2_s')/images_num + lambda1 * eye(image_size);
sigma2_inv = inv(sigma2); sigma2_det = det(sigma2);

CLASS3_s = bsxfun(@minus,CLASS3,mean3);
sigma3 = (CLASS3_s * CLASS3_s')/images_num + lambda1 * eye(image_size);
sigma3_inv = inv(sigma3); sigma3_det = det(sigma3);

result_1 = bayes_classifier(TEST,mean1,mean2,mean3,sigma1_inv,sigma2_inv,sigma3_inv,sigma1_det,sigma2_det,sigma3_det);
[class1_c_a class1_m_a class2_c_a class2_m_a class3_c_a class3_m_a ] = check_result(result_1);

display('Results for first Classifier :')
display('  Accuracy for class1 is ')
display(size(class1_c_a,2))
display('  Accuracy for class2 is ')
display(size(class2_c_a,2))
display('  Accuracy for class3 is ')
display(size(class3_c_a,2))
display('Average accuracy is ')
display((size(class1_c_a,2) + size(class1_c_a,2) +size(class1_c_a,2))/300 * 100)

show_misclassified(result_1,1);

% For part<b> : samples pooled together

lambda2 = 0.6;
CLASS_comm = [CLASS1 CLASS2 CLASS3];
mean_comm = sum(CLASS_comm,2)/(3*images_num);
mean_comm_s = bsxfun(@minus,CLASS_comm,mean_comm);
sigma_comm = (mean_comm_s) * (mean_comm_s')/(3*images_num) + lambda2 * eye(image_size);
sigma_comm_inv = inv(sigma_comm); sigma_comm_det = det(sigma_comm);

result_2 = bayes_classifier(TEST,mean1,mean2,mean3,sigma_comm_inv,sigma_comm_inv,sigma_comm_inv,sigma_comm_det,sigma_comm_det,sigma_comm_det);
[class1_c_b class1_m_b class2_c_b class2_m_b class3_c_b class3_m_b ] = check_result(result_2);

display('Results for second Classifier :')
display('  Accuracy for class1 is ')
display(size(class1_c_b,2))
display('  Accuracy for class2 is ')
display(size(class2_c_b,2))
display('  Accuracy for class3 is ')
display(size(class3_c_b,2))
display('Average accuracy is ')
display((size(class1_c_b,2) + size(class1_c_b,2) +size(class1_c_b,2))/300 * 100)

show_misclassified(result_2,2);

% For part<c> : covariance of each class is Identity Matrix;

lambda3 = 0.5;
sigma = lambda3 * eye(image_size);
sigma_inv = inv(sigma); sigma_det = det(sigma);

result_3 = bayes_classifier(TEST,mean1,mean2,mean3,sigma_inv,sigma_inv,sigma_inv,sigma_det,sigma_det,sigma_det);
[class1_c_c class1_m_c class2_c_c class2_m_c class3_c_c class3_m_c ] = check_result(result_3);

display('Results for third Classifier :')
display('  Accuracy for class1 is ')
display(size(class1_c_c,2))
display('  Accuracy for class2 is ')
display(size(class2_c_c,2))
display('  Accuracy for class3 is ')
display(size(class3_c_c,2))
display('Average accuracy is ')
display((size(class1_c_c,2) + size(class1_c_c,2) +size(class1_c_c,2))/300 * 100)

show_misclassified(result_3,3);

