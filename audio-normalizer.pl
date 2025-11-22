#!/usr/bin/env perl

# ================================================================ PRAGMAS

use v5.10;
use utf8;
use open qw(:std :utf8);

use Term::ANSIColor qw(:constants);
use FindBin qw($RealBin);
use feature qw(say);
use Data::Dumper;

# ================================================================ VARIABLES

$|++;
my $type = '';
my $db = [

	{ 
		level_check => 
		{ 
			cmd => q(ffmpeg -i "MP3" -af loudnorm=print_format=summary -f null - 2>&1 | grep "Input Integrated") 
		}
	},
	{ 
		normalize => 
		{ 
			cmd => q(ffmpeg -i "MP3" -map 0:a:0 -vn -af loudnorm=I=-16.5:TP=-1.5:LRA=11.0 "./normalized/MP3") 
		}
	}
	
];

# ================================================================ INITIALIZATION

unless (@ARGV and @ARGV == 1 and (-d $ARGV[0] or -f $ARGV[0]))
{
	print BRIGHT_RED q(❌ No valid file/folder specified! ), RESET;
	bye_bye();
}
else
{
	$type = -d $ARGV[0] ? 'DIRECTORY' : 'FILE';
	say BRIGHT_BLACK qq(${type} selected!), RESET;
}

my $cmd = qq(mkdir -p '${RealBin}/normalized');
run_cmd($cmd);

MENU:
{
	say "="x50;
	say "CHOOSE:";
	say "="x50;
	for my $key (sort keys @{$db})
	{
		printf qq(%2d - %s\n), $key, (keys %{$db->[$key]})[0] =~ s~_~ ~gr; 
	}
	say "="x50;
	print q(> );
	chomp( my $choice = <STDIN> );
	bye_bye() if $choice =~ m~^Q(?:UIT)?$~i;
	
	unless (defined $choice and $choice =~ m~^[0-9]+$~ and $db->[$choice])
	{
		clear_screen();
		say BRIGHT_RED q(❌ Choice not valid try again!), RESET;
		goto MENU;	
	}
	
	if ($type =~ m~^DIRECTORY$~)
	{
		my $dir = $ARGV[0] =~ s~/+$~~g;
		while (glob("$ARGV[0]/*.mp3"))
		{
			my $cmd = craft_cmd($choice, $_);
			run_cmd($cmd);
			
		}
	}
	else
	{
		my $cmd = craft_cmd($choice, $ARGV[0]);
		run_cmd($cmd);
	}
}

print BRIGHT_GREEN "All done! ";
bye_bye();
 
# ================================================================ SUBROUTINES

sub bye_bye()
{
	say BRIGHT_GREEN qq(👋 Bye!), RESET;
	exit 0;
}

sub clear_screen
{
    # Clear entire screen
    print "\033[2J";
    
    # Move cursor to top-left corner (home position)
    print "\033[H";
}

sub craft_cmd()
{
	my $choice = shift;
	my $file = shift;
	return $db->[$choice]->{ $choice =~ m~^0$~ ? 'level_check' : 'normalize' }->{cmd} =~ s~(MP3)|DIR~$1 ? $file : $RealBin~erg;
}

sub run_cmd
{
	my $cmd = shift;
	say BRIGHT_BLACK $cmd, RESET;
	system $cmd;
	check_error($cmd, $?);
}

sub check_error()
{
	my $cmd  = shift;
	my $code = shift;
	
	if ($code)
	{
		say BRIGHT_RED   qq(❌ Bailing! Error Code: @{[ $code >> 8 ]}), RESET;
		# say BRIGHT_BLACK $cmd, RESET;
		exit $cmd >> 8;
	}
}

# ================================================================ END

__END__
