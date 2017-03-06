function unit_test
    % Stratify strictly dominating layers
    assert(kmeansStrat_test1, 'kmeans stratification test Failed.');
    fprintf('kmeans stratification test1 passed!\n');
end

function status = kmeansStrat_test1
x = [5 5; 4 5; 5 4; 3 2; 2 3; 2 2; 1 0; 0 1; 0 0 ];
[~, index] = kmeansStrat(x, 3, 25);
status = all(index == [3 3 3 2 2 2 1 1 1]');
end