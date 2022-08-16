#!/bin/bash
vmess_req() {
    user=$(tr </dev/urandom -dc a-zA-Z0-9 | head -c8)
    echo -e "[1] Digi"
    echo -e "[2] Maxis"
    echo -ne "Telco ? : "
    read telco
    case "$telco" in
    1)
        kumbang='cf.ctechdidik.me'
        ;;
    2)
        kumbang='who.int'
        ;;
    *)
        vmess_req
        ;;
    esac
    read -p "Domain : " domain
    read -p "Uuid   : " uuid
    read -p "path   : " path

    cat >/root/$user-tls.json <<EOF
      {
      "v": "0",
      "ps": "${user}",
      "add": "${kumbang}",
      "port": "443",
      "id": "${uuid}",
      "aid": "0",
      "net": "ws",
      "path": "wss://${kumbang}${path}",
      "type": "none",
      "host": "${domain}",
      "sni": "${kumbang}",
      "tls": "tls"
}
EOF

    vmesslink1="vmess://$(base64 -w 0 /root/$user-tls.json)"
    echo ""
    echo "Config : $vmesslink1"
    rm -f /root/$user-tls.json
}

vless_req() {
    user=$(tr </dev/urandom -dc a-zA-Z0-9 | head -c8)
    echo -e "[1] Digi"
    echo -e "[2] Maxis"
    echo -ne "Telco ? : "
    read telco
    case "$telco" in
    1)
        kumbang='cf.ctechdidik.me'
        ;;
    2)
        kumbang='who.int'
        ;;
    *)
        vless_req
        ;;
    esac
    read -p "Domain : " domain
    read -p "Uuid   : " uuid
    read -p "path   : " path

    echo ""
    echo "Config : vless://${uuid}@${kumbang}:443?path=wss://${kumbang}${path}&security=tls&encryption=none&type=ws&host=${domain}&sni=${kumbang}#${user}"
}

protocol_req() {
    echo -e "[1] Vmess"
    echo -e "[2] Vless"
    echo -ne "Protocol ? : "
    read proto
    case "$proto" in
    1)
        vmess_req
        ;;
    2)
        vless_req
        ;;
    *)
        protocol_req
        ;;
    esac
}

protocol_req
