function p = log_map( b,x )
% LOG_MAP The log map for n-spheres
% b is the base point (vector in R^n), norm(b)=1
% x is a point on the hypersphere (also a vector in R^n), norm(x)=1

	if (x==b)
		p = b;
	else
	
	theta = acos(dot(b,x));
	alpha = acos((4+norm(b+x).^2-norm(x-b).^2)./(2.*2.*norm(b+x)));
	p2 = (2.*(b+x))./(norm(b+x).*cos(alpha)) - b;
	p = b+((p2-b)./norm(p2-b)).*theta;

end