function pc = pval_adjust(p, method)
% PVAL_ADJUST Adjust p-values for multiple comparisons. Given a set of
% p-values, returns p-values adjusted using one of several methods. This is
% an implementation of the p.adjust R function, the documentation of which
% can be found at http://www.inside-r.org/r-doc/stats/p.adjust.
%
%   pc = PVAL_ADJUST(p, method)
%
% Parameters:
%        p - Numeric vector of p-values. Contrary to the R function, this
%            function does not handle NaNs.
%   method - Correction method, one of 'holm', 'hochberg', 'hommel', 
%            'bonferroni', 'BH', 'BY', 'fdr' or 'none'.
%
% Outputs:
%       pc - A numeric vector of corrected p-values, of the same length as
%            p.
%
% Copyright (c) 2016 Nuno Fachada
% Distributed under the MIT License (See accompanying file LICENSE or copy 
% at http://opensource.org/licenses/MIT)
%

% Number of p-values
np = numel(p);

% Method 'hommel' is equivalent to 'hochberg' of np == 2
if (np == 2) &&  strcmp(method, 'hommel')
    method = 'hochberg';
end;

% Just one p-value? Return it as given.
if np <= 1

    pc = p;
    
% What method to use?
elseif strcmp(method, 'holm')
    
    % Sort p-values from smallest to largest
    [pc, pidx] = sort(p);
    
    % Adjust p-values
    for i = 1:np
        pc(i) = pc(i) * (np - i + 1);
    end;
    
    % Put p-values back in original positions
    pc(pidx) = pc;

elseif strcmp(method, 'hochberg')

    % Descendent vector
    vdec = np:-1:1;
    
    % Sort p-values in descending order
    [pc, pidx] = sort(p, 'descend');
    
    % Get indexes of p-value indexes
    [~, ipidx] = sort(pidx);
    
    % Hochberg-specific transformation
    pc = ((np + 1) - vdec) .* pc;

    % Cumulative minimum
    pc = cmin(pc);
    
    % Reorder p-values to original order
    pc = pc(ipidx);

elseif strcmp(method, 'hommel')

    % Not implemented
    error('Method not implemented');

elseif strcmp(method, 'bonferroni')
    
    % Simple conservative Bonferroni
    pc = p * numel(p);

elseif strcmp(method, 'BH') || strcmp(method, 'fdr')

    % Descendent vector
    vdec = np:-1:1;
    
    % Sort p-values in descending order
    [pc, pidx] = sort(p, 'descend');

    % Get indexes of p-value indexes
    [~, ipidx] = sort(pidx);

    % BH-specific transformation
    pc = (np ./ vdec) .* pc;

    % Cumulative minimum
    pc = cmin(pc);    
    
    % Reorder p-values to original order
    pc = pc(ipidx);

elseif strcmp(method, 'BY')

    % Descendent vector
    vdec = np:-1:1;
    
    % Sort p-values in descending order
    [pc, pidx] = sort(p, 'descend');

    % Get indexes of p-value indexes
    [~, ipidx] = sort(pidx);

    % BY-specific transformation
    q = sum(1 ./ (1:np));
    pc = (q * np ./ vdec) .* pc;

    % Cumulative minimum
    pc = cmin(pc);    
    
    % Reorder p-values to original order
    pc = pc(ipidx);

elseif strcmp(method, 'none')
    
    % No correction
    pc = p;
    
else
    
    % Unknown method
    error('Unknown p-value adjustment method');
    
end;
    
% Can't have p-values larger than one
pc(pc > 1) = 1;    
    
% Helper function to determine the cumulative mininum
function p = cmin(p)

for i = 2:numel(p)
    if p(i) > p(i - 1)
        p(i) = p(i - 1);
    end;
end;

