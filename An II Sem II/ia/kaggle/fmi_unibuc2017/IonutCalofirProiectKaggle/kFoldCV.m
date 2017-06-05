function [accuracy_k_fold_cv C] = kFoldCV(X, y, input_layer_size, hidden_layer_size, num_labels, lambda, nrIter, k)

m = floor(size(X, 1) / 10);
accuracy_k_fold_cv = [];
C = zeros(num_labels, num_labels);
for i = 1 : k
                                   fprintf('Iteratia: %d\n', i);
                                   lt = (i - 1) * m + 1;
                                   rt = i * m;

                                   XTrain = X;
                                   XTrain(lt : rt, :) = [];
                                   XValidation = X(lt : rt, :);

                                   yTrain = y;
                                   yTrain(lt : rt) = [];
                                   yValidation = y(lt : rt, :);

                                   % Antrenez reteaua
                                   [Theta1 Theta2] = nnTrain(XTrain, yTrain, input_layer_size, hidden_layer_size, num_labels, lambda, nrIter);

                                   pValidation = predict(Theta1, Theta2, XValidation);
                                   C(:, :, i) = confusionmat(yValidation, pValidation);
                                   accuracy_k_fold_cv = [accuracy_k_fold_cv; mean(double(pValidation == yValidation)) * 100];
end

accuracy_k_fold_cv = mean(accuracy_k_fold_cv);

end

