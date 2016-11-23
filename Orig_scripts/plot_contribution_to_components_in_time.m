function plot_contribution_to_components_in_time(number_of_components,time,score,variance_explained)
%PLOT contribution of each PC in time
%   input: number of components to plot, time vector for temporal
%   evolution, score from PCA, variance explained by those components
%   output: figure with temporal evolution of each component

% Kathi Unglert, Sep 2015

if number_of_components > 5
    number_of_components = 5;
elseif number_of_components < 3
    number_of_components = 3;
end

cm = get(gca,'ColorOrder');

figure
box on
hold on
h = [];
for ii = 1:number_of_components
    h(ii)=subtightplot(number_of_components,1,ii,[],[],0.1);
    plot(time,score(:,ii),'Color',cm(ii,:))
    datetick('x')
    set(gca,'xticklabel',[])
    if ii == ceil(number_of_components/2)
        ylabel('contribution of component in time')
    end
    grid on
end
hold off
datetick('x')
linkaxes(h,'x')
xlabel('time')


