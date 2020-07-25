#!/usr/bin/sh
current_dir=$HOME
install_home=$current_dir/.polaris

prepare_env() {
	echo "install neovim"
	version=`lsb_release -c`
	echo $version
	sudo apt-get install software-properties-common
	if [[ $version =~ "bionic" ]]; then
		echo "already exits properties"
	else
		sudo apt-get install python-software-properties
	fi
	sudo add-apt-repository ppa:neovim-ppa/stable
	sudo apt-get update
	sudo apt-get install neovim
	nvim --version
	if [ $? -ne 0 ]; then
		echo "neovim install failed"
		exit 1
	fi
	touch $current_dir/.bashrc
	echo "alias vi=nvim" >> $current_dir/.bashrc
	echo "environment install success"
}

download_config() {
	if [ -d $install_home ]; then
		rm -rf $install_home
	fi
	git clone https://github.com/ykerit/polaris-vim.git
	if [ $? -ne 0 ]; then
		echo "vim config file download failed"
		exit 1
	fi
	echo "vim config download success"
}

install_cquery() {
	cmake -version > /dev/null
	if [ $? -ne 0 ]; then
		echo "cmake uninstall"
		sudo apt-get install cmake
	fi
	cmake -version > /dev/null
	if [ $? -ne 0 ]; then
		echo "cmake install failed"
		exit 1
	fi
	echo "start install cquery"
	git clone --recursive https://github.com/cquery-project/cquery.git
	cd cquery
	git submodule update --init
	mkdir build && cd build
	cmake .. -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=$install_name -DCMAKE_EXPORT_COMPILE_COMMANDS=YES
	cmake --build .
	cmake --build . --target install
	cd ..
	rm -rf cquery
	nvim +PlugInstall +UpdateRemotePlugins +qa
}

install_ycm() {
	echo "cd $current_dir/bundle/YouCompleteMe/ && python install.py --clang-completer"
	cd $current_dir/bundle/YouCompleteMe/
	git submodule update --init --recursive
	if [ `which clang` ]
	then
		python install.py --clang-completer --system-libclang
	else
		python install.py --clang-completer
	fi
}

link() {
	echo "link config"	
	today=`date +%m%d`	
	mv $current_dir/.vim $current_dir/.vim.bak_${today} 2>/dev/null
	mv $current_dir/.vimrc $current_dir/.vimrc.bak_${today} 2 >/dev/null
	mkdir -p $current_dir/.config
	rm -f $current_dir/.config/nvim
	ln -s $install_home/init.vim $current_dir/.config/nvim/init.vim
}

prepare_env
download_config
link
install_cquery
install_ycm
echo "install done"
