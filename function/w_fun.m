function [w,J] = w_fun(M,N,q,d)

%% decoding weights

Ni=round(N/q);                            % ratio E to I neurons is q to 1
N_all=[N,Ni];
w=cell(2,1);

for ii=1:2
    
    w_ran=randn(M,N_all(ii));
    
    norm=(sum(w_ran.^2,1)).^0.5;      % normalization of weights with the the number of inputs
    norm_mat=(norm'*ones(1,M))';
    weight=w_ran./norm_mat;    
                          
    w{ii}=weight;
    
end

w{2}=w{2}.*d; % spread of weights of I neurons

%% connectivity matrices

J=cell(4,1);

idx_post=[2,2,1,1];
idx_pre=[1,2,2,1];

for ii=1:3
    
    wpost=w{idx_post(ii)};
    wpre=w{idx_pre(ii)};
    
    proj=wpost'*wpre;                                            % projection of weights + white noise
                                              
    J{ii}=(proj.*(sign(proj)==1));                          % keep only positive sign
    
end

end


