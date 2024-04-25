function S = goertzel(s, ind)
  N = length(s);
  for k = 1:length(ind)s
    
    w = exp(2i*pi*(ind(k))/N);
    
    %alpha
    alpha = 2*cos(2*pi*(ind(k))/N);
    
    % second-order IIR 
    b = [w, -1, 0];
    a = [1, -alpha, 1];
    X = filter(b, a, s);
    S(k) = X(end);
  end

  