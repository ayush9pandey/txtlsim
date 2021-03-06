%% MCMC toolbox demo - proj_protein_constgfp3iii.m
%
% const gfp 3, artificial data, separate, 2 extracts. Check if the CSPs line up exactly. 
% also do it with and without the kf timescale fixed. 
% Make sure you understand that tradeoff. 
% For these low dimensional sets, try to understand most of the parameter tradeoffs. 
% 
% 
% 
% 
% Vipul Singhal, 
% California Institute of Technology
% 2018

%% initialize the directory where things are stored.
[tstamp1, projdir, st] = project_init;

%% We first define the model, mcmc_info struct, and the data_info struct. 

mobj = model_protein3;

mcmc_info = mcmc_info_constgfp3iii(mobj);

mi = mcmc_info.model_info;

di = data_artificial_v2({mobj}, {0:10:1000}, {mi.measuredSpecies}, ...
    {mi.dosedNames}, {mi.dosedVals}, {mi.namesUnord},...
    {[0.5; 100;20;10], [0.5; 100;40;20]});

da_extract1 = di(1).dataArray;
da_extract2 = di(2).dataArray;
tv = di(1).timeVector;
%% convert this section into a data visualization function. 
figure 
    subplot(1,2,1)
    p11 = plot(tv, mean(da_extract1(:, 1, :, 1), 3),...
        'LineWidth', 2.5);hold on % dose 1
    p21 = plot(tv, mean(da_extract1(:, 1, :, 2), 3),...
        'LineWidth', 2.5);hold on % dose 2
    p31 = plot(tv, mean(da_extract1(:, 1, :, 3), 3),...
        'LineWidth', 2.5);hold on % dose 3
    xlabel('Time, (a.u.)', 'FontSize', 16)
    ylabel('Protein conc, (a.u.)', 'FontSize', 16)
    title('Extract 1, artificial data', 'FontSize', 16)
    axis([0 1000 0 14000])
    subplot(1,2,2)
    p12 = plot(tv, mean(da_extract2(:, 1, :, 1), 3),...
        'LineWidth', 2.5);hold on
    p22 = plot(tv, mean(da_extract2(:, 1, :, 2), 3),...
        'LineWidth', 2.5);hold on
    p32 = plot(tv, mean(da_extract2(:, 1, :, 3), 3),...
        'LineWidth', 2.5);hold on
    title('Extract 2, artificial data', 'FontSize', 16)
    xlabel('Time, (a.u.)', 'FontSize', 16)
    ylabel('Protein conc, (a.u.)', 'FontSize', 16)
    axis([0 1000 0 14000])
    legend({'D_{init} = 1 (a.u.)', 'D_{init} = 2', 'D_{init} = 5'},...
        'FontSize', 14,...
        'Location', 'NorthWest')
    
%%
%     Run the MCMC 
ri = mcmc_info.runsim_info;
mai = mcmc_info.master_info;

marray = mcmc_get_walkers({'20180313_125455'}, {20}, projdir);
pID = 1:4;
marray_cut = mcmc_cut(marray, pID, flipud((mai.paramRanges)'));
if size(marray_cut, 2) < ri.nW
    error('too few initial points');
elseif size(marray_cut, 2) > ri.nW
    marray_cut = marray_cut(:,1:ri.nW, :);
end
%%

mi1 = mcmc_runsim_v2(tstamp1, projdir, di(1), mcmc_info,...
    'UserInitialize', marray_cut(:,:,end));
    % 'UserInitialize', marray_cut(:,:,end)); 'InitialDistribution', 'LHS'

%%  plot stuff 
tstamptouse = tstamp1; %'20180313_125455'
marray = mcmc_get_walkers({tstamptouse}, {15:ri.nIter}, projdir);
% mcmc_plot(marray, mi1.namesUnord, 'savematlabfig', true, 'savejpeg', true,...
%     'projdir', projdir, 'tstamp', tstamptouse);
% mcmc_plot(marray, mi1.namesUnord,'ks', true, 'scatter', false);
% mcmc_plot(marray, mi1.namesUnord,'transparency', 0.05);
titls = {'dna 1'; 'dna 2';'dna 5'};
lgds = {};
mvarray1 = masterVecArray(marray, mai);
marrayOrd = mvarray1(mi1.paramMaps(mi1.orderingIx, 1),:,:);
fhandle = mcmc_trajectories(mi1.emo, di(1), mi1, marrayOrd, titls, lgds,...
    'SimMode', 'curves', 'savematlabfig', true, 'savejpeg', true,...
    'projdir', projdir, 'tstamp', tstamptouse, 'extrafignamestring', '_extract1');


%%
[tstamp2, projdir, st] = project_init;
%%
ri = mcmc_info.runsim_info;
mai = mcmc_info.master_info;

marray = mcmc_get_walkers({'20180313_131824'}, {20}, projdir);
pID = 1:4;
marray_cut = mcmc_cut(marray, pID, flipud((mai.paramRanges)'));
if size(marray_cut, 2) < ri.nW
    error('too few initial points');
elseif size(marray_cut, 2) > ri.nW
    marray_cut = marray_cut(:,1:ri.nW, :);
end

mi2 = mcmc_runsim_v2(tstamp2, projdir, di(2), mcmc_info,...
        'UserInitialize', marray_cut(:,:,end));
    % 'UserInitialize', marray_cut(:,:,end)); 'InitialDistribution', 'LHS'
%%
marray = mcmc_get_walkers({tstamp2}, {15:ri.nIter}, projdir);
% mcmc_plot(marray, mi2.namesUnord);
% mcmc_plot(marray, mi2.namesUnord,'ks', true, 'scatter', false);
% mcmc_plot(marray, mi2.namesUnord,'transparency', 0.05);
titls = {'dna 1'; 'dna 2';'dna 5'};
lgds = {};
mvarray2 = masterVecArray(marray, mai);
marrayOrd = mvarray2(mi2.paramMaps(mi2.orderingIx, 1),:,:);
mcmc_trajectories(mi2.emo, di(2), mi2, marrayOrd, titls, lgds,...
    'SimMode', 'curves', 'savematlabfig', true, 'savejpeg', true,...
    'projdir', projdir, 'tstamp', tstamptouse, 'extrafignamestring', '_extract2')

%% the 3d saving here is trickier: 4 C 3 is 4. So for 2 extracts, there are 8 plots. 
pToPlot = [1 2 3; 1 2 4; 1 3 4; 2 3 4];
labellist = mai.estNames;
for plotID = 1:size(pToPlot, 1)
    mstacked1 = mvarray1(:,:)';
    figure
    XX = mstacked1(1:end, [pToPlot(plotID,1)]);
    YY = mstacked1(1:end, [pToPlot(plotID,2)]);
    ZZ = mstacked1(1:end, [pToPlot(plotID,3)]);
    scatter3(XX,YY,ZZ)
    xlabel(labellist{pToPlot(plotID,1)}, 'FontSize', 20)
    ylabel(labellist{pToPlot(plotID,2)}, 'FontSize', 20)
    zlabel(labellist{pToPlot(plotID,3)}, 'FontSize', 20)
    title('covariation in Extract 1', 'FontSize', 20)
    saveas(gcf, [projdir '/simdata_' tstamp1 '/3dfig_ext1_' num2str(plotID) '_' tstamp1]);
end

pToPlot = [1 2 3; 1 2 4; 1 3 4; 2 3 4];
for plotID = 1:size(pToPlot, 1)
    mstacked2 = mvarray2(:,:)';
    figure
    XX = mstacked2(1:end, [pToPlot(plotID,1)]);
    YY = mstacked2(1:end, [pToPlot(plotID,2)]);
    ZZ = mstacked2(1:end, [pToPlot(plotID,3)]);
    scatter3(XX,YY,ZZ)
    xlabel(labellist{pToPlot(plotID,1)}, 'FontSize', 20)
    ylabel(labellist{pToPlot(plotID,2)}, 'FontSize', 20)
    zlabel(labellist{pToPlot(plotID,3)}, 'FontSize', 20)
    title('covariation in Extract 2', 'FontSize', 20)
    saveas(gcf, [projdir '/simdata_' tstamp2 '/3dfig_ext2_' num2str(plotID) '_' tstamp2]);
end
