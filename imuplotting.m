clc;
clear;
timestamp = '12-6-2018_9-11-51';
%timestamp = string(fileread('C:\Users\arbai\OneDrive\Documents\Processing\sketch_6dof_module_edited\mostrecenttime.txt'));
file = ['C:\Users\arbai\OneDrive\Documents\Processing\sketch_6dof_module_edited\angles_',timestamp,'.txt'];
angles = load(file);
starttime = 3000;
millitime = angles(:,1) - angles(1,1);
siz = size(angles);

for i = 1:siz(1)
  if(millitime(i)>=starttime)
     startpoint = i+2; %%slight adjustment +2 magic number
     break;
  end
end

millitime = millitime(startpoint:end)-starttime;
sectime = millitime./1000;
yaw = angles(startpoint:end,2);
pitch = angles(startpoint:end,3);
roll = angles(startpoint:end,4);
x_a = 9.8/255.*(angles(startpoint:end,5)-mean(angles(startpoint:end,5)));
y_a = 9.8/255.*(angles(startpoint:end,6)-mean(angles(startpoint:end,6)));
z_a = 9.8/255.*(angles(startpoint:end,7)-mean(angles(startpoint:end,7)));

x_v = cumtrapz(sectime, x_a);
y_v = cumtrapz(sectime, y_a);
z_v = cumtrapz(sectime, z_a);

x = cumtrapz(sectime, x_v);
y = cumtrapz(sectime, y_v);
z = cumtrapz(sectime, z_v);

for i = 3:size(roll,1)
  if(roll(i)-roll(i-1)> 100 && roll(i)-roll(i-2)> 100)
    roll(i) = roll(i)-360;
  end
  
  if(-roll(i)+roll(i-1)> 100 && -roll(i)+roll(i-2)> 100)
    roll(i) = roll(i)+360;
  end
  
  if(yaw(i)-yaw(i-1)> 100 && yaw(i)-yaw(i-2)> 100)
    yaw(i) = yaw(i)-360;
  end
  
  if(-yaw(i)+yaw(i-1)> 100 && -yaw(i)+yaw(i-2)> 100)
    yaw(i) = yaw(i)+360;
  end
  
  if(pitch(i)-pitch(i-1)> 100 && pitch(i)-pitch(i-2)> 100)
    pitch(i) = pitch(i)-360;
  end
  
  if(-pitch(i)+pitch(i-1)> 100 && -pitch(i)+pitch(i-2)> 100)
    pitch(i) = pitch(i)+360;
  end
 
end

figure('Name','filtered angles')
hold on
plot(sectime,yaw)
plot(sectime,pitch)
plot(sectime,roll)
xlabel('time (s)')
ylabel('angles(deg)')
legend('yaw','pitch','roll')
% 
figure('Name','raw acceleration')
hold on
plot(sectime, x_a)
plot(sectime,y_a)
plot(sectime,z_a)
% plot(sectime, mean(x_a(startpoint:end))*ones(size(x_a,1)));
% plot(sectime, mean(y_a(startpoint:end))*ones(size(x_a,1)));
% plot(sectime, mean(z_a(startpoint:end))*ones(size(x_a,1)));
plot(sectime, x_v)
plot(sectime,y_v)
plot(sectime,z_v)
% plot(sectime, mean(x_v(startpoint:end))*ones(size(x_v,1)));
% plot(sectime, mean(y_v(startpoint:end))*ones(size(x_v,1)));
% plot(sectime, mean(z_v(startpoint:end))*ones(size(x_v,1)));
plot(sectime, x)
plot(sectime,y)
plot(sectime,z)
xlabel('time (s)')
%ylabel('acceleration')
legend('a_x(m/s^2)','a_y (m/s^2)','a_z (m/s^2)','v_x (m/s)','v_y (m/s)','v_z (m/s)','x (m)','y (m)','z (m)')


%%looks like a second order response. maybe higher order. damped

%%what about position?

%%if you move it before it calibrates, there appears to be significant
%%drift

%%if you wait for it to calibrate it does a pretty good job, but still some
%%drift. quantify it somehow

%%run experiments moving it before and after calibration




