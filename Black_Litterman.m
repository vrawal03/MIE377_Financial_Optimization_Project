function  [mu, Q, T] = Black_Litterman(returns, factRet, x0)
    
    % Use this function to perform a basic OLS regression with all factors. 
    % You can modify this function (inputs, outputs and code) as much as
    % you need to.
 
    % *************** WRITE YOUR CODE HERE ***************
    %----------------------------------------------------------------------
    
    % Number of assets
    n = size(returns, 2);

    % Number of observations and factors
    [T, p] = size(factRet); 
    
    % Data matrix
    X = [ones(T,1) factRet];

    % Estimate the asset exp. returns by taking the geometric mean
    mu_raw = ( geomean(returns + 1) - 1 )';

    % Estimate the risk-free rate by taking the mean of the exp. returns
    r_f = mean(mean(returns));

    % Calculate the market portfolio using x_mkt = u_raw^T
    x_mkt = mu_raw./sum(mu_raw);

    % Estimate Q
    Q = cov(returns - r_f);

    % Calculate lambda
    lambda = ((mu_raw')*(x_mkt))/(((x_mkt)')*Q*x_mkt);

    % Calculate pi
    pi = lambda*Q*x_mkt;

    % Since we have no investor views, mu = pi
    mu = pi;

    %----------------------------------------------------------------------
    
end