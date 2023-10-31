function main{
	$folderPath = folder_dir
	create_folder $folderPath
	$fileNames, $fileExt = determine_filetype $folderPath
	$imageNames, $videoNames, $musicNames, $appNames, $docNames, $archNames = sort_filetype $folderPath $fileNames $fileExt
	move_files $folderPath $imageNames $videoNames $musicNames $appNames $docNames $archNames
}

function folder_dir{
	Write-Host "Enter Directory Path: " -NoNewLine; $folderPath = Read-Host
	$folderPath = valid_dir $folderPath
	if($folderPath -eq $false){
		Write-Host "`nPlease enter a valid directory path."
		folder_dir
	} else{
		return $folderPath
	}
}

function valid_dir{
	param($folderPath)
	$validPath = Test-Path $folderPath
	if($validPath -eq $false){
		return $false
	} else{
		return $folderPath
	}
}

function determine_filetype{
	param($folderPath)
	$fileNames = Get-ChildItem $folderPath -name
	$fileExt = [System.Collections.Generic.List[Object]]::new()
	for($i=0; $i -lt $fileNames.Length; $i++){
		$fileExt.Add((Get-ChildItem ($folderPath + "\" + $fileNames[$i])).extension)
	}
	return $fileNames, $fileExt
}

function sort_filetype{
	param($folderPath, $fileNames, $fileExt)
	$videoExt = ".mp4", ".mkv", ".mov", ".avi", ".wmv", ".webm", ".flv", ".f4v", ".swf"
	$imageExt = ".psd", ".png", ".jpg", ".jpeg", ".gif", ".bmp", ".tiff", ".tif", ".ai", ".raw"
	$musicExt = ".m4a", ".mp3", ".flac", ".aac", ".wav", ".ogg", ".alac", ".aiff", ".dsd", ".pcm"
	$appExt = ".exe", ".bat", ".js", ".py", ".app", ".dmg", ".bin", ".msi"
	$docExt = ".doc", ".docx", ".html", ".htm", ".odt", ".pdf", ".xls", ".xlsx", ".xlsm", ".ods", ".ppt", ".pptx", ".txt"
	$archExt = ".zip", ".7z", ".rar", ".tar"
	$imageNames, $videoNames, $musicNames, $appNames, $docNames, $archNames = 1..6 | % {New-Object System.Collections.Generic.List[Object]}
	for($i=0; $i -lt $fileNames.Length; $i++){
		if($imageExt -contains $fileExt[$i]){
			$imageNames.Add($fileNames[$i])
		} elseif($videoExt -contains $fileExt[$i]){
			$videoNames.Add($fileNames[$i])
		} elseif($musicExt -contains $fileExt[$i]){
			$musicNames.Add($fileNames[$i])
		} elseif($appExt -contains $fileExt[$i]){
			$appNames.Add($fileNames[$i])
		} elseif($docExt -contains $fileExt[$i]){
			$docNames.Add($fileNames[$i])
		} elseif($archExt -contains $fileExt[$i]){
			$archNames.Add($fileNames[$i])
		}
	}
	return $imageNames, $videoNames, $musicNames, $appNames, $docNames, $archNames
}

function create_folder{
	param($folderPath)
	for($i=0; $i -lt 6; $i++){
		Switch($i){
			0 {$subFolderName = "Images"}
			1 {$subFolderName = "Videos"}
			2 {$subFolderName = "Music"}
			3 {$subFolderName = "Applications"}
			4 {$subFolderName = "Documents"}
			5 {$subFolderName = "Archives"}
		}
		try{
			New-Item -path $folderPath -ItemType Directory -name $subFolderName -ErrorAction Stop | Out-Null
			Write-Host $subfoldername -ForegroundColor Cyan -NoNewLine; Write-Host " Created" -ForegroundColor Green
		} catch [System.IO.IOException]{
			Write-Host $subfoldername -ForegroundColor Cyan -NoNewLine; Write-Host " Already Exists" -ForegroundColor Red
		}
	}
	return
}

function move_files{
	param($folderPath, $imageNames, $videoNames, $musicNames, $appNames, $docNames, $archNames)
	foreach($image in $imageNames){
		if($image -ne "Images"){
			write-host $image -NoNewLine -ForegroundColor Cyan
			Move-Item -Path ($folderPath+"\"+$image) -Destination ($folderPath+"\Images\"+$image) -ErrorAction SilentlyContinue
			write-host " Moved to Images" -ForegroundColor Green
		}
	}
	foreach($video in $videoNames){
		if($video -ne "Videos"){
			write-host $video -NoNewLine -ForegroundColor Cyan
			Move-Item -Path ($folderPath+"\"+$video) -Destination ($folderPath+"\Videos\"+$video) -ErrorAction SilentlyContinue
			write-host " Moved to Videos" -ForegroundColor Green
		}
	}
	foreach($song in $musicNames){
		if($song -ne "Songs"){
			write-host $song -NoNewLine -ForegroundColor Cyan
			Move-Item -Path ($folderPath+"\"+$song) -Destination ($folderPath+"\Music\"+$song) -ErrorAction SilentlyContinue
			write-host " Moved to Music" -ForegroundColor Green
		}
	}
	foreach($app in $appNames){
		if($app -ne "Applications"){
			write-host $app -NoNewLine -ForegroundColor Cyan
			Move-Item -Path ($folderPath+"\"+$app) -Destination ($folderPath+"\Applications\"+$app) -ErrorAction SilentlyContinue
			write-host " Moved to Applications" -ForegroundColor Green
		}
	}
	foreach($doc in $docNames){
		if($doc -ne "Documents"){
			write-host $doc -NoNewLine -ForegroundColor Cyan
			Move-Item -Path ($folderPath+"\"+$doc) -Destination ($folderPath+"\Documents\"+$doc) -ErrorAction SilentlyContinue
			write-host " Moved to Documents" -ForegroundColor Green
		}
	}
	foreach($archive in $archNames){
		if($archive -ne "Archives"){
			write-host $archive -NoNewLine -ForegroundColor Cyan
			Move-Item -Path ($folderPath+"\"+$archive) -Destination ($folderPath+"\Archives\"+$archive) -ErrorAction SilentlyContinue
			write-host " Moved to Archives" -ForegroundColor Green
		}
	}

}

main