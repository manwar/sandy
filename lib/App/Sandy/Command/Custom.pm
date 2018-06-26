package App::Sandy::Command::Custom;
# ABSTRACT: simulate command class. Simulate a custom sequencing

use App::Sandy::Base 'class';

extends 'App::Sandy::CLI::Command';

with 'App::Sandy::Role::Digest';

# VERSION

sub default_opt {
	'paired-end-id'    => '%i.%U %U',
	'single-end-id'    => '%i.%U %U',
	'seed'             => time,
	'verbose'          => 0,
	'prefix'           => 'out',
	'output-dir'       => '.',
	'jobs'             => 1,
	'gzip'             => 1,
	'count-loops-by'   => 'coverage',
	'coverage'         => 8,
	'strand-bias'      => 'random',
	'seqid-weight'     => 'length',
	'sequencing-type'  => 'paired-end',
	'fragment-mean'    => 300,
	'fragment-stdd'    => 50,
	'sequencing-error' => 0.005,
	'read-size'        => 100,
	'quality-profile'  => 'poisson'
}

sub rm_opt {
}

__END__

=head1 SYNOPSIS

 sandy custom [options] <fasta-file>

 Arguments:
  a fasta-file 

 Options:
  -h, --help                     brief help message
  -M, --man                      full documentation
  -v, --verbose                  print log messages
  -p, --prefix                   prefix output [default:"out"]	
  -o, --output-dir               output directory [default:"."]
  -i, --append-id                append to the defined template id [Format]
  -I, --id                       overlap the default template id [Format]
  -j, --jobs                     number of jobs [default:"1"; Integer]
  -z, --gzip                     compress output file
  -s, --seed                     set the seed of the base generator
                                 [default:"time()"; Integer]
  -c, --coverage                 fastq-file coverage [default:"8", Number]
  -n, --number-of-reads          directly set the number of reads [Integer]
  -t, --sequencing-type          single-end or paired-end reads
                                 [default:"paired-end"]
  -q, --quality-profile          sequencing system profiles from quality
                                 database [default:"poisson"]
  -e, --sequencing-error         sequencing error rate
                                 [default:"0.005"; Number]
  -r, --read-size                the read size [default:"100"; Integer]
                                 the quality_profile from database overrides
                                 this value
  -m, --fragment-mean            the mean size fragments for paired-end reads
                                 [default:"300"; Integer]
  -d, --fragment-stdd            the standard deviation for fragment sizes
                                 [default:"50"; Integer]
  -b, --strand-bias              which strand to be used: plus, minus and random
                                 [default:"random"]
  -w, --seqid-weight             seqid raffle type: length, same, count
                                 [default: "length"]
  -f, --expression-matrix        an expression-matrix entry from database,
                                 when seqid-weight=count
  -a, --structural-variation     a structural variation entry from variation
                                 database [default:"none"]

=head1 OPTIONS

=over 8

=item B<--help>

Print a brief help message and exits.

=item B<--man>

Prints the manual page and exits.

=item B<--verbose>

Prints log information to standard error

=item B<--prefix>

Concatenates the prefix to the output-file name.

=item B<--output-dir>

Creates output-file inside output-dir. If output-dir
does not exist, it is created recursively

=item B<--append-id>

Append string template to the defined template id.
See B<Format>

=item B<--id>

Overlap the default defined template id:
I<single-end> %i.%U %U and I<paired-end> %i.%U %U
e.g. SR123.1 1
See B<Format>

=item B<Format>

A string B<Format> is a combination of literal and escape characters similar to the way I<printf> works.
That way, the user has the freedom to customize the fastq sequence identifier to fit her needs. Valid
escape characteres are:

B<Common escape characters>

	----------------------------------------------------------------------------
	 Escape       Meaning
	----------------------------------------------------------------------------
	 %i   	      instrument id composed by SR + PID
	 %I           job slot number
	 %q           quality profile
	 %e           sequencing error
	 %x           sequencing error position
	 %R           read 1, or 2 if it is the paired-end mate
	 %U           read number
	 %r           read size
	 %c           sequence id as chromossome, gene/transcript id
	 %C           sequence id type (reference or alternate non reference allele) ***
	 %s           read strand
	 %t           read start position
	 %n           read end position
	 %a           read start position regarding reference genome ***
	 %b           read end position regarding reference genome ***
	 %v           structural variation position ***
	----------------------------------------------------------------------------
	*** specific for structural variation (genome simulation only)

B<Paired-end specific escape characters>

	----------------------------------------------------------------------------
	 Escape       Meaning
	----------------------------------------------------------------------------
	 %T           mate read start position
	 %N           mate read end position
	 %A           mate read start position regarding reference genome ***
	 %B           mate read end position regarding reference genome ***
	 %D           distance between the paired-reads
	 %m           fragment mean
	 %d           fragment standard deviation
	 %f           fragment size
	 %F           fragment strand
	 %S           fragment start position
	 %E           fragment end position
	 %X           fragment start position regarding reference genome ***
	 %Z           fragment end position regarding reference genome ***
	----------------------------------------------------------------------------
	*** specific for structural variation (genome simulation only)

=item B<--jobs>

Sets the number of child jobs to be created

=item B<--gzip>

Compress the output-file with gzip algorithm. It is
possible to pass --no-gzip if one wants
uncompressed output-file

=item B<--seed>

Sets the seed of the base generator. The ability to set the seed is
useful for those who want reproducible simulations. Pay attention to
the number of jobs (--jobs) set, because each job receives a different
seed calculated from the I<main seed>. So, for reproducibility, the
same seed set before needs the same number of jobs set before as well.

=item B<--read-size>

Sets the read size, if quality-profile is equal to 'poisson'. The
quality-profile from database overrides the read-size

=item B<--coverage>

Calculates the number of reads based on the sequence
coverage: number_of_reads = (sequence_size * coverage) / read_size

=item B<--number-of-reads>

Sets directly the number of reads desired. It overrides coverage,
in case the two options are given

=item B<--sequencing-type>

Sets the sequencing type to single-end or paired-end

=item B<--fragment-mean>

If the sequencing-type is set to paired-end, it sets the
fragment mean

=item B<--fragment-stdd>

If the sequencing-type is set to paired-end, it sets the
fragment standard deviation

=item B<--sequencing-error>

Sets the sequencing error rate. Valid values are between zero and one

=item B<--quality-profile>

Sets the sequencing system profile for quality. The default value is a poisson
distribution, but the user can choose among several profiles stored into the
database or import his own data.
See B<quality> command for more details

=item B<--strand-bias>

Sets which strand to use to make a read. Valid options are plus, minus and
random - if you want to randomly calculte the strand for each read

=item B<--seqid-weight>

Sets the seqid (e.g. chromossome, ensembl id) raffle behavior. Valid options are
length, same and count. If it is set to 'same', all seqid receives the same weight
when raffling. If it is set to 'length', the seqid weight is calculated based on
the seqid sequence length. And finally, if it is set to 'count', the user must set
the option --expression-matrix. For details, see B<--expression-matrix>

=item B<--expression-matrix>

If --seqid-weight is set to count, then this option becomes mandatory. The expression-matrix
entries are found into the database. See B<expression> command for more details

=item B<--structural-variation>

Sets the structural variation to be applied on the genome feeded. By
default no variation is included to the simulation, but the user has
the power to point some entry from B<variation> database or index his
own data.
See B<variation> command for more details

=back

=head1 DESCRIPTION

Simulate a custom sequencing.

=cut
