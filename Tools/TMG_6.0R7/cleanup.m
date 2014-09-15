function cleanup(filename,direct)
% CLEANUP - This function can be used in order to clean up the directories
%   [TEXT_RESULTS],[TEXT_RESULTS_U] or [TEXT_RESULTS_Q] from any other text outputs, 
%   from previous runnings of tmg. 
%   CLEANUP(FILENAME,DIRECT) defines the actual path of the directory we want to clean up.
%   and the directory we want to cleanup.
%
%Copyright 2011 Eugenia Maria Kontopoulou, Dimitrios Zeimpekis, Efstratios Gallopoulos


error(nargchk(2, 2, nargin));

cleanup_p(filename,direct);
