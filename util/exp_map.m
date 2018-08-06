function x = exp_map( b,p )
% EXP_MAP The exponential map for n-spheres
% b is the base point (vector in R^n), norm(b)=1
% p is a point on the tangent plane to the hypersphere at b (also a vector in R^n)

	if (b==p)
		x=b;
	else

	theta = norm(b-p);
	dminusbx = sqrt(2-2.*cos(pi-theta));
	l = 2.*sin(theta/2);
	alpha = acos( (4+dminusbx.^2-l.^2)./(4*dminusbx) );
	dpb = 2.*tan(alpha);
	v = b + ((p-b)./norm(p-b)).*dpb;
	x = ((v+b)./norm(v+b)).*dminusbx-b;
end 