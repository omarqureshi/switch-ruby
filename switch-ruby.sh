#!/bin/bash
#
# Script to switch between versions of Ruby 1.9 and Ruby 1.8 on a Leopard installation of
# Ruby 1.8.
# 
# Check to see whether the current user is root
if [[ $EUID -ne 0 ]]; then
  echo "This script must be run as root or sudo"
  exit 1
fi

if [ ! $OSTYPE == "darwin9.0" ]; then
  echo "This script assumes that you will be running OS X"
  exit 1
fi
  

mac_ver=`sw_vers -productVersion`
osver=`echo $mac_ver | cut -d \. -f 1`
majorver=`echo $mac_ver | cut -d \. -f 2`
minorver=`echo $mac_ver | cut -d \. -f 3`

if [ ! $osver == "10" ]; then
  echo "This script assumes that you will be running OS X"
  exit 1
fi

if [ ! $majorver == "5" ]; then
  echo "This script assumes that you will be running Leopard"
  exit 1
fi

# Check to see current version of Ruby 
if [ ! -e /usr/local/bin/ruby19 ]; then
  echo "This script assumes that Ruby 1.9 will be installed at /usr/bin/local with a suffix of 19"
  exit 1
fi

ruby_target=`readlink -f /usr/bin/ruby`
case $ruby_target in
"/usr/local/bin/ruby19")
  echo "Running Ruby 1.9"
  cur_ver="1.9"
  ;;
"/System/Library/Frameworks/Ruby.framework/Versions/1.8/usr/bin/ruby")
  echo "Running Ruby 1.8"
  cur_ver="1.8"
  ;;
*)
  echo "Could not find ruby version"
  exit 1
esac

if [ $cur_ver == "1.9" ]; then
  echo "Reverting back to Ruby 1.8"
  if [ ! -e /usr/bin/rake.old ]; then
    echo "You are missing rake.old, cannot revert to 1.8"
    exit 1
  fi
  rm /usr/bin/erb
  rm /usr/bin/gem
  rm /usr/bin/irb
  rm /usr/bin/rake
  rm /usr/bin/rdoc
  rm /usr/bin/ri
  rm /usr/bin/ruby
  rm /usr/bin/testrb
  ln -s /System/Library/Frameworks/Ruby.framework/Versions/Current/usr/bin/erb /usr/bin/erb
  ln -s /System/Library/Frameworks/Ruby.framework/Versions/1.8/usr/bin/gem /usr/bin/gem
  ln -s /System/Library/Frameworks/Ruby.framework/Versions/Current/usr/bin/irb /usr/bin/irb
  mv /usr/bin/rake.old /usr/bin/rake
  ln -s /System/Library/Frameworks/Ruby.framework/Versions/Current/usr/bin/rdoc /usr/bin/rdoc
  ln -s /System/Library/Frameworks/Ruby.framework/Versions/Current/usr/bin/ri /usr/bin/ri
  ln -s /System/Library/Frameworks/Ruby.framework/Versions/Current/usr/bin/ruby /usr/bin/ruby
  ln -s /System/Library/Frameworks/Ruby.framework/Versions/Current/usr/bin/testrb /usr/bin/testrb
fi

if [ $cur_ver == "1.8" ]; then
  echo "Setting up Ruby 1.9"
  rm /usr/bin/erb
  rm /usr/bin/gem
  rm /usr/bin/irb
  rm /usr/bin/rdoc
  rm /usr/bin/ri
  rm /usr/bin/ruby
  rm /usr/bin/testrb
  ln -s /usr/local/bin/erb19 /usr/bin/erb
  ln -s /usr/local/bin/gem19 /usr/bin/gem
  ln -s /usr/local/bin/irb19 /usr/bin/irb
  mv /usr/bin/rake /usr/bin/rake.old
  ln -s /usr/local/bin/rake19 /usr/bin/rake
  ln -s /usr/local/bin/rdoc19 /usr/bin/rdoc
  ln -s /usr/local/bin/ri19 /usr/bin/ri
  ln -s /usr/local/bin/ruby19 /usr/bin/ruby
  ln -s /usr/local/bin/testrb /usr/bin/testrb
fi