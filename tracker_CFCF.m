% In order to re-run the experiments, please replace CFCF_LOCATION/CFCF with the destination of the code folder in your computer.
% The configuration.m file is also given, and it is crucial to employ this configuration file during the experiments 
% since the time_out line is necessary for this tracker.
tracker_label = 'CFCF';
CFCF_repo_path = 'CFCF_LOCATION/CFCF';
tracker_command = generate_matlab_command('CFCF_Wrapper(''CFCF_LOCATION/CFCF'')',...
    {[CFCF_repo_path '/VOT_integration/benchmark_wrapper']});

tracker_interpreter = 'matlab';

