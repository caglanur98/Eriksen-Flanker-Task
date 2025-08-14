% % Initialize output structure array
output = struct('participant', {});

% Iterate over each participant
for i = 1:16 
    % Load the table from the input file
    filename = [num2str(i) '.mat'];
    data = load(filename);
    p = data.p;
    % Extract the first three columns of the table
    condition = p.TrialData(:, 1); %condition is congruency
    accuracy = p.TrialData(:, 2);
    time = p.TrialData(:, 3);
    
    % Initialize vectors to store the reaction times for correct responses
    congruent_rt = [];
    incongruent_rt = [];
    neutral_rt = [];

    
    % Iterate over each trial in the data set
    for j = 1:length(accuracy)
    
        % Check if the trial was congruent or incongruent
        if condition(j) == 1 % Congruent trial
            if accuracy(j) == 1 % Check if it was a correct response
                congruent_rt = [congruent_rt time(j)]; % Add the reaction time to the vector of congruent RTs
            end
    
        elseif condition(j) == 2 % Incongruent trial
            if accuracy(j) == 1 % Check if it was a correct response
                incongruent_rt = [incongruent_rt time(j)]; % Add the reaction time to the vector of incongruent RTs
            end

         elseif condition(j) == 0 % Neutral trial
            if accuracy(j) == 1 % Check if it was a correct response
                neutral_rt = [neutral_rt time(j)]; % Add the reaction time to the vector of neutral RTs
            end
        end
    end

end

    % Calculate the mean and standard deviation for each condition
    mean_rt = [mean(congruent_rt), mean(incongruent_rt), mean(neutral_rt)];
    std_rt = [std(congruent_rt), std(incongruent_rt), std(neutral_rt)];

    % Find the maximum length of the three vectors
    max_length = max([length(congruent_rt), length(incongruent_rt), length(neutral_rt)]);

    % Find the median RT for each condition, ignoring NaN values
    congruent_median = median(congruent_rt, 'omitnan');
    incongruent_median = median(incongruent_rt, 'omitnan');
    neutral_median = median(neutral_rt, 'omitnan');

    % Pad the shorter vectors with medians
    if length(congruent_rt) < max_length
        congruent_rt(end+1:max_length) = congruent_median;
    end
    if length(incongruent_rt) < max_length
        incongruent_rt(end+1:max_length) = incongruent_median;
    end
    if length(neutral_rt) < max_length
        neutral_rt(end+1:max_length) = neutral_median;
    end
    

%     % Check if the data is normally distributed (you will need sw-test adds-on)
%     [congruent_normal, congruent_p] = swtest(congruent_rt);
%     [incongruent_normal, incongruent_p] = swtest(incongruent_rt);
%     [neutral_normal, neutral_p] = swtest(neutral_rt);
%     % the p-value is < 0.05 - data is not normally distributed
    
    
    % The data is not normally distributed, that's why we should use
    % Friedman's test instead of ANOVA with repeated measures
    rt = [congruent_rt', incongruent_rt', neutral_rt'];
    [p_val,l,stats] = friedman(rt,1,'on');
    
%     % Apply Bonferroni correction for multiple comparisons
%     alpha = 0.05;
%     num_comparisons = 3;
%     threshold = alpha/num_comparisons;
%     adjusted_p_val = p_val*num_comparisons;
%     
    disp(['p-value = ' num2str(p_val)]);
    disp(l);
    disp(stats);
    
    % Store the results in the output structure
    


    
    % Display p-values for each participant
    for i = 1:16
    output(i).participant = i;
    output(i).p_val = p_val;
   
    disp(output(i))
    end

    



% % Plot the mean reaction times and error bars for each condition
figure;
errorbar(mean_rt, std_rt, 'o', 'LineWidth', 2);
xlabel('Condition');
ylabel('Mean Reaction Time (ms)');
set(gca, 'XTick', 1:3, 'XTickLabel', {'Congruent', 'Incongruent', 'Neutral'});
title('Mean Reaction Times');
grid on;


