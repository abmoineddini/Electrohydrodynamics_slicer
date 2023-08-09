function [wayPoint, steps] = wayPoint_creating(input, scale, Multiplier)
%UNTITLED4 Summary of this function goes here
%   This Function will create the waypoints
movelist_mt = [];
for i = 1:size(input,2)
    movelist = input{i};
    for j = 1:size(movelist, 1)
        if isnan(movelist(j,1))
            movelist(j,:) = [];
        end
    end
    movelist_mt = vertcat(movelist_mt, movelist);
end
clear i j;

wayPoint = [];
for i = 1:(size(movelist_mt, 1)-1)
    wayPoint(i, 1) = movelist_mt((i+1), 1)- movelist_mt((i), 1);
    wayPoint(i, 2) = movelist_mt((i+1), 2)- movelist_mt((i), 2);
end
% wayPoint = wayPoint.*scale;

wayPointScaled = wayPoint.*scale;
steps = wayPointScaled./Multiplier;
steps = round(steps,0);

XVals = steps(:,1)';
YVals = steps(:,2)';

writematrix(steps,'steps.txt');
writematrix(XVals,'Xvals.txt');
writematrix(YVals,'Yvals.txt');
end

