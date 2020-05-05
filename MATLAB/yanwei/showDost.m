% returns a matrix, which should give a visualization of the DOST

function vis = showDost(d)
  N=max(size(d));
  vis=zeros(N);

  [v,b,t,num,cb] = get_vbt(N);
  ind_i=N;
  ind_j=1;

  for l = 1:N
    height = b(l);
    length = N/height;
    for k = ind_i:-1:(ind_i-height+1)
      for j = ind_j:(ind_j+length -1)
        vis(k,j)=d(l);
      end
    end
    if b(l) ~= 1 && l<N
      if b(l) ~= b(l+1)
        ind_i=ind_i-height;
        ind_j=1;
      else
        ind_j=ind_j+length;
      end
    else
      ind_i=ind_i-height;
      ind_j=1;
    end
  end

  for k=(N/2+1):N
    vis(k,1:N) = vis(k, N:-1:1);
  end

end
