function mprogress(n)
% MPROGRESS Display elapsed and remaining time of a for-loop
%
% Example:
%
% for n=1:N
%    ... do stuff ...
%    mprogress(n/N);
% end

% Copyright 2007 Mikkel N. Schmidt, ms@it.dk, www.mikkelschmidt.dk

% Variables
% n  : Current value of counter (btwn 0 and 1)
% m  : Value of counter at last display
% t0 : Time when counter was started
% c  : Counter string to display
% p  : Step (seconds) 
% tp : Time when counter was last displayed
persistent m t0 c p tp

% Minimum change in counter before it is displayed
N0 = .01;

% Minimum time (seconds) between counter is displayed
T0 = 1;

% No arguments: restart the counter
if nargin==0, n = 0; end
% Clear display
if strcmp(n, 'clear')
    fprintf('%c',8*ones(length(c)+(1*length(c)>1),1)); 
    c = '';
    return;
end

if isempty(m), m = inf; end
if isempty(p) || n<m, p = N0; end


% Only display the counter if
%  (1)      (2)    (3)
if n-m>p || n<m || n==1 
% 1) we have taken a step greater then p
% 2) the counter has been restarted
% 3) the counter is at 100%

    % Update the counter string 
    if n<m % New counter
        t0 = tic;
        tp = [];
        c = '0%';        
    else % Already running counter
        fprintf('%c',8*ones(length(c)+1*(length(c)>1),1)); 
        c = sprintf('%0.f%% (%s) %s', ...
            n*100, mtime(toc(t0)), mtime(toc(t0)*(1-n)/n));
    end
    
    % Display counter string
    disp(c);
    
    % Refresh display
    pause(0); drawnow;
    
    % If timer has been displayed before, set p to make next
    % update in T0 sec and counter has incresed more than N0
    if ~isempty(tp), p = max(T0*p/toc(tp), N0); end
    
    % Remember when the counter was last displayed
    tp = tic;
    
    % Remember the value of the counter that was displayed
    m = n;
end


function tstr = mtime(t)
if t<60*60
    tstr = sprintf('%02.f:%02.f', floor(t/60), mod(t,60));
elseif t<60*60*24
    tstr = sprintf('%02.f:%02.f:%02.f', floor(t/60/60), mod(floor(t/60),60), mod(t,60));
else
    tstr = sprintf('%0.f - %02.f:%02.f:%02.f', floor(t/60/60/24), mod(floor(t/60/60),24), mod(floor(t/60),60), mod(t,60));
end