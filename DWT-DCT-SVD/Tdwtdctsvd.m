figure(2);
%����ԭˮӡͼƬ
I=imread('a.png');
I=im2bw(I);
%��ȡԭʼ����
audio = audioread('open-cc.wav'); 
A=audio(1:160000);
%��ȡ��ˮӡ��Ƶ
[A1,fs]=audioread('new.wav'); 
AL=length(A1);
%������Ƶͼ�� 
subplot(211);plot(A1); 
axis([0,160000,-1,1]);
title('��ˮӡ��Ƶ�ź�');
%{
%���빥��
%0 δ����
%1 �����˹����
A1=awgn(A1,70);
%2 �ز���
A1=resample(A1,22050,fs);
A1=resample(A1,fs,22050);
%3 ���е�ͨ�˲�
% [B1,B2]=butter(1,3/4,'low');
% A1=filter(B1,B2,A1);
%}

%����Ƶ����2��С���ֽ⣺  
[c,l]=wavedec(A1,2,'haar');     
%��ȡ2��С���ֽ�ĵ�Ƶ������������Ƶ������������ 
ca2=appcoef(c,l,'haar',2); 
cd2=detcoef(c,l,2); 
cd1=detcoef(c,l,1); 
ca2L=length(ca2); 

%DCT�任
ca2DCT=dct(ca2);

k=100;      %����
DL=ca2L/k;  %ca2ÿ�εĳ���
j=1;
delta=0.5;
%�ֶ���ȡˮӡ��Ϣ
for i=1:k
    ca22=ca2DCT(j:j+DL-1);
    Y=ca22(1:DL/4);         %��ȡÿ��ǰ1/4ϵ��
    Y=reshape(Y,10,10);
    
    [U,S,V]=svd(Y);         %����SVD�任
    S1=S(1,1);
    S2=S(2,2);
    D=round(S1/(S2*delta)); %�б�ʽ
    %�����б�ʽ����ż����ȡˮӡ
    if(mod(D,2)==0)
        water(i)=0;
    else                                      
        water(i)=1;
    end  
    j=j+DL;
end
%��һά���ݻָ��ɶ�άͼ��
for i=1:10
    for j=1:10
        p=j+10*(i-1);
        J(i,j)=water(p);
    end
end
subplot(212);imshow(J);
title('��ȡ��ˮӡͼ��');
imwrite(J,'b.png');

%����ָ��
%0 ��ֵ�����PSNR
AA = A.*A;
maxAA=max(AA);
Dist = A1-A;
sum=0;
for i=1:AL
    DAA1=Dist(i)*Dist(i);
    sum=sum+DAA1;
end
psnr = 10*log10(maxAA/sum);
%1 ������BER
eber=0;
for i=1:10
    for j=1:10
        if I(i,j)==J(i,j)
        else
            eber=eber+1;
        end
    end
end
ber=eber/100;
%2 ��һ��ϵ��NC
IJ = I.*J;
II = I.*I;
JJ=J.*J;
sumII=0;
sumIJ=0;
sumJJ=0;
for i=1:10
    for j=1:10
        sumII=sumII+II(i,j);
        sumIJ=sumIJ+IJ(i,j);
        sumJJ=sumJJ+JJ(i,j);
    end
end
nc=sumIJ/(sqrt(sumII)*sqrt(sumJJ));