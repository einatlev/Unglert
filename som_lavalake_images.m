% Kathi U., Jan 2015
% create SOM for lava lake images
% run cell by cell

close all
clc

% load data

mypath = '/local/data/lava/einatlev/Lakes/';


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
    datapath = 'Nyiragongo/results/Nyiragongo_full_';
    savepath = 'Nyiragongo/UnglerResults/'; 
elseif dataset_option == 2;  
    %%%%%%%%%% Erebus
    %%% Dec 02 Erebus
    datapath = 'Erebus/results/ErebusDec02_full_';
    savepath = 'Erebus/UnglerResults/';
    
elseif dataset_option == 3;
    %%% Dec 16
    datapath = 'Erebus/results/ErebusDec16_full_';
    datapath = 'Erebus/results/ErebusDec16_full_';   
elseif dataset_option == 4;
    %%% Dec 30
    datapath = 'Erebus/results/ErebusDec30_full_';
    datapath = 'Erebus/results/ErebusDec30_full_';
elseif dataset_option == 5;
    
    %%%%%%% Halemaumau
    %%% Jan 16 velocity
    datapath = 'Halemaumau/results/HalemaumauJan16vel_full_';
    datapath = 'Halemaumau/results/HalemaumauJan16vel_full_';    
elseif dataset_option == 6;
    %%% Aug 22
    datapath = 'Halemaumau/results/HalemaumauAug22_full_';
    savepath = 'Halemaumau/results/HalemaumauAug22_full_';    
elseif dataset_option == 7;   
    %%% Jan 16 thermal
    datapath = 'Halemaumau/results/HalemaumauJan16_full_';
    datapath = 'Halemaumau/results/HalemaumauJan16_full_';
elseif dataset_option == 8;
    %%% Jun 17    
    datapath = 'Halemaumau/UnglerResults/HalemaumauJun18_full_';
    savepath = 'Halemaumau/UnglerResults/';    
 elseif dataset_option == 9
    datapath = 'Marum/UnglerResults/Seq47/';
elseif dataset_option == 10
    datapath = 'Marum/UnglerResults/Seq48/';
elseif dataset_option == 11
    datapath = 'Marum/UnglerResults/Seq56/';
elseif dataset_option == 12
    datapath = '/Masaya/UnglerResults/Rec121/';
elseif dataset_option == 13
    datapath = '/Masaya/UnglerResults/Rec122/';
elseif dataset_option == 14
    datapath = '/Masaya/UnglerResults/Rec123/';
else
    sprintf('Please set valid dataset option')
end

fn = strcat(mypath,datapath,'_pca_results.mat');
load(fn);
c=clock;
disp (['PCA data loaded for ', datapath,'  ', num2str(c(4:6))])

% get factor for map size from ratio of eigenvectors
eig_factor = explained(1)/explained(2);

clearvars -except dataset_option alltime alldata_norm downsampleno eig_factor mypath datapath
%% SOM

if (ismember(dataset_option, [9 10 11]))
    sD = som_data_struct(alldata_norm(:,1:10:end));
else
    sD = som_data_struct(alldata_norm);
end
c=clock;
disp(['som_data_structure constructed for ', datapath,'  ', num2str(c(4:6))])


% randomize in time
datale = size(sD.data,1);
order = randperm(datale);
newdata = sD.data(order,:);
olddata = sD;
sD.data = newdata;

sM = som_make(sD,'lattice','rect','msize',[round(5*eig_factor) 5]);
c=clock;
disp (['som_make finished for ',datapath,'  ', num2str(c(4:6))])

no_row = sM.topol.msize(1);
no_col = sM.topol.msize(2);

savefn = strcat(mypath,datapath,'SOM_',num2str(no_row),'x',num2str(no_col),'_');

%% plot umat

Bmus = som_bmus(sM, sD);
c=clock;
disp (['som_bmus finished for ',datapath,'  ', num2str(c(4:6))])


colormap(1-gray)
figure(1)
som_show(sM,'umat','all')

saveas(gcf,strcat(savefn,'umat.fig'),'fig')

%% plot colors and distance

U = som_umat(sM);
Um = U(1:2:size(U,1),1:2:size(U,2));
c=clock;
disp (['som_umat finished for ',datapath,'  ', num2str(c(4:6))])


C = som_colorcode(sM,'rgb2');
figure(2)
som_cplane(sM,C,1-Um(:)/max(Um(:)));
title('Color coding + distance matrix')
saveas(gcf,strcat(savefn,'color_distance.fig'),'fig')

myhits = som_hits(sM,sD);
c = clock;
disp (['som_hits finished for ',datapath,'  ', num2str(c(4:6))])


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

%% save everything

save(strcat(savefn,'som_results.mat'))
disp (['Mid-way saving finished for ',datapath,'  ', num2str(c(4:6))])

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
        imagesc(reshape(sM.codebook(ii+(jj-1)*no_row,:), ...
            numel(sM.codebook(ii+(jj-1)*no_row,:))/downsampleno, downsampleno));
        
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
