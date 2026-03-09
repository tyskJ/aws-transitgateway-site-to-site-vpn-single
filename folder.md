# フォルダ構成

- フォルダ構成は以下の通り

```
.
└── envs
    ├── backend.tf                              tfstateファイル管理定義ファイル
    ├── config
    │   ├── 20-ens6.network                     ens6インターフェース設定ファイル
    │   ├── 99-vpn.conf                         カーネルネットワークパラメータ変更用ファイル
    │   ├── add-charon.conf                     strongSwan向け IKEv2プロトコルを実装した VPN鍵交換及び通信管理を行う charon デーモン追加設定ファイル
    │   ├── frr_onpremises_gateway_ec2_a.conf   BGPを喋る FRRouting 設定ファイル
    │   ├── nat-ens5-ipset.service              SNAT設定を管理する systemdサービス・ユニット・ファイル
    │   ├── setup.sh                            VPNルーター作成セットアップスクリプト
    │   ├── snat_sources.conf                   iptables 補助アプリケーションである ipset が読み込むNWアドレス一覧ファイル
    │   ├── tgw-ecmp.service                    2本の IPsec トンネル（xfrm101 / xfrm102）に ECMP で振り分けるルーティングを管理する systemdサービス・ユニット・ファイル
    │   ├── tgw.conf                            strongSwan設定ファイル
    │   └── xfrm-ifaces.service                 XFRM Interface (VPNトンネル用仮想トンネルインターフェース)を管理する systemdサービス・ユニット・ファイル
    ├── data.tf                                 外部データソース定義ファイル
    ├── ec2.tf                                  EC2定義ファイル
    ├── iam.tf                                  IAM定義ファイル
    ├── locals.tf                               ローカル変数定義ファイル
    ├── logs.tf                                 CloudWatch Logs定義ファイル
    ├── outputs.tf                              リソース戻り値定義ファイル
    ├── providers.tf                            プロバイダー定義ファイル
    ├── s2svpn.tf                               Site-to-Site VPN定義ファイル
    ├── tgw.tf                                  Transit Gateway定義ファイル
    ├── variables.tf                            変数定義ファイル
    ├── versions.tf                             Terraformバージョン定義ファイル
    └── vpc.tf                                  VPC関連定義ファイル
```