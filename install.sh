#!/usr/bin/sh
current_dir=$HOME
install_home=$current_dir/.polaris

prepare_env() {
	echo "install neovim"
	version=`lsb_release -c`
	echo $version
	sudo apt-get install software-properties-common -y
	if [[ $version =~ "bionic" ]]; then
		echo "already exits properties"
	else
		sudo apt-get install python-software-properties -y
	fi
	sudo add-apt-repository ppa:neovim-ppa/stable -y
	sudo apt-get update
	sudo apt-get install neovim -y
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
	git clone https://github.com/ykerit/polaris-vim.git $install_home
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
		sudo apt-get install cmake -y
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
}

install_ycm() {
	echo "cd $current_dir/.vim/plugged/YouCompleteMe/ && python install.py --clang-completer"
	cd $current_dir/.vim/plugged/YouCompleteMe/
	echo "it's will be cost many time"
	sudo apt install build-essential cmake python3-dev
	git submodule update --init --recursive
	python3 $install/tool.py
	if [ $? -ne 0 ]; then
		echo "$python_v YCM must be >= 3.6.0"
		sudo add-apt-repository ppa:deadsnakes/ppa -y
		sudo apt update
		sudo apt-get install python3.7 -y
		sudo update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.7
	fi
	if [ `which clang` ]
	then
		python3 install.py --clangd-completer --system-libclang
	else
		python3 install.py --clangd-completer
	fi
}

link() {
	echo "link config"	
	today=`date +%m%d`	
	mv $current_dir/.vim $current_dir/.vim.bak_${today} 2>/dev/null
	mv $current_dir/.vimrc $current_dir/.vimrc.bak_${today} 2>/dev/null
	mkdir -p $current_dir/.config/nvim
	mkdir -p $current_dir/.local/share/nvim/site/autoload
	plug_home=$current_dir/.local/share/nvim/site/autoload
	ln -s $install_home/init.vim $current_dir/.config/nvim/init.vim
	ln -s $install_home/vimrc.plug $current_dir/.config/nvim/vimrc.plug
	ln -s $install_home/plug.vim $plug_home/plug.vim
	system_shell=$SHELL
	nvim -u $current_dir/.config/nvim/vimrc.plug +PlugInstall! +PlugClean! +qall!
	export SHELL=$system_shell
}

prepare_env
download_config
link
#install_cquery
install_ycm
echo "install done"
