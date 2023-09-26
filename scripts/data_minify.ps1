Set-Location -Path (Split-Path -Parent $PSScriptRoot)

$data = Get-Content -Path ./data/data.osm -Encoding utf8

$data = $data -replace " timestamp='\S*' uid='\S*' user='\S*' version='\S*' changeset='\S*'",""

$data = $data -replace "<tag k='source' v='.*' />",""

$data = $data -replace "<tag k='source:de' v='.*' />",""

$data = $data -replace " action='\S*'",""

$dataXML = New-Object System.Xml.XmlDocument -Property @{ PreserveWhitespace = $false }

$dataXML.LoadXml($data)

$data = $dataXML.InnerXml

$data | Out-File -FilePath ./data/data_min.osm -Encoding utf8 -NoNewline