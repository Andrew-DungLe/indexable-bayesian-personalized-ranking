function xdot = proj(x, d)
   xdot = d - x*(x(:).'*d(:));
end