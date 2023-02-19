extends HomeUpdateLink

const DOWNLOAD_PATH : String = "download/Mustat.apk";

func _on_Update_pressed():
	OS.shell_open(System.Server.DOMAIN + DOWNLOAD_PATH);
