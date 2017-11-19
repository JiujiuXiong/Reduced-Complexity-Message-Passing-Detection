%MIMO MPD 
clear all;
close all;
%����һ��

%������������� 
K =16;%�û�������
N =128;%��վ������
t=2;%ѡ����ƽ��������������M�е�˳��
s = 7;%�㷨�����Ĵ���
SNRdBs =6;%�����SNR�ķ�Χ
MAX_nobit=100;%���������

%��������
M_tiaozhi=[4,16,64,256];%���ƽ���
M_cs=[2,4,6,8];%��ͬ���ƽ�����Ӧ��ͬ�Ĳ���
M=M_tiaozhi(t);%���ƽ���
can_s=M_cs(t);%���ƽ�����Ӧ�Ĳ���
Es_=[2,10,42,170];%ÿ�����ͷ��ŵ�����
Es=Es_(t);%��ͬ���ƽ����·��ŵ�����
E_guiyi=sqrt(Es);
syn_per_ant = 360 ;%ÿ�����߷��͵����ݳ���
Num_pack =1 ;%���͵����ݰ�����
bit_len = syn_per_ant * K * Num_pack ;% �ܵķ���������=ÿ�����߷�������ݰ����� * ������ * ����İ���
%��ͬ���ƽ����¶��ڷ��ſռ�sym_��ѡ��
if t==1
    sym_=[-1,+1]/E_guiyi;
elseif t==2
        sym_=[-3:2:3]/E_guiyi;
    elseif t==3
        sym_=[-7:2:7]/E_guiyi;
else 
       sym_=[-15:2:15]/E_guiyi;
end


fprintf('\tSNRdBs\t\tBER\n');%��ӡ��ÿ��������µ�������


tic%�����������̵�ʱ��
for i_SNR = 1:length(SNRdBs)  %��������ȱ仯�Ĵ�ѭ��
  
    SNRdB = SNRdBs(i_SNR) ;%�����
        rand('seed',1);
	    randn('seed',1);  
    nobit = 0 ;%�������ĳ�ʼ��
    
    x_guji =zeros(2*K,1);
    
    x_bit_guji = zeros(K,1);
    
    count=0;%�������ĳ�ʼ��
     
   while(1)
       
       count=count+1;%��������1
       
       T_bits = randi([0 1],bit_len, 1);%���͵�bit����
   
       receive_bit =zeros(length(bit_len),1);%����bit���ݵĳ�ʼ��
            
     %�������ݲ�����ѭ��
      for tx_time = 1 : (syn_per_ant * Num_pack/can_s) %ÿ�ν���8K��bit���ݣ����Ǵ��������ѭ��
          
            tx_bit = T_bits( (( tx_time - 1 ) *can_s* K + 1 ): tx_time *can_s * K );%ÿ�δ����8K��bit����
          
            mod = modem.qammod('M',M,'InputType','Bit','SymbolOrder','gray');
       
	        x_1 = modulate(mod,tx_bit);%QAM����֮��ķ������ݣ�������
            
            x_ = x_1./E_guiyi;%������һ��
            
            N0 = (K/2)*1*10^(-SNRdB/10);%��������Es=1 ��һ����
            
             sym_shi_shu=zeros(2*K,1);
             
            %�����ŵ�����ת����ʵ����ʽ
            H = zeros(2*N,2*K);
             hseed = sqrt(0.5)* (randn(N,K) + 1j * randn(N,K));
             hseed1 = real(hseed);
	         hseed2 = imag(hseed);
	        for si1 = 1 : N
	    	for sj1 = 1 : K
	    				hi1 = 2 * si1 - 1;
	    				hj1 = 2 * sj1 - 1;
	    				H(hi1,hj1) = hseed1(si1,sj1);
	    				H(hi1+1, hj1+1) = hseed1(si1,sj1);
            end
	        end
	    		    for si2 = 1 : N
	    			for sj2 = 1 : K
	    				hi2 = 2 * si2;
	    				hj2 = 2 * sj2 - 1;
	    				hi3 = 2 * si2 - 1;
	    				hj3 = 2 * sj2;
	    				H(hi2,hj2) = hseed2(si2,sj2);
	    				H(hi3, hj3) = -hseed2(si2,sj2);
	    			end
                    end  
                    
                    %������֮��ĸ�������ת����ʵ����ʽ��
                    sseed = x_;
	    		    sseed1 = real(sseed);
	    		    sseed2 = imag(sseed);
	    		   for si = 1 : K
	    			    sym_shi_shu(2*si-1) = sseed1(si);
	    			    sym_shi_shu(2*si) = sseed2(si);
                   end
                   x=sym_shi_shu;
                
               %�����Ľ���
             noise = zeros(2*N,1);
             nseed = sqrt(N0)*(randn(N,1) + 1j * randn(N,1));
             nseed1 = real(nseed);
	    	 nseed2 = imag(nseed);
    	    	    	   for ni = 1 : N
                               noise(2*ni-1) = nseed1(ni);
                               noise(2*ni) = nseed2(ni);
                           end
                    
        %   ���յ������� 
             y = H * x + noise; 
              
        %�ŵ�Ӳ��  ���� J,Z�����Ӻ���
        [J,Z,N0v] = ESTIMATE(N0,N,K,y,1,H);%��һ����Es=1
      
        %MPD�����㷨��� x��LLR����, s Ϊ���������������Ӻ���
         [L,pp,dd,bb,LL]= MPD_ren_yi_gui_yi(K,J,Z,N0v,s,t,1,E_guiyi);
         %[L,pp,dd,bb,LL]= MPD_16qam_G_J(K,J,Z,N0v,s,t,1,E_guiyi);
         
        %�㷨�����LLR ��LLR�о� 
        %����о�����
        for n=1:2*K
            L_=max(L(n,:));
            index=find(L(n,:)==max(L(n,:)));
            if L_>0
                x_guji(n,1)=sym_(index);
            else
                x_guji(n,1)=sym_(1);
            end
        end
        
        
        %��ʵ�����Ż��ظ�����ʽ
        for n_=1:K 
            x_bit_guji(n_) = x_guji(2*n_-1,1) + x_guji(2*n_,1)*1j;
        end
         x_bit_guji= x_bit_guji* E_guiyi;
       %�������
       demod = modem.qamdemod('M',M,'OutputType','Bit','DecisionType','hard decision','SymbolOrder','gray','NoiseVariance',N0);
        x_bit_1= demodulate(demod,x_bit_guji);%����Ľ�������ݱ���������N0û�й�ϵ 
        x_bit_=x_bit_1(:)';
        receive_bit(can_s*(tx_time-1)*K+1:can_s*tx_time*K,1) =x_bit_;
      end    %������һ�δ��䵹�����ܹ��ƽ������ٴ�ѭ����������ֱ������ȫ������
      
      %����������
      for i_comp=1:bit_len
           if T_bits(i_comp)~=receive_bit(i_comp) 
                nobit=nobit+1;   
           end
      end
           if nobit>MAX_nobit
              break;%��������������趨������������������ʴ������趨�������������Ӧ��������������whlieѭ��������һ��SNR��BER�ļ���
           end 
           %if count>=100
              %break;
           %end
   end%����whileѭ��
   
   
   %�����ʵļ���
    BER(i_SNR) = nobit / (bit_len*count);
  
    fprintf('\t%d\t\t%e\t\n',SNRdB,BER(i_SNR));%��ӡ��ÿ�������ʵĽ��
             
end
toc%�����㷨ִ��ʱ��

 %   ������Ӧ�����ʾ������ʺ�����ȵĹ�ϵ
    semilogy(SNRdBs(1:length(BER)),BER,'b<-','LineWidth',2);
    xlabel('Average SNR in dB');%������
    ylabel('Uncoded BER');%������
    title('N=128,K=16,16QAM');   %����
    legend('MPD');%��ע
    grid on%��������