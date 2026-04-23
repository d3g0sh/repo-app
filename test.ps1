# 1. Cargar las librerías necesarias
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# 2. Crear la ventana principal (Form)
$form = New-Object System.Windows.Forms.Form
$form.Text = "APP TEST (d3g0sh)"
$form.Size = New-Object System.Drawing.Size(400, 200)
$form.StartPosition = "CenterScreen"

# Crear el Checkbox
$cB1 = New-Object System.Windows.Forms.CheckBox
$cB1.Location = New-Object System.Drawing.Point(20, 20)
$cB1.Text = "Disable Firewall"
$cB1.AutoSize = $true

$cB2 = New-Object System.Windows.Forms.CheckBox
$cB2.Location = New-Object System.Drawing.Point(20, 40)
$cB2.Text = "Delete Temp and %Temp% files"
$cB2.AutoSize = $true

$cB3 = New-Object System.Windows.Forms.CheckBox
$cB3.Location = New-Object System.Drawing.Point(20, 60)
$cB3.Text = "Delete Prefetch files"
$cB3.AutoSize = $true

# Crear el botón de acción
$btnA = New-Object System.Windows.Forms.Button
$btnA.Location = New-Object System.Drawing.Point(20, 100)
$btnA.Size = New-Object System.Drawing.Size(120, 30)
$btnA.Text = "Apply changes"

$btnR = New-Object System.Windows.Forms.Button
$btnR.Location = New-Object System.Drawing.Point(150, 100)
$btnR.Size = New-Object System.Drawing.Size(120, 30)
$btnR.Text = "Restore changes"

# apply changes
$btnA.Add_Click({
        if ($cB1.Checked) {
            try {
                # temp
                $tempPath = "C:\Windows\Temp"
                Get-ChildItem -Path $tempPath -Force | Remove-Item -Recurse -Force -ErrorAction SilentlyContinue

                # %temp%
                $userTempPath = [System.IO.Path]::GetTempPath()
                Get-ChildItem -Path $userTempPath -Force | Remove-Item -Recurse -Force -ErrorAction SilentlyContinue

                # prefetch
                $prefetchPath = "C:\Windows\Prefetch"
                Get-ChildItem -Path $prefetchPath -Recurse | Remove-Item -Force -Recurse -ErrorAction SilentlyContinue

                #Set-NetFirewallProfile -Profile Domain, Public, Private -Enabled False -ErrorAction Stop
                [System.Windows.Forms.MessageBox]::Show("Successfully disabled.")
            }
            catch {
                [System.Windows.Forms.MessageBox]::Show("Error: Make sure you run this program as an administrator.", "Permissions Error")
            }
        }
        else {
            [System.Windows.Forms.MessageBox]::Show("Please check the box first.")
        }
    })

# restore changes
$btnR.Add_Click({
        try {
            # Activate the Firewall
            Set-NetFirewallProfile -Profile Domain, Public, Private -Enabled True -ErrorAction Stop
            # 
            [System.Windows.Forms.MessageBox]::Show("Successfully restored.")
        }
        catch {
            [System.Windows.Forms.MessageBox]::Show("Error: Make sure you run this program as Administrator.", "Permissions Error")
        }
    })

# 5. Agregar el botón al formulario y mostrarlo
$form.Controls.Add($cB1)
$form.Controls.Add($cB2)
$form.Controls.Add($cB3)

$form.Controls.Add($btnA)
$form.Controls.Add($btnR)

$form.ShowDialog() | Out-Null
