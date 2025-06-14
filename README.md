# tunnelbroker
#### 一键配置 he.net 的IPv6隧道
* 许多VPS没有IPv6，某些云服务厂商更是把IPv6当**单独的服务**(*得加钱*)提供

---
> [he.net](https://he.net)又称飓风电气，成立于1944年，以其全球领先的IPv6网络和隧道代理服务闻名，是全球最大的IPv6骨干网运营商之一。
> 其免费IPv6隧道服务可以追溯到2001年。

## 使用步骤

1、注册[he.net](https://tunnelbroker.net)账号

2、创建隧道

![](https://cdn.jsdelivr.net/gh/suyuli458/tunnelbroker-config@main/img/01.webp )

* 输入公网IP后，he.net会检查是否可用
* 如果检测失败。请检查防火墙，放行ICMP入站
* 隧道节点最好别选亚洲的香港、新加坡、日本，都是绕路的

3、记下几行参数`Server IPv4 Address`、`Client IPv4 Address`、`Client IPv6 Address`

![](https://cdn.jsdelivr.net/gh/suyuli458/tunnelbroker-config@main/img/02.webp )

4、拉取脚本

```bash
curl -sL https://cdn.jsdelivr.net/gh/suyuli458/tunnelbroker-config@main/setup-he-ipv6.sh
```

5、编辑脚本，把变量参数填写你自己的
![](https://cdn.jsdelivr.net/gh/suyuli458/tunnelbroker-config@main/img/03.webp
)

6、给权限

```bash
chmod +x setup-he-ipv6.sh
```

7、运行脚本

```bash
bash setup-he-ipv6.sh
```

## 补

- 国内IP可能过不了验证，可以先用别的IP申请，然后看[P2](https://cdn.jsdelivr.net/gh/suyuli458/tunnelbroker-config@main/img/02.webp )`Client IPv4 Address`参数有个下划线，点击可以更改，这个时候再改成国内公网IP（依然会检查，但是国内IP能用）
