$OutputEncoding = [Console]::OutputEncoding = [Text.Encoding]::UTF8

$PluginPath = Join-Path $env:APPDATA 'Tencent\xwechat\XPlugin\Plugins\RadiumWMPF'
$BarWidth = 37

function Set-WindowSize {
	param([int]$Width, [int]$Height)
	try {
		$Host.UI.RawUI.WindowSize = New-Object System.Management.Automation.Host.Size($Width, $Height)
	} catch {
	}
}

function Write-ProgressBar {
	param([int]$Percent)
	$filled = [Math]::Floor($BarWidth * $Percent / 100)
	Write-Host "[$('=' * $filled)$(' ' * ($BarWidth - $filled))] $Percent%"
}

function Wait-Confirm {
	Write-Host ''
	Read-Host '按回车键继续' | Out-Null
}

function Show-Menu {
	Clear-Host
	Set-WindowSize 42 13
	Write-Host '    FxxkWeChatAppEx v1.0 by LateDream'
	Write-Host '========================================='
	Write-Host '      理论上该脚本不需要管理员权限'
	Write-Host ''
	Write-Host '[k] - 关闭微信'
	Write-Host '[f] - 移除 WeChatAppEX + 防止死灰复燃'
	Write-Host ''
	Write-Host '[r] - 恢复 WeChatAppEX'
	Write-Host ''
	Write-Host '                                 [q] 退出'
	Write-Host '========================================='
}

function Stop-WeChat {
	Clear-Host
	Set-WindowSize 42 3
	$proc = Get-Process -Name Weixin -ErrorAction SilentlyContinue
	if (-not $proc) {
		Write-Host '微信未在运行'
	} else {
		try {
			$proc | Stop-Process -Force -ErrorAction Stop
			Write-Host ''
			Write-Host '成功关闭微信'
		} catch {
			Write-Host ''
			Write-Host "关闭微信失败 请尝试手动关闭微信: $($_.Exception.Message)"
		}
	}
	Write-Host ''
	Wait-Confirm
}

function Invoke-Fxxk {
	Clear-Host
	Set-WindowSize 45 3
	try {
		if (Test-Path -LiteralPath $PluginPath) {
			Remove-Item -LiteralPath $PluginPath -Recurse -Force -ErrorAction Stop
		}
		Write-Host '删除 RadiumWMPF...'
		Write-ProgressBar 50
	} catch {
		Write-Host "删除 RadiumWMPF 失败! $($_.Exception.Message)"
		Write-ProgressBar 0
		Wait-Confirm
		return
	}

	Clear-Host
	try {
		Set-Content -LiteralPath $PluginPath -Value 'FxxkWeChatAppEx' -ErrorAction Stop
		Write-Host '写入 RadiumWMPF...'
		Write-ProgressBar 75
	} catch {
		Write-Host "写入 RadiumWMPF 失败! $($_.Exception.Message)"
		Write-ProgressBar 50
		Wait-Confirm
		return
	}

	Clear-Host
	try {
		(Get-Item -LiteralPath $PluginPath -Force).IsReadOnly = $true
		Write-Host '成功! 感谢你的使用'
		Write-ProgressBar 100
	} catch {
		Write-Host "添加只读属性失败! $($_.Exception.Message)"
		Write-ProgressBar 75
	}
	Wait-Confirm
}

function Invoke-Recovery {
	Clear-Host
	Set-WindowSize 45 4
	try {
		if (Test-Path -LiteralPath $PluginPath) {
			(Get-Item -LiteralPath $PluginPath -Force).IsReadOnly = $false
			Remove-Item -LiteralPath $PluginPath -Recurse -Force -ErrorAction Stop
		}
		Write-Host '处理完成 重启微信即可完成恢复'
		Write-ProgressBar 100
	} catch {
		Write-Host "处理失败! $($_.Exception.Message)"
		Write-ProgressBar 0
	}
	Wait-Confirm
}

while ($true) {
	Show-Menu
	$option = Read-Host '>'
	switch ($option) {
		'q' { return }
		'k' { Stop-WeChat }
		'f' { Invoke-Fxxk }
		'r' { Invoke-Recovery }
		default {
			Write-Host '无效的选项'
			Wait-Confirm
		}
	}
}
