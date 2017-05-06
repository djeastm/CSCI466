function G = tanhKernel( U,V )
        B = 2;
        y = -1;
        G = tanh(B*U*V'+y);
end

