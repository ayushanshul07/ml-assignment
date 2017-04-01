function return_val = bayes_classifier(TEST,mean1,mean2,mean3,sigma1_inv,sigma2_inv,sigma3_inv,sigma1_det,sigma2_det,sigma3_det)
    test_size = 300;
    return_val = zeros(1,test_size);
    d = 32*32;
    for i = 1:test_size
        value1 = -0.5 * log(sigma1_det)- 0.5 * ((TEST(:,i) - mean1)' * sigma1_inv * (TEST(:,i) - mean1));
        value2 = -0.5 * log(sigma2_det)- 0.5 * ((TEST(:,i) - mean2)' * sigma2_inv * (TEST(:,i) - mean2));
        value3 = -0.5 * log(sigma3_det)- 0.5 * ((TEST(:,i) - mean3)' * sigma3_inv * (TEST(:,i) - mean3));
        value = [value1 value2 value3];
        [v index] = max(value);
        return_val(i) = index;
    end
end