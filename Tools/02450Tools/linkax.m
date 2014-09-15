function linkax(varargin)
% LINKAX Links axes together and set the axis limits to the common min/max
%
% Usage:
%   linkax        Links all x and y axes in the current figure together
%   linkax(s)     Links axes specified in s in the current figure together
%   linkax(h, s)  Links axes specified by the handle(s) h together  
%  
% Parameters:
%   s   'x'     Links all x-axes
%       'y'     Links all y-axes
%       'xy'    Links all x- and y-axes
%       'grid'  Links x- and y-axes that are aligned in the figure and
%               removes redundant axis ticks and labels
%       'off'   Unlinks all axes
%   h   Handle(s) to axes or figure
%
% Copyright 2011, Mikkel N. Schmidt, Technical University of Denmark

h0 = gcf;    
s = 'xy';
if nargin==1
    s = varargin{1};
end
if nargin==2
    h0 = varargin{1};
    s = varargin{2};
end

% If h0 is an axes object, use this, otherwise, get all axes children of h
if strcmp(get(h0(1),'type'), 'axes')
    h = h0;
else
    h = findobj(h0, 'type', 'axes');
end

if strcmp(s, 'grid')
    p = round(cell2mat(get(h, 'Position'))*1000)/1000;
    [b,i,j] = unique(p(:,[1 3 4]),'rows');
    for u = 1:length(i)
        k = find(j==u);
        % Get current axes limits
        xlim = mycell2mat(get(h(k), 'XLim'));
        % Link x-axes
        linkaxes(h(k), 'x'); 
        % Set axes limits
        set(h(k), 'XLim', [min(xlim(:)), max(xlim(:))]);
        % Sort axes according to y position
        [l_,l] = sort(p(j==u,2));
        set(h(k(l(2:end))), 'XTickLabel', []);
        set(mycell2mat(get(h(k(l(2:end))), 'XLabel')), 'String', '');
    end
    [b,i,j] = unique(p(:,[2 3 4]),'rows');
    for u = 1:length(i)
        k = find(j==u);
        % Get current axes limits
        ylim = mycell2mat(get(h(k), 'YLim'));
        % Link y-axes
        linkaxes(h(k), 'y'); 
        % Set axes limits
        set(h(k), 'YLim', [min(ylim(:)), max(ylim(:))]);
        % Sort axes according to x position
        [l_,l] = sort(p(j==u,1));
        set(h(k(l(2:end))), 'YTickLabel', []);
        set(mycell2mat(get(h(k(l(2:end))), 'YLabel')), 'String', '');
    end
else
    % Get current axes limits
    xlim = mycell2mat(get(h, 'XLim'));
    ylim = mycell2mat(get(h, 'YLim'));

    % Link (or unlink) axes
    linkaxes(h, s);

    % Set axes limits
    if strcmp(s, 'x') | strcmp(s, 'xy')
        set(h, 'XLim', [min(xlim(:)), max(xlim(:))]);
    end
    if strcmp(s, 'y') | strcmp(s, 'xy')
        set(h, 'YLim', [min(ylim(:)), max(ylim(:))]);
    end
    if strcmp(s, 'off')
        set(h, 'XLimMode', 'auto', 'YLimMode', 'auto');
    end
end

function m = mycell2mat(c)
if iscell(c)
    m = cell2mat(c);
else
    m = c;
end

