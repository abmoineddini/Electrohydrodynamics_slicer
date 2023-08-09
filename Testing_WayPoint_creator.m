movelist_mt = []
for i = 1:size(Movelist,2)
    movelist = Movelist{i};
    for j = 1:size(movelist, 1)
        if isnan(movelist(j,1))
            movelist(j,:) = [];
        end
    end
    movelist_mt = vertcat(movelist_mt, movelist)
end

clear i j;

wayPoint = [];
for i = 1:(size(movelist_mt, 1)-1)
    wayPoint(i, 1) = movelist_mt((i+1), 1)- movelist_mt((i), 1);
    wayPoint(i, 2) = movelist_mt((i+1), 2)- movelist_mt((i), 2);
end
scale  = 0.01;
Multiplier = 1.5625e-4;
wayPointScaled = wayPoint.*scale;
steps = wayPointScaled./Multiplier;
steps = round(steps,0);

writematrix(steps,'steps.txt')