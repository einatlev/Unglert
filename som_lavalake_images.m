% Kathi U., Jan 2015
% create SOM for lava lake images
% run cell by cell

clear all
close all
clc

% load data

mypath = '~/Documents/Dokumente/Uni/PhD/Vancouver/UBC PhD/SOM/from_Einat/';
dataset_option = 1;

% dataset_option numbers
% 1 Nyiragongo 10 March 2012
% 2 Erebus Dec 02
% 3 Erebus Dec 16
% 4 Erebus Dec 30
% 5 Halemaumau Jan 16 velocity
% 6 Halemaumau Aug 22
% 7 Halemaumau Jan 16
% 8 Halemaumau Jun 18

% load data

if dataset_option == 1
    
    %%%%%%%% Nyiragongo
    
    datapath = 'Nyiragongo/results/';
    fn = strcat(mypath,datapath,'Nyiragongo_full_pca_results.mat');
    load(fn);
    
elseif dataset_option == 2;
    
    %%%%%%%%%% Erebus
    
    %%% Dec 02 Erebus
    
    datapath = 'Erebus/results/';
    fn = strcat(mypath,datapath,'ErebusDec02_full_pca_results.mat');
    load(fn);
    
elseif dataset_option == 3;
    
    %%% Dec 16
    
    datapath = 'Erebus/results/';
    fn = strcat(mypath,datapath,'ErebusDec16_full_pca_results.mat');
    load(fn);
    
elseif dataset_option == 4;
    
    %%% Dec 30
    
    datapath = 'Erebus/results/';
    fn = strcat(mypath,datapath,'ErebusDec30_full_pca_results.mat');
    load(fn);
    
elseif dataset_option == 5;
    
    %%%%%%% Halemaumau
    
    %%% Jan 16 velocity
    
    datapath = 'Halemaumau/results/';
    fn = strcat(mypath,datapath,'HalemaumauJan16vel_full_pca_results.mat');
    load(fn);
    
elseif dataset_option == 6;
    
    %%% Aug 22
    
    datapath = 'Halemaumau/results/';
    fn = strcat(mypath,datapath,'HalemaumauAug22_full_pca_results.mat');
    load(fn);
    
elseif dataset_option == 7;
    
    %%% Jan 16
    
    datapath = 'Halemaumau/results/';
    fn = strcat(mypath,datapath,'HalemaumauJan16_full_pca_results.mat');
    load(fn);
    
elseif dataset_option == 8;
    
    %%% Jun 17
    
    datapath = 'Halemaumau/results/';
    fn = strcat(mypath,datapath,'HalemaumauJun18_full_pca_results.mat');
    load(fn);
    
else
    sprintf('Please set valid dataset option')
end

clearvars -except alltime alldata_norm downsampleno
%% SOM

sD = som_data_struct(alldata_norm);

% randomize in time
datale = size(sD.data,1);
order = randperm(datale);
newdata = sD.data(order,:);
olddata = sD;
sD.data = newdata;

sM = som_make(sD,'lattice','rect','mapsize','small');

no_row = sM.topol.msize(1);
no_col = sM.topol.msize(2);

savefn = strcat(mypath,datapath,'SOM_',num2str(no_row),'x',num2str(no_col),'_');

%% plot umat

Bmus = som_bmus(sM, sD);

colormap(1-gray)
figure(1)
som_show(sM,'umat','all')

saveas(gcf,strcat(savefn,'umat.fig'),'fig')

%% plot colors and distance

U = som_umat(sM);
Um = U(1:2:size(U,1),1:2:size(U,2));

C = som_colorcode(sM,'rgb2');
figure(2)
som_cplane(sM,C,1-Um(:)/max(Um(:)));
title('Color coding + distance matrix')
saveas(gcf,strcat(savefn,'color_distance.fig'),'fig')

myhits = som_hits(sM,sD);

%% plot timeline in BMU colors

colorvec = C(Bmus,:);
tmp = [colorvec order'];
tmp2 = sortrows(tmp,4);
colorvec = tmp2(:,1:3);

tmp = [Bmus order'];
tmp2 = sortrows(tmp,2);
sorted_Bmus = tmp2(:,1);

figure
colormap(colorvec)
hold on
plot(alltime,sorted_Bmus,'k-')
scatter(alltime,sorted_Bmus,20,1:size(colorvec,1),'filled')
datetick('x')
xlim([alltime(1) alltime(length(alltime))])
hold off

saveas(gcf,strcat(savefn,'color_timeline.fig'),'fig')

%% get some additional output params for saving

[qe,te] = som_quality(sM,sD);

%% plot codebook vectors

figure
colormap(hot)
hold on
% matlab subplots go by row (i.e. TL = 1, TR = 2, and so on)
for ii = 1:no_row
    for jj = 1:no_col
        subtightplot(no_row,no_col,(ii-1)*no_col + jj,[],0.1,0.1)
        imagesc(vec2mat(sM.codebook(ii+(jj-1)*no_row,:),downsampleno))
        set(gca,'Ydir','norm')
        set(gca,'XTickLabel',[])
        set(gca,'YTickLabel',[])
        caxis([0 max(max(sM.codebook))])
    end
end
hold off
saveas(gcf,strcat(savefn,'cbvectors.fig'),'fig')

figure
som_show(sM,'empty','codebook vectors & hits');
hold on
som_cplane(sM,C);
som_show_add('hit',myhits,'Text','on','TextColor','k')
hold off

%% this cell break is necessary because of some clash between the toolbox
% more recent versions of Matlab. If an error message comes up after the
% previous cell just keep going here

saveas(gcf,strcat(savefn,'hits.fig'),'fig')

%% save everything

save(strcat(savefn,'som_results.mat'))
