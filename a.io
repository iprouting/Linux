Edit
iptablesѧϰ�ʼ�

Iptables֪ʶ��

Filter (������)����Ҫ������ Linux �����ķ���йأ������Ԥ��� table��
INPUT����Ҫ����Ҫ�������� Linux �����ķ���йأ�
OUTPUT����Ҫ������ Linux ������Ҫ�ͳ��ķ���йأ�
FORWARD���� Linux �����Ƚ�û�й�ϵ�� ������ת�ݷ������˵ļ��� ���С�
NAT (��ַת��)���� Network Address Translation ����д�� ��������Ҫ�ڽ�����Դ��Ŀ��֮ IP �� port ��ת������ Linux �������޹أ���Ҫ�� Linux ������ľ��������ڼ����������ء�
PREROUTING���ڽ���·���ж�֮ǰ��Ҫ���еĹ���(DNAT/REDIRECT)
POSTROUTING���ڽ���·���ж�֮����Ҫ���еĹ���(SNAT/MASQUERADE)
OUTPUT���뷢�ͳ�ȥ�ķ���й�

Iptables��������

����ѡ�������

-t ������� table ������ nat �� filter ����ʡ�Դ���Ŀ����ʹ��Ĭ�ϵ� filter
-L ���г�Ŀǰ�� table �Ĺ���
-n �������� IP �� HOSTNAME �ķ��飬��ʾѶϢ���ٶȻ��ܶ࣡
-v ���г��������Ϣ������ͨ���ù���ķ����λ������ص�����ӿڵ�
-F ��������е��Ѷ����Ĺ���
-X ���������ʹ���� ���Զ��塱 �� chain ��
-Z �������е� chain �ļ���������ͳ�ƶ�����

����Ĭ�ϲ���( Policy )

���iptables -P

ACCEPT ���÷���ɽ���
DROP ���÷��ֱ�Ӷ����������� client ��֪��Ϊ�α�����

�������������� INPUT �趨Ϊ DROP �������趨Ϊ ACCEPT

[root@www ~]# iptables -P INPUT DROP
[root@www ~]# iptables -P OUTPUT ACCEPT
[root@www ~]# iptables -P FORWARD ACCEPT
[root@www ~]# iptables-save

Iptables�﷨����

[root@www ~]# iptables [-AI ����] [-io ����ӿ�] [-p Э��] [-s ��ԴIP/����] [-d Ŀ��IP/����] -j [ACCEPT|DROP|REJECT|LOG]

ѡ�������

-AI ���������ĳ�������й���� �����롱 �� ���ۼӡ�
-A ��������һ�����򣬸ù���������ԭ�����������档����ԭ���Ѿ�����������ʹ�� -A �Ϳ��Լ��ϵ���������
-I������һ���������û��ָ���˹����˳��Ĭ���ǲ����ɵ�һ����������ԭ������������ʹ�� -I ��ù����ɵ�һ������ԭ��������� 2~5 ���� ���� INPUT, OUTPUT, FORWARD �ȣ������������� -io �йأ��뿴���¡�
-io: ����ӿڣ��趨��������Ľӿڹ淶
-i �������������Ǹ�����ӿڣ����� eth0, lo �Ƚӿڡ����� INPUT ����ϣ�
-o ��������������Ǹ�����ӿڣ����� OUTPUT ����ϣ�
-p:Э�����趨�˹������������ַ����ʽ��Ҫ�ķ����ʽ�У� tcp, udp, icmp �� all ��
-s: ��Դ IP/�����趨�˹���֮�������Դ��Ŀ����ָ�������� IP ���������
-d Ŀ�� IP/����ͬ -s ��ֻ��������ָ����Ŀ��� IP ������
-j :����Ӷ�������Ҫ�Ķ����н���(ACCEPT)������(DROP)���ܾ�(REJECT)����¼(LOG)

������ֻҪ������������ (192.168.100.0/24) �ķ��ͨͨ����

[root@www ~]# iptables -A INPUT -i eth1 -s 192.168.100.0/24 -j ACCEPT
�����������ͽ��ܣ����Ҳ���Գ�֮Ϊ��������
������ֻҪ������ 192.168.100.10 �ͽ��ܣ��� 192.168.100.230 ���������Դ�Ͷ���
[root@www ~]# iptables -A INPUT -i eth1 -s 192.168.100.10 -j ACCEPT
[root@www ~]# iptables -A INPUT -i eth1 -s 192.168.100.230 -j DROP
��Ե�һ IP ��Դ������Ϊ�������������ǲ����εĶ�����Դ��

[root@www ~]# iptables-save
enerated by iptables-save v1.4.7 on Fri Jul 22 16:00:43 2011
*filter
:INPUT DROP [0:0]
:FORWARD ACCEPT [0:0]
:OUTPUT ACCEPT [17:1724]
-A INPUT -i lo -j ACCEPT
-A INPUT -s 192.168.100.0/24 -i eth1 -j ACCEPT
-A INPUT -s 192.168.100.10/32 -i eth1 -j ACCEPT
-A INPUT -s 192.168.100.230/32 -i eth1 -j DROP
COMMIT
Completed on Fri Jul 22 16:00:43 2011

Iptables��Զ˿��趨����

[root@www ~]# iptables [-AI ��] [-io ����ӿ�] [-p tcp,udp] \
[-s ��ԴIP/����] [�Csport ���ڷ�Χ] \
[-d Ŀ��IP/����] [�Cdport ���ڷ�Χ] -j [ACCEPT|DROP|REJECT]

ѡ�������:
�Csport���ڷ�Χ��������Դ�Ķ˿ں��룬�˿ں�������������ģ����� 1024:65535
�Cdport���ڷ�Χ������Ŀ��Ķ˿ں��롣

��������Ҫ�������뱾�� port 21 �ķ�����ֵ�����

[root@www ~]# iptables -A INPUT -i eth0 -p tcp �Cdport 21 -j DROP

���������������ⲿ���������� (upd port 137,138 tcp port 139,445) �ͷ���

[root@www ~]# iptables -A INPUT -i eth0 -p udp �Cdport 137:138 -j ACCEPT
[root@www ~]# iptables -A INPUT -i eth0 -p tcp �Cdport 139 -j ACCEPT
[root@www ~]# iptables -A INPUT -i eth0 -p tcp �Cdport 445 -j ACCEPT