#!/bin/bash

# Shell Options
# e : エラーがあったら直ちにシェルを終了
# u : 未定義変数を使用したときにエラーとする
# o : シェルオプションを有効にする
# pipefail : パイプラインの返り値を最後のエラー終了値にする (エラー終了値がない場合は0を返す)
set -euo pipefail

########################################
# Package Update
########################################
apt update -y

########################################
# TimeZone
########################################
timedatectl set-timezone Asia/Tokyo

########################################
# Locale & Keymap
########################################
localectl set-locale LANG=ja_JP.UTF-8
sed -i 's/^XKBLAYOUT=.*/XKBLAYOUT="jp"/' /etc/default/keyboard
dpkg-reconfigure -f noninteractive keyboard-configuration # 設定再構築
setupcon # ttyへ即時反映

########################################
# Firewall 
########################################
ufw disable

########################################
# Network 
### all: 全インターフェース適用
### default: インターフェース側で未設定の場合に適用
### ip_forward = 1 [あるNICで受信したバケットを別NICへ送出する]
### rp_filter = 0 [複数のNICからパケットが出入りするため Reverse Path Filteringを無効化]
### accept_source_route = 0 [ソースルーティングパケットの受入無効化]
### ip_no_pmtu_disc = 0 [通信遅延をなくすためPath MTU Discoveryを無効化]
### accept_redirects = 0 [セキュリティ上の理由よりICMPリダイレクトパケットの受入無効化]
### send_redirects = 0 [セキュリティ上の理由よりICMPリダイレクトパケットの送出無効化]
########################################
cat <<EOF > /etc/sysctl.d/99-vpn.conf
${nw_conf}
EOF
### /etc/sysctl.d/* を適用する
### sysctl -p は /etc/sysctl.conf のみ反映される
sysctl --system

########################################
# Strongswan install
### strongswan-swanctlもインストールされる&サービス自動起動有効化される
########################################
apt install charon-systemd -y
### strongswan-charon strongswan-starter 自動削除
apt autoremove -y

########################################
# XFMR 
########################################
# AddressにはEC2のInsideIPを入れる
cat <<EOF > /etc/systemd/system/xfrm-ifaces.service
${xfrm_conf}
EOF
systemctl enable --now xfrm-ifaces.service

########################################
# BGP
########################################
apt install frr -y
sed -i 's/^bgpd=no/bgpd=yes/' /etc/frr/daemons
echo 'watchfrr_enable=yes' >> /etc/frr/daemons
systemctl enable --now frr

cat <<EOF > /etc/frr/frr.conf
${frr_conf}
EOF
chown frr:frr /etc/frr/frr.conf
chmod 640 /etc/frr/frr.conf

########################################
# Strongswan settings
########################################
cat <<EOF > /etc/swanctl/conf.d/tgw.tf
${strongswan_conf}
EOF

cat <<EOF > /etc/strongswan.d/add-charon.conf
${charon_conf}
EOF

########################################
# Router Routing
########################################
### テーブル作成
echo "100 tgw" >> /etc/iproute2/rt_tables
### ens6 network
cat <<EOF > /etc/systemd/network/20-ens6.network
${ens6_conf}
EOF
### 反映
networkctl reload
### tgwテーブルルートルールサービス化
cat <<EOF > /etc/systemd/system/tgw-ecmp.service
${rtbrule_conf}
EOF
systemctl enable --now tgw-ecmp.service
