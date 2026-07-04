{
  pkgs,
  inputs,
  lib,
  ...
}:

let
  mkNixPak = inputs.nixpak.lib.nixpak {
    inherit (pkgs) lib;
    inherit pkgs;
  };

  sandboxed-wechat = mkNixPak {
    config =
      { sloth, ... }:
      {
        # 使用 nixpkgs 自带的 wechat（稳定、已缓存）
        app.package = pkgs.wechat;
        app.binPath = "bin/wechat"; # 官方包的实际可执行路径

        # Flatpak-like ID，用于桌面集成
        flatpak.appId = "com.tencent.WeChat";

        dbus.enable = true;
        dbus.policies = {
          "org.freedesktop.portal.*" = "talk"; # 文件选择、截屏等
          "org.freedesktop.Notifications" = "talk";
          "ca.desrt.dconf" = "talk"; # 设置存储
          "org.kde.StatusNotifierWatcher" = "talk"; # 注册系统托盘项
          "org.kde.*" = "own";  # 修复托盘图标
          "org.freedesktop.StatusNotifierHost" = "own"; # 作为 Host 发通知
        };

        etc.sslCertificates.enable = true; # 网络 HTTPS

        gpu.enable = true;
        gpu.provider = "bundle"; # Electron GPU 加速

        bubblewrap = {
          network = true;

          
          env = {
            # 修复wechat中文输入法
            GTK_IM_MODULE = "fcitx";
            QT_IM_MODULE = "fcitx";
            XMODIFIERS = "@im=fcitx";

            ELECTRON_OZONE_PLATFORM_HINT = "wayland";
            NIXOS_XDG_OPEN_USE_PORTAL = "1"; # 让wechat用系统默认浏览器打开链接
            GTK_USE_PORTAL = "1"; # 防止文件选择器沙箱逃逸
          };

          bind.dev = [
            "/dev/dri" # GPU
            "/dev/snd" # 音频（语音通话）
            "/dev/shm" # 共享内存
            "/dev/video0" # 摄像头（视频通话，可选删掉如果不用）
          ];

          bind.rw = with sloth; [
            (sloth.concat [
              sloth.runtimeDir
              "/"
              (sloth.envOr "WAYLAND_DISPLAY" "no")
            ])
            (sloth.concat' sloth.runtimeDir "/at-spi/bus")
            (sloth.concat' sloth.runtimeDir "/gvfsd")
            (sloth.concat' sloth.runtimeDir "/dconf")

            (sloth.concat' sloth.xdgCacheHome "/fontconfig")
            (sloth.concat' sloth.xdgCacheHome "/mesa_shader_cache")
            (sloth.concat' sloth.xdgCacheHome "/mesa_shader_cache_db")
            (sloth.concat' sloth.xdgCacheHome "/radv_builtin_shaders")

            (sloth.env "XDG_RUNTIME_DIR")
            "/tmp/wechat"
            

            # --- 自定义持久化映射 [ "宿主机物理路径" "应用以为的沙盒路径" ] ---

            # Programs/ 放配置和数据
            [
              (sloth.concat' sloth.homeDir "/data/Programs/Chat/wechat/xdg-config")
              xdgConfigHome
            ]
            [
              (sloth.concat' sloth.homeDir "/data/Programs/Chat/wechat/xwechat")
              (sloth.concat' sloth.homeDir "/.xwechat")
            ]

            # Soft_tmp/ 放缓存和下载
            [
              (sloth.concat' sloth.homeDir "/data/Soft_tmp/Chat/wechat/cache")
              xdgCacheHome
            ]
            [
              (sloth.concat' sloth.homeDir "/data/Soft_tmp/Chat/wechat/Downloads")
              (sloth.concat' sloth.homeDir "/Downloads")
            ]
          ];

          bind.ro = [
            (sloth.concat' sloth.runtimeDir "/doc")
            (sloth.concat' sloth.xdgConfigHome "/kdeglobals")
            (sloth.concat' sloth.xdgConfigHome "/gtk-2.0")
            (sloth.concat' sloth.xdgConfigHome "/gtk-3.0")
            (sloth.concat' sloth.xdgConfigHome "/gtk-4.0")
            (sloth.concat' sloth.xdgConfigHome "/fontconfig")
            (sloth.concat' sloth.xdgConfigHome "/dconf")

            # (sloth.concat' sloth.homeDir "/Downloads")

            # Use system font settings instead
            "/etc/fonts"
            "/etc/localtime"

            # Fix: libEGL warning: egl: failed to create dri2 screen
            "/etc/egl"
            "/etc/static/egl"

            # 提供硬件信息和用户身份映射（防止沙箱内崩溃）
            # "/sys"
            "/sys/dev"
            "/sys/devices"
            "/etc/passwd"
            "/etc/group"
            "/etc/machine-id"
          ];

          sockets = {
            wayland = true;
            x11 = false;
            pipewire = true;
          };
        };
      };
  };

in
{
  home.packages = [
    sandboxed-wechat.config.env
  ];

  # 复制 .desktop 文件到本地
  home.activation.createWeChatDesktopAlias = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    ln -sf ${sandboxed-wechat.config.env}/share/applications/* $HOME/.local/share/applications/ || true
    mkdir -p /tmp/wechat

    # 创建持久化数据目录（别人使用此配置时自动初始化，避免数据写入临时位置丢失）
    mkdir -p $HOME/data/Programs/Chat/wechat/xdg-config    # gtk/dconf 主题配置
    mkdir -p $HOME/data/Programs/Chat/wechat/xwechat        # 微信数据、登录状态、聊天记录
    mkdir -p $HOME/data/Soft_tmp/Chat/wechat/cache          # 微信缓存

    # 微信下载目录，微信会在此目录下强制创建 xwechat_files/ 存放聊天文件（图片、视频、语音等）
    # 注意：微信将存储路径与此目录绑定，无法通过符号链接或 bind mount 重定向，只能接受现实
    # 首次使用需在微信 设置→通用→存储位置 手动选择沙箱内的 /Downloads 目录
    mkdir -p $HOME/data/Soft_tmp/Chat/wechat/Downloads      # 微信下载的文件、图片、视频
  '';
}
