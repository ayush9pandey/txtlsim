function simBioSpecies = txtl_addspecies(tube, name, amount)
%TXTL_ADDSPECIES   Add one or more molecular species to a tube
%
% Sobj = TXTL_ADDSPECIES(tube, name, amount) adds a molecule to a
% tube, in the gen amount (in nM).  The species can be a new species or
% one that already exists (in which case its concentration is added to
% what is already present).

% Written by Richard Murray, 11 Sep 2012
%
% Copyright (c) 2012 by California Institute of Technology
% All rights reserved.
%
% Redistribution and use in source and binary forms, with or without
% modification, are permitted provided that the following conditions are
% met:
%
%   1. Redistributions of source code must retain the above copyright
%      notice, this list of conditions and the following disclaimer.
%
%   2. Redistributions in binary form must reproduce the above copyright 
%      notice, this list of conditions and the following disclaimer in the 
%      documentation and/or other materials provided with the distribution.
%
%   3. The name of the author may not be used to endorse or promote products 
%      derived from this software without specific prior written permission.
%
% THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS'' AND ANY EXPRESS OR
% IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
% WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
% DISCLAIMED. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT,
% INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
% (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
% SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
% HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
% STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING
% IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
% POSSIBILITY OF SUCH DAMAGE.


% check 
if (size(amount,2) > 1)
    assert(size(name,2) == size(amount,2));
end

index = findspecies(tube, name);

if size(index,2) > 1 
    for k =1:size(index,2)
        addOneSpecie(tube,name{k},amount{k},index(k));
    end
else
    if iscell(name)
        addOneSpecie(tube,name{1},amount{1},index);    
    else
        addOneSpecie(tube,name,amount,index);    
    end
    
end

indexPost = findspecies(tube, name);
simBioSpecies = tube.Species(indexPost); 

end

function addOneSpecie(tube,name,amount,index)
    % if amount wasn't specified then make it zero
    if isempty(amount)
            amount = 0;
    end
        
    if (index == 0)
        addspecies(tube, name, amount);
    else
      tube.Species(index).InitialAmount = ...
        tube.Species(index).InitialAmount + amount;
        tube.Species(index);
    end
end
% Automatically use MATLAB mode in Emacs (keep at end of file)
% Local variables:
% mode: matlab
% End:
