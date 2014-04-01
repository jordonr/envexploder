#!/usr/bin/perl

foreach my $file ( @ARGV )
{
print "Extracting $file\n";
	(my $file_base = $file) =~ s/(.*)\..*/$1/;
		
	my $envfile = do { local $/; open my( $fh ), $file; <$fh> };

	my $HEADER = 'ÿØ';
	my $FOOTER = 'ÿÙ';
	my $count = 0;
	my $data = $envfile;
	while( $data =~ m/($HEADER.*?$FOOTER)/sg )
	{
		my $image      = $1;
		$count++;
		my $image_name = "$file_base.$count.jpg";
		open my $fh, "> $image_name" or warn "$image_name: $!", next;
		print "Writing $image_name: ", length($image), " bytes\n";
		print $fh $image;
		close $fh;
	}
		
		
	$HEADER = '<\?xml version=';
	$FOOTER = "</VALUATION_RESPONSE>";
	my $mismo = $envfile;
	while( $mismo =~ m/($HEADER.*?$FOOTER)/sg )
	{
		my $xml      = $1;
		my $file_name = "$file_base.mismo.xml";
		open my $fh, "> $file_name" or warn "$file_name: $!", next;
		print "Writing $file_name: ", length($xml), " bytes\n";
		print $fh $xml;
		close $fh;
	}
	
	$HEADER = '<FORMINFO';
	$FOOTER = "</FORMINFO>";
	$count = 0;
	my $ucdpxml = $envfile;
	while( $ucdpxml =~ m/($HEADER.*?$FOOTER)/sg )
	{
		my $xml      = $1;
		$count++;
		my $file_name = "$file_base.$count.xml";
		open my $fh, "> $file_name" or warn "$file_name: $!", next;
		print "Writing $file_name: ", length($xml), " bytes\n";
		print $fh $xml;
		close $fh;
	}
}
