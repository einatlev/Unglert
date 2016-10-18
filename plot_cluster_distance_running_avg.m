function [meandistance]=plot_cluster_distance_running_avg(number_of_clusters,time,my_clusters,pc_space_distance,no_of_points,savepath,savefilename)
%PLOT results from cluster distance measurement
%   input: number of clusters, time vector, cluster membership my_clusters,
%   distance in PCA space pc_space_distance,number of points for running average,
%   path for saving and filename for saving
%   output: figure with timelines from clustering, mean values for
%   distances

% Kathi Unglert, Jan 2016

cm = colormap(jet(number_of_clusters));

meandistance = zeros(number_of_clusters,1);

% get running averages
pc_space_distance_smooth_sub = [];

for cluster_index = 1:number_of_clusters
    temp_smooth = smooth(pc_space_distance(:,cluster_index),no_of_points,'rloess');
    temp_sub = downsample(temp_smooth,no_of_points);
    pc_space_distance_smooth_sub = [pc_space_distance_smooth_sub temp_sub];
end

time_sub = downsample(time,no_of_points);

figure
box on
hold on
mylegend = [];
for cluster_index = 1:number_of_clusters
    plot(time_sub,pc_space_distance_smooth_sub(:,cluster_index),'Color',cm(cluster_index,:))
    if isempty(pc_space_distance(my_clusters == cluster_index,cluster_index))
        meandistance(cluster_index) = 0;
    else
        meandistance(cluster_index) = mean(pc_space_distance(my_clusters == cluster_index,cluster_index));
    end 
    mylegend = [mylegend; strcat('cluster ',num2str(cluster_index),', ',num2str(meandistance(cluster_index),'%.5f'))];
end
hold off
legend(mylegend)
datetick('x')
axis tight
xlabel('time')
box on
saveas(gcf,strcat(savepath,savefilename,'_timeline_distances_sub.fig'),'fig')

figure
box on
hold on
for cluster_index = 1:number_of_clusters
    scatter(time,pc_space_distance(:,cluster_index),40,cm(cluster_index,:),'filled')
end
hold off
legend(mylegend)
datetick('x')
axis tight
xlabel('time')
box on
saveas(gcf,strcat(savepath,savefilename,'_timeline_distances.fig'),'fig')
