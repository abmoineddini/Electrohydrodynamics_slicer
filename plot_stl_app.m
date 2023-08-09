function [] = plot_stl_app(ui,triangles)
%%% plots the triangles in stl file. The vertices in v need to be
%%% continuous.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%Author: Sunil Bhandari%%%%%%%%
%%%%Date: Mar 29, 2017 %%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
v = triangles(:,1:9);
vr = reshape(v',3,size(v,1)*3)';
vrn = zeros(size(vr,1)+size(triangles,1),3);
vrn(1:4:end) = vr(1:3:end);
vrn(2:4:end) = vr(2:3:end);
vrn(3:4:end) = vr(3:3:end);
vrn(4:4:end) = ones(size(triangles,1),3).*[NaN, NaN, NaN];
%h = figure(1);
%set(fig, 'renderer','opengl')
%view(3)
%plot3(vr(:,1),vr(:,2),vr(:,3))

plot3(ui,vrn(:,1)',vrn(:,2)',vrn(:,3)')
mx = max(max(v));
mn = min(min(v));
axis(ui,[mn mx mn mx mn mx]);
end
