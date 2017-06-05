function plotDecisionBoundary(theta, bias)
    % Here is the grid range
    u = linspace(-10, 10, 100);
    v = linspace(-10, 10, 100);

    z = zeros(length(u), length(v));
    % Evaluate z = theta*x over the grid
    for i = 1:length(u)
        for j = 1:length(v)
            z(i,j) = theta*mapFeature(u(i), v(j)) + bias;
        end
    end
    z = z'; % important to transpose z before calling contour

    % Plot z = 0
    % Notice you need to specify the range [0, 0]
    contour(u, v, z, [0, 0], 'LineWidth', 1)

end
