clear;clc;
load('Pattern1.mat');load('Pattern2.mat');load('Pattern3.mat');
load('Test1.mat');load('Test2.mat');load('Test3.mat');
CLASS1 = vec2mat(cell2mat(train_pattern_1),120,200);
CLASS2 = vec2mat(cell2mat(train_pattern_2),120,200);
CLASS3 = vec2mat(cell2mat(train_pattern_3),120,200);
TEST1 = vec2mat(cell2mat(test_pattern_1),120,100);
TEST2 = vec2mat(cell2mat(test_pattern_2),120,100);
TEST3 = vec2mat(cell2mat(test_pattern_3),120,100);
label1 = ones(200,1); label2 = 2*ones(200,1);label3 = 3*ones(200,1);

correct = [];
gamma_array = -6:0.5:5;    
gamma_array = 10.^(gamma_array);
cost = -1:0.5:4.5;
cost = 10.^(cost);

for index1 = 1:size(gamma_array,2)
    for index2 = 1:size(cost,2)
        tmp_s = ['-c ', num2str(cost(index2)), ' -t 2 -g ', num2str(gamma_array(index1)), ' -q'];
        model1 = svmtrain([label1; label2],[CLASS1; CLASS2],tmp_s);
        model2 = svmtrain([label2; label3],[CLASS2; CLASS3],tmp_s);
        model3 = svmtrain([label3; label1],[CLASS3; CLASS1],tmp_s);

        class1 = svmpredict(ones(300,1),[TEST1; TEST2;TEST3],model1);
        class2 = svmpredict(ones(300,1),[TEST1; TEST2;TEST3],model2);
        class3 = svmpredict(ones(300,1),[TEST1; TEST2;TEST3],model3);
        clc
        class = zeros(1,300);
        for i = 1:300
           if (class1(i) == 1 && class2(i) == 1) || (class2(i) == 1 && class3(i) == 1) || (class3(i) == 1 && class1(i) == 1)
               class(i) = 1;
           end
           if (class1(i) == 2 && class2(i) == 2) || (class2(i) == 2 && class3(i) == 2) || (class3(i) == 2 && class1(i) == 2)
               class(i) = 2;
           end
           if (class1(i) == 3 && class2(i) == 3) || (class2(i) == 3 && class3(i) == 3) || (class3(i) == 3 && class1(i) == 3)
               class(i) = 3;
           end
        end

        counter = 0;
        for i = 1:100
            if class(i) == 1;
                counter = counter + 1;
            end
        end
        for i = 101:200
            if class(i) == 2;
                counter = counter + 1;
            end
        end
        for i = 201:300
            if class(i) == 3;
                counter = counter + 1;
            end
        end

        correct = [correct (counter/300)*100];
    end
end

c1 = size(cost,2);
g1 = size(gamma_array,2);

correct = reshape(correct, c1, g1);

log_cost = log10(repmat(cost, g1, 1));
log_gamma = log10(repmat(gamma_array', 1, c1));

surf(log_gamma,log_cost, correct', 'FaceAlpha',0.7)

rotate3d on
xlabel('log_1_0gamma'); ylabel('log_1_0cost'); zlabel('Accuracy_%');
