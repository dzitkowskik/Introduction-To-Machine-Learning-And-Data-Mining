function varargout = mfig(varargin)
% MFIG Create named figure window
%
% Usage
%   mfig('fig1') creates a named figure called 'fig1'. If 'fig1' already 
%   exists, it just becomes the current figure.

% Copyright 2007 Mikkel N. Schmidt, ms@it.dk, www.mikkelschmidt.dk

if nargin==0
    h = figure;
    set(h, 'WindowStyle', 'docked');
else
    name = varargin{1};
    h = findobj('Name', name, 'Type', 'Figure');
    if isempty(h)
        h = figure;
        set(h, 'Name', name);
        set(h, 'NumberTitle', 'off');
        set(h, 'WindowStyle', 'docked');
    else
        h = h(1);
        set(0, 'CurrentFigure', h);
    end
end

if nargout>=1
    varargout{1} = h;
end