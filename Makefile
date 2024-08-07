game: game.ll
	clang -o game game.ll -L./raylib-5.0_linux_amd64/lib -l:libraylib.a -lm
