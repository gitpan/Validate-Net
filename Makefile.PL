require 5.000;
use ExtUtils::MakeMaker;
WriteMakefile(
	'NAME'         => 'Validate::Net',
	'VERSION_FROM' => 'lib/Validate/Net.pm',
	'PREREQ_PM'    => {
		# For the module itself
		'Class::Default' => 0.2,

		# For the tests
		'File::Spec'     => 0.83,
		'Test::More'     => 0,
	},
	($] >= 5.005) ? (
		'AUTHOR'     => 'Adam Kennedy (cpan@ali.as)',
		'ABSTRACT'   => 'Provides standalone validation of Net:: related strings',
	) : (),
);
