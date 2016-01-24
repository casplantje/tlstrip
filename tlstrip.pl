#!/usr/bin/perl
# Remember those old illegal Twilight cd's that contained dozens of games and applications?
# Well, I do. And getting the menu to work on linux just blows.
# 
# This script parses the strange and rather useless file format some Twilight cd's have all their
# game data of cd1 stored in(e.g. game.001).
#
# The files are basically concaternated with 40 bytes of information between each file
# In those 40 bytes there's the filename in the first 32 bytes and then
# the next 4 bytes are for the filelength(little endian 32 bit unsigned integer).
# And then there will be 4 very useless bytes.
#
# Those are my observations, no warranty will be given. You're not supposed to use Twilight cd's anyway
# - Casplantje

my $buffer;
my $continue = 1;
print $ARGV[0] . "\n";
open INFILE, $ARGV[0] or die "\nCan't open $ARGV[0].\n";
binmode INFILE;
read INFILE, $buffer, 8;
while($continue)
{
	if (read INFILE, $buffer, 32)
	{
		my $filename = $buffer;
		open OUTFILE, ">$filename" or die "\nCan't open $filename.\n";
		read INFILE, $buffer, 4;
		my $length = unpack 'V',$buffer;
		print "Writing " . $filename . " filesize:  " . $length . "\n";
		read INFILE, $buffer, 4;
		read INFILE, $buffer, $length;
		print OUTFILE $buffer;	
		close OUTFILE;
	} else
	{
		last;
	}
}
close INFILE
