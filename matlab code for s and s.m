 
% MATLAB script: Animated convolution of a triangular and a rectangular (square) pulse
% Define time axis (sampled for visualization)
dt = 0.01;
t = -4:dt:4;                   % time range covering both signals

% Generate signals: triangular and rectangular pulses
tri_width = 2;                 % total width of the triangular pulse
rect_width = 2;                % width of the rectangular pulse
x = tripuls(t, tri_width);     % triangular pulse, unit height
h = rectpuls(t, rect_width);   % rectangular pulse, unit height

% (Optional) Compute reference convolution using conv for verification:
y_conv = conv(x, h) * dt;      % discrete convolution scaled by dt
t_conv = (t(1)+t(1)):dt:(t(end)+t(end));  % time axis for full convolution

% --- 1. AXIS LIMITS MODIFICATION ---
% Define new axis limits
new_t_min = -4;                % New minimum time limit
new_t_max = 4;                 % New maximum time limit
new_amp_min = -0.5;            % New minimum amplitude (Y)
new_amp_max = 1.5;             % New maximum amplitude (Y)

% Set up figure with two subplots
figure;
subplot(2,1,1);
hTri = plot(t, x, 'g', 'LineWidth', 2);   % fixed triangular signal
hold on;
hRect = plot(t, zeros(size(t)), 'r-', 'LineWidth', 2);  % placeholder for sliding pulse
% Apply new axis limits for the sliding window plot
axis([new_t_min new_t_max new_amp_min new_amp_max]);
xlabel('\tau');
ylabel('Amplitude');
legend('Triangular signal','Flipped Square signal','Location','northwest');
title('Step-by-Step Convolution: Sliding Window');

subplot(2,1,2);
hConv = plot(NaN, NaN, 'b', 'LineWidth', 2);  % placeholder for convolution output
hold on;
% Apply new axis limits for the convolution output plot
axis([t_conv(1) t_conv(end) new_amp_min new_amp_max]);
xlabel('t');
ylabel('Convolution y(t)');
title('Manual Convolution Output');

% --- 2. REPEAT ANIMATION MODIFICATION ---
% Animation loop: slide the square signal across the triangular and accumulate overlap
% We will use an outer loop to repeat the entire process indefinitely (or N times)
num_repetitions = 3; % Set how many times you want the animation to repeat

for rep = 1:num_repetitions
    y_anim = zeros(size(t)); % Reset convolution output for each repetition
    
    % Clear the previous convolution plot for a fresh start
    if rep > 1
        delete(hConv); % Remove the old line handle
        hConv = plot(NaN, NaN, 'b', 'LineWidth', 2); % Create a new placeholder
    end

    for w = 1:length(t)
        shift = t(w);
        % Compute the flipped and shifted version of h: h(shift - tau)
        h_shift = rectpuls(shift - t, rect_width);   % unit-height rectangle flipped & shifted
        
        % Compute convolution integral at this shift (area under product x.*h_shift)
        y_anim(w) = trapz(t, x .* h_shift);          % numeric integration (continuous conv)
        
        % Update the sliding signal (red) plot
        set(hRect, 'YData', h_shift);
        % Update convolution output plot up to current shift
        set(hConv, 'XData', t(1:w), 'YData', y_anim(1:w));
        
        drawnow;  % update figure
        % pause(0.01);  % optional slow-down for visualization
    end
    
    % Optional: Overlay final convolution result for reference after each cycle
    plot(t_conv, y_conv, 'w--','LineWidth',1.5); % Changed to blue dashed line for better visibility
    legend('Convolution (animation)','Convolution (full)','Location','northwest');
    
    % Pause before starting the next cycle
    pause(1); 
end