
function varargout = new_sprintf(varargin)
% adjust input arguments here
for k=1:nargin
    if (issparse(varargin{k}))
        varargin{k} = full(varargin{k});
    end
end
% call the built-in function
[varargout{1:nargout}] = builtin('sprintf',varargin{:});
end