# PowerShell script to create a simple app icon
param(
    [string]$OutputPath = "C:\Users\User\HOMMIE\assets\icon\icon.png"
)

Add-Type -AssemblyName System.Drawing

# Create a bitmap
$bitmap = New-Object System.Drawing.Bitmap(1024, 1024)
$graphics = [System.Drawing.Graphics]::FromImage($bitmap)

# Set high quality rendering
$graphics.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
$graphics.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::AntiAlias

# Create gradient background
$rect = New-Object System.Drawing.Rectangle(0, 0, 1024, 1024)
$brush = New-Object System.Drawing.Drawing2D.LinearGradientBrush(
    $rect,
    [System.Drawing.Color]::FromArgb(255, 102, 126, 234),  # #667eea
    [System.Drawing.Color]::FromArgb(255, 118, 75, 162),   # #764ba2
    45
)

# Fill background with gradient
$graphics.FillEllipse($brush, 80, 80, 864, 864)

# Create house shape
$houseBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::White)

# House base
$graphics.FillRectangle($houseBrush, 350, 450, 324, 250)

# House roof (triangle)
$roofPoints = @(
    [System.Drawing.Point]::new(512, 350),
    [System.Drawing.Point]::new(320, 450),
    [System.Drawing.Point]::new(704, 450)
)
$graphics.FillPolygon($houseBrush, $roofPoints)

# Door
$doorBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 79, 70, 229))
$graphics.FillRectangle($doorBrush, 480, 580, 64, 120)

# Windows
$windowBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 56, 189, 248))
$graphics.FillRectangle($windowBrush, 380, 480, 50, 40)
$graphics.FillRectangle($windowBrush, 594, 480, 50, 40)

# Add "H" text
$font = New-Object System.Drawing.Font("Arial", 200, [System.Drawing.FontStyle]::Bold)
$textBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::White)
$textRect = New-Object System.Drawing.RectangleF(0, 0, 1024, 1024)
$format = New-Object System.Drawing.StringFormat
$format.Alignment = [System.Drawing.StringAlignment]::Center
$format.LineAlignment = [System.Drawing.StringAlignment]::Center

$graphics.DrawString("H", $font, $textBrush, $textRect, $format)

# Save the image
$bitmap.Save($OutputPath, [System.Drawing.Imaging.ImageFormat]::Png)

# Clean up
$graphics.Dispose()
$bitmap.Dispose()
$brush.Dispose()
$houseBrush.Dispose()
$doorBrush.Dispose()
$windowBrush.Dispose()
$textBrush.Dispose()
$font.Dispose()

Write-Host "Icon created successfully at: $OutputPath"
