function x = Max_Sharpe(mu, returns, factRet)
    
    % Define the target return
    target = mean(mu);

    % Find the risk-free rate
    r_f = mean(( geomean(returns + 1) - 1 )');

    % Estimate Q using excess returns
    Q = cov(returns - r_f);

    % Calculate target return
    R = geomean(factRet + 1) - 1;

    % Define A
    A = mu'
    
    model.A = -mu';
    model.obj = (y')*(Q)*(y);
    model.rhs = R;
    model.sense = repmat('<', size(A, 1), 1); % Assuming all constraints are '<='
    model.lb = -1*ones(n,1);
    model.ub = 1*ones(n,1);
    model.modelsense = 'min';

    params.outputflag = 0;
    results = gurobi(model, params);
    y_optimal = results.y;

    x = y_optimal./sum(y_optimal);

end