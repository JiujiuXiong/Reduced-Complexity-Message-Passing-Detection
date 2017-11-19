
function [out1,out2,out3,out4,out5,out6,out7,out8] = dynamic_64(K,J,Z,N0v,s,t,Es,E_guiyi)
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
        sym_=[-7:2:7,0]/E_guiyi;
        p_cs=0.125;
        cs=8;
        else 
       sym_=[-15:2:15]/E_guiyi;
       p_cs=0.0625;
       cs=16;
end

pro=(p_cs)*ones(2*K,cs+1);%��ʼ�� ÿһ�����ŵĸ���Ϊ1��16
pro(:,cs+1)=0;
L=zeros(2*K,cs);
paixu=zeros(2*K,8);%����64qam����

index=zeros(2*K,4);%��Ӧȡ�ĸ��ʵ�λ��
index_=zeros(2*K,8);
L=zeros(2*K,cs);
dy = zeros(2*K,4,13);
for t=1% ������ѭ�� 
    for i_=1:2*K%����xi��ѭ��
         for j_=1:2*K%���ֵ�����ͨ���ѭ��
              a(j_) =J(i_,j_) *(sym_*pro(j_,:)');%��xj�þ�ֵ������xi������xi
              b(j_)=(J(i_,j_).^2)*((sym_.^2)*pro(j_,:)'-(abs(sym_*pro(j_,:)'))^2);
              %b(j_)=(J(i_,j_).^2)*(Es/2);%�������
         end
         
         bb(:,i_,t)=b;
         
       %���
      
         c(i_)= sum(a(:))-a(i_);
         d(i_)= sum(b(:)) - b(i_) + N0v;
         
      
        %������һ�ε�������Ҫ����Ϣ�Ѿ�������� 
         %��ÿ�����ŵĶ�����Ȼ��
         for n_=1:cs
            % L_(i_,n_)=(2*J(i_,i_)*(Z(i_)-c(i_))*(sym_(n_)-sym_(1))+(J(i_,i_)^2)*(sym_(1)^2-sym_(n_)^2))/(2*d(i_));
              L(i_,n_)=(J(i_,i_)*(sym_(n_)-sym_(1)))*(2*Z(i_)-2*c(i_)-J(i_,i_)*sym_(n_)-J(i_,i_)*sym_(1))/(2*d(i_));
             % L(i_,n_)=(1-D)* L_(i_,n_)+D*L(i_,n_);
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
for t=2:s% ������ѭ�� 
    %���Ƕ��ϴε�������ĸ��������ȷ��ÿһ�������������ڿ������������ж�
     for k_i=1:2*K%��̬�ľ���Ҫȡ����
        [paixu(k_i,:),index_(k_i,:)]=sort(pro(k_i,1:cs));%sort��С��������
        
        %��ôд���ֵĶ������һ�������� �϶����Ե����Ի��ø�
        %����Ķ�̬��׼�� ����0.5-0.9֮��ľ�ȡ2�� ����0.9���ϵľ���С��1������4��
        %�����������ȡ8��������̬��ѡ����һ�����ͼ���ĸ��Ӷ�
        for j_k=1:cs%����ж�ֻҪ�����ڷ�Χ�ڵľ�������ǰѭ��ִ���´�ѭ���������������ᵽ������
            if (pro(k_i,j_k)>0.5)&&(pro(k_i,j_k)<0.9)%����0.5ȡ2��
                index(k_i,1:2)=index_(k_i,7:8);
                index(k_i,3:4)=9;
                break;
           
            elseif  pro(k_i,j_k)>=0.9%����0.9ȡ1��
                
                index(k_i,1)=index_(k_i,8);
                index(k_i,2:4)=9;
                break;
            else%�������ȡ4��
                 index(k_i,:)=index_(k_i,5:8);  
                 
            end
        end
               
     end
    in(:,:,t)=index;

    
 
    
    for i_=1:2*K%����xi��ѭ��
         for j_=1:2*K%���ֵ�����ͨ���ѭ��
              a(j_) =J(i_,j_) *(sym_(index(j_,:))*pro(j_,index(j_,:))');%��xj�þ�ֵ������xi������xi
              b(j_)=(J(i_,j_).^2)*((sym_(index(j_,:)).^2)*pro(j_,index(j_,:))'-(abs(sym_(index(j_,:)))*pro(j_,index(j_,:))')^2);
              %b(j_)=(J(i_,j_).^2)*(Es/2);%�������
         end
         
         bb(:,i_,t)=b;
         
       %���
      
         c(i_)= sum(a(:))-a(i_);
         d(i_)= sum(b(:)) - b(i_) + N0v;
         
      
        %������һ�ε�������Ҫ����Ϣ�Ѿ�������� 
         %��ÿ�����ŵĶ�����Ȼ��
         for n_=1:cs
            % L_(i_,n_)=(2*J(i_,i_)*(Z(i_)-c(i_))*(sym_(n_)-sym_(1))+(J(i_,i_)^2)*(sym_(1)^2-sym_(n_)^2))/(2*d(i_));
              L(i_,n_)=(J(i_,i_)*(sym_(n_)-sym_(1)))*(2*Z(i_)-2*c(i_)-J(i_,i_)*sym_(n_)-J(i_,i_)*sym_(1))/(2*d(i_));
             % L(i_,n_)=(1-D)* L_(i_,n_)+D*L(i_,n_);
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


    %��̬���µĸ��Ӷȷ�����
    dy = in;
     dy(dy~=9)= 1;
     dy(dy==9)= 0;
     num=sum(sum(sum(dy)));
    
out1=L;
out2=pp;
out3=dd;
out4=bb;
out5=LL;
out6=in;
out7=num;
out8=dy;


