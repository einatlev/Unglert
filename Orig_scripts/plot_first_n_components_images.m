function plot_first_n_components_images(number_of_components,variance_explained,pca_coefficients,downsampleno)
%PLOT first n components from PCA analysis
%   input: number_of_components, variance_explained, PCA coefficients,
%   downsampleno for conversion back to image
%   output: figure with images of first n components (min 3, max 5)

% Kathi Unglert, Jan 2016

if number_of_components > 5
    number_of_components = 5;
elseif number_of_components < 3
    number_of_components = 3;
end


figure
hold on
set(gcf,'Colormap',feval('linear_kry_5_98_c75_n256'))
h = [];
for ii = 1:number_of_components
    h(ii)=subtightplot(number_of_components,1,ii,[],[],0.1);
    imagesc(vec2mat(pca_coefficients(:,ii),downsampleno))
    set(gca,'ytick',[])
    set(gca,'xtick',[])
    grid on
    axis tight
    caxis([min(min(pca_coefficients)) max(max(pca_coefficients))])
end
linkaxes(h,'x')
hold off


