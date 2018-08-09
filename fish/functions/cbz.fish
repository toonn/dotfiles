function cbz
	for comic in $argv
zip -r $comic{.cbz,}
end
end
