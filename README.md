# sheng-dotfiles

小米平板 6S Pro (aarch64) 上运行 Mobile NixOS 的个人 dotfiles 配置。

系统平台层由 [nixos-sheng](https://github.com/DotRedstone/nixos-sheng) 提供，本仓库在其上叠加私有用户配置、凭据、个人软件包及 Home Manager 设置。

---

## ⚠️ 复用须知：硬编码的敏感信息

> [!CAUTION]
> 本仓库包含属于原作者的硬编码凭据，**复用前必须全部替换**，否则会带来严重的安全风险。

需要替换的内容：

| 文件 | 内容 | 说明 |
|---|---|---|
| `modules/user.nix` | `hashedPassword` | 用户密码哈希，用 `mkpasswd` 生成你自己的 |
| `modules/user.nix` | `openssh.authorizedKeys.keys` | SSH 公钥（用户 & root），替换为你自己的密钥 |
| `modules/setting.nix` | `trusted-users` 中的 `fall_dust` | 替换为你的用户名 |
| `flake.nix` | `home-manager.users.fall_dust` | 替换为你的用户名 |
| `home/user.nix` | 用户名相关配置 | 按需修改 |

生成密码哈希：

```sh
mkpasswd -m sha-512
```

---

## 项目结构

```
sheng-dotfiles/
├── flake.nix                  # Flake 入口，定义 inputs 和 outputs
├── flake.lock                 # 锁定的依赖版本
├── hosts/
│   └── sheng/
│       └── configuration.nix  # 设备主机配置（主机名、服务等）
├── modules/                   # NixOS 系统级模块
│   ├── default.nix            # 模块汇总入口
│   ├── user.nix               # ⚠️ 用户账户、密码、SSH 公钥
│   ├── setting.nix            # Nix 设置、substituters、缓存镜像
│   ├── networking.nix         # NetworkManager、防火墙规则
│   ├── ssh.nix                # OpenSSH、TFTP 服务
│   ├── proxy.nix              # daed 代理服务（默认关闭）
│   ├── fonts.nix              # 字体配置
│   ├── i18n.nix               # 国际化、输入法环境
│   ├── programs.nix           # 系统级程序
│   ├── waydroid.nix           # Waydroid（Android 容器）
│   └── desktop/               # 桌面环境模块
├── home/                      # Home Manager 用户级配置
│   ├── default.nix            # Home Manager 模块入口
│   ├── user.nix               # 用户 home 基础配置
│   ├── desktop.nix            # 桌面应用配置（niri 等）
│   ├── fcitx5.nix             # Fcitx5 输入法
│   ├── firefox.nix            # Firefox 配置
│   ├── vscode.nix             # VS Code 配置
│   ├── programs.nix           # 用户级程序
│   ├── nixpak/                # NixPak 沙箱应用
│   ├── shell/                 # Shell 配置（fish 为默认，含 zsh/bash/starship）
│   └── terminal/              # 终端配置
└── dotfiles/                  # 原始 dotfiles 文件
    ├── fastfetch/             # Fastfetch 配置
    ├── niri/                  # Niri 窗口管理器配置
    └── wallpaper/             # 壁纸
```

---

## 主要依赖

| Input | 说明 |
|---|---|
| `nixpkgs` (unstable) | 主软件包源 |
| `nixpkgs-stable` (26.05) | 稳定包源 |
| `home-manager` | 用户环境管理 |
| `nixos-sheng` | 小米平板 6S Pro 硬件平台层 |
| `nixpak` | 应用沙箱封装 |
| `nur` | Nix 用户软件仓库 |

---

## 部署

> [!NOTE]
> `home-manager` 已作为 NixOS 模块集成，随 `nixos-rebuild` 一并应用，无需单独运行 `home-manager switch`。

### 首次部署

```sh
# 锁定依赖
nix flake lock

# 构建并激活系统配置（home-manager 同步生效）
sudo nixos-rebuild build --flake .#sheng
sudo nixos-rebuild switch --flake .#sheng
```

### 日常更新

```sh
# 更新所有 inputs
nix flake update

# 仅更新硬件平台层
nix flake update nixos-sheng

# 重新构建切换
sudo nixos-rebuild switch --flake .#sheng
```

---

## 桌面环境

| 组件 | 说明 |
|---|---|
| **Niri** | 基于 Wayland 的滚动平铺窗口管理器，触屏友好 |
| **[DankMaterialShell](https://github.com/AvengeMedia/DankMaterialShell)** | Material Design 风格的 Niri Shell/面板 |
| **Fcitx5** | 输入法框架，配置位于 `home/fcitx5.nix` |
| **Fish** | 默认交互 Shell，含 Guix 环境集成与 foreign-env 插件 |
| **Starship** | 跨 Shell 提示符，与 fish/zsh/bash 均兼容 |
