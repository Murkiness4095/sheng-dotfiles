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

  sandboxed-qq = mkNixPak {
    config =
      { sloth, ... }:
      {
        # 使用 nixpkgs 官方 qq 包（稳定、已缓存）
        app.package = pkgs.qq;
        app.binPath = "bin/qq"; # 官方包的实际可执行路径

        # Flatpak-like ID，用于桌面集成
        flatpak.appId = "com.tencent.QQ";

        dbus.enable = true;
        dbus.policies = {
          # 写 "portal.*" 会导致 qq 文件选择器逃逸，必须手动指定 portal 权限
          # "org.freedesktop.portal.*" = "talk"; # 文件选择、截屏、通知等
          "org.freedesktop.portal.Notification" = "talk";
          "org.freedesktop.portal.Settings" = "talk";
          "org.freedesktop.portal.Screenshot" = "talk";
          "org.freedesktop.Notifications" = "talk";
          "ca.desrt.dconf" = "talk"; # 设置存储
          "org.kde.StatusNotifierWatcher" = "talk"; # 注册系统托盘项
          "org.freedesktop.StatusNotifierHost" = "own"; # 作为 Host 发通知
        };

        etc.sslCertificates.enable = true; # HTTPS 网络

        gpu.enable = true;
        gpu.provider = "bundle"; # Electron GPU 加速

        bubblewrap = {
          network = true; # qq 需要联网

          env = {
            # 修复qq中文输入法
            GTK_IM_MODULE = "fcitx";
            QT_IM_MODULE = "fcitx";
            XMODIFIERS = "@im=fcitx";

            ELECTRON_OZONE_PLATFORM_HINT = "wayland";
          };

          bind.dev = [
            "/dev/dri" # GPU 渲染
            "/dev/snd" # 音频（语音消息、视频通话）
            "/dev/shm" # 共享内存
            "/dev/video0" # 摄像头（视频通话，可选）
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
            "/tmp/QQ"
            
            (sloth.concat' sloth.runtimeDir "/doc")  # 从 ro 移到 rw

            # --- 自定义持久化映射 [ "宿主机物理路径" "应用以为的沙盒路径" ] ---
            
            # Programs/ 放配置和数据
            [
              (sloth.concat' sloth.homeDir "/data/Programs/Chat/qq/config")
              (sloth.concat' sloth.homeDir "/.config/QQ")
            ]
            [
              (sloth.concat' sloth.homeDir "/data/Programs/Chat/qq/local-share")
              (sloth.concat' sloth.homeDir "/.local/share/QQ")
            ]
            [
              (sloth.concat' sloth.homeDir "/data/Programs/Chat/qq/cache")
              (sloth.concat' sloth.homeDir "/.cache/QQ")
            ]

            # Soft_tmp/ 放下载文件
            [
              (sloth.concat' sloth.homeDir "/data/Soft_tmp/Chat/qq/Downloads")
              (sloth.concat' sloth.homeDir "/Downloads")
            ]
          ];

          bind.ro = [
            # (sloth.concat' sloth.runtimeDir "/doc")
            (sloth.concat' sloth.xdgConfigHome "/kdeglobals")
            (sloth.concat' sloth.xdgConfigHome "/gtk-2.0")
            (sloth.concat' sloth.xdgConfigHome "/gtk-3.0")
            (sloth.concat' sloth.xdgConfigHome "/gtk-4.0")
            (sloth.concat' sloth.xdgConfigHome "/fontconfig")
            (sloth.concat' sloth.xdgConfigHome "/dconf")


            # Use system font settings instead
            "/etc/fonts"
            "/etc/localtime"

            # Fix: libEGL warning: egl: failed to create dri2 screen
            "/etc/egl"
            "/etc/static/egl"

            # 修复qq播放视频消息无声音
            "/etc/static/alsa"
            "/etc/alsa"

            # 修复qq文件选择器图标
            "/run/current-system/sw/share/mime"
            "/run/current-system/sw/share/icons"
          ];

          sockets = {
            wayland = true;
            x11 = false;
            pipewire = true; # 语音/视频通话音频支持
          };
        };
      };
  };

in
{
  home.packages = [
    sandboxed-qq.config.env
  ];

  # 确保启动器里出现 QQ 图标
  # 复制 .desktop 文件到本地
  home.activation.createQQDesktopAlias = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    ln -sf ${sandboxed-qq.config.env}/share/applications/* $HOME/.local/share/applications/ || true
    mkdir -p /tmp/QQ

    # 创建持久化数据目录（别人使用此配置时自动初始化，避免数据写入临时位置丢失）
    mkdir -p $HOME/data/Programs/Chat/qq/config    # QQ 配置和聊天记录数据库
    mkdir -p $HOME/data/Programs/Chat/qq/local-share  # QQ 本地数据
    mkdir -p $HOME/data/Programs/Chat/qq/cache     # QQ 缓存
    mkdir -p $HOME/data/Soft_tmp/Chat/qq/Downloads # QQ 下载的文件、图片、视频

    # --- 阻止 QQ 热更新 --- 【不防呆，如果不小心点到 “立即重启更新” qq还是会更新，重启后会卡白屏无登录框，需要去qq配置路径把versions文件夹删了】
    # QQ 会在 versions/config.json 里记录当前版本并尝试自动更新
    # 通过 chattr +i 锁定该文件，使 QQ 无法修改版本信息，从而阻止热更新
    mkdir -p $HOME/data/Programs/Chat/qq/config/versions

    CONFIG_FILE="$HOME/data/Programs/Chat/qq/config/versions/config.json"

    # 读取 nix 包里的版本号，作为期望版本
    NIX_VERSION=$(${pkgs.jq}/bin/jq -r '.version' \
      ${pkgs.qq}/opt/QQ/resources/app/package.json 2>/dev/null || echo "unknown")

    # 读取当前 config.json 里记录的版本号
    if [ -f "$CONFIG_FILE" ]; then
      CURRENT_VERSION=$(${pkgs.jq}/bin/jq -r '.curVersion // empty' \
        "$CONFIG_FILE" 2>/dev/null || echo "")
    else
      CURRENT_VERSION=""
    fi

    # 版本不一致时（首次使用或 nix 包升级后），重新生成 config.json
    # 需要启动一次 QQ 让它自动写入正确的版本信息，然后再锁定
    if [ "$NIX_VERSION" != "$CURRENT_VERSION" ]; then
      ${pkgs.e2fsprogs}/bin/chattr -i "$CONFIG_FILE" 2>/dev/null || true  # 先解锁（如果已锁定）
      rm -f "$CONFIG_FILE"                                                  # 删除旧文件
      ${sandboxed-qq.config.env}/bin/qq --no-sandbox &                     # 后台启动 QQ 生成新文件
      QQ_PID=$!
      sleep 8                                                               # 等待 QQ 写入完成
      kill $QQ_PID 2>/dev/null || true                                      # 关闭临时启动的 QQ
      wait $QQ_PID 2>/dev/null || true
    fi

    # 锁定 config.json 防止 QQ 运行时自动热更新覆盖版本信息
    [ -f "$CONFIG_FILE" ] && ${pkgs.e2fsprogs}/bin/chattr +i "$CONFIG_FILE" || true
  '';
}