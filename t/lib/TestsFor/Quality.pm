#
#===============================================================================
#
#         FILE: Quality.pm
#
#  DESCRIPTION: Tests for 'Quality' class
#
#        FILES: ---
#         BUGS: ---
#        NOTES: ---
#       AUTHOR: Thiago Miller (tmiller), tmiller@mochsl.org.br
# ORGANIZATION: Group of Bioinformatics
#      VERSION: 1.0
#      CREATED: 12-05-2017 23:13:23
#     REVISION: ---
#===============================================================================
 
package TestsFor::Quality;

use Test::Most;
use autodie;
use base 'TestsFor';

use constant {
	SEQ_SYS       => "HiSeq", 
	QUALITY_SIZE  => 10
};

sub startup : Tests(startup) {
	my $test = shift;
	$test->SUPER::startup;
	my $class = ref $test;
	$class->mk_classdata('default_quality');
	$class->mk_classdata('default_attr');
}

sub setup : Tests(setup) {
	my $test = shift;
	my %child_arg = @_;
	$test->SUPER::setup;

	my %default_attr = (
		sequencing_system => SEQ_SYS,
		read_size         => QUALITY_SIZE,
		%child_arg
	);

	$test->default_attr(\%default_attr);
	$test->default_quality($test->class_to_test->new(%default_attr));
}

sub constructor : Tests(5) {
	my $test = shift;

	my $class = $test->class_to_test;
	my $quality = $test->default_quality;
	my %default_attr = %{ $test->default_attr };

	while (my ($attr, $value) = each %default_attr) {
		can_ok $quality, $attr;
		is lc $quality->$attr, lc $value, "The value for $attr shold be correct";
	}

	my %attrs = %default_attr;
	$attrs{read_size} = 0;
	throws_ok { $class->new(%attrs) }
	qr/must be greater than zero/,
		"Setting read_size to less than zero should fail";
}

sub gen_quality : Test(10) {
	my $test = shift;

	my $class = $test->class_to_test;
	my $quality = $test->default_quality;
	
	for my $i (1..10) {
		my $q = $quality->gen_quality;
		is length $$q, $quality->read_size,
			"quality length should be equal read_size. Try $i";
	}
}

1;