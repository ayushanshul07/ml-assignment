function show_misclassified(result,classifier)


    cd('./TestCharacters');
    
    cd('./1');  
    count = 0;
    for i = 1:100
       if (result(i) ~= 1) && (count < 2)
           f = figure();
           count = count + 1;
           str = 200 + i; str = num2str(str);
           tmp = result(i);
           if tmp == 2
               tmp = 'c';
           else
               tmp = 'l';
           end
           imshow(strcat(str,'.jpg'));
           str = strcat('Classifier :',num2str(classifier), ' Class : e, Misclassified to : ',tmp);
           title(str);
           waitfor(f);
       end              
    end
    
    cd('../2');
    count = 0;
    for i = 101:200
       if (result(i) ~= 2) && (count < 2)
           f = figure();
           count = count + 1;
           str = 100 + i; str = num2str(str);
           tmp = result(i);
           if tmp == 1
               tmp = 'e';
           else
               tmp = 'l';
           end
           imshow(strcat(str,'.jpg'));
           str = strcat('Classifier :',num2str(classifier), ' Class : c, Misclassified to : ',tmp);
           title(str);
           waitfor(f);
       end              
    end 
    
    cd('../..');
end