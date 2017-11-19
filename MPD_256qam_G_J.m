
function [out1,out2,out3,out4,out5] = MPD_256qam_G_J(K,J,Z,N0v,s,t,Es,E_guiyi)
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
youxiao=zeros(2*K,8);%ȡ8���е�4��
index=zeros(2*K,8);%��Ӧȡ�ĸ��ʵ�λ��
index_=zeros(2*K,16);
L=zeros(2*K,cs);

for t=1% ������ѭ�� 
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
    end   
   for i_c=1:2*K
       for j_c=1:cs
           if L(i_c,j_c)>709
              L(i_c,:)=L(i_c,:).*0.5;
           end
       end
   end  
    LL(:,:,t)=L;
  %�ⲿ��ֻ�Ǽ�������ʵĲ���
    for k=1:2*K
       for n=1:cs
             pro_(k,n)=exp(L(k,n))/(sum(exp(L(k,:))));%���µĸ���
             pro(k,n)=(1-D).* pro_(k,n)+D.*pro(k,n);%������������
       end 
    end
dd(:,t)=d;
pp(:,:,t) =pro;  
end


%��һ�ε�������ȫ������ �ڶ��ε�����ȡ���������
for t=2:6% ������ѭ�� 
     for k_i=1:2*K
        [paixu(k_i,:),index_(k_i,:)]=sort(pro(k_i,:));%sort��С��������
        youxiao(k_i,:)=paixu(k_i,9:16);
        index(k_i,:)=index_(k_i,9:16);
    end
    for i_=1:2*K%����xi��ѭ��
         for j_=1:2*K%���ֵ�����ͨ���ѭ��
              a(j_) =J(i_,j_) *(sym_(index(j_,:))*pro(j_,index(j_,:))');%��xj�þ�ֵ������xi������xi
              b(j_)=(J(i_,j_).^2)*((sym_(index(j_,:)).^2)*pro(j_,index(j_,:))'-(abs(sym_(index(j_,:)))*pro(j_,index(j_,:))')^2); 
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
    end     
   for i_c=1:2*K
       for j_c=1:cs
           if L(i_c,j_c)>709
              L(i_c,:)=L(i_c,:).*0.5;
           end
       end
   end    
    LL(:,:,t)=L;
  %�ⲿ��ֻ�Ǽ�������ʵĲ���
    for k=1:2*K
       for n=1:cs
             pro_(k,n)=exp(L(k,n))/(sum(exp(L(k,:))));%���µĸ���
             pro(k,n)=(1-D).* pro_(k,n)+D.*pro(k,n);%������������
       end 
    end
dd(:,t)=d;
pp(:,:,t) =pro;  
end
%���Ĵε�����ʼ���ٸ��¸��ʵ��λ�� ���ǹ̶����ʵ�������� ����������������������ڷ�������ֵ�����佫�ᵼ�´���Ľ��
for t=7:s% ������ѭ�� 
    for i_=1:2*K%����xi��ѭ��
        for j_=1:2*K%���ֵ�����ͨ���ѭ��
              a(j_) =J(i_,j_) *(sym_(index(j_,:))*pro(j_,index(j_,:))');%��xj�þ�ֵ������xi������xi
              b(j_)=(J(i_,j_).^2)*((sym_(index(j_,:)).^2)*pro(j_,index(j_,:))'-(abs(sym_(index(j_,:)))*pro(j_,index(j_,:))')^2);         
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
    end     
   for i_c=1:2*K
       for j_c=1:cs
           if L(i_c,j_c)>709
              L(i_c,:)=L(i_c,:).*0.5;
           end
       end
   end  
    LL(:,:,t)=L;
  %�ⲿ��ֻ�Ǽ�������ʵĲ���
  %�����ⲿ��ֻ�Ǹ������̶������ַ��Ÿ��� �����Ķ����ټ��� �������ֽ�һ�������˴洢�ͼ��㸴�Ӷ�
    for k=1:2*K
       for n=index(k,1):index(k,2)
             pro_(k,n)=exp(L(k,n))/(sum(exp(L(k,:))));%���µĸ���
             pro(k,n)=(1-D).* pro_(k,n)+D.*pro(k,n);%������������
       end 
    end
dd(:,t)=d;
pp(:,:,t) =pro;  
end
out1=L;
out2=pp;
out3=dd;
out4=bb;
out5=LL;


