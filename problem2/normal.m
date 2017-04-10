function return_val = normal(features, mean, determinant, inverse)
    d = 3;
    temp = sum( ( bsxfun(@minus,features,mean)'*inverse)'.*bsxfun(@minus,features,mean));
    return_val = ((2*pi)^(-1 * (d/2)) * (determinant)^(-0.5)) * exp((-0.5)* temp );
end    
