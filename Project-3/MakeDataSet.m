function [ X ] = MakeDataSet( filename )

    Img = imread(filename);
%     disp(filename);
    [R C] = find( Img == 0 );
    
    figure; 
    
    plot(R,C,'xk');
    filename = filename(1:end-4);
    hold on
    filename = strrep(filename, '_', '-');
    title(filename);
    filename = strrep(filename, '-', '_');
    print(filename,'-dpng');
    hold off
    X = [ R C ];

end