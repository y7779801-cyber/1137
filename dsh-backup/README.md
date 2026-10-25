# DeepSeek Harness (DSH) 个人配置与插件备份

这是你的 DeepSeek Harness 完整环境备份库，包含所有定制化插件、思维链提纯扩展与界面配置。

## 📦 备份包含内容

1. **`package.json`**：所有已安装插件列表与 bundle 挂载清单。
2. **`cordis.patch.yml`**：界面主题、个性化配置与补丁层。
3. **`plugins/`**：
   - **`dsh-plugin-iot-thinking`**（来自 `Roninton/IoT-items-of-thoughts`）：思维链（Thinking Block）原地提纯压缩插件。
   - **`dsh-screenshot-2.3.0.tgz`**：原生微信式截图按钮插件。
4. **`restore.ps1`**：在新电脑上一键恢复全部配置的 PowerShell 脚本。

---

## 🚀 在新电脑上一键恢复步骤

在新电脑安装好 DeepSeek Harness 客户端后：

1. **克隆或下载本仓库**到新电脑；
2. 打开 PowerShell，进入本仓库目录运行：
   ```powershell
   .\restore.ps1
   ```
3. 重启 DeepSeek Harness，所有插件与配置即可无缝还原！
