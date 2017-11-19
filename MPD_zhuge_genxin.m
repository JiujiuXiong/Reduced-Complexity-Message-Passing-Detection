function [out1,out2,out3,out4,out5] = MPD_zhuge_genxin(K,J,Z,N0v,s,t,Es,E_guiyi)
%�ж�Ӧ2K������ �ж�Ӧ16�����ŵĸ���
D=0.33;
if t==1
    sym_=[-1,+1]/E_guiyi;
    p_cs=0.5;
    cs=2;
elseif t==2
        sym_=[-3:2:3]/E_guiyi;
        p_cs=0.25;
        cs=4;
    elseif t==3
        sym_=[-7:2:7]/E_guiyi;
        p_cs=0.125;
        cs=8;
        else 
       sym_=[-15:2:15]/E_guiyi;
       p_cs=0.0625;
       cs=16;
end

pro=(p_cs)*ones(2*K,cs);%��ʼ�� ÿһ�����ŵĸ���Ϊ1��16

L=zeros(2*K,cs);

for t=1:s% ������ѭ�� 
    for i_=1:2*K%����xi��ѭ��
         for j_=1:2*K%���ֵ�����ͨ���ѭ��
              a(j_) =J(i_,j_) *(sym_*pro(j_,:)');%��xj�þ�ֵ������xi������xi
              b(j_)=(J(i_,j_).^2)*((sym_.^2)*pro(j_,:)'-(abs(sym_*pro(j_,:)'))^2);    
         end
         bb(:,i_,t)=b;
       %���
         c(i_)= sum(a(:))-a(i_);
         d(i_)= sum(b(:)) - b(i_) + N0v;
        %������һ�ε�������Ҫ����Ϣ�Ѿ�������� 
         %��ÿ�����ŵĶ�����Ȼ��
         for n_=1:cs
              L(i_,n_)=(J(i_,i_)*(sym_(n_)-sym_(1)))*(2*Z(i_)-2*c(i_)-J(i_,i_)*sym_(n_)-J(i_,i_)*sym_(1))/(2*d(i_));
         end 
         for i_c=1:cs
              if L(i_,i_c)>709
                 L(i_,:)=L(i_,:).*0.5;
              end
         end
          for n=1:cs
             pro_(i_,n)=exp(L(i_,n))/(sum(exp(L(i_,:))));%���µĸ���
             pro(i_,n)=(1-D).* pro_(i_,n)+D.*pro(i_,n);%������������
         end 
    end 
      %��ֹ����̫С ����llr��ֵ����709 ��ʹeָ��ֵ����MATLAB��������     
    LL(:,:,t)=L;
  %�ⲿ��ֻ�Ǽ�������ʵĲ���
dd(:,t)=d;
pp(:,:,t) =pro;  
end

out1=L;
out2=pp;
out3=dd;
out4=bb;
out5=LL;


