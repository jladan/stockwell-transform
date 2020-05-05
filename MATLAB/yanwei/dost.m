%% One dimensional fast DOST
%% Basically a straight copy from Yangwei's thesis

function bas2 = dost(signal)

  % change signal to a row, since that's beetter for my code
  si = size(signal);

  % obtain the values of nu, beta, and tau for this basis (symmetric dost)
  N = length(signal);
  [v, b, t, num, compact_b] = get_vbt(N);

  % Calculate FFT
  fsignal = fftshift(fft(signal));

  % Use the IFFT to calculate DOST coefficients
  bas2 = zeros(si);
  p = 0;
  coof = -pi*1i;
  for l = 1:num
    step = compact_b(l);
    % Construct the corresponding ramp matrix
    ramp = (-1).^(1:step);

    temp_matrix = ifft(fsignal(p+1:p+step))*sqrt(step);
    if size(ramp) == size(temp_matrix)
        bas2(p+1:p+step) = ramp .* temp_matrix;
    else
        bas2(p+1:p+step) = ramp .* transpose(temp_matrix);
    end
    
    if v(p+1) <0
      % reverse order of bas2 between p+1 and p+step
      bas2(p+1:p+step) = fliplr(bas2(p+1:p+step));
      % prepare ramp to time shift
      ramp2 = exp( t(p+(1:step) ) * 2*pi*1i/step);
      % perform ramp filter
      if size(ramp2) == size(bas2(p+1:p+step))
          bas2(p+1:p+step) = bas2(p+1:p+step).*ramp2;
      else
          bas2(p+1:p+step) = bas2(p+1:p+step).*transpose(ramp2);
      end
    end

    clear temp_matrix;
    clear ramp;

    p=p+step;
  end
  % rescale to normalize
  bas2 = -bas2/N;

  % end of DOST
end

