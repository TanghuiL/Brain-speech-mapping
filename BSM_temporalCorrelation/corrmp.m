function z = corrmp(x,y)

L = length(x);
h = length(y);
x = [x zeros(1,h-1)];
for i = 1:L,
    z(i) = corr(x(i:i+h-1)',y');
end