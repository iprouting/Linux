Edit
iptables学习笔记

Iptables知识点

Filter (过滤器)：主要跟进入 Linux 本机的封包有关，这个是预设的 table。
INPUT：主要与想要进入我们 Linux 本机的封包有关；
OUTPUT：主要与我们 Linux 本机所要送出的封包有关；
FORWARD：与 Linux 本机比较没有关系， 他可以转递封包到后端的计算 机中。
NAT (地址转换)：是 Network Address Translation 的缩写， 这个表格主要在进行来源与目的之 IP 或 port 的转换，与 Linux 本机较无关，主要与 Linux 主机后的局域网络内计算机较有相关。
PREROUTING：在进行路由判断之前所要进行的规则(DNAT/REDIRECT)
POSTROUTING：在进行路由判断之后所要进行的规则(SNAT/MASQUERADE)
OUTPUT：与发送出去的封包有关

Iptables常用命令

常用选项与参数

-t ：后面接 table ，例如 nat 或 filter ，若省略此项目，则使用默认的 filter
-L ：列出目前的 table 的规则
-n ：不进行 IP 与 HOSTNAME 的反查，显示讯息的速度会快很多！
-v ：列出更多的信息，包括通过该规则的封包总位数、相关的网络接口等
-F ：清除所有的已订定的规则；
-X ：清除所有使用者 “自定义” 的 chain ；
-Z ：将所有的 chain 的计数与流量统计都归零

定义默认策略( Policy )

命令：iptables -P

ACCEPT ：该封包可接受
DROP ：该封包直接丢弃，不会让 client 端知道为何被丢弃

范例：将本机的 INPUT 设定为 DROP ，其他设定为 ACCEPT

[root@www ~]# iptables -P INPUT DROP
[root@www ~]# iptables -P OUTPUT ACCEPT
[root@www ~]# iptables -P FORWARD ACCEPT
[root@www ~]# iptables-save

Iptables语法规则

[root@www ~]# iptables [-AI 链名] [-io 网络接口] [-p 协议] [-s 来源IP/网域] [-d 目标IP/网域] -j [ACCEPT|DROP|REJECT|LOG]

选项与参数

-AI 链名：针对某的链进行规则的 “插入” 或 “累加”
-A ：新增加一条规则，该规则增加在原本规则的最后面。例如原本已经有四条规则，使用 -A 就可以加上第五条规则！
-I：插入一条规则。如果没有指定此规则的顺序，默认是插入变成第一条规则。例如原本有四条规则，使用 -I 则该规则变成第一条，而原本四条变成 2~5 号链 ：有 INPUT, OUTPUT, FORWARD 等，此链名称又与 -io 有关，请看底下。
-io: 网络接口：设定封包进出的接口规范
-i ：封包所进入的那个网络接口，例如 eth0, lo 等接口。需与 INPUT 链配合；
-o ：封包所传出的那个网络接口，需与 OUTPUT 链配合；
-p:协定：设定此规则适用于哪种封包格式主要的封包格式有： tcp, udp, icmp 及 all 。
-s: 来源 IP/网域：设定此规则之封包的来源项目，可指定单纯的 IP 或包括网域。
-d 目标 IP/网域：同 -s ，只不过这里指的是目标的 IP 或网域。
-j :后面接动作，主要的动作有接受(ACCEPT)、丢弃(DROP)、拒绝(REJECT)及记录(LOG)

范例：只要是来自内网的 (192.168.100.0/24) 的封包通通接受

[root@www ~]# iptables -A INPUT -i eth1 -s 192.168.100.0/24 -j ACCEPT
由于是内网就接受，因此也可以称之为信任网域。
范例：只要是来自 192.168.100.10 就接受，但 192.168.100.230 这个恶意来源就丢弃
[root@www ~]# iptables -A INPUT -i eth1 -s 192.168.100.10 -j ACCEPT
[root@www ~]# iptables -A INPUT -i eth1 -s 192.168.100.230 -j DROP
针对单一 IP 来源，可视为信任主机或者是不信任的恶意来源。

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

Iptables针对端口设定规则

[root@www ~]# iptables [-AI 链] [-io 网络接口] [-p tcp,udp] \
[-s 来源IP/网域] [–sport 埠口范围] \
[-d 目标IP/网域] [–dport 埠口范围] -j [ACCEPT|DROP|REJECT]

选项与参数:
–sport埠口范围：限制来源的端口号码，端口号码可以是连续的，例如 1024:65535
–dport埠口范围：限制目标的端口号码。

范例：想要联机进入本机 port 21 的封包都抵挡掉：

[root@www ~]# iptables -A INPUT -i eth0 -p tcp –dport 21 -j DROP

范例：想连到我这部主机的网芳 (upd port 137,138 tcp port 139,445) 就放行

[root@www ~]# iptables -A INPUT -i eth0 -p udp –dport 137:138 -j ACCEPT
[root@www ~]# iptables -A INPUT -i eth0 -p tcp –dport 139 -j ACCEPT
[root@www ~]# iptables -A INPUT -i eth0 -p tcp –dport 445 -j ACCEPT