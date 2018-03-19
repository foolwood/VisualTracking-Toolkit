ccc
load('2016.mat');

plotDrawStyle10={   struct('color',[1,0,0],'lineStyle','-'),...
    struct('color',[0,1,0],'lineStyle','--'),...
    struct('color',[0,0,1],'lineStyle',':'),...
    struct('color',[0,0,0],'lineStyle','-'),...%    struct('color',[1,1,0],'lineStyle','-'),...%yellow
    struct('color',[1,0,1],'lineStyle','--'),...%pink
    struct('color',[0,1,1],'lineStyle',':'),...
    struct('color',[0.5,0.5,0.5],'lineStyle','-'),...%gray-25%
    struct('color',[136,0,21]/255,'lineStyle','--'),...%dark red
    struct('color',[255,127,39]/255,'lineStyle',':'),...%orange
    struct('color',[0,162,232]/255,'lineStyle','-'),...%Turquoise
    };


tracker_name = fieldnames(a);
tracker_name(strcmp(tracker_name,'x12_')) = [];
legend_name = fieldnames(a.(tracker_name{1}));
num_tracker = length(tracker_name);
num_attr = length(legend_name);
eao = zeros(num_tracker,num_attr);
for i = 1:num_tracker
    for j = 1:num_attr
        eao(i,j) = a.(tracker_name{i}).(legend_name{j});
    end
end
[s,sorted_index] = sort(eao(:,1),'descend');
tracker_name = tracker_name(sorted_index(1:10));
eao = eao(sorted_index(1:10),:);
num_tracker = 10;

eao(:,num_attr+1) = eao(:,1);

a_min = min(eao,[],1);
a_max = max(eao,[],1);

t = (0:1/num_attr:1)*2*pi;
h = [];
masker_shape = {'x','.'};
masker_size = {10,40};
for i = 1:10
    color_masker(i,:) = plotDrawStyle10{i}.color;
end
color_line = color_masker*0.5 +ones(num_tracker,3)*0.5;
ax = polaraxes;

for i = 1:num_tracker
    h(i) = polarplot(t, (eao(i,:)-a_min)./(a_max-a_min)+0.2, 'MarkerSize',masker_size{mod(i,2)+1},...
        'Marker',masker_shape{mod(i,2)+1},'LineWidth',2,...
        'Color',color_line(i,:),'MarkerEdgeColor',color_masker(i,:)); hold on;
end

polarplot(t, 0.5, 'LineWidth',2, 'Color',[0,0,0]); hold on;


grid off
legend_name = {'Overall','Occlusion','Camera motion','Size change',...
    'Illumination change','Motion change', 'Unassigned'};
for i = 1:num_attr
    legend_name{i} = [legend_name{i} '$$(' num2str(a_min(i),'%.2f') ', ' num2str(a_max(i),'%.2f') ')$$'];
end
ax.ThetaTickLabels = legend_name;
ThetaTick = (0:1/num_attr:1)*360;
ax.ThetaTick = ThetaTick(1:end-1);
ax.RTickLabels = [];

ax.TickLabelInterpreter = 'latex';

for i = 1:num_tracker
    tracker_name{i} = strrep(tracker_name{i},'_','\_');
end
tracker_name{5} = [tracker_name{5} sprintf('\n')];  

% legend(h(1:5),tracker_name(1:5),'Orientation','horizontal','Location','southoutside')
legend(h(6:10),tracker_name(6:10),'Orientation','horizontal','Location','southoutside')
% set(gcf, 'position', [500 300 800 800]);
saveas(gcf,'20162','pdf')

