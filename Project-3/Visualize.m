function Visualize( id, dataset, clusters, U, visible, VATAndiVAT)
%Visualize Provide visuals for clustering results and export to file

colorVector = [[0 0 1];[1 0 0];[0 1 0];[0 1 1];[1 0 1];[0.3 0.3 0.3]; [0.6 0.2 0.8]; [0.1 0.5 0.9]];

    maxU = max(U);
    for i=1:size(clusters,1);
        index{i} = find(U(i,:) == maxU);
        if strcmp(visible,'false');
            set(gcf,'visible','off');
        end
        plot(dataset(index{i},1),dataset(index{i},2),'LineStyle','none','Marker','o','Color',colorVector(i,:))
        if i == 1
            hold on
            title(id);
        end
        plot(clusters(i,1),clusters(i,2),'LineStyle','none','Marker','.','Color','black','MarkerSize',35,'LineWidth',3)
        plot(clusters(i,1),clusters(i,2),'LineStyle','none','Marker','x','Color',colorVector(i,:),'MarkerSize',15,'LineWidth',3)
        
    end
    name = strcat(id,'-Clusters');        
    print(name,'-dpng');
    hold off
    
    %% VAT
    if strcmp(VATAndiVAT, 'true');
        figure,
        D = pdist2(dataset,dataset);
        [RV, C, I, RI] = VAT(D);
        imagesc(RV, [0 max(max(RV))]);
        title(id);
        name = strcat(id,'-VAT');
        print(name,'-dpng');
    %     figure, plot(dataset(:,1),dataset(:,2),'or');
        figure,
        [RiV, RV] = iVAT(D);
        imagesc(RiV);
        title(id);
        name = strcat(id,'-iVAT');
        print(name,'-dpng');
    end

end

