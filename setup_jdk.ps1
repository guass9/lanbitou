$javaHome = "C:\Program Files\Java\jdk-17.0.18"

Write-Host "=== JDK环境配置 ===" -ForegroundColor Green
Write-Host ""

# 检查JDK路径是否存在
if (Test-Path $javaHome) {
    Write-Host "✓ JDK路径验证成功: $javaHome" -ForegroundColor Green

    # 设置JAVA_HOME
    [Environment]::SetEnvironmentVariable("JAVA_HOME", $javaHome, "Machine")
    Write-Host "✓ JAVA_HOME环境变量已设置" -ForegroundColor Green

    # 添加Java bin到Path
    $currentPath = [Environment]::GetEnvironmentVariable("Path", "Machine")
    $javaBinPath = "$javaHome\bin"

    if (-not $currentPath.Contains($javaBinPath)) {
        [Environment]::SetEnvironmentVariable("Path", "$javaBinPath;$currentPath", "Machine")
        Write-Host "✓ Java bin路径已添加到Path" -ForegroundColor Green
    } else {
        Write-Host "✓ Java bin路径已存在于Path" -ForegroundColor Green
    }

    # 验证Java版本
    Write-Host ""
    Write-Host "=== 验证Java安装 ===" -ForegroundColor Green
    & "C:\Program Files\Java\jdk-17.0.18\bin\java.exe" -version

    Write-Host ""
    Write-Host "=== 环境变量配置完成 ===" -ForegroundColor Green
    Write-Host "请重启DevEco Studio以使配置生效" -ForegroundColor Yellow
} else {
    Write-Host "✗ JDK路径不存在: $javaHome" -ForegroundColor Red
}
