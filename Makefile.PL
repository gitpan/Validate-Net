require 5.000;
use ExtUtils::MakeMaker;
WriteMakefile(
	'NAME'         => 'Validate::Net',
	'VERSION_FROM' => 'lib/Validate/Net.pm',
	'PREREQ_PM'    => {
		'Class::Default'   => 0.2,
		'Class::Inspector' => 0, # For the test script
	},
	($] >= 5.005) ? (
		'AUTHOR'     => 'Adam Kennedy (adam@ali.as)',
		'ABSTRACT'   => 'Provides standalone validation of Net:: related strings',
	) : (),
);
