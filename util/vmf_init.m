function [P, Q] = vmf_init(m, n, no_dim, kappa, mu)  
    % --initialization by VMF distribution---

    P  = randvonMisesFisherm(no_dim, m, kappa, mu); 
    Q  = randvonMisesFisherm(no_dim, n, kappa, mu); 
      
end
 