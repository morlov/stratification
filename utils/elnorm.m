function z = elnorm(x, i)
z = x ./ repmat( x(i, :) , length(x),1) ;