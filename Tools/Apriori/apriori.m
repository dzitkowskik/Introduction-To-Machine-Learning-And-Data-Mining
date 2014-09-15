function [AssocRules, FrqItemsets, Summary1, Summary2] = ...
    apriori(filename, minSup, minConf, maxRule)
% RUNAPRIORI Mine for associations based on the Apriori algorithm
%
% The Apriori algorithm used in the script is provided by http://www.borgelt.net//apriori.html, for
% details of the algorithm see also http://www.borgelt.net//doc/apriori/apriori.html
%
% Usage
%   [AssocRules, FrqItemsets, Summary1, Summary2] = ...
%       apriori(filename, minSup, minConf, maxRule);
%
% Input
%   filename     A string defining the name of the file to mine for
%                associations, the file needs to be comma separated.
%   minSup       Minimum support in percentage of data points
%   minConf      Minimum confidence in percentage
%   maxRule      Define the largest number of items in an association
%                      rule (default = 4)
%
% Output
%   FrqItemsets  Cell array containing frequent itemsets
%   AssocRules   Cell array containing the found association rules
%   Summary1     Output summary of the Apriori algorithm extracting
%                frequent itemsets
%   Summary2     Output summary of the Apriori algorithm extracting
%                association rules
%
% Copyright 2011, Morten Mørup and Mikkel N. Schmidt, Technical University
% of Denmark
% BUGFIX: 2012, Piotr Sapie¿yñski, Technical University of Denmark

if nargin<4
    maxRule=4;
end

pth = [fileparts(which('apriori')) filesep];

% Run Apriori Algorithm
disp('Mining for frequent itemsets by the Apriori algorithm');
if ~isempty(regexp(computer,'WIN', 'once'))
    [status1, Summary1] = system(['"' pth 'apriori.exe" -f"," -s' num2str(minSup) ' -v"[Sup. %0S]" "' filename '" "apriori_temp1.txt"']);
else
    [status1, Summary1] = system(['"' pth './apriori" -f"," -s' num2str(minSup) ' -v"[Sup. %0S]" "' filename '" "apriori_temp1.txt"']);
end
if status1~=0
    disp(Summary1);
    error('An error occured while calling apriori');
    disp(Summary1);
    return;
end

if minConf>0
    disp('Mining for associations by the Apriori algorithm');
    if ~isempty(regexp(computer,'WIN', 'once'))
        [status2, Summary2] = system(['"' pth 'apriori.exe" -tr -f"," -n' num2str(maxRule) ' -c' num2str(minConf) ' -s' num2str(minSup) ' -v"[Conf. %0C,Sup. %0S]" "' filename '" "apriori_temp2.txt"']);
    else
        [status2, Summary2] = system(['"' pth './apriori" -tr -f"," -n' num2str(maxRule) ' -c' num2str(minConf) ' -s' num2str(minSup) ' -v"[Conf. %0C,Sup. %0S]" "' filename '" "apriori_temp2.txt"']);
    end
    if status2~=0
        disp(Summary2);
        error('An error occured while calling apriori');
        return;
    end
else
    Summary2 = '';
end

% Extract estimated associated from stored file apriori_temp1.txt
disp('Apriori analysis done, extracting results');

if nargout > 1
	disp('Extracting frequent itemsets...');
	disp('----> loading apriori_temp1.txt to memory');
	% Extract Frequent Itemsets
	fid=fopen('apriori_temp1.txt'); 
	F = textscan(fid, '%s','delimiter','\n');
	fclose(fid);
	disp('----> apriori_temp1.txt loaded to memory');
	FrequentItemsets = F{1};
	sup = zeros(length(FrequentItemsets),1);

	sups = regexp(FrequentItemsets, 'Sup. (\d)+','tokens');
	for t = 1:length(F)
	    sup(t) = str2double(sups{t});
	end
	[val,ind]=sort(sup,'descend');
	FrqItemsets=FrequentItemsets(ind,1);
end
disp('Extracting association rules...');

% Extract Association rules
if minConf>0
    disp('----> Loading apriori_temp2.txt to memory');
    fid=fopen('apriori_temp2.txt'); 
    A = textscan(fid, '%s','delimiter','\n');
    fclose(fid);
    disp('----> apriori_temp2.txt loaded to memory');
    AssocRules = A{1};
    conf = zeros(length(AssocRules),1);
    confs = regexp(AssocRules,'Conf\. ([^,])+','tokens');
    for t = 1:length(AssocRules)
        conf(t) = str2double(confs{t});
    end
    [val,ind]=sort(conf,'descend');
    AssocRules=AssocRules(ind,1); 
else
    AssocRules='Condidence set to zero'
end

% Delete temporary files
delete('apriori_temp1.txt');
delete('apriori_temp2.txt');
