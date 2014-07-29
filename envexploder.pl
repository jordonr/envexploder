#!/usr/bin/perl

foreach my $file ( @ARGV )
{
        (my $file_base = $file) =~ s/(.*)\..*/$1/;

        my $HEADER = 'ÿØ';
        my $FOOTER = 'ÿÙ';

        ExtractData($file, $envfile, $HEADER, $FOOTER, $file_base, 'jpg');

        $HEADER = '<\?xml version=';
        $FOOTER = "</VALUATION_RESPONSE>";

        ExtractData($file, $envfile, $HEADER, $FOOTER, $file_base, 'xml');

        $HEADER = '<FORMINFO';
        $FOOTER = "</FORMINFO>";

        ExtractData($file, $envfile, $HEADER, $FOOTER, $file_base, 'xml');
}

sub ExtractData {
        my ($file, $data, $HEADER, $FOOTER, $file_base, $ext) = @_;
        $count = 0;
        my $data = do { local $/; open my( $fh ), $file; <$fh> };

        print "Extracting $file\n";
        while( $data  =~ m/($HEADER.*?$FOOTER)/sg )
        {
                my $raw = $1;
                $count++;
                my $file_name = "$file_base.$count.$ext";
                open my $fh, "> $file_name" or warn "$file_name: $!", next;
                print "Writing $file_name: ", length($raw), " bytes\n";
                print $fh $raw;
                close $fh;
        }
}
