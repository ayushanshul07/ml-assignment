function [class1_c class1_m class2_c class2_m class3_c class3_m] = check_result(testarray)
    class1_c = [];class1_m = [];
    class2_c = [];class2_m = [];
    class3_c = [];class3_m = [];
    for i = 1:100
        if testarray(i) == 1
            class1_c = [class1_c i];
        else
            class1_m = [class1_m i];
        end
    end
    
    for i = 101:200
        if testarray(i) == 2
            class2_c = [class2_c i];
        else
            class2_m = [class2_m i];
        end
    end
    
    for i = 201:300
        if testarray(i) == 3
            class3_c = [class3_c i];
        else
            class3_m = [class3_m i];
        end
    end
end