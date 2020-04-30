# 制作源码压缩包


	git clone --depth=1 --recursive https://github.com/MaskRay/ccls
	tar cf ccls.tar ccls
	xz -z -9 -v ccls.tar
	mv ccls.tar.xz ccls-日期.tar.xz

