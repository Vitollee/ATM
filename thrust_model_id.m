clear all

file_names = {'530g','562g','612g','669g','712g','711g','762g','911g','1020g','1331g','1577g','1656g','1870g'};
force_sample_points = [0.530 0.562 0.612 0.669 0.711 0.712 0.762 0.911 1.020 1.331 1.577 1.656 1.870];
throttle_vector = [];
voltage_vector = [];
thrust_force_vector = [];
    

for i = 1:size(file_names,2)
   [throttle,voltage,thrust_force] = read_data(file_names{i},force_sample_points(i));
   throttle_vector = [throttle_vector;throttle];
   voltage_vector = [voltage_vector;voltage];
   thrust_force_vector = [thrust_force_vector; thrust_force];
end

xdata = [throttle_vector';voltage_vector'];
ydata = thrust_force_vector';

fun = @(k,xdata)k(1)*xdata(2,:).^k(2).*(k(3)*xdata(1,:).^2+(1-k(3))*xdata(1,:)) ;
k0 = [0.05 2.0 1.0];
k = lsqcurvefit(fun,k0,xdata,ydata);

% hold on
[x,y] = meshgrid(0:0.02:1,13.5:0.1:17.0);
for i_x = 1:size(x,2)
   for i_y = 1:size(x,1)
      z(i_y,i_x) =  fun(k,[x(1,i_x);y(i_y,1)]);
   end
end
surf(x,y,z);
hold on
scatter3(throttle_vector,voltage_vector,thrust_force_vector,'MarkerEdgeColor','k');




function [throttle,voltage,thrust_force] = read_data(file_name,weight)

    source = readmatrix(['./flight_logs/',file_name,'.csv']);
    lines_to_remove = [];
    for i = 1:size(source,1)
        if (abs(source(i,13)) > 0.1)
            lines_to_remove = [lines_to_remove i];
        end
    end
    
    for i = 1:size(lines_to_remove,2)
       source(lines_to_remove(end-i+1),:) = []; 
    end
    
    time = source(:,1);
    ref_x = source(:,2);
    x = source(:,3);
    ref_y = source(:,4);
    y = source(:,5);
    ref_z = source(:,6);
    z = source(:,7);
    ref_u = source(:,8);
    u = source(:,9);
    ref_v = source(:,10);
    v = source(:,11);
    ref_w = source(:,12);
    w = source(:,13);
    ref_phi = source(:,14);
    phi = source(:,15);
    ref_theta = source(:,16);
    theta = source(:,17);
    ref_psi = source(:,18);
    psi = source(:,19);
    throttle = source(:,20);
    voltage = source(:,21);
    thrust_force = repmat(weight*9.81,[1 size(throttle,1)])';
end