# 프리텐다드 폰트 다운로드 스크립트
# PowerShell에서 실행: .\download-fonts.ps1

$fontDir = "static\fonts"
$baseUrl = "https://raw.githubusercontent.com/orioncactus/pretendard/main/dist/web/static/woff2"

# 폰트 파일 목록 (GitHub에서 확인된 실제 파일명)
$fonts = @(
    "Pretendard-Thin.woff2",
    "Pretendard-ExtraLight.woff2", 
    "Pretendard-Light.woff2",
    "Pretendard-Regular.woff2",
    "Pretendard-Medium.woff2",
    "Pretendard-SemiBold.woff2",
    "Pretendard-Bold.woff2",
    "Pretendard-ExtraBold.woff2",
    "Pretendard-Black.woff2"
)

Write-Host "🎨 프리텐다드 폰트 다운로드 시작..." -ForegroundColor Green

# 각 폰트 파일 다운로드
foreach ($font in $fonts) {
    $url = "$baseUrl\$font"
    $output = "$fontDir\$font"
    
    Write-Host "다운로드 중: $font" -ForegroundColor Yellow
    
    try {
        Invoke-WebRequest -Uri $url -OutFile $output -UseBasicParsing
        Write-Host "✅ $font 완료" -ForegroundColor Green
    }
    catch {
        Write-Host "❌ $font 실패: $($_.Exception.Message)" -ForegroundColor Red
    }
}

Write-Host "🎉 폰트 다운로드 완료!" -ForegroundColor Green
Write-Host "📁 저장 위치: $fontDir" -ForegroundColor Cyan
