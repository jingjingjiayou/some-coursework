%��ȡԭʼ����
[audio,fs]=audioread('open-cc.wav'); 
A=audio(1:160000);
AL=length(A);
%����ԭʼ��Ƶͼ�� 
subplot(312);plot(A); 
title('ԭʼ��Ƶ�ź�'); 

%����ˮӡͼƬ
I=imread('a.png');
I=im2bw(I);
subplot(311);imshow(I); 
title('ˮӡͼ��');
[m,n]=size(I);
%��ͼƬ��ά 
piexnum=1;
for i=1:m
    for j=1:n
        w(piexnum,1)=I(i,j);
        piexnum=piexnum+1;
    end
end
wl=size(w);

%��ԭ��Ƶ����2��С���ֽ⣺  
[c,l]=wavedec(A,2,'haar');     
%��ȡ2��С���ֽ�ĵ�Ƶ������������Ƶ������������ 
ca2=appcoef(c,l,'haar',2); 
cd2=detcoef(c,l,2); 
cd1=detcoef(c,l,1); 
ca2L=length(ca2); 

%DCT�任
ca2DCT=dct(ca2);
%�ֶ�
k=wl(1);   %����
DL=ca2L/k;  %ca2ÿ�εĳ���
j=1;
delta=0.5;
%�ֶν���ˮӡǶ��
for i=1:k
    ca22=ca2DCT(j:j+DL-1);
    Y=ca22(1:DL/4);        %��ȡǰ1/4ϵ��
    Y=reshape(Y,10,10);
    
    [U,S,V]=svd(Y);        %SVD�ֽ�
    S1=S(1,1);
    S2=S(2,2);
    D=floor(S1/(S2*delta)); %�б�ʽ
    %����D����ż�Խ���ˮӡǶ��
    if(mod(D,2)==0)
        if (w(i)==1)                                       
            S(1,1)=S(2,2)*delta*(D+1);  
        else   
            S(1,1)=S(2,2)*delta*D;  
        end  
    else                                   
        if (w(i)==1)  
            S(1,1)=S(2,2)*delta*D; 
        else  
            S(1,1)=S(2,2)*delta*(D+1);  
        end  
    end  
    Y11=U*S*V';              %SVD ��任��ԭ  
    Y1=reshape(Y11,100,1);
    ca22(1:100)=Y1(1:100);
    ca2DCTnew(j:j+DL-1)=ca22;%��Ƕ��ˮӡ���ϵ���滻ԭ����ǰ1/4ϵ��
    j=j+DL;
end
%IDCT
ca2new=idct(ca2DCTnew');
%IDWT
c1=[ca2new',cd2',cd1'];
Anew=waverec(c1',l,'haar');
audiowrite('new.wav',Anew,fs); %����Ƕ��ˮӡ�����Ƶ
subplot(313);plot(Anew);       %��ʾǶ��ˮӡ�����Ƶ
title('Ƕ��ˮӡ����Ƶ')