% Please complete the TWO TODOs below to implement a fingerprint based localisation system

close all
clearvars

dataset_name = 'dataset/set1';

% read APs
APs= importdata([dataset_name '/APloc.txt']);
num_aps = size(APs.data, 1);

%% offline phase: build radio map by using training data

% get file names
dir_train = [dataset_name '/wifiData/'];
[status, cmdout] = system(['ls ', dir_train '| sort -k1.6 -n']);
file_names = regexp(cmdout, '.txt\n', 'split');

num_files = length(file_names) - 1;
radio_map = zeros(num_files, 2 + num_aps * 2);

% read training data and build radio map
for i = 1:num_files
    % for each file (RSSI collected at a specific fingerprinting position)

    file_name = [dir_train file_names{i} '.txt'];

    % read fingerprinting position
    fid = fopen(file_name);
    loc_xy = textscan(fid, '%f %f', 1);
    fclose(fid);

    % read RSSI of APs
    wifi = importdata(file_name,' ',1);
    rssi = wifi.data;
    rssi = reshape(rssi, num_aps, length(rssi) / num_aps)';

    % ----------------------
    % 1st TODO: build a radio map by using *rssi* and *loc_xy*
    % possible solution: [loc_x, loc_y, mu1, mu2, ...., muN, sigma1, sigma2, ....sigmaN], N is number of APs



    radio_map(i, :) =

    % ----------------------
end

%% online phase: estimate locations

% get file names
dir_test = [dataset_name '/testWifiData/'];
[status, cmdout] = system(['ls ', dir_test '| sort -k1.6 -n']);
file_names = regexp(cmdout, '.txt\n', 'split');

num_files = length(file_names) - 1;
num_fingerprints = size(radio_map, 1);
grount_truth = zeros(num_files, 2);
est_pos = zeros(num_files, 2);

% localise each point by using its wifi data
for i = 1:num_files
    file_name = [dir_test file_names{i} '.txt'];

    % read RSSI of APs at this position
    wifi = importdata(file_name,' ',1);
    rssi = wifi.data;
    rssi = reshape(rssi, num_aps, length(rssi) / num_aps)';

    % mean RSSI of APs
    rssi_aps = mean(rssi, 1);

    % ----------------------
    % 2nd TODO: calculate location by using current RSSI, rssi_aps, and the built radio map

    rssi_aps
    radio_map

    est_x =
    est_y =

    % estimated position
    est_pos(i,:) = [est_x, est_y];

    % ----------------------

    % save ground truth locations for evaluation
    fid = fopen(file_name);
    gt_xy = textscan(fid, '%f %f', 1);
    grount_truth(i,:) = [gt_xy{1}, gt_xy{2}];
    fclose(fid);

end

% plot trajectory
figure;
hold on;
plot(APs.data(:,1), APs.data(:,2), 'rs', 'LineWidth', 2, 'MarkerSize', 10);
plot(grount_truth(:,1), grount_truth(:,2), 'LineWidth', 2);
plot(est_pos(:,1), est_pos(:,2), 'o--', 'LineWidth', 1.2);
xlabel('X (m)'); ylabel('Y (m)');
legend('Access Points', 'Ground Truth', 'Estimated Positions');

% plot CDF
figure;
loc_errors = sqrt((grount_truth(:,1) - est_pos(:,1)).^2 + (grount_truth(:,2) - est_pos(:,2)).^2);
cdfplot(loc_errors);
xlabel('Distance Error (m)'); ylabel('Probability');

