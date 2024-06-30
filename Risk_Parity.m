function  x = Risk_Parity(mu, Q, x0, T)

    % Find the total number of assets
    n = size(Q,1); 
    x1 = 1/n.*(ones(n,1));

    % Define an arbitrary c > 0
    c = 2;
    
    % Set the target as the average expected return of all assets
    targetRet = mean(mu);
    
    % Disallow short sales
    lb = zeros(n,1);

    % Add the expected return constraint
    A = -1 .* mu';
    b = -1 * targetRet;

    %constrain weights to sum to 1
    Aeq = ones(1,n);
    beq = 1;

    % Lower bound (due to log term)
    lb = zeros(n,1); 

    % Set the quadprog options 
    options = optimoptions( 'quadprog', 'TolFun', 1e-9, 'Display','off');
    
    % Optimal asset weights
    func = @(y) (1/2)*transpose(y)*Q*y - c*sum(log(y)) + sum(abs(y./sum(y) - x0));
    y = fmincon(func,x1,[],[],[],[],lb,[]);
    x = y./sum(y);
    
    %----------------------------------------------------------------------
    
end