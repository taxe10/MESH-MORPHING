function H = homography_matrix_SVD(px_in,py_in,px_out,py_out)
A=zeros(8,9);
b=zeros(9,1);
k=1;
for i=1:size(px_in,2)
    A(k,:)=[-px_in(i),-py_in(i),-1,0,0,0,px_in(i)*px_out(i),py_in(i)*px_out(i),px_out(i)];
    A(k+1,:)=[0,0,0,-px_in(i),-py_in(i),-1,px_in(i)*py_out(i),py_in(i)*py_out(i),py_out(i)];
    k=k+2;
end
% h=inv(A'*A)*A'*b;
% h=[h;1];
[U,S,V] = svd(A);
h=V(:,9);
for i=1:3
    H(i,:)=h((i-1)*3+1:i*3);
end
end