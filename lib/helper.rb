def create_working_env path
	filename = File.basename(path,".kmz")
	if !Dir.exist?(filename)
		Dir.chdir(File.dirname(path))
		Dir.mkdir(filename)
		Dir.chdir(filename)
		Dir.mkdir("files")
	end
end
