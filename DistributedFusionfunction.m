function [xf]=DistributedFusionfunction(A,Q,C1,C2,R1,R2,z1,z2,xe1,pk1,xe2,pk2,xkk,pkk)
for i=1:length(z1)
     %������1�˲�
xe11=A*xe1;
p1=A*pk1*A'+Q;    %P1��ʾǰһ����״̬���Ʒ���
K1=p1*C1'*inv(C1*p1*C1'+R1); %K��ʾ�˲�ϵ��
xe1=xe11+K1*(z1(i)-C1*xe11);   %xe��ʾ��ǰ״̬����ֵ
pk1=(eye(size(p1))-K1*C1)*p1;  %eye(size(p1))��ʾ��С��p1һ���ľ���

    %������2�˲�
xe21=A*xe2;
p2=A*pk2*A'+Q;    %P2��ʾǰһ����״̬���Ʒ���
K2=p2*C2'*inv(C2*p2*C2'+R2); %K��ʾ�˲�ϵ��
xe2=xe21+K2*(z2(i)-C2*xe21);   %xe��ʾ��ǰ״̬����ֵ
pk2=(eye(size(p2))-K2*C2)*p2;  %eye(size(p2))��ʾ��С��p2һ���ľ���
 
    
    %%%fusion
    xkk_1=A*xkk;
    pkk_1=A*pkk*A+Q;

    pkk=inv(inv(pkk_1)+(inv(pk1)-inv(p1))+(inv(pk2)-inv(p2)));
   
    xkk=pkk*(inv(pkk_1)*xkk_1+(inv(pk1)*xe1-inv(p1)*xe11)+(inv(pk2)*xe2-inv(p2)*xe21));
    xf(:,i)=xkk;
    
end