$url = "ENTER URL HERE"

# Prompt the user to choose the download location
$saveFileDialog = New-Object System.Windows.Forms.SaveFileDialog
$saveFileDialog.Filter = "Executable files (*.exe)|*.exe"
$saveFileDialog.Title = "Save As"
$saveFileDialog.FileName = "downloader.exe"

$downloaded = $false
$outputPath = ""

if ($saveFileDialog.ShowDialog() -eq "OK") {
    $outputPath = $saveFileDialog.FileName

    try {
        $webClient = New-Object System.Net.WebClient
        $webClient.DownloadFile($url, $outputPath)
        $downloaded = $true
    } catch [System.Net.WebException] {
        $errorMessage = $_.Exception.Message
        if ($_.Exception.InnerException) {
            $errorMessage += "`r`nInner Exception: " + $_.Exception.InnerException.Message
        }
    } catch {
        $errorMessage = "An unexpected error occurred: $_"
    }
}

if ($downloaded) {
    $msg = "Download completed successfully! File saved to: $outputPath"
} else {
    $msg = "Failed to download the file. Error: $errorMessage"
}

# Show message box
Add-Type -AssemblyName PresentationFramework
[System.Windows.MessageBox]::Show($msg, "Download Status", "OK", "Information")
