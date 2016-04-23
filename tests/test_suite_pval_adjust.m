%
% Unit test for pval_adjust.m
%
% These tests require the MOxUnit framework available at
% https://github.com/MOxUnit/MOxUnit
% 
% How to test:
%
% 1 - Run the R script generate_test_pvals.R
% 2 - Make sure MOxUnit and pval_adjust.m are in MATLABs search path
% 3 - Call the moxunit_runtests function
%    
% Copyright (c) 2016 Nuno Fachada
% Distributed under the MIT License (See accompanying file LICENSE or copy 
% at http://opensource.org/licenses/MIT)
%
function test_suite = test_suite_pval_adjust
    initTestSuite
    
function test_pval_adjust

    % Methods to test
    met = {'holm', 'hochberg', 'hommel', 'bonferroni', ...
        'BH', 'BY', 'fdr', 'none'};
    
    % Files containing p-values to test and verify
    lst = dir('out/pvals*.*');
    
    % Test each file
    for i = 1:numel(lst)
        
        % Load current file
        cur_file = ['out' filesep lst(i).name];
        m = dlmread(cur_file);
        
        % Test each method
        for j = 1:numel(met)
            res = pval_adjust(m(1, :), met{j});
            assertElementsAlmostEqual(res, m(j + 1, :));
        end;
        
    end;




