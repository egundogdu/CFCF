
set_global_variable('workspace_path', fileparts(mfilename('fullpath')));

set_global_variable('version', 5);

set_global_variable('trax_timeout', 600);

% Enable more verbose output
% set_global_variable('debug', 1);

% Disable result caching
% set_global_variable('cache', 0);

% Disable result packaging
% set_global_variable('pack', 0);

% Select experiment stack
set_global_variable('stack', 'vot2017');
