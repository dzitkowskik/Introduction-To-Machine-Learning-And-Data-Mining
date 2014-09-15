function init_tmg
% INIT_TMG - Installation script of TMG
%   INIT_TMG is the installation script of the Text to Matrix
%   Generator (TMG) Toolbox. INIT_TMG creates the MySQL 
%   database and adds all TMG directories to the path. 
% 
% Copyright 2008 Dimitrios Zeimpekis, Efstratios Gallopoulos

an1=sprintf('==================================================================================================');
% create database after a MATLAB restart
if exist('mysql_info.mat'), 
    load mysql_info.mat;
    if isfield(mysql, 'run'), 
        res=create_database(mysql); 
        if res~=1, 
            if mysql.is_set==1, an=sprintf('WARNING: Unable to create MySQL database! '); disp(an); end
            mysql.is_set=0;
        else, 
            an=sprintf('Database created successfully!'); disp(an); 
        end        
        mysql=rmfield(mysql, 'run');
        save mysql_info mysql;
        return;
    end
end
% check for MySQL avalaibility and store 
% corresponding information to mysql_info.mat
disp(an1); disp(an1); an=sprintf('You are about to installed the TMG Toolbox to you system. Press any key to continue!'); disp(an); disp(an1); disp(an1); pause;
tmp=isequal(strtrim(lower(input('Is MATLAB Database Toolbox installed (yes/no)?: ', 's'))), 'yes');
quit_matlab=0;
if tmp==1, 
    mysql.is_set=isequal(strtrim(lower(input('Is MySQL installed (yes/no)?: ', 's'))), 'yes');
    if mysql.is_set==1, 
        str=input('Please give the full path to the MySQL Java Connector (jar file): ', 's'); 
        fid=fopen(strcat(matlabroot, filesep, 'toolbox', filesep, 'local', filesep, 'classpath.txt'), 'a'); fprintf(fid, '\n%s', str); fclose(fid);
        mysql.user=input('Please give the login for MySQL: ', 's'); mysql.pass=input('Please give the password for MySQL: ', 's'); 
        quit_matlab=isequal(strtrim(lower(input('In order to complete the installation you have to exit MATLAB and run init_tmg again! Quitting MATLAB (yes/no)? ', 's'))), 'yes');
        if quit_matlab~=1, an=sprintf('Installation has not been completed! Please run init_tmg again! '); disp(an); return; end
        mysql.run=1;
    end
else, 
    mysql.is_set=0;
end
save mysql_info mysql;

% add directories to path
disp(an1); an=sprintf('Adding directories to MATLAB path...'); disp(an); disp(an1); 
str=strcat(fileparts(mfilename('fullpath'))); addpath(str); 
an=sprintf('Adding directory %s...', str); disp(an);
str=strcat(fileparts(mfilename('fullpath')), filesep, 'classification'); addpath(str); 
an=sprintf('Adding directory %s...', str); disp(an);
str=strcat(fileparts(mfilename('fullpath')), filesep, 'clustering'); addpath(str); 
an=sprintf('Adding directory %s...', str); disp(an);
str=strcat(fileparts(mfilename('fullpath')), filesep, 'data'); addpath(str); 
an=sprintf('Adding directory %s...', str); disp(an);
str=strcat(fileparts(mfilename('fullpath')), filesep, 'documentation'); addpath(str); 
an=sprintf('Adding directory %s...', str); disp(an);
str=strcat(fileparts(mfilename('fullpath')), filesep, 'dr'); addpath(str); 
an=sprintf('Adding directory %s...', str); disp(an);
str=strcat(fileparts(mfilename('fullpath')), filesep, 'results'); addpath(str); 
an=sprintf('Adding directory %s...', str); disp(an);
str=strcat(fileparts(mfilename('fullpath')), filesep, 'retrieval'); addpath(str); 
an=sprintf('Adding directory %s...', str); disp(an);
str=strcat(fileparts(mfilename('fullpath')), filesep, 'sample_documents'); addpath(str); 
an=sprintf('Adding directory %s...', str); disp(an);
str=strcat(fileparts(mfilename('fullpath')), filesep, 'var'); addpath(str); 
an=sprintf('Adding directory %s...', str); disp(an);
str=strcat(fileparts(mfilename('fullpath')), filesep, 'var', filesep, 'ANLS'); addpath(str); 
an=sprintf('Adding directory %s...', str); disp(an);
str=strcat(fileparts(mfilename('fullpath')), filesep, 'var', filesep, 'NNDSVD'); addpath(str); 
an=sprintf('Adding directory %s...', str); disp(an);
str=strcat(fileparts(mfilename('fullpath')), filesep, 'var', filesep, 'PROPACK'); addpath(str); 
an=sprintf('Adding directory %s...', str); disp(an);
str=strcat(fileparts(mfilename('fullpath')), filesep, 'var', filesep, 'SPQR'); addpath(str); 
an=sprintf('Adding directory %s...', str); disp(an);
str=strcat(fileparts(mfilename('fullpath')), filesep, 'var', filesep, 'SDDPACK', filesep, 'matlab'); addpath(str); 
an=sprintf('Adding directory %s...', str); disp(an);
savepath;
if quit_matlab==1, quit; end

% create database for TMG
function res=create_database(mysql)
if mysql.is_set==0, 
    res=-1; return;
end
conn=database('mysql', mysql.user, mysql.pass, 'com.mysql.jdbc.Driver', 'jdbc:mysql://127.0.0.1:3306/mysql');
if ~isempty(conn.Message), an=sprintf('MySQL: Unknown user or wrong password... Skipping...'); disp(an); res=-1; return; end
str1='create database TMG;';
str2='use TMG;';
str3='create table COLLECTION (id INT PRIMARY KEY AUTO_INCREMENT, name TEXT, location TEXT, ndocs_tot INT, ndocs_act INT, nterms INT, terms_per_doc DOUBLE, ind_terms_per_doc DOUBLE, sparsity DOUBLE, rem_tl INT, rem_g INT, rem_l INT, rem_stop INT, rem_stem INT);';
str4='create table DOCUMENT (id BIGINT PRIMARY KEY AUTO_INCREMENT, body LONGTEXT, collection_id INT, doc_id BIGINT, FOREIGN KEY (collection_id) REFERENCES COLLECTION(id) ON DELETE CASCADE);';
res=exec(conn, str1); res=exec(conn, str2); res=exec(conn, str3); res=exec(conn, str4); res=1;