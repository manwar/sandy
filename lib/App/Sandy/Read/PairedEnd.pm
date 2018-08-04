package App::Sandy::Read::PairedEnd;
# ABSTRACT: App::Sandy::Read subclass for simulate paired-end reads.

use App::Sandy::Base 'class';

use constant NUM_TRIES => 1000;

extends 'App::Sandy::Read';

with 'App::Sandy::Role::RNorm';

# VERSION

has 'fragment_mean' => (
	is       => 'ro',
	isa      => 'My:IntGt0',
	required => 1
);

has 'fragment_stdd' => (
	is       => 'ro',
	isa      => 'My:IntGe0',
	required => 1
);

sub gen_read {
	my ($self, $ptable, $ptable_size, $read_size, $is_leader) = @_;

	unless ($read_size <= $self->fragment_mean && $self->fragment_mean <= $ptable_size) {
		croak sprintf
			"read_size (%d) must be leseer or equal to fragment_mean (%d) and\n" .
			"fragment_mean (%d) must be lesser or equal to ptable_size (%d)"
				=> $read_size, $self->fragment_mean, $self->fragment_mean, $ptable_size;
	}

	my $fragment_size = 0;
	my $random_tries = 0;

	until (($fragment_size <= $ptable_size) && ($fragment_size >= $read_size)) {
		# ptable_size must be greater or equal to fragment_size and
		# fragment_size must be greater or equal to read_size
		# As fragment_size is randomly calculated, try out NUM_TRIES times
		if (++$random_tries > NUM_TRIES) {
			croak sprintf
				"So many tries to calculate a fragment. the constraints were not met:\n" .
				"fragment_size <= ptable_size (%d) and fragment_size >= read_size (%d)"
					=> $ptable_size, $read_size;
		}

		$fragment_size = $self->with_random_half_normal($self->fragment_mean,
			$self->fragment_stdd);
	}

	# Build the fragment string
	my ($fragment_ref, $attr) = $self->subseq_rand_ptable($ptable,
		$ptable_size, $fragment_size, $read_size);

	# Catch R1 substring
	my $read1_ref = $self->subseq($fragment_ref, $fragment_size, $read_size, 0);
	@$attr{qw/start1 end1/} = ($attr->{start}, $attr->{start} + $read_size - 1);

	# Insert sequencing error
	$attr->{error1} = $self->insert_sequencing_error($read1_ref, $read_size);

	# Catch R2 substring
	my $read2_ref = $self->subseq($fragment_ref, $fragment_size, $read_size,
		$fragment_size - $read_size);
	@$attr{qw/start2 end2/} = ($attr->{end}, $attr->{end} - $read_size + 1);

	# Reverse completement
	$self->reverse_complement($read2_ref);

	# Insert sequencing error
	$attr->{error2} = $self->insert_sequencing_error($read2_ref, $read_size);

	return ($read1_ref, $read2_ref, $attr);
}
