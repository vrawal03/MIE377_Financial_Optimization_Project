function  x = MVO(mu, Q, x0, T)
    
    % Use this function to construct an example of a MVO portfolio.
    %
    % An example of an MVO implementation is given below. You can use this
    % version of MVO if you like, but feel free to modify this code as much
    % as you need to. You can also change the inputs and outputs to suit
    % your needs. 
    
    % You may use quadprog, Gurobi, or any other optimizer you are familiar
    % with. Just be sure to include comments in your code.

    % *************** WRITE YOUR CODE HERE ***************
    %----------------------------------------------------------------------
    
    % Find the total number of assets
    n = size(Q,1); 
    
    % Set the target as the average expected return of all assets
    targetRet = mean(mu);

    % Determine parameters for the ellipsoidal uncertainty set
    theta = sqrt(diag(Q)./T)';
    theta_1 = diag(theta);
    epsilon = chi2inv(0.95, n);
    lambda = 1;
    
    % Disallow short sales
    lb = ones(n,-1)
    ub = ones(n,1)*(5/2*n)

    % Add the expected return constraint
    A = -1 .* mu';
    b = -1 * targetRet;

    % Objective function
    func = @(x) lambda*transpose(x)*Q*x - (transpose(mu)*x-epsilon*norm(theta_1*x,2));

    %constrain weights to sum to 1
    Aeq = ones(1,n);
    beq = 1;

    % Set the quadprog options 
    options = optimoptions( 'quadprog', 'TolFun', 1e-9, 'Display','off');
    
    % Optimal asset weights
    % x = quadprog( 2 * Q, [], A, b, Aeq, beq, lb, [], [], options);
    x1 = 1/n.*(ones(n,1));
    x = fmincon(func,x1,A,b,Aeq,beq,[],[]);

    %----------------------------------------------------------------------
    
end