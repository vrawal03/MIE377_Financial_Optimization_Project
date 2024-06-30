function x = CVaR(returns, factRet, x0)
    
    % Number of assets and number of historical scenarios
    [S, n] = size(returns);

    % Define the confidence level
    alpha = 0.95;

    % Estimate the asset exp. returns by taking the geometric mean
    mu = (geomean(returns + 1) - 1)';

    % Set our target return by taking the geometric mean of the factor returns
    R = mean(geomean(factRet + 1) - 1);

    % Vector of decision variables
    x1 = [zeros(n,1); zeros(S,1); 0];

    % Making A

    % Initialize the matrix of zeros
    A = zeros(2 + 2*S, n + S + 1);

    % Populate the first row with -mu^T
    A(1, 1:n) = -mu';

    % Populate rows 2 to S+1 with -1s starting from column n
    for i = 1:S
        A(i + 1, n + i) = -1;
    end

    % Amend rows S+2 to 2S+1 as per new specifications
    for i = 1:S
        row_index = S + 1 + i;
        A(row_index, 1:n) = -1 * returns(i, :); % -1 * returns(j)^T
        A(row_index, n+1:n+S) = -1; % Elements n+1 to n+S as -1
        A(row_index, n+S+1) = -1; % Element n+S+1 as -1
    end

    % Display the amended matrix
    disp(A);

    % Defining constraint variables
    b = [-R; zeros(S,1); zeros(S,1); 0];
    Aeq = [ones(1,n), zeros(1,S+1)];
    beq = 1;
    lb = [0*ones(n,1); zeros(2*S,1); -Inf];
    ub = [ones(n,1); Inf(2*S,1); Inf];
   
    % Optimal Asset Weights
    func = @(x) x(n+S+1) + (1/((1-alpha)*S))*sum(x(n+1:n+S)) + sum(abs(x(1:n)-x0));

    opt = fmincon(func, x1, A, b, Aeq, beq, lb, ub);
    
    x = opt(1:n)
end