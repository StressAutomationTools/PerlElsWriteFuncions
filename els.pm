###############################################################################
#
# .els creation script
#
# created by Jens M Hebisch
#
#
# These functions can be used to create els and result template files to
# read data into patran
#
###############################################################################
use warnings;
use strict;

sub elsWriter{
	#input: 4 strings, dictionary containing EIDs as keys and arrays of values
	#no checking of the data is performed
	my ($outputFile, $title, $stitle1, $stitle2, %data) = @_;
	open(OPT, ">", $outputFile);
	my @EIDs = sort({$a <=> $b} keys(%data));
	my $entities = @{$data{$EIDs[0]}} + 0;
	print OPT $title."\n";
	printf OPT <%s5>, $entities;
	print OPT "\n$stitle1\n$stitle2\n";
	foreach my $EID (@EIDs){
		print OPT $EID."\n";
		my @values = @{$data{$EID}};
		foreach my $value (@values){
			if($value < 0){
				printf OPT <%.6e>, $value;
			}
			else{
				printf OPT <%.7e>, $value;
			}
		}
		print OPT "\n";
	}
	close(OPT);
}

sub testElsWriter{
	my %data; 
	$data{1} = [1, 2, 3];
	$data{2} = [-1, -2, -3];
	elsWriter("optFile.els", "Title", "Sub1", "Sub2", %data);
}

sub ElsTemplateWriter{
	#input: one string, three array references with type information, primary and secondary titles
	#type array has to be either "scalar" or "tensor"
	#no checking of the data is performed, beyond checking that the arrays have the same number of elements
	my ($outputFile, $typeArrayRef, $primaryTitleArrayRef, $secondaryTitleArrayRef) = @_;
	open(OPT, ">", $outputFile);
	my @types = @{$typeArrayRef};
	my @primaries = @{$primaryTitleArrayRef};
	my @secondaries = @{$secondaryTitleArrayRef};
	if(((@types + @primaries + @secondaries + 0)/3) == (@types + 0)){
		print OPT "KEYLOC = 0\n\n";
		
		for(my $n = 0; $n < (@types + 0); $n++){
			print OPT "TYPE = ".$types[$n]."\n";
			print OPT "COLUMN = ".($n + 1)."\n";
			print OPT "PRI = ".$primaries[$n]."\n";
			print OPT "SEC = ".$secondaries[$n]."\n\n";
		}
		print OPT "TYPE = END\n"
	}
	else{
		print "ElsTemplateWriter Error: All arrays supplied must be of equal length\n";
	}
}

sub TestTemplateWriter{
	my $file = "template.template";
	my $types = ["scalar", "tensor"];
	my $pri = ["PRI1", "PRI2"];
	my $sec = ["SEC1", "SEC2"];
	ElsTemplateWriter($file, $types, $pri, $sec);
	$sec = ["SEC1"];
	ElsTemplateWriter($file, $types, $pri, $sec);
}

1;
