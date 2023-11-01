function main{
	$folderPath = folder_dir
	create_folder $folderPath
	$fileNames, $fileExt = determine_filetype $folderPath
	$imageNames, $videoNames, $musicNames = sort_filetype $folderPath $fileNames $fileExt
	
	move_files $folderPath $imageNames $videoNames $musicNames
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
	$fileExt = @()
	for($i=0; $i -lt $fileNames.Length; $i++){
		$fileExt += (Get-ChildItem ($folderPath + "\" + $fileNames[$i])).extension
	}
	return $fileNames, $fileExt
}

function sort_filetype{
	param($folderPath, $fileNames, $fileExt)
	$videoExt = ".mp4", ".mkv"
	$imageExt = ".psd", ".png", ".jpg", ".jpeg", ".gif"
	$musicExt = ".m4a", ".mp3", ".flac"
	$imageNames = [System.Collections.Generic.List[Object]]::new()
	$videoNames = [System.Collections.Generic.List[Object]]::new()
	$musicNames = [System.Collections.Generic.List[Object]]::new()
	for($i=0; $i -lt $fileNames.Length; $i++){
		if($imageExt -contains $fileExt[$i]){
			$imageNames.Add($fileNames[$i])
		} elseif($videoExt -contains $fileExt[$i]){
			$videoNames.Add($fileNames[$i])
		} elseif($musicExt -contains $fileExt[$i]){
			$musicNames.Add($fileNames[$i])
		}
	}
	return $imageNames, $videoNames, $musicNames
}

function create_folder{
	param($folderPath)
	for($i=0; $i -lt 4; $i++){
		Switch($i){
			0 {$subFolderName = "Images"}
			1 {$subFolderName = "Videos"}
			2 {$subFolderName = "Music"}
		}
		try{
		New-Item -path $folderPath -ItemType Directory -name $subFolderName -ErrorAction Stop
		} catch [System.IO.IOException]{}
	}
	return
}

function move_files{
	param($folderPath, $imageNames, $videoNames, $musicNames)
	foreach($image in $imageNames){
		write-host $image
		Move-Item -Path ($folderPath+"\"+$image) -Destination ($folderPath+"\Images\"+$image)
	}
	foreach($video in $videoNames){
		write-host $video
		Move-Item -Path ($folderPath+"\"+$video) -Destination ($folderPath+"\Videos\"+$video)
	}
	foreach($song in $musicNames){
		write-host $song
		Move-Item -Path ($folderPath+"\"+$song) -Destination ($folderPath+"\Music\"+$song)
	}
}

main