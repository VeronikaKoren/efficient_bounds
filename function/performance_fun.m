function [error,cost,loss] = performance_fun(x,xhat_e,xhat_i,re,ri,mu)

%% squared error

se_e=sum((x-xhat_e).^2,1); % squared error E population [sum across dimensions and time-dependent]
se_i=sum((xhat_e-xhat_i).^2,1); % squared error I population
error=cat(1,se_e,se_i); 

%% metabolic cost

mc_e=sum(re.^2,1);    
mc_i=sum(ri.^2,1);
cost=cat(1,mc_e,mc_i);

%% error + cost = loss
%loss=(gL*error) + ((1-gL).*cost);
loss=error + mu.*cost;
end
