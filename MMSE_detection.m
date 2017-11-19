%   MMSE Detection
%   ���룺   H:    channel matrix
%           y:     receive bits
%           sigma:   ���ŵ�����������
%           M:    ����������
%   �����   x��    ���Ƶ���������
function x=MMSE_detection(H,r,sigma,M)
% function x=MMSE_detection(H,r,M)
    W = (H' * H) + sigma.*eye(M);
    b = H'*r;
    x = inv(W)*b;
   
