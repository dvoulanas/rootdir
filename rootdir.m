function [status,msg,msgID,mk_path_fin]=rootdir(root,dir_lvl,dir_names)
%This function creates directories relative to specified root directory
%
%Inputs:
% - root: root directory where the directories are to be created (char vector)
% - dir_lvl: level of directory, relative to root directory (string row vector)
% - dir_names: name of each correspoding directory (string row vector)
%
% Outputs:
%     1. status -> Folder creation status indicating whether the attempt to
%          create the folder is successful, returned as 0 or 1. 
%          If the attempt to create the folder is successful or the folder 
%          already exists,then the value of status is 1. Otherwise, the
%          value is 0.
%     2. msg -> Error message, returned as a character vector. If an error
%          or warning occurs, msg contains the message text of the error or
%          warning. Otherwise, msg is empty, ''.
%	  3. msgID -> Error message identifier, returned as a character vector.
%          If an error or warning occurs, msgID contains the message identifier
%          of the error or warning. Otherwise, msgID is empty, ''.
%	  4. mk_path_fin -> the yielded full file paths.

% to do list:
% - automatic report generation
% - improve processing speed via mexing or not ->pre-allocate all cells
% and matrixes (too large paths of directory cannot be created because
% there is a limit and actually there is no point of such paths
% but I want to try to make it faster)
% - GUI
% Coded by Voulanas Dimitrios on 2019-05-12
% Copyright (c) 2019 Dimitrios Voulanas. 
% http://https://github.com/dvoulanas
% e-mail: dvoulanas@yahoo.com
% All rights reserved.
 
% Redistribution and use in source and binary forms, with or without
% modification, are permitted provided that the following conditions are 
% met:
% 	* Redistributions of source code must retain the above copyright 
%     notice, this list of conditions and the following disclaimer.
% 	* Redistributions in binary form must reproduce the above copyright 
%     notice, this list of conditions and the following disclaimer in the 
%     documentation and/or other materials provided with the distribution.
% 	* The names of its contributor must not be used to endorse or promote products 
%     derived from this software without specific prior written permission.
%
% THIS SOFTWARE IS PROVIDED BY Dimitrios Voulanas ''AS IS'' AND ANY EXPRESS OR 
% IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES 
% OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. 
% IN NO EVENT SHALL Dimitrios Voulanas BE LIABLE FOR ANY DIRECT, INDIRECT, 
% INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT 
% NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
% DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY 
% THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT 
% (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE 
% OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.


% %Number of repetitions, diff(dir_lvl)~=0 -> TRUE only if values change
n=diff(find([true,diff(dir_lvl')~=0,true]));
% %unique numbers of levels of directory
a=unique(dir_lvl);
% %presets the first level
path_temp=dir_names(dir_lvl==1);
% %makes the paths
if size(n,2)>1
k_start=1;
k_end=1;
for j=2:size(n,2)
    loglvlpath=a(j)==dir_lvl;
    lvlpath_str=dir_names(loglvlpath);
    for i=1:n(j)        
      path_fin(:,k_start:k_end)=path_temp+"\"+lvlpath_str(i);   
      k_start=k_end+1;
      k_end=k_end+size(path_temp,2);
    end   
    path_temp=path_fin;
    k_end=k_start+size(path_temp,2)-1;
end
else
path_fin=path_temp;
end
% %counts times of '\' occurence. Those with the largest number are the
% %indended paths
count_lvl=strfind(path_fin,'\');
if iscell(count_lvl)
num_lvls=cellfun('size',count_lvl,2);
else
num_lvls=size(count_lvl,2); 
end
% %finds the number the maximum level, in case the path levels in dir_lvl
% %is scrabled (Haven't tested it though in this way)
max_lvl=max(max(num_lvls));
% %The indended paths, relative to root, to be created 
mk_path=path_fin(num_lvls==max_lvl);
% %add the root path to the yielded paths
if root(end)=='\'
  mk_path_fin=strcat(root,mk_path);
else
  mk_path_fin=strcat(root,"\",mk_path);   
end
for i=1:size(mk_path_fin,1)
 [status(i,:),msg_temp,msgID_temp]=mkdir(char(mk_path_fin(i)));
 msg(i,:)=string(msg_temp);
 msgID(i,:)=string(msgID_temp);
end
end
