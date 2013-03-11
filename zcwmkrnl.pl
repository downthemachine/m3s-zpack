#!/usr/bin/perl -W

use strict;
use Cwd;


my $dir = getcwd;

my $usage = "zcwmkrnl.pl <ramdisk-directory>\n";

die $usage unless $ARGV[0];

chdir $ARGV[0] or die "$ARGV[0] $!";

system ("find . | cpio -o -H newc | gzip > $dir/ramdisk-repack.gz");

chdir $dir or die "$ARGV[0] $!";;

# Parameters for LG Optimus Elite
system ("$dir/mkbootimg --cmdline 'console=androidboot.hardware=qcom' --kernel zImage --ramdisk ramdisk-repack.gz -o boot.img --base 0x00200000 --pagesize 4096");
print "\nrepacked boot image written at boot.img\n";
print "\nadjusting bootimg size\n";
system ("abootimg -u boot.img -f bootimg.cfg");
unlink("ramdisk-repack.gz") or die $!;
system ("rm $dir/zcwmkrnl.zip");
print "\nremoved old zcwmkrnl.zip\n";
system ("rm $dir/zcwmfiles/boot.img");
print "\nremoved old boot.img from $dir/zcwmfiles/\n";
system ("cp boot.img $dir/zcwmfiles/");
print "\ncopied new boot.img to $dir/zcwmfiles\n";
system ("rm boot.img");
print "\nremoved temporary boot.img\n";
chdir ("$dir/zcwmfiles");
system ("zip -9 -r $dir/zcwmkrnl.zip *");
print "\nceated zcwmkrnl.zip\n";
print "\ndone\n";



