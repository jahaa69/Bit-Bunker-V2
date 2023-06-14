
Import-Module -Name Posh-SSH

$credential = Get-Credential
$session = New-SSHSession -ComputerName "your ip" -Credential $credential -Port "PORT"

$ping = Test-NetConnection "your ip"


###GUI
Add-Type -Assembly System.Windows.Forms
$main_form= New-Object System.Windows.Forms.Form
$main_form.Text = 'Bit Bunker'
$main_form.Width = 500
$main_form.Height = 150
$main_form.AutoSize = $true


$Label = New-Object System.Windows.Forms.Label
$Label.Text = "connection is:"
$Label.Location  = New-Object System.Drawing.Point(0,80)
$Label.AutoSize = $true
$main_form.Controls.Add($Label)


$LabelStatus = New-Object System.Windows.Forms.Label
$LabelStatus.Location  = New-Object System.Drawing.Point(0, 100)
$LabelStatus.AutoSize = $true
$main_form.Controls.Add($LabelStatus)

# Vérifier la valeur de $ping.PingSucceeded
if ($ping.PingSucceeded) {
    $LabelStatus.Text = "up"
    $LabelStatus.ForeColor = "Green"
} else {
    $LabelStatus.Text = "down"
    $LabelStatus.ForeColor = "Red"
}

try{
#code export
$Button = New-Object System.Windows.Forms.Button
$Button.Location = New-Object System.Drawing.Size(400,10)
$Button.Size = New-Object System.Drawing.Size(120,50)
$Button.Text = "Export"
$main_form.Controls.Add($Button)
$Button.Add_Click({
    $sourcePath = "$env:USERPROFILE\Desktop\BitBunker\export"
    $destinationPath = "YOUR PATH"
        ###Test dossier vide export
$emptyfolderforEX= Get-ChildItem -Path "$env:USERPROFILE\Desktop\BitBunker\export"
if($emptyfolderforEX -eq $null){
    [System.Windows.Forms.MessageBox]::Show("Dossier vide.", "Information", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
    }else{

    Get-ChildItem -Path $sourcePath | ForEach-Object {
        $destinationFile = Join-Path -Path $destinationPath -ChildPath $_.Name
        Copy-Item -Path $_.FullName -Destination $destinationFile -Force
    }

    [System.Windows.Forms.MessageBox]::Show("Export terminé.", "Information", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)

    }
})
}
catch{
Add-Type -AssemblyName System.Windows.Forms

$Form = New-Object System.Windows.Forms.Form
$Label = New-Object System.Windows.Forms.Label

$Form.Text = "erreur: 0010"
$Form.Size = New-Object System.Drawing.Size(400, 200)
$Form.StartPosition = "CenterScreen"

$Label.Text = "une erreur est survenue au moment de l'export."
$Label.Location = New-Object System.Drawing.Point(50, 50)
$Label.AutoSize = $true
$Label.ForeColor = "Red"

$Form.Controls.Add($Label)

$Form.ShowDialog()
}


try{


#Code Import
$Button2 = New-Object System.Windows.Forms.Button
$Button2.Location = New-Object System.Drawing.Size(10,10)
$Button2.Size = New-Object System.Drawing.Size(120,50)
$Button2.Text = "Import"
$main_form.Controls.Add($Button2)
$Button2.Add_Click({
    $sourcePath = "YOUR PATH"
    $destinationPath = "$env:USERPROFILE\Desktop\BitBunker\import"

    Get-ChildItem -Path $sourcePath | ForEach-Object {
        $destinationFile = Join-Path -Path $destinationPath -ChildPath $_.Name
        Copy-Item -Path $_.FullName -Destination $destinationFile -Force
    }

    [System.Windows.Forms.MessageBox]::Show("Import terminé.", "Information", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
})
}
catch{
[System.Windows.Forms.MessageBox]::Show("un probleme es sur venue au moment de l'import.", "Information", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
}




###Code initialisation
$error1 ="Le dossier 'BitBunker' existe déjà sur le bureau."
$filePath = "$env:USERPROFILE\Desktop\BitBunker"
$Button3 = New-Object System.Windows.Forms.Button
$Button3.Location = New-Object System.Drawing.Size(200,10)
$Button3.Size = New-Object System.Drawing.Size(120,50)
$Button3.Text = "initialisation"
$main_form.Controls.Add($Button3)
$Button3.Add_click({
if (-not(Test-Path -Path $filePath)) {
    New-Item -ItemType Directory -Path "$env:USERPROFILE\Desktop\BitBunker"
    New-Item -ItemType Directory -Path "$env:USERPROFILE\Desktop\BitBunker\import"
    New-Item -ItemType Directory -Path "$env:USERPROFILE\Desktop\BitBunker\export" 
}
else {###code pour afficher les erreurs
[System.Windows.Forms.MessageBox]::Show("le fichier existe deja.", "Information", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
}
})

$main_form.add_Closing({
    # Supprimer la session SSH lorsque le formulaire se ferme
    Remove-SSHSession -SSHSession $session
})

###
$main_form.ShowDialog()


