function [roots] = root_solver(eqn)

syms x;
% eqn = (1+0.2*x)*(1 + 0.3*x)*(1+0.1*x) == x+1;
roots = vpasolve(eqn,x);

end
