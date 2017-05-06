function [ Data ] = ReadFile(filename)
%ReadFile returns data from a file
    switch filename
        case 'bezdekIris.data'
            f = fopen(filename);
            Data = [];
            while(1)
                a = fscanf(f,'%f',[1 1]);
                if( length(a) <= 0 )
                    break;
                end
                X = fscanf(f,'%c%f%c%f%c%f');
                junk = fgetl(f);
                type = 0;
                if( strcmp( junk , 'Iris-setosa') == 1 )
                    type = 1;
                elseif( strcmp( junk , 'Iris-versicolor') == 1 )
                    type = 2;
                elseif( strcmp( junk , 'Iris-virginica') == 1 )
                    type = 3;
                end
                Data = [ Data ; a X(2) X(4) X(6) type ];
            end
            fclose(f);
        case 'Two_Class_FourDGaussians.dat'
            Data = dlmread(filename);
    end
end


