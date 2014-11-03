function e = average_predictor_error_rate(y_train, y_test)

v_m=sum(y_train)/length(y_train);

target = round((10^0).*v_m)./10^0;

e=1-(sum((y_test==target))/length(y_test));

end
    
