
%% Function to get the parameters
function [v, b, t, num, compact_b] = get_vbt(N)
  count = 0;
  end_p = log2(N)-1;
  b=zeros(1,N);
  v=zeros(1,N);
  t=zeros(1,N);
  compact_b=zeros(1,2*end_p +2);
  num=0;

  % Negative frequencies
  count = count+1;
  v(count) = -N/2 +.5;
  b(count) = 1;
  t(count) = 0;
  num=num+1;
  compact_b(num)=b(count);

  for p=end_p:-1:2
    freq = -2^(abs(p)-2) *3 +1;
    beta = 2^(abs(p)-1);
    for tau = (beta - 1):-1:0
      count=count+1;
      v(count) = freq;
      b(count) = beta;
      t(count) = tau;
    end
    num=num+1;
    compact_b(num)=beta;
  end


  % Positive frequencies
  count = count+1;
  v(count) = .5;
  b(count) = 1;
  t(count) = 0;
  num=num+1;
  compact_b(num)=b(count);

  count = count+1;
  v(count) = 1.5;
  b(count) = 1;
  t(count) = 0;
  num=num+1;
  compact_b(num)=b(count);

  for p=2:end_p
    freq = 2^(abs(p)-2) *3;
    beta = 2^(abs(p)-1);
    for tau = 0:(beta-1)
      count=count+1;
      v(count) = freq;
      b(count) = beta;
      t(count) = tau;
    end
    num=num+1;
    compact_b(num)=beta;
  end
