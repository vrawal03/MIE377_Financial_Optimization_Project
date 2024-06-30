function [mu_new, Q_new, T, r_f] = PCA(returns, factRet)

    % Get the number of assets
    n = size(returns, 1);
    
    % Estimate the asset exp. returns by taking the geometric mean
    mu_raw = (geomean(returns + 1) - 1)';

    % Estimate the risk-free rate by taking the mean of the exp. returns
    r_f = mean(mu_raw);
    
    % Number of observations and factors
    [T, p] = size(factRet); 
    
    % Data matrix
    X = [ones(n,1) returns];

    r_mean = (1/T)*(X')*ones(n,1);
    R_mean = X - ones(n,1)*(r_mean)';

    % Estimating the biased covariance matrix

    Q = (1/T)*(R_mean')*(R_mean);
    e = diag(sort(eig(Q), 'descend'));

    elements_above_threshold = sort(eig(Q)) > 0.01;
    num_elements_above_threshold = sum(elements_above_threshold);

    P = (R_mean)*(e);

    p = max([3 num_elements_above_threshold]);
    P1 = P(:,[1:p]) % These are factors, so create a corresponding model

    % Corresponding Factor Model

    % Data matrix
    X_new = [ones(T,1) P1];

    % Regression coefficients
    B = (X_new' * X_new) \ X_new' * returns;
    
    % Separate B into alpha and betas
    a = B(1,:)';     
    V = B(2:end,:); 
    
    % Residual variance
    ep       = returns - X_new * B;
    sigma_ep = 1/(T - p - 1) .* sum(ep .^2, 1);
    D        = diag(sigma_ep);
    
    % Factor expected returns and covariance matrix
    f_bar = mean(P1,1)';
    F     = cov(P1);
    
    % Calculate the asset expected returns and covariance matrix
    mu_new = a + V' * f_bar;
    Q_new  = V' * F * V + D;
    
    % Sometimes quadprog shows a warning if the covariance matrix is not
    % perfectly symmetric.
    Q_new = (Q_new + Q_new')/2;
    
    %----------------------------------------------------------------------
    
end