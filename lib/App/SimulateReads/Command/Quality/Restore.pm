package App::SimulateReads::Command::Quality::Restore;
# ABSTRACT: quality subcommand class. Restore database.

use App::SimulateReads::Base 'class';

extends 'App::SimulateReads::Command::Quality';

# VERSION

override 'opt_spec' => sub {
	super,
	'verbose|v'
};

sub validate_args {
	my ($self, $args) = @_;
	die "Too many arguments: '@$args'\n" if @$args;
}

sub execute {
	my ($self, $opts, $args) = @_;
	$LOG_VERBOSE = exists $opts->{verbose} ? $opts->{verbose} : 0;
	log_msg ":: Restoring quality database to vendor state ...";
	$self->restoredb;
	log_msg ":: Done!";
}

__END__

=head1 SYNOPSIS

 simulate_reads quality restore

 Options:
  -h, --help               brief help message
  -M, --man                full documentation
  -v, --verbose            print log messages

=head1 DESCRIPTION

B<simulate_reads> will read the given input file and do something
useful with the contents thereof.

=cut