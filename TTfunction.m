function [xf]=TTfunction(A,Q,C1,C2,R1,R2,z1,z2,xe1,pk1,xe2,pk2,pij)

 for i=1:length(z1) 
     
 %������1�˲�
xe1=A*xe1;
p1=A*pk1*A'+Q;    %P1��ʾǰһ����״̬���Ʒ���
K1=p1*C1'*inv(C1*p1*C1'+R1); %K��ʾ�˲�ϵ��
xe1=xe1+K1*(z1(i)-C1*xe1);   %xe��ʾ��ǰ״̬����ֵ
pk1=(eye(size(p1))-K1*C1)*p1;  %eye(size(p1))��ʾ��С��p1һ���ľ���
 
 %������2�˲�
xe2=A*xe2;
p2=A*pk2*A'+Q;    %P2��ʾǰһ����״̬���Ʒ���
K2=p2*C2'*inv(C2*p2*C2'+R2); %K��ʾ�˲�ϵ��
xe2=xe2+K2*(z2(i)-C2*xe2);   %xe��ʾ��ǰ״̬����ֵ
pk2=(eye(size(p2))-K2*C2)*p2;  %eye(size(p2))��ʾ��С��p2һ���ľ���

pij=A*pij*A'+Q;
pij=(1-C1*K1)*pij*(1-C2*K2)';
pf=pk1-(pk1-pij)*inv(pk1+pk2-2*pij)*(pk1-pij);
xf(:,i)=xe1+(pk1-pij)*inv(pk1+pk2-2*pij)*(xe2-xe1);
 end
 
 