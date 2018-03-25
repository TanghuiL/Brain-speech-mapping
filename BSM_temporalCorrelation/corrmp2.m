function z = corrmp2(x,y)

L = length(x);
h = length(y);
x = (x - mean(x))./std(x);
y = (y - mean(y))./std(y);
x = [x zeros(1,h-1)];

for i = 1:L,

    z(i) = x(i:i+h-1)*y'./length(y);
    
end