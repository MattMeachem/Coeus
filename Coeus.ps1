Add-Type -AssemblyName PresentationFramework, PresentationCore, WindowsBase
Add-Type -AssemblyName System.Windows.Forms

# Create a window
$window = New-Object Windows.Window
$window.Title = "Log File Search"
$window.Width = 400
$window.Height = 250
$window.WindowStartupLocation = "CenterScreen"

# Create stack panel for vertical layout
$stackPanel = New-Object Windows.Controls.StackPanel

# Add label and button for log file selection
$logLabel = New-Object Windows.Controls.Label
$logLabel.Content = "Select the logs.txt file:"
$stackPanel.Children.Add($logLabel)

$logTextBox = New-Object Windows.Controls.TextBox
$logTextBox.Width = 250
$stackPanel.Children.Add($logTextBox)

$logButton = New-Object Windows.Controls.Button
$logButton.Content = "Browse"
$logButton.Add_Click({
    $openFileDialog = New-Object System.Windows.Forms.OpenFileDialog
    $openFileDialog.Filter = "Text files (*.txt)|*.txt"
    $openFileDialog.Title = "Select the logs.txt file"
    $openFileDialog.InitialDirectory = [Environment]::GetFolderPath('Desktop')
    $result = $openFileDialog.ShowDialog()

    if ($result -eq [System.Windows.Forms.DialogResult]::OK) {
        $logTextBox.Text = $openFileDialog.FileName
    }
})
$stackPanel.Children.Add($logButton)

# Add label and button for IOC file selection
$iocLabel = New-Object Windows.Controls.Label
$iocLabel.Content = "Select the IOC (Indicator of Compromise) file:"
$stackPanel.Children.Add($iocLabel)

$iocTextBox = New-Object Windows.Controls.TextBox
$iocTextBox.Width = 250
$stackPanel.Children.Add($iocTextBox)

$iocButton = New-Object Windows.Controls.Button
$iocButton.Content = "Browse"
$iocButton.Add_Click({
    $openFileDialog = New-Object System.Windows.Forms.OpenFileDialog
    $openFileDialog.Filter = "Text files (*.txt)|*.txt"
    $openFileDialog.Title = "Select the IOC (Indicator of Compromise) file"
    $openFileDialog.InitialDirectory = [Environment]::GetFolderPath('Desktop')
    $result = $openFileDialog.ShowDialog()

    if ($result -eq [System.Windows.Forms.DialogResult]::OK) {
        $iocTextBox.Text = $openFileDialog.FileName
    }
})
$stackPanel.Children.Add($iocButton)

# Add button to initiate search
$searchButton = New-Object Windows.Controls.Button
$searchButton.Content = "Search"
$searchButton.Add_Click({
    $logFilePath = $logTextBox.Text
    $iocFilePath = $iocTextBox.Text
    $iocData = Get-Content $iocFilePath | Where-Object { $_ -ne "" -and $_ -notmatch "^\s+$" }
    $iocPattern = $iocData -join '|'  # Create regex pattern from IOC data
    Write-Host "Regular Expression Pattern: $iocPattern"
    Write-Host "Searching for IP addresses using pattern: $iocPattern"
    
    $logContent = Get-Content $logFilePath
    Write-Host "Log File Content:"
    $logContent

    $matches = Select-String -Path $logFilePath -Pattern $iocPattern -AllMatches
    Write-Host "Matches found:"
    $matches

    if ($matches) {
        foreach ($match in $matches.Matches) {
            [System.Windows.MessageBox]::Show("Match found in log file: $($match.Value)")
        }
    } else {
        [System.Windows.MessageBox]::Show("No match found")
    }
    $window.Close()
})