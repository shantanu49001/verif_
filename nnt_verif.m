
%extra implementation: if we dont find that variable break loops.->at last.
a=y;  %model output object 
disp(y);
dataset= y.L1I1{1}.Values.Data; %getting simulation data for 1 output
disp(dataset);
L0_data = max(y.L0{1}.Values.Data(:));  % outermost layer: input layer 
dynamicArray = [true(1, 11)]; %initally all components true.

% Initialize structure to store results
results = struct(); %each layer element's string identifier; max value and min value from model simulation
valid_range=struct(); %each layer elememt's string identifier; max allowed vaue and min allowed value.
indexMap = containers.Map('KeyType', 'double', 'ValueType', 'char'); %each layer element's string identifier and index at dynamic array.
% Loop through L1 to L5 and I1, O1 subtypes
for i = 1:5
    for j = 1:2
        % Determine subtype
        if j == 1
            subtype = 'I1';
        else
            subtype = 'O1';
        end
        
        % Construct the variable name dynamically
        varName = sprintf('L%d%s', i, subtype);
        
        % Access the data using dynamic field names from model simulation
        % result 
        dataset = y.(varName){1}.Values.Data;
        
        % Find the maximum and minimum values in the dataset
        maxValue = max(dataset(:));
        minValue = min(dataset(:));
        
        % Compute the index for the dynamic array to store fasification
        % result
        arrayIndex = (i - 1) * 2 + j;
        indexMap(arrayIndex) = varName;

       

        % Store the results in the structure
        results.(varName) = struct('MaxValue', maxValue, 'MinValue', minValue, 'Index', arrayIndex);
    end
end




% Display the results structure
disp('Results Structure:');
disp(results);

% Print L0's data
fprintf('Variable: L0\n');
fprintf('Max Value: %f\n', max(y.L0{1}.Values.Data(:)));
fprintf('Min Value: %f\n', min(y.L0{1}.Values.Data(:)));
fprintf('Location: 0\n');
fprintf('\n');


%  access values from the results structure
for i = 1:5
    for j = 1:2
        % Determine subtype
        if j == 1
            subtype = 'I1';
        else
            subtype = 'O1';
        end
        
        varName = sprintf('L%d%s', i, subtype);
        fprintf('Variable: %s\n', varName);
        fprintf('Max Value: %f\n', results.(varName).MaxValue);
        fprintf('Min Value: %f\n', results.(varName).MinValue);
        fprintf('Index : %d\n', results.(varName).Index);
        fprintf('\n');
    end
end
%lovcation of nn element in truth result array
fprintf('\n');
for index = 1:length(dynamicArray)
    value = dynamicArray(index);
    if islogical(value)
        % If value is logical, print 'true' or 'false'
        fprintf('%d\t%s\n', index-1, mat2str(value));
    else
        % Print the actual numeric value
        fprintf('%d\t%f\n', index-1, value);
    end
end

% Initialize valid_range structure to store fixed values: this is the vaue
% of max and min range of allowed fluctuation of each nn layer element
valid_range = struct();

% Loop through L0 to L5 and I1, O1 subtypes
for i = 0:5
    for j = 1:2
        % Determine subtype
        if j == 1
            subtype = 'I1';
        else
            subtype = 'O1';
        end
        
        % Construct the variable name dynamically
        if i == 0
            varName = 'L0';
        else
            %search for this nn eleemnt signal time array 
            varName = sprintf('L%d%s', i, subtype);
        end
        
        % Compute the index for the valid_range array
        arrayIndex = (i - 1) * 2 + j;
        
        % Store the fixed range values in the valid_range structure
        valid_range.(varName) = struct('MaxValue', 2, 'MinValue', -2); 
    end
end

% Print the valid_range structure
disp('Valid Range Structure:');
for i = 0:5
    for j = 1:2
        % Determine subtype
        if j == 1
            subtype = 'I1';
        else
            subtype = 'O1';
        end
        
        varName = sprintf('L%d%s', i, subtype);
        if isfield(valid_range, varName)
            fprintf('Variable: %s\n', varName);
            fprintf('Max Value: %f\n', valid_range.(varName).MaxValue);
            fprintf('Min Value: %f\n', valid_range.(varName).MinValue);
        
            fprintf('\n');
        end
    end
end

% Display the map contents
disp('Index to Variable Map:');
keys = indexMap.keys;
for k = 1:length(keys)
    index = keys{k};
    varName = indexMap(index);
    fprintf('Index: %d -> Variable: %s\n', index, varName);
end

% Now, iterate through the keys in the indexMap and check if the actual range falls inside the allowed range
keys = indexMap.keys;
for k = 1:length(keys)
    index = keys{k};
    if dynamicArray(index) % only check if the value is true
        varName = indexMap(index); % get the variable name using the index
        actualMax = results.(varName).MaxValue; % get actual max value from results
        actualMin = results.(varName).MinValue; % get actual min value from results
        allowedMax = valid_range.(varName).MaxValue; % get allowed max value from valid_range
        allowedMin = valid_range.(varName).MinValue; % get allowed min value from valid_range
        
        % Check if the actual range falls inside the allowed range
        if actualMax > allowedMax || actualMin < allowedMin
            fprintf('Signal %s''s actual range [%f, %f] falls outside the allowed range [%f, %f]\n', varName, actualMin, actualMax, allowedMin, allowedMax);
            dynamicArray(index) = false; % update the truth value in the dynamic array
        end
    end
end

% Print the truth value of each variable in the dynamic array
fprintf('Truth values in the dynamic array:\n');
for k = 1:length(keys)
    index = keys{k};
    varName = indexMap(index);
    if dynamicArray(index)
        fprintf('Variable %s at index %d is true\n', varName, index);
    else
        fprintf('Variable %s at index %d is false\n', varName, index);
    end
end
% Calculate the prefix AND for the dynamic array
for i = 2:length(dynamicArray)
    dynamicArray(i) = dynamicArray(i) & dynamicArray(i-1);
end

% Print the ith state of nn 
fprintf('Verification Result\n');
for i = 1:length(dynamicArray)
    fprintf('Index %d: %s\n', i, mat2str(dynamicArray(i)));
end
% Iterate through the dynamic array to find the first false value
falsified = false;
for i = 1:length(dynamicArray)
    if ~dynamicArray(i)
        varName = indexMap(i); % Get the variable name using the index
        fprintf('Falsified at %s\n', varName);
        falsified = true;
        break;
    end
end

% If no false value is found, print verification message
if ~falsified
    fprintf('No falsification; model verified\n');
end
