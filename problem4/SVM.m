load('Pattern1.mat');
load('Pattern2.mat');
load('Pattern3.mat');
load('Test1.mat');
load('Test2.mat');
load('Test3.mat');

ftrain=fopen('train.txt','w');
ftest1=fopen('test1.txt','w');
ftest2=fopen('test2.txt','w');
ftest3=fopen('test3.txt','w');

for i=1:200
    a=train_pattern_1{i};
    b=train_pattern_2{i};
    c=train_pattern_3{i};
    fprintf(ftrain,'+1 ');
      for j=1:120
        fprintf(ftrain,'%d:%f ',j,a(j));
      end
    fprintf(ftrain,'\n');
        fprintf(ftrain,'+2 ');
      for j=1:120
        fprintf(ftrain,'%d:%f ',j,b(j));
      end
    fprintf(ftrain,'\n');
        fprintf(ftrain,'+3 ');
      for j=1:120
        fprintf(ftrain,'%d:%f ',j,c(j));
      end
    fprintf(ftrain,'\n');
end
    
for i=1:100
    a=test_pattern_1{i};
    b=test_pattern_2{i};
    c=test_pattern_3{i};
    fprintf(ftest1,'+1 ');
    fprintf(ftest2,'+2 ');
    fprintf(ftest3,'+3 ');
      for j=1:120
        fprintf(ftest1,'%d:%f ',j,a(j));
        fprintf(ftest2,'%d:%f ',j,b(j));
        fprintf(ftest3,'%d:%f ',j,c(j));
      end
    fprintf(ftest1,'\n');
    fprintf(ftest2,'\n');
    fprintf(ftest3,'\n');
end
fclose(ftrain);
fclose(ftest1);
fclose(ftest2);
fclose(ftest3);

[train_label,train_inst] = libsvmread('train.txt');
[test_label_1,test_inst_1] = libsvmread('test1.txt');
[test_label_2,test_inst_2] = libsvmread('test2.txt');
[test_label_3,test_inst_3] = libsvmread('test3.txt');

for i=1:100
    str=horzcat('-s 0 -t 2 -c ',num2str(i));
model = svmtrain(train_label, train_inst, str);
[predict_label_c, accuracy_c, dec_values_c] = svmpredict(test_label_1, test_inst_1, model);
acc_c_1(i)=accuracy_c(1);
[predict_label_c, accuracy_c, dec_values_c] = svmpredict(test_label_2, test_inst_2, model);
acc_c_2(i)=accuracy_c(1);
[predict_label_c, accuracy_c, dec_values_c] = svmpredict(test_label_3, test_inst_3, model);
acc_c_3(i)=accuracy_c(1);
end

for i=1:1000
    str=horzcat('-s 0 -t 2 -g ',num2str(i/100));
model = svmtrain(train_label, train_inst, str);
[predict_label_g, accuracy_g, dec_values_g] = svmpredict(test_label_1, test_inst_1, model);
acc_g_1(i)=accuracy_g(1);
[predict_label_g, accuracy_g, dec_values_g] = svmpredict(test_label_2, test_inst_2, model);
acc_g_2(i)=accuracy_g(1);
[predict_label_g, accuracy_g, dec_values_g] = svmpredict(test_label_3, test_inst_3, model);
acc_g_3(i)=accuracy_g(1);
end
