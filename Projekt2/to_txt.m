function out_vec = to_txt( y, varargin )
%TO_TXT Changes a matlab vector into a simple txt list
%   y is the vector you want to save (y axis)
%   filename is the file you want to save in
%   x if you want a different indexing than 1,2,3... (x axis)
    if (nargin < 1 || nargin > 3)
        error('Wrong number of input parameters.');
    end
    if ~isvector(y) || (nargin ~= 1 && ~isempty(varargin{1}) && ~isvector(varargin{1}))
        error('Invalid vector size.');
    end
    out_vec = zeros(length(y),2);

    if nargin == 1 || isempty(varargin{1})
        out_vec(:,1) = (1:size(y,2));
    elseif (length(varargin{1}) ~= length(y))
        error('Vector length should match.');
    else
        out_vec(:,1) = varargin{1};
    end
    out_vec(:,2) = y;
    if nargin == 3
        dlmwrite(varargin{2}, out_vec, ' ');
    end


end

