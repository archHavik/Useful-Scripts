[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; invoke-webrequest https://github.com/archHavik/Useful-Scripts/archive/refs/heads/main.zip -Outfile repo.zip; explorer .;