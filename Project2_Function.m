function x = Project2_Function(periodReturns, periodFactRet, x0)

    % Use this function to implement your algorithmic asset management
    % strategy. You can modify this function, but you must keep the inputs
    % and outputs consistent.
    %
    % INPUTS: periodReturns, periodFactRet, x0 (current portfolio weights)
    % OUTPUTS: x (optimal portfolio)
    %
    % An example of an MVO implementation with OLS regression is given
    % below. Please be sure to include comments in your code.
    %
    % *************** WRITE YOUR CODE HERE ***************
    %----------------------------------------------------------------------

    % Example: subset the data to consistently use the most recent 3 years
    % for parameter estimation
    returns = periodReturns(end-35:end,:);
    factRet = periodFactRet(end-35:end,:);
    
    % Example: Use an OLS regression to estimate mu and Q
    % [mu, Q, T, r_f] = PCA(returns, factRet);
    [mu, Q, T, r_f] = OLS(returns, factRet);
    % [mu, Q, T] = Black_Litterman(returns, factRet, x0)
    
    % Example: Use MVO to optimize our portfolio
    % x = MVO(mu, Q, x0, T);
    x = Robust_MVO(mu, Q, x0, T);
    % x = Max_Sharpe(mu, returns, factRet);
    % x = CVaR(returns, factRet, x0);
    % x = Risk_Parity(mu, Q, x0, T)
    % x = Market(returns, factRet, x0)
    % x = mean_maker(mu, Q, x0);
    % x = max_mu(returns, mu, Q);
    %----------------------------------------------------------------------
end
