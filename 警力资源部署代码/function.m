function y=mx(W1,W2,W3,f,D,n)
    y=0
    for i=1:n
        y=y+D(i)*(W1*f(i,1)+W2*f(i,2)+W3*f(i,3))
    end
end

function 