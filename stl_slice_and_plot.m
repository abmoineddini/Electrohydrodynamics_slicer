%this script shows how everything works together
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Sunil Bhandari 
%3/17/2017
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc; clear vars; close all;
triangles = read_binary_stl_file('Version1.stl');
%%
%triangles = read_ascii_stl('Version1.stl',1);
original = triangles;
%triangles = orient_stl(triangles,'z');
triangles = rotate_stl(triangles,'x',90);
%%
slice_height = .1;
% tic;[movelist, z_slices] = slice_stl_create_pathV2(triangles, slice_height);toc;

min_z = min([triangles(:,3); triangles(:,6);triangles(:,9)])-1e-5;
max_z = max([triangles(:,3); triangles(:,6);triangles(:,9)])+1e-5;

z_slices = min_z: slice_height :max_z;

movelist_all = {};
triangles_new = [triangles(:,1:12),min(triangles(:,[3 6 9]),[],2), max(triangles(:,[ 3 6 9]),[],2)];


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%find intersecting triangles%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
slices = z_slices;
z_triangles = zeros(size(z_slices,2),4000);
z_triangles_size=zeros(size(z_slices,2),1);
for i = 1:size(triangles_new,1)        
    node = triangles_new(i,13);
    high= size(slices,2);
    low = 1;
    %start_point = floor((max+min)/2);
    not_match = true;
    include1 = true;
    include2 = true;
    while not_match
        mid = low + floor((high - low)/2);
        %check = comparator_floating2(match_node,nodes(mid,:),tol);
%         mid
%         slices(mid)
%         node
        %triangles(i,:)
        if mid == 1 && slices(mid) >= node
            check = 2;
        elseif slices(mid) <= node && mid == size(slices,2)
            check = 2;
        elseif slices(mid)>node && slices(mid-1)<node
            check = 0;
        elseif slices(mid)>node
            check = -1;
        elseif slices(mid) < node
            check = 1;
        end
%     check
      if check == -1
          high = mid - 1;
      elseif check == 1
          low = mid + 1;
      elseif check == 0
          node = mid;
          not_match = false;
      elseif high > low || check == 2
          include1 = false;
          not_match = false;
      end
    end
    z_low_index = mid;

 %binary check high
    node = triangles_new(i,14);
    
    high= size(slices,2);
    low = 1;
    
    %start_point = floor((max+min)/2);
    not_match = true;
    while not_match
        mid = low + floor((high - low)/2);
        %check = comparator_floating2(match_node,nodes(mid,:),tol);
        if mid == 1 && slices(1) <= node
            check = 2;
        elseif mid == size(slices,2) && slices(mid) <=node
            check = 2;
        elseif slices(mid)>node && slices(mid-1)<node
            check = 0;
        elseif slices(mid)>node
            check = -1;
        elseif slices(mid) < node
            check = 1;
        end

      if check == -1
          high = mid - 1;
      elseif check == 1
          low = mid + 1;
      elseif check == 0
          node = mid;
          not_match = false;
      elseif high > low || check == 2
          include2 = false;
          not_match = false;
      end

    end
    z_high_index = mid;
    if z_high_index > z_low_index 
        for j = z_low_index:z_high_index-1
            z_triangles_size(j) = z_triangles_size(j) + 1;
            z_triangles(j,z_triangles_size(j)) = i;
        end
    end
end

%list formed
'list formed'
triangle_checklist2 = z_triangles;
start_checker = 1;
for  k = 1:2%size(z_slices,2)
    
  triangle_checklist = triangle_checklist2(k,1:z_triangles_size(k));

    [lines,linesize] = triangle_plane_intersection(triangles_new(triangle_checklist,:), z_slices(k));
%     line(:, :, k) = lines;
%     line_size(k) = linesize;
%     assignin('base','line',line);
%     assignin('base','linesize',line_size);
     if linesize ~= 0
            %find all the points assign nodes and remove duplicates
            start_nodes = lines(1:linesize,1:2);
            end_nodes = lines(1:linesize,4:5);
            nodes = [start_nodes; end_nodes];
            connectivity = [];
            tol_uniquetol = 1e-8;
            tol = 1e-8;

            nodes = uniquetol(nodes,tol_uniquetol,'ByRows',true);
            nodes = sortrows(nodes,[1 2]);

            [~, n1] = ismembertol(start_nodes, nodes, tol, 'ByRows',true);
            [~, n2] = ismembertol(end_nodes, nodes,tol,  'ByRows',true);
            conn1 = [n1 n2];
%check for bad stl files. repeated edges, too thin surfaces, unclosed loops
%enable if error encountered
            conn2 = [n2 n1];
            check = ismember(conn2,conn1,'rows');
            conn1(check == 1,:)=[];
%end check
  
            G = graph(conn1(:,1),conn1(:,2));

            %create subgraph for connected components
            bins = conncomp(G);
            
        movelist =[];
          for i = 1: max(bins)
                    if start_checker ==1
                        
                        startNode = find(bins==i, 1, 'first');
                        %path =[];
                        path = dfsearch(G, startNode);
                        path = [path; path(1)];
                        %list of x and y axes
                        movelist1 = [nodes(path,1) nodes(path,2)];
                        if ~isempty(path)
                            if movelist1(1,1)>movelist1(2,1) || movelist1(1,2)>movelist1(2,2)
                                movelist1 = movelist1(end:-1:1,:);
                            end
                        end                    
                        %connect to the first point
                        movelist = [movelist;movelist1; [NaN NaN]];
                        movelist_size = size(movelist,1);
                        
                    else 
                        
                        
                    end
   
          end
          movelist_all(k) = {movelist};         
     end
end
movelist_all(1) = [];

%%
%'plotting'
%for i = 1: size(
plot_slices(movelist,z_slices, 0.0001)
%mov = make_movie(movelist, z_slices);
