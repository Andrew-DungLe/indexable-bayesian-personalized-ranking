function u_triple = gen_triple(user_data, u)
   u_data = user_data{u};
   u_triple = []; 
   if length(u_data) > 1
       t_u = [];
       for c_id = 1 : (length(u_data) - 1)
         i_indx = u_data{c_id}; 
         j_indx = u_data{c_id + 1};
         [p, q] = meshgrid(i_indx, j_indx);
         ij    = [p(:), q(:)]; 
         t_u   = [t_u; ij];
       end
       u_triple = [repmat(u, size(t_u, 1), 1), t_u];
   end
end