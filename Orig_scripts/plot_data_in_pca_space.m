function plot_data_in_pca_space(score,colorvector)
%PLOT data points in space spanned by first 3 components
%   input: score from PCA, vector with colors (can be empty)
%   output: figure with data projected onto first 3 components

% Kathi Unglert, Sep 2015

if isempty(colorvector)
    colorvector = 0.25.*zeros(length(score(:,1)),3);
end

figure('Renderer','Painters')
box on
scatter3(score(:,1),score(:,2),score(:,3),[],colorvector)
xlabel('component 1')
ylabel('component 2')
zlabel('component 3')
title('observations in new component space')
view(45,45)
grid on