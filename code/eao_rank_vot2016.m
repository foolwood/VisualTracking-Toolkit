clear; close all; clc;
load('../data/attr_eao_vot2016.mat');

tracker_names = fieldnames(result);
legend_names = fieldnames(result.(tracker_names{1}));
num_tracker = length(tracker_names);
num_attr = length(legend_names);
eao = zeros(num_tracker,num_attr);
for i = 1:num_tracker
    for j = 1:num_attr
        eao(i,j) = result.(tracker_names{i}).(legend_names{j});
    end
end
[eao_sorted,sorted_index] = sort(eao(:,1),'descend'); % rank by baseline eao
tracker_names = tracker_names(sorted_index);

figure;
Maker_style = {'o','x','*','v','diamond','+','<','pentagram','>','square','^','hexagram'};
Color_style = hsv(7);
line([0,num_tracker],[0.255,0.255],'LineWidth',2,'Color',[0.7 0.7 0.7]); hold on;
recent_index = [1,2,4,5,7,10,13,15,17,22,28,31,36,39,50];

for i = 1:num_tracker
    if i == 1 || i == 3
        m(i) = plot(i,eao_sorted(i),'Marker','.','Color',Color_style(i,:),...
            'LineStyle','none','LineWidth',2,'MarkerSize',35);hold on;
    else
        m(i) = plot(i,eao_sorted(i),'Marker',Maker_style{mod(i-1,12)+1},'Color',Color_style(mod(i-1,7)+1,:),...
            'LineStyle','none','LineWidth',2,'MarkerSize',10);hold on;
    end
    plot([i,i],[0,eao_sorted(i)],'LineStyle',':','Color',[0.83 0.81 0.78]);hold on;
    if any(i == recent_index)
        plot(i+2, 0.05,'MarkerSize',6,'Marker','o','LineStyle','none',...
            'Color',[0.83 0.81 0.8],'LineWidth',2);hold on;
    end
end


set(gca,'xdir','reverse')
ylim([0,(eao_sorted(1)+0.05)]);
xlim([1, num_tracker]);
set(gca,'XTick',1:5:70);
set(gca,'YTick',0:0.05:(eao_sorted(1)+0.05))
set(gca,'linewidth',2);
set(gca,'FontSize',12);
% annotation('textarrow',[0.76,0.8],[0.76,0.72],'String','SAECO','FontWeight','bold','FontSize',12);
annotation('textbox',[.15,.8,.1,.1],'String','$$\hat{\Phi}$$','FontWeight','bold','FontSize',30,'LineStyle','none','Interpreter','latex','FitBoxToText','off')
box on

num_tracker_show = 10; % only write top10
for i = 1:num_tracker_show %
    legend_names{i} = [strrep(tracker_names{i},'_','\_'),...
        num2str(eao_sorted(i),'~[%0.3f]')];
end
legend(m(1:num_tracker_show),legend_names(1:num_tracker_show),...
    'Location','eastoutside','Interpreter', 'latex','FontSize',16)
set(gcf, 'position', [500 300 800 250]);
saveas(gcf,'../img/eao_rank_vot2016','pdf');
saveas(gcf,'../img/eao_rank_vot2016','png');

