clc;
clear;

%% q1
step = 0.01;
domain = -5:step:5;

f = 3 * (heaviside(domain + 2)-heaviside(domain - 1));
g = exp(-2 * domain) .* heaviside(domain);

c = step * conv(f, g, 'same');
figure();
plot(domain, c, domain, g, domain, f)
legend('y = h * x','x','h')
xlim([-4 4])
ylim([0 4])
%print('plot', '-dpng', '-r300');

%% q2

clc;
clear;

a.data = [2, 1, 0, -1, 3] ;
a.start = -2;
b.data = [2, 1, 3];
b.start = 1;

[c, x, y] = convolve(a,b)

stemPlot(c, x, y)


%% functions
function [] = stemPlot(x, y, z)
    figure();
    d = min([x.start, y.start, z.start]):max([(x.start+length(x.data)-1),(y.start+length(y.data)-1),(z.start+length(z.data)-1)])    

    x.data = [x.data, zeros(1, length(d)-length(x.data))]
    y.data = [y.data, zeros(1, length(d)-length(y.data))]
    z.data = [z.data, zeros(1, length(d)-length(z.data))]
    
    subplot(3,1,1);
    stem(d, x.data);
    legend('y = h*x')
    subplot(3,1,2);
    stem(d, y.data);
    legend('x')
    subplot(3,1,3);
    stem(d, z.data);
    legend('h')
    
    print('stemPlots', '-dpng', '-r300');
end

function [c, x, y] = convolve(x, y)
    lower = min([x.start y.start])
    upper = max([x.start+length(x.data)-1 y.start+length(y.data)-1])
    
    xn = zeros(1, upper - lower +1);
    yn = zeros(1, upper - lower +1);
    
    I = lower:upper
    x.data = (I >= x.start) .* [circshift([x.data, zeros(1, (upper-lower+1)-length(x.data))], x.start - lower)];
    y.data = (I >= y.start) .* [circshift([y.data, zeros(1, (upper-lower+1)-length(y.data))], y.start - lower)];
    
    c.data = circshift(conv(x.data, y.data), lower); % shift convolution so that it matches the support
    c.start = x.start + y.start;
end

function [v] = getSupport(x)
    v = [x.start, x.start+length(x.data)-1];
end

function [] = displayInfo(y, x, h)
    y.data = y.data(find(y.data,1,'first'):find(y.data,1,'last'));
    disp('Support of y:')
    disp(getSupport(y))
    disp('Length of y:')
    disp(length(y.data))
    
    disp('Support of x:')
    disp(getSupport(x))
    disp('Length of x:')
    disp(length(x.data))
   
    disp('Support of h:')
    disp(getSupport(h))
    disp('Length of h:')
    disp(length(h.data))
    
end