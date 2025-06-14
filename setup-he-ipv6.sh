#!/bin/bash

# === 用户配置区域 ===
SERVER_IPV4="216.66.80.30"      # HE.net 提供的远程 IPv4
CLIENT_IPV4="8.8.8.8"      # 你的 VPS 公网 IPv4
CLIENT_IPV6="2001:470:1f13:1234::2/64"      # HE.net 分配的本地 IPv6
TUNNEL_IFACE="he-ipv6"      # 接口名称，可自定义（建议保持 he-ipv6）
# =====================

set -e

echo "[+] 正在生成 HE.net 隧道设置脚本..."

cat <<EOF >/usr/local/bin/setup-${TUNNEL_IFACE}.sh
#!/bin/bash
set -e

# 清理旧的接口（如果存在）
ip tunnel del ${TUNNEL_IFACE} 2>/dev/null || true

# 添加新的隧道接口
ip tunnel add ${TUNNEL_IFACE} mode sit remote ${SERVER_IPV4} local ${CLIENT_IPV4} ttl 255
ip link set ${TUNNEL_IFACE} up
ip addr add ${CLIENT_IPV6} dev ${TUNNEL_IFACE}
ip -6 route add ::/0 dev ${TUNNEL_IFACE}

EOF

chmod +x /usr/local/bin/setup-${TUNNEL_IFACE}.sh

echo "[+] 正在创建 systemd 服务..."

cat <<EOF >/etc/systemd/system/${TUNNEL_IFACE}.service
[Unit]
Description=HE.net IPv6 Tunnel Setup
After=network-online.target
Wants=network-online.target

[Service]
Type=oneshot
ExecStart=/usr/local/bin/setup-${TUNNEL_IFACE}.sh
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reexec
systemctl daemon-reload
systemctl enable --now ${TUNNEL_IFACE}.service

echo "[✔] 隧道配置完成并已启动！"
ip -6 addr show dev ${TUNNEL_IFACE}
